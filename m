Return-Path: <kvm+bounces-35825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88ABAA1546E
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 17:33:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E69583A3B68
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 16:32:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81F871A00FE;
	Fri, 17 Jan 2025 16:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZrejEyJB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0277F13B59B
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 16:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737131502; cv=none; b=aWRSd1Maff6QeX4TfTF3o6GfO1CxiDMERonxCtno+dExhKF2Ngvc5fhElPaK2U1uhWTtcOKD3yB5bbOzT0Ku1VJuQgJo2lCtLmXdxLAg2x/e9XAtzIBKcc8DDVOR6fG9NBenLonunCez6Lyu2kLJJ6iju9vkjU/qHpRAKSiAntM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737131502; c=relaxed/simple;
	bh=FeICJz26VuZJTBSz/mgNGIoJHYW0xflODP3chhVaxzk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=DIb6TkrDIojxMF8sZ0/KRXAy7tkbN7WtWcpSqR3XIoQyvJO1ydueV3eb0SSbmSbIngXSftPz8LGGV+UTuQUPa6kIM687PYPsHJ/9ClCGXyN05JHxcfEzWTlhw+GBqYhZQqDpHuJV8iNVO0TdvfoRQ0OokvxUFjmwBdKlHpgD/eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZrejEyJB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737131500;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+77/SaUXCKkXV6hKKiCSh57OzjBaZbkjDOMBDHfY2X4=;
	b=ZrejEyJBpOhg07We9OFeuRgaujsTBjKIB1UX3H9gjJ/nEKJ0Wv1NCbozTAO4uu107Tr93+
	9kIr8xWMmxDQqfYU76GCvG7/6xWFWFOeNvm/9tMHHkgwSkOwZ3U3SquEzhTxaqorthHH+o
	4s0cWKND4ukvFDeMF3XkN5f0TUYxx04=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-315-ZK7eRGTwPx-FbMYLmJastw-1; Fri, 17 Jan 2025 11:31:38 -0500
X-MC-Unique: ZK7eRGTwPx-FbMYLmJastw-1
X-Mimecast-MFC-AGG-ID: ZK7eRGTwPx-FbMYLmJastw
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43646b453bcso11629015e9.3
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 08:31:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737131497; x=1737736297;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+77/SaUXCKkXV6hKKiCSh57OzjBaZbkjDOMBDHfY2X4=;
        b=Pgj4zbfqusD3RKLtouK0MVfGEcniNwhZkdBGs0d3XkytYnb0/H+1hKV+Jt2Q/8zx81
         tUDlMVmBA9rDO0qTyXdOfDcd7f4PwMPuKIfjywh7yRFQ/Yap8BGhxWh01Vww2NU3MFhJ
         sOT4v4JsuTH7EKsXPIkxjaAgaT5wQ3zVQDVcNrH5g+FJHhGsRJogKVXSJPfn9yrrk/3G
         ZAVAftdUcVSYys9c3Kk+BBmvT0lVP9YCtf+tnVD4yxW8BF1gJOyBCPRYu6nzAugOSEQq
         q7+f0nTSTUox5TlThkc1J48wEKT7CxYlAMhCkA+4XHxFUV9DEdf8+601pRGYeECxk4Oz
         3zyA==
X-Gm-Message-State: AOJu0YzGX60Isd7mauw/mHaGkuF0btdnpUg+2BvWVvAT6jOnHgMCs4TO
	40O1P4rE7IVU+2ed3lqrsFTxZy2hQevXHRhteX4gfuKBXLgpgJEMFPIq04AKtCh60SYaXerOV1e
	ZDkoc6EImwrsWC5qoRYb97w2kzVYsUiKySj9Z0vimCc86N+kNlA==
X-Gm-Gg: ASbGncvooiHo22PzQc049AznPPThoKI9H5WsghPRY+mAdWVP5H8di0LQNGZzEhZzwQ8
	ieZjHEa1hxceOkZg/mlyRfgEn5uNYUaL47tdv1OZQYBh+ko4Z4SQ/QY8FqTERuRxnUU3O5LFJaJ
	yT9AaELG5bdc37upsP7VH3y9xTJ2Ye5z1xiuDlcjwiq4Dz+qNldXVrm0c/UKBOFbuiW8Lytq5hB
	prj9JXHIxdqGQYbRHJNRkPPzOVOhWQsoalie78VWIkOlxpVFuk=
X-Received: by 2002:a05:600c:1d07:b0:436:488f:50a with SMTP id 5b1f17b1804b1-438913ef4b7mr34995935e9.17.1737131497116;
        Fri, 17 Jan 2025 08:31:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFu82CO+1HMJl6Yl6mARaKmQ8v95VIoR/LMJxTs5DG8YsvMipJpx9rlFz3w6AWHY5Z1lYtE6g==
X-Received: by 2002:a05:600c:1d07:b0:436:488f:50a with SMTP id 5b1f17b1804b1-438913ef4b7mr34995535e9.17.1737131496762;
        Fri, 17 Jan 2025 08:31:36 -0800 (PST)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43890469ba8sm37794535e9.37.2025.01.17.08.31.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2025 08:31:36 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Dongjie Zou
 <zoudongjie@huawei.com>, stable@vger.kernel
Subject: Re: [PATCH 4/5] KVM: selftests: Manage CPUID array in Hyper-V CPUID
 test's core helper
In-Reply-To: <20250113222740.1481934-5-seanjc@google.com>
References: <20250113222740.1481934-1-seanjc@google.com>
 <20250113222740.1481934-5-seanjc@google.com>
Date: Fri, 17 Jan 2025 17:31:35 +0100
Message-ID: <87h65x8krc.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

> Allocate, get, and free the CPUID array in the Hyper-V CPUID test in the
> test's core helper, instead of copy+pasting code at each call site.  In
> addition to deduplicating a small amount of code, restricting visibility
> of the array to a single invocation of the core test prevents "leaking" an
> array across test cases.  Passing in @vcpu to the helper will also allow
> pivoting on VM-scoped information without needing to pass more booleans,
> e.g. to conditionally assert on features that require an in-kernel APIC.
>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/x86_64/hyperv_cpuid.c       | 25 ++++++++-----------
>  1 file changed, 11 insertions(+), 14 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> index 09f9874d7705..90c44765d584 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> @@ -41,13 +41,18 @@ static bool smt_possible(void)
>  	return res;
>  }
>  
> -static void test_hv_cpuid(const struct kvm_cpuid2 *hv_cpuid_entries,
> -			  bool evmcs_expected)
> +static void test_hv_cpuid(struct kvm_vcpu *vcpu, bool evmcs_expected)
>  {
> +	const struct kvm_cpuid2 *hv_cpuid_entries;
>  	int i;
>  	int nent_expected = 10;
>  	u32 test_val;
>  
> +	if (vcpu)
> +		hv_cpuid_entries = vcpu_get_supported_hv_cpuid(vcpu);
> +	else
> +		hv_cpuid_entries = kvm_get_supported_hv_cpuid();
> +
>  	TEST_ASSERT(hv_cpuid_entries->nent == nent_expected,
>  		    "KVM_GET_SUPPORTED_HV_CPUID should return %d entries"
>  		    " (returned %d)",
> @@ -109,6 +114,7 @@ static void test_hv_cpuid(const struct kvm_cpuid2 *hv_cpuid_entries,
>  		 *	entry->edx);
>  		 */
>  	}
> +	free((void *)hv_cpuid_entries);

(see my comment on "[PATCH 3/5] KVM: selftests: Explicitly free CPUID
array at end of Hyper-V CPUID test"): 

vcpu_get_supported_hv_cpuid() allocates memory for the resulting array
each time, however, kvm_get_supported_hv_cpuid() doesn't so freeing
hv_cpuid_entries here will result in returning already freed memory next
time kvm_get_supported_hv_cpuid() path is taken.

>  }
>  
>  static void test_hv_cpuid_e2big(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
> @@ -129,7 +135,6 @@ static void test_hv_cpuid_e2big(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
>  int main(int argc, char *argv[])
>  {
>  	struct kvm_vm *vm;
> -	const struct kvm_cpuid2 *hv_cpuid_entries;
>  	struct kvm_vcpu *vcpu;
>  
>  	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_CPUID));
> @@ -138,10 +143,7 @@ int main(int argc, char *argv[])
>  
>  	/* Test vCPU ioctl version */
>  	test_hv_cpuid_e2big(vm, vcpu);
> -
> -	hv_cpuid_entries = vcpu_get_supported_hv_cpuid(vcpu);
> -	test_hv_cpuid(hv_cpuid_entries, false);
> -	free((void *)hv_cpuid_entries);
> +	test_hv_cpuid(vcpu, false);
>  
>  	if (!kvm_cpu_has(X86_FEATURE_VMX) ||
>  	    !kvm_has_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS)) {
> @@ -149,9 +151,7 @@ int main(int argc, char *argv[])
>  		goto do_sys;
>  	}
>  	vcpu_enable_evmcs(vcpu);
> -	hv_cpuid_entries = vcpu_get_supported_hv_cpuid(vcpu);
> -	test_hv_cpuid(hv_cpuid_entries, true);
> -	free((void *)hv_cpuid_entries);
> +	test_hv_cpuid(vcpu, true);
>  
>  do_sys:
>  	/* Test system ioctl version */
> @@ -161,10 +161,7 @@ int main(int argc, char *argv[])
>  	}
>  
>  	test_hv_cpuid_e2big(vm, NULL);
> -
> -	hv_cpuid_entries = kvm_get_supported_hv_cpuid();
> -	test_hv_cpuid(hv_cpuid_entries, kvm_cpu_has(X86_FEATURE_VMX));
> -	free((void *)hv_cpuid_entries);
> +	test_hv_cpuid(NULL, kvm_cpu_has(X86_FEATURE_VMX));
>  
>  out:
>  	kvm_vm_free(vm);

-- 
Vitaly


