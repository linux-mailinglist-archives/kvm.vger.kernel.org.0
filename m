Return-Path: <kvm+bounces-31682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 39DB49C6422
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 23:14:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE3C31F233A9
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 22:14:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05BFF21A6F7;
	Tue, 12 Nov 2024 22:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jXej/ZmU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2060.outbound.protection.outlook.com [40.107.92.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9827621A4D2;
	Tue, 12 Nov 2024 22:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731449686; cv=fail; b=VZ0dCGAA758BTxlJEQKsH2z7tT63JdK0Jty2aLfnRpzKythpW4qKrxSv1NDQgnbF1qy6ywZQGAFXPnilE8ZwHjDWL6N4j1o4CCH0saiHUbKQ+8OboSDVucFt7yG7xn3lT25jFDOnFU8aI19PRJ6BqjSKoEAh+clZvMqMjY7IXMw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731449686; c=relaxed/simple;
	bh=B/kzwKCZPfu0XoICXBjcTAcL+U8eL2Ci7WFIoTxnj4Q=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M7OQarjLgZfz6ugE1KfeyKNNugdCRE2j5aW15obtOpPTAdyJ7+skP9SdXcZxlxLKJ3136vm1cERneqruhlYEavHoymIzLUrwwWojDYC5+RMJ7y8EczQOPAFE4KcKrtTbdTd0gOwgGqnSGxYVC3c+vdqs4Fj25RHUbZvER10VGPA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jXej/ZmU; arc=fail smtp.client-ip=40.107.92.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cpHQdh7cMMbE6+Vtwvg1SNtjfTqB9kkh5lx/sJC2+rxdLvDFVQJsAxiNshWgQ1MLDvPeYJ635wHmRvDaitr0QrwVyRpmng7SGrdEobAuDJ58++kIk9b6L5QKSgf04wpllFck20IIyfHoRJ3hdEE92SyUYV9TmwmhKp2wExjJZUPfD2RbyKAoRGnV5GCyph85Z5yVrZGfFNtZ+m16vvYOidq2Nwcmd1UDFf2tJ3svF+HtgJijajtLYZc9PoX7Q7pqGfUPYP277oEcklZM/PcHxPU2WYItFJf32pLKH/DcH4XrSs0kESraG9nAPVckHQ/4+PJi/a2/J5cdruR/a7bL8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UB4xeYuA6q8m3dBRiRSVt+xNLC+ixRrYX0jR5oxj2ys=;
 b=tHFJEUPvtESxEvE12pDBnIcDk1j9kEjSk5oyylRb3e39BO55r6mELayKjvjqQP8w/ILqasisckh2N97nCKy/aeVNvxm/svdhqj3dIiGqg6EcpySjnOds7fE1++PQMUTK4R2oJYgIKizLZ1493sZmZmdgKd7TNDPtU1d8TP7PCCG+OFw9odGPauC/Vq1jo1d4/t/CAqvFiorJ7XuU0WwTdh3Nmmcbtaoh5CWnDNMo5jwTeX29GYsSHMfoDzjJy8MbpIvH4pliXbjSX1YutanCzYb8rKJr2GqWRbvMMgNEWcWiFpo4LR6O5My8XQMBTIcYBp8k8fIMa0Gg3YsGO27kRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UB4xeYuA6q8m3dBRiRSVt+xNLC+ixRrYX0jR5oxj2ys=;
 b=jXej/ZmU37LIfIIoHSGD7et9UHjZUJu7zjBPhKrkzcUsOtWKCrLYN4oXaxzxZIHrwunzqqdXasAK73eBC84AO/6YCKgG4Di3kbY/Zw2QCUZ0k9BMo4rtbEId7xS/3ReraPsEIpArFLjzElJFbVrCynlgvZSKc49elyhpyZc6ZtChXhuQFb+pj79+CIRvoq7Pi8r8MQlKdxCxbQQ9mmb9i62GLW3u1YCt/kdYcjExNxOT3/t0JOLq6T06iExV+8gSG+tc/Op3y+HbC+jbiGQU6sd0qN0z/zUI4Z5RRTdZ1f3AjlFc3CIgQVlbwCfAHnglb89gDI2zbP4nPrcXEvQT3g==
Received: from BN9PR03CA0296.namprd03.prod.outlook.com (2603:10b6:408:f5::31)
 by CH2PR12MB4085.namprd12.prod.outlook.com (2603:10b6:610:79::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20; Tue, 12 Nov
 2024 22:14:41 +0000
Received: from BL02EPF0001A0FE.namprd03.prod.outlook.com
 (2603:10b6:408:f5:cafe::a7) by BN9PR03CA0296.outlook.office365.com
 (2603:10b6:408:f5::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.29 via Frontend
 Transport; Tue, 12 Nov 2024 22:14:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF0001A0FE.mail.protection.outlook.com (10.167.242.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Tue, 12 Nov 2024 22:14:40 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 12 Nov
 2024 14:14:24 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 12 Nov
 2024 14:14:24 -0800
Received: from Asurada-Nvidia (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 12 Nov 2024 14:14:22 -0800
Date: Tue, 12 Nov 2024 14:14:21 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: <maz@kernel.org>, <tglx@linutronix.de>, <bhelgaas@google.com>,
	<alex.williamson@redhat.com>, <jgg@nvidia.com>, <leonro@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <robin.murphy@arm.com>,
	<dlemoal@kernel.org>, <kevin.tian@intel.com>, <smostafa@google.com>,
	<reinette.chatre@intel.com>, <eric.auger@redhat.com>, <ddutile@redhat.com>,
	<yebin10@huawei.com>, <brauner@kernel.org>, <apatel@ventanamicro.com>,
	<shivamurthy.shastri@linutronix.de>, <anna-maria@linutronix.de>,
	<nipun.gupta@amd.com>, <marek.vasut+renesas@mailbox.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH RFCv1 6/7] PCI/MSI: Add pci_alloc_irq_vectors_iovas helper
Message-ID: <ZzPTPQNxWDmh97cr@Asurada-Nvidia>
References: <cover.1731130093.git.nicolinc@nvidia.com>
 <e9399426b08b16efbdf7224c0122f5bf80f6d0ea.1731130093.git.nicolinc@nvidia.com>
 <ZzHPtwPdCehYyXWE@smile.fi.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZzHPtwPdCehYyXWE@smile.fi.intel.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FE:EE_|CH2PR12MB4085:EE_
X-MS-Office365-Filtering-Correlation-Id: 25991c69-3410-4997-8e63-08dd03676730
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?R/+c08bgVh7HUigQFcmeoK/PGRxeiH3UOE4nvwkwEdRxKbOkXUWKxq6LImB9?=
 =?us-ascii?Q?wXqi9rOjJCunvA0UmyJlFcNbe00RLhntPAPa23uEMP9+8NNVsLSjT5rBLhRD?=
 =?us-ascii?Q?+TJJcv3RUM8Le1Xpc0fHyYDnht98B6nZ5YZrbt2ArgAipYHBjz4XrAZb0whB?=
 =?us-ascii?Q?nydXWSzOHIPsysxbo+nVbA7B3yB0iAC+JWjeLi3c4t4rSFSnRS0m7Ios/n2D?=
 =?us-ascii?Q?kI8mkloPsck8djTvh/NyY3nrVmmaIx7j3leG9rNvT8h3DszmHRqO0TXw1S5t?=
 =?us-ascii?Q?KweAa/yFvwVdtc9euj7Kb5buXYT4PdLyBaSdtjbZOOKo6RlokuX1ec3pGY/N?=
 =?us-ascii?Q?Ju1y4VpqisxA8JfybyzlwaHex+RJVI3tZY7d7Dm68rK8g2BIbRKmCBJ53pay?=
 =?us-ascii?Q?x3ghivlRc/cLJqiaAEaR8F2fOPw86hMm2B51CLQCoqHlEC5EuS2CZC6ARihg?=
 =?us-ascii?Q?jH9IqZum983I1EzKC6ZENSGAbwe0K8DqfxJy9yNtnftkp2JudxSoQrBC30ks?=
 =?us-ascii?Q?34SpqRdGRHawo5GS4/KsFCGIWXfw/TlpUmHBD7YkvE5WVp35Q4gjl/yPRCKJ?=
 =?us-ascii?Q?Wqow7RAxA+/mihnBBdUm/+6rfci9QyI/S6UAqwSKBLsKfMZYPoq8kU9Fl/H0?=
 =?us-ascii?Q?w3bk+B5liEfqR8ivRuM/W9/4Ekzuv3KazLbWdOgCzHVWKIP5xJ1TejFtQbvh?=
 =?us-ascii?Q?brL4TNl+VZjweMuKKM0C/+1zvcXcr7dAjUjYqJjCChGOW6ZUc2q9UzxYHF+C?=
 =?us-ascii?Q?SQ4V3rECTbZsdXB5BIhIpomTgP+KaBPOOlWFQ7dgYZQM1PDt0HJ9C6wkFt5j?=
 =?us-ascii?Q?yYKbVc03G23uz1RSv2RV20Ke7x7U1ISrpi4XMfVyfjNVOHFcF5mWi/LujdAW?=
 =?us-ascii?Q?nqfvFmGtrsjpc83MYoFAoG+1rsFplXhlRuj93PJA4m4557OetFo6gTogub0L?=
 =?us-ascii?Q?6TRrwGHrXKszLdEKnD2doYctLx1dpkVix0PKx+YFgyhwUpSJS5Sq4uBlimND?=
 =?us-ascii?Q?QZhWoJNcZ9VC3Fqq7rSmGagNgDa5wCEbZo59xkQe3ZXIJI2IA8PblGbZVpY8?=
 =?us-ascii?Q?xLppkQ0vSwXeVs3GNj6E2Hed9GGE/hL6UMdQcK3HfY36EqBowxZSmrf6CKAB?=
 =?us-ascii?Q?bEUZfSzVHOvBR+zdQm48jtYQNyrIfXiNsQ5mT6kY8Vu4gP4XO2hMrzz00H3g?=
 =?us-ascii?Q?nkGXVLiaxxDWxGF7UDJ73a756FwR7YvyrEfAuY6+YLIGW7W+cUSfkIj0tOgH?=
 =?us-ascii?Q?G5wac9SH2r2qSoFiVntmrlRsKNEQFX2O1ubE50dORy5/5PE3ooMfR1ud5921?=
 =?us-ascii?Q?h7yX0vcfiBT+Ki/LxLTOkdOw1pIu95CHUKCLgwToh6xlINyBMuJAMRQckWGI?=
 =?us-ascii?Q?8O6VeXoiRhL+JdMW87jYTFNCUj6qDfqE1amzk6jXw2totRphog=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 22:14:40.2509
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 25991c69-3410-4997-8e63-08dd03676730
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4085

On Mon, Nov 11, 2024 at 11:34:47AM +0200, Andy Shevchenko wrote:
> On Fri, Nov 08, 2024 at 09:48:51PM -0800, Nicolin Chen wrote:
> > Now, the common __pci_alloc_irq_vectors() accepts an array of msi_iovas,
> > which is a list of preset IOVAs for MSI doorbell addresses.
> >
> > Add a helper that would pass in a list. A following patch will call this
> > to forward msi_iovas from user space.
> 
> ...
> 
> > +/**
> > + * pci_alloc_irq_vectors_iovas() - Allocate multiple device interrupt
> > + *                                 vectors with preset msi_iovas
> > + * @dev:       the PCI device to operate on
> > + * @min_vecs:  minimum required number of vectors (must be >= 1)
> > + * @max_vecs:  maximum desired number of vectors
> > + * @flags:     allocation flags, as in pci_alloc_irq_vectors()
> > + * @msi_iovas: list of IOVAs for MSI between [min_vecs, max_vecs]
> > + *
> > + * Same as pci_alloc_irq_vectors(), but with the extra @msi_iovas parameter.
> > + * Check that function docs, and &struct irq_affinity, for more details.
> > + */
> 
> Always validate your kernel-doc descriptions
> 
>         scripts/kernel-doc -Wall -none -v ...
> 
> will give you a warning here.

Will do in next round.

Thanks!
Nicolin

