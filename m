Return-Path: <kvm+bounces-58702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 20443B9B964
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 21:04:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4B7242302A
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 19:04:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6300B24E016;
	Wed, 24 Sep 2025 19:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cPdv5e5O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149EE19C546
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 19:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758740676; cv=none; b=QI3lLQbsGCT08O1qjVMCLjZf6ytX2K/qgx9LMBjDdlKbroPeBZrXeI1hj1gyPwEzsGNI0plwDBXjWq2lniNmRZ4TTaOI5AEL2PgpeAZIRG0tvvdnlwCHspht3X1d8GyuX4OQYi1/xbqnHa21a0UDB6v+9q8Ho5Hexf6RPs+rOts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758740676; c=relaxed/simple;
	bh=RGWtKrOOLNWYTSDuRiuXkPplrVfwaq2EP1qrdFnB8Bk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZVs2988KNb3uDEwQ8RKi9B+IQr9op6jR3TR1m4hLQ20NXuwDyGORgOr3KTBjBWtuNE7PyWCCfBe1m1daZS3Nkmu5NGWwkNiGEQtl5yTSAWmhAYX2GemhZWfQH+5SNUUS1KPqUDS6uSwpgxtpFfbhDPoee2d74Oy9JI7pWPQcUJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cPdv5e5O; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-269af520712so1645475ad.2
        for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 12:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758740674; x=1759345474; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zhobkvNwmZ1KaAHiSUahaC62ylu/YKuBdOUTZ4WpS7s=;
        b=cPdv5e5OWcYVpvZfiu9iCMgqBTwQ7rHPMY31pp6mqR64Cc8r4SM3eW//D5zEyEEJgt
         ax57348zqxDM1wAutaHrmNQARIbtDuyHT64xrLYtfhOwgb8lnMLkmvvOp1zvU9mCHJRx
         63rhpdGUqBHoSSPjQvLI6q4d0ZQmDJpaxMeq06dUgVMqpFRM/WZEH6LKzziLm6N8/W31
         jMLPT9WQKPRX7n11dZUOqLXhX6Q4579GVbv6Add7EbzfVP/E5EXh05KSgdR63JPw0ATV
         vCRo8lczwWuFhIBCUdqM6W9NzTUP1Tb17kFAi2oLF0YJ+Xn3nRaOj0usE9oXp8UBZPdm
         DOxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758740674; x=1759345474;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zhobkvNwmZ1KaAHiSUahaC62ylu/YKuBdOUTZ4WpS7s=;
        b=DHqMMZGlUZGe6p7kjnis69M3GUwYQKT1IcTc0tkDo/ajPKHaEjliGdqdMYMJMsxG77
         EsprRffM9qcFRGBOrAJMYNWVc3g/hGDU69avo6px+BzDb6C/Ogg3xHEFs3LBPOooVW8v
         yg2yC3DXkTNyYxGzEBEwGCv8Wj9UW8GWsvAzei6mLc2atLAwk8rlTS8P8CZs4jGqZ6qj
         cvJyQedB0BZazFEq4vonNJ4JW1GdaKPP2cLsb/ZSgqIGJUilIlUmBAe2kOqv3PwMDZVz
         cCyjoRcsPHTkKZQd5RchbcuC9zuSAxCR7PjmaY/8aRpyVmokqrLCRFef4O0DJ6BpXwjh
         aUXg==
X-Gm-Message-State: AOJu0YzRw7oX+xGMQ8/7gXE7/VSFYReyBz00nOIveuQJt4UFU0keIwXc
	gMaJ91Y6hepXdTLuGPqyse9pBFH6DQ+rlSj+vEPzglqcudhJpyoHvCCnjj+3kDesInC8xrMBr3v
	s7t5jbQ==
