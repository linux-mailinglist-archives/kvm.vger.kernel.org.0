Return-Path: <kvm+bounces-57146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 11D9BB5080D
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 23:22:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 736D65E6F03
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 21:22:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B769264A97;
	Tue,  9 Sep 2025 21:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="a7SP0jEm"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2064.outbound.protection.outlook.com [40.107.243.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7BD257AF0;
	Tue,  9 Sep 2025 21:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757452889; cv=fail; b=J6Na/s6MoZ87LyDlf4U6Lw9fS15ngiF55I6QbkiLUVrbinadYE9hKZsQhhni7kTVSKc6ChZiDliAAButSYL8+xa76LVKZpTSZXLKaKqtcoSutZHopMCrl6Pny28RVdAewJ/UQwGLVF7n0F0+t3uL5Vs1Mp07xQ3wlJFeIM+LedQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757452889; c=relaxed/simple;
	bh=dONBt5NZJ1g9alo8Ia9NG/6WZrQFRAtcxTXY38PU7og=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Qgut5x7mS/Xx2mGEDVIIvoLRl2VcrKPDCzNGqvHQCpEdbCAAQPGb7DYzlqIhtc4lPA3iTg5L0CoJr9fkrMdgQtMPUOLrfO2zzLWx9TeWCwB6V9XeODeIKFmJIT3OMAD0E1n7S837nJSdPaYWwjK/0SUmYitvAp+64jPnwMFeqyQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=a7SP0jEm; arc=fail smtp.client-ip=40.107.243.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K2alvcSNKNP6twXxjLFGZz9KERFY/lSxnrkCtgDZFu9N9scDg6H3L1z5a8DMOQ2IbH9dzTDjodgIbVIhybAcZC50X/Q1lPj19f9oI9vcA82g1UPBoau7enDs7QsRwHt9+ua7eMhj0yJL4xiFXXFNh23wir/oEaUARTpoFpB8aLIpOvkfrdBvztZZuh9E4Sj0jZ6GDAbRr7KH11YRoEoJ/qpdVy4Pg9LXih6chagIR4CTE31S3z7WbF+WYokvnZRA8p1R3fIp8B5n92YTEBUtalp/4O1iTK08itF/bxJ4BaT5HRizr7NaR7ZT+bwz9skqqxaj0RfUpOblBAtTCLrv+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NoDevURt+oZXXwqrtc84bVN6VVGUXG/ZnYSehyZmToA=;
 b=kS7Lb+BQNsBmjuv9S5h/fFOipsgbr66aq2xZyqP7E8BuvIvNfRNBw/KPHZR3ojRD20TAnLKadnNa5Grd+TxEjPvzqcAvBikXUp0DPt2zWkgG7IgfgGHIVYoxCl6g2qdsFpC3eDNUfItPhsnUgk3l+0pOgQZg+NQwhVF+Dp2qeYLEnV/8BFT8t3YZ515DavqJqkfJh+c7MoHx2acgZ5/yu2CsyYF+WpRFkpWRlOYqkFUa9Ab69Hnbc39aDwXYuvdFP34WKeYXt7iS6rOsNfhRyhDmJpVCoidCZXPFhqaKHEZKm+5VEzTsPhWk99Pa59NPWT1/zfcshv11FJZwmvOQqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NoDevURt+oZXXwqrtc84bVN6VVGUXG/ZnYSehyZmToA=;
 b=a7SP0jEmldnbV2B61IhclENKi8dAP7nM0Z16qNRp6bhk9IOP0rtO1G7EqEKzPiyv2GrFKZh7yRq6uMQdEEeH1HMJpHkq063Ikjfn8s/WorXKUeX36prDEiTpUm+KroSPva5I8f38GLuISpjWkn9uOkSfnLSDlfGiAYJuvVBxmZX0n52V32g3f5cmi9xxudi0AdajJwe52R7PZo4cg7NuV5gDShC7s+TE8tOhoSnPo9n4y5rHbmepin9ff9dhSd+AwIgZGycGL5oCsHePt6wfUCeg7HEN4LldKbp8F2yuygDoUcl10fBODqnbTuv/AghDpW3BdiDF3cystmwyhZk6lQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by DS7PR12MB9528.namprd12.prod.outlook.com (2603:10b6:8:252::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 21:21:21 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 21:21:21 +0000
Date: Tue, 9 Sep 2025 18:21:19 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Donald Dutile <ddutile@redhat.com>, galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
	tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH v3 02/11] PCI: Add pci_bus_isolated()
Message-ID: <20250909212119.GA895786@nvidia.com>
References: <2-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
 <20250909195409.GA1494873@bhelgaas>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909195409.GA1494873@bhelgaas>
X-ClientProxiedBy: YT4PR01CA0209.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ad::6) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|DS7PR12MB9528:EE_
X-MS-Office365-Filtering-Correlation-Id: be170531-e4ab-4e0c-bc7a-08ddefe6d256
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?G3Ajt5hcWdecutygQc18synjWai+2u7G22VN6+dwSXTmx9Jszk8m7NjsrrDF?=
 =?us-ascii?Q?/clF4ByxT5eMHHBBrl1SyCnc8pvvybuoBOIzqZEsSypVunSUcSkI2JkCpSQh?=
 =?us-ascii?Q?ipTfl6oSAwyihHZVsIJa9NdOcgwyYXV0CqVhOCdl4zVcSHjqmTftEUO6xl9g?=
 =?us-ascii?Q?QpXQgBvgE4avjhK75CmbQ2GGYANYQOVjayLnr6WNpmmo0d/bGNuVntx7PNAp?=
 =?us-ascii?Q?osqoMWft02DpyITJ5pkvy42Om6LFSZ35Cr9e50IDByuQkU3SuNfFs2c8w7uP?=
 =?us-ascii?Q?Rm10+XCkRWHrg/OOb/vIey4bsxi6LmtR/9fcdp8TglRG6l3g87Qd5wBmA1/9?=
 =?us-ascii?Q?JVgxKfRRf26KrjD60XotmNJZzGKms77Iybjf3gKVc97NF6h5SRxp1kiH6H47?=
 =?us-ascii?Q?HB9//TfOcgQypWqj3dZxYZ1PsgaApe+Clza/xsz/a5m08OWz279AQ1q3qB9h?=
 =?us-ascii?Q?fJrXpKk3UMHt7kutKAk7NR/kRVOaulKbvMVLftqi9CstsClBkNygPysSnWpW?=
 =?us-ascii?Q?lI3o0IHwCaJd6wZThGZAzp+2DkeFbdJwM32t3ahdxe7qOn13k1QBs6ocyRV3?=
 =?us-ascii?Q?L2jaG4TSqTozZ33YO1YB29uGIpCAIg7p5L6iMuDPm0qlzyu39UfLGCruOxlW?=
 =?us-ascii?Q?NsV214VMBwwdO0Dy4px4JPmN7c9Xjq4or1t/M3x/YkPLYEsDRdHgNQtKDazn?=
 =?us-ascii?Q?PJZmEAtRsx6sND+hHnvqyBa4Ik5h+uI7Lo4KgsJKj0ev7mo7rxfhTCvWeReF?=
 =?us-ascii?Q?XzUcZ/0Z2zwidY2/r8M/7Xenm55NDIETnw5r3P+qLAT3JFcnfisZlHqrWbKH?=
 =?us-ascii?Q?vbU9oetYRmS7jvIAd9D+b+rYXsZDXPOT3PC+jU9oiSSEKSTDgx0OCSIT6ymU?=
 =?us-ascii?Q?Q0Di1/8qITaTNI9vMNdyGFrbzZiYmFNZZlBWFVUZ3M9DKfvY7kxTi+Cy5uB3?=
 =?us-ascii?Q?81BC1o5VBZNCqe7fGga7QUFpY0tk7xnt879O+/mCEkOFT3DAgzBe3eDs2ic0?=
 =?us-ascii?Q?uI03CrL5u6HXURgzTfStTg2Ll+HC+cv8ayVnf8xKT0B3q8Xr4UljrLJUBIO5?=
 =?us-ascii?Q?Zc/L3W9Os2q4D/fPGEtWWfcJ4+MW8Ki+aTgpIN02H197+gTUpIQ3XcvbkqLu?=
 =?us-ascii?Q?wwWOkOe++nM2PIEBPWNVEM4iWns7esNcJf8NEXhrDJrZTWYLwNJIozTrDtR6?=
 =?us-ascii?Q?+HGOYKolBxva+Ox/uBNwARl2nJdT3itYxiCdd0O5h0CyWvJDUJw5DdUIMPlV?=
 =?us-ascii?Q?mDpXkBIPZhLveYkDZbPKEN1t4RYhPWuL32OUc/gPUeNRMNNlF/ijSOmBuuih?=
 =?us-ascii?Q?mpWMoosyYzz7/99CHLrREqDcEbCDL086ACO5nz+Vj0QAoUJmXr9lUh62x/3p?=
 =?us-ascii?Q?XFlwWN3gGQBZ3cvzt/ttxvUXsWWgvaCbog3XVQgoXRdz55u0D74Wmky3JEXl?=
 =?us-ascii?Q?yaIKjqs+67c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JnEuOl9ExB3JY6Iuxrk3/tszRKv5hHMcRTjRwPMCITzKg/Twqi/3ATDnYvJq?=
 =?us-ascii?Q?T9+Rwa5yEjA8Xg/KJcuwOF3qQ78gc+R27ck7/Q48Wl0NMfugti3NuBWeAKRB?=
 =?us-ascii?Q?of9LZVLMZ81kIMU/g491HayOz0u9xyD6+XQar9TlgGhcb1L+P4Au+K6O853J?=
 =?us-ascii?Q?wQN7tveFrHGZDhwQ76UKaodMM3inmQx9uDLM9w0TMO97SP74vl1D2QXnypUq?=
 =?us-ascii?Q?+wCCeLTz9AMb+/4r15r/OfqAJzNHOozYJqDCBZi4HNugdfKAHUIFyKGx/g+w?=
 =?us-ascii?Q?pgw8iI9Mo34V5sZkZwGuHFpIk2i3OZD1F0Bwtu0WBYdo8XNVOBWSWvBxc1qo?=
 =?us-ascii?Q?nVPJXwZFNM2sEc917ADyC28GCMqcKe3pw94CAUO2vsd3uYPKuPCHJ4zuSWVy?=
 =?us-ascii?Q?SwpeXbziy1sCM3GQLAQOCl1P5vwCWjzqAsik/oKg/t2eIo2NWZoUTdh+MsO4?=
 =?us-ascii?Q?hGoU5MQtMQA9p/yv5y1KWXPWSVSi6pyM7yrbHt4C1bmoQ4+cwD4sHQQmxR3s?=
 =?us-ascii?Q?wW2CHeGysNKFprXRCFwMKeB01fUpG/qtgco163mfRYqvjsctS4gy7ZuVpF7N?=
 =?us-ascii?Q?CRxn84T2SJQPT8M+Cjb5ttvAOgBRZ/XHOx2xw6sCznd9cvJ4n7ez24c1+UEo?=
 =?us-ascii?Q?CsENdmz91lzRVDSRlycF1NNtsLSvWW26xownU+1exy3Pr0NOTRoYk/crsy30?=
 =?us-ascii?Q?moPKf2F9l38zBef24OvTIENTJNh3P+fHLeI2LcQlw2NhnkTxppwvLJALoFaE?=
 =?us-ascii?Q?GxU93Anz18vXFhMWUB7rzHl3OTz4eq+0EGZXk6IGGGpFBcPyP4zw8kjcBtWI?=
 =?us-ascii?Q?e/JACAEepv3h9ojCtyRWqTxDzvLFkAUC3qSBi0IOBUhHZC0vELkkhcplaYp9?=
 =?us-ascii?Q?Vt3GZPA/34K7uZO/lO77INuVCcugNaX/q3pffW+55DYfImJ+3/wXH+tBsq6r?=
 =?us-ascii?Q?iSSeJp+W2u1t/l7RY4FX5u3uzWP66GUbOPj1oy3VYGk+QRFNGy5y+PTNEPl9?=
 =?us-ascii?Q?9N03ke2PgGe6e3AT8z8WdiZ+c66J0GyTish3xsEdHo61+AihFXJoCzn0YEAH?=
 =?us-ascii?Q?PekOHbA6H/qQKyor8fZD4m0gaN7rsb/ci9Wv12Md6iA2m4+B0ufwkLCLqpP8?=
 =?us-ascii?Q?SsOlB981GBgF1xRnaYfbQ2oOQIgUSoWCgQZuK1QvcsxuZkGyDV22iEV8A4Hl?=
 =?us-ascii?Q?90HLZDsMeKxtuFQB55QlllpVhLNqJRrAxw5g1c+OMQrH/QnIizZLIYqnmtjj?=
 =?us-ascii?Q?DwbLeW6YXpWuBYRt3GSncGWzrvYFS/filZupK0Ka2C4Pd2K/s0uRWRKpSs53?=
 =?us-ascii?Q?7iYKpP4E0YyYlVkxNrVK8kPJImhBA2Cfw7lsWNraKs5DXiAPRAKZiBWXacZx?=
 =?us-ascii?Q?FpJzH6E2FJVXbw91buK07dCvl7zDqnTIlxrEbqGYS37WbtBYlv+zrI6Xeb3m?=
 =?us-ascii?Q?SxaM2uwZcNn3Z4SRoPbGoGluWiD/Evh7IPVglzy98urHv1bufKghr5UQ0Ns1?=
 =?us-ascii?Q?TVBIrzz/PgfCu83yoDqE0Yw3lGOKEJZho3sSyPIRdE3DpNh1i811MaBo82oQ?=
 =?us-ascii?Q?qn/3QACx1xvv8B8V7ok=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be170531-e4ab-4e0c-bc7a-08ddefe6d256
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 21:21:20.8505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1QlLmA3eQmTqXlJN9q4NBMDhrP4+y+NNu50I1HsHUK2ZRAI8iBgpPfJMY/pbSMT9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB9528

