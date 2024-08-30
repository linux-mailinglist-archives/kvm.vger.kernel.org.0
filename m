Return-Path: <kvm+bounces-25582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 72061966D04
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 01:55:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E81F1F2451A
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 23:55:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2AD618F2D3;
	Fri, 30 Aug 2024 23:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xmwx6/X2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A8A17B510
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 23:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725062100; cv=none; b=feAPgQvrKkrR2AxLJZa6UVS4XCR01qzVuTdoT5IbjZXks0hlFw++J/NZfj+YIrWIja3i6efl1BMofyhZh/fQTnEj8dcQpeGSJwNKQeGTEC+yd+6Wrtkuf10ZBBv4k08eOUxG22Oshuf6RvRbX4FDGUgcSMRtARu8U4QPUZONKj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725062100; c=relaxed/simple;
	bh=+EsYePFzMFNpF6erMIpOe0WO8D6FAuzs9/EQFCfVmyY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mAe3P5QcSgYfsSxqqLTDDF2k+EwipWMbct09qczkF7fgN6rpSIWgW4BCgxNw6eq1XD2DOeqY2ogrN2wJSICJSGXRJKjUcd/icrkadnaxyZYoWPKyoihyAwQfgM0rVi0R3teaZ/9pGGdjoS5pq9gToFbdMSBkoDqeRubzLLI1elE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xmwx6/X2; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6d4426ad833so20538817b3.2
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 16:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725062098; x=1725666898; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7mTp89YM4a+JZ2WxsvEPMQELbnbLphEGU34GUEc+1rE=;
        b=xmwx6/X2yBrCzqrYhCN4r8qk6lOACar88BdriaApdOFv2ph9Y3BW7wiPuFGriElTNx
         BqrWoVJ5zsgyioqD9XXTaRW4WEQgl5E3ogdiiGGapPjtBGhn/YO9U6h0h43lZWJASgte
         TqkGO4h3uibNslpkOAwfB9ma9lDgIQ8KtMqO0CODyfwRnUZab+b1JxVT88RspsabsFP9
         UGX6SwJuGFZ2m+qlU1Kp6CY4brEJDx6kNJTEXrNjaQ7ezNRmYRo6sd3Bs1oI7e804Ohn
         6eFk8/MZx0If0vWcpSe2ugEnE/OpJdzvcM1oXfnvWnEzwyKmjZBRt80tcF6aTQN8EUuJ
         /t3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725062098; x=1725666898;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7mTp89YM4a+JZ2WxsvEPMQELbnbLphEGU34GUEc+1rE=;
        b=GnARswlGP5aH01KhCDwvdkfwnSbuS0k/XJxJvsn9r6jLpg0NbFbSv09j+QyGw5HaVi
         CoCpoXi1mIKMI3yDlhjqKPRE3ZmIClvfBVC2yKSUW/auHWc2PeP0p7+IOFwxCHRLqXyD
         O+R4xJ993BgFDGG4xK7+MOQ9nHbzkGJ8kx3t6QBxJI8x0J6aHAEm7j0Tx7K2obDaVRW6
         CNUO8PzUXIoeX5DF9z/fpZ0xRslVfRNqRwEpZWwnv05fCwIFRbRKOB6v4LZi9cnXBaLm
         4bhaVAYR3+NLo/Inpz0JyuPE6DiqwlWBbRisfFxBUbGG4F58cQs1KWWTHSkdKEHTyZfx
         BfoA==
X-Gm-Message-State: AOJu0YwRVxfTxfkZrbZXoAjqCDTDHgcW2BJfYhBixTSeXjztV6TlDzbW
	xf+2qiKMWnaVdr61ktazlDk5D3VBnmIShy5VZwgZ9k96o2pryUfQc+H0VmmE4a0bJQGs83lbMDI
	QnQ==
X-Google-Smtp-Source: AGHT+IGwZxjO7ktsYm2v/oExs6JzBV3HAZ4YBOgUiAc3Zp4+M4L8o7WExR7rM/tO17TVCN5qdyaZadxEIjw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:dc07:0:b0:6b2:3ecc:817 with SMTP id
 00721157ae682-6d4118645a0mr107867b3.8.1725062098023; Fri, 30 Aug 2024
 16:54:58 -0700 (PDT)
Date: Fri, 30 Aug 2024 16:54:56 -0700
In-Reply-To: <Zr4P86YRZvefE95k@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809190319.1710470-1-seanjc@google.com> <20240809190319.1710470-23-seanjc@google.com>
 <5f8c0ca4-ae99-4d1c-8525-51c6f1096eaa@redhat.com> <Zr4P86YRZvefE95k@google.com>
Message-ID: <ZtJb0M8Y3dRVlSaj@google.com>
Subject: Re: [PATCH 22/22] KVM: x86/mmu: Detect if unprotect will do anything
 based on invalid_list
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Gonda <pgonda@google.com>, Michael Roth <michael.roth@amd.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerly Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 15, 2024, Sean Christopherson wrote:
> On Wed, Aug 14, 2024, Paolo Bonzini wrote:
> > On 8/9/24 21:03, Sean Christopherson wrote:
> > > Explicitly query the list of to-be-zapped shadow pages when checking to
> > > see if unprotecting a gfn for retry has succeeded, i.e. if KVM should
> > > retry the faulting instruction.
> > > 
> > > Add a comment to explain why the list needs to be checked before zapping,
> > > which is the primary motivation for this change.
> > > 
> > > No functional change intended.
> > > 
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >   arch/x86/kvm/mmu/mmu.c | 11 +++++++----
> > >   1 file changed, 7 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 300a47801685..50695eb2ee22 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -2731,12 +2731,15 @@ bool __kvm_mmu_unprotect_gfn_and_retry(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> > >   			goto out;
> > >   	}
> > > -	r = false;
> > >   	write_lock(&kvm->mmu_lock);
> > > -	for_each_gfn_valid_sp_with_gptes(kvm, sp, gpa_to_gfn(gpa)) {
> > > -		r = true;
> > > +	for_each_gfn_valid_sp_with_gptes(kvm, sp, gpa_to_gfn(gpa))
> > >   		kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
> > > -	}
> > > +
> > > +	/*
> > > +	 * Snapshot the result before zapping, as zapping will remove all list
> > > +	 * entries, i.e. checking the list later would yield a false negative.
> > > +	 */
> > 
> > Hmm, the comment is kinda overkill?  Maybe just
> > 
> > 	/* Return whether there were sptes to zap.  */
> > 	r = !list_empty(&invalid_test);
> 
> I would strongly prefer to keep the verbose comment.  I was "this" close to
> removing the local variable and checking list_empty() after the commit phase.
> If we made that goof, it would only show up at the worst time, i.e. when a guest
> triggers retry and gets stuck.  And the logical outcome of fixing such a bug
> would be to add a comment to prevent it from happening again, so I say just add
> the comment straightaway.
> 
> > I'm not sure about patch 21 - I like the simple kvm_mmu_unprotect_page()
> > function.
> 
> >From a code perspective, I kinda like having a separate helper too.  As you
> likely suspect given your below suggestion, KVM should never unprotect a gfn
> without retry protection, i.e. there should never be another caller, and I want
> to enforce that.

Oh, another argument for eliminating the separate helper is that having a separate
helper makes it really hard to write a comment for why reading indirect_shadow_pages
outside of mmu_lock is ok (it reads/looks weird if mmu_lock is taken in a different
helper).

