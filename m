Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72B957A4E42
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjIRQJ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjIRQJW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:09:22 -0400
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F58D49C8;
        Mon, 18 Sep 2023 09:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
        s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From;
        bh=Oc53yzU2VCdUyIo3BjcPhE5hr1+ghEoPGq4cggTejWY=; b=R/WcIPwhyvbzwQowjQg0taQRF7
        mgRpElbPoVEYQLzQux7XmW2HdWINeMgZ8KT/ooK55CxcHrecXjIxuoJl2TpjufIdb1ftAu/zVYLkP
        ySz/H1HlWPq0jGQVNlxWKP/WPDyhv6rtzScpwYdzLAf9YiwVFCbKyfz0sPWPrbYJd1bE=;
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qiFRI-0003Rs-6X; Mon, 18 Sep 2023 14:41:28 +0000
Received: from ec2-63-33-11-17.eu-west-1.compute.amazonaws.com ([63.33.11.17] helo=REM-PW02S00X.ant.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qiFRH-0006IJ-VD; Mon, 18 Sep 2023 14:41:28 +0000
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
Subject: [PATCH v3 09/13] KVM: xen: automatically use the vcpu_info embedded in shared_info
Date:   Mon, 18 Sep 2023 14:41:07 +0000
Message-Id: <20230918144111.641369-10-paul@xen.org>
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

The VMM should only need to set the KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO
attribute in response to a VCPUOP_register_vcpu_info hypercall. We can
handle the default case internally since we already know where the
shared_info page is. Modify get_vcpu_info_cache() to pass back a pointer
to the shared info pfn cache (and appropriate offset) for any of the
first 32 vCPUs if the attribute has not been set.

A VMM will be able to determine whether it needs to set up default
vcpu_info using the previously defined KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA
Xen capability flag, which will be advertized in a subsequent patch.

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

v3:
 - Add a note to the API documentation discussing vcpu_info copying.

v2:
 - Dispense with the KVM_XEN_HVM_CONFIG_DEFAULT_VCPU_INFO capability.
 - Add API documentation.
---
 Documentation/virt/kvm/api.rst | 22 +++++++++++++++-------
 arch/x86/kvm/xen.c             | 15 +++++++++++++++
 2 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index e9df4df6fe48..47bf3db74674 100644
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
+  The vcpu_info for the first 32 vCPUs defaults to the structures
+  embedded in the shared_info page.
+
+  If the KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA flag is also set in the
+  Xen capabilities then the VMM is not required to set this default
+  location; KVM will handle that internally. Otherwise this attribute
+  must be set for all vCPUs.
+
   As with the shared_info page for the VM, the corresponding page may be
   dirtied at any time if event channel interrupt delivery is enabled, so
   userspace should always assume that the page is dirty without relying
   on dirty logging. Setting the gpa to KVM_XEN_INVALID_GPA will disable
   the vcpu_info.
 
+  Note that, if the guest sets an explicit vcpu_info location in guest
+  memory then the VMM is expected to copy the content of the structure
+  embedded in the shared_info page to the new location. It is therefore
+  important that no event delivery is in progress at this time, otherwise
+  events may be missed.
+
 KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO
   Sets the guest physical address of an additional pvclock structure
   for a given vCPU. This is typically used for guest vsyscall support.
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 459f3ca4710e..660a808c0b50 100644
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
 
-- 
2.39.2

