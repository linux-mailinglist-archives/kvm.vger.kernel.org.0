Return-Path: <kvm+bounces-67457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E16FD05B88
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 20:04:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DD6DB300981A
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 18:58:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 728D532572F;
	Thu,  8 Jan 2026 18:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TPY9+YSh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8540328256
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 18:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767898725; cv=none; b=tvRNGmPbOn89lDlBx/hgmcwZ6Sgh2EcL+UAa/BWhnTf4z078zS1mLQW0faY/coY9PWS2US604NpajXyZErYiTarqNtAZe4Ruc6BTq/C+sptyvi2KFT+UJ8bvnFB0Lr1HiMfDEyqOda3J5j0F2WCD7JubEcNEcfvwK9KMYVOXSrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767898725; c=relaxed/simple;
	bh=w5f2PEgTs0BBLv9c9FM2NNv1zeik3LXcK5KkbJ2+x0Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sJ9QncblQIZwrwQRFbvU+RJotxvVTJTEcWpg9oiqScKc15MpNbEBbtnwqACr8cvu7tPN85hdeNp64t3UB2zdbepY6udecBk0Zlw9iKjpDWrbNwLf3K4pQRpuQn+fgPXuGu5XmIBtWLaiMUj/+F7SPc2Vu1i0k1LKgxj6R4ZcZjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TPY9+YSh; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a090819ed1so25735645ad.2
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 10:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767898722; x=1768503522; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ypsK1rGG2ABw2BBL2zqC+68joUlmGkI7LLGq70eowD8=;
        b=TPY9+YShiwsWKaGEV2v7viBQmflrk4KBaOGSPOSxUyav4TvxJPhZKtDLoZmWSmyUqI
         6GpM3fDyavdAfDsWDawriqCL1d9Of61pk+zFKOX5BMEIYucxWFslxr37InFr95tp7lNx
         0rSR7LyGc7vXN5GG2HL1Nxpy8EZRJTCuoKTCgQKuhQrQAEuL0gsXN+1hdODwcfgFF3y9
         rC9/2f/kd+bA/cm7vXXPak+spKpk3BQMezUlENY1y6LJpbUrLSDDGuLm9LgC1uB3eSpM
         GJh5pfPh8331xE+M9NepeTI/tPHQp2cpZL5I9scyh42EXK7Lpzbh/0sveS8ANQDBgWq2
         f4Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767898722; x=1768503522;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ypsK1rGG2ABw2BBL2zqC+68joUlmGkI7LLGq70eowD8=;
        b=mXpH2WWhCTY1cYosYMvVD6HKzSzH+UQdZUnfdU1GuO+YHX0j7GU6Dk1owd0b2FVy1R
         m8MYPivavloVOMhQV1NUpS1lAFWCH8imIcEa3ft930uh5YHBG0bpiE4a2BXHVtT6OtFf
         rrMA9Jm9lL9mJ8UpjcuN+mBg2iH9ZYZPnTJ0wQpot6kKJXa0XRJ0+1HM3NegF7xSFkB9
         iB9IYGJXd7HUiaz12MbOdbxg4ijLFFY2o6MLUf416uOTBFAimxOgVKuQdM8Ilxvzwrdg
         sjA8ga/rVlznd3lcv2v0H2TW0ynmwl1Ngp7dNFXv03aNupWXyv7NyVkOSNPuJeCQMfwM
         43qg==
X-Forwarded-Encrypted: i=1; AJvYcCULvbNM7DV0qZSm9lUFj0cXVft/HruUKsWLenzoCnED2a99Y86Llfk2QdDvb8nxOPYLhj0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOsYQnC6v2JeLEcvijuN/1xFxr/mNVo7SNJPoXZu5nJnVM2O4I
	/8vnYaRxB9rW/MClxNC0Tx18k+rLalRIyTutkmzXBIESo6clbW6MoZ5h393sxU8bFH+HgaQwm+G
	X7b13QQ==
X-Google-Smtp-Source: AGHT+IHcj9+yiUqOxzZRi7EfayWO5WMSQAE/YG4SEvKNM7JAUjZ2IzYBjVUP0qUXkmPw+uiul3QFtKg4pw8=
X-Received: from pjqf5.prod.google.com ([2002:a17:90a:a785:b0:34c:cc12:1613])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:264a:b0:341:3ea2:b625
 with SMTP id 98e67ed59e1d1-34f68b661eamr7710714a91.12.1767898722034; Thu, 08
 Jan 2026 10:58:42 -0800 (PST)
Date: Thu, 8 Jan 2026 10:58:40 -0800
In-Reply-To: <20251121204803.991707-2-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251121204803.991707-1-yosry.ahmed@linux.dev> <20251121204803.991707-2-yosry.ahmed@linux.dev>
Message-ID: <aV_-YLO4AVQc-ZmY@google.com>
Subject: Re: [PATCH v3 1/4] KVM: SVM: Allow KVM_SET_NESTED_STATE to clear GIF
 when SVME==0
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 21, 2025, Yosry Ahmed wrote:
> From: Jim Mattson <jmattson@google.com>
> 
> GIF==0 together with EFER.SVME==0 is a valid architectural
> state. Don't return -EINVAL for KVM_SET_NESTED_STATE when this
> combination is specified.
> 
> Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/nested.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index c81005b24522..3e4bd8d69788 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1784,8 +1784,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  	 * EFER.SVME, but EFER.SVME still has to be 1 for VMRUN to succeed.
>  	 */
>  	if (!(vcpu->arch.efer & EFER_SVME)) {
> -		/* GIF=1 and no guest mode are required if SVME=0.  */
> -		if (kvm_state->flags != KVM_STATE_NESTED_GIF_SET)
> +		/* GUEST_MODE must be clear when SVME==0 */
> +		if (kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE)

Hmm, this is technically wrong, as it will allow KVM_STATE_NESTED_RUN_PENDING.
Now, arguably KVM already has a flaw there as KVM allows KVM_STATE_NESTED_RUN_PENDING
without KVM_STATE_NESTED_GUEST_MODE for SVME=1, but I'd prefer not to make the
hole bigger.

The nested if-statement is also unnecessary.

How about this instead?  (not yet tested)

	/*
	 * If in guest mode, vcpu->arch.efer actually refers to the L2 guest's
	 * EFER.SVME, but EFER.SVME still has to be 1 for VMRUN to succeed.
	 * If SVME is disabled, the only valid states are "none" and GIF=1
	 * (clearing SVME does NOT set GIF, i.e. GIF=0 is allowed).
	 */
	if (!(vcpu->arch.efer & EFER_SVME) && kvm_state->flags &&
	    kvm_state->flags != KVM_STATE_NESTED_GIF_SET)
		return -EINVAL;

