Return-Path: <kvm+bounces-53332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 71946B0FFFE
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 07:36:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 98B8B565B98
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 05:36:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 520EF20127B;
	Thu, 24 Jul 2025 05:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RWSq41v2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E932E401;
	Thu, 24 Jul 2025 05:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753335363; cv=fail; b=gulsGLboLIXKArkVkr1slr3tKLKsRpkDmW9fWnh7SKF0GOmH4eg3yvNe4eJqJT5jVjVTPdA3kQ0FDNnCmGhvKiiUNFhgsexBBCCX9iULqhVsdYPzOuZKRp24weuUzg2DOJRk+6Q3YY3OrWte6tSV5aesmQuMEzg/SB//kLveL3Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753335363; c=relaxed/simple;
	bh=RQLsoaaP5pVw2Uh3N2zeSTVFtWfzOuJUWmAidoGWxd0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jrKWVWWLE8cub4l3EpuSpQn2YUyIucJeyMACJploEcVweH8CQsynWmJ2HcpapoSk1GW4jozUclYQzWr4JdyFgQ88MWNS+kqL5cnxwrfc4p8bahcTtVic3B4Fz6X5uFA7BUZzV8/6YESVIhhybzc1uJrbcTQrrdMXcA/Hv1RX/gw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RWSq41v2; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753335362; x=1784871362;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=RQLsoaaP5pVw2Uh3N2zeSTVFtWfzOuJUWmAidoGWxd0=;
  b=RWSq41v2mvssMQGBU2oDre/qMbXqt49CGShgsA77oRpgftiDBwS49CWY
   IQr79pjAPsT6kkZ8qaUqPRBqvl52/8PDQHW0qHvTzsmjpZr2eFsSngtjz
   ypUJIIKh0pf80WfgVMtTBuKWiJdjhkm1miSRn2OS+JZ25Z0dE2Etg6+Wd
   xluB170K9zJSLDc/XaT5xvYAJrQjgLwcJD2vqlfFx/hbffQz6SMpHQlq8
   RJflKs/lsTBaoTimCIlWTc0uRtN1IwEqRXWrkNs10oNfePr9b5lzLoO50
   FgmO5PsmmGBWo6x2ZY1xrhmFqW6mdyc8nam7DwlJayQZQqF6STIhm4BFc
   w==;
X-CSE-ConnectionGUID: TyAb20KwTReJKRQ0sOogLw==
X-CSE-MsgGUID: G1NKog0iQLG9aTSJJapiQw==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="58246919"
X-IronPort-AV: E=Sophos;i="6.16,336,1744095600"; 
   d="scan'208";a="58246919"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 22:36:01 -0700
X-CSE-ConnectionGUID: 753l1vEPS1Kd46baBuqzbg==
X-CSE-MsgGUID: XBcLydueRfC+lOjUGzBiHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,336,1744095600"; 
   d="scan'208";a="197137370"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 22:36:01 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 23 Jul 2025 22:36:00 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 23 Jul 2025 22:36:00 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.53) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 23 Jul 2025 22:36:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xIXkLfjoreSCbbwkCRovxPfW7civLX4XR33Y1F9HH50f6cpoENikkKOyobh6I5HYksk4UqhVhrHG+flOgfEQJNZTLFKPwKEp2VZQJZXKQI7Km/U5VMV/0FgJC35ZmH1teCLVnT6RbEQhpB3hfGwXlXk+0+3l71WI0d9+1Bd0thC9yRTkfy72+/S+a9+KLI2lyg1/VECiWIiR79DihINJbgjVKNnzTSfpK0t9b+aBcmqw34RMwcBE5MCQOowEYAkIQFdisgKPRObCZAWPwJaxWkE2hLOtG1IZBzJ5Z6BbJ974j/1Z0HwWw26onW8xo9f7tVOxffybGf0bWP2843gE0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IXVZv801TcN0qYu5hgvRqWpEnQA5pUkOnSYNwDxJ+1o=;
 b=jzHamNQalyWnCRkmgVYxRaaKsNbMHcS//QFq/ecfjzKSo/T+WasxOi2m/LuX008uAtkr8ihDsoGQJE51o/rP3LLMJ7i8qnx9CtYDrCTCtJLFUkfue8jB+SLNNVpAWEgqLWXUPhB5wD68psAOAiNaE4X90YCAPPgSdwI8mmoGoXJdkiqwaZYQDJ89VRuB3NzgYeoa+zeISpzZtyfJaiX8nbQ1hU6TgtM9LE3/yVYXQgvFdgIqq+vftPd4x9Us/hrbP+QR6UaXOC9/IF1z4qoYrE9Y/wBeKXlyZu65h+KfO04HOa1hgKLqvcscuApLgO0SScDEOtM3o+K+J/8MqZhtWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH0PR11MB5128.namprd11.prod.outlook.com (2603:10b6:510:39::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Thu, 24 Jul
 2025 05:35:31 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8964.019; Thu, 24 Jul 2025
 05:35:31 +0000
