Return-Path: <kvm+bounces-59176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F7F6BAE081
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 18:21:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 434AA4A6387
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 16:21:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A29C235C01;
	Tue, 30 Sep 2025 16:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="p2Z0d9Cv"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011009.outbound.protection.outlook.com [52.101.52.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0196C148;
	Tue, 30 Sep 2025 16:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759249309; cv=fail; b=MqZncPtXCCjShTxWNkQ4w/PDWMkeyZ4KKqjoIYfYWzHOnezDaEM/lHta8vApSBrkNOO3h8OwlX70VVi7/I/ab31SVg7wVxkUurp/Ta2NakTEyOl7jDINrn2Ob+998nJ/J88X9fTo78qrjSZo9cU0KKBHx7PqrTjGnNFUISX6EGk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759249309; c=relaxed/simple;
	bh=1NF3t2NZqEeH7Bh91LETh3ry+CigVFjmh4zEAmSn/98=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=n+7OabK+l76TVsLcEwsMIC/kispOrgXVImbn/1Y0r1F6DAj8B4DbSdB34UXVC5VDN0K2PA8G4+reDchq3tg/xz9qs0rpRzecFmxly9z8OR3s3z7f/3YPvHMu7MB3LiaKvdszRffnNuuoLM7GWR/LiFUZdHbFf7Yh7eKzkt8QD5o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=p2Z0d9Cv; arc=fail smtp.client-ip=52.101.52.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H3+mcMPKUlDY02wyr0kml0LujVj3Ik/xBMWsp4omUAMQMJiDBuBtUfzOq4I0wY7kZ03OqJCywL1WNK+Xct8A4jLe3usLxXBysXm08xjdHkSlhpq15D6MzxVjH5visQIQ8tlyGuo6Rfvb++ks837DJQ5FNKy17FDBhwPYHMTPH+Y2mbvKHGwqG6ICAAtUPr/O53M9Nah3xeq5p+iWXLQnIjUk5yJxnkPsv5e3Va0yhI5NDHLzCjsWo9v0MgviGI81nLl7fEnEhuBpcmkddI0ycTynnjziKQpEPIpDOWMqgEqIuu9GD6xlL/db2Acgxl/eOyfO9VbtCW5OrvUhziJ21A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2YFHQzcvaTWuYi6YgUsvlCJgD2VqXiuU6wwVWn+MV7I=;
 b=Z/Yudw2lofcd/u6axONzp1929iKvoJGBafjq1STkv301lfEGBg5WcfAszNzOeacMDLIxrPJBZNX+40UKEh+5Uz3+kak48l4ddGljYFJWa2lkmPeF6b4cxnqmctQ5FYDYsLFzeCUsadqk2ajlBEVzDrkf6YuxiGcvHqzAUFP0QKRGUKaEYF4a0756tpCz5qcAXuKDSOsSHNCoNWAWGlO7JFfb5NHmGJ0ti6MHOvCDmCPLLvYCZxwwx94ECTjOzwBQA1fKg8wz56fPUfr+/s+06cpskZhx3K6LAwSc4mv+MaQrwsyMyYoIjd8JbAtO5m7G6x5IxvimQEtrFj/DECL99g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2YFHQzcvaTWuYi6YgUsvlCJgD2VqXiuU6wwVWn+MV7I=;
 b=p2Z0d9Cvrk+uJ8CeDCEWr5Fc2+Rr8/oYRCld8MqSZyUIEDf2B9facV7gNaVC6pzDY65GSbUFiakDlDUIYwpTnL/iwVgN2klwmJ3myw+BAafpB49EuZt01adr3HJrWc57vMr9Zu/W9ythrk8EH9AiH49f8ozjduqxAf1+JvZKsnmWj3pUAjJOxMXMu4U2OPFIYz0OnXPBEl11sW/yebJxeCmlkIcsZfjtGTBNpvev8fN6dGAvifDae53MuxZs1RK5wOFUrVYf9V6oaIrQQaqBI8Kw1SJLtH0jUKYV3EAKuo+yCphK+lSeg2H9fZ1GCm0ptWYQdGJGgouMwh3dELQsJw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by SN7PR12MB7129.namprd12.prod.outlook.com (2603:10b6:806:2a1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.15; Tue, 30 Sep
 2025 16:21:42 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9160.014; Tue, 30 Sep 2025
 16:21:42 +0000
Date: Tue, 30 Sep 2025 13:21:40 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Donald Dutile <ddutile@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
	tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH v3 00/11] Fix incorrect iommu_groups with PCIe ACS
Message-ID: <20250930162140.GJ2942991@nvidia.com>
References: <0-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
 <20250922163947.5a8304d4.alex.williamson@redhat.com>
 <e9d4f76a-5355-4068-a322-a6d5c081e406@redhat.com>
 <20250922200654.1d4ff8b8.alex.williamson@redhat.com>
 <0eb2e721-8b9c-40d0-afe7-c81c6b765f49@redhat.com>
 <20250923162337.5ab1fe89.alex.williamson@redhat.com>
 <8e679dad-b16d-45e3-b844-fa30b5a574ee@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e679dad-b16d-45e3-b844-fa30b5a574ee@redhat.com>
X-ClientProxiedBy: SA1PR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:806:2ce::17) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|SN7PR12MB7129:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cd92ca7-10c3-416c-cf33-08de003d70e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?07f7h2QU9xWlAuSccdM6yjSNXiApDLFWHl8H6K8d9x+0i0vkyhWCJROfOFqF?=
 =?us-ascii?Q?YLeo/S+Uj1ZWZDb+XserM5iOCXiSTfXhcLKjcyK2j/ssm/fbwyyDXdJ8uamU?=
 =?us-ascii?Q?pK5ZhZDROSbA0z4VBZkxthPdWkXeFEe/QVFB+eipxdHkb91BL42BKz58j6S+?=
 =?us-ascii?Q?DEaXqz7DpPvMvAJ4f/b8pVUJXYaXu/hDvbYK6aYcmHp725eBo3iZSbV55kr1?=
 =?us-ascii?Q?2EvuFZW3LmvSlsQsk40YpPTp1SCq4clkxhNTbqoLodGi1/31B7MfDWkQIICN?=
 =?us-ascii?Q?2VlnnqPUxM/Jcnm/XhOBAbrc6KeNzDUITfY60VAHA80TOU956FiWyR/ZJeyA?=
 =?us-ascii?Q?EcFBuRcpTSVQdqMtdhJHETY7z1bE4PZ8dQhNfPfhSQgz8plzqYf+1S0o+G8T?=
 =?us-ascii?Q?Wyb6tV4zAazWrBZofwTv1M5+An0fDPuiTrV3cenjbqhmycPc7ZvREQO9DKAI?=
 =?us-ascii?Q?8hHsQ58ybwkhpXNyQ3gehbMnZ+68SzDZne1wCchDBMn3YjChRk2WRnJSDkDK?=
 =?us-ascii?Q?MdLI5y0jAmhGvgPOIAwtvES2i0FUgE9wQedvoIc3BZCSdTZBD+pSNqVoTGZn?=
 =?us-ascii?Q?T+L4dpRcpXOvsZOYMWyqPmlu2AjEHNstfg0PSO5JZRZSFpwobKSoBj1jel7k?=
 =?us-ascii?Q?CWyVj7xLeNQGiXlKTRrphrzx32uYZzpsJreAxAv077T8zcsVo3KvrTn+4gX3?=
 =?us-ascii?Q?+nuyoTvuUH3fE0UvXiMCZKpMI5jm/nSo1bNhsz9yWuSCfTA53f7LG4QS4dys?=
 =?us-ascii?Q?SR9UGc7CF404Me8gLzCF+gWMNe19hEuxY8AvISmcrspZ8a+5Rq1k9ByppdE8?=
 =?us-ascii?Q?d40mhxEw34yqSceRPnI5PT1FkwPS7PEmL9JlhdVleNudLF4Y7azrPJTD/hE5?=
 =?us-ascii?Q?QJpyQOrFhTY/WCkxthtbP9CDu33mmh00BmnHC9slaXfb8crsvLKxsduSHLab?=
 =?us-ascii?Q?moeUk7EpHnUZxskxoQfleKCiq5cfdf1ZY6GTUmQG0rJuB2UnY92ypRY1A9C+?=
 =?us-ascii?Q?hk1clChOwkR8lEBwtI0+ruhh1It4/oLVQ7fxWyCnySENzbE4wwgPwEdExUYx?=
 =?us-ascii?Q?TzjLozPIebAuRr0Xx5IQHkwZ+H8MyJmiF5+6A5BA3cGxHrn9Gm67Dp1V4iRT?=
 =?us-ascii?Q?d7T7Zf+eTSaI3ADQXraKAjRQL4K9WjBLPqYA4dKoroX1h/tnhyRfVv2M9tMn?=
 =?us-ascii?Q?jo5fKlnbUpCWXMrQVe66SaBRwwEsFqcVhnzcHmGamMG9jXVfINww78DbePQg?=
 =?us-ascii?Q?G1z40Td312gwWC6nzz7szjPE6tt8i11rdCfl6lOrE5FFoZJflSGZ9Yv0cO9/?=
 =?us-ascii?Q?pQmlvRvZylhDu3YMpkAHVV5+zOwD0C696i/Kf1WPNp5UpjlV/XLPqgpvQGwQ?=
 =?us-ascii?Q?yV4PqF1YFpG/P62ze7n4PoKsBGpKIlOof2FlniUl/0cSHWZ5JQ0szl1B68lx?=
 =?us-ascii?Q?H9NxGqx6WKR/U0ZUVBTogyDJxJVoUCyX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iYE3FUkpCH6YfIvEeLUpl7ejmQoIZbXv8kT4nSN3JPQSl7an6inU95m3con/?=
 =?us-ascii?Q?xA222kX8hBCqqC7OGYHuB6m4mXBbu1WyjomCi3sZUGE2Jdzegh1cZiXSlKQM?=
 =?us-ascii?Q?ZJLeaHeWalFLQYSD8FBquU5sRp3qlleqiP62W+SlnX115o7elGhBD49qxgCv?=
 =?us-ascii?Q?G7ZHHlGrsFYjVsmn1ppoBmd7TINJcsNcATrj+tI3qhVBTliiQti6tTO8KnMP?=
 =?us-ascii?Q?ITIRbwrQhk29F9nfFeuFVLuXev8bH5z9YPYZrqPBaUkdAV6qCzOKF4ar0s99?=
 =?us-ascii?Q?34vVvtIOhFIJuBXliVyOnVYn/wTzlBc4mavVhoBmrZu1gCZjj/AvFiyPXKm4?=
 =?us-ascii?Q?TJsL0Vp/ULP/w3pBdcXJTHbulCXv7OaNFQslLgXBSvBFk17RUs8HwBq6iiHZ?=
 =?us-ascii?Q?8b5TW0O5f0Kr8tjtrQ4Dnl9VUN9GBD2RCEFwTFWAcIVDnY1sbt0gAJlXvWTQ?=
 =?us-ascii?Q?LAUrf49aLHivDMwcGUwRF1iiRGVRsE6XP1ei2IJEdNH3zXry4+A9n6VXwhMo?=
 =?us-ascii?Q?zLM9cg2/PLndgNAwnifNBwoqmrpHdIZDgRpmfqpqReHXtRFYS/DPF1yuX8s4?=
 =?us-ascii?Q?iF3ZIGyCtzeqH2KLWqWwfxbS/5Rg17AxvfzrrXxq21s5mFCSvBjkvDerWS78?=
 =?us-ascii?Q?/OzlRX7LrRnMvuWas0K9rxyRl6ZeBkwuk4EpiGdf4XIKREpQNXDEX8RU+m8T?=
 =?us-ascii?Q?8CBqorJrNa1tNt0o9dt2WRPGZTRyRusRRj9nqkQsjYQrdwOFBFV2SsqfNSNA?=
 =?us-ascii?Q?mxq9LQzcGBn31fzblGYfsiKdh4UJEg/MfxjgAz7nFV0hKntec0X0z4ZT2TLE?=
 =?us-ascii?Q?aleLyR1wPH1TSitYRRGb1cIrpsGATl5kYGl6SFuyQi/qgXxZR/qiPkkry2GS?=
 =?us-ascii?Q?hWB7wxIABL2qqC0lJ1c4krVyASA4jxuYfzKmeL339pRN6sUr1Vm7vZxUDmWn?=
 =?us-ascii?Q?JaUk8cAINzeLyOz+KMJkIfplYs2tyvJJuRX+gXmOmDmjPCNn2VAtn904btdI?=
 =?us-ascii?Q?G73Qo49uIgXQegFkwljy059RBi4zNSMdv94HO0MJcqjyqGEAnN0UqYpAqoYr?=
 =?us-ascii?Q?UBzASD67vqyuIn7GvTtxjFHQ4OSk14Sq1eReRx7p+tP+JJdG2lA7qGiXATMm?=
 =?us-ascii?Q?R7/KL+FmMr1lVhijqmSfLeL0tasWRZg6nJkFRwgMrlYhMxJY2XBD3unXUW9J?=
 =?us-ascii?Q?8/7keNLG0XXJZT7yzT5uGjgSIwsJGAbpMeDQZKiUHeWVlDeMxYulvuUCZ5FX?=
 =?us-ascii?Q?4VHpnJNBhOmwIvOqqq59GH+7xes2GR8Ij2pk+sfWIn5AadPOewWuvFhFqsdg?=
 =?us-ascii?Q?bEnMN8M4DBYgnIseHg47PnPHzUozsuAEDjMNH+nvoraJos5yEQJTcuKhq2E3?=
 =?us-ascii?Q?SdKjTqOZ3ye7hVHwnim23/Qzd0s7OCFx5d/wfm6D0dvIvdON3IQd6CpgJ1dV?=
 =?us-ascii?Q?4Vy/+LkdAp1NVRGoogyuGJyrWnQzSIkNRSXnN8ZXYRx4Ln5iUegFhdMcY24Z?=
 =?us-ascii?Q?qqrQ7YnCgs1i58sfWrwN2Ol7uXiA1ngZ6CGM+8lhREMxCU/fzAVeJMvjjfgx?=
 =?us-ascii?Q?aps1Vrjt870cv08Xwp5237iFCbz0mFe3COW4eytf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cd92ca7-10c3-416c-cf33-08de003d70e4
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2025 16:21:42.1608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yHX+2f97RKKKMArdJ0v8GvAW7H1bFA3a1VusSzT81ala6Zg3YlCRlJSQED1egMu8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7129

On Tue, Sep 30, 2025 at 11:23:06AM -0400, Donald Dutile wrote:

> This is boiling down to an interpretation of the spec.

I think we all agree a reasonable intepretation of the spec is that no
ACS means *undefined*

But Linux cannot work on undefined. It needs to assume a definition
because it needs to make security decisions.

So I think this entirely a Linux discussion about how we should
respond to this undefined behavior in the spec.

Every heuristic option should be consider even if not directly
supported by the spec. Our current behavior isn't strongly spec
supported either :\

> I believe a definitive answer from the PCI-SIG would be best, especially wrt
> backward compatibility.  

IMHO they will say it is undefined. Device are allowed to implement
both internal loopback and block internal loopback.

This position is useless for the OS, but it is how PCI SIG has acted
historically. They don't retroactively make existing devices
non-compliant.

Jason

