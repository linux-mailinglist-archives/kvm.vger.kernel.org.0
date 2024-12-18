Return-Path: <kvm+bounces-34055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 473789F69EE
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 16:24:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8862616702A
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 15:24:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1192C1F427B;
	Wed, 18 Dec 2024 15:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="U97tTS0U"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2064.outbound.protection.outlook.com [40.107.220.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3BF76410;
	Wed, 18 Dec 2024 15:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734535402; cv=fail; b=uYbL8JZs96+1vw0C3lVuMuZOVu3FGYnfwkqDF793YV8wb3o82fYFd+hCWTnZ9UezCIU6qdn12x3NK8JsXtaK/AcHl3zp+656M3MPwSswlhTfZggwL7S6R6QzmoByeVwFvJ4IOKHK/QixTdSaWEf+QathUexXtUulRfvDctZWQHM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734535402; c=relaxed/simple;
	bh=rYXNZjGVHjVb6dvUPS8tfOXLiaipxBI813vt44uCpws=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uZuKg8y5+DRvGoyBEgZgrgsRoXnTdC6alL1itRkQQfsX2ZWk7DCoK/cA3nFiJQ3oK7LWOZFuv65tNTnZr5r8/SiwPkn666p4cUX85CMBjmifFog4v8GjIq5WFFh1zibzqJe0aT2Ur+wCjHzT9P3Nw9co+K7xkMfQXRnuyhCwyk8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=U97tTS0U; arc=fail smtp.client-ip=40.107.220.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C8kfKJVp42NlBner2H0RjhTsXIrXf+OxFZ4yukFKiZNC7MLoZ/V17u3GRLRcMM6RB7zB5SI0LvBnC6G2bJFzhG2rUAqy+NiBtYZWvpimAYFZjr3G+ryGeTWTwA2dFed1IQER1ex5NHnAMhAZ6wS5QYxZ4wHnECwoSNqsCX9+CsGNfXuCPHtpN1275c1cG34JS0Hz9bSZJVSu5jZOqmMk96Ll10GP03dyVZ3E8apmwDdTi2y3IxGUdZfe8HNEAKknHj3raPXHkIz2HC/9kgICM9JvLIKqrdRzO9DvjjzZOAh0RB3JK4a9LiqecgPbyJ0ruLglZ1bSU339tJhGxKD6cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sbwJ1v4tqq7PmIMBfdZ3IS9A2nbdsHSnAWvOMByCGP8=;
 b=Vf0xifV0W51j/lMEsTfFdsGOBfD74UcsjZi40LKCvnjBd9BUss5esNbVLmlv/lU8YbQ5+kPAiYzllk4cwlaxd//xJe///6VqFJS0UD517KFT5gN7coUwcmccQUWzrd+pIugTT91WsOxvEieA2N4oVtdNb3P3qxhiUzxOuimG6Cr7Y1ZJ0DEo3bKZoe5Y8wimzeMDtkmKljoQw20e0Bg+9XDmJdB1O8ceUHsrUE5mX+2aqk3fUO9xc4HMVflmud7F5rC94Yt2KGa8oXSEW34aiNlD0BOGAxhYXdcb7IR/c52pp3z0oZ2ZymxC5DDGZmcQcKpfuD4WeROIMB/G+kUb1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sbwJ1v4tqq7PmIMBfdZ3IS9A2nbdsHSnAWvOMByCGP8=;
 b=U97tTS0U7fxIieJWYVRObNF80waScez3Kf8J40/nSNZGe36EB7aFcSL9nO3AnsuT5Nc4ZCdP3T2qvoz+7kh4O27wDLy/cAYXu1y3rfNNN4zGP5IWD72a9tARZfcWeDMqd4bTHWeNedacZFgXMlK/OJ0heZ0ZB7sLS06ZQG+g02s=
Received: from SN7PR04CA0187.namprd04.prod.outlook.com (2603:10b6:806:126::12)
 by LV2PR12MB5799.namprd12.prod.outlook.com (2603:10b6:408:179::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.16; Wed, 18 Dec
 2024 15:23:15 +0000
Received: from SA2PEPF00001505.namprd04.prod.outlook.com
 (2603:10b6:806:126:cafe::94) by SN7PR04CA0187.outlook.office365.com
 (2603:10b6:806:126::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8251.22 via Frontend Transport; Wed,
 18 Dec 2024 15:23:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00001505.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8251.15 via Frontend Transport; Wed, 18 Dec 2024 15:23:15 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 18 Dec
 2024 09:23:14 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <ashish.kalra@amd.com>, <liam.merwick@oracle.com>,
	<pankaj.gupta@amd.com>, <dionnaglaze@google.com>, <huibo.wang@amd.com>
Subject: [PATCH v3] KVM: Introduce KVM_EXIT_SNP_REQ_CERTS for SNP certificate-fetching
Date: Wed, 18 Dec 2024 09:22:26 -0600
Message-ID: <20241218152226.1113411-2-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241218152226.1113411-1-michael.roth@amd.com>
References: <20241218152226.1113411-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00001505:EE_|LV2PR12MB5799:EE_
X-MS-Office365-Filtering-Correlation-Id: d94930a1-6463-4292-8e4e-08dd1f77e49c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5Mi3zvSBFmdGxmjO0wIhEEcgexrQm2JOfA0Ka4UjpQ50bsHUxCgRNXOhTasX?=
 =?us-ascii?Q?XjdMKksUUf64KRsOO2lBlS/kOFLmRpkUHdro5kb7E1/ZtKWjM64kgTQfmsoZ?=
 =?us-ascii?Q?w0LJAzw5d+ofZVdfUE17qI78h8hqV6RpNl4vW086pHjFGph2/blx4FsPkCz6?=
 =?us-ascii?Q?FtLjvZYKG+WlS4yGYaPkTcUfOOuILpM9q0lIeD0h6KoYVNJ2UbdfxrYT/aQR?=
 =?us-ascii?Q?JiyIAx4mwl8uRNsAVmwcK8KPhRI3fz1ioE+AEGV/yrFLbip9Hj8Dn1JAy1no?=
 =?us-ascii?Q?pTNmA7ARU94NybrAaB3y78LnsZjk9IP4+/Hi9hT/zimbFNgiMA2b+teSo1IZ?=
 =?us-ascii?Q?ZN/ZwPN/yCtEVd1sckiLwJmOH3/z+txIjvFlfH4GDmaHz6xPHcgjutV0eGrY?=
 =?us-ascii?Q?PepLvXsqbzEf/RrbH/lUZQ/Da6+GWamARuDOeuDH1WzogE6GyimJc/5+yZHQ?=
 =?us-ascii?Q?nYa2WPFR1NmwT7Aa5SdEj8B5+qX3RI1qrUJ//SySPwX7V0bHG+Gf88KDOvKn?=
 =?us-ascii?Q?8YUgzY70xlipDlczyjE3JpkZTbiZInCYhDNclAzUzVQSw2YmKJq1mAKsqaS0?=
 =?us-ascii?Q?B2zsonp+reU9qe1q1Dexsd3IqTNOpAzixhfw6+X5zZxpwRdlj15g8zqCtfUi?=
 =?us-ascii?Q?A7NGxPjCF6t3aQAI4qS9V41AtZQzpVNeZJvblQ1zoBRVKHJFUqajIHOiX9z6?=
 =?us-ascii?Q?ZKjdj2gz0aJx0pkxKdgj3GI+MZ68hz6xYVTa7Ew7eYb7e11PSnYlafGtEgJs?=
 =?us-ascii?Q?nHXvRoQhAbvbbw+PKXJOl9gjdsPfSvsDBUA2zjvVxofqWDaAQXtHwokbXMfS?=
 =?us-ascii?Q?UuzQhOiS3jx/JYijsoHLG1e/ratm+f5Liwl8Z+AyQnHS2sfQ+wdOZM9RxF13?=
 =?us-ascii?Q?s3CZFDsU33QZBJrfuwBuqymZm3/u6kwDHbQJw+oxuPMa8xqg0lmEbus01txU?=
 =?us-ascii?Q?xHkajK141n0SUPmSQWovAEG46OGEy0DWYjirC/RRvNaizuQLy/oTyJGWZJX0?=
 =?us-ascii?Q?1nZ2c3HmchqfUysMVz2gz5Lv55iVmgSFksT/IGWWQckq5rtVsq4ZZez5n9Fe?=
 =?us-ascii?Q?tBK4YbL+I/oYk06d07UAUBIyrKEL7gEq2sXYgKbB1cTvCsAFomEFrUeO7xnR?=
 =?us-ascii?Q?J5nanIJAIBoesxb9QVWVkYa2zZgfTeCQywp/Ytqs1YJ/REzvX957yOMe8x79?=
 =?us-ascii?Q?nnRCZ6H2GbbTwXu/inUn4uBOaMGiABO4Z0miJLodbKlCUg7y3Dj44cX7bqXO?=
 =?us-ascii?Q?Vzgmjj2ac76kpFKQo8SNwQX2m+7q7CVuyua5YrIp08rY7nhnMJiHYn+VN/j3?=
 =?us-ascii?Q?p4sgKWHO3w63ED48d4J0S1mGfysWVS+qW85Tfon6ZEXotAhmDLRQ++igr1F6?=
 =?us-ascii?Q?Qfer7t4I0bQb0hFWM5z26ly9PE4p8sDm7yaUx+hvJRrZPiwHMhzE3T+zUJPL?=
 =?us-ascii?Q?VHekbCJwaOIntVAcsDlJjB5SBg7QwZ27oCHxeESuiaygV4bhUC4yCSXl52uV?=
 =?us-ascii?Q?5ZwoDsnlMytikE4=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 15:23:15.2575
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d94930a1-6463-4292-8e4e-08dd1f77e49c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001505.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5799

For SEV-SNP, the host can optionally provide a certificate table to the
guest when it issues an attestation request to firmware (see GHCB 2.0
specification regarding "SNP Extended Guest Requests"). This certificate
table can then be used to verify the endorsement key used by firmware to
sign the attestation report.

While it is possible for guests to obtain the certificates through other
means, handling it via the host provides more flexibility in being able
to keep the certificate data in sync with the endorsement key throughout
host-side operations that might resulting in the endorsement key
changing.

In the case of KVM, userspace will be responsible for fetching the
certificate table and keeping it in sync with any modifications to the
endorsement key by other userspace management tools. Define a new
KVM_EXIT_SNP_REQ_CERTS event where userspace is provided with the GPA of
the buffer the guest has provided as part of the attestation request so
that userspace can write the certificate data into it while relying on
filesystem-based locking to keep the certificates up-to-date relative to
the endorsement keys installed/utilized by firmware at the time the
certificates are fetched.

Also introduce a KVM_CAP_EXIT_SNP_REQ_CERTS capability to enable/disable
the exit for cases where userspace does not support
certificate-fetching, in which case KVM will fall back to returning an
empty certificate table if the guest provides a buffer for it.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 Documentation/virt/kvm/api.rst  | 93 +++++++++++++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/sev.c          | 43 ++++++++++++---
 arch/x86/kvm/x86.c              | 11 ++++
 include/uapi/linux/kvm.h        | 10 ++++
 include/uapi/linux/sev-guest.h  |  8 +++
 6 files changed, 160 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 7911da34b9fd..d6a34b330968 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7188,6 +7188,82 @@ Please note that the kernel is allowed to use the kvm_run structure as the
 primary storage for certain register types. Therefore, the kernel may use the
 values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
 
+::
+
+		/* KVM_EXIT_SNP_REQ_CERTS */
+		struct kvm_exit_snp_req_certs {
+			__u64 gfn;
+			__u32 npages;
+			__u32 ret;
+		};
+
+This event provides a way to request certificate data from userspace and
+have it written into guest memory. This is intended to handle attestation
+requests made by SEV-SNP guests (using the Extended Guest Requests GHCB
+command as defined by the GHCB 2.0 specification for SEV-SNP guests),
+where additional certificate data corresponding to the endorsement key
+used by firmware to sign an attestation report can be optionally provided
+by userspace to pass along to the guest together with the
+firmware-provided attestation report.
+
+KVM will supply in `gfn` the non-private guest page that userspace should
+use to write the contents of certificate data. The format of this
+certificate data is defined in the GHCB 2.0 specification (see section
+"SNP Extended Guest Request"). KVM will also supply in `npages` the
+number of contiguous pages available for writing the certificate data
+into.
+
+  - If the supplied number of pages is sufficient, userspace must write
+    the certificate table blob (in the format defined by the GHCB spec)
+    into the address corresponding to `gfn` and set `ret` to 0 to indicate
+    success. If no certificate data is available, then userspace can
+    either write an empty certificate table into the address corresponding
+    to `gfn`, or it can disable ``KVM_EXIT_SNP_REQ_CERTS`` (via
+    ``KVM_CAP_EXIT_SNP_REQ_CERTS``), in which case KVM will handle
+    returning an empty certificate table to the guest.
+
+  - If the number of pages supplied is not sufficient, userspace must set
+    the required number of pages in `npages` and then set `ret` to
+    ``ENOSPC``.
+
+  - If the certificate cannot be immediately provided, userspace should set
+    `ret` to ``EAGAIN``, which will inform the guest to retry the request
+    later. One scenario where this would be useful is if the certificate
+    is in the process of being updated and cannot be fetched until the
+    update completes (see the NOTE below regarding how file-locking can
+    be used to orchestrate such updates between management/guests).
+
+  - If some other error occurred, userspace must set `ret` to ``EIO``.
+    (This is to reserve special meaning for unused error codes in the
+    future.)
+
+NOTE: The endorsement key used by firmware may change as a result of
+management activities like updating SEV-SNP firmware or loading new
+endorsement keys, so some care should be taken to keep the returned
+certificate data in sync with the actual endorsement key in use by
+firmware at the time the attestation request is sent to SNP firmware. The
+recommended scheme to do this is to use file locking (e.g. via fcntl()'s
+F_OFD_SETLK) in the following manner:
+
+  - The VMM should obtain a shared/read or exclusive/write lock on the path
+    the certificate blob file resides at before reading it and returning it
+    to KVM, and continue to hold the lock until the attestation request is
+    actually sent to firmware. To facilitate this, the VMM can set the
+    ``immediate_exit`` flag of kvm_run just after supplying the certificate
+    data, and just before and resuming the vCPU. This will ensure the vCPU
+    will exit again to userspace with ``-EINTR`` after it finishes fetching
+    the attestation request from firmware, at which point the VMM can
+    safely drop the file lock.
+
+  - Tools/libraries that perform updates to SNP firmware TCB values or
+    endorsement keys (e.g. via /dev/sev interfaces such as ``SNP_COMMIT``,
+    ``SNP_SET_CONFIG``, or ``SNP_VLEK_LOAD``, see
+    Documentation/virt/coco/sev-guest.rst for more details) in such a way
+    that the certificate blob needs to be updated, should similarly take an
+    exclusive lock on the certificate blob for the duration of any updates
+    to endorsement keys or the certificate blob contents to ensure that
+    VMMs using the above scheme will not return certificate blob data that
+    is out of sync with the endorsement key used by firmware.
 
 .. _cap_enable:
 
@@ -9032,6 +9108,23 @@ Do not use KVM_X86_SW_PROTECTED_VM for "real" VMs, and especially not in
 production.  The behavior and effective ABI for software-protected VMs is
 unstable.
 
+8.42 KVM_CAP_EXIT_SNP_REQ_CERTS
+-------------------------------
+
+:Capability: KVM_CAP_EXIT_SNP_REQ_CERTS
+:Architectures: x86
+:Type: vm
+
+This capability, if enabled, will cause KVM to exit to userspace with
+KVM_EXIT_SNP_REQ_CERTS exit reason to allow for fetching SNP attestation
+certificates from userspace.
+
+Calling KVM_CHECK_EXTENSION for this capability will return a non-zero
+value to indicate KVM support for KVM_EXIT_SNP_REQ_CERTS.
+
+The 1st argument to KVM_ENABLE_CAP should be 1 to indicate userspace support
+for handling this event.
+
 9. Known KVM API problems
 =========================
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0787855ab006..1167badb6500 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1462,6 +1462,7 @@ struct kvm_arch {
 	struct kvm_x86_msr_filter __rcu *msr_filter;
 
 	u32 hypercall_exit_enabled;
+	bool snp_certs_enabled;
 
 	/* Guest can access the SGX PROVISIONKEY. */
 	bool sgx_provisioning_allowed;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 40fe7258843e..221446a3051f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4064,6 +4064,30 @@ static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_
 	return ret;
 }
 
+static int snp_complete_req_certs(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb_control_area *control = &svm->vmcb->control;
+
+	if (vcpu->run->snp_req_certs.ret) {
+		if (vcpu->run->snp_req_certs.ret == ENOSPC) {
+			vcpu->arch.regs[VCPU_REGS_RBX] = vcpu->run->snp_req_certs.npages;
+			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
+						SNP_GUEST_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN, 0));
+		} else if (vcpu->run->snp_req_certs.ret == EAGAIN) {
+			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
+						SNP_GUEST_ERR(SNP_GUEST_VMM_ERR_BUSY, 0));
+		} else {
+			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
+						SNP_GUEST_ERR(SNP_GUEST_VMM_ERR_GENERIC, 0));
+		}
+
+		return 1; /* resume guest */
+	}
+
+	return snp_handle_guest_req(svm, control->exit_info_1, control->exit_info_2);
+}
+
 static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
 {
 	struct kvm *kvm = svm->vcpu.kvm;
@@ -4079,12 +4103,10 @@ static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t r
 	/*
 	 * As per GHCB spec, requests of type MSG_REPORT_REQ also allow for
 	 * additional certificate data to be provided alongside the attestation
-	 * report via the guest-provided data pages indicated by RAX/RBX. The
-	 * certificate data is optional and requires additional KVM enablement
-	 * to provide an interface for userspace to provide it, but KVM still
-	 * needs to be able to handle extended guest requests either way. So
-	 * provide a stub implementation that will always return an empty
-	 * certificate table in the guest-provided data pages.
+	 * report via the guest-provided data pages indicated by RAX/RBX. If
+	 * userspace enables KVM_EXIT_SNP_REQ_CERTS, then exit to userspace
+	 * to fetch the certificate data. Otherwise, return an empty certificate
+	 * table in the guest-provided data pages.
 	 */
 	if (msg_type == SNP_MSG_REPORT_REQ) {
 		struct kvm_vcpu *vcpu = &svm->vcpu;
@@ -4100,6 +4122,15 @@ static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t r
 		if (!PAGE_ALIGNED(data_gpa))
 			goto request_invalid;
 
+		if (vcpu->kvm->arch.snp_certs_enabled) {
+			vcpu->run->exit_reason = KVM_EXIT_SNP_REQ_CERTS;
+			vcpu->run->snp_req_certs.gfn = gpa_to_gfn(data_gpa);
+			vcpu->run->snp_req_certs.npages = data_npages;
+			vcpu->run->snp_req_certs.ret = 0;
+			vcpu->arch.complete_userspace_io = snp_complete_req_certs;
+			return 0; /* fetch certs from userspace */
+		}
+
 		/*
 		 * As per GHCB spec (see "SNP Extended Guest Request"), the
 		 * certificate table is terminated by 24-bytes of zeroes.
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4f94b1e24eae..cff1cbda430a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4797,6 +4797,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_READONLY_MEM:
 		r = kvm ? kvm_arch_has_readonly_mem(kvm) : 1;
 		break;
+	case KVM_CAP_EXIT_SNP_REQ_CERTS:
+		r = 1;
+		break;
 	default:
 		break;
 	}
@@ -6764,6 +6767,14 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		mutex_unlock(&kvm->lock);
 		break;
 	}
+	case KVM_CAP_EXIT_SNP_REQ_CERTS:
+		if (cap->args[0] != 1) {
+			r = -EINVAL;
+			break;
+		}
+		kvm->arch.snp_certs_enabled = true;
+		r = 0;
+		break;
 	default:
 		r = -EINVAL;
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 1dae36cbfd52..e1f257efbbbf 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -135,6 +135,12 @@ struct kvm_xen_exit {
 	} u;
 };
 
+struct kvm_exit_snp_req_certs {
+	__u64 gfn;
+	__u32 npages;
+	__u32 ret;
+};
+
 #define KVM_S390_GET_SKEYS_NONE   1
 #define KVM_S390_SKEYS_MAX        1048576
 
@@ -178,6 +184,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_NOTIFY           37
 #define KVM_EXIT_LOONGARCH_IOCSR  38
 #define KVM_EXIT_MEMORY_FAULT     39
+#define KVM_EXIT_SNP_REQ_CERTS    40
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -447,6 +454,8 @@ struct kvm_run {
 			__u64 gpa;
 			__u64 size;
 		} memory_fault;
+		/* KVM_EXIT_SNP_REQ_CERTS */
+		struct kvm_exit_snp_req_certs snp_req_certs;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -934,6 +943,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_PRE_FAULT_MEMORY 236
 #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
 #define KVM_CAP_X86_GUEST_MODE 238
+#define KVM_CAP_EXIT_SNP_REQ_CERTS 239
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
diff --git a/include/uapi/linux/sev-guest.h b/include/uapi/linux/sev-guest.h
index fcdfea767fca..4c4ed8bc71d7 100644
--- a/include/uapi/linux/sev-guest.h
+++ b/include/uapi/linux/sev-guest.h
@@ -95,5 +95,13 @@ struct snp_ext_report_req {
 
 #define SNP_GUEST_VMM_ERR_INVALID_LEN	1
 #define SNP_GUEST_VMM_ERR_BUSY		2
+/*
+ * The GHCB spec essentially states that all non-zero error codes other than
+ * those explicitly defined above should be treated as an error by the guest.
+ * Define a generic error to cover that case, and choose a value that is not
+ * likely to overlap with new explicit error codes should more be added to
+ * the GHCB spec later.
+ */
+#define SNP_GUEST_VMM_ERR_GENERIC       ((u32)~0U)
 
 #endif /* __UAPI_LINUX_SEV_GUEST_H_ */
-- 
2.25.1


