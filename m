Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 518173DFD5E
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 10:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236775AbhHDI6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 04:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235421AbhHDI6t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 04:58:49 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5C0C0613D5
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 01:58:36 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id h5-20020a05620a0525b02903b861bec838so1675771qkh.7
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 01:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=9z0ILel/nmHkGUMptTPmpCG4j9f031MAvczP47Mkt78=;
        b=AGG526CClu6IqHFTOxS7+h3HvPWXLqKYwyxWDqhy8O1Cl7kRhpnrrXFTY0kzLPlJzo
         NTLuHbzcLYaYfAWrM32xY1DL6EHrQH4/2lErBCn8/ZGON8Be4/Pp9eWnRrHfI5ABkk+e
         cUAX5/1tP6hG7xgE0KZ69uOsXKCWECXSJndhcqwqutNTyGslSd/lvGhdMfdY1YZV67+W
         DWELveZd0WTMUmICxJLUctfDxryaN/y9+D66dBcuvb4CitoE5kvYTWemb+5QNRxgHI0j
         rWPx8EeySutkqhAJYHR/vC6ZOVzwZ3vF7onQk6tkqzA+Opb0I7MhtY7K0lwaz97Zb10g
         jtsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9z0ILel/nmHkGUMptTPmpCG4j9f031MAvczP47Mkt78=;
        b=d3nLXgq65fk8fK4/0O7KJb0D35lEuye0/l73Ue2gYrLBhlrJ51Yqjya1IUn6IsH6yj
         BKfvaUcocuA/b61JTYBrA0avFiLcGfZYkXE2OqX0/yO6KAtEpCpb3X00iRXAXxl1lHwV
         EPoHrip4xXzkpU8SgGvgvdtc1F3PcKTA/SRtO8Hf9G5QOffCuiKbfsYTl7Ca3nL3qR4o
         o8DVBFtZwJkftP8lmNn2Wy4d/nH+9w5HIHzeQjoQ+E6gGmCTS/AdFOBB62Z/c942gbne
         aZ53noa9bWTX4RerWtlhNr+8sjCtOWp8E+cNSOPUY1xzDCexvAv+vmpvvTYVhCyzGyEv
         470g==
X-Gm-Message-State: AOAM531WyOpRYwwCuy4/TNr++fqVxTnVXCm8XnAqZbvJjoFpoMsWRjg7
        U21tl/ykLBV+0zEF0Rn6msGvSQbDoPyS+SPh3vF9iMqy2BtUnw2xhc3C3jpM7W4nj47AyZerKES
        k5qYrRH2pgzbMKoLQiG8eHhYljxpgoRRFtC1l9/VDlHc9ZuqqsfEIgEc4Uw==
X-Google-Smtp-Source: ABdhPJzxzqd5PN7eP88ZrBpXcJ5Qw54s+lcbwp2wfv6KXhmpgwkZOP22ITfr7gZ3p1xKgG6E9IZ8pxMUSks=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:332:: with SMTP id
 j18mr25863430qvu.21.1628067515916; Wed, 04 Aug 2021 01:58:35 -0700 (PDT)
Date:   Wed,  4 Aug 2021 08:57:59 +0000
In-Reply-To: <20210804085819.846610-1-oupton@google.com>
Message-Id: <20210804085819.846610-2-oupton@google.com>
Mime-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v6 01/21] KVM: x86: Fix potential race in KVM_GET_CLOCK
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
index 8cdf4ac6990b..34287c522f4e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2782,19 +2782,20 @@ static void kvm_gen_update_masterclock(struct kvm *kvm)
 #endif
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
@@ -2806,13 +2807,26 @@ u64 get_kvmclock_ns(struct kvm *kvm)
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
@@ -6104,11 +6118,14 @@ long kvm_arch_vm_ioctl(struct file *filp,
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
2.32.0.605.g8dce9f2422-goog

