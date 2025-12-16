Return-Path: <kvm+bounces-66083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E95EDCC4A37
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 18:23:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id ADA1530365B6
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 17:19:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8711A2D8384;
	Tue, 16 Dec 2025 17:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YF7U4fgd"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012035.outbound.protection.outlook.com [52.101.48.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D3029D288;
	Tue, 16 Dec 2025 17:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765905593; cv=fail; b=WtIvjoXOAkCvIy/ZPHLHkqE/Roqfjnsvj4DeI7Yh3xfDSDRg5eA7TUF/wrn4ny0+PomZMPVZTUWqItl7FasU+DVyCzrxTVxyu3bhL4l0BLryhidirEw1mhi9CVYiKttiwg3Bqk4Is+Z2nbsjcGOy5hGh5Px5bp4mdCdXFh/X75c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765905593; c=relaxed/simple;
	bh=2B01NLAcmyuPUByymH/5dcvVeX5fkLw7d6DZJ/xOy/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TyTEymwGX4bbI5zvRIZyHsYI+CvzUdHkSDQAac2lQ7qlKr53uWmKsUFy6GCeUTfMGn0Eb5bgUghPGuAaL94NaoKLlxezSlfc4tw5d3jynb8VPHHGdkLvQQxn6NR1RyYGO78YJq26t4qE+/c24i75Aqj9y4RnpplokefQtvU1FRU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YF7U4fgd; arc=fail smtp.client-ip=52.101.48.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E8ixqt5vCUOFbCmX5ZNb2E97ZR0uBlbcjd24a6/lpL7/uXzUfSRI/J3bTx8qxiQGpF23mo94Vj8PS0PiCxwEDZGAEbIqyl4/KUONSSScgcS9ezCUnXVR8wKB3v+fRHL9KY5Y4VKPFDrJuWf5Edm+dhTaFy1n7OYNzFSjGK/Rv05IlApet8ECvJopmEESlK9O6l2o5o+VTOAn8aaj8fGN4Z45JU2exXRX5HgPMEtE7TnXqxKUHcsYXhlRZs6Lls7kzzwfds9CSSiGNlW05TsihsByjjvuQ+qDMOy3x423qJ0twsQXJVlpX4xEzLlfHeoB1rH5OYomCLvmrfSVdJVluQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SEENmMoqfzX2s3shDmJjxDv6QpfaIwKKdKvlqNMOv1w=;
 b=VWog7j+rHLCgFCZYyp8VduHy2M1yCQU0Zr44gSKdcDAblsqkoyrfAIC3gXkMuXjlhvWoC6R4lSxf6aubCllwYGR674UojbrVtk9UT0B1yFyuAwH/CLldArPAzKazVx9iS8zUwIds8PUAxFepz+HI6xqRe+0zPReEr2gc5nkcBMJBr4N+S7I2E+3mixEitutgIjbM5B40RXXoqrD12uiWBV4p+fcB/Ytsy2aSxzNPVAnwrVnedpJNXXJ48B1bd3TEoWHHQzTGqHwsPWsQOdyATkHD03n5NPDeiVu0EvJntUXm9hkTbQ3215IDClqo4N68OyNiVpLeNHiOUM9GUrgkzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SEENmMoqfzX2s3shDmJjxDv6QpfaIwKKdKvlqNMOv1w=;
 b=YF7U4fgdJmqpIutoMs0B0EHfa3KzHTgZhD6ZgeT3GUTmpBvgfaBhWjY3K9OYqI54cQmiJ8w/2Ycqvthd9IuGu+cm1xM+F3QzSRdV3GkfNRLQxahF1h9rimWu87UvNGD05m99FLS0p2GbysRe6xfmm5+mZ8UMM7o8CDXlkI4Hz/nk3uNC9xr3qYQYyrrq4tVzZxV9hoReT2Hv+L8tXvnoZmCLW6rOv8UWdnT4BT69DOzAKDmSHgfZ2/j2VZwx9xUiPn7PFjTAtr7vfvLwAe2rgeAit0i66In0N8K5xELXoiEaIaLL102fkzWY/njIg5ksbp1OzoPXUaPttnC19jlZbg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
 by CH1PPF6B6BCC42C.namprd12.prod.outlook.com (2603:10b6:61f:fc00::612) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Tue, 16 Dec
 2025 17:19:46 +0000
Received: from CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3]) by CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3%6]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 17:19:46 +0000
Date: Tue, 16 Dec 2025 13:19:44 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 2/4] mm: Add file_operations.get_mapping_order()
Message-ID: <20251216171944.GG6079@nvidia.com>
References: <20251204151003.171039-1-peterx@redhat.com>
 <20251204151003.171039-3-peterx@redhat.com>
 <aTWpjOhLOMOB2e74@nvidia.com>
 <aTnWphMGVwWl12FX@x1.local>
 <20251216144427.GF6079@nvidia.com>
 <aUF97-BQ8X45IDqE@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUF97-BQ8X45IDqE@x1.local>
