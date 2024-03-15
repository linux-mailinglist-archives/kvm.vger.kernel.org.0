Return-Path: <kvm+bounces-11933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 91DA987D39A
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 19:29:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F9732818E3
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 18:29:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6461C50249;
	Fri, 15 Mar 2024 18:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3hLQDDI+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C234EB5F
	for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 18:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710527380; cv=none; b=HI++OONASHsIJ2NSszK6HwsxMbKW57S67hlFh7jRk/pm2tRdYEeQok8vVD4/IB31ly2AC6C6TWEv6ntyVvXilr+HW5CXE6dnFrDB1DGBNAnuIkbZRIL6GM2cjPRGZ//RAfGZ0AWwmTrRtXv2dNYtHevvxFP77CeQTCwuWeo6AKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710527380; c=relaxed/simple;
	bh=KUHOP8ehexowNIEsOotntCAdUefMeTgT8ndPqIvacRI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NBapMfoL2NR/4ATd88myzcWQAPPO79JqgJaVOyCbdUts7PtUIiUilytjsPIbtcO56rVCyvvqFc1CXvTEh+ceE5I7VRB+PXV6JadQqqPPrt4TNEGwqD1E/nqZEGiG2XHEjZqOfkEvF8Q5Y3icWJ22x2EHQ1PcRl3cBojK74Poxj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3hLQDDI+; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6e6ca8c8be2so2138289b3a.1
        for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 11:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710527376; x=1711132176; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8Yx8GBGZtm8giG+I86hNAaIO2ye/1iwJfeXfUGn8W+g=;
        b=3hLQDDI+eEN3UTYekutR7sByJhxPou0i4tE2YGyQVOIZHWDIIHm4Zw7hynNsICviyr
         zlKN76yJ3PiWSPj7NiT1q65DGOXLcovhqrKNS7Veb9FfdV+0zZ8P57O3iNLvqWYURdQq
         IBuAd6069dIf4ZQh44QOO7ToDMXrhnYgflh+g67Kti/ohCcbiB8pfeKkxQs0ODMWQl7A
         /2b+r8EgyK7cvFoPV2voZr8WxXUk6U6Q9fEUg9/9PMiau8ThgSvjM1YNWvq2rx4BeAbg
         sSpRlSJGTDO9oRMfSAeuYg5J2HtpDf7chDJ7TRgpxcfPg/iwKSe++QghZysiop9LaG3C
         IZkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710527376; x=1711132176;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8Yx8GBGZtm8giG+I86hNAaIO2ye/1iwJfeXfUGn8W+g=;
        b=CYLj6sJYuIhHzBa+zGwgyEFByJWcOAHADdBl8dm1P15Tn/4g8FhpXtzaECDOH/dMho
         xPNrIn1kt03zU4xeQiaNVgg6PuiqK21uwkfN3btx+xtdjQO9hIhZHBxEkmUHZxvHvjsQ
         ciO1QNSGsdHokKKQbCCIwetFXFdRZs3nz8UhvcmO/3bir08kVG/Jr1ysraTSttmd/td+
         oejneKPvUGtZv3wwSYjB09W/1szRGaG4GfiQ5vHnp5uRpqavhgH053jv6fLU1NoZM9HE
         JQ9M/u+gTlbgiV0QTtZUOohfYbEnLxq+H1hVs0tuQeKII5vDhg+FcDeibRzbaCs6Xixx
         fdJw==
X-Forwarded-Encrypted: i=1; AJvYcCVJFlHyeIjqiJwi3UEZhnJiDzvOOkj/cEc6wGyDgaiL92gK/1a5UiIJ62Ru4RpbmlOnmw3HNIk8qvDguDZ9+wpRfQMa
X-Gm-Message-State: AOJu0YweRXMI2In8M6sYCLEnL3kGJy02AgNMPzSx8/Z1JNJI53PYg62a
	8wIXdI1U9yHbNJnWqvbRmHg1aDyVnu4W0cw2KCsJRGc4f9+SLtEqDqi9A82YgQ==
