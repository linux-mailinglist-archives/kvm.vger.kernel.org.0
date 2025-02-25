Return-Path: <kvm+bounces-39191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A2BCA44F6D
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 23:01:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08D083AC7AD
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 22:00:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2C492135AC;
	Tue, 25 Feb 2025 22:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LuLWil9I"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4016118DB04
	for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 22:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740520808; cv=none; b=A9uQdZijFpGCgapF4nEaYBAJvZ1i0HOAfDeskiz3ZchB0OrmuUpfiSJDWZ7qvAhMKn1yXp6Fq3tBS3W3jmq4kyK/+gxfNQIDQP+3P3xPTFr177N4uMsVc1R+gXMwEqyBhayh/STCVVBv4ILNw7vhxQWdEC51VHU1fPT5P9k1j/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740520808; c=relaxed/simple;
	bh=LGdXOz1Z3oleLe2XFRI65us3attlCYpRc59iXFHvP88=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Jq/0YChw6hn8rua0IJQye+3nhYQBppiegLGX6yM2K3HP+pFYSjWD+xFlr0nh12VwXt2nxNYOSdvgPJvxEA93VrqsQcM8u04WW5OColV+45JsfeMsvAPvQZd8rFqcMK2sVvTS4ep9zbS+cTnUDCb6I2NDyzW1pGYNierkgEjLXlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LuLWil9I; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740520805;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0Bb2V+mbnJJoInEW5Wm2LB6yv6+Wa0umig9olpTiRHM=;
	b=LuLWil9IPzcvya7pqUh8SmEopCnShVlX1DaPD5XP1cO6/CL04YNHcQvuQnIYXifG0hSwet
	AjymbueG4vA/y/ZEaFXqp93ru3uigcLduLZv+h4vH/QvRVjiMxRDtm+4SRG20AeYRb4E3V
	eKLJvhY2SOp+A+5Z2gFLFV5xErIg908=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-232-IunZqEzZMiKllt0hd7YTKQ-1; Tue, 25 Feb 2025 17:00:03 -0500
X-MC-Unique: IunZqEzZMiKllt0hd7YTKQ-1
X-Mimecast-MFC-AGG-ID: IunZqEzZMiKllt0hd7YTKQ_1740520803
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-471fc73b941so185534731cf.1
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 14:00:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740520803; x=1741125603;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0Bb2V+mbnJJoInEW5Wm2LB6yv6+Wa0umig9olpTiRHM=;
        b=PZPX6XEku8+DXT1xPMbSZyuU/EcUgjVebnA5nupWMuZ7Xn4Ib2cLCfwfrUQuu2hzjL
         iYt0q1k98l1/lWlXgIIAa7/K5QSo1eyWfQOlQ96gH7VN8eMQ1QCNdtdw4FyrChMx6F+1
         KwA3jiTPgme683OWjL5Ljxw+WJe/q0ddo+3kEe8gH12gZJ05tm07bhMId9lCCbCI7ZPK
         jsGPhcGQR7H8ipc/K8wymAcRLGslCPt8MRyEq4IiybEvVPpoJmxaGpQ04crgXw9rE8XO
         jVp/qQAcgjeoGNYjZXzt6aU+lxEd4H7R0pQeA9YxyYKWqI90WU3+WT7J3fGK8xt+gYT5
         7kgw==
X-Forwarded-Encrypted: i=1; AJvYcCU7Kgmk9oPeJVojctrkmuD53qYPTWzS7QijNsbWfom8MrlFlvKPWzTjFknIIfwfSOgLkU4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtzObFbqYn/0yIKKvR9ETTSTqfxOZtOJtbsPeTmtEMtwpf7kJN
	pk1tLns0qp7jVDSe7GGYgcnXSAxsy4+6MsoYd6rZFCGxdAwfz8Uo4SKtc62a3CvP9jfBiuMf98p
	snyFDt7okvazpt9jz7Esvnsmq0UjT2mDHkfK59/XvFkd3QmUxxQ==
X-Gm-Gg: ASbGncvf3LQtfvIDRAnzaX2m5MBHQKbJ5AJZemaips5W2ytvoZOdowCnYcHMmHrrqOz
	7HbqKASSrZXNWxJwkbM1ckQ+bbI24IsZO0Y0Zc3PWQc9E2p4LRdthUCHlc4VU3If4K+5ShVf5d4
	cv0X0NolL78yxGg6LADE/IVTNQ+wd5ILJEHig3+gzEyzwKMGP78h2uX1+dcc7SkGP76lgxxsm7O
	q0gAo38xU6ISGyRXsD6eUjGtqprTUviCqJ5Y0UsKbVIeKxFBwOVcYc3ZCY+KyV69EPUP5QuEVIO
	Dfoeq6ORdEsJuR8=
