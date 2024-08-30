Return-Path: <kvm+bounces-25555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B3FC89667AB
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 19:11:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4320A1F25A4B
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 17:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96ECE1B8EB3;
	Fri, 30 Aug 2024 17:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Y2XHDOTV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287DA192D98;
	Fri, 30 Aug 2024 17:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725037851; cv=fail; b=QnqFk3IO0Kddp8l4YSuTw1QUdM1B44qRtDoq6Y+stJ8AOLRPH2oJeM2HR0C+poTZzinzFJ8PttDqAny0H8RDtHdIB/fUab+tiXs85ZBp9ou62FcPpks0QpNw4wmcoMoiPz8TScIK0hPkcYMmQDzi20X4aJwf51taq0NriwqXu+k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725037851; c=relaxed/simple;
	bh=aNFOMn1BZEZwfLqbKWwY3Cq/nCjxt+Nd2FLWNgyZ5vo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=btv9Ua5PN7lspjvTIn2P7vzAoJWhiR1qlcu4CBUtuUmyMXLcUluHqNisK7cqs5Z0PgIZPddBfs3rXpum2v3/ZQXUvk/HHXUZKn2boghro3cHAYW5S8IcVCHId8gXRbpBcDhBT+jXHKDGyxVdoJ6Vpajehk+x8XgbON7wHUb6wfY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Y2XHDOTV; arc=fail smtp.client-ip=40.107.243.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mT6oBP3OMLKJKkVlJTkc451d8iqghw3Q6enmXlhYHv2ZL8xohBYWUkNbSNAP/K3Uw4AGm7ssqEGSN+NhgttATUdH98YSBlZGTI4r9/FfPrPxxm5knO9xYmUR/stcNW2/ARG1aThWmbkkq4L5R3tQYhsfzCUkqwecmBjky1sRM+kwBmdVyZYFiJ6WgCC924UdaoJ1F3Q/GsXVJvyvOSkQpo7JYxlqIuWcQLSRrqfF89co3seTxahURur/eRzAsHYAUFspg8IjRFhk+3yjAEXy5q1XUcG7kC+89ArF+lotGhhtaAhhoO1ZMY9w7NMHm95/KrYM5sJAHtBm2CmesC9WkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p8+rdO3vb4Sh1G9bKrlaqCpUsBsW6U0HQ02E/o/f3zQ=;
 b=YIVVb1LUTi55Ls/KwvI9XREUApVskSFr2OCau38ceI8rhp1Su7ZsOogtrD46Jhl9afTmPvTYzT4z8+FgG0iL9k+IXjvIruPTTcEOeOXT5mKHks0ONtxzOIxLNCdyyL/qUH94UmSaKWAW+aJTdQZUaAfqeV88gXdvjAghGnEGiPL/+U9QnMGRAi9t8a2+dNIZ6rP1VVCJ0plkFmOSLFmyvTqxoZm7i2NJ8moZRMAiKO37jj0pl9QWca5hVubgVYSRZoQ3Hm1Z7gBnvhQTOIWSohAoOXZzUHvzejEcULXuyNBX+tCLBmhK+jxcAADIDFjl75r5QGb9BdvNMzloxb821A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p8+rdO3vb4Sh1G9bKrlaqCpUsBsW6U0HQ02E/o/f3zQ=;
 b=Y2XHDOTVxVrh90v5nRsPzJo+uleI2objEat86/PaH1mbgyIM4iCI4QDvIljAkF8+G4UMHHtdS4/gWjXYtBnUE+hWmhSGn4IO9GGm4XXwokGCrTE3bT7DT02spcPBghkeMU6lkRLwklxa//3jFFQ3kKWiNivKgOkoL2qerLeWYw/tAdgpm4eNI4cQhmRgcx5Vu8NmA0a2linMjiPxD3387yg5TyhxAV4oppB62wp51HGAVoDlWa1lbNBkjp6G+nT63KgGPNzAuiCgrRU3pGAD/SyDf9e9r6W0Q1LrrCX0i5C9Bo+blhmmhH0wyMxUupDXTb+gKxs/q78jX22kLlz5Mw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SA0PR12MB4366.namprd12.prod.outlook.com (2603:10b6:806:72::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 17:10:47 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.027; Fri, 30 Aug 2024
 17:10:46 +0000
Date: Fri, 30 Aug 2024 14:10:45 -0300
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
Subject: Re: [PATCH v2 5/8] iommu/arm-smmu-v3: Report
 IOMMU_CAP_ENFORCE_CACHE_COHERENCY for CANWBS
