Return-Path: <kvm+bounces-15268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AA0B8AAEE5
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 14:58:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BC2BCB21CAD
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 12:58:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C87985951;
	Fri, 19 Apr 2024 12:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YoXcAM0C"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2086.outbound.protection.outlook.com [40.107.212.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497424D137
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 12:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713531524; cv=fail; b=nbwmJJhz5gk+LS6R3Wpnf2F9HrVg8srZcgpr5H5EzS55hLO7BOoDN6vA+x1Gdq+HmMwI72qCSVd8BfQC9u9kGDSTm0+3FHG7k/AIO6yz1OSKmuWoqAJkrF61DLqOvCTEAnkbx2sd/TpPJZtZToewbURLTR4MdUkQWuZ2vluwyiw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713531524; c=relaxed/simple;
	bh=ZJE4COtvIJin7nKxZa6VUvqFMX76d6XYW5gE0Yc5qyY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MF6yiRmZmqgxUH0/RfQLYATVqB1up3CrTtal9xojOH1MUjLduVQOnH2+zDb8ktSz+jb/SK9cehbHenBvFHEaOyy25HQOb+K4ie7UQxdtzGws424tVsIjgn8bl9+dL8w7lZHhveZi/fZ8CDYRf4Wku2lIx80CR0qGlVE1e23SYww=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YoXcAM0C; arc=fail smtp.client-ip=40.107.212.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bhfGzt4Uv0pTfbyL8LITQE9Lh6CJHiciHqaEYzAIm5tyJpeuwmdNkutdXSU8XYeKsyfE02wsuNpeIHTZj13K4tBlbyEOhpwUQBfXSm8xV5AvIF8OIxAzCbc8bNje2YhiES391IGcyGiHXZANFjjegXyCuZLrwEGKXq2fXuRDSZxgeHTaePZZ0kWTnm76dn1jRoi0kvwaL875e+ItDHTrisDnHLKrfBSOwcqwcqgryJ+BRGhcBQYFVhRE2U3a6S9pcUhhTfQCDew8ZysAyMBts+LiP02xxxijcxiyugGwPqp6KPejG4kE6SpamQK4ah+Xc7iH71EN5v5FZtTTvUbdLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5kTICRnIRkUmgxu22iyii6DumxThLJSh/trAtDvNaKc=;
 b=Pv4IL/r+lzldyHyfWIJtnk+sdlpKg+t6UtIdxn20DGSwaXeWfrlHhOf0lzR7+kVWYYQw8Iioz/1xJSRnxDjt0R0Wv/Q40a2qejVDXPHIn3kx0rYo6hJrG7VD2QpL8x8XD2IDNqws++CvRY5dMR00JgR4toKChc59+lS00/sMoZuJ56vWu7VJEl7Fn4y2x4kVuMhfch4DSiRGXmmTnSS8zhCEc0SMZnUMay8dESDX3j+cXpDCtX9aUt6ZU2tn2GOCHJCxdNN21hTjca9y6fpaxZWkunxE8j4sW1viSrhFiEYknBRxNGAgTP39fUv5uan37JX/nXxIuSk7gaVcg7jTQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5kTICRnIRkUmgxu22iyii6DumxThLJSh/trAtDvNaKc=;
 b=YoXcAM0Cv3X7+wD8gA03YVpQXVha+bNnqxBmykKoiwFNV1UJpOwslrQeSSa0o580x1P1pLuKm9BiR1hPcvN7DeEBmrVuS0mT4W7JIcYcvb5+17GeYv53XfdQYg2QCnV6sFuFGBXalPw7QKCcziMGbRqWWf0avXn4gG+Mt9GkIYQ=
