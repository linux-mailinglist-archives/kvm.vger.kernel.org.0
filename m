Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C21A93ECBE1
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 02:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbhHPAMN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Aug 2021 20:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbhHPAMG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Aug 2021 20:12:06 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03722C061764
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:11:36 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id y8-20020a92c748000000b00224811cb945so690024ilp.6
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=J0lJJJkW+NmZlpb6fpFofwzCF2N0YPn/fE7VW8sEN0E=;
        b=onMRm+c0TmbvvH91s8krImCv1CKEk4b274WYjrqgKk7gKLOUw9VrXJClkZ1DmSna/8
         3tepivV3mzLKvagWxhpO+/WQdfkPceIPNKfBb2bGq51hsXJu/WQCIkjs874UB7dk0W9W
         oXAUvi79qPx6l8QqPRpDusbWhyXuCw7E1AogPxUA0fgJz83AKxK+/O+IR3aKYsxFeqZM
         JjNSmzkGS23X+RekEHj1AacWn1arDI/RxjwhBttOKfWKf9+zoiG8nYGaSZvEuGaZs74t
         Vs8UyftyhM2f38KfhifByPOjskfYoVIv781b+80yLp+3M+udeuw+Zi4uFZAtu/XHAmkx
         u6/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=J0lJJJkW+NmZlpb6fpFofwzCF2N0YPn/fE7VW8sEN0E=;
        b=U1h8Q0rQQ3Q6b+6r7bB4hRZ8RxwK9GWQVTaBz2jwXmaRkzWdGLiKj67j7yBwoBBzsh
         eEzgn1spK034XQomzQWt3cBqiRzx75j2ONjeMvaSKo5Zqe+3f7Ubp7S52+SKhfMnRJy0
         zHXi0Oc21v931PISpXuM9PcxZlKc7lx+qklIA/BO+/XRzRZpgPs0lBxQL5Zb4BW0RtsE
         MSpCdCNfZxEu5Knh9au0QpTmHUFhC/XJ/E5zhIIHHZmuWraRs138NFh1wuI/RZJeq4lU
         cpKhIAfg+lvyG4fGgSggelkrwrHfKUa9leS9XKuXsMvTPx4TGNH2zrhJ4wJmN0fV54vJ
         Yw+A==
X-Gm-Message-State: AOAM531h/kB0GLQDRGOyEnW78T1mUY1cNPqeGHw7mJp1qkTzvi334uuW
        A9uD/s+iiuFe/SXtRpZp3j+n5+6Z+1RQRpGcSI5WNSgs095qC++ptnvXmQqnAqI2B5ZbxGGDG/H
        2fX8KXa+DLUi2NcdnCiLfNUIF6uvQLoOwYmjMo+lbcCeZq0T+z+VBeLS/+w==
X-Google-Smtp-Source: ABdhPJw09eGgNy3EXbjdqGFxxJgFJV5YrUuGjNKkF5zMC9eqOSxrLDgPkbJpMCJxluIG+Ci2XveMUkYVc70=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:cd09:: with SMTP id g9mr12684753jaq.87.1629072695306;
 Sun, 15 Aug 2021 17:11:35 -0700 (PDT)
Date:   Mon, 16 Aug 2021 00:11:25 +0000
In-Reply-To: <20210816001130.3059564-1-oupton@google.com>
Message-Id: <20210816001130.3059564-2-oupton@google.com>
Mime-Version: 1.0
References: <20210816001130.3059564-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 1/6] KVM: x86: Fix potential race in KVM_GET_CLOCK
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean noticed that KVM_GET_CLOCK was checking kvm_arch.use_master_clock
outside of the pvclock sync lock. This is problematic, as the clock
value written to the user may or may not actually correspond to a stable
TSC.

Fix the race by populating the entire kvm_clock_data structure behind
the pvclock_gtod_sync_lock.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/x86.c | 39 ++++++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fdc0c18339fb..2f3929bd5f58 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2787,19 +2787,20 @@ static void kvm_update_masterclock(struct kvm *kvm)
 	kvm_end_pvclock_update(kvm);
 }
 
-u64 get_kvmclock_ns(struct kvm *kvm)
+static void get_kvmclock(struct kvm *kvm, struct kvm_clock_data *data)
 {
 	struct kvm_arch *ka = &kvm->arch;
 	struct pvclock_vcpu_time_info hv_clock;
 	unsigned long flags;
-	u64 ret;
 
 	spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
 	if (!ka->use_master_clock) {
 		spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
-		return get_kvmclock_base_ns() + ka->kvmclock_offset;
+		data->clock = get_kvmclock_base_ns() + ka->kvmclock_offset;
+		return;
 	}
 
+	data->flags |= KVM_CLOCK_TSC_STABLE;
 	hv_clock.tsc_timestamp = ka->master_cycle_now;
 	hv_clock.system_time = ka->master_kernel_ns + ka->kvmclock_offset;
 	spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
@@ -2811,13 +2812,26 @@ u64 get_kvmclock_ns(struct kvm *kvm)
 		kvm_get_time_scale(NSEC_PER_SEC, __this_cpu_read(cpu_tsc_khz) * 1000LL,
 				   &hv_clock.tsc_shift,
 				   &hv_clock.tsc_to_system_mul);
-		ret = __pvclock_read_cycles(&hv_clock, rdtsc());
-	} else
-		ret = get_kvmclock_base_ns() + ka->kvmclock_offset;
+		data->clock = __pvclock_read_cycles(&hv_clock, rdtsc());
+	} else {
+		data->clock = get_kvmclock_base_ns() + ka->kvmclock_offset;
+	}
 
 	put_cpu();
+}
 
-	return ret;
+u64 get_kvmclock_ns(struct kvm *kvm)
+{
+	struct kvm_clock_data data;
+
+	/*
+	 * Zero flags as it's accessed RMW, leave everything else uninitialized
+	 * as clock is always written and no other fields are consumed.
+	 */
+	data.flags = 0;
+
+	get_kvmclock(kvm, &data);
+	return data.clock;
 }
 
 static void kvm_setup_pvclock_page(struct kvm_vcpu *v,
@@ -6098,11 +6112,14 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	}
 	case KVM_GET_CLOCK: {
 		struct kvm_clock_data user_ns;
-		u64 now_ns;
 
-		now_ns = get_kvmclock_ns(kvm);
-		user_ns.clock = now_ns;
-		user_ns.flags = kvm->arch.use_master_clock ? KVM_CLOCK_TSC_STABLE : 0;
+		/*
+		 * Zero flags as it is accessed RMW, leave everything else
+		 * uninitialized as clock is always written and no other fields
+		 * are consumed.
+		 */
+		user_ns.flags = 0;
+		get_kvmclock(kvm, &user_ns);
 		memset(&user_ns.pad, 0, sizeof(user_ns.pad));
 
 		r = -EFAULT;
-- 
2.33.0.rc1.237.g0d66db33f3-goog

