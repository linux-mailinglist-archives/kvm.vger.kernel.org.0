Return-Path: <kvm+bounces-3640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABBB38061AD
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 23:29:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CEBDF1C21095
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 22:29:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8316C6EB4D;
	Tue,  5 Dec 2023 22:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mxi/hiPv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2051.outbound.protection.outlook.com [40.107.237.51])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6319E1A5
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 14:28:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SPXjF7IQ5n2YZ5Bs/CFyK2d8TpoNr9JvvFnEqeggj6xWWKoEYybzL/EL+Uh5282SGW/3BhcCV0Qbih3Bap2L3cc6/Hy/t/MXrRIN8SaGsrI3uKM4dIRiWa5bDQnTKjzKYQuOBIofVHjM89hdF9zN+smG4GfBH6a4fUR1ldzM80Ye7Z5gMG9dRO+qlEiwMt8mP31JS8cJiBh4mYnsvDWfgi8gB3gMUdU0un7+Cea/xJHiM6dM8CziFOaVWCEBo9dTT8C3OvfT3hMY4ZV7spniqcUweogaX+uU5DJBvJbmqoNnBaSZzNwbtZ59bxH1mO8L7L6ZFQ9IekDBunsCPwEKOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T/Pj+kgHtUV4ZrZ3URY/U4pJ9dgcilvNFGA0IShckSI=;
 b=CVGPJZWQgL+niK5L5gcAbIWDal+0jsAf4DY2k2/2XBg4mWL6yMXU6CeRrr32SwjvCSiib+CP0qqTMzWBX5/NLHJB13K1eM3sByiqfjg02/cd/24RpEUh+MKniGd/bDh02cgipe8HJdCLXkDbPvYy/WZpEu96dLYQu5oSK2nnRydB1uK7/wEgx9E7UMxXu52IPl5u3vIe3kvwGQDxz6VM3xZyPLr9bFAOhkgNrLzpB9dwMI0322QgBIt/QQkeOFS/KtSRuNY9P8j/FPlOpYzB6opTPmysqhzq+N4tADgH8Krb1xyYsJjCk7R7SYL48uFpydSp+Y+riR7bYfJsAhS4aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T/Pj+kgHtUV4ZrZ3URY/U4pJ9dgcilvNFGA0IShckSI=;
 b=mxi/hiPvP29prAQFPESdTKrbl1FmC3ImU3VULAFbK2NLFM8A1haBPigoRaLRuG9fOgAfFJzNtglDiKAHicv7HxTR3QSjWVfhQZE9uQ9/hOJ2A4KhZc3bplb3J4ldtR0Y0RrMqekXmlngU5ITm28bi8mMijieH7MzswgTnAZHt+Y=
