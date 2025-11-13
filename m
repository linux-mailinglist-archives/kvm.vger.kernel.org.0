Return-Path: <kvm+bounces-62965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F629C557F7
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 04:00:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5201F4E1A72
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 03:00:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28471264A92;
	Thu, 13 Nov 2025 03:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ExChM6hS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329E435CBC5;
	Thu, 13 Nov 2025 03:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763002829; cv=fail; b=kdGBSiahkX3bVnbM1FV96tGvYLZD/AVl+pwJ33wafIKDWVkYM4bhtiv4EZiOho6CSXaLrrTNWsMKKu4+/mYTNeHwA8MmzlDuKxb81Zi6eHlkJxxOZKSNri9I0SSp2cJSWCTVAA9w7vgEX0n/qycTAbR3q+3LlZ66zF72XVqHE7s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763002829; c=relaxed/simple;
	bh=LeDJab/p0tXfyPQUbSQpSS5fALZTju9J5Bl2g4G3yWU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gsqLT1p5SvodMblrCKHDEb+1IOyMxFkfo7i6Tqf8anwRzfGmcJvOW6dz7R+sVgUQYcjAXERUTfAEtv55I8WaMSqJ4AkuymoiyCbARj4tmTO1z5okznBCi6rD+NHh9B1KkPBhLHc98xsNCvfYKZhVX6Suy6NZEkc56lqUQJExSRU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ExChM6hS; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763002826; x=1794538826;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=LeDJab/p0tXfyPQUbSQpSS5fALZTju9J5Bl2g4G3yWU=;
  b=ExChM6hSupiJNF4fmg+KvoMvwm0EQBua99EdLFtV5DxWiZ6Sw3r8y/Ef
   qR0ur0qfhLI3/1iv/I4H31WxZce1tkWuAHVrVN7fms3cv9yAFT0zTerb3
   GXjGxXA21JebIm738I27JoTVmTYcr/9ubbRvJbxUegl7gJImy8lOhjgtH
   gN41VoAPMbng0GCbDc5ywX2wRCfqRPzwNPMgPR9ppG++PtCy2Y0/Kt+lw
   9kLbnomgRRESTI6UJDOevKC/FnH8keCkjtbyq2i15eWND8yhkm3YIov1T
   uJuijBspBgkwyHuHI6Dep+EWy6Xnrz9ZL9ncugHC+ap8AjnCb9no6bx6C
   w==;
