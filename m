Return-Path: <kvm+bounces-2208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A9E27F357F
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 19:03:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DF5E2B21B79
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 18:03:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8019222079;
	Tue, 21 Nov 2023 18:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen.org header.i=@xen.org header.b="QPHWpDWT"
X-Original-To: kvm@vger.kernel.org
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BEEC18E;
	Tue, 21 Nov 2023 10:03:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
	s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-Id:Date:Subject:To:From;
	bh=0DZ85GBDIX7OEp0bx4GOzWNATdcequDe+9yrjRRR5Lc=; b=QPHWpDWTF64a1Q8LRuy9FsaxGj
	qgs616ONQTPUJwL6dHLQxsNYmXVUUMadGze218LMMosWMbbW4LKEmTi+2C4WRvAbb/AIJ66jogYzn
	VYjSqDfTlhhS0Smp+qtpz5CcCStloYCRWq97p0ej5wvmdkhPm15I/B8sa4fuYqn8HYeo=;
Received: from xenbits.xenproject.org ([104.239.192.120])
	by mail.xenproject.org with esmtp (Exim 4.92)
	(envelope-from <paul@xen.org>)
	id 1r5V5Y-00084M-Iw; Tue, 21 Nov 2023 18:03:08 +0000
Received: from 54-240-197-231.amazon.com ([54.240.197.231] helo=REM-PW02S00X.ant.amazon.com)
	by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <paul@xen.org>)
	id 1r5V5Y-0004Z3-9v; Tue, 21 Nov 2023 18:03:08 +0000
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
Subject: [PATCH v8 03/15] KVM: xen: mark guest pages dirty with the pfncache lock held
Date: Tue, 21 Nov 2023 18:02:11 +0000
Message-Id: <20231121180223.12484-4-paul@xen.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231121180223.12484-1-paul@xen.org>
References: <20231121180223.12484-1-paul@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Paul Durrant <pdurrant@amazon.com>

Sampling gpa and memslot from an unlocked pfncache may yield inconsistent
values so, since there is no problem with calling mark_page_dirty_in_slot()
with the pfncache lock held, relocate the calls in
kvm_xen_update_runstate_guest() and kvm_xen_inject_pending_events()
accordingly.

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
---
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: x86@kernel.org

v8:
 - New in this version.
---
 arch/x86/kvm/xen.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index e53fad915a62..426306022c2f 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -452,14 +452,13 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
 		smp_wmb();
 	}
 
-	if (user_len2)
+	if (user_len2) {
+		mark_page_dirty_in_slot(v->kvm, gpc2->memslot, gpc2->gpa >> PAGE_SHIFT);
 		read_unlock(&gpc2->lock);
-
-	read_unlock_irqrestore(&gpc1->lock, flags);
+	}
 
 	mark_page_dirty_in_slot(v->kvm, gpc1->memslot, gpc1->gpa >> PAGE_SHIFT);
-	if (user_len2)
-		mark_page_dirty_in_slot(v->kvm, gpc2->memslot, gpc2->gpa >> PAGE_SHIFT);
+	read_unlock_irqrestore(&gpc1->lock, flags);
 }
 
 void kvm_xen_update_runstate(struct kvm_vcpu *v, int state)
@@ -565,13 +564,13 @@ void kvm_xen_inject_pending_events(struct kvm_vcpu *v)
 			     : "0" (evtchn_pending_sel32));
 		WRITE_ONCE(vi->evtchn_upcall_pending, 1);
 	}
+
+	mark_page_dirty_in_slot(v->kvm, gpc->memslot, gpc->gpa >> PAGE_SHIFT);
 	read_unlock_irqrestore(&gpc->lock, flags);
 
 	/* For the per-vCPU lapic vector, deliver it as MSI. */
 	if (v->arch.xen.upcall_vector)
 		kvm_xen_inject_vcpu_vector(v);
-
-	mark_page_dirty_in_slot(v->kvm, gpc->memslot, gpc->gpa >> PAGE_SHIFT);
 }
 
 int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
-- 
2.39.2


