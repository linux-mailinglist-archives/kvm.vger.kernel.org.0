Return-Path: <kvm+bounces-42610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 07823A7AFF7
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 23:05:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 25A4F7A793D
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 21:03:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 955B925DAFD;
	Thu,  3 Apr 2025 20:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CSdi6Hzr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3F12550B0
	for <kvm@vger.kernel.org>; Thu,  3 Apr 2025 20:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743711029; cv=none; b=f4QdtkZNU5q2urP3fBrJPqwUNFAPzlNkQX7w18+5HlW5Irm8rKFeZv35LmtK2VhNwkECcIm2PXXyXKjPS83RV8VVH6yxXqdRjElZyDgVIibKhMaF7u2IUsIM9h90z7VSteQ1fpUt294go17srymHAdG3RYy0kHXpRQZiz6Vx6y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743711029; c=relaxed/simple;
	bh=D26HNSNydq0vhTezmBXrbOpJ4YYH6UhhcDMgeoQd/tE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kcaFcV4q52r6tANWhRGa+pj0CdvLSuEHvppYxlygaW87+IjGXez1YunzS7Cx5kYHbC2a3YjuA+PscR/mN0e/MH0WDm6UFmS8AvNs1MYJ+Y1EMrSeFwXvoNWYuhLlyX9cOf6e3sYBtMabsIdR5PoWNiJorKg13F+K+oxUmg25uxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CSdi6Hzr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743711027;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s5hUYLT5Mkdx8Zf+eFJbT1CNzreTFwCPqVChesRtvo8=;
	b=CSdi6Hzr9K1i+lILJKZ2HvNO9xNMOzT3NSvNe+PijQc8cbxNGdgtuz+axWCwEUDFK8j82B
	OPvTye8wqmjnkmo/w2047XAaoyu42yATLiEhXB0/l817OaMGg751pWCk8hO8oAlONGKtIQ
	mAEpHiGBlfZYzTu075JQ3BKRAzRMP2M=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-290--jNjbq1vNCy4PSmwYP-qtQ-1; Thu, 03 Apr 2025 16:10:25 -0400
X-MC-Unique: -jNjbq1vNCy4PSmwYP-qtQ-1
X-Mimecast-MFC-AGG-ID: -jNjbq1vNCy4PSmwYP-qtQ_1743711025
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4769a1db721so33089881cf.3
        for <kvm@vger.kernel.org>; Thu, 03 Apr 2025 13:10:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743711025; x=1744315825;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s5hUYLT5Mkdx8Zf+eFJbT1CNzreTFwCPqVChesRtvo8=;
        b=LhMYIfeLjoG2WPpruMp++jcHTTprDVAWYo0xDvw3JPzklcqUx6c6yypQntMUmRZ68O
         T/YS4OShR0lNCUgkhKIIDnx+dK8kiAoRzJYH5tKmHDoLQRBi5jXNxHhq8IbqCaZYs84L
         t4YqEGr49YhKkD4XbIzmCcddBi6NImSEvTO6qvqQ1UcnNt/TTRJuUimpC8wa5SguDZJ+
         2Giu0DxqyYoJbvnAgNzcGZFAwTtyKdliUsbia2JDwVLM62673SQUX9+2bxLPLXxXKYem
         mpPwpm7QiJAKxEthO2EKwQdAjkfOUbNYF5jxx0gg3VUIAHy2ykIC4b/g1C6GpaS+hPw9
         UK6w==
X-Forwarded-Encrypted: i=1; AJvYcCXvhiRIpa8QUS76yykj3QBB3s/PcK9Nq2Oi5MHWtjPEhrsBsAxjog8Q9Z/pqpYUcrJNqxs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDAIyVOFBZAf9I0Dn7Acl+M/6UTA+q9OsPx/yhZl8bR/iqAJ5z
	ZUIQIl0CHKUdbONYEKjt5NH7riemNbgyzZEiCardZzgM+T9gkmmvy4v/auCD5Ii9Onjst6+0Ogc
	g0SWg84zV3dU/4Gq2Jvmj+i0jGD1Ue4cfK8KjaDUexOLBt3MObg==
