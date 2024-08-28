Return-Path: <kvm+bounces-25291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D0D196309E
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 21:01:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 82D5C1C22323
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 19:01:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3E1A1ABEA1;
	Wed, 28 Aug 2024 19:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tI5Ozs64"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2046.outbound.protection.outlook.com [40.107.93.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4B11993AF;
	Wed, 28 Aug 2024 19:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724871670; cv=fail; b=BPSsR8ntxDNdnJFrgaUT3Mjyh9r0BGAWHUgsHN1nAJAC/b/Xdxq/O0UhiVCJfu1TYBVB584DC2iRdiBMIyX3kF6gXktUtsookW9i1pszOocqGpkI8/l7Otfr31YPJ9cPuZVzBlC8aGwuP6Q1VNLtJuc4jqCFEO3FJG9MqPujNLQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724871670; c=relaxed/simple;
	bh=LyVMyq4RDCyvAZYEN+vb6jJK5t0K4tSmMGbLiwky1gI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bdy/FbpBjkHfvRefOum72YKUmg21+dV3ETmDhQL60dsW7diisSWUFJO/209/6e8XzHaa21VTZLIHiY83RhZxVjT8yiaobRSdKRXNxtwpSv27UyE/LOE0KvPT1WpVQ/ikArmO/euFr2y2YU5tuhBjul2LkZKAHjlvYNELZ6cIEmo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tI5Ozs64; arc=fail smtp.client-ip=40.107.93.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MtPRi83/A+BCiKsWOR9VptHSayMPtjlSl0k6Dzpf/rCCau9zXdb2fPA0R5kBYntzWq6N0NQ9t71qvOrAQBEuX5RCjjYgYxb/d1AjjSn+z36Kq8FhyC/5MDjy1IeGTPIGaLZTFDVFvNDYj23ToXDkAE7B3fmpEkry3eYWey45bigy7avqwU+xZtyIJRvTXZT0NX46Dl8DkuYYcSIdcakquoEUusKpYUZUWDSjwjbY2mp9fLrqzRHvxFgbo+UzczG9BgQJWS29c9y/zgnb2+bs+qiOKmCDfXfLz6ZHiOFC/j2U5KEJc3nN1Ywtt9b4ynqKWQAMqfvhM+EPExe/nNnBtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yM8++mz3VCUErKmy+WJHwrhdEHjD0HHjy6i1OXIubWE=;
 b=oUekb6M6uBM/xob8GkrGqsU2PSscmsM8bQeGctAhUSbRxGWebbkE3g4GbR6bg9X5x1XahU+8NfAZySAwVdxVxQksDIAU9PIR3xRjLskKajA5DvPWyT2rCONIAKjpp7Oo0+ProTTgS8qvB7QKv9l2koXy4eiNenJo49kQS6zmxs/02YFhxO+z07VeHeK6EMby5s3RadHG73a6Yw66eFrrVznut5M7L4SwUA4U6f3MrttQZ0VaIMDty1gPabVhZJ+5sHotSaGsiNXO1aeNlxs8lcqBpnEUqHLcZJo4d2qO1z8Te8Y56Mb1N6QsfOO4QacaBT7wnTLyUo/UlbFJhxb0WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yM8++mz3VCUErKmy+WJHwrhdEHjD0HHjy6i1OXIubWE=;
 b=tI5Ozs64EEY3rIZ9QaQ5dK0gzf8I0ztfCF4wW/Z6t89et9VEhcZXUU5q7fs+Muy/uKzkNPGcgl9A7iSKNidJlrzMcTstU+bwFhWFhgJldddeKO7Fw6nckgSlmS+8seQub9wl1h03ioNsT3BPtI5aXzLZWozB9ewd2ZdBEX9IRv9eX6SKEZ0iUVtTMF48EdNlSSMAvWtZ7D+6IZ4Hdc54/Mq0xnPsRgGL65WtjdwQsnCAiStXw7Ph4sHjucQNql1wjys6PH7pa8feJPPvQrdi9f9J6g6rI97/nldQAc3H23lcmvz9pzPbdW+HOcaa/w7mnMQC6rQRCSEoPFGzKEXLLQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by CH3PR12MB8852.namprd12.prod.outlook.com (2603:10b6:610:17d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Wed, 28 Aug
 2024 19:01:02 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.027; Wed, 28 Aug 2024
 19:01:02 +0000
Date: Wed, 28 Aug 2024 16:01:00 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
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
	Michael Shavit <mshavit@google.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 8/8] iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
