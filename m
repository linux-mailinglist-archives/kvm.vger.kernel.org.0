Return-Path: <kvm+bounces-49781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6E53ADDFF3
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 02:22:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B1DC3AA9C7
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 00:22:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DAFACA5A;
	Wed, 18 Jun 2025 00:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Awm0U5Lc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425A79443;
	Wed, 18 Jun 2025 00:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750206156; cv=fail; b=sRXh2almLWbavwnDI4u/pdhnBoABJ9cTzIoqWBftV8lli+gaCmzS1durgNKopgnSsKtDzvTIwmEWgB6e+Uf0lZ9TiYsSjqZjtShnm+9P/Qw+lA9xMicw5GAfSFqjbzGH0kQodf0Cm8PmutJfhegHqJ/qY5ATjAp/gMkfv4rMBjI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750206156; c=relaxed/simple;
	bh=lEHNBIwXLoW/9uOeHFtrJDIQmMdMdSVR5gjGxFKxk3k=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=awPzPb6DSMCDXjOyDjwl+oM+Q++O0NClaLHiE5TUiJT9M5knsQ1m6iXnKf76Qh8H87YsTZjHqXXfj1a1/SDVsSos3Dd8zAx21PNjhi1EiI+IuC0JJXOgX5JEjy9EdaUYh//9Rj0XI403BuZi2Gir28oaZWsVtRY33tKtMmmeo8w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Awm0U5Lc; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750206155; x=1781742155;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=lEHNBIwXLoW/9uOeHFtrJDIQmMdMdSVR5gjGxFKxk3k=;
  b=Awm0U5LcQ2NaJkD+tPwGoOAbWGYJfTTgMpAB9aU097InN5COMD/qOTj4
   b6GHpnX2KhEgrUQLL9Rs4hI4DxxzNe4HieuJTtFFZH2xjRGXcRb29HskE
   15VPKU/iWLDJNREWCAyxUE7Sg0kodxEySa94Tvo3shAs2xwyX4SX2o+yD
   etOTm5N9t+Ax9TzPE+B38mQ/XzJPPfDqWO46Cpurgy8lK7OFSZdfH5Eg9
   bHP0BYVHkdM8CAZg8pCExBYIg5P85C/IGVprbRHTAwv99AYzwavSvCDgK
   TyoMrogu+w2WI9rZfkLaW3lkBoaho29S9ynOokfPZ3cTv0F9wRd3ll5G/
   w==;
X-CSE-ConnectionGUID: bEG4bgCISVygz7U0wWKP5Q==
X-CSE-MsgGUID: aB9HYYEiTIGLfb7NUrHKJw==
X-IronPort-AV: E=McAfee;i="6800,10657,11467"; a="56210334"
X-IronPort-AV: E=Sophos;i="6.16,244,1744095600"; 
   d="scan'208";a="56210334"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 17:22:34 -0700
