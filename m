Return-Path: <kvm+bounces-17464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 536FE8C6D5A
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 22:43:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D6B281F22750
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 20:43:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64DF115B10E;
	Wed, 15 May 2024 20:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LtINA/nE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2056.outbound.protection.outlook.com [40.107.93.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE687158845;
	Wed, 15 May 2024 20:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715805790; cv=fail; b=Nx0hZE7+CEUY9mARY8ac19gMGADgZRoU4hGkX5brDze4IwvJ+VBVjEuiRgXx74zwrdgCMUOrDC4g5ULLvQorhPdvTM1dIAWWwnjryDW4lLe19erkobwSXTZzgcpjhqLId65FSMKsGAzENot70OQfzJBIv5siMMiHt0nEbQfycds=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715805790; c=relaxed/simple;
	bh=bbHogzMK0ENwm5xJqTVqnfRkItNUtaR93kHXPorLcCI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fo0qLvDX15X8HrcSQHelfU6nbV+ROGup3AW4v0mRbw3zQAjzPNig8BCbxM9T/+Plkunmk9gaLJ8klbMwbNL2/x0RKNHJ5jM1+v/A8pz/FLsVqEpQjMY/AE8PK+lzuvi+9b9YoAQTgWFURJO8hURa/cdARQ/mleR0KgdBMXTLOmI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LtINA/nE; arc=fail smtp.client-ip=40.107.93.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FdnziZd3agPiwh381CR/lF/zLzU1qD8+O72WVjPAeECEYRiYnnTmCp6EJHKt0GwBG1nPw/BG36iAO+ULAMqsJs/LJ7hVpISzM65iJLe18YAgHij0FakjNG3USBg2pDCcsfkmCTE0KynjvrDuXdHZVaxsYxdqAZh6x9EiMbvYa9Bl4inza4Awm/psQ2d6GjwHC5V5xJXfsKhkglxDt56sYYPRuEOIDwWmEoC9+LQ/k5WsT9l59ydpIJGALTVM3bq3s8llUO6Qw6c5mzyhd5nMzivruZcVUk3Se9SEFEs/vEUVFrGWDRZAuDDwbeVf9W/lbuEufYT01ajrJYWQsE0SrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bbHogzMK0ENwm5xJqTVqnfRkItNUtaR93kHXPorLcCI=;
 b=bh+2xe5M2sR+eaiW6Z82u9bPuVvFxGe4z1JcIm7zAOddqsAXydZBqaLPbgQkwOLhOuINiAxKwzVRCSMNfyMdDVlZ/R7sPB8942feSjOGPCzV0p26Na+0m09H3pXu3tJYrrQJQKpVgodSUIlBFzSy0HwwhPnQuJPOfrtn0l5nfFImQtn1yxVRTTnJKVcyzWw0X5Q3B+P3GWrmuhNHic4C93sfRsEnK9WiajjeeAyEAvq5V+SeE2QDmFyxfVvWE2lgtakmjyfvc5JaxGNSHvnNff67+zeqij0NJ8AgbGBw5RT02rnoYTlmzAASzy/tovl/UFls2b+bCWx+GhZj4Wvl4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bbHogzMK0ENwm5xJqTVqnfRkItNUtaR93kHXPorLcCI=;
 b=LtINA/nEXDBHh8h7LGC1ZDIi4nmZ030mHmNHtnHoeUHZUH6yDwoDQaE0PIpT2765QMh/lEDdQEaEtkjag31gsp1mjxTAjmoaMB+tqP7Sc69YGiT9cC5iWsKZJzkKJVVuqi/e8Ns1G22l+HbDJhxBZECQiCG732qSfm5WH5RJkT51hEoJFheV0N5v/5UPVPMfm3gLG8RXCaKHh7obh9QWH6R7wAUboI6R3lv4KCW3jMQzF0ewIYH1LxktuQMHtgOvraqxnrSOijoMH462RgZ7qk3Lm5OkADz0rMOGAUTQtIgeDDmTjSfFJZCeKn0pbK9HEW/Xiu3X7FjVJLUwxDdV0Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CY8PR12MB7513.namprd12.prod.outlook.com (2603:10b6:930:91::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Wed, 15 May
 2024 20:43:05 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7544.052; Wed, 15 May 2024
 20:43:05 +0000
Date: Wed, 15 May 2024 17:43:04 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
	alex.williamson@redhat.com, kevin.tian@intel.com,
	iommu@lists.linux.dev, pbonzini@redhat.com, seanjc@google.com,
	dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	corbet@lwn.net, joro@8bytes.org, will@kernel.org,
	robin.murphy@arm.com, baolu.lu@linux.intel.com, yi.l.liu@intel.com
Subject: Re: [PATCH 5/5] iommufd: Flush CPU caches on DMA pages in
 non-coherent domains
Message-ID: <ZkUeWAjHuvIhLcFH@nvidia.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507062212.20535-1-yan.y.zhao@intel.com>
 <20240509141332.GP4650@nvidia.com>
 <Zj3UuHQe4XgdDmDs@yzhao56-desk.sh.intel.com>
 <20240510132928.GS4650@nvidia.com>
 <ZkHEsfaGAXuOFMkq@yzhao56-desk.sh.intel.com>
 <ZkN/F3dGKfGSdf/6@nvidia.com>
 <ZkRe/HeAIgscsYZw@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZkRe/HeAIgscsYZw@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: CY5PR22CA0019.namprd22.prod.outlook.com
 (2603:10b6:930:16::26) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CY8PR12MB7513:EE_
X-MS-Office365-Filtering-Correlation-Id: d5936ccb-5813-4b83-31ad-08dc751f9f1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?e+rY/34FLKPWr1w9edoj/LQOmX57CxyFZrn30BWwr1QdZdYyDBeJZJ8Y604/?=
 =?us-ascii?Q?aQ+qyKYoiuSVGaY9CngBDLbwFCh/tVuEXbt9S8D9J9Fo/H85c4DN/AmGkEzv?=
 =?us-ascii?Q?kpdJYjXVxoX1CTWdODQ9k9/86TQjlJxBE4BkXHv3JBPnzCOG4vaO5Uzfb8cL?=
 =?us-ascii?Q?lkFXlk7fshFnxzjlfa1aKBUWIG/f3k+cHZwWjJvrQgpYIIpGrRukRiaSuPlA?=
 =?us-ascii?Q?KuxHWvlrzYhwp6mpsGoQNxQDXQd/eZ9uzgTtfkRfzd6o64gjrGWqBCRtq6C9?=
 =?us-ascii?Q?QUehtlzUSn6HfRK8Fy7T6A9awIrf5oNRDbtkzj5trfqDUMCV8tPmg0at50zF?=
 =?us-ascii?Q?gg+gk5Sg5Pv1d9/lkXOJPWYoyugPjb+pasbPudevxXnT12f6xMY8Y/F1vFO9?=
 =?us-ascii?Q?qTdSg9Vs6lVgH6D8wfKi3uKT9c6LNrUifPE02mQUc4mTe7ncayZgq+jSYLLy?=
 =?us-ascii?Q?irOvYLhFyNB7dRtKxxR7jY+VNzVHzIjLdFQ6/s8C75CjUG1OW3Gh5e0svS1s?=
 =?us-ascii?Q?4LYZR3mPI8/65uxvlgF9QybR/E/PHKDn56nAa/w/BmRt9yG/7ywsojbRpN3I?=
 =?us-ascii?Q?+o0SEyjMejUwusshuwRLXpdC6xeVjmBKXwVImBDbYb59LIgNl4tHcZw5HUGX?=
 =?us-ascii?Q?OFIUzIrhnr92cjdYDVqtr49WxYRV98tFnvJDViAAUDrcUGVPPBZr4hYvhrAC?=
 =?us-ascii?Q?9ZdSJ6qgLvisfMG2HvDIjc/fJT+SXIuu/Y+7VxfNLYSefJtl0pTLPQsIX/y4?=
 =?us-ascii?Q?+80yU60TVlYKtPf/Ng0WVb+xC4Oiok2g1xNcRfG2iA/eR5eFAEt+xzKUQPXd?=
 =?us-ascii?Q?FqVFqxDZnaP4KJAEHvDF1xL5NZ0TtAKFt045lbMAGxKJ/zh0DZNQT6+YunLz?=
 =?us-ascii?Q?ndQ/KkYzLDqZcaXZT4NVeCVSb3N4QUjgtxL41iaLC0FA4hnoBOfJjuk9o3Nh?=
 =?us-ascii?Q?5fe+qk+8j8RTRULXyb1vJAf2tXFLETj2oqTwGliRKPVaYFKZtSrUYEUuQmTf?=
 =?us-ascii?Q?KGKZGcxex4tgAFJbAkQQDe/N5HxzwgLPFDIgeoCo0oYTbinmm609lZF7IN8w?=
 =?us-ascii?Q?wSeXo2bKUTEL6FqrEsvhH14TaC2rysULfrkXSRRPI12FNZm9ivmDaUkJzdLs?=
 =?us-ascii?Q?slg8pEsSv7PdVv3ontWjDr4CK5jVxi+AeHKqi56BNDCpsHrmFllFM0/HIKxi?=
 =?us-ascii?Q?xQCblyH0DOZ7ivKKEFPxFQzx6vSRxE5KhXWe1P+jCSaBwsSgCZs96LojbtbD?=
 =?us-ascii?Q?O290RrY/iTJmF+eY6A7hjwQ4DOvrbf+t8goeHYBwtw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VIM7ZmdWIS7LLT2LLau3MV7i3HBXhk+gRAibJvXvHrunTx4H9V/nBpHhdJdh?=
 =?us-ascii?Q?1WVWYKk6euaCB0P17rTb2qMGZjRV8cYDOldMIdT5aDsI9Am2t+wIV3uK2pR7?=
 =?us-ascii?Q?lgfVFN++JmLVBjvkhNtRNrhdHvWxQ09OHXNoqt5ePlBOEaX+zUdmF0Fa4olX?=
 =?us-ascii?Q?heoPEdTXh+ggZwRn2KWA4zjNXfyU+AndHm3Pm0aABf2iXLoYQqy3SlBy3Y4c?=
 =?us-ascii?Q?5YPE4MPNgwNC8vzmI0Ei5ZoQMhusHr39xm4oyJsUQB0LtQ0u3gvRXFiFdIOb?=
 =?us-ascii?Q?2mburGhXZj7P/ls6xY8hZeWp3Q8WbZY2Wiha23NB01s9m1a+nTJX7RCBoHV7?=
 =?us-ascii?Q?QVg2CISHc1c1549BYauWCcCoDNlq3kkAICVsZgne6UPxba9u2uYRo+CEXYOw?=
 =?us-ascii?Q?xB0UD14NOojGVgqnqlrYlVVYCtBbK00xSrC5/SQbricXRoqWOt0E8JS6UZHV?=
 =?us-ascii?Q?snyAvnQYxh+FtuoZJIiSsdWTrg+Z36LszgCOTnYCrLeP8fyMG8vJjKFfYiw3?=
 =?us-ascii?Q?OoxozXg1QcJHrlRS5h7CZi/ufrbkntE0s8mx8kEdO4CPz9ONf/pF2lir8njW?=
 =?us-ascii?Q?Dld2fN7hYE9lmooqUUL07Uptdg0e6z94Vi3x52TKE6Yhq9mq3rPBOGvbtx8E?=
 =?us-ascii?Q?ZXKtB3gU1Af2ludKbMs4k9We6ZqkfkUItLAPKbFDnreph6Ly5Ct+qVNQNo5H?=
 =?us-ascii?Q?2PWZZKjFKcN/NTJETYTs36wnennU9gZVxvo/4rCb2JhmMHGsKESeRl0C0Ala?=
 =?us-ascii?Q?whLgAAzCQWTRAZUBFhQBqTYbBItF/BT/LAE4gjvjQ7ZaKQoLw+t3Fe82WLO9?=
 =?us-ascii?Q?onhtOyr/fbD43gOu+wr1Ey1Tc/UXkxje69fB2iCMdQaMbWQBL0/p6BsJc5e9?=
 =?us-ascii?Q?wkDQI4WKnzkuxszbzdh+9jUgFOWLL0pfY7ThIkc5otMTgOcIeTLHpjwHvLL4?=
 =?us-ascii?Q?mK+ojBgD/syX+lixsFJegZHw3XSzKN7EU0jRZiC7QQoUQEA/HbcLJv20XQYn?=
 =?us-ascii?Q?BYJilmVucs2+csjlan3W90zY7/laujBmGc12G+au4g7Q74zq0Yeqnklhaxu5?=
 =?us-ascii?Q?arM1gwYtCFPKnXOU7IlSLDb6dE7BekPygYxUw244qcUxJjdFywB2CH393mYW?=
 =?us-ascii?Q?Gd9NKDd3ZDELLGvA8xw9QCSHyO4TMBshUjgYHJlwJCXJ/uNO9DBCG6mXMcGv?=
 =?us-ascii?Q?IQdq8ALzgTxgviF3omg3c2Vjn32vpfO28QJO3b565IqFstlbE7+xD1Nxx2KF?=
 =?us-ascii?Q?feL4AhsEHKeHy40fhi6Tn4i+9u3ndhvGUs/AluCQcsc0PCkomPjTfRlvU9/3?=
 =?us-ascii?Q?Rno62nPxs/XaX/+eimvLpT994w2sfkNBxGxINb/Q2TmQRMALyXkGN+W2Ogr8?=
 =?us-ascii?Q?yZ4n5cAeJ0Lxi0jozyjMnXz4F81wn3cai0VTs7twMOaa5CRj85yBpVedlE9x?=
 =?us-ascii?Q?H2GnL5iS1H3iDRAsFqJ+bx3LFTO8WQ4AWHOE286Xa1cw0jl7s4x/TyP56gnE?=
 =?us-ascii?Q?21lQZ68JkpjsvYXEP4C/Z5Mn6tkI4qpOiR9AxklpWvH/O0rTfm9mr5Iy/GQ5?=
 =?us-ascii?Q?AeUJoayLnlVq1jqCFAQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5936ccb-5813-4b83-31ad-08dc751f9f1f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2024 20:43:05.4919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tV2/bfQPV233TqDApcpdmUdJdayD9Y3BSDA34rlt9GCAynUjZGHXSlafj/AC/uQ0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7513

On Wed, May 15, 2024 at 03:06:36PM +0800, Yan Zhao wrote:

> > So it has to be calculated on closer to a page by page basis (really a
> > span by span basis) if flushing of that span is needed based on where
> > the pages came from. Only pages that came from a hwpt that is
> > non-coherent can skip the flushing.
> Is area by area basis also good?
> Isn't an area either not mapped to any domain or mapped into all domains?

Yes, this is what the span iterator turns into in the background, it
goes area by area to cover things.

> But, yes, considering the limited number of non-coherent domains, it appears
> more robust and clean to always flush for non-coherent domain in
> iopt_area_fill_domain().
> It eliminates the need to decide whether to retain the area flag during a split.

And flush for pin user pages, so you basically always flush because
you can't tell where the pages came from.

Jason

