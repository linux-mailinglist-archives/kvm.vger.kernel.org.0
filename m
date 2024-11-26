Return-Path: <kvm+bounces-32483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49FB19D8F85
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 01:25:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5F3716946F
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 00:25:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BD554C8E;
	Tue, 26 Nov 2024 00:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C2BxWhab"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5973161
	for <kvm@vger.kernel.org>; Tue, 26 Nov 2024 00:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732580722; cv=none; b=oz+BJlqir3g5jLNEzITpDyc6pmzRmN2LWQNi8rWeeUXbCwlfHWdbwizanf9wcuRU/mn20fm+17pL1ZYFQPxgq2NssAYBlfyWX4+cfVBIiCiAvC+2XJnOwLgVkSi3L0nx+DrkCcMOmj6DepF37ettS+5D0YmRhKCUXuHf7R0HL0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732580722; c=relaxed/simple;
	bh=n+11RRM7aa4Qig8gaoj5CrapDLhCyDb2Ov5YvEdUPrg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pc3aUCjbXU/OOLeKAdzroOQkfeBokPrkGdPJ8oS+URYpgwbce4qm5M5IUTQrJCZ3oFM85aI2vnB+4nkmlc9MIIr/FFZSbueAkT5mZpOV/9HdvMQIivIbqEFPAOu9X+0srfr8xcNeZU9o0u+YZ5AOyUfp3BrOES5qA5ac56Hg/LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C2BxWhab; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2e9ff7aa7eeso5103501a91.1
        for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 16:25:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732580720; x=1733185520; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tN//AiS7h/bI7r5dwoIJd0p2pyQjhXkKgeTuVgcAQiU=;
        b=C2BxWhabBI/h8gO+OTDX5iCWjAllV1B+13Y0TIuy1v4yKS5A/HvdnQRQA9qP9T1ewW
         04QctI9l49b6eSW2xzAub1kPRcROZzcO1KTjkXIohZyahY4umPu2N/8rEBcOZEPmTnQE
         0Yt79ReDxF4agZ1OHS1PjkWRkwJRpESirGreT1/m9zRAK0Z0eJPu7FJMto6eq9ib56WY
         cmGIz+pOfi92I1MKd3nuIThWEHx8ngW+49a7kcnxqYdaRiz6eip93glY+8ArpwxjpwVa
         bQSvS6/c9Yhp7rPVcO8h4IJGsj/vgQnS448cBj4Hs/xMw4UXxL9tNo/Hpbfq4DpSMf85
         2T3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732580720; x=1733185520;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tN//AiS7h/bI7r5dwoIJd0p2pyQjhXkKgeTuVgcAQiU=;
        b=W9jzmKzc45C6lYjbYZ0W7FVAUB/5i/7T1v03Hd1iZJvcoUtb8yw0xew9E1z33T5ttc
         5pdwJ4yl32OjXkcexcG7QwMrT2IsckAEcmNWIERg7P8xLbpzPCM+lT76QjSKaJsjF4ph
         qqsk2v9b0fncnepaNXxSCwq0lPbfWdst2ReQOOvOQmPjn81x0ZgWPFWq0oWRxZNZZr4M
         I72ZbmtsBxMKj5NFcjadwvWoybBJUCnoaL0FCBlT3l2Ra1G5g9eeKdTIWOD5AS1jUVE7
         C2V8WsXCsW/zjppqdoiihplgsxI/pR0cXzrS4wB9xmcIoiA7hflDXQ8isEfpNsno8MX3
         XUQg==
X-Gm-Message-State: AOJu0YxZlMP7STJ2QiidA9ayfQV1NJ393KS2HoIpjIcJevpu5d/gFEj8
	f4e+drE8hYgePYcVwPu5VUS9uLyBfoJ1jUPGbnKU7d87JLdSMRxhFfHaEBpj0CNsVu85Cwx2V+Z
	6kA==
