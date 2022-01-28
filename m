Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC9DF49F013
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 01:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345044AbiA1AyI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 19:54:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345038AbiA1Axx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 19:53:53 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF7EC06177F
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:39 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id e3-20020a170902ed8300b0014b46561c92so2292807plj.15
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=+fgTTm9nrHmeG0FgLza5Karyosr5i7v7pBMlh0d99R0=;
        b=AoJD+O+f5LrotQSvynZoaLZnhwDrHUhmG34xGE9mx2riuWL0zeVdquhHAbb11THRtX
         YlfjZ2s/xnB9RkHsgYaFz8PtvQ+orER04OVMExOvNdtR0sehxd78A+SQZMmKLJnsFCqn
         gtbCHrRxq7wjzgcGVOd5qcUruluJe0hLJyOTaK0jpnnx44vxJJFr0VAnMDnjTK65TBrE
         oRDwD/kI8Dmwrb1P53XMwuX9woWNkWtn2/7B/gHVJ215/oNHuvHFFcKt4wjsR8JooldJ
         oTVg+bPMm8PO6vb3/wjqZbM0J84L5fdfGJhX6pFcKEUR41Wq5JWUNipfrBNBEZKHy5no
         FlHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=+fgTTm9nrHmeG0FgLza5Karyosr5i7v7pBMlh0d99R0=;
        b=NWpV9AoLfI1TK0jGhEH3iEm7udob/bgwVQQlQUlkG4dZ2PeZIqzn0Af+bdAzY8eSgV
         s99OWzwk7J//4JfAH08LtK+ZkrlKx2z3QDQHPOjhMs4dHrBizTuGpkFQ/7h2rAzYH9AM
         EEkz+ml2+O4CwSTCtkPAt25l5skE1NHEC3pnp/VZC9FHxmnzcPsKLfJI/84ZTjLRt8cN
         Jx5HVilyQhOhGpfb5XGLIEZ/fr+xRDoHPK/z6Is5nX/Dq9a7+EU6Y/Wsv+Ugjl1Fjo8H
         kXhZYj73tCEQMSxnjpm98btmXGQsO8YUZ1JXTlAcBdUBorXnxiUAh07ToTyf/8+RDhjD
         3KHQ==
X-Gm-Message-State: AOAM530TufZvRyAFqMORje5UhvEzCTJDx+J/nFllqafs0WZZM6L8sH53
        0Fk8ocEL9flB4v8BtvmDP+Id080pcVg=
X-Google-Smtp-Source: ABdhPJwmTuCahChEBGU7SHh+TlMJfQzORp/I86NBNcOH5v+eoVWBfWkcAwKpe0cOPshnM8Po5sPoUGg2V5Q=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4c8e:: with SMTP id
 my14mr1878284pjb.0.1643331218725; Thu, 27 Jan 2022 16:53:38 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jan 2022 00:52:01 +0000
In-Reply-To: <20220128005208.4008533-1-seanjc@google.com>
Message-Id: <20220128005208.4008533-16-seanjc@google.com>
Mime-Version: 1.0
References: <20220128005208.4008533-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 15/22] KVM: x86: Move get_cs_db_l_bits() helper to SVM
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move kvm_get_cs_db_l_bits() to SVM and rename it appropriately so that
its svm_x86_ops entry can be filled via kvm-x86-ops, and to eliminate a
superfluous export from KVM x86.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/svm/svm.c          | 11 ++++++++++-
 arch/x86/kvm/x86.c              | 10 ----------
 3 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 91c0e4957bd0..f97d155810ac 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1717,7 +1717,6 @@ int kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val);
 void kvm_get_dr(struct kvm_vcpu *vcpu, int dr, unsigned long *val);
 unsigned long kvm_get_cr8(struct kvm_vcpu *vcpu);
 void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long msw);
-void kvm_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l);
 int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu);
 
 int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 991d3e628c60..fda09a6ea3ba 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1531,6 +1531,15 @@ static int svm_get_cpl(struct kvm_vcpu *vcpu)
 	return save->cpl;
 }
 
+static void svm_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
+{
+	struct kvm_segment cs;
+
+	svm_get_segment(vcpu, &cs, VCPU_SREG_CS);
+	*db = cs.db;
+	*l = cs.l;
+}
+
 static void svm_get_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -4486,7 +4495,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.get_segment = svm_get_segment,
 	.set_segment = svm_set_segment,
 	.get_cpl = svm_get_cpl,
-	.get_cs_db_l_bits = kvm_get_cs_db_l_bits,
+	.get_cs_db_l_bits = svm_get_cs_db_l_bits,
 	.set_cr0 = svm_set_cr0,
 	.post_set_cr3 = svm_post_set_cr3,
 	.is_valid_cr4 = svm_is_valid_cr4,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 580a2adaec7c..b151db419590 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10570,16 +10570,6 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	return 0;
 }
 
-void kvm_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
-{
-	struct kvm_segment cs;
-
-	kvm_get_segment(vcpu, &cs, VCPU_SREG_CS);
-	*db = cs.db;
-	*l = cs.l;
-}
-EXPORT_SYMBOL_GPL(kvm_get_cs_db_l_bits);
-
 static void __get_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 {
 	struct desc_ptr dt;
-- 
2.35.0.rc0.227.g00780c9af4-goog

