Return-Path: <kvm+bounces-18987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EEC948FDCF8
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 04:49:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89DB5285A71
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 02:49:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 022081DA32;
	Thu,  6 Jun 2024 02:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FURBmeP6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7863ADDC1;
	Thu,  6 Jun 2024 02:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717642159; cv=fail; b=mzT9MnVAiqogwwCXxW04he70jerFcHZCMgzLTpTAYXpRaLS9ffl+2GdtgPo++VzrAOhdPkFcyRteEpfhgzHHNkxwzcrWIgQCpdGMLDRHHuQvG15JJnKpoLldC3SJA7Ani/HHv8s6+hdt9FnGeBqncUsEJV4/plP/Y1Ycge0DQm0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717642159; c=relaxed/simple;
	bh=Qi2QnY8uqpODO2njaVozCrp9L7+ibLvQEy+2/F4BMNQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cfuYYeBf2MevPG31N+cbuLoisy9arMs1K0tGGjFKDOT3sjoWZLHgNi6H6tH7T/rblIVaWQBg0p5dWcqKeVytzjTbx6jpnX2N/jr7xeQ/k94jC9V46HBLZDmYjZGfBTVO5EKi87dUN4wYKcyZmc63uNCqIAohNegCRU04j/89yjE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FURBmeP6; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717642157; x=1749178157;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=Qi2QnY8uqpODO2njaVozCrp9L7+ibLvQEy+2/F4BMNQ=;
  b=FURBmeP6Okg1F3aw2K/s1PrKY+c4OO2+XugEHsP4ggwygb/3nV0aAUdt
   AK7oyuMw8jK4TYaa/v2zt/KusBfwniwAV0bBRotJTmnoO6Kt3qHijZ4e2
   IqbTHkfPt/g4Ez/DRpK/K+xKES7qpnTv9Tvz/rsQSrDZp0vzv4PvyCELP
   zg2p0ZUjfk4NzqOn/QAgEPZ7eGWpC+rNyEm9uDnxlTtdmCY1ai3HA3fVD
   Nsea1hV6Dk1LUViU26Ou2my8dJ5Sv7xFa12i/yxWjgu88wVZVpm4PrpvF
   lfVuHYellJac2tluQuIMtTohVRitMnZFHtHcuUEO8vD5iBraqHChNCMS5
   g==;
X-CSE-ConnectionGUID: 3ap2qfYQQReywWn80Jn/Ww==
X-CSE-MsgGUID: WFafQIVER4ifnxMAwq7exA==
X-IronPort-AV: E=McAfee;i="6600,9927,11094"; a="24945422"
X-IronPort-AV: E=Sophos;i="6.08,218,1712646000"; 
   d="scan'208";a="24945422"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2024 19:49:16 -0700
X-CSE-ConnectionGUID: BTbI+0rzQ3K/HRAZMsyGYQ==
X-CSE-MsgGUID: Z2MEwGdjT1yUUmf77KINtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,218,1712646000"; 
   d="scan'208";a="37687400"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Jun 2024 19:49:17 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 5 Jun 2024 19:49:16 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 5 Jun 2024 19:49:15 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 5 Jun 2024 19:49:15 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.49) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 5 Jun 2024 19:49:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JM5+HXCiIJrcvl/Ka1+WTLAMl4jY/exwmjRwfFUOR6YgjskJknO72XVCZTJkTwcgAKilFDhikiY0aQmtaudP2dCoRXwbDxFVPP175MxZA/Peg/ldUH0aIDvLiMVy3YDi1iWge6dOUxeiG19A5lfv0PbFH1oMR1aQC2NvAEVpkNiPWj1BWijVQxVFB5OhZreMdESCs2EzjyKcixfAEZmnp0C8MgS0tByH0BI6fJigYw0w27f2+748lPyf3Hiouhc9EyrsdJ39fptLT5hU+EB+qbluKG4u6ki3HuqWZduTtImHBnfiQjQQG+MlHa+qk4YORqHByzYXgLhDUo04C6VrpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D7NnYmnQWTD2nVf8q4Gs2zxlQa8i6yEBpPycVnV4yco=;
 b=R5Lc5BftZNe/aUZAjHr9hiEcOLHSatUPwOPAcykp/jr9SMcbBpLWiUDL7pj1iWfr+HPsIVBHDU011vPxDdyHBDqZctIn8HrP+gtaoDNY/KJjomMXY+hDeIq4ci4K3kUnb+Re4Bu1XHOuMzpOtT62nb2afVVUISF0S+kxnKopzOw4PBC9Q8LLv4Y3mzwfiKgkAN7DffuR1uj33fLzpAeGXV+vWMoomETB8JIar7Koo+GnU+be20F9PSl314Pl8U6miTzJE8401KhDOVn4OATqru+kLX0eEWoRXzaOC7xy4Is7kVZ3EbPXUdd6Gaf8WxuLaK8wOnTQZRPcWjcSrvHLzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MN2PR11MB4598.namprd11.prod.outlook.com (2603:10b6:208:26f::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.33; Thu, 6 Jun 2024 02:49:14 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7633.021; Thu, 6 Jun 2024
 02:49:14 +0000
Date: Thu, 6 Jun 2024 10:48:10 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Christoph Hellwig <hch@infradead.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<alex.williamson@redhat.com>, <kevin.tian@intel.com>,
	<iommu@lists.linux.dev>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
	<corbet@lwn.net>, <joro@8bytes.org>, <will@kernel.org>,
	<robin.murphy@arm.com>, <baolu.lu@linux.intel.com>, <yi.l.liu@intel.com>,
	Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH 3/5] x86/mm: Introduce and export interface
 arch_clean_nonsnoop_dma()
