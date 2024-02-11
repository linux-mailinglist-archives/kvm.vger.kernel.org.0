Return-Path: <kvm+bounces-8516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 84171850AB6
	for <lists+kvm@lfdr.de>; Sun, 11 Feb 2024 18:48:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D76C7B211A5
	for <lists+kvm@lfdr.de>; Sun, 11 Feb 2024 17:48:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D94805D910;
	Sun, 11 Feb 2024 17:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="maM81IZg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2062.outbound.protection.outlook.com [40.107.95.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706195D8ED;
	Sun, 11 Feb 2024 17:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707673668; cv=fail; b=IFb8AQxBoh/4TFznYDS8wEb/zBn9jYc2Au23D+48wXL5qtVPlknfOIpL1xkZOr9oki1UP9kBsmRS8i1wmMeLLNI2H16Yt39qnqW52H2OmqCLH0DzMS5dLixM/OrMQ9/AzOH+6IfSpnBApWFdY0Hlb/On6y7p/T7ynvK8rrG9oV0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707673668; c=relaxed/simple;
	bh=osznS9Wsfqjfhol6/oReaIYXeAC9OS46UNIsihIzpsQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vFb1H3eI1a67ZAHHj/f1Y9bg+CUD4brEUEv5lZLWQQz9JIeSmAciiansvEqqyCQZOMP0Ztuxwab1+guz1++snKp7pE224f3YRmoFaYqXbyWXGz44J/+Bf9ltm5kgkvL9oi2yILbnpC5lc3OVO3gJG2KT9Ot68rdXLDMqGkERKBM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=maM81IZg; arc=fail smtp.client-ip=40.107.95.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b14R01CnK/mOWDiIO/92bQZROhx4hCOWYfz15x5x6zOBIuXWwWsh9/ha2I2NtKhsK+29JNFKVYgYsNptcttFkM54FFJpwr/ExeLEjxi/HAZDsJRgfogZ1CMLmsTjO4BZr8rak638oUG3cKjuFjQpggUvr5p+0pmVeKncv9opVhYfkI95KVee8bXeQ17ZFedn9U4bu9QEkhDm7BhP8m3vYm37ZtnGARbbXDF40CEWwo8/PWzsCUOgeeCTysnz7wyJK8DXvzldNvvqnNax5yd57sSUyiXxw9itHH1xl9QwoB5pXp5ckavgHlXkVwLwGurwZa2QjHbE/pKhiAY+b1SwTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k5zGtt47H9t3q8PQmD/JIeN4xCzA2TDjhLc/bv9gbc0=;
 b=oeQUJoV6s3BXmk6/i+5qub+shlf9IptHeXlwSZwN0olqvrvnK1GwUZxSJ8K1+x3+V8/hHFUtu96AYoAhuGH8Fflk6NbstRF2z8eoy18v16UJ7QfNfigN0t1khOBhMtE5IbyhgIrL3zxzLvT8qFs2kRvHHxz+kw/U3rs1ghvH+Esm7TnUo0b7WqPX06g7sdUD2v+OwWsTex0CQVn5PYfZXWJszGMTgcIcxGtGVN49cBkRFf8VDIOLHh+TQ2YHROGTHboMIcGX6qb3tfdZL5lso+RZXxL2tZFVfBBqmr0Akf5FdNm/2eBNWTi/3ivyRPWHKnZ8Z96zi5V+lJF8PodcAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k5zGtt47H9t3q8PQmD/JIeN4xCzA2TDjhLc/bv9gbc0=;
 b=maM81IZgir/IjiP0aa+kMAn+vlKuOWZGU/dLRKffzIBbuOKXezJNsqG7Wh58l04hQxwvFN+dd1IFFV7cjYnL1hGjWQudwuvMG/lGUkMYXQBkDTMS4BmYPotMPDukKqLM2n8Tfwa6Eo5yOhVLO+xnHWxq12FGhAJMPwdSeixzGE9ZqmK6SHw0B9pbb120fvVvOQoe0QPGkihmKuUKSGby51z9MjCYnriX8kHXRcBkc1hDUe11uvwGhUTQi+U8/Ew8eDNuYTN6SjGq7iVnpkgGMqOy11r005DMtRnvVWwCjyIewwIhDFoRpEhOuWz8P+1E48egJgMeAY0VTDzZLslx2w==
