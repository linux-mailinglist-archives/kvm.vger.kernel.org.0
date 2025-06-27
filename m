Return-Path: <kvm+bounces-51013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 25CDDAEBD4A
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 18:28:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 53D921894BFC
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 16:27:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5B7C2EA152;
	Fri, 27 Jun 2025 16:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Qc/f3yO9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2852E9ECE;
	Fri, 27 Jun 2025 16:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751041584; cv=fail; b=ndKVOnRFmWw5KvoRHH3T9cbxIHY97VH/LjJFAJWsRpVEHbD4eWTjxZVTPD9jo62QOa6hqfS01J0yXRzDRof6RDKj7CO+FBYipf86LtkpeDxyxmF++2gOvw6FHjS2mlLnzZgNzx8KSZMjZyD2QoDKjrgK6YYnjlGScXj8XOqtKik=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751041584; c=relaxed/simple;
	bh=koeRTJ7r3UznyRLbKdkHtwrG4ua8nMVwAKfa/3+y3Z4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RQcWugIRhRm5ejDjNW2BKuR6Zj8YmASDZpwGJyHrjIf7k15W3HC//eim6rnzQKOUAWdHthIWAuoE1jNWo27KX0DT+TC8HMxzJk+mJfF3Zr02BD2J7JC4Z6R13go+P4ZY0XqxoRsGNa8S9zSvzlc4GLFHLx6Dv0sc0TyvnYfXLmI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Qc/f3yO9; arc=fail smtp.client-ip=40.107.94.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zPOH+F7+b3Y6DHYyS5nW04bxQDa8/WcgHlDPS3Mmwlg2qNAzrvv6Ol0wXD6zBV4E6a4BF5fbiqR/klEc01uMJ7amsJ7X9cKNmionnkX+wTgHOrWOGQr5jP5UGj2EpH+0PVfC0uKtUEfzbwUVskWukXQNCMjf3yfEQ0TL8B7KGM5Ua40DzHMLsiq3w+RcJBF9B35H8naIIVM1bPOk8ft+zuguzt+9YwoR92KL4ya1ZP15CYiFPRiEg6FoQXhFRUIppp9cyFcxRtjE0kXRF0PjDAfLDldXIiswk+uqIdEfTBod/GnjTcR5U1C4tseI+y9hpJIwu9X/BUWHK6fYIUTWQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W1Wzhfz+0FPt878K7VQqJL5r6Kq1gRiXUcbwHmOi1SY=;
 b=sN6z/1Yeex71kfSfMr2qGASh6clg4ouY5vMBtPa3EwQ/hCqgzLEyYFpzuycz9b6mZjDc8/vU/dP+2eNcnQNI874XrHdPVK+bc3g9WwBjtAOT3P4tcFjHclPww0N3k2hlmqR3tvazsLViWDCrFApN92qTPIIu4fA8siNUM3CU0blsupOZ/g1Z9F9srhYtIUNXqoIR4E4loTNeE5VXlp2HlgLlKwed+LZ7nql47Zv3bn1KpylpuKc16cwF2WbJtvALWER5YlkkaLNFRoyllqD7sAEbwxIgRIZwBBMSmLHj5Mz64QNPeWvZL4g6cSIfxqPAf4EghHqVTWaKKcrsVcyieg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=temperror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W1Wzhfz+0FPt878K7VQqJL5r6Kq1gRiXUcbwHmOi1SY=;
 b=Qc/f3yO9CFgHwQclr6axadKAxZoYSNX1KBPiOhuTlxA1B5UyoEUCs2o5b/0PVf1bwraSEiD3JluqWUNgcJDXsIyN0JKwDwUqAIpOjwlY3mIEbPmMlGGiEvJUycRe+m25DMua1JPW/thqQIMIPVsu2dOMaBF03Hmkm7xPd2A4Wr8=