Received: from DM6PR12CA0024.namprd12.prod.outlook.com (2603:10b6:5:1c0::37)
 by IA1PR12MB6483.namprd12.prod.outlook.com (2603:10b6:208:3a8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 22:28:50 +0000
Received: from CY4PEPF0000FCC3.namprd03.prod.outlook.com
 (2603:10b6:5:1c0:cafe::a0) by DM6PR12CA0024.outlook.office365.com
 (2603:10b6:5:1c0::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34 via Frontend
 Transport; Tue, 5 Dec 2023 22:28:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCC3.mail.protection.outlook.com (10.167.242.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7068.20 via Frontend Transport; Tue, 5 Dec 2023 22:28:49 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Tue, 5 Dec
 2023 16:28:48 -0600
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti
	<mtosatti@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>, Akihiko Odaki
	<akihiko.odaki@daynix.com>, <kvm@vger.kernel.org>
Subject: [PATCH v2 for-8.2?] i386/sev: Avoid SEV-ES crash due to missing MSR_EFER_LMA bit
Date: Tue, 5 Dec 2023 16:28:16 -0600
Message-ID: <20231205222816.1152720-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC3:EE_|IA1PR12MB6483:EE_
X-MS-Office365-Filtering-Correlation-Id: e39938e1-3f89-4fe3-73a6-08dbf5e18da4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	MfqHVaOcO2GRjk1MzzjmR/xSycNBSy/AxPBXKcdZ/aqk3wTeB215hadanjNV1kPXN3aP8+Xo+XmFn0e1iErYxGfCiwIQYQiSh18oYBMDknuCzQTCozbnAnQQ8YldSbPWqgmiHWZcKsdu2Vz3DpgCLBahhvB7qCflpXI6kdMR3+45D4f7SoTKXsfYbeRaM+hLtQjGJF/dj9LQ7PTnFHu/oBKNzYYRlgvRV3xOKlACycrvR4RxVMB4YF8XpnJ66Oo7270vqXzeryks8GbkoOEa1R78Mcl6V6hJHUPYpwDgBkDWC7LthAjN5MV4ZgHVsz7uJ8y8jf0fZQhXndeNSqQmPvr8NBW3we4MFK/SR8Xq7JAq0vp+r30UTMVW4aATTO89xHVwZW88N8D3tQtqdfZNDoaH2SpS5zFqrZ1xm+0PXzrKZFGWJe+ZkcKE6alL0MtDrjA8+b3HbRJhL/i4txOP9I/MWYxU6Tkn+TkZoY6qFU7Q+DnAbfr5RBnUKdq9AQgQRMbQrZsD9bSLligBKweTiZ+oPcFNRrufykczAjrbo/+aft8OnhXeCXivcESBR9+AqXj53Zq4guylFVaTIMfkM4s5OCSOk1IlfjcYBz+0jqyS4mM6KmonYg0sRgZAgMXxE18w2/klSJMxvVOqawYIzPFChJA03qUC8BCmcIVFLl2rTFpFo20U/mJ9rEhQmddHT50bGQpOorWXRM/Fe6Xh52foTL0cYWvSAK4X7fQaj5m6M1iqIrEM1kRF1hnRXI4Dzj/xPPQl3nuqwoEC5/eWPA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(346002)(136003)(39860400002)(230922051799003)(451199024)(1800799012)(186009)(82310400011)(64100799003)(46966006)(36840700001)(40470700004)(40460700003)(426003)(83380400001)(478600001)(2616005)(26005)(16526019)(336012)(6666004)(1076003)(316002)(54906003)(6916009)(86362001)(8676002)(4326008)(8936002)(41300700001)(70206006)(70586007)(36756003)(36860700001)(40480700001)(2906002)(44832011)(5660300002)(82740400003)(81166007)(356005)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 22:28:49.4150
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e39938e1-3f89-4fe3-73a6-08dbf5e18da4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6483

Commit 7191f24c7fcf ("accel/kvm/kvm-all: Handle register access errors")
added error checking for KVM_SET_SREGS/KVM_SET_SREGS2. In doing so, it
exposed a long-running bug in current KVM support for SEV-ES where the
kernel assumes that MSR_EFER_LMA will be set explicitly by the guest
kernel, in which case EFER write traps would result in KVM eventually
seeing MSR_EFER_LMA get set and recording it in such a way that it would
be subsequently visible when accessing it via KVM_GET_SREGS/etc.

However, guests kernels currently rely on MSR_EFER_LMA getting set
automatically when MSR_EFER_LME is set and paging is enabled via
CR0_PG_MASK. As a result, the EFER write traps don't actually expose the
MSR_EFER_LMA even though it is set internally, and when QEMU
subsequently tries to pass this EFER value back to KVM via
KVM_SET_SREGS* it will fail various sanity checks and return -EINVAL,
which is now considered fatal due to the aforementioned QEMU commit.

This can be addressed by inferring the MSR_EFER_LMA bit being set when
paging is enabled and MSR_EFER_LME is set, and synthesizing it to ensure
the expected bits are all present in subsequent handling on the host
side.

Ultimately, this handling will be implemented in the host kernel, but to
avoid breaking QEMU's SEV-ES support when using older host kernels, the
same handling can be done in QEMU just after fetching the register
values via KVM_GET_SREGS*. Implement that here.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: kvm@vger.kernel.org
Fixes: 7191f24c7fcf ("accel/kvm/kvm-all: Handle register access errors")
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
v2:
  - Add handling for KVM_GET_SREGS, not just KVM_GET_SREGS2

 target/i386/kvm/kvm.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 11b8177eff..8721c1bf8f 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3610,6 +3610,7 @@ static int kvm_get_sregs(X86CPU *cpu)
 {
     CPUX86State *env = &cpu->env;
     struct kvm_sregs sregs;
+    target_ulong cr0_old;
     int ret;
 
     ret = kvm_vcpu_ioctl(CPU(cpu), KVM_GET_SREGS, &sregs);
@@ -3637,12 +3638,18 @@ static int kvm_get_sregs(X86CPU *cpu)
     env->gdt.limit = sregs.gdt.limit;
     env->gdt.base = sregs.gdt.base;
 
+    cr0_old = env->cr[0];
     env->cr[0] = sregs.cr0;
     env->cr[2] = sregs.cr2;
     env->cr[3] = sregs.cr3;
     env->cr[4] = sregs.cr4;
 
     env->efer = sregs.efer;
+    if (sev_es_enabled() && env->efer & MSR_EFER_LME) {
+        if (!(cr0_old & CR0_PG_MASK) && env->cr[0] & CR0_PG_MASK) {
+            env->efer |= MSR_EFER_LMA;
+        }
+    }
 
     /* changes to apic base and cr8/tpr are read back via kvm_arch_post_run */
     x86_update_hflags(env);
@@ -3654,6 +3661,7 @@ static int kvm_get_sregs2(X86CPU *cpu)
 {
     CPUX86State *env = &cpu->env;
     struct kvm_sregs2 sregs;
+    target_ulong cr0_old;
     int i, ret;
 
     ret = kvm_vcpu_ioctl(CPU(cpu), KVM_GET_SREGS2, &sregs);
@@ -3676,12 +3684,18 @@ static int kvm_get_sregs2(X86CPU *cpu)
     env->gdt.limit = sregs.gdt.limit;
     env->gdt.base = sregs.gdt.base;
 
+    cr0_old = env->cr[0];
     env->cr[0] = sregs.cr0;
     env->cr[2] = sregs.cr2;
     env->cr[3] = sregs.cr3;
     env->cr[4] = sregs.cr4;
 
     env->efer = sregs.efer;
+    if (sev_es_enabled() && env->efer & MSR_EFER_LME) {
+        if (!(cr0_old & CR0_PG_MASK) && env->cr[0] & CR0_PG_MASK) {
+            env->efer |= MSR_EFER_LMA;
+        }
+    }
 
     env->pdptrs_valid = sregs.flags & KVM_SREGS2_FLAGS_PDPTRS_VALID;
 
-- 
2.25.1


