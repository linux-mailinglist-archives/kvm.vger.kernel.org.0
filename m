Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AAF02D943E
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 09:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439396AbgLNIki (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 03:40:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439380AbgLNIki (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 03:40:38 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50031C061285
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 00:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=FHeSliL/xeyTfrUIsOSLgvxIZFgqnxlNOpjZeJyPGU8=; b=N1ek99R8bTEihzfGyOjRJ3lmBt
        /j3eTLFQRnPR0+HbKpDILTr46o/Sf4Y1zXXPlhVJ/E76Sa+njn6fGQ467jtrPspos4EgBAyAenbKv
        dlyh8LMetydVnTRW4Kg46xS0BKgANezHN6hDDphx2gHPnSJBScU0s1Km4ye3Ll/ToxHPe5MiBa2Xp
        9kaI5i6W7/oFtwCM7HTsObjH3UK7UykvebBz2J8f5h4ds+O81lvHd3ueRmkbxKfybG3dYechpvRP1
        ph/tuS9tGc3JmfoR+1NinYpHyB4wReXBF6s7Bxj0JQ9l4IfMcUfMozPXliL3puTMUaaDjkoGo0ZST
        pVMNIY9g==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kojNs-0006lU-RF; Mon, 14 Dec 2020 08:39:08 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kojNr-008Sy3-Pk; Mon, 14 Dec 2020 08:39:07 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com
Subject: [PATCH v3 12/17] KVM: x86/xen: setup pvclock updates
Date:   Mon, 14 Dec 2020 08:39:00 +0000
Message-Id: <20201214083905.2017260-13-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201214083905.2017260-1-dwmw2@infradead.org>
References: <20201214083905.2017260-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joao Martins <joao.m.martins@oracle.com>

Parameterise kvm_setup_pvclock_page() a little bit so that it can be
invoked for different gfn_to_hva_cache structures, and with different
offsets. Then we can invoke it for the normal KVM pvclock and also for
the Xen one in the vcpu_info.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/x86.c | 31 ++++++++++++++++++-------------
 arch/x86/kvm/xen.c |  4 ++++
 2 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 64016443159c..cbdc05bb53bd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2582,13 +2582,15 @@ u64 get_kvmclock_ns(struct kvm *kvm)
 	return ret;
 }
 
-static void kvm_setup_pvclock_page(struct kvm_vcpu *v)
+static void kvm_setup_pvclock_page(struct kvm_vcpu *v,
+				   struct gfn_to_hva_cache *cache,
+				   unsigned int offset)
 {
 	struct kvm_vcpu_arch *vcpu = &v->arch;
 	struct pvclock_vcpu_time_info guest_hv_clock;
 
-	if (unlikely(kvm_read_guest_cached(v->kvm, &vcpu->pv_time,
-		&guest_hv_clock, sizeof(guest_hv_clock))))
+	if (unlikely(kvm_read_guest_offset_cached(v->kvm, cache,
+		&guest_hv_clock, offset, sizeof(guest_hv_clock))))
 		return;
 
 	/* This VCPU is paused, but it's legal for a guest to read another
@@ -2611,9 +2613,9 @@ static void kvm_setup_pvclock_page(struct kvm_vcpu *v)
 		++guest_hv_clock.version;  /* first time write, random junk */
 
 	vcpu->hv_clock.version = guest_hv_clock.version + 1;
-	kvm_write_guest_cached(v->kvm, &vcpu->pv_time,
-				&vcpu->hv_clock,
-				sizeof(vcpu->hv_clock.version));
+	kvm_write_guest_offset_cached(v->kvm, cache,
+				      &vcpu->hv_clock, offset,
+				      sizeof(vcpu->hv_clock.version));
 
 	smp_wmb();
 
@@ -2627,16 +2629,16 @@ static void kvm_setup_pvclock_page(struct kvm_vcpu *v)
 
 	trace_kvm_pvclock_update(v->vcpu_id, &vcpu->hv_clock);
 
-	kvm_write_guest_cached(v->kvm, &vcpu->pv_time,
-				&vcpu->hv_clock,
-				sizeof(vcpu->hv_clock));
+	kvm_write_guest_offset_cached(v->kvm, cache,
+				      &vcpu->hv_clock, offset,
+				      sizeof(vcpu->hv_clock));
 
 	smp_wmb();
 
 	vcpu->hv_clock.version++;
-	kvm_write_guest_cached(v->kvm, &vcpu->pv_time,
-				&vcpu->hv_clock,
-				sizeof(vcpu->hv_clock.version));
+	kvm_write_guest_offset_cached(v->kvm, cache,
+				     &vcpu->hv_clock, offset,
+				     sizeof(vcpu->hv_clock.version));
 }
 
 static int kvm_guest_time_update(struct kvm_vcpu *v)
@@ -2723,7 +2725,10 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	vcpu->hv_clock.flags = pvclock_flags;
 
 	if (vcpu->pv_time_enabled)
-		kvm_setup_pvclock_page(v);
+		kvm_setup_pvclock_page(v, &vcpu->pv_time, 0);
+	if (vcpu->xen.vcpu_info_set)
+		kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_info_cache,
+				       offsetof(struct compat_vcpu_info, time));
 	if (v == kvm_get_vcpu(v->kvm, 0))
 		kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
 	return 0;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 4bc72e0b9928..d2055b60fdc1 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -82,6 +82,9 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		/* No compat necessary here. */
 		BUILD_BUG_ON(sizeof(struct vcpu_info) !=
 			     sizeof(struct compat_vcpu_info));
+		BUILD_BUG_ON(offsetof(struct vcpu_info, time) !=
+			     offsetof(struct compat_vcpu_info, time));
+
 		r = kvm_gfn_to_hva_cache_init(kvm, &v->arch.xen.vcpu_info_cache,
 					      data->u.vcpu_attr.gpa,
 					      sizeof(struct vcpu_info));
@@ -89,6 +92,7 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 			return r;
 
 		v->arch.xen.vcpu_info_set = true;
+		kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
 		break;
 
 	default:
-- 
2.26.2

