Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8803E331CE2
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 03:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhCICTt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 21:19:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbhCICTY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 21:19:24 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B534C06175F
        for <kvm@vger.kernel.org>; Mon,  8 Mar 2021 18:19:24 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id o9so15134045yba.18
        for <kvm@vger.kernel.org>; Mon, 08 Mar 2021 18:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=jtA7dmTGM016o6c6Ho9LtE/Z/lpkYetz59Bx/2WDcjg=;
        b=q5QA+Mb1K6pSAOPJxCsSJRwnmdG0iBZJ/0J1vnIa5lqxWbZ6A69GJHEnauZ5IgHygX
         vXuDNkgMxkFIFhDBCc4ElWddoWjtMz/vpgDQaZs9GO65lSLeft9GFQU6l9c0LCtDqW03
         5oix+LVQ8fhx1UVeJYxUWDJnDBkqYjnkpa63NO5UZufKBQIr62P2mBij8iYjV4bDPXW1
         0tqExZVsU1jWJ7r5iv8edK7p/ZUBTXVNU3MmgptIbV7Qy/eU3NjmwoIsii7MMh2pUVGg
         jrUrmZWOuIiP6UL+aprfrks61l6tnKA3a9/uB8SjYPqJKfCyYA8dnK18sFf5fB1+tZj2
         NMLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=jtA7dmTGM016o6c6Ho9LtE/Z/lpkYetz59Bx/2WDcjg=;
        b=TH3N8ebwZFZpPiDa0qsusUjn2xxJZksOLq69V65h0TlW9oTRZluXxr3Gk/qNAZ3U58
         BAHUtgowe9dVmQOUOs1ou4Wd6WjE9E8kF2f7HIj7xkIK3aN/zvgnGIKqNgjSMuyJghMO
         Kw1X4EQYbLCheFwGTIrDbkG/StqMW0gVnjNC/uupMWyeB+rEfSc95RsaDimyYknHmeHC
         LyIK9xyMqQPPOPkAi/cL6i6MZNJ935KH2KQ8ESeRgNk+m1zK2NNo+1weubV8N8USNMfg
         SqTa0Lm2st+DecPiq7j32MJlryWgTjz3V4mbSy+wB3/+rFPEuIf+gQwkQeIJ/Zp8UR+L
         2DHQ==
X-Gm-Message-State: AOAM5328Udo5abgfEmXWeHFkz4l6sSqiRZLa6YnCVlRhOcqexriP2o3o
        ppevxtOW7OiVpTIZ5TTZ5H3GYTGz4+4=
X-Google-Smtp-Source: ABdhPJyolcHTtr/bnM1qT7DOGQ63cZOTUAxpJD1UnzUoyRRUgv2SN+e8rdURB0vGNH9IyglaCrIsI6KWLls=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:8:847a:d8b5:e2cc])
 (user=seanjc job=sendgmr) by 2002:a25:c6cb:: with SMTP id k194mr36721092ybf.27.1615256363614;
 Mon, 08 Mar 2021 18:19:23 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon,  8 Mar 2021 18:18:59 -0800
In-Reply-To: <20210309021900.1001843-1-seanjc@google.com>
Message-Id: <20210309021900.1001843-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210309021900.1001843-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 1/2] KVM: x86: Fixup "Get active PCID only when writing a CR3 value"
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Fix SME and PCID, which got horribly mangled on application.

Fixes: a16241ae56fa ("KVM: x86: Get active PCID only when writing a CR3 value")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7876ddf896b8..271196400495 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3907,15 +3907,20 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 	struct vcpu_svm *svm = to_svm(vcpu);
 	unsigned long cr3;
 
-	cr3 = __sme_set(root_hpa);
 	if (npt_enabled) {
-		svm->vmcb->control.nested_cr3 = root_hpa;
+		svm->vmcb->control.nested_cr3 = __sme_set(root_hpa);
 		vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
 
 		/* Loading L2's CR3 is handled by enter_svm_guest_mode.  */
 		if (!test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
 			return;
 		cr3 = vcpu->arch.cr3;
+	} else if (vcpu->arch.mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
+		cr3 = __sme_set(root_hpa) | kvm_get_active_pcid(vcpu);
+	} else {
+		/* PCID in the guest should be impossible with a 32-bit MMU. */
+		WARN_ON_ONCE(kvm_get_active_pcid(vcpu));
+		cr3 = root_hpa;
 	}
 
 	svm->vmcb->save.cr3 = cr3;
-- 
2.30.1.766.gb4fecdf3b7-goog

