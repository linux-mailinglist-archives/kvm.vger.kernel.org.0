Return-Path: <kvm+bounces-30824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C7A6F9BDAEC
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 02:08:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6D4C7B21245
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 01:08:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EC53176AC8;
	Wed,  6 Nov 2024 01:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UG26ljVa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F5C6088F
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 01:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855327; cv=none; b=WSSN4XwMoeA28klBxpXobz2F/jluRQhcDqjIJd8J+sW0Ux0XLTfc4oMZqZI0TRW99YTu4sKTCylDT9mib1AmPlOHYHzOu7VUt9wRWyLnU4EzYLWy75Iybx9LFFclcss4BEabvbdHaWZ6/QvYHhof5LQg4sznsRhxswmP1W9D18k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855327; c=relaxed/simple;
	bh=x7qQsnnVw4bPxyLG+CE9kBQPkeGC1GJpqcxEHiYft0g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=begqdAeSzIH1hb1tr5ejx+Q4cHdhi1UVHEbptsWQw5foikyRx5y8S9UzzQj8p13dBmIwocP8Su/IonX82OMeILV5ZyVh/9+qD/u4tn9xzonsEoxV/06WLyzFGfwnT+WWidWFEG3GfZizJngd2AedNCsHVJmhvGpEKrsup66Bl2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UG26ljVa; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6ea6aa3b68bso77584937b3.3
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 17:08:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730855325; x=1731460125; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UMgtJ0KzOhmo9rIc3kh4+kOac/nNqUwcudzaP6/Cffs=;
        b=UG26ljValdw9unrCFFTKRD078DHF7FM5gl12fqgBg+QkZCXozBRUjZHndXn6RQjXXy
         f4cRZq9myn9drAALoN0dr2Ujm2ROCARbVTEvjxYkDMhXDP6eUQQJG/Yi0WoMIREpOt3d
         rTEx11udNH1QVRb7ma0My++gHfX6M3AJ89NAj5LF/sXNpcUomsVp8cCmAJsOFzj7yX0e
         u9OBTgerNENQ5rLnSU/rMgzOz14aJe77vYCZDGZurIzR5/Krg1uA4shGXs5qMiQ3QRLY
         WxlPTblaYByVmK54qopVDLKUJ+RVBhG03oGZFkK/nkGYKk0kW+JteGsaDC+enjhv6l4q
         jSZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730855325; x=1731460125;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UMgtJ0KzOhmo9rIc3kh4+kOac/nNqUwcudzaP6/Cffs=;
        b=OyDpEwGu3e9/XCMKwCvb2WtUSGqbdOs7O5K8cCMjt5jEQ4ydhGYzRrVN5mTvcbeIzH
         8iznLeExo25K6brZotwmW/nRFrp4+MgurO7OBuU9bHaE47DB4u2ZmEDL7eEahrPgHiZ0
         9hi/cDyGTs6wtC+c2N3TOORehrsxXJeWKoee6uV69YXKFpHKDV9TXq+uKPnr5mHBhXyz
         Vwlsj484OVeLyPMDuNbN3HJJAnl+KWt0OrkolvfqTMBy0dY+nzQSEqvSM+W3NYKmipNa
         9qzjb8LdWPCe9V/undWZVofoaisS3eo8phXhSqu1vJ8d0LfUy4lxjWf2VgbevcOska0S
         iHNw==
X-Forwarded-Encrypted: i=1; AJvYcCXanSDtpAKShgyxBDTWVcDK35DrjCcj/MTHZCaqjHaijJE25Wm0c7FWUmwT0Z7+XIaPzjQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBbf9dPc2T2ZAgTSMIYbHKsvU5dbIHfVIu6qOsEwky9GT8TSi1
	td2PpVJ2EapgHsPLPtldSX3ru1Ergv35G6oQyH7Vx0zwaoUKqIVW6S19glhoqRxNba49nXTCFhx
	5xg==
