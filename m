Return-Path: <kvm+bounces-9134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C8F085B403
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 08:30:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9A5A8B21E4E
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 07:30:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DDDF5B691;
	Tue, 20 Feb 2024 07:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="K2r6bmJ6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2055.outbound.protection.outlook.com [40.107.94.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60755B67C;
	Tue, 20 Feb 2024 07:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708414228; cv=fail; b=A4iBQwe7VcTl/6/ixyBM+d9UqbF9OACbRarWjd+9LNHv1W68w9vQrGhJeyx1xImrjKn7WN56z0d2CHcozNl+AZboLUN55NaBgMCH68weigYQmCnQWG2XtgzKlpF1UdS50af74lZ4Kuorz/fXC/pawUBEOOmk/d9Z/gyKsop2uYk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708414228; c=relaxed/simple;
	bh=JtVxSe5e+tatR70Q2EbLOj6fkWTi26MlpqDduhnC/K8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=itxWOIKp4ovml2sQnn650FXsz02VZ2vS8O4XXKuqHuKYFrayfPSPGjWuNoeuh0WB8F8Oj63QP76FaeeP9t2ExVtex+XqN2Ee0/Uy84ePOG6EwyUBdWwPcKp3OSmVB29zpGN4x50ZPtHZNcJQPGq8bp8C1l/T437FoftdfEz4+YQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=K2r6bmJ6; arc=fail smtp.client-ip=40.107.94.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DdwWsruWQUaRyntM3PSubqCMNkV2OHywqxa/hgPBZDF5E1AyerPvJyevXzUIPb9nmeNQI0GwBaDsanwl3AYuz4OTbFS8B5i+j0NngtVmkK6NnD3awUPsx8SR5Z3If3H6DtTrtviW0aTps2hhB7+eIUm6cpH7CfGLvJaYanrDG1KHi2KfiYUBc65ciPzKSU0trutMTXnnnpwUYl1s6bWsMX7AIZbtVcfuXTJZshy95ihDw6BIaiaE9sVf/e/qL7pHoooNb7bX0mHXGS8b/5ijPbfKacCkuHs03SKqlkJGGitfm0okHPM+POc6+l+XR0hxmD/kX0QKKj7QBQ65XTtaKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5HNtKkDPIq2Wa2PmpJenFBQzXvyzTh38KvX3ICNw+5U=;
 b=Ud91zoghkI6PfPQDILa95GjRRf386rPb6+xamcElDPq7Vo/oYfbFJNpVf/zBv9Jb0ccD8ulzvKLfDbrmlccraX/MbMZ8ceS6vAAPT/YJ0XiPTDwauIqYQtKSdjKIOlmRQqt/PGfWjZUGPIP2eEsqb4E3iTsN2xst7Giur0gxUhDSZoM7Vw4MjsSscw+PtuR7THvzSaIUSOZDLpAsd5XJFUNLI3wIy1sVweiBHZWGab+MMVdTWsjdLG6P4oIF7f2IhrveA+fwGLn3+7SIZJOL7mwsSEcZy1rlPnIzSfe+2oUqoKnC+WsJ1GEyJjNX/FKQzJG9K2F8bxdZe+28KPJScQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5HNtKkDPIq2Wa2PmpJenFBQzXvyzTh38KvX3ICNw+5U=;
 b=K2r6bmJ6LloCVaYjqstLQFO2hLH7vK+PqWVlIvVUbEzbV664RUWA6ysiCptxa8go8mD25MN82hrU+0E7JjuWA1zAuAjhyRzeaoy69j3LMSMIqwzLjgjXFbkbF3AbIMbIAJRmHX2BkUPhPD++TfzWGE5JhqovQW16Cef/Cuj1c/GOlCtvy6+E46rqC2ItxbfyWASO8M8OwqlwL7tqKlHLfKZdcfByYmgR/lrlkg8SL2Xk/mK70792Fcxbx0544Kd3orNJO0Ha8VdeHtDkNL5Y4OK/as0NPjapZNUbb9OiRS1Lgy82r0Gavsugw1U+4kdoPINZ60vI3PT1lSwywvUZKg==