X-CSE-ConnectionGUID: b4VVuFZ0RZSV5MOFR2sPqA==
X-CSE-MsgGUID: b845CFVLRdqeg7G4BCcWTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,244,1744095600"; 
   d="scan'208";a="179970610"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 17:22:34 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 17 Jun 2025 17:22:32 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 17 Jun 2025 17:22:32 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.70)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 17 Jun 2025 17:22:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y1dfuLKm6ogxIpxCh3jKTOUBvunP4XrVi59rSlolNcBB4oh/MmlYNB6QXloCU+S3R07pz7my6sZX1c7bAVu1kvawmN/LtpT66a0WtXd+GRPmohZ9IEy6K6fayI0jVuelSvX9kCal44hr90eDyLWcf8I4BiJVxxkIx+OLokii+dUtLRGN73jE0OcHU10B/wXxjrHZ1Im9XteNwuAFRmKBRbScYEid+5YrU32pFaLTo6abiHj5+WmoEh00UrsF8Lhca2jb/GOgiyM6f7NIPMRCg71FmyGDywwl+YNWCeyTUFRPRBRyfFtnj6u2hdH4FU0Ttm4jHDOKv84FcA6+y0UHNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+vNh2WmYl4DtphsRdIe3c4/KonROoS9HQoSIE1nFj1Y=;
 b=paxBR90sMm13hJALU0uyNu5bmABiygSb/liiNynXkZAyn08Yv5/tdK/mZa/Y3RvX8qcEp+5ph7VrZunMKLq2E4kbbqqCtt6VQKfmAgoTrhcOuQ3BETDuvPU7BzLYSySdja0iCTnmHZevEeN8AOABF5VsoZZFEUl0ds6K+BiWdEprRCAg1Fjuhei0x0H7AAuDqusOf3nMOQP60bayAyZzLD8o20/SYBN0nqyz4Cmyd+vgIMJHCb31kQdMT1AfvLC1hGAyvtUy8Zm3nzj+VnM/qBGJuJLM9ah6pYPppWGDdOvSgrhhuAkdAjzdABxSm45ddJkfLFthQQ9f14Kl7yDTbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB7985.namprd11.prod.outlook.com (2603:10b6:510:240::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Wed, 18 Jun
 2025 00:22:02 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8835.027; Wed, 18 Jun 2025
 00:22:02 +0000
Date: Wed, 18 Jun 2025 08:19:33 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>, "david@redhat.com"
	<david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>,
	"Du, Fan" <fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aFIGFesluhuh2xAS@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com>
 <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
 <aEEEJbTzlncbRaRA@yzhao56-desk.sh.intel.com>
 <CAGtprH_Vj=KS0BmiX=P6nUTdYeAZhNEyjrRFXVK0sG=k4gbBMg@mail.gmail.com>
 <aE/q9VKkmaCcuwpU@yzhao56-desk.sh.intel.com>
 <9169a530e769dea32164c8eee5edb12696646dfb.camel@intel.com>
 <aFDHF51AjgtbG8Lz@yzhao56-desk.sh.intel.com>
 <6afbee726c4d8d95c0d093874fb37e6ce7fd752a.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6afbee726c4d8d95c0d093874fb37e6ce7fd752a.camel@intel.com>
X-ClientProxiedBy: SI2PR06CA0006.apcprd06.prod.outlook.com
 (2603:1096:4:186::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB7985:EE_
X-MS-Office365-Filtering-Correlation-Id: 102fb891-db1f-454d-ab3a-08ddadfe2567
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?6/HMi9xEvQRky76OUzXBY5n1PhqKa8UxKSVyxj4MI00luXqfwHPDY09hqEPy?=
 =?us-ascii?Q?NllCO8gyLne62tRqGf6i/Jv5Ij3OcgoBZFnS7BaIoP6lXNGTHCu1OHmU1Tbo?=
 =?us-ascii?Q?g0LbeEKYrJno2HsuHBtHY6GPMbXAdW5qTvsrwhpnEIHzOMRsPn+jqeCE5JU4?=
 =?us-ascii?Q?4uysIlg44sNdwSKrOrpwSYOJTWZqAkeBpgQ+5UNk0ZxQsMoPvpjCZVqLIg2p?=
 =?us-ascii?Q?sZJbV4AJVnP831f/Zj/ZubkYneYWowRHq2HG6TenbpsmpDs3l0E4hHjcxYWE?=
 =?us-ascii?Q?HfFfUq10whUdGmNbuMIYDIyvl1c9SxjE+LEp4lYDfNciH4ia1w8It9h3dZdM?=
 =?us-ascii?Q?QPBaTczKyFnCQvJVHinVAKlFlwDSE9Xp5GSZCwwDzELB8NldVtZAJRDLjvTH?=
 =?us-ascii?Q?x42p8dUjAHTM7h0+1+i1HkMKG6jv9WWkyLMeGs0vQl7oo7aU2ko6FKcHzbMo?=
 =?us-ascii?Q?i5A2+cpcWDo9DL97v+Jb6jC8lRl/8FDt/5nBwZ2DqEMc+hTtY9HrCP9ZkI1z?=
 =?us-ascii?Q?Dp0XYrWhcWjiUuD5a2lTDHM9l5t/yZ1vdWZevz+T1z+/qE/WOWVSz+8SBEsI?=
 =?us-ascii?Q?o/Xt5NXshrJXhhDjSEbGNAZdDeOSU6k+Lwtz0AUJ6j2WoNMtOE86a7gMIuza?=
 =?us-ascii?Q?WsFKIpcnh3qwLdGhewd2axl4bHBJ3Vumr8bAEOf5fcgfho2NbeQ0VebaeZdT?=
 =?us-ascii?Q?hahGPcTWcRTq06RLbUrLLmz0JpBN2Q3tAqIOJfpIdni7k4QvnaYtFO6Ehp2L?=
 =?us-ascii?Q?ra48nrPXMJA6/viVfJ/87TaBplIqQdaUeomBaXZRkPgBMofNW2hfNWd8zlu/?=
 =?us-ascii?Q?y2JQTY0WrSKnSEf2STnlj4LbKo5NkOMlgUWgzGG0Y8Z6sVlPJ2DcuZPKnGWy?=
 =?us-ascii?Q?T4DdLSmcapwBwkGjQhzSyY1c4jvsU55yeJsDgLyYQVpjWXOLWRNWKtqRjV0K?=
 =?us-ascii?Q?Bvljha3U0AdpZX5/HmIcgVSb+IP6x4ahFrghUihY6qGXVIcg6a0qaypkaO8p?=
 =?us-ascii?Q?fAQo7nPjCznNLimYSc9aE2PLBxmLokHvDoYoMlnb3jgbNBGXKpDSOwgbSHUX?=
 =?us-ascii?Q?9qVOEyX9Q5jmy1HZ2qp4AEEsUW76Kn7SbKJ+Ya7JWBjdfDDcruNFjX6CfagU?=
 =?us-ascii?Q?mOJ4KqsqV5xuHO2VdKxQ2EJ/RtUPzhV/A5zPeD/CngMb3kmBOlBV226B7D+E?=
 =?us-ascii?Q?u5k6g+zmHcyk0lp3LG8U+5Qh51MePrVCCmUxgM5RS9p5qJLa1cxqDCuQM3XE?=
 =?us-ascii?Q?aZM92yzAui0Hdtau1dG0o0XZLxJWpbvd7O3cNbcCcU77gpPjR/AwyAnd6kYm?=
 =?us-ascii?Q?615NAsY1bBj5Jnilq3J9bgXjjnYvVUdl+enJ1qxBplM4zGsrU4ojNSlU7K8I?=
 =?us-ascii?Q?vjZZ6ikiofMNT2nQ7zwMnLxI9oR4EV8Ekw4l0Sj9sPtOy2dCblus42J0ryKq?=
 =?us-ascii?Q?BC/wnvi/8Fo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m+7pXOrGnPSeccLKhHeaMviaqtaJIyvylCZMRg+iNoPpBV0KP45DONsZO5ce?=
 =?us-ascii?Q?a9JBX8khzXo6b7i0j7r4c0KD44r5nGHfHVGUapcASgiLxIx/NDEipMMsYluU?=
 =?us-ascii?Q?9oeZN/TvBKa2ReU58KbDpXZOfEF6G3hBep2ept+QRoq5JFPNfzry+wFsvvit?=
 =?us-ascii?Q?QgeAGMN1QAHSV34sGGb09RuUFDSAWxeylthumOsGtTF+tW6Brfd8ZwqhiNFZ?=
 =?us-ascii?Q?rkaH5uL0SFfftNxHUuquLbSx3fJZVeeuxG7LJmurI1kQRU/yXubGaIE19eru?=
 =?us-ascii?Q?S3nHGlkCMAouT3yHikZIa+VoToplw8aXrNjrXy1tCGa//+DZOdeNth49tdp7?=
 =?us-ascii?Q?npyhiMFc2RZ3W2WTOiON2S1gqFlakhBub22S67/j0B5mm+oa+309pmDo/314?=
 =?us-ascii?Q?ZfO541DPtGkTUofbEqYFJ56mf0SbuMEdx3Me97OvwCfgpWpnpPwvY2EzI0su?=
 =?us-ascii?Q?YfAEYr3vo86UWsq2JwLvm0y3Pv+pBTXtN/JcXghKNqDzApf/y7lEvmLZvmK9?=
 =?us-ascii?Q?V4q+9SKuLxy/Hm2XAPWBCwi5KSYzLKRcSnoMGjVr5SoCSmrAJVRtJkZib8I0?=
 =?us-ascii?Q?CQc7sVVlK7rv31uUCWD8V37kMSOJPyKTg43B5v5DC96fryuBdajPlWFHT28o?=
 =?us-ascii?Q?Gyx1NFzZH5WAz40G2rSfVr1Sf4OCBBbQArQCpJcf8mNPQnch3aGXbZjBSgUb?=
 =?us-ascii?Q?8XbC03zvAhegwr0GgaUvL1H6MKXbKsMfMUaJ4bS/mwaNaGju6qK8cYhl2ucA?=
 =?us-ascii?Q?Hyjf0GDqoyD5dMo9qwGbW8dGV+hF8W1jJK5imrLDCyY7jHH96KERcMg9dEYy?=
 =?us-ascii?Q?z/EXi6Qlm6GGPp/4i0UcCntvflbWPGhU067a0Jv18Ld+CSqSh1HXA/269cmK?=
 =?us-ascii?Q?lCDygmLfARgegOy82JOTHRnOjt1zb5ytf1WsX4AmoepZuAjh5YEYa6h3YkAt?=
 =?us-ascii?Q?iINr3lc9D35j7XIsoUPnT6nqsGn9Wx0kVSlZbM8X3a0X6n+iWw6QD2hAHj/y?=
 =?us-ascii?Q?dfzag6PvdiiW9yfQEsaggT1ycTpN11xeMr6sSCTD6+Gls0O/lgPCWJIchvQK?=
 =?us-ascii?Q?qGmnByxWPHDv6KWq+5Y/IHMxlF6kvLynZh+X0mIcDwTAj2NHmez7t+maPGc3?=
 =?us-ascii?Q?dfLqap2EGR0gBKuM/wy2pvXF++tjltq+z3aPcCTl+3RRLRnu3W9BqhGCoOzI?=
 =?us-ascii?Q?501KCrNimUsq5McN3oxHEYSEm0Lv68iQSGWsro/CBMR1CCljsCDbZmiInaJ7?=
 =?us-ascii?Q?6r2PBfPz40WVtQqzYrEbahsjDZ7PQ6mt/hE0oN/TR6NBtiWQNDgjBrtPoOcK?=
 =?us-ascii?Q?fU5E7a8WovRuPGXizohBXfZx9vZTPEkXCpIEORXIhUdUUwzEdpXGJSrSCsQi?=
 =?us-ascii?Q?i1Sjay2pyryKGIEvHp2AHLqZXS4zVKfb+O1pX8bgl38dtk48L++kPatvWre4?=
 =?us-ascii?Q?wklGs8t8FRUNG+/9e0JzPUTVi6pPgk8yF1fZmsP7RMFL3sMb6AcmuTqtMCsF?=
 =?us-ascii?Q?pH0JiGdE80lwWOSs1egzyYdhM1neS17zZDYuG6TVyVKQPgGa0R2a5GzAbdoR?=
 =?us-ascii?Q?XhMtySKgiC8tl7yYg1SxWygHYebT6LP4MGPNIAqJ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 102fb891-db1f-454d-ab3a-08ddadfe2567
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 00:22:01.9474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cwQjSPLouGnZuhMkxFdLrrO1n8YvFWJ0AtlJMA60A3Q4Gw/qJWLTCgDF6hzp9TEgdtpVCeUecL465MlBdYKWfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7985
X-OriginatorOrg: intel.com

On Tue, Jun 17, 2025 at 11:52:48PM +0800, Edgecombe, Rick P wrote:
> On Tue, 2025-06-17 at 09:38 +0800, Yan Zhao wrote:
> > > We talked about doing something like having tdx_hold_page_on_error() in
> > > guestmemfd with a proper name. The separation of concerns will be better if
> > > we
> > > can just tell guestmemfd, the page has an issue. Then guestmemfd can decide
> > > how
> > > to handle it (refcount or whatever).
> > Instead of using tdx_hold_page_on_error(), the advantage of informing
> > guest_memfd that TDX is holding a page at 4KB granularity is that, even if
> > there
> > is a bug in KVM (such as forgetting to notify TDX to remove a mapping in
> > handle_removed_pt()), guest_memfd would be aware that the page remains mapped
> > in
> > the TDX module. This allows guest_memfd to determine how to handle the
> > problematic page (whether through refcount adjustments or other methods)
> > before
> > truncating it.
> 
> I don't think a potential bug in KVM is a good enough reason. If we are
> concerned can we think about a warning instead?
> 
> We had talked enhancing kasan to know when a page is mapped into S-EPT in the
> past. So rather than design around potential bugs we could focus on having a
> simpler implementation with the infrastructure to catch and fix the bugs.
However, if failing to remove a guest private page would only cause memory leak,
it's fine. 
If TDX does not hold any refcount, guest_memfd has to know that which private
page is still mapped. Otherwise, the page may be re-assigned to other kernel
components while it may still be mapped in the S-EPT.


> > 
> > > > 
> > > > This would allow guest_memfd to maintain an internal reference count for
> > > > each
> > > > private GFN. TDX would call guest_memfd_add_page_ref_count() for mapping
> > > > and
> > > > guest_memfd_dec_page_ref_count() after a successful unmapping. Before
> > > > truncating
> > > > a private page from the filemap, guest_memfd could increase the real folio
> > > > reference count based on its internal reference count for the private GFN.
> > > 
> > > What does this get us exactly? This is the argument to have less error prone
> > > code that can survive forgetting to refcount on error? I don't see that it
> > > is an
> > > especially special case.
> > Yes, for a less error prone code.
> > 
> > If this approach is considered too complex for an initial implementation,
> > using
> > tdx_hold_page_on_error() is also a viable option.
> 
> I'm saying I don't think it's not a good enough reason. Why is it different then
> other use-after free bugs? I feel like I'm missing something.
By tdx_hold_page_on_error(), it could be implememented as on removal failure,
invoke a guest_memfd interface to let guest_memfd know exact ranges still being
under use by the TDX module due to unmapping failures.
Do you think it's ok?

