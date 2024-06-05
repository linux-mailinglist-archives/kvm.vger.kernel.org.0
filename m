Return-Path: <kvm+bounces-18918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C5B98FD166
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 17:09:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D0AB4B24336
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 15:09:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E4831474A2;
	Wed,  5 Jun 2024 15:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LOWxch2K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375EF143722
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 15:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717600138; cv=none; b=SJnfJ7y++UXfvPjQyK6JKFbYW374+JqQqLR9d+uiIPa4i9hWUUnYNKDQAYUMuuLTlwtt/2fK51XmobNfkypq2+TU6SzpjWqFpyMYSHfDMDyVen4lKbl1XA6qpa3rs5GrwA3ekC/Igi2+feRtzI+yMZ6Cei9GP9Q9AQ6ZHLC4NRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717600138; c=relaxed/simple;
	bh=4JyuwwyC3HBCATZsuMSNx2NdgBe2Rb9+OjQPFT0wds8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LVRjEREJ2WMuvq+PMwJha8MoBKY6UBZ3uUPzlumGuxPMlQxrmZSG+FElou4KXqhT8s8p9tQWP+jg+OoyEsOBQSWTkCEIcd+CkPPtBaIjHSijI5Kth+a8s3MN2U4+thPtY3/8QkD74gClsnPvjGomrnSSZHwajbC7F366FaIUJ3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LOWxch2K; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1f66f2e4cc7so41810855ad.3
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 08:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717600136; x=1718204936; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9QZ+vKQP5mDiEMq7aC/1ssTDMAZfDe/7jI56fqmifes=;
        b=LOWxch2KH2LSl24kClKFEev2bvld6zvWHKktwiAXfuFZHiEm9p6R3z+1tqHE/79YAY
         0O39tlclUMgkUIpRZeNZ1RazIG3qh6fwl7feJWpFiHHTRAOv3sV1r684cdT1DqyoGOxO
         hxdPpWO3F7AVETIK+YnxmbN8ATDsSt8b6bN/aBGzPKVBHu1NKjDe1b9JZv/QtSaZL8CS
         l5+lLXJu7dZMRvoHN8v2o7KdaNJD45vbBcn99Wa8WkqMdxJaXKS2yWTx6G+a1TvqQN4f
         EM2YiWx5WJwci9clhu9NjTnJXrNg1AoNklD4ybr1rKTfvA2FVk99IObdOco76mG3GKD1
         BPuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717600136; x=1718204936;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9QZ+vKQP5mDiEMq7aC/1ssTDMAZfDe/7jI56fqmifes=;
        b=ubfY4Ms6FGkTPwgrIND8jNx47TXT/Hw3R9S+mxYqv5eHgQrSkwhfz6JbToQnGuM7a5
         Sbu2GX6g9t5qH4dOGOD3nUjuOurNkDod18G88/BKjq27TTw04QUYaWBk0EyEpMg3RaQS
         NQwF7FGIH4JSZlaF0snvHl85w8pCMPEng6cSPRR507smWc9CJhkruwk0qsStWIPj/AVq
         77eM3FRJEOmGngu/9yYAEEP8JC3btdtYHIuN3vw7DDwCbx22Zw0EBTixxd5DA4/3b8Cn
         EAJXHP/Jmx4MI54jtoHXp5c5XotmNS5q6uZFaOsRd5W9m2PwKr6CmHat8GHkMSHS0McZ
         jxjA==
X-Forwarded-Encrypted: i=1; AJvYcCXTdO9ksSL/hV1JHb19C0mQ1AINt7l/rmxMgqytwiPwAeun1zBapCmUCyTtAuKRzVooySGqs6DhFn6MWhzmhiOISTzQ
X-Gm-Message-State: AOJu0Yxajqu/vMFYpx9ZVxxrEnE/xHdl7MAUa68l3sCCZOAb/iF2t6cM
	+IuuIv6vry2f05pKoxgQG+MUtPizC6ITDNN5YtPO8/dh6mWVr5J8FylY9YooUn1R6WMX0EJiLMB
	giQ==
X-Google-Smtp-Source: AGHT+IFOWIAW8rQZeqIoAhkK9HfGTM8iAboRiyRWXoj3LvZaRP7jP/VaJALlP/KwviDZ8VgTtBwOJCi8oYs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1cc:b0:1f3:e88:a6a0 with SMTP id
 d9443c01a7336-1f6a5a1b926mr1528685ad.7.1717600136208; Wed, 05 Jun 2024
 08:08:56 -0700 (PDT)
Date: Wed, 5 Jun 2024 08:08:54 -0700
In-Reply-To: <e1c29dd4-2eb9-44fe-abf2-f5ca0e84e2a6@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240429060643.211-1-ravi.bangoria@amd.com> <20240429060643.211-4-ravi.bangoria@amd.com>
 <Zl5jqwWO4FyawPHG@google.com> <e1c29dd4-2eb9-44fe-abf2-f5ca0e84e2a6@amd.com>
Message-ID: <ZmB_hl7coZ_8KA8Q@google.com>
Subject: Re: [PATCH 3/3] KVM SVM: Add Bus Lock Detect support
From: Sean Christopherson <seanjc@google.com>
To: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, pbonzini@redhat.com, thomas.lendacky@amd.com, 
	hpa@zytor.com, rmk+kernel@armlinux.org.uk, peterz@infradead.org, 
	james.morse@arm.com, lukas.bulwahn@gmail.com, arjan@linux.intel.com, 
	j.granados@samsung.com, sibs@chinatelecom.cn, nik.borisov@suse.com, 
	michael.roth@amd.com, nikunj.dadhania@amd.com, babu.moger@amd.com, 
	x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	santosh.shukla@amd.com, ananth.narayan@amd.com, sandipan.das@amd.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 05, 2024, Ravi Bangoria wrote:
> Hi Sean,
> 
> On 6/4/2024 6:15 AM, Sean Christopherson wrote:
> > On Mon, Apr 29, 2024, Ravi Bangoria wrote:
> >> Upcoming AMD uarch will support Bus Lock Detect. Add support for it
> >> in KVM. Bus Lock Detect is enabled through MSR_IA32_DEBUGCTLMSR and
> >> MSR_IA32_DEBUGCTLMSR is virtualized only if LBR Virtualization is
> >> enabled. Add this dependency in the KVM.
> > 
> > This is woefully incomplete, e.g. db_interception() needs to be updated to decipher
> > whether the #DB is the responsbility of the host or of the guest.
> 
> Can you please elaborate. Are you referring to vcpu->guest_debug thingy?

Yes.  More broadly, all of db_interception().

> > Honestly, I don't see any point in virtualizing this in KVM.  As Jim alluded to,
> > what's far, far more interesting for KVM is "Bus Lock Threshold".  Virtualizing
> > this for the guest would have been nice to have during the initial split-lock #AC
> > support, but now I'm skeptical the complexity is worth the payoff.
> 
> This has a valid usecase of penalizing offending processes. I'm not sure
> how much it's really used in the production though.

Yeah, but split-lock #AC and #DB have existed on Intel for years, and no one has
put in the effort to land KVM support, despite the series getting as far as v9[*].
Some of the problems on Intel were due to the awful FMS-based feature detection,
but those weren't the only hiccups.  E.g. IIRC, we never sorted out what should
happen if both the host and guest want bus-lock #DBs.

Anyways, my point is that, except for SEV-ES+ where there's no good reason NOT to
virtualize Bus Lock Detect, I'm not convinced that it's worth virtualizing bus-lock
#DBs.

[*] https://lore.kernel.org/all/20200509110542.8159-1-xiaoyao.li@intel.com

> > I suppose we could allow it if #DB isn't interecepted, at which point the enabling
> > required is minimal?
> 
> The feature uses DEBUG_CTL MSR, #DB and DR6 register. Do you mean expose
> it when all three are accelerated or just #DB?

I mean that if KVM isn't intercepting #DB, then there's no extra complexity needed
to sort out whether the #DB "belongs" to the host or the guest.  See commit
90cbf6d914ad ("KVM: SEV-ES: Eliminate #DB intercept when DebugSwap enabled").

