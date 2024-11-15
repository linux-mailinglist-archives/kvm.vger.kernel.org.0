Return-Path: <kvm+bounces-31940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D59F9CEE8C
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 16:21:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D266EB332CA
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 14:58:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAE521D4352;
	Fri, 15 Nov 2024 14:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OzOL4lVl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2077.outbound.protection.outlook.com [40.107.93.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5311D433C
	for <kvm@vger.kernel.org>; Fri, 15 Nov 2024 14:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731682690; cv=fail; b=lA6uCsuNQOtiRpIBZhUjCh+97l4bRrt7a79MZnQQWB1qE9hKFTIjOtFuZIhO7misMoHCdpIVYbmkAVr1PYOaIgVfMeHFsFwCty0dM7U15yySGiCSRahMlKkjWk7qcVm7V6dKyzdNhSz7vK6N1OdyctD1sxffOXGmhn3hsLPal/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731682690; c=relaxed/simple;
	bh=w0pz7/WJ/DH876aKYn8gdbHy248+9SRp2Qc95na8nFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UrsagQacaegPsYmOuJOQL+icAEJPRd18I2lsr/IV8nzNOchr2XZen53JvzWbj/cgzfP9SI/95nLuwJ66vhO+ek9jwvB6wBPEqhQD/jXGPQIr+KhrDaO0WuJ4dN6Tlof2sixoEVOLx/zfa3sk50+yViEnR3oJ0lN3IzaY63Swhcc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OzOL4lVl; arc=fail smtp.client-ip=40.107.93.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RfKPwL20SriN4bK8bzxfuL5zUVXZqgGttNXxGWdSmGeJ/pbn290zDE1KxKU0ZUaIHNFUD79f5IqK/r55A0hgR1YOPBJPW4N40ffnJyRzNmeNnv0gztcAPEWkdxJl/temucVzo8jIWjgIqBQKfgM1DN14vaSPxgFAeUqzNB1KJNwpZvS/OSfyReHDtFjxm48WXyKzQ2eesSQ9GHJb4gejozdJ4B7Rl6nLVlHcg4COvzTBHiHm6B8a/rXvGdVSdo8fKNug/gNIwOX3VOk/x7UQ+0ndT9t/8H9ECOgAIz4inB0VUz7h8clwxssnDuDgrwXm5F+aHjv/jbsSu2sBGExW/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kwG7H3G7RjWLh9+T9C+7CzhfJdgWpkRCpr9DiYIAlTk=;
 b=mLDVpkB8/MhaUkNlVqe3LmYkhvzz5pe/yfwDeU2WDIQF5jJiU0WrO4j0dphB3Gx+X/7ZyHvqln5bCzAGgKbeiAnruj8Kdf9hVnXLEhe8khhGBlcNhHf9PdbKovuYqBsiLYLFCiIbHnVA6y07/KjZk3cSwclzWhrUEKe2WQGyTS6uTg05nmzEvFMZrQNvQtwAw6q+Zd9lkbhejnyu5hgv6G/TC9NKdVlmkBoCHVHExaulpWdSgZBhYlvlPZuz7d/HxZYXUaaFnQbESQwOSRkEiET7Ka4aeKuhDVMrwgmaXgWUJA43aSPR3cFB/LprLTz+EVbcYC6R3CI9dLa+702z2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kwG7H3G7RjWLh9+T9C+7CzhfJdgWpkRCpr9DiYIAlTk=;
 b=OzOL4lVlInn2hODJUOmGzIukHz1QEwepgJH27FTUZ9zaT1hGsAROo+/H1EAm99MrxlCF+XGoRnyF/tOa35yASxm66U6kGfDeTWcinua2gfVJOB/sGm6/hSIJM0cqfA3wbBWlsBmC7NI3Nn7zE/boMMsLdUUXnwLm6JQGSYM0nf3yLYOoi8oQsrqh0bpFhePUvHYWdLI0ESiDp9ht3S02p9BzTTccNQK/uoOOKxI2d8cnKfL13neX3VTyBBVl9Vn73IQyDpuwqrQ3IHgQDuvxnnLcg0N5tayDzY2XLmNv18KE8Q5+LRkPIRNnJqVXf/NhXpIugZhlTT5LGWT8+iOumw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW6PR12MB8663.namprd12.prod.outlook.com (2603:10b6:303:240::9)
 by MN6PR12MB8543.namprd12.prod.outlook.com (2603:10b6:208:47b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.18; Fri, 15 Nov
 2024 14:58:06 +0000
Received: from MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f]) by MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f%6]) with mapi id 15.20.8158.019; Fri, 15 Nov 2024
 14:58:05 +0000
Date: Fri, 15 Nov 2024 10:58:04 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: joro@8bytes.org, kevin.tian@intel.com, baolu.lu@linux.intel.com,
	eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
	zhenzhong.duan@intel.com, vasant.hegde@amd.com, will@kernel.org
Subject: Re: [PATCH v5 1/7] iommu: Prevent pasid attach if no
 ops->remove_dev_pasid
