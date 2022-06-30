Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31FDD562190
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 19:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235370AbiF3R4G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 13:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbiF3R4F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 13:56:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4F8BB37AAE
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 10:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656611763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3hutr3rlRIoBI0yHWIgB4iXy7e3e90UBk0hpHVegM/w=;
        b=DT+53OosHo/ChxBo7uxOBJC5xCFparIVVB7Bbgqe7O95KPSp8p9x4tKPcwEGNHPc5ZVaKb
        6c+VgnPsoFkm446fUYei16FYSXBfKJwZUW9rQ8wvVzHjh/yHpY81HXPvLPAgv37kYgRwNn
        mCEdc1mKm7qCSDV1d6rxUUMIAAtt+pY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-423-8JJtFl5YPU-KsBjQ3IiYhw-1; Thu, 30 Jun 2022 13:56:01 -0400
X-MC-Unique: 8JJtFl5YPU-KsBjQ3IiYhw-1
Received: by mail-wm1-f72.google.com with SMTP id m20-20020a05600c4f5400b003a03aad6bdfso8175015wmq.6
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 10:56:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3hutr3rlRIoBI0yHWIgB4iXy7e3e90UBk0hpHVegM/w=;
        b=yEaAdzW/JwoBIx4E3AT7NsM8EX4DkPH0ri029tZHyUTRlQSGW4X3Pt8Qw0Q1QnzHIp
         YWtdwHN4U6L9MVm3BT8GFqdwWNtjOqNKZ+NTE+x7T2n0wxDYuMaciZ1Zba7xHg/6Zlea
         C7mPNv6HdcN5zniyC7vFQyhWtKrjHr3J7rNcrnkI8K0ly5S4lh6yibbSgaCrbRm38ReJ
         Dp3fLuNWtqYpK1v8pclIfqFAZnN0Pz4olDmEppFwfJNdSbLg/mM5aI+0mzCfyxxJADsI
         2PYcNx2zfgDlDc7rJ/3RLTSZDsQSvtNwj/03CgilXOW4HWtR5QYqRIHWqJN2YVhNU3mJ
         ITvg==
X-Gm-Message-State: AJIora8AOsaSzcLNqkPOKktl/PorArwFmWcFRT7E3v/gTjerpg+XVn90
        N4OZPoRTPWSz6NvVWfIxB7tdQTOiiCkr+kLUb865ehZTamF7m+BpRaVyGrYCZAU4/hGScBlFCJl
        MQhIN96LzMJqf
X-Received: by 2002:a05:6000:88:b0:21d:2d0d:e1e4 with SMTP id m8-20020a056000008800b0021d2d0de1e4mr8410478wrx.525.1656611760466;
        Thu, 30 Jun 2022 10:56:00 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vpQnXc+h+ne+5eOxK2vvakOSnNeImuvCM3KprOYxuahjkKyMa8chy2G0Xz2+2m9A4k1eV01Q==
X-Received: by 2002:a05:6000:88:b0:21d:2d0d:e1e4 with SMTP id m8-20020a056000008800b0021d2d0de1e4mr8410452wrx.525.1656611760139;
        Thu, 30 Jun 2022 10:56:00 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-179-66.web.vodafone.de. [109.43.179.66])
        by smtp.gmail.com with ESMTPSA id m12-20020adfe0cc000000b0021d4155cd6fsm1328964wri.53.2022.06.30.10.55.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 10:55:59 -0700 (PDT)
Message-ID: <1dd3c230-da8e-023d-59b4-8c455c4a4836@redhat.com>
Date:   Thu, 30 Jun 2022 19:55:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [kvm-unit-tests PATCH v1 2/3] s390x: add extint loop test
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com
References: <20220630113059.229221-1-nrb@linux.ibm.com>
 <20220630113059.229221-3-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220630113059.229221-3-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/06/2022 13.30, Nico Boehr wrote:
> The CPU timer interrupt stays pending as long as the CPU timer value is
> negative. This can lead to interruption loops when the ext_new_psw mask
> has external interrupts enabled.
> 
> QEMU is able to detect this situation and panic the guest, so add a test
> for it.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   s390x/Makefile      |  1 +
>   s390x/extint-loop.c | 64 +++++++++++++++++++++++++++++++++++++++++++++
>   s390x/unittests.cfg |  4 +++
>   3 files changed, 69 insertions(+)
>   create mode 100644 s390x/extint-loop.c

Reviewed-by: Thomas Huth <thuth@redhat.com>