Received: from SN6PR05CA0006.namprd05.prod.outlook.com (2603:10b6:805:de::19)
 by PH8PR12MB8429.namprd12.prod.outlook.com (2603:10b6:510:258::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Fri, 27 Jun
 2025 16:26:15 +0000
Received: from SN1PEPF000397B3.namprd05.prod.outlook.com
 (2603:10b6:805:de:cafe::38) by SN6PR05CA0006.outlook.office365.com
 (2603:10b6:805:de::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.11 via Frontend Transport; Fri,
 27 Jun 2025 16:26:14 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=amd.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of amd.com: DNS Timeout)
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000397B3.mail.protection.outlook.com (10.167.248.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8880.14 via Frontend Transport; Fri, 27 Jun 2025 16:26:14 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 27 Jun
 2025 11:26:09 -0500
From: Manali Shukla <manali.shukla@amd.com>
To: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-doc@vger.kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>,
	<manali.shukla@amd.com>, <bp@alien8.de>, <peterz@infradead.org>,
	<mingo@redhat.com>, <mizhang@google.com>, <thomas.lendacky@amd.com>,
	<ravi.bangoria@amd.com>, <Sandipan.Das@amd.com>
Subject: [PATCH v1 00/11] Implement support for IBS virtualization
Date: Fri, 27 Jun 2025 16:25:28 +0000
Message-ID: <20250627162550.14197-1-manali.shukla@amd.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B3:EE_|PH8PR12MB8429:EE_
X-MS-Office365-Filtering-Correlation-Id: d2a160e3-6357-4a79-0a4e-08ddb59755ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aTBodUdmdE51bU1Pd091NHBPeWhXSGtYa3hVd0trTTVveVlycU9XSzJlSzhF?=
 =?utf-8?B?S2JhSndFN2RMd25IMUVHTVFzdGFlS3R6K1lCZ3lCd01sSmJKSGVPWTFmcHlr?=
 =?utf-8?B?TGVETEk3clJCQ1h4VDhRQ1RFUU52dXdaMFFEY1dFOURDZ05RSmhRcFZ5b3dy?=
 =?utf-8?B?cFhUbUhZYmF6RWY3NTZ5U3BzbkJCTGE2aTZIWHZDTEsycEFkbjRPVlo4dlNs?=
 =?utf-8?B?TjlkZ3h5V0tFYjF3K3hud2lWOE9hN2ZJZDRlT0hrUDFPUzg4YitFMHl3MG10?=
 =?utf-8?B?SmxsVC9XQ0pMMUFQdENHOG5NNU1CY0pzRVAydmF2aEZDY0ZKR0p4cU1RRTRD?=
 =?utf-8?B?S0dXcWNIeVFZQW8zeVpGNHJkTHNMVTh6YTdyK2RLVzF2WERva3pSWXNKSmhu?=
 =?utf-8?B?Y1pNc3libFZpYXBiTGRaZHFVaGZHMXVzZ2M2K29obi9hKzBQZ0piMXM4OUsy?=
 =?utf-8?B?UmdxUVlMck5DSjJmVnlIZVZtOEFYcTduOVZCeXYrTk51YmU0YWJmazY2dlRy?=
 =?utf-8?B?c0pXRUNQUUk1YnExOWhrRkxjbGdaWGNZV2M4SU5ialI4K2tqSm9BSTBmSjBy?=
 =?utf-8?B?cVNBczE2RnlWYlpVNHl1NFVoeEhjbGx6YXZzSUEzN3lyeG9JMWRONTZ1aUVQ?=
 =?utf-8?B?aU8rZllibjA4RUtOZStmc0JzOWRoZU9neE15MnhYbUZhQUNkK2xPZHArY2pD?=
 =?utf-8?B?Znh3cmJCSG4wQTdtTytvUGozUlhUaXRJWjRmREVtZHF5dktBYmlyV0xqcWph?=
 =?utf-8?B?dU5yWW5IMzhQL3VHa0liWkE1dEJtR0tpMjRJK0JBUVh3RzF1MmJWZGJsVFhT?=
 =?utf-8?B?UlM1K2xMMCtncGt1d0s0dU5hT0JBNzUwOUFiTnI2Wng2eXcvZjlNQ3V5aVRM?=
 =?utf-8?B?SGlYWnVRZjg5cnNVU1hjcmlvcGZHT0Y1QyswNFhZR3ZVZXJHdmFvczJVM1ZY?=
 =?utf-8?B?YXp1STlXUUIwcVhwZTVzVm1pdVR0clRHYUNUd1JjalJVTG40TFhrOXN0VVNR?=
 =?utf-8?B?RXJvNkdnWEZmaTVYWmMxaGU3aER0ME0rb0l1Y3hBZ2lQVi9LY3ZZdURNTWFh?=
 =?utf-8?B?YyswcEtNc0d0OEtFSU01YSsxMGIwUDFlUkhGRmFEem1jOGNmYzQzTnczYkRu?=
 =?utf-8?B?YTJ4QXh3dVc0YWhEZVJJMGZ3R2VqenZsZUFIdnZ6YlNsL1J4RlFLa09zQUJj?=
 =?utf-8?B?KzF4Q0FLa3NnVGtPeUxCNEJCT2VNZ3NFbXl1N3oxL1pMeFRPblg4bjRBaGM5?=
 =?utf-8?B?Tk1LODRYNDN3bW1COHJqOTg5QUVqS0F2dmtDV1BzRWVxdWxLbWJnZHA5aXA0?=
 =?utf-8?B?QngxcE1GVGVrbDRBNlJTTDlObXVWdG8xRGlROXpZNGFUcjVnOWEwZW1Vd1VD?=
 =?utf-8?B?dFE3dWo3NTFRc1h6bDF0WWZtM0k3aGV1VVZCUkx5eDk5WENYQmVCaE4vZjFV?=
 =?utf-8?B?SnhzRmNEaVE1L2xWMTFkNGNsMmg3bHc1cE9zZWtNM0dZNFFJMG5mN3ByeDZ0?=
 =?utf-8?B?RFJpeGlBUklKTEYvL1FwR3J5ZXFSMnlBZG1MQTNCRlRxZG1nUE1HZEFZbDNp?=
 =?utf-8?B?a2YxOUZjaXgvQzJ1TnB2WEpRYkprOG9SSWt5emlDcjNnK0Q3VDBxeDJDOGM4?=
 =?utf-8?B?VkhWbXBCMitXaUxoWGVaeXNBTmpkanhicWQ5WS84QTlZbEZPT1pwY2Vod2Ex?=
 =?utf-8?B?VUJOVXhwTmR6d3lFdUVuY01PaFRxSG9Lc25hc25kNml3TU1HRlhObk8yMjFi?=
 =?utf-8?B?Vk5EMFdyaU83YjE4b0tEeE5ZNDY5SlNkQ2RxSFdJT3ZkL2lMY0htRnI2K1dY?=
 =?utf-8?B?TXgvd0JPY05Fbk8zcmFiRC9VVHVubUJZSCszemFGN0ZZRHhuSmJpNzliMHdu?=
 =?utf-8?B?Vy9xaWxaRjNkUzB2eUhrd0VJL0Jvc0V5VnJEaVVTaTNyMDQ1angyemo2OU1Z?=
 =?utf-8?B?VHY0TEw1SmNLY3FIek1NbWo2UExYeEM1cmhMZWZTM2ZNMHgzOVplMVZkZjkv?=
 =?utf-8?B?SFA5KzVLWFhVUFpyZDhtU05vT0E3LzlMLzc4ekRMalFCUmEzSkpMa2pnZWpE?=
 =?utf-8?B?VlZ2RGl5OHNjTldpb2FFeDVBdHR4OVRnT2FNZz09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2025 16:26:14.2054
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d2a160e3-6357-4a79-0a4e-08ddb59755ec
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8429

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
dynamic behavior of AVIC. While a guest is launched with AVIC enabled,
AVIC can be inhibited at runtime. When AVIC is inhibited and VNMI is
disabled, there is no mechanism to deliver IBS NMIs to the guest.
Therefore, enabling VNMI is necessary to support IBS virtualization
reliably.

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

Since then, the mediated PMU patches [5] have matured significantly.
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
qemu-system-x86_64 -enable-kvm -cpu EPYC-Genoa,+ibs,+extlvt,+extapic,+svm,+pmu \ ..

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
  sudo ./tools/perf/perf record -e ibs_op// -e ibs_fetch// -a --raw-samples -c 100000
  sudo perf report
  sudo perf script
  sudo perf report -D | grep -P "LdOp 1.*StOp 0" | wc -l
  sudo perf report -D | grep -P "LdOp 1.*StOp 0.*DcMiss 1" | wc -l
  sudo perf report -D | grep -P "LdOp 1.*StOp 0.*DcMiss 1.*L2Miss 1" | wc -l
  sudo perf report -D | grep -B1 -P "LdOp 1.*StOp 0.*DcMiss 1.*L2Miss 1" | grep -P "DataSrc ([02-9]|1[0-2])=" | wc -l
- perf_fuzzer was run for 3hrs, no softlockups or unknown NMIs were
  seen.

TO-DO: 
-----------------------------------
Enable IBS virtualization on SEV-ES and SEV-SNP guests.

base-commit (61374cc145f4) + [4] (Clean up KVM's MSR interception code)
+ [5] (Mediated vPMU 4.0 for x86). 

[1]: https://bugzilla.kernel.org/attachment.cgi?id=306250
     AMD64 Architecture Programmer’s Manual, Vol 2, Section 15.38
     Instruction-Based Sampling Virtualization.

[2]: https://bugzilla.kernel.org/attachment.cgi?id=306250
     AMD64 Architecture Programmer’s Manual, Vol 2, Appendix B Layout
     of VMCB, Table B-3 Swap Types.

[3]: https://bugzilla.kernel.org/attachment.cgi?id=306250
     AMD64 Architecture Programmer’s Manual, Vol 2, Section 16.4.5
     Extended Interrupts.

[4]: https://lore.kernel.org/kvm/20250610225737.156318-1-seanjc@google.com/

[5]: https://lore.kernel.org/kvm/20250324173121.1275209-1-mizhang@google.com/

Manali Shukla (6):
  perf/amd/ibs: Fix race condition in IBS
  KVM: Add KVM_GET_LAPIC_W_EXTAPIC and KVM_SET_LAPIC_W_EXTAPIC for
    extapic
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

 Documentation/virt/kvm/api.rst     | 23 +++++++
 arch/x86/events/amd/ibs.c          |  8 ++-
 arch/x86/include/asm/apicdef.h     | 17 ++++++
 arch/x86/include/asm/cpufeatures.h |  2 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/include/asm/svm.h         | 16 ++++-
 arch/x86/include/uapi/asm/kvm.h    |  5 ++
 arch/x86/kvm/cpuid.c               | 13 ++++
 arch/x86/kvm/lapic.c               | 81 ++++++++++++++++++++++---
 arch/x86/kvm/lapic.h               |  7 ++-
 arch/x86/kvm/reverse_cpuid.h       | 16 +++++
 arch/x86/kvm/svm/avic.c            |  4 ++
 arch/x86/kvm/svm/svm.c             | 96 ++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c                 | 37 ++++++++----
 include/uapi/linux/kvm.h           | 10 ++++
 15 files changed, 313 insertions(+), 23 deletions(-)


base-commit: 61374cc145f4a56377eaf87c7409a97ec7a34041
-- 
2.43.0


