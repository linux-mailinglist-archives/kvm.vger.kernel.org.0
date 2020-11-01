Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4AE2A1DB4
	for <lists+kvm@lfdr.de>; Sun,  1 Nov 2020 12:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgKALzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Nov 2020 06:55:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20881 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726442AbgKALzj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 1 Nov 2020 06:55:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604231737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+q0qWgbd42/dH+vjHbTHT/3/dGQ2ybVNRikzTQrqgn4=;
        b=f2wWfDyMEe9hC+Zy6WOMuZJux8Bk6QfOCgKTv5eQKH2VPdClMRonjbmuZvwmFHF93fwRt+
        00L2foQ4Yw+YqDuv9EeLEKZby2vQD60YXOFrhmWC9lXXE3AItRty10l51L/fpkeZ79t42Z
        /Kjqc8AijWnGnzfOFeHqxaQIjnTem4w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-57-mdjPRHv-O0KmEQFhtWUWWQ-1; Sun, 01 Nov 2020 06:55:36 -0500
X-MC-Unique: mdjPRHv-O0KmEQFhtWUWWQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED217185A0C3;
        Sun,  1 Nov 2020 11:55:33 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4EE0B109F1A6;
        Sun,  1 Nov 2020 11:55:25 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)),
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>, Qian Cai <cai@redhat.com>
Subject: [PATCH] KVM: x86: use positive error values for msr emulation that causes #GP
Date:   Sun,  1 Nov 2020 13:55:23 +0200
Message-Id: <20201101115523.115780-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Recent introduction of the userspace msr filtering added code that uses
negative error codes for cases that result in either #GP delivery to
the guest, or handled by the userspace msr filtering.

This breaks an assumption that a negative error code returned from the
msr emulation code is a semi-fatal error which should be returned
to userspace via KVM_RUN ioctl and usually kill the guest.

Fix this by reusing the already existing KVM_MSR_RET_INVALID error code,
and by adding a new KVM_MSR_RET_FILTERED error code for the
userspace filtered msrs.

Fixes: 291f35fb2c1d1 ("KVM: x86: report negative values from wrmsr emulation to userspace")
Reported-by: Qian Cai <cai@redhat.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 29 +++++++++++++++--------------
 arch/x86/kvm/x86.h |  8 +++++++-
 2 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 397f599b20e5a..537130d78b2af 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -255,11 +255,10 @@ static struct kmem_cache *x86_emulator_cache;
 
 /*
  * When called, it means the previous get/set msr reached an invalid msr.
- * Return 0 if we want to ignore/silent this failed msr access, or 1 if we want
- * to fail the caller.
+ * Return true if we want to ignore/silent this failed msr access.
  */
-static int kvm_msr_ignored_check(struct kvm_vcpu *vcpu, u32 msr,
-				 u64 data, bool write)
+static bool kvm_msr_ignored_check(struct kvm_vcpu *vcpu, u32 msr,
+				  u64 data, bool write)
 {
 	const char *op = write ? "wrmsr" : "rdmsr";
 
@@ -267,12 +266,11 @@ static int kvm_msr_ignored_check(struct kvm_vcpu *vcpu, u32 msr,
 		if (report_ignored_msrs)
 			vcpu_unimpl(vcpu, "ignored %s: 0x%x data 0x%llx\n",
 				    op, msr, data);
-		/* Mask the error */
-		return 0;
+		return true;
 	} else {
 		vcpu_debug_ratelimited(vcpu, "unhandled %s: 0x%x data 0x%llx\n",
 				       op, msr, data);
-		return -ENOENT;
+		return false;
 	}
 }
 
@@ -1416,7 +1414,8 @@ static int do_get_msr_feature(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 	if (r == KVM_MSR_RET_INVALID) {
 		/* Unconditionally clear the output for simplicity */
 		*data = 0;
-		r = kvm_msr_ignored_check(vcpu, index, 0, false);
+		if (kvm_msr_ignored_check(vcpu, index, 0, false))
+			r = 0;
 	}
 
 	if (r)
@@ -1540,7 +1539,7 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 	struct msr_data msr;
 
 	if (!host_initiated && !kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_WRITE))
-		return -EPERM;
+		return KVM_MSR_RET_FILTERED;
 
 	switch (index) {
 	case MSR_FS_BASE:
@@ -1581,7 +1580,8 @@ static int kvm_set_msr_ignored_check(struct kvm_vcpu *vcpu,
 	int ret = __kvm_set_msr(vcpu, index, data, host_initiated);
 
 	if (ret == KVM_MSR_RET_INVALID)
-		ret = kvm_msr_ignored_check(vcpu, index, data, true);
+		if (kvm_msr_ignored_check(vcpu, index, data, true))
+			ret = 0;
 
 	return ret;
 }
@@ -1599,7 +1599,7 @@ int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
 	int ret;
 
 	if (!host_initiated && !kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_READ))
-		return -EPERM;
+		return KVM_MSR_RET_FILTERED;
 
 	msr.index = index;
 	msr.host_initiated = host_initiated;
@@ -1618,7 +1618,8 @@ static int kvm_get_msr_ignored_check(struct kvm_vcpu *vcpu,
 	if (ret == KVM_MSR_RET_INVALID) {
 		/* Unconditionally clear *data for simplicity */
 		*data = 0;
-		ret = kvm_msr_ignored_check(vcpu, index, 0, false);
+		if (kvm_msr_ignored_check(vcpu, index, 0, false))
+			ret = 0;
 	}
 
 	return ret;
@@ -1662,9 +1663,9 @@ static int complete_emulated_wrmsr(struct kvm_vcpu *vcpu)
 static u64 kvm_msr_reason(int r)
 {
 	switch (r) {
-	case -ENOENT:
+	case KVM_MSR_RET_INVALID:
 		return KVM_MSR_EXIT_REASON_UNKNOWN;
-	case -EPERM:
+	case KVM_MSR_RET_FILTERED:
 		return KVM_MSR_EXIT_REASON_FILTER;
 	default:
 		return KVM_MSR_EXIT_REASON_INVAL;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 3900ab0c6004d..e7ca622a468f5 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -376,7 +376,13 @@ int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
 int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva);
 bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
 
-#define  KVM_MSR_RET_INVALID  2
+/*
+ * Internal error codes that are used to indicate that MSR emulation encountered
+ * an error that should result in #GP in the guest, unless userspace
+ * handles it.
+ */
+#define  KVM_MSR_RET_INVALID	2	/* in-kernel MSR emulation #GP condition */
+#define  KVM_MSR_RET_FILTERED	3	/* #GP due to userspace MSR filter */
 
 #define __cr4_reserved_bits(__cpu_has, __c)             \
 ({                                                      \
-- 
2.26.2

