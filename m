Return-Path: <kvm+bounces-25557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED4E49667CF
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 19:18:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E0A11C211DF
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 17:18:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 145641B2503;
	Fri, 30 Aug 2024 17:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jMVKN0Gg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DE71AF4ED;
	Fri, 30 Aug 2024 17:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725038303; cv=fail; b=goXCVhpJK3fGAutp55GcL3Fy21f90cRbzQJ5UX2jB8mNQhBu9N6EjAvO+vYAM8pJc1d3MSIUK0QtEYpbJUnyltttpb/07GL/sEWaelQ6+2/6a9F8JzWto/3Djwn9vJyQDHclOOlZfeElz+YwZUq2YPhfQ7n59IvSyieTFu9bxns=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725038303; c=relaxed/simple;
	bh=BXeHgTBqO3EVIVEYhQ5MHd6PpUEkbeG2fqPMzIzuSqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FQy095PREo3BHn6Y0ydWfLw5g9woEVeLRjmeT+HS9CJXWZiLraf3YxV61tr0ZhvvkF0k4rQm0vghCbBYFtyHwQZPljLeb/zduW8BtOoIRX2JBWALgZl6PdMNqFtM9oRzPbxqSxpshNxRKEFfOm6uuNPrq1lMFAe8WJzf9fuQFfU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jMVKN0Gg; arc=fail smtp.client-ip=40.107.223.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w6cA4pEnOw9JIeHb4Yw/li2Ht+05S8WGRDmkBU2qtaAYKZGLZiQYrlDDaLllvpK3KLfQpoADkJHphiWoQtxLmtJ3HprUx/vHIlUR61NZfsWkl+w5ixqA1p1IAv6908mBH8J/tkUL3bg5QLT0FuCg9zXLB9rMx2IFEWwrArAn0682Bg2WI1fJdGOr9cOYeBzrcgEACUdfIviJ9JHPsnNLXh3+WsxMeAwY36Hk6iSHkVfglN9SiaiPmPWJv9f0FXhOyetUq8UyZLXdJIGAT2SdZth7f/zzr1jezbWLrF1Ge6c3SlZJ+4d0JWE2S370LHb5ITAkFsgJkmtvUsFul6+P+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rT/uNbmlbF0EmtCRZyswsiAvKUURfjOwk3x8DUdg7zw=;
 b=ulNzN8QmXyT+eWeIUuq4Q+7j4YwpvnWzOt9wKsAnUM4nS3GzBGi6JulpoTt+WQEw2QyJckN7DAj183buV2MouUoJQDmp63VlA8jHXPH9cQSFZN4llqBsuKUMIqSTA6MjjIGX6Z464gbs2wdcEOYyFrJXMijoh7jk8xxm4kVSK/b5puaZbdzfLnJ/cf56kBK2P6PU5FZYj7OkmViG1kNFwkRbthG3Ec4nimmuXMMfczEmWxOsEqPA9wZrcztf4mp4990lzfr6IMChx+jhFRG3AkRXOp+dMXJufY2MYLo3nbI0vd9RaogTaWf3W0sbvWIByGspXCaAXuayg8Hxln3ktg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rT/uNbmlbF0EmtCRZyswsiAvKUURfjOwk3x8DUdg7zw=;
 b=jMVKN0GgNAQqud9sAbZjJOe0PrBGJy4cO1qja6+ukOCpJddtBdUayQfIb0WJHEqvAdqCmqTKdtk9xTR9cfga8kQr1JvkaCJSi0sWtO4L45PSVtA4ZwnS3s8uAuVmFzGBcd3d3KdSamBTmbvSQEQEVjOVMGLgNbI/TOg2v7p7yf3mH5vWumBRPz1QVfPbTKXD0mjXZoMXTQN9vCtZnQHSYQPTInTgCxGMu49a1LAM6Tj1aU0k2t2PnmcL994Vn7rbdvuPfcepmg4miymr3Z+RivQoAoSnKev6AwyfEUFYPXamvKCeP7GqUqBoTU4SkZ0B5IOsx0sbDzhxp7lqSzycQw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SA0PR12MB4366.namprd12.prod.outlook.com (2603:10b6:806:72::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 17:18:18 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.027; Fri, 30 Aug 2024
 17:18:18 +0000
Date: Fri, 30 Aug 2024 14:18:17 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: acpica-devel@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v2 7/8] iommu/arm-smmu-v3: Implement
 IOMMU_HWPT_ALLOC_NEST_PARENT
