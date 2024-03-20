Return-Path: <kvm+bounces-12243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B2EAC880DC1
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:51:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 683E328254D
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:51:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 877443FBBA;
	Wed, 20 Mar 2024 08:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="o/3GESvW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2048.outbound.protection.outlook.com [40.107.244.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299A43FB8C
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924576; cv=fail; b=uG3tOotQcdACkDEdtqt1NhG9j8EwNrTGTCWslvfANyZj1TtBJex2Nb4K/Pq6wJMpwfonDiEfIHFiYDP+gvSgmj5//3Ma85IH/vQVXR/SCOJG8RH5h698So2X7sW5dQfHlRblyUOsdpMx1bNWZesR7agkV5xv94GvJqNwQ82Rr5Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924576; c=relaxed/simple;
	bh=JbKIZNCFji6bUoY1Bplz+Ud2PiZ2uUfUoe3/UlARVY4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fu/TRL0x7w6leoJyTsCvB9ICupGXfWlfHkYcBEfHzMcZphmha8DGUMajizDsSncjp3Zf8dl7qVfw77oGOFNQdBIFGIiG7HhR2KjMKqneYPCJPP6fWR7z/0C6UvyziYNscAqDmAo8dVzVodUaiL2fF6tfbvgwA4FGGIuomt6ODmg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=o/3GESvW; arc=fail smtp.client-ip=40.107.244.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VVWEhtm4m5nCSSeXafvrAChoIc1uFxtMkrJhL0GNww2ngsnqEnZUCeskJsun1HXBOoKKLb+mwjcz3myWw7HyakBXGC5Mmg6DBj5Gp6JrflCaTElydr1O8Gu7TSalgiEV1UbVEU/nuFGlbTlH8twRMpZRVRB9Jb3xbr+H9U56H5So+omtYEj9x8fwT+upzu93a1pukVINhn2ZgIY8TJf4S7yPsX9jp9A/k4kSNtFjjjj3juYxPz1fUEWiIMhhJkRE4XwwQbMfZh0S1+HX72NLO11aJw+g2bZV3tTil6ez38qzSo8axehv8jVAOnIytEmJpHRCfJNmNiEZriSua5Cw9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b08MNWU7OrrmNusRruYlxEmAMS6k924e9RrUDzPgRzk=;
 b=IBvGn8dJZU2GYnZ5xPneCFbdRQXfjo4zTY/4nDnvWdP3wER40UzBigoX4S4pLWcV3VYp1+tPZkQ8xEsl31OVzWEsw97TucO2s/MZhLU8b9otVblO6+S+FBuInctfpsPZhUpv5v2fhYqn/gllCzWt3Bsz/FEN4Ivuo8HcsqTraq2J0++gnKAJl9YxsMJ8xUCuj6+RpP1I38uGkcDs4ICrf3zH7H0E72LhPRbztUfLqdxmcygdhHW/lj+Cdrec8Nl0eZPz6L4Fi44FHkRq/Sos8HPoOUCmLrIdX++oK8KpWvCKf3oE0npdfCmPsuNE7cWy/i4JHSPhdYfPiSBdv9iHRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b08MNWU7OrrmNusRruYlxEmAMS6k924e9RrUDzPgRzk=;
 b=o/3GESvWmUckWn2rdw4b4QUmnGFBMqYMc8teLMemCyGRK4OunBfoN4h+O8LNd1T0Qu1+cI/urqXdXBPeGEfHL2vOoP+xOC7xPrE0yYGQ+RyfxLO290Isdfad/6JN6lDDKbydQiFseVkECbP8Sj0nFLikrzvbL6CrQ4C9FycyxYA=
