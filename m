Return-Path: <kvm+bounces-11220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 72BD08744B3
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 00:49:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF7191F23A59
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 23:49:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 770661CABA;
	Wed,  6 Mar 2024 23:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RJ8+4RS2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9CE1C6B1
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 23:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709768971; cv=none; b=dAGrgofrsAPWIXDqMhsJ2yt6w6OP562qN0ovWJxhF2nwzypdwtC0cHQLyKeA4RqVQ0d76P3AwmhdYcB+IPTMDfIi216WZ+tzeuaJ2a1Sv6uXFfv/h4lNHMQnjLhw2br8QH7uQ0GErsp+OH5oGbV+na1B81AlcrGOESJ06j7KWbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709768971; c=relaxed/simple;
	bh=UQ1NytZg7mc4xN3lMIs2BJwS3y0y6ZmogZomVAX0UO4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R1vn7/C4IMggtg6UKUOHwJOgKy65lsVnWoCjDKGTxyXrC74xM7JWwag2lElFLvEHrQyhlDCuGk/NHtpUnAs33aF/yqK4ioigAWowYuptR4JlC+IYmLeRgj+JM2S4PrP+i/J4lGSVlqPjqOq+uTjMA7C6yoKriYaxOEPSI52ShhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RJ8+4RS2; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5f38d676cecso18827707b3.0
        for <kvm@vger.kernel.org>; Wed, 06 Mar 2024 15:49:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709768969; x=1710373769; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=e+8p0GxMzUmHnO32tiGOH8cj3lz7Nl1rwkqh5mjWr7k=;
        b=RJ8+4RS2zPGXgPwFChJUbTuDcMGMw1QaVwGp/dnU9qnUQCAPB5H6o1clYma8OD3yLZ
         3ahSdKMUmz9r/xXNL+8F+7gpxnPFD/B45sndh5pI1TT0V0HUQ+V7wDyejkDtYHoYgBQZ
         3xjNan/EcQF0RVwSWs5RHAeRbNAFlO+U4cYHBvUHu5akvNCDKsWKx7ADGSkKP5Sfd0F0
         rkge2VDKUiV5AUUEUtZaOjCKMrNxr/mUooNUpVIDySLaz4D8MRn/RcI7tUIhxyZR7RVJ
         WAO4jyvACEtC+l0GDZw9IgleWAM7JR6B55BtGWrc6KnXIT7FbHyCLExJeg6njPQ2GpuU
         HWrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709768969; x=1710373769;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e+8p0GxMzUmHnO32tiGOH8cj3lz7Nl1rwkqh5mjWr7k=;
        b=KMKBYoYrSqro+mZXtKkrbj/r4Z30XQAn70LGJGilrRBhGO41vnQKywWiT9uZ8U0sQw
         CqbdLi2Qi6uEDDfO28j+fMfxJbZzThtIoMUxI9QTAmOMsGpstVIzIqwXN4BMqdasmS5Q
         vtPmGZnxBcV7mm6yvpcqYbUeDQ+fuf44dyHRfdcnM5RzQbHoN/bwwYE85+HhsLNtXuQ7
         NJkcNs4xyxTKjbxHSazvFTwe/d5AceohrpjE0XysMmQuVi3D5uzynf5ZBgNGB+5d+XtA
         00KB5uRTex538cEYdhQ84JvhZ4VYaU7RBcmA0p+t5rZsNBrRXdmvX5PNCuuNjH596bu8
         sE2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWCp7ElQC12Mq2CA/D0I9h0/+IrYNrYV2KlmBylI02ftNpcV8E9QVGIGVxqwc8GU8cnogdltckmwQUoNgph+7+0ExXp
X-Gm-Message-State: AOJu0YwUpvJ3IO7wbSSAZlVqv4pIJMWdWNtVoQisBefF79nT7NNQufaU
	qqi9y6abR3zD+zgm1vJGbuXFoRGEcwFUSYZKBw78s9jvkolRTy6XwJtRD4b8CDG20GcSCiyupp0
	t0A==
X-Google-Smtp-Source: AGHT+IHjx0dPql9CdUMSl+6NNhyRIBggdVbkPS3sl+qbxMTJd4YPnFKnJAZMiBW3jn/y4oDzSDYDNuWz16w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:120f:b0:dc7:7655:46ce with SMTP id
 s15-20020a056902120f00b00dc7765546cemr2125660ybu.2.1709768969207; Wed, 06 Mar
 2024 15:49:29 -0800 (PST)
