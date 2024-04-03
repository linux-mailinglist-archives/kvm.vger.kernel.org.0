Return-Path: <kvm+bounces-13490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 63A38897855
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 20:36:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DDAB9B2E1BD
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 18:30:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC06F153BFB;
	Wed,  3 Apr 2024 18:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O4l5Q98X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2783D60
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 18:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712169031; cv=none; b=q6L9sXwevyxuts9MjgImCUrsZaiEySi6uNTcikMELHfnCceeAbTtVO8uKOK+X4sqgOqYIqBpJT/ePUgX+bnPWRrCEmwMHmQn4xxERqPgWHeiqLV13wWjEoMFFEq6TkenJcxcXySlexuEB7xG4rIe5x7OutDXu52ZxiHsHcd0LWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712169031; c=relaxed/simple;
	bh=3+9lMpILcT4GrzjklqZThP0A8O5Au3Kt8WUWoV+QX18=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RmkBaZjR+8Zrm1T0xKMj6aNYaedRxHf+Iy9OxPZ0iOY+VeugbIcxuI6o2OWV/W2IB3QVZYsAAos3qfe9i0ps/KuXRnPU/fNVUVyCcb94TEsmgsBXz+DStRdky7T2cw7/dPJKo5DLw7FGDPNsbDJiyGKtZDXws5g3FRMmaWDHRMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O4l5Q98X; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6ea80a33cf6so85587b3a.1
        for <kvm@vger.kernel.org>; Wed, 03 Apr 2024 11:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712169029; x=1712773829; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VwSQRZk+BRxb7GZSaFeES/scIy0HPs9KPKeQnP6jNQA=;
        b=O4l5Q98XSlJ72CMiyfQLVgLeeDoICseHsQPl9PQcQRZEanElc/xhifRioSWN/kmDJ1
         q4X8YjhIeTuuekY6pg2l1AYn+616tmQRUMbjsdLbxx30h+Y3No4Ox51OHNCLRZgZ0mE1
         ePAGleNsio1BUflY2SvqlfD9MK1VuJthlBeF6cyPb39o74K4Gue+iiBddBslhhbHTxK4
         ALJnOaVj3WK4UYNYFiFpVDVvvjozo5SXSy/Uug5CVuUCAK+NgBXWR7QewwZLFGCbz9LB
         CawLdpfUKxhwLN3A2i7sUlejoOmy/T//l48WU0ESvh1pj8xD/5LEtevm1PJgQdCnBNGN
         xTjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712169029; x=1712773829;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VwSQRZk+BRxb7GZSaFeES/scIy0HPs9KPKeQnP6jNQA=;
        b=F56XPUOjalLx1gtBPwqJwaOYFu+Dv2e0jK3fOo4MfsS3VWd1DvuhDxhov5wEOe75Y5
         WaIqJQ5Jqxg2IDJ3zHkmyzL0IIQu/86pt5HV9QzpQvnawCMW8cdnKeqqVO1SzHkzg7sR
         kt2dL8NnKr9X5i6Fro8sASia/tQL6Y8qo5qTzO9qhKJozeckLXZ9i0avOYaY7WBwWSBM
         FhS1wKYKJ7mHGxBQNZNy0yMqhVjjuyiMnxCWA8KjkSw9R52/0oqopGDAbhcAjsjy4N3N
         UReqoSAmlOL5tYJVUYK/29HCPFw7FACXaAYR50bMcM5XBBKb3m5e5XjLytzpz/4RNI2z
         du1w==
X-Forwarded-Encrypted: i=1; AJvYcCUou32rfgp2o1rEItRDCgzvKrkheEZEa7+SM4rdQqL+DoIMLA+2WLnoOP6TFIdm1feMbcyhljv8VwlMX7wbZpq2H9Ua
X-Gm-Message-State: AOJu0YyB73p/Uf2gy1d1H6915P/Ich/zwlDsI217TBc2FBPB7yUvT/PS
	Lw8cHHPCr+PFy9VUb0u2FF5FkjUdR6Zrv/glaWJtAGDtG9XG67KgorpzFv7vaRmpEWbXNo7TZx4
	fmQ==
X-Google-Smtp-Source: AGHT+IG/dVT1QOvlvL3U4/nwwVAfLf64pBOTR5Elndu+IJvpzi5Oo1x0lhZjKdwFiBZ+AqTPHPDpWYXpEf8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d07:b0:6ea:b999:4de1 with SMTP id
 fa7-20020a056a002d0700b006eab9994de1mr10338pfb.5.1712169028875; Wed, 03 Apr
 2024 11:30:28 -0700 (PDT)
Date: Wed, 3 Apr 2024 11:30:21 -0700
In-Reply-To: <20240319163309.GG1645738@ls.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1709288671.git.isaku.yamahata@intel.com>
 <ZekQFdPlU7RDVt-B@google.com> <20240307020954.GG368614@ls.amr.corp.intel.com> <20240319163309.GG1645738@ls.amr.corp.intel.com>
Message-ID: <Zg2gPaXWjYxr8woR@google.com>
Subject: Re: [RFC PATCH 0/8] KVM: Prepopulate guest memory API
From: Sean Christopherson <seanjc@google.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: David Matlack <dmatlack@google.com>, kvm@vger.kernel.org, isaku.yamahata@gmail.com, 
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Michael Roth <michael.roth@amd.com>, Federico Parola <federico.parola@polito.it>
Content-Type: text/plain; charset="us-ascii"

On Tue, Mar 19, 2024, Isaku Yamahata wrote:
> On Wed, Mar 06, 2024 at 06:09:54PM -0800,
> Isaku Yamahata <isaku.yamahata@linux.intel.com> wrote:
> 
> > On Wed, Mar 06, 2024 at 04:53:41PM -0800,
> > David Matlack <dmatlack@google.com> wrote:
> > 
> > > On 2024-03-01 09:28 AM, isaku.yamahata@intel.com wrote:
> > > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > 
> > > > Implementation:
> > > > - x86 KVM MMU
> > > >   In x86 KVM MMU, I chose to use kvm_mmu_do_page_fault().  It's not confined to
> > > >   KVM TDP MMU.  We can restrict it to KVM TDP MMU and introduce an optimized
> > > >   version.
> > > 
> > > Restricting to TDP MMU seems like a good idea. But I'm not quite sure
> > > how to reliably do that from a vCPU context. Checking for TDP being
> > > enabled is easy, but what if the vCPU is in guest-mode?
> > 
> > As you pointed out in other mail, legacy KVM MMU support or guest-mode will be
> > troublesome.

Why is shadow paging troublesome?  I don't see any obvious issues with effectively
prefetching into a shadow MMU with read fault semantics.  It might be pointless
and wasteful, as the guest PTEs need to be in place, but that's userspace's problem.

Testing is the biggest gap I see, as using the ioctl() for shadow paging will
essentially require a live guest, but that doesn't seem like it'd be too hard to
validate.  And unless we lock down the ioctl() to only be allowed on vCPUs that
have never done KVM_RUN, we need that test coverage anyways.

And I don't think it makes sense to try and lock down the ioctl(), because for
the enforcement to have any meaning, KVM would need to reject the ioctl() if *any*
vCPU has run, and adding that code would likely add more complexity than it solves.

> > The use case I supposed is pre-population before guest runs, the guest-mode
> > wouldn't matter. I didn't add explicit check for it, though.

KVM shouldn't have an explicit is_guest_mode() check, the support should be a
property of the underlying MMU, and KVM can use the TDP MMU for L2 (if L1 is
using legacy shadow paging, not TDP).

> > Any use case while vcpus running?
> > 
> > 
> > > Perhaps we can just return an error out to userspace if the vCPU is in
> > > guest-mode or TDP is disabled, and make it userspace's problem to do
> > > memory mapping before loading any vCPU state.
> > 
> > If the use case for default VM or sw-proteced VM is to avoid excessive kvm page
> > fault at guest boot, error on guest-mode or disabled TDP wouldn't matter.
> 
> Any input?  If no further input, I assume the primary use case is pre-population
> before guest running.

Pre-populating is the primary use case, but that could happen if L2 is active,
e.g. after live migration.

I'm not necessarily opposed to initially adding support only for the TDP MMU, but
if the delta to also support the shadow MMU is relatively small, my preference
would be to add the support right away.  E.g. to give us confidence that the uAPI
can work for multiple MMUs, and so that we don't have to write documentation for
x86 to explain exactly when it's legal to use the ioctl().

