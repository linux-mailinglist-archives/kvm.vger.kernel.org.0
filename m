Return-Path: <kvm+bounces-3089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6ED98008CF
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 11:46:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0BAF2818F8
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 10:46:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8BA420B3E;
	Fri,  1 Dec 2023 10:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen.org header.i=@xen.org header.b="kI8mcnYH"
X-Original-To: kvm@vger.kernel.org
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD47196;
	Fri,  1 Dec 2023 02:46:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
	s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-Id:Date:Subject:To:From;
	bh=XqNvN8Mg13YD+DXjeh+PV6E2xDfXAoMQ4rXRMVJHewY=; b=kI8mcnYHDv1ww3/E+0zAz51qll
	2OI4JiPs8G0XPAmE5gRwij/dPDhSkNZ6shIgZHO9dxsHaOnRzlSnVFQ8Daoom9nllED8XVlBguhzJ
	iG+uYpBwt+xLLqZpwmKL8XmLhrwT5MsXQOjtp6GTgiWPIMYjzD8eJtvC4MsW9QrVYPS4=;
Received: from xenbits.xenproject.org ([104.239.192.120])
	by mail.xenproject.org with esmtp (Exim 4.92)
	(envelope-from <paul@xen.org>)
	id 1r911t-0005P4-7Z; Fri, 01 Dec 2023 10:45:53 +0000
Received: from 54-240-197-231.amazon.com ([54.240.197.231] helo=REM-PW02S00X.ant.amazon.com)
	by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <paul@xen.org>)
	id 1r911s-0003dT-Je; Fri, 01 Dec 2023 10:45:53 +0000
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
Subject: [PATCH 1/2] KVM: xen: separate initialization of shared_info cache and content
Date: Fri,  1 Dec 2023 10:45:35 +0000
Message-Id: <20231201104536.947-2-paul@xen.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231201104536.947-1-paul@xen.org>
References: <20231201104536.947-1-paul@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Paul Durrant <pdurrant@amazon.com>

The shared_info cache should only need to be set up once by the VMM, but
the content of the shared_info page may need changed if the mode of guest
changes from 32-bit to 64-bit or vice versa. This re-initialization of
the content will be handles in a subsequent patch.

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
---
 arch/x86/kvm/xen.c | 70 ++++++++++++++++++++++++++--------------------
 1 file changed, 40 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index cfd5051e0800..7bead3f65e55 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -34,7 +34,7 @@ static bool kvm_xen_hcall_evtchn_send(struct kvm_vcpu *vcpu, u64 param, u64 *r);
 
 DEFINE_STATIC_KEY_DEFERRED_FALSE(kvm_xen_enabled, HZ);
 
-static int kvm_xen_shared_info_init(struct kvm *kvm, u64 addr, bool addr_is_gfn)
+static int kvm_xen_shared_info_init(struct kvm *kvm)
 {
 	struct gfn_to_pfn_cache *gpc = &kvm->arch.xen.shinfo_cache;
 	struct pvclock_wall_clock *wc;
@@ -44,34 +44,22 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, u64 addr, bool addr_is_gfn)
 	int ret = 0;
 	int idx = srcu_read_lock(&kvm->srcu);
 
-	if ((addr_is_gfn && addr == KVM_XEN_INVALID_GFN) ||
-	    (!addr_is_gfn && addr == 0)) {
-		kvm_gpc_deactivate(gpc);
-		goto out;
-	}
+	read_lock_irq(&gpc->lock);
+	while (!kvm_gpc_check(gpc, PAGE_SIZE)) {
+		read_unlock_irq(&gpc->lock);
 
-	do {
-		if (addr_is_gfn)
-			ret = kvm_gpc_activate(gpc, gfn_to_gpa(addr), PAGE_SIZE);
-		else
-			ret = kvm_gpc_activate_hva(gpc, addr, PAGE_SIZE);
+		ret = kvm_gpc_refresh(gpc, PAGE_SIZE);
 		if (ret)
 			goto out;
 
-		/*
-		 * This code mirrors kvm_write_wall_clock() except that it writes
-		 * directly through the pfn cache and doesn't mark the page dirty.
-		 */
-		wall_nsec = kvm_get_wall_clock_epoch(kvm);
-
-		/* It could be invalid again already, so we need to check */
 		read_lock_irq(&gpc->lock);
+	}
 
-		if (gpc->valid)
-			break;
-
-		read_unlock_irq(&gpc->lock);
-	} while (1);
+	/*
+	 * This code mirrors kvm_write_wall_clock() except that it writes
+	 * directly through the pfn cache and doesn't mark the page dirty.
+	 */
+	wall_nsec = ktime_get_real_ns() - get_kvmclock_ns(kvm);
 
 	/* Paranoia checks on the 32-bit struct layout */
 	BUILD_BUG_ON(offsetof(struct compat_shared_info, wc) != 0x900);
@@ -642,17 +630,39 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		break;
 
 	case KVM_XEN_ATTR_TYPE_SHARED_INFO:
-		mutex_lock(&kvm->arch.xen.xen_lock);
-		r = kvm_xen_shared_info_init(kvm, data->u.shared_info.gfn, true);
-		mutex_unlock(&kvm->arch.xen.xen_lock);
-		break;
+	case KVM_XEN_ATTR_TYPE_SHARED_INFO_HVA: {
+		int idx;
 
-	case KVM_XEN_ATTR_TYPE_SHARED_INFO_HVA:
 		mutex_lock(&kvm->arch.xen.xen_lock);
-		r = kvm_xen_shared_info_init(kvm, data->u.shared_info.hva, false);
+
+		idx = srcu_read_lock(&kvm->srcu);
+		if (data->type == KVM_XEN_ATTR_TYPE_SHARED_INFO) {
+			if (data->u.shared_info.gfn == KVM_XEN_INVALID_GFN) {
+				kvm_gpc_deactivate(&kvm->arch.xen.shinfo_cache);
+				r = 0;
+			} else {
+				r = kvm_gpc_activate(&kvm->arch.xen.shinfo_cache,
+						     gfn_to_gpa(data->u.shared_info.gfn),
+						     PAGE_SIZE);
+			}
+		} else {
+			if (data->u.shared_info.hva == 0) {
+				kvm_gpc_deactivate(&kvm->arch.xen.shinfo_cache);
+				r = 0;
+			} else {
+				r = kvm_gpc_activate_hva(&kvm->arch.xen.shinfo_cache,
+							 data->u.shared_info.hva,
+							 PAGE_SIZE);
+			}
+		}
+		srcu_read_unlock(&kvm->srcu, idx);
+
+		if (!r && kvm->arch.xen.shinfo_cache.active)
+			r = kvm_xen_shared_info_init(kvm);
+
 		mutex_unlock(&kvm->arch.xen.xen_lock);
 		break;
-
+	}
 	case KVM_XEN_ATTR_TYPE_UPCALL_VECTOR:
 		if (data->u.vector && data->u.vector < 0x10)
 			r = -EINVAL;
-- 
2.39.2


