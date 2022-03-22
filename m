Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D754E4508
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 18:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239663AbiCVR0v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 13:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239632AbiCVR0t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 13:26:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A8BFA49F29
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 10:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647969920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0nD0f4ohe3Iz1X7Qm4QJaPpSnCIA0gc8Jw6mHd+dPZ0=;
        b=L66FLmnK7VcbMKbgUwB2w0ETdmMGxMSl2/50medriy+Zo7MZDwnAfAfjQ5fC9QuWH7ypBZ
        MZhpq7+IBAYtPwiDuznWBuurFFdWbjBCrIVtMnFq+k6KBPcpLdybm/ny3Tr56yvp0tQmdS
        hdsLt2PvYu+Vve6GN76WFEOg0JXYCaU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-283-_r9rqOeMPvOXIsL4g5ygKg-1; Tue, 22 Mar 2022 13:25:17 -0400
X-MC-Unique: _r9rqOeMPvOXIsL4g5ygKg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D1C4B802803;
        Tue, 22 Mar 2022 17:25:16 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7DDB92166B2D;
        Tue, 22 Mar 2022 17:25:13 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 4/8] KVM: x86: SVM: fix avic spec based definitions again
Date:   Tue, 22 Mar 2022 19:24:45 +0200
Message-Id: <20220322172449.235575-5-mlevitsk@redhat.com>
In-Reply-To: <20220322172449.235575-1-mlevitsk@redhat.com>
References: <20220322172449.235575-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Due to wrong rebase, commit
4a204f7895878 ("KVM: SVM: Allow AVIC support on system w/ physical APIC ID > 255")

moved avic spec #defines back to avic.c.

Move them back, and while at it extend AVIC_DOORBELL_PHYSICAL_ID_MASK to 12
bits as well (it will be used in nested avic)

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/svm.h |  8 +++++---
 arch/x86/kvm/svm/svm.h     | 11 -----------
 2 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 7eb2df5417fb..ab572d8def2b 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -222,7 +222,7 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 
 
 /* AVIC */
-#define AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK	(0xFF)
+#define AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK	(0xFFULL)
 #define AVIC_LOGICAL_ID_ENTRY_VALID_BIT			31
 #define AVIC_LOGICAL_ID_ENTRY_VALID_MASK		(1 << 31)
 
@@ -230,9 +230,11 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK	(0xFFFFFFFFFFULL << 12)
 #define AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK		(1ULL << 62)
 #define AVIC_PHYSICAL_ID_ENTRY_VALID_MASK		(1ULL << 63)
-#define AVIC_PHYSICAL_ID_TABLE_SIZE_MASK		(0xFF)
+#define AVIC_PHYSICAL_ID_TABLE_SIZE_MASK		(0xFFULL)
 
-#define AVIC_DOORBELL_PHYSICAL_ID_MASK			(0xFF)
+#define AVIC_DOORBELL_PHYSICAL_ID_MASK			GENMASK_ULL(11, 0)
+
+#define VMCB_AVIC_APIC_BAR_MASK				0xFFFFFFFFFF000ULL
 
 #define AVIC_UNACCEL_ACCESS_WRITE_MASK		1
 #define AVIC_UNACCEL_ACCESS_OFFSET_MASK		0xFF0
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d07a5b88ea96..468f149556dd 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -577,17 +577,6 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 
 /* avic.c */
 
-#define AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK	(0xFF)
-#define AVIC_LOGICAL_ID_ENTRY_VALID_BIT			31
-#define AVIC_LOGICAL_ID_ENTRY_VALID_MASK		(1 << 31)
-
-#define AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK	GENMASK_ULL(11, 0)
-#define AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK	(0xFFFFFFFFFFULL << 12)
-#define AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK		(1ULL << 62)
-#define AVIC_PHYSICAL_ID_ENTRY_VALID_MASK		(1ULL << 63)
-
-#define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
-
 int avic_ga_log_notifier(u32 ga_tag);
 void avic_vm_destroy(struct kvm *kvm);
 int avic_vm_init(struct kvm *kvm);
-- 
2.26.3

