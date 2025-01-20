Return-Path: <kvm+bounces-36011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A9AFA16D6A
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 14:29:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E5263A06BF
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 13:28:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D8901E1A39;
	Mon, 20 Jan 2025 13:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="E+SpMnQd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2054.outbound.protection.outlook.com [40.107.93.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE2C1B5EBC;
	Mon, 20 Jan 2025 13:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737379728; cv=fail; b=opnkNCjJQpNFOJS2wo4HXBAkOQJZJFYNzUIRgxRqm2k5/eATWjTjd9bVUot+p7TMjS1kIvjHR52SGvhJASGEwUjq723izVCUqHL3+2WcfFFBf/tkRTp9sAGa7k2QYus2vlA6Uq7WArD8/6vHNnVlLuzrXxzF/1vNFecbhkkgvKo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737379728; c=relaxed/simple;
	bh=yt68FeNq1G9h8BXVIbc/gsPc4hOfXX4Z1sEtQtWDftM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=sNuAZVVPU7xwboCP7tAuWiB8OV2ANrf3kPJLKNLUDt2kVlunR8KP76r3xi3jdNguPwojdTmrFyd7AXmxOoJyxg5blMXeD7ebLpIurxSMvw/XdADxOwtVuciFje2Rlpwlq011syVdUZywa2aoG+ICmFKt1aUZH5WauBjPSAsmQFA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=E+SpMnQd; arc=fail smtp.client-ip=40.107.93.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qahOrKKfsa5y18UAnCJHCApodLT+NUwCfCYmx6FQA20buNRL5xNdvpwcP3D9AFtzyhNR0eDq9VGzubis+fgSfimuHYlc8aal9q0jxUx7TIaOagZK0SSmp8K7/1G7PKqeFCGQ0MIyjGmDSX8j3JTWIWRCXCm3koCwWIYCsddJHPjtq4/QPJ2zjgemjzYe1zbf2lxVBhhbGaMuGWr26m2lhrrCx8Vo5JmhzefuG29GFh0tKAbU1j2ayzikIVfUEjtbFm7+gbhB+w29FnA5eCoiWl31TKP9Sre8JdHIrues6pFz8Ln3J4tI2B2Llet3CCFW7DxkbSmQYFSbhEWcE9H53g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YjY2hhx/sk+IJ9M7ap9qZpMNeLEjNaQ+Ctz4D/q8FeI=;
 b=A81gRw+6icN6mphV/qJ7RyHrev4FleXbBzDWRZ0OJ+ceUR2VUNLy29KAvpEBx0/Xu12+Zq2KapsmeRsP1j82ine2zlIUMstN5eKSUfx2DW5KH7axWKe0+yIYuJFegOnBVbxnSCQd4uNEj5HDv2JEo/A6oSZGx7a6+FwevQ4qnzRTjqpqPlxjYIqtY6j2l2jzn/zkpq0LUvfAcyQFUuXSrEVw+MvFr3zOFFzv+k8f4pO1x3YtmUplHtApBwnzM98/m0A5OdtG0mjqlpBh8PMKgJ/IxtT12MO1zcBuRiItUsLk2pTVvPcVIaK1ybr5KrSL5zKj4IQfryjHE67oU+/qAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YjY2hhx/sk+IJ9M7ap9qZpMNeLEjNaQ+Ctz4D/q8FeI=;
 b=E+SpMnQdcSGn8t7dL00HUteGXD9hGr75TNCvK37VQ1P6iaZaiqflf02fHtZdSQtb4cVs6zAV1PnMqAszqWymW9i3jfJXpNDsUoMtOkVfIXuzCsRwQvXByKGElKefih9in/h/8WmsZdqqdAA2XQvMOb/QpIFAphawGbxfGvCpqHJ4elqnn2wp/lDv4EJLnjTfytUC/mXlXgoCRZFPzWeGp4rsCZiwPwCRYu38LR1BKQgYxJDBaDIEnwr0bt4C9FHr8W1UP7MWFFGjSiA6TMk/St8SzrVd6DGmF49fb8/ZRnkysueF6wFogs1/c+2EeSsP+xHcg2auvPSuixnmoCZ8YQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA3PR12MB7922.namprd12.prod.outlook.com (2603:10b6:806:314::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.17; Mon, 20 Jan
 2025 13:28:44 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8356.010; Mon, 20 Jan 2025
 13:28:44 +0000
Date: Mon, 20 Jan 2025 09:28:43 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: Baolu Lu <baolu.lu@linux.intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>, kvm@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
	christian.koenig@amd.com, pbonzini@redhat.com, seanjc@google.com,
	alex.williamson@redhat.com, vivek.kasireddy@intel.com,
	dan.j.williams@intel.com, yilun.xu@intel.com,
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	lukas@wunner.de, yan.y.zhao@intel.com, daniel.vetter@ffwll.ch,
	leon@kernel.org, zhenzhong.duan@intel.com, tao1.su@intel.com
Subject: Re: [RFC PATCH 08/12] vfio/pci: Create host unaccessible dma-buf for
 private device
Message-ID: <20250120132843.GI5556@nvidia.com>
References: <20250110133116.GF5556@nvidia.com>
 <Z4Hp9jvJbhW0cqWY@yilunxu-OptiPlex-7050>
 <20250113164935.GP5556@nvidia.com>
 <ZnDGqww5SLbVD6ET@yilunxu-OptiPlex-7050>
 <20250114133553.GB5556@nvidia.com>
 <17cd9b77-4620-4883-9a6a-8d1cab822c88@amd.com>
 <20250115130102.GM5556@nvidia.com>
 <f1ac048f-64b1-4343-ab86-ad98c24a44f5@linux.intel.com>
 <20250117132523.GA5556@nvidia.com>
 <835c7751-d8ba-4af0-812f-2b3a9a91d0bc@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <835c7751-d8ba-4af0-812f-2b3a9a91d0bc@amd.com>
X-ClientProxiedBy: BN9PR03CA0176.namprd03.prod.outlook.com
 (2603:10b6:408:f4::31) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA3PR12MB7922:EE_
X-MS-Office365-Filtering-Correlation-Id: abb76b94-f9bf-4491-578f-08dd39565cf5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Olvk5NpNPcL91Z1Oib4ra1Z1WgiUZ9kahjlAz+isHJjyJJdNDaEPkJybg9An?=
 =?us-ascii?Q?xnMfQ4qVw8dQXXAkjVIetT+9gQJolIBaxJgXk81G8plq/LZ5feav2Vmtf8z8?=
 =?us-ascii?Q?0wCfl4o6nGZdD/eFWaSszmaTDSn7XXwInKWmVtgdEqihBY44MHewgYKeWFeD?=
 =?us-ascii?Q?f3mi82oJyQF1fEtvsVEsf8G8wEelfLkrZUA0/YJZdmNZUh199FxJ81GOmDP6?=
 =?us-ascii?Q?o24ZL3siB0kvcbbTAKiZuTTT2Dj8eOxjoBKHx3DTFnCYs3nWDjMdESK3NoY0?=
 =?us-ascii?Q?7g6/ipS0ZUWIrV71WrIRKK+zg1pv4bUhncCpftVQyl4cihMw2N2zxgJV5pjn?=
 =?us-ascii?Q?vIhWSJAwRmdBP/dmVyOGyUZyyL7ZZWP3d13HWHaLlyU0upIiqa22Av7Yxezu?=
 =?us-ascii?Q?25YJmBLRR3n4EMvTz6Cd6uEnhpWa64NN4mxJaKezCCMSyoLzgnAOdk9X3qMl?=
 =?us-ascii?Q?HeaS9O8D7yl92nat91ptpOo4N3nYSqTWwe1NLjEW142UHkkIpqvzmnrRbSSe?=
 =?us-ascii?Q?RQwnujaLF7loBLQ9ZnSCU/EhKvZYPieAl0xLOt4oxLLVxcyxre+nYHjumZAk?=
 =?us-ascii?Q?299ae2rWOgvSJgPpNQBFa9BPXhlqeRNKQT4gOjnVXN/0/433NcuE3qVWDH95?=
 =?us-ascii?Q?QUy0IT83A4lICV/GnCKF3rYaWsI3dwEnvyutQ+txaeqm8/gRF6dk4x/AwKbR?=
 =?us-ascii?Q?poUc3kKyeasNm48ctS1TB7TalVzyWV9lieknaP9YuZYw2Xsh/ggyxlQt3HNY?=
 =?us-ascii?Q?iQyDylvBiKjwdKZxPdUrAX67VSij7Tzif15jbzNyHE2ouUJWq/Im3X81ZYsa?=
 =?us-ascii?Q?KdyD7oNI9orKSoq5/Lunzl3obblZUb2Gu3+gG9JOefm61RbCoyDBwTmcUoio?=
 =?us-ascii?Q?PM/nMWkwU1ff//4dmTzSrjknHDlHlXVIYbvUfas0ZDUmi4qfF4LtCjSR0guL?=
 =?us-ascii?Q?LECHK+SmYYBfIy6qkWT5FOyoU6QWA76kvhBzpg1YDH7OIjAz0JBEjx+G55yY?=
 =?us-ascii?Q?GNka27n0zuA+jaUjncH6YsjF8sqAgpnqycL6GhlPHDb6ajTKiUnS628qVgR5?=
 =?us-ascii?Q?rug6k5oESQtGdnlqCvDA+8MY8hH5FPCGRZq5Gu30fTDQIr9RVdPXckc69Klx?=
 =?us-ascii?Q?JTnmDoZIkeu5CqPplvdDZr/4Pm5DlgfK9XP1CKDSKXVW6yikwB0Ni1aEUnN0?=
 =?us-ascii?Q?1r8cbLamlhXG34BWdOpENYLO2gpNSPSGqsktZWYFuL4BfPdkPemVOtgBrmm9?=
 =?us-ascii?Q?+tUhhAMjCbghr6tOJ28oFQKOpiZW+H1gp6tK73hA2/zE7c1sqQ8pAvc63CJc?=
 =?us-ascii?Q?iVXgUUzdhdmmy6ZRnk/mLXSIgad+nkgklWG3UDZWQbKSku4yFaDxKSsAgKY/?=
 =?us-ascii?Q?hFrxdyOVRcBXjPZTXrpuiJLhNNUb?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yPo8ezrRG4kNceRoUiC0LsBOyAKQHryauKx6BA/i/FtPcygWVk7hTJnPBt7X?=
 =?us-ascii?Q?OwiV33WVCvMU0+dAl2ZkmOrvlLUqz2TtJSjU8rfR3uorzUFfANYSW073eHrE?=
 =?us-ascii?Q?seMi4FmRjuK+mFLTX9LQFwFuwihEJivdhCh3id4ygAP78c1pSo5SyRk90eOM?=
 =?us-ascii?Q?Oo0S9k496ikFDCiAjosqYIzLYCAhllFYs8ymXlAAHxiLF1jOJO8G9YL8Gig2?=
 =?us-ascii?Q?WdIlgmpU6AEpEkbgp/+Iep4tE8X2RbEAGcomvlcr0zRay1VGBUkHJLgUPGhQ?=
 =?us-ascii?Q?Uec4h/4dxZEMWpvGtOW81EKGAxd711/LWIpKn06J2rjNBDI7RoO5NzTjaIYx?=
 =?us-ascii?Q?ua4hhUWtk9w1M6U1cs63M9QP2kFJSc8dTcLZuTFXfqcBgQpeYy1BP8qRnxGZ?=
 =?us-ascii?Q?wlRDUICpnsrS5cL5SJDeKwfMItCkDGwjCDoDWKA0+oYGkGkfyBh7Fry430NG?=
 =?us-ascii?Q?Qsokyd4T0WfJBFGg2S3rd1t6e/QO7vL+1SJkz60TdXfil6eOhbUWKXLUzYAp?=
 =?us-ascii?Q?jIIQG50dmEqhUJXdQqwpCa+XYsiaik7Zt3TyO+UCU1SyoJn1J52Vxk/JyzPu?=
 =?us-ascii?Q?jaA5op50EKz9xqCxnJ9f7Pz7EaREj1WZG2lD1YpwAE97QPMCpdOtBI/iAvxz?=
 =?us-ascii?Q?GKMVxOVk2gmL9muZtVkLWhZn4Grju1o8fdP/ZI5QBVBtR1vRKV1Ilr9s+ETG?=
 =?us-ascii?Q?mM2Vut/jShH+vDRTYqOEGcpGgoA2ipYG+qX48BhIbeTZBSRfXxeYTGyqQeW/?=
 =?us-ascii?Q?T8RVx76HR0GxHoyT1r++VUnAX3ICHOvYFBP7sOTTCgfPIMt23r9Xt1UmvwSF?=
 =?us-ascii?Q?UT5r+Cn2uttiiZeg4rXjjGuB9pmm//4QDnJ5zamnXyRsqfvy5iUWIdXq0OgJ?=
 =?us-ascii?Q?xOhBxU78WODLFNbsJirdnRowfkiL/Kl3HhYJllUxAyJKgaqqM2Zp43bHGOHA?=
 =?us-ascii?Q?SLxO1NAF0GRXVqKYw593fNBI/mpCh3HC4NHx8MdGvkDezPnU/e1RhOyk/ACb?=
 =?us-ascii?Q?rPcFUC2F32JNmrCPfmQTWXz//RRy7A8Ou4PupCAX22Q4cq7MMa3dwO1gtft9?=
 =?us-ascii?Q?lA0W6EQMJNx/1MqHWMoIHmQnSymjZRZ/a6O0g9wlzJr04xlvep4ITFD1xiu4?=
 =?us-ascii?Q?x9nRfsisKjkTYnAfu/TiqGoODUtm+ztDFw+a9qekAol5afh83zl7L119wGib?=
 =?us-ascii?Q?4q3XWKwSmR16Pl3irCwNWqSTexrKV7fs0cHPk5WnWKp8Fpo2CpwHMeBaa9wd?=
 =?us-ascii?Q?b/9A3b3Q5YYACaFKnkfzOlFdHf+W74hqGVbgDg09WGg4H7I8RkKWImjKdVEI?=
 =?us-ascii?Q?8/jK3CBY0Ii8kVqAV525/DD5pHvsR44zNLY2JVXOXLzf1+cfByHCUZRnK/mw?=
 =?us-ascii?Q?PMSxS1XCLPseEbLPu4moTjq/rcj0T1SraqcsIu6IlYfseEw4KBDJdgUce6n8?=
 =?us-ascii?Q?l2soh4+Js5DBF/bKmFRjMcgjxnB+2fGSCGkqcuXOZ5LbNUAnOkfatRdDavHz?=
 =?us-ascii?Q?UxifUPZL2Fb0ZEqhG5C+O5zCk34G+zZzOjCtPBBmr5Oc3EE3MqECWsa2ByPK?=
 =?us-ascii?Q?JVtU7ftaka9deb6jazY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abb76b94-f9bf-4491-578f-08dd39565cf5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2025 13:28:44.7531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WL26YRFDqMjKQVAMRVXAHC4ttB3fxpLKEatEeYfj0mZoqxM5vVqJCqXebhKNkLFS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7922

On Mon, Jan 20, 2025 at 08:45:51PM +1100, Alexey Kardashevskiy wrote:

> > For CC I'm expecting the KVM fd to be the handle for the cVM, so any
> > RPCs that want to call into the secure world need the KVM FD to get
> > the cVM's identifier. Ie a "bind to cVM" RPC will need the PCI
> > information and the cVM's handle.
> 
> And keep KVM fd open until unbind? Or just for the short time to call the
> PSP?

iommufd will keep the KVM fd alive so long as the vIOMMU object
exists. Other uses for kvm require it to work like this.

> > But it also seems to me that VFIO should be able to support putting
> > the device into the RUN state without involving KVM or cVMs.
> 
> AMD's TDI bind handler in the PSP wants a guest handle ("GCTX") and a guest
> device BDFn, and VFIO has no desire to dive into this KVM business beyond
> IOMMUFD.

As in my other email, VFIO is not restricted to running VMs, useful
things should be available to apps like DPDK.

There is a use case for using TDISP and getting devices up into an
ecrypted/attested state on pure bare metal without any KVM, VFIO
should work in that use case too.

Jason

