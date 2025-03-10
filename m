Return-Path: <kvm+bounces-40577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C6F94A58C78
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 08:07:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 42587188A77E
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 07:07:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D068A1D5AB2;
	Mon, 10 Mar 2025 07:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mUhMgwDz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226601C07D9;
	Mon, 10 Mar 2025 07:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741590419; cv=fail; b=IibVIWCK7021IXR3mT76fOYIxYXvCDIWg1Ee4wifkFU8+TkIhCndG6F0VCIE2eQ9qscxLuaNFLMRa2wucTfI4dy09N4x/45z8EW8sdWVEHwuuGk3o4HYiLzp6zgO1cGHE+OH9eI7ZKQOtk5hbHbwp1Ya21+uf6fmVOsy4nGD+t4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741590419; c=relaxed/simple;
	bh=7ZsfW8TKzu/BqsY+cScSG0g/R1TUSBnQuVKVuToCJD8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=l0Zcb5X+CdtoDoTIHDL5MqznXyub0BTjE6GaHblh8bhfj0l9Rybd+8tSgf3xUiMatd4rRIPU3HhENMyI/q/pYW5fyZIGAarGf7GAPjR/9aqUGPMXt+tdA3epaPRKA/pTWA5jWIXTfSGoOpEvHIBEY1uM0Xn4WX+UkpiHb+ZcyVk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mUhMgwDz; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741590417; x=1773126417;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=7ZsfW8TKzu/BqsY+cScSG0g/R1TUSBnQuVKVuToCJD8=;
  b=mUhMgwDz6Fmy9E5AMc7ccphODbTag0NPcv90wFWAcOvTtmRAqLefbJ/M
   40eZJkk46RwMJspVj08uT+4vyiOSUg6QGMcYf8geB7qkVmI2IFna3lFIt
   EzX5yPJF/BouG4QYYXv7o3BSyNC41xpZV08KfvunoyCjuZxOcinNyJRdk
   4VSE7jIHI3Lav9NQkOp3T25oUTQjEIz7EZhE99DqfzF0v0Bx5B6stQtHf
   I+PDT3hw2wxKGcrB+Zh5iq7hInowIm+puLU/ye85+mGDkxRTQG8u0SfP5
   26b1Fvrm+ma9FIAj+zw922PwcvkBCzbU4PZ5zrHNOKB7gJ3iXkGi7QZUj
   g==;
