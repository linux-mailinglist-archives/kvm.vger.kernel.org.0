Return-Path: <kvm+bounces-20970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BD43A927F7A
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 02:56:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E066B1C21FBC
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 00:56:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A09A27492;
	Fri,  5 Jul 2024 00:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GrjpJVdi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416336FDC
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 00:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720140965; cv=none; b=H2Mh7qRtxiqllfNOdTNE4L/H05oATVvfvOEMLEokY88nJ94ZwNKeqjNLqxpfALjKN7OXgUt/Q60sQ5FAeExxSWrcuEuK9apkb6BMAXQZ9Z3Zeg5c4/uiMAnrheCbM/xd3xIIGPcVd/tx3DmGBHHPfvX5QZrmZ1H0MirnnFb2XYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720140965; c=relaxed/simple;
	bh=S3xwj3SSrHexk+7iACYLjVGlkWmIXxZdU+QnTCrBghA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=icqjmaPt7qm+RlSVu1co1f4V1I+fTPrwnEYKgOSW17Gm1+d9uG1l1g5lnZmrgxDRsNV9h6+rlOlnspEyT3KnlDDqCeDxtm2t5X6ftoSeIploc6ZlJNDXXglXWnOdpTt1jddQVANB/6W3id6gtAZpznCmplHaoQ5x1AicRDRbwBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GrjpJVdi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720140963;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gJxuE3owsaN1b9K+F3KXTBVImtk1DkIBSsoZGA+zEMM=;
	b=GrjpJVdiXDRUSjklru1CxDyouyKQiuFZLMJty45ThPV8Ui1SxGzk8LwbmLSeYgiKDwXKUL
	gWTjQz+MgjookNzICldk//ZhqGE8sQOzswSv3slF7L9cZoInY6AEfZKa6IFNa5ThXP66Yq
	VDo1xRGcflPVEa1J6UVWlHfBY5bE8ns=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-376-Abwrqe1JMIiDJaMbQ9bi0Q-1; Thu, 04 Jul 2024 20:56:01 -0400
X-MC-Unique: Abwrqe1JMIiDJaMbQ9bi0Q-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6b5e96477ebso15307806d6.1
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 17:56:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720140960; x=1720745760;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gJxuE3owsaN1b9K+F3KXTBVImtk1DkIBSsoZGA+zEMM=;
        b=ra1LT77xq+5QdbOA5CHTntY+MFy1BfBUoZ9z1CZACre9tjaLmEG792ahwtEWdQ0pRf
         5bL1PSMxhY1Ay/ierU7011bQ+uEsM/D7km6mSDSNBmpBUOY+k6c0f2eX2WbrQF+EpUTk
         st2wVvrT8OZVvC2rPiTb878Q+6p4kleUfLI7/k8Pl0nW643dPySJA+uaGDF4PHXkeqn6
         VnJmKBXXhTbfrSZJ8Fxtt2Q6uTZcYLw+Equtuz3RTRacckEUWjg4hzzjlqJhdEYc4M5h
         VA8wUw9SU4xI61xuy9XC4RaFMynYOQo0LGBynNorJYYKv47w4AgmsGflDLShQYwTRrg6
         S+aw==
X-Gm-Message-State: AOJu0YybkEAggp6aiZ0JODEamv6rRaedjwJBDM1g3p4JIVRScrq7WxLx
	jIJVouBEE6Kt3+C2KF2uoqSwVBJAqcZEonZUVzMn98mj3Tmhe4OI0HVy2JseD9DignelDak2LUo
	y2/40xO7YN8z1kw1ux9NCXk5S79uPyTQC9kzQ72HRgI1MgjCHaQ==
X-Received: by 2002:a05:6214:2601:b0:6b5:a98:44b8 with SMTP id 6a1803df08f44-6b5ecfd0681mr35685856d6.29.1720140960659;
        Thu, 04 Jul 2024 17:56:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEyAP9RBwLKkq+JtxHkjFTmueN5ngBcP0znqcM1KGgsC10aA2MLvsEc+7uyOHEIBbT3jwGcow==
X-Received: by 2002:a05:6214:2601:b0:6b5:a98:44b8 with SMTP id 6a1803df08f44-6b5ecfd0681mr35685656d6.29.1720140960318;
        Thu, 04 Jul 2024 17:56:00 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b5e9d6f9besm12437426d6.138.2024.07.04.17.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 17:56:00 -0700 (PDT)
Message-ID: <55ed983e83b419fe0d8063cc41953b9f45fac198.camel@redhat.com>
Subject: Re: [PATCH v2 04/49] KVM: selftests: Update x86's set_sregs_test to
 match KVM's CPUID enforcement
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 20:55:59 -0400
In-Reply-To: <20240517173926.965351-5-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-5-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2024-05-17 at 10:38 -0700, Sean Christopherson wrote:
> Rework x86's set sregs test to verify that KVM enforces CPUID vs. CR4
> features even if userspace hasn't explicitly set guest CPUID.  KVM used to
> allow userspace to set any KVM-supported CR4 value prior to KVM_SET_CPUID2,
> and the test verified that behavior.
> 
> However, the testcase was written purely to verify KVM's existing behavior,
> i.e. was NOT written to match the needs of real world VMMs.
> 
> Opportunistically verify that KVM continues to reject unsupported features
> after KVM_SET_CPUID2 (using KVM_GET_SUPPORTED_CPUID).
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/x86_64/set_sregs_test.c     | 53 +++++++++++--------
>  1 file changed, 30 insertions(+), 23 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/set_sregs_test.c b/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
> index c021c0795a96..96fd690d479a 100644
> --- a/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
> @@ -41,13 +41,15 @@ do {										\
>  	TEST_ASSERT(!memcmp(&new, &orig, sizeof(new)), "KVM modified sregs");	\
>  } while (0)
>  
> +#define KVM_ALWAYS_ALLOWED_CR4 (X86_CR4_VME | X86_CR4_PVI | X86_CR4_TSD |	\
> +				X86_CR4_DE | X86_CR4_PSE | X86_CR4_PAE |	\
> +				X86_CR4_MCE | X86_CR4_PGE | X86_CR4_PCE |	\
> +				X86_CR4_OSFXSR | X86_CR4_OSXMMEXCPT)
> +
>  static uint64_t calc_supported_cr4_feature_bits(void)
>  {
> -	uint64_t cr4;
> +	uint64_t cr4 = KVM_ALWAYS_ALLOWED_CR4;
>  
> -	cr4 = X86_CR4_VME | X86_CR4_PVI | X86_CR4_TSD | X86_CR4_DE |
> -	      X86_CR4_PSE | X86_CR4_PAE | X86_CR4_MCE | X86_CR4_PGE |
> -	      X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_OSXMMEXCPT;
>  	if (kvm_cpu_has(X86_FEATURE_UMIP))
>  		cr4 |= X86_CR4_UMIP;
>  	if (kvm_cpu_has(X86_FEATURE_LA57))
> @@ -72,28 +74,14 @@ static uint64_t calc_supported_cr4_feature_bits(void)
>  	return cr4;
>  }
>  
> -int main(int argc, char *argv[])
> +static void test_cr_bits(struct kvm_vcpu *vcpu, uint64_t cr4)
>  {
>  	struct kvm_sregs sregs;
> -	struct kvm_vcpu *vcpu;
> -	struct kvm_vm *vm;
> -	uint64_t cr4;
>  	int rc, i;
>  
> -	/*
> -	 * Create a dummy VM, specifically to avoid doing KVM_SET_CPUID2, and
> -	 * use it to verify all supported CR4 bits can be set prior to defining
> -	 * the vCPU model, i.e. without doing KVM_SET_CPUID2.
> -	 */
> -	vm = vm_create_barebones();
> -	vcpu = __vm_vcpu_add(vm, 0);
> -
>  	vcpu_sregs_get(vcpu, &sregs);
> -
> -	sregs.cr0 = 0;
> -	sregs.cr4 |= calc_supported_cr4_feature_bits();
> -	cr4 = sregs.cr4;
> -
> +	sregs.cr0 &= ~(X86_CR0_CD | X86_CR0_NW);
> +	sregs.cr4 |= cr4;
>  	rc = _vcpu_sregs_set(vcpu, &sregs);
>  	TEST_ASSERT(!rc, "Failed to set supported CR4 bits (0x%lx)", cr4);
>  
> @@ -101,7 +89,6 @@ int main(int argc, char *argv[])
>  	TEST_ASSERT(sregs.cr4 == cr4, "sregs.CR4 (0x%llx) != CR4 (0x%lx)",
>  		    sregs.cr4, cr4);
>  
> -	/* Verify all unsupported features are rejected by KVM. */
>  	TEST_INVALID_CR_BIT(vcpu, cr4, sregs, X86_CR4_UMIP);
>  	TEST_INVALID_CR_BIT(vcpu, cr4, sregs, X86_CR4_LA57);
>  	TEST_INVALID_CR_BIT(vcpu, cr4, sregs, X86_CR4_VMXE);
> @@ -119,10 +106,28 @@ int main(int argc, char *argv[])
>  	/* NW without CD is illegal, as is PG without PE. */
>  	TEST_INVALID_CR_BIT(vcpu, cr0, sregs, X86_CR0_NW);
>  	TEST_INVALID_CR_BIT(vcpu, cr0, sregs, X86_CR0_PG);
> +}
>  
> +int main(int argc, char *argv[])
> +{
> +	struct kvm_sregs sregs;
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +	int rc;
> +
> +	/*
> +	 * Create a dummy VM, specifically to avoid doing KVM_SET_CPUID2, and
> +	 * use it to verify KVM enforces guest CPUID even if *userspace* never
> +	 * sets CPUID.
> +	 */
> +	vm = vm_create_barebones();
> +	vcpu = __vm_vcpu_add(vm, 0);
> +	test_cr_bits(vcpu, KVM_ALWAYS_ALLOWED_CR4);
>  	kvm_vm_free(vm);
>  
> -	/* Create a "real" VM and verify APIC_BASE can be set. */
> +	/* Create a "real" VM with a fully populated guest CPUID and verify
> +	 * APIC_BASE and all supported CR4 can be set.
> +	 */
>  	vm = vm_create_with_one_vcpu(&vcpu, NULL);
>  
>  	vcpu_sregs_get(vcpu, &sregs);
> @@ -135,6 +140,8 @@ int main(int argc, char *argv[])
>  	TEST_ASSERT(!rc, "Couldn't set IA32_APIC_BASE to %llx (valid)",
>  		    sregs.apic_base);
>  
> +	test_cr_bits(vcpu, calc_supported_cr4_feature_bits());
> +
>  	kvm_vm_free(vm);
>  
>  	return 0;


Makes sense.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


