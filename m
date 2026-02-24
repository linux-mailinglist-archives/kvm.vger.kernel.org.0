Return-Path: <kvm+bounces-71590-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sDfTA5hgnWkDPAQAu9opvQ
	(envelope-from <kvm+bounces-71590-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 09:26:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 683381839F1
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 09:25:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 335F2310C49F
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 08:21:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8BF636657D;
	Tue, 24 Feb 2026 08:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fCuqYHXm"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013016.outbound.protection.outlook.com [40.107.201.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ADDE262FD0
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 08:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771921310; cv=fail; b=j6gTPI5KqmDE0Pb1VOO1D5YkpAiMi13tVwzTETO98JKU82rfoQjDI24ZsXU9awic+ME+YzX94CusZz8quvaV85SzGH8nbHWVhd0FUCb4dsGpNccHvz5AhxagUIv4+nc/LOwvT9X5ZEXGx45qkNori6WCXQUqXAkXCuim1Crhfdw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771921310; c=relaxed/simple;
	bh=ji5otG+A5W/SAN+Le2jLe66PlQfKRFQ5WfQtt9xMotw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Ep2i4CNTiXJisaDbiATEMocM1UefyGr7x2XL40wQceCc+BNot0hmjgRlnRCX/X+KM1jZge444a0HmeDljWX8b+oRA1KqPD+DFeRJ+IEBMjePXFAazrmvCKD+bi9tqUADMbuXSshUKcdDKsQvW4VCb6G97jo+edh+SJZZSKgeDDY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fCuqYHXm; arc=fail smtp.client-ip=40.107.201.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zS8yvWfn0zZJFDGO5fYHRthH5+6kIt5lSbP/vOmO+BgJyZ/oXL/eM+7uOoG3zWMjQCAmPuGN/KchwVt7oPiUDR+CvaR9/ruz2yCbH3Rf+iOpXeVcuDtju4f4HYTHGfI3v+31MZm0XgV4kampTJ69Kf199QqyLu4ljKb9+A3dUaEaFLVIKtPZHwSGtxaiZNb6y8M+ZE79ef40ZGouMOL5KGOtwTqfXVqxTScJBBzhoPrrCHqlFExEhczOpkUSCicSSXXh1JnDiFMVtQMUORN8Pg3Z/3GrR7AphKDUzWmUESJZLjkNwsdx01Ok9glghe9KIsdBJVtbDQS8+BlpPGm92g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nUmkPY8eU3zlNixrggZTjdkxDELBrQ7nAZZQP9JrQrs=;
 b=aWOO70steKT+D6aTtFNZZDJmZSC70WQxQmQbbSG/4UgalNwVYqJE3V1b9+vNCeXwV5A8i/SJMFnVftCSACp3MURiv6D/X3foBO/78hOWPaDXWPfulF9YS4DMcOI/jPKWrh0k/Wa5n5lb3A8FODzEwp7B5N1n8HEtF3KPi7imheG4ZzhwknscWb80/elRcgLbPzvMcM+Xzeou3oJwjyOgwfXSiGwysLRTm0fZXunRzLyvSBGGgcls9yio1UAN0CSzLTSgovkY+G0TCODZpPc7kgFjB2Hl7PdrFyOG37X7/tBnrwTWEBuKoN9KAeqkE4zRKbsD3osvr+yOCdv7bkK/Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nUmkPY8eU3zlNixrggZTjdkxDELBrQ7nAZZQP9JrQrs=;
 b=fCuqYHXmOC/KveOvSFSQlR9mIfavncvoBgiDDxLYbGqmFPqKt353ICwt0iPE+RgjqyokUUv4kJ7ImK6M8kE3g9hpwC8cEg190/tlUZ4R/e17CKrTjVhQAgsEP9fkuk3D0sO9Q1S+4Jj0mDD0FZ4ny0+AeMtWFm8HojTSPcE8Te50GAdcVMG/tbu4COzgxQQo1Gq7XiXUFFzraz+3CGjsjvob1loKgWxeX+wvvlhZiD1vu+WEoHEDPGXMmTNqBwER40DDA+RWy8irefIKQEKJSwBzooZltZ2EXkZh5BVCYtrGR8g4K8wmteV0j+uXsCwTJHlxjzdEt89RlQ4yRz9xIQ==
Received: from SJ0PR03CA0294.namprd03.prod.outlook.com (2603:10b6:a03:39e::29)
 by CY8PR12MB7490.namprd12.prod.outlook.com (2603:10b6:930:91::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 08:21:44 +0000
Received: from CO1PEPF000075ED.namprd03.prod.outlook.com
 (2603:10b6:a03:39e:cafe::32) by SJ0PR03CA0294.outlook.office365.com
 (2603:10b6:a03:39e::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.22 via Frontend Transport; Tue,
 24 Feb 2026 08:21:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000075ED.mail.protection.outlook.com (10.167.249.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Tue, 24 Feb 2026 08:21:44 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 24 Feb
 2026 00:21:26 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 24 Feb
 2026 00:21:25 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Tue, 24
 Feb 2026 00:21:22 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>, <avihaih@nvidia.com>, <liulongfang@huawei.com>,
	<giovanni.cabiddu@intel.com>, <kwankhede@nvidia.com>
Subject: [PATCH vfio 0/6] Add support for PRE_COPY initial bytes re-initialization
Date: Tue, 24 Feb 2026 10:20:13 +0200
Message-ID: <20260224082019.25772-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075ED:EE_|CY8PR12MB7490:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b20d394-1824-4b1d-0363-08de737dbec5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MRGQNNlXeKn1XDxb7wUgAYox0MZBE4GrecQxxSeYh1JmFW7Cjaw1Y9dlOtgY?=
 =?us-ascii?Q?QhJk/z+mxLbiEpS9GMXqd7UD3ipEPLxCo3o9QAxIN1UQQUoBNj51EzFMt+EO?=
 =?us-ascii?Q?ft6Lt/4OpoioCc084o/YfavdGs4j+5YX/ff/CfcxWF/OGYyduWUPDPPSib/g?=
 =?us-ascii?Q?IQtuCBr+xCrGFeNF4nzWNdKygm0HzlXmg9gWH7QTEtm+ugr7cea4B2jxjFyO?=
 =?us-ascii?Q?vEKeaFY4h4KF4FxNDs5H6mj6mCVTVFxyVrjYHwxGaOoh3yC8MmdrNYA1zxC2?=
 =?us-ascii?Q?zw3Vl8x+nLxcW7IyaXQwWH/avBRnAl45j+aWEK+YzLVHLkRVAAi6VpblxSYf?=
 =?us-ascii?Q?uhtCniCjGyqCIF+NtPPNaKqn6ocJ5W26AyyskZeLURQ0YFWjlquFTTjy71NZ?=
 =?us-ascii?Q?hMpku5cgI7kx9wuhcZpfCuwEV95sXeumwDAdx4O90fQXMQYykvalvRDCCS/Q?=
 =?us-ascii?Q?A9LsF72gDj3pvyhRwNGq+3UChFXkvz9GGs/4okZChBhj7V6+u/6B/rd1Cy+M?=
 =?us-ascii?Q?msldRWsf4vEKZp25543577ltm5sPHa0I1moTIBaB4QD4b+z8Z8HbJmadWcf9?=
 =?us-ascii?Q?OXvK31P61iYvUtg7Oqh0c92sgH5U3WrP5GaixJikkUB6LwIoiYg3q5bZU0dB?=
 =?us-ascii?Q?nzqlXWDMQVBTrpKQWsmj9yTjV55OTqTqUq1n2ZXi1HbaASxiBlvqQera+7Ni?=
 =?us-ascii?Q?wSBzPIC03/bWirdR1L/O4VAT1p260otYDNxSJsDxf2yJ1oS72ab1dn7qalBx?=
 =?us-ascii?Q?izyAj3jYx6+50jdaLe4RkxptGYh8iUDpwEDMjzMXyk8ugvyflJ0lTz2KF53C?=
 =?us-ascii?Q?NS0VXMut49xbiq+lM6ki35ZGd1yKVYckzyIuhzOaqOXH3C9U0ixtGR6qY3Lj?=
 =?us-ascii?Q?xuj56dtUenAc7ese+pCS2kILpY/9JlpzhPIMd1TNXzOlqREJ0dit8Q0Xxh1I?=
 =?us-ascii?Q?26AugfoEqVIZy6H3xeB1HHAOkGNArvUfxo0EuT9iGBoAyyKTu1bjyZvwojSX?=
 =?us-ascii?Q?C8iwCsbjZIIBOykogjoeZ6WwxOTThM3jlkMrBujDX/CzhBYtSaqEwVlzpl8Y?=
 =?us-ascii?Q?DeQWEVSQEf7aloe+81uDKaEcH+scNMp1yobLn9Cv4yIdukKmJ75QVNZygB0R?=
 =?us-ascii?Q?GFqComws8yYCVtz0Xt90/Qa8vMckgUwK+UzCp2O3eOdPP7TSZI+Br4iAQEHT?=
 =?us-ascii?Q?nEWKC2/jqLFGS/rIdhHA0eKhkzHsNi1pTIXgoqojuBATTwPoy9mc3qCSGWIZ?=
 =?us-ascii?Q?cVFNvI2Q0FOLruitJSWWCOjLxVzKzgnh+YVHrE8P/daMwhkzHfZBC1hIcv9X?=
 =?us-ascii?Q?zZ0IHdYydC6rvKfx92AO5DhKTJwFM/UEZmW/IQ3oH5XEadi1YiotCy2t7dZY?=
 =?us-ascii?Q?GApAlyRdAvCw+W+QNPiiX5cNUfe6drF17JhTWtcApO5btDgskLE8Az35IiZT?=
 =?us-ascii?Q?I4Sr+pkBzd/Gcevmp9E3rskqQfacMcMVNmp6cAXKsN115P6Df4U2G3CCrgao?=
 =?us-ascii?Q?reNLe/8Kl9qUPNMxusap37Q8/2a82Pl/18V1rMaab1axKBzbCFadu9YKO16y?=
 =?us-ascii?Q?yuMgUmO+hXQ75h4mcAPhccX8g4UDHrlkmBeMAH76j2Kx9JFjq1Sw5rIEYh3y?=
 =?us-ascii?Q?vOtt3NGS2WZIEDWs7lcVlwPbLD+IyX/KEE3orKTMfRgRFxZONotllUBDiW9v?=
 =?us-ascii?Q?wy//aw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	UY4vh2F7fI7vzk0PnCBuNc/LBAyHKkiImhlTYjSoQMhn79bzLroAF+5cEH0PwWr6WZtg0igaNVr1hx6LoJ5KmQ8jJv9oT1E6kilUJ9rWtQ7WUHslYQcayJZRBnMXBgIc4KUoNfKv7KMGPic9gtAqeL4zVq8RZZbLKS591K2WZua5/AkV0AgsrdZ3IdrRK/RcMEsAW5nH4fLbBCbcF8LKBb6MUAq9f3RfDgHyuolqYnLAS2CHCa75UY15mbjWDyOmm/pjBKOda3mY8lptp64tjuKCAg9XMNKk7ldgNkkxN8AXekJRdHn1J58twXRLfCtqhpgHqqVkbda6tYAlagj55RfNAm1DjrrSnGHVk+7T7bHqVmnGur+czbHxU4hhcrOk5AgdCyt4Ai4jMt1/usrk3WfsjGoXCKT4PRYG7YwlCwpXXyMCGAuzFT9BKCTrJIRQ
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 08:21:44.0443
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b20d394-1824-4b1d-0363-08de737dbec5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075ED.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7490
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71590-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[12];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yishaih@nvidia.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nvidia.com:mid,Nvidia.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: 683381839F1
X-Rspamd-Action: no action

This series introduces support for re-initializing the initial_bytes
value during the VFIO PRE_COPY migration phase.

Background
==========
As currently defined, initial_bytes is monotonically decreasing and
precedes dirty_bytes when reading from the saving file descriptor.
The transition from initial_bytes to dirty_bytes is unidirectional and
irreversible.

The initial_bytes are considered critical data that is highly
recommended to be transferred to the target as part of PRE_COPY.
Without this data, the PRE_COPY phase would be ineffective.

Problem Statement
=================
In some cases, a new chunk of critical data may appear during the
PRE_COPY phase. The current API does not provide a mechanism for the
driver to report an updated initial_bytes value when this occurs.

Solution
========
For that, we extend the VFIO_MIG_GET_PRECOPY_INFO ioctl with an output
flag named VFIO_PRECOPY_INFO_REINIT to allow drivers reporting a new
initial_bytes value during the PRE_COPY phase.

However, Currently, existing VFIO_MIG_GET_PRECOPY_INFO implementations
don't assign info.flags before copy_to_user(), this effectively echoes
userspace-provided flags back as output, preventing the field from being
used to report new reliable data from the drivers.

Reliable use of the new VFIO_PRECOPY_INFO_REINIT flag requires userspace
to explicitly opt in. For that we introduce a new feature named
VFIO_DEVICE_FEATURE_MIG_PRECOPY_INFOv2.

User should opt-in to the above feature with a SET operation, no data is
required and any supplied data is ignored.

When the caller opts in:
- We set info.flags to zero, otherwise we keep v1 behaviour as is for
  compatibility reasons.
- The new output flag VFIO_PRECOPY_INFO_REINIT can be used reliably.
- The VFIO_PRECOPY_INFO_REINIT output flag indicates that new initial
  data is present on the stream. The initial_bytes value should be
  re-evaluated relative to the readiness state for transition to
  STOP_COPY.

The mlx5 VFIO driver is extended to support this case when the
underlying firmware also supports the REINIT migration state.

As part of this series, a core helper function is introduced to provide
shared functionality for implementing the VFIO_MIG_GET_PRECOPY_INFO
ioctl, and all drivers have been updated to use it.

Note:
We may need to send the net/mlx5 patch to VFIO as a pull request to
avoid conflicts prior to acceptance.

Yishai

Yishai Hadas (6):
  vfio: Define uAPI for re-init initial bytes during the PRE_COPY phase
  vfio: Add support for VFIO_DEVICE_FEATURE_MIG_PRECOPY_INFOv2
  vfio: Adapt drivers to use the core helper vfio_check_precopy_ioctl
  net/mlx5: Add IFC bits for migration state
  vfio/mlx5: consider inflight SAVE during PRE_COPY
  vfio/mlx5: Add REINIT support to VFIO_MIG_GET_PRECOPY_INFO

 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |  17 +--
 drivers/vfio/pci/mlx5/cmd.c                   |  25 +++-
 drivers/vfio/pci/mlx5/cmd.h                   |   6 +-
 drivers/vfio/pci/mlx5/main.c                  | 118 +++++++++++-------
 drivers/vfio/pci/qat/main.c                   |  17 +--
 drivers/vfio/pci/vfio_pci_core.c              |   1 +
 drivers/vfio/pci/virtio/migrate.c             |  17 +--
 drivers/vfio/vfio_main.c                      |  20 +++
 include/linux/mlx5/mlx5_ifc.h                 |  16 ++-
 include/linux/vfio.h                          |  40 ++++++
 include/uapi/linux/vfio.h                     |  22 ++++
 samples/vfio-mdev/mtty.c                      |  16 +--
 12 files changed, 217 insertions(+), 98 deletions(-)

-- 
2.18.1


