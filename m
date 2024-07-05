Return-Path: <kvm+bounces-20973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 05F9F927F82
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 03:02:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A2F31F23DBB
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 01:02:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25F53BA55;
	Fri,  5 Jul 2024 01:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="McDe1RzI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDE520EB
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 01:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141354; cv=none; b=KhkmGqojXPxP+IdxLMepPGdA7/g86xLrGGisIBEy3WUedJmPm/K88l/oYJDkSKqyWo+d6tU8xv7a0vxjG9TIH4SpIVDReaibPmmPM9/4TPnQW4JBKr5FXgmDYzXwHLjQZTYN/4EXOehObEB4CsvabIQnbn5gZ8fA3KV43XHVZx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141354; c=relaxed/simple;
	bh=u+OreedE+cv2OOQQpEIpccyVi6bTidv2DN8CFSKQrQQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=muVskAQLNwl1mSe3q10fM5vt7dKKV/t3Fcf2k/Eoot90kZM623Gk+75oGOIZzhlrcXjoeL8JVAbI36EYlumdOAgb5Z9Xi057ntE1+WQqY+0O6p8mvkXkYQJWXkBCB4ra6SsnksgpsDWaYiWUZsQ25mNl4Kb1FygNUW7AFM9M6Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=McDe1RzI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720141351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AnQOH1i2dxeIS94y/P+FuIvUfVg8E1PY3fSZomFyKys=;
	b=McDe1RzIrVF7LqotFE/6WjguqRAJgrMTXjZ5CvqwdV0xVxfp948JKz8H3GB785ZBwPNGkn
	/XVfhXlK2Q4YmfG9YRR1oKjcuCm0m5x0Vb895VU7KrtIlzVUJMJRDHDpdCT0lodIgpK1qB
	i098Kk1Q+KRVSsXsR5N4lkwbIZ56bRw=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-14-ZNgN0OEUNy-UCkW5hI5fIA-1; Thu, 04 Jul 2024 21:02:29 -0400
X-MC-Unique: ZNgN0OEUNy-UCkW5hI5fIA-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-62d054b1ceeso18464837b3.2
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 18:02:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720141349; x=1720746149;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AnQOH1i2dxeIS94y/P+FuIvUfVg8E1PY3fSZomFyKys=;
        b=Sb8yHNwDjaYb3W3Oqf2PcRoOD3LHbc52a7NiL4CgsFi3HM1yIIgro0qOV/UGSA0uq2
         ZqUk04HY7eUG53rOdn56LrdOGgjtUIbUoejecSXnSm6pGVEMzMZAQ/gkXhYmV+1eeo7q
         J0a3GxAEn3Fna4ReuBg/H6+OVFKIjps0IRpZuMBZneK54zZw+NIncATtrGA3tWcKAa6o
         Vzgog9OHOzFp/tFYVzr8BP0N2CHvUFK7PFl3ZEYvsRrgRJXyVJvKxF/AP+LrtA6YwpbF
         oowxGC3o8vfANFDsC4gC2GhirnJsUujRM7prKBvTOiJPuuPvNAb462vVvUcFBetPrqR1
         SnYw==
X-Gm-Message-State: AOJu0Yx/xT1VU03lWw2PFwdPFkG7T4ib02k+OUsvbD8+X5tZY+qHW+ns
	uyF0nhd+YQicSW3JLiA4VlyusCd/OGdMjVIPFqEj5Ahe+AXP71xAscvPgR088avMdcCm6sRmpQc
	zSL0VNCfl73ArtvzssFfoi4Z6sNNEgA0hfzR9gmwLbxK+4sX8vQ==
X-Received: by 2002:a25:2d23:0:b0:df7:92ee:bb1a with SMTP id 3f1490d57ef6-e03c19e944fmr2976453276.52.1720141348988;
        Thu, 04 Jul 2024 18:02:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGrbfAekzI3MOusknwu71mva/b6c6qPU7NSu05V3zxTPZZqZ8I0OvFm2MdiajqS2WT/CvDOVw==
X-Received: by 2002:a25:2d23:0:b0:df7:92ee:bb1a with SMTP id 3f1490d57ef6-e03c19e944fmr2976438276.52.1720141348648;
        Thu, 04 Jul 2024 18:02:28 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b59e368439sm68982606d6.14.2024.07.04.18.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 18:02:28 -0700 (PDT)
Message-ID: <480aa33ffa8f4fcc1e85d36206447b19719e9e3f.camel@redhat.com>
Subject: Re: [PATCH v2 07/49] KVM: selftests: Verify KVM stuffs runtime
 CPUID OS bits on CR4 writes
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 21:02:27 -0400
In-Reply-To: <20240517173926.965351-8-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-8-seanjc@google.com>
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
> Extend x86's set sregs test to verify that KVM sets/clears OSXSAVE and
> OSKPKE according to CR4.XSAVE and CR4.PKE respectively.  For performance
> reasons, KVM is responsible for emulating the architectural behavior of
> the OS CPUID bits tracking CR4.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/x86_64/set_sregs_test.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/set_sregs_test.c b/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
> index 96fd690d479a..f4095a3d1278 100644
> --- a/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
> @@ -85,6 +85,16 @@ static void test_cr_bits(struct kvm_vcpu *vcpu, uint64_t cr4)
>  	rc = _vcpu_sregs_set(vcpu, &sregs);
>  	TEST_ASSERT(!rc, "Failed to set supported CR4 bits (0x%lx)", cr4);
>  
> +	TEST_ASSERT(!!(sregs.cr4 & X86_CR4_OSXSAVE) ==
> +		    (vcpu->cpuid && vcpu_cpuid_has(vcpu, X86_FEATURE_OSXSAVE)),
> +		    "KVM didn't %s OSXSAVE in CPUID as expected",
> +		    (sregs.cr4 & X86_CR4_OSXSAVE) ? "set" : "clear");
> +
> +	TEST_ASSERT(!!(sregs.cr4 & X86_CR4_PKE) ==
> +		    (vcpu->cpuid && vcpu_cpuid_has(vcpu, X86_FEATURE_OSPKE)),
> +		    "KVM didn't %s OSPKE in CPUID as expected",
> +		    (sregs.cr4 & X86_CR4_PKE) ? "set" : "clear");
> +

Hi,

Just for fun, why not to have a test function that toggles a CR4 bit and then
checks the corresponding CPUID bit toggles as well? This is both better
coverage wise and will remove the above code duplication.

Best regards,
	Maxim Levitsky


>  	vcpu_sregs_get(vcpu, &sregs);
>  	TEST_ASSERT(sregs.cr4 == cr4, "sregs.CR4 (0x%llx) != CR4 (0x%lx)",
>  		    sregs.cr4, cr4);



