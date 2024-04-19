Return-Path: <kvm+bounces-15267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ED898AAEE4
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 14:58:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F09951F21A94
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 12:58:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D0C285C62;
	Fri, 19 Apr 2024 12:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BKMx1iiV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37BA4D137
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 12:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713531513; cv=fail; b=JFhFXDAXAtsAqUFQEBsDIunAs6+pV8tf8SqgPA7/OMsLH668fABSV5w6Flhm8veJ3b276TWE6ypS4M7/zx4B5vbMNzeyVcZKy3snEbwf190zjPooJ03h9uup8gwWFQwpVDQnCdUa4xPoq2s9BBYO+q9wUSp8fNdGFO6wi1qAlPI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713531513; c=relaxed/simple;
	bh=MWPkL+iS0ocZhF6WRsVQ1ADM9sE4GrWZr6LPROuR94I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g2e2HBPq9fAKpxP9XV0PJASJX+fFl4FMQ1tDOkfuJL2Ik14i5dZ8ffg077iWRdGbC54Aeg5jxqhSGJsfHo8mcvmIU6k6SSafc8SjzgjSooYIQcFb+HP9CMid7c7XqZ/PC4NzBy7C+uKVtHT3Wvw0Af/slwNADJrUSklUYNHJeYQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BKMx1iiV; arc=fail smtp.client-ip=40.107.92.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bTGHOL+pvVR7RT/cW9nTEfA8A0sM+cK9yGhDJzHuKW47CB1KZ02BnWId6MVPMACDZoVl3yGy4QMCdUV1JX+l27F7cvVLAfIiSeBqykvrOttajBcrfENN1xm3bkZM5ru1CgR4Th2DdTpq4mkuZUfNp8UfXAgJ6iRlO3FEAGIsgr2VbUKK8E5A4BNusQCFaw8AB8xPa/KP4CSPI0kXDr32fFwobtmb62tc0hkDOOvo2IsRDwvOd88Ah3xJmMIvtuZMZJZbmPFx1jUQYB7WVMb+iZjmdYvlFheBlAsZXp75VSirNvrfbBhfhnhqJF/opWbxjbUjhXChZJnC8jffhOaTwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LlgVMKaLpMaWyncrPGC59yU6ro+G1mB5s3dSNKwkVXk=;
 b=ktgmHaXNOwjbsqrBR2xMt/NYbqY4oZ+qQu1V+SYJXzHcZ8gWGTEfNSaoDnVpy41Rrs4O1TGoQKNmZJat+aYN3Cy9W36G1/nQFEZGNdsUHs05wkF0o4/XTwlqLsf/jT5lrMMj6LqabjEgPzRhV3pzyHroALVDKCbPHa+MHIjREfMWPJiypDtFVnFjLvilMDBLczkl2GMb5Pc9dcTBwBJ/2XX8GM9yLjtM0Q2kZN8VFpfbWfnv6pTyFULzBL5pFnmZ6spqKyKofNkhpG8ROsywGxTn9AMp/PXNOTKFbm2quWke3K0mBeKk/88jmixPJ4SPheBdGIYYUb2qU8UT9fj5XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LlgVMKaLpMaWyncrPGC59yU6ro+G1mB5s3dSNKwkVXk=;
 b=BKMx1iiV3SjJeYe7l/waf6I+gfQS9Ng/CU5ZRVi90LF8RGzFfz/t21/P5boE7ygkil0bSN2jhlhGTunXdmz4hdtZxMGq5SZuNR+v0FCOqPywCPDA3y0FwCryHz4Okvba4rgPzS3U9+eh+E63XbrBUqbGiYhP7oBM1vrRA+/2eL4=