Message-ID: <20240830171045.GW3773488@nvidia.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <5-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <ZtHi9DkSjev7pLfr@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZtHi9DkSjev7pLfr@google.com>
X-ClientProxiedBy: MN2PR08CA0021.namprd08.prod.outlook.com
 (2603:10b6:208:239::26) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SA0PR12MB4366:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d182d03-5772-4257-57ff-08dcc916b082
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?y2WGippRNtv5Zu0VGLgAYyISF1RPv2ZmdsqtpADf5jkia4D2lZg6/3ppAnw7?=
 =?us-ascii?Q?w4xJCuCFeLRq79TT2t+oClS23WsZ2wtMOZevYC6Tin5DI2AXd0c86YULsg4F?=
 =?us-ascii?Q?wUlsHrJ7v9qq+PJOtIylbHR8YcEeHZAqqB3/LhUPUp30jTM9cxoI/SmQ6s5v?=
 =?us-ascii?Q?7ywaglSvA3PDuYSeyz4Pmmm9HkcGWEaqiK4MVoRhuWCG5/yJYQF5kbbCFDbw?=
 =?us-ascii?Q?95ErQk3u7PgoPR4SWIaGvMd6yYpnTqG5Ko1qKWhfOwGdoO+A/Ey67jvxPHGZ?=
 =?us-ascii?Q?WqWBE+bC87J41y1p9s+kDg2CaQZjTi8llxJEY8z5nTU5bcIaBiTgljx13jrR?=
 =?us-ascii?Q?b/62n8v9MKD3F3AMlMltppSluwBjkTJO5btlgcrg/BH+e79VG+Z0NQWrWpAS?=
 =?us-ascii?Q?PEUp8NPKaVeEClvT8+B1+NauLCV1uD9jktfTDzlwbVjmO6oafth47XyXw60S?=
 =?us-ascii?Q?ENkrmUx36rd7qeTOIUaeMmmt4cCqebbVoylfQz8rk0gmOx6jqS6W8z6E8mtz?=
 =?us-ascii?Q?m/taaZxn2gKHzcOWvlEDbLoXsqq+hou/iIgzk5f5MpR6gGsY+gmvZl7QxaCA?=
 =?us-ascii?Q?jt2Lp32a4cKpcWmG4Ri+De2hbc0AXCKwY35p9bASP8NKKc43VCfQkU+NgHMl?=
 =?us-ascii?Q?GyE1tMlm/SSUump87RaJxTokLUFMSsO5ST7jsgf673SHsullubbnjrQgRXd6?=
 =?us-ascii?Q?M/1oKc0FFbkBogtCl7+MNH6vaHOs3/14b4lkdsHX7zp+mmFufxyjcvHPoxJN?=
 =?us-ascii?Q?kNAhH8i1BVXxymMUhJGU4O/OPeta9BkxJ6G21UhCabMv0BaCfl7UXEIbUd1u?=
 =?us-ascii?Q?XM/QNKiXrokmJcntb9g3cMUkChXoqN1bMSCJKmcRQH4q2fXxngr9IAVVb1b8?=
 =?us-ascii?Q?JJj17Jjmv0+xUivthGtzMXSygF7egKOa/7v2FDhzwc/+vbJRemmH8KvD6rE6?=
 =?us-ascii?Q?PxVQXfhz9YBviLs5/Y7kjmfSXSwBS/2ecr6LP5z7Lf+/MjN+Dx+baQDijNQX?=
 =?us-ascii?Q?BOtiy9vXUiu/bWwU8XtU6qQn4Yb9kOV+OFLcZrsGoXVi9mU5Bp9GHnetVhLw?=
 =?us-ascii?Q?C8cNu+EHfTmvwcg14fTnxRvgjUw38DObPOIIyvjGqg5ZfVzz514uOR2NNY0r?=
 =?us-ascii?Q?aU3Pf+IsaIRzG34WeDCdhhLImI+EdhacsKaxTjHGiv1Q2j/Oq6cHxKM47Y46?=
 =?us-ascii?Q?o78oBM6g0rRNOgF577hvEdpu61mX6Ke+S30AXig7a6HxFAQLY9Gx3urmf9/4?=
 =?us-ascii?Q?wkmjCMOekEBkRjvDZ46ARX1TsjRNkkRpp+7vVVp/Tw5eGby7hm6xn71jJNW+?=
 =?us-ascii?Q?PlC8r3ULMdgXw3JKRf9hkYsik7ThDzebl9jvf6Hba1tdAg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DiOQiCkBP+ZYmtjj9uf/3TMPLEELsOu10eEBI30iSkDGwJEXGmpG3LWfHRQ/?=
 =?us-ascii?Q?UXUCov/yKXkJJDKndCpLWUeHN1sdxeAeG8lVLkGuwfQDDdVfZ1YObv1rgF4+?=
 =?us-ascii?Q?cR/EqDqwEKtoGgbPduqjx7I63rBr4u7wS5d3bJhBalWcTrpDjLJpBjww65ag?=
 =?us-ascii?Q?XsCqXXx1j7wKy63EbnOYHimAicYcyf5O6Cw8Cj1xqA04HSR44v1Ml/KB1f6d?=
 =?us-ascii?Q?MObEh2YOGLhP3/TSCWBcifyn4XXBixib4Ce5Mfp6ckoWE/8nfoq5WxSIRUL+?=
 =?us-ascii?Q?eVoEgt6blZcTQFvbNplxvBtWg8jOl9m0j2cPV5woP4xYOmiyWDoKbp/MoCUW?=
 =?us-ascii?Q?iW9Ds1Nv0XQE4RLT3VT667ibU3B4tAScLmn8LmvNjeSYCePSZhJsGyMVcmGS?=
 =?us-ascii?Q?hClvJs5aTgBxWw5YpZ7u+H0P+tkhSd+pud/jAGhcxXMJK0gOasmKncDjYlbQ?=
 =?us-ascii?Q?EqjT0BMq5JwfOHeaWBWdcYxc2ZdM+g+TWtzS4n5zIH9NESV1qGT1mHgD981D?=
 =?us-ascii?Q?QHbVwTlf/4E5Ua9YF8DZxevsXqnXEyVLpottH0zfTekJ9ZgyOZVr02K6sX30?=
 =?us-ascii?Q?PjdOZ/c+t3TnJq+Co3DYCqu+imrE1TGNGx5+JlgXQ7elXb8XJT4VkkED3A0w?=
 =?us-ascii?Q?rTXgG4ts+36XX6ETJStBuksupmHM2VnV0KoA/jkiHEiVp9ZzN5nLtQym3CXl?=
 =?us-ascii?Q?N8y+Tpvv5qAkV42X+Mr0yRuRVfYgfBp1TblCw7r+JKiWmeSA9Cg5NILkXhZ+?=
 =?us-ascii?Q?m9jwVp7MmEFcuGAlbghGr6UmzAMU8liXnO8ZM+VvG6QkHq/u7ZzbE72l9c5J?=
 =?us-ascii?Q?kJ/ysYCaeknsw8kd6OLNK3EOqtg3a+FfqOtfDozsgYtYy1x4SseOnuTZN+PB?=
 =?us-ascii?Q?/seAvBqzTi5yQdydJDqVMJZ+hN9QIi+zMBOhhUbRU1v9XZwml/kHfMdkWLXW?=
 =?us-ascii?Q?B0n5/NT6nHhpJKb3kbGYCNL+GQV/CQE38dxGVpT/RHqI+WpYc2fTIY9xHrOf?=
 =?us-ascii?Q?UQUGOjOEVc+ym0Pcg+fHRUjgbx6Oz5wJ1eOl5p/Anx7bg6wtzdEsjF9DJz7A?=
 =?us-ascii?Q?Bkh7cnLtBIYQ/ctEKAofAq8o4MY6JgjXLJLm12AMnZOBCQzBHQ5Iz180MwnN?=
 =?us-ascii?Q?LleZX0CP+PH4xYM2dltQXA61x+zjgQ/obVqlYi+mBCGqzZGe+nU89QdvuoRM?=
 =?us-ascii?Q?gaaYk7xrJHsB7W/kxtf4HD/0MkUso6DhcsppEG2qGLqlIsPJbwVmBKtW+yk6?=
 =?us-ascii?Q?i5ByBjZetEoPzZjWgAxUaWX04xxNuKk3UK9xnnBXE6bUJEY/7CabgAYnKiqK?=
 =?us-ascii?Q?u1LStN0twRRhU9tiw3E+k6hk9aobxDlS9drolBaxV5N1GKWWpHQoaeMqU+FX?=
 =?us-ascii?Q?AoKaBOLbrWFK0NhQvjWCNkHuCZQgaOzMHEXJm8lh7sOMnO4frQ1k32Xv1Wzq?=
 =?us-ascii?Q?D80UW+ML8qnJwLfAWqRLEX6MFCmms8LULcTTmzFdBecNOd9UNjPPakHLG6k4?=
 =?us-ascii?Q?+NCb2QpqDUtysfJnMrkCqydVgau7HOyhZUkEVp36QGSMX5zpMtrM2G8hqxpF?=
 =?us-ascii?Q?l17P1daQru+Hz5t2aSmXrOT5091xvtyFBC1uTuqF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d182d03-5772-4257-57ff-08dcc916b082
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 17:10:46.8928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jc0uzeonnqGi5yh1+T+q64k4AICgkZMoBOvT5oMBMDSk9h2hV0BRy8dBusuSTd5b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4366

On Fri, Aug 30, 2024 at 03:19:16PM +0000, Mostafa Saleh wrote:
> > @@ -2263,6 +2266,28 @@ static bool arm_smmu_capable(struct device *dev, enum iommu_cap cap)
> >  	}
> >  }
> >  
> > +static bool arm_smmu_enforce_cache_coherency(struct iommu_domain *domain)
> > +{
> > +	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
> > +	struct arm_smmu_master_domain *master_domain;
> > +	unsigned long flags;
> > +	bool ret = false;
> nit: we can avoid the goto, if we inverse the logic of ret (and set it
> to false if device doesn't support CANWBS)

Yeah, that is tidier:

static bool arm_smmu_enforce_cache_coherency(struct iommu_domain *domain)
{
	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
	struct arm_smmu_master_domain *master_domain;
	unsigned long flags;
	bool ret = true;

	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
	list_for_each_entry(master_domain, &smmu_domain->devices,
			    devices_elm) {
		if (!arm_smmu_master_canwbs(master_domain->master)) {
			ret = false;
			break;
		}
	}
	smmu_domain->enforce_cache_coherency = ret;
	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
	return ret;
}

Thanks,
Jason

