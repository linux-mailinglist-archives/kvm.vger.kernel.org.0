Return-Path: <kvm+bounces-25428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D76A965537
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 04:21:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3CCBD1C22612
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 02:21:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30A1713049E;
	Fri, 30 Aug 2024 02:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VeLd3pAt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321D076410;
	Fri, 30 Aug 2024 02:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724984509; cv=fail; b=II0eTbFU5Hzj6fVm5HK/7NT3P2325fDnBdhdIT5DLT+C9xPez/WKIJ0cEOIlnbWAZhPt57xf1UWtJzQTaoTUJfLqzfTew2Ge+bp+rGUAyrbKUGJ9NDVZ7ml8TbH/mVbkc7EsQ0YYH4LvS9AHYf1Os/4fV3ewkbQ+n06DeDMlVOU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724984509; c=relaxed/simple;
	bh=my8p6pvIxC2eiVtJmJJynKtyH+y3hpQSFjwF/Ptpu2E=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JQq5sffBeEbjdTpseZPDmtOdtdUL6gw6yWRjnm82CMhC49QlZcNRqnuz5m3hoglta3Iwa7/qjMH74h32e/bQRnbRGBIjMEPTtm4EzxYeqpGbXKXv8PnPACC+zVLt6/XBkigANYS8s70aXGF0CPPjzWFEjrtS3/yYbqJIHWvM9G8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VeLd3pAt; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724984507; x=1756520507;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=my8p6pvIxC2eiVtJmJJynKtyH+y3hpQSFjwF/Ptpu2E=;
  b=VeLd3pAtY8xO/DfigSkRpDscNhWYQp2gW3uyKQFaO425CGfM4TBnTwHq
   tyFLI1jkl3df9jSmvZQiqvj36EA+pzL0QuEShb1WFlITmiEhhWXnn/+0P
   Ko5yf8Gk6MYtM3cMJ7H4wi57DJl9hz9waEQHVTOUTT6OMWk1GiLKWHsav
   LM0WRTptJmBcGD6KzNUU9WRgKptNL7ZIqN5rbCLpS4aECZIyCDbLLOLAp
   b+lGnly+o3slT3g7FKZc3KVHGlCBLbzZRvS0QsU5LYSZSJjQBwUWapYt7
   ZYo6nttHYYYwuiw+yYyKOhFORiiESJBUisK2J6FvKLBMJcsbodF7iO7p1
   w==;
X-CSE-ConnectionGUID: OTaTBHbFSlCQGfaqqoiPeA==
X-CSE-MsgGUID: SthrqeuiTE+LmcbLC8rPaQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="34774466"
X-IronPort-AV: E=Sophos;i="6.10,187,1719903600"; 
   d="scan'208";a="34774466"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 19:21:46 -0700
X-CSE-ConnectionGUID: Lax1AKJfRT2T1oDwKsB3lA==
X-CSE-MsgGUID: 6QN0FbxvRoeIwQQH9zvJ/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,187,1719903600"; 
   d="scan'208";a="63611565"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Aug 2024 19:21:46 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 29 Aug 2024 19:21:46 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 29 Aug 2024 19:21:46 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 29 Aug 2024 19:21:46 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 29 Aug 2024 19:21:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G6uQ3prnVsoD29KBIEnhMPnBGTrH+nzY/uztN/ooxYoi66xcq/J5n4HXILQlGP7x19iCnQSefW8V4KSYTdtZSodIaAVa+tjFQdqn0gF/fZ/yztEGNmELE6WN/8H0lN3K+B6O80wmHsKS/Pj9GqX+izpK+iAC2msi3Q9K9qcgOHAdgR8uXGpW+NbIOGRW5T69b9QWVdyuOyiCkVRG9Re/J0gqVwCBw83UmPTg9IbGNwY+0AG4lK/Z7/OxunCqDKgrrvdYA6+dAJXUKuvIWLNmUjf/u5NxtxxsJNnViPYejAzb30zy3t93v8IVFunboU255R/ZSyYhYH239ash2DeB+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9P2NlsDmW2RWm0JV/yocKvlTEvNSi7NK1z+Sgod1S0Y=;
 b=J4gfjvSN79wB25jsItqS486u4ZkVZoKLC3tLWHne2VxORUMHvUadkOTWhLjTYlo4UtGQms8EHHeuIKKPEmytzAaB73ucMqi8Z0BP7GvX3R+5M4lS/FhaGmyjZkpWZUSk9RY7gZ4+ni47OKPNKJPNxKGnQTJnsuLliPQIjUajK/NJOU8BqDRqjOlVAcVEYd4Sug3iTNoJ2RkiClI6kCGMOZUjTBNmzpa9xHRvpIt46/MQ1FvlDr2+zrIw12ED03HQy/mS0uqIzuQBC+W6HDoIlxQd6PbsMD7s/rCkj9TPqx28YCiOTT4pMsa71NnJKs7T4zfPIoyHIs/O8QqjIOVhvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH0PR11MB4839.namprd11.prod.outlook.com (2603:10b6:510:42::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 02:21:44 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%7]) with mapi id 15.20.7897.021; Fri, 30 Aug 2024
 02:21:44 +0000
