Return-Path: <kvm+bounces-15683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D13D28AF406
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 18:28:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 45DA51F23421
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 16:28:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3940513E889;
	Tue, 23 Apr 2024 16:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UrtawqBp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2067.outbound.protection.outlook.com [40.107.223.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC7A13CFBD;
	Tue, 23 Apr 2024 16:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713889541; cv=fail; b=mw61jSGZmaoIE6guF4xviHLgSOqo9nbMhvF4An+BJ4R39C8YSN5RR3kyPkTD+CWVdu1y1P7KAOuEipuEArQMDIEsTPH0hYfThGubLHFeqTYeeT/L+5Pgft1pIYQZsiwbla+91yBW2kWf6dnbDWQqkBfJx2sOOqMrF95ey4GFwVA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713889541; c=relaxed/simple;
	bh=9tvv/ITgL8togB8ryH3y89mHkgfUQrSPhi17ZQF43fU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b0LCjRenb26ALtJaszix/+qiUPv9/azMlE8lY1qbx40lzIgt+Elz/5b7//qROc1uzOSRazDl9NrqDnNDrLZ1iqmxlruEw2vSziVjgwoDlTTzP4A0JLDahgNkSt8BZT/r6nPlqYWOeUOBcmWV4sFpBul6+CIC6tbyLlZ9nLNfbKI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UrtawqBp; arc=fail smtp.client-ip=40.107.223.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E4u3tBlykwixD/HcTjA0n8RlC0TwLAdZ/ub3dX3q1bje/39QQKRpm4k1FmsUXH24xzKkdF+FWInqK5B/cbj9e35n9NireC6gNYtq5bjsvmowhkDUyg6QhkjZWlPYyixM2AI5VVUA4x856+1f95ZZutairtbHb7NneV2OQG7pFG3gTHfg0Kdj3Q8VnH6jgVmgCIkYml1c8HkSs/FXEY5r0NEif8yvLW2535thcFFIA0xunwj+2gbKuVdEoJ+TgggVMa3QkdtSR842EtziA0Zr0qM0MzQetqDLvf7d+SPu5toz1iarANZAbCodU358zGXfjG0Tyyb/gFp5ejVZX8kldw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1uvqxf4AAT/4+K/snKnusN567i81xeodAMTISj8yubc=;
 b=ajSoNjZxlVAsCPSTooZyatngFHnBrz5bD7uzTTeDFFEa+DfofXA6gR9AgZVi/8X25E309rALOOppKLCjA7D8fNzPi18Um3fqqrfUtvDYLw8UbKDViTw9a65/oAftsEz785bs1wltncOZGhJeL5mg1B+9Q9DdjHnue+ycaeojIiNMdXO8hNqrc2BQkbhdTUCvMuoAUU45RBgsXQzjGpI5Dyg9MNXYXyXxmHe+fsShEcbUfvIOzjKxoUNjiv+e6h82XAMoEXZy1eqhaozAF8Sw3cNsgX9Zs+c7nAf4kWrk+X0Tcb1SyQF9KrTdNkxWc7t2+a8yqp6/hpe7IiYrK7x0dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1uvqxf4AAT/4+K/snKnusN567i81xeodAMTISj8yubc=;
 b=UrtawqBpfwlFpR0JhIGiTeXDK3ACDmvJXSKMJs97LGGT3jgUVnZUVPXuf7sKImeZYtvrHJeC91V7liuAy1HxzA3lGrCKhuHFwCTUDlxEYdPXLVGv+LyqyIcRUliOnYKC4XZpCN8asBH2xvLES02KeXrkc/uVLIRYxzVs/ECerAY=
Received: from CH0PR04CA0023.namprd04.prod.outlook.com (2603:10b6:610:76::28)
 by CY5PR12MB6060.namprd12.prod.outlook.com (2603:10b6:930:2f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Tue, 23 Apr
 2024 16:25:35 +0000
Received: from CH1PEPF0000AD81.namprd04.prod.outlook.com
 (2603:10b6:610:76:cafe::57) by CH0PR04CA0023.outlook.office365.com
 (2603:10b6:610:76::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.35 via Frontend
 Transport; Tue, 23 Apr 2024 16:25:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD81.mail.protection.outlook.com (10.167.244.89) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Tue, 23 Apr 2024 16:25:34 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 23 Apr
 2024 11:25:34 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v14 28/22] [SQUASH] KVM: SEV: Provide support for SNP_EXTENDED_GUEST_REQUEST NAE event
Date: Tue, 23 Apr 2024 11:21:43 -0500
Message-ID: <20240423162144.1780159-6-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240423162144.1780159-1-michael.roth@amd.com>
References: <20240421180122.1650812-1-michael.roth@amd.com>
 <20240423162144.1780159-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD81:EE_|CY5PR12MB6060:EE_
X-MS-Office365-Filtering-Correlation-Id: 094770ec-aaba-4a75-6ebb-08dc63b200c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YzZ82casV1xpEF1kUPpSiTFHOFMGH+HTfEhuHKEHoDMM5op2AxTEexLWi7Ki?=
 =?us-ascii?Q?HSsRhN1DwvLgOVaFet+yEEtemSiNHK5SIbrJkqSRixnvUgMNlribdxovjlgE?=
 =?us-ascii?Q?lI+Gmu5mvHYwFywJi+9giglvBQ+VQ3Gvkp4iEl73fsMNmYWVPAQgfeoGdKZi?=
 =?us-ascii?Q?6el/0+q/is1MB3dSgvWKiivoKL8rVDcX7HJ1JqV6hSJLC6hjethPRXgovXy9?=
 =?us-ascii?Q?oCoCaziMNVWEB0/AOi7eTa0lC34kMSElO/qXLH6pRUnq3oY+YGD1+GBKzl+A?=
 =?us-ascii?Q?ubTRUXqhONxRmIXeZ+1tg6BR/1j6LBwcggXjY4gCQ2M73nMFl+JBAb5mB8ML?=
 =?us-ascii?Q?qhyApjsWCK9e/hF3Ugoje1862Ikr+MKkPKwc3vUNhEvOJla6vrQbeSN0GaVa?=
 =?us-ascii?Q?tk78YDq1Ic8PeBkaANtlDGEa8sw1wi+ZKYBX591SurYLOStnvUxFnp8FaCQa?=
 =?us-ascii?Q?unDd02rF2qf/L7i2Fbl5ZTyWGRhlZtwVhLzPQ6XQaH+7OMWdmoV1iKKscIo4?=
 =?us-ascii?Q?LOD5FIv+3fPZDz3xFr9v8QeRfqW/KAdn06RdJByMY1v30zbUGdNTj1W09oOb?=
 =?us-ascii?Q?P1+pWP6Rlj+/B+CVG0Xi/vVN88nV/Yvob4WrRexLNE4/BuvRpnqdmAkROEDB?=
 =?us-ascii?Q?yJMjECCnIcnrXznvq1vft8JY02mhYM4nwgGd75uLw3oBjQSCaFmj3s8jdeE7?=
 =?us-ascii?Q?H+b4jLZwI9VjJvnJdFAi/5RVysJ6CD5dwTV+9/kVpAVZ6Rv0q0a2lLRHufIZ?=
 =?us-ascii?Q?34ek/rIaqZtC9skFlNV1e64vsVkCmfo8ZhDZ8wnTRfrQZyvUbx36DhAGW5aU?=
 =?us-ascii?Q?aljxz1iHpf6WgpnbkSnOicip7l+2NuzclMndwOmAv34zf7DDJo/vLGXgzUS1?=
 =?us-ascii?Q?iMEJXkOGfRS6xdDUmCsZTH/LBt2E83tL6DXGr+yXgQWHs6bBh9vebVt34f4h?=
 =?us-ascii?Q?DEBwvGer262wRcTRrxT2sCVpXrjz8tY9qBJRonflE67liYwk3/JkDNzpxw9t?=
 =?us-ascii?Q?S0DDDIgna/2xY08hXvsQxviFePBaoIDvC2ufz2v86UCjYMea3KQi0d29hty4?=
 =?us-ascii?Q?3zWjQBYZUQxQ2aTixgr2B1RcuRg/JwVvZ55a7Xcjr2rS+6nlV2GP6sxYaUSr?=
 =?us-ascii?Q?yE76BpNTFATaD2oX9EUQlbpc//OANg7DJLqd40KrbivAUzjnyNeAbR2EyF6P?=
 =?us-ascii?Q?UR7pNn8Xg0iKob+9NdVxGXW9M60x10pOZLn85zYWtGn+LedbXKoEBWzswgMN?=
 =?us-ascii?Q?b4ZYARZM7CkT+WOcmq9HmxWFcvdSfO5XBV/0A8ACUe3CPPe8fFIBPfMdKrs+?=
 =?us-ascii?Q?IL28RM5M/PfLZ8DVF+Dse388PsJjTAMzJ2wDRA9+HoMtCkp4OQ7duutlYPR/?=
 =?us-ascii?Q?CJRfYzk=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(376005)(7416005)(36860700004)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 16:25:34.7319
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 094770ec-aaba-4a75-6ebb-08dc63b200c6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD81.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6060

Ensure an error is returned if a non-SNP guest attempts to issue an
Extended Guest Request. Also add input validation for RAX/RBX.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2b30b3b0eec8..ff64ed8df301 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3297,6 +3297,11 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 			goto vmgexit_err;
 		break;
 	case SVM_VMGEXIT_EXT_GUEST_REQUEST:
+		if (!sev_snp_guest(vcpu->kvm))
+			goto vmgexit_err;
+		if (!kvm_ghcb_rax_is_valid(svm) ||
+		    !kvm_ghcb_rbx_is_valid(svm))
+			goto vmgexit_err;
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
-- 
2.25.1


