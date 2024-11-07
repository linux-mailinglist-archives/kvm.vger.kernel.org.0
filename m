Return-Path: <kvm+bounces-31174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5527C9C0FA6
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 21:26:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7849D1C21B8C
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 20:26:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 972A1217F55;
	Thu,  7 Nov 2024 20:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JwvEiTp7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5D12161E6
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 20:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731011209; cv=none; b=STm18Kfj0HVvQoJQKsQAwyQrUqhOE8ywf3Ne0Yizrzsb/zCFxLSqphDIa5GoRUASWae+ioMVhJColDCTnXsnC0APddW3qr79Odqzh3aRzoHjjSlg9cD1KprBAD2zjbDYWLcbGgd8w6wwqJQEMW8mvFUxgcbOcaa+k+avfSMMnzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731011209; c=relaxed/simple;
	bh=5+dKjp4NFaoQsFGHLDX4etrIGMptFEHaNLPNJNjWcpA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fPaBm0ySJefBVHNnHVjCVCZcHNxA4ocJamldj+RJnozrWiIZxxhg0/+vY2CuwUz3s8f2TcYpNFHfHP+jvgfppZ2sLIZYTDBo1AiahbBlyA3FtGHCo2v9oVD4n8LfHmxW9glVD6ssuuAqhYMRDi/lPg7+rmb2+iTvMePZb6VyBOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JwvEiTp7; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e38fabff35so27468597b3.0
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2024 12:26:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731011207; x=1731616007; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0DaXja48Eoul2mL0v8OhTPkrroMKx/GLkawdW4wfS5s=;
        b=JwvEiTp7sdqRNkz79MeEriRoj/WRbraWnTAsC17ku1ps5nX1dqaLa1nDros+b6LcGW
         BLDoEl8G/y/ElWlmySjDZFg+bYSDsrVgjK3RJqSgAJh+Wx9IRwYmBalT4EpDdrc1H3DL
         96DowUwv4Uyt5stswwoXUJU3z6z9wH/9JxpAbneyJahHKFwCL3jseMktUgU8tSt5qD+B
         Sh6WFehsAllGBml2qa5tk4KZq+BqtOscepInxXTcf+5fSG9+bVPAKzLJ8uAinl9PumeJ
         4Chz83jHD/s2P0qraK7yMa4ISYzCtKwk92iI5+TXDO+FWxzMkV10PFAObY/ETji1hLs4
         /W4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731011207; x=1731616007;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0DaXja48Eoul2mL0v8OhTPkrroMKx/GLkawdW4wfS5s=;
        b=GLprvjCNck/0TQL8PSIYvqkDzYtFtLttkys6YtxVlQ2SH8ev0OrmcVbcNGlR7cE0ji
         YEsCcwWyL/Tla3GgdvZRGBRrWNE7W4Llrq3F8BrSV8qGX4EAZjr+zfEpvn2yTae8yl51
         V0VRg3MR0nbCleGpqtNjSZICqJ0WJK5IxytffjWraqE8MavqtHwn8dqcG1Jfy2w0RcDC
         sA7a0/LnDI6AtncHVRMce2r2Cm5BSH8j4H9A3BJZwGIFm1RhOLeNZZXrIRT/YzCqqvYN
         YF1qnNBBNPcYwY7+5blxGwfNoQBdV24Sse5sNjsFlXZs1A4YMW/xRjh+SBMGsy9LEWtm
         +PIg==
X-Forwarded-Encrypted: i=1; AJvYcCUoL2bbYenggea6ODN9gILagGR9Sre9/dOACNT1k9u3QlowlfGUAZqlcJ3KOySI5TwxLQE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXTlHBNo/MDlW0GLEH9ZOz6MU7nSfftzERLTIKVYstXkEfgTlP
	92uHpXPYWzF45CyvbSvToC8xOzx1YFb4765Ew/yZQ1cscEp6CK5kyjuDScFuYmx2OqcRqPZPeGm
	y3A==
X-Google-Smtp-Source: AGHT+IFGnCavdqNWrqQzhvzEc2Nc4+MjfMOxSGbHqWn9yrACMcOtJh8NbYcCcVft7/QoNWhW/fUDme7cQ9Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:7307:b0:6ea:3c62:17c1 with SMTP id
 00721157ae682-6eaddd75f83mr31897b3.1.1731011207357; Thu, 07 Nov 2024 12:26:47
 -0800 (PST)
Date: Thu, 7 Nov 2024 12:26:45 -0800
In-Reply-To: <Zy0fPgwymCdBwLd_@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241107094000.70705-1-eric.auger@redhat.com> <20241107094000.70705-3-eric.auger@redhat.com>
 <Zyz_KGtoXt0gnMM8@google.com> <Zy0QFhFsICeNt8kF@linux.dev>
 <Zy0bcM0m-N18gAZz@google.com> <Zy0fPgwymCdBwLd_@linux.dev>
Message-ID: <Zy0ihQlkexIWc1fq@google.com>
Subject: Re: [PATCH  2/3] KVM: selftests: Introduce kvm_vm_dead_free
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com, broonie@kernel.org, 
	maz@kernel.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	joey.gouly@arm.com, shuah@kernel.org, pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 07, 2024, Oliver Upton wrote:
> On Thu, Nov 07, 2024 at 11:56:32AM -0800, Sean Christopherson wrote:
> > ---
> > From: Sean Christopherson <seanjc@google.com>
> > Date: Thu, 7 Nov 2024 11:39:59 -0800
> > Subject: [PATCH] KVM: selftests: Don't bother deleting memslots in KVM when
> >  freeing VMs
> > 
> > When freeing a VM, don't call into KVM to manually remove each memslot,
> > simply cleanup and free any userspace assets associated with the memory
> > region.  KVM is ultimately responsible for ensuring kernel resources are
> > freed when the VM is destroyed, deleting memslots one-by-one is
> > unnecessarily slow, and unless a test is already leaking the VM fd, the
> > VM will be destroyed when kvm_vm_release() is called.
> > 
> > Not deleting KVM's memslot also allows cleaning up dead VMs without having
> > to care whether or not the to-be-freed VM is dead or alive.
> 
> Can you add a comment to kvm_vm_free() about why we want to avoid ioctls
> in that helper? It'd help discourage this situation from happening again
> in the future in the unlikely case someone wants to park an ioctl there.
> 
> > Reported-by: Eric Auger <eric.auger@redhat.com>
> > Reported-by: Mark Brown <broonie@kernel.org>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> I'm assuming you want to take this, happy to grab it otherwise.

You take it.  Unless my git foo is off the rails, this is needs to go into 6.12,
along with a fix for the vGIC test.  That, and I already sent Paolo a pull request
for rc7; I don't want to overwork myself ;-)

