Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6D440EA6A
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 20:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345196AbhIPS5y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 14:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245570AbhIPS53 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 14:57:29 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF17C04A156
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:15:44 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id x11-20020ac86b4b000000b00299d7592d31so63203429qts.0
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ompqiNMWI2hga8pPlI1DdLrAhAHA2ErmtWHohcgkDnQ=;
        b=EIa4PYxeIB/jdTr4Bj3rabymZMfiRDUda4Z/1Om5oXzv+tZ0fVo/aVqKHI2InGS1OU
         j9lrVhRl1gkVZxnjRo2Omv6GbaDFwuTFsTyhpJYtmlVggm0E+aaYOkyBo2IY8jh1btCe
         GCVbynojpKzy/F6leYHtS6kaa6OBYmyZ/yg5VpAo7eUg7Ay9lq3XlUxJEOuwtyxYRwM7
         U8r/qmsNggetc0Jtt0lQFuvAKtC4IYRkZQuGIYG8PCS2CcI+gaR0uAWDft1vZecQzTlV
         1E3D6XDkidTe09oTgISDpS3sGZjyIeQ2ZsLL11W4oTK5YDPcDw9j6SfA/hsX0uy5AbmI
         bz8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ompqiNMWI2hga8pPlI1DdLrAhAHA2ErmtWHohcgkDnQ=;
        b=i3UtFNEVrV7weC1loiTRIvWg83dEGpPYc4rVRUBWWzErv6sn2YrN9gfp+k6dCDsnsJ
         oxhSAMVAcfhKr4OlStYOMzaigKPsQg+iwWw3bjD3RoIg5yBhFezSxr6yMF0FSHkJ5udb
         SepHDeXAdmrkqxIaybZz/1PaW5TH0xHp7qWUA1UL6vpGA4sl3E971IKjxhV2L3tdfIgO
         iSqnes+TN1zOVl2Xuk4z08loGmb1P9exx0u/ytc+AZcnVWbltzkozGrYwf+FpB2QJaeU
         LbNZfcN7td/3zccSRVS5n+zsT0sDaZ8rpFEkszk4mSwNArQTtIxdGzjF2cPrXhh/jgb8
         Ds3g==
X-Gm-Message-State: AOAM532VmJGB5in5+4LMhtM6NBB89EMLEWqVB7GWkI7GCEweUEbvRV7+
        Doxdpvi2paGhVhMEoZIBZPMInfdB137GJb2Zb3oTQ5TVrX6puvy2EX/4WehsSdp9npi9JoBt6v0
        I/KoAFd4RsUDn3PEBOWRJZoVwbqJtpCFyqthqnRcgj/CWe0/a9OqUJsyYHg==
X-Google-Smtp-Source: ABdhPJyMtDkmedSBXQ9JneBR51sdoiXY3FTPAb7hN3Y4cUearQHH1ZnZgDcI1O9vcz/G/4rXwSUCJqg2mWg=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:13ee:: with SMTP id
 ch14mr6861648qvb.43.1631816143780; Thu, 16 Sep 2021 11:15:43 -0700 (PDT)
Date:   Thu, 16 Sep 2021 18:15:33 +0000
In-Reply-To: <20210916181538.968978-1-oupton@google.com>
Message-Id: <20210916181538.968978-3-oupton@google.com>
Mime-Version: 1.0
References: <20210916181538.968978-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v8 2/7] KVM: x86: extract KVM_GET_CLOCK/KVM_SET_CLOCK to
 separate functions
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

From: Paolo Bonzini <pbonzini@redhat.com>

no functional change intended.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/x86.c | 99 ++++++++++++++++++++++++----------------------
 1 file changed, 52 insertions(+), 47 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1082b48418c3..c910cf31958f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5829,6 +5829,54 @@ int kvm_arch_pm_notifier(struct kvm *kvm, unsigned long state)
 }
 #endif /* CONFIG_HAVE_KVM_PM_NOTIFIER */
 