On Tue, Sep 09, 2025 at 02:54:09PM -0500, Bjorn Helgaas wrote:
> On Fri, Sep 05, 2025 at 03:06:17PM -0300, Jason Gunthorpe wrote:
> > Prepare to move the calculation of the bus P2P isolation out of the iommu
> > code and into the PCI core. This allows using the faster list iteration
> > under the pci_bus_sem, and the code has a kinship with the logic in
> > pci_for_each_dma_alias().
> > 
> > Bus isolation is the concept that drives the iommu_groups for the purposes
> > of VFIO. Stated simply, if device A can send traffic to device B then they
> > must be in the same group.
> > 
> > Only PCIe provides isolation. The multi-drop electrical topology in
> > classical PCI allows any bus member to claim the transaction.
> > 
> > In PCIe isolation comes out of ACS. If a PCIe Switch and Root Complex has
> > ACS flags that prevent peer to peer traffic and funnel all operations to
> > the IOMMU then devices can be isolated.
> 
> I guess a device being isolated means that peer-to-peer Requests from
> a different bus can't reach it?

peer-to-peer requests from a different *device*

> Did you mean "Root Port" instead of "Root Complex"?  Or are you
> assuming an ACS Capability in an RCRB?  (I don't think Linux supports
> RCRBs, except maybe for CXL)

