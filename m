Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF29230DD77
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 16:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbhBCPCk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 10:02:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233120AbhBCPCg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 10:02:36 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC961C06178C
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 07:01:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=KLfcyGy9T9iGpQk+qY/7SlZOvrvapfPj0j7PTYdasYk=; b=bXWZdZnLbbiZ6+gLOtGK4ym1Bk
        51F5IpXDdqkeXSsobZRXWubxz2FbA5o5qGEe0pJxBCGGbZUT+/eUlM85h+EzDvI9p7wte7nX4FY+G
        SAGzBHrQRq4dRQyPJkbARhV//DsLW05+YcbNqKBvN0+uAv1pE28bQJ9UcKGMcZvzLghfeoKDVQ+us
        Q63IfVqUg3CG7Kq4V1Lc2/ukI8kOsKCPyASAmr3Pm3wfVtjUZa9vqEht4v0NC6DHHOlWveikUtJlx
        Fy1ZavhSyDp4UBnVpiETWrqATbAvio1aeAhslnEqBeNmVKPFdwrDZc5d6oZBMABgnijLWhaQmhwlX
        3nBrsoew==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l7Jeg-00015q-HD; Wed, 03 Feb 2021 15:01:18 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l7Jef-003rer-De; Wed, 03 Feb 2021 15:01:17 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
Subject: [PATCH v6 15/19] KVM: x86/xen: setup pvclock updates
Date:   Wed,  3 Feb 2021 15:01:10 +0000
Message-Id: <20210203150114.920335-16-dwmw2@infradead.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210203150114.920335-1-dwmw2@infradead.org>
References: <20210203150114.920335-1-dwmw2@infradead.org>
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
 arch/x86/kvm/xen.c |  5 +++--
 2 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 16549b9fb347..65d06d4426a2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2589,13 +2589,15 @@ u64 get_kvmclock_ns(struct kvm *kvm)
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
@@ -2618,9 +2620,9 @@ static void kvm_setup_pvclock_page(struct kvm_vcpu *v)
 		++guest_hv_clock.version;  /* first time write, random junk */
 
 	vcpu->hv_clock.version = guest_hv_clock.version + 1;
-	kvm_write_guest_cached(v->kvm, &vcpu->pv_time,
-				&vcpu->hv_clock,
-				sizeof(vcpu->hv_clock.version));
+	kvm_write_guest_offset_cached(v->kvm, cache,
+				      &vcpu->hv_clock, offset,
+				      sizeof(vcpu->hv_clock.version));
 
 	smp_wmb();
 
@@ -2634,16 +2636,16 @@ static void kvm_setup_pvclock_page(struct kvm_vcpu *v)
 
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
@@ -2730,7 +2732,10 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
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
index 2712f1aa9ac9..c307f8b7a8a3 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -135,11 +135,12 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 					      &vcpu->arch.xen.vcpu_info_cache,
 					      data->u.gpa,
 					      sizeof(struct vcpu_info));
-		if (!r)
+		if (!r) {
 			vcpu->arch.xen.vcpu_info_set = true;
+			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
+		}
 		break;
 
-
 	default:
 		break;
 	}
-- 
2.29.2

