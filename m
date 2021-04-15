Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A842360F9E
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 17:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234216AbhDOP6z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 11:58:55 -0400
Received: from mail-mw2nam08on2085.outbound.protection.outlook.com ([40.107.101.85]:35008
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233520AbhDOP6x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 11:58:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n/gTSiIVWe9BLTvCXegLdmP0BZC8JNEKYqx921MsxHGq8FLT+BrRM3PAl1dpIoTotcLU57J28H/MK9lPQyJvBGaYIGYQlzmef3Y42ZH05/p/O/HvNGB/kd8imbE/8lmA8HijhLvxZV4nzuN4UdepTwMPoMNP2elGbCt7mkpQD29L6LApF5E44UIthCHK29GB6mwhRSkhV+FNnI5Gd7TIXsFDTnefi3u0qNIQiRs2AXR4gFm/xVh1z4w7DMCxnB5Ajfeo9LrKvVMRxx3bRR/T1qA/z6eScu1mwz8x3hGFu9QehTSp8rjMmwkQhGFYXC2IDVdGIdiaFEVAcIbjPDDX0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fxaCy/NKB3rxM9gYsE1EVvmOL2tgzwh48NPLoJzhB8A=;
 b=eJco73kUxqdyG4lTPT+3XQg3ak6DvjpQs7iQlIq2Mjv9qJgOOY5E1vFosX2hyV83aotPv+6ecmMqX9du7BS/QsI4CTF859uRveX3SDXgJ87rwyJIjW6mH9UFp+B9ZotMaloVGcZ7VFNdxdxrgYCjv1sOnc5Sg01/FMWwRq+02tvdxPqlBjwnGp2kdh7m0NX1NyCnY8B0g4zq5fJgw+6miYsx1qt9xm1j3i3/2bH963xPnlDtSDwGEET46ma+0gGWr5qFGa/C9//WDxHpiDzYk6SRk8CK38ng28tpNz43IltQd/KtFcMrniK1uQp8lE2xgTxepkCaO8OOyatprXuFlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fxaCy/NKB3rxM9gYsE1EVvmOL2tgzwh48NPLoJzhB8A=;
 b=TXo+UuSoB5GCnNtuH3n3LwFidSohmsLw/HQuaBsc7SjpyI8I7Ue5kTwp6itrh7n+CG9lhUJjeQmzlTirivX5TEgRVUX3IHWAc2+BSzZngQRlpbmmFqvMhIJ9Y7w6t8Pz7UohQXRtAYJgFk8xrMgeDkTu5BHiqiqbOLvv2fdJ4D0=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4415.namprd12.prod.outlook.com (2603:10b6:806:70::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Thu, 15 Apr
 2021 15:58:28 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4042.018; Thu, 15 Apr 2021
 15:58:28 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v13 10/12] KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION feature & Custom MSR.
Date:   Thu, 15 Apr 2021 15:58:17 +0000
Message-Id: <3232806199b2f4b307d28f6fd4f756d487b4e482.1618498113.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1618498113.git.ashish.kalra@amd.com>
References: <cover.1618498113.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN7PR04CA0065.namprd04.prod.outlook.com
 (2603:10b6:806:121::10) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN7PR04CA0065.namprd04.prod.outlook.com (2603:10b6:806:121::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Thu, 15 Apr 2021 15:58:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 479e2c2a-3983-4789-e99f-08d900274f6b
X-MS-TrafficTypeDiagnostic: SA0PR12MB4415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44152C25CEE2DF2295D713C78E4D9@SA0PR12MB4415.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7OUJEyKAmYmImQrg5dnZJpVjD9/dC5C2YYr/dZIaC+lFWExSoCqj+3AXUoExb1aJMxfbcC2BG+15A55a/Z3AGRwWod/gAP6RRUNx9CFOI+FiV3iiJ+B4mxMKOhw4h1ljO5l4ZLV80auB420msw6Zmf6GVgmGFYIwX7gb+SKFSaGQq/uOW3vPCrt8yVPaDYLRageZpkFQwFaykDPsNC8I2yWL2xdPv9L8R1uDgwe9WBPSMVx/KTDAOE5LJYEgwAcqti0/Y62LmRpkjHp6RQZ/pPDmM/X+L3M9N/ilaW2+a0/siL7H364VIL1I64IUmYZL995vL6qtLKLGDW/LTQRa8tF2Pjjs32Q8WSXJ+wi/c72vKQhBIiZcwdXpYr2V7NeWA3dluILyEhUKDce2iQzAOy9VQQC/onJ5Xddf9btr1XUkSYMP+3Mt/iNzBwQJNU2TZg+vq4A0jhZQ8w/GcAvwH9eci9WAHGFkDJ9xCoARr12rOYaMJVKORRmi2jG2y25XzzMwIFfQa7XKTB0RQLPOQi+x14JaVznq/EZu565gA7+qzjqXXNeh1N+EEPebWVTXiuDaKw+K5EpnNBiNL+tr1JX5xbkyouaoqFEN+Rv1C+olh2uWbvvcG91Q6ImMHCRY724jz5c5SL05kqrkqg10+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(376002)(396003)(39860400002)(2616005)(6666004)(38100700002)(316002)(956004)(66476007)(36756003)(38350700002)(66946007)(4326008)(66556008)(26005)(86362001)(478600001)(7696005)(52116002)(6916009)(6486002)(2906002)(8676002)(16526019)(8936002)(186003)(7416002)(83380400001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?cJbTKq7cycThfu6QmcyGTuk33W+ok5LeonDd2CnAkQs1bvpSHHY79WUD1P4D?=
 =?us-ascii?Q?FeP9TR3q4AOF4cMvZlkkmqvwUuRhwvUNbM8MB1zcbcbawPrfXnwMxa0UaPtR?=
 =?us-ascii?Q?oCI/Ng40NPUIxAvhbk0OC02PMowNzlxZOjPNEGZ0Z4PeSHT/XXQUvrrJTXS9?=
 =?us-ascii?Q?r/kaX56pYVbsbB3Q/UAKhGFM7jHuQZi5mOOgMv8FE2733+oR4my8wOXcCwyy?=
 =?us-ascii?Q?ioaKyUJTx093xwpHJVppzb92BvWOh3jMNqVVT8Sc5qmqQOCblcR9/5kWpLXu?=
 =?us-ascii?Q?F8/zKo2SNt7t9OunAb6LXxHA/RNBufbLoSEZ/SQQ7Xcp6FI/pNZV5KuB8X2d?=
 =?us-ascii?Q?TIXWd2oi1/8r7x5zD1zdLJmiPjrCxUPyoeRnw4iDbkqzrtvG5PdD86GtIHoy?=
 =?us-ascii?Q?uJ20ySn/YxTMZdk/mtDfV1+Kqpa1xC2e8u1jUzN0OdHqfSYmHAdbYNehLbmw?=
 =?us-ascii?Q?3cBEesJABSV55TVMufhVO3MHam646LrJ3H1h3DVa8V/Cigxq0Nffl++PsMXp?=
 =?us-ascii?Q?jjjOpx6g98DAQoCuyfjEvh6sz54L3z/zsqFTdmCENGFChrr99+Tmf1j3yUtG?=
 =?us-ascii?Q?/ok3y28lSuW1zOtz7+80klew95c8k95yyvEtBwAUOh0LVm1v7DFeafz2LOMJ?=
 =?us-ascii?Q?RL2P+pCyPNbkcZERllnx5qwWE1iddbhCqVkBnumpWlHXzsTKpwfvh/Zr/MEv?=
 =?us-ascii?Q?lhMBatwAKAqOZOXTcYBMlaUv3XCUdQJ0o8d7PBGYyAJFQg/Hox88sXa5XH4E?=
 =?us-ascii?Q?Hh4C+T3/dofZs24DJjzA++Ay60XyazCgdVbn8OaUMGMnaDZxtdatRx/jl4ON?=
 =?us-ascii?Q?+nwx0hw4Q0xlmmJIBDP1eE2hnue5d5qlNRxausMAmQqkoc9dhA6p3+slPHL/?=
 =?us-ascii?Q?l7KLbKgD3w/DR45a9X8xe2x+3uV45ldh0p81KYP0swoDxKubrqqjkDMV2Vhz?=
 =?us-ascii?Q?4kwm82Emtlu9KzCmZMOO3FUtPzJ7mtJxOFfC6rgklI0qdVBfNXa1qIpvbY6s?=
 =?us-ascii?Q?M6rBhRTUKJCCQqpD+Z1BOY/ZShBpvqE5Icaj7AWACcJ24DnXwwcx8YTvtDxO?=
 =?us-ascii?Q?vwfMyXDbep9rQ3FD6DY4le8K3K7cK3gfDm9jxoAbuNqiwohepkxAITnwtzxx?=
 =?us-ascii?Q?qWqZaodESK/aDrXFTHJQzIg9I8q0BQbrhGUs416NCsaunklANUDEIClhfzKj?=
 =?us-ascii?Q?oTaZQjaAFZ9jMIECyaXyFucobTX7p0tYsrle/WVQFmdjkhoByhGtFBvKtlXO?=
 =?us-ascii?Q?5T2bKe5eb5k4CflGHtBs3kiQP3Ohk/c0DSnz2RP9qEMMKulCE7Jn1MNqTsrs?=
 =?us-ascii?Q?VEBx8dJaN0d09gpVj/C3bn2i?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 479e2c2a-3983-4789-e99f-08d900274f6b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 15:58:28.7531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 74/Ac9nbnAY3MZJP1N+UPr+D0CxGwkUpFMGS48roFVKZHBRAoDb+J4slb2gk8vEKgOYnzY1mNy4YiiPyeYTAsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4415
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Add new KVM_FEATURE_SEV_LIVE_MIGRATION feature for guest to check
for host-side support for SEV live migration. Also add a new custom
MSR_KVM_SEV_LIVE_MIGRATION for guest to enable the SEV live migration
feature.

MSR is handled by userspace using MSR filters.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Reviewed-by: Steve Rutherford <srutherford@google.com>
---
 Documentation/virt/kvm/cpuid.rst     |  5 +++++
 Documentation/virt/kvm/msr.rst       | 12 ++++++++++++
 arch/x86/include/uapi/asm/kvm_para.h |  4 ++++
 arch/x86/kvm/cpuid.c                 |  3 ++-
 4 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
index cf62162d4be2..0bdb6cdb12d3 100644
--- a/Documentation/virt/kvm/cpuid.rst
+++ b/Documentation/virt/kvm/cpuid.rst
@@ -96,6 +96,11 @@ KVM_FEATURE_MSI_EXT_DEST_ID        15          guest checks this feature bit
                                                before using extended destination
                                                ID bits in MSI address bits 11-5.
 
+KVM_FEATURE_SEV_LIVE_MIGRATION     16          guest checks this feature bit before
+                                               using the page encryption state
+                                               hypercall to notify the page state
+                                               change
+
 KVM_FEATURE_CLOCKSOURCE_STABLE_BIT 24          host will warn if no guest-side
                                                per-cpu warps are expected in
                                                kvmclock
diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
index e37a14c323d2..020245d16087 100644
--- a/Documentation/virt/kvm/msr.rst
+++ b/Documentation/virt/kvm/msr.rst
@@ -376,3 +376,15 @@ data:
 	write '1' to bit 0 of the MSR, this causes the host to re-scan its queue
 	and check if there are more notifications pending. The MSR is available
 	if KVM_FEATURE_ASYNC_PF_INT is present in CPUID.
+
+MSR_KVM_SEV_LIVE_MIGRATION:
+        0x4b564d08
+
+	Control SEV Live Migration features.
+
+data:
+        Bit 0 enables (1) or disables (0) host-side SEV Live Migration feature,
+        in other words, this is guest->host communication that it's properly
+        handling the shared pages list.
+
+        All other bits are reserved.
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 950afebfba88..f6bfa138874f 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -33,6 +33,7 @@
 #define KVM_FEATURE_PV_SCHED_YIELD	13
 #define KVM_FEATURE_ASYNC_PF_INT	14
 #define KVM_FEATURE_MSI_EXT_DEST_ID	15
+#define KVM_FEATURE_SEV_LIVE_MIGRATION	16
 
 #define KVM_HINTS_REALTIME      0
 
@@ -54,6 +55,7 @@
 #define MSR_KVM_POLL_CONTROL	0x4b564d05
 #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
 #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
+#define MSR_KVM_SEV_LIVE_MIGRATION	0x4b564d08
 
 struct kvm_steal_time {
 	__u64 steal;
@@ -136,4 +138,6 @@ struct kvm_vcpu_pv_apf_data {
 #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
 #define KVM_PV_EOI_DISABLED 0x0
 
+#define KVM_SEV_LIVE_MIGRATION_ENABLED BIT_ULL(0)
+
 #endif /* _UAPI_ASM_X86_KVM_PARA_H */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 6bd2f8b830e4..4e2e69a692aa 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -812,7 +812,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			     (1 << KVM_FEATURE_PV_SEND_IPI) |
 			     (1 << KVM_FEATURE_POLL_CONTROL) |
 			     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
-			     (1 << KVM_FEATURE_ASYNC_PF_INT);
+			     (1 << KVM_FEATURE_ASYNC_PF_INT) |
+			     (1 << KVM_FEATURE_SEV_LIVE_MIGRATION);
 
 		if (sched_info_on())
 			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
-- 
2.17.1