X-Google-Smtp-Source: AGHT+IELkS/KOIpSHXkL5x3MCn6HBT67YNDmLF6NPvb/kF/3OThrSOrfEV0+bjyAP4qMRYc4kQ7DL5+h9vE=
X-Received: from pjc7.prod.google.com ([2002:a17:90b:2f47:b0:2e2:9021:cf53])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d04:b0:2ea:a9ac:eeec
 with SMTP id 98e67ed59e1d1-2edebe10c8amr2050990a91.18.1732580720150; Mon, 25
 Nov 2024 16:25:20 -0800 (PST)
Date: Mon, 25 Nov 2024 16:25:18 -0800
In-Reply-To: <8d7e0d0391df4efc7cb28557297eb2ec9904f1e5.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231002115723.175344-1-mlevitsk@redhat.com> <ZRsYNnYEEaY1gMo5@google.com>
 <1d6044e0d71cd95c477e319d7e47819eee61a8fc.camel@redhat.com>
 <Zxb4D_JCC-L7OQDT@google.com> <Zxf2ZK7HS7jL7TQk@google.com> <8d7e0d0391df4efc7cb28557297eb2ec9904f1e5.camel@redhat.com>
Message-ID: <Z0UVbpcYJIbsRxp2@google.com>
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

On Thu, Nov 21, 2024, Maxim Levitsky wrote:
> On Tue, 2024-10-22 at 12:00 -0700, Sean Christopherson wrote:
> > On Mon, Oct 21, 2024, Sean Christopherson wrote:
> > > On Wed, Oct 04, 2023, Maxim Levitsky wrote:
> > > > About the added 'vcpu->loaded' variable, I added it also because it is
> > > > something that is long overdue to be added, I remember that in IPIv code
> > > > there was also a need for this, and probalby more places in KVM can be
> > > > refactored to take advantage of it, instead of various hacks.
> > > 
> > > I don't view using the information from the Physical ID table as a hack.  It very
> > > explicitly uses the ir_list_lock to ensure that the pCPU that's programmed into
> > > the IRTE is the pCPU on which the vCPU is loaded, and provides rather strict
> > > ordering between task migration and device assignment.  It's not a super hot path,
> > > so I don't think lockless programming is justified.
> 
> If you strongly prefer this I won't argue. KVM does read back its SPTE entries,
> which is also something I can't say that I like that much.

Heh, ignoring the conundrum with SPTEs being writable by hardware for A/D assists,
not reading SPTEs would add an almost absurd amount of complexity due to the need
to manage mappings in a separate data structure.  E.g. see TDX's S-EPT implementation
for how messy things get.

> > > I also think we should keep IsRunning=1 when the vCPU is unloaded.  That approach
> > > won't run afoul of your concern with signaling the wrong pCPU, because KVM can
> > > still keep the ID up-to-date, e.g. if the task is migrated when a pCPU is being
> > > offlined.
> > > 
> > > The motiviation for keeping IsRunning=1 is to avoid unnecessary VM-Exits and GA
> > > log IRQs.  E.g. if a vCPU exits to userspace, there's zero reason to force IPI
> > > senders to exit, because KVM can't/won't notify userspace, and the pending virtual
> > > interrupt will be processed on the next VMRUN.
> > 
> > My only hesitation to keeping IsRunning=1 is that there could, in theory, be a
> > noisy neighbor problem.  E.g. if there is meaningful overhead when the CPU responds
> > to the doorbell. 
> 
> I once measured this by bombarding a regular CPU, which is not running any
> guests, with AVIC doorbells. It was like 60% reduction of its performance if
> I remember correctly.

Ah, right, I keep forgetting the Intel's posted interrupts limits the spam to a
single IRQ thanks to the PID.ON behavior, which is why it's ok-ish to keep posted
interrupts active when a vCPU is put.

> So physical id table entries of a VM can't point to a CPU which doesn't run
> the VM's vCPU thread, because only in this case this doesn't pose a DOS risk.
> 
> Same with IOMMU (malicious guest can in theory make an assigned device
> generate an interrupt storm, and then this storm can get redirected to a
> doorbell of a CPU which doesn't belong to a VM).

