Return-Path: <kvm+bounces-57573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E0E79B57D83
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 15:38:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3FDB21883C1D
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 13:39:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D441F319843;
	Mon, 15 Sep 2025 13:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="P9B64z8N"
X-Original-To: kvm@vger.kernel.org
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011004.outbound.protection.outlook.com [52.101.57.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B94031326F;
	Mon, 15 Sep 2025 13:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757943520; cv=fail; b=Eh9UNVQceeiVs7AluujoATWqHhfVQ2u/9YiwhlmZwIGp2r52g32Drbo+ulb6AXArRdC1XDqB4zGuceop5UFXU6nGkgAAufQUuwgpVZaM0OnFZX9ZEW2u8Zewp4c2sHmlGrkn3Mhx/yTCGUv2kWSRH3Y9xtbosC8pFMDzVzm0s2s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757943520; c=relaxed/simple;
	bh=WpEiEeTguTS9qcOzgCEeGMewRlPu0h95IwapVCb2jRY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hGRALiS0FK1JmKMz1PWdyHaPwKiJNC31BhTax6NjemiH64KyAk/TQ4UZDMfKgL5PK7wyNzkkjyDLH0v9EtUl8M9eGKwrMiamP5Yx7ciBJhDjrDF7fG1AW/M5RuJOd10jySu8DSedkiAnwcO93nOecar/rs8uN/acCnhjtsdafZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=P9B64z8N; arc=fail smtp.client-ip=52.101.57.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XOnGa/GK53KzvJ7orCwr0o3lA178cGFrK9wP6ZQKkwoI1lbaOo+0fhDtHMmwArHybEHXtdoWGK/4ImTC/mmzes27Sse1GpJtvoFJG8gTSo2/H5kXeXfeNXBTXyr309psjHroyeIxjTmfK25hGiIzPRytBq9LbfIKD7w9dcd3ZhAanaVaG3wjhh0ZFzvNCndLnf8CbQRe7LrD3fipnwNuysoDAwPM78O8whRnDtX6AXDAgfaD2DeqNHRPjwJ+CyH+UaR96B+KcMNp+KclaiVMkUJCmbQUFvkZKl/MzY37wFsAyUDTpMzUGBdXy8w8edUwMOXowlXjnrwJArk3jBhJXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0qvFfWc/uJtsAdJBd529g2QnPiqXdmC2WmwrEHI06hM=;
 b=aGwPaG4nY13iSRsV3ykkGHWo6Ckt9jMaBYUDGJO1c2LZ9fd6nw2m8GV70WKm6Yr4OLPQE02hl/mKspw3ceuWOD4BYpV+/vA2c3qUu0+bn24lR352V6YBiQmm2WsEdxyhPII8TRKICe4lCzIbqe9/+H3IlWSRsAl4tfyKHkKBj3m24AbXQXWHhBpwo378h0cDhOExwJnHgUptTkx4TU5yYy+wogNlO7bhkyOziUP2/20BoPRsqeVYZoT3GzVIduRQBf9B67faLOE/9VsfouE/YAuT65CsimgPuELwJMTHXOPCHEGqL4Hn6Te/LpcgUaOlOqNlU6P5bXMyFW6kdUN76A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0qvFfWc/uJtsAdJBd529g2QnPiqXdmC2WmwrEHI06hM=;
 b=P9B64z8NLzOT/Wiq5G5fwZqgonRPO8MVLHIiSOfhiYJlLKN8Qtmu4fOQV6AV/Ddzp68Yiqp/SCjyID3mMARFsCWnHAMW9KHt8hG6AcOtJcPEEohv/y9XKsb6E66DypGqcpOlMGf8iFANz9b2MMwJNkwnAPBvztpU8nU95OM0fupPFl2N+THvPa5cL3jLlT0jRPVsn5PEfaBMGwJ9TsgWRDExuJKhX5uyP3H6aHhxPvxA7scJHxwkEGiPUSTATAIJXI2U+kd6iEOHcvzMX19iRcdE8jgbUUpRzpgdXzQCTyKiZn1QButZYUjj0D8CUqFLRMzsGSwQUguBcGfzPbVvJA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by DM6PR12MB4283.namprd12.prod.outlook.com (2603:10b6:5:211::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Mon, 15 Sep
 2025 13:38:34 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 13:38:34 +0000
Date: Mon, 15 Sep 2025 10:38:32 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Donald Dutile <ddutile@redhat.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-pci@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
	tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH v3 05/11] PCI: Add pci_reachable_set()
Message-ID: <20250915133832.GE922134@nvidia.com>
References: <20250909210336.GA1507895@bhelgaas>
 <3d3f7b6c-5068-4bbc-afdb-13c5ceee1927@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d3f7b6c-5068-4bbc-afdb-13c5ceee1927@redhat.com>
X-ClientProxiedBy: YT4PR01CA0190.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:110::15) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|DM6PR12MB4283:EE_
X-MS-Office365-Filtering-Correlation-Id: f95f116e-8459-4657-92c6-08ddf45d2a75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ibga0iXI8VOknZxL5xoMbJDjJbRpUzmjFu5gMUsQY7UTx2Jw/lA3l87QvdVb?=
 =?us-ascii?Q?cM1FjGitwEcO4eoP0DahQx2N8XLKJt84Pkahk2sMub59fQjpL+ZL+K3nJhqQ?=
 =?us-ascii?Q?I4fPNEer2WVMcMFbaxkeBGdbJ1336wjbHtSrDQTZk+H+lVqO6OjWmu1mMBe5?=
 =?us-ascii?Q?/7RafihA9J8/eRIS2IiyUaBRD3MoRUD4MsL3DZEn4RxS0RuGYloam40BBOMg?=
 =?us-ascii?Q?dHlPaOFWSbyfCtJet4c4dwAnCCyMfAF5/TXE2zpX0t0/pZBJFJYJpl9Eq09H?=
 =?us-ascii?Q?2TnvWwLTX3IOlIvQRpGgYymG2zFW7HQKH/Vxd8hIFK69rzStkZ+zjVsc8T4N?=
 =?us-ascii?Q?Lb3ayLrLR88anJGrMQjumOa6ZzbtZTjt65ojIlQRButPSjK2BWs+wmI9mGW9?=
 =?us-ascii?Q?OEg/U+czB95QSCblhzp93zg/rxZvMZxx71ueJ8Dbq1mtkkTF1D/VGBfwRoy1?=
 =?us-ascii?Q?ZCShnf+P1Z4ARZih+4ybX1mAzhYpKykktYUSWvsXhR97sOAARERIffxja5Tf?=
 =?us-ascii?Q?oyy2HFDkdWnvxbS+XZxg9gl3x+DrkZBkNnmSxB9mfMml8mhse1Pa1zqSKy1O?=
 =?us-ascii?Q?irE0LcWbUWs/Wwp7O/6sHifpdwP4LJhVSyPQ5vqAPnL/W0fy05+inryc33RS?=
 =?us-ascii?Q?N10kyhC0oBWK9uhLjmwRcVy24K06YZ3LXkTT88AAWSbmdQKDbil5BHagSVP9?=
 =?us-ascii?Q?uuEG8Ng/ru57s2SlrsB2kkfp2HBwS0fEoo+8zGcRucbKywIKr6sgJgaZMEE2?=
 =?us-ascii?Q?Q9ct9ix54PRxmVpFeGp46aKj7Rx+sZcjnZTyvzJ5sAruA+ql+nHIQ7e6Z8uL?=
 =?us-ascii?Q?gyU7d4q1GtpIYuL7HMGMC9i0eFZHesnmHtmHS0DwDu6rW7fV+jNFaC79fVFO?=
 =?us-ascii?Q?a5BrVN4KY4sehpiVNS5N6VD8ElTq6UII9pz+MT3qj1YL3OIJiH6V6oUwXjY7?=
 =?us-ascii?Q?acQb16MS/vAO1lEgRTF4roRVSpNyZ4HiDH7FKEwV0e8xZjSFA37vKchwmXe1?=
 =?us-ascii?Q?cXs19unA35txPezp9HdXqDgSCmabH+zudQYmJgrNPjO5C4C+t/IMGkhjWxHQ?=
 =?us-ascii?Q?oBtvNfeyTjU5pxX8VT1d5EQcUnMtXjiJF/bIZETTQR4J6o+PuqdzjxvIX6b4?=
 =?us-ascii?Q?gR67fM4EU1N9Mfonb72gUl5REuPIjneBCOEyDbwtZ+CQpv2sDOjGHeZPNrEZ?=
 =?us-ascii?Q?4bzjyH+bx2cqxlPsGRSDKio4l7Di84/dMGitK8/soIkEfzj0LZkKS9Zcld6b?=
 =?us-ascii?Q?wkxoo/6vR7V9K1wLevF6HdbuHooz8192f4HCQeN7pIWWxzjkDGrewDnG277o?=
 =?us-ascii?Q?bg7CAvGcfaEWoPvuwlvr/zB15MDTsrYkLC0QjQg84UDZp04K+ia3Yku/82Yr?=
 =?us-ascii?Q?L3h/0dkHpfhYdYozK7JmoCxqnoYcq1ZvU3+iKW1YI803qfqHRURV+RbD71fT?=
 =?us-ascii?Q?GoJNZOpSO6w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LktUz4nqThIH4ZmAvrXcbNCGeWkG+wrxtB7cuDGm0So1R5PxS7HQGmlDV277?=
 =?us-ascii?Q?Mjuq4lr9/A3sa8YzlX2oj00nV1kSXIE9sqH+D9VXhIH4Q+tkL3lYi4r63YaZ?=
 =?us-ascii?Q?F8O+UnTAoXiJ1Nve4fEyoeRtgdqxC163ALjz8BqSM2MkJ4S3fIO+fGNfFUpV?=
 =?us-ascii?Q?byTy/o5chVBkIr87J3MbPx//VXJsdg/eLW4gRYwFagg8a1PjrkeGC/QWUxAm?=
 =?us-ascii?Q?ejfflJnhsMKzbV2DBarGYWsl1kgmJW/a3ajQ7Jv/SyUFYGe+iT3Jos+JkUNP?=
 =?us-ascii?Q?MMqoqT9gnt+mjAGKPK/rSed3ndj4qkzE7X2KB2rwzZfcuw0+pq8cppGs1tjz?=
 =?us-ascii?Q?1D3qbZPKZVff21a4YZVFZUiUCg0T7J+sM6/cQDSU9LahREEhVYdeoVSFY4gE?=
 =?us-ascii?Q?Z/wUP2ePR9klON1WeO9d0FkPsf7nZvUZwZhIn6YGMfu5NQCykXejqXFzQk31?=
 =?us-ascii?Q?y+/t3a+Pw6VohsVRuEXz8LH5NxCAdif4x+YwD6fKkjRRiabc5IkJpmcAjhfM?=
 =?us-ascii?Q?o3UeYVL/SCbB+QPsBEPtMyidPQS4THFhsISqwbUmGUsqo9BNu4YuISolUNMQ?=
 =?us-ascii?Q?D7JDG/ay86lIrVDHnD+jKZ6Y57xdPk2QQou+CMagaFSxDI4nWzsLA6TTa5AQ?=
 =?us-ascii?Q?xfQFWbDFfjjRWZuOV8tx0vwJqw5CkjGJLiqKt8Oj+ok6SufRPeY8VI7OHmib?=
 =?us-ascii?Q?11+dHLvTo3f4T/ibOfH3uizJXqPPvEdxWDn7bDK5onJX4IKpZLj6dtsLAjEo?=
 =?us-ascii?Q?UYNrwI48i+AQkU9pL58ct7R8Xhaw0jxZSw8qs9vgyfdCF06qsw8pnlQkCBQP?=
 =?us-ascii?Q?oQt1lFQE0Bx8XHz3gny23JJ1tiTg3YrNF1+7k2CUTq4AKg2J/Eip8o0AWyPN?=
 =?us-ascii?Q?Rys6oaajOe4Nszx3NS4aVCXrauNvGQzMNIcJU4ZjmD2Dp3vpl/3VegMQVRvX?=
 =?us-ascii?Q?qf9TyLf8vyzAlgEnn0JBJfHpfEn32Bbro6CZZ4sGumxPDotcncOb58r9j2Za?=
 =?us-ascii?Q?q0HI+MF9zjIszgMfgF3AfLHCloodbPCjew3NJMqDGk+C0dwpUbyO8ZJsAphG?=
 =?us-ascii?Q?oG3nQ5oTeHiBpUC6mfwTtotBIU35zxg8fvrjBuMn+Bf3Mcrty2d/+J90w1ar?=
 =?us-ascii?Q?W6fYKBjkloDYYcEA9M9PwT2vX8WC2h+ldFVZ8Dm9MOPdZINjWnNnO95zE3DO?=
 =?us-ascii?Q?nvqriUC145RgriFxs0ULGTI3PmqAmIdXwf4JqdBW4T6O8lRF0pUAo53uY5Qi?=
 =?us-ascii?Q?/A5/E8gbPaNyfWkbONbQkagQvOChqVBiO0rGI6c5K+Hhk+aH6hoIPHWrpYBu?=
 =?us-ascii?Q?al8q98jfKs79fRQlJ94J1OYBvzAQCLmRurvCQ9mS80yitboTKfJVPHtplsQd?=
 =?us-ascii?Q?Mda0Z/d0Kr4D8ZMlAvvrlOZVvCSwaCVazrOPnwQes0HdaiwLA4DaTV27sIEe?=
 =?us-ascii?Q?ov0A8qyRS9ebRpkpAK63FnOqcSX59chk1b0ULaSUzNd3nYPOu4RU2nVWplJx?=
 =?us-ascii?Q?hPtDI5Habrd6VWswgEMKaaGVydAEBSG5383DTk8OgoivJXRyX+oPHa7HWgpY?=
 =?us-ascii?Q?usKB6aCuNG2X/BRGjzw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f95f116e-8459-4657-92c6-08ddf45d2a75
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 13:38:33.9828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lqT0ORxrmQZlBlWBTvJ0JWr3k0JCS+G8lTMnUV1XO8zyYd/JlDGZHJwisV+JtDo2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4283

