Return-Path: <kvm+bounces-29898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4A0D9B3CFE
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 22:47:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 088501C22390
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 21:47:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8952C1EE001;
	Mon, 28 Oct 2024 21:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X+DqSovk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1609B18B03;
	Mon, 28 Oct 2024 21:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730152021; cv=fail; b=Rvw36BuYyFAgeVzZBqcRZ19/YkyZngzqPbkWpnaq5phFKh9UNnsQrftDkCYNkNq+FSnkYvFtuYgs/u9OFw5vlJtHrfLOfgeVyA+5B5+25MKtDt9QqP8B/+SGUBzeUyfudYk0F9KzY1o1oD655kc9AgXSRYAVTj2shuUKQGr+qZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730152021; c=relaxed/simple;
	bh=+pfOR6UMT2eGb+YBBgi/z15t8jRWkuClBogCuPMHofo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=k0hEiVnVV3lsne9PKaSzxwKT4/PpDNH2aK0FbtAqCx5t8t9BCkhSzwOIUm4C1HqB9+UFYPN2uVJTJiAyvBd+ovMdYy6reyrWnbCRAkCD6fRCf6Gpn03qvRKpS2bxnh9JGY/KtOXHT7qKGRMIUnUnB1/yXi7x/q1kUuVjxJ3QrKQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X+DqSovk; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730152019; x=1761688019;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+pfOR6UMT2eGb+YBBgi/z15t8jRWkuClBogCuPMHofo=;
  b=X+DqSovkEN01uTKi/XtzhLKwIPpIg+LDAu+WbL8zUbXOYJt48juLn9Hp
   QaLpCVZAXMP9y+CtFptRuRHdqbw9pvtEkan27TXvAowZo5GqbAhkigQbj
   uaZIEuz90dplZBTuN1yOnqb5VVKvGb9xM3DsuWEdWqN+aLCxSeI6O7ztc
   XpLaxvr9Zj2odwSa9ZiYqY2ubCRbijs6g7M3SFXnUVCzPpnCvWPMyoQe+
   tPGmWKARiK8wNFQUoTg1t18bbagxc7rxD0bio1uARChZJxnZuGgCYdb3U
   q3xu+Ct9qUJ0PlosE5aRefSfD8fyEkY3q+meq0BFK016F61wA+9VXrigL
   A==;
X-CSE-ConnectionGUID: IA54t4bXQS2rVr5kURHhuQ==
X-CSE-MsgGUID: wRred3tNTk+yzLLVwR6CUw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="29911549"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="29911549"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 14:46:59 -0700
X-CSE-ConnectionGUID: iDIB63HzRFmiRwtm0Hc5DQ==
X-CSE-MsgGUID: 7I/mPazGT/24SRU9ag9yOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="86495055"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Oct 2024 14:46:58 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 28 Oct 2024 14:46:57 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 28 Oct 2024 14:46:57 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 28 Oct 2024 14:46:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tp8pkDRyWQHooIyOXU4eJcfQr18Lu6PvHdeLsueXgx4fytDhTorl+O/vhLUlrfHnudzdpHDL68K98KkXP0jKKzcY8+3rpSJfzQIjUQhNClqUEQmn13et9uvlm7Qf1OCvAnNd7BwIkyLTxRzRYeudipdQdepk1ijAmkrVzoZR8vqA6Rwj0S/BCRLkSLFdt3HralKtX5Nm9kZPew0Xl7+uJMI5+ufr1Eu53ZvLq9Jg1qikpJLrYChX+L/wmaAv8fgwEHmYR6qrgZAydfZEYwESH1bG//NCaduo6/t1ZO74XwORkARL/GgVZ+Cr2XD25sdKRLLHgKJRzOZ2uMu08a3+Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zk0pnZNbLRagr1fECLnlTjwRH0UPUji0mB888HJ6wGc=;
 b=xQgb9olL9X+0G4KDsLv2msNj1e9AYNAXDgf6PsGALQ/aIhm+sR7Y8eoDaDkytosNwj5lNnX6ZOiI12NeKdSmZjibiRia2LlbcVfeCan9eEkR8nvDc7oMmn4V6RS7rdQEmPFKiG7gf/12SZz0LeLUFntRZ+RRxa2CJUfCUi8W0b7cxUNinVLpgsScvNasUb9LeINyjVkMrWc3nOSsFe5De7cF+MEe1NgykVaztHl0VlNGlUcKf1p/Jra3gEAPsw/8Olzg1Fl/N3yvyKvDRbEni5Tgd7XxTqASDWdS+qcpGxUsZuiUTi//md/CO8tQqRelOhyCDsYxwYYDDs/IOnDUwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SN7PR11MB8264.namprd11.prod.outlook.com (2603:10b6:806:26c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25; Mon, 28 Oct
 2024 21:46:54 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%5]) with mapi id 15.20.8093.018; Mon, 28 Oct 2024
 21:46:54 +0000