X-Google-Smtp-Source: AGHT+IGX5AnXwVptVRYCTmYijITYZQXNG5Ljn81Ng3J/Wc79SvOmCCyPXICY2sJgH0SuFzxPk+mYHO6MGJ0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:4c09:b0:6db:b2ed:7625 with SMTP id
 00721157ae682-6ea521c92b4mr1265787b3.0.1730855324900; Tue, 05 Nov 2024
 17:08:44 -0800 (PST)
Date: Tue, 5 Nov 2024 17:08:43 -0800
In-Reply-To: <20241105105248.812dc586921df56e5bf78a5e@linux-foundation.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <6729f475.050a0220.701a.0019.GAE@google.com> <20241105105248.812dc586921df56e5bf78a5e@linux-foundation.org>
Message-ID: <ZyrBmwxOa0ewvh3n@google.com>
Subject: Re: [syzbot] [mm?] BUG: Bad page state in kvm_coalesced_mmio_init
From: Sean Christopherson <seanjc@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: syzbot <syzbot+e985d3026c4fd041578e@syzkaller.appspotmail.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 05, 2024, Andrew Morton wrote:
> (cc kvm list)
> 
> On Tue, 05 Nov 2024 02:33:25 -0800 syzbot <syzbot+e985d3026c4fd041578e@syzkaller.appspotmail.com> wrote:
> 
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    59b723cd2adb Linux 6.12-rc6
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=17996587980000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=11254d3590b16717
> > dashboard link: https://syzkaller.appspot.com/bug?extid=e985d3026c4fd041578e
> > compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> > userspace arch: i386
> > 
> > Unfortunately, I don't have any reproducer for this issue yet.
> > 
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/202d791be971/disk-59b723cd.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/9bfa02908d87/vmlinux-59b723cd.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/93c8c8740b4d/bzImage-59b723cd.xz
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+e985d3026c4fd041578e@syzkaller.appspotmail.com
> > 
> > BUG: Bad page state in process syz.5.504  pfn:61f45
> > page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x61f45
> > flags: 0xfff00000080204(referenced|workingset|mlocked|node=0|zone=1|lastcpupid=0x7ff)
> > raw: 00fff00000080204 0000000000000000 dead000000000122 0000000000000000
> > raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
> > page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
> > page_owner tracks the page as allocated
> > page last allocated via order 0, migratetype Unmovable, gfp_mask 0x400dc0(GFP_KERNEL_ACCOUNT|__GFP_ZERO), pid 8443, tgid 8442 (syz.5.504), ts 201884660643, free_ts 201499827394
> >  set_page_owner include/linux/page_owner.h:32 [inline]
> >  post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1537
> >  prep_new_page mm/page_alloc.c:1545 [inline]
> >  get_page_from_freelist+0x303f/0x3190 mm/page_alloc.c:3457
> >  __alloc_pages_noprof+0x292/0x710 mm/page_alloc.c:4733
> >  alloc_pages_mpol_noprof+0x3e8/0x680 mm/mempolicy.c:2265
> >  kvm_coalesced_mmio_init+0x1f/0xf0 virt/kvm/coalesced_mmio.c:99
> >  kvm_create_vm virt/kvm/kvm_main.c:1235 [inline]
> >  kvm_dev_ioctl_create_vm virt/kvm/kvm_main.c:5488 [inline]
> >  kvm_dev_ioctl+0x12dc/0x2240 virt/kvm/kvm_main.c:5530
> >  __do_compat_sys_ioctl fs/ioctl.c:1007 [inline]
> >  __se_compat_sys_ioctl+0x510/0xc90 fs/ioctl.c:950
> >  do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
> >  __do_fast_syscall_32+0xb4/0x110 arch/x86/entry/common.c:386
> >  do_fast_syscall_32+0x34/0x80 arch/x86/entry/common.c:411
> >  entry_SYSENTER_compat_after_hwframe+0x84/0x8e

...

> > If the report is a duplicate of another one, reply with:
> > #syz dup: exact-subject-of-another-report

There's already a proposed fix (and long discussion) for this issue[*], but AFAIK
there's no upstream visible report to dup this against.  Ah, yep, looks like Roman
was working off a Google-internal report.  I'll point him at this one.

[*] https://lore.kernel.org/all/20241021164837.2681358-1-roman.gushchin@linux.dev