On Thu, Sep 11, 2025 at 03:56:50PM -0400, Donald Dutile wrote:

> Yes, and for clarify, I'd prefer the fcn name to be 'pci_reachable_bus_set()' so
> it's clear it (or its callers) are performing an intra-bus reachable result,
> and not doing inter-bus reachability checking, although returning a 256-bit
> devfns without a domain prefix indirectly indicates it.

Sure:

/**
 * pci_reachable_bus_set - Generate a bitmap of devices within a reachability set
 * @start: First device in the set
 * @devfns: Output set of devices on the bus reachable from start
 * @reachable: Callback to tell if two devices can reach each other
 *
 * Compute a bitmap @defvfns where every set bit is a device on the bus of
 * @start that is reachable from the @start device, including the start device.
 * Reachability between two devices is determined by a callback function.
 *
 * This is a non-recursive implementation that invokes the callback once per
 * pair. The callback must be commutative::
 *
 *    reachable(a, b) == reachable(b, a)
 *
 * reachable() can form a cyclic graph::
 *
 *    reachable(a,b) == reachable(b,c) == reachable(c,a) == true
 *
 * Since this function is limited to a single bus the largest set can be 256
 * devices large.
 */
void pci_reachable_bus_set(struct pci_dev *start,
			   struct pci_reachable_set *devfns,
			   bool (*reachable)(struct pci_dev *deva,
					     struct pci_dev *devb))

Thanks,
Jason