X-Google-Smtp-Source: AGHT+IHf+8j7zKnvwbaJH/TUrJOU+u8aCZhENiidgnodEi0/+PKq1PeMhJI52e2EQ4QfYyAqDADIhg==
X-Received: by 2002:a05:6a00:3d0d:b0:6e6:9f29:fc43 with SMTP id lo13-20020a056a003d0d00b006e69f29fc43mr7068182pfb.12.1710527375893;
        Fri, 15 Mar 2024 11:29:35 -0700 (PDT)
Received: from google.com (61.139.125.34.bc.googleusercontent.com. [34.125.139.61])
        by smtp.gmail.com with ESMTPSA id dr23-20020a056a020fd700b005d67862799asm2480674pgb.44.2024.03.15.11.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 11:29:33 -0700 (PDT)
Date: Fri, 15 Mar 2024 11:29:27 -0700
From: David Matlack <dmatlack@google.com>
To: syzbot <syzbot+900d58a45dcaab9e4821@syzkaller.appspotmail.com>
Cc: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
	pbonzini@redhat.com, seanjc@google.com,
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org,
	vipinsh@google.com
Subject: Re: [syzbot] [kvm?] WARNING in clear_dirty_gfn_range
Message-ID: <ZfSTh4bLuAMlF6Er@google.com>
References: <000000000000c6526f06137f18cc@google.com>
 <CALzav=euH_n9WXG29CFd10urh85O4Mw2L=StEizVmh27CYzrtQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALzav=euH_n9WXG29CFd10urh85O4Mw2L=StEizVmh27CYzrtQ@mail.gmail.com>

On 2024-03-15 11:07 AM, David Matlack wrote:
> On Tue, Mar 12, 2024 at 4:34 PM syzbot
> <syzbot+900d58a45dcaab9e4821@syzkaller.appspotmail.com> wrote:
> >
> > ------------[ cut here ]------------
> > WARNING: CPU: 1 PID: 5165 at arch/x86/kvm/mmu/tdp_mmu.c:1526 clear_dirty_gfn_range+0x3d6/0x540 arch/x86/kvm/mmu/tdp_mmu.c:1526
> > Modules linked in:
> > CPU: 1 PID: 5165 Comm: syz-executor417 Not tainted 6.8.0-syzkaller-01185-g855684c7d938 #0
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> > RIP: 0010:clear_dirty_gfn_range+0x3d6/0x540 arch/x86/kvm/mmu/tdp_mmu.c:1526
> > Call Trace:
> >  <TASK>
> >  kvm_tdp_mmu_clear_dirty_slot+0x24f/0x2e0 arch/x86/kvm/mmu/tdp_mmu.c:1557
> >  kvm_mmu_slot_leaf_clear_dirty+0x38b/0x490 arch/x86/kvm/mmu/mmu.c:6783
> >  kvm_mmu_slot_apply_flags arch/x86/kvm/x86.c:12962 [inline]
> >  kvm_arch_commit_memory_region+0x299/0x490 arch/x86/kvm/x86.c:13031
> >  kvm_commit_memory_region arch/x86/kvm/../../../virt/kvm/kvm_main.c:1751 [inline]
> >  kvm_set_memslot+0x4d3/0x13e0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1994
> >  __kvm_set_memory_region arch/x86/kvm/../../../virt/kvm/kvm_main.c:2129 [inline]
> >  __kvm_set_memory_region+0xdbc/0x1520 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2020
> >  kvm_set_memory_region arch/x86/kvm/../../../virt/kvm/kvm_main.c:2150 [inline]
> >  kvm_vm_ioctl_set_memory_region arch/x86/kvm/../../../virt/kvm/kvm_main.c:2162 [inline]
> >  kvm_vm_ioctl+0x151c/0x3e20 arch/x86/kvm/../../../virt/kvm/kvm_main.c:5152
> 
> The reproducer uses nested virtualization to launch an L2 with EPT
> disabled. This creates a TDP MMU root with role.guest_mode=1, which
> triggers the WARN_ON() in kvm_tdp_mmu_clear_dirty_slot() because
> kvm_mmu_page_ad_need_write_protect() returns false whenever PML is
> enabled and the shadow page role.guest_mode=1.
> 
> If I'm reading prepare_vmcs02_constant_state() correctly, we always
> disable PML when running in L2. So when enable_pml=1 and L2 runs with
> EPT disabled we are blind to dirty tracking L2 accesses.

