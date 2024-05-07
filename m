Return-Path: <kvm+bounces-16939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C94948BF041
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 01:01:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 433121F236C7
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 23:01:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40463127E34;
	Tue,  7 May 2024 22:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uwhzibAd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00BBF80055
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 22:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715122679; cv=none; b=u8qwKvE6kwtiL29raUboHHMilHZ3ns9HTZt29kWCjJBe4p2w11LdLqccLhi6jhm+HMpcvFh4TbLBFw8OmRUjJzmq1WyMbtXQop4JS7tEVYQ88JOQkbqyS8U6nzYeXLXbcrkAH19SRZiJ5D/RkF5JuLbajyW6vD8fFBNCtmTgkcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715122679; c=relaxed/simple;
	bh=XyBcZnJlWUppCuQIMinKz47R/Vd3bwL8FhNo2NLewFs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Pxc0ZNiXCOuUGMgBbTCt91U1JWyEc62xPtf9LGXKaH8QPRbt5ny3QpLUbzGoF4vYnqExMWBbfpKSWL0spLZoTwAlfyrSLV0A1PJ2iEh5m4sh0tMkcjTql/NO4R2sw2rjYoW3IW23ToEGig2kkkCeJedAi+wJ8uHEDLRxXC7K6LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uwhzibAd; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc647f65573so8557838276.2
        for <kvm@vger.kernel.org>; Tue, 07 May 2024 15:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715122677; x=1715727477; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=If9Q7YXcI0jaMPx5yFMsDYt2AC8Km9g14o178fmmDSQ=;
        b=uwhzibAdk7SJF5PiZr80OlUUfdpQ2nyF8AQn4b1e5BjyH468Th+vQZKHdagrj83BWz
         weXeFRd5HFBXawGUiblHto7z1KcwSRQE0G3aWX6OJcFPrQMAgtifLfWtH9W4bIBA+9AP
         RMNd0OLclTwa10ulL+uXASm/jHT/i3vhfGSWT/uada+mqE15RpEIklE0HkYI/RWm+urK
         zroDzds6xwEueMtNwR+lbBO+8r4FtFOeq9W15V5MQronb3xg4P7eAFJWR1ckCGNV8x1Y
         mQvVX5DOtCsEtiwtWDT9POcGD8ULvTuypv5fNspbXoWJPLpqwoyzxhmmuywu2wKiz4UU
         CXKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715122677; x=1715727477;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=If9Q7YXcI0jaMPx5yFMsDYt2AC8Km9g14o178fmmDSQ=;
        b=UA5FJ8EKVYyhfLl/A4/98i8wetNueKs1gnuOOHS1k4ptM3GnGlI5zlx6khU7QlnRIk
         mSRuk86iSD/lswK/a5lFmwTCbtLSBk9W9AnNI9C0tyj2c4csRQHjBc4/hhdjqYF/SIV3
         +u2l2mjItXSGwrEedKb5Kb4sZVtp9gsOAsaUhVG5EG4jqw3aoRhMTT7bg0gvg+KSahkA
         rNJB1YmMkHIm8ZQfcLxfYhtXawKZR3LQdGo1kMBkkblYzNASS++jYx1zEIeq3/8jkOBk
         PNF93rDCllRHeGMk914AxyeFzIzDki14+dD4sNJ2JrbpSGKwxPdeEwRQDxSt0tmlEYfi
         PvHw==
X-Forwarded-Encrypted: i=1; AJvYcCUIVWbIOqPpPSpOtbVS2Qb1IA5bQujVrS3ZcJ6QYSJXki8NOgVH+qKnyj4VP4+QtoNaHVUbApXt8De7EE3U0+ZPnUA9
X-Gm-Message-State: AOJu0YyBiNzCPtEl+4r/g5P77PCRhUKCW8wD6yVylq4Z7DVjfQmdK6YD
	VHX/HpJ0XYMgwekMsQoOhSRexOSxpyJRuUMmQ/q1EswfF6OyKGOc/g9yonHVnVQmrOmmkjlN/1X
	hmQ==
X-Google-Smtp-Source: AGHT+IE4ZzQs5DeCns7tV3JfldxH2PjYiaee+lvyRphhL7PiqwnLOnIrfJmA1n2xRqrLX2r28xpQ5tHNpeg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:110e:b0:dc7:7ce9:fb4d with SMTP id
 3f1490d57ef6-debb9e6d93bmr281205276.12.1715122677033; Tue, 07 May 2024
 15:57:57 -0700 (PDT)
