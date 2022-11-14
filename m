Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38508628601
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 17:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237813AbiKNQuu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 11:50:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236205AbiKNQua (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 11:50:30 -0500
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A0B62FC03;
        Mon, 14 Nov 2022 08:49:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1668444574; x=1699980574;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=W/HB3Xe0IyEpEgjwwlHeRnwekQHUqIvwFTZpMp6G+lM=;
  b=MYO5uvfaSqroRvZ+kbNFu8HME5ahb2CYN+S5Aa73qb01yHrQliB4VfOW
   rFWfzOth9iYlZ6Z9prGPptvaK0oJeulDefCrDbROUUsLRObnNza0oShLS
   DGe1nad1iQ4ComO0j9L6et6ol2aHcm5Cb8cZ3/kJFRL2+LP9UJsZroAqQ
   E=;
X-IronPort-AV: E=Sophos;i="5.96,164,1665446400"; 
   d="scan'208";a="150552225"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-26a610d2.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 16:49:23 +0000
Received: from EX13D06EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-26a610d2.us-west-2.amazon.com (Postfix) with ESMTPS id D197041726;
        Mon, 14 Nov 2022 16:49:18 +0000 (UTC)
Received: from EX19D033EUC002.ant.amazon.com (10.252.61.215) by
 EX13D06EUC001.ant.amazon.com (10.43.164.225) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Mon, 14 Nov 2022 16:49:17 +0000
Received: from dev-dsk-hborghor-1a-30381df9.eu-west-1.amazon.com
 (10.43.162.178) by EX19D033EUC002.ant.amazon.com (10.252.61.215) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.20; Mon, 14 Nov
 2022 16:49:13 +0000
From:   Hendrik Borghorst <hborghor@amazon.de>
To:     <hborghor@amazon.de>
CC:     <graf@amazon.de>, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] KVM: x86/vmx: Do not skip segment attributes if unusable bit is set
Date:   Mon, 14 Nov 2022 16:48:23 +0000
Message-ID: <20221114164823.69555-1-hborghor@amazon.de>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
X-Originating-IP: [10.43.162.178]
X-ClientProxiedBy: EX13D21UWB001.ant.amazon.com (10.43.161.108) To
 EX19D033EUC002.ant.amazon.com (10.252.61.215)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When serializing and deserializing kvm_sregs, attributes of the segment
descriptors are stored by user space. For unusable segments,
vmx_segment_access_rights skips all attributes and sets them to 0.

This means we zero out the DPL (Descriptor Privilege Level) for unusable
entries.

Unusable segments are - contrary to their name - usable in 64bit mode and
are used by guests to for example create a linear map through the
NULL selector.

VMENTER checks if SS.DPL is correct depending on the CS segment type.
For types 9 (Execute Only) and 11 (Execute Read), CS.DPL must be equal to
SS.DPL [1].

We have seen real world guests setting CS to a usable segment with DPL=3
and SS to an unusable segment with DPL=3. Once we go through an sregs
get/set cycle, SS.DPL turns to 0. This causes the virtual machine to crash
reproducibly.

This commit changes the attribute logic to always preserve attributes for
unusable segments. According to [2] SS.DPL is always saved on VM exits,
regardless of the unusable bit so user space applications should have saved
the information on serialization correctly.

[3] specifies that besides SS.DPL the rest of the attributes of the
descriptors are undefined after VM entry if unusable bit is set. So, there
should be no harm in setting them all to the previous state.

[1] Intel SDM Vol 3C 26.3.1.2 Checks on Guest Segment Registers
[2] Intel SDM Vol 3C 27.3.2 Saving Segment Registers and Descriptor-Table
Registers
[3] Intel SDM Vol 3C 26.3.2.2 Loading Guest Segment Registers and
Descriptor-Table Registers

Cc: Alexander Graf <graf@amazon.de>
Signed-off-by: Hendrik Borghorst <hborghor@amazon.de>
---
 arch/x86/kvm/vmx/vmx.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 63247c57c72c..4ae248e87f5e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3412,18 +3412,15 @@ static u32 vmx_segment_access_rights(struct kvm_segment *var)
 {
 	u32 ar;
 
-	if (var->unusable || !var->present)
-		ar = 1 << 16;
-	else {
-		ar = var->type & 15;
-		ar |= (var->s & 1) << 4;
-		ar |= (var->dpl & 3) << 5;
-		ar |= (var->present & 1) << 7;
-		ar |= (var->avl & 1) << 12;
-		ar |= (var->l & 1) << 13;
-		ar |= (var->db & 1) << 14;
-		ar |= (var->g & 1) << 15;
-	}
+	ar = var->type & 15;
+	ar |= (var->s & 1) << 4;
+	ar |= (var->dpl & 3) << 5;
+	ar |= (var->present & 1) << 7;
+	ar |= (var->avl & 1) << 12;
+	ar |= (var->l & 1) << 13;
+	ar |= (var->db & 1) << 14;
+	ar |= (var->g & 1) << 15;
+	ar |= (var->unusable || !var->present) << 16;
 
 	return ar;
 }
-- 
2.37.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