X-Received: by 2002:ac8:5fcd:0:b0:471:f272:9862 with SMTP id d75a77b69052e-4737725ccd8mr80673541cf.41.1740520803183;
        Tue, 25 Feb 2025 14:00:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGKcJI9jny77dfDG0KDTNvU6C4CH9BV0kPcSk7G/tFKXoyZJlHMLOdxm3hpfh33e+GECWyEuQ==
X-Received: by 2002:ac8:5fcd:0:b0:471:f272:9862 with SMTP id d75a77b69052e-4737725ccd8mr80672761cf.41.1740520802597;
        Tue, 25 Feb 2025 14:00:02 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-47378082f55sm15049841cf.65.2025.02.25.14.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 14:00:02 -0800 (PST)
Message-ID: <07788b85473e24627131ffe1a8d1d01856dd9cb5.camel@redhat.com>
Subject: Re: [PATCH v9 00/11] KVM: x86/mmu: Age sptes locklessly
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: James Houghton <jthoughton@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  David Matlack <dmatlack@google.com>, David Rientjes
 <rientjes@google.com>, Marc Zyngier <maz@kernel.org>,  Oliver Upton
 <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao
 <yuzhao@google.com>, Axel Rasmussen <axelrasmussen@google.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 25 Feb 2025 17:00:00 -0500
In-Reply-To: <Z7UwI-9zqnhpmg30@google.com>
References: <20250204004038.1680123-1-jthoughton@google.com>
	 <025b409c5ca44055a5f90d2c67e76af86617e222.camel@redhat.com>
	 <Z7UwI-9zqnhpmg30@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2025-02-18 at 17:13 -0800, Sean Christopherson wrote:
> On Tue, Feb 18, 2025, Maxim Levitsky wrote:
> > On Tue, 2025-02-04 at 00:40 +0000, James Houghton wrote:
> > > By aging sptes locklessly with the TDP MMU and the shadow MMU, neither
> > > vCPUs nor reclaim (mmu_notifier_invalidate_range*) will get stuck
> > > waiting for aging. This contention reduction improves guest performance
> > > and saves a significant amount of Google Cloud's CPU usage, and it has
> > > valuable improvements for ChromeOS, as Yu has mentioned previously[1].
> > > 
> > > Please see v8[8] for some performance results using
> > > access_tracking_perf_test patched to use MGLRU.
> > > 
> > > Neither access_tracking_perf_test nor mmu_stress_test trigger any
> > > splats (with CONFIG_LOCKDEP=y) with the TDP MMU and with the shadow MMU.
> > 
> > Hi, I have a question about this patch series and about the
> > access_tracking_perf_test:
> > 
> > Some time ago, I investigated a failure in access_tracking_perf_test which
> > shows up in our CI.
> > 
> > The root cause was that 'folio_clear_idle' doesn't clear the idle bit when
> > MGLRU is enabled, and overall I got the impression that MGLRU is not
> > compatible with idle page tracking.
> > 
> > I thought that this patch series and the 'mm: multi-gen LRU: Have secondary
> > MMUs participate in MM_WALK' patch series could address this but the test
> > still fails.
> > 
> > 
> > For the reference the exact problem is:
> > 
> > 1. Idle bits for guest memory under test are set via /sys/kernel/mm/page_idle/bitmap
> > 
> > 2. Guest dirties memory, which leads to A/D bits being set in the secondary mappings.
> > 
> > 3. A NUMA autobalance code write protects the guest memory. KVM in response
> >    evicts the SPTE mappings with A/D bit set, and while doing so tells mm
> >    that pages were accessed using 'folio_mark_accessed' (via kvm_set_page_accessed (*) )
> >    but due to MLGRU the call doesn't clear the idle bit and thus all the traces
> >    of the guest access disappear and the kernel thinks that the page is still idle.
> > 
> > I can say that the root cause of this is that folio_mark_accessed doesn't do
> > what it supposed to do.
> > 
> > Calling 'folio_clear_idle(folio);' in MLGRU case in folio_mark_accessed()
> > will probably fix this but I don't have enough confidence to say if this is
> > all that is needed to fix this.  If this is the case I can send a patch.
> 
> My understanding is that the behavior is deliberate.  Per Yu[1], page_idle/bitmap
> effectively isn't supported by MGLRU.
> 
> [1] https://lore.kernel.org/all/CAOUHufZeADNp_y=Ng+acmMMgnTR=ZGFZ7z-m6O47O=CmJauWjw@mail.gmail.com

