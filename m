Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9738BDF1
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 18:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbfHMQFA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 12:05:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52484 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728108AbfHMQFA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 12:05:00 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C8E02306E171;
        Tue, 13 Aug 2019 16:04:59 +0000 (UTC)
Received: from x1.home (ovpn-116-99.phx2.redhat.com [10.3.116.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 68FB21001281;
        Tue, 13 Aug 2019 16:04:59 +0000 (UTC)
Date:   Tue, 13 Aug 2019 10:04:58 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Xiao Guangrong <guangrong.xiao@gmail.com>
Subject: Re: [PATCH v2 11/27] KVM: x86/mmu: Zap only the relevant pages when
 removing a memslot
Message-ID: <20190813100458.70b7d82d@x1.home>
In-Reply-To: <20190205210137.1377-11-sean.j.christopherson@intel.com>
References: <20190205205443.1059-1-sean.j.christopherson@intel.com>
        <20190205210137.1377-11-sean.j.christopherson@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Tue, 13 Aug 2019 16:04:59 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  5 Feb 2019 13:01:21 -0800
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> Modify kvm_mmu_invalidate_zap_pages_in_memslot(), a.k.a. the x86 MMU's
> handler for kvm_arch_flush_shadow_memslot(), to zap only the pages/PTEs
> that actually belong to the memslot being removed.  This improves
> performance, especially why the deleted memslot has only a few shadow
> entries, or even no entries.  E.g. a microbenchmark to access regular
> memory while concurrently reading PCI ROM to trigger memslot deletion
> showed a 5% improvement in throughput.
> 
> Cc: Xiao Guangrong <guangrong.xiao@gmail.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/mmu.c | 33 ++++++++++++++++++++++++++++++++-
>  1 file changed, 32 insertions(+), 1 deletion(-)

A number of vfio users are reporting VM instability issues since v5.1,
some have traced it back to this commit 4e103134b862 ("KVM: x86/mmu: Zap
only the relevant pages when removing a memslot"), which I've confirmed
via bisection of the 5.1 merge window KVM pull (636deed6c0bc) and
re-verified on current 5.3-rc4 using the below patch to toggle the
broken behavior.

My reproducer is a Windows 10 VM with assigned GeForce GPU running a
variety of tests, including FurMark and PassMark Performance Test.
With the code enabled as exists in upstream currently, PassMark will
generally introduce graphics glitches or hangs.  Sometimes it's
necessary to reboot the VM to see these issues.  Flipping the 0/1 in
the below patch appears to resolve the issue.

I'd appreciate any insights into further debugging this block of code
so that we can fix this regression.  Thanks,

Alex

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 24843cf49579..6a77306940f7 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -5653,6 +5653,9 @@ static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
 			struct kvm_memory_slot *slot,
 			struct kvm_page_track_notifier_node *node)
 {
+#if 0
+	kvm_mmu_zap_all(kvm);
+#else
 	struct kvm_mmu_page *sp;
 	LIST_HEAD(invalid_list);
 	unsigned long i;
@@ -5685,6 +5688,7 @@ static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
 
 out_unlock:
 	spin_unlock(&kvm->mmu_lock);
+#endif
 }
 
 void kvm_mmu_init_vm(struct kvm *kvm)
