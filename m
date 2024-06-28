Return-Path: <kvm+bounces-20682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EAC2591C2A3
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 17:30:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1959F1C21A02
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 15:30:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 418AF1C688A;
	Fri, 28 Jun 2024 15:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LblRfXHv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC581E878;
	Fri, 28 Jun 2024 15:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719588596; cv=fail; b=iEXhzhURyEG5D/04l76ux1G2auFopq4UODrSvfXHazQsqnQCuWycsgCHTqZPNPlRwGvali2ZHl3+paAkzw+2JtcQ7b0uBJxJO71N+/j8of4NZDitQDJwgbZSKOjqjDc9X58tALiZpg0ZmjLRqBNSzOXnmB373vGvXIO7pOiaVDg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719588596; c=relaxed/simple;
	bh=vgtXmN8cEPlVZx8dLg79GdRylmRBcPH7c//g3sVWiYQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UeTrukiDRnrAmMiJ3cmUyknX5W8Meyxgayg4B9UBielx6Qsw3LuiR90SNJC36MQ0tr51fKpbTXDjpJ03+vn9WaGEsxD7KwPbW1ZK2aJQ6BbuDU4kaVdeYAnmYU4HzWDru+q/ANMciwmmAg0K4TDhtxa+sYRZBdBTbRBFMvRovLY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LblRfXHv; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719588594; x=1751124594;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=vgtXmN8cEPlVZx8dLg79GdRylmRBcPH7c//g3sVWiYQ=;
  b=LblRfXHvGmMt4eOx69Oz8hPY2PdUxq0cpIFQ2VWr0YbOhiM/4tvN7RLf
   ony6NTV1g3aEB5AbBi/pGUUy2CwS2Fddz7EFNmlAhwHKQg2GvCpBw1Nbf
   yWqGNa/Q89aEsmXIGVMMd0qZp6VkHQFwNSlXjEbGCvthPq0b4PD+o3tYw
   v2G+khwRd6Bw0IEdjs13NG2O+pRK9n5j5GTv3jQXhnl/J4lkwApEtMa4+
   16mOj4sQ9SeaJjaHd6AdmZDMorW4/KdFswC+gaGdzhtR+r6q1oXrZlUE2
   TT2uOLYfIw3JUmNYaE0TfHDSzwpJIKLbv9wp7gA8yao65NWLScK/vYOtK
   A==;
X-CSE-ConnectionGUID: rvyMPxc8R3O7u0sDIYW97Q==
X-CSE-MsgGUID: QGQFApwGTJC9wKFksykxjw==
X-IronPort-AV: E=McAfee;i="6700,10204,11117"; a="16597568"
X-IronPort-AV: E=Sophos;i="6.09,169,1716274800"; 
   d="scan'208";a="16597568"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 08:29:54 -0700
X-CSE-ConnectionGUID: akOrEKp6QHeSDGzkM3TG5Q==
X-CSE-MsgGUID: H2I24YJBQ6C1UedfahySqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,169,1716274800"; 
   d="scan'208";a="82327739"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Jun 2024 08:29:54 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 28 Jun 2024 08:29:53 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 28 Jun 2024 08:29:53 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 28 Jun 2024 08:29:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AzfJjWx2c03gKWO8k3D8FND6s9z1t4+O3OsABQHirKJPhrJTqMar92lyz1EcOkqBHKczPZjfi9GIShUSTFt+JZmmcNN9IKphO15p6LOFMJydUMR26HCs6TmU9KNKyxkLOA7gvafLn4S3YKT+arB6olNkVlNNMB9zrWfg4AT38/LJNw2jGbQyPS6PisNwEbuHbzok2abY2tkeIeTXhMtrb4al+7DUbQSqmLB9mAPPfDOu3tWj3Qh6T+2iyLRFxGrUsjjeAmj3WA+S/Sqhq9Rf4Pwtps/nxNyv0STMErSb7j5DguhTSlf6xCJSljhxkX7OY16RMTg3KDaDYfRh8SiqUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7apQsi9oWTdGdPSTezji8Jte1kF7XVnEMVasPIT8GDQ=;
 b=iV+1dAKBifBF6muqGHBKM/qKP0bZg+LmCwW9368/txio59hJK5us7vYqZi8idvgSyuT4stEDJfTshM8+IvKVWETKczgHr+1wcbF+bW6U93E0AuReMY+iH4K3bAkwHdw3AKMTPXF4eqXsAuDpsAtwEHJ+ZaHmTLKEUZnU+x7XQ3SV4gbecgGWSPn1u4ZPK2XxZdUL3sR7VjhWOhZQQweCQ5S2Z3XKJgckWmyCCaCqHaoG/Hwur6KN2Bx1srqxXQZ1D6l2Dhyjw82C6126AdHbrbAd3yKmvl3iymIed2MdraNBkt3IFDTzx0IvznE8JanAzhv8d0qdyiXHEBdl7ay5gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ2PR11MB8568.namprd11.prod.outlook.com (2603:10b6:a03:56c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.35; Fri, 28 Jun
 2024 15:29:46 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7698.033; Fri, 28 Jun 2024
 15:29:46 +0000
Date: Fri, 28 Jun 2024 23:28:33 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Yi Liu <yi.l.liu@intel.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, "Tian, Kevin" <kevin.tian@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "peterx@redhat.com" <peterx@redhat.com>,
	"ajones@ventanamicro.com" <ajones@ventanamicro.com>
Subject: Re: [PATCH] vfio: Reuse file f_inode as vfio device inode
Message-ID: <Zn7WofbKsjhlN41U@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240617095332.30543-1-yan.y.zhao@intel.com>
 <20240626133528.GE2494510@nvidia.com>
 <BN9PR11MB5276407FF3276B2D9C2D85798CD72@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Zn02BUdJ7kvOg6Vw@yzhao56-desk.sh.intel.com>
 <20240627124209.GK2494510@nvidia.com>
 <Zn5IVqVsM/ehfRbv@yzhao56-desk.sh.intel.com>
 <cba9e18a-3add-4fd1-89ad-bb5d0fc521e4@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cba9e18a-3add-4fd1-89ad-bb5d0fc521e4@intel.com>
X-ClientProxiedBy: SG2PR04CA0177.apcprd04.prod.outlook.com
 (2603:1096:4:14::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ2PR11MB8568:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fb77a6d-f1da-45d0-2fde-08dc97872431
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?IEfvvAfrPzKzLFj86XyXi0+6OQDd/g7pdQZ0GWra9ZKs6ai51LxUCGA6dzup?=
 =?us-ascii?Q?mA4rEDnPC9A6zS+7pvsVmnjG3KPLivcvp+P1VEhVrOdR6lzFQqJer+4DpG2L?=
 =?us-ascii?Q?rYjPFkOCfxm3upczgH+5nd2Tslm81o9IVaarqAbKKqjIhCodG6wTJieo9SCb?=
 =?us-ascii?Q?LcfpfOgP+ULo3iQFu3gr2MYm+Bew3B6hz+VASX+FtTEcjrH2Cfl+98Le5gpN?=
 =?us-ascii?Q?S3FL8XsKtIwaTcRYJbv8E6DhrJPm7wRYUD2Y9fd0VH6ptG+RO0WkICSYQjPN?=
 =?us-ascii?Q?SY2PtPAcKoSAm2nS4nQGqDp7qrssQS2Lri+tIk43xgVZbhYyhNuFtZAiWT2d?=
 =?us-ascii?Q?n4fmtOFPaVaRM/Lw9MxTh2ieBHuZtcyCVkKLcDax2xS9CiY1uoZHdEx4Kkdi?=
 =?us-ascii?Q?gS0UtVkkWoXjK4i91WsCN007eQgu7quFRbwF4HAYGsnf/xI4bKlGxrN76kxg?=
 =?us-ascii?Q?jbWVmqyYWwgcOPGSvK94ySK6Sy5ANDA+KBhceFhWwCyAKRmUaQ6rkh65DUuR?=
 =?us-ascii?Q?q3MqXPGzGxAq2JbRRfCC5L2kgOhaDrisb05PkzKV86JAbWpM7+2kvLKzgJ1Y?=
 =?us-ascii?Q?uz+TrWdmaV7HrRhWxBsu4yCs4hhoH+EtG6lA9lfrPOPScUHBZWoFq5SC8J99?=
 =?us-ascii?Q?ZzEGVaJbrNyk2Xd7/rUlaSDPwSFvs4hYrSxnaY/eMcebjwh1LSNfiekBRjdH?=
 =?us-ascii?Q?/98W+6IAIBeXmKkFMzvToj4knIgsU+Kqlt68qMlUb9L7KVoI8gMCtMDK7UUZ?=
 =?us-ascii?Q?0YbcWUdFkvqV3Qs7NfeJgwmp7nBcoETxqIMraqIPzKizv4Z2gZ0APg9M+I2P?=
 =?us-ascii?Q?TFtLlP/QGMJmXWeJxw1cWMvJowepXkioM+w7MXlhEcTXg7LvT6qWWIoE5rID?=
 =?us-ascii?Q?7d627p2iDsS4fHENnClHHSPk0+QnRpV6vs1y7J4bZq+lDaKGvsdpoHcajaNa?=
 =?us-ascii?Q?sHOG9R4a66L1f2kPfhd3QVWiPw78ZC7vUqrIs9J3hYRhNtFLtNBMaBeObf5m?=
 =?us-ascii?Q?zcTJ5FYcj0l6Zuaa4F9bUkBYVYZEvPlEmkVHkxsnZYSBxwrqislRl903fDEf?=
 =?us-ascii?Q?WrwH7lp4skqEFvxqqNXQh0Ten7snuCsZ7tk1GGAOZlcXV84hNPgOmsLWhwip?=
 =?us-ascii?Q?qwpTe/lIHy7dL3GEJv59AsIiQWxy97ovc6PxCmFSIBF9ACHytxBVH7Xp1yKL?=
 =?us-ascii?Q?tWN47Nn0lxunw5tyCA6NxgISaKlPUQ9FGn84mlCYWA7dsL8+kiK+MQ4eUT0C?=
 =?us-ascii?Q?VcoWT4eDm9encfU7b34U9OAHtr1RvrfNidIZgI/kLOY27PSn7EAEwet2VUep?=
 =?us-ascii?Q?YUXUuUfDlqsbvliPShGR29sjjyAK6eZ4Zowy5LLfH7MneQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eUK+YTYrYpVOE1el7ers7bUKvnmJ4lU0LlCI8JzRXM+s9R4uZbFDmoIS6Zbn?=
 =?us-ascii?Q?E9SvbXBAp88XQM9LSoOABNCIGI9VtTavfv6cF+f2NK5nuTi4GZyIjDZh90pY?=
 =?us-ascii?Q?gRjDKdgRNz/5Y+b0a6uycNC7hEr2854nrd3ZArQklso8KA7y2uXOcSeSJGFX?=
 =?us-ascii?Q?O7sF8i0Dqpa4HC5EbCaA8uypNrWZb5moP5cw6/8M8ihl2QnoLFNRJgO67Tww?=
 =?us-ascii?Q?sn1HTAcSDteqahmR/BVZ+2ADP4IgDtxGlAg/qL4afOMrDxGeoB9VnuoAdLEa?=
 =?us-ascii?Q?O3E5yc5OR4DLBDW9U+cGn5lsljBzNEDtvlNgWRqBsIeBtSZ35tafIOcNWW/Y?=
 =?us-ascii?Q?xY3A7rTi5TT6uuR/HtQM7OlvKCo7VAxrpkJUZ6+WZtI2+2sgOMxeeZfC2W3m?=
 =?us-ascii?Q?DH0Uawuh/DV2VyTmH4V9P90ry86C0KFaHodP5yIqslP3moBhoNDDDUAYGpMh?=
 =?us-ascii?Q?wxOA2eQnlAM54cBDuvjaBOmYQyVEOODG51jXe9YGgZCMadFHdcb1cLY9ZDrV?=
 =?us-ascii?Q?8tUwa03Wf6L9SKJVzeBILCgvPRBsGjmKRG2DTFuItQMDqafNh9SYVqmTJttr?=
 =?us-ascii?Q?O5RnplW4yQvZCNW/s2kfBReilBeYUKFsQifxic2r3NzDZGkKV+pyztr7T2uL?=
 =?us-ascii?Q?VyjSuhUgKExUDZoKHVq7Nl2YrWl5sZWiYCKKvO4zhatUuzGihBzIFNxB1VN9?=
 =?us-ascii?Q?reUepKTnstlU0bPp0sO8V8LZDVaTBY/4KFrLFEDUaE1QosZpevAY4RX9+PyM?=
 =?us-ascii?Q?uQV553b4IQzdL5x72DTQFmV5y716aHvH5WR6zvotJnAKGTrzUF8MRtZIpjr8?=
 =?us-ascii?Q?NK/X+bpd1DmITyXfzLeHcabAkrOba3W61Yu0quGH1bNB6G8/KvyuWXEx+/YK?=
 =?us-ascii?Q?oyrG8UGIK+Wp+3LV4NayAKTi8Zytm+OLDGlHKM+4Qe7hcPIHF+1ymdXVfK+z?=
 =?us-ascii?Q?9XGu0x/KD5BxCQbdFmj46lLNfWO+67rht8quQXM1NewuoOSSRpu2fz+6Aw9K?=
 =?us-ascii?Q?MmahBwVWp3QV/3NH13yIm7hmvrRdoFotyKpDWzvmG2mKeP6Z22MvQ4Sj9O1y?=
 =?us-ascii?Q?dqMyiMga+AcVdXWTxHQHMwGUIeFzaW5nyc1UFy2T3Efk7YQM+UWkkmr4MTYL?=
 =?us-ascii?Q?e61kRkbkmiDf7OxG7JLlBRDe6ejImF8xssII1YYoEKm8Qxvcf+eVbSZQcUUP?=
 =?us-ascii?Q?s5uha8OD8fXAQzMJJOOGL1VsSdlQsqn3z/pR8ZPuOhmOTj8HjcHEJU/Xm251?=
 =?us-ascii?Q?IsKjeOMjeULt4bTwRCUTgE03DMIV34s6uq0ilJ48JCwh4QvmWYe7EMJCXzNe?=
 =?us-ascii?Q?GImdAp8JXLIqSUYAoUhTovs3ZoeEUuepWLXlBRCtecKDd0PW/Qhuia0U3c2V?=
 =?us-ascii?Q?vV7w5cztuP2P4csumwCDCL5eJ78CcugN7ygdW05FiatMS/xtX2OuBLCU4BzN?=
 =?us-ascii?Q?/VcS3lKgksj6An/eI3zGKH85KsdAGNRjQiM5a+1Neahps67i+Am9ZV2fNN1N?=
 =?us-ascii?Q?Xye4lvKUMUTEbl/aziP73cQuh2D+X4U2+sGaiIAtJJdjpMRYhTQ38eW7/kZZ?=
 =?us-ascii?Q?NjdrOT8nk4SmZgReR6X1oCyZ3o+qPXTg7/xgP9eA?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fb77a6d-f1da-45d0-2fde-08dc97872431
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2024 15:29:46.4897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AHY78udFc+iHiixakptVRFBFiFxJeoRI93TWghDUI6VVK7LIGugZhAvDZQTjoQ5QWqZJz5GqKtSkESNRaufjXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8568
X-OriginatorOrg: intel.com

On Fri, Jun 28, 2024 at 05:48:11PM +0800, Yi Liu wrote:
> On 2024/6/28 13:21, Yan Zhao wrote:
> > On Thu, Jun 27, 2024 at 09:42:09AM -0300, Jason Gunthorpe wrote:
> > > On Thu, Jun 27, 2024 at 05:51:01PM +0800, Yan Zhao wrote:
> > > 
> > > > > > > This doesn't seem right.. There is only one device but multiple file
> > > > > > > can be opened on that device.
> > > > Maybe we can put this assignment to vfio_df_ioctl_bind_iommufd() after
> > > > vfio_df_open() makes sure device->open_count is 1.
> > > 
> > > Yeah, that seems better.
> > > 
> > > Logically it would be best if all places set the inode once the
> > > inode/FD has been made to be the one and only way to access it.
> > For group path, I'm afraid there's no such a place ensuring only one active fd
> > in kernel.
> > I tried modifying QEMU to allow two openings and two assignments of the same
> > device. It works and appears to guest that there were 2 devices, though this
> > ultimately leads to device malfunctions in guest.
> > 
> > > > BTW, in group path, what's the benefit of allowing multiple open of device?
> > > 
> > > I don't know, the thing that opened the first FD can just dup it, no
> > > idea why two different FDs would be useful. It is something we removed
> > > in the cdev flow
> > > 
> > Thanks. However, from the code, it reads like a drawback of the cdev flow :)
> > I don't understand why the group path is secure though.
> > 
> >          /*
> >           * Only the group path allows the device to be opened multiple
> >           * times.  The device cdev path doesn't have a secure way for it.
> >           */
> >          if (device->open_count != 0 && !df->group)
> >                  return -EINVAL;
> > 
> > 
> 
> The group path only allow single group open, so the device FDs retrieved
> via the group is just within the opener of the group. This secure is built
> on top of single open of group.
What if the group is opened for only once but VFIO_GROUP_GET_DEVICE_FD
ioctl is called for multiple times?

