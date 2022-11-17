Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E754862CF62
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 01:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233981AbiKQARY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 19:17:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbiKQARW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 19:17:22 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E4031FB3
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 16:17:21 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-386bb660154so3197967b3.18
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 16:17:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/2DmMdwiRBUsLE5SjUjPAC9NBnBP9UxCQTwqSFTfX5E=;
        b=CMnvzFpdejbVSi1OAAn0w8leDh5jUN3qiVPchNeCENWNn5PE62/3fbuVgqVi0hLqWb
         ltrex3AeYFAmqCd/c8Lq6zrhunIKU89WHjxmWFZyEB3SVXposVn4463+Zzh62fGxWZt/
         t0vucoj3p3gXwZlygVXSAlbRbiIXilaw1Q6uU9qSA+FQ3dXxe/nNB5okATHm6R4MUC1p
         0eH2mGA0TTnOm6VLz+vKo9hB//d2g6elAcsMIp25QaRiDOglwusniRhSyzb6aI4TXtld
         oLJXAXgTgv9R5fmIMDxvgkRSKGcEA1776dhF28eKSoO46v0apMVKjbz40xFi4OSbL0D/
         AugA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/2DmMdwiRBUsLE5SjUjPAC9NBnBP9UxCQTwqSFTfX5E=;
        b=zijCCikGz7Cu2/29sTyafvUT6VYdg5MZkjKqwv5CpalnAXXfN7NXa3RKKCf+pbe5sy
         5LHcjrsE7usdUQ9E1/uvdHI6uWLcZAF+CgJfc5KccLGoHjd0KCYAl5DoFWAxfTc0WRbC
         T9RX9pxw35YURI/xLHL35wye1x6qWnJJz++bI4+P2ovw6teU2fH4UrGxujk+AiywfjV9
         0uLwP5eeUNIwV5PUFkQZWL1e83S2FGwfN41CSl732pULPQo4M0p1uwA0v1409KcJvSSX
         biTKN1utlYpfkUGaNDExLc+va73Npn4UnHk3gtUlXmXW4NaSHH+ysIFFfr+f8TTLBDJS
         VEoQ==
X-Gm-Message-State: ANoB5pn5jkJ8d0l+wEjEhzseciRXkgAszhZ+yi86uccloJuEx1yc47dx
        GHSNiyzJbDg1NawlB15oHtipg1PdH5NtfQ==
X-Google-Smtp-Source: AA0mqf6YJFVLQnnn1nTWX4F8U1bhLpUWx1CH79OfqlssyQxDfMIxl78cAUkmirIYZ2/ByqGYbD80xfOxNeNAxg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:aba9:0:b0:6dc:786f:86d8 with SMTP id
 v38-20020a25aba9000000b006dc786f86d8mr64452ybi.597.1668644241104; Wed, 16 Nov
 2022 16:17:21 -0800 (PST)
Date:   Wed, 16 Nov 2022 16:16:57 -0800
In-Reply-To: <20221117001657.1067231-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221117001657.1067231-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221117001657.1067231-4-dmatlack@google.com>
Subject: [RFC PATCH 3/3] KVM: Obey kvm.halt_poll_ns in VMs not using KVM_CAP_HALT_POLL
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jon Cargille <jcargill@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>, kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Yanan Wang <wangyanan55@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Obey kvm.halt_poll_ns in VMs not using KVM_CAP_HALT_POLL on every halt,
rather than just sampling the module parameter when the VM is first
created. This restore the original behavior of kvm.halt_poll_ns for VMs
that have not opted into KVM_CAP_HALT_POLL.

Notably, this change restores the ability for admins to disable or
change the maximum halt-polling time system wide for VMs not using
KVM_CAP_HALT_POLL.

Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
Fixes: acd05785e48c ("kvm: add capability for halt polling")
Signed-off-by: David Matlack <dmatlack@google.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 27 ++++++++++++++++++++++++---
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e6e66c5e56f2..253ad055b6ad 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -788,6 +788,7 @@ struct kvm {
 	struct srcu_struct srcu;
 	struct srcu_struct irq_srcu;
 	pid_t userspace_pid;
+	bool override_halt_poll_ns;
 	unsigned int max_halt_poll_ns;
 	u32 dirty_ring_size;
 	bool vm_bugged;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 78caf19608eb..7f73ce99bd0e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1198,8 +1198,6 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 			goto out_err_no_arch_destroy_vm;
 	}
 
-	kvm->max_halt_poll_ns = halt_poll_ns;
-
 	r = kvm_arch_init_vm(kvm, type);
 	if (r)
 		goto out_err_no_arch_destroy_vm;
@@ -3490,7 +3488,20 @@ static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
 
 static unsigned int kvm_vcpu_max_halt_poll_ns(struct kvm_vcpu *vcpu)
 {
-	return READ_ONCE(vcpu->kvm->max_halt_poll_ns);
+	struct kvm *kvm = vcpu->kvm;
+
+	if (kvm->override_halt_poll_ns) {
+		/*
+		 * Ensure kvm->max_halt_poll_ns is not read before
+		 * kvm->override_halt_poll_ns.
+		 *
+		 * Pairs with the smp_wmb() when enabling KVM_CAP_HALT_POLL.
+		 */
+		smp_rmb();
+		return READ_ONCE(kvm->max_halt_poll_ns);
+	}
+
+	return READ_ONCE(halt_poll_ns);
 }
 
 /*
@@ -4600,6 +4611,16 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
 			return -EINVAL;
 
 		kvm->max_halt_poll_ns = cap->args[0];
+
+		/*
+		 * Ensure kvm->override_halt_poll_ns does not become visible
+		 * before kvm->max_halt_poll_ns.
+		 *
+		 * Pairs with the smp_rmb() in kvm_vcpu_max_halt_poll_ns().
+		 */
+		smp_wmb();
+		kvm->override_halt_poll_ns = true;
+
 		return 0;
 	}
 	case KVM_CAP_DIRTY_LOG_RING:
-- 
2.38.1.431.g37b22c650d-goog

