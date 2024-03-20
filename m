Return-Path: <kvm+bounces-12237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08F27880DAB
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:50:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3A112816FE
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:50:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7B3E3BBD5;
	Wed, 20 Mar 2024 08:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Ie2ux9WV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2049.outbound.protection.outlook.com [40.107.101.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FE03BBC2
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924454; cv=fail; b=UWP55wwGNeJk06ji5V6Hb3mrZgBg8YU8K+RFGgdsvD+IbzowmD8DRoe4qoY8L6682rDqyvf82ncl24rEzpR9NKf8K1c+F3dGfFSbNK+i/nziFypqHZaoSmnLzTHdzWxzJ3xdMA38kcgI/nBfsKhvRlznvQS7ByiZqiA1KV21qr8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924454; c=relaxed/simple;
	bh=5ZjxaqfxpekoScPYT6WQxHEsmAU+OeV0igoCzLJ6mSA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wj8ea85pnI7dcSJcyAxyjI747fPR0c8gLlFDeIT6AqgJz61H5/Fhy0lL8j0nRsToQL5TQ0yBGPjME24xdPH8YN9lgyIF8uaL893mypfrsO8Bg+lbZdUG4ej06MvVC17eZ/67i6GCojN7YpQl8vhOSuohQuAj4e1wo+w0A08epwQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Ie2ux9WV; arc=fail smtp.client-ip=40.107.101.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a5prRKH0OrKOG/h4k6zSwNGtEKv4dB9NJhep/y4HTYdCwC+2GHR1ENNu8RNeE2H/8wzdJMOC+YS4ZHe0jtid2Hfrc4oWqp6geZtFOcH0Bx6YqK7SCdukQDntGETdgeyUkFRaAlRP5digE7z1n0JbDmt8/VNQOtn0aOTG67kn/nheDqsjqhu3il9lAaLrFB9SgBQRTmQ/nRsfRjMYsd0/3IdS+5j8mHe0aEHaMREFS0zqCfh2P3OTXrjBxZTOpzGSbdQq29BT5XEq1FS4nK8L/fFZ4HiZT/IGVprfIsoArZIwXwkLStEBDvkQ4AzYG+Qa9PCu/N1p7wtTvlVAov5csw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=409eVt8P+OBu2rRFXQ6ZZ6hlrPE6VnzyvWs+OExqOYI=;
 b=OaBioqeEZ+dYr53KjF9nr09ZEw+BrbtlDzCIzXjjmSM5HKbnUXmt+VR7h8Rq5gol0ByXwEJtPFpKKUr5z0ZdDd8L6UeLYCY/iaRf64My+1RQ4M8MLuPndjVmeQpaPH62fCzyHyyjbB1Q4mPIcWj98cRoNdqqdt9zphDCp5bGyO4VvPYLhKSepLoSS1Rs9eW1WY36ljRTs1hIRoiSokdY0b81RlvzAuzuVLXTXQK7cY0kvgFULqT3fap0JvWRY/FQG7siGDA/F2DKbQ6ot52qXdKGe+R7sQex0a35jaZPwrP8wmPgbsyvY6hAo39DrEDKOGKUwynukycdVBobTChL2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=409eVt8P+OBu2rRFXQ6ZZ6hlrPE6VnzyvWs+OExqOYI=;
 b=Ie2ux9WVtkV4aEKU/3alSRm+VAVTE1TKDfZPgy6gDDCxe5y0Y++0kzkFQv4cplOjcxlBgCADAEVtk5l68IZep9QF+qa+jz01YZQmIQymIJPGqNc8mR49MG5nzOhuwcQlJf/P2Vnx/x+jxX7nytEwRwmy8JXMWsW1stfo2WzBcS0=
Received: from MW4PR04CA0033.namprd04.prod.outlook.com (2603:10b6:303:6a::8)
 by PH0PR12MB5630.namprd12.prod.outlook.com (2603:10b6:510:146::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.35; Wed, 20 Mar
 2024 08:47:26 +0000
Received: from MWH0EPF000A672E.namprd04.prod.outlook.com
 (2603:10b6:303:6a:cafe::a9) by MW4PR04CA0033.outlook.office365.com
 (2603:10b6:303:6a::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.26 via Frontend
 Transport; Wed, 20 Mar 2024 08:47:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A672E.mail.protection.outlook.com (10.167.249.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:47:26 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:47:25 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: [PATCH v3 25/49] i386/sev: Skip RAMBlock notifiers for SNP
Date: Wed, 20 Mar 2024 03:39:21 -0500
Message-ID: <20240320083945.991426-26-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A672E:EE_|PH0PR12MB5630:EE_
X-MS-Office365-Filtering-Correlation-Id: a64caa0c-a721-4255-d145-08dc48ba5e52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Yyfd9qXk0d6Nb9lNYhvt8KK+rDlHGF/ppH6LsxxNu/6Lh1MSRv1RKyoTyBZS3FB4mV5lGyV0nV5sQCvodtu8xmb66xBWELF9yAYY4N4vcIv+QAnvVOxyH5pgIE1LBd325oqmg0ZChg9HyWiMrDDSR0j2zyuGEqUvYvzfK6NeN3XaTdyk/rXqqmN1spc3EV0qimZelVcOdPdiUBvw3IoRE5HAOE0Nns2pJdx3aBLXFJmGYcdUzBo+XeBrPVxLUsEz9Py9ajqFINgoSjjzv6SD+pkd/ghTD7sF+NszvZEPIJEG5DNVMbZq/wOC2AdveHX2dW41oaXo4TOI/YzUl7fzjWi1MampXEndec49wwFGsLEbUK7q92kJHnoI59aevCvcR0P7DFL70Tk39kFdJx2dJbuPL9ZTPuYm7GVlKtYgb4VTXP2iqRTKM3NmiOY3XKGMByoVA6OYjbDy5LQBHEu6TkjPXg8mUeVyOsJn7XDjXXxvddy9l/5AKFPTjNwB49zgUwFXkoYa5lGn0xkg3f1SlsKXo4uJ/aQpSAHnmkh6ICSm8WdSkQcOYlMlcmtU4Z/b5o7QqRrIhPmltmwGKMfCCMyyUOJogbDFU+tqryYQTd+TlmqtiNVFTdkfC16kx2hHDBDzCnheb9Abv4dn3A55rrZ8rAzqaysmUizYEkWjMNvBAEYAe9KdCGjmP4osHRma3UJX3rRsMHqtddUjovZcAiOkhg7kZtPqF0auXU5T3RXYHQoBsaM3Qgtwf7AXJBoo
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(376005)(82310400014)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:47:26.1808
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a64caa0c-a721-4255-d145-08dc48ba5e52
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A672E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5630

SEV uses these notifiers to register/pin pages prior to guest use, since
they could potentially be used for private memory where page migration
is not supported. But SNP only uses guest_memfd-provided pages for
private memory, which has its own kernel-internal mechanisms for
registering/pinning memory.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 target/i386/sev.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 61af312a11..774262d834 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -982,7 +982,15 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         goto err;
     }
 
-    ram_block_notifier_add(&sev_ram_notifier);
+    if (!sev_snp_enabled()) {
+        /*
+         * SEV uses these notifiers to register/pin pages prior to guest use,
+         * but SNP relies on guest_memfd for private pages, which has it's
+         * own internal mechanisms for registering/pinning private memory.
+         */
+        ram_block_notifier_add(&sev_ram_notifier);
+    }
+
     qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
     qemu_add_vm_change_state_handler(sev_vm_state_change, sev_common);
 
-- 
2.25.1


