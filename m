Return-Path: <kvm+bounces-24655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3494D958BFB
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 18:12:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5A39282CBF
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 16:12:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0076119D8BB;
	Tue, 20 Aug 2024 16:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mBg+uRVy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4387191F89
	for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 16:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724170327; cv=none; b=BvEGldI63Q9P8bICTeXPLZ4ZJ1tm9NQzGZfbkbsk6AL6TWn23mS4OBccOyYKlmZqcZw8MyPImm2gLVl9WiOGGR6VSS2Z7Nqynww565zTE87MC52iO3EmmpskXjeVf23Kr+mqqNtPjUVvO8uBie/z3WV2r1Sz2a4OrFqJfKX5kkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724170327; c=relaxed/simple;
	bh=xDYkri/7jTuLqwePZwxb6rBZv38bm+WMZP8lwIWYY8s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dpWVCVYJmexnF9zwutVobmPQcu2NblaTqlZM3hvg6L3/FX4XNQX6cpy9qMHX5fe+77SL3Y4s26alUrKBF6Ww2p37u3xUTaCIOPzFO7yv0D1StRu/B5qrEKwP48LJuphp8WMI2DFPG2us/F0hrFBIW0dXeB+ydZcUIjd8c5zrRWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mBg+uRVy; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2cfe9270d4aso5857923a91.0
        for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 09:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724170325; x=1724775125; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mEGfKffA8k25KTN9hjG+1Czg335p9pzfLGZ0r6ISLdQ=;
        b=mBg+uRVyqPeElGh77Iqe9cz67W4mQjw0AFerd88COpMU1gyyoq4g12at6w60i+UqWs
         cNi9v6iRfB6glHI+k6QiZ4CWWolH0hLnZRQfkGpJXl/ztpm6ej9M0mz/9y43zkXs+E7l
         SwUccIFrnWCy79pn8IEPTwWtHsmclg64xxLWVosrajvbqwmERbCE134drFugeRHN8h4l
         uGGg3Y5yt21hdKP0nhUprnZ9Gp52T3xJDs27eeLVP8clXPilfQ40WtbsHAKOXsyjsZ1U
         jBXkWylTMzSksOamcPXwIGWvI/cv15B2HKekHJsul7xTjf6iVXVmpndYUbxJ0dhSvzwe
         ri6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724170325; x=1724775125;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mEGfKffA8k25KTN9hjG+1Czg335p9pzfLGZ0r6ISLdQ=;
        b=DtkmcSee6U/awkhuDSr4OGSsU20pIZMm2r5o//wFyYBrgjTIAV4Wl4AnY6snRpabKM
         3ZaPdt9OwtHXsE1zrgMFTqdXNhrhPitSyTFwb3VnuMUF0t9AGYvwuAKq+T9ekPksE6pl
         fSp82oiVnnmkyp3qgep7FxNLdyuCsI5URsaNg9J/gFYmXijlP8pwlIuvp5W9TRnj5Dvx
         SB0EFOsLTTkvKy6/sWXMki8Nl5OkIuu65062f5h2Ct9GvgovgI/a8XEuxNQxaNG/TRwA
         PKgg5fqDbGb2O66GbX252NUZgJNACPVKmjwPBnjzjVd3VrwTECznE+V++bNjbEs+8bO+
         qwZQ==
X-Gm-Message-State: AOJu0YwjQpfaRzdTyBTSSLhsAWPX+RKWVnq0+X9wPEuo+DtfawRWwak/
	K2+VsxRadkLccCFFtRtoQwL1kDH1ag8qLjjiOJmj6l2LIufnr0ndmRWsAB5GDzvsF7elngyn2si
	wgw==
