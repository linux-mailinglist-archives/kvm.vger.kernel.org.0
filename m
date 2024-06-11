Return-Path: <kvm+bounces-19367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F97F9046DE
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 00:21:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ADD1DB22AF4
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 22:21:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54341155345;
	Tue, 11 Jun 2024 22:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WFbSCK4A"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAED315253B
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 22:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718144492; cv=none; b=dtOEs0DmOQvKBoHeLGv7ZJbDsth21NeePN/mmK3PX4qcN4Qu8nEJKGCQJo3SvIjsWz0vHJyK5eEr6Azk50PX5rMJVbFgLvDprzDJq0IVi7I4sdqKBoQ+GVS2WM+TI+qUDaoHf2vB9TSYO+0yZOopE5W442DiHzPd93xKU1FK9RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718144492; c=relaxed/simple;
	bh=1BaXhoKSY0jcaVNcI4emnVP144YL7TFNPcNk9dMJmrg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uK0Z792KjOhXl1iQj4WfQdcCoOnDt1HbE53GMSlBoAnff0FPJHzWjSAd1STyk50tcjBSPAlEuf2LZjGetrb2AMueUDLZfPvTMjeKl6G77m+R7e7mVEovTH/haeW69R3mU8OGpDJ1mtn7YU4N4qacsYdH1K9MJQSgMNctsIMKxXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WFbSCK4A; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718144488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DatEcFGN+0ZIwiKEmnb9vwdAqYXlhMMgpgcnDRaoZ+o=;
	b=WFbSCK4A+o6VgI5yphO5ez+ioniw1GByzTKxYpSMvdEpVQcX5+EcN1g0O98KKHA+L2NAqV
	WCZX6GHt2YsiI32YFoBMkISHoGJfKUmHSHJaM0oTkWS/w4N46UqprrI82LtZSjN8KEaLnN
	aFdpWbn/IfHGXI6vpxwTo51utk3MY7c=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-147-PsKY3BflOkiLhc-a3MNpwg-1; Tue, 11 Jun 2024 18:21:25 -0400
X-MC-Unique: PsKY3BflOkiLhc-a3MNpwg-1
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-6f8f8b59250so1587109a34.2
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 15:21:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718144485; x=1718749285;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DatEcFGN+0ZIwiKEmnb9vwdAqYXlhMMgpgcnDRaoZ+o=;
        b=e84LYGuLQX+VJJ8rxA86HQfaFLvjI7mB+7pfG/V9/M1OGtQC+xzMb0HzLYxS+LmmA3
         R3w0Iq+AaMUcXrlG0biSdVrwriZsXYgnMBme5OeEw5zSBOMW7153I9v5QKxcc4CmX1MQ
         Sx9gHvhXoB3JVOdXiUWFK9ZVR88E7HyFvo+63RkY2QL7yp1+3lovK5isJn5EUPFdshC4
         6oAyiFslSK2HETEeyd9HOFh8WauOUZrAQ8HL/xx19x3mVlkpiuSJ7eTx6sTtXRyrXKUl
         1qYfSVHL7LMNX3NPve6hSdTfhM9dJuRTTW8lQ5SmNNCH2bgkM+6yVtONKqrySwoMhjjz
         Tyng==
X-Forwarded-Encrypted: i=1; AJvYcCWpiv/7FKJZ8xTxaEKZOcp+/5/h0sg8kQroS5AwLfj/PIN1B/LSL1s2bhY49nmCRxKoMTLRmzCC5reTRAopuuXk9IPk
X-Gm-Message-State: AOJu0YwwzIbSj3bGely+UGV3gDIs1fUErdjRyMeCmb6/Otlsu0gWLv8F
	0ZlQAiVbdphcl3DH1StYAAPdSiVrgqSaVCG+v1hCsaLkdlCkINbraKMIylB/bwDr4ZmrCoANTNe
	s5aoJ/Egwkdvyucx6nbDjwk2NMEo2pNnPTeE9OCT5wZWkSLiiSw==
X-Received: by 2002:a05:6830:1e1c:b0:6f9:ecfb:6c98 with SMTP id 46e09a7af769-6fa1c222978mr73365a34.24.1718144484474;
        Tue, 11 Jun 2024 15:21:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHWqJsi/lpTX61iOR3KZ19pif3tSW4wF5q5hqI6RDE+uV2Q3A4Wf86dWHbtNQ/mVPuv8gWCFw==
X-Received: by 2002:a05:6830:1e1c:b0:6f9:ecfb:6c98 with SMTP id 46e09a7af769-6fa1c222978mr73350a34.24.1718144484027;
        Tue, 11 Jun 2024 15:21:24 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-6f96bf1c127sm1557633a34.74.2024.06.11.15.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jun 2024 15:21:23 -0700 (PDT)
