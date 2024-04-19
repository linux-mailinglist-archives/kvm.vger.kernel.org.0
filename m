Return-Path: <kvm+bounces-15274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 94C238AAEEE
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 14:59:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1AF451F22D8F
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 12:59:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CB816FE14;
	Fri, 19 Apr 2024 12:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="s1YTMj6h"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182CF7F46C
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 12:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713531588; cv=fail; b=DCdR1/jqIJmTGwowtigM275heu6a+tm8sdgOwYdNg2qGH2r/G4NN9bMTz9YrJzMHsbPa/VaabbVpmsEMiQQSZut7GzYuUg49p1pCze+75nKh5ZpjGta5P09WfzJOMHVyGj16Bm/UCGok4mFsh0h8/K70qWFDx/Z1JbL1/J1mz5U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713531588; c=relaxed/simple;
	bh=XM+Onknuvxi4trzncnAy/smX0wqy49T9d3Trw6hFNY8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mod7Bg5wRpIDo6VZpA9HHsUO36jEmRDKtIcOBrlsGAETDpq5dem0r5eM1nWArVObt7QnjFTyfNxN5cmpwLsQUa9isgIbWFaJ4GG45rV41l4tdqbD1JuHV95Yy1IUoLv6Tq/z2b8VUfJlxa3LKK2CcGLX8tUMFviXTQK19ZoHM3Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=s1YTMj6h; arc=fail smtp.client-ip=40.107.220.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AXax9BLHP1dnGPmjJGzA/NGMUpHH+LTs8wi2rghgXwk+KPh4km1SEJ/2b8Mxp8zYOvypGlfhwdoVBz3CoBhZd54z8oYW/ARKzBN7FWP37Rt8e6RH6HtJMq+btEP6sxfXR4DJtIcwiryqStYcE+iOA8RYJ+8S/Z6LBFUIqGs50ydWBJFxyRM8DXHb99+ljFSC86rl17C6tODX8+Q6Ma49X1UainCumIIyf1zCOXLldSf33gfRFXBumebzSh5g2LnIFzLPeHVdkR3aSfT/L83ClN/bfTqMSO1abAoKfq4RtoCBhNcn1P0byB1R8Jn+AT5Aly4fWi9C3KkIdeBHj88Z0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jLk9vdAMB5tp0CAPWhF4txWpZehPk5b3WqI1Pfeh/XE=;
 b=BUpRAu2euwQ1A3K8KGdiwvmZv0NVBut/4t1RSq0W2qUG1EiU/lrGx3meYxyQJb+MEFhsGQ+sLzsxSD4AUgvsgMa/ACeUMUx6qJjdc/XOaYMGGa/wFX8CsryONsMCHG+KnHWiFrzmWBs8dlW5hqe98vz06f4wKNiE1yfL+CGiBj4mj2Yl3FXKP3Y9m0+Uw4rpmW2BGTr/qO+pwDwJlM/Llq6y/aeqOhg7MR7dx3nf6wYy8KB69UozqAWzjKHUYZjd/Lah5SghC3eaeLBnRVGes2gSr4kSOiKFi8whTMg6Ziq2u2mYZXxlvhjLKfcje1yIsHczE9JSxyxx0r7FLi0tVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jLk9vdAMB5tp0CAPWhF4txWpZehPk5b3WqI1Pfeh/XE=;
 b=s1YTMj6hUBByPOGck46SYyXUAvZDQv62gmoFN2qsl6SgZumu8bl5t8c9ykMnFyP0VV3K8uzChuzAG5cIdj6lSGaM+HZ8pbB+psSyiN11glGyH7q/pKhXwxzFX/9bZ4IQGTE+fxiTmAeJ9kCV7qt+YQ/EbdadU8x/BnifJ4LBgDI=
