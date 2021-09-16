Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5A5D40EA6C
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 20:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344712AbhIPS55 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 14:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245110AbhIPS5a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 14:57:30 -0400
Received: from mail-oo1-xc49.google.com (mail-oo1-xc49.google.com [IPv6:2607:f8b0:4864:20::c49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1854C04A157
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:15:45 -0700 (PDT)
Received: by mail-oo1-xc49.google.com with SMTP id e17-20020a056820061100b002910b1828a0so34384119oow.16
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/xw1HPEE3yg6hDZiSRSN4mqpJW+LQ6wXxySnmKRFyJ8=;
        b=aeIy+Fj9Ddx5QaJjlHoSsG2pqbF8w2bOPA1NUF6/sz/meu/pc2y7XH5Frw9KOhU9jX
         /kH/TSaeEzKpU3E9F4mu2P4UwMb8CA8hVkOuGgpkMxluodvQx0JB40MGxrC/28jBzSpS
         tOcue5Y0S/zW65/M/S+fci0vMm5hJ5aXdp3cKtcIkEKR27UTz5eqwFNzBMVkFzM01TOD
         rlmCukD6+Sq5NdvlmiFK9SoTsk9V7CF9hxsEpXwf31yhlcLh4USsTGsziVGOqmjspN8o
         0Ky6X+cH1ZOM4CgbuHJIjBmRAlEsdJzbNTWMO+pHL8eK5LJOZ0KcX4fxKffaaQujOn7V
         WyoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/xw1HPEE3yg6hDZiSRSN4mqpJW+LQ6wXxySnmKRFyJ8=;
        b=uie8DFHgysaFaBZtacoOObCeASNNw+M6I4+cWgOqSu7ve7EucI4yn/7M/xhPgHauxG
         KnmA/oIj4FAoHYbJjIy/J6KttA8WStPLVL0B15KXlSYihMotCscNIPPPHlmJZZKU1S4/
         UmFynFfBeDyHAq71083WC5HN1BgIfIXKeXfRsM3KiiwBcuQfoawGNcHzQIeEWPvLGhbB
         ZMkodpf5LILHVTrzyE4zEFjK6/z8qwhnGGMOZl2gxxGlV3D1pt1IyAs29JQFbUP38YTV
         gXuq1oKi+6UPQrCUteq9DsB+RaekmpZa0RSSEQPKpAtdb327hNRFCZLHxM3m19s9Oxsh
         ajyg==
X-Gm-Message-State: AOAM531/rrlpX+YoXYLvr5Uh55qGiaO41gedVe1RWmwZ3SS8SV3QcUIQ
        qnEboZJ3SDB+21mzMz+Ne21wI3jAzYgwmfe2GUmRAdj9/iSsOYOID7dkPPUrGheHexN2Cr1uZN6
        eGtghMWzkHBZ0UQG7/wWclvXGxATYBs5PGbGcA0XAdbQFhmj8Y0rkA9+/2Q==
X-Google-Smtp-Source: ABdhPJwhSdiutQtzePdJzjaNwKrgENSZ7USY45/SDq1qTsydz5Pm4qLqm2IgqkpSSQFsIfTfuENKHUrRnnM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a9d:7f07:: with SMTP id j7mr5952745otq.84.1631816144992;
 Thu, 16 Sep 2021 11:15:44 -0700 (PDT)
Date:   Thu, 16 Sep 2021 18:15:34 +0000
In-Reply-To: <20210916181538.968978-1-oupton@google.com>
Message-Id: <20210916181538.968978-4-oupton@google.com>
Mime-Version: 1.0
References: <20210916181538.968978-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v8 3/7] KVM: x86: Fix potential race in KVM_GET_CLOCK
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
 arch/x86/kvm/x86.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c910cf31958f..523c4e5c109f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2793,19 +2793,20 @@ static void kvm_update_masterclock(struct kvm *kvm)
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
@@ -2817,13 +2818,26 @@ u64 get_kvmclock_ns(struct kvm *kvm)
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
@@ -5832,13 +5846,9 @@ int kvm_arch_pm_notifier(struct kvm *kvm, unsigned long state)
 static int kvm_vm_ioctl_get_clock(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_clock_data data;
-	u64 now_ns;
-
-	now_ns = get_kvmclock_ns(kvm);
-	user_ns.clock = now_ns;
-	user_ns.flags = kvm->arch.use_master_clock ? KVM_CLOCK_TSC_STABLE : 0;
-	memset(&user_ns.pad, 0, sizeof(user_ns.pad));
 
+	memset(&data, 0, sizeof(data));
+	get_kvmclock(kvm, &data);
 	if (copy_to_user(argp, &data, sizeof(data)))
 		return -EFAULT;
 
-- 
2.33.0.309.g3052b89438-goog