Date: Tue, 7 May 2024 15:57:55 -0700
In-Reply-To: <893ac578-baaf-4f4f-96ee-e012dfc073a8@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <20240219074733.122080-5-weijiang.yang@intel.com> <ZjKNxt1Sq71DI0K8@google.com>
 <893ac578-baaf-4f4f-96ee-e012dfc073a8@intel.com>
Message-ID: <Zjqx8-ZPyB--6Eys@google.com>
Subject: Re: [PATCH v10 04/27] x86/fpu/xstate: Introduce XFEATURE_MASK_KERNEL_DYNAMIC
 xfeature set
From: Sean Christopherson <seanjc@google.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org, 
	chao.gao@intel.com, rick.p.edgecombe@intel.com, mlevitsk@redhat.com, 
	john.allen@amd.com
Content-Type: text/plain; charset="us-ascii"

On Thu, May 02, 2024, Dave Hansen wrote:
> On 5/1/24 11:45, Sean Christopherson wrote:
> > On Sun, Feb 18, 2024, Yang Weijiang wrote:
> >> Define a new XFEATURE_MASK_KERNEL_DYNAMIC mask to specify the features
> > I still don't understand why this is being called DYNAMIC.  CET_SS isn't dynamic,
> > as KVM is _always_ allowed to save/restore CET_SS, i.e. whether or not KVM can
> > expose CET_SS to a guest is a static, boot-time decision.  Whether or not a guest
> > XSS actually enables CET_SS is "dynamic", but that's true of literally every
> > xfeature in XCR0 and XSS.
> > 
> > XFEATURE_MASK_XTILE_DATA is labeled as dynamic because userspace has to explicitly
> > request that XTILE_DATA be enabled, and thus whether or not KVM is allowed to
> > expose XTILE_DATA to the guest is a dynamic, runtime decision.
> > 
> > So IMO, the umbrella macro should be XFEATURE_MASK_KERNEL_GUEST_ONLY.
> 
> Here's how I got that naming.  First, "static" features are always
> there.  "Dynamic" features might or might not be there.  I was also much
> more focused on what's in the XSAVE buffer than on the enabling itself,
> which are _slightly_ different.

Ah, and CET_KERNEL will be '0' in XSTATE_BV for non-guest buffers, but '1' for
guest buffers.

> Then, it's a matter of whether the feature is user or supervisor.  The
> kernel might need new state for multiple reasons.  Think of LBR state as
> an example.  The kernel might want LBR state around for perf _or_ so it
> can be exposed to a guest.
> 
> I just didn't want to tie it to "GUEST" too much in case we have more of
> these things come along that get used for things unrelated to KVM.
> Obviously, at this point, we've only got one and KVM is the only user so
> the delta that I was worried about doesn't actually exist.
> 
> So I still prefer calling it "KERNEL" over "GUEST".  But I also don't
> feel strongly about it and I've said my peace.  I won't NAK it one way
> or the other.

I assume you mean "DYNAMIC" over "GUEST"?  I'm ok with DYNAMIC, reflecting the
impact on each buffer makes sense.

My one request would be to change the WARN in os_xsave() to fire on CET_KERNEL,
not KERNEL_DYNAMIC, because it's specifically CET_KERNEL that is guest-only.
Future dynamic xfeatures could be guest-only, but they could also be dynamic for
some completely different reason.  That was my other hang-up with "DYNAMIC";
as-is, os_xsave() implies that it really truly is GUEST_ONLY.

diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
index 83ebf1e1cbb4..2a1ff49ccfd5 100644
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -185,8 +185,7 @@ static inline void os_xsave(struct fpstate *fpstate)
        WARN_ON_FPU(!alternatives_patched);
        xfd_validate_state(fpstate, mask, false);
 
-       WARN_ON_FPU(!fpstate->is_guest &&
-                   (mask & XFEATURE_MASK_KERNEL_DYNAMIC));
+       WARN_ON_FPU(!fpstate->is_guest && (mask & XFEATURE_MASK_CET_KERNEL));
 
        XSTATE_XSAVE(&fpstate->regs.xsave, lmask, hmask, err);