Message-ID: <ZmEjavnYePBLDbrS@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507062044.20399-1-yan.y.zhao@intel.com>
 <ZktZDmcNnsHhp4Tm@infradead.org>
 <20240521154939.GH20229@nvidia.com>
 <20240521160016.GA2513156@nvidia.com>
 <ZlV7rlmWdU7dJZKo@infradead.org>
 <Zlt6huNJeW8ekJlE@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Zlt6huNJeW8ekJlE@nvidia.com>
X-ClientProxiedBy: SG2PR02CA0047.apcprd02.prod.outlook.com
 (2603:1096:3:18::35) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MN2PR11MB4598:EE_
X-MS-Office365-Filtering-Correlation-Id: 24f367d5-d876-4e75-9c4f-08dc85d34004
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007|7416005;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?lW7VzTVOVZsaNWlBxYbD3CuEcstZepyJ74tPA+KgM94LDYxJcD661Hv3gQ3S?=
 =?us-ascii?Q?v9ShY6CVXXg4MtYZv/G/LeSyQFuEerHwY13UqWDmXvF2+/KuiMilCKwakO+s?=
 =?us-ascii?Q?xyl5ZTznFeRxaPJ5sYPfp/BcFuQzLrvsIWH2x8qdzLPgFHdepZxzR2R7eoKa?=
 =?us-ascii?Q?hSqR7PTn8U2re868zwo6WGwDcfU93U5L9M5v9sTq1Ht9szSFKhXIOfpTLJ1A?=
 =?us-ascii?Q?8Fn8q9TJnd7Pl6lZjfkstTooe6l3ZxKBXCAf1uHDBXfr4aAhfM7PLwhZP8IK?=
 =?us-ascii?Q?B6Hg7/3IKE0vNMRYMORL/4rWjRwOxS1LAhSebEKdO3GQRlZu7WAZPCJgGGh5?=
 =?us-ascii?Q?44UV7oepZESLwl4y9IcFUkAU0kelLqEk5EKqzABOxzvIntqA8s+97S/gYQ+5?=
 =?us-ascii?Q?KPL9R9XVK28vsPzHnkFmAOCGcMMklI+17OMTCkxV6a/Y1Vl4FLC0lJzsjKpy?=
 =?us-ascii?Q?ZJwjEZFVuaDsQKWBIE1Dtptoa+5k4DOGQ7QtnxPDwVX6KyAckTXo0behDsk/?=
 =?us-ascii?Q?J0zEE5wAtNwLUyEb4XH32xQqLh2kcc1YZqXErWB3FLCzGVmvpiqRbk2Mazh5?=
 =?us-ascii?Q?Gen+PCpD/gPTQe0qG4TFMuK1QaUIIJBudhWsIqbaBm1L4KpYmx6SN+hWRUQw?=
 =?us-ascii?Q?WPRoNaANywGVTmF9GhaTKAt9fxb+63n4UKdhHq4lGr3Vy2RpDGOBbZ8YHhEg?=
 =?us-ascii?Q?EIZVHEkXJcwjR8QRgHQ5JLblz7u4Vb32nz4ivH18jcdATBcv/xc6fwrldk2t?=
 =?us-ascii?Q?fLHDEFz2FrPyw/gMSo+B4K/MwLiHvrVuYdnPyfiigT1uMVC3niZoVNZFqW9y?=
 =?us-ascii?Q?xbAEdACsvr8IszfOS0BRY6D8eHdJ6yVTbP/JEX/GkWzHV+aIREIAbcsLvA5S?=
 =?us-ascii?Q?ced76sb5ZjZ37lf7nUaXjlHLPNheWKvGlpemlR1TLEVes0HOw8WMr/zmgb75?=
 =?us-ascii?Q?9t5hY22hGM93TTia1ZfdIAZh1XLEy31Ahsi8JEyHvJCAnhnpB/uKeRGr1AK6?=
 =?us-ascii?Q?yMcK0HdBPak1LPhTkqU+gX8qsOREtNV3SGzPDoeLWu46srJhVKn2fsOkKOE1?=
 =?us-ascii?Q?63bGSsWYScuItfrHKIH7z0XNmg3WFBn0mq5M0SfEHmwHQjHCb4BLw2b55WqZ?=
 =?us-ascii?Q?4Xr9MGd9cuT0F7VwaVdGAMiiJLRI2fYEu9Q3EsNUMmuzoht04/Wtx9WQYanf?=
 =?us-ascii?Q?1KIRe3gwXFQlCT1s19jkBQQTGM23zbkK8eOgb2MO3Q+ZSClFBnRMk1BtCaby?=
 =?us-ascii?Q?zbs1rIAHWfmpr2r4iww3iLofBYjaiQbLs0KuYtW+Qg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ON5og7HHBy8IN3KXQKPHFzf0JCIO5DPjH55sjeA8WLjqV0s72TVDDO+7sJfl?=
 =?us-ascii?Q?bwfpiE+3C92uz6dMJ9iwFSbLSRowyADEFfVX3dgrrGX5Dsxi+PDhBwq73GAQ?=
 =?us-ascii?Q?7r3WykIzIoXOX/YNqKm8cahQ1yiAPVPaG8jh0u0gMCXfu2xRYaYN/IV7h1cr?=
 =?us-ascii?Q?1J157YGokMTizeANa/GDaw6CuXRWjF6W3S96pEMJ+vqoEg3ORsLkLC899783?=
 =?us-ascii?Q?5FdxQBSCV3LsxnfPd3hHlw7m/KDZswLKb/BjDC82rPfVwTQNtR7ekhU4Sjmj?=
 =?us-ascii?Q?MuPar/MnLeCMKDNZ2TefQ879pE3HqGoDtO4w/xueUDGpQyiOfCe/go97XdI+?=
 =?us-ascii?Q?hELZ0+HGJVr5YWuFT1oXYb+vUSmcamlK5C9F/A7g8y/c+wpDhdrNguKw+qnl?=
 =?us-ascii?Q?q3ouZKIkTKOTeigRJWuZvJNw1GMcmAiLDmHjqpqOWlXOjLmBcPEXhsYbxVjy?=
 =?us-ascii?Q?8an0fpJAtMrUB5x6I6HdyZqBjUflNqYaJI0EqmXsXfm7CB2ad8FU2IR9ABGM?=
 =?us-ascii?Q?qdBecv3T/NBLIoy/yRUGpY3XZVGgEjuzypYeUi0xyUKyZny1JBslkwKLAJeP?=
 =?us-ascii?Q?J90Q9IUxp1yjZXmiSlwR1Kf4TYlKkyJEfaWfDIrLG5LqJ7R6BxGbBd7MMZaG?=
 =?us-ascii?Q?6x3TJ6zLM+fHbz6j/khepctGTDYXpzOF+/EIN6WD7ds6GTt9CR9EQDO8cu07?=
 =?us-ascii?Q?n4MpZL8RpH4VP4Dydz+nQHSh+cHy1AClTB2X+70cGkTxqcoD/ccAGMlxr9hH?=
 =?us-ascii?Q?VpAZRTKuB49F+lSxM4h/YqWHiwxv3j5X8BTNedYEs1YJDgVEmT64VJNe0xGn?=
 =?us-ascii?Q?JTqwDzLbMpDnHTNmdl1EshgXUjlJGGeNpWx75P9pkaC5fjErGTw/boHmmxWP?=
 =?us-ascii?Q?EHmuEP7eFYbwgLkURhpe7gC35/znTGiV5LVF1m848pmknxWa4k0lt5TtBjev?=
 =?us-ascii?Q?l6XhkITGkeTFCNCi0TF8bGRjXAZYBOnjhRjoLmQSX/qvIkazmdg2gGrzerEd?=
 =?us-ascii?Q?bDnyJ0UFQ6NCcNK58TkV/daVTYKHscR18e6f3iwWXBUEmHH3f153syw3KSDl?=
 =?us-ascii?Q?EkgESmbpZTm+Iql7LOSuan0ZIe4YaTLJZcsqw+8sKzqOvdwNCU/GIkj9sTnN?=
 =?us-ascii?Q?Ap7VEcy7xhpkEb5tXXLuuFRbjSDJ7EC0TgkxJf6FgCDxqBIZB2SoVw2jc0S4?=
 =?us-ascii?Q?qKFg+Jg/jJoNsJ0d/JMrCvAHTAPYyDjCoJzFnvN6pcgeAmsR6sIAN2zTd8yH?=
 =?us-ascii?Q?oO1ZcMlvt1xARjAcGzXzat6ih3sX9HAFKomnucaWxFuUIC6JW2j9tZ6tcEFP?=
 =?us-ascii?Q?Dskm1gypRTb21fj3Ur7kok7qG6L0bzxEZwrHdCfZzUG1D2Y8Cahf0XW2M8FP?=
 =?us-ascii?Q?VxCkAhN1HeHxkNQxgDbBqAvypNAFSMkxqT6Kz6PtLPYo0NaZiLsgcBl3EBQx?=
 =?us-ascii?Q?4u66KC1g+9LlAibxdgqZVj6WTEv7bE8a2qkGlolDOj15wKbuRZWRwbnNWlnA?=
 =?us-ascii?Q?96yJmtUWvyXZyYa1Ves2BcnLuuP1qyYRJQu/NMxH9Ip1R0YU3UQezFsICVUD?=
 =?us-ascii?Q?RL5CloTerL/c+w5YV9uPdAfwpxUmBPPGJR09Jhs3?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 24f367d5-d876-4e75-9c4f-08dc85d34004
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2024 02:49:14.0045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KyaPunXM0qNRzdEubVSH+HXi1JpB5xVl0XIYH57gwWPFe2xeN4cO5vXzTc5B6XwZ2yOkU+y793NqePT4x0UIaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4598
X-OriginatorOrg: intel.com

