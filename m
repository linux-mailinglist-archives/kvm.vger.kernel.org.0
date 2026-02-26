Return-Path: <kvm+bounces-71948-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wAMOFaQToGlAfgQAu9opvQ
	(envelope-from <kvm+bounces-71948-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 10:34:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F8331A3782
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 10:34:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2515C317EC0B
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 09:26:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 185EC3A1A46;
	Thu, 26 Feb 2026 09:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0mcCzq6h"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010012.outbound.protection.outlook.com [40.93.198.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B07139E6ED;
	Thu, 26 Feb 2026 09:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772097876; cv=fail; b=GUY5bNeZx84OXJHNhWM9tkNMmhBoPb/iplmfMBrly1emuz+amIXeQPf5kHbEMKJwG+GlKdwMSXojpgUMntzLduSgHe45V+TVrwuaNXhLePSB0LNy71O0Alk0ftJPeWlC7rfLg3gC9nfbpOXi6q7bCWMLZOlAvg0WJaaom4+Necg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772097876; c=relaxed/simple;
	bh=ZCykvlFun0V6io4UOZWecgf1HH9ffCb8a0pc+a5Mu/s=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IE3bVUYqQVqpFLf7nmlDwpQjflH0iIssSo4UJtyoGaod3IzcXudrO6gtpdrin74o1T1RdzQKxzVnwvu4Cuz9kCH7cqKFggF8C1nr/rCMq34lA7xaB94kbK4j057eYuz8SRWvTb9QGllt1vct+1nwdGLPWifctMafLrd7D8Dt4I8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0mcCzq6h; arc=fail smtp.client-ip=40.93.198.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jiWasVoqpgmQstAYGhOdzm+O2cYj1/oS1KQba3fDKsEGeJn0cJ2B3vsTWr0pG4ATInEUZV/9VgBiZ4H23+DBH6/FiginoHDKYkjcDquBImqJ+yKt5854zo+sO7dp3k7q4LnlY1af/4tZSNg2cApoKTmieLC0tmRsFECybPymZYRoifcuRMRO+75y0jIVtAga5Cdt3LBrVPzBqibNIoGNlwfRy2mM18wa8PpBfGrumR+IgNOH+me+NWm8gqpl+1Zv4sPATc/KXI747yKT7jfS5za71DMT9cb8g+vgth36fNDdVl3aTzT+BzXM7hQ3TGZVZUmaRqsOJ46ImuC1xWVcmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E0Iba3VlgI5ta/pFc943/HBIYXraqf7kwXDiWrthwdI=;
 b=V74nw+CeRFQjbtG7kfBRf6POaP93pow2oZWOndcRuJSw9l4l32EiIH56e/BDidQQU5xyrVnYVmz4mqoyipvvnst10L5WhUAs+Nj8kbyTxJ8JrIuSfzJf9BILfHiRUluIV63KCPFC8meJOBmNX1dAk/zKOTMI6MVr852Q2EZMPGB6Vm331ZW5/p/h4yLHYEwN6g+27jqGry2dHPHc+t/IF/B/7BLl3jXjimSIbyZK31HCaIEpPOGS5vGhDwnpewmNf3g3qDzDrGXNdlwJ6kWDPKAJuALufoCgyxR6Zy4xrPdMMcLL7htX9nrRKc/huIlRUwuEO2LFKuWcagrHHDSAvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E0Iba3VlgI5ta/pFc943/HBIYXraqf7kwXDiWrthwdI=;
 b=0mcCzq6h5M4FMpgocTI6hc3c5u4K/COKp1aTdwouMyLYEGsOCEb1prSjlHGyNqzbibxHUYwWKHdLroxGy+Dow7M/QjSA0VuEN553FqwJOPDn806fI4M3upOYnyQdsDiJB+Q6c3pR6KLJPvsMx1mq9+JUKzbu9J+SReVAiJFs92o=
Received: from BL1PR13CA0133.namprd13.prod.outlook.com (2603:10b6:208:2bb::18)
 by DS0PR12MB8367.namprd12.prod.outlook.com (2603:10b6:8:fd::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Thu, 26 Feb
 2026 09:24:31 +0000
Received: from BL02EPF0001A0FB.namprd03.prod.outlook.com
 (2603:10b6:208:2bb:cafe::4b) by BL1PR13CA0133.outlook.office365.com
 (2603:10b6:208:2bb::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.22 via Frontend Transport; Thu,
 26 Feb 2026 09:24:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0001A0FB.mail.protection.outlook.com (10.167.242.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Thu, 26 Feb 2026 09:24:31 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 26 Feb
 2026 03:24:26 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <bp@alien8.de>,
	<thomas.lendacky@amd.com>
CC: <tglx@kernel.org>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <xin@zytor.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<x86@kernel.org>, <sohil.mehta@intel.com>, <jon.grimm@amd.com>,
	<nikunj@amd.com>
Subject: [PATCH v2 0/2] x86/fred: Fix SEV-ES/SNP guest boot failures
Date: Thu, 26 Feb 2026 09:23:47 +0000
Message-ID: <20260226092349.803491-1-nikunj@amd.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FB:EE_|DS0PR12MB8367:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ea88447-e582-4fb2-b92e-08de7518d8fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	oSpcmb9KuwzrqkfV9KcggFfNm4zdNen42Dav6lkbjFG61QtvpKQ+oVCkQtN36mn74J321vXXBZ5H2BmRb4l4NVnZOe9VWwly2hfWEBIlpaIaBAjJyS3lKnAmpc8WC1E1Ksp7kFcCohelXUdzVYIQRfd2SZS6XHfklXUfEsjs5M5eOwc8/j/H2SOqZTRWd75gmYNeckgkmYb3ZvHg9mYwfWqjGpO4nl2nwyLz7n721Zm6OIItdvqhPiFUh8HboEL5U3uoXYGdIQrps3ysiZAXPwmcBds2sei7zc2nxuA5IQ/HRSAlnzzLPtZESFw5cF0ZlIO13Wp1t6l75D94OXVmi7SOCZ2EIm8M1KBIzdtW5BwBQZg2guZ90lv8jMcjO2cWhOpXkGxMqHSffo0Eic8LjlBSWySPejXQkyEUkGa6D2ztut3KrGE5ktvqMjj59HQyqzehyzQp32C0wtCpUnNd1SSR/dNi4kfQOOyV1yG7hYoicVRXx2aYt7JlEABNmKrgHTDZXFYLFR+NR0AyCUHkVFCgKpJhtbraFsrkyTOiHqWrNKeJmRXmNrxMOzEwQmtwcrSW7N7gNU/uOE9/LQwnkevqIflTs+3dgNigUwe4uloywnVPi0rXVAV/Uf5hRaFAqhUQt3tOhtz7NUtqd/H8UwIatK3dhgjPwQJgHCeUpwbdK5pKAjBC9yl+NMQvnlylEJePb6/VuMUyno16ZCEPH2bMJbZ8q7h+HmVDPqryAODS9ix4F13jBe5wNaC9oxzZttuXbAqGLtQ5V6r2Ackk7hwefcfKZQ1+KH2yG2VNEEw=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	17EcrDWbr00zl5+ZYx407UjljYkQaMCyaqhrpD4kZZCm4sqZXNzMcaGlWSjiO+efYthvi7qITDCfSnyUCYbKlGbxI3q4utbEcMe1KCfdZsa/0Rygi3q/bBClOrMs8wN+6lyGCpN8GM+HpzDmSTE/yJ0YX59YjAmU+aPOCzcV/qeHVpYVf48b7/2A5vTHwtVCcfCj5zPjk295BMeKCHgjO6z7ibMhMBIxbLUdBXB8xikxtQGXR4tLPXmvsvaw3rjfcPtWJtmyvMpBGqWVOSuybqO8IfDSozPnGQczvjzpx49cI79JVrrYI1b3T/pe4uPeR53RJYY8hDNQO+buuU5AuLOxoLmJQ2nX7p75BzkGMLNTfltyKcrW+ftoraisYZUkhUa1I7hUOk8nO+YiL6sb92tIYZXeu/93WDY1GemwUsrUgaYuRYb1TfekLScvE4LZ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 09:24:31.2924
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ea88447-e582-4fb2-b92e-08de7518d8fc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8367
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71948-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[15];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nikunj@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 9F8331A3782
X-Rspamd-Action: no action

SEV-ES and SNP guests fail to boot when FRED is enabled due to missing #VC
exception handling and a CR-pinning issue that prematurely enables FRED before
its MSRs are configured.

Patch 1 fixes the CR-pinning issue by deferring enforcement during secondary
CPU bringup, preventing FRED from being enabled before it is configured and
able to handle exceptions.

Patch 2 adds #VC exception handling to FRED and fixes early GHCB access to
use boot_ghcb before per-CPU GHCBs are initialized.

These fixes enable SEV-ES/SNP guests to boot successfully with FRED enabled.

Changelog:
v1 -> v2:
* Instead of moving pr_info(), fix the root cause by disabling CR pinning
  during secondary CPU bringup (Dave Hansen)
* Use unified #VC exception handler in fred_hwexc() (Dave Hansen)
* Collect RoB (Sohil Mehta)

v1: https://lore.kernel.org/kvm/20260205051030.1225975-1-nikunj@amd.com/

Dave Hansen (1):
  x86/cpu: Disable CR pinning during CPU bringup

Nikunj A Dadhania (1):
  x86/fred: Fix early boot failures on SEV-ES/SNP guests

 arch/x86/coco/sev/noinstr.c  |  6 ++++++
 arch/x86/entry/entry_fred.c  | 14 ++++++++++++++
 arch/x86/kernel/cpu/common.c | 23 +++++++++++++++++++----
 3 files changed, 39 insertions(+), 4 deletions(-)


base-commit: 7e8eff12c150f3bc24f0faac42e3a62a8fad751d
-- 
2.48.1


