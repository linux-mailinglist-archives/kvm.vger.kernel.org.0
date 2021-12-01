Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9CD7464D71
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 13:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349158AbhLAMII (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 07:08:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54956 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349149AbhLAMIG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 07:08:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBB38B81E66
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 12:04:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933F5C53FD5;
        Wed,  1 Dec 2021 12:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638360283;
        bh=Y6IbRR56aDBvOEwfHFjAMyQtTO8uqhozFSDwo/ky2ns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YN1GaPrx/T6NoF83PBD2sJAU8axpY/DJNuNmfyPL0k+YK99dj/KanCPPzfzTJZnQT
         RB8hjrkxWGe6I8rQOnlRzPGkiw4EaBQFC1oIljh9GhVyntlMld7MkyxKygxgHhfb7R
         dp+8KFkLQPh9Sd/85zeQtT3ANp3OU5S7kLqlXMFrzrOsphjqMVSVEJppiwANhL91n+
         4Y1s+wclBSDFuIvYYo++8MV5gE6Klkb/Dh57qDwdyWHbQDsYF9aYf6h4WntHSz4UOO
         96b03Kod2LHpKIIGYj8MKqYtp6rjcTUT+MSrfAoxkzGpei7tN0Kr7ekfM6JS0hBpWJ
         LFsh2kvg98k/Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1msOLp-0097Ab-OS; Wed, 01 Dec 2021 12:04:41 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, broonie@kernel.org,
        Zenghui Yu <yuzenghui@huawei.com>, kernel-team@android.com
Subject: [PATCH v3 3/6] KVM: arm64: Remove unused __sve_save_state
Date:   Wed,  1 Dec 2021 12:04:33 +0000
Message-Id: <20211201120436.389756-4-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211201120436.389756-1-maz@kernel.org>
References: <20211201120436.389756-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, qperret@google.com, will@kernel.org, broonie@kernel.org, yuzenghui@huawei.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that we don't have any users left for __sve_save_state, remove
it altogether. Should we ever need to save the SVE state from the
hypervisor again, we can always re-introduce it.

Suggested-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_hyp.h | 1 -
 arch/arm64/kvm/hyp/fpsimd.S      | 6 ------
 2 files changed, 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 5afd14ab15b9..462882f356c7 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -90,7 +90,6 @@ void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu);
 
 void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
 void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
-void __sve_save_state(void *sve_pffr, u32 *fpsr);
 void __sve_restore_state(void *sve_pffr, u32 *fpsr);
 
 #ifndef __KVM_NVHE_HYPERVISOR__
diff --git a/arch/arm64/kvm/hyp/fpsimd.S b/arch/arm64/kvm/hyp/fpsimd.S
index e950875e31ce..61e6f3ba7b7d 100644
--- a/arch/arm64/kvm/hyp/fpsimd.S
+++ b/arch/arm64/kvm/hyp/fpsimd.S
@@ -25,9 +25,3 @@ SYM_FUNC_START(__sve_restore_state)
 	sve_load 0, x1, x2, 3
 	ret
 SYM_FUNC_END(__sve_restore_state)
-
-SYM_FUNC_START(__sve_save_state)
-	mov	x2, #1
-	sve_save 0, x1, x2, 3
-	ret
-SYM_FUNC_END(__sve_save_state)
-- 
2.30.2

