Return-Path: <kvm+bounces-42609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 75C71A7B01D
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 23:09:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C90D18925BD
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 21:04:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CA0D25D913;
	Thu,  3 Apr 2025 20:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UHVTOpGg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B3113B58A
	for <kvm@vger.kernel.org>; Thu,  3 Apr 2025 20:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743711022; cv=none; b=hwXE4+2q7TBJSgqFz88eGdeUAMEiw0xUt14M0C7lv2MzA8hWAgoGB2o4wF59pG6VQGWHI//zl/p++phFLoXhuTSZJ4LP8B7bKM49Rv7AJyofOvGfL61YK7XVsT/zLAIZvdP57a5zRIMXX1DVirRF9DtRwbTOBsPyNqw2L6HO6j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743711022; c=relaxed/simple;
	bh=ARHuqMUFBa6EBIqx3FjwFk0m9wzztwUMkSlCIakG680=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=l4eC/fwx/tbFfzZXlv1v8hDjqcXCqQc9v4RAqPg6brNXOmwz5v5kkuNje/Xo99RrntP9wKKruPC8Ff0KHddWwGF5/HfIGZ16Id1FtTqZ6AuHzJQyAcAdt3v252QjYHMPb65k9qQSC3SNOs7O0wP+kYPDMGrylQ2g+HnlNxMeOMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UHVTOpGg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743711020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0BwHIPwV3rI7qIkcJhhOaSvRbMhK1Ui6OQS4Co5poDA=;
	b=UHVTOpGg46R9zSYveCVLLD8H09N2mJadmQRtu4bylrDwPqxKsD8cbzdprDsJM9d2hb7HML
	cnemuLwcKapNYflNNoUVppcIFktgUriEr9z0vH8kk35FCR2SzndvyCjidreI8+n3gL7xr1
	kqQEH930qx/h8eUzhVRYFdGRQw+YqXM=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-HGhLjpF9MX-QWe8ozAOm_A-1; Thu, 03 Apr 2025 16:10:18 -0400
X-MC-Unique: HGhLjpF9MX-QWe8ozAOm_A-1
X-Mimecast-MFC-AGG-ID: HGhLjpF9MX-QWe8ozAOm_A_1743711017
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6e8feea216aso46139356d6.0
        for <kvm@vger.kernel.org>; Thu, 03 Apr 2025 13:10:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743711017; x=1744315817;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0BwHIPwV3rI7qIkcJhhOaSvRbMhK1Ui6OQS4Co5poDA=;
        b=e17Hw1s+XLkvjFmcMuCruzyxa0OxSD/RphpzRwG97df7DN3odeEdvBqg3zMNtvhupF
         Ov5mMDtTit2logYeugl3bC0uOP5ifVgYcRgMGDrh4CxnOk8s1YKQgCACp2yHNMtvvKdo
         1DQbO1GwZHwikZMjcpFCM820TpUogIbgV96EUQNqIgAOVyvKkhJXdlvkWFyMrppZbi+v
         RhqO51WwNVmYKLfLXrddm9D7nfWCHufxLE5/eaZW+j7+hTXLIbrMn6pAa6IiR83i6rkK
         DVGoE9r9OmXs8cqcVy8nej09qGmkUxUY9R1s0X2vsQIGkhKt2YObFIULZXhUUWh0nu4I
         wmJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJ0C2b8cagoqSUu/I/iiwvWvouZ/b+sdm3cAteePJi+tsWWMcwvaLDsYRCQgX7hW4UbjM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjQAahQ/d4RcYLqZoPvjNp3j9/oRuVYCLvThbDCDSe/y2NorTb
	ILaN0aKyj11LvB6YOb/o88rXMsRzt1xITE4JdMR0oVdp9xFeG2FIR6EKudksIBu1wsB4Fx7goCb
	JphV7+LbPO1ph/veyaOPvIDdT7yK8zKkHuVTCySmSv4muSLcQvA==
