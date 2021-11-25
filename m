Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAB1545D2C8
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 03:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353367AbhKYCDV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:03:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349605AbhKYCBS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 21:01:18 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29FDC0619E6
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:50 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id iq9-20020a17090afb4900b001a54412feb0so2325644pjb.1
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ThWKbMb11S83q7o+DnaIqZun5g0x3s0bH3bwI98uErE=;
        b=P9mEo1LhkRWYoHvuJ2GCc5jDWIBVJzw1G35OScwGKKjukWZp15OztJnVI47ujcJ8MY
         IBNxporI7p8DiqQM00XO8XNfebGrWS9Jb3ftLq3ipeEmpPsEgiyOKJH1i4n1jlZ7BaAP
         iuQFMO9HdKeMWq5xWHVNU6T4lsT36YVtPeOdn6+NbMJP3+K+oVefOVSQfjKBiu9KnLrl
         75pdDq4Nx4SpG9KfHWuWiKlxf4oJRWwvCNzWKTjmjuq/AXnY3em3Jr6W+tmzKYFRGq+X
         0cteZr4NwUuvTUmkH6v0Ai/4PbMtbUorQ2s5MXIayGZieRDf3cvOV5QplIrxmOZoY8sg
         DNQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ThWKbMb11S83q7o+DnaIqZun5g0x3s0bH3bwI98uErE=;
        b=CBopzHaIVCkx3kYgz/NKe0454rk/IJ+cTWlSqRz+6qP6YEYqOAgCBDRBIS121DlwEd
         40FmFHCK6vzmcHDojUmqhZcHNQXIl2WFf533Cl0WOYkApyoFH9aNqbvQCVLkcZhFlXL9
         orn0UJtoBZQu5xEho6x4uKf2Amvqp2/FzVbfETJg09gIiu8IUBqC9m9SljmX9ytAeXu8
         MLDrdP33CHI2BPt99snM1GKa1HmKM6w24Gn7ZYKE2cozDHnvy1I1coY61o5dYRtRJVDL
         Bv4DyYx1l0c5nRkKjaEwgLwKQtfgsOGpGMTtcpJD+Xs3xUn70Ohk8rjCVCabIi2t76g4
         ygVQ==
X-Gm-Message-State: AOAM533AuUiGg9PhYyksHJY3TmpArv2emLoHqmJEahs6Zrql5AzFeUEX
        kOq5OU09bY8598V4XOQDBb2oCoW6Anc=
X-Google-Smtp-Source: ABdhPJwXuZsZ7se9BCPrjb00vcs4sjFp4nhora0NRde5maZPr8eA26PpPRl+8yc6YobP6WwHJ0WbnTW0s4A=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:c943:b0:142:1758:8ee7 with SMTP id
 i3-20020a170902c94300b0014217588ee7mr24288021pla.58.1637803790447; Wed, 24
 Nov 2021 17:29:50 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:49 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-32-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 31/39] nVMX: Add helper to get first supported
 INVVPID type
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Deduplicate some clever/interesting code for retrieving the first
supported INVVPID type, and opportunistically avoid RDMSR on every test.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx_tests.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 66f374a..f2e24f6 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -3197,16 +3197,20 @@ static void try_invvpid(u64 type, u64 vpid, u64 gla)
 	       expected, vmcs_read(VMX_INST_ERROR));
 }
 
+static inline unsigned long get_first_supported_invvpid_type(void)
+{
+	u64 type = ffs(ept_vpid.val >> VPID_CAP_INVVPID_TYPES_SHIFT) - 1;
+
+	__TEST_ASSERT(type >= INVVPID_ADDR && type <= INVVPID_CONTEXT_LOCAL);
+	return type;
+}
+
 static void ds_invvpid(void *data)
 {
-	u64 msr = rdmsr(MSR_IA32_VMX_EPT_VPID_CAP);
-	u64 type = ffs(msr >> VPID_CAP_INVVPID_TYPES_SHIFT) - 1;
-
-	TEST_ASSERT(type >= INVVPID_ADDR && type <= INVVPID_CONTEXT_LOCAL);
 	asm volatile("invvpid %0, %1"
 		     :
 		     : "m"(*(struct invvpid_operand *)data),
-		       "r"(type));
+		       "r"(get_first_supported_invvpid_type()));
 }
 
 /*
@@ -3216,13 +3220,9 @@ static void ds_invvpid(void *data)
  */
 static void ss_invvpid(void *data)
 {
-	u64 msr = rdmsr(MSR_IA32_VMX_EPT_VPID_CAP);
-	u64 type = ffs(msr >> VPID_CAP_INVVPID_TYPES_SHIFT) - 1;
-
-	TEST_ASSERT(type >= INVVPID_ADDR && type <= INVVPID_CONTEXT_LOCAL);
 	asm volatile("sub %%rsp,%0; invvpid (%%rsp,%0,1), %1"
 		     : "+r"(data)
-		     : "r"(type));
+		     : "r"(get_first_supported_invvpid_type()));
 }
 
 static void invvpid_test_gp(void)
-- 
2.34.0.rc2.393.gf8c9666880-goog