Can't really say, the interaction of ACS within the Root Port, Root
Complex and so on is not really fully specified. Something within the
Root Complex routes to the TA/IOMMU.

Linux has, and continues with this series, to assume that the Root
Port is routing to the TA because we don't accumulate other Root
Complex devices into shared groups.

> > Multi-function devices also have an isolation concern with self loopback
> > between the functions, though pci_bus_isolated() does not deal with
> > devices.
> 
> It looks like multi-function devices *can* implement ACS and can
> isolate functions from each other (PCIe r7.0, sec 6.12.1.2).  But it
> sounds like we're ignoring peer-to-peer on the same bus for now and
> assuming devices on the same bus can't be isolated from each other?

Yes, MFD has ACS, but no it is not ignored for now. The iommu grouping
code has two parts, one for busses/switches and another for MFDs.

This couple of patches switches the busses/switches to use the new
mechanism and leaves MFD alone. Later patches correct the issues in
MFD as well. The above comment is trying to explain this split in the
patch series.

> If we ignore ACS on non-bridge multi-function devices, I think the
> only way to isolate things is bridge ACS that controls forwarding
> between buses.  

Yes

> If everything on the bus must be in the same group, it
> makes sense for pci_bus_isolated() to take a pci_bus pointer and not
> deal with individual devices.