Message-ID: <20241115145804.GY35230@nvidia.com>
References: <20241113134613.7173-1-yi.l.liu@intel.com>
 <20241113134613.7173-2-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241113134613.7173-2-yi.l.liu@intel.com>
X-ClientProxiedBy: BN8PR12CA0012.namprd12.prod.outlook.com
 (2603:10b6:408:60::25) To MW6PR12MB8663.namprd12.prod.outlook.com
 (2603:10b6:303:240::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB8663:EE_|MN6PR12MB8543:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f6bc8ff-6786-4072-75fc-08dd0585e90f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4+NbzHnlWUKaSyK9+3JHw4Iw1CcQCZQ7hQte7tC9C26haJeLfBTTnE1Lg86H?=
 =?us-ascii?Q?i82f7W5rdZ24vD5gTJLZQwVpEZfJQphG3pbUwZzoxCDMkrGeEmYxuExvKFUi?=
 =?us-ascii?Q?TxPKlxOwfDH4O3XTcq/PaQlDPODkB3jOrCNR32wlgAfR6RyNj6OICypPy19I?=
 =?us-ascii?Q?dh0UyYCrwTWhIGdC4MsfoIbohm5E7AbB9O4cadcwaygm5eNFY0rItcgwyrBA?=
 =?us-ascii?Q?LqV90yDTPrxePb3R8VZpvylZ/H95tN+vxx2NLjCddX/UgfGSbH7KhGcmA9qA?=
 =?us-ascii?Q?bw9M8a2XaLMzxfROzNm1zehcWhWiTBNsea0XVq+D2vkWiVuB6yKDDBaHtVaq?=
 =?us-ascii?Q?1Uea2RTEy5i6APAG90uDQFM6SZy0432rYcZ3CJSClqcX6cTy156OXCV2/z7+?=
 =?us-ascii?Q?p4JlS4WY3A3rdJ+t1qxU57iMtw0Zrn89DdiC/jJGphlN4hpdKLQdFJd4uq06?=
 =?us-ascii?Q?sNo/Dp/YJv9h8WlBwdkrg68kXJnqlY4GHpOSTyeITe74g27+Efd/g83thk0t?=
 =?us-ascii?Q?tlwYUQThkVC5CvyejRHw/vB2ht60Zn232CwYw8yHj7I0WJhUi7CRIRrDREBn?=
 =?us-ascii?Q?KUG5jBsbYfslwLYhvWHz/0cyn2qJjjx/cqYbgA/MjTsKQSChjvuRKE+snZrf?=
 =?us-ascii?Q?kJAwhSooZZ34Ytaaea8PUnW6+DJCiwmxQXcNWwZdg9ERjbDBhpjnvRr8MqKW?=
 =?us-ascii?Q?vRVAsjsRQ2Uc7MGtUP3J4fopV5ol2EiQnT5htigc0t8WwleB1K21UJGXD3vP?=
 =?us-ascii?Q?SRHBBpG2Q2zZBpSQTU4R9xJyMZZ3dZLjZ9OTKKb77FzyL4F7H9zU7vpUSV3N?=
 =?us-ascii?Q?ZQH7vSJXfhOb/TJgJ7TpYahXI3wpi2ymr/VjBejRmR0B6IdPjD7an0pnjyKg?=
 =?us-ascii?Q?FesVTevQU3eGHTiW9mkddvqK++Sjl+9oVX1oUYvMhvoHkasQ0ELfCdEbRo/B?=
 =?us-ascii?Q?kijgc7yrHTPTncqBD3KPx6Igxsv0LEXR9AEY6D9RevMcv7Lxueqv/yhJN+xc?=
 =?us-ascii?Q?3s4aZo83qU0t1ulguhYXpR4Jbfl8Bu1sbVmlARHghsepX/vzWZRWe0Hzt4Ad?=
 =?us-ascii?Q?yp0wAUQfZUXREg5Qxkvz5Mm4/qH/UVD6NFRfbY3WiTkguaFm5an8/2DnG8xv?=
 =?us-ascii?Q?PnHFSzp3JTnlZwL5qG0FmMWC6KBtN7bQlmq9jJ0CI7BG98vpI9NJJFFGejIg?=
 =?us-ascii?Q?3Y2MDXz0pfrvJTXrlZFgNKWIvsOh3drXolNos1jDVhYDGTCItS737q93/9PL?=
 =?us-ascii?Q?qnCFA5Sf2EoVj4LA6DsgalKS+2rmL1abWM0KU4o+Oa1Lz5iCmxwebgM1HtBI?=
 =?us-ascii?Q?HQuhsrO/FoKCHpbLcL/mOkdc?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB8663.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EPSOqJULzZKA1+/4K7eECADcCeXyvr0rc7Wcu+JI+6Js/+HV7XDt5IcF48sK?=
 =?us-ascii?Q?RqO7dx1kW3q3rXNmDgVoZAfCF/+von+5cOQ1I+P6LVfMR2ScySIqVnK0QFE6?=
 =?us-ascii?Q?ccvq1Llqj7Cs4roTrKwax6LJacow3DPCQoj34wq5hB96A4lm/pxzvnCS/0tn?=
 =?us-ascii?Q?RSHJJ+J5ank+3jtZbFP299CV6iFAhPyafEagH84ZLB0QsmG35mcbzqMZVtk6?=
 =?us-ascii?Q?WWY6pBZshqclvHnxDQnULCycdIYsjBYfznZqbPtVEMPCPUCgMRasuD5/WUju?=
 =?us-ascii?Q?iy5C5x5XAWCeZI+gSJTY3UURynkF+u6rd4CSogmUdvyDZpOBtPBSq2IkowEr?=
 =?us-ascii?Q?h3pofMLc8ea6y46E+jXZ1ZGmijU5Qd54dtKpsToY2JskVhqAaR6ibryGWfiX?=
 =?us-ascii?Q?m2JN0T5k6+dstmAqEJshIv00my8XmdUszHok/wsjkBfZMOwhuIibcFoLTOk/?=
 =?us-ascii?Q?d0IRzpR//f/kVVBvnX6ICTZAwuMeiWMJhpsiNzSCesr/g73Zx9b+3vyfQAQY?=
 =?us-ascii?Q?SwGojPoPv9x/m69P0wQDMfhrqXg3U/H7DIKh8U+qOhNh7Zo+FpQFhQEoZFxa?=
 =?us-ascii?Q?nD/2FEJ6giOyqHVHdtXmOL0r6W8eamH4RMJ/zHu8wPzp3LXzpA/o7SKMkoqj?=
 =?us-ascii?Q?8Qb5jjfx5bQvsAgs9MuAHoDnb7+RymbWTR8LlKQjjyy+TEDVZuEDv9uQsasO?=
 =?us-ascii?Q?Tnit6x0/mnSJnwFPeGu5zguLfY6ewYU5W9d4zSCSiNuLfSu/Ym5Mbi1hBymP?=
 =?us-ascii?Q?Pfbconl0M/I1hB2kEl8InRhwXtXknVjyAR0s0s/6ONLhvDsf8yrHM8enU4CQ?=
 =?us-ascii?Q?xGqVhjsqGsE/WfBMqWJfg2RdLHDs9sv9fOoHQwmTDOQ+Uv+Db7crJLIFpC8s?=
 =?us-ascii?Q?K9FPWof0/3ifwPYmgg+DOUt+ChQhtGfUD0UAjFl8zPJZO2AErIMmFpnd8a9t?=
 =?us-ascii?Q?W+SEnb5NJ7z+TSby+/Ojvj+CWLFbAbaguflId13AuN8AM0l+z8aO3lImvUvQ?=
 =?us-ascii?Q?l6HJQxhc/CyJ4Rlo2r4G7pK16DIL/ASCutP6s4H03AQon+h+6rtkzmhVoE7Z?=
 =?us-ascii?Q?9LxERNne3U3ENc/VStfSfNODs9nabC13BogZ95RQuPP7J3WQMewNSyKGuIA/?=
 =?us-ascii?Q?MJL/c7ZDiq+7PEUFvO3+kk8TpPJJZR/XbPf55sxHwKTU+/Kxknv+Zj9+UV7/?=
 =?us-ascii?Q?FGUo4aRcYEjbAw3sNK6Nbs6raRORImONBd1Mkrr5kC6vQmAM6rMubWvaYKUJ?=
 =?us-ascii?Q?j8tNCC208uSjG8QAn/Cx5MvfbeNv0CkfuXq3bOCOvu+msnsSxQJ5nwc9ck7X?=
 =?us-ascii?Q?Ikq0LbOcn8lIz1egHtPmj5Rb0YQtQJZlUfZ9lKUaWgbBoIAzjP8K2GqmL5tl?=
 =?us-ascii?Q?itpugwSTZqdxfOO9BdIHG/WqvSLpcWbyLZmil2tPEbercEgfs450tQlX07jK?=
 =?us-ascii?Q?AcQyx+GNVOlEEPj0U59ICeOco+K2c83X2R5aprK7IH8CETDDXDp/eq5Nbi41?=
 =?us-ascii?Q?LFWerIY0F/DdBTx/4lvkuvjhAvFlAVo/HT5N0oBt6Qocrpkv51S8Wf7ZhsUZ?=
 =?us-ascii?Q?umXr0Wl8iqkR9P5Ba0k=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f6bc8ff-6786-4072-75fc-08dd0585e90f
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB8663.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2024 14:58:05.6508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Cxw6naXmEfPzN+p9b5HO66Hn5FIgb4wCrManxtXTcH6WlZW1ZE8Pqo4vtXMPyKT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8543

On Wed, Nov 13, 2024 at 05:46:07AM -0800, Yi Liu wrote:
> driver should implement both set_dev_pasid and remove_dev_pasid op, otherwise
> it is a problem how to detach pasid. In reality, it is impossible that an
> iommu driver implements set_dev_pasid() but no remove_dev_pasid() op. However,
> it is better to check it.
> 
> Move the group check to be the first as dev_iommu_ops() may fail when there
> is no valid group. Also take the chance to remove the dev_has_iommu() check
> as it is duplicated to the group check.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/iommu/iommu.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

