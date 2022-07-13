Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1A50572DD1
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 08:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbiGMGAQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 02:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbiGMGAN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 02:00:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3EEA654660
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 23:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657692012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fAB+fzgqpii87zwJYPvAgT3WrxuSqJ6Z616wMWBAEuA=;
        b=eYddPereKqbwxseiLRREjVLbueJNCFgdqywSFS6KIWHs/Z1cPduhon3cZIY4rnOPVr/Jf2
        o5XBQLit/DuvimwWWes4PEbJwEexCfjC45yt6Eh08m+6HMP13UtCddMoopb7u1SGh7pfvp
        I26sWAVh5Ff/n2svizC5PRymA/NiobU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-540-a6c9kh2ZMEqI9hj5_vZWhw-1; Wed, 13 Jul 2022 02:00:06 -0400
X-MC-Unique: a6c9kh2ZMEqI9hj5_vZWhw-1
Received: by mail-ed1-f69.google.com with SMTP id z5-20020a05640235c500b0043ae18edeeeso4037908edc.5
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 23:00:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=fAB+fzgqpii87zwJYPvAgT3WrxuSqJ6Z616wMWBAEuA=;
        b=mhk+ima/43pgUaslLq+qUvlKpBfg4Z8tiV/GKDYgYIROTC41DdoYZnhkngIG+x0UAB
         y1DKDOz6cdqW0FKZ3DoxiK+yB0z4SPPT7rsijRAgCb2alUJDpOkW/Vn3wffHwBDgnw7Z
         9454NHRikRw9Eux1ybmh7LLYI/R7Kn5Kyh77UXMapWl8ZTZEMk4edHryIyH+KOcvszxr
         g+MA3xk9kZ21d0rerLYwYQipX3Bsn9aFltakMmu5Zv9QnxBvNqv5T9VX6GrcIAJsnkmJ
         yE6wdqRiC5WGa7vBeNTUhvz+SePQ8QwG8T0KQQYeM2FpJFuvZEB6Qo2NUsAljQ6w2L/O
         RR+Q==
X-Gm-Message-State: AJIora/1mMbmZ2XGHbXlTaNDJaaBK8US74OLuWYiz7KL63+4p9be/VFi
        tpxXMZmmvmh9yX505Aqb+ih9cHTt002emCFHcRjhCQvkZiTQcYsoq3K2lTES64z3tl7dBqD+K8l
        9L8H1b2v3xouE
X-Received: by 2002:a17:907:7f8e:b0:726:41df:cbc6 with SMTP id qk14-20020a1709077f8e00b0072641dfcbc6mr1838116ejc.230.1657692005044;
        Tue, 12 Jul 2022 23:00:05 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tRIZh3VheoWSCPA14LoWhV4jqxvo/RDpgqW20v0Gpf4kuo3kp2wtRzRQC6r1uN2p0xfLziOw==
X-Received: by 2002:a17:907:7f8e:b0:726:41df:cbc6 with SMTP id qk14-20020a1709077f8e00b0072641dfcbc6mr1838098ejc.230.1657692004835;
        Tue, 12 Jul 2022 23:00:04 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id bd27-20020a056402207b00b0043a21e3b4a5sm7341454edb.40.2022.07.12.23.00.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jul 2022 23:00:03 -0700 (PDT)
Message-ID: <01ec025d-fbde-5e58-2221-a368d4e1bb3a@redhat.com>
Date:   Wed, 13 Jul 2022 08:00:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Anup Patel <anup@brainfault.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>
References: <CAAhSdy1CAtr=mAVFtduTcED_Sjp2=4duQwgL5syxZ-sYM6SoWQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [GIT PULL] KVM/riscv fixes for 5.19, take #2
In-Reply-To: <CAAhSdy1CAtr=mAVFtduTcED_Sjp2=4duQwgL5syxZ-sYM6SoWQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/13/22 07:47, Anup Patel wrote:
> Hi Paolo,
> 
> We have two more fixes for 5.19 which were discovered recently:
> 1) Fix missing PAGE_PFN_MASK
> 2) Fix SRCU deadlock caused by kvm_riscv_check_vcpu_requests()

Pulled, thanks.

For the latter, my suggestion is to remove KVM_REQ_SLEEP completely and 
key the waiting on kvm_arch_vcpu_runnable using kvm_vcpu_halt or 
kvm_vcpu_block.

Also, I only had a quick look but it seems like vcpu->arch.pause is 
never written?

Paolo