On Sat, Jun 01, 2024 at 04:46:14PM -0300, Jason Gunthorpe wrote:
> On Mon, May 27, 2024 at 11:37:34PM -0700, Christoph Hellwig wrote:
> > On Tue, May 21, 2024 at 01:00:16PM -0300, Jason Gunthorpe wrote:
> > > > > Err, no.  There should really be no exported cache manipulation macros,
> > > > > as drivers are almost guaranteed to get this wrong.  I've added
> > > > > Russell to the Cc list who has been extremtly vocal about this at least
> > > > > for arm.
> > > > 
> > > > We could possibly move this under some IOMMU core API (ie flush and
> > > > map, unmap and flush), the iommu APIs are non-modular so this could
> > > > avoid the exported symbol.
> > > 
> > > Though this would be pretty difficult for unmap as we don't have the
> > > pfns in the core code to flush. I don't think we have alot of good
> > > options but to make iommufd & VFIO handle this directly as they have
> > > the list of pages to flush on the unmap side. Use a namespace?
> > 
> > Just have a unmap version that also takes a list of PFNs that you'd
> > need for non-coherent mappings?
> 
> VFIO has never supported that so nothing like that exists yet.. This
> is sort of the first steps to some very basic support for a
> non-coherent cache flush in a limited case of a VM that can do its own
> cache flushing through kvm.
> 
> The pfn list is needed for unpin_user_pages() and it has an ugly
> design where vfio/iommufd read back the pfns seperately from unmap,
> and they both do it differently without a common range list
> datastructure here.
> 
> So, we'd need to build some new unmap function that returns a pfn list
> that it internally fetches via the read ops. Then it can do the read,
> unmap, flush iotlb, flush cache in core code.
Would the core code flush CPU caches by providing page physical address?
If yes, do you think it's still necessary to export arch_flush_cache_phys()
(as what's implemented in this patch)?

> 
> I've been working towards this very slowly as I want to push this
> stuff down into the io page table walk and remove the significant
> inefficiency, so it is not throw away work, but it is certainly some
> notable amount of work to do.
Will VFIO also be switched to this new unmap interface? Do we need to care
about backporting?

And is it possible for VFIO alone to implement in the current proposed way
in this series as the first step for easier backport?

