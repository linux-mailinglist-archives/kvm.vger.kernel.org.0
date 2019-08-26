Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5559C931
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 08:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729597AbfHZGV0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 02:21:26 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33899 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729585AbfHZGV0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 02:21:26 -0400
Received: by mail-pl1-f193.google.com with SMTP id d3so9513096plr.1;
        Sun, 25 Aug 2019 23:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BsqBrZVvB3aYALU0Tr4c1e95Wzoeukjoi28dg9zJbFw=;
        b=L5oTXekFL6XwdH2IxzLZb9BPgpAF4Jrd5oL5Qkxw4la7UNp3raE/gDoW4Ff2njXY/F
         wdSGiTTiBim5/m4viHMCSHxTPclRHXZ2oF3Z9iUWHV4QtNwZykcU91WYvBJbQbuC0xpy
         JPStkhcrFwheKDf+oWWOpwBKmaxEV+i3POC3OKa0NvgpdNXfNAcdtDlZ0C3FDZOHgM6x
         L8mYYPmp5GpkzrJpyIKiO9ljIUvxHHsu/M3g6FXAHb2VLjtpi+F2dyhYcQwWakNYYILO
         2gAVbLrTkEzjSHGyuKlALvZ/DYgl9udvepTbbumpBG2jf8r6JPhCUzkgkYvFIpCy1iti
         RmOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BsqBrZVvB3aYALU0Tr4c1e95Wzoeukjoi28dg9zJbFw=;
        b=RdbpSPdy6ohVEIf2gXQO57dWTi20d+ogyNeILISYQKBBDUhe+bxVCUWRo3GdePMmQV
         zcKlWaLjQLvbJACKL152echZoH4ael2f0jCNIOe7xaQ+IHFvMfl6WpRTHUMyA9F9ZdHt
         oQw/7qZAWdxapKJ/XZ95EMSFRdV9I41vmJ3qH6Tc1xp5m6YAF9A6+gWwK3XkxG1fmdT9
         W+XajwibOYeU0dSzXtdT3TnGDDB067pUQsh2YX9CSgSA+1e3qVhStWzzXPIc7h1l2qzh
         euqgRUTukieMyHBDUZdZN1AML86OQ1y/Hlfy5rzsyssjZoBUP/zpsX5EikrkFFMLXE5c
         U9qw==
X-Gm-Message-State: APjAAAUMM63R/pfg86BjuTui53y9eCbn+Uek9jUA6P+ZotaVJiwi4Obd
        7dOXfaz7t3iLhfdMJHrGxREX8f8eVcQ=
X-Google-Smtp-Source: APXvYqyJt804GoPFT7TCrV0yG4vt2QTsxBhXYoGaGAw8QSwT31LeXaJzR3A0dxrXoV5cBtMlNM7egA==
X-Received: by 2002:a17:902:f01:: with SMTP id 1mr16872518ply.337.1566800485320;
        Sun, 25 Aug 2019 23:21:25 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id f7sm10030353pfd.43.2019.08.25.23.21.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 25 Aug 2019 23:21:24 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     paulus@ozlabs.org, kvm@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [PATCH 04/23] KVM: PPC: Book3S HV: Handle making H_ENTER_NESTED hcall in a separate function
Date:   Mon, 26 Aug 2019 16:20:50 +1000
Message-Id: <20190826062109.7573-5-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20190826062109.7573-1-sjitindarsingh@gmail.com>
References: <20190826062109.7573-1-sjitindarsingh@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A pseries guest (that is a guest acting as a guest hypervisor) which
would like to run it's own guest (a nested guest) must perform this by
invoking the top level hypervisor via the H_ENTER_NESTED hcall.

Separate out the code which handles calling this into a separate
function for code clarity and readability.

