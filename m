Return-Path: <kvm+bounces-17919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F7468CB9E5
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 05:43:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB3572835B7
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 03:43:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99E56757E3;
	Wed, 22 May 2024 03:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y4pk4RUG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBD360BBE;
	Wed, 22 May 2024 03:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716349374; cv=fail; b=PIQutJOoEQTrNJqsM/qYj4mm1HzOMJI55SKshuoQE/jCky3SLnQwtnZubNQp+4SwRJBQJB2GeSqdjUImW86zq3HHpAikzAajGaIPSWIh0M3T3xjLWDxv7ezEm392oKrKxY9lu32TqN+Yi7R/eTqw8XKUbausyz5yKF0thQ2I0r0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716349374; c=relaxed/simple;
	bh=oRkT+XsO6UQ65BraJPV/ioYdh1qMmE2Zo8kCv2o8fEg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=sQZZNeX1i8QeX4MFvUJjqj/qJEK3i9DIGNI/1+JteqGMHmrR4ZcfzMIOkGP7jnE41C7X3GJzQKAsKnO9WGFJcGdgQ+6MAHv/V8mVv3k408st8RvHICdHPm5r4CWJ110tbU5rQmx/8smsZytH757O0OoMQOWrTFVenUI3mHdBTNM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y4pk4RUG; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716349374; x=1747885374;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=oRkT+XsO6UQ65BraJPV/ioYdh1qMmE2Zo8kCv2o8fEg=;
  b=Y4pk4RUGySVrTfIw2+TYQuOG9MM6JctXNAaqqbmgA2jm1Q2X3eIgwIo1
   cyqrZUPRUqjQ+8essR8Lv9fTRiinZrnosita8bepgRAMHBZHnPP0UVBkN
   Eb+snQjHUudkBRtx2n2sqISBUEl2Nzi2YrHJrZ4QwufOU4qvcrSQ6YmWd
   XerMFUELt09y8sbVjqF6NaHn68lIqEAArd1qSiZO0Jp+qpmilm3aCf58J
   PaffcuGHdO1kNJ5//nsyCEx4Wf4ilSCXS640+U+h9dMzbaTY/LDmB6pnv
   Ymc0rpfQOnhiLeYFa8EUM/UrRYaNj6DirwEAytnpXkDtLRniQ2tGzN+C/
   g==;
