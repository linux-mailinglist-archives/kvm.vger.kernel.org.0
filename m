Return-Path: <kvm+bounces-58958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DED1BA823F
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 08:36:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D0D7B1889FE0
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 06:36:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20B9C2BDC26;
	Mon, 29 Sep 2025 06:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="j1nG0HyL"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011066.outbound.protection.outlook.com [40.93.194.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE41C2853EF;
	Mon, 29 Sep 2025 06:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759127769; cv=fail; b=Oovxy7XyTN9roz0CXquzqidf0EtOX6SO0yJEfYA47vb6Pa+iTI75qGv8nWmD/cv1E0lk8k9smwOUEMLS5rCEKuvcPjZb2mths4Sd2AmSfIPa3Fb1LOq8WYMj5jAPMtQYe/xRmCGmqKmTygQRQCzkLEUgzhhjkDxFRCTPBQrGkPg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759127769; c=relaxed/simple;
	bh=klY/uJhLZWojAof4EDPA1B7/AlfnSpi3sTHKl2Gd/+A=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Wqzq/vqHjoQ2oBLK3GtCq9IiAQu83dVBWwQQOZqsymRvhm3MU10BJ0lo6q2QQ2qw5nuqfB1RIRDjEaA94noM5BvwqEErEg320Ve0zJBQPqqOcjfdOCpDlufCLBFgrAJrglSgLRTn9paa7mYHTkJvzVn6ZJn+TPKt6jZAITiBqwY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=j1nG0HyL; arc=fail smtp.client-ip=40.93.194.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ud3OY4435ZfiFWnflUBl9ra86B0cpGbXzAlMiWK0oq5B8eB/mt1MqDs+A4xv0YbHlIAv1PSuvwcXXNxdRMnSa2AUuBzqTy68wNHlwH3q8jGYmAWRlDQtG9ENlD4Oe8H36P0blGgb9rssH0U3J3pWCHSov1cHhNY3O5At6NP9nCtuOGL43i1aq2+UnVs/KJYHlJIhAQacPexcOXIl+BSi5NS1inkpdaYciqNLeJIS+ea5Y9SRkdz1Uy8sl79GMg4ebffU74wbc/RahcptOl1YOClSTXkhElFlJZTEu3rfsmb/Y99Q5K1Z+POSNaIa5QAIDASE2/Rz5qfSmAibqAmBrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cvGcAfxfHHSWG0zY3gNfGYhhPGTha+6KUnFeDOd++Q0=;
 b=XrtTFp27V26vkTdGUkYe7dX4P+mPIHtGbVYF/60KzSqIvHMVK4lViL2pVjkYP4tHzkAFdnBNSiIPVchWUs+XzWzzHBcSmcGuiTnxny8xyUqmZo+7ab1TV115I+Y6kstfnTm7VKTa534XxaREePeDSQ82ECr7ZdZ3PAf38tpzjD3hJ3q0s2pGgOq/C8NSfdM6xEqeWYcrTPHK8kXNL1YhO4ZGcjd/Mfx2SzebJXk/wsSeCkKI4Qw9+XQDL9P4mYQvPMO27ul14yzi/MtG5NV0VfPfFKRZ7gZNlI588C0eUeUyEE0SNSEWBv25BWq+z7dWC3ZqBiCuni2+Oh7Rj0QT3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cvGcAfxfHHSWG0zY3gNfGYhhPGTha+6KUnFeDOd++Q0=;
 b=j1nG0HyLq47THxQTI6w5xr4+k0UCyNV5gMUMvI+nSeJ8KFA/7SiaXvVsvb5peQctSesXOCLj2K7XC+vQfFs1UESfrkk+/jOc82ZP6kuPZ7qNczmigONL+AYaAtp9ktnTrIR6acjwNh63/TXfX6ypFAPgY3ENX4q67Rp5FoR90+w=
Received: from MN2PR11CA0021.namprd11.prod.outlook.com (2603:10b6:208:23b::26)
 by PH0PR12MB8007.namprd12.prod.outlook.com (2603:10b6:510:28e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Mon, 29 Sep
 2025 06:36:00 +0000
Received: from BL02EPF0001A0F9.namprd03.prod.outlook.com
 (2603:10b6:208:23b:cafe::fc) by MN2PR11CA0021.outlook.office365.com
 (2603:10b6:208:23b::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9160.17 via Frontend Transport; Mon,
 29 Sep 2025 06:36:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0001A0F9.mail.protection.outlook.com (10.167.242.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.9 via Frontend Transport; Mon, 29 Sep 2025 06:36:00 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 28 Sep
 2025 23:35:56 -0700
From: Shivank Garg <shivankg@amd.com>
To: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC: <namhyung@kernel.org>, <mingo@kernel.org>, <james.clark@linaro.org>,
	<xiaoyao.li@intel.com>, <acme@redhat.com>, <jmattson@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <shivankg@amd.com>
Subject: [PATCH kvm-next] tools headers: Sync KVM headers for KVM_CAP_GUEST_MEMFD_MMAP
Date: Mon, 29 Sep 2025 06:35:32 +0000
Message-ID: <20250929063532.19980-1-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0F9:EE_|PH0PR12MB8007:EE_
X-MS-Office365-Filtering-Correlation-Id: 382a65c4-971d-4bf0-632f-08ddff227479
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bVPgJC1owdySFaqCiQ5P3Gf9U/OIjy750UNWtZeAKMSxrdoxR9x7G41YIRjC?=
 =?us-ascii?Q?6YPR4m5YGXjVXa0H4jTvm2OH8NwI79q8mFp4Z1zGnV7B7uz4BjeDByigoL4+?=
 =?us-ascii?Q?zUnphrxOUBl0kH+N72wz4GwUkE6cNuH8pew7LmnQIBx3sX1Z8nRd6iG+1KLi?=
 =?us-ascii?Q?itAvuLgLUWU6e4UaipFd2Z/RxFewoJm1r0tzUoZXiOmQGrNv7ZFaUp7Dd/GM?=
 =?us-ascii?Q?yWI3/lNi7QUvUKyL5x4HlWhKOqooIOwJGCMgKR51EtLomGGbieGsuz3KApSh?=
 =?us-ascii?Q?NfIsI2jFTvIHX+vPWQWtsU4gzyfECiNqDUsXEtw8cKZqeMs+TpaPCGbtdC1N?=
 =?us-ascii?Q?A5x0GjOnqOW6DAo2sqN5UKTTAEsYHKa5MxXplyDTe/guiUUUmMe6Nvy8Lk3u?=
 =?us-ascii?Q?hw+GqYg1XnZUjDKEpUFGicN2jdMMbuD05orvp0GmIj4PdX44Jbs0nnREVZJe?=
 =?us-ascii?Q?LsDDKyW8g+4SP7Q0+qPq+40tACp/D2dfA7ZyXrS498lYIb9W5JaYbo9lbFYZ?=
 =?us-ascii?Q?FOgFtt/EMgDs3AaJN1sDbvLoXlacHlQefC7XbbdkkO0ivy5rkHv9dudFwTri?=
 =?us-ascii?Q?ZziMDx/v8aMgALV7hB9i6DH/aHVPtyis28wtCPoaC+Gn0TsKEv//i3oHwvbv?=
 =?us-ascii?Q?M9ic6joTuCs2Vl29BHTSBFEAYypcWoxZnVyUV92KaXBJxG85TBchXqpQYq6N?=
 =?us-ascii?Q?4/I8XKi4Y7C/4jCTZ9j5Z1bu05eSg4h7KadKEt5GAwNcvYyyfdxa+ZgcGXKg?=
 =?us-ascii?Q?eTpg4EIE8ADS8wCWfvFIrpCgBvsHvW2Nlz+Bl4jp4wV2PEuSgbCiArBMa+E2?=
 =?us-ascii?Q?Mooknho2iyduws9bx8rDRBeiTClBsyS48Aa69SCsDB0Qkf49WsikhzyqBQJI?=
 =?us-ascii?Q?HcG4OBne6Egn9E53+sVLs+s1lLolMW5DasRxsRv0BpjnIfh8yD46sJR6Roah?=
 =?us-ascii?Q?Sk6CZa3XMR+NXvY61LSrAr8nkE+i05K93Vgs6MlXI02EHplOnp169w+Jfr+x?=
 =?us-ascii?Q?rXKs3GYghXEgJ97qnUCHuw96rGRcrTmr5WLZmVhBTCTbKObOAwS2eycgW07B?=
 =?us-ascii?Q?INWIguJIqX3g8HLkD4DicpYpNcWEcZo0n/gkRjTllZ1sfY7YunKumLmmaAt+?=
 =?us-ascii?Q?68pooApDtcGKLy/SrWgSBF45aDBJnI1k3qZumoF6IRQLV/cLRn4lyK5l/5bu?=
 =?us-ascii?Q?WIT5SYR6XQiFklM4F8NgK6b5/H35f220zKlfOm4Y9DwGKpbSZncUJYzQ3Fm7?=
 =?us-ascii?Q?h20lbrlkWzm5sIdZ0/Suo/OsfIgzLxE7E/nG4JyXvUohsy1E59MgomVdy4tP?=
 =?us-ascii?Q?3KmebkDxb6muZjpdsWdPrbQ+UJ373YbYmSwLd+Q8EkS6D/z2zW2HBc7OcWeK?=
 =?us-ascii?Q?AsLLEH3cRjLItU8nPF92AiYCFLkc6tXOltdxV/DZ6CKvaIylRPZEg22+E3Sl?=
 =?us-ascii?Q?76HKVrNWj+rhNGQWkSexyumM3jxCluAUT2/YkYqOf1ilt3Ir2g5JPijtcHJk?=
 =?us-ascii?Q?ReSHeHeiYmL+LMEKctV+BZdsDvJZj9oPwROJ0hsDfzjB7jzvfO28RqHsAo6p?=
 =?us-ascii?Q?//qkCl4Od8dv+h8yERo=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2025 06:36:00.4120
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 382a65c4-971d-4bf0-632f-08ddff227479
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0F9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8007

To pick up the changes in this cset:
commit 82d26cc8e90b ("KVM: Allow and advertise support for host mmap() on guest_memfd files")

This addresses these perf build warnings:
tools/perf$ ./check-headers.sh
Warning: Kernel ABI header differences:
  diff -u tools/include/uapi/linux/kvm.h include/uapi/linux/kvm.h

Please see tools/include/uapi/README for further details.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 tools/include/uapi/linux/kvm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index f0f0d49d2544..6efa98a57ec1 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -962,6 +962,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_ARM_EL2_E2H0 241
 #define KVM_CAP_RISCV_MP_STATE_RESET 242
 #define KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED 243
+#define KVM_CAP_GUEST_MEMFD_MMAP 244
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1598,6 +1599,7 @@ struct kvm_memory_attributes {
 #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
 
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
+#define GUEST_MEMFD_FLAG_MMAP	(1ULL << 0)
 
 struct kvm_create_guest_memfd {
 	__u64 size;
-- 
2.43.0


