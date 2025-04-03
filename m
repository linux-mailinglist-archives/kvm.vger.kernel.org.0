Return-Path: <kvm+bounces-42608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A499A7B017
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 23:08:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A851418818D3
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 21:04:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBBD425D556;
	Thu,  3 Apr 2025 20:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CohNH8fu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2675B25D546
	for <kvm@vger.kernel.org>; Thu,  3 Apr 2025 20:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743710986; cv=none; b=OYjk5GcNou1Ng83UDPtFenilQw1g46QsDYtS7aAPaYs2PYr18wkj2e+cOdQ63SpGLuMdCXGJadK542QcTPIGSIkULy4O2L95c6l8O2iKg9cWxfQne6RA9iWdZwH53cuwsBf5CO3qwsORVDyPC6FUKVV6+1/2vbMxwpF10InzPe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743710986; c=relaxed/simple;
	bh=KuAuPC2Kc5A2gf9Br08oeF8OB+Zc9OXztUj1fYLftnc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=n43TqmPNWm/STNM/zdyYBFDQ1CzUjREn/9c0UVfhgKnAv+aN/QzpVYYKwXAsQ8rfnQ7yyn2InQBDqD2ID8nOVlZ9a9Uyi7mEf9hxqgp+Z32DlFr1zW8rGJ9fVRw0d7aW1Y0EsAab7Y4weradAcMZ13olgUTkWwR/sLUX+hL4NuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CohNH8fu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743710984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o38mcyc5s3JRsdW3YB6YPHjbQdyEBV4D3I4i1S6k6to=;
	b=CohNH8fuakVW+EbFrBHvo1DCFS1RFLgyrHYzbK+Oy/45gI1N0bCkwD18gmQgLVxux0XFn+
	E33eMwLh/kvoYi+BwVU3J1cdSewYLEwApNY4C+3pqAWpd1R18yf+ogbaI/tOhVWIu2+TFx
	cfFJ1XpnMyJ0m0EtjlTNSb9HGSsm4Yw=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-224-WjcU5jb0Pm2CsyxiUwBM3g-1; Thu, 03 Apr 2025 16:09:42 -0400
X-MC-Unique: WjcU5jb0Pm2CsyxiUwBM3g-1
X-Mimecast-MFC-AGG-ID: WjcU5jb0Pm2CsyxiUwBM3g_1743710982
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7c543ab40d3so197367785a.2
        for <kvm@vger.kernel.org>; Thu, 03 Apr 2025 13:09:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743710982; x=1744315782;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o38mcyc5s3JRsdW3YB6YPHjbQdyEBV4D3I4i1S6k6to=;
        b=gh+NdWaIWc7dFM7YQPv2+JJr0CliA5dgl/rsQnPMkZqzBN00s5pjTlCfa7K74rKpMa
         tMf5L4trSFHqTiavhvD7Wb1GYbUIfugOriEGElYWL0WoUrHKzU9bLCWVqv84h7+IvO8t
         s2cN9rucfB6AgVJN5iaDHKgevJR3ivrecAyNQHhz//eAMJVjcWVwXfgNihP1cKS3oHhX
         c4wmahxl1MhV4SEfE3hSBzXykmZA7xo39rtz3jTXQwuk2eFK/ttHwg6z5t2FG8pNyk/W
         +Pzl2OaVpcn9LRYoZK46y4W5TGBOv4LO0FLQSTE3YdPx8rEFluYxVRXrXX2+ui8Iw8TO
         +sxw==
X-Forwarded-Encrypted: i=1; AJvYcCUXttELXOj4M+TIhaFy2XMQZAPu5CZXXoHe7ssInAqOPz7+z1JR+g0LLI0dWRkGz6gqlgw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPcYVwIB8S3acaAkHzPr/gToB6qgTRM3T1xL4clzhf/pZRbR6o
	YeTUegHrJEWIFcEY9y7PzNUDZWNb+bxHeuXQm26JF1bPMesgB3iSeQBnJKGCTNtUMhSI2vt7YSe
	jBPbwnkC3oGmSou7/ySzC3m2caMvbBtaqFHUTLg4CWcodEU/hOllfFic1kA==
X-Gm-Gg: ASbGncthuvPNc4hKNOtRX1ddzJcXn4E2xn6XinZHWaU5/h1eIl62n1angObU3GoKRi7
	gRMvr5eBkwxUhc5o1238e8ql3tgn2l9ecU4G3/ppGFf9dxA6fVBcnDJnzi1EbV5dzkWLCX0eMGm
	Ct9g6tvmz+ilOtjnFPnHllRIVxwC66N/7AYNXRbOpuMl/LhxCTxAN5tyxKoGy5WRLeha6Ijz4Yc
	c6/4AzSX0RkwzH5XYrrLoaaoegFpMABN502n3fBDECRKJHCoWGXn9cpWPi+93jn/gu7JzrNCXcH
	baChkmRi4aQLaCw=
