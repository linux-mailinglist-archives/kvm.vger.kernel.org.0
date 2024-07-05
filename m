Return-Path: <kvm+bounces-20980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BE65927FA3
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 03:18:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FAD61C2213F
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 01:18:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FF4314AA0;
	Fri,  5 Jul 2024 01:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DYQYo2Gb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E17479CE
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 01:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720142255; cv=none; b=vD+yR+5sJrue5a0/p8r7wjmcFMMPfMaYVbcfzx9ED5gVluVe8IIkEy5P6rsfZ+TKq0DvXo8a+iK/02aEf2DLLxEmV5z/aGTVKbazyxILbWsN46GYedcT8+iJ/inhNJZXxV4V82N8QBW2gEzUUJe2N0/mGwGYzJ4NRJ/c5LOFvzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720142255; c=relaxed/simple;
	bh=NyJgyRlBAEoSMEPPMIYFUyzmU1phXtkRstTCIkDHdlE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YHzh/aFi8d3SCKmOiCHavD24KvbPsxHtYyuV9BUdrwhq+jI6W9nO0SJvJZu0yYg5yvg+IAAPnnnpEfcSoX19sdoDouV5cFNJB+ED+s6aGo0i9PbVvysKcBwJAh4nWsAtejtOMwd7z4z4NlWnpK/9IkUj+kQZUZFO3xtlHtpgBkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DYQYo2Gb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720142253;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nbFCJLmi1kOokmQrYHjRd6cmp6875lN4UgTPLhI/iwI=;
	b=DYQYo2Gbib2nU2p09kDGyWDNtxQuyn3fxbqhHM9Z7twAOAwCa2mHhC8HbLuzB8pjNtkPDO
	daNQSNNfI8zAm7bsX5IzqLvKSwqzuHG/Fk1O17fA61r/Wdmlr+l5EufURZPv/9cZHiNg62
	H74TqIldXhBwu+IT+yby6hiVg8NJrs0=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-57-3l1WiyWVPb-e9AfkHeL3yg-1; Thu, 04 Jul 2024 21:17:31 -0400
X-MC-Unique: 3l1WiyWVPb-e9AfkHeL3yg-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-79d5d9b99b0so205280985a.1
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 18:17:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720142251; x=1720747051;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nbFCJLmi1kOokmQrYHjRd6cmp6875lN4UgTPLhI/iwI=;
        b=CWHqPfjXfGvhVxRLZuy1HljWtk5hGHd0cjNCA2az37FNhXlVptOhI3eTiH7PDkVz+4
         GsUBPi5crBzu9zQr5uelGNy1+Ps2GEtf39Lz8R6CeRYCl5y2xm/g6QHM+EB9BXbfc4g8
         RDg408RzbiJxgYQI3zzJpWu5GuZ1/oxJh86vZUyvkJMYiKe9bUC0x5rpoLIOWrkcd6oG
         EnD5OZ//cBAOPEVtHa7VltyvjVkEpjMZNnLFoAUGFqaRcXQJlzlDOnGwfSVzvUNS6eHY
         xEsB76EtAQck2nnwGsSILVMgZEVTwf05Rbhg2vFjZSrixROU3gXO6zlRfQYg3F1emiB2
         3oaA==
X-Gm-Message-State: AOJu0YwAvMBYuuMH9iRIqz5aRunuxnNZjFcnCZtCdjHJJ80MqHB0y02D
	JTyDoazX/qcqNii0BJvr7T6yPP4LP6PRsbRIMj47P3gmhf0gPfe++duRAljj0fdpqQhqfgBY+UH
	qdB3wAY0V7SCYUetrmGI4I+RqxHESm/YNJT4VeUndOIyInArDHg==
X-Received: by 2002:a05:620a:2089:b0:795:5570:8b30 with SMTP id af79cd13be357-79eef39d236mr410601985a.13.1720142250883;
        Thu, 04 Jul 2024 18:17:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFSjmtIkKmjYqqv68nWE8EsiwliqoHuytxQlZzMpfcqjgkuU8HG70oOOi+/VqByCFjRn7vD0g==
X-Received: by 2002:a05:620a:2089:b0:795:5570:8b30 with SMTP id af79cd13be357-79eef39d236mr410600285a.13.1720142250598;
        Thu, 04 Jul 2024 18:17:30 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79d69307c42sm722027985a.122.2024.07.04.18.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 18:17:30 -0700 (PDT)