Received: from SA0PR12CA0019.namprd12.prod.outlook.com (2603:10b6:806:6f::24)
 by SA1PR12MB8144.namprd12.prod.outlook.com (2603:10b6:806:337::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.55; Fri, 19 Apr
 2024 12:59:45 +0000
Received: from SN1PEPF00036F43.namprd05.prod.outlook.com
 (2603:10b6:806:6f:cafe::6c) by SA0PR12CA0019.outlook.office365.com
 (2603:10b6:806:6f::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.31 via Frontend
 Transport; Fri, 19 Apr 2024 12:59:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F43.mail.protection.outlook.com (10.167.248.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Fri, 19 Apr 2024 12:59:44 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 19 Apr
 2024 07:59:44 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christophersen
	<seanjc@google.com>, Michael Roth <michael.roth@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>, "Kim
 Phillips" <kim.phillips@amd.com>, Vasant Karasulli <vkarasulli@suse.de>
Subject: [kvm-unit-tests RFC PATCH 07/13] x86 AMD SEV-ES: Set GHCB page attributes for a new page table
Date: Fri, 19 Apr 2024 07:57:53 -0500
Message-ID: <20240419125759.242870-8-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F43:EE_|SA1PR12MB8144:EE_
X-MS-Office365-Filtering-Correlation-Id: 822dfbb0-f849-420c-e2de-08dc60709621
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	i9pya0xkiAQ3cjnvYrXpObDozupfoFAIBVgLZ0TVdEnwEEXyGtuF6/ei6UYahWwhV3dXzBQrXcsXE7ySG+aSg5IG3UWkXZBEN3Qrk7EV99b0J3bB/CAG7VBhpGFpaiWgRhMG+K4/hLXePC18J9npemMTRb1hcPLot1J0Wor/lcf8kgN0SX0vy9q1+yPaQf6mN+nNiG+3KOOlWabHvFazywHftDIAPeN9LemD7NEKlwcRCKlA7wcc1a07oDPnOa802ahnKvUgOt1PYyeCHMmN1nbIQCrcf1RTrSikUnR68CayAC0ET6hkpO8VSx8tif5IIMP6oS9JyPr4b5qRu27CZxDqoFYBME6upprC4joJmOdGcfRH5xns+fJWO3jx1uS7hnNYG2hHTCFgThJNlky9hDpoBFv5LNEjn8oQENZ+Zp5WYuRpzDaUiw04XbILuDCY61JscJgtIFpTr0kRUf2HDzBL0Xvh5pa8Dhfb7uaKNR5Jfu0GCe5P6Hlanfk04BZ7VrBaDCzUswsi7/30bmjAEifq7ejg0Ss04N9X6ylU0EDrNF9PhZlR7LGg3MZ/7EROkOYP3clTj53h+ueg6rDrt/dTrqwyAPo2vkbq5RgClhiushafv2/AlZQJ7TeaEEfgKJ6K9bt8/t3r6uO5EqRGIWDJhCw1pm/pncFi7Vn6txWQQmoTpzznZGhxhLI3VlXXFMC5oOZZc0LqxYL5PM3XjCAh2kLmyvYgFyCeRMJUBerwHcIezMV73uQaGrCKjMtq
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(36860700004)(376005)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2024 12:59:44.9768
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 822dfbb0-f849-420c-e2de-08dc60709621
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F43.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8144

SEV-ES/SNP guest uses GHCB page to communicate with the host. Such a
page should remain unencrypted (its C-bit should be unset in the guest page
table). Therefore, call setup_ghcb_pte() in the path of setup_vm() to ensure
C-bit of GHCB's pte is unset, for a new page table that will be setup as
a part of page allocation for UEFI-based SEV-ES/SNP tests later on.

Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 lib/x86/vm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/lib/x86/vm.c b/lib/x86/vm.c
index 90f73fbb2dfd..ce2063aee75d 100644
--- a/lib/x86/vm.c
+++ b/lib/x86/vm.c
@@ -3,6 +3,7 @@
 #include "vmalloc.h"
 #include "alloc_page.h"
 #include "smp.h"
+#include "amd_sev.h"
 
 static pteval_t pte_opt_mask;
 
@@ -197,6 +198,11 @@ void *setup_mmu(phys_addr_t end_of_memory, void *opt_mask)
     init_alloc_vpage((void*)(3ul << 30));
 #endif
 
+#ifdef CONFIG_EFI
+	if (amd_sev_es_enabled())
+		setup_ghcb_pte(cr3);
+#endif
+
     write_cr3(virt_to_phys(cr3));
 #ifndef __x86_64__
     write_cr4(X86_CR4_PSE);
-- 
2.34.1


