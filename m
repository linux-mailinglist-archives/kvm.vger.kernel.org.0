Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96CCD301137
	for <lists+kvm@lfdr.de>; Sat, 23 Jan 2021 00:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbhAVXyY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 18:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbhAVXwd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 18:52:33 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31069C0617AB
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 15:51:06 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id r1so7028037ybd.23
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 15:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=r3IIkGAa61MnJqRj3fcRniDrryvcAMIqBhLKyFl38rA=;
        b=i/kBaLgRBYVZ0ZgLV1J9cHLj/jJy/sxK/Mg1oV7j4zoRI5zRWYtXPmiKSIl6uEEU7+
         Bb2JpBuQ9PzOHY3f0nE1SQsK5SR9MoMEgXs9KjGVoNZS7Hy1zjxzzrarFPA3vAyueNuM
         5I5IKEjLBOzrvwGtcSACwoU5rb48kKCzWuTnjyt00FfNCoo7nY2APFvJj3sdTIc7rRgQ
         1Y/409GkeshmRujBFBV4eGq2tD2nJUJ+3NQmpNFJfl6m8F23ZEnjDZZp3MM1LJl7DHeJ
         hQqMrRvq9OLwHUtDKRoHCYb2fqQ3IrGAuuQZlo0uk2t4wR4P11Va8TAv7Q12+a9NYluW
         B3zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=r3IIkGAa61MnJqRj3fcRniDrryvcAMIqBhLKyFl38rA=;
        b=n9B9c3VBg1cCg1NJviiiGdgzvEp/6CUrxwRd4CTAD4FEGy7F4n3/hgkHIVgbh1PWH3
         nJ32Lpl8FfqsaixqI3krM0/lCjEXCc2RT9hd/yf/VhGTPXq4vzA56stmUShbSRH7ik7g
         UE+mnnZDWzgoUapwTRhYjDV9EVixQEISGH07RsbP3FgBBogKx4o0N86QQy9Y6VDAGsCj
         XoOBAuqAF+l0PRO2dGLsKhKFAii0Swpdguym7MDcOjZ0kWOZGfdj1yh+LDC/momoOD4o
         trOxppXUszjSPrHftvDS3AGo2QIupfjNaWzIjtA6mZkfcfStdTmHpIqLPwZaHTcvbH75
         ktWg==
X-Gm-Message-State: AOAM533JyktppESRRu228+2DE5cCTtOm5BbWQInsRiwaHGUbwTzZjE2W
        hqoqxqsZG+hya8DpSv8D2NzLPzECV8M=
X-Google-Smtp-Source: ABdhPJz3mmxzI6jTLrn733eHumARphbHgVa0LiQzSZwODrHcFjN+KjRnng59m2ZkbGYrFf7QPWspkCybedU=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a25:d70a:: with SMTP id o10mr9412902ybg.235.1611359465355;
 Fri, 22 Jan 2021 15:51:05 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 22 Jan 2021 15:50:49 -0800
In-Reply-To: <20210122235049.3107620-1-seanjc@google.com>
Message-Id: <20210122235049.3107620-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210122235049.3107620-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH 3/3] KVM: SVM: Sync GPRs to the GHCB only after VMGEXIT
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sync GPRs to the GHCB on VMRUN only if a sync is needed, i.e. if the
previous exit was a VMGEXIT and the guest is expecting some data back.

Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 15 ++++++++++-----
 arch/x86/kvm/svm/svm.h |  1 +
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index ac652bc476ae..9bd1e1650eb3 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1418,10 +1418,13 @@ static void sev_es_sync_to_ghcb(struct vcpu_svm *svm)
 	 * Copy their values, even if they may not have been written during the
 	 * VM-Exit.  It's the guest's responsibility to not consume random data.
 	 */
-	ghcb_set_rax(ghcb, vcpu->arch.regs[VCPU_REGS_RAX]);
-	ghcb_set_rbx(ghcb, vcpu->arch.regs[VCPU_REGS_RBX]);
-	ghcb_set_rcx(ghcb, vcpu->arch.regs[VCPU_REGS_RCX]);
-	ghcb_set_rdx(ghcb, vcpu->arch.regs[VCPU_REGS_RDX]);
+	if (svm->need_sync_to_ghcb) {
+		ghcb_set_rax(ghcb, vcpu->arch.regs[VCPU_REGS_RAX]);
+		ghcb_set_rbx(ghcb, vcpu->arch.regs[VCPU_REGS_RBX]);
+		ghcb_set_rcx(ghcb, vcpu->arch.regs[VCPU_REGS_RCX]);
+		ghcb_set_rdx(ghcb, vcpu->arch.regs[VCPU_REGS_RDX]);
+		svm->need_sync_to_ghcb = false;
+	}
 }
 
 static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
@@ -1441,8 +1444,10 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
 	 * VMMCALL allows the guest to provide extra registers. KVM also
 	 * expects RSI for hypercalls, so include that, too.
 	 *
-	 * Copy their values to the appropriate location if supplied.
+	 * Copy their values to the appropriate location if supplied, and
+	 * flag that a sync back to the GHCB is needed on the next VMRUN.
 	 */
+	svm->need_sync_to_ghcb = true;
 	memset(vcpu->arch.regs, 0, sizeof(vcpu->arch.regs));
 
 	vcpu->arch.regs[VCPU_REGS_RAX] = ghcb_get_rax_if_valid(ghcb);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0fe874ae5498..4e2e5f9fbfc2 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -192,6 +192,7 @@ struct vcpu_svm {
 	u64 ghcb_sa_len;
 	bool ghcb_sa_sync;
 	bool ghcb_sa_free;
+	bool need_sync_to_ghcb;
 };
 
 struct svm_cpu_data {
-- 
2.30.0.280.ga3ce27912f-goog