+Vipin

I believe this was introduced by 6.4 commit 5982a5392663 ("KVM: x86/mmu:
Use kvm_ad_enabled() to determine if TDP MMU SPTEs need wrprot").

I see two options to fix:

  1. Allow PML to be enabled when L2 is running with EPT is disabled.
  2. Fix the TDP MMU logic to write-protect role.guest_mode=1 SPTEs.

(1.) sounds more complicated and will require more testing. (2.) is
quite simple since an entire TDP MMU tree is either guest_mode=0 or
guest_mode=1.

Example fix (fixes syzbot repro but otherwise untested):

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6ae19b4ee5b1..eb6fb8d9c00c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1498,6 +1498,24 @@ void kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
 	}
 }
 
+static inline u64 tdp_mmu_dirty_bit(struct kvm_mmu_page *root, bool force_wrprot)
+{
+	if (force_wrprot || kvm_mmu_page_ad_need_write_protect(root) || !kvm_ad_enabled())
+		return PT_WRITABLE_MASK;
+
+	return shadow_dirty_mask;
+}
+
+static inline bool tdp_mmu_dirty_bit_invalid_for_spte(struct tdp_iter *iter, u64 dbit)
+{
+	/*
+	 * The decision of whether to clear the D-bit or W-bit is made based on
+	 * the root, as all TDP MMU SPTEs within a root should require the same
+	 * modifications. This check ensures that is actually the case.
+	 */
+	return dbit == shadow_dirty_mask && spte_ad_need_write_protect(iter->old_spte);
+}
+
 /*
  * Clear the dirty status of all the SPTEs mapping GFNs in the memslot. If
  * AD bits are enabled, this will involve clearing the dirty bit on each SPTE.
@@ -1508,7 +1526,7 @@ void kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
 static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			   gfn_t start, gfn_t end)
 {
-	u64 dbit = kvm_ad_enabled() ? shadow_dirty_mask : PT_WRITABLE_MASK;
+	u64 dbit = tdp_mmu_dirty_bit(root, false);
 	struct tdp_iter iter;
 	bool spte_set = false;
 
@@ -1523,8 +1541,7 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
 
-		KVM_MMU_WARN_ON(kvm_ad_enabled() &&
-				spte_ad_need_write_protect(iter.old_spte));
+		KVM_MMU_WARN_ON(tdp_mmu_dirty_bit_invalid_for_spte(&iter, dbit));
 
 		if (!(iter.old_spte & dbit))
 			continue;
@@ -1570,8 +1587,7 @@ bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm,
 static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 				  gfn_t gfn, unsigned long mask, bool wrprot)
 {
-	u64 dbit = (wrprot || !kvm_ad_enabled()) ? PT_WRITABLE_MASK :
-						   shadow_dirty_mask;
+	u64 dbit = tdp_mmu_dirty_bit(root, wrprot);
 	struct tdp_iter iter;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
@@ -1583,8 +1599,7 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 		if (!mask)
 			break;
 
-		KVM_MMU_WARN_ON(kvm_ad_enabled() &&
-				spte_ad_need_write_protect(iter.old_spte));
+		KVM_MMU_WARN_ON(tdp_mmu_dirty_bit_invalid_for_spte(&iter, dbit));
 
 		if (iter.level > PG_LEVEL_4K ||
 		    !(mask & (1UL << (iter.gfn - gfn))))

