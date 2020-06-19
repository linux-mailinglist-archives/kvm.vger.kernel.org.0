Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D8B201162
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 17:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393934AbgFSPlF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 11:41:05 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27490 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2393882AbgFSPkP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Jun 2020 11:40:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592581214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BaRomvnfjue0tu8cBdiZKDG1ddjd2ZQd0aQj0OLIxlI=;
        b=QwTp6bnvIroaqqui3zCuHiynMnJp21+i+vhkvC8wVRvHCCIhMAFrRXdhhgO7AN4vr5tRM/
        vFmdH+/RnVBgaXa0umabnm0JjXkdL2TOE1z9kjhWqdz2ijkbMt/tUt7r4MSqDuU+R+j6fX
        OEPMuj5aM1vwXyWo47s3Tioe+MJflmY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-zZovgldMPQez88J8f2yAMA-1; Fri, 19 Jun 2020 11:40:11 -0400
X-MC-Unique: zZovgldMPQez88J8f2yAMA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A1DC7107B265;
        Fri, 19 Jun 2020 15:40:09 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-254.ams2.redhat.com [10.36.112.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0281560BF4;
        Fri, 19 Jun 2020 15:40:06 +0000 (UTC)
From:   Mohammed Gamal <mgamal@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, thomas.lendacky@amd.com,
        babu.moger@amd.com, Mohammed Gamal <mgamal@redhat.com>
Subject: [PATCH v2 09/11] KVM: SVM: introduce svm_need_pf_intercept
Date:   Fri, 19 Jun 2020 17:39:23 +0200
Message-Id: <20200619153925.79106-10-mgamal@redhat.com>
In-Reply-To: <20200619153925.79106-1-mgamal@redhat.com>
References: <20200619153925.79106-1-mgamal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CC: Tom Lendacky <thomas.lendacky@amd.com>
CC: Babu Moger <babu.moger@amd.com>
Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 8 ++++++++
 arch/x86/kvm/svm/svm.h | 6 ++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 94108e6cc6da..05412818027d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1087,6 +1087,9 @@ static void init_vmcb(struct vcpu_svm *svm)
 	}
 	svm->asid_generation = 0;
 
+	if (svm_need_pf_intercept(svm))
+		set_exception_intercept(svm, PF_VECTOR);
+
 	svm->nested.vmcb = 0;
 	svm->vcpu.arch.hflags = 0;
 
@@ -1633,6 +1636,11 @@ static void update_exception_bitmap(struct kvm_vcpu *vcpu)
 
 	clr_exception_intercept(svm, BP_VECTOR);
 
+	if (svm_need_pf_intercept(svm))
+		set_exception_intercept(svm, PF_VECTOR);
+	else
+		clr_exception_intercept(svm, PF_VECTOR);
+
 	if (vcpu->guest_debug & KVM_GUESTDBG_ENABLE) {
 		if (vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP)
 			set_exception_intercept(svm, BP_VECTOR);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6ac4c00a5d82..2b7469f3db0e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -19,6 +19,7 @@
 #include <linux/kvm_host.h>
 
 #include <asm/svm.h>
+#include "cpuid.h"
 
 static const u32 host_save_user_msrs[] = {
 #ifdef CONFIG_X86_64
@@ -345,6 +346,11 @@ static inline bool gif_set(struct vcpu_svm *svm)
 		return !!(svm->vcpu.arch.hflags & HF_GIF_MASK);
 }
 
+static inline bool svm_need_pf_intercept(struct vcpu_svm *svm)
+{
+        return !npt_enabled;
+}
+
 /* svm.c */
 #define MSR_INVALID			0xffffffffU
 
-- 
2.26.2