Date: Wed, 6 Mar 2024 15:49:27 -0800
In-Reply-To: <18510419-3030-4af2-89cd-d642b6135046@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240228024147.41573-1-seanjc@google.com> <20240228024147.41573-10-seanjc@google.com>
 <adbcdeaa-a780-49cb-823c-3980a4dfea12@intel.com> <Zee7IhqAU_UZFToW@google.com>
 <a8dbea9d-cca7-4720-9193-6dbeaa62bb67@intel.com> <ZefOnduZJurb9sty@google.com>
 <18510419-3030-4af2-89cd-d642b6135046@intel.com>
Message-ID: <ZekBBxiackL1dRTg@google.com>
Subject: Re: [PATCH 09/16] KVM: x86/mmu: Move private vs. shared check above
 slot validity checks
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 07, 2024, Kai Huang wrote:
> 
> 
> On 6/03/2024 3:02 pm, Sean Christopherson wrote:
> > On Wed, Mar 06, 2024, Kai Huang wrote:
> > > 
> > > 
> > > On 6/03/2024 1:38 pm, Sean Christopherson wrote:
> > > > On Wed, Mar 06, 2024, Kai Huang wrote:
> > > > > 
> > > > > 
> > > > > On 28/02/2024 3:41 pm, Sean Christopherson wrote:
> > > > > > Prioritize private vs. shared gfn attribute checks above slot validity
> > > > > > checks to ensure a consistent userspace ABI.  E.g. as is, KVM will exit to
> > > > > > userspace if there is no memslot, but emulate accesses to the APIC access
> > > > > > page even if the attributes mismatch.
> > > > > 
> > > > > IMHO, it would be helpful to explicitly say that, in the later case (emulate
> > > > > APIC access page) we still want to report MEMORY_FAULT error first (so that
> > > > > userspace can have chance to fixup, IIUC) instead of emulating directly,
> > > > > which will unlikely work.
> > > > 
> > > > Hmm, it's not so much that emulating directly won't work, it's that KVM would be
> > > > violating its ABI.  Emulating APIC accesses after userspace converted the APIC
> > > > gfn to private would still work (I think), but KVM's ABI is that emulated MMIO
> > > > is shared-only.
> > > 
> > > But for (at least) TDX guest I recall we _CAN_ allow guest's MMIO to be
> > > mapped as private, right?  The guest is supposed to get a #VE anyway?
> > 
> > Not really.  KVM can't _map_ emulated MMIO as private memory, because S-EPT
> > entries can only point at convertible memory.
> 
> Right.  I was talking about the MMIO mapping in the guest, which can be
> private I suppose.
> 
> > KVM _could_ emulate in response to a !PRESENT EPT violation, but KVM is not
> > going to do that.
> > 
> > https://lore.kernel.org/all/ZcUO5sFEAIH68JIA@google.com
> > 
> 
> Right agreed KVM shouldn't "emulate" !PRESENT fault.

One clarification.  KVM *does* emulate !PRESENT faults.  And that's not optional,
as caching MMIO info in SPTEs is purely an optimization and isn't possible on all
CPUs, e.g. AMD CPUs with MAXPHYADDR=52 don't have reserved bits to set.

My point above was specifically about emulating *private* !PRESENT faults as MMIO.

> I am talking about this -- for TDX guest, if I recall correctly, for guest's
> MMIO gfn KVM still needs to get the EPT violation for the _first_ access, in
> which KVM can configure the EPT entry to make sure "suppress #VE" bit is
> cleared so the later accesses can trigger #VE directly.

That's totally fine, so long as the access is shared, not private.

> I suppose this is still the way we want to implement?
> 
> I am afraid for this case, we will still see the MMIO GFN as private, while
> by default I believe the "guest memory attributes" for that MMIO GFN should
> be shared?

No, the guest should know it's (emulated) MMIO and access the gfn as shared.  That
might generate a !PRESENT fault, but that's again a-ok.

> AFAICT, it seems the "guest memory attributes" code doesn't check whether a
> GFN is MMIO or truly RAM.

That's userspace's responsibility, not KVM's responsibility.  And if userspace
doesn't proactively make emulated MMIO regions shared, then the memory_fault exit
that results from this patch will give userspace the hook it needs to convert the
gfn to shared on-demand.

