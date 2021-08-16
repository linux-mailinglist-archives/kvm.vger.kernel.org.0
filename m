Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540A13ECBE6
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 02:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbhHPAMT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Aug 2021 20:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbhHPAMH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Aug 2021 20:12:07 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14881C061764
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:11:37 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id c7-20020a928e070000b0290222cccb8651so8698599ild.14
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=JjAheCeU8OLcl85r3fMj4Tdvexc0vXT5B0Nj3krTsUc=;
        b=d6cpi6xW3Siu7V3Ocspqj9m35qtPwhy9VjX9IpuhYvzlBO9bm8dw1P5J7VBwrG/v2d
         Fupr4JhmaYS9+w6umx9EqHBP3LfnMtK1Kr/jxVbEcNDyy8oQGQ3no2t92dY3FKEEIXEa
         CfCckQags7sN+kVlG5Hdj57ck9GltxZaJKxUBfcwB427IahQVbWxenKXA58a5qIeC3DG
         8MrhNb0gHlaZT3vFri2g7jpaq5huj5XKJlGzrhzAtTdOSINjh7hF5DnQT/nJ3MjbGZNe
         c04JMAGppd3t5hTbFCi+s+kwGbL+qIHiUT7IsFop3H7TGFWcKRZxC8p8YgqscoZog1mz
         mhbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JjAheCeU8OLcl85r3fMj4Tdvexc0vXT5B0Nj3krTsUc=;
        b=s/0jD5r2AbmbzYE/QG2gW6eTAtJQi3AZ6MUl6LCUsxcNOuau9quhzcOoKcbitlE8ny
         QnBqMzjb5+wYotobH0AhbPa2UKst17KQgAmLQTxu9pkh0E6WQLMuRL7HjpZIVFlS9vvr
         Dw+yOaoT2/ujNLCwS/6ENDgIIM9h/bJ64U/CYW3AC+DY2p2X7TdZFntWBT1I4/2NiMcl
         lWyLbDU2y9FmCwbfTNiLZZdkKbKduQ5Hg8FoKr13G19oZv4fE1CysIkf3rRC+9HnCFex
         NAOkmkyImhsno8to4OShYfEbeOzJ7ul/VhbMEQa9q5xMtMw60JtLCMI4wGrxXbYbHFiD
         bA8A==
X-Gm-Message-State: AOAM531D1AWITcf2EHGCL5+Bw4NwJGUZWnKrAY1m52YA7Qx0rvYilw/W
        /tKs5E9lnlj1ergDqlvpmL7vfzSYc3CmVredG5dWCJB6CNgOuI88JIJQlf6VTP8Xg1tfXdFraui
        n1NLuM/w00HqdmclUhVJlITbNGmh2QAXcK/GqyW5ETlEhj2B0ncBbvKeb5w==
X-Google-Smtp-Source: ABdhPJzql/ws9nv1W9hhmm8kA+C+wyM8/Yyi52JOtJkxfAmPdz1NtGSbK43RlGb0QaSB6Cb2d7x8Jf49cT8=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:cca8:: with SMTP id t8mr13047843jap.51.1629072696400;
 Sun, 15 Aug 2021 17:11:36 -0700 (PDT)
Date:   Mon, 16 Aug 2021 00:11:26 +0000
In-Reply-To: <20210816001130.3059564-1-oupton@google.com>
Message-Id: <20210816001130.3059564-3-oupton@google.com>
Mime-Version: 1.0
References: <20210816001130.3059564-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 2/6] KVM: x86: Create helper methods for
 KVM_{GET,SET}_CLOCK ioctls
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

Wrap the existing implementation of the KVM_{GET,SET}_CLOCK ioctls in
helper methods.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/x86.c | 107 ++++++++++++++++++++++++---------------------
 1 file changed, 57 insertions(+), 50 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2f3929bd5f58..39eaa2fb2001 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5833,12 +5833,65 @@ int kvm_arch_pm_notifier(struct kvm *kvm, unsigned long state)
 }
 #endif /* CONFIG_HAVE_KVM_PM_NOTIFIER */
 
+static int kvm_vm_ioctl_get_clock(struct kvm *kvm, void __user *argp)
+{
+	struct kvm_clock_data data;
+
+	/*
+	 * Zero flags as it is accessed RMW, leave everything else
+	 * uninitialized as clock is always written and no other fields
+	 * are consumed.
+	 */
+	data.flags = 0;
+	get_kvmclock(kvm, &data);
+	memset(&data.pad, 0, sizeof(data.pad));
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
+
+	return 0;
+}
+
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg)
 {
 	struct kvm *kvm = filp->private_data;
 	void __user *argp = (void __user *)arg;
 	int r = -ENOTTY;
+
 	/*
 	 * This union makes it completely explicit to gcc-3.x
 	 * that these two variables' stack usage should be
@@ -6076,58 +6129,12 @@ long kvm_arch_vm_ioctl(struct file *filp,
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
-
-		/*
-		 * Zero flags as it is accessed RMW, leave everything else
-		 * uninitialized as clock is always written and no other fields
-		 * are consumed.
-		 */
-		user_ns.flags = 0;
-		get_kvmclock(kvm, &user_ns);
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
2.33.0.rc1.237.g0d66db33f3-goog