Date: Tue, 11 Jun 2024 16:21:19 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>, Gerald Schaefer
 <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, Vasily
 Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle
 <svens@linux.ibm.com>, Gerd Bayer <gbayer@linux.ibm.com>, Matthew Rosato
 <mjrosato@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>, Suren
 Baghdasaryan <surenb@google.com>, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 1/3] s390/pci: Fix s390_mmio_read/write syscall page
 fault handling
Message-ID: <20240611162119.6bc04d61.alex.williamson@redhat.com>
In-Reply-To: <b38b571b753441314c090c3eb51c49c0e28a19d5.camel@linux.ibm.com>
References: <20240529-vfio_pci_mmap-v3-0-cd217d019218@linux.ibm.com>
	<20240529-vfio_pci_mmap-v3-1-cd217d019218@linux.ibm.com>
	<98de56b1ba37f51639b9a2c15a745e19a45961a0.camel@linux.ibm.com>
	<30ecb17b7a3414aeb605c51f003582c7f2cf6444.camel@linux.ibm.com>
	<db10735e74d5a89aed73ad3268e0be40394efc31.camel@linux.ibm.com>
	<ce7b9655-aaeb-4a13-a3ac-bd4a70bbd173@redhat.com>
	<32b515269a31e177779f4d2d4fe2c05660beccc4.camel@linux.ibm.com>
	<89c74380-6a60-4091-ba57-93c75d9a37d7@redhat.com>
	<b38b571b753441314c090c3eb51c49c0e28a19d5.camel@linux.ibm.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 11 Jun 2024 17:37:20 +0200
Niklas Schnelle <schnelle@linux.ibm.com> wrote:

> On Tue, 2024-06-11 at 17:10 +0200, David Hildenbrand wrote:
> > > > 
> > > > which checks mmap_assert_write_locked().
> > > > 
> > > > Setting VMA flags would be racy with the mmap lock in read mode.
> > > > 
> > > > 
> > > > remap_pfn_range() documents: "this is only safe if the mm semaphore is
> > > > held when called." which doesn't spell out if it needs to be held in
> > > > write mode (which I think it does) :)  
> > > 
> > > Logically this makes sense to me. At the same time it looks like
> > > fixup_user_fault() expects the caller to only hold mmap_read_lock() as
> > > I do here. In there it even retakes mmap_read_lock(). But then wouldn't
> > > any fault handling by its nature need to hold the write lock?  
> > 
> > Well, if you're calling remap_pfn_range() right now the expectation is 
> > that we hold it in write mode. :)
> > 
> > Staring at some random users, they all call it from mmap(), where you 
> > hold the mmap lock in write mode.
> > 
> > 
> > I wonder why we are not seeing that splat with vfio all of the time?
> > 
> > That mmap lock check was added "recently". In 1c71222e5f23 we started 
> > using vm_flags_set(). That (including the mmap_assert_write_locked()) 
> > check was added via bc292ab00f6c almost 1.5 years ago.
> > 
> > Maybe vfio is a bit special and was never really run with lockdep?
> >   
> > >   
> > > > 
> > > > 
> > > > My best guess is: if you are using remap_pfn_range() from a fault
> > > > handler (not during mmap time) you are doing something wrong, that's why
> > > > you get that report.  
> > > 
> > > @Alex: I guess so far the vfio_pci_mmap_fault() handler is only ever
> > > triggered by "normal"/"actual" page faults where this isn't a problem?
> > > Or could it be a problem there too?
> > >   
> > 
> > I think we should see it there as well, unless I am missing something.  
> 
> Well good news for me, bad news for everyone else. I just reproduced
> the same problem on my x86_64 workstation. I "ported over" (hacked it
> until it compiles) an x86 version of my trivial vfio-pci user-space
> test code that mmaps() the BAR 0 of an NVMe and MMIO reads the NVMe
> version field at offset 8. On my x86_64 box this leads to the following
> splat (still on v6.10-rc1).

There's already a fix for this queued[1] in my for-linus branch for
v6.10.  The problem has indeed existed with lockdep for some time but
only with the recent lockdep changes to generate a warning regardless
of debug kernel settings has it gone from just sketchy to having a fire
under it.  There's still an outstanding question of whether we
can/should insert as many pfns as we can during the fault[2] to reduce
the new overhead and hopefully at some point we'll have an even cleaner
option to use huge_fault for pfnmaps, but currently
vmf_insert_pfn_{pmd,pud} don't work with those pfnmaps.

So hopefully this problem disappears on current linux-next, but let me
know if there's still an issue.  Thanks,

Alex

