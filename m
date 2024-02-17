Return-Path: <kvm+bounces-8965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5123C858F26
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 12:40:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 657761C21584
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 11:40:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D39876A035;
	Sat, 17 Feb 2024 11:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="l4x31Fi1"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD8B6A010
	for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 11:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708170029; cv=none; b=EDEd2+Qvyl+XzAPO8Qr3YRkscOVM/zkkwzJw8jqRkjQ7qJGVPa5emM8lABCqr4MBZv7cJmizeusbxZ5L/mxLDl0XX7cE6Vsjt3BV2DnGoInzeMmgxj3kB7Rl/q7lcu1KQAxT6I1GNrixZJiMmGY4CfEyoCiqusj7iC0ZBEDS0H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708170029; c=relaxed/simple;
	bh=k3WkaHKlWoTNaL4mad5xlJc9eqtK33g9A32lSW7k+hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UwaaP6U2/Xr/jJ56JLCv0prrbf496IzCRFC0z7l//yT3kIFD7RT7bo7FaPZu7mO2w+9Xz57nevZFVpiD3LoLgMU0bgPF+aULlnntwzulEiCB5ijk0c7BADimBwUfdqpFVP3kq1iK6fMB53yU7rxdpB+B6niPLGyPqCES+1SKFU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=l4x31Fi1; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:
	To:From:Reply-To:Content-ID:Content-Description;
	bh=WGLpW6FT++ZTSc9z/kA2ucScxMGZ3vZ8SGGZsO+TlS4=; b=l4x31Fi1Q9YqtFH2G31OnJU0gF
	fdZXFrD9ZkHYSeK8o/hrNb5HVWW1iHItY2JOTkxp6CJ41dR83pbgtFC9/B8MXaE2z+0Pwj6ksSTHd
	2A1xWgPGn064VaimVVP+xowl8HnaL9M++tFFvYyZpO61LAJfBOBwSlQPLx+vSJoaM38C66Ndwsk3c
	gZagrQ8VurMNKGVfn28ZqF/ClEioyXQWCnvmtDY/cJBrQftNlIZ8u8U2GholSin5a+fkvCtdkw3f2
	+Ku6xa1EPuK5eo/ZQoVZmSBzHNumtNeu5uw4vsxs0P579yt8XJjNZb4dxl17BiilmDRODkv7/h3zG
	Pqv6No2w==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbJ3K-00000007JdW-3ULh;
	Sat, 17 Feb 2024 11:40:25 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbJ3L-0000000034I-3oWM;
	Sat, 17 Feb 2024 11:40:19 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Paul Durrant <paul@xen.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michal Luczaj <mhal@rbox.co>,
	David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH 4/6] KVM: pfncache: simplify locking and make more self-contained
Date: Sat, 17 Feb 2024 11:27:02 +0000
Message-ID: <20240217114017.11551-5-dwmw2@infradead.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240217114017.11551-1-dwmw2@infradead.org>
References: <20240217114017.11551-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

The locking on the gfn_to_pfn_cache is... interesting. And awful.

There is a rwlock in ->lock which readers take to ensure protection
against concurrent changes. But __kvm_gpc_refresh() makes assumptions
that certain fields will not change even while it drops the write lock
and performs MM operations to revalidate the target PFN and kernel
mapping.

