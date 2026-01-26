Return-Path: <kvm+bounces-69177-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cMtkFOTtd2kVmgEAu9opvQ
	(envelope-from <kvm+bounces-69177-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 23:42:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E51D18DFF8
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 23:42:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 472AE302A6EA
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 22:42:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DA0430AAD7;
	Mon, 26 Jan 2026 22:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wGTKTLW+"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013011.outbound.protection.outlook.com [40.107.201.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0B32F549C;
	Mon, 26 Jan 2026 22:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769467348; cv=fail; b=B5jJiq2P+boc459x8hKUs1BdVGtY3j/8fX9vA6k0AWNnJU+NqHFpaXxkI7m8tHP8qxmG5Aq0Er2Jf+yBBONRx+4f5U+Bi7LkbkyEh6gIg2p1+cg2FQUOcLX5ku0uf6JJ2ixiIu2aJdOTV84G6pkutVWirdy5r/+/4Y7efZVjCIk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769467348; c=relaxed/simple;
	bh=m5iZ9atl2TXjAYTmuVZBC0BF7Dq82Skn4LxZPPdKGE0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tV8CzXQNgNcw4sRmqDfeUpZ+SZBLFNiiwPsb/f6XEahMUso59tijqQc/U/D/p1e5cnzxYFuMJQZgRgFeVNake3blejfXLQt3nTMGgbBQoEEvEVUbHvcqRnNvQsKUYBCprD7bW96G1ARfFV/q1GvOEnE7yRTKdq7+/Kl2U4a7Sk4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wGTKTLW+; arc=fail smtp.client-ip=40.107.201.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I3kMp0D6YDCMNGsz1hAO061CJRFuSUrnuIZeIlLynf1Z1fOObA6/UDTcn3f/CoJf1fM0Rn5vY0AeA0hC+lNlwaECzrA3+av0DfRvjqN22Z9+vQLZ1K2lcNKUV0ziQmxkKSxkvNpXZLFsvH2lPOqvt9wIO7xmqdrsGOsYkGr2Os0WarCu8F8rFvcnTnAh2dJOdEbmwpFJdRL0QPu9Gw4W9PL+xziL+HjiNcaAWaClrZJo0G2hRZskvM2Un9NIA2zsCxo6apQG7IjnI0CcO2mRB2sNVy2BAo4LskrL2Qj9fh0YAXaMuR25eXoNxPCh294EIDDRylu2GysW9jlSGx2obA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sKn9V449gghH/entdm1UFsWvj9I/XJLtcu7oujF6llY=;
 b=q9Cqrb6EJFn375id8ZzwVig/klPqKKv21JIm/vyQ0KLleYfgtzAK0qjTrRd7GmzwUcQx3MngavaSycjovFF25fAljyZvaFE5VlGviR9oclkEtxPFneVuOUt65RwQLKGmLOZc6E9UjG2R3cdWZz34ByW/ZErPXBpUSf9XdH/3NpJ+DycIFDUNoBTQGC397yXjOR4FGZr990M5p1v2jI6hHyRL8u8GtCg4LvchgoMrG9PzFeto3DUE9ob7NXtzk8+fqW+DlGMNoTJY9lgs5VqUbiMkDNDhGkL6d+kG96Y929XY5KMSHKfnquqemz8WPIpe6+1t5zDDRqF+HVcoXrd2Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sKn9V449gghH/entdm1UFsWvj9I/XJLtcu7oujF6llY=;
 b=wGTKTLW+3re58FAzmqoijHFqZIxcNOoXyb6GbLC0loqz/gP78CEVwf6pGShvjvrPTKURhqtgiqB4IP64I5tfl9yllM5TbVGyMRzXXon135ardJk5DHf58x9/fszjKg9Gzb+zH5aRTEKBkrgb+SDfkypu1Ggrk0LvhboGNjpuLnM=
Received: from BN9PR03CA0752.namprd03.prod.outlook.com (2603:10b6:408:13a::7)
 by IA1PR12MB6067.namprd12.prod.outlook.com (2603:10b6:208:3ed::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.16; Mon, 26 Jan
 2026 22:42:20 +0000
Received: from BN2PEPF00004FBE.namprd04.prod.outlook.com
 (2603:10b6:408:13a:cafe::d8) by BN9PR03CA0752.outlook.office365.com
 (2603:10b6:408:13a::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.16 via Frontend Transport; Mon,
 26 Jan 2026 22:42:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF00004FBE.mail.protection.outlook.com (10.167.243.184) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Mon, 26 Jan 2026 22:42:20 +0000
Received: from gaul.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 26 Jan
 2026 16:42:18 -0600
From: Kim Phillips <kim.phillips@amd.com>
To: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <x86@kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, "Nikunj A
 Dadhania" <nikunj@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, "Michael
 Roth" <michael.roth@amd.com>, Borislav Petkov <borislav.petkov@amd.com>,
	Borislav Petkov <bp@alien8.de>, Naveen Rao <naveen.rao@amd.com>, David Kaplan
	<david.kaplan@amd.com>, Kim Phillips <kim.phillips@amd.com>
Subject: [PATCH 0/2] KVM: SEV: Add support for IBPB-on-Entry
Date: Mon, 26 Jan 2026 16:42:03 -0600
Message-ID: <20260126224205.1442196-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBE:EE_|IA1PR12MB6067:EE_
X-MS-Office365-Filtering-Correlation-Id: b6b1d79f-6a8e-435d-0fc9-08de5d2c2a76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eRn4uMQLHUeRpdOSJ0aRiaEWY+4MgMw6aZ0xG0ZuG+VlE3htk1D9iMfEcsqP?=
 =?us-ascii?Q?ASgjS2HqMlkBZyc6d+RHTDc71OBjkiJdrZxVZQy8DWfedHkLx75CXktmQ3pB?=
 =?us-ascii?Q?zD3xEDhBv9+hxt8tngXfL5LJxdjz1EE/MxsQSEaLwu4jsJs/3+w6g/JgGTQc?=
 =?us-ascii?Q?W6xlnqHQMFOjv9dTnK0IhcaioQgKC54hdKUaTk7mF6zbL/mDypA7UVHJFUkx?=
 =?us-ascii?Q?RtihfhothDoSqL8seSOms5JIt8WLeIMoHr76L6V42xcUXEf5834fMif/IQXb?=
 =?us-ascii?Q?ZuVjvkl9QiwjDtcN3+EgsAmbXrM38waaPp4zljqUjbXQ1rsKZPmxkzWNtlcz?=
 =?us-ascii?Q?V5Zjhjl6aFntkOX8cEMiwABI6Hpw91Hey4tXEDt39AduoWmoqeqtleXONJ6w?=
 =?us-ascii?Q?P+Q//BHdiY7eE8SSSELZtUzRRpJ2r4ql9lZtcSpVxagfbs6UPDMrgUuwlHPg?=
 =?us-ascii?Q?WLe8y5kdVWTOn7OfGu6gDYafg4wEEh2YKnp2rWh9ofRET8RxYJUCmYvKhDzr?=
 =?us-ascii?Q?bpu2frsSsb90Aju88T9nRMGgsjL3Bau5SPg8vb5t8W0ykRZqcSEhX0GSvA3H?=
 =?us-ascii?Q?5tJf1JMWKyzAdG3klV3rwt5FckKZYhPnoqz2FyWu0d2CN/5i8rSjb/E9PlKr?=
 =?us-ascii?Q?E0XXvCYAd7PStuzNfjHbHv61sr4kgUBw5mwjf2DShaNdAf/x5AiKtohjzB6T?=
 =?us-ascii?Q?fv7NOGBh9R/jCNRyIB+KxNaXk8A2hmuIM4MQs5se9SxQkBBCglJlHZRhU174?=
 =?us-ascii?Q?+KRc0nNxIl3s5zJZKUtRAdSfXTAB/dXGuZYvmEF0JXIVOFj+d2f1ipV8KGAy?=
 =?us-ascii?Q?A1dIfKBWouHo19MWI8O+Pj5v3XI3aA79W9sfvSWhj1Hj8IkmCqNFunHXhCMR?=
 =?us-ascii?Q?BMdnV4auQE8QIPoZsAF4HzUmYe2QqMniiLOJN6F5lAHFHxmnOAofo9d04rf2?=
 =?us-ascii?Q?O8kinzSUz9eIA3hPDWrGYa/ymBhJ2W+Kcvmm4XR/iPtEYz45ChiRvNrrPrRU?=
 =?us-ascii?Q?BpnayO6IPzYPkLdPjly4WbBV7axbkehIXKB4YOqKkllc2WkRZ1AbF+zu4smc?=
 =?us-ascii?Q?x+dw7DWAq5GxoOHhz57W5T0gZa6g85t67qZg7zmfoNtlV1nr+es/dRdbl3lc?=
 =?us-ascii?Q?ZbKYt6HEmn6VhhSTuHpE+vAsrqVb55xoysLYAjTuJqhrHQ+kz3VlW+UNSkse?=
 =?us-ascii?Q?fPLBuK7CfvhLvtUp9Spm8Vu4zOVc0SK4JAsIzFwlfsxctMfKL6bDGl1wSs7c?=
 =?us-ascii?Q?IwmlQR0cZP/xOrYOT6ObCE3lZ7NtCPFD0Nu4eUoywfZ2odJscFN5VYlIINZ/?=
 =?us-ascii?Q?UqIcNblXDx1UleJZsmOPj/ZeF3ZbPWxIkOwjh8zpD3/nyZQs/a2zYovC+U1i?=
 =?us-ascii?Q?1j0iVzCpvFvUYCDqksyTHq3BKLTHGQdjvZCsIhur+NmLx/4Ray0t7XNN66tz?=
 =?us-ascii?Q?ZHvFogG9xPAU8Q0jwMtg8KmncOL3P6CBskzp8GlFyitFFeRaHVLYavhg+rQD?=
 =?us-ascii?Q?8NuR3vBZa9uiIAgt1IkuN35GtTvsneWT+nth2P9FPrIKDQEBMkrdpwoyJBQt?=
 =?us-ascii?Q?oYyoffttssCrsK+4Y86l3LojbIM1CSXF+bCF+5iWW8AHr4wImwnxLIRnLv0y?=
 =?us-ascii?Q?RY66y98tnwmlSg7zCUXyumq4bq4+Q76qB/YrZPRO3BiRqrxbZtQUGtFPeBzx?=
 =?us-ascii?Q?9KC9YecLQ1spoIyke/XBxkpNR/M=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 22:42:20.5090
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b6b1d79f-6a8e-435d-0fc9-08de5d2c2a76
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBE.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6067
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69177-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kim.phillips@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[amd.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: E51D18DFF8
X-Rspamd-Action: no action

AMD EPYC 5th generation and above processors support IBPB-on-Entry
for SNP guests.  By invoking an Indirect Branch Prediction Barrier
(IBPB) on VMRUN, old indirect branch predictions are prevented
from influencing indirect branches within the guest.

The first patch is guest-side support which unmasks the Zen5+ feature
bit to allow kernel guests to set the feature.

The second patch is host-side support that checks the CPUID and
then sets the feature bit in the VMSA supported features mask.

Based on https://github.com/kvm-x86/linux kvm-x86/next
(kvm-x86-next-2026.01.23, e81f7c908e16).

This series also available here:

https://github.com/AMDESE/linux/tree/ibpb-on-entry-latest

Advance qemu bits (to add ibpb-on-entry=on/off switch) available here:

https://github.com/AMDESE/qemu/tree/ibpb-on-entry-latest

Qemu bits will be posted upstream once kernel bits are merged.
They depend on Naveen Rao's "target/i386: SEV: Add support for
enabling VMSA SEV features":

https://lore.kernel.org/qemu-devel/cover.1761648149.git.naveen@kernel.org/

Kim Phillips (2):
  KVM: SEV: IBPB-on-Entry guest support
  KVM: SEV: Add support for IBPB-on-Entry

 arch/x86/boot/compressed/sev.c     | 1 +
 arch/x86/coco/sev/core.c           | 1 +
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/include/asm/msr-index.h   | 5 ++++-
 arch/x86/include/asm/svm.h         | 1 +
 arch/x86/kvm/svm/sev.c             | 9 ++++++++-
 6 files changed, 16 insertions(+), 2 deletions(-)


base-commit: e81f7c908e1664233974b9f20beead78cde6343a
-- 
2.43.0


