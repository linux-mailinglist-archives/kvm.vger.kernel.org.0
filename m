Return-Path: <kvm+bounces-2280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 841417F45CD
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 13:20:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 24819B216AE
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 12:20:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EE804C63E;
	Wed, 22 Nov 2023 12:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen.org header.i=@xen.org header.b="X3c8rCbe"
X-Original-To: kvm@vger.kernel.org
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0167F1BDF;
	Wed, 22 Nov 2023 04:19:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
	s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-Id:Date:Subject:To:From;
	bh=NQsNWrELjG5Cq/2sI7DaoTTJ1sioU7rwnFvf1GPJFQs=; b=X3c8rCbe9Wkq+3/XcRI9VxhDwY
	YcJWwdbOPk+XM/aZhx7zZyb+q8lHUgYgX/qivPTL2T5v7+RxmyAAROnWO7y0eqsvgItX5z3TnooC4
	ypQgNjjsyJViNTVUHP9kn5Gup65/6aymgxkbNOYr9qM/y4RZnj9YDVPmE7M3nnZF3b7Y=;
Received: from xenbits.xenproject.org ([104.239.192.120])
	by mail.xenproject.org with esmtp (Exim 4.92)
	(envelope-from <paul@xen.org>)
	id 1r5mCV-0004xD-7Q; Wed, 22 Nov 2023 12:19:27 +0000
Received: from 54-240-197-231.amazon.com ([54.240.197.231] helo=REM-PW02S00X.ant.amazon.com)
	by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <paul@xen.org>)
	id 1r5mCU-0004y9-UU; Wed, 22 Nov 2023 12:19:27 +0000
From: Paul Durrant <paul@xen.org>
To: David Woodhouse <dwmw2@infradead.org>,
	Paul Durrant <paul@xen.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v9 04/15] KVM: pfncache: add a mark-dirty helper
Date: Wed, 22 Nov 2023 12:18:11 +0000
Message-Id: <20231122121822.1042-5-paul@xen.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231122121822.1042-1-paul@xen.org>
References: <20231122121822.1042-1-paul@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Paul Durrant <pdurrant@amazon.com>

At the moment pages are marked dirty by open-coded calls to
mark_page_dirty_in_slot(), directly deferefencing the gpa and memslot
from the cache. After a subsequent patch these may not always be set
so add a helper now so that caller will protected from the need to know
about this detail.

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
---
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org

v8:
 - Make the helper a static inline.
---
 arch/x86/kvm/x86.c       |  2 +-
 arch/x86/kvm/xen.c       |  6 +++---
 include/linux/kvm_host.h | 10 ++++++++++
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2c924075f6f1..f4ebac198ff5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3145,7 +3145,7 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
 
 	guest_hv_clock->version = ++vcpu->hv_clock.version;
 
-	mark_page_dirty_in_slot(v->kvm, gpc->memslot, gpc->gpa >> PAGE_SHIFT);
+	kvm_gpc_mark_dirty(gpc);
 	read_unlock_irqrestore(&gpc->lock, flags);
 
 	trace_kvm_pvclock_update(v->vcpu_id, &vcpu->hv_clock);
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 426306022c2f..41a7c03f7204 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -453,11 +453,11 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
 	}
 
 	if (user_len2) {
-		mark_page_dirty_in_slot(v->kvm, gpc2->memslot, gpc2->gpa >> PAGE_SHIFT);
+		kvm_gpc_mark_dirty(gpc2);
 		read_unlock(&gpc2->lock);
 	}
 
-	mark_page_dirty_in_slot(v->kvm, gpc1->memslot, gpc1->gpa >> PAGE_SHIFT);
+	kvm_gpc_mark_dirty(gpc1);
 	read_unlock_irqrestore(&gpc1->lock, flags);
 }
 
@@ -565,7 +565,7 @@ void kvm_xen_inject_pending_events(struct kvm_vcpu *v)
 		WRITE_ONCE(vi->evtchn_upcall_pending, 1);
 	}
 
-	mark_page_dirty_in_slot(v->kvm, gpc->memslot, gpc->gpa >> PAGE_SHIFT);
+	kvm_gpc_mark_dirty(gpc);
 	read_unlock_irqrestore(&gpc->lock, flags);
 
 	/* For the per-vCPU lapic vector, deliver it as MSI. */
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index fb6c6109fdca..ae83caa99974 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1367,6 +1367,16 @@ int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, unsigned long len);
  */
 void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc);
 
+/**
+ * kvm_gpc_mark_dirty - mark a cached page as dirty.
+ *
+ * @gpc:	   struct gfn_to_pfn_cache object.
+ */
+static inline void kvm_gpc_mark_dirty(struct gfn_to_pfn_cache *gpc)
+{
+	mark_page_dirty_in_slot(gpc->kvm, gpc->memslot, gpc->gpa >> PAGE_SHIFT);
+}
+
 void kvm_sigset_activate(struct kvm_vcpu *vcpu);
 void kvm_sigset_deactivate(struct kvm_vcpu *vcpu);
 
-- 
2.39.2


