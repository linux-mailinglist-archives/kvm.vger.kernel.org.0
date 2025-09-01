Return-Path: <kvm+bounces-56401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E7CBB3D88B
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 07:17:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13875178718
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 05:17:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFBCE1F37C5;
	Mon,  1 Sep 2025 05:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xqHVGgSD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2045.outbound.protection.outlook.com [40.107.244.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0C833D8;
	Mon,  1 Sep 2025 05:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756703851; cv=fail; b=atnJNnF2ve8TboYd2i3z2H3Cp6FSz9bA9kjnHeU+HhtcrX6cdlAq92kzzxr9d1wnNm89PeslgUJl90f+W3zUo84SE3iTpT6xEOsQtwDoqR9ODu3TnDt4XttTvmZlm7p37K/t/xw3bTrwwpcB+GCzEYVedXbUn6wjjr0jynCIIuo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756703851; c=relaxed/simple;
	bh=IIlW6hGCGqoPt1W/k1inIqzwsu5gfxiGkM+Lo9vH29Q=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LqP43uB+Kot0wW+Nxer5A+NQul7Pd1zaOe4mbKYqaEkU6h/ACckHADRruzyWqopDkbdRhBXbqZim2oUwXlFOZZlJlrQbH+jpbx2wyQJCqzAqa1twibczMd4avaXfw5nH9C8ouBCXShDr1lEGoYfJbp1hHJEV8Hn60OWuCnFgaQc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xqHVGgSD; arc=fail smtp.client-ip=40.107.244.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hT4DSVT+rz6YTbDnVUBOh1Dfn5kRQ1lh3IEXt2C7DVPK3BNphKfS1d0CLiIPPDVWtvs9N2QoYrugpddOysOgXbumX6tqHfUUmMg4s/RXlxw7fgHf2CfP0esHJWrxJjBM6cIKC9/PkLnt5c7HcBraSt2KP4GnpeFp5as6hH9cejpnsEvg8NbgmX7f+3xcuLiAFykUUtUOgJMmQ4JW5rwwOsSCtJoAulMWLOv81e2Q2cPJU18OJLdMVWeNSC7ZYLEKDz76PWqMtecC6H3n7PjSF/bSg9Po+Ew608Fv+HHSejOOJBdNMsVA+2JDbnwoOEC2dRg2lf8QEzYTc9vTwr5COg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cs3h/o4At6baVzLjyQPbLkuN73POeWEn2hJzboUIeDA=;
 b=zEsB3tFnP1wAI4KbqJCAum1T5aGluCPKZcxpJZeRBv+AAxeHdkj29Gd04pdclUAlbalbvr2V1vgnmLGUt+E2+PQU7hbRJcIPtwnBnBW8e9AjdXz2C4vdTlC0fue7QvvmLORbVqZuw9GRMhvtQjtOw0AwE282rGydp1/RDW7Q+l0+Oj9pDOV+SDxY8AtIgyBFfF4NfTxkABmqQfBmKMFcAX1p9prCrPX2PF7s3nLOej8lAJusSt3/MYS0LloBdE81JOY7iOC9n/WrQZvHNgBhImEoAU9BSQqjKLxHs9aZceLDaiveu4Uq89WNbkpBXXiKRomrRwb9TuTIgSwlIxMm+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cs3h/o4At6baVzLjyQPbLkuN73POeWEn2hJzboUIeDA=;
 b=xqHVGgSDyV3vBOI+UrKuOtZ1Q77bOHfAt85iJ83NEFTRgE0d3JoYuc02NJyNIyH+2yPDbo2nZIEc5L8dL700V9ZpIeJTmajx2XXfOjUD4aUaECVARMYhwtJTLKMzUj5mGxg2yq4Ijzj3Z6/Q6iM/lVNQyac87G+qgKreM9kTEkc=
Received: from BYAPR08CA0002.namprd08.prod.outlook.com (2603:10b6:a03:100::15)
 by IA1PR12MB6434.namprd12.prod.outlook.com (2603:10b6:208:3ae::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.21; Mon, 1 Sep
 2025 05:17:24 +0000
Received: from SJ1PEPF00002310.namprd03.prod.outlook.com
 (2603:10b6:a03:100:cafe::3d) by BYAPR08CA0002.outlook.office365.com
 (2603:10b6:a03:100::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.26 via Frontend Transport; Mon,
 1 Sep 2025 05:17:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 SJ1PEPF00002310.mail.protection.outlook.com (10.167.242.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Mon, 1 Sep 2025 05:17:23 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 1 Sep
 2025 00:17:22 -0500
Received: from BLR-L-MASHUKLA.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Sun, 31 Aug
 2025 22:17:18 -0700
From: Manali Shukla <manali.shukla@amd.com>
To: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-doc@vger.kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>,
	<manali.shukla@amd.com>, <bp@alien8.de>, <peterz@infradead.org>,
	<mingo@redhat.com>, <mizhang@google.com>, <thomas.lendacky@amd.com>,
	<ravi.bangoria@amd.com>, <Sandipan.Das@amd.com>
Subject: [PATCH v2 00/12] Implement support for IBS virtualization
Date: Mon, 1 Sep 2025 10:46:44 +0530
Message-ID: <20250901051656.209083-1-manali.shukla@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002310:EE_|IA1PR12MB6434:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e617872-290d-4289-5d67-08dde916d54f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QlMwb3lCVXBuNXd3NmtWUHR3V2NaN1ZIYlBSajROTHJjWnpYM2YrREh6Yy9W?=
 =?utf-8?B?ditjMUpaelNEUUNKblExdWdETzJMendIMzQ1TUlHSHNFQU5wWklSbi9vdW5y?=
 =?utf-8?B?S3Z0Nnk0Mjc5Q3c2c1laUWxOM3FiVHF5enRGeGlsY2dKK3I2UHovVzFDUFIz?=
 =?utf-8?B?YzI5NVZKKzhYOFNxTGtCaDhNZTAreHVpNno2cXdkOVdIaGhBbENldmZRZkFl?=
 =?utf-8?B?NzFlYlJkQ1NIQzd2MmFPYVhHc2NQRk51cHlOdFVVZXpleS9yMGJWZS9FWEpx?=
 =?utf-8?B?djdvNm1qa3FzcTJRSXE2UjZhMUl0R1V1VTA3MHNoZDBaSGdBUC9Rd0lLQ0FT?=
 =?utf-8?B?Wm9SZ01vTE03ZmliTzkvK2xsOGtDUFdrdEFzRURqQXBXQ083REk4VmpHc0pw?=
 =?utf-8?B?a2dOcTA1QjBjQnd6ejZpUDN4U0hSVmpPa25qVmhJSWRpZWlmVVZLbUtuM0Ny?=
 =?utf-8?B?T2kvNENyL2FWYU1jRW1vUlZPclBXN0g0KzhVWTNyK0hFWmFsVFZMa2QzQ3E3?=
 =?utf-8?B?OUVXZGw4cmpSUy9ZRWxuMlZhb0h2b2hLOU44a3kvZSsrdEZZajZNSUxzbW11?=
 =?utf-8?B?Mmd3WGtVWERHZkFTVTFjcVNKUERPdVUzekNNN3c5ZVQyMnlNWjliUW9BaFFw?=
 =?utf-8?B?ekJjNWVaOWVXditCYWtqbzlBME9PNnJmKytUZk1UN1Juek1PYVArUUdHZzFm?=
 =?utf-8?B?QUVNbnpXaFJWYk5PVlNRRSs2M3hHL1pPazZIbmpZQmh0aUNMU0dVQ2g5U3Mv?=
 =?utf-8?B?dDJDYmJsa2ptMzMxSFl5UEtvUkVYdUF4SmZrNXYrYXZtYW1Tb0xSSmlIdkdN?=
 =?utf-8?B?ZEJubngyQnQ2bExKZXZLMzN0Nkdxc09ZajJjMkJUUVhhL29WZHl0TzF6TnEv?=
 =?utf-8?B?N1RSV1hMRkZDc25PNnA3ZHNDWDBhVFhXRUp0ajE5TGRPMGg4NldPcUZXWU1w?=
 =?utf-8?B?b0FPVS9ZL2Z1R0o3azVkWWE5alpDcmNLa2w4NEVZL3RUbHJmQzZoS2swUVg4?=
 =?utf-8?B?aXlwcHlwcUhDcXJWODRXaUQzUWVQZDNod2QxMm9ielJDR0taWVU1RUNnbDNE?=
 =?utf-8?B?L0p3RGdVQXlocW9qV20yMzh4TGc0TkRvR1FJWjRScTlsdzBKYnF6aC9SeWpV?=
 =?utf-8?B?c0lQejF2M2lUdW9jbTE3QzBoWHBZUjNCT0c1VDJnSG9DOUZaVGV3TkhJZGhY?=
 =?utf-8?B?di9FOXFCR0ljYS9xQXZxcDVudEhVYkdkaSs0YUgySm9pR0JkY0JCQ005anpP?=
 =?utf-8?B?ejFBYkorQTR5T2k1SHdOZ3ZiQnFGSnpLUmgwVlZOeE5sUCtldWdPV2FDa0w3?=
 =?utf-8?B?d045UDQwV2k5ZkhTYUYyNG1FME5NVjJMdU85N0VteUthblpCdUpZc2lDb3FS?=
 =?utf-8?B?QnFxT2FaQ25XNG4wV2c0Nk5WUnYzZHFIdVdoR0lJbDQzd25YcDRKT2o4M3N2?=
 =?utf-8?B?VnFUczNkVW1FR1h3dHhkbnNwWEU3dldPaCszTzJxOFFvMFlsN0UwRURkQXNk?=
 =?utf-8?B?RzdkandWcCtyQ3l3MHpjRFFlVUJnS28rd1JvUk81SWNDaGJHZ3l2ZEh3bWQ3?=
 =?utf-8?B?bzVZdGlHMDEvQWJPWm0yRlgrY1dPUHJ3ckVUNS9SQU5IQXRrVzB5dDNLM3Qz?=
 =?utf-8?B?QmlDZkpRdjVOd29aWGJUVHJtck5QQWhJWHhXbEhjYzVDUXBLUHlnTU1UdjJq?=
 =?utf-8?B?YWVKK3o4TkhoUXhFWjU1ZjNxeDdLZHVSOU1yd3d0aXpRNFVNek8zdytKSVk5?=
 =?utf-8?B?MWNaR0M2dG5VaitwaVM1RUZmbUNqRk5VZ1I3OS83NXpkQ2xxczc1amc0V1Fk?=
 =?utf-8?B?aHFkbVJJSC8xSzlUdHNIR0tLNnNpKzdrQ2t3S09QcUxCUG4yNEhoTXpPamtM?=
 =?utf-8?B?QVRkdHJwUnpUbERKeWh1S2E5NjY5MmV2TERTbFZSUHViYlc4V2V6TndnWWFR?=
 =?utf-8?B?TDI5dUdMSW1idExJZzMvaFNrdTAwNVpzeU5vcXdQYjlpdUhTQTFsL1ArNTh0?=
 =?utf-8?B?M2JGZHNMR1NOQlBWQ1JpVDhod0toZnJNbHdIdEtmT0lPeXlkNFU2YzRXVjYr?=
 =?utf-8?B?M3FaYyt5Z2lDeVJBT3h6eTNXQ2lKSlFSUmFDQT09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 05:17:23.2382
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e617872-290d-4289-5d67-08dde916d54f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002310.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6434

Add support for IBS virtualization (VIBS). VIBS feature allows the
guest to collect IBS samples without exiting the guest.  There are
2 parts to it [1].
 - Virtualizing the IBS register state.
 - Ensuring the IBS interrupt is handled in the guest without exiting
   the hypervisor.

To deliver virtualized IBS interrupts to the guest, VIBS requires either
AVIC or Virtual NMI (VNMI) support [1]. During IBS sampling, the
hardware signals a VNMI. The source of this VNMI depends on the AVIC
configuration:

 - With AVIC disabled, the virtual NMI is hardware-accelerated.
 - With AVIC enabled, the virtual NMI is delivered via AVIC using Extended LVT.

The local interrupts are extended to include more LVT registers, to
allow additional interrupt sources, like instruction based sampling
etc. [3].

Although IBS virtualization requires either AVIC or VNMI to be enabled
in order to successfully deliver IBS NMIs to the guest, VNMI must be
enabled to ensure reliable delivery. This requirement stems from the
dynamic behavior of AVIC (This is needed because AVIC can change its
state while the guest is running). While a guest is launched with AVIC
enabled, AVIC can be inhibited at runtime. When AVIC is inhibited and
VNMI is disabled, there is no mechanism to deliver IBS NMIs to the
guest. Therefore, enabling VNMI is necessary to support IBS
virtualization reliably.

Note that, since IBS registers are swap type C [2], the hypervisor is
responsible for saving and restoring of IBS host state. Hypervisor needs
to disable host IBS before saving the state and enter the guest. After a
guest exit, the hypervisor needs to restore host IBS state and re-enable
IBS.

The mediated PMU has the capability to save the host context when
entering the guest by scheduling out all exclude_guest events, and to
restore the host context when exiting the guest by scheduling in the
previously scheduled-out events. This behavior aligns with the
requirement for IBS registers being of swap type C. Therefore, the
mediated PMU design can be leveraged to implement IBS virtualization.
As a result, enabling the mediated PMU is a necessary requirement for
IBS virtualization.

The initial version of this series has been posted here:
https://lore.kernel.org/kvm/f98687e0-1fee-8208-261f-d93152871f00@amd.com/

Since then, the mediated PMU patches [4] have matured significantly.
This series is a resurrection of previous VIBS series and leverages the
mediated PMU infrastructure to enable IBS virtualization.

How to enable VIBS?
----------------------------------------------
sudo echo 0 | sudo tee /proc/sys/kernel/nmi_watchdog
sudo modprobe -r kvm_amd
sudo modprobe kvm_amd enable_mediated_pmu=1 vnmi=1

Qemu changes can be found at below location:
----------------------------------------------
https://github.com/AMDESE/qemu/tree/vibs_v1

Qemu commandline to enable IBS virtualization:
------------------------------------------------
qemu-system-x86_64 -enable-kvm -cpu host \ ..

Testing done:
------------------------------------------------
- Following tests were executed on guest
  sudo perf record -e ibs_op// -c 100000 -a
  sudo perf record -e ibs_op// -c 100000 -C 10
  sudo perf record -e ibs_op/cnt_ctl=1/ -c 100000 -a
  sudo perf record -e ibs_op/cnt_ctl=1/ -c 100000 -a --raw-samples
  sudo perf record -e ibs_op/cnt_ctl=1,l3missonly=1/ -c 100000 -a
  sudo perf record -e ibs_op/cnt_ctl=1/ -c 100000 -p 1234
  sudo perf record -e ibs_op/cnt_ctl=1/ -c 100000 -- ls
  sudo perf record -e ibs_op// -e ibs_fetch// -a --raw-samples -c 100000
  sudo perf report
  sudo perf script
  sudo perf report -D | grep -P "LdOp 1.*StOp 0" | wc -l
  sudo perf report -D | grep -P "LdOp 1.*StOp 0.*DcMiss 1" | wc -l
  sudo perf report -D | grep -P "LdOp 1.*StOp 0.*DcMiss 1.*L2Miss 1" | wc -l
  sudo perf report -D | grep -B1 -P "LdOp 1.*StOp 0.*DcMiss 1.*L2Miss 1" | grep -P "DataSrc ([02-9]|1[0-2])=" | wc -l
- perf_fuzzer was run for 12hrs, no softlockups or unknown NMIs were
  seen.
-  Ran xapic_ipi_test and xapic_state_test to verify there was no
   regression after changes were made to the APIC register mask
   to accommodate extended APIC registers.

TO-DO:
-----------------------------------
Enable IBS virtualization on SEV-ES and SEV-SNP guests.

base-commit: 
https://github.com/sean-jc/linux.git tags/mediated-vpmu-v5

[1]: https://bugzilla.kernel.org/attachment.cgi?id=306250
     AMD64 Architecture Programmer’s Manual, Vol 2, Section 15.38
     Instruction-Based Sampling Virtualization.

[2]: https://bugzilla.kernel.org/attachment.cgi?id=306250
     AMD64 Architecture Programmer’s Manual, Vol 2, Appendix B Layout
     of VMCB, Table B-3 Swap Types.

[3]: https://bugzilla.kernel.org/attachment.cgi?id=306250
     AMD64 Architecture Programmer’s Manual, Vol 2, Section 16.4.5
     Extended Interrupts.

[4]: https://lore.kernel.org/kvm/463a0265-e854-4677-92f2-be17e46a3426@linux.intel.com/T/#t

v1->v2
- Incorporated review comments from Mi Dapeng
  - Change the name of kvm_lapic_state_w_extapic to kvm_ext_lapic_state.
  - Refactor APIC register mask handling in order to support extended
    APIC registers.
  - Miscellaneous changes

v1: https://lore.kernel.org/kvm/afafc865-b42f-4a9d-82d7-a72de16bb47b@amd.com/T/

Manali Shukla (7):
  perf/amd/ibs: Fix race condition in IBS
  KVM: x86: Refactor APIC register mask handling to support extended
    ranges
  KVM: Add KVM_GET_EXT_LAPIC and KVM_SET_EXT_LAPIC for extapic
  KVM: x86/cpuid: Add a KVM-only leaf for IBS capabilities
  KVM: x86: Extend CPUID range to include new leaf
  perf/x86/amd: Enable VPMU passthrough capability for IBS PMU
  perf/x86/amd: Remove exclude_guest check from perf_ibs_init()

Santosh Shukla (5):
  x86/cpufeatures: Add CPUID feature bit for Extended LVT
  KVM: x86: Add emulation support for Extented LVT registers
  x86/cpufeatures: Add CPUID feature bit for VIBS in SVM/SEV guests
  KVM: SVM: Extend VMCB area for virtualized IBS registers
  KVM: SVM: Add support for IBS Virtualization

 Documentation/virt/kvm/api.rst     |  23 +++++
 arch/x86/events/amd/ibs.c          |   8 +-
 arch/x86/include/asm/apicdef.h     |  17 ++++
 arch/x86/include/asm/cpufeatures.h |   2 +
 arch/x86/include/asm/kvm_host.h    |   1 +
 arch/x86/include/asm/svm.h         |  16 ++-
 arch/x86/include/uapi/asm/kvm.h    |   5 +
 arch/x86/kvm/cpuid.c               |  13 +++
 arch/x86/kvm/lapic.c               | 152 +++++++++++++++++++++--------
 arch/x86/kvm/lapic.h               |   9 +-
 arch/x86/kvm/reverse_cpuid.h       |  16 +++
 arch/x86/kvm/svm/avic.c            |   4 +
 arch/x86/kvm/svm/svm.c             |  98 +++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c             |   9 +-
 arch/x86/kvm/x86.c                 |  37 +++++--
 include/uapi/linux/kvm.h           |  10 ++
 16 files changed, 359 insertions(+), 61 deletions(-)


base-commit: 196d9e72c4b0bd68b74a4ec7f52d248f37d0f030

