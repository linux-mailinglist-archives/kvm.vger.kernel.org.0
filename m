Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5448C7A6584
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 15:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232586AbjISNml (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Sep 2023 09:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbjISNmc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Sep 2023 09:42:32 -0400
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD11123;
        Tue, 19 Sep 2023 06:42:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
        s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From;
        bh=U+rtPhgXdgIIGsYQQvVCaE4NK9nElUAjd2cFRLMOB5o=; b=6xjSJpx1B2G3GZlCMoYVeWXt4A
        0dB0LqqQLX4o7GE+qKNTEyaCZhXm2z6VGKsW5FfhQKrv4KPVsmb5ejGwzDMOfRjpgiNxl9bXJMniD
        UFrmgth7jzA+mWJkCb2Ux1WzBthxVAOncWV3mmr7JjDMC+fQJGTeO/SgWHvU4L9ltvQ8=;
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qiazQ-00047M-RG; Tue, 19 Sep 2023 13:42:08 +0000
Received: from ec2-63-33-11-17.eu-west-1.compute.amazonaws.com ([63.33.11.17] helo=REM-PW02S00X.ant.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qiazQ-0005jy-Je; Tue, 19 Sep 2023 13:42:08 +0000
From:   Paul Durrant <paul@xen.org>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        David Woodhouse <dwmw2@infradead.org>, x86@kernel.org
Subject: [PATCH v4 09/13] KVM: xen: automatically use the vcpu_info embedded in shared_info
Date:   Tue, 19 Sep 2023 13:41:45 +0000
Message-Id: <20230919134149.6091-10-paul@xen.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230919134149.6091-1-paul@xen.org>
References: <20230919134149.6091-1-paul@xen.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paul Durrant <pdurrant@amazon.com>

The VMM should only need to set the KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO
attribute in response to a VCPUOP_register_vcpu_info hypercall. We can
handle the default case internally since we already know where the
shared_info page is. Modify get_vcpu_info_cache() to pass back a pointer
to the shared info pfn cache (and appropriate offset) for any of the
first 32 vCPUs if the attribute has not been set.

A VMM will be able to determine whether it needs to set up default
vcpu_info using the previously defined KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA
Xen capability flag, which will be advertized in a subsequent patch.

If the VMM subsequently sets a vcpu_info in response to the aforementioned
hypercall then the content of the default vcpu_info will be copied to the
new location.

Also update the KVM API documentation to describe the new behaviour.

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

v4:
 - Copy the default vcpu_info content when an explicit vcpu_info is set.
 - Amend API documentation.

v3:
 - Add a note to the API documentation discussing vcpu_info copying.

v2:
 - Dispense with the KVM_XEN_HVM_CONFIG_DEFAULT_VCPU_INFO capability.
 - Add API documentation.
---
 Documentation/virt/kvm/api.rst |  22 ++++---
 arch/x86/kvm/xen.c             | 110 ++++++++++++++++++++++++++++++---
 2 files changed, 117 insertions(+), 15 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 8d85fd7709f0..48c86108efca 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5442,13 +5442,7 @@ KVM_XEN_ATTR_TYPE_LONG_MODE
 
 KVM_XEN_ATTR_TYPE_SHARED_INFO
   Sets the guest physical frame number at which the Xen shared_info
-  page resides. Note that although Xen places vcpu_info for the first
-  32 vCPUs in the shared_info page, KVM does not automatically do so
-  and instead requires that KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO be used
-  explicitly even when the vcpu_info for a given vCPU resides at the
-  "default" location in the shared_info page. This is because KVM may
-  not be aware of the Xen CPU id which is used as the index into the
-  vcpu_info[] array, so may know the correct default location.
+  page resides.
 
   Note that the shared_info page may be constantly written to by KVM;
   it contains the event channel bitmap used to deliver interrupts to
@@ -5564,12 +5558,26 @@ type values:
 
 KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO
   Sets the guest physical address of the vcpu_info for a given vCPU.
+  The location of the shared_info page for the VM must be specified before
+  this attribute is set.
+
+  If the KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA flag is also set in the
+  Xen capabilities then the VMM is not required to set this default
+  location for any of the first 32 vCPUs; KVM will handle that
+  internally (using the vcpu_info embedded in the shared_info page).
+  Otherwise this attribute must be set for all vCPUs.
+
   As with the shared_info page for the VM, the corresponding page may be
   dirtied at any time if event channel interrupt delivery is enabled, so
   userspace should always assume that the page is dirty without relying
   on dirty logging. Setting the gpa to KVM_XEN_INVALID_GPA will disable
   the vcpu_info.
 
+  Note that once vcpu_info is set then it may not be set again unless
+  it is explicitly disabled beforehand. If it is set for any of the
+  first 32 vCPUS then the content of the default vcpu_info will be copied
+  into the specified location.
+
 KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO
   Sets the guest physical address of an additional pvclock structure
   for a given vCPU. This is typically used for guest vsyscall support.
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index a9aada47e9b8..f0ac535300dd 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -491,6 +491,21 @@ static void kvm_xen_inject_vcpu_vector(struct kvm_vcpu *v)
 
 static struct gfn_to_pfn_cache *get_vcpu_info_cache(struct kvm_vcpu *v, unsigned long *offset)
 {
+	if (!v->arch.xen.vcpu_info_cache.active && v->arch.xen.vcpu_id < MAX_VIRT_CPUS) {
+		struct kvm *kvm = v->kvm;
+
+		if (offset) {
+			if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode)
+				*offset = offsetof(struct shared_info,
+						   vcpu_info[v->arch.xen.vcpu_id]);
+			else
+				*offset = offsetof(struct compat_shared_info,
+						   vcpu_info[v->arch.xen.vcpu_id]);
+		}
+
+		return &kvm->arch.xen.shinfo_cache;
+	}
+
 	if (offset)
 		*offset = 0;
 
@@ -764,6 +779,92 @@ static int kvm_xen_set_vcpu_id(struct kvm_vcpu *vcpu, unsigned int vcpu_id)
 	return 0;
 }
 
+static int kvm_xen_set_vcpu_info(struct kvm_vcpu *vcpu, gpa_t gpa)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct gfn_to_pfn_cache *si_gpc = &kvm->arch.xen.shinfo_cache;
+	struct gfn_to_pfn_cache *vi_gpc = &vcpu->arch.xen.vcpu_info_cache;
+	unsigned long flags;
+	unsigned long offset;
+	int ret;
+
+	if (gpa == KVM_XEN_INVALID_GPA) {
+		kvm_gpc_deactivate(vi_gpc);
+		return 0;
+	}
+
+	/*
+	 * In Xen it is not possible for an explicit vcpu_info to be set
+	 * before the shared_info exists since the former is done in response
+	 * to a hypercall and the latter is set up as part of domain creation.
+	 * The first 32 vCPUs have a default vcpu_info embedded in shared_info
+	 * the content of which is copied across when an explicit vcpu_info is
+	 * set, which can also clearly not be done if we don't know where the
+	 * shared_info is. Hence we need to enforce that the shared_info cache
+	 * is active here.
+	 */
+	if (!si_gpc->active)
+		return -EINVAL;
+
+	/* Setting an explicit vcpu_info is a one-off operation */
+	if (vi_gpc->active)
+		return -EINVAL;
+
+	ret = kvm_gpc_activate(vi_gpc, gpa, sizeof(struct vcpu_info));
+	if (ret)
+		return ret;
+
+	/* Nothing more to do if the vCPU is not among the first 32 */
+	if (vcpu->arch.xen.vcpu_id >= MAX_VIRT_CPUS)
+		return 0;
+
+	/*
+	 * It's possible that the vcpu_info cache has been invalidated since
+	 * we activated it so we need to go through the check-refresh dance.
+	 */
+	read_lock_irqsave(&vi_gpc->lock, flags);
+	while (!kvm_gpc_check(vi_gpc, sizeof(struct vcpu_info))) {
+		read_unlock_irqrestore(&vi_gpc->lock, flags);
+
+		ret = kvm_gpc_refresh(vi_gpc, sizeof(struct vcpu_info));
+		if (ret) {
+			kvm_gpc_deactivate(vi_gpc);
+			return ret;
+		}
+
+		read_lock_irqsave(&vi_gpc->lock, flags);
+	}
+
+	/* Now lock the shared_info cache so we can copy the vcpu_info */
+	read_lock(&si_gpc->lock);
+	while (!kvm_gpc_check(si_gpc, PAGE_SIZE)) {
+		read_unlock(&si_gpc->lock);
+
+		ret = kvm_gpc_refresh(si_gpc, PAGE_SIZE);
+		if (ret) {
+			read_unlock_irqrestore(&vi_gpc->lock, flags);
+			kvm_gpc_deactivate(vi_gpc);
+			return ret;
+		}
+
+		read_lock(&si_gpc->lock);
+	}
+
+	if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode)
+		offset = offsetof(struct shared_info,
+				  vcpu_info[vcpu->arch.xen.vcpu_id]);
+	else
+		offset = offsetof(struct compat_shared_info,
+				  vcpu_info[vcpu->arch.xen.vcpu_id]);
+
+	memcpy(vi_gpc->khva, si_gpc->khva + offset, sizeof(struct vcpu_info));
+
+	read_unlock(&si_gpc->lock);
+	read_unlock_irqrestore(&vi_gpc->lock, flags);
+
+	return 0;
+}
+
 int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 {
 	int idx, r = -ENOENT;
@@ -779,14 +880,7 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 		BUILD_BUG_ON(offsetof(struct vcpu_info, time) !=
 			     offsetof(struct compat_vcpu_info, time));
 
-		if (data->u.gpa == KVM_XEN_INVALID_GPA) {
-			kvm_gpc_deactivate(&vcpu->arch.xen.vcpu_info_cache);
-			r = 0;
-			break;
-		}
-
-		r = kvm_gpc_activate(&vcpu->arch.xen.vcpu_info_cache,
-				     data->u.gpa, sizeof(struct vcpu_info));
+		r = kvm_xen_set_vcpu_info(vcpu, data->u.gpa);
 		if (!r)
 			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 
-- 
2.39.2