X-CSE-ConnectionGUID: BtUE52N+SEmB3JAL5bnLUQ==
X-CSE-MsgGUID: 6m6cpvGfRAW9H4EWILY1Sg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="65001534"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="65001534"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 19:00:25 -0800
X-CSE-ConnectionGUID: juWgU3kFRe63uEZkgtqzQQ==
X-CSE-MsgGUID: n4SnFu+dTnmgbzYax9Jmxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="193508524"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 19:00:25 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 19:00:24 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 12 Nov 2025 19:00:24 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.60) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 19:00:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Oacz+YmNgHNzRY6GUwFUlTDUNGgSn4bRoZdNU1Wr6T+sOEWD5u783/Crm9sqeJ3Y9NA1k0nYWWRLPv8XsP+1I/4Rnu1Mfui+zsOEA+1ddO7aErM7P0tPfoCVtrDsqW+nFDSlDdv38odq97fENJjKWVI5KWa+Bh/TJYzMFZvv/Dhrjq0abk6k0HGRhJZmcwJThLdnyvkrLQ3h3KcZ1UZM2OvJ+ChAjygqs95KeDuyoSuu5g5M149u3wjkDtG8WJ7pJE7tAId1Uw8GrN+eMYcCx2b5Qs6pH/oCF1KH/Bsgsk7NezHXEXjF3sXml0ylBjLshkr+a/Lynj2xNkZcY4v9bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w1tGU98azWWwdtdCcStdENqH7ZxBvwh6u+t5d/6U0q8=;
 b=bBmdQas3iYSzRQL3zj1dsS9CEQGKvd9TcKaMXIbwt2+oikGFRnzJ04z1AsaUJub3dlKRIjBPX9QIs7AFQnXoSTI73PVk1atCg9dS9FDhl1jyVvWQQSaJYIjK6fLJfL9GuRSSUAItb9skarr8soS1PaCKLDu+abFrePzy/1ljDZjx2dJjyeSHyTW/GU0b8qVvAh1E7G4+d8tiBHCxOuU4iL4+cGNkLNW3KwNxAtKebftz9Ktr9MZLzbu9tju2F7VgVmBKeqWTMZP1i7ghdrI9i0mP3VOLVgxZkX0sOGKUR2QcT9cTfFRH+Xll3DeiDjF5SThdvT+JVKmp1ZP9/xCgLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by LV8PR11MB8746.namprd11.prod.outlook.com (2603:10b6:408:202::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Thu, 13 Nov
 2025 03:00:21 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 03:00:21 +0000
Date: Thu, 13 Nov 2025 11:00:09 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Xin Li (Intel)" <xin@zytor.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>,
	<hch@infradead.org>, <sohil.mehta@intel.com>
Subject: Re: [PATCH v9 20/22] KVM: nVMX: Validate FRED-related VMCS fields
Message-ID: <aRVJucn5t5WjS2fe@intel.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-21-xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251026201911.505204-21-xin@zytor.com>
X-ClientProxiedBy: KU0P306CA0087.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:22::11) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|LV8PR11MB8746:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f6d9ba5-f5ef-4712-8c13-08de2260c8e0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?o9ILvGAH9iDffHuTWvuk96ZB7MUAHgUDEWn7UKarC2VuP79A0YQx/uZawP0/?=
 =?us-ascii?Q?NIDyX+QQ5iXg8LCtF2VCHlIxk2zlnLM+LGqRirOEfRAeVjLO3NcITtjB+zjq?=
 =?us-ascii?Q?HhQ2sq6Gx8JnA3qoMUJcN3a28OwhduR8VDhfcPkwSWLdROo2sWzES6AxBKX0?=
 =?us-ascii?Q?LLKUDaHxRo7WGQ2KAkd0tD5vzOUxAyrFED4CmWrvGW54wdM3EJy1yo9whH1L?=
 =?us-ascii?Q?w7Nn9iHoKMqr41Xe5rYeECVErW0PNDnFZx8udnvRi6tAAE4S4IGQke0LIWLs?=
 =?us-ascii?Q?pilLLRw5/2Tc1F6NRxlTxesBQN85r22rJyzx9/kcdnX8YR0wpI0zdhW0muG+?=
 =?us-ascii?Q?fwNn497xp9QooWREDXbZwR/qYqtJw/SeIrKfHmgpw+ZcfCbznlfH9fslekEp?=
 =?us-ascii?Q?wqK2hBxTQ4SPsd+qKDkK90GQfOQuWEA2payXSQiBIVyXfv/EqCzqW9fALAmx?=
 =?us-ascii?Q?wCZW5FF3qepodR1bHGQhIeEY1H8CLc7WEYw4i09nhK2oYLO/hx5xv7EVWbaF?=
 =?us-ascii?Q?oC7f32MCBLgH8ri+7xgPBYGEbzQN6T8igSupGZGRPL2oRVWwH/ER/ro6PAr/?=
 =?us-ascii?Q?hX7Y33iEphQzFR6F26Ot0fDtxWTqWukTqiQiBAzNlVD/E/1zrZpoNQlHBMZk?=
 =?us-ascii?Q?1JCftv391C+PhV83xbMrHLVrhbx528oP1gPcp/IJXqIFRTSXwGLUDunfbsdQ?=
 =?us-ascii?Q?MWiso5GzC6Ctq+6W5kuOe6Ote5R1Tfc337b5t7A/knE58Bv6XeUoosQX0k88?=
 =?us-ascii?Q?sk/iOyWkhGcOJ2QxSxrv07/z2sVk4f/GDvfpsyLe0e4Qt4H/EPuXzhLiljnN?=
 =?us-ascii?Q?JBjfs3URZNLHlxI0x77cBxUSDJ7Ocf37+CbwnLSK90CDWuMbLu+Jj4AWa7BJ?=
 =?us-ascii?Q?yI6jxFuJmK9K7tbCho72IX8SsKYxQjCG6/rTd8ZR1/J/nXl7aq6GwYpo9qon?=
 =?us-ascii?Q?4/OJRT5Ggo1T1pREnO1XHP7NBUpJ73ZQqetgPYZl6lw7dr/HmipofkvWkq8b?=
 =?us-ascii?Q?KJBNt0Xkifzfo5cpA6bMHMDQS9uWgU3pGwpjHQb7+p1pDqxj+EavkSKF10x2?=
 =?us-ascii?Q?K3ScQgUgfRhtO2Yt01Ttie7hwAs6WWuMHiFqeEGsUAda2pEzzdVzaV1RVxla?=
 =?us-ascii?Q?QZ1ziLeYjWHC0e9udPQYeNTcRN+/S7fs2Sv3F4PwZCvvl+qYEw17Y6C0xaIX?=
 =?us-ascii?Q?29sLXFcWwCd/Q0HJgrWBI3dYORuTefYYj++xPYfJBArgBBCWsW5NBSsJF/nx?=
 =?us-ascii?Q?3D4pHZEdENo/aAOo8WMSZA+ENB21bZYUmeorLO/dPy0f2+hkgmZ+17vJFdSx?=
 =?us-ascii?Q?whCK62VUeEDOJLQ8pTMo3O9f3uFxIbYIi954RZNCAj8wBKHcefB3DzCNuLW0?=
 =?us-ascii?Q?lphU53OAkM/Y71gtiR4ahEzZ809Y1ayOpMGLmFMJ0DvXX2B6GyLeW0tg+h3F?=
 =?us-ascii?Q?ubkjWMxr8O/qGKZJ2gK9oPUQ82ceaqgs?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RLqaEYZ5gdmdjXwvBxGxjsGpHU3EzXhdWhD0lf1gXuXmoZGDNCOqQGSbK6A3?=
 =?us-ascii?Q?8JCDyrJLqdzLUMdJYbaCdPBbpxyaq0O51O2Zm2bUtq0sNKEuJKdGsa3/Vwf3?=
 =?us-ascii?Q?GI7swar/AcuOXytMM6XtYsRVyIjHmwK1JSML0xCLuZZ5X+3yuZtV22KC0blX?=
 =?us-ascii?Q?aTwF17AFltmWxKIN+sIbYpo2UH/U4EM0XL+HAwFOmk+QVrUIaUOV0Bf/HP1u?=
 =?us-ascii?Q?LvoZHV+KttwGxXgiSkRzhnSEYyhR7X2l2bNckd12XUww0KfwzZhhsCxOvIMO?=
 =?us-ascii?Q?tV40nqZbeyTWwMko1loq7PAeGkeqJ6Kxdx/hEgBZucaPOYV7oD0bDDZWQ5FA?=
 =?us-ascii?Q?33YdjBh5PVSs5TYU3VwMhserFJJs3NqDYJtKUFobREGsjyje1KuKlxzwAPwM?=
 =?us-ascii?Q?FgrkVte5artNEqsEvLZ7uEHjSwpSKth8oP5L0N/6y2LDvhrnz9VcZcDVssan?=
 =?us-ascii?Q?oLiuPWZdtiZd5XhrvLztMzaTfgukR80fSNgpKShcBcyXGRyJN7Vy5uELYXkF?=
 =?us-ascii?Q?nxoebSdTaQVNX56V7QJlFhTNzjCeWYq6fc6kIXmFcn+kajUIVEG8RYkZOSfN?=
 =?us-ascii?Q?f0WVY/nDfDGNnRTh0pWuXeb0/be0JG4CwO4R9xWdYIHX6th6JVB9cZVHMwmK?=
 =?us-ascii?Q?tOpGO7gx/qDPUCOog+AuXZKbO7DAAl8GMGa9pF2ozbGFUrFUuc5SDZ+RjCvJ?=
 =?us-ascii?Q?JQeEYHPSGPz5KLPZyQg0lY4yTKLntx5xspGigiOgQxqP3HTSwStf/+Q7jzrA?=
 =?us-ascii?Q?9ou4dwF4/gc39f6+1QRoG08e1A1UbyFIW8+TbeaqjIi7DIVHmnJEWSZCMiwC?=
 =?us-ascii?Q?J7wRDaz8AHzDmka4vzvWHEjz2skuOc0LmUbzAOIDRggAOzH7qCQqoz11xqog?=
 =?us-ascii?Q?z58XjjRfJzyDZ8XLfitPSVSeyLLPtv/CT9Gl9Hc2sc7xSdji42NO+sFz5nZ9?=
 =?us-ascii?Q?nMP/0hIbuFK4ZGMFILDfAMifBtS6Cjc+eOc49USwNmZ65lT4vbOvnmqaCcxh?=
 =?us-ascii?Q?nGzkWEGfoS6nJnYSk/eGOafTqdz3rXJAEN1uRnr4YVd2bRuWJEUFqa39ThBd?=
 =?us-ascii?Q?kNF2PYYEf3SlQL+jSK9gAz3x930srQKBEBLDIJVg03H+lty8EZKl7Pp1GB71?=
 =?us-ascii?Q?N1ve7/ccHZQQnqOlzNss3w7VIXMJmiTsHtdSsOCsQVgECEgfYk95ZLfmXZan?=
 =?us-ascii?Q?6mfrwfQHSDoT4gq+Za9JVidFve6hTu4zz69Sw+PKIPfrr3NJgaW3LSmwzDVj?=
 =?us-ascii?Q?7pmuVwGy8BLv7pP91WyqW5MPxN5RJYbIk9ldP7ZIF7b27MLK5F9H9lbX2hNv?=
 =?us-ascii?Q?0axae7omf5N95EVnGktRTULJDBJqsOZo+yVVJR3di+HmsRxLbZEDychzyNQJ?=
 =?us-ascii?Q?0u8FqjAIpfD8elNtRyUccwqjikiN98Y1dYQrBsCthJRbH1g5jcTQVJ4QFUl/?=
 =?us-ascii?Q?B9tQB93CsNYOboUoS+k59Ju8rKvRJ42zeAtY2Yzflcz23u/vqiWIJtyHCZh+?=
 =?us-ascii?Q?weYpTsWZDZohja7oeDxr+9w7hN+wyHAqk0VsrEBNmI++9rdjHOmEbexw56xU?=
 =?us-ascii?Q?FakUcPhXjxwx+6yfE0bsoFbT4yEQjmLq6CUf09Am?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f6d9ba5-f5ef-4712-8c13-08de2260c8e0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 03:00:21.7668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ACrkgYIgL4L7YPGsS/VQfM6xbg7QyGicKtvUh967NuOkEmeUoiv73exGX6tfhGylFSsccxf36kGKF037txLog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8746