> Below, it seems like sometimes we refer to *buses* being isolated and
> other times *devices* (Root Port, Switch Port, Switch, etc), so I'm a
> little confused.

They are different things, and have different treatment. I've tried to
keep them separated by having code that works on busses and different
code that works on devices. 

A bus is isolating if upstream travelling transactions reaching the
bus only go upstream.

A device is isolated if its bus and all upstream busses are isolating,
and the device itself has no internal loopback.

In this code it sometimes talks about the device in terms of a
bridge, USP, DSP, or Root Port. All of these are a bit special because
a upstream travelling transaction is permitted to internal loopback to
the bridge device without touching a bus.

So while the bridge device may be on an isolating bus, the bridge
device itself is not isolated from its downstream bus.

> > As a property of a bus, there are several positive cases:
> > 
> >  - The point to point "bus" on a physical PCIe link is isolated if the
> >    bridge/root device has something preventing self-access to its own
> >    MMIO.
> >
> >  - A Root Port is usually isolated
> >
> >  - A PCIe switch can be isolated if all it's Down Stream Ports have good
> >    ACS flags
> 
> I guess this is saying that a switch's internal bus is isolated if all
> the DSPs have the ACS flags we need?

Yes

> > pci_bus_isolated() implements these rules and returns an enum indicating
> > the level of isolation the bus has, with five possibilies:
> > 
> >  PCIE_ISOLATED: Traffic on this PCIE bus can not do any P2P.
> 
> Is this saying that peer-to-peer Requests can't reach devices on this
> bus?  Or Requests *from* this bus can only go to the IOMMU?

