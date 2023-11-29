Return-Path: <kvm+bounces-2738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F1D247FD04E
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 09:04:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2D480B2168C
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 08:04:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5336611C91;
	Wed, 29 Nov 2023 08:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
X-Greylist: delayed 282 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 29 Nov 2023 00:04:18 PST
Received: from bg1.exmail.qq.com (bg1.exmail.qq.com [114.132.233.22])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E93710F0;
	Wed, 29 Nov 2023 00:04:17 -0800 (PST)
X-QQ-mid: bizesmtp64t1701244736ta8gixpe
Received: from HX01040049.powercore.com.cn ( [125.94.202.196])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 29 Nov 2023 15:58:49 +0800 (CST)
X-QQ-SSF: 01400000000000708000000A0000000
X-QQ-FEAT: gBprNiU+WNeRCxd1mFC0ek6Tr9pLWM0mTZ8midTMAGSwDIo4FTOPE7P8jVK5u
	+jS+f0RV5CzN/+0yORbfyySXnusFmiK22mABedLLcYzyGgYY1frZEeKnDSQl8zoRdx90QJy
	G/zOe6wfeheY/JSBeS+SmYGCxZbkSJiYeEiOkibXu9AaKfnYNSd1J1SqscQdVLaFoTCA9zN
	9atgjRdl4GsXTkWfml6gExxq80YpEp/8gdZoGjwNktkdkCZumWt9uN3nEUQR7BV4w2x6Jh/
	mf0OcdUJoF4M7awpTHrY26mXg61djVAzY/+1VZVZq0WhonU6SAilF4v3uT/9rDfTcR/FFNy
	HF+Gvi4Z452yTWE5KoCxtLfp6j8ZTNwd9Qc0tkxi3r0bu7Gwd66E2IHEsFZsHIUX9Dd6g+2
	Xiks/CqNkxmvGl6iz5vOGnr6Rlpn7cwC
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 3565711899021422489
From: Zhao Ke <ke.zhao@shingroup.cn>
To: mpe@ellerman.id.au,
	npiggin@gmail.com,
	christophe.leroy@csgroup.eu,
	fbarrat@linux.ibm.com,
	ajd@linux.ibm.com,
	arnd@arndb.de,
	gregkh@linuxfoundation.org
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	shenghui.qu@shingroup.cn,
	luming.yu@shingroup.cn,
	dawei.li@shingroup.cn,
	Zhao Ke <ke.zhao@shingroup.cn>
Subject: [PATCH v2] powerpc: Add PVN support for HeXin C2000 processor
Date: Wed, 29 Nov 2023 15:58:45 +0800
Message-Id: <20231129075845.57976-1-ke.zhao@shingroup.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:shingroup.cn:qybglogicsvrsz:qybglogicsvrsz3a-0

HeXin Tech Co. has applied for a new PVN from the OpenPower Community
for its new processor C2000. The OpenPower has assigned a new PVN
and this newly assigned PVN is 0x0066, add pvr register related
support for this PVN.

Signed-off-by: Zhao Ke <ke.zhao@shingroup.cn>
Link: https://discuss.openpower.foundation/t/how-to-get-a-new-pvr-for-processors-follow-power-isa/477/10
---
	v1 -> v2:
	- Fix pvr_mask and cpu_name
	- Fix alignment pattern to match other lines
	v0 -> v1:
	- Fix .cpu_name with the correct description
---
---
 arch/powerpc/include/asm/reg.h            |  1 +
 arch/powerpc/kernel/cpu_specs_book3s_64.h | 15 +++++++++++++++
 arch/powerpc/kvm/book3s_pr.c              |  1 +
 arch/powerpc/mm/book3s64/pkeys.c          |  3 ++-
 arch/powerpc/platforms/powernv/subcore.c  |  3 ++-
 drivers/misc/cxl/cxl.h                    |  3 ++-
 6 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
index 4ae4ab9090a2..7fd09f25452d 100644
--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -1361,6 +1361,7 @@
 #define PVR_POWER8E	0x004B
 #define PVR_POWER8NVL	0x004C
 #define PVR_POWER8	0x004D
+#define PVR_HX_C2000	0x0066
 #define PVR_POWER9	0x004E
 #define PVR_POWER10	0x0080
 #define PVR_BE		0x0070