X-OriginatorOrg: intel.com

On Sun, Oct 26, 2025 at 01:19:08PM -0700, Xin Li (Intel) wrote:
>From: Xin Li <xin3.li@intel.com>
>
>Extend nested VMX field validation to include FRED-specific VMCS fields,
>mirroring hardware behavior.
>
>This enables support for nested FRED by ensuring control and guest/host
>state fields are properly checked.
>
>Signed-off-by: Xin Li <xin3.li@intel.com>
>Signed-off-by: Xin Li (Intel) <xin@zytor.com>
>Tested-by: Shan Kang <shan.kang@intel.com>
>Tested-by: Xuelian Guo <xuelian.guo@intel.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

There are some minor issues below that may need to be fixed.

>---
>
>Change in v5:
>* Add TB from Xuelian Guo.
>---
> arch/x86/kvm/vmx/nested.c | 117 +++++++++++++++++++++++++++++++++-----
> 1 file changed, 104 insertions(+), 13 deletions(-)
>
>diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>index 63cdfffba58b..8682709d8759 100644
>--- a/arch/x86/kvm/vmx/nested.c
>+++ b/arch/x86/kvm/vmx/nested.c
>@@ -3030,6 +3030,8 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
> 					  struct vmcs12 *vmcs12)
> {
> 	struct vcpu_vmx *vmx = to_vmx(vcpu);
>+	bool fred_enabled = (vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) &&
>+			    (vmcs12->guest_cr4 & X86_CR4_FRED);
> 
> 	if (CC(!vmx_control_verify(vmcs12->vm_entry_controls,
> 				    vmx->nested.msrs.entry_ctls_low,
>@@ -3047,22 +3049,11 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
> 		u8 vector = intr_info & INTR_INFO_VECTOR_MASK;
> 		u32 intr_type = intr_info & INTR_INFO_INTR_TYPE_MASK;
> 		bool has_error_code = intr_info & INTR_INFO_DELIVER_CODE_MASK;
>+		bool has_nested_exception = vmx->nested.msrs.basic & VMX_BASIC_NESTED_EXCEPTION;

has_error_code reflects whether the to-be-injected event has an error code.
Using has_nested_exception for CPU capabilities here is a bit confusing.

> 		bool urg = nested_cpu_has2(vmcs12,
> 					   SECONDARY_EXEC_UNRESTRICTED_GUEST);
> 		bool prot_mode = !urg || vmcs12->guest_cr0 & X86_CR0_PE;
> 
>-		/* VM-entry interruption-info field: interruption type */
>-		if (CC(intr_type == INTR_TYPE_RESERVED) ||
>-		    CC(intr_type == INTR_TYPE_OTHER_EVENT &&
>-		       !nested_cpu_supports_monitor_trap_flag(vcpu)))
>-			return -EINVAL;
>-
>-		/* VM-entry interruption-info field: vector */
>-		if (CC(intr_type == INTR_TYPE_NMI_INTR && vector != NMI_VECTOR) ||
>-		    CC(intr_type == INTR_TYPE_HARD_EXCEPTION && vector > 31) ||
>-		    CC(intr_type == INTR_TYPE_OTHER_EVENT && vector != 0))
>-			return -EINVAL;
>-
> 		/*
> 		 * Cannot deliver error code in real mode or if the interrupt
> 		 * type is not hardware exception. For other cases, do the
>@@ -3086,8 +3077,28 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
> 		if (CC(intr_info & INTR_INFO_RESVD_BITS_MASK))
> 			return -EINVAL;
> 
>-		/* VM-entry instruction length */
>+		/*
>+		 * When the CPU enumerates VMX nested-exception support, bit 13
>+		 * (set to indicate a nested exception) of the intr info field
>+		 * may have value 1.  Otherwise bit 13 is reserved.
>+		 */
>+		if (CC(!(has_nested_exception && intr_type == INTR_TYPE_HARD_EXCEPTION) &&
>+		       intr_info & INTR_INFO_NESTED_EXCEPTION_MASK))
>+			return -EINVAL;
>+
> 		switch (intr_type) {
>+		case INTR_TYPE_EXT_INTR:
>+			break;

This can be dropped, as the "default" case will handle it.

>+		case INTR_TYPE_RESERVED:
>+			return -EINVAL;

I think we need to add a CC() statement to make it easier to correlate a
VM-entry failure with a specific consistency check.

>+		case INTR_TYPE_NMI_INTR:
>+			if (CC(vector != NMI_VECTOR))
>+				return -EINVAL;
>+			break;
>+		case INTR_TYPE_HARD_EXCEPTION:
>+			if (CC(vector > 31))
>+				return -EINVAL;
>+			break;
> 		case INTR_TYPE_SOFT_EXCEPTION:
> 		case INTR_TYPE_SOFT_INTR:
> 		case INTR_TYPE_PRIV_SW_EXCEPTION:
>@@ -3095,6 +3106,24 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
> 			    CC(vmcs12->vm_entry_instruction_len == 0 &&
> 			    CC(!nested_cpu_has_zero_length_injection(vcpu))))
> 				return -EINVAL;
>+			break;
>+		case INTR_TYPE_OTHER_EVENT:
>+			switch (vector) {
>+			case 0:
>+				if (CC(!nested_cpu_supports_monitor_trap_flag(vcpu)))
>+					return -EINVAL;

Does this nested_cpu_supports_monitor_trap_flag() check apply to case 1/2?

>+				break;
>+			case 1:
>+			case 2:
>+				if (CC(!fred_enabled))
>+					return -EINVAL;
>+				if (CC(vmcs12->vm_entry_instruction_len > X86_MAX_INSTRUCTION_LENGTH))
>+					return -EINVAL;
>+				break;
>+			default:
>+				return -EINVAL;

Again, I think -EINVAL should be accompanied by a CC() statement.

>+			}
>+			break;
> 		}
> 	}
> 
>@@ -3213,9 +3242,29 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
> 	if (ia32e) {
> 		if (CC(!(vmcs12->host_cr4 & X86_CR4_PAE)))
> 			return -EINVAL;
>+		if (vmcs12->vm_exit_controls & VM_EXIT_ACTIVATE_SECONDARY_CONTROLS &&
>+		    vmcs12->secondary_vm_exit_controls & SECONDARY_VM_EXIT_LOAD_IA32_FRED) {
>+			if (CC(vmcs12->host_ia32_fred_config &
>+			       (BIT_ULL(11) | GENMASK_ULL(5, 4) | BIT_ULL(2))) ||
>+			    CC(vmcs12->host_ia32_fred_rsp1 & GENMASK_ULL(5, 0)) ||
>+			    CC(vmcs12->host_ia32_fred_rsp2 & GENMASK_ULL(5, 0)) ||
>+			    CC(vmcs12->host_ia32_fred_rsp3 & GENMASK_ULL(5, 0)) ||
>+			    CC(vmcs12->host_ia32_fred_ssp1 & GENMASK_ULL(2, 0)) ||
>+			    CC(vmcs12->host_ia32_fred_ssp2 & GENMASK_ULL(2, 0)) ||
>+			    CC(vmcs12->host_ia32_fred_ssp3 & GENMASK_ULL(2, 0)) ||
>+			    CC(is_noncanonical_msr_address(vmcs12->host_ia32_fred_config & PAGE_MASK, vcpu)) ||
>+			    CC(is_noncanonical_msr_address(vmcs12->host_ia32_fred_rsp1, vcpu)) ||
>+			    CC(is_noncanonical_msr_address(vmcs12->host_ia32_fred_rsp2, vcpu)) ||
>+			    CC(is_noncanonical_msr_address(vmcs12->host_ia32_fred_rsp3, vcpu)) ||
>+			    CC(is_noncanonical_msr_address(vmcs12->host_ia32_fred_ssp1, vcpu)) ||
>+			    CC(is_noncanonical_msr_address(vmcs12->host_ia32_fred_ssp2, vcpu)) ||
>+			    CC(is_noncanonical_msr_address(vmcs12->host_ia32_fred_ssp3, vcpu)))
>+				return -EINVAL;
>+		}
> 	} else {
> 		if (CC(vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) ||
> 		    CC(vmcs12->host_cr4 & X86_CR4_PCIDE) ||
>+		    CC(vmcs12->host_cr4 & X86_CR4_FRED) ||
> 		    CC((vmcs12->host_rip) >> 32))
> 			return -EINVAL;
> 	}
>@@ -3384,6 +3433,48 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
> 	     CC((vmcs12->guest_bndcfgs & MSR_IA32_BNDCFGS_RSVD))))
> 		return -EINVAL;
> 
>+	if (ia32e) {
>+		if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_FRED) {
>+			if (CC(vmcs12->guest_ia32_fred_config &
>+			       (BIT_ULL(11) | GENMASK_ULL(5, 4) | BIT_ULL(2))) ||
>+			    CC(vmcs12->guest_ia32_fred_rsp1 & GENMASK_ULL(5, 0)) ||
>+			    CC(vmcs12->guest_ia32_fred_rsp2 & GENMASK_ULL(5, 0)) ||
>+			    CC(vmcs12->guest_ia32_fred_rsp3 & GENMASK_ULL(5, 0)) ||
>+			    CC(vmcs12->guest_ia32_fred_ssp1 & GENMASK_ULL(2, 0)) ||
>+			    CC(vmcs12->guest_ia32_fred_ssp2 & GENMASK_ULL(2, 0)) ||
>+			    CC(vmcs12->guest_ia32_fred_ssp3 & GENMASK_ULL(2, 0)) ||
>+			    CC(is_noncanonical_msr_address(vmcs12->guest_ia32_fred_config & PAGE_MASK, vcpu)) ||
>+			    CC(is_noncanonical_msr_address(vmcs12->guest_ia32_fred_rsp1, vcpu)) ||
>+			    CC(is_noncanonical_msr_address(vmcs12->guest_ia32_fred_rsp2, vcpu)) ||
>+			    CC(is_noncanonical_msr_address(vmcs12->guest_ia32_fred_rsp3, vcpu)) ||
>+			    CC(is_noncanonical_msr_address(vmcs12->guest_ia32_fred_ssp1, vcpu)) ||
>+			    CC(is_noncanonical_msr_address(vmcs12->guest_ia32_fred_ssp2, vcpu)) ||
>+			    CC(is_noncanonical_msr_address(vmcs12->guest_ia32_fred_ssp3, vcpu)))
>+				return -EINVAL;
>+		}
>+		if (vmcs12->guest_cr4 & X86_CR4_FRED) {
>+			unsigned int ss_dpl = VMX_AR_DPL(vmcs12->guest_ss_ar_bytes);
>+			switch (ss_dpl) {
>+			case 0:
>+				if (CC(!(vmcs12->guest_cs_ar_bytes & VMX_AR_L_MASK)))
>+					return -EINVAL;
>+				break;
>+			case 1:
>+			case 2:
>+				return -EINVAL;

Ditto.

>+			case 3:
>+				if (CC(vmcs12->guest_rflags & X86_EFLAGS_IOPL))
>+					return -EINVAL;
>+				if (CC(vmcs12->guest_interruptibility_info & GUEST_INTR_STATE_STI))
>+					return -EINVAL;
>+				break;
>+			}
>+		}
>+	} else {
>+		if (CC(vmcs12->guest_cr4 & X86_CR4_FRED))
>+			return -EINVAL;
>+	}
>+
> 	if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE) {
> 		if (nested_vmx_check_cet_state_common(vcpu, vmcs12->guest_s_cet,
> 						      vmcs12->guest_ssp,
>-- 
>2.51.0
>
>

