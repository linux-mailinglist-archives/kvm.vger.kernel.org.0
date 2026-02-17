Return-Path: <kvm+bounces-71184-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mGwxLu3LlGluHwIAu9opvQ
	(envelope-from <kvm+bounces-71184-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 21:13:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4517414FE3F
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 21:13:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 96D4730614EC
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 20:11:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E99CF3793B0;
	Tue, 17 Feb 2026 20:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LIUPMUkh"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010019.outbound.protection.outlook.com [52.101.56.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925AC37881C;
	Tue, 17 Feb 2026 20:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771359100; cv=fail; b=PRTufEX8PPJJw6IQpNDOzcqhpFZPkkkR/yTDV8/9c85kJUa54IKISqlWYt8+b7AwxoBx959omS/DnRrl3XW8lzu4lBpp1L2ts7TTanzDnKJDG9pCS+fHFkiQUD0fjJxqhdRNUUedZWrYqcS8ZWNyiFGQ5JSjgqVD0K6zY6cfRp8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771359100; c=relaxed/simple;
	bh=8G/SQJwSkgM34hSNp/8W5+Ia+Pfb8ZgFDhqxUvxpagg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BPixbpfDDPrwwq41BpLv1vLcSOtRp/c/6eDs+2tFJZBsiNmcwkm1qM3LY3jTisqiEvTALSb5owtTCxJ3v5rDvIZ9oKIqPKqQLwM046yNH9rI2iEYbEhS2KwrDVNxtxD1mBFD55CwK/cQ2nFECOz4KMzajAzJ5BUVVigy0bw8jfY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LIUPMUkh; arc=fail smtp.client-ip=52.101.56.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fx1QtxtEfiLKb3UFLgUtZCanfKdlJVsapcZUh0A2TsgXvvTtPWGm8ugbpiv4gSl86A1txRwngxxBtE+oxzHugPasyurOYFRg+hVDStY8OL6K3R+KVhdcXwSPdN6AjruSdBhNEjZsof9BlVoMWbesGJML6KEre8Wsz/GVTovAtoXqp6j5KP+kWjjFPGvGqVbSqbzmoPUc1JZMhLrkL+/k1Mi9J5ldBM1R808bK3yJtpXNPk84enFK7BnBkXT6iwaD+K35kIu9Qn8gd3JxVcngS8lAjYv/6d9OFxz/pHEQVLmFpgwfIt4gH7y0nRhy7GLAocCTGtZNm1SlbC7ONYprXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HeSfSdri0VkXVVAOjkc9Inj9ao04BkmJRwvso5QMS7Q=;
 b=VltluH9dn6eccfI2oRS68iZWoTaf3tgDbqcaZ+11TkX1+3jjWXlZzFKI+NpEVl/Gdq4P5LOvdp/Wb3Fe3h+wdOvRa1Jh5VylvKCFdSvVHY5TFJH0KnYZqPcYcolKfT0Chv2GpGpXSl0msdQANa4vpT0DfmFV8Gc0JZs4ZtOb78/pCg+KNdiXLXILTwQQ87IAeWLV+54RAW9GXfoJ7T/QM/SFKskRUv1/qCL1MkktwV4pxxxSPLHT4ADOCTSWr93vj3lJIsB4tN2EOVS0r3OYm7a96qHz9SLSvEWtU9c6Damt0c44Qf05T6Y2kpXVh6YFUK1skCG9I8sg9VeoJYP/Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HeSfSdri0VkXVVAOjkc9Inj9ao04BkmJRwvso5QMS7Q=;
 b=LIUPMUkhoBaADU30X5haV1bZ2eXdaWseg+Q++fd+VlZGeOmFxkwe1Jt98tkLX5jZhMO9PwuNmrwKqug1v3oMff2KMBKEQeLsmrdp3GxrNLndPbSnwTGnHDK6KK7qIkt+FHxB5W+O/e+lXaBTYSZ3RfPJX9NYSAEJ8QKoQwLN+Qg=
Received: from MN2PR12CA0003.namprd12.prod.outlook.com (2603:10b6:208:a8::16)
 by DM4PR12MB7504.namprd12.prod.outlook.com (2603:10b6:8:110::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Tue, 17 Feb
 2026 20:11:30 +0000
Received: from BL6PEPF0001AB57.namprd02.prod.outlook.com
 (2603:10b6:208:a8:cafe::e4) by MN2PR12CA0003.outlook.office365.com
 (2603:10b6:208:a8::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.13 via Frontend Transport; Tue,
 17 Feb 2026 20:11:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0001AB57.mail.protection.outlook.com (10.167.241.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Tue, 17 Feb 2026 20:11:29 +0000
Received: from nigeria-2635-os.aus-spse (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 17 Feb
 2026 14:11:28 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <peterz@infradead.org>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <ardb@kernel.org>
CC: <pbonzini@redhat.com>, <aik@amd.com>, <Michael.Roth@amd.com>,
	<KPrateek.Nayak@amd.com>, <Tycho.Andersen@amd.com>,
	<Nathan.Fontenot@amd.com>, <jackyli@google.com>, <pgonda@google.com>,
	<rientjes@google.com>, <jacobhxu@google.com>, <xin@zytor.com>,
	<pawan.kumar.gupta@linux.intel.com>, <babu.moger@amd.com>,
	<dyoung@redhat.com>, <nikunj@amd.com>, <john.allen@amd.com>,
	<darwi@linutronix.de>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH 5/6] x86/sev: Use configfs to re-enable RMP optimizations.
Date: Tue, 17 Feb 2026 20:11:19 +0000
Message-ID: <88ddc178dcab3d27d6296e471218f13a4826f4a8.1771321114.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1771321114.git.ashish.kalra@amd.com>
References: <cover.1771321114.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB57:EE_|DM4PR12MB7504:EE_
X-MS-Office365-Filtering-Correlation-Id: 94598225-bf98-4a1d-e5b0-08de6e60bce3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?g52DwhbaMRMZnkPiYrIPJCfpzqv6y+BcMsXZauCV62ryD34aZ5kKI8RPnZIi?=
 =?us-ascii?Q?FLlaO9z0BQSckqnUc7zE56XPR70bIKmXm6AtU1ofcmGARN6adQicYlype44q?=
 =?us-ascii?Q?acbGW5j4BhmihCODofh2g9kLBkF0w9q7WsVk5v6qbJK0Az94PepapLUzmVc0?=
 =?us-ascii?Q?ovtYunArhy5jZ1Aa2pNbj0NdyieJDbBnVfY5jSPkRH6HMTdNDVZGh0OgZeen?=
 =?us-ascii?Q?U22adrr3eTj4TV/cJy9pSwZagldntfIaCHJC/+dpGQ/e2rxKkk5hQrNWRZh4?=
 =?us-ascii?Q?gjcReEqrmbKCPpDm7jstySCcIbKSFc0jiVTotL7OzDYmRR2vOsb8IvaBgyqo?=
 =?us-ascii?Q?CCCbt6NLRvYTGNzVZmwXmeV/1MEK3Aeyr6oagIMJJVosIFcE5xVjDVNfL2R1?=
 =?us-ascii?Q?5CV5N8TbF8pWh7FR4085PoGZLpIrKPI4V6eyKqmk7xefUqzigmz++B+oSXTz?=
 =?us-ascii?Q?bshGGxlHonb34aEyn45bKlK458Or+Xx1ebrbkLHq+RYFfZvSYA+R2TwHzADN?=
 =?us-ascii?Q?i5hm3cPO+yXbhIE/y7JcRZ5j00VvcvvTqAWyviNagPusGWqHnirRwBQREq9K?=
 =?us-ascii?Q?tAL/kcgWuYbAEVx0u98MNhVXBRJiXBs9gyRUO43AjaYwm9EEt7OJ1Jgh9q8k?=
 =?us-ascii?Q?oAtJdflrGz6J5UVMkaRgb9cVthb1Ku1xpqYu4W+ixMixzg/GNUdKqnn50MMN?=
 =?us-ascii?Q?e+8ckxDP3suSch25F5loYYeHEAnLMtgP7Pw+nZu1pI1YbjcM4AU6XMNbLtVb?=
 =?us-ascii?Q?A9BV3p6CwnSavv4mM4cwA/rbELccezLoyBVG98ymPVjn2DEHeCe6czVchCKy?=
 =?us-ascii?Q?W4SWLaShz0hvwlEgjiZXnLBZCsTVSErcc+B6Nq8MXVmrCshlkEg4uidOyr7f?=
 =?us-ascii?Q?zDutgIe2hRbbMTaSiwLlc6L1zSxeJUTBDZZ8dP/wmhihpFYXRAB7KaB/zJUy?=
 =?us-ascii?Q?UhzQ/A9pi3Vf5Zois/6WGj6xvPnPQFgyeQw3SwynRQCthxLcfmHcUC2D9OG8?=
 =?us-ascii?Q?I52dXrO20OlY7v7RK4eVWmrq5Ml8xjeWOoV0MxpCKFE/sIBQvU+klBI7XQys?=
 =?us-ascii?Q?QRIcAz+FbN+KonxMHeMVnWtk0OfkKcDSK1rkTvtH5DomYE3vQfmL/tsNA6XQ?=
 =?us-ascii?Q?BLFiYOlk1ierc69P4O7JHhBo3EHNmnP3zT+96GW06ywWE0zBFITsDlG+Uq4c?=
 =?us-ascii?Q?4FIa0wOf8FdhlkakdD+8KB/7fw5d4f2KT/wcYTIU5TIKJ+/JgZYbTYkw1unZ?=
 =?us-ascii?Q?2y/9JeX3UdqqJ/D7Lo0J/dhYj+Rth2PDvbN9tmg4bewSrKuVMcdhbG9C+pDl?=
 =?us-ascii?Q?Id3xOlZCp45M5NtIeXlwbImrDYj+pZNk0T3G0FDGwzXY81StFqaSX+Xq6DSj?=
 =?us-ascii?Q?okSuVLME496wAMzfCuMyitjuXkETbCDKZmeI8AkIeneMdaUk1x9D65241v9f?=
 =?us-ascii?Q?D6ADpEeIJ439S/aapxhN/atA7N0cVtP0F8C4a91KDl5Rzbyz0mmkvAeTs7Tl?=
 =?us-ascii?Q?iQZwCAXAZb0bTp3pbXMKzr6HVXGL80x8aYpXeZsLEkqbighRFOb9dX0P8CAk?=
 =?us-ascii?Q?X9mogaPMzk71EhkLW4RZO8TGQWlMGy7z8Gbl7Fyhx24uT48eVknNu1eg0w1D?=
 =?us-ascii?Q?P2qYtvvVADfdC+ziti37zzNGMJXIiT7Nqv2H99Gk8gigTovCXqOwZeXAGzgP?=
 =?us-ascii?Q?5ZL4+EAyaF3svtTz3FbweL2SMeg=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	g37XSC670hltZrZFJd6ZuUMTNyXyriB/XE4PjHMQGaMC+3leEFMcC0f2KvOnEkcPVW6MkEvYRRVLITaz1+sgxyqr6xU1Z/HUNj77cP8vlyNBtXL9WnkYXcDxZ4ufrRkhpyIQ5gNE6Tmclbbp3opQr3Mtwxw75rDHGQ70GtWaAJNwkTCV9tQdwFB8O5kMHOHrWpWawmaAhrzVUCSziTzHw3t3QFFWzNXUxJLW0RcjuNoL5vBxJDfAgLhso8HE+2vBu9pkIDWU/USL1pRTjY/Hx2em8IKomFHIE/aIjOW9wBMM++NHeL6ZNCjaN0Fwj92eNEFkHm9cnnEiP+CRyVwIHn1ib/cFrMGtWyfL2cN8sDdZhkcilfKPsiTz0gx5peKq5fT//Nk0ExVldXuOmYQoDQzyG0u9vAW7gmanhm6tMQu9C18z7fmRkFeifjwCEWK/
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2026 20:11:29.7725
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 94598225-bf98-4a1d-e5b0-08de6e60bce3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB57.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7504
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71184-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_TWELVE(0.00)[33];
	FROM_NEQ_ENVFROM(0.00)[Ashish.Kalra@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim,amd.com:email];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 4517414FE3F
X-Rspamd-Action: no action

From: Ashish Kalra <ashish.kalra@amd.com>

Use configfs as an interface to re-enable RMP optimizations at runtime

When SNP guests are launched, RMPUPDATE disables the corresponding
RMPOPT optimizations. Therefore, an interface is required to manually
re-enable RMP optimizations, as no mechanism currently exists to do so
during SNP guest cleanup.

Also select CONFIG_CONFIGFS_FS when host SEV or SNP support is enabled.

Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/Kconfig    |  1 +
 arch/x86/virt/svm/sev.c | 79 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index d916bd766c94..8fb21893ec8c 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -164,6 +164,7 @@ config KVM_AMD_SEV
 	select HAVE_KVM_ARCH_GMEM_PREPARE
 	select HAVE_KVM_ARCH_GMEM_INVALIDATE
 	select HAVE_KVM_ARCH_GMEM_POPULATE
+	select CONFIGFS_FS
 	help
 	  Provides support for launching encrypted VMs which use Secure
 	  Encrypted Virtualization (SEV), Secure Encrypted Virtualization with
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 713afcc2fab3..0f71a045e4aa 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -20,6 +20,7 @@
 #include <linux/amd-iommu.h>
 #include <linux/nospec.h>
 #include <linux/kthread.h>
+#include <linux/configfs.h>
 
 #include <asm/sev.h>
 #include <asm/processor.h>
@@ -146,6 +147,10 @@ struct rmpopt_socket_config {
 	int current_node_idx;
 };
 
+#define RMPOPT_CONFIGFS_NAME	"rmpopt"
+
+static atomic_t rmpopt_in_progress = ATOMIC_INIT(0);
+
 #undef pr_fmt
 #define pr_fmt(fmt)	"SEV-SNP: " fmt
 
@@ -581,6 +586,9 @@ static int rmpopt_kthread(void *__unused)
 			cond_resched();
 		}
 
+		/* Clear in_progress flag before going to sleep */
+		atomic_set(&rmpopt_in_progress, 0);
+
 		set_current_state(TASK_INTERRUPTIBLE);
 		schedule();
 	}
@@ -595,6 +603,75 @@ static void rmpopt_all_physmem(void)
 		wake_up_process(rmpopt_task);
 }
 
+static ssize_t rmpopt_action_show(struct config_item *item, char *page)
+{
+	return sprintf(page, "RMP optimization in progress: %s\n",
+		       atomic_read(&rmpopt_in_progress) == 1 ? "Yes" : "No");
+}
+
+static ssize_t rmpopt_action_store(struct config_item *item,
+				   const char *page, size_t count)
+{
+	int in_progress_flag, ret;
+	unsigned int action;
+
+	ret = kstrtouint(page, 10, &action);
+	if (ret)
+		return ret;
+
+	if (action == 1) {
+		/* perform RMP re-optimizations */
+		in_progress_flag = atomic_cmpxchg(&rmpopt_in_progress, 0, 1);
+		if (!in_progress_flag)
+			rmpopt_all_physmem();
+	} else {
+		return -EINVAL;
+	}
+
+	return count;
+}
+
+static ssize_t rmpopt_description_show(struct config_item *item, char *page)
+{
+	return sprintf(page, "[RMPOPT]\n\necho 1 > action to perform RMP optimization.\n");
+}
+
+CONFIGFS_ATTR(rmpopt_, action);
+CONFIGFS_ATTR_RO(rmpopt_, description);
+
+static struct configfs_attribute *rmpopt_attrs[] = {
+	&rmpopt_attr_action,
+	&rmpopt_attr_description,
+	NULL,
+};
+
+static const struct config_item_type rmpopt_config_type = {
+	.ct_attrs       = rmpopt_attrs,
+	.ct_owner       = THIS_MODULE,
+};
+
+static struct configfs_subsystem rmpopt_configfs = {
+	.su_group = {
+		.cg_item = {
+		.ci_namebuf = RMPOPT_CONFIGFS_NAME,
+		.ci_type = &rmpopt_config_type,
+		},
+	},
+	.su_mutex = __MUTEX_INITIALIZER(rmpopt_configfs.su_mutex),
+};
+
+static int rmpopt_configfs_setup(void)
+{
+	int ret;
+
+	config_group_init(&rmpopt_configfs.su_group);
+	ret = configfs_register_subsystem(&rmpopt_configfs);
+	if (ret)
+		pr_err("Error %d while registering subsystem %s\n", ret, RMPOPT_CONFIGFS_NAME);
+
+	return ret;
+}
+
 static void __configure_rmpopt(void *val)
 {
 	u64 rmpopt_base = ((u64)val & PUD_MASK) | MSR_AMD64_RMPOPT_ENABLE;
@@ -770,6 +847,8 @@ static __init void configure_and_enable_rmpopt(void)
 	 */
 	rmpopt_all_physmem();
 
+	rmpopt_configfs_setup();
+
 free_cpumask:
 	free_cpumask_var(primary_threads_cpulist);
 }
-- 
2.43.0