Message-ID: <20240828190100.GA1373017@nvidia.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <8-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <Zs5Du208eSxU67wT@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs5Du208eSxU67wT@Asurada-Nvidia>
X-ClientProxiedBy: BN9P221CA0001.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:408:10a::16) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|CH3PR12MB8852:EE_
X-MS-Office365-Filtering-Correlation-Id: 150acda6-34da-4eee-8467-08dcc793c288
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pXi0ImsRFKLlQXE1yJQLL0TSnvDnk5lD08FUtUIUFGUT3izOdXX45dt8vSef?=
 =?us-ascii?Q?iPyHJJW/VyBKQO+L44+kxXo4DU/Yz3KZgJP4krsTvaDcBSaqgf8teK1LHih0?=
 =?us-ascii?Q?IAchJYB9aisN30EhiGF8FZjJ5Lj7vD8LbhUWpiSb7iQasU9R6wYexUpj5oMC?=
 =?us-ascii?Q?JEq1oD8EG0NH3PUDmAqAYRAGCEV6uNJYLMXrAD7+ft5yzGYHNq566B22bJCL?=
 =?us-ascii?Q?42RowMR+QIGvTP4ob5TKNxTox3SZFIG85Z32zoq5T4sECnGzhWn7kDUryEAf?=
 =?us-ascii?Q?NjctH1xM1B+uHVXTNLzswBayBsCydsGqBCwUBSErXK5RcWoclMN0cehXhFBx?=
 =?us-ascii?Q?HhQtkHKd48J+cprKaaS/jMRriRWVFsjc5+XOpPPpQPTJMBMcnUgn7tjbOaVs?=
 =?us-ascii?Q?J/4+eugYwttsjrsm4WpEC0ehCF/hvgE3j79+83kEIV3Y5D8/MqsNsZbcJVnj?=
 =?us-ascii?Q?2pnflnyYjifK30geq3QX0XukI4EMV7ITE/0TNw10NoDUcV1ucD5bM5ti6Mvd?=
 =?us-ascii?Q?f8INri/DML4N2tCc//4u/Fv+EevjtMnsBQFZHN2XthjTUXVAKleRq/drewbV?=
 =?us-ascii?Q?xfFTYqk1xfnZKPJM5M2XuEruDcT9oqF6qPLkaIl/GFrt5fsdYSgO4YCMVDtY?=
 =?us-ascii?Q?+8emBmSPbQ+Otza89dsjBZYZNBUdoIhEFjQqLyJNSnsF4ZV/JNPC0u1z0bdT?=
 =?us-ascii?Q?JDWkgSvrktkwYP+xyLV/6A40ZnmTdepX7UoPHuaBqS4iSSlIsyZOtx0Fhrca?=
 =?us-ascii?Q?7iKW2eF+A8Z254gbhRKUCwoI/VNq3VFuCam62uooirZCPA2rUL9FUrmZcgOc?=
 =?us-ascii?Q?9/VUW1yCRYiZ9gLbRc1ASjCVSBB+OJaXEIKIyTKwQMMTVPS/tV3TZsDRdOBq?=
 =?us-ascii?Q?TJY+LRXKkMacO5ljGzZxDOZdm5rIq587LpVked/8MoDZcM+EuaLIg+RJ7O1d?=
 =?us-ascii?Q?7YAUd5MWnjBIVJMD6VcRj+e9nQc21Mbq+Vo2XSgWtghPm9HR02hSv9piCKsW?=
 =?us-ascii?Q?/EtXXQvknbibu6n3IQA8YxJd0Cr6mGtcxTevu6XLWLHj9yyKG0fF0dBI7Nl/?=
 =?us-ascii?Q?Haq099SvkfsiM5MHazSoDTb8bZVYqThCyQEmyZmp9T1bKVYiTv2UATN2QmU1?=
 =?us-ascii?Q?9zLN134zWT/EothzQHBwxNCT9EcjH+zz5t6+sW7xV1DIQ//10fzX5YkzhZhS?=
 =?us-ascii?Q?uGm4GdCwMBsbpHriCSHNqtElLqa18DgiYvSnvbo33FoEBiaHnSGHWgdImjj3?=
 =?us-ascii?Q?0u2ORfxySSullkkpJMSZJj+yLx/ENcaLqSCzfASza9JsvPOi20xwmid2ypG5?=
 =?us-ascii?Q?zqCpIcLe64VsCBaCWkwT8TdxGuXTYx8ov4+q2fkCqtpa+A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EaN6ppijGi8A5UYHnNKcEctAghgffcNuOT+AVx+SVwkCho/ahGUWLbCsG0Bo?=
 =?us-ascii?Q?4skx9+tPBKkeK/BcOIw+14UW9jzXF9g3MDd2zE3Gw9nwUmzJJZMSgvmJrbAU?=
 =?us-ascii?Q?ovI5toaVcwnN39dDXBzRgbNckt4OJmTLVoHxRXTyxoqu0ILCZ7g9vzjDJp2i?=
 =?us-ascii?Q?8WSDw5M84ihpaFiHMwdJ9NtZIYODfpDvhq7BmH8GHR3sOStsCqerVv2Rh/bU?=
 =?us-ascii?Q?3kOxAmdWe1XQVuBsPTMY8aR36ECmHbq5IdHPOI487mcy27JNC+2M5bDJ4Y4k?=
 =?us-ascii?Q?2JVHSxGEOly3Dk7Ybov/7YhhY/CkAldYZl8nRT/ByvMPBd2rssE63x46t+A1?=
 =?us-ascii?Q?NdidIqVxohOH2GRV2UZP991zE0jxbZTPddPD+yrB5mG3Yyl9skXFyFlGNGd+?=
 =?us-ascii?Q?78F9RvRCGVvMK+RKKOvGugezm5woPKy7xUylfnep7AApYAM+zr6QxHuHq+Dx?=
 =?us-ascii?Q?2f0z+R/NlNkllibL1HwQh9vYIQda6jkSZQ8cNlD5Hw9j0SiLOWeRtDNHAGBQ?=
 =?us-ascii?Q?sBupsjljKCh5Kdoke/1gUBhAWmG96WMMEgOEucf6uioTcQU9x+6YoAO3181e?=
 =?us-ascii?Q?S71NmiQJacHQ5G0q2DQmJOwnPSq2K0HznUOcVaFdQegxw3tJUACj9+AQBmVZ?=
 =?us-ascii?Q?J6xdugfbgKPFpRmTcYGCrxFVko3f8sy82moxRwdB65b5EMdg+jxfbDBIYdhb?=
 =?us-ascii?Q?7WztuUS85LJ9G4Nt+2vbfKli6iUKaF5EJGheFwbSdxLhcTc63lQqEb3JVoKO?=
 =?us-ascii?Q?NF838CzkBS/UtGehWZyDMMBIOoNOp8SGANqNl+RsIyN2kVibz9tG7XAp0HVe?=
 =?us-ascii?Q?NPliLfeuPXxnNT/Xox2rcqqfj+Jp7rJBvLMtFiIT5fNw0kIqX4cgrxZl+s/i?=
 =?us-ascii?Q?dfdAiLm9E8M4GcV7WbQxEvMYtrVxxoEUXOotzViCP6cdkSxCeK951vFWsI/C?=
 =?us-ascii?Q?DPQBIMF+EVFUROVeSosP9SFVQw3t61kBzduSQGw2OEarJ2IIQh1K9Hg/SVB5?=
 =?us-ascii?Q?t8LhyUA58zSt5p1PbpUdUaG5We9TUrrYKaSN7kjyhPKKa2nhf2ViaZG2ar41?=
 =?us-ascii?Q?i6TLoaRNtEcIa7zKv6tsZU1dDYt3pnXBvLT/2+KN719AgMIWThiJ1naFdnqt?=
 =?us-ascii?Q?k/N9SR7LPaCT5VsMA39V1B1ImSVfIDCSL6akOL0P1LRTyL4+x2hI26kmCTII?=
 =?us-ascii?Q?eDtVShE366NP8qDS3NEUwkqX0MawzvGOxZJiPmkC38JDjuBKSOFGxYAdpYhy?=
 =?us-ascii?Q?FojTdFB4mdnARoB0HwErqIXIJQkYQhqcecvg9IxQOFoAfdGPJtDpFjyAQdha?=
 =?us-ascii?Q?iwl+PbO9YNms8KNx/yyU6ytuOhBl409KBRE/nQ4Hj3qPrPrkgCU25nSsVFK7?=
 =?us-ascii?Q?tIEbMVwMUk0LbfIrKUTMw+H4M4akVTpS/ADx/EHyCOGwnuoSxpEHEuDF0D+l?=
 =?us-ascii?Q?gT4Ptiinr0q6Iw9YmjiXRCR2PB5IWPBy5QluJuKlWaILY888SDJWdsBJ4P4d?=
 =?us-ascii?Q?S8fSSh2gon7aYRcyyl4+kwVW+K/yXjw+scl9ZlwU5HR5g/u7lhaQ4tkcEheo?=
 =?us-ascii?Q?cTev8QT64r9iLTsLeXvbn/oTqRrq+GDJB4qUG06h?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 150acda6-34da-4eee-8467-08dcc793c288
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2024 19:01:02.0084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 68N68nRulLLxC4LZyT2GOAcFk8fcoaN527FThEs3KGu2oPo/I9E0PZuqjfQ7FhCx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8852