Date: Thu, 24 Jul 2025 13:35:18 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Xin Li (Intel)" <xin@zytor.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>,
	<hch@infradead.org>
Subject: Re: [PATCH v5 10/23] KVM: VMX: Add support for FRED context
 save/restore
Message-ID: <aIHGFpKfkyDisYaZ@intel.com>
References: <20250723175341.1284463-1-xin@zytor.com>
 <20250723175341.1284463-11-xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250723175341.1284463-11-xin@zytor.com>
X-ClientProxiedBy: SGBP274CA0020.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::32)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH0PR11MB5128:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a52c766-d934-47b5-f9f5-08ddca73e73e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?4EW08M/uHSU8ZEQN8GZg3t6PYrqJ4Iv63Vu8o50d+4SnaPrfDUUcUSelDocd?=
 =?us-ascii?Q?1s1VN9DkLvfH9EyvyDQGZ9Jtbt4Dm/fxQGV4lpSV2JpPqG/IMM9l+40JUHVk?=
 =?us-ascii?Q?H7Z/HwonVivqVLKH5irbwIAO3rWmVNeQnxW17W1PhponvaK51pYWUFQ4Flnn?=
 =?us-ascii?Q?6CtFTZukq4/dXvmGos0EotiWNiS/hYvTvPtUxjcgOAhicJ3ISlc9i5GbhmMj?=
 =?us-ascii?Q?Os7Izygrt7L6XLMI2zCjpWYLYsBlOT3buXItB6VuCjLLxPAPrWOyDa2PFY2N?=
 =?us-ascii?Q?/CMmJCndTSvjZEFsMLdOuqjlYMORfMTl/f5wYaX/NRwrX8optVtDzVV2W6sw?=
 =?us-ascii?Q?atLw6ySg2Gcdd59amy5+lSSQdnUlTnH6QbVg3XojinWxlwg8rdfrcp4lQ/qS?=
 =?us-ascii?Q?w5FBieuHlJwhrf8dFje4epFQlu2PXfjkr0WyfH3VwL7lG6hxj+ueqjMwIFsQ?=
 =?us-ascii?Q?Dq1k5EwuwTiMCa8mmkkZNcbcnedVhmyjfAekrzNUTz9jrvwYQiykTYA7lepu?=
 =?us-ascii?Q?Zhp4KwLAlOrtL35coBRCHn2tnlXH9QyzA5WH8jJg+Rd0VJlEQeehM3B2W7nk?=
 =?us-ascii?Q?lUK4jyDf4VdIYCECuPhw9y6jgNpXDgfnJuvtYDtay3rU5S6auWFX2i+n5/m3?=
 =?us-ascii?Q?FSJsEvYQCs9KOL9cQLX8lHkXG/fBRGvq04ayTj3g3MEdVsSoEoTehjAUYpIc?=
 =?us-ascii?Q?0xTT5sj4OhGTVC9ABdCLxKfv8f2C2HGkp3sbrpnjzajrVSH91w/1eCg+3ZFR?=
 =?us-ascii?Q?rJ/mHApDU3TFfAzZiIHlJUaoHT9HGCZ06CUzlZ5fZ9km3xIqgcgEm8nID3ua?=
 =?us-ascii?Q?35+wew/saJoT+qnHimd8mirUDGPJVgthK0O2GXm8O3vB43F4CQ5WJkSwpwVk?=
 =?us-ascii?Q?VbgjNdje5j/QCKDWTUsZIwhar28YuARra7hFYYQZw6tRJ6q+zfqYst9FW9Xi?=
 =?us-ascii?Q?UoWsN3ICl1xVE5WYD/Ze4p59Euk0NXs2IcMy2cQCPY0O9avC7tg3+9CPcv3l?=
 =?us-ascii?Q?lIKbB4KbNfieDDNGRGYBNSqKQABNxbHVI2RI8fqTBA/7Jip4EeK6EgKNz93z?=
 =?us-ascii?Q?JanlWzoEtOU3hGCK2GdvWOlrR1iIz30vjTt1jFO2y1/pnK+ThCElzjdv3nA/?=
 =?us-ascii?Q?JJMWOxlMRbdwozukW+hgRMoLkolYPbwEPnJG2W2EneFqsjgnJYeGHxHv1mki?=
 =?us-ascii?Q?sgcNB219UVGNysx5FfRg4qrHuSCd9hP/Cd0i636hyv6QOolbidyklRk+B0xT?=
 =?us-ascii?Q?i9FkikTiVXLhrSkkaPomMvRuKqpehBx7pOSCFBK23iWQV+0JjMYXWeW5CA6s?=
 =?us-ascii?Q?ZD7LITaLGM9iuC3iqagtvGOccQbOMCC4IyKuHn+24eXRi0co3hZH7pDMhjVd?=
 =?us-ascii?Q?tFEVwAyG8588IqE9GUQb62Rsl24VezrAkKKMKHErTDiE7qkhF7nO3oMbZcyO?=
 =?us-ascii?Q?oHepEl7m+U8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w7DsRX+hHy/tTfoTUkn8jcp7o3p9nKeXIh3sieGGml80xIF4CPQJMATENRoh?=
 =?us-ascii?Q?leYBhIL+uesFnh15Kva/RDbI56cDnVf9hjK6+5fOxy0wG3qogkJuo9einDdy?=
 =?us-ascii?Q?U36TcUDM7qEd0bp+3O6xWifqARVl+x/KauB0ksFTZgKP9US0pkh8IA7q+Ei9?=
 =?us-ascii?Q?dgBeCnBEBawL7/YCtTN1y9PI/fCFbp7BxVul1y2DkXanF2mMuEVVPdnTVhse?=
 =?us-ascii?Q?h84zjziyvlssmbB8RX0szJRlOBc+Z9GKTQHpEOxjEiMFiPur2JIfiZj2roBW?=
 =?us-ascii?Q?ouWyXDOmwb5N/OougmSBIB5OsnAk4hxoRUfQ+zJGNygv3Z8uGcmcA+P4TIwl?=
 =?us-ascii?Q?Mt67GvFU8jNH4A358rzwJgyN4PEy7V2EYbLg+yyUXUIfHhYQhgMNKW1FqC9o?=
 =?us-ascii?Q?DhgN8ezaiAbgFHg0xGxHLwds/+QZ4aCI+j7zD88s991rrkkh0jqunP5CVyAV?=
 =?us-ascii?Q?c42BZgRE1YO9EwGxswKDgFu/Yc20UvYEo9lmy/UJanikb91ln+tB8twi4Xsw?=
 =?us-ascii?Q?QzO3YL4XidhF4RRDGubZ53ppqlLbwjArjqkk30/izegTTDHT9CdvTodzO/dc?=
 =?us-ascii?Q?J75BSGL3458eZE27zAGLPfkxGDDH9o+BLia4IX2OjZktZynOfI4vYgm9jW9j?=
 =?us-ascii?Q?QpiMdr4n/bUKBuzt5IM1A7Gd9RXzW7tFF3ZRBbq0BO0PvqOhMb/VE6xq8dKd?=
 =?us-ascii?Q?V6HzaGvcBP9jT4LY77tbtBrLqeJcUHzQwYf+QEYozqYHxR7SxiDWlMhP5aG2?=
 =?us-ascii?Q?mZdxzSd4hsc0XH2dwOu6WeQP6HOxhg6J8v4YXxiJXv/ZrRh1P1c6A+nttlaR?=
 =?us-ascii?Q?2tWp7dK2wPwjc9Si/LGLtp/pZOQhkrgpemfaKH8JeYA6z4jJ2Wck+8Kns4yd?=
 =?us-ascii?Q?R1KX8+lODxyNJSvtNHy5GajPubiVHSST9aFbfuosIuJJ5tNiCVvjAuXhatB2?=
 =?us-ascii?Q?Ag3lvUkpYRMr5jngrjFIiChHV1/ULlD0Ym2Ok3snp91JkmHFndtcuI9gMVyj?=
 =?us-ascii?Q?EOTxbPI7Kht/TqwsBCOBoQaqvXmedVCOtvGEVglk4l3YfJxyI9KAyUF3C3xH?=
 =?us-ascii?Q?Znr+wu1MDRM4H34TyLPt0cv2B5GqWZk+h5dBkVeiXKHNyWSNhI3rmdX9WVxk?=
 =?us-ascii?Q?8JiB7FVkhMHQqjH24CUm7T60c+bI7tiBb+x0D7izFmJJh1zi02L8r0d7cuX8?=
 =?us-ascii?Q?LmyrBNyigjzrkIj/YjrrKq2gP6pMe3jcgzN4QJSTz+EXYjvsQ7pKOxnDKCJl?=
 =?us-ascii?Q?xL7pqziicE7HRiUfPZ2Tw1qtETjQVzhBTr+VwvqiTGAMw2xIOR/vWx9disNV?=
 =?us-ascii?Q?5RAhcMz8g/ztvZkKmsHMjGWnAVi5JeRv4IwXgGWI+0/suCDblJ72k/Aam8e7?=
 =?us-ascii?Q?mZ1WliRIifJ30RObQCh09e3Irdau4AkBWPARNRSiDPu9cP9rqqORrmDXWDtR?=
 =?us-ascii?Q?jhKHkeVS9iDOEw5Kk4TkZswxISo9Be3s7Bn/vvQV4ZtLB7HoLU4+I2+1gMlR?=
 =?us-ascii?Q?z7rh93Sfa8dFCjaBt8z49HnhNPAYgMOGrqR3QxzcG2DtSCM5lLVRMIZXhhma?=
 =?us-ascii?Q?o7D1jh0z+9oO1llME7UPr13cg+IXzVhMK9ebBewp?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a52c766-d934-47b5-f9f5-08ddca73e73e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 05:35:31.1320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pCrMO1DDC13PU0o3LtfJfUyfhRu6EQyu+STq1hM4CSVbhLOrdTsWADLY78Jela6j1YpZ2H2ED5Ns7kIwKQXhnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5128