X-CSE-ConnectionGUID: wv357hK7TI6P2ZdGxGH/fg==
X-CSE-MsgGUID: W2RsbvgRRXaP5sdvpsPs6g==
X-IronPort-AV: E=McAfee;i="6600,9927,11079"; a="16406593"
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="16406593"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 20:42:53 -0700
X-CSE-ConnectionGUID: qfUy4wodSWyOtgTV+jK7Vw==
X-CSE-MsgGUID: fX4ujRPyRsGgTNbQqwkvtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="37542328"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 May 2024 20:42:52 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 21 May 2024 20:42:51 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 21 May 2024 20:42:51 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 21 May 2024 20:42:51 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 21 May 2024 20:42:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CGBzgKs/5vjRSYzWdNrauhfYr/eimhHpsVyp9aol0YP7n+cmuocIW6Ly6Hqw5T+S4HTUGXxdgLpqHRgw35a1OdUQ3qAc/SJNKI/y5FVviNR1c9nOqHxrB85pA/iSIpaDjPuV2Y9D370hIYZsPypRP2Sd+simRzg0rbITiXAabJMv3T8OOXzdMpJnZfXQpXskl07TpIjQCqdDKCePLOjuwNC9HQ7mjo1rsvpdg7tpAp54wVIZ12AcDCYb2GX3yLrP5NR2lg2jHM5TMb9H7NFimfE5ymulPnPFIZFSicTSi7LmoSd9xJKOt1ZfuxHxRlT4KinKhhC5I4hY41vxCa7JOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MKtsv1Sz5EuPbq5jp70+H1swsWCJPunn4LAFBX6POko=;
 b=T/p7Cwi8ovcW6Gaokko222OsqJU/+GnLGgjKfJhZJp5kTQSvR+LPWrESQYOgw/LE5gSu1Kiiq6aZHBvSiDzRzVoGOoCyQYWVSLDd2rae3zlc+VuNj5KmfcecBufIhaLLwvndA+rcPzKkaoo+hEjXrKZMv/0vGZonoEQB2yXgVR1pmpDtfL+XTWn6wPeirlcz6hsFxHvjA7FexYcjtSgxXhPd/OI9xH6zWC2TmSWW9W9awIFt+XOIOwbixNSPrasFSw7flmTZ4m1JFa/te/lPaj6m+ue1gHmdeiv+eyymxpLRnpOtpXWxJceEVJGgBMYjPDTvC2PuexAd+W1jykNMUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 BL3PR11MB6508.namprd11.prod.outlook.com (2603:10b6:208:38f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.34; Wed, 22 May 2024 03:42:36 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7587.030; Wed, 22 May 2024
 03:42:35 +0000
Date: Wed, 22 May 2024 11:41:42 +0800
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
Message-ID: <Zk1pdkQj/CuBahqx@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507062044.20399-1-yan.y.zhao@intel.com>
 <ZktZDmcNnsHhp4Tm@infradead.org>
 <20240521154939.GH20229@nvidia.com>
 <20240521160016.GA2513156@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240521160016.GA2513156@nvidia.com>
X-ClientProxiedBy: SI2PR01CA0026.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|BL3PR11MB6508:EE_
X-MS-Office365-Filtering-Correlation-Id: 03c260c7-1c8f-4a4e-64fa-08dc7a11384c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?/leXYTON7uUkhFH6+/viayl5oxqE92mPVSqzGSm/v0uSI9qPD02sxOxJSIpQ?=
 =?us-ascii?Q?TKPKD93xUDnBKCZWvFlIivlvVwTC8CmDsFWbI/Zee4hnQTfzIjUEVuO6d7MK?=
 =?us-ascii?Q?A1DtQtLiwbYZmQpKnhjWthmdadBZeNyYs1Q5O7aZGvYJ2eToDo1Hp/BB4ik+?=
 =?us-ascii?Q?j1bMuHnv8DZhNiR0MtWOc0GBfjpnBRP9iDiC87IKeizr+pCilEfz/t2bIWBB?=
 =?us-ascii?Q?GsfEBt7+/OUs7ZSJnCelLSvrwYS6wth63HQfSEpGl7jbA0TYKN93cMWr2zp6?=
 =?us-ascii?Q?vN6iQF2UbFjjDYrwt9seVeQc3bfZJLoPayXl+MSFdq1QGQQf1XRHGpfCeJlc?=
 =?us-ascii?Q?y+l0hN+TBuZG/7oNko3aMDKXDdfIcAQl+hWLe1mihUtGQ9NdQSqkTDwOgATu?=
 =?us-ascii?Q?aSmwKeJGWsMjp31Wvu1UraeNYWqavHCBARhc3koNTs81U39DY8d93VOVZwKy?=
 =?us-ascii?Q?Wn8wtDHjS/JCKqNejkJY8ImDdqTeRUjFvj2j0OcLq8ZC6SK0vrb8w4fkedSN?=
 =?us-ascii?Q?Sol19qgX3VYzFdxvvp2fcqRFCSUgZeD47tmYPLNgPSdQtA9ZkHSdOnkvFlif?=
 =?us-ascii?Q?hezaE/3zz5GwPIXRu/41tEoygfzKLdDMcYsw+/BjINFBrv9q2jJp8WQt/XYb?=
 =?us-ascii?Q?2gk+tfOLh33PqAiSGySU8iMQU2Vc5aKsvrb69yyHrQSTnPkWYVlPQnOAqSG0?=
 =?us-ascii?Q?Y+YN/9u4RLseavTG0a94JayfRt6SR7yg1FcBiC/vaCGXQWLIzQjCownKIcdt?=
 =?us-ascii?Q?DI9BB1vjFqTYoFZ1H+HgeCrrh/OWGcgEmlvt6JuNZbsyTd5qmzTnIbbX2jkJ?=
 =?us-ascii?Q?MPukHrbGUP4A31RNV2rKmXzasQ/UPFBJqJFiVlimX5wHzJckQEkn44xS/wfo?=
 =?us-ascii?Q?ESyYEeFV7nnDfwoo55Na5asxYZ7YAsX+ZP/0BhckFLnOuZ0YudEbud2bj8x5?=
 =?us-ascii?Q?fpvUXaUoZd66zGM6NPAnXKXKafmA4NW2lgM82j1b0RimHZn8oSDOhvF0kcJk?=
 =?us-ascii?Q?02RfyY6WnaTINyg9hjYn/jPaq1jPrpC/ytyFNbpdMOU6LULBecTDAwA/qebX?=
 =?us-ascii?Q?shZ238Hhfg5UUvSSLFIVlP3xV1jbpMtsppjgekDZXqje37K6YR54ifovh61L?=
 =?us-ascii?Q?5L1x3w/65OnCId4nZAFZTeOUtfcND6X1u2B0BcSD2Q52rb24mWtPLDBOHtab?=
 =?us-ascii?Q?4CinuJMLaU2hahKOPzp2fHn2VNOVT0jmx0MFG95GfVMI9bBADKoPfo7AbYM5?=
 =?us-ascii?Q?OIsCzb9TvS8fZTO3jT4Nf+g2EG9zs00Vi1Ma4eG4Mw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XUSMOeOLOKNMTXrl0k5fnXh6FmqglDzzv52nekpxNBpZPKgB4nb4QygQTLmt?=
 =?us-ascii?Q?g9KRHXz0ShOaZEi4ziPBTdzd3kgNHSrxsLlwZxrMg2FSxp7mgpFZkEga2ega?=
 =?us-ascii?Q?cgA+fsLXxNB++1JVoQoeeY0KpS6dxgSKkqrHeE9JG2zyMZnPdT806H/rFQSl?=
 =?us-ascii?Q?V2oJzqcKMWaHtbiqQiPQewSaca7Z5j3xgTVpVzx4O0mKaPHGPOWcrUdepwKe?=
 =?us-ascii?Q?tggxx2iZ2jwY3rqXAFzl4eUPWxeKV8f3ambfPulASOBAByB1Gl/It67H9fgW?=
 =?us-ascii?Q?Mb8B1BMqvUUrAb3fzzAbd/qPBalsSM/5nqFFcxXsN4BDWH1aSGGOZEtDi/e1?=
 =?us-ascii?Q?Lb6f1f/WLtocFiEzOkTKwJ7tvN3pFq50SDmyuHjBQFalGjVkaiQI3QJKihUP?=
 =?us-ascii?Q?QSnCKBRTWzxdAT4LhS4y5ngKB/SAFbN8VwHXUPCsu+2Q0gBIQhfvzOMIAwZ9?=
 =?us-ascii?Q?9xAP03dSymVchN4KYptupjQcxJocIJxRcuPPK3N/1KDnDC1DqT1Vk2MbKvZc?=
 =?us-ascii?Q?B+9lsT139M4Gj9aRPva8DXoqmo4G0gFG1qaKKPuqjkJpn2226ptABqRh5InL?=
 =?us-ascii?Q?bvYPdQtNKNbrb9eUGVQX9Xkkx2kldVqBMVi4fOWadBvDO7rTCFJxBhe+gOd9?=
 =?us-ascii?Q?7PF/mf7pK/azlh6kqZ28gqc3NU/FJEW0KROCz70ql0F7Dzh7k+7AVSY9yLdq?=
 =?us-ascii?Q?RyZS6Sts7olmmpPzqSnD6PPmElINWELMbcaIzftJ0FgxlExx6Wpxxl9RczjD?=
 =?us-ascii?Q?hvlE3RXIX0i2cvmI7bQIRVycvBI0XqUTMmotnwrg2jGupdxC0D3gbJEC9IvR?=
 =?us-ascii?Q?N1V6PHincQt88oiqtOSRdr13cwMolC1kF4j8Ru3YRr+2qb+66pJnS+SdvhWV?=
 =?us-ascii?Q?u1Z8EhUyeQgDoW8dtlyId6fGDTYPAZVSPDxqSQViE3yUj70kmYwU5pMtxR3c?=
 =?us-ascii?Q?PRbMXifHOXbn3c8sn2xd2s/TEHget1j2RSF3KlHhThpi3NZe2Fn0zCN66gut?=
 =?us-ascii?Q?X6rPhOJWw3HHcvzwls3PeJBjoU1KTM/Id2r6LBLAvmiFK9GvOPFuznAWWh+/?=
 =?us-ascii?Q?X//e+14q7tg24PraIbG5wSDoD13q+xQiX18CusfC1Mcvt/MOGLArRXLWCDuL?=
 =?us-ascii?Q?VkARwpggBtT6Cd+sQ3L5TuqNQBvDhRaioVB/cEC5cPa70SsWZre/NQ415K/3?=
 =?us-ascii?Q?hB9uzS+RzhYrHxwfQSP5U5kskYOwcVNVlm1yxAIMpDCc1M3I9zWqw9TocWdQ?=
 =?us-ascii?Q?JTSwq75WbpIrnznf1T3WEtroqppBHORWkq7FnZjrncc9odm+syFb55Re3UMH?=
 =?us-ascii?Q?gChmB/g3cm49aPaDIfFbvOSP4gK2cx3itGs5rrzu+YxQVryQc/+qu/Ai9tpZ?=
 =?us-ascii?Q?0plLsO6Mksbpxo1IHbAwW7z8kw0qIOiVXusRdnQ1emD4B49zku+69OUj9c9a?=
 =?us-ascii?Q?v5GJ/ePu7Of1Riy0MeO7itY6V9e3iqCD7/CvVBY7LUyDX0l5RRWN1Odd27zZ?=
 =?us-ascii?Q?4/4SBrtfe5XNCyYtwYuOFNvdFQal6FhsUPvlqv2ySmiCg1tiS01difdv2f6d?=
 =?us-ascii?Q?3svDHsoKFK9df8Hb04vI6U6it/fClnZZZPvvbpz9?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 03c260c7-1c8f-4a4e-64fa-08dc7a11384c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 03:42:35.8647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QCCgfdet1xZKoqsEnlx5wnxdbw2Yr34/lJDai4FRd3PhgqvaJTo/it2lm83SrVVVsj2CuNqXebu7cDC0Y0SSwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6508
X-OriginatorOrg: intel.com

On Tue, May 21, 2024 at 01:00:16PM -0300, Jason Gunthorpe wrote:
> On Tue, May 21, 2024 at 12:49:39PM -0300, Jason Gunthorpe wrote:
> > On Mon, May 20, 2024 at 07:07:10AM -0700, Christoph Hellwig wrote:
> > > On Tue, May 07, 2024 at 02:20:44PM +0800, Yan Zhao wrote:
> > > > Introduce and export interface arch_clean_nonsnoop_dma() to flush CPU
> > > > caches for memory involved in non-coherent DMAs (DMAs that lack CPU cache
> > > > snooping).
> > > 
> > > Err, no.  There should really be no exported cache manipulation macros,
> > > as drivers are almost guaranteed to get this wrong.  I've added
> > > Russell to the Cc list who has been extremtly vocal about this at least
> > > for arm.
> > 
> > We could possibly move this under some IOMMU core API (ie flush and
> > map, unmap and flush), the iommu APIs are non-modular so this could
> > avoid the exported symbol.
> 
> Though this would be pretty difficult for unmap as we don't have the
> pfns in the core code to flush. I don't think we have alot of good
> options but to make iommufd & VFIO handle this directly as they have
> the list of pages to flush on the unmap side. Use a namespace?
Given we'll rename this function to arch_flush_cache_phys() which takes physical
address as input, and there're already clflush_cache_range() and
arch_invalidate_pmem() exported with vaddr as input, is this export still good?

