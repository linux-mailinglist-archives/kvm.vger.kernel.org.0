Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58C5565625C
	for <lists+kvm@lfdr.de>; Mon, 26 Dec 2022 13:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbiLZMDc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Dec 2022 07:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiLZMDb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Dec 2022 07:03:31 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F1F128
        for <kvm@vger.kernel.org>; Mon, 26 Dec 2022 04:03:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=x3XNvnYEgM/LKRNuBcAst3gBWIkXh91aD89g52xb1AM=; b=nlA97QX3jmAcVVCaTHYcMwp56S
        5+3MPnVZl1CBwphfPpFeZ7shc60Zkn+639AKhrjyTJRRE4frWaUDS95moDoUK242TWX33mN/PydD3
        iLDLcan1jsCNLI/75bpovXSTquWwP7Lm1x5H98IUG4dIX2Qc9fBPLILWUCJpQNCeehHiX9YuuUHzG
        gQu/D4EPylqA3lnDYbaZukqlNNKQIXjcCWz8jNTkvoQQ08UUt7F96PQtCIumUB8I1KsM5zJZAoWEN
        XU1lW4j9NQl9swWf75GWAt3dJ79HpycfcVmvzHOBp6+wj9/wcFrWwN3N/X8MMtUhs/YDMEQvvIFWi
        5pPdqeKA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p9mCZ-006e9s-QM; Mon, 26 Dec 2022 12:03:32 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p9mCO-004ily-Qp; Mon, 26 Dec 2022 12:03:20 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Michal Luczaj <mhal@rbox.co>,
        Sean Christopherson <seanjc@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>, kvm@vger.kernel.org,
        Paul Durrant <paul@xen.org>
Subject: [PATCH 5/6] KVM: x86/xen: Add KVM_XEN_INVALID_GPA and KVM_XEN_INVALID_GFN to uapi
Date:   Mon, 26 Dec 2022 12:03:19 +0000
Message-Id: <20221226120320.1125390-5-dwmw2@infradead.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20221226120320.1125390-1-dwmw2@infradead.org>
References: <b36fa02bc338d6892e63e37768bf47f035339e30.camel@infradead.org>
 <20221226120320.1125390-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

These are (uint64_t)-1 magic values are a userspace ABI, allowing the
shared info pages and other enlightenments to be disabled. This isn't
a Xen ABI because Xen doesn't let the guest turn these off except with
the full SHUTDOWN_soft_reset mechanism. Under KVM, the userspace VMM is
expected to handle soft reset, and tear down the kernel parts of the
enlightenments accordingly.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/xen.c       | 14 +++++++-------
 include/uapi/linux/kvm.h |  3 +++
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index bddbe5ac5cfa..b178f40bd863 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -41,7 +41,7 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
 	int ret = 0;
 	int idx = srcu_read_lock(&kvm->srcu);
 
-	if (gfn == GPA_INVALID) {
+	if (gfn == KVM_XEN_INVALID_GFN) {
 		kvm_gpc_deactivate(gpc);
 		goto out;
 	}
@@ -659,7 +659,7 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		if (kvm->arch.xen.shinfo_cache.active)
 			data->u.shared_info.gfn = gpa_to_gfn(kvm->arch.xen.shinfo_cache.gpa);
 		else
-			data->u.shared_info.gfn = GPA_INVALID;
+			data->u.shared_info.gfn = KVM_XEN_INVALID_GFN;
 		r = 0;
 		break;
 
@@ -705,7 +705,7 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 		BUILD_BUG_ON(offsetof(struct vcpu_info, time) !=
 			     offsetof(struct compat_vcpu_info, time));
 
-		if (data->u.gpa == GPA_INVALID) {
+		if (data->u.gpa == KVM_XEN_INVALID_GPA) {
 			kvm_gpc_deactivate(&vcpu->arch.xen.vcpu_info_cache);
 			r = 0;
 			break;
@@ -719,7 +719,7 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 		break;
 
 	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO:
-		if (data->u.gpa == GPA_INVALID) {
+		if (data->u.gpa == KVM_XEN_INVALID_GPA) {
 			kvm_gpc_deactivate(&vcpu->arch.xen.vcpu_time_info_cache);
 			r = 0;
 			break;
@@ -739,7 +739,7 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 			r = -EOPNOTSUPP;
 			break;
 		}
-		if (data->u.gpa == GPA_INVALID) {
+		if (data->u.gpa == KVM_XEN_INVALID_GPA) {
 			r = 0;
 		deactivate_out:
 			kvm_gpc_deactivate(&vcpu->arch.xen.runstate_cache);
@@ -937,7 +937,7 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 		if (vcpu->arch.xen.vcpu_info_cache.active)
 			data->u.gpa = vcpu->arch.xen.vcpu_info_cache.gpa;
 		else
-			data->u.gpa = GPA_INVALID;
+			data->u.gpa = KVM_XEN_INVALID_GPA;
 		r = 0;
 		break;
 
@@ -945,7 +945,7 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 		if (vcpu->arch.xen.vcpu_time_info_cache.active)
 			data->u.gpa = vcpu->arch.xen.vcpu_time_info_cache.gpa;
 		else
-			data->u.gpa = GPA_INVALID;
+			data->u.gpa = KVM_XEN_INVALID_GPA;
 		r = 0;
 		break;
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 20522d4ba1e0..55155e262646 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1767,6 +1767,7 @@ struct kvm_xen_hvm_attr {
 		__u8 runstate_update_flag;
 		struct {
 			__u64 gfn;
+#define KVM_XEN_INVALID_GFN ((__u64)-1)
 		} shared_info;
 		struct {
 			__u32 send_port;
@@ -1798,6 +1799,7 @@ struct kvm_xen_hvm_attr {
 	} u;
 };
 
+
 /* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO */
 #define KVM_XEN_ATTR_TYPE_LONG_MODE		0x0
 #define KVM_XEN_ATTR_TYPE_SHARED_INFO		0x1
@@ -1823,6 +1825,7 @@ struct kvm_xen_vcpu_attr {
 	__u16 pad[3];
 	union {
 		__u64 gpa;
+#define KVM_XEN_INVALID_GPA ((__u64)-1)
 		__u64 pad[8];
 		struct {
 			__u64 state;
-- 
2.35.3