Message-ID: <20240830171817.GY3773488@nvidia.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <7-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <ZtHkxFrojjXplvvn@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZtHkxFrojjXplvvn@google.com>
X-ClientProxiedBy: MN2PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:208:23a::25) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SA0PR12MB4366:EE_
X-MS-Office365-Filtering-Correlation-Id: b42dc6a0-5d00-4559-c757-08dcc917bdd2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?USxrAfLeMKODGwol7rvKVjnpsOf0Hr+Qj3mYrjF1GNOQB0YMGmmFVsPIUow4?=
 =?us-ascii?Q?JlQ0YcNZHsuDqzG46Qa1tfPX4okOATziLOzydGAgVK5qTzJTDh613FAANe+o?=
 =?us-ascii?Q?u1bm69h3sdd2KcIpWji4G83jTAIEQvac+BnmajRg5JIk7XiFuV+V2QLHq5ti?=
 =?us-ascii?Q?NoBORUY2BBtptnmWgGm6s48wxaZRnNlMfn0QFB11R+gHQk+qa1EtDvGvg66N?=
 =?us-ascii?Q?tjk0v5E+X3d5gcEvR228u+NsizFU89MTK0IZrhVxyKVx++kYrK7EPUx+s+Bc?=
 =?us-ascii?Q?N4dydFso/wTs8WLD7AM6JMjcUjWXo6Ufh/R47Y9hE4GoV9KN43MYi/cw+Dlc?=
 =?us-ascii?Q?lfPRByz1KLxxJ4ujdCnzGWPEpxiSNckYNh2e4jnUdYQegGaOI1BZxkgpTqvL?=
 =?us-ascii?Q?QUHFq5ZmqKj2MgnKrJBidENvaOZ2mTZwc1BCJ0VgbDPP5etx7RL2/cOjBlrK?=
 =?us-ascii?Q?di9wUVtEfP443Dhyo5Bv2AozgK0TMeFMPFqjy3Rj2TiSbEM8G39wFVq4Cqw0?=
 =?us-ascii?Q?EtxmvU+Gph1gMEzjMPZ/O8VpyUSo6Q7N269umhSvywpq2L5LDs1YpjjjLz8H?=
 =?us-ascii?Q?LvcFCry/KTA2QT1iwOdMnuGQDtBJ5lE4Dw/la+NwtTs0vgE3ZGm3NBeWlNfe?=
 =?us-ascii?Q?mEQsxqZKY9JO855OPxEDNx9EWr8lB0nAXjE2SvdGZvGLIhSiTZ8m7jAWeWgk?=
 =?us-ascii?Q?KfyvyBKmBAz3diT94/OB3XTO99kH0nl/ylb5AKMCFjJJ0UbOsly8oHna5eRV?=
 =?us-ascii?Q?1+vgABiWyc641vRU7mAJh8SI7mOOulPS1gZCCIaqm8PlZ4BmnnTCHhxWnVwH?=
 =?us-ascii?Q?bRmIvlYyM7As3MhPlGnST/iHJeUi+jUbN44sx8y4m9GXNXpo24VI8RPFwIXD?=
 =?us-ascii?Q?rm4fjPlJ4w60w5+U0wEp/h2Fbv4Zt1oBzMf7td/GUo/H/840w8XNK6PtPaP3?=
 =?us-ascii?Q?w+BmnYMjxZ4LOxfBnasDxkCmdOXmJzXltI8ka2Biq7YvkLVpsIqvNZ6FUVzF?=
 =?us-ascii?Q?B3YnIhkUG+/TY0XGjLlXoyuQT7WsKxYZLn8IEq9pGBCfG2wS++X9ySXpOYJD?=
 =?us-ascii?Q?1ZzZ9VP/RVd4sEQx4wPBqOvYi6E8WjHgc6yxTK6Vzali5EAxUnaoInYMB0CZ?=
 =?us-ascii?Q?3fAloLURwEBF+Xc0SiVGSsBOGBtqNrXF9NDxN+CGEBtMMP/3tMY2hWr/z3Xw?=
 =?us-ascii?Q?VSYcKrBKZiTG4PLF6NTz556MaxJZDLS5JEprQfLl7bu6xkc6qcbUtlptbWok?=
 =?us-ascii?Q?QGksNy3tovVtf9aEfP1vE3/B974hl0gW5Gvof5bM2z+XwoOkJMYsmmr7X1LM?=
 =?us-ascii?Q?bkEoStxyh1zgtlcvp7YMXKWrBxBPIfu/W09+aK9wY2j7SA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6SPrbrL/ZjcBxx6QaWuL/3ibqKhB+c1AC2hEH19O6XdYFIxkM99w1GyQ/O1Y?=
 =?us-ascii?Q?0XUGDAGFQvyVBcGl1GAEvhOTJjK6Gef9F//IIb6MlK15diJNzou2t2SYmCgO?=
 =?us-ascii?Q?08CdgHpN1YFq3MQeyrnYpqY8uJKaPGU2f3IMOGViBmPEqNCq7M6eT+x2j5GP?=
 =?us-ascii?Q?lmkv8zLpUS6qDIGx5cqvqc3eX1n8uZjYcJdmBitP9JrNDBbv/qN4EZimevDw?=
 =?us-ascii?Q?FzHAePWxl9iFPPpQJ7f4B1JTt4hxqTIPWxbgp5KesbgxKpiwe9m4uQUMn2eq?=
 =?us-ascii?Q?UpRqvOIAI6Ar21UATYkYY53LGrVXdmI1ILk1ikvUaT8mnXT2g4AMYLkv5qlk?=
 =?us-ascii?Q?Manpcirq+YmVt3/9BmM0tKNPecaB7ztW30P2oi3uRE2ZSpyXPtBYkidOfz8H?=
 =?us-ascii?Q?tA6sY2Y6ongVHrsBzMKzEj/ld4TgkMNkwNTZAkqJ7zTp2mecdTkZrUXmJrL4?=
 =?us-ascii?Q?AKj88jbCw7Krr3mSvmUxTeLaEuCuPcTspj8CnoI8o4yeL2Jr7s7MDpumXJTD?=
 =?us-ascii?Q?iozJ9znZGg7vFG8B7G/eBSp+DpkjsZ1GMePiNEmY8jtm7VrnCANlaRfECSO/?=
 =?us-ascii?Q?fY0wQvpmKWPdLIz3UeyVFHahlUWVHtpwOpHAFxe5hWPQMx21frRsqe18Tywe?=
 =?us-ascii?Q?UrijH8seKpCxMDyT+9eOrCPiqK30LmQbvRNcX4hPsXk5cHIXmCJEuB/3APen?=
 =?us-ascii?Q?LiM72DmCL/RwNHY4oydS49HUS9CZHufutqbktIedG3Hc8FN4BCYQqaqErw0B?=
 =?us-ascii?Q?0tqO2+HwQsqGyO2Go24/NN9A5+4q1aw9ZwnfJkof/ykb/6SAsa9ZlyC2rOWo?=
 =?us-ascii?Q?nNMPrnXYn9UW+jgJaEu9QRSwvtrFkmk/UTzJ6M2xGcupEpP6zQNZZCPOzn4w?=
 =?us-ascii?Q?v3GGpUxIEDtazU72ebMEyL9CySL16yLnqoU+rLbYqGUdQdBYP3TtMvvidQaf?=
 =?us-ascii?Q?0JyqIxrff6gkhP9UEe0Pvxb3BihT03AwET5yY17lMFBIJVrVn2AAIzltgMPJ?=
 =?us-ascii?Q?itByM5wRMIpDSwbJyMcqWVaTwbRXwulkrnXhB0xI3R1wlnDs4UnhYC/m6AS/?=
 =?us-ascii?Q?yEeNCxo0qcpk7NwLKQEX/ROveuCnP9jSZ67yx4BVEri/+qdXDb/Iadt30ObK?=
 =?us-ascii?Q?DS/wk1S73/TNtbby8xp0D2c2v1uvJiFx8t4c8HjquPULjexyIy+rGEYPZ7sM?=
 =?us-ascii?Q?L918slLEujE0twfsbS42fBS8q92366X2VkpMcuY2rNlolDYgxgDjAXuwSN3J?=
 =?us-ascii?Q?sGP2JhNu7Oc9TsowJvsD27kBgDUuYIkYK3ql5HPZsQWMA4Y35kGIVkgkdiH6?=
 =?us-ascii?Q?MLmQG+wLBhzRYC8cJKFBkcZpg4HPsWn4w1J85Fl4Em0ajdkf820ZUzjPpkdd?=
 =?us-ascii?Q?yFrBTSR5fL+uPBM/uTam1+4/Qu8DkKLEsR1LxcWN4sQ9zXR2jEmP+E5VJcZ4?=
 =?us-ascii?Q?sCwAfg52sKU0XNkxD7f0Cepk1IlnN0tQwsCSZdBXjiDC4NqT88fuQ+SqeNoh?=
 =?us-ascii?Q?NoT1ar5e8+FtXwGD+Rfsdplc2PJSUUFXDmrGUiAXG222ZXtpi4Z+cRHDjIKp?=
 =?us-ascii?Q?CoePaTGUxFQAmFrRfmYmK6uKWs9W7Fg32oqAleVT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b42dc6a0-5d00-4559-c757-08dcc917bdd2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 17:18:18.7505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p581jyJzSfBO1P+3oy7qnMYdhlAKE17gzn1QGvGcJEzwm5H03Gq+HkOodpbOHNLM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4366

