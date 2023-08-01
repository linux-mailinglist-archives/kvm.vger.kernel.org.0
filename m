Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 930FA76A79C
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 05:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbjHADpt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 23:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbjHADpq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 23:45:46 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66ABCAD;
        Mon, 31 Jul 2023 20:45:45 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id 5614622812f47-3a37909a64eso3625137b6e.1;
        Mon, 31 Jul 2023 20:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690861544; x=1691466344;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KfszHRJOVPfFpXtBsFWgYXU08hYic2XalPmb5NyIUGA=;
        b=r0eQ6oNlqT/CYhxMXlHrSqRna1+pWrzucl07KD8GoR8uKjhr0+LhPTecphfX99fZoM
         p+FepPXfM7Iyrngo1UT5jOCKm7q5R2hpWT6X0dGRekhNUCuiuOxMxY/r1mpE5QKrK9Am
         g5TNUzAzMWq7APnoaLM9buVwwVSG5h6d/jNWI9asrQvQS4fY0o5Sa+N6shS5TeAE1fyK
         b5k/Wi1wIOAZs+s7kcitY3JRyyqhbulwC+4rbtbvS3Swp761u1pZ0lY/FD+riiEMnQsP
         blNPX2YarQqaeJh8byy5sPU7bd8rIdyBbm/lJuIaELoSspyMyZ/IUyI1uYOmgtM7POOH
         G4yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690861544; x=1691466344;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KfszHRJOVPfFpXtBsFWgYXU08hYic2XalPmb5NyIUGA=;
        b=ipAuUKCq6klQC/seKzCNOy/XOhQooHniJ+H4/R0nCFjR2aLIoxdGN2cLVh1BePuK0q
         tj9/BlKu7xEs20GXY9YjteANjDL35RilUqOdJQeixiVvOS8djrwHIQcjZp4pKncssw/8
         lGE5d112NFPg9CPaWVYi0mUC08r2gFRyGGFEzRPmwwok6b2XQd2LZZ5nvQuDO6HUqXQk
         1QvM2HOwuATSTOJu7itrL0TRC2tLjpop4J7XiFysgwfb7WZwAaOZrMHbRg6aV44IJeXe
         BbtxNzv9dLapgijq0O91dKgc0AyxUQA0UAMu802OY2k0jaVR/rB/uKGpmdDuMOdDxMic
         WVPA==
X-Gm-Message-State: ABy/qLY4sHME9yuk11h5mD5hBWgLHRn7IqNh7YN811s9lv8tTHQiHDKc
        yk+4jhtnWM2Jwk9Ydh72mfGgwJxun4qYJyrL
X-Google-Smtp-Source: APBJJlHkPFZuiN6J/2wxYByVcMRwxpk6AADIbb0O6Kk9PZAyZgCSCyPX9fAMJZ/gu1+9GgBgBB7j3A==
X-Received: by 2002:a05:6808:d4f:b0:3a6:fb16:c782 with SMTP id w15-20020a0568080d4f00b003a6fb16c782mr13051441oik.30.1690861544348;
        Mon, 31 Jul 2023 20:45:44 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id r2-20020a63a002000000b00563ff7d9c4bsm8636723pge.73.2023.07.31.20.45.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 20:45:43 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4] KVM: x86/tsc: Don't sync user changes to TSC with KVM-initiated change
Date:   Tue,  1 Aug 2023 11:45:24 +0800
Message-ID: <20230801034524.64007-1-likexu@tencent.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Add kvm->arch.user_changed_tsc to avoid synchronizing user-initiated
changes to the guest TSC with the KVM initiated change at least once.

KVM interprets writes to the TSC with values within 1 second of each
other as an attempt to synchronize the TSC for all vCPUs in the VM,
and uses a common offset for all vCPUs in a VM. For brevity's sake
let's just ignore what happens on systems with an unstable TSC.

While this may seem odd, it is imperative for VM save/restore, as VMMs
such as QEMU have long resorted to saving the TSCs (by value) from all
vCPUs in the VM at approximately the same time. Of course, it is
impossible to synchronize all the vCPU ioctls to capture the exact
instant in time, hence KVM fudges it a bit on the restore side.