Date: Mon, 28 Oct 2024 14:46:52 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Kai Huang <kai.huang@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@linux.intel.com>, <tglx@linutronix.de>, <bp@alien8.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<dan.j.williams@intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<adrian.hunter@intel.com>, <nik.borisov@suse.com>, <kai.huang@intel.com>
Subject: Re: [PATCH v6 03/10] x86/virt/tdx: Use auto-generated code to read
 global metadata
Message-ID: <6720064bf2c69_bc69d2947b@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1730118186.git.kai.huang@intel.com>
 <8955c0e6f0ae801a8166c920b669746da037bccd.1730118186.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8955c0e6f0ae801a8166c920b669746da037bccd.1730118186.git.kai.huang@intel.com>
X-ClientProxiedBy: MW4PR03CA0324.namprd03.prod.outlook.com
 (2603:10b6:303:dd::29) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SN7PR11MB8264:EE_
X-MS-Office365-Filtering-Correlation-Id: a1c732fa-9e58-4ad3-0e3d-08dcf79a0a29
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ISvcBWZj1TlCMS7BkGEo//B3Q5rsFCzyc80sd2zXvvcsI89evZLmsqVW9Pto?=
 =?us-ascii?Q?pAhlt0Uj2ZE3PuRl9g2rrxNPXZ4PwasjLC7w06Po6z/9/qR5+uBW8EBgWk5h?=
 =?us-ascii?Q?02PhfrC4cDMZ0vG2gZUYQG3Dqii4d8UoCN87AUbA8nKuxVyln+q2oaiyrYnL?=
 =?us-ascii?Q?m6gry62k5MioE8v6kGs04OAFjRJvlVE25OMhzBD5mphfFZV+wrSLoIg1zYEd?=
 =?us-ascii?Q?pL3bmK3muHYxZOCUHlGWUmzj4f1MzRrDQqbJ11+K5+PUjgiwNAu3Dra954Mk?=
 =?us-ascii?Q?RMf4s1U2XIaE+hLkCNv8bMXRXZEEkvYIkGMsoUlY6DpHNi49++4FyDrOTx5Y?=
 =?us-ascii?Q?5Wv6SypSeU6YVmKrV2vAd547/5bSRMCwWu9NMzOqASALgdXeiJiK4rgT/mil?=
 =?us-ascii?Q?bpC3I3m4t/L/yJ1uZc8DKlP5loXY0uQcqx3dslqCQnjoObEJOUVEQHJsb/N9?=
 =?us-ascii?Q?cjtqEE3lcc9tI8pm2ho5eRDdKsLu3bQ+OVzbwcAzNOSzorXeIutT4GAnB8jH?=
 =?us-ascii?Q?bQCts8G8UZp4lWbyfE/b1HPeC/NVRT0hiWS3i+r+5aGF+dRAw1u5fGqouhnv?=
 =?us-ascii?Q?ir/4fVVd6pRVW5nlr9q2oeZPOk/R5X+Gl6Eh6LNvLQq9FF66pSriDcDBeZ1N?=
 =?us-ascii?Q?+30NCI2Rar07hdRY9DeqAsqjAXxXU48VCAk0k1cfV6XIic3cx6p5Ese3oeo5?=
 =?us-ascii?Q?1qiDou/6eHOw6MRLwZhgfBYRne0FncLVksTag3IlMGsTeq+uVKP2jaSjQHBq?=
 =?us-ascii?Q?6VboART8gsLYYWtsO4ilPtdIh58V7fcOaErsdmJBwGNMJpIRAh0iyxhc4fZF?=
 =?us-ascii?Q?3e48/vpeyhpqqMPzvcYSfIT0avoLT9JCLM9t685CSr32dwqFFzJ5jvEoYNWh?=
 =?us-ascii?Q?jYcy4AxJ1HFPORuIjbvbQkipuhrY/AODDtFXhdjsl8Tp+Emg1O6E3D/zb4ju?=
 =?us-ascii?Q?/czxMCZrTbZhrLThJMvIm4NQYy1kQx7bG210NyUpAP8iRVGhQNXZtUCRTV5R?=
 =?us-ascii?Q?iwtQroABhRpHlOUaApgQZmcb30PCqpTjKVxi1Hpf0lAYhTQtqDCRDv9PA7Jc?=
 =?us-ascii?Q?VdYjBsHcoC1riG9qe4xlue92jAeue52o069Mw0wFn010nun8zj+D0jnBCKCf?=
 =?us-ascii?Q?GrB5vzT6Le+TMXq5jjACUJpVSksBHDvwJ4ucGiqYIII6mB7hFdLn78OikQcm?=
 =?us-ascii?Q?QNHpy0uUE6fgM6KwyZxEvY01aYYKV9veVC9lXrxuM0hueKga+IzmyCgWCSUf?=
 =?us-ascii?Q?a6OJJiXCRBUnb0qQ2RhA4h2QHABstyrQkjntJMBMJrfGFllGg+FRLPB8gyYd?=
 =?us-ascii?Q?v3t77yhgQdmGNAueqiFiimXl/JsQtrhdR/CS62zAp5czLjXwo8pR7Ed20Zzn?=
 =?us-ascii?Q?yv6DSlhW7/1GNugtT5acNz80XHvn?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Nu9tiZpz2T3Cjud1YatT1eEDUkYbrunpaLkN2pxynxmSVjFlQlPT4j9k0Tlb?=
 =?us-ascii?Q?hZm1/8dTS/ups2vZjN3cM1Vr6+Je3P9wu7Fsk8wS+7hdEPhCK4hg4bYPrN4D?=
 =?us-ascii?Q?FmZh7a3Z4sKPylotKgXKOZyTB+1P2v+DoIGe3L0dWvyK3TEddIIEQbO8CG5X?=
 =?us-ascii?Q?9tV9JP1yvtDvGUd4rVuxjHBvEGzNJMgMCSnkqXi73Hc8yy2as8gXsuYRkKO2?=
 =?us-ascii?Q?s69VenfuZl25cJxKGoJ4E2Eomq8ly5mzrh5yDH0vCaOJmblNqkSuaw1JdqwI?=
 =?us-ascii?Q?gytpohuEzajoH9CLKhzEWhZQVxaATOf+nonf0EkYYvi/tytqAQvy2pRb6Chj?=
 =?us-ascii?Q?1S4bJBw2FscGpB8hp3a+vAYzD/o/SALkUYzEXECkOtHP6cLayzlfrxNqVE+E?=
 =?us-ascii?Q?qHm2PkgAz0CJXkAL6mT5xff/cnyDpQ4+xvUZ9vImT20Tear80KgYG2S//PSn?=
 =?us-ascii?Q?yK0wcvzCvvmSBqgqxi47hwt0g30sj2ziYvLpD1sJNvKDhFrvyA83D+5plhp/?=
 =?us-ascii?Q?84697dLKXkcalvozKPO3En7mgH1IEH6I75j2fJCFwtXAhSHh0BwBFHkcOlze?=
 =?us-ascii?Q?SlS+mBBp5ztqtgPmxsJivKkItHY4JHWvfS0ptDrKfmN2nyGkKgO8R/10V4Sg?=
 =?us-ascii?Q?GFssB+Yea4dE/iyFs2VcAW3Rc44NP+j+yyE7O+OFRkH09eX4ChKCa6TQg6x9?=
 =?us-ascii?Q?+6vmJuvfXTueg1gTVLxF3GjVccI2y0CRoQTBtCSXcodOtO2bDIeA0cxOxZst?=
 =?us-ascii?Q?vJWJC8RJVvN6J36G+oTP2poe+1TRE6ZKM12R8C2CiFKDclB8X9suVfY6FhXy?=
 =?us-ascii?Q?HW8roJM0+PlHJRXqOjdQzb8Vf1O5AB93Q1q2BnOMBD4Ptln34tMdy4Sh+8l2?=
 =?us-ascii?Q?7q9uar3riKxuK0bddJOaynnypuqivZ1mDYCQwG5kG9jYS3xVbJV2eimf4Io7?=
 =?us-ascii?Q?uUsqSxnXY0jmkgRcSoYwSqF1FnhYaTPRrCYTLh84PKwjUtEwX7j7P3sthyjp?=
 =?us-ascii?Q?y7KK/6UUzp4J4RQUv0XHCkxMTgikIVVKDzN5q33oW9QDzqcx/hi7a6KTchku?=
 =?us-ascii?Q?6IUM3RuyDDx6QLhkul6p5B+e/win45SqPp2DegYFivfLTrPYw8mP5iUkKkSn?=
 =?us-ascii?Q?Wd7i+55XYx8SBRt/n2vmx0Uca/656y6SRsL4ApJdxZcySMqNngGyh8QvNSgZ?=
 =?us-ascii?Q?gyVA1PDRiA0IvwWfTSvbnySGGKaloAoeRdiAtcl/vr2V13+dOjiUsk46+I8D?=
 =?us-ascii?Q?RQbxAagXfWqBXfiEA0qEJ86CcgvOqR0GAEO6z4WsBC2Ax6Wgf/v2QPtwC5cY?=
 =?us-ascii?Q?nLtezaLsC5JELqk/gtUDLxZyxI0Ya5VivkJChrc9osQXDm8bIPiZvHVKSY6f?=
 =?us-ascii?Q?f/SmR7eSx0TEPLPKxNNbq5A5cDtS8aRBQoi9brWoJU89Xbfvy9PNAtOWvmuI?=
 =?us-ascii?Q?sMXpIUWuiiIlzYyRwqBCkjsM/ANMhmRy1xOOEeMLd/oGwFM6ElTSkboRP8Qg?=
 =?us-ascii?Q?GdCiOMvor3OC9R37kBBiQsc6WUuaycovHg73ZtG7e0YsrsXqsGTzfTyEGCsW?=
 =?us-ascii?Q?1fAeWuf6zG7ZtKm9yC2Sl4xX8VBOwCNc8bp9tp6CW1MegA64exCfF5tSV1EJ?=
 =?us-ascii?Q?/g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a1c732fa-9e58-4ad3-0e3d-08dcf79a0a29
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 21:46:54.8688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +MB5ZdqcprRPGEsF57EF0TesFHZSTH1/tMFJWJoLyV3fjXrDOX9HOfU9NJ2bm9On34NiBTrUgOLqXX/Vc5pFR4BX6tV6DxsDasviDXo4bzQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8264
X-OriginatorOrg: intel.com

