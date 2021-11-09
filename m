Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C67A44A4F1
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 03:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242046AbhKICmd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 21:42:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241873AbhKICmZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 21:42:25 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E88BC061764
        for <kvm@vger.kernel.org>; Mon,  8 Nov 2021 18:39:39 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id e4-20020a630f04000000b002cc40fe16afso11241712pgl.23
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 18:39:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tc3mXVzzOaZBy5gyuY36RG3hrmBxESsxJH6cjzwnYCE=;
        b=Re6hB7wRoT18fAcpM30azZmr5LuzK6wqyf/A8iUeb0FcMAeRijXmJNCamHrNbyVJYV
         sa2cJFJkbLzmyswtvwuSPlxXVH3CkpN9Nn6mxLs+UVXzoDgnQGLMxFV0kYA5RrDvBEON
         9yH2SI589qCICvAD68c8bWJZ0dftj7oYaul1wnYvGoGu9ylzuZzZnb5OBxJJm1JKmI/F
         dJ/98P6tXrZmYr+cNwokFbq/PitIVz6TVdDoR2LjkxFKB8graOPS8Ri559A05evEmb1x
         n/2RQ5x6zo/jGhyllBtP/5qqdC0SeY5JCcUCmsp7ifL+6z8bMWQARIqeTF4H2/ooQrSF
         7ujA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tc3mXVzzOaZBy5gyuY36RG3hrmBxESsxJH6cjzwnYCE=;
        b=VeBRQkNiVqMgpogb9S5njwIo0eWrbMJzPnlDapvq2OSSzLICtukVrhCBu5pO+OP8QG
         AdBjMeBnUw77HRPoMoxXZ+cEZFFgWj2M7KzRUvOAK9S6zTTN9QVkTLJABSNO8WzpqWnB
         fDEgMVUxBC6o5eSfzjRQ/Shq2As0fEui038aKeIDc7i311WQvoAuvO9s8iXtmpizo9zo
         laqg1cL6dHZvJ1EbIRulLZK6vx4ob41HCKLpWOQ7TPfM2srMOJaQaPslo0Ovzt8nEaH9
         is2b1kGBcZLRoQFAJNE4W6zbCD8/r9U5AtT3KlY+gt28rIi34L6+tW3Vhc+fSIkb2sJi
         cIYQ==
X-Gm-Message-State: AOAM533cfs+CThVJsn/5PMegaeDwfzOlgvccHhg6VaoBaz8wD/DlawkN
        WE3J/n8SxEWVmYvDUNlgx3styLin7VgUlIw6nfokn/ZuEDkVIAsWMDKmTLINTVZ3F+I0QmIkUDx
        yw939nI+MMADLCNH02ZqDxLyXo81065LiB91E9nQZZ+m/nqJwykoypx5q9jKzs8E=
X-Google-Smtp-Source: ABdhPJyPSCCkl/K5UVGKkEu9Pa4VFG9SOYr7MwUgakcjaRqD+5d0aaPnebxqZaIiLnYnhcP9ybbQCof1iuzpkg==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:7608:b0:141:9a53:ceff with SMTP
 id k8-20020a170902760800b001419a53ceffmr3722147pll.78.1636425578745; Mon, 08
 Nov 2021 18:39:38 -0800 (PST)
Date:   Mon,  8 Nov 2021 18:39:05 -0800
In-Reply-To: <20211109023906.1091208-1-ricarkol@google.com>
Message-Id: <20211109023906.1091208-17-ricarkol@google.com>
Mime-Version: 1.0
References: <20211109023906.1091208-1-ricarkol@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 16/17] KVM: selftests: aarch64: add ISPENDR write tests in vgic_irq
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add injection tests that use writing into the ISPENDR register (to mark
IRQs as pending). This is typically used by migration code.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_irq.c  | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index 121113f24ed3..ab39f0bf18e7 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -65,6 +65,7 @@ typedef enum {
 	KVM_SET_IRQ_LINE_HIGH,
 	KVM_SET_LEVEL_INFO_HIGH,
 	KVM_INJECT_IRQFD,
+	KVM_WRITE_ISPENDR,
 } kvm_inject_cmd;
 
 struct kvm_inject_args {
@@ -105,6 +106,7 @@ static struct kvm_inject_desc inject_edge_fns[] = {
 	/*                                      sgi    ppi    spi */
 	{ KVM_INJECT_EDGE_IRQ_LINE,		false, false, true },
 	{ KVM_INJECT_IRQFD,			false, false, true },
+	{ KVM_WRITE_ISPENDR,			true,  false, true },
 	{ 0, },
 };
 
@@ -113,6 +115,7 @@ static struct kvm_inject_desc inject_level_fns[] = {
 	{ KVM_SET_IRQ_LINE_HIGH,		false, true,  true },
 	{ KVM_SET_LEVEL_INFO_HIGH,		false, true,  true },
 	{ KVM_INJECT_IRQFD,			false, false, true },
+	{ KVM_WRITE_ISPENDR,			false, true,  true },
 	{ 0, },
 };
 
@@ -495,6 +498,20 @@ static void kvm_set_gsi_routing_irqchip_check(struct kvm_vm *vm,
 	}
 }
 
+static void kvm_irq_write_ispendr_check(int gic_fd, uint32_t intid,
+			uint32_t vcpu, bool expect_failure)
+{
+	/*
+	 * Ignore this when expecting failure as invalid intids will lead to
+	 * either trying to inject SGIs when we configured the test to be
+	 * level_sensitive (or the reverse), or inject large intids which
+	 * will lead to writing above the ISPENDR register space (and we
+	 * don't want to do that either).
+	 */
+	if (!expect_failure)
+		kvm_irq_write_ispendr(gic_fd, intid, vcpu);
+}
+
 static void kvm_routing_and_irqfd_check(struct kvm_vm *vm,
 		uint32_t intid, uint32_t num, uint32_t kvm_max_routes,
 		bool expect_failure)
@@ -597,6 +614,11 @@ static void run_guest_cmd(struct kvm_vm *vm, int gic_fd,
 					test_args->kvm_max_routes,
 					expect_failure);
 		break;
+	case KVM_WRITE_ISPENDR:
+		for (i = intid; i < intid + num; i++)
+			kvm_irq_write_ispendr_check(gic_fd, i,
+					VCPU_ID, expect_failure);
+		break;
 	default:
 		break;
 	}
-- 
2.34.0.rc0.344.g81b53c2807-goog