This has been useful for the 'typical' VM lifecycle, where in all
likelihood the VM goes through save/restore a considerable amount of
time after VM creation. Nonetheless, there are some use cases that
need to restore a VM snapshot that was created very shortly after boot
(<1 second). Unfortunately the TSC sync code makes no distinction
between kernel and user-initiated writes, which leads to the target VM
synchronizing on the TSC offset from creation instead of the
user-intended value.

Avoid synchronizing user-initiated changes to the guest TSC with the
KVM initiated change in kvm_arch_vcpu_postcreate() by conditioning the
logic on userspace having written the TSC at least once.

Reported-by: Yong He <alexyonghe@tencent.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217423
Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Original-by: Oliver Upton <oliver.upton@linux.dev>
Tested-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
V3 -> V4 Changelog:
- Apply the suggested changelog for better clarification of issue; (Oliver)
V3: https://lore.kernel.org/kvm/20230731080758.29482-1-likexu@tencent.com/

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 23 ++++++++++++++++-------
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3bc146dfd38d..e8d423ef1474 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1303,6 +1303,7 @@ struct kvm_arch {
 	u64 cur_tsc_offset;
 	u64 cur_tsc_generation;
 	int nr_vcpus_matched_tsc;
+	bool user_changed_tsc;
 
 	u32 default_tsc_khz;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 278dbd37dab2..eeaf4ad9174d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2713,7 +2713,7 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
 	kvm_track_tsc_matching(vcpu);
 }
 
-static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
+static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data, bool user_initiated)
 {
 	struct kvm *kvm = vcpu->kvm;
 	u64 offset, ns, elapsed;
@@ -2734,20 +2734,29 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 			 * kvm_clock stable after CPU hotplug
 			 */
 			synchronizing = true;
-		} else {
+		} else if (kvm->arch.user_changed_tsc) {
 			u64 tsc_exp = kvm->arch.last_tsc_write +
 						nsec_to_cycles(vcpu, elapsed);
 			u64 tsc_hz = vcpu->arch.virtual_tsc_khz * 1000LL;
 			/*
-			 * Special case: TSC write with a small delta (1 second)
-			 * of virtual cycle time against real time is
-			 * interpreted as an attempt to synchronize the CPU.
+			 * Here lies UAPI baggage: user-initiated TSC write with
+			 * a small delta (1 second) of virtual cycle time
+			 * against real time is interpreted as an attempt to
+			 * synchronize the CPU.
+			 *
+			 * Don't synchronize user changes to the TSC with the
+			 * KVM-initiated change in kvm_arch_vcpu_postcreate()
+			 * by conditioning this mess on userspace having
+			 * written the TSC at least once already.
 			 */
 			synchronizing = data < tsc_exp + tsc_hz &&
 					data + tsc_hz > tsc_exp;
 		}
 	}
 
+	if (user_initiated)
+		kvm->arch.user_changed_tsc = true;
+
 	/*
 	 * For a reliable TSC, we can match TSC offsets, and for an unstable
 	 * TSC, we add elapsed time in this computation.  We could let the
@@ -3776,7 +3785,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_TSC:
 		if (msr_info->host_initiated) {
-			kvm_synchronize_tsc(vcpu, data);
+			kvm_synchronize_tsc(vcpu, data, true);
 		} else {
 			u64 adj = kvm_compute_l1_tsc_offset(vcpu, data) - vcpu->arch.l1_tsc_offset;
 			adjust_tsc_offset_guest(vcpu, adj);
@@ -11950,7 +11959,7 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 	if (mutex_lock_killable(&vcpu->mutex))
 		return;
 	vcpu_load(vcpu);
-	kvm_synchronize_tsc(vcpu, 0);
+	kvm_synchronize_tsc(vcpu, 0, false);
 	vcpu_put(vcpu);
 
 	/* poll control enabled by default */

base-commit: 5a7591176c47cce363c1eed704241e5d1c42c5a6
-- 
2.41.0

