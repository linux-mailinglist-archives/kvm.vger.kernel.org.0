Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2233DFD61
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 10:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236811AbhHDI6v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 04:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235421AbhHDI6v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 04:58:51 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC06EC0613D5
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 01:58:38 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id c7-20020a928e070000b0290222cccb8651so609862ild.14
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 01:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=yT+nCrFmg471JgKctqrSQtIm1tfSoSdZEimBbuaP3hM=;
        b=I75O/UznjRurZ12yqjeSXM1uRHLtkMyqOHMPWxjHv7EqFHpdUtNM/q2lhH3rSJRXMi
         hmtx2v5DfPRntVTXd1HEnfhKFNm++uRppRctqQ9/tBN3y/qLQO6G3I2+zHRVMWwO1Qei
         zrOEuyl5E91LBxGmWuvw3x7WRXMvdLPIXIO7e3es+i3ueOVQhqmLhiWEr19ExFdGTomd
         tzU7TnghJPoMZ486oD2ZRvoEOyvto0wtqL/JmqdjzcDUWMzObugg/StxuiD9e42u0kek
         tBdoapOnjPK+cQ9upIllnUwqm+zBJQdTCWl7xwGMM/2Q+sZLNygYgEiJoxOxk2TjKJ7l
         qk2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=yT+nCrFmg471JgKctqrSQtIm1tfSoSdZEimBbuaP3hM=;
        b=JvprzMpG1xfcxSHu8jSMuu7HcH+bZIPUc0adzqugszAoVzeB3GRlLKGMjovYnP0se2
         EEiwd4t0UeoJMg52Vs8PJ+NDhljAKzcbLPCHkkhjuo0G/znJMOxgZf4FDd9Z9qUKYmbN
         t2RABQMAovyyEXWeKsLTzrXljNJ3o2VbVfA9cNHL4OCvYTO7Btvo2yhscfgzWImBgnlb
         52dCwiJJQ0MJpOVbcJ29WCRMDrsTuwteMHbLCTj46ZRTH968/4xHsfKjEQ5UYOHqFvGM
         gcvStgJwk3siIczV1xyXdGguRW3af4s+NFK9vbF9w5tXu7tQQj+knPdyAwf9WEe4ziLo
         CudA==
X-Gm-Message-State: AOAM533PckNERgFJus118+f5eGDOX7Bw64QQ7yHv1ZynUeGZD5JH7V9i
        1m4x2LOEC+UC5ob/Klq1zYDP9C5sDprQwn+I3prP60W+4fwqnAiB8QA89Xe82c3Q6Rwt0yomqi+
        GrauGil5fNHn8Hp2cfeI37IwitVtXppUF22jXr46KmWpGCcyGo1T+LJunfw==
X-Google-Smtp-Source: ABdhPJxSOYTpnXMnEgvD536Lr//pppHFulfycmnTBjxZ233HWebGAqoEW5FBilAhV/Yot+rrAUs5jGbPkWM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:cf44:: with SMTP id c4mr262704ilr.11.1628067518129;
 Wed, 04 Aug 2021 01:58:38 -0700 (PDT)
Date:   Wed,  4 Aug 2021 08:58:01 +0000
In-Reply-To: <20210804085819.846610-1-oupton@google.com>
Message-Id: <20210804085819.846610-4-oupton@google.com>
Mime-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v6 03/21] KVM: x86: Take the pvclock sync lock behind the tsc_write_lock
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
index 26f1fa263192..93b449761fbe 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2529,7 +2529,6 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 	vcpu->arch.this_tsc_write = kvm->arch.cur_tsc_write;
 
 	kvm_vcpu_write_tsc_offset(vcpu, offset);
-	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 
 	spin_lock_irqsave(&kvm->arch.pvclock_gtod_sync_lock, flags);
 	if (!matched) {
@@ -2540,6 +2539,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 
 	kvm_track_tsc_matching(vcpu);
 	spin_unlock_irqrestore(&kvm->arch.pvclock_gtod_sync_lock, flags);
+	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 }
 
 static inline void adjust_tsc_offset_guest(struct kvm_vcpu *vcpu,
-- 
2.32.0.605.g8dce9f2422-goog