Received: from SA0PR12CA0015.namprd12.prod.outlook.com (2603:10b6:806:6f::20)
 by PH7PR12MB8828.namprd12.prod.outlook.com (2603:10b6:510:26b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.43; Fri, 19 Apr
 2024 12:58:25 +0000
Received: from SN1PEPF00036F3F.namprd05.prod.outlook.com
 (2603:10b6:806:6f:cafe::cb) by SA0PR12CA0015.outlook.office365.com
 (2603:10b6:806:6f::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.30 via Frontend
 Transport; Fri, 19 Apr 2024 12:58:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F3F.mail.protection.outlook.com (10.167.248.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Fri, 19 Apr 2024 12:58:25 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 19 Apr
 2024 07:58:24 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christophersen
	<seanjc@google.com>, Michael Roth <michael.roth@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>, "Kim
 Phillips" <kim.phillips@amd.com>, Vasant Karasulli <vkarasulli@suse.de>
Subject: [kvm-unit-tests RFC PATCH 01/13] x86/apic: Include asm/io.h and use those definitions to avoid duplication
Date: Fri, 19 Apr 2024 07:57:47 -0500
Message-ID: <20240419125759.242870-2-papaluri@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240419125759.242870-1-papaluri@amd.com>
References: <20240419125759.242870-1-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3F:EE_|PH7PR12MB8828:EE_
X-MS-Office365-Filtering-Correlation-Id: c3b168c2-d954-4263-385d-08dc607066ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nzXLRBt99XC4YyW7lh0CGMECXWgQNiuT7byzWd5dJ4NCmWdi1pa701LHalB8?=
 =?us-ascii?Q?0IoAhZdijKLowRyr59VOhekMv3puAYFRCHtLCOGAiwhGt0tKf+QRTqMSv5f0?=
 =?us-ascii?Q?vYE4oEklWI2T5BBiDKBf2ZbtNHbD4AFOUgBkQFGIxQe759NZlFobiJjTshZS?=
 =?us-ascii?Q?9AiOh42ImlYPfAmNN5XaIksM9JXa0jIKFerTPSY/xHKYCvPlYGpk/iiejWz4?=
 =?us-ascii?Q?zQ4a4tzWelCWJvKyztyfSkXTNkYr9Ek/7LH6f2LyYvuQk6A1oOFyqMF+94bs?=
 =?us-ascii?Q?1S3w2+PSP4g1JrfKSyFrDMhIxRCTbwaRJ8dTI+dUsh01twgjBlWmgy5+pnIK?=
 =?us-ascii?Q?xepoYAAvVgOHGd0dFI45p/d3SdlnJucFZMNRCcuVb24HGIXxxQ7mo3MtUg2k?=
 =?us-ascii?Q?oy6JwzsuayOHQv/x6WGf6xvnuaBkTUIoQLu4Rx0yQKrBUaG7B94x1c3UeXsO?=
 =?us-ascii?Q?6lTm26QK7gSaWvKmEXhxD27OfJJ4cmu+1eJZ00YGQZssL44f4YV28OQL83JV?=
 =?us-ascii?Q?sh8zYjpzyr0QwEnMjX+qHuNfaQS+gxk58D9l3VFEPxWfJMg6riI8jQ1nZNhI?=
 =?us-ascii?Q?y7c5BLV451gWrja7ZIDDWnW6qUoiyoT9xk2rEEY2K8YkL/xA4GNmI4Ft+oYW?=
 =?us-ascii?Q?JGeovj4NelCBapKCs7Z5IIiF4Isw9Yr+kiMcRPUpmD61j24EnL+dDkyfTtE4?=
 =?us-ascii?Q?0ieGr+w6+d4Acil1GT+PRgm2EE/dW6qAG0QWcWvvzhBMA4t1TrJZMBgk5SKd?=
 =?us-ascii?Q?LcbZrCmykLfIK4xsIDsIa1gEXfbfKVbYenWnsIJykHwTQsHBhRyDkMELhofI?=
 =?us-ascii?Q?v/Tu16MaNS0/fWUDnakhbCS6cq9L3s9yCzaFNWAOdp47IdZOif+tkTENIJbv?=
 =?us-ascii?Q?POmKPB3drKJ+7hpS+nJIbJTlNUsfpaEyDZib3fiQOQR6CV+b1ACOwfgJ/1Qz?=
 =?us-ascii?Q?l101tam8MzKuSAqRPewO0tVqlQRdU7psq4YvLhdmT78phe9XX8AuaY1x+lHL?=
 =?us-ascii?Q?5Xmks72dUCiTD6Uq3F/xW/E/gXBg7rLVOcYkce1L2RIxiGqrcbd+3hrvHIJ0?=
 =?us-ascii?Q?XK9qXpY/9NKoEKijFnj+PNtv0RTCBY/s8B962JavUdxesqGQM4vnxlNE5E9I?=
 =?us-ascii?Q?LuEBH2duin/fEOLad6+UBG5qvmfja90gIbjjDZr6rLQPX50TVCzFJ+4WD7rx?=
 =?us-ascii?Q?iEx/XTXQ/ui0mSvtVcTHbZ1Q9fxEHevFVQ3C8CS+C0jnUsWg3iKTvD/ObTy9?=
 =?us-ascii?Q?9IOuwHWS9oo7WRk25ycHjsX+FUiqDgVmHkKQ5k8pzroAmMusAH37JfwRlsJv?=
 =?us-ascii?Q?IkyTf4jEUhyZkANfhmf7CPf5c9gO2gCppBjSdunCkakNHzQtwTdus/eNkPvP?=
 =?us-ascii?Q?wiSmhC0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(82310400014)(376005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2024 12:58:25.3658
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c3b168c2-d954-4263-385d-08dc607066ae
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3F.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8828

To avoid duplication, use outb() definition from asm/io.h.

No functional change has been introduced in this patch.

Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 lib/x86/apic.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/lib/x86/apic.c b/lib/x86/apic.c
index 0d15147677dd..ed22820784cf 100644
--- a/lib/x86/apic.c
+++ b/lib/x86/apic.c
@@ -4,6 +4,7 @@
 #include "processor.h"
 #include "smp.h"
 #include "asm/barrier.h"
+#include "asm/io.h"
 
 /* xAPIC and I/O APIC are identify mapped, and never relocated. */
 static void *g_apic = (void *)APIC_DEFAULT_PHYS_BASE;
@@ -23,11 +24,6 @@ static struct apic_ops *get_apic_ops(void)
 	return this_cpu_read_apic_ops();
 }
 
-static void outb(unsigned char data, unsigned short port)
-{
-	asm volatile ("out %0, %1" : : "a"(data), "d"(port));
-}
-
 void eoi(void)
 {
 	apic_write(APIC_EOI, 0);
-- 
2.34.1