Kai Huang wrote:
> From: Paolo Bonzini <pbonzini@redhat.com>
> 
> The TDX module provides a set of "Global Metadata Fields".  Currently
> the kernel only reads "TD Memory Region" (TDMR) related fields for
> module initialization.  There are needs to read more global metadata
> fields including TDX module version [1], supported features [2] and
> "Convertible Memory Regions" (CMRs) to fix a module initialization
> failure [3].  Future changes to support KVM TDX and other features like
> TDX Connect will need to read more.
> 
> The current global metadata reading code has limitations (e.g., it only
> has a primitive helper to read metadata field with 16-bit element size,
> while TDX supports 8/16/32/64 bits metadata element sizes).  It needs
> tweaks in order to read more metadata fields.
> 
> But even with the tweaks, when new code is added to read a new field,
> the reviewers will still need to review against the spec to make sure
> the new code doesn't screw up things like using the wrong metadata
> field ID (each metadata field is associated with a unique field ID,
> which is a TDX-defined u64 constant) etc.
> 
> TDX documents all global metadata fields in a 'global_metadata.json'
> file as part of TDX spec [4].  JSON format is machine readable.  Instead
> of tweaking the metadata reading code, use a script [5] to generate the
> code so that:
> 
>   1) Using the generated C is simple.
>   2) Adding a field is dirty simple, e.g., the script just pulls the

