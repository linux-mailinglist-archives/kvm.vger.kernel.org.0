Return-Path: <kvm+bounces-3710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C7F7D807436
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 16:59:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3EAB1B20E5D
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 15:59:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86A5445C0F;
	Wed,  6 Dec 2023 15:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="i4W4BKzw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2059.outbound.protection.outlook.com [40.107.237.59])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC233D46
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 07:59:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Grh6tpMUlgfX9Jy7d8sj70YkHCOD6Y3ijp/S9v/bB3wgdA/1+1BG8zhNIg/Jt5klDkFh1IYWFR2iU/A8xKFaZ5ChtGvqtXdrbh5HZ7t2wniW/smyEAko2gGFpurCiMzQ6i4b0QS2ZE0agYqm3mUljhIbhvs/1Gcaa/gZnurLhNnbfg4eigmb901zM0Y0qQxbMvibiTqaeyjVdfyLGxqmtgGtU+Wmj9u+Nssee+BiGBN+SeS5ZdwpMPbn+/cDAbLg95oIM2mLD9spSKAXSVlKeF5ObAjdkgTt1fzMY4M7SkAUjL8jJrMegfq32uRvMAQJziqUY5np78PHZPEdiXn2Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=80T7DJv+lZOjy9DTWu2VgFrUpT8q2+yxhOI0LNXDF8E=;
 b=ocqfp5DVCKSyFPi/MKB46+AOYhUkGK60CAwZDq76DTeINNKgp3Rk+pg9SW/JRYnMcOcElm5ZnjX+GucYNe2vMPFLNa+lzBI3uAU9Ct3cFjxHdT8e6cB5CBQHX9W/P3xHcJM+TPj7Aie0gmqRN8JF+CGyuD+qo/68NmrJAENU98e1VJf0DqNNJyE3Ka2IVRNVWJcu/Fkt0SMZW+sQkcV/oxpGSPlOJujl41KnXEv0t2t7BVlCCFulDAu0ZQMwCz8MTJtk+quY8/2mPiGdI6HIlAZ/u1csBDY/6Tbtd/SUB5x6kaoCtK39oZQG2VbH2tO8whQ3Pk8wjDqEZhlEteG6xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=80T7DJv+lZOjy9DTWu2VgFrUpT8q2+yxhOI0LNXDF8E=;
 b=i4W4BKzw8ONhtpBu3WT5lHr5MRa7a69MgIyR0jOu5YjPvz4EfzlDjQ42B5VPZqUafQL0tqW2qVeZSv7R22ATuJzJfyxoOlmBFArRmEKHFPIrPVk6jOsKWkt2j+Hu/ALsd/o+0hEZg+12Yw6VAWNtz+gMkMmk2RQZ1ad6+BH4Pjs=
