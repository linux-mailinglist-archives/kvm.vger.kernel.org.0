Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A503E126B
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 12:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239963AbhHEKSC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 06:18:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33700 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239866AbhHEKSB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Aug 2021 06:18:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628158666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RGCDd+VFDPy5rMoo1alS1/3RDEYL6LRCLUYw59oQro8=;
        b=SeavDOtlHh6nm7MXy4JLScx+isIin3D9cG6dItalqnmABZp10M5+JTqg6MPM3dL6IsTczb
        W6u8YupU8I5gCtH3i3p1rEAJA25wDRYTAZHh6DyyMLP6PMX0hydOBeZ5i9V5e1pHE74enT
        /cFWeD8K5iPJY0TCT0KvdgP8CHdBM58=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-svYoIvWyMz-ApYsybDSkeg-1; Thu, 05 Aug 2021 06:17:45 -0400
X-MC-Unique: svYoIvWyMz-ApYsybDSkeg-1
Received: by mail-ed1-f71.google.com with SMTP id d6-20020a50f6860000b02903bc068b7717so2916977edn.11
        for <kvm@vger.kernel.org>; Thu, 05 Aug 2021 03:17:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RGCDd+VFDPy5rMoo1alS1/3RDEYL6LRCLUYw59oQro8=;
        b=rRza80gS8Q4kWNRgvQkosVkdDNAJUIuTZ69fPdnKLTQbJttnVxRKPIhBAuz81j15L5
         biEkG291OpS+kFXlHUuxqufkcx9MDm4aMg+mFEKT1dLINt93fk4s2QKzWrrJMU0rwNlZ
         DdXD6D79CuMT2yRv7hemYT3D7iY1k5GYBsUKjK2xc+t0PNAU0aj8Ep+z5GxbXbDV1tZF
         c5wKWcghzqVLFRJKDOx0KGYMbEzkGsODsDr8Y6RKEqHXW7Uawe0HVKBqMWkvKiNIvo5J
         VGUm/8SS4eJBO3KWVH/vzI167iwUFO7zskF+FG+1UIfYj0ftr8UmWRRA/tu3kA1cBkEH
         ihnQ==
X-Gm-Message-State: AOAM530XTp68PzUHNJeKTDsC/UTekd/lMOFjyST1FtXp33aKGoJUDDJp
        fbTC/iMuK00abCcJE8s9EFs5pjEd7NoLHuceUOyx6zJc2UOeovb+EC7TQLDRLPVkpJvQS9AkDEh
        gSH7PUAcVFn/wPm1rHPzNPxQzVlKjmSnDbSnkLGlbtD3BQKQ19MahkO2ymYdCrl96
X-Received: by 2002:a05:6402:3128:: with SMTP id dd8mr5628022edb.367.1628158664009;
        Thu, 05 Aug 2021 03:17:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxtEjXuGxjytu7uL6GYVtx3F46+LVD5GBTLwf+ROQli87U0/aiZSvCHs4peECe9Fat4OftlCw==
X-Received: by 2002:a05:6402:3128:: with SMTP id dd8mr5627991edb.367.1628158663768;
        Thu, 05 Aug 2021 03:17:43 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id y23sm1541836ejp.115.2021.08.05.03.17.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Aug 2021 03:17:43 -0700 (PDT)
To:     Lara Lazier <laramglazier@gmail.com>, kvm@vger.kernel.org
References: <20210805085746.95096-1-laramglazier@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH kvm-unit-tests] nSVM: test canonicalization of segment
 bases in VMLOAD
