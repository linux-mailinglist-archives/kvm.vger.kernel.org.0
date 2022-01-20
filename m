Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037A949455F
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 02:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358100AbiATBHs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 20:07:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358071AbiATBHh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 20:07:37 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F5BC06173E
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 17:07:37 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id g26-20020aa79dda000000b004bde19ed422so2609094pfq.18
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 17:07:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=yJF8IE4woQyFxdtp6qxfyGJA8OkTrqLP6YfwBFeba+0=;
        b=tlZuieks+J1SbXLVjDBQ3/s8r9tSTvUzUKdZ/9IkvvKjtAGgLZPFbyfoK01Ktf8Tkr
         afeWSISvuS+1bOBsyY9jlj+pPixqUl4vGgFpbzY2bsJcqXMgwSeEnr5PVGg2OkKLWhAB
         H9Qx9zexDs6VtK2wzDfPHR/qA8gX3KHT+vnu2hTJhb7cMWCFghrydxmDBEgxBgv2XLv/
         YZTXEAtE3nAzSv3MLLUuQMPG1LtEFqz0Rpryy+0N0erQnHPHb4iU+7rYvM6DosGIp1ps
         ZhJBX5nrDI8jLj3bIb38VGbxP3mAoTrOg2nJnlygiw902c2tNYjnhjkuW7gmqAXDiCMX
         iUYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=yJF8IE4woQyFxdtp6qxfyGJA8OkTrqLP6YfwBFeba+0=;
        b=Iz3hGONPBbBp9TgaOdVd68tUF42atB2ySwGmP75Qe2rqaLK5rZ6Af7O6Vilv+Fc1yd
         sfoEWR50jSlCVBKkPRZtZJzAmDXaBldMPmWF9QV9zwKTnXysRlyRCTnPShTO6V1aNAVV
         xYXd5rMdkWjij81KcUz74pWHtMjFjFJ1sOHwR3rkLeBxN6/RFSGjwolAC8IgsyKdH8xI
         N3D0GwHGTasfdM+V7RY1bcCphJa6p+hlM7oevd2BmclNF3MhK7IM/c9i4ANl2gWxnE4x
         GCTg0RSAdOHwGJPNEq7iySPj7wwxlAjY/MxXrpLTZ9HFQ/45MGluy+ZTJlqC2NUhFyuL
         KbIQ==
X-Gm-Message-State: AOAM531LeItjVRP5uZIoeuquKPs6dwI3RznQsoyedQrl+NJMdgzfG1an
        Jy+NrGaafpmgiDMNs3BqAiXyDycTWck=
X-Google-Smtp-Source: ABdhPJzS0pk0Wydquz3Ss7PJbYx+S/VDXhRa8iSZLYgQsF9yVYE4YVlLXqJtPt44YQI/Er1I4nCKr9SWauo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1308:b0:4c5:e231:afd4 with SMTP id
 j8-20020a056a00130800b004c5e231afd4mr2350283pfu.34.1642640856552; Wed, 19 Jan
 2022 17:07:36 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 20 Jan 2022 01:07:18 +0000
In-Reply-To: <20220120010719.711476-1-seanjc@google.com>
Message-Id: <20220120010719.711476-9-seanjc@google.com>
Mime-Version: 1.0
References: <20220120010719.711476-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH 8/9] KVM: SVM: Don't apply SEV+SMAP workaround on code fetch
 or PT access
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
        Liam Merwick <liam.merwick@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Resume the guest instead of synthesizing a triple fault shutdown if the
instruction bytes buffer is empty due to the #NPF being on the code fetch
itself or on a page table access.  The SMAP errata applies if and only if
the code fetch was successful and ucode's subsequent data read from the
code page encountered a SMAP violation.  In practice, the guest is likely
hosed either way, but crashing the guest on a code fetch to emulated MMIO
is technically wrong according to the behavior described in the APM.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 43 +++++++++++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d324183fc596..a4b02a6217fd 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4262,6 +4262,7 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
 {
 	bool smep, smap, is_user;
 	unsigned long cr4;
+	u64 error_code;
 
 	/* Emulation is always possible when KVM has access to all guest state. */
 	if (!sev_guest(vcpu->kvm))
@@ -4325,22 +4326,31 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
 	 * loap uop with CPL=0 privileges.  If the load hits a SMAP #PF, ucode
 	 * gives up and does not fill the instruction bytes buffer.
 	 *
-	 * Detection:
-	 * KVM reaches this point if the VM is an SEV guest, the CPU supports
-	 * DecodeAssist, a #NPF was raised, KVM's page fault handler triggered
-	 * emulation (e.g. for MMIO), and the CPU returned 0 in GuestIntrBytes
-	 * field of the VMCB.
+	 * As above, KVM reaches this point iff the VM is an SEV guest, the CPU
+	 * supports DecodeAssist, a #NPF was raised, KVM's page fault handler
+	 * triggered emulation (e.g. for MMIO), and the CPU returned 0 in the
+	 * GuestIntrBytes field of the VMCB.
 	 *
 	 * This does _not_ mean that the erratum has been encountered, as the
 	 * DecodeAssist will also fail if the load for CS:RIP hits a legitimate
 	 * #PF, e.g. if the guest attempt to execute from emulated MMIO and
 	 * encountered a reserved/not-present #PF.
 	 *
-	 * To reduce the likelihood of false positives, take action if and only
-	 * if CR4.SMAP=1 (obviously required to hit the erratum) and CR4.SMEP=0
-	 * or CPL=3.  If SMEP=1 and CPL!=3, the erratum cannot have been hit as
-	 * the guest would have encountered a SMEP violation #PF, not a #NPF.
+	 * To hit the erratum, the following conditions must be true:
+	 *    1. CR4.SMAP=1 (obviously).
+	 *    2. CR4.SMEP=0 || CPL=3.  If SMEP=1 and CPL<3, the erratum cannot
+	 *       have been hit as the guest would have encountered a SMEP
+	 *       violation #PF, not a #NPF.
+	 *    3. The #NPF is not due to a code fetch, in which case failure to
+	 *       retrieve the instruction bytes is legitimate (see abvoe).
+	 *
+	 * In addition, don't apply the erratum workaround if the #NPF occurred
+	 * while translating guest page tables (see below).
 	 */
+	error_code = to_svm(vcpu)->vmcb->control.exit_info_1;
+	if (error_code & (PFERR_GUEST_PAGE_MASK | PFERR_FETCH_MASK))
+		goto resume_guest;
+
 	cr4 = kvm_read_cr4(vcpu);
 	smep = cr4 & X86_CR4_SMEP;
 	smap = cr4 & X86_CR4_SMAP;
@@ -4350,6 +4360,21 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
 		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 	}
 
+resume_guest:
+	/*
+	 * If the erratum was not hit, simply resume the guest and let it fault
+	 * again.  While awful, e.g. the vCPU may get stuck in an infinite loop
+	 * if the fault is at CPL=0, it's the lesser of all evils.  Exiting to
+	 * userspace will kill the guest, and letting the emulator read garbage
+	 * will yield random behavior and potentially corrupt the guest.
+	 *
+	 * Simply resuming the guest is technically not a violation of the SEV
+	 * architecture.  AMD's APM states that all code fetches and page table
+	 * accesses for SEV guest are encrypted, regardless of the C-Bit.  The
+	 * APM also states that encrypted accesses to MMIO are "ignored", but
+	 * doesn't explicitly define "ignored", i.e. doing nothing and letting
+	 * the guest spin is technically "ignoring" the access.
+	 */
 	return false;
 }
 
-- 
2.34.1.703.g22d0c6ccf7-goog

