Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF4035AA34A
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 00:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233846AbiIAWq1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 18:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbiIAWqY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 18:46:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05BC66114
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 15:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662072382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EMTDS8DnyN2eeNSyxyOGmR/0rHhtMQj+1Wvt/dXWAYc=;
        b=ZXCwPmdLA9CSxz9+SStZmL8OiCOd67cqHg8k38kRbRNalKmKAfePj6dIKSpJ1rksLOkCEG
        0x7/a6OtTg2IopmNragn32v7reag5z87rUNBrnKUFjK2ISNsRm47fAXOySzfYcTCZDhI9J
        i5X/3QJGwbs14ruE9rHndJ5YIFq6eSY=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-641-gFC0xFqPPVWn-neBWb4ZBw-1; Thu, 01 Sep 2022 18:46:19 -0400
X-MC-Unique: gFC0xFqPPVWn-neBWb4ZBw-1
Received: by mail-ej1-f69.google.com with SMTP id ho13-20020a1709070e8d00b00730a655e173so85665ejc.8
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 15:46:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=EMTDS8DnyN2eeNSyxyOGmR/0rHhtMQj+1Wvt/dXWAYc=;
        b=AKzxxGo3MnNzGUNDeA0+BUgtQzPurnZTZY/1aHA1ZMzw/EBMj+y+dbSIRLOiL7XuFA
         qyl1aS74uygMfHLtTFBA48Ftze12Jjng2jKIR5FR7h35MGIAssWWhP1X2qaM18AAsT/n
         dw8AcvFSjQ7Mb+BSflFFTZqmRYFjWd65bM0HqJkDYuyTZ8bQpIq3EXtlN4cww2KtiawP
         ePjwFICXW2qsdrUbUVPPi83e7dK8q4gFcAX39br9yP+fM/iEBn+SCTkCgtGaZwGD8cFt
         ZWPAnACswqJ8gRx9MnmBRRM701tTapj9cDgzCdrS4L8EhjubAvxzMbbtl1L0A4lp/xjm
         XnMw==
X-Gm-Message-State: ACgBeo35AAwx8oih5BJfBUPRPx+k5Oqr/4To+fEC85MYXzcX6qBTOmyW
        Ik9XDyEf5FclmAB/mNYNsmUx/VuZPeXlDnPkEp8nibUafLx+TflnU1YCpqDDiYCcOBzerBp8Pxt
        ecsuny67oCYTr
X-Received: by 2002:a17:907:2c78:b0:741:4b9b:8d40 with SMTP id ib24-20020a1709072c7800b007414b9b8d40mr18232035ejc.553.1662072378518;
        Thu, 01 Sep 2022 15:46:18 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7BPR8Reg8rAqyX9sNVbrSev7DRGLWHt44hmiQrv62/iZjx9Eji9KfHXDyeB55d0ZJ2hKuMtQ==
X-Received: by 2002:a17:907:2c78:b0:741:4b9b:8d40 with SMTP id ib24-20020a1709072c7800b007414b9b8d40mr18232027ejc.553.1662072378308;
        Thu, 01 Sep 2022 15:46:18 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id z11-20020aa7d40b000000b00445b5874249sm231232edq.62.2022.09.01.15.46.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Sep 2022 15:46:17 -0700 (PDT)
Message-ID: <c218bef6-bbc1-931e-64cc-5328c0966365@redhat.com>
Date:   Fri, 2 Sep 2022 00:46:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [GIT PULL] KVM/riscv fixes for 6.0, take #1
To:     Anup Patel <anup@brainfault.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>
References: <CAAhSdy2oDoytypnjNFodEY7q_E0OVmrh=GkihQE_K5MnPcK_Sg@mail.gmail.com>
Content-Language: en-US
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAAhSdy2oDoytypnjNFodEY7q_E0OVmrh=GkihQE_K5MnPcK_Sg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/20/22 10:01, Anup Patel wrote:
>    https://github.com/kvm-riscv/linux.git  tags/kvm-riscv-fixes-6.0-1

Pulled, thanks; sorry for the delay.

Paolo

