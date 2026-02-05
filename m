Return-Path: <kvm+bounces-70373-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yAbVOAkRhWms7wMAu9opvQ
	(envelope-from <kvm+bounces-70373-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 22:52:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 40E07F7E96
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 22:52:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 75F4F3007A67
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 21:52:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA2DD33469D;
	Thu,  5 Feb 2026 21:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zo6B4CDz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FCD29BDA2
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 21:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770328323; cv=none; b=skYhKR9Evb98RW3cpzsYyIhjj5rMNqSUoLkcEeS+qtJdNKQmg6JPMZBgLEHRZfInmwIfEH663RYDC5/77c6k2zYkEcBzpcDyIg0LTD0miVDH7mm204egcKYhHmlHukLkrpm0GHb0RTzbud91k3T988G9Mv07p2As6Ehpp11k9cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770328323; c=relaxed/simple;
	bh=F3aKZ/fCnbB9EJmonJjgo8SU4XqpJqBtz1yAs+j9ReM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HQy07cWOzcRvwqIkxTlwcBQZo5M2mqMoMAs37bQnMFUlu1jblKiuYEWT/CG7l8pdGgZKoPhvbKRSNlV/FfqwaX7FymfA3GfueXJF7JtDvXxRxvXvwlpMtMDvU+VRAuPKbb8XQ7KGv8WXz6iXyWQZDOzdlSwBxK8IgG90B30JOuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zo6B4CDz; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2a7bceb6cd0so9996275ad.1
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 13:52:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770328322; x=1770933122; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kGsy+6Drt04/pl8yx93tFPhkkWQllmpTFtK5bY5HHKI=;
        b=zo6B4CDzOGlGXmOvjRL/lMANxUl4N3LMS16xfUwXnMDXBRpMnGEinBZG1yN/mavVSw
         MTOWp8oegko5eCOezR1SJM1kCtufF6NHEIOFYVHg+GepYMQOiCONJ3ifcuu+bI8eAJob
         6Epvs0Wu1jhWY6wHu07KTyaT60sIr5iyHZ52B5Glvll1bS3PJ6OroCThuWBY5guYqPLo
         f/MeNo80xp+wwRexTgW6BRwFeowC2JyzoCJl+c8i9NVJBmm/NwWN7T0s5Voj/iChYd3e
         2m0mzBvEDC4SAf7/KVnyi1TaV2q/msHAIjFZFpM/xFW31TTaOImHR/Y0ilU1Fh+eeJXU
         QHOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770328322; x=1770933122;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kGsy+6Drt04/pl8yx93tFPhkkWQllmpTFtK5bY5HHKI=;
        b=UnodV2dw4ijHok9mswy/l8U0wxNcBx1zFvp4om1tMxNbiTMBmNNGjUjW8NUBPwzgy9
         u7EYwLyX4A85kZBUcVU2N8UoSpDBUmsOKuUdALfmUlMftM6PeSETfeBpUkusOO+jPRbO
         rILPtSqCBTGsbOZGA9CW/OuX4muOSJSM6miQlx8CRUPFO0arFiKt01ieQsTKSEEtvDpG
         0psdZXv2p/L9+Cjnr/SVZ9YEF4CMuK9lLta3nUhbVY4V4ORMnIs8wn69xD1zLDMKC7m4
         4koPrk7Svo0UmRUcHsJkx/r1k1p9pIxkY9AeDB7qw1lGvTNPq9anb8uVQdAwjC49H7Xi
         s7Vg==
X-Forwarded-Encrypted: i=1; AJvYcCUhZeMZUrE/9UdUaSrvRu4tdHPI7liJTsNIPOBAB0lhNFZBVIhFf55VbDDDC4AcRjq0/4o=@vger.kernel.org
X-Gm-Message-State: AOJu0YytqbRSuM9PszXBF+TBF+8q9cUYa3hXPQ0SeJtvpBleAo8jrxA2
	poS9UXEEtgw3zX1FyP2ZIYZ5P9Ag4OC7cTpZWFItwfDqpJA+Vr/XZ8jGO+fFDUfmmg==
X-Gm-Gg: AZuq6aLij3oTS2+qpQaSX+zh7NZckRWs67bpdOtt3UGxGYFrlwBLYFWaJVIPX1tAq3H
	pwhSad3ZKBo0MBgQhqqztwiw/kp1NIFi8yEhHzUDq/QfnEp3+G5yIidv72w5pAzE7gg13od+cCc
	CtKgjlhwidasEm4VjsHOZ3/QZZMBnQjDqlL0VN9BmtXDCy5j5byuBkyOtzyL2ztfnl98TXmEsFB
	AoabkaaEpp+38ryDi8XNaHDpS9Sabzj+R7ShrC+11w+7Cjj+nvKrzLpGBRMDl4SfsjgsleW68uD
	stuEFw2a8aZKgsqn2NjY2ELdIGq3xtrQFa4Q0LeACtjkFeyXG7E214oSVE2WuPUMORfqlTeYYre
	qAl44/9SYx/4R1jnDhEkL4JlZty4XKeT9+s0HDO6GxjAHnyU0LEggx/SEX4JhXIimNG7RBumoqQ
	uMtAA2GtcMYHJd4AvNnPYX2fyPDaXLmKCOEaSfSMiaOOAWLwwoiA==
X-Received: by 2002:a17:902:c94b:b0:2a1:deb:c460 with SMTP id d9443c01a7336-2a9516d3e0cmr5394585ad.33.1770328321980;
        Thu, 05 Feb 2026 13:52:01 -0800 (PST)
Received: from google.com (79.217.168.34.bc.googleusercontent.com. [34.168.217.79])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a9521b9f5esm3197445ad.51.2026.02.05.13.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 13:52:01 -0800 (PST)
Date: Thu, 5 Feb 2026 21:51:56 +0000
From: David Matlack <dmatlack@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH v2 6/6] vfio: selftests: Add tests to validate SR-IOV UAPI
Message-ID: <aYUQ_HkDJU9kjsUl@google.com>
References: <20251210181417.3677674-1-rananta@google.com>
 <20251210181417.3677674-7-rananta@google.com>
 <aUSNoBzvybi24SUD@google.com>
 <CAJHc60zAB8pyc7=ca=eOf+SEEvnZ3JxVEnZoOtgj+mX1GQiALw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJHc60zAB8pyc7=ca=eOf+SEEvnZ3JxVEnZoOtgj+mX1GQiALw@mail.gmail.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-70373-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 40E07F7E96
