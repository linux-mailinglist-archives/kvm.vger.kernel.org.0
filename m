Return-Path: <kvm+bounces-13506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C45F897BBD
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 00:43:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B79ECB26A3A
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 22:43:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E9DC156871;
	Wed,  3 Apr 2024 22:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1yFVmDks"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC33B692FC
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 22:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712184171; cv=none; b=sQRFTisuBhxwTurjIyup2Uwx5NCjNbQXNExI7Cs2VQ3UWP4SKcfUKWISewrPQrw4RX9/RpyJj3+jpVC/gpnIOLWwPhs4nNZfeBUIE13E6UnabUp8X2vGlFlUiJaAa7oWGMZqqVU61RGxZ/a6gDHeNjwOgLTgkm/2Ct6CVTIM2Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712184171; c=relaxed/simple;
	bh=rz+PvBK3Tkf1uBvQQhw3KfI5Oam7TgqAW+rcHV7DZBA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JezbFN4XTvG0ZHheCUi8kUJ5TNHOiwdr4jK0NBnFCWpW9w8TQ7JqH+yEV2V5Wz3eV/SguYaPbhKqiWN9Ox/UtPx3Cm4EbkNl64FHCOOxoQ+Gtyt7T5PJW6fKEcwhdmIYQHzfC84vm1w6o2KuijYjFTTg0uNaqdRaiPwTLIU5x50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1yFVmDks; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60cc00203faso7005647b3.2
        for <kvm@vger.kernel.org>; Wed, 03 Apr 2024 15:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712184169; x=1712788969; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UlLZ7hA4oy1JpChmEiN14ttbq81N4arBdlGQRutmBxA=;
        b=1yFVmDkswO93LtyCO4XfV+WN1Koj4ead1qgHwLI8TLYzXRULHUVFQzve7e2de2q9VQ
         FsP/XnmHnLBayCLs3DbHevSLatcvq8Jw6PYtk5GOmihFXNSPuTeYSkbeTsPVE0GrELrF
         UOwVhG5Gz/T8+nlW/RQuokl1DWMKufawUGDH7We9YmA4fBmJ8bwbTUo8Ox38PkLbEICs
         mO2OZ2ZyyONx01tppOktqX08UN/MZcHkWpMK26Yx2g9Q/UYI7qiCw4vAafBC2+GgAb6U
         nYnG0GvYf1q6ZZfVYBdf2YWMV71q73KaRJPDEnNenwpn3GhV4JFLVzYOJLBb1ACBH2PV
         5D+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712184169; x=1712788969;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UlLZ7hA4oy1JpChmEiN14ttbq81N4arBdlGQRutmBxA=;
        b=YnXVZA6cmBpBiaAxiKERLTrzvyLCyEcGQTM5e6h3tUhWmIuubxwMIdqCwHjBNISPvh
         /l/XxcDcDzgwSeU4KOXuKdxGiQM8HsFh65H9Oo4qRo94hw6L5wQbv+ugPc8iCxNsyJJI
         qUVzoSAoLiYcieBHkmCEnpXJ5Q5+ywD/Ks5oJ/QsImNSsRYaZe2kDUCsmVhZtVRhnjMO
         EV0RzCHHGs2xPTbNq8J3IZirasQgaG2ib+OlLVhwSN35kSS4PlO+BY0WBslVB0pCg6Wc
         kUB1qwdDpis8E+Ucvs+plp4NG0TovgWPR5Yl+WmU1VL9pNxjgojiI0roXPRLaJ3bV3vL
         oy5Q==
X-Forwarded-Encrypted: i=1; AJvYcCWuVcBvpbdoqUZZx33pN5ICl00mrd00cpo3bb4X6nR4g4tRTHOjT9B+wY60tXsFbsgzNaKplGTzswy2i5oF5I2+BozU
X-Gm-Message-State: AOJu0Yxxsiu/ACC2gANr3yyO1yiUrhm7cnhlGKBi41xYTBIzB2usn5jM
	59FXE87wNLOaeOkzJXEgls6d6kaAzDfSigvdThccNz+FJDNq7fiz6WtOny0lmteMF116D19zoiT
	C2g==