X-Google-Smtp-Source: AGHT+IEAAN2Y0yVXFnGWS3O1jcL8IhFceJXuAl87lXtczud4Q3G1ILQCVLF2/rPx9IRrrraoAPdNb64AF1I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:1bcf:b0:2c8:b576:2822 with SMTP id
 98e67ed59e1d1-2d3e03e698dmr110268a91.8.1724170324996; Tue, 20 Aug 2024
 09:12:04 -0700 (PDT)
Date: Tue, 20 Aug 2024 09:12:03 -0700
In-Reply-To: <c603c0c3-36cb-4429-9799-ed50bba4a59e@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802015732.3192877-1-kim.phillips@amd.com>
 <20240802015732.3192877-3-kim.phillips@amd.com> <Zr_ZwLsqqOTlxGl2@google.com>
 <7208a5ac-282c-4ff5-9df2-87af6bcbcc8a@amd.com> <ZsPF7FYl3xYwpJiZ@google.com> <c603c0c3-36cb-4429-9799-ed50bba4a59e@amd.com>
Message-ID: <ZsTAU2hVyI-4WDK3@google.com>
Subject: Re: [PATCH 2/2] KVM: SEV: Configure "ALLOWED_SEV_FEATURES" VMCB Field
From: Sean Christopherson <seanjc@google.com>
To: Kim Phillips <kim.phillips@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Nikunj A Dadhania <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Kishon Vijay Abraham I <kvijayab@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 20, 2024, Kim Phillips wrote:
> On 8/19/24 5:23 PM, Sean Christopherson wrote:
> > On Mon, Aug 19, 2024, Kim Phillips wrote:
> > > but since commit ac5c48027bac ("KVM: SEV: publish supported VMSA features"),
> > > userspace can retrieve sev_supported_vmsa_features via an ioctl.
> > > 
> > > > And based on this blurb:
> > > > 
> > > >     Some SEV features can only be used if the Allowed SEV Features Mask is enabled,
> > > >     and the mask is configured to permit the corresponding feature. If the Allowed
> > > >     SEV Features Mask is not enabled, these features are not available (see SEV_FEATURES
> > > >     in Appendix B, Table B-4).
> > > > 
> > > > and the appendix, this only applies to PmcVirtualization and SecureAvic.  Adding
> > > > that info in the changelog would be *very* helpful.
> > > 
> > > Ok, how about adding:
> > > 
> > > "The PmcVirtualization and SecureAvic features explicitly require
> > > ALLOWED_SEV_FEATURES to enable them before they can be used."
> > > 
> > > > And I see that SVM_SEV_FEAT_DEBUG_SWAP, a.k.a. DebugVirtualization, is a guest
> > > > controlled feature and doesn't honor ALLOWED_SEV_FEATURES.  Doesn't that mean
> > > > sev_vcpu_has_debug_swap() is broken, i.e. that KVM must assume the guest can
> > > > DebugVirtualization on and off at will?  Or am I missing something?
> > > 
> > > My understanding is that users control KVM's DEBUG_SWAP setting
> > > with a module parameter since commit 4dd5ecacb9a4 ("KVM: SEV: allow
> > > SEV-ES DebugSwap again").  If the module parameter is not set, with
> > > this patch, VMRUN will fail since the host doesn't allow DEBUG_SWAP.
> > 
> > But that's just KVM's view of vmsa_features.  With SNP's wonderful
> > SVM_VMGEXIT_AP_CREATE, can't the guest create a VMSA with whatever sev_features
> > it wants, so long as they aren't host-controllable, i.e. aren't PmcVirtualization
> > or SecureAvic?
> 
> No, as above, if the guest tries any silly business the host will
> get a VMEXIT_INVALID, no matter if using the feature *requires*
> ALLOWED_SEV_FEATURES to be enabled and explicitly allow it (currently
> PmcVirtualization or SecureAvic).

Oooh, I finally get it.  PmcVirtualization and SecureAvic require an opt-in via
ALLOWED_SEV_FEATURES, i.e. are off-by-default, whereas all other features are
effectively on-by-default, but still honor ALLOWED_SEV_FEATURES.