X-OriginatorOrg: intel.com

>@@ -1870,6 +1873,37 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
> 
> 		data = (u32)data;
> 		break;
>+	case MSR_IA32_FRED_STKLVLS:
>+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
>+			return 1;

Return KVM_MSR_RET_UNSUPPORTED instead of 1.

KVM's uAPI allows userspace to read MSRs and write 0 to MSRs even if an MSR
isn't supported according to guest CPUIDs. Returning KVM_MSR_RET_UNSUPPORTED
allows kvm_do_msr_access() to suppress the failure when needed to comply with
the uAPI.

For more details, see kvm_do_msr_access().

>+		break;
>+	case MSR_IA32_FRED_RSP0 ... MSR_IA32_FRED_RSP3:
>+	case MSR_IA32_FRED_SSP1 ... MSR_IA32_FRED_CONFIG:
>+		u64 reserved_bits = 0;
>+
>+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
>+			return 1;

Ditto here and for __kvm_get_msr() below.

>+
>+		if (is_noncanonical_msr_address(data, vcpu))
>+			return 1;
>+
>+		switch (index) {
>+		case MSR_IA32_FRED_CONFIG:
>+			reserved_bits = BIT_ULL(11) | GENMASK_ULL(5, 4) | BIT_ULL(2);
>+			break;
>+		case MSR_IA32_FRED_RSP0 ... MSR_IA32_FRED_RSP3:
>+			reserved_bits = GENMASK_ULL(5, 0);
>+			break;
>+		case MSR_IA32_FRED_SSP1 ... MSR_IA32_FRED_SSP3:
>+			reserved_bits = GENMASK_ULL(2, 0);
>+			break;
>+		default:
>+			WARN_ON_ONCE(1);
>+			return 1;
>+		}
>+		if (data & reserved_bits)
>+			return 1;
>+		break;
> 	}
> 
> 	msr.data = data;
>@@ -1914,6 +1948,10 @@ int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
> 		    !guest_cpu_cap_has(vcpu, X86_FEATURE_RDPID))
> 			return 1;
> 		break;
>+	case MSR_IA32_FRED_RSP0 ... MSR_IA32_FRED_CONFIG:
>+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
>+			return 1;
>+		break;
> 	}
> 
> 	msr.index = index;
>@@ -7365,6 +7403,10 @@ static void kvm_probe_msr_to_save(u32 msr_index)
> 		if (!(kvm_get_arch_capabilities() & ARCH_CAP_TSX_CTRL_MSR))
> 			return;
> 		break;
>+	case MSR_IA32_FRED_RSP0 ... MSR_IA32_FRED_CONFIG:
>+		if (!kvm_cpu_cap_has(X86_FEATURE_FRED))
>+			return;
>+		break;
> 	default:
> 		break;
> 	}
>-- 
>2.50.1
>