Received: from SN1PR12CA0074.namprd12.prod.outlook.com (2603:10b6:802:20::45)
 by SJ1PR12MB6337.namprd12.prod.outlook.com (2603:10b6:a03:456::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.43; Fri, 19 Apr
 2024 12:58:36 +0000
Received: from SN1PEPF00036F40.namprd05.prod.outlook.com
 (2603:10b6:802:20:cafe::c8) by SN1PR12CA0074.outlook.office365.com
 (2603:10b6:802:20::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.30 via Frontend
 Transport; Fri, 19 Apr 2024 12:58:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F40.mail.protection.outlook.com (10.167.248.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Fri, 19 Apr 2024 12:58:36 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 19 Apr
 2024 07:58:35 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christophersen
	<seanjc@google.com>, Michael Roth <michael.roth@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>, "Kim
 Phillips" <kim.phillips@amd.com>, Vasant Karasulli <vkarasulli@suse.de>
Subject: [kvm-unit-tests RFC PATCH 02/13] x86/apic: Add MMIO access support for SEV-ES/SNP guest with C-bit unset
Date: Fri, 19 Apr 2024 07:57:48 -0500
Message-ID: <20240419125759.242870-3-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F40:EE_|SJ1PR12MB6337:EE_
X-MS-Office365-Filtering-Correlation-Id: fd974885-6afb-4407-10fc-08dc60706d17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	oLcocU1QEnUtYEiSAUaOPf07+6utsXxyT8aaY4O/oA+TKMIG7C5L809ILNG5PhJB79kvbYg+I53tALNy3yQNPtbQPYKppta0bhPh3DfRz1j5DMZyBVqQp64IOd2g5yBkRIAAWmfYTMsBWde76Z5DY/NWRU9s3U9aNyOZWfOIHWqRGwVx43N2SC4YDo/7KynawwbdYdlvvupUOxWfE4rfc/KDH1AJSf9Jrkb+QpzHYkIXEyxjACu7D1/vh6PEKB27yiFXVMxq6vYs23M3jDYw1ZtkX+rZ82LunUp42QR+L8FlB9Q1OjYvhIOMvb+X9fAbplgpfyx6XiAr/1Pw1nVRlOZycP5qnVn32WO+AnKLgmpYPjllaVd++DxY6TRepoIRGgMMW3vTaQF8Fdm5W+cC292CwPfNMJDlaWk5bXojI08EG6yOAiWo1iivNMUpQHxCgX6pIdGxJZeKkHA7nCtVGKbxCwm4cTEWfNJOX0hP7DUHMSxoh+rQI9lpFx4vpopecZMEnTCvzMpGUFB85EaVGbWacUhrLr6EbcVcgDbnkttT+vGpEqpCZoIHHGjSc/dOAs7+bhU40Nb4+HAdR5RLKPcjo0nx0rFOb6qT3JuLzKwgh9yRvwIX8/JT1lMjaq7Cy9vpiRbUBGKm4rQWWEoZwfkH4NrIwTYNla2btfXPEebG3cwowB0ndIgbwbbpPlsHqatFLO1y7bqBAp088Rc1t0pJI5DRg8wH5w2rHCw9VThASILobEyBDMztEreaWqe0
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(376005)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2024 12:58:36.1349
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd974885-6afb-4407-10fc-08dc60706d17
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F40.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6337

MMIO access to APIC's private GPA with C-bit set that is not backed by
memslots is no longer treated as MMIO access and is treated as an
invalid guest access. So unset the C-bit on APIC page for it to be treated
as a valid MMIO access. This applies to both SEV-ES/SNP guests.

Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 lib/x86/apic.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/lib/x86/apic.c b/lib/x86/apic.c
index ed22820784cf..c6305e996a35 100644
--- a/lib/x86/apic.c
+++ b/lib/x86/apic.c
@@ -5,6 +5,8 @@
 #include "smp.h"
 #include "asm/barrier.h"
 #include "asm/io.h"
+#include "amd_sev.h"
+#include "x86/vm.h"
 
 /* xAPIC and I/O APIC are identify mapped, and never relocated. */
 static void *g_apic = (void *)APIC_DEFAULT_PHYS_BASE;
@@ -233,7 +235,17 @@ void set_irq_line(unsigned line, int val)
 
 void enable_apic(void)
 {
+	pteval_t *pte;
+
 	printf("enabling apic\n");
+
+	if (amd_sev_es_enabled()) {
+		pte = get_pte((pgd_t *)read_cr3(),
+			      (void *)APIC_DEFAULT_PHYS_BASE);
+
+		*pte &= ~(get_amd_sev_c_bit_mask());
+	}
+
 	xapic_write(APIC_SPIV, 0x1ff);
 }
 
-- 
2.34.1


