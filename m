Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC3634D2BFD
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 10:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbiCIJad (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 04:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbiCIJa2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 04:30:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F54E16EA8C
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 01:29:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646818169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6YUYIcwixv9xPs5YQ2KQbYGaGUdidrNF8nAaHdrTppY=;
        b=PacQ53wezVvDtt0lV2uxamHBt/zFVMkOnFqVKsdxT1W6dAwSEGapwi+YWCGrDdhC2ZVPza
        PH7EHUxVVTA+AOciPg9x3EaCvXPs7p4hEo8FEjIcn0/4H9d6GvOBfGSs5iSpYqOB6WZ+K9
        7Xd7xc5OWHRpXl93RfX3r6TzT5uyzpo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-XlcDTY_mOwC-OV_CGED2pg-1; Wed, 09 Mar 2022 04:29:28 -0500
X-MC-Unique: XlcDTY_mOwC-OV_CGED2pg-1
Received: by mail-wr1-f72.google.com with SMTP id t15-20020adfdc0f000000b001ef93643476so553805wri.2
        for <kvm@vger.kernel.org>; Wed, 09 Mar 2022 01:29:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6YUYIcwixv9xPs5YQ2KQbYGaGUdidrNF8nAaHdrTppY=;
        b=joHTMJe4EY9+J+nHmckSoHJHNIKbBo/2fR8d1ZOmEoDyBkLXV7Jo6TobUVf8OFjOVv
         xfNSc9+K81KXzclO6RyLR4IhkgBKEG1d9TnZGZisDviGzk/o46BZzbnN+yjWfIKkEHRf
         1E33u//amjkwPNc13GQo+kQL/z+cFTCkAea7cHPetGR057ES7cigNB55SA9VLAJADdm8
         sjPFz5DOlhOAAE3m3GDRPIx7mm8+QtU8LPpvsyyk+NdJsCS397doVdp7NOlVMDplAqu1
         RlXnrBVYQZiaG+xmphKKdz66c0D8hOQN0aLI6Sh6PeIykwYppx+5z/wX0Tqq8XBSy8sx
         4IPg==
X-Gm-Message-State: AOAM532jhc1Ly3IjFqZlwJYJqpCxex+qRNm+uvTyS/WOp3cnPVmWts+T
        DvP5mK9fBEN3h/6ZHLJP42iEraH8vJfDlp1DejO0PhysjUrSzfWKzOMt5L0FquofnaXkDtKfU7P
        GHxjS9rXD1rH0
X-Received: by 2002:a1c:6a08:0:b0:388:73a2:1548 with SMTP id f8-20020a1c6a08000000b0038873a21548mr2589284wmc.163.1646818166611;
        Wed, 09 Mar 2022 01:29:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxEbt+c8okfU5DwO35n4fyWDyYUEpVVbAC+ADCiIS9+uCxOi9jPzZQLrfYJoBwSd5qpf9jtGQ==
X-Received: by 2002:a1c:6a08:0:b0:388:73a2:1548 with SMTP id f8-20020a1c6a08000000b0038873a21548mr2589273wmc.163.1646818166354;
        Wed, 09 Mar 2022 01:29:26 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id p5-20020a05600c358500b0038167e239a2sm1253364wmq.19.2022.03.09.01.29.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 01:29:25 -0800 (PST)
Message-ID: <7746aad0-3968-ffba-1b7e-97e52b1afd6a@redhat.com>
Date:   Wed, 9 Mar 2022 10:29:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH][v3] KVM: x86: Support the vCPU preemption check with
 nopvspin and realtime hint
Content-Language: en-US
To:     Li RongQing <lirongqing@baidu.com>, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, x86@kernel.org,
        kvm@vger.kernel.org, wanpengli@tencent.com
