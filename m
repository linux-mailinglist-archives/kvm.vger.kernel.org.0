Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0546F8EE9D
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 16:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733099AbfHOOqz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 10:46:55 -0400
Received: from mga12.intel.com ([192.55.52.136]:44609 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726008AbfHOOqz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 10:46:55 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Aug 2019 07:46:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,389,1559545200"; 
   d="scan'208,223";a="260834340"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 15 Aug 2019 07:46:54 -0700
Date:   Thu, 15 Aug 2019 07:46:54 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Xiao Guangrong <guangrong.xiao@gmail.com>
Subject: Re: [PATCH v2 11/27] KVM: x86/mmu: Zap only the relevant pages when
 removing a memslot
Message-ID: <20190815144654.GA27076@linux.intel.com>
References: <20190205205443.1059-1-sean.j.christopherson@intel.com>
 <20190205210137.1377-11-sean.j.christopherson@intel.com>
 <20190813100458.70b7d82d@x1.home>
 <20190813170440.GC13991@linux.intel.com>
 <20190813115737.5db7d815@x1.home>
 <20190813133316.6fc6f257@x1.home>
 <20190813201914.GI13991@linux.intel.com>
 <cd9e5c9d-a321-b2f3-608d-0b8f74a5075f@redhat.com>
 <20190813151417.2cf979ca@x1.home>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <20190813151417.2cf979ca@x1.home>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 13, 2019 at 03:14:17PM -0600, Alex Williamson wrote:
> On Tue, 13 Aug 2019 22:37:14 +0200
> Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
> > On 13/08/19 22:19, Sean Christopherson wrote:
> > > Yes?  Shadow pages are stored in a hash table, for_each_valid_sp() walks
> > > all entries for a given gfn.  The sp->gfn check is there to skip entries
> > > that hashed to the same list but for a completely different gfn.
> > > 
> > > Skipping the gfn check would be sort of a lightweight zap all in the
> > > sense that it would zap shadow pages that happend to collide with the
> > > target memslot/gfn but are otherwise unrelated.
> > > 
> > > What happens if you give just the GPU BAR at 0x80000000 a pass, i.e.:
> > > 
> > > 	if (sp->gfn != gfn && sp->gfn != 0x80000)
> > > 		continue;
> 
> Not having any luck with this yet.  Tried 0x80000, 0x8xxxxx, 0.

I've no idea if it would actually be interesting, but something to try
would be to zap only emulated mmio SPTEs (in addition to the memslot).
If that test passes then I think it might indicate a problem with device
enumeration as opposed to the mapping of the device itself ("think" and
"might" being the operative words).  Patch attached.

--uAKRQypu60I7Lcqm
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="emulated_mmio_only.patch"

From df7d1bf7025c20703f71e126dc673ba58230605f Mon Sep 17 00:00:00 2001
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Thu, 15 Aug 2019 07:27:05 -0700
Subject: [PATCH] tmp

---
 arch/x86/kvm/mmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 24843cf49579..d5bbb7ed716f 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -5649,6 +5649,8 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 	return alloc_mmu_pages(vcpu);
 }
 
+static void __kvm_mmu_zap_all(struct kvm *kvm, bool mmio_only);
+
 static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
 			struct kvm_memory_slot *slot,
 			struct kvm_page_track_notifier_node *node)
@@ -5685,6 +5687,8 @@ static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
 
 out_unlock:
 	spin_unlock(&kvm->mmu_lock);
+
+	__kvm_mmu_zap_all(kvm, true);
 }
 
 void kvm_mmu_init_vm(struct kvm *kvm)
-- 
2.22.0


--uAKRQypu60I7Lcqm--