On Tue, Aug 27, 2024 at 02:23:07PM -0700, Nicolin Chen wrote:
> On Tue, Aug 27, 2024 at 12:51:38PM -0300, Jason Gunthorpe wrote:
> > For SMMUv3 a IOMMU_DOMAIN_NESTED is composed of a S2 iommu_domain acting
> > as the parent and a user provided STE fragment that defines the CD table
> > and related data with addresses translated by the S2 iommu_domain.
> > 
> > The kernel only permits userspace to control certain allowed bits of the
> > STE that are safe for user/guest control.
> > 
> > IOTLB maintenance is a bit subtle here, the S1 implicitly includes the S2
> > translation, but there is no way of knowing which S1 entries refer to a
> > range of S2.
> > 
> > For the IOTLB we follow ARM's guidance and issue a CMDQ_OP_TLBI_NH_ALL to
> > flush all ASIDs from the VMID after flushing the S2 on any change to the
> > S2.
> > 
> > Similarly we have to flush the entire ATC if the S2 is changed.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> 
> With some small nits:
> 
> > @@ -2192,6 +2255,16 @@ static void arm_smmu_tlb_inv_range_domain(unsigned long iova, size_t size,
> >  	}
> >  	__arm_smmu_tlb_inv_range(&cmd, iova, size, granule, smmu_domain);
> >  
> > +	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S2 &&
> > +	    smmu_domain->nest_parent) {
> 
> smmu_domain->nest_parent alone is enough?

Yes, I thought I did that when Robin noted it.. 

> [---]
> > +static int arm_smmu_attach_dev_nested(struct iommu_domain *domain,
> > +				      struct device *dev)
> > +{
> [..]
> > +	if (arm_smmu_ssids_in_use(&master->cd_table) ||
> 
> This feels more like a -EBUSY as it would be unlikely able to
> attach to a different nested domain?

Yeah, we did that in arm_smmu_attach_dev()

> > +static struct iommu_domain *
> > +arm_smmu_domain_alloc_nesting(struct device *dev, u32 flags,
> > +			      struct iommu_domain *parent,
> > +			      const struct iommu_user_data *user_data)
> > +{
> > +	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> > +	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
> > +	struct arm_smmu_nested_domain *nested_domain;
> > +	struct arm_smmu_domain *smmu_parent;
> > +	struct iommu_hwpt_arm_smmuv3 arg;
> > +	unsigned int eats;
> > +	unsigned int cfg;
> > +	int ret;
> > +
> > +	if (!(master->smmu->features & ARM_SMMU_FEAT_NESTING))
> > +		return ERR_PTR(-EOPNOTSUPP);
> > +
> > +	/*
> > +	 * Must support some way to prevent the VM from bypassing the cache
> > +	 * because VFIO currently does not do any cache maintenance.
> > +	 */
> > +	if (!(fwspec->flags & IOMMU_FWSPEC_PCI_RC_CANWBS) &&
> > +	    !(master->smmu->features & ARM_SMMU_FEAT_S2FWB))
> > +		return ERR_PTR(-EOPNOTSUPP);
> > +
> > +	ret = iommu_copy_struct_from_user(&arg, user_data,
> > +					  IOMMU_HWPT_DATA_ARM_SMMUV3, ste);
> > +	if (ret)
> > +		return ERR_PTR(ret);
> > +
> > +	if (flags || !(master->smmu->features & ARM_SMMU_FEAT_TRANS_S1))
> > +		return ERR_PTR(-EOPNOTSUPP);
> 
> A bit redundant to the first sanity against ARM_SMMU_FEAT_NESTING,
> since ARM_SMMU_FEAT_NESTING includes ARM_SMMU_FEAT_TRANS_S1.

Yeah, I think this was ment to be up at the top

	if (flags || !(master->smmu->features & ARM_SMMU_FEAT_NESTING))
		return ERR_PTR(-EOPNOTSUPP);

> > +
> > +	if (!(parent->type & __IOMMU_DOMAIN_PAGING))
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	smmu_parent = to_smmu_domain(parent);
> > +	if (smmu_parent->stage != ARM_SMMU_DOMAIN_S2 ||
> 
> Maybe "!smmu_parent->nest_parent" instead.

Hmm, yes.. Actually we can delete it, and the paging test above.

The core code checks it.

Though I think we missed owner validation there??

@@ -225,7 +225,8 @@ iommufd_hwpt_nested_alloc(struct iommufd_ctx *ictx,
        if ((flags & ~IOMMU_HWPT_FAULT_ID_VALID) ||
            !user_data->len || !ops->domain_alloc_user)
                return ERR_PTR(-EOPNOTSUPP);
-       if (parent->auto_domain || !parent->nest_parent)
+       if (parent->auto_domain || !parent->nest_parent ||
+           parent->common.domain->owner != ops)
                return ERR_PTR(-EINVAL);

Right??

> [---]
> > +	    smmu_parent->smmu != master->smmu)
> > +		return ERR_PTR(-EINVAL);
> 
> It'd be slightly nicer if we do all the non-arg validations prior
> to calling iommu_copy_struct_from_user(). Then, the following arg
> validations would be closer to the copy().

Sure

> >  struct arm_smmu_entry_writer {
> > @@ -830,6 +849,7 @@ struct arm_smmu_master_domain {
> >  	struct list_head devices_elm;
> >  	struct arm_smmu_master *master;
> >  	ioasid_t ssid;
> > +	u8 nest_parent;
> 
> Would it be nicer to match with the one in struct arm_smmu_domain:
> +	bool				nest_parent : 1;
> ?

Ah, lets just use bool

> > + * struct iommu_hwpt_arm_smmuv3 - ARM SMMUv3 Context Descriptor Table info
> > + *                                (IOMMU_HWPT_DATA_ARM_SMMUV3)
> > + *
> > + * @ste: The first two double words of the user space Stream Table Entry for
> > + *       a user stage-1 Context Descriptor Table. Must be little-endian.
> > + *       Allowed fields: (Refer to "5.2 Stream Table Entry" in SMMUv3 HW Spec)
> > + *       - word-0: V, Cfg, S1Fmt, S1ContextPtr, S1CDMax
> > + *       - word-1: S1DSS, S1CIR, S1COR, S1CSH, S1STALLD
> 
> It seems that word-1 is missing EATS.

Yes, this was missed

Jason

