Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6527D3ECBE8
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 02:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbhHPAM0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Aug 2021 20:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbhHPAMK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Aug 2021 20:12:10 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739FCC0613C1
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:11:39 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j9-20020a2581490000b02905897d81c63fso15017803ybm.8
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kyk+rbWBkERQd/V+m5Ky7yGxQv7VTu6C8mlmv2dRF6E=;
        b=eUHubHDxtjyylPDdc7bFedowojWI9zLrQ6psYgTsmP3GTPLnhTiyG3JkHUedJyRGuV
         2eC7QcQGo03/1Q1arzvIjJknUW+aRLXuYxOvgHebRDZQ+7hdr2FgzaxHCH/W37K8ExbY
         9uhaQUa0ugMkV3wHWqJYNohGT7pEbAs0kvTvoALG1Idd6riRwTK8ubVHttvqg6pDcmgY
         R1VdJ2k/NjLhzNLeWBJXngB3Qv5y1wbhHQFfsF/Ri1L5Yh2n58lKXFT3Y2CGEQAj+riK
         Fl5HPuvhjJMALXNobtZyVFmABCcoh04VnbuWQBWv7Lpu4R2JoEVIcnsrmG4ADhqIYrQA
         rhBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kyk+rbWBkERQd/V+m5Ky7yGxQv7VTu6C8mlmv2dRF6E=;
        b=bR7deXuaSEf6oJGPisxKPuYtUSBYgjLeb+LVt97KIPEj+G8L/qpfjNJymZD6dSg6De
         y7CvJN0nO4Yjkg7AAZ5udNRxsnMdsflN2zpHM8tV6FxEXa/ocpAHACXW9pOnNDNl9Fvt
         511VJIkczCRLm9wu+DE7XnYSYkgVFqAef3UkrpwiQWikKPIUl9sdBxnYSZrx+zwMuER+
         0wbv105Mo4W3aY6NzWCQuXhP3X2T+JpKi++lQk+dQKSb7HnsTJFAoGbOlE2LmbNJYM3I
         cOtYQ7ZZCeWV6ru5eLHxfZOSqxCkSuOlM/EtKeip7pHhbwy1qUDGdmKWDWYTi3WD9El2
         5xZg==
X-Gm-Message-State: AOAM531ndLBM9boddO3rygwRovellKfMXX620g+T6bGh5bKyu7xrWWg7
        s97zTTqOJEPKk1zeGtPtVg6dipLuXjT28bH6QhSUNZxoyAvdPuvNmENsHv5h2+s2+XIez6ioP/0
        M5ZD4iUrMM+G95xLZlQgmelzEWlOiMnbJg1vZyG54f3f4UlL6QYZsf/xntQ==
X-Google-Smtp-Source: ABdhPJyMH3Sq1NjbgLuSEifGRtyldSI+jrBmr/Nsj225QWnfzIp+Bgns1yDUBBrraJg58Tk3MfA7ngTcz3A=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:7a04:: with SMTP id v4mr17335731ybc.261.1629072698596;
 Sun, 15 Aug 2021 17:11:38 -0700 (PDT)
Date:   Mon, 16 Aug 2021 00:11:28 +0000
In-Reply-To: <20210816001130.3059564-1-oupton@google.com>
Message-Id: <20210816001130.3059564-5-oupton@google.com>
Mime-Version: 1.0
References: <20210816001130.3059564-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 4/6] KVM: x86: Take the pvclock sync lock behind the tsc_write_lock
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

A later change requires that the pvclock sync lock be taken while
holding the tsc_write_lock. Change the locking in kvm_synchronize_tsc()
to align with the requirement to isolate the locking change to its own
commit.

Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 Documentation/virt/kvm/locking.rst | 11 +++++++++++
 arch/x86/kvm/x86.c                 |  2 +-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index 8138201efb09..0bf346adac2a 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -36,6 +36,9 @@ On x86:
   holding kvm->arch.mmu_lock (typically with ``read_lock``, otherwise
   there's no need to take kvm->arch.tdp_mmu_pages_lock at all).
 
+- kvm->arch.tsc_write_lock is taken outside
+  kvm->arch.pvclock_gtod_sync_lock
+
 Everything else is a leaf: no other lock is taken inside the critical
 sections.
 
@@ -222,6 +225,14 @@ time it will be set using the Dirty tracking mechanism described above.
 :Comment:	'raw' because hardware enabling/disabling must be atomic /wrt
 		migration.
 
+:Name:		kvm_arch::pvclock_gtod_sync_lock
+:Type:		raw_spinlock_t
+:Arch:		x86
+:Protects:	kvm_arch::{cur_tsc_generation,cur_tsc_nsec,cur_tsc_write,
+			cur_tsc_offset,nr_vcpus_matched_tsc}
+:Comment:	'raw' because updating the kvm master clock must not be
+		preempted.
+
 :Name:		kvm_arch::tsc_write_lock
 :Type:		raw_spinlock
 :Arch:		x86
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b1e9a4885be6..f1434cd388b9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2533,7 +2533,6 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 	vcpu->arch.this_tsc_write = kvm->arch.cur_tsc_write;
 
 	kvm_vcpu_write_tsc_offset(vcpu, offset);
-	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 
 	spin_lock_irqsave(&kvm->arch.pvclock_gtod_sync_lock, flags);
 	if (!matched) {
@@ -2544,6 +2543,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 
 	kvm_track_tsc_matching(vcpu);
 	spin_unlock_irqrestore(&kvm->arch.pvclock_gtod_sync_lock, flags);
+	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 }
 
 static inline void adjust_tsc_offset_guest(struct kvm_vcpu *vcpu,
-- 
2.33.0.rc1.237.g0d66db33f3-goog

