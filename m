Return-Path: <kvm+bounces-39587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E5FCCA481D7
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 15:45:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7784C189AB3E
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 14:34:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FD8923645F;
	Thu, 27 Feb 2025 14:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QNZmdHDp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1BA2356CA
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 14:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740666827; cv=none; b=e4/7qrsRwKSZB9XEn1wvH8gTp+JWbncaB7XNxEMxkGI5ehAU1BvTpuwLodZoJH0xfIaS0g7Nnr+hZfoXH8lY3gn7u+DJQvk3jPUTy1nzpHchGi4IR9zZOnx2nNynFZHu0TBjDz11v829P6soKnKJE0PTqszwJdnbCUr4e5sYkAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740666827; c=relaxed/simple;
	bh=zWtqNmASXXzhNQSxrXA22fXpE03X8yWrh0pFugMTKS0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HWfE2e5lp4ypO4SsbesnwtHEsoH68ttqdhrpp+YMI7DE+KDsP8Bgjiyp4ttLaFKMkIm3j8lTs+8oLY0WnfdjRdZcyrgxLTS/WJxvQMWnM/POLzuooUsuImtMSCfkBWPZXFevSICKPR8ImReegtrLri6UdtmTVxXC3XnmJw4bkec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QNZmdHDp; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fe8c5dbdb0so2342892a91.3
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 06:33:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740666825; x=1741271625; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aM4IOWsMOsUKGOueBo8hs5YRr3VMSWUcLW0YRBjc3QQ=;
        b=QNZmdHDpZmCof3C6los9oJXYHWRFnLqjdC0Y0X/z99dzrlF6DeaBCPMXNEMoKGJnJx
         /qv3w25Ac3WjewLzYoB+DcQzaODQ+XNnSwjmNDWzLKxgtPNDZe21nNNelovKYVYVpGhk
         lar+jRWbJ7bWReytZpFKpEo+HUzzlwf6FWmZky0lXS0m71HqmEVWSZe1vi36q4Rh/17m
         OTKmpw8zN6sw2TEvtZsDxp4yEB0VkScjzQCALRqwkYchhUGOkVxaHmO79CY1VVj1eBLu
         Ac9BGt4VZZ/8doPIapYasxpP4Qhck4iW3tyz0pKhOY6G6rJJmf2Zd7hNBbSHXYSrCb2i
         8enQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740666825; x=1741271625;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aM4IOWsMOsUKGOueBo8hs5YRr3VMSWUcLW0YRBjc3QQ=;
        b=CBvUZCwrNfAsrfa+hSt9SdtqJP7bRm/G8zO0bLsCLQBlA5XMiCcMN8geNyFbH1T6yB
         7+uKNKtoTy2mCW7IWwsdV1VLmSvw6pOqYlEgHfh7tq4U/zroukNIONyCUPsNGCEiCkmp
         j8JRsFokPeYfwgw3gTHrKDgc9B0D7WlTDlaqi0BP3NiIZWhAt9kIarBJmQQ5wgYy/RNz
         wWhqGkabbap1wZWaBaGMAtw+YFQbPF2mGm6j1ZWVoUcyhuWCWnDnLk53PatwJkhdgbEu
         s8vPjJ9PVLgaT12aunOCn6HKYWaeHxb1S3dCZPcNeQyF9YBbXVtFlPaum8FqETZv4TjL
         LkSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWmE1w5TrdDGzAgBLcg67bs0C1NmJhc5najJPzCvWRcO73DvBhSZJwn8m/ZK5KXkBo13pA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz32RKpVKDF1qMFpKLHZNtk51im7yjpbBsWqOoHv/WfoLKcN8qA
	sqcamhW/++eqHWS8KHEwvm85+eDiNkpv/Pv8Nh2jlbErNRy+s8CAuCp2eiPeg0HWOpZjA/p87uJ
	QdA==
X-Google-Smtp-Source: AGHT+IFZ+eorGQKaIMnkNpp4Xl3k6BgEN9l2wHIf66/VZpDtmvSIB9msMN4tFIyCy4McBL5BVgjT+8kRCEo=
X-Received: from pjb16.prod.google.com ([2002:a17:90b:2f10:b0:2fa:1803:2f9f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:518b:b0:2ee:741c:e9f4
 with SMTP id 98e67ed59e1d1-2fe7e31f509mr12297010a91.11.1740666825142; Thu, 27
 Feb 2025 06:33:45 -0800 (PST)
Date: Thu, 27 Feb 2025 06:33:43 -0800
In-Reply-To: <4443bdf2-c8ea-4245-a23f-bb561c7e734e@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227012541.3234589-1-seanjc@google.com> <20250227012541.3234589-6-seanjc@google.com>
 <4443bdf2-c8ea-4245-a23f-bb561c7e734e@amd.com>
Message-ID: <Z8B3x7EPYY8j8o7F@google.com>
Subject: Re: [PATCH v2 05/10] KVM: SVM: Require AP's "requested" SEV_FEATURES
 to match KVM's view
From: Sean Christopherson <seanjc@google.com>
To: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Alexey Kardashevskiy <aik@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 27, 2025, Pankaj Gupta wrote:
> On 2/27/2025 2:25 AM, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 9aad0dae3a80..bad5834ec143 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -3932,6 +3932,7 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
> >   static int sev_snp_ap_creation(struct vcpu_svm *svm)
> >   {
> > +	struct kvm_sev_info *sev = to_kvm_sev_info(svm->vcpu.kvm);
> >   	struct kvm_vcpu *vcpu = &svm->vcpu;
> >   	struct kvm_vcpu *target_vcpu;
> >   	struct vcpu_svm *target_svm;
> > @@ -3963,26 +3964,18 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
> >   	mutex_lock(&target_svm->sev_es.snp_vmsa_mutex);
> > -	/* Interrupt injection mode shouldn't change for AP creation */
> > -	if (request < SVM_VMGEXIT_AP_DESTROY) {
> > -		u64 sev_features;
> > -
> > -		sev_features = vcpu->arch.regs[VCPU_REGS_RAX];
> > -		sev_features ^= to_kvm_sev_info(svm->vcpu.kvm)->vmsa_features;
> > -
> > -		if (sev_features & SVM_SEV_FEAT_INT_INJ_MODES) {
> 
> 'SVM_SEV_FEAT_INT_INJ_MODES' would even be required in any future use-case,
> maybe?

Can you elaborate?  I don't quite follow what you're suggesting.