Received: from SCZP152CA0010.LAMP152.PROD.OUTLOOK.COM (2603:10d6:300:53::7) by
 DM3PR12MB9433.namprd12.prod.outlook.com (2603:10b6:0:47::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.25; Wed, 6 Dec 2023 15:59:01 +0000
Received: from DS3PEPF000099D7.namprd04.prod.outlook.com
 (2603:10d6:300:53:cafe::53) by SCZP152CA0010.outlook.office365.com
 (2603:10d6:300:53::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.32 via Frontend
 Transport; Wed, 6 Dec 2023 15:58:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099D7.mail.protection.outlook.com (10.167.17.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7068.20 via Frontend Transport; Wed, 6 Dec 2023 15:58:59 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Wed, 6 Dec
 2023 09:58:58 -0600
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti
	<mtosatti@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>, Akihiko Odaki
	<akihiko.odaki@daynix.com>, =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Lara Lazier <laramglazier@gmail.com>, Vitaly Kuznetsov
	<vkuznets@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>,
	<kvm@vger.kernel.org>
Subject: [PATCH v3 for-8.2] i386/sev: Avoid SEV-ES crash due to missing MSR_EFER_LMA bit
Date: Wed, 6 Dec 2023 09:58:21 -0600
Message-ID: <20231206155821.1194551-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D7:EE_|DM3PR12MB9433:EE_
X-MS-Office365-Filtering-Correlation-Id: 79a83fa6-3f35-499c-e9c0-08dbf6744272
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	213xM9hF0vAyrr058KEslyxjfDgp4KGtsvhjowMW6HwXJZD5i3Uu0t8O55XtV7p7lWHg/UwIb3pfgjEgTWJF8xuRKyl9XDpPNCOo/kcsNwndJGJf0MkFAktAp93TR217sC6z5Tzmi6zwPY6zsHDvKlrnhGGH3CirBO1QyFMLfdFDpzfuEuu30J2qdm3SLUsP0DEKzJRlNe7XMruD/sLfsPAt+CMn9l9dUIhqfLyuX9PDiIB6oCK64OjS3iCdssc6dpI4hX/qW8z6MrwiIYose/H61anWEt6cK6uL9fa1SeiryBOV8LPK+TvPJjv2287lpAg6CSWdk1+8x4CMjWNWtnGCrkzcN8t6i1NSDZPBrOL+w9p1D/lbMgLecb/wWHcCVjCLC5NCiqvdodEC/2ml1bG5zrMV9rQGZplNAk24sfiWKEnPQYdI83hX6+kf559x9Ep1d7e/GPeSvFss38Jqhp9TrTODLM6rE/m+GX50RL+XgahmHJX+oOY62QN/LXm2W6bXsYKG05y46jMYpmZq6CV7Fk3qpAtMqbiX7npKDgiGiAJ13+kWkHNLNH5pTtSSNPcr2HuAnMb5ckelFb7etuQRMkosXXiPDgW7aLWmsUPLvi2ILrfx4V3xWaPGd3AaBxTsRRJ7FK37zFCB+vKYYfeOGmnp2DuAbY0RiPQH2dUKeyWTzO7ViPRuYittYX5jJraPxNVt826+n/aLoOoPgWzs+R6z7hDPk056CzGjp9ITWZ1LRqt9p0tGB2gp9YFCjO9M7C6VWj2n3YgWeUmcKw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(376002)(396003)(136003)(230922051799003)(186009)(82310400011)(64100799003)(451199024)(1800799012)(36840700001)(40470700004)(46966006)(70586007)(70206006)(36860700001)(356005)(83380400001)(82740400003)(426003)(336012)(16526019)(26005)(2616005)(1076003)(6666004)(478600001)(44832011)(316002)(6916009)(54906003)(86362001)(8676002)(4326008)(8936002)(5660300002)(2906002)(40480700001)(36756003)(41300700001)(47076005)(81166007)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 15:58:59.3742
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 79a83fa6-3f35-499c-e9c0-08dbf6744272
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D7.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9433

Commit 7191f24c7fcf ("accel/kvm/kvm-all: Handle register access errors")
added error checking for KVM_SET_SREGS/KVM_SET_SREGS2. In doing so, it
exposed a long-running bug in current KVM support for SEV-ES where the
kernel assumes that MSR_EFER_LMA will be set explicitly by the guest
kernel, in which case EFER write traps would result in KVM eventually
seeing MSR_EFER_LMA get set and recording it in such a way that it would
be subsequently visible when accessing it via KVM_GET_SREGS/etc.

However, guest kernels currently rely on MSR_EFER_LMA getting set
automatically when MSR_EFER_LME is set and paging is enabled via
CR0_PG_MASK. As a result, the EFER write traps don't actually expose the
MSR_EFER_LMA bit, even though it is set internally, and when QEMU
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
Cc: Philippe Mathieu-Daudé <philmd@linaro.org>
Cc: Lara Lazier <laramglazier@gmail.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org
Fixes: 7191f24c7fcf ("accel/kvm/kvm-all: Handle register access errors")
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 target/i386/kvm/kvm.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 11b8177eff..4ce80555b4 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3643,6 +3643,10 @@ static int kvm_get_sregs(X86CPU *cpu)
     env->cr[4] = sregs.cr4;
 
     env->efer = sregs.efer;
+    if (sev_es_enabled() && env->efer & MSR_EFER_LME &&
+        env->cr[0] & CR0_PG_MASK) {
+        env->efer |= MSR_EFER_LMA;
+    }
 
     /* changes to apic base and cr8/tpr are read back via kvm_arch_post_run */
     x86_update_hflags(env);
@@ -3682,6 +3686,10 @@ static int kvm_get_sregs2(X86CPU *cpu)
     env->cr[4] = sregs.cr4;
 
     env->efer = sregs.efer;
+    if (sev_es_enabled() && env->efer & MSR_EFER_LME &&
+        env->cr[0] & CR0_PG_MASK) {
+        env->efer |= MSR_EFER_LMA;
+    }
 
     env->pdptrs_valid = sregs.flags & KVM_SREGS2_FLAGS_PDPTRS_VALID;
 
-- 
2.25.1