Date: Thu, 29 Aug 2024 19:21:41 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Alexey Kardashevskiy <aik@amd.com>, <kvm@vger.kernel.org>
CC: <iommu@lists.linux.dev>, <linux-coco@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, Dan Williams <dan.j.williams@intel.com>,
	<pratikrajesh.sampat@amd.com>, <michael.day@amd.com>, <david.kaplan@amd.com>,
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>, Alexey Kardashevskiy
	<aik@amd.com>
Subject: Re: [RFC PATCH 03/21] pci: Define TEE-IO bit in PCIe device
 capabilities
Message-ID: <66d12cb51dc9b_31daf294e9@dwillia2-xfh.jf.intel.com.notmuch>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-4-aik@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240823132137.336874-4-aik@amd.com>
X-ClientProxiedBy: MW4P222CA0002.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::7) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH0PR11MB4839:EE_
X-MS-Office365-Filtering-Correlation-Id: c9829ec2-2a14-40be-939e-08dcc89a7dbf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?zwcgMFIDQxjMcvHE4lECwno4wS0YN3tLwum7fCpszPRwHPoGu5hECmBDaExB?=
 =?us-ascii?Q?1DamRUV6jjzBkOZz7SCCJRYaFF2b/IkDHy+IFwfveBlPBRhX2ihSSzxj5FnN?=
 =?us-ascii?Q?aOB2F1K+QNf9GEHZvj4/1OXgb92OgTtgf9u5uRnQDoJp+2fU6C3Ootjnl+4/?=
 =?us-ascii?Q?gpsMek3QIcYdjoQslYm+22MBmYCXo7PgKpKqYPRgDBbFc4TZ83xRvMvHhGCJ?=
 =?us-ascii?Q?h2fsR8JQUXVqdSeStrQdUfwbAGdzwP7eE7IYN3SeSo7meXMrS9xY6ZBBfUSR?=
 =?us-ascii?Q?i1BhQZ6JT2dnkhJ8emmvdahB6Y66Mj8lZe8yXUMeP4i8Dq329hGPzs8MgmSF?=
 =?us-ascii?Q?Xvo5RJC/hCawHEOp97aA3mIbbgOZop5OwZJswtZef5tuGBYJKcqAU//pknwD?=
 =?us-ascii?Q?8Loww10uRPTcL4FkOgCZ6a/kjIcVQIRhupCaWEWhE0Yruiku39WJ6uY2fYD0?=
 =?us-ascii?Q?KnibJMJ46ZOQtiWghymQ3iW25f/sMPV6Rcq/6GDv58XhrCUCfayYodBZXjUr?=
 =?us-ascii?Q?epE3C6u2t8jL67q/07jN5wJvos1peOh4GJVvuZDfoJoFHo6D94PXuJiSob21?=
 =?us-ascii?Q?hB/75OdEe9cX3QTZALpBm2C1MyRWzI6olbCZdVEF+1DojTHHEgghVHXHxre5?=
 =?us-ascii?Q?bGlF/zzBH9H3ZV2Ln/kZ6scJQGQEG9e3mfVWctG9b1iUIDmC/6RnjVG+vOVG?=
 =?us-ascii?Q?dqQGTtf3wYYPExrxJHmtxMSFYxSMAeG5AF4vcPsyJyl8CQ2a55X1l/piNMmq?=
 =?us-ascii?Q?cXQZ3qTtKAXfu0PHFJhFTxBw43Bh9XzxxyAxOt1Zn7XTfIiMinaXsDX+Mdgk?=
 =?us-ascii?Q?28tyyZT9ePkzQV9mLyIXwOwwY03dkIOt/BQInO1g35paaX/nUsi92r+bAcQF?=
 =?us-ascii?Q?A76BFIv+CF46iWbkq542MRlW2wDQJ/OHE+9o+5PSeh1LzGw72HBVDFZ54IYC?=
 =?us-ascii?Q?RSgQrm6QL5NAYsVbPy1JQSxa1I2vStV8hcjE9aqu5+WTQm7Tbemd4Vefqyfv?=
 =?us-ascii?Q?dSbeHgjZYDtQCd2qQ0pJk0IA4UyaSoHuOn9AYPlPcmykfNMGnpLT8pAeOklw?=
 =?us-ascii?Q?//HFlADL2YeI+v5QsGoOK+9xDGk3h4wStLyRsIryFRyCL80aFgxrFa/hEy0T?=
 =?us-ascii?Q?f0SrROqdMG/OaZPEVhU2yOvSvBvoKtqwAIDpkn5pHrAerZ1v/W4+Jaat/ZcN?=
 =?us-ascii?Q?aQw1amGqoJ02ZBO7cROgVAqQqKql/+A1CnqEortpzaCLS2N+0CTEdpqyMzne?=
 =?us-ascii?Q?5nN+Ilqqnd6OWhMWUZM9hujvaFTiNOhFFeqHW41YiNIA+9qXXIRIZ1OAU05f?=
 =?us-ascii?Q?vIzhX6NGijHOcB8eYpYRbh5VrIf4U1CBUJIZD/UH1z02xA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xYobdBo/GfmNaR2sZ6Z/1hZQ8yg0rWsmuBt9A54cqPCiW5G/d3yXpmf9nFVM?=
 =?us-ascii?Q?pss8Uhs/FQxoISMkILHP3KYTj3nndRuLeXORf+jyL8LsNvHDzVlsofGfEgJ4?=
 =?us-ascii?Q?v2ZNgYlfjCHaf3K8TFVRXsXb0CKTASJ22pkul/+O8HCGHOZoAiUdQjG/MNiK?=
 =?us-ascii?Q?dkbtC3lW7c312t1+DLKFQuZuV+QXZbTTQl1gj48JmXDF1HtqnWJl5lykxJ02?=
 =?us-ascii?Q?0r5aO/EwVfOjU3C9TpfGGLnIR8dr+n2R550nYdVHoX4vpVT42mD40XUcXqZd?=
 =?us-ascii?Q?T1ZyMgTtl6G5Vt/CoevhqkcBjMbLEqnjMQRwWJXamhJ/8HSYRMVknmZ3pyrM?=
 =?us-ascii?Q?C8FKc9kvSko9xyjhFm4cUKLI/IATTb2TDXNlcJgN4NP5qQ/JSTaI0tBNNZOr?=
 =?us-ascii?Q?0Tyu69cgqh5SqF9xGOqFFBWpUJ0V2CuxwthJHpSkLreHUJjf9bRTDYJiNXxi?=
 =?us-ascii?Q?imF+l8HYTOfjXV2m+1hFI4NtR0yIGZjx4WacSSZ0Stros2hPndmFP65nwSPI?=
 =?us-ascii?Q?d0wQETycI5HW0cvRN+66AFSCaWS9682Gv0e4aX51o0YOzKFACaB0SksuEMrQ?=
 =?us-ascii?Q?1FtJ9aWs4qNznxfuj62lBxCg02Byt8qGGiy9BurGEIIxAhNMWb2uXQifMVTW?=
 =?us-ascii?Q?VvlThk1eR6H5s/DC0jbDsgLVnMQSnFSe5ntM/VNs/QfrkAOdbgxE8gRuxyQW?=
 =?us-ascii?Q?WY7TH38weWZzFQRZF0xd7UiMrKHnsx76AXIHuwLjc8y3WcEMOEEosyijArZb?=
 =?us-ascii?Q?qEpbZKZBsrrtcSlw4It0hbQJym/k/WtOcHSTilx6w+nnOw4N5p5qVncKellc?=
 =?us-ascii?Q?nk0zHH9V+xufW4q1sXsL+UKodxLPPeGuKShBzmCrrhaeh0SZqWqB3BhVhAeq?=
 =?us-ascii?Q?kCOnuhM4mKKEysEqcnWqzWEvaSIhf6W14M2KQypQ0HknZDvxRO4V2vtIh0VC?=
 =?us-ascii?Q?8b/PcBRycG5EPJBRJEgrrfIT0yYOlv0dip+pCZbINg4uOcIgT6nmWHzu2Rw8?=
 =?us-ascii?Q?jSUBWOe/oL/iacvS2Uk8uTox7a6bzT61GqWrf8EFWdM1AeRJO17uO/lg3bLm?=
 =?us-ascii?Q?5WZpMytC95CZt4vuhhVhf9ddHm6q4/L/hCb9sEK4I/dTb3lyRD02y2KmXZgs?=
 =?us-ascii?Q?e6jOVEhrmk8URvmIzzYW1r6lhh4WoKXL8NvZvqifpR6mkVaoYLxaPgvOTwsn?=
 =?us-ascii?Q?9Lk2zZJh4xaAjookZtGK2Jbi4WrJf1voDKwKWxbJuW4hNbjKunwnlzreWoB1?=
 =?us-ascii?Q?dEVNEv1gjdPixtUnuQfAcL2SA+uQkfNvmuysGERtB8m6KpFIDZNLm5LqWUn1?=
 =?us-ascii?Q?RPN5NAL0amT7tZ7qtBuvMNYuXcu9gHSSZn57JEBrX8HzT9Jq+fhVeCSv2wLJ?=
 =?us-ascii?Q?Ln6m8Gj4lxoHakFQdpP1pqoIV9dCvKo0g8DlRyRyKnQrmMYEhXloKT2hc97r?=
 =?us-ascii?Q?ZXs4S+2eghx/I1R5pOucLefTRoMCpCDh04kwcSi84FpgAEWHxOoXO4UM0S6+?=
 =?us-ascii?Q?Yc43qaDjnucYQOL/pTqF5TXCexNB/hsI0q8wf4b546/ETJ3dZoKHbhV08DXn?=
 =?us-ascii?Q?pfTf/IHbzjV0hSma7cy9cA1U35DbZLXQE2kZdK5SKRa+f3QNZ0TWmg/Ne06C?=
 =?us-ascii?Q?PA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c9829ec2-2a14-40be-939e-08dcc89a7dbf
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 02:21:44.0941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dYb/WcloYak8js5n+hjohK5dTTE1K91k/zAmXgzFfSsdUAsvej74Zdy6wMfPJRcooGYURLIAP5SWY0ECB0NAsAlxmgW6J0bz/9A2iVvpG6s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4839
X-OriginatorOrg: intel.com

Alexey Kardashevskiy wrote:
> A new bit #30 from the PCI Express Device Capabilities Register is defined
> in PCIe 6.1 as "TEE Device Interface Security Protocol (TDISP)".
> 
> Define the macro.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
>  include/uapi/linux/pci_regs.h | 1 +
>  1 file changed, 1 insertion(+)

Not sure this is justified as a standalone patch, lets fold it in with
its user.

