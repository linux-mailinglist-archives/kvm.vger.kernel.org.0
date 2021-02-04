Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC21A30E835
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 01:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234240AbhBDADE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 19:03:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234215AbhBDAC4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 19:02:56 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD73C06121E
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 16:01:52 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id w4so1551320ybc.7
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 16:01:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=A6vZFDvp80hzL8bSGmgbXTenVplxRZt6FUQXbaMJFdM=;
        b=iILJ48vL9bhmsbygJ+drqXyFr1y2A4TSk8IGIa4dcDPFX6fRXtdLP65EqBLBKnpsGV
         wknSQuVLipRUANA3gQuUOnp2NsqDOedFFElNDsbmc7Aa9ix69g3i08n7T1Hg11QsntHo
         NSJrc8S63wRb0Xf5mF3xttAFX4E0jq3wwHbWtSKeRVnt7NTS40zh5chTiil1PGCTIC9M
         MS67NISELAvQ+wJfzM0f0JCGNGP5Uf/o84bYLNLGG1LWJKwktka0W1Ai3+wsjRl+5ONa
         zkeKBtg7RDOzZgskjs9IBV+bObJr3kGUMEUb/URaqIXd4AfRsDts5U4njswutTrHyKcK
         MUMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=A6vZFDvp80hzL8bSGmgbXTenVplxRZt6FUQXbaMJFdM=;
        b=NslFCJPmVCMUIaWWPizUWHh8iSFNLYQYghcDBLhvcLlHMdb+OqPE1j5wNIyn5x8REF
         0QAPRxixPfpY8ruXsmjTf0Wuv2Nq8YBGC7QZ+pD/tsquBB0qaI4X/WoK/MI040wSDF1o
         ecwKhnvLZqDz9oevURCihE+JfX8RQfEaly8eJJH7r3iC91elvzLBqRnWotmHYKtQxbnG
         2iy+LujE/igM+lxFDsTOU9L0tS/57vP3ZbEdx77uR1T4yswHIIuUu0mDgPnQytecBFMv
         0AymwVgwlbsndStj5NtsWp4ZS79caXI4KPu0ibffH4gSeZ3mEkUlKKRDjH5DLN/cDfVu
         lFzQ==
X-Gm-Message-State: AOAM531ActASVoL7hUpDbzJ3SmKY1s4XwsFmDByC50r5X5GoJZYUXK//
        qWZYLfHSgJNC6nXb2z562HbA07PZpZE=
X-Google-Smtp-Source: ABdhPJzJssUlPvMCPA9v68raoyHoKIZLJwhTQkUnkx2kNJvyrd9sqrlkcPKamhZCcXSwN8F7zq+GTdpUfn8=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:a9a0:e924:d161:b6cb])
 (user=seanjc job=sendgmr) by 2002:a25:7c06:: with SMTP id x6mr8347021ybc.445.1612396911857;
 Wed, 03 Feb 2021 16:01:51 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  3 Feb 2021 16:01:16 -0800
In-Reply-To: <20210204000117.3303214-1-seanjc@google.com>
Message-Id: <20210204000117.3303214-12-seanjc@google.com>
Mime-Version: 1.0
References: <20210204000117.3303214-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH 11/12] KVM: x86: Move nVMX's consistency check macro to common code
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move KVM's CC() macro to x86.h so that it can be reused by nSVM.
Debugging VM-Enter is as painful on SVM as it is on VMX.

Rename the more visible macro to KVM_NESTED_VMENTER_CONSISTENCY_CHECK
to avoid any collisions with the uber-concise "CC".

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 8 +-------
 arch/x86/kvm/x86.h        | 8 ++++++++
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b25ce704a2aa..dbca1687ae8e 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -21,13 +21,7 @@ module_param_named(enable_shadow_vmcs, enable_shadow_vmcs, bool, S_IRUGO);
 static bool __read_mostly nested_early_check = 0;
 module_param(nested_early_check, bool, S_IRUGO);
 
-#define CC(consistency_check)						\
-({									\
-	bool failed = (consistency_check);				\
-	if (failed)							\
-		trace_kvm_nested_vmenter_failed(#consistency_check, 0);	\
-	failed;								\
-})
+#define CC KVM_NESTED_VMENTER_CONSISTENCY_CHECK
 
 /*
  * Hyper-V requires all of these, so mark them as supported even though
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 4f875f8d93b3..a14da36a30ed 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -8,6 +8,14 @@
 #include "kvm_cache_regs.h"
 #include "kvm_emulate.h"
 
+#define KVM_NESTED_VMENTER_CONSISTENCY_CHECK(consistency_check)		\
+({									\
+	bool failed = (consistency_check);				\
+	if (failed)							\
+		trace_kvm_nested_vmenter_failed(#consistency_check, 0);	\
+	failed;								\
+})
+
 #define KVM_DEFAULT_PLE_GAP		128
 #define KVM_VMX_DEFAULT_PLE_WINDOW	4096
 #define KVM_DEFAULT_PLE_WINDOW_GROW	2
-- 
2.30.0.365.g02bc693789-goog