Received: from DM6PR04CA0017.namprd04.prod.outlook.com (2603:10b6:5:334::22)
 by DM4PR12MB7501.namprd12.prod.outlook.com (2603:10b6:8:113::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.19; Tue, 20 Feb
 2024 07:30:22 +0000
Received: from DS1PEPF00017096.namprd05.prod.outlook.com
 (2603:10b6:5:334:cafe::a4) by DM6PR04CA0017.outlook.office365.com
 (2603:10b6:5:334::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.39 via Frontend
 Transport; Tue, 20 Feb 2024 07:30:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF00017096.mail.protection.outlook.com (10.167.18.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.25 via Frontend Transport; Tue, 20 Feb 2024 07:30:22 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 19 Feb
 2024 23:30:10 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Mon, 19 Feb
 2024 23:30:09 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Mon, 19 Feb 2024 23:29:56 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <james.morse@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <reinette.chatre@intel.com>, <surenb@google.com>,
	<stefanha@redhat.com>, <brauner@kernel.org>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <mark.rutland@arm.com>, <alex.williamson@redhat.com>,
	<kevin.tian@intel.com>, <yi.l.liu@intel.com>, <ardb@kernel.org>,
	<akpm@linux-foundation.org>, <andreyknvl@gmail.com>,
	<wangjinchao@xfusion.com>, <gshan@redhat.com>, <shahuang@redhat.com>,
	<ricarkol@google.com>, <linux-mm@kvack.org>, <lpieralisi@kernel.org>,
	<rananta@google.com>, <ryan.roberts@arm.com>, <david@redhat.com>,
	<linus.walleij@linaro.org>, <bhe@redhat.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<kvmarm@lists.linux.dev>, <mochs@nvidia.com>, <zhiw@nvidia.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v8 2/4] mm: introduce new flag to indicate wc safe
Date: Tue, 20 Feb 2024 12:59:24 +0530
Message-ID: <20240220072926.6466-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240220072926.6466-1-ankita@nvidia.com>
References: <20240220072926.6466-1-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00017096:EE_|DM4PR12MB7501:EE_
X-MS-Office365-Filtering-Correlation-Id: 9baeac31-ee65-4a6f-3e6f-08dc31e5cc6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	OjL1k5WQRcdh4vjhjQUUxo5cuWa1ZDmV55Tq5D+dou1QEShSv6LFhmfkPBvlzWv4/AHbwbRyH+JN/A4B/2nGMTsZBaHFlmaN5+/82PIawBYcSOLHBb2w7Z/5MStxWEi6MquQuTrUtUClyWEK/TNnMSYMI3poKqh8FJSbeBT5MMYF8/UmtSJxQsUxUngPXfiAlp5rrkdtvcFbaLUAQmKKgWvbKK0RpPQhK5iPQrVBrZoYtZRTza868S7ZuJsofxJmPfzc0mhQaW8ncc251pG362D7oS5tG/uJch1QSO7Mz0lsUNgyzm6xWwlUr6qKgLWVwLZ3rS37fSDiF220i6RRWOwHijFku3B3Az/PshJa2OmCld41T8yD1fxVG2j6MNRxUtKoJhXCGLwwE2r0B7HteMQI1xaf37K9clRYRHnJTSC9cj4S87tE4+XAJgOypzp8XkzrE7UafR1m8U9wf6gNVzOo5MecFksP9hP7CfJ6KVVXWiIaxbiKDabCmIeVkeSm+DvYZ6wVVBYbFAIpoWoPMshVOcZKFitAfEtC7lEE/xUfxvORxwrmQF23rZkfiBjvcJriskPO19Ed6vtn4SB0r5Ab0xZUxWWzVQXaReJgqC3nLcRudF6wk1wm5TYYVzJmgyflfA6h6xUHl7SR5M/J9l3wy1lx+cqjYIpVfhQbAL8=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(46966006)(40470700004)(921011);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2024 07:30:22.4876
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9baeac31-ee65-4a6f-3e6f-08dc31e5cc6d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017096.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7501

From: Ankit Agrawal <ankita@nvidia.com>

The VM_ALLOW_ANY_UNCACHED flag is implemented for ARM64, allowing KVM
stage 2 device mapping attributes to use NormalNC rather than
DEVICE_nGnRE, which allows guest mappings supporting combining
attributes (WC). ARM does not architecturally guarantee this is safe,
and indeed some MMIO regions like the GICv2 VCPU interface can trigger
uncontained faults if NormalNC is used.

Even worse we expect there are platforms where even DEVICE_nGnRE can
allow uncontained faults in corner cases. Unfortunately existing ARM IP
requires platform integration to take responsibility to prevent this.

To safely use VFIO in KVM the platform must guarantee full safety in the
guest where no action taken against a MMIO mapping can trigger an
uncontained failure. We belive that most VFIO PCI platforms support this
for both mapping types, at least in common flows, based on some
expectations of how PCI IP is integrated. This can be enabled more broadly,
for instance into vfio-platform drivers, but only after the platform
vendor completes auditing for safety.

The VMA flag VM_ALLOW_ANY_UNCACHED was found to be the simplest and
cleanest way to communicate the information from VFIO to KVM that
mapping the region in S2 as NormalNC is safe. KVM consumes it to
activate the code that does the S2 mapping as NormalNC.

Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 include/linux/mm.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f5a97dec5169..59576e56c58b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -391,6 +391,20 @@ extern unsigned int kobjsize(const void *objp);
 # define VM_UFFD_MINOR		VM_NONE
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_MINOR */
 
+/*
+ * This flag is used to connect VFIO to arch specific KVM code. It
+ * indicates that the memory under this VMA is safe for use with any
+ * non-cachable memory type inside KVM. Some VFIO devices, on some
+ * platforms, are thought to be unsafe and can cause machine crashes
+ * if KVM does not lock down the memory type.
+ */
+#ifdef CONFIG_64BIT
+#define VM_ALLOW_ANY_UNCACHED_BIT	39
+#define VM_ALLOW_ANY_UNCACHED		BIT(VM_ALLOW_ANY_UNCACHED_BIT)
+#else
+#define VM_ALLOW_ANY_UNCACHED		VM_NONE
+#endif
+
 /* Bits set in the VMA until the stack is in its final location */
 #define VM_STACK_INCOMPLETE_SETUP (VM_RAND_READ | VM_SEQ_READ | VM_STACK_EARLY)
 
-- 
2.34.1