On Fri, Aug 30, 2024 at 03:27:00PM +0000, Mostafa Saleh wrote:
> Hi Jason,
> 
> On Tue, Aug 27, 2024 at 12:51:37PM -0300, Jason Gunthorpe wrote:
> > For SMMUv3 the parent must be a S2 domain, which can be composed
> > into a IOMMU_DOMAIN_NESTED.
> > 
> > In future the S2 parent will also need a VMID linked to the VIOMMU and
> > even to KVM.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > index ec2fcdd4523a26..8db3db6328f8b7 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > @@ -3103,7 +3103,8 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
> >  			   const struct iommu_user_data *user_data)
> >  {
> >  	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> > -	const u32 PAGING_FLAGS = IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
> > +	const u32 PAGING_FLAGS = IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
> > +				 IOMMU_HWPT_ALLOC_NEST_PARENT;
> >  	struct arm_smmu_domain *smmu_domain;
> >  	int ret;
> >  
> > @@ -3116,6 +3117,14 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
> >  	if (!smmu_domain)
> >  		return ERR_PTR(-ENOMEM);
> >  
> > +	if (flags & IOMMU_HWPT_ALLOC_NEST_PARENT) {
> > +		if (!(master->smmu->features & ARM_SMMU_FEAT_NESTING)) {
> > +			ret = -EOPNOTSUPP;
> I think that should be:
> 	ret = ERR_PTR(-EOPNOTSUPP);

Read again :)

static struct iommu_domain *
arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
			   struct iommu_domain *parent,
			   const struct iommu_user_data *user_data)
{
	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
	const u32 PAGING_FLAGS = IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
				 IOMMU_HWPT_ALLOC_NEST_PARENT;
	struct arm_smmu_domain *smmu_domain;
	int ret;
     ^^^^^^^^^^^^^^

err_free:
	kfree(smmu_domain);
	return ERR_PTR(ret);
           ^^^^^^^^^^^^^^^^^^

Jason