No functional change.

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 88 ++++++++++++++++++++++++--------------------
 1 file changed, 49 insertions(+), 39 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index ce960301bfaa..4901738a3c31 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3367,7 +3367,55 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 }
 
 /*
+ * Handle making the H_ENTER_NESTED hcall if we're pseries.
+ */
+static int kvmhv_pseries_enter_guest(struct kvm_vcpu *vcpu, u64 time_limit,
+				     unsigned long lpcr)
+{
+	/* call our hypervisor to load up HV regs and go */
+	struct hv_guest_state hvregs;
+	/* we need to save/restore host & guest psscr since L0 doesn't for us */
+	unsigned long host_psscr;
+	int trap;
+
+	host_psscr = mfspr(SPRN_PSSCR_PR);
+	mtspr(SPRN_PSSCR_PR, vcpu->arch.psscr);
+	kvmhv_save_hv_regs(vcpu, &hvregs);
+	hvregs.lpcr = lpcr;
+	vcpu->arch.regs.msr = vcpu->arch.shregs.msr;
+	hvregs.version = HV_GUEST_STATE_VERSION;
+	if (vcpu->arch.nested) {
+		hvregs.lpid = vcpu->arch.nested->shadow_lpid;
+		hvregs.vcpu_token = vcpu->arch.nested_vcpu_id;
+	} else {
+		hvregs.lpid = vcpu->kvm->arch.lpid;
+		hvregs.vcpu_token = vcpu->vcpu_id;
+	}
+	hvregs.hdec_expiry = time_limit;
+	trap = plpar_hcall_norets(H_ENTER_NESTED, __pa(&hvregs),
+				  __pa(&vcpu->arch.regs));
+	kvmhv_restore_hv_return_state(vcpu, &hvregs);
+	vcpu->arch.shregs.msr = vcpu->arch.regs.msr;
+	vcpu->arch.shregs.dar = mfspr(SPRN_DAR);
+	vcpu->arch.shregs.dsisr = mfspr(SPRN_DSISR);
+	vcpu->arch.psscr = mfspr(SPRN_PSSCR_PR);
+	mtspr(SPRN_PSSCR_PR, host_psscr);
+
+	/* H_CEDE has to be handled now, not later */
+	if (trap == BOOK3S_INTERRUPT_SYSCALL && !vcpu->arch.nested &&
+	    kvmppc_get_gpr(vcpu, 3) == H_CEDE) {
+		kvmppc_nested_cede(vcpu);
+		trap = 0;
+	}
+
+	return trap;
+}
+
+/*
  * Load up hypervisor-mode registers on P9.
+ * This is only called on baremetal (powernv) systems i.e. where
+ * CPU_FTR_HVMODE is set. This is only used for radix guests, however that
+ * radix guest may be a direct guest of this hypervisor or a nested guest.
  */
 static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 				     unsigned long lpcr)
@@ -3569,45 +3617,7 @@ int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	mtspr(SPRN_DEC, vcpu->arch.dec_expires - mftb());
 
 	if (kvmhv_on_pseries()) {
-		/*
-		 * We need to save and restore the guest visible part of the
-		 * psscr (i.e. using SPRN_PSSCR_PR) since the hypervisor
-		 * doesn't do this for us. Note only required if pseries since
-		 * this is done in kvmhv_load_hv_regs_and_go() below otherwise.
-		 */
-		unsigned long host_psscr;
-		/* call our hypervisor to load up HV regs and go */
-		struct hv_guest_state hvregs;
-
-		host_psscr = mfspr(SPRN_PSSCR_PR);
-		mtspr(SPRN_PSSCR_PR, vcpu->arch.psscr);
-		kvmhv_save_hv_regs(vcpu, &hvregs);
-		hvregs.lpcr = lpcr;
-		vcpu->arch.regs.msr = vcpu->arch.shregs.msr;
-		hvregs.version = HV_GUEST_STATE_VERSION;
-		if (vcpu->arch.nested) {
-			hvregs.lpid = vcpu->arch.nested->shadow_lpid;
-			hvregs.vcpu_token = vcpu->arch.nested_vcpu_id;
-		} else {
-			hvregs.lpid = vcpu->kvm->arch.lpid;
-			hvregs.vcpu_token = vcpu->vcpu_id;
-		}
-		hvregs.hdec_expiry = time_limit;
-		trap = plpar_hcall_norets(H_ENTER_NESTED, __pa(&hvregs),
-					  __pa(&vcpu->arch.regs));
-		kvmhv_restore_hv_return_state(vcpu, &hvregs);
-		vcpu->arch.shregs.msr = vcpu->arch.regs.msr;
-		vcpu->arch.shregs.dar = mfspr(SPRN_DAR);
-		vcpu->arch.shregs.dsisr = mfspr(SPRN_DSISR);
-		vcpu->arch.psscr = mfspr(SPRN_PSSCR_PR);
-		mtspr(SPRN_PSSCR_PR, host_psscr);
-
-		/* H_CEDE has to be handled now, not later */
-		if (trap == BOOK3S_INTERRUPT_SYSCALL && !vcpu->arch.nested &&
-		    kvmppc_get_gpr(vcpu, 3) == H_CEDE) {
-			kvmppc_nested_cede(vcpu);
-			trap = 0;
-		}
+		trap = kvmhv_pseries_enter_guest(vcpu, time_limit, lpcr);
 	} else {
 		trap = kvmhv_load_hv_regs_and_go(vcpu, time_limit, lpcr);
 	}
-- 
2.13.6

