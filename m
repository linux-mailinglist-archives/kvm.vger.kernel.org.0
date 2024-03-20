Return-Path: <kvm+bounces-12230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B9A3880D5F
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:45:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1001B281E5F
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:45:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F3D8383B5;
	Wed, 20 Mar 2024 08:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tPW2cThE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2084.outbound.protection.outlook.com [40.107.243.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF6E364D4
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924303; cv=fail; b=WcYrHA/qwwg1a0rfpJkr5ipfw0Fgg84dB11K6XkBudNkAvZvZ4J9u+0jEZWn+KcK8rnkwpbAl+4MLMyVjl9p9DX7BXIbF6CZlrGtkgsngb8iP2JeXC7A5n5YrQoG2X25ftkL8ywgFeLRFVgErehBA629xHjd5zfr1tna3GjdZqU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924303; c=relaxed/simple;
	bh=KDTnfeophUzFWXCGgm3ynfxcj1RCR2IIHE5JrvBoM58=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tlTgYFKFDYycf7x+Hbff6hJ8tgl4iLxyQWJ21dFHZ4NFRZg4Joq40iZ3DnM9X2AywFTdWS843qlBljdSRqxmV/8AGkSAfutKIY08P6dtjeYuaVs5CZLOCgDQjO6CDy6UobjnYSMsk+DaoV012hRd9WD5V6MtI+wP0KobsK0Br8A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tPW2cThE; arc=fail smtp.client-ip=40.107.243.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hJESJWdGMq/esKu3BGmh2jUktOOffKW4lzL9l9WFoz8Wu7CuFQiTXqmFnFL7hnf53pcU0BysIguLwr7qWnqFYcg5wPwzHn/vNhma/Z5yOb0oDEiVuF5ufjUcCAJDqa+HHS+7EYupThxgiStnXvUdNNAfBftj0YB+HbUG8cCl0fJlXYxyOW8Hy7siNzgh2/k3yD37tIRxVtyIX+vGKxNGYYBrmGGAH29Gmkvjp0rjsJycN9fv78+ETpHTRrNxj0Vhz7Nu6vUd+R86kWfAZEHPzWU3t+dK9uICSS/QpC/qYJdV93a5ZS1m+iW3o45dTW0ozPHJix3bGPz055sMj2Vd4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BpZ+SqVKQVLU/VQrnrSoqvpAcIU0Juoe+lQqz7DfMFI=;
 b=Or+tfC3zbUfDEy/p+O3vqA8tAG5E/ER89onh26VVHGd2kfWn6q4AyNRPjl8eq9/83fOJCh3W71osgaitjQKStkNXkFenuWZAkl/minZyrjLFanf0eCYP7XWPdHzdetQnfwqHxLWgSNg1pvmFIn00ZSwniu4IRIfcst+iI44hyQaQgk67pSrfnGUE/LudKSRABGLcN92TjMKLy/k2k7k1rw1wwO06sl1Ngh8XsplvLfwV3a9GDYWdSL3xI+XVEqLDrtOQ/it4PZMfpaigP6Yde3vc+ukmY1IhLoaEw3JMcAMD5eoI/bWHCEyoAjonC8ldDsicRqkAioyTPTXGfWhGpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BpZ+SqVKQVLU/VQrnrSoqvpAcIU0Juoe+lQqz7DfMFI=;
 b=tPW2cThE8+K6BPat/aEEA8ubqWD2lIZqyFGRWM6HBBotfbC1CrwRziZX1wDXlL67qk79BGSyvvzjFa80pyvAL3wG06EevB7QFv33oEjrxL07yRfFLXBqY0yQBP0ygDliWSuZI1E/g4TVqbeQxSzmuVrLuV+NZ1hkyeQaHhB5E9k=
Received: from MW4PR04CA0059.namprd04.prod.outlook.com (2603:10b6:303:6a::34)
 by SA1PR12MB8161.namprd12.prod.outlook.com (2603:10b6:806:330::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.27; Wed, 20 Mar
 2024 08:44:59 +0000
Received: from MWH0EPF000A672E.namprd04.prod.outlook.com
 (2603:10b6:303:6a:cafe::a) by MW4PR04CA0059.outlook.office365.com
 (2603:10b6:303:6a::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.28 via Frontend
 Transport; Wed, 20 Mar 2024 08:44:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A672E.mail.protection.outlook.com (10.167.249.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:44:59 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:44:58 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: [PATCH v3 19/49] kvm: Make kvm_convert_memory() obey ram_block_discard_is_enabled()
Date: Wed, 20 Mar 2024 03:39:15 -0500
Message-ID: <20240320083945.991426-20-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240320083945.991426-1-michael.roth@amd.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A672E:EE_|SA1PR12MB8161:EE_
X-MS-Office365-Filtering-Correlation-Id: 1af5f33d-1b74-4826-a053-08dc48ba06c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	KShVnZL+BhTW3k38A/fuHCan76XqbbIFxYYGcF2y3udhKw+eVFQ8ZuSFveUqRSrvC1AmFc0Tb1JdF7EImmd/vOKMukr5HL5d7LmVWIj39zlu97P+OodwOyHpv0Ucl9lu2Tb4fQeAlfL8SrTtpQnLM0D1I5Ut8z6/U0QK0A+iaC5zCDrAHqk+Lo4BCtIdGgIrCrOtlDOxjAvTjBiPfaqkTi1Qhfbtf5JRM6PqehX/UKr73iYksB3ubmgooay6nr/1LQaI5chL6UPyXvv9MgQuIx9Iu1vApCGxltyoqiOseVCMRW7uI4AIyMH7MmSuFQV58GIPycj5Nk+CA1YORlnAwBO2aPdoa6p7Idwv6XP3kDfuC+Ht8eCWKXvXIx5Prj310Ti/Zv/1L6vbuSUBxNlbCnxpmkxdCJk4jFFcWnaFEmJ4mbtV97Iv/wuNR37ZiQGxpCeXMZRQerdzARCKa4FyxQVlgvldeEhFCuIIAmgHwhyRgqEWJL/7G24/m1yOxaAJ2+xtKi7O5LkML339xdjweNNgPajX9y/DsyIRxZMLDOsMo9XtW7/Ozqrmqazrj0+hC2aFKP0bMKtLKKiPuKKo0mNvbeWMjiKe/Uixa6UACJe54JB6qaPA3aRd8kuCHEzkKllCnLS1fVXwdlWNvc6S/E4tN6XMmzp5X8xJIzQ2bdB7VEmcxx4GSDz2sxLYveukjQ/MkX31CiPgLXIAYq7rLPwXOhME6tLSbITVliIkIlw8xJbQ2DOSpA1Lcoyn9hlG
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(36860700004)(376005)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:44:59.2740
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1af5f33d-1b74-4826-a053-08dc48ba06c2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A672E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8161

Some subsystems like VFIO might disable ram block discard for
uncoordinated cases. Since kvm_convert_memory()/guest_memfd don't
implement a RamDiscardManager handler to convey discard operations to
various listeners like VFIO. Because of this, sequences like the
following can result due to stale IOMMU mappings:

  - convert page shared->private
  - discard shared page
  - convert page private->shared
  - new page is allocated
  - issue DMA operations against that shared page

Address this by taking ram_block_discard_is_enabled() into account when
deciding whether or not to discard pages.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 accel/kvm/kvm-all.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 53ce4f091e..6ae03c880f 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2962,10 +2962,14 @@ static int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
                 */
                 return 0;
             } else {
-                ret = ram_block_discard_range(rb, offset, size);
+                ret = ram_block_discard_is_disabled()
+                      ? ram_block_discard_range(rb, offset, size)
+                      : 0;
             }
         } else {
-            ret = ram_block_discard_guest_memfd_range(rb, offset, size);
+            ret = ram_block_discard_is_disabled()
+                  ? ram_block_discard_guest_memfd_range(rb, offset, size)
+                  : 0;
         }
     } else {
         error_report("Convert non guest_memfd backed memory region "
-- 
2.25.1