+static int kvm_vm_ioctl_get_clock(struct kvm *kvm, void __user *argp)
+{
+	struct kvm_clock_data data;
+	u64 now_ns;
+
+	now_ns = get_kvmclock_ns(kvm);
+	user_ns.clock = now_ns;
+	user_ns.flags = kvm->arch.use_master_clock ? KVM_CLOCK_TSC_STABLE : 0;
+	memset(&user_ns.pad, 0, sizeof(user_ns.pad));
+
+	if (copy_to_user(argp, &data, sizeof(data)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int kvm_vm_ioctl_set_clock(struct kvm *kvm, void __user *argp)
+{
+	struct kvm_arch *ka = &kvm->arch;
+	struct kvm_clock_data data;
+	u64 now_ns;
+
+	if (copy_from_user(&data, argp, sizeof(data)))
+		return -EFAULT;
+
+	if (data.flags)
+		return -EINVAL;
+
+	kvm_hv_invalidate_tsc_page(kvm);
+	kvm_start_pvclock_update(kvm);
+	pvclock_update_vm_gtod_copy(kvm);
+
+	/*
+	 * This pairs with kvm_guest_time_update(): when masterclock is
+	 * in use, we use master_kernel_ns + kvmclock_offset to set
+	 * unsigned 'system_time' so if we use get_kvmclock_ns() (which
+	 * is slightly ahead) here we risk going negative on unsigned
+	 * 'system_time' when 'data.clock' is very small.
+	 */
+	if (kvm->arch.use_master_clock)
+		now_ns = ka->master_kernel_ns;
+	else
+		now_ns = get_kvmclock_base_ns();
+	ka->kvmclock_offset = data.clock - now_ns;
+	kvm_end_pvclock_update(kvm);
+	return 0;
+}
+
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg)
 {
@@ -6072,55 +6120,12 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		break;
 	}
 #endif
-	case KVM_SET_CLOCK: {
-		struct kvm_arch *ka = &kvm->arch;
-		struct kvm_clock_data user_ns;
-		u64 now_ns;
-
-		r = -EFAULT;
-		if (copy_from_user(&user_ns, argp, sizeof(user_ns)))
-			goto out;
-
-		r = -EINVAL;
-		if (user_ns.flags)
-			goto out;
-
-		r = 0;
-
-		kvm_hv_invalidate_tsc_page(kvm);
-		kvm_start_pvclock_update(kvm);
-		pvclock_update_vm_gtod_copy(kvm);
-
-		/*
-		 * This pairs with kvm_guest_time_update(): when masterclock is
-		 * in use, we use master_kernel_ns + kvmclock_offset to set
-		 * unsigned 'system_time' so if we use get_kvmclock_ns() (which
-		 * is slightly ahead) here we risk going negative on unsigned
-		 * 'system_time' when 'user_ns.clock' is very small.
-		 */
-		if (kvm->arch.use_master_clock)
-			now_ns = ka->master_kernel_ns;
-		else
-			now_ns = get_kvmclock_base_ns();
-		ka->kvmclock_offset = user_ns.clock - now_ns;
-		kvm_end_pvclock_update(kvm);
+	case KVM_SET_CLOCK:
+		r = kvm_vm_ioctl_set_clock(kvm, argp);
 		break;
-	}
-	case KVM_GET_CLOCK: {
-		struct kvm_clock_data user_ns;
-		u64 now_ns;
-
-		now_ns = get_kvmclock_ns(kvm);
-		user_ns.clock = now_ns;
-		user_ns.flags = kvm->arch.use_master_clock ? KVM_CLOCK_TSC_STABLE : 0;
-		memset(&user_ns.pad, 0, sizeof(user_ns.pad));
-
-		r = -EFAULT;
-		if (copy_to_user(argp, &user_ns, sizeof(user_ns)))
-			goto out;
-		r = 0;
+	case KVM_GET_CLOCK:
+		r = kvm_vm_ioctl_get_clock(kvm, argp);
 		break;
-	}
 	case KVM_MEMORY_ENCRYPT_OP: {
 		r = -ENOTTY;
 		if (kvm_x86_ops.mem_enc_op)
-- 
2.33.0.309.g3052b89438-goog

