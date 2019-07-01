Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29955174D3
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 11:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbfEHJQB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 05:16:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50816 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727016AbfEHJQB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 05:16:01 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CC66981F13
        for <kvm@vger.kernel.org>; Wed,  8 May 2019 09:16:00 +0000 (UTC)
Received: from xz-x1.nay.redhat.com (dhcp-15-205.nay.redhat.com [10.66.15.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B998A61B74;
        Wed,  8 May 2019 09:15:58 +0000 (UTC)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        peterx@redhat.com, "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: [PATCH v2 3/3] KVM: Introduce KVM_CAP_MANUAL_DIRTY_LOG_PROTECT_2
Date:   Wed,  8 May 2019 17:15:47 +0800
Message-Id: <20190508091547.11963-4-peterx@redhat.com>
In-Reply-To: <20190508091547.11963-1-peterx@redhat.com>
References: <20190508091547.11963-1-peterx@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Wed, 08 May 2019 09:16:00 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The previous KVM_CAP_MANUAL_DIRTY_LOG_PROTECT has some problem which
blocks the correct usage from userspace.  Obsolete the old one and
introduce a new capability bit for it.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 Documentation/virtual/kvm/api.txt            | 13 ++++++++-----
 include/uapi/linux/kvm.h                     |  5 +++--
 tools/testing/selftests/kvm/dirty_log_test.c |  4 ++--
 virt/kvm/kvm_main.c                          |  4 ++--
 4 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 675cb0bea903..f725fb4b243f 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -330,7 +330,7 @@ They must be less than the value that KVM_CHECK_EXTENSION returns for
 the KVM_CAP_MULTI_ADDRESS_SPACE capability.
 
 The bits in the dirty bitmap are cleared before the ioctl returns, unless
-KVM_CAP_MANUAL_DIRTY_LOG_PROTECT is enabled.  For more information,
+KVM_CAP_MANUAL_DIRTY_LOG_PROTECT_2 is enabled.  For more information,
 see the description of the capability.
 
 4.9 KVM_SET_MEMORY_ALIAS
@@ -3791,7 +3791,7 @@ to I/O ports.
 
 4.117 KVM_CLEAR_DIRTY_LOG (vm ioctl)
 
-Capability: KVM_CAP_MANUAL_DIRTY_LOG_PROTECT
+Capability: KVM_CAP_MANUAL_DIRTY_LOG_PROTECT_2
 Architectures: x86
 Type: vm ioctl
 Parameters: struct kvm_dirty_log (in)
@@ -3824,10 +3824,13 @@ the address space for which you want to return the dirty bitmap.
 They must be less than the value that KVM_CHECK_EXTENSION returns for
 the KVM_CAP_MULTI_ADDRESS_SPACE capability.
 
-This ioctl is mostly useful when KVM_CAP_MANUAL_DIRTY_LOG_PROTECT
+This ioctl is mostly useful when KVM_CAP_MANUAL_DIRTY_LOG_PROTECT_2
 is enabled; for more information, see the description of the capability.
 However, it can always be used as long as KVM_CHECK_EXTENSION confirms
-that KVM_CAP_MANUAL_DIRTY_LOG_PROTECT is present.
+that KVM_CAP_MANUAL_DIRTY_LOG_PROTECT_2 is present.
+
+The old name of KVM_CAP_MANUAL_DIRTY_LOG_PROTECT_2 is
+KVM_CAP_MANUAL_DIRTY_LOG_PROTECT but it was obsolete now.
 
 4.118 KVM_GET_SUPPORTED_HV_CPUID
 
@@ -4780,7 +4783,7 @@ and injected exceptions.
 * For the new DR6 bits, note that bit 16 is set iff the #DB exception
   will clear DR6.RTM.
 
-7.18 KVM_CAP_MANUAL_DIRTY_LOG_PROTECT
+7.18 KVM_CAP_MANUAL_DIRTY_LOG_PROTECT_2
 
 Architectures: all
 Parameters: args[0] whether feature should be enabled or not
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6d4ea4b6c922..edab61ec92ef 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -986,8 +986,9 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_HYPERV_ENLIGHTENED_VMCS 163
 #define KVM_CAP_EXCEPTION_PAYLOAD 164
 #define KVM_CAP_ARM_VM_IPA_SIZE 165
-#define KVM_CAP_MANUAL_DIRTY_LOG_PROTECT 166
+#define KVM_CAP_MANUAL_DIRTY_LOG_PROTECT 166 /* Obsolete */
 #define KVM_CAP_HYPERV_CPUID 167
+#define KVM_CAP_MANUAL_DIRTY_LOG_PROTECT_2 168
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1434,7 +1435,7 @@ struct kvm_enc_region {
 #define KVM_GET_NESTED_STATE         _IOWR(KVMIO, 0xbe, struct kvm_nested_state)
 #define KVM_SET_NESTED_STATE         _IOW(KVMIO,  0xbf, struct kvm_nested_state)
 
-/* Available with KVM_CAP_MANUAL_DIRTY_LOG_PROTECT */
+/* Available with KVM_CAP_MANUAL_DIRTY_LOG_PROTECT_2 */
 #define KVM_CLEAR_DIRTY_LOG          _IOWR(KVMIO, 0xc0, struct kvm_clear_dirty_log)
 
 /* Available with KVM_CAP_HYPERV_CPUID */
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 052fb5856df4..eb5f94b113b3 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -311,7 +311,7 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 #ifdef USE_CLEAR_DIRTY_LOG
 	struct kvm_enable_cap cap = {};
 
-	cap.cap = KVM_CAP_MANUAL_DIRTY_LOG_PROTECT;
+	cap.cap = KVM_CAP_MANUAL_DIRTY_LOG_PROTECT_2;
 	cap.args[0] = 1;
 	vm_enable_cap(vm, &cap);
 #endif
@@ -427,7 +427,7 @@ int main(int argc, char *argv[])
 	int opt, i;
 
 #ifdef USE_CLEAR_DIRTY_LOG
-	if (!kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT)) {
+	if (!kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT_2)) {
 		fprintf(stderr, "KVM_CLEAR_DIRTY_LOG not available, skipping tests\n");
 		exit(KSFT_SKIP);
 	}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7883e0ad07fe..c624ef03b7e0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3110,7 +3110,7 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_CHECK_EXTENSION_VM:
 	case KVM_CAP_ENABLE_CAP_VM:
 #ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
-	case KVM_CAP_MANUAL_DIRTY_LOG_PROTECT:
+	case KVM_CAP_MANUAL_DIRTY_LOG_PROTECT_2:
 #endif
 		return 1;
 #ifdef CONFIG_KVM_MMIO
@@ -3148,7 +3148,7 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
 {
 	switch (cap->cap) {
 #ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
-	case KVM_CAP_MANUAL_DIRTY_LOG_PROTECT:
+	case KVM_CAP_MANUAL_DIRTY_LOG_PROTECT_2:
 		if (cap->flags || (cap->args[0] & ~1))
 			return -EINVAL;
 		kvm->manual_dirty_log_protect = cap->args[0];
-- 
2.17.1