X-Google-Smtp-Source: AGHT+IGEhST2p92PFmovBbCMnCdeSkkVmZWkaaVSFg5gshHzyJej3edC2UH7m/8KBivZvDzkOdXH2hRT9zc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:a195:0:b0:614:fa:c912 with SMTP id
 y143-20020a81a195000000b0061400fac912mr201614ywg.1.1712184168995; Wed, 03 Apr
 2024 15:42:48 -0700 (PDT)
Date: Wed, 3 Apr 2024 15:42:47 -0700
In-Reply-To: <20240403220023.GL2444378@ls.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1709288671.git.isaku.yamahata@intel.com>
 <ZekQFdPlU7RDVt-B@google.com> <20240307020954.GG368614@ls.amr.corp.intel.com>
 <20240319163309.GG1645738@ls.amr.corp.intel.com> <Zg2gPaXWjYxr8woR@google.com>
 <20240403220023.GL2444378@ls.amr.corp.intel.com>
Message-ID: <Zg3bZ3MQaBvC5LML@google.com>
Subject: Re: [RFC PATCH 0/8] KVM: Prepopulate guest memory API
From: Sean Christopherson <seanjc@google.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: David Matlack <dmatlack@google.com>, kvm@vger.kernel.org, isaku.yamahata@gmail.com, 
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Michael Roth <michael.roth@amd.com>, Federico Parola <federico.parola@polito.it>, 
	isaku.yamahata@linux.intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Apr 03, 2024, Isaku Yamahata wrote:
> On Wed, Apr 03, 2024 at 11:30:21AM -0700,
> Sean Christopherson <seanjc@google.com> wrote:
> 
> > On Tue, Mar 19, 2024, Isaku Yamahata wrote:
> > > On Wed, Mar 06, 2024 at 06:09:54PM -0800,
> > > Isaku Yamahata <isaku.yamahata@linux.intel.com> wrote:
> > > 
> > > > On Wed, Mar 06, 2024 at 04:53:41PM -0800,
> > > > David Matlack <dmatlack@google.com> wrote:
> > > > 
> > > > > On 2024-03-01 09:28 AM, isaku.yamahata@intel.com wrote:
> > > > > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > > > 
> > > > > > Implementation:
> > > > > > - x86 KVM MMU
> > > > > >   In x86 KVM MMU, I chose to use kvm_mmu_do_page_fault().  It's not confined to
> > > > > >   KVM TDP MMU.  We can restrict it to KVM TDP MMU and introduce an optimized
> > > > > >   version.
> > > > > 
> > > > > Restricting to TDP MMU seems like a good idea. But I'm not quite sure
> > > > > how to reliably do that from a vCPU context. Checking for TDP being
> > > > > enabled is easy, but what if the vCPU is in guest-mode?
> > > > 
> > > > As you pointed out in other mail, legacy KVM MMU support or guest-mode will be
> > > > troublesome.
> > 
> > Why is shadow paging troublesome?  I don't see any obvious issues with effectively
> > prefetching into a shadow MMU with read fault semantics.  It might be pointless
> > and wasteful, as the guest PTEs need to be in place, but that's userspace's problem.
> 
> The populating address for shadow paging is GVA, not GPA.  I'm not sure if
> that's what the user space wants.  If it's user-space problem, I'm fine.

/facepalm

> > Pre-populating is the primary use case, but that could happen if L2 is active,
> > e.g. after live migration.
> > 
> > I'm not necessarily opposed to initially adding support only for the TDP MMU, but
> > if the delta to also support the shadow MMU is relatively small, my preference
> > would be to add the support right away.  E.g. to give us confidence that the uAPI
> > can work for multiple MMUs, and so that we don't have to write documentation for
> > x86 to explain exactly when it's legal to use the ioctl().
> 
> If we call kvm_mmu.page_fault() without caring of what address will be
> populated, I don't see the big difference.  

Ignore me, I completely spaced that shadow MMUs don't operate on an L1 GPA.  I
100% agree that restricting this to TDP, at least for the initial merge, is the
way to go.  A uAPI where the type of address varies based on the vCPU mode and
MMU type would be super ugly, and probably hard to use.

At that point, I don't have a strong preference as to whether or not direct
legacy/shadow MMUs are supported.  That said, I think it can (probably should?)
be done in a way where it more or less Just Works, e.g. by having a function hook
in "struct kvm_mmu".

