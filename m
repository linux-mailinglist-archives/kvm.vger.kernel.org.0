Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07B9B969EF
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 22:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730775AbfHTUDW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Aug 2019 16:03:22 -0400
Received: from mga04.intel.com ([192.55.52.120]:13894 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728283AbfHTUDV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Aug 2019 16:03:21 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Aug 2019 13:03:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,408,1559545200"; 
   d="scan'208,223";a="169197661"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 20 Aug 2019 13:03:19 -0700
Date:   Tue, 20 Aug 2019 13:03:19 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Xiao Guangrong <guangrong.xiao@gmail.com>
Subject: Re: [PATCH v2 11/27] KVM: x86/mmu: Zap only the relevant pages when
 removing a memslot
Message-ID: <20190820200318.GA15808@linux.intel.com>
References: <20190205205443.1059-1-sean.j.christopherson@intel.com>
 <20190205210137.1377-11-sean.j.christopherson@intel.com>
 <20190813100458.70b7d82d@x1.home>
 <20190813170440.GC13991@linux.intel.com>
 <20190813115737.5db7d815@x1.home>
 <20190813133316.6fc6f257@x1.home>
 <20190813201914.GI13991@linux.intel.com>
 <20190815092324.46bb3ac1@x1.home>
 <a05b07d8-343b-3f3d-4262-f6562ce648f2@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <a05b07d8-343b-3f3d-4262-f6562ce648f2@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 19, 2019 at 06:03:05PM +0200, Paolo Bonzini wrote:
> On 15/08/19 17:23, Alex Williamson wrote:
> > 0xffe00
> > 0xfee00
> > 0xfec00
> > 0xc1000
> > 0x80a000
> > 0x800000
> > 0x100000
> > 
> > ie. I can effective only say that sp->gfn values of 0x0, 0x40000, and
> > 0x80000 can take the continue branch without seeing bad behavior in the
> > VM.
> > 
> > The assigned GPU has BARs at GPAs:
> > 
> > 0xc0000000-0xc0ffffff
> > 0x800000000-0x808000000
> > 0x808000000-0x809ffffff
> > 
> > And the assigned companion audio function is at GPA:
> > 
> > 0xc1080000-0xc1083fff
> > 
> > Only one of those seems to align very well with a gfn base involved
> > here.  The virtio ethernet has an mmio range at GPA 0x80a000000,
> > otherwise I don't find any other I/O devices coincident with the gfns
> > above.
> 
> The IOAPIC and LAPIC are respectively gfn 0xfec00 and 0xfee00.  The
> audio function BAR is only 16 KiB, so the 2 MiB PDE starting at 0xc1000
> includes both userspace-MMIO and device-MMIO memory.  The virtio-net BAR
> is also userspace-MMIO.
> 
> It seems like the problem occurs when the sp->gfn you "continue over"
> includes a userspace-MMIO gfn.  But since I have no better ideas right
> now, I'm going to apply the revert (we don't know for sure that it only
> happens with assigned devices).

After many hours of staring, I've come to the conclusion that
kvm_mmu_invalidate_zap_pages_in_memslot() is completely broken, i.e.
a revert is definitely in order for 5.3 and stable.

mmu_page_hash is indexed by the gfn of the shadow pages, not the gfn of
the shadow ptes, e.g. for_each_valid_sp() will find page tables, page
directories, etc...  Passing in the raw gfns of the memslot doesn't work
because the gfn isn't properly adjusted/aligned to match how KVM tracks
gfns for shadow pages, e.g. removal of the companion audio memslot that
occupies gfns 0xc1080 - 0xc1083 would need to query gfn 0xc1000 to find
the shadow page table containing the relevant sptes.

This is why Paolo's suggestion to remove slot_handle_all_level() on
kvm_zap_rmapp() caused a BUG(), as zapping the rmaps cleaned up KVM's
accounting without actually zapping the relevant sptes.