X-Received: by 2002:a05:620a:4625:b0:7c5:4eee:53f8 with SMTP id af79cd13be357-7c774dad123mr90918285a.41.1743710981893;
        Thu, 03 Apr 2025 13:09:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGp7BcesIEd44ayqQbs+gVIFhGnWkPjIAyem/IbMBRBP4H6O6igve2fPOHCQZcgJGBgM1OgHw==
X-Received: by 2002:a05:620a:4625:b0:7c5:4eee:53f8 with SMTP id af79cd13be357-7c774dad123mr90915085a.41.1743710981558;
        Thu, 03 Apr 2025 13:09:41 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c76e96cf0esm116192785a.53.2025.04.03.13.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 13:09:41 -0700 (PDT)
Message-ID: <e255fa3ee192b136eeef7e9a63e8d1506d5e85a8.camel@redhat.com>
Subject: Re: [RFC PATCH 12/24] KVM: x86: hyper-v: Pass is_guest_mode to
 kvm_hv_vcpu_purge_flush_tlb()
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Sean Christopherson
 <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
 Vitaly Kuznetsov <vkuznets@redhat.com>, Rik van Riel <riel@surriel.com>,
 Tom Lendacky <thomas.lendacky@amd.com>,  x86@kernel.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 03 Apr 2025 16:09:40 -0400
In-Reply-To: <20250326193619.3714986-13-yosry.ahmed@linux.dev>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
	 <20250326193619.3714986-13-yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2025-03-26 at 19:36 +0000, Yosry Ahmed wrote:
> Instead of calling is_guest_mode() inside kvm_hv_vcpu_purge_flush_tlb()
> pass the value from the caller. Future changes will pass different
> values than is_guest_mode(vcpu).
> 
> No functional change intended.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/hyperv.h  | 8 +++++---
>  arch/x86/kvm/svm/svm.c | 2 +-
>  arch/x86/kvm/x86.c     | 2 +-
>  3 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
> index 913bfc96959cb..be715deaeb003 100644
> --- a/arch/x86/kvm/hyperv.h
> +++ b/arch/x86/kvm/hyperv.h
> @@ -203,14 +203,15 @@ static inline struct kvm_vcpu_hv_tlb_flush_fifo *kvm_hv_get_tlb_flush_fifo(struc
>  	return &hv_vcpu->tlb_flush_fifo[i];
>  }
>  
> -static inline void kvm_hv_vcpu_purge_flush_tlb(struct kvm_vcpu *vcpu)
> +static inline void kvm_hv_vcpu_purge_flush_tlb(struct kvm_vcpu *vcpu,
> +					       bool is_guest_mode)
>  {
>  	struct kvm_vcpu_hv_tlb_flush_fifo *tlb_flush_fifo;
>  
>  	if (!to_hv_vcpu(vcpu) || !kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu))
>  		return;
>  
> -	tlb_flush_fifo = kvm_hv_get_tlb_flush_fifo(vcpu, is_guest_mode(vcpu));
> +	tlb_flush_fifo = kvm_hv_get_tlb_flush_fifo(vcpu, is_guest_mode);
>  
>  	kfifo_reset_out(&tlb_flush_fifo->entries);
>  }
> @@ -285,7 +286,8 @@ static inline int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>  {
>  	return HV_STATUS_ACCESS_DENIED;
>  }
> -static inline void kvm_hv_vcpu_purge_flush_tlb(struct kvm_vcpu *vcpu) {}
> +static inline void kvm_hv_vcpu_purge_flush_tlb(struct kvm_vcpu *vcpu,
> +					       bool is_guest_mode) {}
>  static inline bool kvm_hv_synic_has_vector(struct kvm_vcpu *vcpu, int vector)
>  {
>  	return false;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index e664d8428c792..865c5ce4fa473 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4025,7 +4025,7 @@ static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu)
>  	 * A TLB flush for the current ASID flushes both "host" and "guest" TLB
>  	 * entries, and thus is a superset of Hyper-V's fine grained flushing.
>  	 */
> -	kvm_hv_vcpu_purge_flush_tlb(vcpu);
> +	kvm_hv_vcpu_purge_flush_tlb(vcpu, is_guest_mode(vcpu));
>  
>  	/*
>  	 * Flush only the current ASID even if the TLB flush was invoked via
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 182f18ebc62f3..469a8e5526902 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3615,7 +3615,7 @@ static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
>  	 * Flushing all "guest" TLB is always a superset of Hyper-V's fine
>  	 * grained flushing.
>  	 */
> -	kvm_hv_vcpu_purge_flush_tlb(vcpu);
> +	kvm_hv_vcpu_purge_flush_tlb(vcpu, is_guest_mode(vcpu));
>  }
>  
>  

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky




