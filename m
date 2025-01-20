Return-Path: <kvm+bounces-36019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CE8B1A16E59
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 15:21:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1EB3E1881A88
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 14:21:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CE991E379F;
	Mon, 20 Jan 2025 14:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PiNPAPFm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B9B1E3786
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 14:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737382857; cv=none; b=m2F3wLANp1oG/4QOLXNPUAgKGqv+bdYKjvgpqojyU6L7JzsIJLzjJQDhM0fkDHXXoBY03fYmnJlkcJHC5gqUg/XpBlgyRiz/vVfAQwxWQkU12mAWNoVeZV9py+DkrKgvqNnEY9zI+Nmn+kHB8Y3S1WpB0CpcbZ8OtJnn519KmaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737382857; c=relaxed/simple;
	bh=suKxKDTEjcS+hBYZlJUZIHQsfCWIJB64PESfiLzeAyQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=flpH9TUSN1MqYhinl3NUnH1QStU9mVuzXgbDm6f71R9OmhocAs9c45VshnzSvoHrFdUXMkRb5yqyOg6Gs8ucPgKj+r9ULofH2dEPsHJXIHRfOMJPw7MjFQWTz12ru9Yc5UCgit0mZBGw2LJEhMiSy7tnEARomEkhSAbBlU3GpFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PiNPAPFm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737382854;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SvN2HL1s3vl0r88ePE5HTVvwon5QIhXjCIcs6kwnVUI=;
	b=PiNPAPFmkV8rrglV8t7IvoxHDLTElB5WuHqSWz44lzYHGKTrzoq3FopVeAlPCrFLIp8OoK
	nq8GRdjvJD7e8tAsSBe82yjqtY57wi41JPJ1pe/6KNpCmwvylcV4tNYVu5dHFbBX0WavGy
	XU2Y1WOzW25bslBOfqvvp09FK67mfGY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-_dvDfQHRMqGqwmlErj5CTg-1; Mon, 20 Jan 2025 09:20:53 -0500
X-MC-Unique: _dvDfQHRMqGqwmlErj5CTg-1
X-Mimecast-MFC-AGG-ID: _dvDfQHRMqGqwmlErj5CTg
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3862be3bfc9so2846795f8f.3
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 06:20:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737382852; x=1737987652;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SvN2HL1s3vl0r88ePE5HTVvwon5QIhXjCIcs6kwnVUI=;
        b=gx/ITwH+y+biHo9sUICcq4en56SmzgLQMujVTyRONC3KzB39zIS2G07OkjSYK4gSRl
         8ipNEhoTGz26oq1KX2xiRUI74ZmCSdHzUfno+5tJXzC6PWZz3tTKnavfgaG/zwnz3iGh
         oOF/2HBUjRDw9jM1cDDV7jC+MuRtyoxkNzxD9fOCujyA0FtQqELEfer71YslBHxAvScL
         b2rLjDlwyS+DWVBgflXX97yN6Z2J32fAQ1RgCVFzIoBenYjRIzvBj1+cBK5zaxRGvzln
         z/Y4I7zEXuhWO+iqzpRqvFglhR2uSPdhg6BXl/XG/dXd7Ggv9xGqloHA5ipShefGWOls
         wbKw==
X-Gm-Message-State: AOJu0YzNxJpt5KEw3lNuezodkY+/ZVRrySrhaPtTNNz7S9pUIJJCy8mH
	tHbtnOlhen4Hn/XYP5y4yIHIRijxrZJ9Ow7ue1xVsLdecwFC9ujbSDlFqRUxm0oeinz+40ttxk0
	DkrQLqgHLR7oJ7DGD7c/aUED7ezCKbDtM4pKwRi+kTTZfvXj9VeAQW64lKw==
X-Gm-Gg: ASbGncsonr8OisZtJtKuY7XDGltsR4z69Lihe3z7K5U2DkHfVs8+aRU+wSZDfBZ1/10
	kX01LLDNtY1sJ0xKHaHqfFw9UBihRUX/GLh3l6cN++Zq7KK/l77zvxOGMZnCtMrbh7kiVZMV2Ev
	drp4luzCsoR4A1dPzIoCvmeRjCg6mzOisDlqdDCE01qNLleiWIjETgK1LI+SMq15s3z34qIEVZw
	51kzRDyVrNt8YI7SFa9S8MQ4o+iBPKzUnYp7qsZAKMg2LWPPrgbp0HP/QDfYRam
X-Received: by 2002:a5d:47c2:0:b0:385:e8ce:7483 with SMTP id ffacd0b85a97d-38bf56555admr9436276f8f.4.1737382852041;
        Mon, 20 Jan 2025 06:20:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEQRZWBg3BiN14B3lboMp8g8k3LhBlXdMxIMG0O7SHp8HTkJQ4e3YMeYry8CkbCXZokHWp2Gg==
X-Received: by 2002:a5d:47c2:0:b0:385:e8ce:7483 with SMTP id ffacd0b85a97d-38bf56555admr9436260f8f.4.1737382851631;
        Mon, 20 Jan 2025 06:20:51 -0800 (PST)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438904625f5sm144155115e9.28.2025.01.20.06.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2025 06:20:51 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Dongjie Zou
 <zoudongjie@huawei.com>
Subject: Re: [PATCH v2 3/4] KVM: selftests: Manage CPUID array in Hyper-V
 CPUID test's core helper
In-Reply-To: <20250118003454.2619573-4-seanjc@google.com>
References: <20250118003454.2619573-1-seanjc@google.com>
 <20250118003454.2619573-4-seanjc@google.com>
Date: Mon, 20 Jan 2025 15:20:50 +0100
Message-ID: <875xm98t31.fsf@redhat.com>
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
> To avoid use-after-free bugs due to overzealous and careless developers,
> opportunstically add a comment to explain that the system-scoped helper
> caches the Hyper-V CPUID entries, i.e. that the caller is not responsible
> for freeing the memory.
>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/x86_64/hyperv_cpuid.c       | 30 +++++++++++--------
>  1 file changed, 17 insertions(+), 13 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> index 9a0fcc713350..3188749ec6e1 100644
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
> @@ -109,6 +114,13 @@ static void test_hv_cpuid(const struct kvm_cpuid2 *hv_cpuid_entries,
>  		 *	entry->edx);
>  		 */
>  	}
> +
> +	/*
> +	 * Note, the CPUID array returned by the system-scoped helper is a one-
> +	 * time allocation, i.e. must not be freed.
> +	 */
> +	if (vcpu)
> +		free((void *)hv_cpuid_entries);
>  }
>  
>  static void test_hv_cpuid_e2big(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
> @@ -129,7 +141,6 @@ static void test_hv_cpuid_e2big(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
>  int main(int argc, char *argv[])
>  {
>  	struct kvm_vm *vm;
> -	const struct kvm_cpuid2 *hv_cpuid_entries;
>  	struct kvm_vcpu *vcpu;
>  
>  	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_CPUID));
> @@ -138,10 +149,7 @@ int main(int argc, char *argv[])
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
> @@ -149,9 +157,7 @@ int main(int argc, char *argv[])
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
> @@ -161,9 +167,7 @@ int main(int argc, char *argv[])
>  	}
>  
>  	test_hv_cpuid_e2big(vm, NULL);
> -
> -	hv_cpuid_entries = kvm_get_supported_hv_cpuid();
> -	test_hv_cpuid(hv_cpuid_entries, kvm_cpu_has(X86_FEATURE_VMX));
> +	test_hv_cpuid(NULL, kvm_cpu_has(X86_FEATURE_VMX));
>  
>  out:
>  	kvm_vm_free(vm);

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly


