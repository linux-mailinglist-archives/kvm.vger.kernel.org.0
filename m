Return-Path: <kvm+bounces-29428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FA689AB65D
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 21:01:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF8A61F2419F
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 19:01:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 417EB1CB30A;
	Tue, 22 Oct 2024 19:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sgVZrZyY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0EB145A1C
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 19:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729623656; cv=none; b=kxyBUoZ0XUgZPtmCJEkqu6bjsvseClNYXzEvs4iMUigonhSIWL+t6+vN5jhQz/29gwTxyi3ni+5pPYQLJfMqwbUUSzBT5QOtUr4ELqpALqPw+ZXGrfEcRnBUJxhGohbwSsSTefyCFYNPhk0sqdHjZdyDty1Xj+Zpq6KtVJ/ccfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729623656; c=relaxed/simple;
	bh=ha7ePI1h8iQoHbzruRXiN0x3RDdtMaNlStfwZOXb78M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O98b9RGogH2LxEGhEFpETFBHcmYuwZ0NzocKEArF94aiAM7NKQnEBmT+sekBBTIXGKRKvpDp3urpJlRUNiPQ1nnipJ1siCJTTIMQOOSNdoHYKdFzBYEdmJOSwgVBAd/JMtsiyOt+Q7XqNLlKLqy+5GDUzHRuim4tF/E10nZka2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sgVZrZyY; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e2974759f5fso208790276.0
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 12:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729623654; x=1730228454; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DrBrn35LjV4fle0zz8oDGlad/5uSTJzGLTSWOS1Px4s=;
        b=sgVZrZyYaW1qZQGVZ2akAh+ruiXXKF0vqf11LJQQchYlvwzmM3akWidg0lLtqDhA+w
         ycIv/FYQ879kya5U6qOXmzc4aXNRPP4oJrR4L/IpPQ1CQTuYyskUV1hgVC4tGS8AXNtt
         KfGIrHOZGH+zAROyLXcPf0rDShiIKgZS/kSK5peOFWt1LWzqhqYUPbybSkQxfdcHPttr
         r1CbkCFxeFpOSwTRfw49nRNXHLMwDyvTb+y7bk2iZ0uoEt73O2ghlJvQcP65xD9WksRO
         XnqQNvOvVayv90N610qoylACOoDV71pxTxXzs8u75d7Y9zZ4zC3JDuT6jT9iKriJw901
         66CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729623654; x=1730228454;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DrBrn35LjV4fle0zz8oDGlad/5uSTJzGLTSWOS1Px4s=;
        b=H2HuhSKKFqRrMQab9V/Wf3LPP/W6KpsH0Y7eidCDgGdRD81ifYsOG3tsL8D2RgtRhU
         MtOtmHFgOO3j5hurfipzMJ4FFw6eltr++nDvggdmVq3I0NZaLswPgOWvcNplePqLLSHE
         neuKnqgWGtRNSqo15l32SySV7m2DRUg9/eJJkeLzZr/zzAzyNGLbp2lsSoWgu3hFCKZM
         INb9aMCkdQbYx1n/6wPEPj/7Tr71vfOTz4biAKLrIrYsYAQKDcowTKLpaQJNYOT//VZH
         Cs2jajz+oPJRQ5vhZy3tyKypDKZY3Ab/qKwVyNBaT0hYQIeUjIJeoiPPGA/Z5HEmp/vW
         2cWA==
X-Gm-Message-State: AOJu0YyO2rENzvScKgB5lpbS7qKHM2+TYUic1pHD0o+wRsGMk1NWiiuq
	PeDK8SvQCasjHDCd0a2n5qWUI/5knrDOXVOAvT0xadLyGKpouSRXnBMJsrQtoCkVwc8w/ly4MX8
	v5Q==
X-Google-Smtp-Source: AGHT+IHbl0Q/eeAVwKL16JD6RI9BME7YNfz+VrN478T5E+rYVmLa3hGPlShaVUdcv9jsDUrZk7bS7mixkfY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:aa12:0:b0:e2e:2c2e:277b with SMTP id
 3f1490d57ef6-e2e2c2e316cmr19368276.3.1729623653976; Tue, 22 Oct 2024 12:00:53
 -0700 (PDT)
Date: Tue, 22 Oct 2024 12:00:52 -0700
In-Reply-To: <Zxb4D_JCC-L7OQDT@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231002115723.175344-1-mlevitsk@redhat.com> <ZRsYNnYEEaY1gMo5@google.com>
 <1d6044e0d71cd95c477e319d7e47819eee61a8fc.camel@redhat.com> <Zxb4D_JCC-L7OQDT@google.com>
Message-ID: <Zxf2ZK7HS7jL7TQk@google.com>
Subject: Re: [PATCH v3 0/4] Allow AVIC's IPI virtualization to be optional
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Joerg Roedel <joro@8bytes.org>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, 
	Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 21, 2024, Sean Christopherson wrote:
> On Wed, Oct 04, 2023, Maxim Levitsky wrote:
> > About the added 'vcpu->loaded' variable, I added it also because it is
> > something that is long overdue to be added, I remember that in IPIv code
> > there was also a need for this, and probalby more places in KVM can be
> > refactored to take advantage of it, instead of various hacks.
> 
> I don't view using the information from the Physical ID table as a hack.  It very
> explicitly uses the ir_list_lock to ensure that the pCPU that's programmed into
> the IRTE is the pCPU on which the vCPU is loaded, and provides rather strict
> ordering between task migration and device assignment.  It's not a super hot path,
> so I don't think lockless programming is justified.
> 
> I also think we should keep IsRunning=1 when the vCPU is unloaded.  That approach
> won't run afoul of your concern with signaling the wrong pCPU, because KVM can
> still keep the ID up-to-date, e.g. if the task is migrated when a pCPU is being
> offlined.
> 
> The motiviation for keeping IsRunning=1 is to avoid unnecessary VM-Exits and GA
> log IRQs.  E.g. if a vCPU exits to userspace, there's zero reason to force IPI
> senders to exit, because KVM can't/won't notify userspace, and the pending virtual
> interrupt will be processed on the next VMRUN.

My only hesitation to keeping IsRunning=1 is that there could, in theory, be a
noisy neighbor problem.  E.g. if there is meaningful overhead when the CPU responds
to the doorbell.  Hrm, and if another vCPU is scheduled in on the same pCPU, that
vCPU could end up processing a virtual interrupt in response to a doorbell intended
for a different vCPU.

The counter-argument to both concerns is that APICv Posted Interrupts have had a
_worse_ version of that behavior for years, and no one has complained.  KVM sets
PID.SN only when a vCPU is _preempted_, and so devices (and now virtual IPIs) will
send notification IRQs to pCPUs that aren't actively running the vCPU, or are
running a different vCPU.

The counter-counter-argument is that (a) IPI virtualization is a recent addition,
and device posted interrupts are unlikely to be used in a CPU oversubscribed setup,
and (b) Posted Interrupts are effectively rate-limited to a single "spurious"
notification per vCPU, as notification IRQs are sent if and only if PID.ON=0.

That said, while I'm somewhat less confident that keeping IsRunning=1 is desirable
for all use cases than I was yesterday, I still think we should avoid tightly
coupling it to whether or not the vCPU is loaded, because there are undoubtedly
setups where it _is_ desirable, e.g. if vCPUs are pinned 1:1 to pCPUs.