All that being said, it doesn't explain why gfns like 0xfec00 and 0xfee00
were sensitive to (lack of) zapping.  My theory is that zapping what were
effectively random-but-interesting shadow pages cleaned things up enough
to avoid noticeable badness.


Alex,

Can you please test the attached patch?  It implements a very slimmed down
version of kvm_mmu_zap_all() to zap only shadow pages that can hold sptes
pointing at the memslot being removed, which was the original intent of
kvm_mmu_invalidate_zap_pages_in_memslot().  I apologize in advance if it
crashes the host.  I'm hopeful it's correct, but given how broken the
previous version was, I'm not exactly confident.

--mP3DRpeJDSE+ciuQ
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-KVM-x86-MMU-Rewrite-zapping-pages-in-memslot-to-fix-.patch"

From 90e4b3dcb33a52da267f1099289ec7b71ad6a975 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Tue, 20 Aug 2019 12:00:13 -0700
Subject: [PATCH] KVM: x86/MMU: Rewrite zapping pages in memslot to fix major
 flaws

TODO: write a proper changelog if this actually works

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu.c | 58 +++++++++++++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 24843cf49579..c91c3472821b 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -5653,37 +5653,47 @@ static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
 			struct kvm_memory_slot *slot,
 			struct kvm_page_track_notifier_node *node)
 {
-	struct kvm_mmu_page *sp;
+	struct kvm_mmu_page *sp, *tmp;
 	LIST_HEAD(invalid_list);
-	unsigned long i;
-	bool flush;
-	gfn_t gfn;
+	int max_level, ign;
+	gfn_t gfn_mask;
+
+	/*
+	 * Zapping upper level shadow pages isn't required, worst case scenario
+	 * we'll have unused shadow pages with no children that aren't zapped
+	 * until they're recycled due to age or when the VM is destroyed.  Skip
+	 * shadow pages that can't point directly at the memslot.
+	 */
+	max_level = kvm_largepages_enabled() ? kvm_x86_ops->get_lpage_level() :
+					       PT_PAGE_TABLE_LEVEL;
+	while (slot->npages < KVM_PAGES_PER_HPAGE(max_level))
+		--max_level;
 
 	spin_lock(&kvm->mmu_lock);
+restart:
+	list_for_each_entry_safe(sp, tmp, &kvm->arch.active_mmu_pages, link) {
+		if (sp->role.level > max_level)
+			continue;
+		if (sp->role.invalid && sp->root_count)
+			continue;
 
-	if (list_empty(&kvm->arch.active_mmu_pages))
-		goto out_unlock;
+		/*
+		 * Note, the mask is calculated using level+1.  We're looking
+		 * for shadow pages with sptes that point at the to-be-removed
+		 * memslot, not just for shadow pages residing in the memslot.
+		 */
+		gfn_mask = ~(KVM_PAGES_PER_HPAGE(sp->role.level + 1) - 1);
+		if (sp->gfn < (slot->base_gfn & gfn_mask) ||
+		    sp->gfn > ((slot->base_gfn + slot->npages - 1) & gfn_mask))
+			continue;
 
-	flush = slot_handle_all_level(kvm, slot, kvm_zap_rmapp, false);
+		if (__kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list, &ign))
+			goto restart;
 
-	for (i = 0; i < slot->npages; i++) {
-		gfn = slot->base_gfn + i;
-
-		for_each_valid_sp(kvm, sp, gfn) {
-			if (sp->gfn != gfn)
-				continue;
-
-			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
-		}
-		if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
-			kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
-			flush = false;
-			cond_resched_lock(&kvm->mmu_lock);
-		}
+		if (cond_resched_lock(&kvm->mmu_lock))
+			goto restart;
 	}
-	kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
-
-out_unlock:
+	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 	spin_unlock(&kvm->mmu_lock);
 }
 
-- 
2.22.0


--mP3DRpeJDSE+ciuQ--
