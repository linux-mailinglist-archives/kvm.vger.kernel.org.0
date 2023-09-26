Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABFC7AEC76
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 14:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234668AbjIZMUz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 08:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234623AbjIZMUm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 08:20:42 -0400
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF7610A;
        Tue, 26 Sep 2023 05:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
        s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From;
        bh=l33abFY8+LeWK4/A7cj6ffiqEBnVQtpFfXFd8rLMTOU=; b=ooXL6ar2M5Gn2JUvqj+he7LZnK
        kjbJl0iNzZdaHKykS3iFsJ9gpdc5AYZdwVmPLZcvhc9vUX7HBgxg10CFP3PTv5/vEYQicOPGCixwi
        zmVOHRkmX0cY+Gvrq6A65LtvEHJOf+8kYx5/yxGpmk6CkcNIoSQSbCpPEAuO9J7QYB2Y=;
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1ql73G-0000HN-DJ; Tue, 26 Sep 2023 12:20:30 +0000
Received: from ec2-63-33-11-17.eu-west-1.compute.amazonaws.com ([63.33.11.17] helo=REM-PW02S00X.ant.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1ql73G-0001mF-5h; Tue, 26 Sep 2023 12:20:30 +0000
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
Subject: [PATCH v6 07/11] KVM: xen: allow vcpu_info to be mapped by fixed HVA
Date:   Tue, 26 Sep 2023 12:20:09 +0000
Message-Id: <20230926122013.867391-8-paul@xen.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230926122013.867391-1-paul@xen.org>
References: <20230926122013.867391-1-paul@xen.org>
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

If the guest does not explicitly set the GPA of vcpu_info structure in
memory then, for guests with 32 vCPUs or fewer, the vcpu_info embedded
in the shared_info page may be used. As described in a previous commit,
the shared_info page is an overlay at a fixed HVA within the VMM, so in
this case it also more optimal to activate the vcpu_info cache with a
fixed HVA to avoid unnecessary invalidation if the guest memory layout
is modified.

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

v5:
 - New in this version.
---
 Documentation/virt/kvm/api.rst | 26 +++++++++++++++++++++-----
 arch/x86/kvm/xen.c             | 33 +++++++++++++++++++++++++++------
 include/uapi/linux/kvm.h       |  3 +++
 3 files changed, 51 insertions(+), 11 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index e9df4df6fe48..5adc6dfc8c6e 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5444,11 +5444,12 @@ KVM_XEN_ATTR_TYPE_SHARED_INFO
   Sets the guest physical frame number at which the Xen shared_info
   page resides. Note that although Xen places vcpu_info for the first
   32 vCPUs in the shared_info page, KVM does not automatically do so
-  and instead requires that KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO be used
-  explicitly even when the vcpu_info for a given vCPU resides at the
-  "default" location in the shared_info page. This is because KVM may
-  not be aware of the Xen CPU id which is used as the index into the
-  vcpu_info[] array, so may know the correct default location.
+  and instead requires that KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO or
+  KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO_HVA be used explicitly even when
+  the vcpu_info for a given vCPU resides at the "default" location
+  in the shared_info page. This is because KVM may not be aware of
+  the Xen CPU id which is used as the index into the vcpu_info[]
+  array, so may know the correct default location.
 
   Note that the shared_info page may be constantly written to by KVM;
   it contains the event channel bitmap used to deliver interrupts to
@@ -5570,6 +5571,21 @@ KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO
   on dirty logging. Setting the gpa to KVM_XEN_INVALID_GPA will disable
   the vcpu_info.
 
+KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO_HVA
+  If the KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA flag is also set in the
+  Xen capabilities, then this attribute may be used to set the
+  userspace address of the vcpu_info for a given vCPU. It should
+  only be used when the vcpu_info resides at the "default" location
+  in the shared_info page. In this case it is safe to assume the
+  userspace address will not change, because the shared_info page is
+  an overlay on guest memory and remains at a fixed host address
+  regardless of where it is mapped in guest physical address space
+  and hence unnecessary invalidation of an internal cache may be
+  avoided if the guest memory layout is modified.
+  If the vcpu_info does not reside at the "default" location then
+  it is not guaranteed to remain at the same host address and
+  hence the aforementioned cache invalidation is required.
+
 KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO
   Sets the guest physical address of an additional pvclock structure
   for a given vCPU. This is typically used for guest vsyscall support.
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 1abb4547642a..aafc794940e4 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -736,20 +736,33 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 
 	switch (data->type) {
 	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO:
+	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO_HVA:
 		/* No compat necessary here. */
 		BUILD_BUG_ON(sizeof(struct vcpu_info) !=
 			     sizeof(struct compat_vcpu_info));
 		BUILD_BUG_ON(offsetof(struct vcpu_info, time) !=
 			     offsetof(struct compat_vcpu_info, time));
 
-		if (data->u.gpa == KVM_XEN_INVALID_GPA) {
-			kvm_gpc_deactivate(&vcpu->arch.xen.vcpu_info_cache);
-			r = 0;
-			break;
+		if (data->type == KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO) {
+			if (data->u.gpa == KVM_XEN_INVALID_GPA) {
+				kvm_gpc_deactivate(&vcpu->arch.xen.vcpu_info_cache);
+				r = 0;
+				break;
+			}
+
+			r = kvm_gpc_activate(&vcpu->arch.xen.vcpu_info_cache,
+					     data->u.gpa, sizeof(struct vcpu_info));
+		} else {
+			if (data->u.hva == 0) {
+				kvm_gpc_deactivate(&vcpu->arch.xen.vcpu_info_cache);
+				r = 0;
+				break;
+			}
+
+			r = kvm_gpc_activate_hva(&vcpu->arch.xen.vcpu_info_cache,
+						 data->u.hva, sizeof(struct vcpu_info));
 		}
 
-		r = kvm_gpc_activate(&vcpu->arch.xen.vcpu_info_cache,
-				     data->u.gpa, sizeof(struct vcpu_info));
 		if (!r)
 			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 
@@ -978,6 +991,14 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 		r = 0;
 		break;
 
+	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO_HVA:
+		if (vcpu->arch.xen.vcpu_info_cache.active)
+			data->u.hva = kvm_gpc_hva(&vcpu->arch.xen.vcpu_info_cache);
+		else
+			data->u.hva = 0;
+		r = 0;
+		break;
+
 	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO:
 		if (vcpu->arch.xen.vcpu_time_info_cache.active)
 			data->u.gpa = kvm_gpc_gpa(&vcpu->arch.xen.vcpu_time_info_cache);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 062bfa14b4d9..0267c2ef43de 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1858,6 +1858,7 @@ struct kvm_xen_vcpu_attr {
 	union {
 		__u64 gpa;
 #define KVM_XEN_INVALID_GPA ((__u64)-1)
+		__u64 hva;
 		__u64 pad[8];
 		struct {
 			__u64 state;
@@ -1888,6 +1889,8 @@ struct kvm_xen_vcpu_attr {
 #define KVM_XEN_VCPU_ATTR_TYPE_VCPU_ID		0x6
 #define KVM_XEN_VCPU_ATTR_TYPE_TIMER		0x7
 #define KVM_XEN_VCPU_ATTR_TYPE_UPCALL_VECTOR	0x8
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA */
+#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO_HVA	0x9
 
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
-- 
2.39.2

