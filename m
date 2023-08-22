Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98D0D783986
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 07:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232883AbjHVFwJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 01:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232893AbjHVFwH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 01:52:07 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2C71A4
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 22:52:05 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d9443c01a7336-1bf1935f6c2so27509895ad.1
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 22:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1692683525; x=1693288325;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pX6r3WX3NvSr18ZoSAOxDmvOMvYtId2NY9DB6/FvmJw=;
        b=A5/+3Q3Hyn/lH9dYFfXb928gLVZSQE6OlxNPDiZQhprTlxgVutY1N2jFlGCAOzK3IQ
         AOFrdh1kgz4mDfmBe5QcNK4x2A0zw2bs3z7yQTSMnxpajPU2DNxu9yaaqhnaeU/Yub22
         qcqwOOQ41zMiHtW21Vy/cxX8jojKejbQoxNNS/8oUfpGpqy33SS0C21imrUR4girrMy5
         dcv03Rns271ypsH8Fb1aoEjLZCsY3Z2Xt1JTeOMl9m6QhDX/5pCrsImxxwBuxco4UX7U
         PemA/SoCWe/uhjsGYpi2g/ncwn91JOIccizpXz3WuSNr8KzN+8eN7A5HWS7DvS5HwE1e
         FOqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692683525; x=1693288325;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pX6r3WX3NvSr18ZoSAOxDmvOMvYtId2NY9DB6/FvmJw=;
        b=kKchFo5Wc1KsR/TdMepHyHUshQwfcMzUYv3/EbuzcNhdvY0W1/89ChD9MLl+tq2qsP
         M+LELDO9qCkIxPh3mZ6Oc9UP/h7RITXJNFxMYH+r+xYvCX1ZMjeOQ+2+ElKGDYTp/35/
         hWUpxpsGGxQJtShUWOCxQEYN+O/U31coyCl1m/SF1sJIrhpheCI8bBFJlEK0dA3PNk16
         R7354kzOMFmO+245GY2TU1F99aoeZvkTAGpgEQ6+1ZnHginN4FITLYLiObPhA9xFQ6fz
         n02BXK9BZ089MMqKLSkNzmSyqRa0wr0/CHe3WynpHjliPSTpdPMN/cnFfYmKVVjDkW2l
         My3g==
X-Gm-Message-State: AOJu0YzVSHZ0+UeztqqUlz25/Y/LqDPTU4zQo6yYB5MovVp4KCaDknEx
        WZ4bw2+UYcwB0c7u2+/tn+glew==
X-Google-Smtp-Source: AGHT+IHoStOkuAAck1PdJ7uJtA2xFxVwA0h3uFvR/EarNEv49cmAKimiDq0JXFxErYjSOQNtqhqqFA==
X-Received: by 2002:a17:903:2304:b0:1b8:8682:62fb with SMTP id d4-20020a170903230400b001b8868262fbmr12007273plh.4.1692683525104;
        Mon, 21 Aug 2023 22:52:05 -0700 (PDT)
Received: from [10.3.220.88] ([61.213.176.9])
        by smtp.gmail.com with ESMTPSA id q6-20020a170902a3c600b001bbd8cf6b57sm8210654plb.230.2023.08.21.22.52.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Aug 2023 22:52:04 -0700 (PDT)
Message-ID: <b3e716ee-988a-49cd-996d-a27517aa8e91@bytedance.com>
Date:   Tue, 22 Aug 2023 11:51:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] KVM: arm/arm64: optimize vSGI injection performance
To:     Marc Zyngier <maz@kernel.org>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhouyibo@bytedance.com,
        zhouliang.001@bytedance.com, Oliver Upton <oliver.upton@linux.dev>,
        kvmarm@lists.linux.dev, Mark Rutland <mark.rutland@arm.com>
References: <20230818104704.7651-1-zhaoxu.35@bytedance.com>
 <ZOMnZY_w83vTYnTo@FVFF77S0Q05N> <86msykg0ox.wl-maz@kernel.org>
From:   zhaoxu <zhaoxu.35@bytedance.com>
In-Reply-To: <86msykg0ox.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

hi marc, thanks for reviewing.

On 2023/8/21 18:16, Marc Zyngier wrote:
>>> This work is based on v5.4, and here is test data:
> 
> This is a 4 year old kernel. I'm afraid you'll have to provide
> something that is relevant to a current (e.i. v6.5) kernel.
> 
In fact, the core vCPU search algorithm remains the same in the latest 
kernel: iterate all vCPUs, if mpidr matches, inject. next version will 
based on latest kernel.

>>> Based on the test results, the performance of vm  with less than 16 cores remains almost the same,
>>> while significant improvement can be observed with more than 16
>>> cores.
> 
> This triggers multiple questions:
> 
> - what is the test being used? on what hardware? how can I reproduce
>    this data?
> 
1. I utilized the ipi_benchmark 
(https://patchwork.kernel.org/project/linux-arm-kernel/patch/20171211141600.24401-1-ynorov@caviumnetworks.com/) 
with a modification to the Normal IPI target in the following manner: 
smp_call_function_single(31, handle_ipi, &time, 1).
2. On kunpeng 920 platform.
3. Using ipi_benchmark but change the target cpu in Normal IPI case, and 
use bcc or bpftrace to measuret the execution time of vgic_v3_dispatch_sgi.
> - which current guest OS *currently* make use of broadcast or 1:N
>    SGIs? Linux doesn't and overall SGI multicasting is pretty useless
>    to an OS.
> 
> [...]
Yes, arm64 linux almost never send broadcast ipi. I will use another 
test data to prove performence improvement
> 
>>>   /*
>>> - * Compare a given affinity (level 1-3 and a level 0 mask, from the SGI
>>> - * generation register ICC_SGI1R_EL1) with a given VCPU.
>>> - * If the VCPU's MPIDR matches, return the level0 affinity, otherwise
>>> - * return -1.
>>> + * Get affinity routing index from ICC_SGI_* register
>>> + * format:
>>> + *     aff3       aff2       aff1            aff0
>>> + * |- 8 bits -|- 8 bits -|- 8 bits -|- 4 bits or 8bits -|
> 
> OK, so you are implementing RSS support:
> 
> - Why isn't that mentioned anywhere in the commit log?
> 
> - Given that KVM actively limits the MPIDR to 4 bits at Aff0, how does
>    it even work the first place?
> 
> - How is that advertised to the guest?
> 
> - How can the guest enable RSS support?
> 
thanks to mention that, I also checked the relevant code, guest can't 
enable RSS, it was my oversight. This part has removed in next version.
> This is not following the GICv3 architecture, and I'm sceptical that
> it actually works as is (I strongly suspect that you have additional
> patches...).
there are nothing left, all the patchs are here
> 
> 	M.
> 
With regards
Xu