X-Google-Smtp-Source: AGHT+IH2WlD/AveH5Fl/D7PzNyoDXFz37t7GYa1z3iEAaJ8Rnn0Y73Fm2mZH24+yaKsFzrWnGS9iAX9B9ZI=
X-Received: from pjbqj6.prod.google.com ([2002:a17:90b:28c6:b0:332:6d9d:1e99])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e78d:b0:273:c463:7b2c
 with SMTP id d9443c01a7336-27ed4a0920emr8931715ad.3.1758740674393; Wed, 24
 Sep 2025 12:04:34 -0700 (PDT)
Date: Wed, 24 Sep 2025 12:04:32 -0700
In-Reply-To: <3204c99d-6c62-4327-9aa0-a09651a75f0d@arvin.dk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <3204c99d-6c62-4327-9aa0-a09651a75f0d@arvin.dk>
Message-ID: <aNRAwBB0SkTbX3fS@google.com>
Subject: Re: Co-stop
From: Sean Christopherson <seanjc@google.com>
To: Troels Arvin <troels@arvin.dk>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Sep 05, 2025, Troels Arvin wrote:
> Hello,
> 
> According to https://www.linux-kvm.org/page/Lists,_IRC it's OK to use this
> list for KVM user questions, so here it goes:
> 
> How important is it to consider "co-stop" with KVM?

From a _KVM_ perspective, it's not important at all.  Outside of a few targeted
paravirt yielding scenarios, KVM isn't involved in vCPU scheduling.

> I haven't been able to find anything about this for KVM, but there's some
> material about it for VMWare (albeit typically rather old material). Based
> on VMWare material, by "co-stop" I mean the following situation:
> 
> A VM called "x" has been assigned quite a few vCPUs, e.g. 10, on a
> hypervisor with e.g. 20 physical cores. The hypervisor is hosting many other
> VMs, and the many VMs take turn running on the hardware.
> Now, if it's often the case that, e.g., only 7 physical threads are
> available when it's x's turn to run, the hypervisor needs to postpone
> running x till all 10 cores can be allocated at the same time. During this
> waiting time, x is stopped (co-stop).
> 
> Is my understanding correct?

Maybe?  How vCPUs are scheduled isn't even really a kernel decision, it's much
more of a userspace decision.  E.g. the kernel scheduler will balance competing
tasks, but which vCPUs are allowed to run on which pCPUs, and when (at a macro
level), is entirely userspace controlled.

> Or will KVM allow x to run on (e.g.) 7 cores, even though the VM thinks it
> has 10 vCPUs available?

As above, KVM doesn't care.  KVM does enumerate the maximum number of
recommended vCPUs per VM, e.g. to help userspace avoid doing something truly
stupid, but that's just a recommendation.  Nothing prevents userspace from
creating a 128 vCPU and pinning all vCPUs tasks to a single pCPU.  Performance
will obviously be terrible, but functionally it works.

> It's my understanding that with KVM, the co-stopped situation is reflected
> in the VM's "steal time" metric in a tool like "top".

More or less.  Steal time captures how much time a vCPU wanted to run, but
couldn't because a different task (or tasks) in the host preempted the vCPU.
Note, I specifically say "tasks" and not "vCPUs", because in Linux+KVM, vCPUs
are regular tasks from a scheduling perspective, and so depending on how a host
is configured, a vCPU task may compete against other host tasks.

And to really warp your mind... nothing in KVM requires a 1:1 task:vCPU mapping.
VMMs typically use a dedicated task to run a vCPU, but KVM allows running a vCPU
on different tasks (though obviously not at the same time), and KVM also allows
running multiple vCPUs on a single task (again, obviously not at the same time).

> Does hyperthreading in either the hypervisor and/or the guest impact the
> risk of co-stop?

Not directly, no.  But hyperthreading can factor into the platform owner's
scheduling policies, and that in turn can certain impact contention.  E.g. with
all of the side channels that are suspecitble to cross-SMT attacks, it's common
for cloud providers to do "core scheduling", where vCPUs scheduled on a per-core
basic, not a per-CPU basis.

