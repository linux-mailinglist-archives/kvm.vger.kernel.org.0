Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2EE30E831
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 01:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234148AbhBDAC1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 19:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234077AbhBDACZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 19:02:25 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA822C061793
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 16:01:33 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id q7so1064195qkn.7
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 16:01:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Tdon8eC5Mj9r7LlkZz+UAtMydKIEM0SgyE72PrAxPS8=;
        b=elT9TRgDqK4CrAsfjShNdqhUkP6AR4MsqFZ63uKDIOidSiyiOPUqYKHu26WoTrlW5C
         1q/piuJQaA8V4Wti77ssR9CNlA7pROk5yxcz5yD859ZwS+yk98DriMIdqdn65eW9ZknA
         gbwGhbTJhHMdjcKLBbNhi1es9NGT27zPbXSdIQ6kzy+YZA3TLWu+1txBG37IbJ0Kq1Dk
         V3pi0TVZaCqkuuYsSs9dt8JsGPfu/UcqAiZu/IjREFjWLiKxI6yfwbrb/cNHqZ4x7XLm
         UVlce3iLTFSaksVi2KMHChmVd0s/5aVVw+HRHbK8ez2CV6Hyqy3CiRk7NSzPGKoRU+xZ
         dNiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Tdon8eC5Mj9r7LlkZz+UAtMydKIEM0SgyE72PrAxPS8=;
        b=WaZ+JZk/tHdGwmd6hed2Yr+15f/+gIoRTE7PVv/Zb0sb5MJlQbur38xtQA+KOThpGB
         Qnc10mExv7C/BG+U6lPvQpZZnSsSvVMoRJ3dYm8FGg49bdLUdqoehSheJRBWAkVI9bi0
         1pxgAYxYJY+m/i+VybPdwyVaGBSV1ooLXz7R9f4tViQzdi8d8pXEi2Oggf/g7BWpxOZx
         bIvtfuUBDCbX2Vn2DwzducJsU1ki0gbxzRIE5zGF9tA5C+G8ObakPiaaXU9Cv3IkVQzx
         +6jFB3D2hqMhKDeAtavgYCFLzo3FaJ3XuDqIytiUYSeLRjpN7RwT5F4l4PEAQ4RDPgqL
         50vw==
X-Gm-Message-State: AOAM530340Ta3PN4ZdOzYqjNkbFV7fbTYVnoeuExrXuwBE8LwF1LUzLF
        OFwlko8ldQQgZGB7Vb73vsTXuyStDQM=
X-Google-Smtp-Source: ABdhPJwVk/Vwo8DeZc9aunFIzu73jnLKiexkJobxrAuFiUkTHMywWbEiin4okhJMM11JaAaLzEDcu3rduKQ=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:a9a0:e924:d161:b6cb])
 (user=seanjc job=sendgmr) by 2002:ad4:46cd:: with SMTP id g13mr5282675qvw.27.1612396892974;
 Wed, 03 Feb 2021 16:01:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  3 Feb 2021 16:01:08 -0800
In-Reply-To: <20210204000117.3303214-1-seanjc@google.com>
Message-Id: <20210204000117.3303214-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210204000117.3303214-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH 03/12] KVM: x86: Add a helper to check for a legal GPA
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

Add a helper to check for a legal GPA, and use it to consolidate code
in existing, related helpers.  Future patches will extend usage to
VMX and SVM code, properly handle exceptions to the maxphyaddr rule, and
add more helpers.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.h | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index dc921d76e42e..674d61079f2d 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -36,9 +36,19 @@ static inline int cpuid_maxphyaddr(struct kvm_vcpu *vcpu)
 	return vcpu->arch.maxphyaddr;
 }
 
+static inline bool kvm_vcpu_is_legal_gpa(struct kvm_vcpu *vcpu, gpa_t gpa)
+{
+	return !(gpa >> cpuid_maxphyaddr(vcpu));
+}
+
 static inline bool kvm_vcpu_is_illegal_gpa(struct kvm_vcpu *vcpu, gpa_t gpa)
 {
-	return (gpa >= BIT_ULL(cpuid_maxphyaddr(vcpu)));
+	return !kvm_vcpu_is_legal_gpa(vcpu, gpa);
+}
+
+static inline bool page_address_valid(struct kvm_vcpu *vcpu, gpa_t gpa)
+{
+	return PAGE_ALIGNED(gpa) && kvm_vcpu_is_legal_gpa(vcpu, gpa);
 }
 
 struct cpuid_reg {
@@ -324,11 +334,6 @@ static __always_inline void kvm_cpu_cap_check_and_set(unsigned int x86_feature)
 		kvm_cpu_cap_set(x86_feature);
 }
 
-static inline bool page_address_valid(struct kvm_vcpu *vcpu, gpa_t gpa)
-{
-	return PAGE_ALIGNED(gpa) && !(gpa >> cpuid_maxphyaddr(vcpu));
-}
-
 static __always_inline bool guest_pv_has(struct kvm_vcpu *vcpu,
 					 unsigned int kvm_feature)
 {
-- 
2.30.0.365.g02bc693789-goog