X-Gm-Gg: ASbGncsxQ9ECB3npYTEm4bNb/NO8qxso/RaYSYIRUC93ytTwnINZJVwiHpW2xFVkCKY
	ubCwG4QI4O8zskcWWNVWij1jk2JGuPiyp21PIx3H3r2IhXqmZ0crN0Y64OkF+D28ClYc76QjbX2
	rp6URRqK4VJXik+Y9yF++ve863EfjNwUsJVSbklThwouAV1Ef5SF1pxcue+ANC5soyaf+V0sVju
	0WxPh9Vn1BtdP+sN1hGp6G1VHj9KiHSvFynNV73/mSJUd5wh0MgJSJt4HJwOfIq9ZdaW4LdF4AS
	o8TkNqYxUHY4fNE=
X-Received: by 2002:a05:622a:191e:b0:476:95dd:521c with SMTP id d75a77b69052e-479249d5bf8mr10465951cf.45.1743711025463;
        Thu, 03 Apr 2025 13:10:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHzJVWMoaVpWh2K232paPphG0v1QG/Q2e884aySDX7gMKjgXUK3/eB6I/ba2r9ahGTGP6zSsA==
X-Received: by 2002:a05:622a:191e:b0:476:95dd:521c with SMTP id d75a77b69052e-479249d5bf8mr10465651cf.45.1743711025204;
        Thu, 03 Apr 2025 13:10:25 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4791b121970sm11540121cf.50.2025.04.03.13.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 13:10:24 -0700 (PDT)
Message-ID: <032981892a2ed9ff596ded9b5945342894fdb9ba.camel@redhat.com>
Subject: Re: [RFC PATCH 16/24] KVM: x86/mmu: Allow skipping the gva flush in
 kvm_mmu_invalidate_addr()
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Sean Christopherson
 <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
 Vitaly Kuznetsov <vkuznets@redhat.com>, Rik van Riel <riel@surriel.com>,
 Tom Lendacky <thomas.lendacky@amd.com>,  x86@kernel.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 03 Apr 2025 16:10:23 -0400
In-Reply-To: <20250326193619.3714986-17-yosry.ahmed@linux.dev>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
	 <20250326193619.3714986-17-yosry.ahmed@linux.dev>
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
> Refactor a helper out of kvm_mmu_invalidate_addr() that allows skipping
> the gva flush. This will be used when an invalidation is needed but the
> GVA TLB translations that require invalidation are not of the current
> context (e.g. when emulating INVLPGA for L1 to flush L2's translations).
> 
> No functional change intended.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/mmu/mmu.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 4a72ada0a7585..e2b1994f12753 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6355,15 +6355,15 @@ static void kvm_mmu_invalidate_addr_in_root(struct kvm_vcpu *vcpu,
>  	write_unlock(&vcpu->kvm->mmu_lock);
>  }
>  
> -void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> -			     u64 addr, unsigned long roots)
> +static void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> +				      u64 addr, unsigned long roots, bool gva_flush)
>  {
>  	int i;
>  
>  	WARN_ON_ONCE(roots & ~KVM_MMU_ROOTS_ALL);
>  
>  	/* It's actually a GPA for vcpu->arch.guest_mmu.  */
> -	if (mmu != &vcpu->arch.guest_mmu) {
> +	if (gva_flush && mmu != &vcpu->arch.guest_mmu) {
>  		/* INVLPG on a non-canonical address is a NOP according to the SDM.  */
>  		if (is_noncanonical_invlpg_address(addr, vcpu))
>  			return;
> @@ -6382,6 +6382,12 @@ void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  			kvm_mmu_invalidate_addr_in_root(vcpu, mmu, addr, mmu->prev_roots[i].hpa);
>  	}
>  }
> +
> +void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> +			     u64 addr, unsigned long roots)
> +{
> +	__kvm_mmu_invalidate_addr(vcpu, mmu, addr, roots, true);
> +}
>  EXPORT_SYMBOL_GPL(kvm_mmu_invalidate_addr);
>  
>  void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva)

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky




