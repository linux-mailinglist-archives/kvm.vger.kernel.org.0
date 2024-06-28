Return-Path: <kvm+bounces-20630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D27B91B614
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 07:23:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C1C1FB214F7
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 05:22:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45BC33BB21;
	Fri, 28 Jun 2024 05:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bkijMOMO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9880228DBC;
	Fri, 28 Jun 2024 05:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719552169; cv=fail; b=Q2wK60B4zcxq/4kjPudm1lQW5cL12aIbBHtyzZkDmGu/fPXd1SQNRKl90oK6pMet7pAdvb7eEIL8t6iZjDaVp3UgJxCanPNzkJ7W2sGJk6Iz1JoAqFgkZ3z9tMkhG0BM36o+Vz6NRgQEhCTNcU3xF08k5SceuOKX94fGm3oQ8JI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719552169; c=relaxed/simple;
	bh=GAzxzGReNQvow2jxI+z3OuaXYsC14uDNHW0vJZBoB3I=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qzo4liv1UChdyMtiQqY+9GekFVvrjeRhV+XsGnTzYC794UPGBVivzi9LY+n7a7zyPS5cVJPP88IG28YvSXGIGEYxZtY9vx/fI7t3hJCr49hYw+jjZvNZh8fvEXAaJB16z1+aEUoLBsA/W85LT0oWW8L8EQXQXSmUfWlYgx1rkIM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bkijMOMO; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719552168; x=1751088168;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=GAzxzGReNQvow2jxI+z3OuaXYsC14uDNHW0vJZBoB3I=;
  b=bkijMOMO8rNcDjjE+iCpMrJ4knKgnhAmDMbJ0tqUmh7gC3V3qInoZlpk
   fK/FC+tLqGMUi+J64gPIkUC0+pdkcPnLPf6QXg6Oqnmas2NLfp28YQHzF
   EHN2ZJulvi2glQTufeIowU+sBGSmJ92iIZxvG47GWc75vIRYoGPuEMaKU
   bpGul4xsUoqYsIC2Th2DVJ0QEYpnyzS0+XPQYgNcdzTHM3bK4ugjms2H2
   oY0zZPg6NkRm3nwEDnHz1IKols1qY+M9ysNFNeP76z9Z7VM8W72M8PvMD
   Eq8AqLJV5IHkJw54njU6nZbXOSgquE4DREddmk3LBXBTdWjKWnerJmY72
   w==;
X-CSE-ConnectionGUID: TpPkYuQdToqhCx4Lm+1Ong==
X-CSE-MsgGUID: tw0uGN3ER+SqlevvNAFy1w==
X-IronPort-AV: E=McAfee;i="6700,10204,11116"; a="27406667"
X-IronPort-AV: E=Sophos;i="6.09,168,1716274800"; 
   d="scan'208";a="27406667"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2024 22:22:47 -0700
X-CSE-ConnectionGUID: jkmgYU5aStmxr/XVVYnxpw==
X-CSE-MsgGUID: k9EHsJEbR4OLR4fst95h1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,168,1716274800"; 
   d="scan'208";a="75371690"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Jun 2024 22:22:46 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 27 Jun 2024 22:22:46 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 27 Jun 2024 22:22:46 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 27 Jun 2024 22:22:46 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 27 Jun 2024 22:22:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PXxqSK/7mQjDEfrVzBwuOmtMMuOiwlr2uOlEHSQmIcT9vJoJfbucMMqYMwtDo/ItEHXBaNa9fFIDAJxDXYk/VKZwodh5WvcHPHVl2KLXfIGBXMTB4Ka6FQbq+7NVZ3BpFkAQzG1AGbmEA5KBsXpe3bPapdBaRAlWqvS2w237sw7gjlJe6bJkeBYV9KIK/Zj8IGhJfgbYE8S2cQ84eR8/vWagfVFe4exX0CfvO+kl8QMKIFiqrAcPmFVKYdqyprZtTIE5kw6ynoCOnDtXJUkpwvnA97FqGmD6dkC3Zb6NUgPE7m5X36vogA4QCbmeDzjOHtAOB4zX1eaIdzG77d8owA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wr9dEe1lZSV2IJYuuY00uY5RAWUYYVky8+yBq7mzUTM=;
 b=Azm7Jma3jigNBR6XIUPA2mGXUZ2WoblFl8kmSzd25+9v7rVc7aQp2yWTgM4nm8sXbq5PY9C2m8ORT6FqK6YLIZbmVbmumJQt5Gw6gLd8EnOZFLvB0zyMT0MzvHfQ3oiFqRALv4iIo2eebiX0eICG8nVMSTedfE/2HJFM/lYMxqfW5JbwEAW4/QlH86tQftHXRwnu9iAdBC8QBWF5pR1luc7il22onaR7Wwm2LmG0PXUSFunlCOinDuDz9+Oaa7puFwOYoCVeOK3z2+sgU9hMfs2GhdHtPVVgwoxGjKebUT/4bCVtjyw/MIt7J5S3pNH3/uBnHgTUi4cIf1W6LaLqcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB8133.namprd11.prod.outlook.com (2603:10b6:8:15b::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7698.32; Fri, 28 Jun 2024 05:22:39 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7698.033; Fri, 28 Jun 2024
 05:22:39 +0000
Date: Fri, 28 Jun 2024 13:21:26 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: "Tian, Kevin" <kevin.tian@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "peterx@redhat.com" <peterx@redhat.com>,
	"ajones@ventanamicro.com" <ajones@ventanamicro.com>
Subject: Re: [PATCH] vfio: Reuse file f_inode as vfio device inode
Message-ID: <Zn5IVqVsM/ehfRbv@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240617095332.30543-1-yan.y.zhao@intel.com>
 <20240626133528.GE2494510@nvidia.com>
 <BN9PR11MB5276407FF3276B2D9C2D85798CD72@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Zn02BUdJ7kvOg6Vw@yzhao56-desk.sh.intel.com>
 <20240627124209.GK2494510@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240627124209.GK2494510@nvidia.com>
X-ClientProxiedBy: SI2PR01CA0022.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::14) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB8133:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e915b71-afb9-45e4-5cc0-08dc973253cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?iCMcP2nlql6MDljcDCWoF5Ee7L0wmII7yOJYCLtbXBKnkz+1y0c7nsh3vIfJ?=
 =?us-ascii?Q?RhUPeyMbEGo12p5CDvvyr/yGlT8G1dVMnrWLthgccIRCmCN6U+5vaH84+Ykh?=
 =?us-ascii?Q?Hn/793pjKWxLvCEFVjxOShmGzWBkrKi3THrUYgjeedYACeV8lU6Q3tsMi5OQ?=
 =?us-ascii?Q?TRHxG4jN1brVlADqWbiPC6SWSL0TP4nI0dP2xbzqlYLw5NbkFbm5MLs0f+dr?=
 =?us-ascii?Q?K/mGd06x8+PvWy7SOwFZATv69QvtvikWyelOZqXZdX3Xysr46TzFTf4rvQao?=
 =?us-ascii?Q?564sIhbpBduqOkgV3rlYEKxxBjhryaUprDAZ+3vZzyHvt4UAfMTYIlaKBn4c?=
 =?us-ascii?Q?fjH259G8GPFWfQd2eSq5MQzUG7qnoWiQxwdBvbDkhiOoTOyWgetOe7r9kUpy?=
 =?us-ascii?Q?OnBYIjlhTcTUHA9Y6L6/d8r/dUTeMKfh60QdP9NLdr9WB0haiUB8+x8aiJUo?=
 =?us-ascii?Q?WlBypaCnPyQH8pw/aEtd6dAuJzbLqLoJu2IwE8Xq085xLecOovuA7NFM4HzA?=
 =?us-ascii?Q?hm4XBZdzzVH5GLeCQVO3uePBwdB87cgZPT57FCrbVRvnhYGHSYpmVxaxXv1J?=
 =?us-ascii?Q?yjYkQs2beXrJXhx4FxYozhNDSqBTU/RvZw8RIR6ro0DthM2Ajm1yWI6/W4l0?=
 =?us-ascii?Q?BaLEtDajqqwzDpEr5rBVyWbj7/4nlX9fkjozhOZCF9zYiM9IeMvhSkw2q9QG?=
 =?us-ascii?Q?eAx+sTDvsmyXPdH4liUhKhkm579I2+6YldcSbdn6mqFojGD5yj+zKNWdHr0Y?=
 =?us-ascii?Q?bKkMvBVki0+1dncbAdXXU1HCcg9nQwwEP0GHOdEpB6octdrzIMwIfSjGx6TO?=
 =?us-ascii?Q?Um+1p4N0IoXfs8MOdapvpakIK8XTjsf87Kq0rrlN7iPyVLob+wofaxRtXqzA?=
 =?us-ascii?Q?RotqFNlsebGHfEAcwex/Ijtdgprh3EpHCYVn8/iHaO9ygjcudlIK0/OwiWG4?=
 =?us-ascii?Q?xuI6oyknbofJxrhfJCLeW755BDnaHkqQF8Qk+Agf8T5DnXuXetJdsKgzL3gm?=
 =?us-ascii?Q?c4ac6QYbKPUAlmsAD0LEQp+stQHXrCzaGzlzPBi2Tmd2pUQShhxpdkUdc4Cc?=
 =?us-ascii?Q?F8+nnMRmJ3cX9+xLaQ23tlR+Inz69RbVC0ewcOe6feRLIA+7cyLj1xu7oee5?=
 =?us-ascii?Q?xa9ijpLTvB7by9B3RhwtbezxHeW5mmGHiPq4E4l8Q9j3ZIOtZcDg6LpCCSQg?=
 =?us-ascii?Q?ocPUrhLLBZojvxhRGp2NslCuBJK6DbmBXVBjvM9l6k8sDGn8DOr4zGuwlUDr?=
 =?us-ascii?Q?ZPZPYrFRPhVgaI1WLzBDKrqym56wOhkwMbqYaOEBGiUNbsXE7ZpLcwIUPzD8?=
 =?us-ascii?Q?sxIxI5OkwelIVgBuQeHJn8LV14Rr0/F+Nj6IbJTmuJq7DQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rhxh1NX4dv8zlU1N+F3oXSnICK772VcAcA6hQH3n7r0i2bLJcM9hqivnbHMU?=
 =?us-ascii?Q?we7NSVv6LlskVDaMch3kkJaAUK0Isgbdt+qbwGLlkHr9DEpTN5FSI9dt4udD?=
 =?us-ascii?Q?Np/T0zXybJzhJ050Wvz+1edoPrghCJcz3LvxQ+csV8TbK5cYgIZ1TiAftqWY?=
 =?us-ascii?Q?Pvl80QGz8N13fmfdaH2qR6r6GPRQhG5XJUPowZxIpaLt1kjzkybHhJnzROeo?=
 =?us-ascii?Q?N2NiLX2ewhR2F6z9jBPExniV1K+jjoEPG41ljrE4x3jWhSqu7kwS7dD6FAgH?=
 =?us-ascii?Q?3A+8OcTPgOuMvB16oLdnSEU1mFT3+xDlTMIcD3oDr/fiMEyUcifN3iU5Ezj7?=
 =?us-ascii?Q?D8OoKnXJjaEG1LJBFScUeibYMCrDHSVjgGYSwu+Wjlx+MjAVP5ROQqKIIoo7?=
 =?us-ascii?Q?zOABDxruh4IKz/fqcqXcyS7SAfIMeHf8fhh0y/YWSZ6O38Rgp3o8CBWIQe2Y?=
 =?us-ascii?Q?8uydoD4rIHPrL/2SDCMjgVQdrdrbgZadcbQ30+7a7Uk9HS7qbhQ0rHoiCm2t?=
 =?us-ascii?Q?m5TYnn8AGuklBUXN2+WlLrmto97B+AbxzH13lB/iUnXD4zAz5AOwCd697316?=
 =?us-ascii?Q?4RHgAX63wDhMuOH0dtwF/rj2zN9cGb+Q/hj1w+6epOFWYJB0W2YhfQpUR8k4?=
 =?us-ascii?Q?MCeSWfBVrdSwNbJ1IPCAJ5PD170VsRbyydL1h5s2Z/jGXov0Sb8QEeWV9YfG?=
 =?us-ascii?Q?b/6PmbnE8ME7V6mXw1iWZBCRWII3TkIb2y0bLtoskkrd2MAvquKQL7LWUliw?=
 =?us-ascii?Q?KzhNLfnAlKVWs+MNdeNaeBQlkhkD67J9pQdYUzXuHABD2K5IiybKBUGv8hwp?=
 =?us-ascii?Q?YVbadvfR59C73j9I1Cq7fQwVwaNcJJl+ztxoKDigYR4wpgSktjMQk4+5qvMy?=
 =?us-ascii?Q?eK2gW1GKyHCFnR5uAqQGySHy7jVo8fVAK9J7GfPY3JdgF3IUqVa/a54ZGLy+?=
 =?us-ascii?Q?3rJ56XUrIcecVC3anlul7TxTmr9C5mQf2lTJlJ1jzGGqyGtJXVG3wFLmiJ/5?=
 =?us-ascii?Q?qP5J6TPA7iblCP9iP6H1qOY6Hod37l9oNlADKFBYywjMA0ASzaeTrihEkOEV?=
 =?us-ascii?Q?3dIYOgkWux3k8UTJTwF7OVlO+dwY0d0QeoEpLihC6+yktSzPRBTrLM7xJvUg?=
 =?us-ascii?Q?C9QMBcVf6rlTXdem9wj72WsoyN8Y6qR1HU+Hs8sMptkSWkPzb+BXtfEoE7aY?=
 =?us-ascii?Q?Mtdp/dLQunNLls3yqRrk29ifTeGgxnqke5hwOHs4fdBKNteLdxnDZKHTcdRu?=
 =?us-ascii?Q?F73FuHCe/C8cSkPd3bn2ONHOLMfD8KWVu6aUkjhbrF2wAnhxnt/l6K+evFA5?=
 =?us-ascii?Q?PQH2H9ppNcRc+1RAXpqq6nKxCzqW5apTORAM8ahRUbPkBvA/oFmCkhZolVIm?=
 =?us-ascii?Q?LiEhFWO/IYn2UHWIifSWJ7tBMEtllgZ4NzQMNp37jFyTKE9QapFaZY/pLDVX?=
 =?us-ascii?Q?74E/6Fqr7FbNqE9XbR8G0h4gCNjg+vizqvBNkOIv/QEIYRVI653TW3YWSkG4?=
 =?us-ascii?Q?7uYlMheM2WRS00HZQuj6SOV3B91RaRH5Qmo3TmGwsuyOjWtMECCnyj3nsZ4U?=
 =?us-ascii?Q?HWlxeRSispAebAX64/qsMtd/2PibSqfPyxP9Ce5G?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e915b71-afb9-45e4-5cc0-08dc973253cf
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2024 05:22:39.1237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l3XAsECCRXn/VbZ6/YB7BMJmGbu3Myn9u1v5JcIHoSfRJ8tODd+hFARYOdXQAe4VzxVwWaFyfL0JTmfbd8jQ9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8133
X-OriginatorOrg: intel.com

On Thu, Jun 27, 2024 at 09:42:09AM -0300, Jason Gunthorpe wrote:
> On Thu, Jun 27, 2024 at 05:51:01PM +0800, Yan Zhao wrote:
> 
> > > > > This doesn't seem right.. There is only one device but multiple file
> > > > > can be opened on that device.
> > Maybe we can put this assignment to vfio_df_ioctl_bind_iommufd() after
> > vfio_df_open() makes sure device->open_count is 1.
> 
> Yeah, that seems better.
> 
> Logically it would be best if all places set the inode once the
> inode/FD has been made to be the one and only way to access it.
For group path, I'm afraid there's no such a place ensuring only one active fd
in kernel.
I tried modifying QEMU to allow two openings and two assignments of the same
device. It works and appears to guest that there were 2 devices, though this
ultimately leads to device malfunctions in guest.

> > BTW, in group path, what's the benefit of allowing multiple open of device?
> 
> I don't know, the thing that opened the first FD can just dup it, no
> idea why two different FDs would be useful. It is something we removed
> in the cdev flow
>
Thanks. However, from the code, it reads like a drawback of the cdev flow :)
I don't understand why the group path is secure though.

        /*
         * Only the group path allows the device to be opened multiple
         * times.  The device cdev path doesn't have a secure way for it.
         */
        if (device->open_count != 0 && !df->group)
                return -EINVAL;


