Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6255A7A4E8C
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbjIRQTB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbjIRQSo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:18:44 -0400
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3830B55A3;
        Mon, 18 Sep 2023 09:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
        s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From;
        bh=CnnzQ4eiCWT/+IlcdQWASoCfyneq5mdBodDzIdnbsCc=; b=kG39+KSvtKJVp5vY5CwfM7TMNJ
        HAqO9ri+lg68hF5xBJ8KrAD5OQbumNV4bFPvi4r+fAkIiYZ2IQYF75s6rum798eb2yALcN9Y2qT+Q
        +HcXw6y/bNsB1CBlMbR8UEYp8TAW9nxROGsT/kIU0PCTQnGFKpMWqw6SjSz3nUyydHBM=;
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qiFRA-0003QG-4k; Mon, 18 Sep 2023 14:41:20 +0000
Received: from ec2-63-33-11-17.eu-west-1.compute.amazonaws.com ([63.33.11.17] helo=REM-PW02S00X.ant.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qiFR9-0006IJ-RC; Mon, 18 Sep 2023 14:41:20 +0000
From:   Paul Durrant <paul@xen.org>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH v3 03/13] KVM: pfncache: add a helper to get the gpa
Date:   Mon, 18 Sep 2023 14:41:01 +0000
Message-Id: <20230918144111.641369-4-paul@xen.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230918144111.641369-1-paul@xen.org>
References: <20230918144111.641369-1-paul@xen.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paul Durrant <pdurrant@amazon.com>

A subsequent patch will rename this field since it will become overloaded.
To avoid churn in places that currently retrieve the gpa, add a helper for
that purpose now.

No functional change intended.

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
---
 arch/x86/kvm/xen.c       | 15 ++++++++-------
 include/linux/kvm_host.h |  7 +++++++
 virt/kvm/pfncache.c      |  6 ++++++
 3 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 33fddd29824b..8e6fdcd7bb6e 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -261,8 +261,8 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
 	 * alignment (and the 32-bit ABI doesn't align the 64-bit integers
 	 * anyway, even if the overall struct had been 64-bit aligned).
 	 */
-	if ((gpc1->gpa & ~PAGE_MASK) + user_len >= PAGE_SIZE) {
-		user_len1 = PAGE_SIZE - (gpc1->gpa & ~PAGE_MASK);
+	if ((kvm_gpc_gpa(gpc1) & ~PAGE_MASK) + user_len >= PAGE_SIZE) {
+		user_len1 = PAGE_SIZE - (kvm_gpc_gpa(gpc1) & ~PAGE_MASK);
 		user_len2 = user_len - user_len1;
 	} else {
 		user_len1 = user_len;
@@ -343,7 +343,7 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
 			 * to the second page now because the guest changed to
 			 * 64-bit mode, the second GPC won't have been set up.
 			 */
-			if (kvm_gpc_activate(gpc2, gpc1->gpa + user_len1,
+			if (kvm_gpc_activate(gpc2, kvm_gpc_gpa(gpc1) + user_len1,
 					     user_len2))
 				return;
 
@@ -677,7 +677,8 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 
 	case KVM_XEN_ATTR_TYPE_SHARED_INFO:
 		if (kvm->arch.xen.shinfo_cache.active)
-			data->u.shared_info.gfn = gpa_to_gfn(kvm->arch.xen.shinfo_cache.gpa);
+			data->u.shared_info.gfn =
+				gpa_to_gfn(kvm_gpc_gpa(&kvm->arch.xen.shinfo_cache));
 		else
 			data->u.shared_info.gfn = KVM_XEN_INVALID_GFN;
 		r = 0;
@@ -955,7 +956,7 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 	switch (data->type) {
 	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO:
 		if (vcpu->arch.xen.vcpu_info_cache.active)
-			data->u.gpa = vcpu->arch.xen.vcpu_info_cache.gpa;
+			data->u.gpa = kvm_gpc_gpa(&vcpu->arch.xen.vcpu_info_cache);
 		else
 			data->u.gpa = KVM_XEN_INVALID_GPA;
 		r = 0;
@@ -963,7 +964,7 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 
 	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO:
 		if (vcpu->arch.xen.vcpu_time_info_cache.active)
-			data->u.gpa = vcpu->arch.xen.vcpu_time_info_cache.gpa;
+			data->u.gpa = kvm_gpc_gpa(&vcpu->arch.xen.vcpu_time_info_cache);
 		else
 			data->u.gpa = KVM_XEN_INVALID_GPA;
 		r = 0;
@@ -975,7 +976,7 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 			break;
 		}
 		if (vcpu->arch.xen.runstate_cache.active) {
-			data->u.gpa = vcpu->arch.xen.runstate_cache.gpa;
+			data->u.gpa = kvm_gpc_gpa(&vcpu->arch.xen.runstate_cache);
 			r = 0;
 		}
 		break;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c71e8fbccaaf..4d8027fe9928 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1374,6 +1374,13 @@ void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc);
  */
 void kvm_gpc_mark_dirty(struct gfn_to_pfn_cache *gpc);
 
+/**
+ * kvm_gpc_gpa - retrieve the guest physical address of a cached mapping
+ *
+ * @gpc:	   struct gfn_to_pfn_cache object.
+ */
+gpa_t kvm_gpc_gpa(struct gfn_to_pfn_cache *gpc);
+
 void kvm_sigset_activate(struct kvm_vcpu *vcpu);
 void kvm_sigset_deactivate(struct kvm_vcpu *vcpu);
 
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index b68ed7fa56a2..17afbb464a70 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -386,6 +386,12 @@ int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_activate);
 
+gpa_t kvm_gpc_gpa(struct gfn_to_pfn_cache *gpc)
+{
+	return gpc->gpa;
+}
+EXPORT_SYMBOL_GPL(kvm_gpc_gpa);
+
 void kvm_gpc_mark_dirty(struct gfn_to_pfn_cache *gpc)
 {
 	mark_page_dirty_in_slot(gpc->kvm, gpc->memslot, gpc->gpa >> PAGE_SHIFT);
-- 
2.39.2

