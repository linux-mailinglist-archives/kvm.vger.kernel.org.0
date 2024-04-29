Return-Path: <kvm+bounces-16154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2534B8B5A9A
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 15:55:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDF422846A6
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 13:55:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C892171B24;
	Mon, 29 Apr 2024 13:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Jr3QsRbd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2063.outbound.protection.outlook.com [40.107.244.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A496657D4
	for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 13:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714398917; cv=fail; b=P8mryUMU+5/HQ2eox68FZCTA1U9s4b+qDil8sbVyBmSZAdnAyEgon7J8hnQDulkJbtwgz37u0FgpuFtx3sng/FLq+gVFFxmnPotx+cHPmZSxMChkgrNxWAIED7a220pB0m59h9QzZxjPOrVOPhmdqstD4e7E3Sk9GqI2ZRSAVg0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714398917; c=relaxed/simple;
	bh=y5vUllEXQ/Ytf/DtK/SUyZyQDnIeH1PxBQg/jOC7+OI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DEXOUAPXJun5X/EADa0ooGJzAaMfir8GUjC8GPuk1pdrHORw2la+SYCIc8WqhwFxi3Ovs0V9PDMcXDUtR9dRfoli5yL3H5uS2WmVoRmLcmpy0XyeCu0NMrBCBmhgwM7Lqpv+K4sj0LdjKdXXb3t/VURlEvlYNQqgeBVhVRWV4SI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Jr3QsRbd; arc=fail smtp.client-ip=40.107.244.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=it72CjO58bB70o4mKQ/u/ofYlSJ4tA+OhvrLICMO5AdZmbOVnr/Km60wzWKG/Dd4AubLG6OSBnPe3m5IaBWSap9/z8sY6nttNzQfVHpO+Vt8H7yJNRXF5w/iE0NdBtIfYFRW5cdHuL7HPW9zEJG/0GLNafiOzKq+cOSHhpvem+zqiKBCyRvHJ23bZTQOYfg8vG9eOT5t/ZSrEIdiSWLRZBXhIB9QvE44X7HewcEVqrZ37BfPJA7bYJFgMjnkKthmK74T0kEjHcuCG2DNNQ8bqH9dZEKqm0VR9bOQCuFLBFugExRf4RtKtx25aEf7hE7gfOVCdq339T1vqU6YVstSTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yx+Tydu5KRt4GIdEq+7aDtgytxmTKo/B1b/Lp9ZT/dc=;
 b=a/LzIN/aWt6Ylcvk4lmYCUh2OcqGt/GJaKXk335y202eH1w8YGEjwlWgv1YJ9mQJPZ58eAWhWxdffEJ1hn4R6Fhrg03R/euS1WnO+vc0KMHED8DnkWupNN+ZcCaSvAN7XDBSBJyjSal1wLrfaWg1I5rBMMv3rtviWVRJaAIzvnGSf2gJg9UqhN9e6gDnQn/GTvID9FKQAgan89UcX65jvuYyYxCAL/LnTYlH3Z2NMb2KFe8pK7b6jiKUEkEBwdobiacgfyLW3+oKXSLaUjiFzRv1wX71OzQnuk9fT5t/WRO8T2WshicQg0RsV9h8ngt9JVhNTSxqHNLWmJg236eyow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yx+Tydu5KRt4GIdEq+7aDtgytxmTKo/B1b/Lp9ZT/dc=;
 b=Jr3QsRbdcLfNeV04cBxEwVvSQhXJeCYd9/XA9KxrNGBNr0mvkoP5mvOATweGdJgaQ2DrrA+LDVwRMgo4wuDLMelJq6tKZMoT2SqwUmplwl6ftb7VaP2m7MCrA9aCGjfMSjL9ZZZIuL0I4YEd0O+9Ba2c85R31RjFdvfUPhQicVeXia3SYOX8YFoQ7Ju95BchX9oiTAd7YSGIG24M/SeozTZxEFiKyKHvrLz3C7EBCqlpUkhmD5GONgfMNQwEJt0b1anQ+3nA34ggKLdR5iMXN82sOJAzz67zuYS3poh+SMJyp5tKp7S0KAVlchRP8OPAYfkPd/SwiSo/bFdtBIF1+A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SJ0PR12MB7008.namprd12.prod.outlook.com (2603:10b6:a03:486::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Mon, 29 Apr
 2024 13:55:13 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.031; Mon, 29 Apr 2024
 13:55:13 +0000
Date: Mon, 29 Apr 2024 10:55:12 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: joro@8bytes.org, kevin.tian@intel.com, baolu.lu@linux.intel.com,
	alex.williamson@redhat.com, robin.murphy@arm.com,
	eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
	zhenzhong.duan@intel.com, jacob.jun.pan@intel.com
Subject: Re: [PATCH v2 02/12] iommu: Introduce a replace API for device pasid
Message-ID: <20240429135512.GC941030@nvidia.com>
References: <20240412081516.31168-1-yi.l.liu@intel.com>
 <20240412081516.31168-3-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240412081516.31168-3-yi.l.liu@intel.com>
X-ClientProxiedBy: BL0PR02CA0093.namprd02.prod.outlook.com
 (2603:10b6:208:51::34) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SJ0PR12MB7008:EE_
X-MS-Office365-Filtering-Correlation-Id: 390d2378-f390-4adc-6178-08dc6853fddd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|7416005|376005|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?c/ssumhwCSfulHo+e3CIoq5a+GRCSSP0/JKwlUdajqEEIRfyctcTUvO2Ckh2?=
 =?us-ascii?Q?fB2ENLNWakWfJAN3/h4MVVMHtPkGmzH9kx5T5Pf3b2mGBxY8nGYqAA7jitwu?=
 =?us-ascii?Q?9TZyjwlaYK2HxAgYht5/IveBgTv+rAS2f8JINNv04jFT3GFy2HKfs2UB7tN0?=
 =?us-ascii?Q?7uPZRfzXM53sckEToCxhJHcnJbydOPeLaG6Fal8AJltsad/gxofkFdV8Mh25?=
 =?us-ascii?Q?6srvEA57vewCdN4nGnfp3h62cqVLxj2gCBZN4lC+PgxXwdEGz/tpVBD5u7RX?=
 =?us-ascii?Q?LtftwWRJ4rEhIf/V3DsvKcuVfVHv6W+xstRI9n07hC5wp53W7AO1gVJFhf4y?=
 =?us-ascii?Q?OcSQ0F0kTKt7IdskSA5hlYiQeD5qFjlb2ZRiKL9qsh9gNER18I0ThMXfHoc/?=
 =?us-ascii?Q?U+svt6/Xx3eHw5h3H32phT/64YX+rfD1D8T66pFB4VhddeLrZSwWYwTXej5E?=
 =?us-ascii?Q?yA3WeXH+i6GWR/SGqUsTizawle2srd4hhI4Muknp10CAYbRVuH1YfcK/Ox0T?=
 =?us-ascii?Q?nDPym6Rcy6Cn2Ya/vV9l9g7OrabKvjlDIpFGJntHxxACQaMkwGn07ehZ7c+U?=
 =?us-ascii?Q?ygY0b6gxr2y0tUG7f/0XbsOBOu21o5Wmfi8BpjQjO/vzlTPV3/cEmjOLgGT1?=
 =?us-ascii?Q?73mu8s0Fx69BfRpJaVc+ZLemM9sTs4XWEXTH6QO8jnHj4/SJcxANWY/ZzkIK?=
 =?us-ascii?Q?i1TPV/RzSEYpjzPfe6aVY0tA2UJ0iTUhE0nY+qi0vMI++ms1GZ1C6gzAq1FR?=
 =?us-ascii?Q?QnqszWxv3m+rttnEWoXxvLB0QLcJ+o98iyDZ0zoxtqVB0wKVJVR2oFQVAgvq?=
 =?us-ascii?Q?2CdTl3dooSnJtVXtFqDk8AFQIleuM1jUN50SwPIAY9txqj75nh3W797aQ028?=
 =?us-ascii?Q?5VVPmqIQbs1LcyJ0GmAStCkHbJJGY5bDA551E6uBkm6VLj6Ie+4skSxs7kbA?=
 =?us-ascii?Q?Zr6A/oyfBpKW9QYqJzzRGx5/IMBJjN1w1aCimoD8qQroEAHAO3poV0nB5U3R?=
 =?us-ascii?Q?D07GHIGzucQ2cL2yWHgbwlKQqskSpwThcsVngdHrGUzjF6THhm1MwyqIKrL3?=
 =?us-ascii?Q?DyIN1rPBmjACGHkIjPAPobv4ino1gV67bCtMCV2tXr4kzFycoVIC5xUg+wjh?=
 =?us-ascii?Q?elhTLktoFUTpWe9erRNKE8rar0vtWbuLahNDSXxZkdS85a/cU44eTaxM2jfS?=
 =?us-ascii?Q?nA93w94HZWW0CJrfQtMW5ju8vCcCNuu3cFDsN1XQb2I32WTiorStw9Cp/TuS?=
 =?us-ascii?Q?D1TU1JdpKqcV6qEJSoXvLmnAVIFSpQmDcl75B+71uw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eMqpv3RcODE1ET1tvl9Vbh6i6Y7oUZGcEKn2IwoChbVLr+Ihp+prMAp8Z91u?=
 =?us-ascii?Q?rT0Uz9eDaHjyBsgF8fYcJFlzVVeUrLTv48Faybul1b05JlRfv5EiJtw0YJwX?=
 =?us-ascii?Q?S9Y4ehIwqodzFbJrrHajPCUL4wcIHk7PyE9qcxuTbHGEK4F2JuamrScgDOCV?=
 =?us-ascii?Q?xe7DflnfKh2cBnjkRCi3g0AFWoS9KVbceG30Un18/6N8ndbc0IMwsAfuqtN8?=
 =?us-ascii?Q?HBgr/08wX394DNyacNzpghkhapH1DUH4bmnGv+00SbjQVfr/z1fyMoXOOc/r?=
 =?us-ascii?Q?+M8QVjw45krlvMEMLx63MG1SRvWsxhA84fNFV0/ARZYLcbUSdlrjmxxa/xQs?=
 =?us-ascii?Q?R+zLKTr94+Zww2tAWPPSCx/Qsd4V5Ti6SFysI99RdJp1KifujokgAvMRmowu?=
 =?us-ascii?Q?i0y847mHYHXuWm3qpHKp6q6mNzidmTftiJoNmiFBZY9inee1dkKrsFM+7JpW?=
 =?us-ascii?Q?g0CLP+MaR/Aj8iyOBUg0hEjBtFh+8gLwSoPzvvYjRz6cZ5PMULoPCxnkAhqQ?=
 =?us-ascii?Q?kKbRuVMulnb+pGYhkioSVOSpuI6Y2MELk5K1OjjUQskH1m5kPe3Yu31OsKbS?=
 =?us-ascii?Q?fS0fpGzvZ15pU4+7D8SYdcDuNWnWcwgIm3PxIhMyZ6LRHu7aQs7CBBZB88sX?=
 =?us-ascii?Q?rIChN62DEfN13dkZjkPPEUy0OMz9YsF6EUH7lpA6cXunqa91KvpQj9wsEqQ/?=
 =?us-ascii?Q?68H99Ismm7DA4YFPp0X25a7pUGjplgUdRIMhSsGYAumJFYohRSH0nMPROMA4?=
 =?us-ascii?Q?Xf25jQzoXI1v3FIo884TL/vo6I5bCfWeYy251eVeGHAQWOnniYOpx40t4FLw?=
 =?us-ascii?Q?GEkaQd+NccBwkzf8CbW2e0wsngLM5U0DfzFGZO43ldFYMDxG4PIYW/NP7tnw?=
 =?us-ascii?Q?1jRja2ak/CHTLHxA37oNMxuIU5c7d5Dm4I2ym/sw5bZPcmvAGFi0WTltzimI?=
 =?us-ascii?Q?1E2/WbNG3LGLpRQlgSVoivggXAuy5rIrHjt64kwq7rsyHwAKe/+PnRGLzxwZ?=
 =?us-ascii?Q?bwWZ4XHV3UVyPvBXaZr5VvwXmiTQl6C3319XfOmdIimpccOAs431JE7VdqGj?=
 =?us-ascii?Q?bSDGudGlCrsr1tYv6dm2dV+wpiXgSHaLN55LJeIGgWMOa3UV7hOH91c291zU?=
 =?us-ascii?Q?+3CITAQubMnRh5FWkDiT39JqiSDW4zCl20fhVBPCqhgmpNgIquGNtEZYe7mo?=
 =?us-ascii?Q?Xmc/SFa1O7Jq1w9c/m6lP+gc1GTD4AKokKlGUWZRPurgBS1imqduraO+8mbQ?=
 =?us-ascii?Q?GKtZJttBE7OclqItQxN3B/4/rdD0hEcWVuALxYowKiLhpfHZtaNlXb3Y01Mu?=
 =?us-ascii?Q?u/OxUBNQjKY5/KEyYpHeE2FZNrwIyBL9rtfWv3r+hSbCTjGAX6+KmNRRn7Qs?=
 =?us-ascii?Q?XgS4JMTqxkTKekIatrZzVFiinPSjIkQ/ZVsBJQ9I/l4Zn/Qkbb29U98pURkr?=
 =?us-ascii?Q?NeglfTLNJ5SOEorlYVKOBGUgP/mSx2y3115pRLFHR3cDAoAcsPaZav3XxaG6?=
 =?us-ascii?Q?gNc9L8a3UBlhVACdYHl2Z/BMyWbUHr3YxHM8H/PTOOzgsQgU+kSs3o6Cnc3V?=
 =?us-ascii?Q?TudGe/fREHV6lzQDsfXqzhc2YQoZ+jK7jCui8ywZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 390d2378-f390-4adc-6178-08dc6853fddd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2024 13:55:13.2151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1c8LFJcVNX/p4GiXF9JZxRQgYUifCHiddwMIADtslM42o3/6IA0dA+U2istFpL8T
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7008

On Fri, Apr 12, 2024 at 01:15:06AM -0700, Yi Liu wrote:

> -		if (device == last_gdev)
> +		/*
> +		 * Rollback the devices/pasid that have attached to the new
> +		 * domain. And it is a driver bug to fail attaching with a
> +		 * previously good domain.
> +		 */
> +		if (device == last_gdev) {
> +			WARN_ON(old->ops->set_dev_pasid(old, device->dev,
> +							pasid, NULL));
>  			break;
> -		ops->remove_dev_pasid(device->dev, pasid, domain);

Suggest writing this as 

if (WARN_ON(old->ops->set_dev_pasid(old, device->dev, pasid, curr)))
    ops->remove_dev_pasid(device->dev, pasid, domain);

As we may as well try to bring the system back to some kind of safe
state before we continue on.

Also NULL doesn't seem right, if we here then the new domain was
attached successfully and we are put it back to old.

> +	mutex_lock(&group->mutex);
> +	curr = xa_store(&group->pasid_array, pasid, domain, GFP_KERNEL);
> +	if (!curr) {
> +		xa_erase(&group->pasid_array, pasid);

A comment here about order is likely a good idea..

At this point the pasid_array and the translation are not matched. If
we get a PRI at this instant it will deliver to the new domain until
the translation is updated.

There is nothing to do about this race, but lets note it and say the
concurrent PRI path will eventually become consistent and there is no
harm in directing PRI to the wrong domain.

Let's also check that receiving a PRI on a domain that is not PRI
capable doesn't explode in case someone uses replace to change from a
PRI to non PRI domain.

Jason