Commit 93984f19e7bc ("KVM: Fully serialize gfn=>pfn cache refresh via
mutex") partly addressed that — not by fixing it, but by adding a new
mutex, ->refresh_lock. This prevented concurrent __kvm_gpc_refresh()
calls on a given gfn_to_pfn_cache, but is still only a partial solution.

There is still a theoretical race where __kvm_gpc_refresh() runs in
parallel with kvm_gpc_deactivate(). While __kvm_gpc_refresh() has
dropped the write lock, kvm_gpc_deactivate() clears the ->active flag
and unmaps ->khva. Then __kvm_gpc_refresh() determines that the previous
->pfn and ->khva are still valid, and reinstalls those values into the
structure. This leaves the gfn_to_pfn_cache with the ->valid bit set,
but ->active clear. And a ->khva which looks like a reasonable kernel
address but is actually unmapped.

All it takes is a subsequent reactivation to cause that ->khva to be
dereferenced. This would theoretically cause an oops which would look
something like this:

[1724749.564994] BUG: unable to handle page fault for address: ffffaa3540ace0e0
[1724749.565039] RIP: 0010:__kvm_xen_has_interrupt+0x8b/0xb0

I say "theoretically" because theoretically, that oops that was seen in
production cannot happen. The code which uses the gfn_to_pfn_cache is
supposed to have its *own* locking, to further paper over the fact that
the gfn_to_pfn_cache's own papering-over (->refresh_lock) of its own
rwlock abuse is not sufficient.

For the Xen vcpu_info that external lock is the vcpu->mutex, and for the
shared info it's kvm->arch.xen.xen_lock. Those locks ought to protect
the gfn_to_pfn_cache against concurrent deactivation vs. refresh in all
but the cases where the vcpu or kvm object is being *destroyed*, in
which case the subsequent reactivation should never happen.

Theoretically.

Nevertheless, this locking abuse is awful and should be fixed, even if
no clear explanation can be found for how the oops happened. So expand
the use of the ->refresh_lock mutex to ensure serialization of
activate/deactivate vs. refresh and make the pfncache locking entirely
self-sufficient.

This means that a future commit can simplify the locking in the callers,
such as the Xen emulation code which has an outstanding problem with
recursive locking of kvm->arch.xen.xen_lock, which will no longer be
necessary.

The rwlock abuse described above is still not best practice, although
it's harmless now that the ->refresh_lock is held for the entire duration
while the offending code drops the write lock, does some other stuff,
then takes the write lock again and assumes nothing changed. That can
also be fixed^W cleaned up in a subsequent commit, but this commit is
a simpler basis for the Xen deadlock fix mentioned above.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 virt/kvm/pfncache.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index a60d8f906896..79a3ef7c6d04 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -255,12 +255,7 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 	if (page_offset + len > PAGE_SIZE)
 		return -EINVAL;
 
-	/*
-	 * If another task is refreshing the cache, wait for it to complete.
-	 * There is no guarantee that concurrent refreshes will see the same
-	 * gpa, memslots generation, etc..., so they must be fully serialized.
-	 */
-	mutex_lock(&gpc->refresh_lock);
+	lockdep_assert_held(&gpc->refresh_lock);
 
 	write_lock_irq(&gpc->lock);
 
@@ -346,8 +341,6 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 out_unlock:
 	write_unlock_irq(&gpc->lock);
 
-	mutex_unlock(&gpc->refresh_lock);
-
 	if (unmap_old)
 		gpc_unmap(old_pfn, old_khva);
 
@@ -356,16 +349,24 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 
 int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, unsigned long len)
 {
-	unsigned long uhva = gpc->uhva;
+	unsigned long uhva;
+	int ret;
+
+	mutex_lock(&gpc->refresh_lock);
 
 	/*
 	 * If the GPA is valid then invalidate the HVA, otherwise
 	 * __kvm_gpc_refresh() will fail its strict either/or address check.
 	 */
+	uhva = gpc->uhva;
 	if (!kvm_is_error_gpa(gpc->gpa))
 		uhva = KVM_HVA_ERR_BAD;
 
-	return __kvm_gpc_refresh(gpc, gpc->gpa, uhva, len);
+	ret = __kvm_gpc_refresh(gpc, gpc->gpa, uhva, len);
+
+	mutex_unlock(&gpc->refresh_lock);
+
+	return ret;
 }
 
 void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm)
@@ -377,12 +378,16 @@ void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm)
 	gpc->pfn = KVM_PFN_ERR_FAULT;
 	gpc->gpa = INVALID_GPA;
 	gpc->uhva = KVM_HVA_ERR_BAD;
+	gpc->active = gpc->valid = false;
 }
 
 static int __kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long uhva,
 			      unsigned long len)
 {
 	struct kvm *kvm = gpc->kvm;
+	int ret;
+
+	mutex_lock(&gpc->refresh_lock);
 
 	if (!gpc->active) {
 		if (KVM_BUG_ON(gpc->valid, kvm))
@@ -401,7 +406,10 @@ static int __kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned
 		gpc->active = true;
 		write_unlock_irq(&gpc->lock);
 	}
-	return __kvm_gpc_refresh(gpc, gpa, uhva, len);
+	ret = __kvm_gpc_refresh(gpc, gpa, uhva, len);
+	mutex_unlock(&gpc->refresh_lock);
+
+	return ret;
 }
 
 int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
@@ -420,6 +428,7 @@ void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc)
 	kvm_pfn_t old_pfn;
 	void *old_khva;
 
+	mutex_lock(&gpc->refresh_lock);
 	if (gpc->active) {
 		/*
 		 * Deactivate the cache before removing it from the list, KVM
@@ -449,4 +458,5 @@ void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc)
 
 		gpc_unmap(old_pfn, old_khva);
 	}
+	mutex_unlock(&gpc->refresh_lock);
 }
-- 
2.43.0