References: <1646815610-43315-1-git-send-email-lirongqing@baidu.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <1646815610-43315-1-git-send-email-lirongqing@baidu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/9/22 09:46, Li RongQing wrote:
> If guest kernel is configured with nopvspin, or CONFIG_PARAVIRT_SPINLOCK
> is disabled, or guest find its has dedicated pCPUs from realtime hint
> feature, the pvspinlock will be disabled, and vCPU preemption check
> is disabled too.
> 
> but KVM still can emulating HLT for vCPU for both cases, and check if vCPU
> is preempted or not, and can boost performance
> 
> so move the setting of pv_ops.lock.vcpu_is_preempted to kvm_guest_init, make
> it not depend on pvspinlock
> 
> Like unixbench, single copy, vcpu with dedicated pCPU and guest kernel with
> nopvspin, but emulating HLT for vCPU`:
> 
> Testcase                                  Base    with patch
> System Benchmarks Index Values            INDEX     INDEX
> Dhrystone 2 using register variables     3278.4    3277.7
> Double-Precision Whetstone                822.8     825.8
> Execl Throughput                         1296.5     941.1
> File Copy 1024 bufsize 2000 maxblocks    2124.2    2142.7
> File Copy 256 bufsize 500 maxblocks      1335.9    1353.6
> File Copy 4096 bufsize 8000 maxblocks    4256.3    4760.3
> Pipe Throughput                          1050.1    1054.0
> Pipe-based Context Switching              243.3     352.0
> Process Creation                          820.1     814.4
> Shell Scripts (1 concurrent)             2169.0    2086.0
> Shell Scripts (8 concurrent)             7710.3    7576.3
> System Call Overhead                      672.4     673.9
>                                        ========    =======
> System Benchmarks Index Score             1467.2   1483.0
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
> diff v3: fix building failure when CONFIG_PARAVIRT_SPINLOCK is disable
>           and setting preemption check only when unhalt
> diff v2: move setting preemption check to kvm_guest_init
> 
>   arch/x86/kernel/kvm.c | 74 +++++++++++++++++++++++++--------------------------
>   1 file changed, 37 insertions(+), 37 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index d77481ec..959f919 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -752,6 +752,39 @@ static void kvm_crash_shutdown(struct pt_regs *regs)
>   }
>   #endif
>   
> +#ifdef CONFIG_X86_32
> +__visible bool __kvm_vcpu_is_preempted(long cpu)
> +{
> +	struct kvm_steal_time *src = &per_cpu(steal_time, cpu);
> +
> +	return !!(src->preempted & KVM_VCPU_PREEMPTED);
> +}
> +PV_CALLEE_SAVE_REGS_THUNK(__kvm_vcpu_is_preempted);
> +
> +#else
> +
> +#include <asm/asm-offsets.h>
> +
> +extern bool __raw_callee_save___kvm_vcpu_is_preempted(long);
> +
> +/*
> + * Hand-optimize version for x86-64 to avoid 8 64-bit register saving and
> + * restoring to/from the stack.
> + */
> +asm(
> +".pushsection .text;"
> +".global __raw_callee_save___kvm_vcpu_is_preempted;"
> +".type __raw_callee_save___kvm_vcpu_is_preempted, @function;"
> +"__raw_callee_save___kvm_vcpu_is_preempted:"
> +"movq	__per_cpu_offset(,%rdi,8), %rax;"
> +"cmpb	$0, " __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax);"
> +"setne	%al;"
> +"ret;"
> +".size __raw_callee_save___kvm_vcpu_is_preempted, .-__raw_callee_save___kvm_vcpu_is_preempted;"
> +".popsection");
> +
> +#endif
> +
>   static void __init kvm_guest_init(void)
>   {
>   	int i;
> @@ -764,6 +797,10 @@ static void __init kvm_guest_init(void)
>   	if (kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
>   		has_steal_clock = 1;
>   		static_call_update(pv_steal_clock, kvm_steal_clock);
> +
> +		if (kvm_para_has_feature(KVM_FEATURE_PV_UNHALT))
> +			pv_ops.lock.vcpu_is_preempted =
> +				PV_CALLEE_SAVE(__kvm_vcpu_is_preempted);
>   	}

Is it necessary to check PV_UNHALT?  The bit is present anyway in the 
steal time struct, unless it's a very old kernel.  And it's safe to 
always return zero if the bit is not present.

Paolo