[1]https://lore.kernel.org/all/20240530045236.1005864-1-alex.williamson@redhat.com/
[2]https://lore.kernel.org/all/20240607035213.2054226-1-alex.williamson@redhat.com/

> [  555.396773] ------------[ cut here ]------------
> [  555.396774] WARNING: CPU: 3 PID: 1424 at include/linux/rwsem.h:85 remap_pfn_range_notrack+0x625/0x650
> [  555.396778] Modules linked in: vfio_pci <-- 8< -->
> [  555.396877] CPU: 3 PID: 1424 Comm: vfio-test Tainted: G        W          6.10.0-rc1-niks-00007-gb19d6d864df1 #4 d09afec01ce27ca8218580af28295f25e2d2ed53
> [  555.396880] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./X570 Creator, BIOS P3.40 01/28/2021
> [  555.396881] RIP: 0010:remap_pfn_range_notrack+0x625/0x650
> [  555.396884] Code: a8 00 00 00 75 39 44 89 e0 48 81 c4 b0 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d e9 26 a7 e5 00 cc 0f 0b 41 bc ea ff ff ff eb c9 <0f> 0b 49 8b 47 10 e9 72 fa ff ff e8 8b 56 b5 ff e9 c0 fa ff ff e8
> [  555.396887] RSP: 0000:ffffaf8b04ed3bc0 EFLAGS: 00010246
> [  555.396889] RAX: ffff9ea747cfe300 RBX: 00000000000ee200 RCX: 0000000000000100
> [  555.396890] RDX: 00000000000ee200 RSI: ffff9ea747cfe300 RDI: ffff9ea76db58fd0
> [  555.396892] RBP: 00000000ffffffea R08: 8000000000000035 R09: 0000000000000000
> [  555.396894] R10: ffff9ea76d9bbf40 R11: ffffffff96e5ce50 R12: 0000000000004000
> [  555.396895] R13: 00007f23b988a000 R14: ffff9ea76db58fd0 R15: ffff9ea76db58fd0
> [  555.396897] FS:  00007f23b9561740(0000) GS:ffff9eb66e780000(0000) knlGS:0000000000000000
> [  555.396899] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  555.396901] CR2: 00007f23b988a008 CR3: 0000000136bde000 CR4: 0000000000350ef0
> [  555.396903] Call Trace:
> [  555.396904]  <TASK>
> [  555.396905]  ? __warn+0x18c/0x2a0
> [  555.396908]  ? remap_pfn_range_notrack+0x625/0x650
> [  555.396911]  ? report_bug+0x1bb/0x270
> [  555.396915]  ? handle_bug+0x42/0x70
> [  555.396917]  ? exc_invalid_op+0x1a/0x50
> [  555.396920]  ? asm_exc_invalid_op+0x1a/0x20
> [  555.396923]  ? __pfx_is_ISA_range+0x10/0x10
> [  555.396926]  ? remap_pfn_range_notrack+0x625/0x650
> [  555.396929]  ? asm_exc_invalid_op+0x1a/0x20
> [  555.396933]  ? track_pfn_remap+0x170/0x180
> [  555.396936]  remap_pfn_range+0x6f/0xc0
> [  555.396940]  vfio_pci_mmap_fault+0xf3/0x1b0 [vfio_pci_core 6df3b7ac5dcecb63cb090734847a65c799a8fef2]
> [  555.396946]  __do_fault+0x11b/0x210
> [  555.396949]  do_pte_missing+0x239/0x1350
> [  555.396953]  handle_mm_fault+0xb10/0x18b0
> [  555.396959]  do_user_addr_fault+0x293/0x710
> [  555.396963]  exc_page_fault+0x82/0x1c0
> [  555.396966]  asm_exc_page_fault+0x26/0x30
> [  555.396968] RIP: 0033:0x55b0ea8bb7ac
> [  555.396972] Code: 00 00 b0 00 e8 e5 f8 ff ff 31 c0 48 83 c4 20 5d c3 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 48 89 7d f8 48 8b 45 f8 <8b> 00 89 c0 5d c3 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48
> [  555.396974] RSP: 002b:00007fff80973530 EFLAGS: 00010202
> [  555.396976] RAX: 00007f23b988a008 RBX: 00007fff80973738 RCX: 00007f23b988a000
> [  555.396978] RDX: 0000000000000001 RSI: 00007fff809735e8 RDI: 00007f23b988a008
> [  555.396979] RBP: 00007fff80973530 R08: 0000000000000005 R09: 0000000000000000
> [  555.396981] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000002
> [  555.396982] R13: 0000000000000000 R14: 00007f23b98c8000 R15: 000055b0ea8bddc0
> [  555.396986]  </TASK>
> [  555.396987] ---[ end trace 0000000000000000 ]---
> 


