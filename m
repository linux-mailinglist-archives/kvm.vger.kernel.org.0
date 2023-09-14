Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A871A79FF92
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 11:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237070AbjINJHY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 05:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237134AbjINJHQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 05:07:16 -0400
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DFF11BF9;
        Thu, 14 Sep 2023 02:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
        s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From;
        bh=b1ozqveOAFRuO/wOLzb/wpotEM9GW9TMSEMYXUlq+eo=; b=seWWyEITPDYjae4Nj30M50y4M3
        HgTVvcdf04i37rSRTFWMkg+p4yMK7DRpKb4KtFf9Rn+ngHcUlgmr2q7D7K6DcHk2poBFQ5LmL/5eX
        hBBLHHZBCV+EQ/Hfu4hn0bVQYXXl/tGGqcQQi17tMebimnVGwgqnAXFMzPf1E7p/QWqg=;
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qgi3O-0001kl-Rt; Thu, 14 Sep 2023 08:50:26 +0000
Received: from ec2-63-33-11-17.eu-west-1.compute.amazonaws.com ([63.33.11.17] helo=REM-PW02S00X.ant.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qgi3O-0002T9-Ij; Thu, 14 Sep 2023 08:50:26 +0000
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
Subject: [PATCH 8/8] KVM: xen: automatically use the vcpu_info embedded in shared_info
Date:   Thu, 14 Sep 2023 08:49:46 +0000
Message-Id: <20230914084946.200043-9-paul@xen.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230914084946.200043-1-paul@xen.org>
References: <20230914084946.200043-1-paul@xen.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paul Durrant <pdurrant@amazon.com>

Add a KVM_XEN_HVM_CONFIG_DEFAULT_VCPU_INFO flag so that the VMM knows it
need only set the KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO attribute in response to
a VCPUOP_register_vcpu_info hypercall, and modify get_vcpu_info_cache()
to pass back a pointer to the shared info pfn cache (and appropriate
offset) for any of the first 32 vCPUs if the attribute has not been set.

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
---
 arch/x86/kvm/x86.c       |  3 ++-
 arch/x86/kvm/xen.c       | 15 +++++++++++++++
 include/uapi/linux/kvm.h |  1 +
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4cd577d01bc4..cdce8c463a1b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4528,7 +4528,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		    KVM_XEN_HVM_CONFIG_SHARED_INFO |
 		    KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL |
 		    KVM_XEN_HVM_CONFIG_EVTCHN_SEND |
-		    KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA;
+		    KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA |
+		    KVM_XEN_HVM_CONFIG_DEFAULT_VCPU_INFO;
 		if (sched_info_on())
 			r |= KVM_XEN_HVM_CONFIG_RUNSTATE |
 			     KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 892563fea40f..66050a96ba25 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -491,6 +491,21 @@ static void kvm_xen_inject_vcpu_vector(struct kvm_vcpu *v)
 
 struct gfn_to_pfn_cache *get_vcpu_info_cache(struct kvm_vcpu *v, unsigned long *offset)
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
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d3f371bafad8..480612f73fc2 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1283,6 +1283,7 @@ struct kvm_x86_mce {
 #define KVM_XEN_HVM_CONFIG_EVTCHN_SEND		(1 << 5)
 #define KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG	(1 << 6)
 #define KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA	(1 << 7)
+#define KVM_XEN_HVM_CONFIG_DEFAULT_VCPU_INFO	(1 << 8)
 
 struct kvm_xen_hvm_config {
 	__u32 flags;
-- 
2.39.2