Probably meant "dirt simple", but if this is fixed up on apply I'd drop
the idiom and just say "simple".

...don't spin the patch just for this nit.

>      field ID out of the JSON for a given field thus no manual review is
>      needed.
> 
> Specifically, to match the layout of the 'struct tdx_sys_info' and its
> sub-structures, the script uses a table with each entry containing the
> the name of the sub-structures (which reflects the "Class") and the
> "Field Name" of all its fields, and auto-generate:
> 
>   1) The 'struct tdx_sys_info' and all 'struct tdx_sys_info_xx'
>      sub-structures in 'tdx_global_metadata.h'
> 
>   2) The main function 'get_tdx_sys_info()' which reads all metadata to
>      'struct tdx_sys_info' and the 'get_tdx_sys_info_xx()' functions
>      which read 'struct tdx_sys_info_xx()' in 'tdx_global_metadata.c'.
> 
> Using the generated C is simple: 1) include "tdx_global_metadata.h" to
> the local "tdx.h"; 2) explicitly include "tdx_global_metadata.c" to the
> local "tdx.c" after the read_sys_metadata_field() primitive (which is a
> wrapper of TDH.SYS.RD SEAMCALL to read global metadata).
> 
> Adding a field is also simple: 1) just add the new field to an existing
> structure, or add it with a new structure; 2) re-run the script to
> generate the new code; 3) update the existing tdx_global_metadata.{hc}
> with the new ones.
> 
> For now, use the auto-generated code to read the aforesaid metadata
> fields: 1) TDX module version; 2) supported features; 3) CMRs.
> 
> Reading CMRs is more complicated than reading a simple field, since
> there are two arrays containing the "CMR_BASE" and "CMR_SIZE" for each
> CMR respectively.
> 
> TDX spec [3] section "Metadata Access Interface", sub-section "Arrays of
> Metadata Fields" defines the way to read metadata fields in an array.
> There's a "Base field ID" (say, X) for the array and the field ID for
> entry array[i] is X + i.
> 
> For CMRs, the field "NUM_CMRS" reports the number of CMR entries that
> can be read, and the code needs to use the value reported via "NUM_CMRS"
> to loop despite the JSON file says the "Num Fields" of both "CMR_BASE"
> and "CMR_SIZE" are 32.
> 
> The tdx_global_metadata.{hc} can be generated by running below:
> 
>  #python tdx.py global_metadata.json tdx_global_metadata.h \
> 	tdx_global_metadata.c
> 
> .. where tdx.py can be found in [5] and global_metadata.json can be
> fetched from [4].
> 
> Link: https://lore.kernel.org/lkml/4b3adb59-50ea-419e-ad02-e19e8ca20dee@intel.com/ [1]
> Link: https://lore.kernel.org/all/fc0e8ab7-86d4-4428-be31-82e1ece6dd21@intel.com/ [2]
> Link: https://lore.kernel.org/kvm/0853b155ec9aac09c594caa60914ed6ea4dc0a71.camel@intel.com/ [5]

Just an fyi, that lore accepts the simple:

https://lore.kernel.org/$msg_id

...format, no need to record the list name in the URL (127734e23aed
("Documentation: best practices for using Link trailers"))

> Link: https://github.com/canonical/tdx/issues/135 [3]
> Link: https://cdrdv2.intel.com/v1/dl/getContent/795381 [4]
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Co-developed-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>

Looks good to me, with or without the above nits addressed.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