X-Rspamd-Action: no action

On 2026-01-06 11:47 AM, Raghavendra Rao Ananta wrote:
> On Thu, Dec 18, 2025 at 3:26 PM David Matlack <dmatlack@google.com> wrote:
> >
> > On 2025-12-10 06:14 PM, Raghavendra Rao Ananta wrote:
> > > Add a selfttest, vfio_pci_sriov_uapi_test.c, to validate the
> > > SR-IOV UAPI, including the following cases, iterating over
> > > all the IOMMU modes currently supported:
> > >  - Setting correct/incorrect/NULL tokens during device init.
> > >  - Close the PF device immediately after setting the token.
> > >  - Change/override the PF's token after device init.
> > >
> > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> >
> > I hit the following kernel NULL pointer dereference after running the
> > new test a few times (nice!).
> >
> > Repro:
> >
> >   $ tools/testing/selftests/vfio/scripts/setup.sh 0000:16:00.1
> >   $ tools/testing/selftests/vfio/vfio_pci_sriov_uapi_test 0000:16:00.1
> >   $ tools/testing/selftests/vfio/scripts/cleanup.sh
> >   ... repeat ...
> >
> > The panic:
> >
> > [  553.245784][T27601] vfio-pci 0000:1a:00.0: probe with driver vfio-pci failed with error -22
> > [  553.256622][T27601] vfio-pci 0000:1a:00.0: probe with driver vfio-pci failed with error -22
> > [  574.857650][T27935] BUG: kernel NULL pointer dereference, address: 0000000000000008
> > [  574.865322][T27935] #PF: supervisor read access in kernel mode
> > [  574.871175][T27935] #PF: error_code(0x0000) - not-present page
> > [  574.877021][T27935] PGD 4116e63067 P4D 40fb0a3067 PUD 409597f067 PMD 0
> > [  574.883654][T27935] Oops: Oops: 0000 [#1] SMP NOPTI
> > [  574.888551][T27935] CPU: 100 UID: 0 PID: 27935 Comm: vfio_pci_sriov_ Tainted: G S      W           6.18.0-smp-DEV #1 NONE
> > [  574.899600][T27935] Tainted: [S]=CPU_OUT_OF_SPEC, [W]=WARN
> > [  574.905104][T27935] Hardware name: Google Izumi-EMR/izumi, BIOS 0.20250801.2-0 08/25/2025
> > [  574.913289][T27935] RIP: 0010:rb_insert_color+0x44/0x110
> > [  574.918623][T27935] Code: cc cc 48 89 cf 48 83 cf 01 48 89 3a 48 89 38 48 8b 01 48 89 cf 48 83 e0 fc 48 89 01 74 d7 48 8b 08 f6 c1 01 0f 85 c1 00 00 00 <48> 8b 51 08 48 39 c2 74 0c 48 85 d2 74 4f f6 02 01 74 c5 eb 48 48
> > [  574.938080][T27935] RSP: 0018:ff85113dcdd6bb08 EFLAGS: 00010046
> > [  574.944013][T27935] RAX: ff3f257594a99e80 RBX: ff3f25758af490c0 RCX: 0000000000000000
> > [  574.951857][T27935] RDX: 0000000000001a00 RSI: ff3f25360038eb70 RDI: ff3f2536658bbee0
> > [  574.959702][T27935] RBP: ff3f25360038ea00 R08: 0000000000000002 R09: ff85113dcdd6badc
> > [  574.967544][T27935] R10: ff3f257590ab8000 R11: ffffffffa78210a0 R12: ff3f2536658bbea0
> > [  574.975387][T27935] R13: 0000000000000286 R14: ff3f25758af49000 R15: ff3f25360038eb78
> > [  574.983230][T27935] FS:  00000000223403c0(0000) GS:ff3f25b4d4d83000(0000) knlGS:0000000000000000
> > [  574.992032][T27935] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [  574.998488][T27935] CR2: 0000000000000008 CR3: 00000040fa254005 CR4: 0000000000f71ef0
> > [  575.006332][T27935] PKRU: 55555554
> > [  575.009753][T27935] Call Trace:
> > [  575.012919][T27935]  <TASK>
> > [  575.015730][T27935]  intel_iommu_probe_device+0x4c9/0x7b0
> > [  575.021153][T27935]  __iommu_probe_device+0x101/0x4c0
> > [  575.026231][T27935]  iommu_bus_notifier+0x37/0x100
> > [  575.031046][T27935]  blocking_notifier_call_chain+0x53/0xd0
> > [  575.036634][T27935]  bus_notify+0x99/0xc0
> > [  575.040666][T27935]  device_add+0x252/0x470
> > [  575.044872][T27935]  pci_device_add+0x414/0x5c0
> > [  575.049429][T27935]  pci_iov_add_virtfn+0x2f2/0x3e0
> > [  575.054326][T27935]  sriov_add_vfs+0x33/0x70
> > [  575.058613][T27935]  sriov_enable+0x2fc/0x490
> > [  575.062992][T27935]  vfio_pci_core_sriov_configure+0x16c/0x210
> > [  575.068843][T27935]  sriov_numvfs_store+0xc4/0x190
> > [  575.073652][T27935]  kernfs_fop_write_iter+0xfe/0x180
> > [  575.078724][T27935]  vfs_write+0x2d0/0x430
> > [  575.082846][T27935]  ksys_write+0x7f/0x100
> > [  575.086965][T27935]  do_syscall_64+0x6f/0x940
> > [  575.091339][T27935]  ? arch_exit_to_user_mode_prepare+0x9/0xb0
> > [  575.097193][T27935]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

I think this is a use-after-free.

The VF used in this test matches quirk_intel_e2000_no_ats() which means
that ATS gets disabled (pdev->ats_cap = 0) via quirk after the device is
set up.

 drivers/pci/quirks.c:

 5651 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x1457, quirk_intel_e2000_no_ats);