Message-ID: <7a2ff05bfa3f9a2c9b71ac5fbfd75ef50f0bbf9e.camel@redhat.com>
Subject: Re: [PATCH v2 14/49] KVM: selftests: Update x86's KVM PV test to
 match KVM's disabling exits behavior
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 21:17:29 -0400
In-Reply-To: <20240517173926.965351-15-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-15-seanjc@google.com>
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
> Rework x86's KVM PV features test to align with KVM's new, fixed behavior
> of not allowing userspace to disable HLT-exiting after vCPUs have been
> created.  Rework the core testcase to disable HLT-exiting before creating
> a vCPU, and opportunistically modify keep the paired VM+vCPU creation to
> verify that KVM rejects KVM_CAP_X86_DISABLE_EXITS as expected.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/x86_64/kvm_pv_test.c        | 33 +++++++++++++++++--
>  1 file changed, 30 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
> index 2aee93108a54..1b805cbdb47b 100644
> --- a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
> @@ -139,6 +139,7 @@ static void test_pv_unhalt(void)
>  	struct kvm_vm *vm;
>  	struct kvm_cpuid_entry2 *ent;
>  	u32 kvm_sig_old;
> +	int r;
>  
>  	if (!(kvm_check_cap(KVM_CAP_X86_DISABLE_EXITS) & KVM_X86_DISABLE_EXITS_HLT))
>  		return;
> @@ -152,19 +153,45 @@ static void test_pv_unhalt(void)
>  	TEST_ASSERT(vcpu_cpuid_has(vcpu, X86_FEATURE_KVM_PV_UNHALT),
>  		    "Enabling X86_FEATURE_KVM_PV_UNHALT had no effect");
>  
> -	/* Make sure KVM clears vcpu->arch.kvm_cpuid */
> +	/* Verify KVM disallows disabling exits after vCPU creation. */
> +	r = __vm_enable_cap(vm, KVM_CAP_X86_DISABLE_EXITS, KVM_X86_DISABLE_EXITS_HLT);
> +	TEST_ASSERT(r && errno == EINVAL,
> +		    "Disabling exits after vCPU creation didn't fail as expected");
> +
> +	kvm_vm_free(vm);
> +
> +	/* Verify that KVM clear PV_UNHALT from guest CPUID. */
> +	vm = vm_create(1);
> +	vm_enable_cap(vm, KVM_CAP_X86_DISABLE_EXITS, KVM_X86_DISABLE_EXITS_HLT);
> +
> +	vcpu = vm_vcpu_add(vm, 0, NULL);
> +	TEST_ASSERT(!vcpu_cpuid_has(vcpu, X86_FEATURE_KVM_PV_UNHALT),
> +		    "vCPU created with PV_UNHALT set by default");
> +
> +	vcpu_set_cpuid_feature(vcpu, X86_FEATURE_KVM_PV_UNHALT);
> +	TEST_ASSERT(!vcpu_cpuid_has(vcpu, X86_FEATURE_KVM_PV_UNHALT),
> +		    "PV_UNHALT set in guest CPUID when HLT-exiting is disabled");
> +
> +	/*
> +	 * Clobber the KVM PV signature and verify KVM does NOT clear PV_UNHALT
> +	 * when KVM PV is not present, and DOES clear PV_UNHALT when switching
> +	 * back to the correct signature..
> +	 */
>  	ent = vcpu_get_cpuid_entry(vcpu, KVM_CPUID_SIGNATURE);
>  	kvm_sig_old = ent->ebx;
>  	ent->ebx = 0xdeadbeef;
>  	vcpu_set_cpuid(vcpu);
>  
> -	vm_enable_cap(vm, KVM_CAP_X86_DISABLE_EXITS, KVM_X86_DISABLE_EXITS_HLT);
> +	vcpu_set_cpuid_feature(vcpu, X86_FEATURE_KVM_PV_UNHALT);
> +	TEST_ASSERT(vcpu_cpuid_has(vcpu, X86_FEATURE_KVM_PV_UNHALT),
> +		    "PV_UNHALT cleared when using bogus KVM PV signature");
> +
>  	ent = vcpu_get_cpuid_entry(vcpu, KVM_CPUID_SIGNATURE);
>  	ent->ebx = kvm_sig_old;
>  	vcpu_set_cpuid(vcpu);
>  
>  	TEST_ASSERT(!vcpu_cpuid_has(vcpu, X86_FEATURE_KVM_PV_UNHALT),
> -		    "KVM_FEATURE_PV_UNHALT is set with KVM_CAP_X86_DISABLE_EXITS");
> +		    "PV_UNHALT set in guest CPUID when HLT-exiting is disabled");
>  
>  	/* FIXME: actually test KVM_FEATURE_PV_UNHALT feature */
>  

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


