Return-Path: <kvm+bounces-70704-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yI6/KmrVimnrOAAAu9opvQ
	(envelope-from <kvm+bounces-70704-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 07:51:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1484611782E
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 07:51:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 999663044835
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 06:46:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4D032D0617;
	Tue, 10 Feb 2026 06:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JkJFRKLl"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010025.outbound.protection.outlook.com [40.93.198.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F7732B9BE;
	Tue, 10 Feb 2026 06:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770706006; cv=fail; b=KCA3TzTZ9HciZManpFX5cEAn1tVja9T4cQAjEDt0ZzBL/hEpm5Hb63i2rU3KeCgJCBYfKjRFBiykx4MSUIvldtmHiVyN8Yl7ejxyiMv98Fj8nO1k29IB7D5xDdDV0jo/3MiUnR5b0o3M7cdXue0iYWkd37rSQGgIiQfqkvw8E3A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770706006; c=relaxed/simple;
	bh=mCCiPrOkWFKlkYRl/cMtgB0sMb3XS+w6YNAdEqszdyM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b75lhp9+ys3fJdbksoCEOs+jR8HYjR3UEp6ZQ9TRvGlow20HCMVv8vsV7+K02UXDad3OIgI4t1tcfr1q2o3mcDaHVanCBjwoosW+A0qwyztZ/4qeX03iaJCGo62z2CcpHMrUXxz4iITiBewsHaUB/HPiE4ID3Qqjn5GpgiTZZbg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JkJFRKLl; arc=fail smtp.client-ip=40.93.198.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qcrw7IQe4ytrdu6yqtu7MD7Zq8ngswAwugyDPKPs8aOfPzVi7kMZhf3zEbJls0MHYznXT6Lk5ESphOIYCXhtNEjV8ZdwG9uW1tWe/H8x5YB6yxcqgDM5s5CmQ9XXgsKtnFVC3tpHArT7/1Tj70/FPpynyDufumkeCbRwF6Ms4XJbL7yJmSItqC8r+HALiSreRdpu0Xja34PN3Td8oWiRB5u3KQT13MA1O9jiZn7ZO/KVIV3z49s1LoMn0cHBKhKi/4qAVnq3/iCOi6sckQ6Zg1p6bJBc8do838NQZEvp7q7pqpRvnIKdHC68LWDlrfKsr/alw6/GWiIVEvxSNT7H1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=554HFNYoYz3HNc8vu/Vf4UqDuGyPs5rZe33zkez/eHQ=;
 b=a7lIwzqjA7KIW3ROOfgX2xkBSg1kDyqdaqo/A/hGVjF6AEo/6Ffd+AaRAEiL42JBWwyIh4fOPhdjhdZhSPO8PG3ZWxj+19bk/4uWpWl2hXJYl0P++fWTAyN0e8fJoNzTh2ntzba08XV3vYH7/CitFVyOJpU7ZeoBObj3PAmvm9rcVzBohjB9XbEZmZffSrotw592S4uBb/IKWULMoyuBlDK7/UBsCZ0GfBnof8bS0SIlMaAhP3grcfYFGMw6SKKbzfjJGv3Sw8BaIM2Sq1LVuwUG+G57rLiEaWOXfu56pOsFkD8WhNm9ljgWF+IYBNB05/gTf8Ss9OmAyyE5I8OlWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=554HFNYoYz3HNc8vu/Vf4UqDuGyPs5rZe33zkez/eHQ=;
 b=JkJFRKLlKKNcNneSWEzkbxCz4nPY/PIKUPwfFT5TFGIwLU0bwVQk2O8npWHv56wEKkCvq+GiIdz8AmFXoNAnQRtsSrhCFo8icfQCfE7mWxzc7fNEBH5nkN9iSrsXs1R2HZ3CBMI6Htan6mkqBKZdfv9pLZs1CvQOZ9GEygI8bzbJSjc5qGVxOz8CDwFLBRjd7hzPcHS3nj/U95TzFk/zi64eIc4WTwTepZtSB/a/90auuJ1t32QvLvNP1K43aEODhXs3DCT8ap+Wo5MOS2FsiyMA6aY8aQbJ12WlrPFKiSe69NzKMQ53Ix3Hayg/uwBeGMC5xbk4dHyTEDaePAVP9g==
Received: from CH5P221CA0002.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:1f2::27)
 by SA3PR12MB9198.namprd12.prod.outlook.com (2603:10b6:806:39f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Tue, 10 Feb
 2026 06:46:41 +0000
Received: from CH2PEPF00000147.namprd02.prod.outlook.com
 (2603:10b6:610:1f2:cafe::5b) by CH5P221CA0002.outlook.office365.com
 (2603:10b6:610:1f2::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.8 via Frontend
 Transport; Tue, 10 Feb 2026 06:46:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH2PEPF00000147.mail.protection.outlook.com (10.167.244.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9611.8 via Frontend Transport; Tue, 10 Feb 2026 06:46:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 9 Feb
 2026 22:46:26 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 9 Feb
 2026 22:46:26 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Mon, 9 Feb
 2026 22:46:22 -0800
From: Gal Pressman <gal@nvidia.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Naveen N Rao <naveen@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Gal Pressman <gal@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>
Subject: [PATCH 1/2] KVM: SVM: Fix UBSAN warning when reading avic parameter
Date: Tue, 10 Feb 2026 08:46:20 +0200
Message-ID: <20260210064621.1902269-2-gal@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260210064621.1902269-1-gal@nvidia.com>
References: <20260210064621.1902269-1-gal@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000147:EE_|SA3PR12MB9198:EE_
X-MS-Office365-Filtering-Correlation-Id: 60f13811-6bb8-43ca-01cf-08de687025f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|82310400026|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jYR2HUqiN2U56qsePTQ8OojfcQZNW/5q0w03KZ4kBoYMQ+KQnNR3iG5wXgxL?=
 =?us-ascii?Q?CRs33qp2fPZ3CKAjaoBZ+iR6OEfoa/w+SHmsyxECYEdpT/2S75acXSVkP1gF?=
 =?us-ascii?Q?LohOZGmFDJ9xGUj+IbdYUlVkYmSWqUvOereUDuCRCpvDih5GWjJr/7Ph5vtF?=
 =?us-ascii?Q?2kX0DudGzdDuH8hx/lBIj7oHmJpK69faXBfmzzs6kz0zbgmKkJDlGolgpfzY?=
 =?us-ascii?Q?6nLPdc6ZCMYxUftwTftaIAk+WoFYnx6cxu2lpyyhFOR95JW58QiVufxL9rOf?=
 =?us-ascii?Q?WM5T9kOrfD0+Kq522uGtib1EbaFqRbU5PQoN0XHSuu1IL2bEH+IDVtid6sHf?=
 =?us-ascii?Q?DIEwAflrImVC0VntUrDPZS8Jp8UTkxfDDUI4TOvIsvMRuOrrkjpf4miYe+oI?=
 =?us-ascii?Q?Jv6V0F7PIQDSm2LKx9nseZzMsGBINlBfQ/gRxv68eM/sgKS8IkOinTsFrxsi?=
 =?us-ascii?Q?qfSOS5+Jp/E5d8ezv/66xGjSazJqiIo/8EPQrWotbNuhKYpKkBB6gkGW4EqO?=
 =?us-ascii?Q?aaZ0JTJvpmtumpZN4OVRU8c3LRmnnpm8Qy3EPgkI5eMVgnsPt1Y9Sz0p0KKF?=
 =?us-ascii?Q?+Ac/yxMi0Xg0Ki89etXOl8ifqGqwXFJAuvt4wQD6fdSBQAL1ULhRKv7+5uxm?=
 =?us-ascii?Q?qZriOaQ3UzKUCIyKcARadfJH4qSnY+dCpS4g1lVn9/X1MutwC3dsYU2lecXe?=
 =?us-ascii?Q?mD8JuyWSGiIiBGFvzBhuhukraN5qQ0xuEN9Ae2R4/ArtmnGtEFbnoT6jBvNS?=
 =?us-ascii?Q?8QOhDXTO5eFW0/NdyVQOk9Lj1hd7u+s2AjOv5qhtBVmMKq4GdnAx0780MOoE?=
 =?us-ascii?Q?sivO08R4Lqn4xcsPMK7nmjKEKwdfHIJUj0D/XVRrpop5M1WrJvTIexJJwTAQ?=
 =?us-ascii?Q?0M/AHsffgb8S3m//AULo8mQ/dDnPD0fCAbZvGP+Ibvuga80vCT5tmfiyRPA/?=
 =?us-ascii?Q?Nn3yfgJR4kaSy4aMu+zu641agB62voViTl7FcOnZFt4Kh7jUY8CdtiGcmc2P?=
 =?us-ascii?Q?qgPXURipAP7i++/m26xK17obr3kXkoeTsrgU6spVyRtBLBVC8HRQhEdW4XXn?=
 =?us-ascii?Q?1zvoLnbQtvjMUKeSiWrKnbJD/T1VZUKM02DG9a5I4Lj2AEOCAoAUMyYIyF3F?=
 =?us-ascii?Q?BHRElnY3yriL77U+c7srfMxIi05ElSlOiyULip0Z847Ufai4CMez304z4PXL?=
 =?us-ascii?Q?DCnDdnU66EC/JVFkD1bFQxOu97UILlldJ7ExolzGFbBw9NX1xUFEBQpvGnHI?=
 =?us-ascii?Q?H4Y6l5G7IotOTeu/cIbNvrorjOV68QpVFasWtcJxHJf4/fdvhi0oeH5FXLjm?=
 =?us-ascii?Q?kphlQ1SUJNIGm+BWvFQWx9+RJwRae1+3kztALy8IACijpQcbhlRFp3ttAk3V?=
 =?us-ascii?Q?V6edkOp76RXRD5FxICsDaU+6T4wrjrjOwnB5AHh4AFHvbNQA/9l3nfw0MrK3?=
 =?us-ascii?Q?GL0YUPyRkBXRSbS1mN736DR6mFHdrV8F6uN7JQsiMXsvKSB8zH0iazHXJ+m1?=
 =?us-ascii?Q?kr1TaWPUrmxxf/KMxVUTNSLTQ7AbQQK+mKUG+GOo5OG88YzoHdb/IGf1Zmos?=
 =?us-ascii?Q?QpqKHttlLAI7jY0fizjXhohvHDqGBKsgSzosAx4jo58kKdLhxQV+jWw4q/JL?=
 =?us-ascii?Q?cPIF0RXGfnYAxbmGbCjtPA3Hg54Gld+FA4ECOsonioz6tQx60AmhyeZxpa6+?=
 =?us-ascii?Q?pc9HF1WIosoh8kG6EstnK+hIBeg=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(82310400026)(36860700013)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gA0BLgdkBM6eGYwPbsSZGK7i2E4ofEHA6MKZ4EdtPnsapKialuTrQjLMGFFXG2JtpYKG5uQrkvPzfOaSWrkxH/Yaz+n+x/f3QjtGBhbhz3x8h03h+oeSRD1o+2yHbxs/5DdmzE4RdYIp4ACZQ5OhrEe4HXAk90rzxQR7GJOhkm9fkhOOGtoDh+QGdYIIPnzBuS1BBVO+jGg6ga1KnzftGW2y63Se+PvEq3tgnfI80WGMq7ySxTt0T+rSYcu85seIZ3Lt7Sv/EWMJO2kc6OmdCIZr1g3E/BY9xY8sxAhJbPlLACuQ2eIc7j0y1p4BQe5ASguA86ejl7iN7XB91EZkjKGQnJZb13AR6W7JucW5aBQR3qtSKcCKUgeBoQ/W0VKi71LTVxZzkebd/zO6ABlkT7MgcsZRZFn8qRq3F8Tn3RipoCfLj8jmtdU1cwzKRBGA
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 06:46:41.3844
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60f13811-6bb8-43ca-01cf-08de687025f3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000147.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9198
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TAGGED_FROM(0.00)[bounces-70704-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gal@nvidia.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,nvidia.com:mid,nvidia.com:email,Nvidia.com:dkim];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: 1484611782E
X-Rspamd-Action: no action

The avic parameter is stored as an int to support the special value -1
(AVIC_AUTO_MODE), but the cited commit changed it from bool to int while
keeping param_get_bool() as the getter function.
This causes UBSAN to report "load of value 255 is not a valid value for
type '_Bool'" when the parameter is read via sysfs.

The issue happens in two scenarios:

1. During module load: There's a time window between when module
   parameters are registered, and when avic_hardware_setup() runs to
   resolve the value, where the value is -1.

2. On non-AMD systems: On non-AMD hardware, the kvm_is_svm_supported()
   check returns early. The avic_hardware_setup() function never runs,
   so avic remains -1.

Fix that by implementing a getter function that properly reads and
converts the -1 value into an 'auto' string.

Triggered by sos report:
  UBSAN: invalid-load in kernel/params.c:323:33
  load of value 255 is not a valid value for type '_Bool'
  CPU: 0 UID: 0 PID: 4667 Comm: sos Not tainted 6.19.0-rc5net_mlx5_1e86836 #1 NONE
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x69/0xa0
   ubsan_epilogue+0x5/0x2b
   __ubsan_handle_load_invalid_value.cold+0x47/0x4c
   ? lock_acquire+0x219/0x2c0
   param_get_bool.cold+0xf/0x14
   param_attr_show+0x51/0x80
   module_attr_show+0x19/0x30
   sysfs_kf_seq_show+0xac/0xf0
   seq_read_iter+0x100/0x410
   copy_splice_read+0x1b4/0x360
   splice_direct_to_actor+0xbd/0x270
   ? wait_for_space+0xb0/0xb0
   do_splice_direct+0x72/0xb0
   ? propagate_umount+0x870/0x870
   do_sendfile+0x3a3/0x470
   __x64_sys_sendfile64+0x5e/0xe0
   do_syscall_64+0x70/0x8c0
   entry_SYSCALL_64_after_hwframe+0x4b/0x53

Fixes: ca2967de5a5b ("KVM: SVM: Enable AVIC by default for Zen4+ if x2AVIC is support")
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
---
 arch/x86/kvm/svm/avic.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 6b77b2033208..48de0f475ca5 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -19,6 +19,7 @@
 #include <linux/amd-iommu.h>
 #include <linux/kvm_host.h>
 #include <linux/kvm_irqfd.h>
+#include <linux/sysfs.h>
 
 #include <asm/irq_remapping.h>
 #include <asm/msr.h>
@@ -76,10 +77,20 @@ static int avic_param_set(const char *val, const struct kernel_param *kp)
 	return param_set_bint(val, kp);
 }
 
+static int avic_param_get(char *buffer, const struct kernel_param *kp)
+{
+	int val = *(int *)kp->arg;
+
+	if (val == AVIC_AUTO_MODE)
+		return sysfs_emit(buffer, "auto\n");
+
+	return param_get_bool(buffer, kp);
+}
+
 static const struct kernel_param_ops avic_ops = {
 	.flags = KERNEL_PARAM_OPS_FL_NOARG,
 	.set = avic_param_set,
-	.get = param_get_bool,
+	.get = avic_param_get,
 };
 
 /*
-- 
2.52.0