Transactions mastered on this bus travelling in the upstream direction
are only received by the upstream bridge and are never received by any
other device on the bus.

Or Transactions reaching this bus travelling in the upstream direction
continue upstream and never go back downstream.

I would not use the words 'from' or 'to' when talking about busses,
they don't originate or terminate transactions they are just
transports.

> > + * pci_bus_isolated() does not consider loopback internal to devices, like
> > + * multi-function devices performing a self-loopback. The caller must check
> > + * this separately. It does not considering alasing within the bus.
> 
> s/alasing/aliasing/ (I guess this refers to the
> PCI_DEV_FLAG_PCIE_BRIDGE_ALIAS thing where a bridge takes ownership?)

Yes

> > +	/*
> > +	 * bus->self is only NULL for SRIOV VFs, it represents a "virtual" bus
> > +	 * within Linux to hold any bus numbers consumed by VF RIDs. Caller must
> > +	 * use pci_physfn() to get the bus for calling this function.
> 
> s/VF RIDs/VFs/  I think?  I think we allocate these virtual bus
> numbers when enabling the VFs.

Maybe BDF instead of RID

> > +	/*
> > +	 * bus is the interior bus of a PCI-E switch where ACS rules apply.
> 
> s/interior/internal/ to match use above
> s/PCI-E/PCIe/
> 
> I'm not sure what this is saying.  A USP can't have an ACS Capability
> unless it's part of a multi-function device.

So it can have ACS :)

Not sure what is unclear?

I will fix up all the notes

Thanks,
Jason

