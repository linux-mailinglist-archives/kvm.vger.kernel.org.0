Return-Path: <kvm+bounces-5213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A36F481E09D
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 14:01:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 59F771F221FB
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 13:01:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDE2754BCF;
	Mon, 25 Dec 2023 12:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jEIOj0Et"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11AA5479F;
	Mon, 25 Dec 2023 12:59:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4605CC433C9;
	Mon, 25 Dec 2023 12:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703509181;
	bh=eTLon+HIxwFMbvdezleTBTpFzqzzZBcJdHF+vuZfDLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jEIOj0EtbPA5/QvSmWlPD9LzcwSuEHnkJ7E5jKdiCW2nsqGhk/EGY7sd4FOPjfkP5
	 W/DR9oFO2xUVZkLvoqISc4EgWMebHjhg+n2mVezvN0uwdYFGB2PfZfyzTZkdFB7Xgf
	 1HZyxM3+DuKCy8Euzc/wQ4gKAAo/5vsWey1tgNeyuWAm2JJ7h79rTe2F/QjR4+n9VA
	 Zn9obPY4be/cIIcaaPFNAQPbhy6JH50OVLJucvd1nrTPXjmoPiN0bXCH9dcrhv2cVY
	 QN2+sBLHZ6/N1gItlVGl9rfs3klk5J98L2+e+Sz45Nk81pHAUi/WnBTggDjs/D562M
	 Yr5IemZ/2vcWw==
From: guoren@kernel.org
To: paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	guoren@kernel.org,
	panqinglin2020@iscas.ac.cn,
	bjorn@rivosinc.com,
	conor.dooley@microchip.com,
	leobras@redhat.com,
	peterz@infradead.org,
	anup@brainfault.org,
	keescook@chromium.org,
	wuwei2016@iscas.ac.cn,
	xiaoguang.xing@sophgo.com,
	chao.wei@sophgo.com,
	unicorn_wang@outlook.com,
	uwu@icenowy.me,
	jszhang@kernel.org,
	wefu@redhat.com,
	atishp@atishpatra.org
Cc: linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	Guo Ren <guoren@linux.alibaba.com>
Subject: [PATCH V12 08/14] riscv: qspinlock: Force virt_spin_lock for KVM guests
Date: Mon, 25 Dec 2023 07:58:41 -0500
Message-Id: <20231225125847.2778638-9-guoren@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231225125847.2778638-1-guoren@kernel.org>
References: <20231225125847.2778638-1-guoren@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guo Ren <guoren@linux.alibaba.com>

Force to enable virt_spin_lock when KVM guest, because fair locks
have horrible lock 'holder' preemption issues.

Suggested-by: Leonardo Bras <leobras@redhat.com>
Link: https://lkml.kernel.org/kvm/ZQK9-tn2MepXlY1u@redhat.com/
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
---
 arch/riscv/include/asm/sbi.h | 8 ++++++++
 arch/riscv/kernel/sbi.c      | 2 +-
 arch/riscv/kernel/setup.c    | 6 +++++-
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index 0892f4421bc4..8f748d9e1b85 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -51,6 +51,13 @@ enum sbi_ext_base_fid {
 	SBI_EXT_BASE_GET_MIMPID,
 };
 
+enum sbi_ext_base_impl_id {
+	SBI_EXT_BASE_IMPL_ID_BBL = 0,
+	SBI_EXT_BASE_IMPL_ID_OPENSBI,
+	SBI_EXT_BASE_IMPL_ID_XVISOR,
+	SBI_EXT_BASE_IMPL_ID_KVM,
+};
+
 enum sbi_ext_time_fid {
 	SBI_EXT_TIME_SET_TIMER = 0,
 };
@@ -276,6 +283,7 @@ int sbi_console_getchar(void);
 long sbi_get_mvendorid(void);
 long sbi_get_marchid(void);
 long sbi_get_mimpid(void);
+long sbi_get_firmware_id(void);
 void sbi_set_timer(uint64_t stime_value);
 void sbi_shutdown(void);
 void sbi_send_ipi(unsigned int cpu);
diff --git a/arch/riscv/kernel/sbi.c b/arch/riscv/kernel/sbi.c
index 5a62ed1da453..4330aedf65fd 100644
--- a/arch/riscv/kernel/sbi.c
+++ b/arch/riscv/kernel/sbi.c
@@ -543,7 +543,7 @@ static inline long sbi_get_spec_version(void)
 	return __sbi_base_ecall(SBI_EXT_BASE_GET_SPEC_VERSION);
 }
 
-static inline long sbi_get_firmware_id(void)
+long sbi_get_firmware_id(void)
 {
 	return __sbi_base_ecall(SBI_EXT_BASE_GET_IMP_ID);
 }
diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index 0bafb9fd6ea3..e33430e9d97e 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -281,6 +281,9 @@ DEFINE_STATIC_KEY_TRUE(virt_spin_lock_key);
 
 static void __init virt_spin_lock_init(void)
 {
+	if (sbi_get_firmware_id() != SBI_EXT_BASE_IMPL_ID_KVM)
+		no_virt_spin = true;
+
 	if (no_virt_spin)
 		static_branch_disable(&virt_spin_lock_key);
 	else
@@ -290,7 +293,8 @@ static void __init virt_spin_lock_init(void)
 
 static void __init riscv_spinlock_init(void)
 {
-	if (!enable_qspinlock) {
+	if ((!enable_qspinlock) &&
+	    (sbi_get_firmware_id() != SBI_EXT_BASE_IMPL_ID_KVM)) {
 		static_branch_disable(&combo_qspinlock_key);
 		pr_info("Ticket spinlock: enabled\n");
 	} else {
-- 
2.40.1