Message-ID: <db4df39d-ee72-ff81-2633-ec28854cc4f0@redhat.com>
Date:   Thu, 5 Aug 2021 12:17:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210805085746.95096-1-laramglazier@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/08/21 10:57, Lara Lazier wrote:
> APM2 states that VMRUN and VMLOAD should canonicalize all base
> addresses in the segment registers that have been loaded respectively.
> 
> Split up in test_canonicalization the TEST_CANONICAL for VMLOAD and
> VMRUN. Added the respective test for KERNEL_GS.
> 
> Signed-off-by: Lara Lazier <laramglazier@gmail.com>
> ---
>   x86/svm_tests.c | 51 +++++++++++++++++++++++++++++++++----------------
>   1 file changed, 35 insertions(+), 16 deletions(-)
> 
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index 7c7b19d..f6bccb7 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -2460,32 +2460,51 @@ static void test_msrpm_iopm_bitmap_addrs(void)
>   	vmcb->control.intercept = saved_intercept;
>   }
>   
> -#define TEST_CANONICAL(seg_base, msg)					\
> -	saved_addr = seg_base;						\
> +#define TEST_CANONICAL_VMRUN(seg_base, msg)					\
> +	saved_addr = seg_base;					\
>   	seg_base = (seg_base & ((1ul << addr_limit) - 1)) | noncanonical_mask; \
> -	report(svm_vmrun() == SVM_EXIT_VMMCALL, "Test %s.base for canonical form: %lx", msg, seg_base);							\
> +	return_value = svm_vmrun(); \
> +	report(return_value == SVM_EXIT_VMMCALL, \
> +			"Successful VMRUN with noncanonical %s.base", msg); \
> +	report(is_canonical(seg_base), \
> +			"Test %s.base for canonical form: %lx", msg, seg_base); \
> +	seg_base = saved_addr;

Interesting, processors seem not to write back the canonicalized form on 
VMRUN.  They probably remember it has not changed and avoid the 
writeback.  Oh well.

Note that you do not need to reproduce this behavior for QEMU/TCG, as it 
is not even documented.

I removed the second "report" and pushed the patch.

Thanks!

Paolo

> +
> +#define TEST_CANONICAL_VMLOAD(seg_base, msg)					\
> +	saved_addr = seg_base;					\
> +	seg_base = (seg_base & ((1ul << addr_limit) - 1)) | noncanonical_mask; \
> +	asm volatile ("vmload %0" : : "a"(vmcb_phys) : "memory"); \
> +	asm volatile ("vmsave %0" : : "a"(vmcb_phys) : "memory"); \
> +	report(is_canonical(seg_base), \
> +			"Test %s.base for canonical form: %lx", msg, seg_base); \
>   	seg_base = saved_addr;
>   
>   /*
>    * VMRUN canonicalizes (i.e., sign-extend to bit 63) all base addresses
>    • in the segment registers that have been loaded.
>    */
> -static void test_vmrun_canonicalization(void)
> +static void test_canonicalization(void)
>   {
>   	u64 saved_addr;
> -	u8 addr_limit = cpuid_maxphyaddr();
> +	u64 return_value;
> +	u64 addr_limit;
> +	u64 vmcb_phys = virt_to_phys(vmcb);
> +
> +	addr_limit = (this_cpu_has(X86_FEATURE_LA57)) ? 57 : 48;
>   	u64 noncanonical_mask = NONCANONICAL & ~((1ul << addr_limit) - 1);
>   
> -	TEST_CANONICAL(vmcb->save.es.base, "ES");
> -	TEST_CANONICAL(vmcb->save.cs.base, "CS");
> -	TEST_CANONICAL(vmcb->save.ss.base, "SS");
> -	TEST_CANONICAL(vmcb->save.ds.base, "DS");
> -	TEST_CANONICAL(vmcb->save.fs.base, "FS");
> -	TEST_CANONICAL(vmcb->save.gs.base, "GS");
> -	TEST_CANONICAL(vmcb->save.gdtr.base, "GDTR");
> -	TEST_CANONICAL(vmcb->save.ldtr.base, "LDTR");
> -	TEST_CANONICAL(vmcb->save.idtr.base, "IDTR");
> -	TEST_CANONICAL(vmcb->save.tr.base, "TR");
> +	TEST_CANONICAL_VMLOAD(vmcb->save.fs.base, "FS");
> +	TEST_CANONICAL_VMLOAD(vmcb->save.gs.base, "GS");
> +	TEST_CANONICAL_VMLOAD(vmcb->save.ldtr.base, "LDTR");
> +	TEST_CANONICAL_VMLOAD(vmcb->save.tr.base, "TR");
> +	TEST_CANONICAL_VMLOAD(vmcb->save.kernel_gs_base, "KERNEL GS");
> +	TEST_CANONICAL_VMRUN(vmcb->save.es.base, "ES");
> +	TEST_CANONICAL_VMRUN(vmcb->save.cs.base, "CS");
> +	TEST_CANONICAL_VMRUN(vmcb->save.ss.base, "SS");
> +	TEST_CANONICAL_VMRUN(vmcb->save.ds.base, "DS");
> +	TEST_CANONICAL_VMRUN(vmcb->save.gdtr.base, "GDTR");
> +	TEST_CANONICAL_VMRUN(vmcb->save.idtr.base, "IDTR");