diff --git a/arch/powerpc/kernel/cpu_specs_book3s_64.h b/arch/powerpc/kernel/cpu_specs_book3s_64.h
index c370c1b804a9..3ff9757df4c0 100644
--- a/arch/powerpc/kernel/cpu_specs_book3s_64.h
+++ b/arch/powerpc/kernel/cpu_specs_book3s_64.h
@@ -238,6 +238,21 @@ static struct cpu_spec cpu_specs[] __initdata = {
 		.machine_check_early	= __machine_check_early_realmode_p8,
 		.platform		= "power8",
 	},
+	{	/* 2.07-compliant processor, HeXin C2000 processor */
+		.pvr_mask		= 0xffff0000,
+		.pvr_value		= 0x00660000,
+		.cpu_name		= "HX-C2000",
+		.cpu_features		= CPU_FTRS_POWER8,
+		.cpu_user_features	= COMMON_USER_POWER8,
+		.cpu_user_features2	= COMMON_USER2_POWER8,
+		.mmu_features		= MMU_FTRS_POWER8,
+		.icache_bsize		= 128,
+		.dcache_bsize		= 128,
+		.cpu_setup		= __setup_cpu_power8,
+		.cpu_restore		= __restore_cpu_power8,
+		.machine_check_early	= __machine_check_early_realmode_p8,
+		.platform		= "power8",
+	},
 	{	/* 3.00-compliant processor, i.e. Power9 "architected" mode */
 		.pvr_mask		= 0xffffffff,
 		.pvr_value		= 0x0f000005,
diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 9118242063fb..5b92619a05fd 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -604,6 +604,7 @@ static void kvmppc_set_pvr_pr(struct kvm_vcpu *vcpu, u32 pvr)
 	case PVR_POWER8:
 	case PVR_POWER8E:
 	case PVR_POWER8NVL:
+	case PVR_HX_C2000:
 	case PVR_POWER9:
 		vcpu->arch.hflags |= BOOK3S_HFLAG_MULTI_PGSIZE |
 			BOOK3S_HFLAG_NEW_TLBIE;
diff --git a/arch/powerpc/mm/book3s64/pkeys.c b/arch/powerpc/mm/book3s64/pkeys.c
index 125733962033..a974baf8f327 100644
--- a/arch/powerpc/mm/book3s64/pkeys.c
+++ b/arch/powerpc/mm/book3s64/pkeys.c
@@ -89,7 +89,8 @@ static int __init scan_pkey_feature(void)
 			unsigned long pvr = mfspr(SPRN_PVR);
 
 			if (PVR_VER(pvr) == PVR_POWER8 || PVR_VER(pvr) == PVR_POWER8E ||
-			    PVR_VER(pvr) == PVR_POWER8NVL || PVR_VER(pvr) == PVR_POWER9)
+			    PVR_VER(pvr) == PVR_POWER8NVL || PVR_VER(pvr) == PVR_POWER9 ||
+			    PVR_VER(pvr) == PVR_HX_C2000)
 				pkeys_total = 32;
 		}
 	}
diff --git a/arch/powerpc/platforms/powernv/subcore.c b/arch/powerpc/platforms/powernv/subcore.c
index 191424468f10..393e747541fb 100644
--- a/arch/powerpc/platforms/powernv/subcore.c
+++ b/arch/powerpc/platforms/powernv/subcore.c
@@ -425,7 +425,8 @@ static int subcore_init(void)
 
 	if (pvr_ver != PVR_POWER8 &&
 	    pvr_ver != PVR_POWER8E &&
-	    pvr_ver != PVR_POWER8NVL)
+	    pvr_ver != PVR_POWER8NVL &&
+	    pvr_ver != PVR_HX_C2000)
 		return 0;
 
 	/*
diff --git a/drivers/misc/cxl/cxl.h b/drivers/misc/cxl/cxl.h
index 0562071cdd4a..6ad0ab892675 100644
--- a/drivers/misc/cxl/cxl.h
+++ b/drivers/misc/cxl/cxl.h
@@ -836,7 +836,8 @@ static inline bool cxl_is_power8(void)
 {
 	if ((pvr_version_is(PVR_POWER8E)) ||
 	    (pvr_version_is(PVR_POWER8NVL)) ||
-	    (pvr_version_is(PVR_POWER8)))
+	    (pvr_version_is(PVR_POWER8)) ||
+	    (pvr_version_is(PVR_HX_C2000)))
 		return true;
 	return false;
 }
-- 
2.34.1