X-ClientProxiedBy: SJ0PR13CA0044.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::19) To CY1PR12MB9601.namprd12.prod.outlook.com
 (2603:10b6:930:107::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9601:EE_|CH1PPF6B6BCC42C:EE_
X-MS-Office365-Filtering-Correlation-Id: 09c1a2bb-3baa-4d36-53a3-08de3cc74f31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lv2ANLyfbM9S79lEApsLt9x3mb673jol72aE2m/kafloEIEbaHgObKlZB9vR?=
 =?us-ascii?Q?ymVP7yKYBUwcVklLJ13kJDIJs9pUWeG4wMgYlPoX6bWrAFQ0XWn6NxHtcdhH?=
 =?us-ascii?Q?/FdFemxKDDx1Y/quXIrHnj81IoYwUFt4diU9LnhxZV80pMcQIQzaWWew0J1y?=
 =?us-ascii?Q?udi4iRKpWMFmO7G43H7se+aKuZGOzFOAHdayZvqx1Xx46pqnLrsDklEOoNm6?=
 =?us-ascii?Q?bhYqzy8U0j12hxdPuVjkawT7+EUeIT3fXwmtaCaFL7FeyA1TbDdE7Cso4oB5?=
 =?us-ascii?Q?um/U9juWrWRzCjMll0PTZo7tgF4SEM2nxrT+1TqI9PuoLbYJD60Y8TXxVc6n?=
 =?us-ascii?Q?9XPm0KDhqR1pB0JOwhJ4TZEoVn7K+Y30mnKLJ9APjBTfTk11qiUu7UyVkHVJ?=
 =?us-ascii?Q?tCfKpqt+Zn7e9LYsg5yQiadEG6zdVYyagTZCWz/P1W3zl/rfDAhwI33ZNTfd?=
 =?us-ascii?Q?tpAzBLAihw1dVJRshqinsZIYubfNlowxxh3/VMH0p0WtMaL8MnCpxCHFM2FK?=
 =?us-ascii?Q?E64Bee5qB6M4JCjzGrUGsNjNo1vrKiNfddM4sehXTEFEKtpdK0I1tM5JNWtO?=
 =?us-ascii?Q?25kWNVTEl/jbXiPonGyuGWTCkOoerd/EvZKoHhUjToO3L0IWfDBLZGr6yt2+?=
 =?us-ascii?Q?Pq6S8Db9Ftilaj8jtakJVYMJLjElOjsKGgHmJ+CxPq0VCsqhDAcPn/DPbVh4?=
 =?us-ascii?Q?ffM61DB28GON0EdT2L2GgmC155c0ygczfDM9eyEde4X0bwppRgZtEzkki5pN?=
 =?us-ascii?Q?bm4jrlKV0HcBS71eNpnY1IMFx7oMsA9XO2u1jFxHT0/HBPPSUZfz1kNkQWUM?=
 =?us-ascii?Q?TV1S26afZWzzbdLg+QnOy4QMbvXPEhgfPLT3ppyuHXNKNG9vWZbjNMWx8HOE?=
 =?us-ascii?Q?qlArk4uEPyMaULjnB4pbI5uEU86Pof0oozTqbmTLOuqftIbKeWF95TD9woLs?=
 =?us-ascii?Q?Au6FTeUn51Ra5qMqjvL/pIaPeMMRb4pxDgQL2ApN3WSinCdDUXN0DiA5rfVd?=
 =?us-ascii?Q?9wVvk6L47HDV/fxnBq4910Rqz2I3ohymJhQ16hNCadL+tL7SNZWD7gMfJBJU?=
 =?us-ascii?Q?M0ntlkOpT6l8F6MbgfBNNXpZ4dJM1Qip3eCIALj4eZUePcuKDV0InT7YkteG?=
 =?us-ascii?Q?pS00C7XK6HIqxzD5KBl7NQRvW9hfTgrHW5F9MlncniH9Kjq1H4RM+yyj2qWu?=
 =?us-ascii?Q?xe76pbRBFDUuctw/AojYf5ixyrIOz2n3TfLLr+5cAz9IR/YPxXislL+h+VAF?=
 =?us-ascii?Q?xCyRqHnn4x3c4TKV3jCkorWLJQZMcUidREoxAtgcJS4Xspq7Yp78sDey+qB5?=
 =?us-ascii?Q?Zve2iTToTIVqTbzgJUyfFfq2HtTJWtlcuJ59CtnBWt4crqgCXRjsCfV8Utm8?=
 =?us-ascii?Q?CwQyaSGJieABZ0vxi5SlCuFDdtYBoKKrtoCrCScDol5pBu7z3eK1payZDM/U?=
 =?us-ascii?Q?Y9R6MXsWAhpF+nEC68dHT2KrzOTbby53?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jpEyvrkVxS45+QxkBzp1764KedY30sDy7HZr7Jdu+UkV1Kq1QB4ycTEnHuc6?=
 =?us-ascii?Q?BF+osS6b13tR9USXxsA4k38KtEc75pZ0SOgsbFOtHBil2W18K6RmvnvgF7A7?=
 =?us-ascii?Q?Ql64yZHyzKNn0DKwgnxIOPJvXckSVHtIv35joC4/7S1ssl66yG4LcIAuVepd?=
 =?us-ascii?Q?0qu+/Km72dDIL7buWHEkrkAs95QYdeYGQlPpar2J9oj09SLKHEM4Qx2PuJt+?=
 =?us-ascii?Q?WXxRLBZ79Tlwlj2CpRWXJTANvkvRMORbZ5V4Stg4pZoh7M1RswPSz+RTcmvT?=
 =?us-ascii?Q?hczSPN3A0D+lOGAr3MHwEDin7S1zsb1sKsKAdx5KbgFhPHztRs/QUpyHNH4Z?=
 =?us-ascii?Q?ykgBpw06j98+T7ZiC9qnWK6rQLbwOCxG/yRus49WUxSHpDFP6dRMtR1GWbpu?=
 =?us-ascii?Q?JC6pqyeJujJKAcoGYArNDMEMArVyfMJ1hCOZrWq8dWGiPDIHb3q8x1gbkvPV?=
 =?us-ascii?Q?QBlLCMJJ3TACIUQJjXUoe83rf90hHJTvZazQrru8PNVlvIqB4Ndu7po7By6b?=
 =?us-ascii?Q?8KMX7s/VEk+4mvvgaUVOJoxTOb3czi/lTYfKKJe3LcWxo3jDO5N4T0vBW+Hp?=
 =?us-ascii?Q?tWxUNqsM6ja5vl+m4cLJUgJZvLwGZLb614Z5tbIa1qf4e+8RXUzyCoSNA6s4?=
 =?us-ascii?Q?u5Jn2Mqn3ODFB1mc9MmLKCCh58ykvGHkU4KFjHwFwZ3F1tfcQSyjKHcN8E1W?=
 =?us-ascii?Q?Z2YtfLj7hvkCFiE6UVtfViFjwOMvDT21SKtYCK6PRBagTpzdhnrYACOTpjwJ?=
 =?us-ascii?Q?cXwKlucBPZT5JQZU2rmQ6YL+3fTq8nM2p4y2KBJWFVrbAY6f3KVtzsJ2r0B/?=
 =?us-ascii?Q?dSmq3RRxGF03Iw9HCKCV+WGg2an0B91YRxRkCOqJ/KqBdinEdvaBlFneThj/?=
 =?us-ascii?Q?tRVaqPLQWjyxmt/V+SSR/FvMLGK9ET7FEs2Wb6saPekP/RL7t+1ow51hd+Fe?=
 =?us-ascii?Q?7e91vOEGmI5KfZAdUP/EA4t77KVtjtownSaqaXKKHHLpv8R3+1oXuJS9ikCD?=
 =?us-ascii?Q?YwiZIkXbTHmhti59BpbpYGA3YjUZHOyZtb99fPMs77YvKTSB5WqFtjJmBc5M?=
 =?us-ascii?Q?rdByAKk+Gjc6aoKCHojgdABAAdR5SU1CoVLnH18EwRyMcRKTs6k0msZ93bT/?=
 =?us-ascii?Q?tN9BzFD8ceWoYIuo31mieqOr5Y2rKJxwprzyPqeBpGhkuDultjsCGpnQx1q+?=
 =?us-ascii?Q?r7E2x5HPJEYiybWZgk3YmdMtgJAr83wCv3FvAAnUDgDu1DWJ9/a/bik0B5RT?=
 =?us-ascii?Q?vkFrCWhXDkxnIH2IDiYgtlDqXzq7uFTyA4PxcFk5vMiCTdO2LCvP8Umm+ExD?=
 =?us-ascii?Q?vNy6Jxj9LzFly/ecoA+B1YRLU3TrMZEuRwcC44aVWBLw7MfJmgx6BJASEHw0?=
 =?us-ascii?Q?NLC05lRVCYMo58CenWh/RwAtd+7HHZDW6W57R4mfHe50UFbSNmPjaDTC9nLd?=
 =?us-ascii?Q?osuWghFLQs1kkC3rTloODGHCw8XeLxtEFLfhFiiE/5b2Pzh7UEp9Jz8J8J0S?=
 =?us-ascii?Q?FaXa42lQOJSQXjUQLUIfwhbb7PimkjYFbkfhzogF6xkG3LG4smG0L2KWwpOj?=
 =?us-ascii?Q?n06t15/ONs3rpY68VIpiFHoOSuC+/kzEmlZrvTUp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09c1a2bb-3baa-4d36-53a3-08de3cc74f31
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 17:19:45.9653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dgoxk47nghoYTTcuSTwRmWTms3k1GfzEZihrWZhJlRfhM6cKIDvvkAuBD5vGqtAB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF6B6BCC42C

On Tue, Dec 16, 2025 at 10:42:39AM -0500, Peter Xu wrote:
> Also see __thp_get_unmapped_area() processed such pgoff, it allocates VA
> with len_pad (not len), and pad the retval at last.
> 
> Please let me know if it didn't work like it, then it might be a bug.

It should all be documented then in the kdoc for the new ops, in this
kind of language that the resulting VA flows from pgoff

Jason

