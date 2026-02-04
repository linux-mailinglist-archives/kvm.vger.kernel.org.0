Return-Path: <kvm+bounces-70144-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eGe3J0j4gmm2fwMAu9opvQ
	(envelope-from <kvm+bounces-70144-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 08:42:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A26CE2C52
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 08:42:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 729F2301A428
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 07:41:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 313D738E5ED;
	Wed,  4 Feb 2026 07:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dkvsUEvY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9153138E5CE;
	Wed,  4 Feb 2026 07:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770190908; cv=fail; b=kGVVDlj0I3FlQ5ttA6ZAfQK5/TIMA+vFczjYy/rgXQT6KmIJqNUpDfFiu0iZ7laeyQQCLcXyRXnheILeQeKhY1/zt8ZPdSwk0DMFbJuVFatvye4Us1UPAOFrmvWEyASGBbl7+1WuqW4XHnI//UV11Nq7ilC+61A5da4U1N8e7Uo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770190908; c=relaxed/simple;
	bh=kiF73AfEMRRGsoy8j5rrcXkhkbJDsmP67BMPmGYOE9w=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RTJI2L/4RXTr2m1HB5yb3c9D45Hez5Agmy0SOiK6dStCavdZ6tn9E57BPZfrJEWUTjGkNJKzGHJlh7DbIh+c9VQAbryFVI7AlrXVQfjQsjIeDzDQkTfUOwhId8j64gmH0vlxterF4fvJe982VNd84iL86tokyz85bex52eeNqDc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dkvsUEvY; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770190908; x=1801726908;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=kiF73AfEMRRGsoy8j5rrcXkhkbJDsmP67BMPmGYOE9w=;
  b=dkvsUEvYkxKrGwJbzpvBhq1Np/LEGNUiqXBrs6Pq8xwKAwH//t9VYjUl
   VumCVmh2ullpjE+exL8iJTJpUrbmKr/CuKmmIqZ2MOJVgAuyCcfbBuiLg
   yymkzWowGVsfrCvshJDisNzZFiBawyXdrybMJF79t2XmAbYUvi2b/a44U
   sICFeJxo5C7lh/BsIn1i5Ni0nGtDogfasI+vvvKdVuRvOoGuLHiupszDm
   NVGVS7z4/5HXx3RiOjrAocsq7udhkVcDCSGKoZ6ixBvEw90R/Gox06Med
   iP5tjwWZNezi/wb5ha8m1adLSPX8NnK0HgMtlsPtd+IMlvJpfj3eDMmeJ
   g==;
X-CSE-ConnectionGUID: HRh5dp70SKW5TpGNzV/lUQ==
X-CSE-MsgGUID: bGXYWtTYS3yUZ1HWtEQonA==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="82804744"
X-IronPort-AV: E=Sophos;i="6.21,272,1763452800"; 
   d="scan'208";a="82804744"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 23:41:47 -0800
X-CSE-ConnectionGUID: SEvjIsMgRbyLI6Pem9OV0g==
X-CSE-MsgGUID: XN7Z4KeoT1W1eCgNaQ+o2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,272,1763452800"; 
   d="scan'208";a="215070824"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 23:41:47 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 23:41:46 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 3 Feb 2026 23:41:46 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.69) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 23:41:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rVdNO6RCNJmnHQbWh2RhhbmkHz8mK9UzDIdLH+kL5v9AwvMUyqyf/2gbMwa9KlD/LOEhTSJ/0G+UXLV3KP9DRZqVF5GOLzdw9ygKB4mWrQvZGsFtNKeEE1Yu6sju1VC33ZnwZGMuW1fTuGIp5PeByHI9NqLtBwL+4Xbi3Y6R/4o2Pg6rWr8lbZhoPjeuu2qOD0djYH905BO480Qw8upiEGJDj0z3kjFFeUV0YyL9lsAFuNnqPHv/TzAN3cuQiMJ/W9GbzCHWjHkrPkYIy7jy1F4l2r2WExoLDM/AuFuq7CRJObEulULqelcKXtnF/5X1a3FMZI4mNN/V02sT5iLB6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=muiIPnTZ+tSQD2I/AtruqC8JIIYc3Rp4ZNjx9BntVcY=;
 b=yDOvG9ATAlHm0KG3wbRtCKQ0n4DoBNz6azVRIVjbacrWRNsq4Nkgy+M/tQ2xYlNZ10ZYT54aQN97NQvMrey8WRoQTKflBTgnC1TEgvvYAKv7Sn5faJbwWzFVIuSgvses3b+TcBCW+bkG9lTy0RbOyH/OAqJ1ZPSjMiXnffjOWW/tu/ak50tzhTd5LklNOk02uU44PKmqr6rh0S083a20t1zBsS0ntFzm/2huHW70MIPMRJvJEMOhTnD/SgI+C/JE/lObpBCLjg2glC5FmqUVHx0Ulvxw6ElYZycR8VTL6rQkhATrjvhwGW3X74YQV/mv8Wz1KArHvNBtyrSV8tX4eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH8PR11MB6877.namprd11.prod.outlook.com (2603:10b6:510:22b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Wed, 4 Feb
 2026 07:41:43 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9564.016; Wed, 4 Feb 2026
 07:41:43 +0000
Date: Wed, 4 Feb 2026 15:38:51 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>, Kai Huang
	<kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, "Vishal
 Annapurve" <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>,
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [RFC PATCH v5 06/45] KVM: x86/mmu: Fold
 set_external_spte_present() into its sole caller
Message-ID: <aYL3izez+eZ34G/3@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
 <20260129011517.3545883-7-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260129011517.3545883-7-seanjc@google.com>
X-ClientProxiedBy: SG2PR04CA0154.apcprd04.prod.outlook.com (2603:1096:4::16)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH8PR11MB6877:EE_
X-MS-Office365-Filtering-Correlation-Id: cdc917ef-d816-4713-b28d-08de63c0d75e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?jWgs6wO96Pcycm4cQ99F/ytjw0eKDuNj8f5gQqPH30cqrSSQgiWvsH0b4U9r?=
 =?us-ascii?Q?uWHmTZuFX9M6najoDCl+3Cyoi57l/qopyp3oyMssatKxe6z+luuNRtFEtNvl?=
 =?us-ascii?Q?P9ZOkzLn1oLtfLRVYSQp5HwlRlcknRSa6BXRxaeTsQS4OzkD1OfQrkibo6T1?=
 =?us-ascii?Q?cdfuunWjmDD+slBRufuiKoIb8C3tb5UKW1oXXit9/qrtSpr4Fg3H1380gn99?=
 =?us-ascii?Q?xGtWw75/UGmBKqCKeTOSbKGB8QPry82EsnvMGXMvGVfnMnXjnwnlmm72ENDE?=
 =?us-ascii?Q?qzp4dm8IzK3g4ETwrR/Bvr4LY11TRc4FUPnWhkE9h6CX7IsL9/E3p8Lb6umr?=
 =?us-ascii?Q?MqcAt6UDMjExZRJeSGL8e+mW8pmlhMFRk9cnz/K5d72dI8PxECR8GzcD0Wbj?=
 =?us-ascii?Q?rJQL0xVETBaMRM7hbBLDpNq7RRFX+PCTQh8Ut7Qh3HqYAszcxuHy/2xFItYl?=
 =?us-ascii?Q?pW4xzFmdP1exItD9U4ouSIQSt5Qc267gihxRfoRHP2fwpvMJ1O4ap4hjY3DW?=
 =?us-ascii?Q?pjFUsCKN9MoIV2hsEEZu9mn0yAImo1XMtU0hM4FQpc+6MGmsl9FlOTdMRRi5?=
 =?us-ascii?Q?LsLjhVHp3oozUt/Vp4R+eb12/snfa8bg/zGUc3svXxv8f1ZUDaMUbBINwf0m?=
 =?us-ascii?Q?VmYcrNggtZj23Jx+qM/iFt1TuwyOfMr24NAttEwAVXz5EhMk/V9I0pK5p0rI?=
 =?us-ascii?Q?PpGtQWF0oXxxQhecHh+TLm3dWnTOT53Fs9V3Zso1vzeUPVZ5pWpl/S+YsU0b?=
 =?us-ascii?Q?PCU1GaUhBVsdW60Oy1ApK6s2+V0q0TfnDV0QsMNIVHaIl8PJsfygPowo4PnB?=
 =?us-ascii?Q?/Xgk3BiCo1DVJhsmMEciDeI0NQkyOaT+OYo8qJQ4n6OZB0I+QXmrhAYbA3+E?=
 =?us-ascii?Q?y/RkQ0WeOD7uGk38pOaV1fE1A5lYx6L1JtqIBrMtneHsy/CdqNNncrXw5NlA?=
 =?us-ascii?Q?OL/HmDFWziJbRDAKQ/JWHrmHcyOCiRUbArDgUxqsnE7eF9CPTlfE7imOEXb+?=
 =?us-ascii?Q?eBg88PJ9/nHtPiHokdBPMkt6EjrO+qr4cxE+yOZ2Ei/FS6tZwRdE+t9j7U6a?=
 =?us-ascii?Q?rBIF8zJu2D+RAD9+1lv1KquaY6KxGp8FcMXWfuAwvuWNOjVGetmZuhzFx0lU?=
 =?us-ascii?Q?oaUT5r232WgF3l/K42XaPYCLZyeC/jrUsLGM8udEuFOgz5KhypHkdKT+opeA?=
 =?us-ascii?Q?E2BzLCyyCfplZsNxeKr9l45bBT042mPKCAC+ZbnP8MrCMP3n0KdlZkwythgf?=
 =?us-ascii?Q?XE0XYKRHhZg3dzfJPGrKE8aop5/NWUqcEAXsp5zH7K5AsNLg6pg5kVJP1lQ6?=
 =?us-ascii?Q?QQLl9wQSXoDB1SoYnQpx4JEElwFwHmhTE0Ky88hB0YD9zLnJlX1CJTSJJGir?=
 =?us-ascii?Q?MSjHKts6zk6xFV7VDwogwnC6Sfj/yszyjzUFAWoLpUCH8maaiWKmsZXS1jeI?=
 =?us-ascii?Q?vpQ3B3G7hOPvSPhFaJSmDkVBBS5PWosAGTmhYECvb1LPLFCI21AAB3QlF65k?=
 =?us-ascii?Q?2T5uqU/LjTeRFMhM9f9wkOh+bZaBgCNnZ7dO6EL5lCzmpzxpnhXj3bnh6gUe?=
 =?us-ascii?Q?mYzTKZHOKkQBX9GDf7k=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M85O1d8MBS/zXdiadUd6Yanm8FQKn118w2OJv1y28mlPWePQCZ0OS0U+IYGf?=
 =?us-ascii?Q?/NLJe/Hc7gEcZFO4WeasrWgnbfugc1DN/dUTwkY6mx+hMYvK93/4lwHAfkO4?=
 =?us-ascii?Q?6oKfWDSBzmbe+u/xbnJSbY/hBU5kUXAVMZRwNyPPa0fCp63SfJJcczd5sIA9?=
 =?us-ascii?Q?YHvfjYwgmgAQ4CVmK9Ykx+Mo2ltuqjG+Vhls56bK32dj79aDknrsUb13/s/+?=
 =?us-ascii?Q?/dGXnbUtBembatb4q2GvjsAAIPjGUWqsPsygYU6/Y0bI3m0kjz1anDuAS8+f?=
 =?us-ascii?Q?0KN1OhQ0/iT2IJwEcHijE4SiVqBiY2MTJTFrpzgvwpyF5W2viKLrs9alb4Ey?=
 =?us-ascii?Q?/TvOoSzaxc/h0dsbe9eI3J7kbxO/8IbhxeB0ARuqBos5pkrQraRDD+vKPjUS?=
 =?us-ascii?Q?NOSItL6ZwSaTvrAIq1XcQCyeO/LQpqBcb9UQoEnfJ+whql0BtwoH4/lxZw6O?=
 =?us-ascii?Q?dt65rbr6Mk6WKW54lMDhj15XXqDAUOuChF5xrVAvw22fzo/5bkSCLkWG4ViE?=
 =?us-ascii?Q?XM55irrR6qzu+XsFPMlBsNIg+a7wXIr8gd0yNEclcNxYEwEOidOoozy3zdx0?=
 =?us-ascii?Q?GO0msCGFt+Vxh35yHAieWbwNKtMUlzTQeO8dp9x0DTcxpg9N0tw3R4aB4ewy?=
 =?us-ascii?Q?6gKXOhPKsxtcOS68Oh2D4jR7B4Jyc43/lpnbnG0qwarhA/u5MjxbVwL7w/xq?=
 =?us-ascii?Q?HxPMsNw4Bh1ttJ4lFtWvuyWkOUZGF8hHDpV/mLnsHohvNwip4m4UF7GFtV6m?=
 =?us-ascii?Q?N277rwvuob2V5URQ/ISFBh2Xw+3CiPDfVpEcjccVPXvtxj/2uLOTcaQ4HTO6?=
 =?us-ascii?Q?erG74Ht2C49nJac3BcHsQbZWGdQHSMoVFEGiyVRHFWFjSsbMGi9lmfVPTzMO?=
 =?us-ascii?Q?9nZb/YJXJPotM6KppjAz3COxBm8l6+NOMLyqT/na2xeWiVa62Q4s+hMClbWb?=
 =?us-ascii?Q?BJ5yBFFRSZcWLDUwfQJvle4hw4oDFm9OISB7vdzs6uYHvYioFt3Z53TFhxn5?=
 =?us-ascii?Q?6LA65ZEWhNNrRR/j2uZIMIRFN6SAuvYYbjHVZbE1DVrktXwvOxrEx419YcrJ?=
 =?us-ascii?Q?pJKSsUIzQDyagGMDGK3VTfe02X0zIUaM/S4x0jvsFQDbAF89MEfmS+sGJF2t?=
 =?us-ascii?Q?Va8uoBKW2D4MgBdZzPovzmoWUpT/DojQFmm1Ax65iq7aOVt6JiNZONs/wMar?=
 =?us-ascii?Q?irnnISYdjwBAYFXiYxT6hJkIpeHT1mdBNsPuMWdn3veL3Xb9rudeNUCdQDBi?=
 =?us-ascii?Q?yckwbEPnnTVccGOSnrS9+V+dqH+ZRSbWo3AvlqCyLX6gvE0OUW+zCl8fcf6C?=
 =?us-ascii?Q?A0r3qjbQsIYJqh3lX/RU8KD4w4bbK9iUe9OPBk0ouPGNd+1kmHBnjjmlZCZ2?=
 =?us-ascii?Q?ommihSLE52DVbfl+MmkchmfFHp9W5UFvK8PtMCBSlERFxcNiRmDQGrsf6Q9e?=
 =?us-ascii?Q?yHJ9YgKQjXjpEB5QDdDqrsBmgY4E71tThdTvg+baQNk4jpj9/mxwGCESK3i9?=
 =?us-ascii?Q?2ZQo5bwORIzAIR9JkRU1yztkt2wYL4xVfyLelkV1NGGHheO6jHJ1JVybJuoi?=
 =?us-ascii?Q?gsXoTjWNkd2THHpJrT/InOPvCFvee8FUPAEG2ZJnRsDqDGX0J2Jwik9wqYRu?=
 =?us-ascii?Q?f+3IwZPAjNIWXrsCmZ70Xm6dgQ5ZoQqO025ktax1ZdH6XQaBh4b70IIgqTXL?=
 =?us-ascii?Q?DUkRuvj7PfnKcz1aKxpwLR1iirIv5Ky76uYOFrN7jGKs5lEja0mbPLPbAmxy?=
 =?us-ascii?Q?c6PdXa3LKw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cdc917ef-d816-4713-b28d-08de63c0d75e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 07:41:43.2851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GlWAkbDnkKe5gdQKwh+DeRSjxb5VYV05EgkPQyyBJq5cMJDu5VFFQaEwkRgaYa49DqslH/P5mDHQ9I7wIyNLLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6877
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70144-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	HAS_REPLYTO(0.00)[yan.y.zhao@intel.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yan.y.zhao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 1A26CE2C52
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 05:14:38PM -0800, Sean Christopherson wrote:
> Fold set_external_spte_present() into __tdp_mmu_set_spte_atomic() in
> anticipation of supporting hugepage splitting, at which point other paths
> will also set shadow-present external SPTEs.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 82 +++++++++++++++++---------------------
>  1 file changed, 36 insertions(+), 46 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 56ad056e6042..6fb48b217f5b 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -495,33 +495,6 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
>  	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
>  }
>  
> -static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t sptep,
> -						 gfn_t gfn, u64 *old_spte,
> -						 u64 new_spte, int level)
> -{
> -	int ret;
> -
> -	lockdep_assert_held(&kvm->mmu_lock);
> -
> -	if (KVM_BUG_ON(is_shadow_present_pte(*old_spte), kvm))
> -		return -EIO;
> -
> -	/*
> -	 * We need to lock out other updates to the SPTE until the external
> -	 * page table has been modified. Use FROZEN_SPTE similar to
> -	 * the zapping case.
> -	 */
> -	if (!try_cmpxchg64(rcu_dereference(sptep), old_spte, FROZEN_SPTE))
> -		return -EBUSY;
> -
> -	ret = kvm_x86_call(set_external_spte)(kvm, gfn, level, new_spte);
> -	if (ret)
> -		__kvm_tdp_mmu_write_spte(sptep, *old_spte);
> -	else
> -		__kvm_tdp_mmu_write_spte(sptep, new_spte);
> -	return ret;
> -}
> -
>  /**
>   * handle_changed_spte - handle bookkeeping associated with an SPTE change
>   * @kvm: kvm instance
> @@ -626,6 +599,8 @@ static inline int __must_check __tdp_mmu_set_spte_atomic(struct kvm *kvm,
>  							 struct tdp_iter *iter,
>  							 u64 new_spte)
>  {
> +	u64 *raw_sptep = rcu_dereference(iter->sptep);
> +
>  	/*
>  	 * The caller is responsible for ensuring the old SPTE is not a FROZEN
>  	 * SPTE.  KVM should never attempt to zap or manipulate a FROZEN SPTE,
> @@ -638,31 +613,46 @@ static inline int __must_check __tdp_mmu_set_spte_atomic(struct kvm *kvm,
>  		int ret;
>  
>  		/*
> -		 * Users of atomic zapping don't operate on mirror roots,
> -		 * so don't handle it and bug the VM if it's seen.
> +		 * KVM doesn't currently support zapping or splitting mirror
> +		 * SPTEs while holding mmu_lock for read.
>  		 */
> -		if (KVM_BUG_ON(!is_shadow_present_pte(new_spte), kvm))
> +		if (KVM_BUG_ON(is_shadow_present_pte(iter->old_spte), kvm) ||
> +		    KVM_BUG_ON(!is_shadow_present_pte(new_spte), kvm))
>  			return -EBUSY;
Should this be -EIO instead?
Though -EBUSY was introduced by commit 94faba8999b9 ('KVM: x86/tdp_mmu:
Propagate tearing down mirror page tables')

> -		ret = set_external_spte_present(kvm, iter->sptep, iter->gfn,
> -						&iter->old_spte, new_spte, iter->level);
Add "lockdep_assert_held(&kvm->mmu_lock)" for this case?


> +		/*
> +		 * Temporarily freeze the SPTE until the external PTE operation
> +		 * has completed, e.g. so that concurrent faults don't attempt
> +		 * to install a child PTE in the external page table before the
> +		 * parent PTE has been written.
> +		 */
> +		if (!try_cmpxchg64(raw_sptep, &iter->old_spte, FROZEN_SPTE))
> +			return -EBUSY;
> +
> +		/*
> +		 * Update the external PTE.  On success, set the mirror SPTE to
> +		 * the desired value.  On failure, restore the old SPTE so that
> +		 * the SPTE isn't frozen in perpetuity.
> +		 */
> +		ret = kvm_x86_call(set_external_spte)(kvm, iter->gfn,
> +						      iter->level, new_spte);
>  		if (ret)
> -			return ret;
> -	} else {
> -		u64 *sptep = rcu_dereference(iter->sptep);
> -
> -		/*
> -		 * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs
> -		 * and does not hold the mmu_lock.  On failure, i.e. if a
> -		 * different logical CPU modified the SPTE, try_cmpxchg64()
> -		 * updates iter->old_spte with the current value, so the caller
> -		 * operates on fresh data, e.g. if it retries
> -		 * tdp_mmu_set_spte_atomic()
> -		 */
> -		if (!try_cmpxchg64(sptep, &iter->old_spte, new_spte))
> -			return -EBUSY;
> +			__kvm_tdp_mmu_write_spte(iter->sptep, iter->old_spte);
> +		else
> +			__kvm_tdp_mmu_write_spte(iter->sptep, new_spte);
> +		return ret;
>  	}
>  
> +	/*
> +	 * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs and
> +	 * does not hold the mmu_lock.  On failure, i.e. if a different logical
> +	 * CPU modified the SPTE, try_cmpxchg64() updates iter->old_spte with
> +	 * the current value, so the caller operates on fresh data, e.g. if it
> +	 * retries tdp_mmu_set_spte_atomic()
> +	 */
> +	if (!try_cmpxchg64(raw_sptep, &iter->old_spte, new_spte))
> +		return -EBUSY;
> +
>  	return 0;
>  }
>  
> -- 
> 2.53.0.rc1.217.geba53bf80e-goog
> 