X-Gm-Gg: ASbGncsjDheetsCxMsvj8k75R4iab63Oqopzc3CbelousMzShkmvtQPqQgEMxCDNpds
	p7D11WCgli1m6gRBN1SYJPtmK3IBUc0XV8UEWTtmVCDRRePscFrDJLo3I1KSw6sbciLXN4m2onk
	OvzcGBq70gM5Xb5GQxljJKDhYRxNNI7Ul+dv1pZY2mnxlQ5U3wWeiWbBA1VcrBlDG0CBJ1qBSuP
	U+v8/vcLpuZtGOnOZLg1v9evdtvR5mvgm0eoxkVyV0PENOQvD98IJ5P2K8uyFGPuhSlCYI4flzv
	2vWHOC3/xTwXg/k=
X-Received: by 2002:ad4:5d63:0:b0:6e4:5317:64a0 with SMTP id 6a1803df08f44-6ef0bec79a6mr76325126d6.13.1743711017644;
        Thu, 03 Apr 2025 13:10:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH/Z3nXXtzkhi6L9ZJ/I+L1ALXbuENimr3h0WF6vMnmAXGGpI7ggBqt/YYh2/kFXiLPUaBJ0Q==
X-Received: by 2002:ad4:5d63:0:b0:6e4:5317:64a0 with SMTP id 6a1803df08f44-6ef0bec79a6mr76324756d6.13.1743711017338;
        Thu, 03 Apr 2025 13:10:17 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ef0f1393dcsm11339676d6.78.2025.04.03.13.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 13:10:17 -0700 (PDT)
Message-ID: <616df4f9191cb59af8776775ad2577e412c5f71d.camel@redhat.com>
Subject: Re: [RFC PATCH 15/24] KVM: x86/mmu: rename
 __kvm_mmu_invalidate_addr()
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Sean Christopherson
 <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
 Vitaly Kuznetsov <vkuznets@redhat.com>, Rik van Riel <riel@surriel.com>,
 Tom Lendacky <thomas.lendacky@amd.com>,  x86@kernel.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 03 Apr 2025 16:10:16 -0400
In-Reply-To: <20250326193619.3714986-16-yosry.ahmed@linux.dev>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
	 <20250326193619.3714986-16-yosry.ahmed@linux.dev>
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
> In preparation for creating another helper for
> kvm_mmu_invalidate_addr(), rename __kvm_mmu_invalidate_addr() to
> kvm_mmu_invalidate_addr_in_root().
> 
> No functional change intended.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/mmu/mmu.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 63bb77ee1bb16..4a72ada0a7585 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6317,8 +6317,9 @@ void kvm_mmu_print_sptes(struct kvm_vcpu *vcpu, gpa_t gpa, const char *msg)
>  }
>  EXPORT_SYMBOL_GPL(kvm_mmu_print_sptes);
>  
> -static void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> -				      u64 addr, hpa_t root_hpa)
> +static void kvm_mmu_invalidate_addr_in_root(struct kvm_vcpu *vcpu,
> +					    struct kvm_mmu *mmu,
> +					    u64 addr, hpa_t root_hpa)
>  {
>  	struct kvm_shadow_walk_iterator iterator;
>  
> @@ -6374,11 +6375,11 @@ void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  		return;
>  
>  	if (roots & KVM_MMU_ROOT_CURRENT)
> -		__kvm_mmu_invalidate_addr(vcpu, mmu, addr, mmu->root.hpa);
> +		kvm_mmu_invalidate_addr_in_root(vcpu, mmu, addr, mmu->root.hpa);
>  
>  	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
>  		if (roots & KVM_MMU_ROOT_PREVIOUS(i))
> -			__kvm_mmu_invalidate_addr(vcpu, mmu, addr, mmu->prev_roots[i].hpa);
> +			kvm_mmu_invalidate_addr_in_root(vcpu, mmu, addr, mmu->prev_roots[i].hpa);
>  	}
>  }
>  EXPORT_SYMBOL_GPL(kvm_mmu_invalidate_addr);

Reviewed-by: Maxim Levitsky<mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky




