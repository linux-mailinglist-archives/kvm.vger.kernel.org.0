Return-Path: <kvm+bounces-36018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3030DA16E58
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 15:21:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD4E118814C7
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 14:21:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAAC31E32CA;
	Mon, 20 Jan 2025 14:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YdfEdx21"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509671DED7B
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 14:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737382852; cv=none; b=i63xauHbFhm5yZakX/q8rm7E9Fb752zhukV3iAVwtc88L15uooRSNBNgse4zere0GY8v0qZVOtmMW74aXOtZAOnPml5wBZieRegMWU71Dmds9iR7d59VN6T/r65l/SewFqMJHAZu6RR1j5IAjoTX7BIE+f/n94oe0vwSnpoyR4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737382852; c=relaxed/simple;
	bh=nx6qFDSuHXU5+jLvEnHbxJo96kpctDpPjOqbTyejF8o=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Q7pOgzLgt4GSyAR/gjegSwoNak+sPIpOn1Jg2tAVdtusEqYo4ZoFAOceZeg2vz/E3mBdflQtSeY/jKhOCTXbjngCCi86iZZVPcArfLWh+MuibD1k9RGeEKyUuYN8Y1eQhv2IdHeiijAIp1tCfk2AGVqz/mMonaE5qdKpUKWcKus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YdfEdx21; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737382850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I4rjvwRbHp/ejyDth9c4qQFSemdyjYcY3QB2/oRm5rI=;
	b=YdfEdx21we0u3mNcg2mjaLxJ3a/T1tndbjTnhr35jgTSvQvSlkgTfmaDrou22YeGnjzvBS
	gWjZaYnxG9eZwTVIw2DDS1akUVLahCbDfs+2OzTOFoGpi2lKMzdBL6uCZunvkW059LEYSx
	r9r3FAQxJCXWqbxyF1qy6QjjAZuwRf0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-u6KfRxp8MOuuJzFeS2ITog-1; Mon, 20 Jan 2025 09:20:49 -0500
X-MC-Unique: u6KfRxp8MOuuJzFeS2ITog-1
X-Mimecast-MFC-AGG-ID: u6KfRxp8MOuuJzFeS2ITog
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43619b135bcso23643725e9.1
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 06:20:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737382848; x=1737987648;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I4rjvwRbHp/ejyDth9c4qQFSemdyjYcY3QB2/oRm5rI=;
        b=RsJjKEPem+iE0lPWJmFm0IhRiWtM0BmSqtURZ9difd01nklgtwgIr2Uo+lHDNRmxZ1
         Tf32ZSvIiLoHD3ag9D3g+C971nH7mMVqV7fqhgcIPXSQ/RoycsHDbCf1XvML6cMnTOVO
         ZZTPY6A4Wt1pRIE+fLBGrL4kBmJTsVD5dhejY4Zy/UhAT9/r7MJiwM2HhpdULhvEMW26
         Ceg3d6/x4FAMMQ7nfJk1P2KNgxtXc6BpJ++wZg04c0Sh3HG/UcDVfnSK0y0A2Oduoj8o
         5nmiDpc3Rm01It9/hqpiL91C/aT7KU+QuDsYDIN99XXIcY6/rvxLS62xixgOb4zhoo7E
         MSMw==
X-Gm-Message-State: AOJu0Yw3qZ2XDidAv/escMOurMQG0xtS5p2siwjven6jNMwShWpnMyZr
	0WpfqsYwIN6XAMBtLM5dp8QDGWmnSiFwD+F03z6k9eirwzFnoogo919cbpos1YwKvC8iFs65tbK
	iswRJuCRdaDS+nXd0XjCVXiXbAebV0Le/yJM9UVUmbVOTO7EWuQ==
X-Gm-Gg: ASbGncuSf0s3SQ7dbLCZQ4EW1Ws685A9HvwCBF9f3bu+4wiKCia/hKJshWAaxwqzmUW
	eZVuqUIucGLcdGKzX9CQ3WczERCYPK+s91yChwRWyDay39WGr5EmZWyeYFQzmytsWMTXzV9/jPF
	CqylUtQYRC7N7Pj7six4kuP/Syb2Kd8vPkX1HBeupgsBVbgPGMY5ehefoGXY1XYNcocl6rqx+2W
	bxMT5+aPPov88adNw/pxtbS5dOhPSJ/JmElxecmZxPhsYOEKLUiyiIStZdOg/Zf
X-Received: by 2002:a05:600c:4e4f:b0:434:f767:68ea with SMTP id 5b1f17b1804b1-438913bf92cmr145256285e9.5.1737382847791;
        Mon, 20 Jan 2025 06:20:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF9/eXpkW1p7eS6BjFhNwAWx80Xw8+DRkZCUv8g1NkiVsgdzoJTpBZAB0S5w0R90ueiojf7Ig==
X-Received: by 2002:a05:600c:4e4f:b0:434:f767:68ea with SMTP id 5b1f17b1804b1-438913bf92cmr145255985e9.5.1737382847412;
        Mon, 20 Jan 2025 06:20:47 -0800 (PST)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43890462195sm140441565e9.30.2025.01.20.06.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2025 06:20:47 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Dongjie Zou
 <zoudongjie@huawei.com>
Subject: Re: [PATCH v2 4/4] KVM: selftests: Add CPUID tests for Hyper-V
 features that need in-kernel APIC
In-Reply-To: <20250118003454.2619573-5-seanjc@google.com>
References: <20250118003454.2619573-1-seanjc@google.com>
 <20250118003454.2619573-5-seanjc@google.com>
Date: Mon, 20 Jan 2025 15:20:46 +0100
Message-ID: <877c6p8t35.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

> Add testcases to x86's Hyper-V CPUID test to verify that KVM advertises
> support for features that require an in-kernel local APIC appropriately,
> i.e. that KVM hides support from the vCPU-scoped ioctl if the VM doesn't
> have an in-kernel local APIC.
>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> index 3188749ec6e1..8f26130dc30d 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> @@ -43,6 +43,7 @@ static bool smt_possible(void)
>  
>  static void test_hv_cpuid(struct kvm_vcpu *vcpu, bool evmcs_expected)
>  {
> +	const bool has_irqchip = !vcpu || vcpu->vm->has_irqchip;
>  	const struct kvm_cpuid2 *hv_cpuid_entries;
>  	int i;
>  	int nent_expected = 10;
> @@ -85,12 +86,19 @@ static void test_hv_cpuid(struct kvm_vcpu *vcpu, bool evmcs_expected)
>  				    entry->eax, evmcs_expected
>  				);
>  			break;
> +		case 0x40000003:
> +			TEST_ASSERT(has_irqchip || !(entry->edx & BIT(19)),
> +				    "Synthetic Timers should require in-kernel APIC");

Nitpick: BIT(19) of CPUID.0x40000003(EDX) advertises 'direct' mode
for Synthetic timers and that's what we have paired with
lapic_in_kernel() check. Thus, we may want to be a bit more specific and
say

"Direct Synthetic timers should require in-kernel APIC"
(personally, I'd prefer "Synthetic timers in 'direct' mode" name but
that's not how TLFS calls them)

or something similar. 

(feel free to address this small rant of mine upon commit or just ignore)

> +			break;
>  		case 0x40000004:
>  			test_val = entry->eax & (1UL << 18);
>  
>  			TEST_ASSERT(!!test_val == !smt_possible(),
>  				    "NoNonArchitecturalCoreSharing bit"
>  				    " doesn't reflect SMT setting");
> +
> +			TEST_ASSERT(has_irqchip || !(entry->eax & BIT(10)),
> +				    "Cluster IPI (i.e. SEND_IPI) should require in-kernel APIC");
>  			break;
>  		case 0x4000000A:
>  			TEST_ASSERT(entry->eax & (1UL << 19),
> @@ -145,9 +153,14 @@ int main(int argc, char *argv[])
>  
>  	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_CPUID));
>  
> -	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
> +	/* Test the vCPU ioctl without an in-kernel local APIC. */
> +	vm = vm_create_barebones();
> +	vcpu = __vm_vcpu_add(vm, 0);
> +	test_hv_cpuid(vcpu, false);
> +	kvm_vm_free(vm);
>  
>  	/* Test vCPU ioctl version */
> +	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
>  	test_hv_cpuid_e2big(vm, vcpu);
>  	test_hv_cpuid(vcpu, false);

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly


