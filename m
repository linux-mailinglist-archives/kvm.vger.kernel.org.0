Return-Path: <kvm+bounces-42467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E385EA78CF8
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 13:20:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A0E116CF03
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 11:20:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B400C2376F8;
	Wed,  2 Apr 2025 11:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X+jrPfQS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBD4231CB0
	for <kvm@vger.kernel.org>; Wed,  2 Apr 2025 11:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743592801; cv=none; b=O8fH+CCdZVAQe3E1Y4P8jOrVMKr42uXGP61/rAMYLEApw0WIA3oyYaorsedXI+daotDHWdXG8jgPuhzJwwFGLjfADXy7L0dAaKdGkc6eHSSwkyEc6El2Jf3bQ6ewSjEoLJn+eI/ZLbQ17NIGHTFJEZQIPx7/QTPqCoQDgVuGADU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743592801; c=relaxed/simple;
	bh=+XHLLwQIqniAShr/zDi4PIli6Pj9vsKmOjJJeTZdbYM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CefMt7S4d9ba35/QX97VT/hE2DZcwB4+H59Vn611fmQagi6YC7tCsNpRy4qLghhwdkmBPHOtRBdt3YFOjdWhGrRam4Sf3iMTe1CfjZJVlcAL0qGZHBDKHP7Z2CXEjGQ0s/K1XCCJTpRUmTHNBvws/AHAOroohcPEk3ellGe86qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X+jrPfQS; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-736aaeed234so4111b3a.0
        for <kvm@vger.kernel.org>; Wed, 02 Apr 2025 04:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743592798; x=1744197598; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TGYk4MN5JgZ/GTWR6xaYNWOcgddcbUz8F9N3UmxYMIM=;
        b=X+jrPfQS1BpY3zl+PU3rCasXzyoiCplmuLQs8O34rX4qiU/qjJOAkvJfNi1VLoo2lS
         ZeZO+9qFrZpEU7Oe6bOr44K2nbZ9/TuUEClOaMNR9GiJu99SiwkeIIYETJmmQQ/w9Kq6
         x7D4auuQwYuAIuIK3i4UCNHQragPI1gQyWGYr39QXH5LXJkx+Mik7LdE4AjS3SYBZAGC
         id7kYzvQvzYzVGwcmi3cojoin52Z6EVFjWkUF11Fri7GZaw0iY3KpQS0c71nS86KZJQs
         ZhkqbfLow1ZI0HvPzqhUL6QoJjPTgEPV8r6C8bZlAhsekAP3aN3Kjv0u4uofSQRpnFTC
         5pnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743592798; x=1744197598;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TGYk4MN5JgZ/GTWR6xaYNWOcgddcbUz8F9N3UmxYMIM=;
        b=g35bgO6gvpeF3or7v6rRAviSANryro2vORYhJOpNXUS40scFxQI2M4vZocwYp/h8Gt
         Hm7WAb3qZ+UbQJd+8wAFqevxdzr3t0XJn0JiCW/aptDC9egO3gQ0b/4NX9sbcckNWkKm
         6kP7Luqjtmoho8i4HA73maOdPN8QaLIuMzyIHVBXKH+rZkXYVkg1awVQn+O+ck0Y+zs+
         Ytrbxiz1+0FIoRUcg2CevEt3KmjV/YrzjqEf50XUJrKZnr2lgiIlJoHoccsAm9j+oKHJ
         n1x/gTe6XV58BP9CtQlV2eJ4j7oGeaGImPdnxC209zCLwkRCRtDv74knbODeot8rcO7M
         F1PQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0qExK6Ck/S/ZdxfzinXmDeYBEOSKHegB3EIGdLFJemMrP9S2YToGcAvT0kWNZ4ejpHno=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4poD/V7BGVDbJOCDE3+1snES2+Gz11SMckGJDkTh7CMobElTy
	Dhkoai/he3zJxH1NILZ3o/Awdao90dZifUoK+UZ0LdkiKAynzzG1
X-Gm-Gg: ASbGncvw/+hgeDck68iXEGbPGAxN3TYN9WYTTm77ina8st3xCbNZ6B3wOd43iX/zT09
	ZGYpGCsawhcjURxsr+0t6FfmfKNSYwg2jgxbf46ULx0WJtEsaAxIyVWUKSSRN8cXj8YSrVVcH4f
	SXOCG9J/5AZupa+NBExdvZ6lO4wSesrq567MHw2K2TMl409UPoa72vuCx/LY7Jtv3wq7+cMy1+d
	sOc3H6+8MdgPRYirkmfY2VNnq/vhzDLNrP0d/lLKMFB9JUnDKxDHG6D7W/NmXWxw3ScsbFxr5xE
	hAgJ8S6pl4zd5Ire3Sdygc5+oPuMr5pz7zacKA==
X-Google-Smtp-Source: AGHT+IED6RODE5t1fgpLzXAzt+WwoeH8VunMoBhibfk12A/H/jmVed7PJAwEBl7ILJ5RLoZMUek0/Q==
X-Received: by 2002:aa7:8890:0:b0:736:339b:8296 with SMTP id d2e1a72fcca58-7398042ff42mr24632593b3a.18.1743592798394;
        Wed, 02 Apr 2025 04:19:58 -0700 (PDT)
Received: from raj ([103.48.69.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73970e2233asm10673144b3a.43.2025.04.02.04.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Apr 2025 04:19:58 -0700 (PDT)
Date: Wed, 2 Apr 2025 16:49:50 +0530
From: Yuvraj Sakshith <yuvraj.kernel@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Cc: oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	jens.wiklander@linaro.org, sumit.garg@kernel.org,
	mark.rutland@arm.com, lpieralisi@kernel.org, sudeep.holla@arm.com,
	pbonzini@redhat.com, kvmarm@lists.linux.dev,
	op-tee@lists.trustedfirmware.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] KVM: optee: Introduce OP-TEE Mediator for
 exposing secure world to KVM guests
Message-ID: <Z-0dVi1_XMmmVZsL@raj>
References: <20250401170527.344092-1-yuvraj.kernel@gmail.com>
 <87ldsjzr5l.wl-maz@kernel.org>
 <Z-yn6BdPcuM_aDBX@raj>
 <87jz83ymww.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87jz83ymww.wl-maz@kernel.org>

On Wed, Apr 02, 2025 at 09:42:39AM +0100, Marc Zyngier wrote:
> On Wed, 02 Apr 2025 03:58:48 +0100,
> Yuvraj Sakshith <yuvraj.kernel@gmail.com> wrote:
> > 
> > On Tue, Apr 01, 2025 at 07:13:26PM +0100, Marc Zyngier wrote:
> > > On Tue, 01 Apr 2025 18:05:20 +0100,
> > > Yuvraj Sakshith <yuvraj.kernel@gmail.com> wrote:
> > > >
> 
> [...]
> 
> > > > This implementation has been heavily inspired by Xen's OP-TEE
> > > > mediator.
> > > 
> > > [...]
> > > 
> > > And I think this inspiration is the source of most of the problems in
> > > this series.
> > > 
> > > Routing Secure Calls from the guest to whatever is on the secure side
> > > should not be the kernel's job at all. It should be the VMM's job. All
> > > you need to do is to route the SMCs from the guest to userspace, and
> > > we already have all the required infrastructure for that.
> > >
> > Yes, this was an argument at the time of designing this solution.
> >
> > > It is the VMM that should:
> > > 
> > > - signal the TEE of VM creation/teardown
> > > 
> > > - translate between IPAs and host VAs without involving KVM
> > > 
> > > - let the host TEE driver translate between VAs and PAs and deal with
> > >   the pinning as required, just like it would do for any userspace
> > >   (without ever using the KVM memslot interface)
> > > 
> > > - proxy requests from the guest to the TEE
> > > 
> > > - in general, bear the complexity of anything related to the TEE
> > >
> > 
> > Major reason why I went with placing the implementation inside the kernel is,
> > 	- OP-TEE userspace lib (client) does not support sending SMCs for VM events
> > 	  and needs modification.
> > 	- QEMU (or every other VMM)  will have to be modified.
> 
> Sure. And what? New feature, new API, new code. And what will happen
> once someone wants to use something other than OP-TEE? Or one of the
> many forks of OP-TEE that have a completely different ABI (cue the
> Android forks -- yes, plural)?

If something other than OP-TEE has to be supported, a specific mediator
(such as drivers/tee/optee/optee_mediator.c) has to be constructed
with handlers hooked via tee_mediator_register_ops().

But yes, the ABI might change and the implementor has the freedom to
mediate it as required.

> > 	- OP-TEE driver is anyways in the kernel. A mediator will just be an addition
> > 		and not a completely new entity.
> 
> Of course not. The TEE can be anywhere I want. On another machine if I
> decide so. Just because OP-TEE has a very simplistic model doesn't
> mean we have to be constrained by it.
> 
> > 	- (Potential) issues if we would want to mediate requests from VM which has
> > 	  private mem.
> 
> Private memory means that not even the host has access to it, as it is
> the case with pKVM. How would that be an issue?
>

Guest shares memory to OP-TEE through a buffer filled with pointers, which
the mediator has to read for IPA->PA translations of all these pointers.
VMM wont be able to read these if memory is private.

But, this is a "potential" solution and if at all the mediator is moved to VMM,
this is completely ruled out.
 
> > 	- Heavy VM exits if guest makes frequent TOS calls.
> 
> Sorry, I have to completely dismiss the argument here. I'm not even
> remotely considering performance for something that is essentially a
> full context switch of the whole machine. By definition, calling into
> EL3, and then S-EL1/S-EL2 is going to be as fast as a dying snail, and
> an additional exit to userspace will hardly register for anything
> other than a pointless latency benchmark.
> 
Okay, makes sense.
> > 
> > Hence, the thought of making changes to too many entities (libteec,
> > VMM, etc.) was a strong reason, although arguable.
> 
> It is a *terrible* reason. By this reasoning, we would have subsumed
> the whole VMM into the kernel (just like Xen), because "we don't want
> to change userspace".
> 
> Furthermore, you are not even considering basic things such as
> permissions. Your approach completely circumvents any form of access
> control, meaning that if any user that can create a VM can talk to the
> TEE, even if they don't have access to the TEE driver.

Well, this is a good point. OP-TEE built for NS-Virt supports handles calls
from different VMs under different MMU partitions (will need to go off track
to explain this). But, each VM's state and data remains isolated internally
in S-EL1.

> Yes, you could replicate access permission, SE-Linux, seccomp (and the
> rest of the security theater) at the KVM/TEE boundary, making the
> whole thing even more of a twisted mess.
> 
> Or you could simply do the right thing and let the kernel do its job
> the way it was intended by using the syscall interface from userspace.
> 
> > 
> > > In short, the VMM is just another piece of userspace using the TEE to
> > > do whatever it wants. The TEE driver on the host must obviously know
> > > about VMs, but that's about it.
> > > 
> > > Crucially, KVM should:
> > > 
> > > - be completely TEE agnostic and never call into something that is
> > >   TEE-specific
> > > 
> > > - allow a TEE implementation entirely in userspace, specially for the
> > >   machines that do not have EL3
> > >
> > 
> > Yes, you're right. Although I believe there still are some changes
> > that need to be made to KVM for facilitating this. For example,
> > kvm_smccc_get_action() would deny TOS call.
> 
> If something is missing in KVM to allow routing of SMCs to userspace,
> I'm more than happy to entertain the change.

Okay.

> > So, having an implementation completely in VMM without any change in
> > KVM might be challenging, any potential solutions are welcome.
> 
> I've said what I have to say already, and pointed you in a direction
> that I see as both correct and maintainable.
> 

Yes, I get your point on placing mediator in VMM. And now that I think of it,
I believe I can make an improvement.

But yes, since too many entities are involved, the design of this solution has been
a nightmare. Good to have been pushed this way.

> Thanks,
> 
> 	M.
> 
> -- 
> Jazz isn't dead. It just smells funny.

Thanks,
Yuvraj Sakshith