Hi,

Reading this mail makes me think that the page idle interface isn't really used anymore.

Maybe we should redo the access_tracking_perf_test to only use the MGLRU specific interfaces/mode,
and remove its classical page_idle mode altogher?

The point I am trying to get across is that currently access_tracking_perf_test main 
purpose is to test that page_idle works with secondary paging and the fact is that it doesn't work 
well due to more that one reason:

The mere fact that we don't flush TLB already necessitated hacks like the 90% check,
which for example doesn't work nested so another hack was needed, to skip the check
completely when hypervisor is detected, etc, etc.

And now as of 6.13, we don't propagate accessed bit when KVM zaps the SPTE at all, 
which can happen at least in theory due to other reasons than NUMA balancing.


Tomorrow there will be something else that will cause KVM to zap the SPTEs, and the test will fail again,
and again...

What do you think?


> 
> > This patch makes the test pass (but only on 6.12 kernel and below, see below):
> > 
> > diff --git a/mm/swap.c b/mm/swap.c
> > index 59f30a981c6f..2013e1f4d572 100644
> > --- a/mm/swap.c
> > +++ b/mm/swap.c
> > @@ -460,7 +460,7 @@ void folio_mark_accessed(struct folio *folio)
> >  {
> >         if (lru_gen_enabled()) {
> >                 folio_inc_refs(folio);
> > -               return;
> > +               goto clear_idle_bit;
> >         }
> >  
> >         if (!folio_test_referenced(folio)) {
> > @@ -485,6 +485,7 @@ void folio_mark_accessed(struct folio *folio)
> >                 folio_clear_referenced(folio);
> >                 workingset_activation(folio);
> >         }
> > +clear_idle_bit:
> >         if (folio_test_idle(folio))
> >                 folio_clear_idle(folio);
> >  }
> > 
> > 
> > To always reproduce this, it is best to use a patch to make the test run in a
> > loop, like below (although the test fails without this as well).
> 
> ..
> 
> > With the above patch applied, you will notice after 4-6 iterations that the
> > number of still idle pages soars:
> > 
> > Populating memory             : 0.798882357s
> 
> ...
> 
> > vCPU0: idle pages: 132558 out of 262144, failed to mark idle: 0 no pfn: 0
> > Mark memory idle              : 2.711946690s
> > Writing to idle memory        : 0.302882502s
> > 
> > ...
> > 
> > (*) Turns out that since kernel 6.13, this code that sets accessed bit in the
> > primary paging structure, when the secondary was zapped was *removed*. I
> > bisected this to commit:
> > 
> > 66bc627e7fee KVM: x86/mmu: Don't mark "struct page" accessed when zapping SPTEs
> > 
> > So now the access_tracking_test is broken regardless of MGLRU.
> 
> Just to confirm, do you see failures on 6.13 with MGLRU disabled?  

Yes. The test always fails.

> 
> > Any ideas on how to fix all this mess?
> 
> The easy answer is to skip the test if MGLRU is in use, or if NUMA balancing is
> enabled.  In a real-world scenario, if the guest is actually accessing the pages
> that get PROT_NONE'd by NUMA balancing, they will be marked accessed when they're
> faulted back in.  There's a window where page_idle/bitmap could be read between
> making the VMA PROT_NONE and re-accessing the page from the guest, but IMO that's
> one of the many flaws of NUMA balancing.
> 
> That said, one thing is quite odd.  In the failing case, *half* of the guest pages
> are still idle.  That's quite insane.
> 
> Aha!  I wonder if in the failing case, the vCPU gets migrated to a pCPU on a
> different node, and that causes NUMA balancing to go crazy and zap pretty much
> all of guest memory.  If that's what's happening, then a better solution for the
> NUMA balancing issue would be to affine the vCPU to a single NUMA node (or hard
> pin it to a single pCPU?).

Nope. I pinned main thread to  CPU 0 and VM thread to  CPU 1 and the problem persists.
On 6.13, the only way to make the test consistently work is to disable NUMA balancing.


Best regards,
	Maxim Levitsky