The issue is this quirk is applied after the Intel IOMMU driver is
notified about the device.

So during intel_iommu_probe_device(), the Intel IOMMU driver sees that
ATS is enabled, and adds the device to the device rbtree:

 drivers/iommu/intel/iommu.c:

 3765 static struct iommu_device *intel_iommu_probe_device(struct device *dev)
 3766 {
 ...
 3826         if (pdev && pci_ats_supported(pdev)) {
 3827                 pci_prepare_ats(pdev, VTD_PAGE_SHIFT);
 3828                 ret = device_rbtree_insert(iommu, info);
 3829                 if (ret)
 3830                         goto free;
 3831         }
 ...
 3858 }


Then ATS is disabled via quirk:

 drivers/pci/iov.c:

 346 int pci_iov_add_virtfn(struct pci_dev *dev, int id)
 347 {
 ...
 383
 384         pci_device_add(virtfn, virtfn->bus);  <======= notifies Intel IOMMU
 385         rc = pci_iov_sysfs_link(dev, virtfn, id);
 386         if (rc)
 387                 goto failed1;
 388
 389         pci_bus_add_device(virtfn);  <==== Disables ATS via pci_fixup_final
 390
 391         return 0;
 ...
 401 }

Then later when the VF is destroyed (SR-IOV disabled on the PF), the
Intel IOMMU sees that ATS is disabled and does not remove the device
from its rbtree.

 drivers/iommu/intel/iommu.c:

 3889 static void intel_iommu_release_device(struct device *dev)
 3890 {
 ...
 3903         if (dev_is_pci(dev) && pci_ats_supported(to_pci_dev(dev)))
 3904                 device_rbtree_remove(info);
 ...
 3913         kfree(info);   <======= info is still reachable from device rbtree
 3914 }