Received: from BN8PR12CA0009.namprd12.prod.outlook.com (2603:10b6:408:60::22)
 by SA3PR12MB7973.namprd12.prod.outlook.com (2603:10b6:806:305::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.27; Wed, 20 Mar
 2024 08:49:32 +0000
Received: from BN1PEPF00004681.namprd03.prod.outlook.com
 (2603:10b6:408:60:cafe::df) by BN8PR12CA0009.outlook.office365.com
 (2603:10b6:408:60::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.27 via Frontend
 Transport; Wed, 20 Mar 2024 08:49:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00004681.mail.protection.outlook.com (10.167.243.87) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:49:31 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:49:31 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: [PATCH v3 02/49] scripts/update-linux-headers: Add setup_data.h to import list
Date: Wed, 20 Mar 2024 03:38:58 -0500
Message-ID: <20240320083945.991426-3-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004681:EE_|SA3PR12MB7973:EE_
X-MS-Office365-Filtering-Correlation-Id: e10b0ae5-ccb6-4927-bc4b-08dc48baa90f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	MFTH7275d6c3qTC3ZT0MXxx6mFC0dpLLak0mD6uuR3r6Bp5ELDLENSTtdOR2w7+Ikc6FB2UywP3u5+tSXBP6vcmg9Jnq4UxIvu6SU3i/4ZKgKIxu6Zt5VAbqOFFouO0RgH0614SzsqVtWJh0ind07QTaZMskCX0YhrRtkOI+cSASSxQbWJW3OwFDdL0+DP2f/Yngeu5FCNWEZuDZkLWSYTYRCfteMYKXFObADiBl2ssEOyW1dk3f25QXW8rnTPten4/b7XouenDNweP5sMQISPpGCWE95/RlKrFLCi+vAWFCCTnjE31ofpzRHoiQ48yvNorSxxZMmooGCJHhqkp61a87ojEGJXo/F7oQaQQTJ2VBzvgu431kMigwHtGXcFKZtG8b6Erah9KhFJY6S5kABfx0Iqk+TnEKw8RxxcMjtNrcXJ3OzROEwEnk94FnvHvVoLs0v+N6tQPHR7rz1OtxTw8L/s4friNJ/rrCdwwKFjs1gC93AjLWM+rHnuWFokP/If2yC1sewaEvB6mwORx6bWX7tXIJ2ojXCcon7TGIsJTPwU8FH8nwdynrbfix63oeOwe3V7i3mR6BCsAM92zWZmTEHqYK6avDlmc2dAbp/jgD1/C2NdN2DuD6tmUN5WG5aAVLGwP/jAdtPVKKHFA6Hg8TDhTH0LHjuFNstrII1CqSYeFxkycPRnu1DObb5LK1u3RBtzkak7InvZxZxJZ17czPhGbNMebvGGRW4SRRXG/wFmqj45ztm3Pdd65Y1YR4
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(1800799015)(376005)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:49:31.6796
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e10b0ae5-ccb6-4927-bc4b-08dc48baa90f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004681.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7973

Data structures like struct setup_data have been moved to a separate
setup_data.h header which bootparam.h relies on. Add setup_data.h to
the cp_portable() list and sync it along with the other header files.

Note that currently struct setup_data is stripped away as part of
generating bootparam.h, but that handling is no currently needed for
setup_data.h since it doesn't pull in many external
headers/dependencies. However, QEMU currently redefines struct
setup_data in hw/i386/x86.c, so that will need to be removed as part of
any header update that pulls in the new setup_data.h to avoid build
bisect breakage.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 scripts/update-linux-headers.sh | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/scripts/update-linux-headers.sh b/scripts/update-linux-headers.sh
index a0006eec6f..579b03dc82 100755
--- a/scripts/update-linux-headers.sh
+++ b/scripts/update-linux-headers.sh
@@ -62,6 +62,7 @@ cp_portable() {
                                      -e 'linux/kernel' \
                                      -e 'linux/sysinfo' \
                                      -e 'asm-generic/kvm_para' \
+                                     -e 'asm/setup_data.h' \
                                      > /dev/null
     then
         echo "Unexpected #include in input file $f".
@@ -155,6 +156,8 @@ for arch in $ARCHLIST; do
                "$tmpdir/include/asm/bootparam.h" > "$tmpdir/bootparam.h"
         cp_portable "$tmpdir/bootparam.h" \
                     "$output/include/standard-headers/asm-$arch"
+        cp_portable "$tmpdir/include/asm/setup_data.h" \
+                    "$output/linux-headers/asm-x86"
     fi
     if [ $arch = riscv ]; then
         cp "$tmpdir/include/asm/ptrace.h" "$output/linux-headers/asm-riscv/"
-- 
2.25.1