X-CSE-ConnectionGUID: 2RdBIxlmSF6IT+TdoxvB+Q==
X-CSE-MsgGUID: HO1Jjz7JStmuHz0c1MzkQQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11368"; a="59978922"
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="59978922"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 00:06:56 -0700
X-CSE-ConnectionGUID: ObwJ0AB8QPOdSFgiNdwTdg==
X-CSE-MsgGUID: G9WdsfLJQGyCdZOFPBWSiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="157111759"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 00:06:57 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 10 Mar 2025 00:06:56 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 10 Mar 2025 00:06:56 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 10 Mar 2025 00:06:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TT88UmO6p5GgwlHs2FQSbe4VLdWJANivu8BEGlrH+lG3QvZcaFmiQTs93Lx/vBaU8PJBJ7x6q+h6Z8SxUQsWkR3cKp/KTuRWp5gNBNoGlUZf7eiA21zoFq68Ku0ac0Mh6SpObPsMMbwFHBw8VHFh2wov7CsmYFWehx7DkIuYMRS5ht2Bzp2jw8WHOYz/N8X94idEiq5frHTgPa435kO2P2LgVDetE+rF/f38wihWPypXiXLKkRuFuEUUbcATS7ck4f9Mohe/Q8W58g+Pgh9zPWgFHbUVmx4PhHZ/Pdks1jYBkvoI9n2YeSarUD4Mx2h30U/hBQrbyr1BId8J/EAReg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rWGN40ISsAYtpSyUDtUlj/Ru/0UiISAAu2HcmZLUz04=;
 b=PH3hu2CWgdrQuXtJAMqX636UY53gY0H6ZBbY3p1mRtN0am77ZINrOSRoE05fPODhCq5ijCAy4Z+CUG3RNMxG9ReyUcTVk18xPkNIGzrmWZIlykHkW9QpZKZs5gVL3IqDwRgMou0iXuvakUlbCvqP1+8g6GCPJ/qblemD4FOSzn4exZM/DLaP8M6p8st5I08NDHHoSmBroSBHhc7IQbSjvLFlvJelagODn7HiwoqRRLmDgg1s8IzMzZs41xURLBecordcvaTYOjN/+wX5DucDR7MtBsNOkQVVpq/u8PeeWvmEWiXvncujqz2pCGpb+jZ5XMpVu9E0IjQARQ/TvPtsuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by BL1PR11MB6051.namprd11.prod.outlook.com (2603:10b6:208:393::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.26; Mon, 10 Mar
 2025 07:06:54 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8511.026; Mon, 10 Mar 2025
 07:06:53 +0000
Date: Mon, 10 Mar 2025 15:06:42 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
CC: <tglx@linutronix.de>, <dave.hansen@intel.com>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>
Subject: Re: [PATCH v3 04/10] x86/fpu/xstate: Correct guest fpstate size
 calculation
Message-ID: <Z86PgkOXRfNFkoBX@intel.com>
References: <20250307164123.1613414-1-chao.gao@intel.com>
 <20250307164123.1613414-5-chao.gao@intel.com>
 <b34c842a-142f-4ef7-97d4-2144f50f74cf@intel.com>
 <Z8uwIVACkXBlMWPt@intel.com>
 <481b6a20-2ccb-4eae-801b-ff95c7ccd09c@intel.com>
 <Z85BdZC/tlMRxhwr@intel.com>
 <24b5d917-9dd0-4d5b-bca8-d9683756baff@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <24b5d917-9dd0-4d5b-bca8-d9683756baff@intel.com>
X-ClientProxiedBy: SI1PR02CA0013.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::7) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|BL1PR11MB6051:EE_
X-MS-Office365-Filtering-Correlation-Id: c39b0f82-4ba8-41f2-0c51-08dd5fa2232a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TzB5c0xNRlZpcmJQMi9oWWN3YWNDUXdjQ0hDN2lWTGpaeUhuN0pGMXRKcXdC?=
 =?utf-8?B?U09EQXlLS3BhODBtSlUzQ1FVYnVvMUF4YWE4bGJMSUxvRjZ2a3JtOGtlNWtK?=
 =?utf-8?B?V3ZPZzRKS20yWkxaR1c5ZUo4bjVPNUZoSSs5M0RVRlRicFVadVpWRWE5V1BU?=
 =?utf-8?B?QS9NUUNQb0ZQakNtUnFBUElvR3VSMEY2YVRCcmljZ3k0S0VmWm1rNlVrTW5L?=
 =?utf-8?B?UjBINkFTTVBwN0ljRnQ0STQvNHhnVmJqUzlCWEFsQkVvRGM1RDYza0Zhbnda?=
 =?utf-8?B?V3drckE4Umg3d2JaL0dLSjJrTDErdUUvVmtnSnNNMWZjZWgwcWJ0U3pVZnR1?=
 =?utf-8?B?S09NQUk4bmdpYnArNWpsblg4Rk5TU0hRRUlBelN2aVVMKzZZZmV3aVREdlZ1?=
 =?utf-8?B?bEVBS2t1cndCd3RkUm1aaytVeXA2MTRRa0FMZjJ0OUpFaGZJVmpmWHNaM1ZW?=
 =?utf-8?B?TmhoT0ZrVTdTRUxGOEQxckFzK3pWaUNEeDA5NGJCYjMwZmRROWd3bE1IOWYw?=
 =?utf-8?B?bFNORUh2NDdDbWtBL3FNdGZ1OVRNV2NEQ0ZnbjZ0MlZRb0twaU80MC9zcm5T?=
 =?utf-8?B?VWJLNDA3MXNBbWM3cUgvZkd3Mk1HVElTZlVvakY0TVc2RUttUTVnbVRRdVBP?=
 =?utf-8?B?MkRpQnBOcllWeCswM0Z2MFBucVZZU1d6eDZIcEdHdXpFYytwWmszT090T1hB?=
 =?utf-8?B?MUJRT1NCWTBJTEp5c0RIZlJzUUpIc1R4eUx6YUltNndQUW8vK2dTTXIyc0NX?=
 =?utf-8?B?RDRtYnRiQTMzNW1QZUNkanpHbXNnQTFjN25zYkkyekc0MXpUSlIxSUJKeUwr?=
 =?utf-8?B?ek1KczZGREpwa1FwK2V2ZFpWZXd3TjlSVWViRnpEVHRIVDdEbFp2dTZBRDVI?=
 =?utf-8?B?dStoa0loSWxydmZJa2RSampWM0NFbDNkbFBIbnBuWnpPNGZzZkJiellUYnl1?=
 =?utf-8?B?Y0VEaXhmT29HUWxCZ0hyL2FFRlZVdWNDZHJhMDlZN3Iyamd1ZkZQTkx6RXBD?=
 =?utf-8?B?dUV1UkhEN2VMUVJDT1pRWkpzZlUwWml0enNSRFRMMllZTFVidjZsUVlvYnFL?=
 =?utf-8?B?emEzVFpmZTJCK3NIOStkcUIxM00xYloxaVQ0ZExpZmJ1TU9rYTVDSmwxWEhn?=
 =?utf-8?B?dEFSTUVJclQ3bm5rWjJGNWFLQ09XSXY1MGxYekdaSGVCVFl5NkRrZjJXRWpt?=
 =?utf-8?B?UUs0RU9ONUVSOTZIWjNiNkMrY2svdHBqaFpKRUhaVW9JK1puakUySFYzWmNp?=
 =?utf-8?B?ejJwSjNpMTBrSnlGMmdRNWZZTTMxVGxKYmNzSVFXcWhra1owTVdGd1pnTzdx?=
 =?utf-8?B?b0loSHl1OHhFMm1JMzljWkZ4YVU0VmhZS2hwUkkzQWxKM2FsUnB1Sm1Cc2tj?=
 =?utf-8?B?byt5VzZjT1NDSFRnUHVCR2JuWmUvOERSeWRpclRwVXJYY1NTdmdFV0hwemp6?=
 =?utf-8?B?UFczYWZGbVMvZHYwZ2NuT1Z5TDRWQVdSdVltVXVDUWJtNlhSbmllTTVLVEFV?=
 =?utf-8?B?aGF1dVB4UVQ5dlhQeEpVeU5RY0p0RzZjemFxc0JDeHB2ejN3N2NpVlduNE95?=
 =?utf-8?B?azZMWWRmQVFrTkducXkzK3U0T1VGL2dwVTA4ZUNqQXpWODBvQVh6NUdKaXNL?=
 =?utf-8?B?aFVsWS9rd2JRT3R1WmN1Wk92VWhaSHFwSlk4QUN4T3lKYVlhb2t1eDEvS1dY?=
 =?utf-8?B?eDVjb0dhRWZzM0xURi9IREZvLzIzWFhmcUx1MWhjL014cCtiRVo3Mlp0aUEx?=
 =?utf-8?B?OVJIOUN3M2dHY1FFbFV0UUI0ekpXb09JTndaTHdzRHlXRDZ5WWUvVTVPWTFa?=
 =?utf-8?B?UmhnZW5yazdZVlR2MlUrbnBGQjhwbndMSXI4eVRmSW9nOHc4b3B4dzg1SDdr?=
 =?utf-8?Q?qWwuNpV60GfrP?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aTdyQ0hWaGVqVmk3YWRCQ2Zlb0wwZERrT2F0QnlGMWdYaGpBVWJhd2RGOE1V?=
 =?utf-8?B?OFBOKzNEUXBYcy9xOGpuQlBocnErWVo2VlcwMXY2OG9QWHZkbjlkQTAvQzVk?=
 =?utf-8?B?MGxqS21SQklDNkFhYzFUeXcxYkVJY0VJM3JRZEwrTlNvYjRsSFVINFR1V0lW?=
 =?utf-8?B?K0lrL0JFUnBVZzhtM2dnV1UzWUJwbXQxNGEySEIzcnFjTCtwWHRRYTNSSEVm?=
 =?utf-8?B?bmVTbWdyZS95VHBtM3JKVTFIV0s2RlVQelVlbGt3Q0xqdHRqbHJWZW9SV0ZZ?=
 =?utf-8?B?M0hlNFJBVGxCREF5ZnhXSng4SElLaTFxNlJRaFJldnR2RGZheWgxT2tKQjJ5?=
 =?utf-8?B?akNpNGJ3VlF6TlE2bzNabGVJeUNlS1p2SS9EbUJUUzdhQUc2MXF0Uk1zWUJ2?=
 =?utf-8?B?bitXWGNXa3EyRzY5YXQ1dk82R01aNUowc3g5bEdsc3JOWXpaMWpMcm9qRFda?=
 =?utf-8?B?TkcxUE1rZE9TeENDR1oxV3FqYVpXVVVOZXdVN1A5VW1nUkhQY3c5K1BORlZR?=
 =?utf-8?B?MElYOUkvcHY1RUhlNThMZkFXbThRbUhCQ0xMYWRxWU1VemwycGFxNmtUWG9v?=
 =?utf-8?B?dnprbG9FV0JXZGNhbnhGSy91OTVrNlRXVVY3RmQzZmlmZkNGMlplaklnTnVw?=
 =?utf-8?B?NVZjaGYxNlVhWm5Idi8va0lpUmt6UXZPM0JlVVRnSld5TlkraE4xQXhTbU1E?=
 =?utf-8?B?ZFIzb3ltaGRIaGhFUlROcXZBbDlwYnBCNkNieW9IZGlSNndjeW81OGdUWmJW?=
 =?utf-8?B?SDcxak96bkVVbW8rVE93VDlKOU1BN0o5TDNoRUxjMXYvVUxoTWIxVnN3ZVRy?=
 =?utf-8?B?dC9qeGl3QlJpWm1LR282ZkZOYmRvd0VINUlxcHVtSGM5d2ZUYVpKR1JiN3Z0?=
 =?utf-8?B?bFpXWDRpWldrNGhoYWZVeEIvMXdFZVNoWCtaTGFBQ3N3ODBjcE9EdDJWdStG?=
 =?utf-8?B?RWw3enV1ZmowT25Mb3BSVkNxY1dHSU00M0ZLbWNTNEZFaGZrR0laalVpdE5z?=
 =?utf-8?B?OVV0a1dhRlQvSFV6UitUUEhMNW1vU2EvNS9DM0w1alRQcE1JaXV1cWpPd09S?=
 =?utf-8?B?WmZpQVZUZjByVUFvbXJUZDVXTXVibGN3MXYxN0U3M2ZMYWFIenNQQ3kxaUxh?=
 =?utf-8?B?OE1iUFRKaTcxcXNsQmVtOEhUd2NYK0hONFM3Q0lpdE5mTm9ndnJBTGg2em1E?=
 =?utf-8?B?NXN5bC9ITHQrVHE3NzNLeEVBc1c2YU1jYVNkOXNCWm5GKytrWFhkZmlZWEVz?=
 =?utf-8?B?THhhY1VobG9NbGR4KzVaNlY1dXR3TTlQOEhaRk5uWlJUNmhEYW5oRFZsSjBu?=
 =?utf-8?B?MDBjWVB5aW1SUzBRVEpIeXlFb2MwanFjRFFuUG1md0NsekZjUTFUczBURlY2?=
 =?utf-8?B?SjBqdVhVcmZhMGhMcTMyTHVNOStjVFFqTW9BMzErVG1JY3Z2dzI3YmtkZEt2?=
 =?utf-8?B?c0xmZzVhN2YwWFQrRlJHN3dXSHRWbFhkWTJOemFTNGlicFNPRkJXTzlmeElH?=
 =?utf-8?B?cGZRT2ZhbmZZMklFZHA0akUzWUQvYlVmdEttZFI0OXVLMm03U1Q3WGZRdHBS?=
 =?utf-8?B?NEI1SUx2MTcvYUpGT25sK014TlZJQVFIRHRJbmt5aWdGbE1Kbm1PQ2lSV3Y2?=
 =?utf-8?B?d1UrdFY2R09ZbVFyRDhPN3JtVUw0T1AzeE9vMGJ1MHNNUW5Ra0EvK1lYWWdG?=
 =?utf-8?B?UGd0ZDlVZnRZUUZzajUwRkxWMWNRVVNkWEhpaDhVY1ZpNkdlV3BTQmkrVVlP?=
 =?utf-8?B?NEdQL29MNndzemQwU0pQYVkvRnh1L251eGYyVW1xVlU0empRazlSWWNLY05T?=
 =?utf-8?B?RnpaeUJtYnZQS1N0NU05VGVjS1ZYNGRiaFc4TmRyWWliOU1YWCtOTW8weTh5?=
 =?utf-8?B?L2NDMzZlUkFNeEd3OHpCekU2bTJTZmFkaklibTJtOWRlRllOcGhVQkVXY0hO?=
 =?utf-8?B?a1FKQ21jbCt2WE44eis5U0o0OXhRcytqWm9FcXFlZXFEdzBzVWd3eXlBZ2hs?=
 =?utf-8?B?d3BDSHM5a2IwRzFwZlRmLy9TNzdHdWs3TlZGSmxRWERQWEN4VSt0OEFYUHJs?=
 =?utf-8?B?b2lIZlcrdE42VzMwSzgyQnRjQXVveWJpTnlCYnRvRmI1cVI2Z2JwUTArWDBV?=
 =?utf-8?Q?hrgZQ0YbBBiFgY4EizjbofQjB?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c39b0f82-4ba8-41f2-0c51-08dd5fa2232a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2025 07:06:53.7551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yQSJaP7nXfIx9e9lyzxjpb2GkibsSpo1t6gA+YYVxVBKitFJyRw050LaSnUvuacRzbjLEiGbzjZVMD5c5F85lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6051
X-OriginatorOrg: intel.com

On Sun, Mar 09, 2025 at 10:21:12PM -0700, Chang S. Bae wrote:
>On 3/9/2025 6:33 PM, Chao Gao wrote:
>> 
>> This is fixed by the patch 3.
>
>Well, take a look at your changelog — the context is quite different. I don't
>think it'S mergeable without a rewrite. Also, this should be a standalone fix
>to complement the recent tip-tree changes.

Should patch 2 be posted separately?

Because current tip/master branch has:

	gfpu->xfeatures		= fpu_user_cfg.default_features;
	gfpu->perm		= fpu_user_cfg.default_features;

Adjusting only fpu_guest->features raises the question: why isn't gfpu->perm
adjusted as well?

If patch 2 should go first, I don't think it's necessary to post patches 2-3
separately as maintainers can easily pick up patches 1-3 when they are in good
shape.

Regarding the changelog, I am uncertain what's quite different in the context.
It seems both you and I are talking about the inconsistency between
gfpu->xfeatures and fpstate->xfeatures. Did I miss something obvious?