Received: from DM6PR03CA0065.namprd03.prod.outlook.com (2603:10b6:5:100::42)
 by CH2PR12MB4261.namprd12.prod.outlook.com (2603:10b6:610:a9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.14; Sun, 11 Feb
 2024 17:47:42 +0000
Received: from DS3PEPF000099D6.namprd04.prod.outlook.com
 (2603:10b6:5:100:cafe::2a) by DM6PR03CA0065.outlook.office365.com
 (2603:10b6:5:100::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.37 via Frontend
 Transport; Sun, 11 Feb 2024 17:47:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS3PEPF000099D6.mail.protection.outlook.com (10.167.17.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.19 via Frontend Transport; Sun, 11 Feb 2024 17:47:42 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sun, 11 Feb
 2024 09:47:41 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.12; Sun, 11 Feb 2024 09:47:40 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Sun, 11 Feb 2024 09:47:29 -0800
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
Subject: [PATCH v7 2/4] mm: introduce new flag to indicate wc safe
Date: Sun, 11 Feb 2024 23:17:03 +0530
Message-ID: <20240211174705.31992-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240211174705.31992-1-ankita@nvidia.com>
References: <20240211174705.31992-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D6:EE_|CH2PR12MB4261:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b659551-c621-4322-9836-08dc2b298c4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	awzC5TE0LSxMn4qr+GzBDMDcxV52pxIfhT9/r7CzH40NJzFNp3Xf+m3uM+NuV71HKTlT5++9Aqbb8oLB/0xoYvRSFaAD4ZQ1NIrynDE7/HlMkUD0PKdhNAyuolPDFaLtCWurwQe91+BcxK2ldQkQZEVsygvqQ7DL5ArrNbfSVOEV/DQx/ollSsmICx4gIYFP8V3BXFN82xBWkeW9aj2fbNz7M7O17y3lGCl4P81LlgT9z49LNcMWv6h2TWs6xNb8L1GPsXfcX2NsgB0kD7pUCSLQSOF8f0nik0lsEiQhhVbd6InvymtBdtknAzHfD4Bw2RqZRo7xt3bKhQr7bieGnJDC2B30weZoCSZ6PQ7/ay9+HY8SGajbqgfkYUcVZfayjMgmV9E3768WsNevG/URFDqTOqsz6jDFk8mxmTLbAggtiwp50bxnkUSHB47tu4GAyKS1+lI4XGYId08K6YwpOWswK7hRbbRE1dklUkOpe4ZXlcPt9mVgKIscFJcdKMb3SKd8iqDtrMZdbEnk7bEG5D7qhmlCLWdC1GM95OQgT3dZcVXyHn8DFnz6aaiM69DoLrXwpDeHEunZC2tZ0t0+vZj/F0EbeQMJ7u8eeQfNmxB8TZl+UjtdzlTlRXtE+V60PdRtO+URoslOsLJjiLwDeA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(136003)(396003)(376002)(39860400002)(230922051799003)(186009)(82310400011)(451199024)(1800799012)(64100799003)(40470700004)(36840700001)(46966006)(316002)(2876002)(2906002)(5660300002)(82740400003)(7406005)(7416002)(8936002)(921011)(356005)(1076003)(83380400001)(7636003)(36756003)(110136005)(6666004)(70586007)(4326008)(70206006)(54906003)(41300700001)(8676002)(478600001)(26005)(426003)(2616005)(336012)(86362001)(7696005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2024 17:47:42.6197
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b659551-c621-4322-9836-08dc2b298c4f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D6.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4261

From: Ankit Agrawal <ankita@nvidia.com>

Generalizing S2 setting from DEVICE_nGnRE to NormalNc for non PCI
devices may be problematic. E.g. GICv2 vCPU interface, which is
effectively a shared peripheral, can allow a guest to affect another
guest's interrupt distribution. The issue may be solved by limiting
the relaxation to mappings that have a user VMA. Still there is
insufficient information and uncertainity in the behavior of
non PCI drivers.

Add a new flag VM_ALLOW_ANY_UNCACHED to indicate KVM that the device
is WC capable and these S2 changes can be extended to it. KVM can use
this flag to activate the code.

Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
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


