Return-Path: <kvm+bounces-40767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 29FA2A5C097
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 13:20:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D1EF7178726
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 12:16:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B99B25BAB2;
	Tue, 11 Mar 2025 12:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="niFqAshk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A0C2566F3;
	Tue, 11 Mar 2025 12:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741694984; cv=fail; b=E/oiMwtrCbE/5hkmh4trkP47EKzm7NSNsHXvO/gFJFvWon4/7tNluamDXYmY0bPAITX6R3EVJH9ifyyMAZo0Q/bWvRsPzVFzi5w3/5bapclVJodgTnY3/tBnZM3tsf9H2kBv63sqEEGgHXBaQi5P3qWOMdCB18BZ/jzOlK9QRPI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741694984; c=relaxed/simple;
	bh=WO5CijazXof0y5oBj80F5LKTmn0W2Wvm0n4wZUCdQOE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=foK1r503jPbSJddR6hvOszmAiMyENkDv8B8Jt4bggjQl7t/ofYmN9rYdaI9cxDax+GcovsXKJd9e0rwH9eCpz21bAzmHb62xWyhycN0xh0fWXlazr0pknbD+XTaxvjJFNKgKlpeAh2vT9qfvxZ0nooubX6ZeOfL/gbHyZ2+9LQQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=niFqAshk; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741694982; x=1773230982;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=WO5CijazXof0y5oBj80F5LKTmn0W2Wvm0n4wZUCdQOE=;
  b=niFqAshku9gM2Vsx4af7EHCmee5mfakUQcKiaP74Ljw7SHL7tjsreStJ
   /mnwfvMrbfC1I3XdVtfsF7bmuNhWexe+AeJEJK0CFNIETXN4P3sN2nIGZ
   XtR8iUAVIc34EWI5GuicCe2cRs0NF2cofzmu7MO78ZEFyRGv8bvFq9hl1
   PWStRRc7GLahBs+KTz9G0Cqi4IKJmXkj2/30thvP7jK/fdFeE27Gv6Unu
   3JYaDwP0KGj9CNuCvSBCABQpZGthr9nF5HbWo1oJ5TQygwOqG12SbsrF5
   D1SUkWEHJ5NXpMGb0P31ShrS4P1G1dMxnug3vP45vExl+fHZ53Ceca+e9
   w==;
X-CSE-ConnectionGUID: UYsVbq4jRP+gtAEgDNz6rQ==
X-CSE-MsgGUID: Oen4o8xlS4SrCt2SkTo1WQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11369"; a="45512728"
X-IronPort-AV: E=Sophos;i="6.14,239,1736841600"; 
   d="scan'208";a="45512728"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2025 05:09:41 -0700
X-CSE-ConnectionGUID: 5tuPuLcrTB246Y8TxxYzQw==
X-CSE-MsgGUID: H/n4IZP+Que/FDEYeT+C3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,239,1736841600"; 
   d="scan'208";a="120238219"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2025 05:09:42 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Tue, 11 Mar 2025 05:09:41 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 11 Mar 2025 05:09:41 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 11 Mar 2025 05:09:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aMb06jmIhc5gkGTIqnmcwEzGpffOI5fAsbPHQ0kbPPaSTNSUa+LuPAXbLeHSVB2D7v87Q4IRHplwXoIklzbZ2xONZ/sZ5My/AL/8OLVhOjJBZMNPAY42y75UFo0NswDmqPxkrZ6PdQjECO5PcV6BQMNob0c/DpcpcCX9bOeUfn9VALHXqd5+3ly1X3QMOAJ1myb5B75hgVO05S2t1gLMU9SkKP4NLHuOVQZfHeL+EtcNbtyDjv3YA1w3X7ufduw3sRa/jrDSCZsp/wsOMm+oGKeyUQV/ZNf1/+HZ2lS92Ckss0qrArNM8Q25niQZHNVsD7AR845mB0D1aJONaYN4VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vu7dQCP2Fm0RUtklZ87wHkZAW0fmhoYyq7oWR0sKC1c=;
 b=xGn/N2zI9emwqDGm+UN1sdUIAYeXvUSQ0TsIDYyhZmcedQwZPAQQPBIQ4GGsm1p0TUs16AAzMritBqobgA8veGOjhu6zO1Hnb3iPzhTyRr73twUrIa61uJAqYj+6fkkhMXgmGSs1QLF657cr2YwhdIeMJMkVLgcPgXdbzEInbAU6o5cirhvPOrZ4kEoEGt9WVsT23cCJ6ZKVcPrknY2DFOVv6yihBOWGg1AA0ZZteDKV/HPnPV7EKxg5Y9u9GKUSkLzoEPVACszknodwmumx3bxw75YWxfg7A0Be429+cr5td0qJcw2itV/nFjwkf091/bJdVQIutpMkl2gaZ43C0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ0PR11MB5865.namprd11.prod.outlook.com (2603:10b6:a03:428::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.28; Tue, 11 Mar
 2025 12:09:33 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8511.026; Tue, 11 Mar 2025
 12:09:33 +0000
Date: Tue, 11 Mar 2025 20:09:21 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
CC: <tglx@linutronix.de>, <dave.hansen@intel.com>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>
Subject: Re: [PATCH v3 04/10] x86/fpu/xstate: Correct guest fpstate size
 calculation
Message-ID: <Z9An8TJ37Ok8BRNQ@intel.com>
References: <20250307164123.1613414-1-chao.gao@intel.com>
 <20250307164123.1613414-5-chao.gao@intel.com>
 <b34c842a-142f-4ef7-97d4-2144f50f74cf@intel.com>
 <Z8uwIVACkXBlMWPt@intel.com>
 <481b6a20-2ccb-4eae-801b-ff95c7ccd09c@intel.com>
 <Z85BdZC/tlMRxhwr@intel.com>
 <24b5d917-9dd0-4d5b-bca8-d9683756baff@intel.com>
 <Z86PgkOXRfNFkoBX@intel.com>
 <b624a831-0c91-4e89-8183-a9a1ea569e6c@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b624a831-0c91-4e89-8183-a9a1ea569e6c@intel.com>
X-ClientProxiedBy: SI2PR01CA0052.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::11) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ0PR11MB5865:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ca57021-c474-4309-b60b-08dd6095955a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YVFZYndjOUIxMTB3alIwdW16NUJCbWJiR2JvM2hkWjY3dGYrTE9WZkNwaDA5?=
 =?utf-8?B?U3dpaUFzWE9FUGpzSWhyWUpKblkyTFk4blFKU0hIcXJaaUJWNXV6emY4RkYv?=
 =?utf-8?B?bmcxeWFnUDIxYjB1aXJvSDFBbWMyZjFVdWVzVWRzKzlQMDFpbDkrYndwWXY3?=
 =?utf-8?B?VjhGRzFmS2FpcFZhZldSa29aM2hBaytDVDZiS0JhRG5hSWdiUGJzdTRPY28w?=
 =?utf-8?B?eHlDWWlHMm45dkg0M0RNU3QxRWJRbEFyUW1oMXZaOXZSaTJ1WFRkbkZIZmN4?=
 =?utf-8?B?SXpjbUZuZ054REdodUZJVDNrRlI0VE1lQkJQZEwwZUFoUThmRnl5emZKTmg5?=
 =?utf-8?B?VCtkdWxPQVJoVUk3eWRhWmR4WC8rcDNuZnhjTVAwMFNvNjVyTjR3SktvWnRG?=
 =?utf-8?B?aGxMcS9MYWRWOTBMd2pKTU0xK1dFRm1kOUM5dUJhcnpDenBqREsvaFpFQkdC?=
 =?utf-8?B?THdiblYvV2YxOGIvOXpyUjlHL25BLzVyb1Q5dGVpR3hIZTdEZ05IQjUraVI2?=
 =?utf-8?B?dU81eUhqQXowcVFlaUhzRHVGODdNbG9VWDNVMDcxZTBpT1BkSWZoajFobnF4?=
 =?utf-8?B?THFZT0xERWdtVzhDTmk3Z25adUE5OWtUTFhqaEtrL3lCL1NFdExSb0dqcTlt?=
 =?utf-8?B?UHNLUzE2MmtJQ3czdk5zQ2pLd3kwUStzY1RvT1kwZkN6Z2ZjY0M4N0pUdk9C?=
 =?utf-8?B?emhPeFJDWjdibGJYeVBJTk5SQWJHblU1QS9yNnk5MzhIRmQvazkxb3FRN2Zo?=
 =?utf-8?B?dFQ2ek42VllseFIrcTQwTGRRMmJmNnYwN01jdVkzalNVNHo0MW5sR1VPQkt6?=
 =?utf-8?B?a1NxTDlCMWpCWXBUOEpsQ2NweW5RYXVSUjNENkhsNUhkWXlQZzU0akhQcGJI?=
 =?utf-8?B?Tm12VG1mU2x1KzNYeGV5NVY4T1BZWU5QaStYTlZWVGN2NkwyTHhKSVlRNmM3?=
 =?utf-8?B?OWxWb3l1dXNRSW4relhIYng4MjRybEoybmh1cDI2OGt4NVR2MTUwbmZYaTg0?=
 =?utf-8?B?cWdHeVE1Yjdia0NoaWozUmVrWjY5RmRiSSt1aENrY1NYWFVpUzlhZWR3bkpJ?=
 =?utf-8?B?NU9lVTNmVFNTUUlud0thdjF3RS9HdDFHamQrRm1WY084eHVocXlMR3pNazg3?=
 =?utf-8?B?eVNnWlhGK215WVZwZmNFVmgzWGhTRno5dFNqTGR2UDVnazYyQ1UyQ3dMeHdr?=
 =?utf-8?B?a0ZEMnltdHBzc0JNLzZZQWNFK0c4Um9PU1lKNkVOYW5qeFRUckNiWTM4WXZB?=
 =?utf-8?B?RU9kTzgyL3hrK1QwcGc1aUhhZ1JROWxwbTlqVVFyZ3daSlZHcy9WNkhEdXMx?=
 =?utf-8?B?OEp0SnEzWVpiZTFkbUZiK0lSMGlEUjJsZitOdWxiZkJ3eWlTSy9VQm9KemxI?=
 =?utf-8?B?Z3JiNkduYVJTV3JHc3pVdU8rUmhhRkc2NU54dnZZaFdOUTZrRXFzY1Frc1Zs?=
 =?utf-8?B?dGc3dTFETWg2czYwR1M2dGswZ1UxUy9XajVJNXVhb243aTc1anZQWTR2bFgy?=
 =?utf-8?B?Y2syblZEUnVybUdPbnBtSFk2cGJ1akphdm1DcnVvZ3Y3emdjOXRPcElHQk5E?=
 =?utf-8?B?bGtMaUlORHBNdGkrRERRUWwxL0ltUzRKWDM4RzY4cm9vYW94OGxNQnZXRGhY?=
 =?utf-8?B?d05HMjdoY2NvdHJPRkJ5QXFQTUFzZHhrWDByOFVycnRncHVKQ0RWakowSytt?=
 =?utf-8?B?bmVRUDVDK2c2UWVOMzNJQnNVMlUvUzNTOEIzaGROdDl6WnoyZURPWHErSVpt?=
 =?utf-8?B?R3Bqc28zbjIrWDRzQmEyTXVCZ3YzZWR2R3g2Y0R3eDdaWlJSVll0WlNBY096?=
 =?utf-8?B?b3R6clAycWRVaUVBUTAvOTdaQjZkc3RmU0JtL0s2ekhSbDZvcmIrRlFPVjE1?=
 =?utf-8?Q?+2ts10yr2scXL?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TStwRFp3bGtVV1VDVWhRbkVNOC9OUmJoS2lCcUdvbVZ6ZFVyNVd6NkZjRWxx?=
 =?utf-8?B?WE1pRFlsYWRNUlplM3RvaE1aaGVuTUFTQi9WNXdFWDA3SXRoMThBVW0zNkk4?=
 =?utf-8?B?R1BpUDJGK3hPc1VNMk5UU0hlcERtRFRhM05HcjZtNndHVjFwWDVpSUZCTi90?=
 =?utf-8?B?Tm9XZXlTc2ZTSnB4OWhkNWg4US93eXRoREcwaW9IRlYvamVuNlFHclpMamdl?=
 =?utf-8?B?ODY5LzZtSE81NUVXYjZHK0cyV0Z3ZHhXWG5HYktJb2pJWkJ4bzk1ejhCSEZ4?=
 =?utf-8?B?MkdoTE1JeDlNV2xjMHVTRlF6UEZmanhaQlJ3bm1OdzNtK2trYlp0NmFjVlhF?=
 =?utf-8?B?RWoxYXdSYUpnQUV1ZlI2ZkV2aU1Kb3BET0Fva25Sd3VhbngzTjRVU3BlTi9v?=
 =?utf-8?B?MVlJVWdrR1NwVURRNTJZVHVWSWhlQ2N6K1d6aTByRXZQTmJibVBrS1Btd3FM?=
 =?utf-8?B?dVVDRExWd1FjMUNpbUQwUGxVUG5aT3BVZnJwK2p5dFVMZ3k3V1I2VWNQS0xT?=
 =?utf-8?B?NHdUTFJ3c2N3MmswaWs5NVYxZzZJTm9NSWJIeExiRHVRL3Qxd2MwMlNxem5N?=
 =?utf-8?B?MHR1dFNrSEp2c0Z5cTU4NFcwMWVoUk0xWFhPM1RPcWFtcHJvQUo3OTI0U29O?=
 =?utf-8?B?RmU2azNmUXV3d01ORGxST29sMjdRRS9HSm51Y294Y3g1dEdUSER0dm1OREFv?=
 =?utf-8?B?Sml2dGQ0aFBDNSszdEVTR3MrV2tHb28yV051RUdLcFR6MWlGTnkveWpNN0tR?=
 =?utf-8?B?aGFaVnVZc3ptV21CLzJYYWtIRU9STUtCay9NTU9QSWNjVWpFYWR6Y1N4UzRu?=
 =?utf-8?B?YjNNU09lVjlxbW50eHdMQTRnUFNmNWt1Yy9qQWFYNTBqbUFWSXdoTnVpakkv?=
 =?utf-8?B?dWxVcldzWWM1b1NMR3g2K2tOK0FiSXdDS3dyRTc2Q2Fxc005M25jUjBvZ2E4?=
 =?utf-8?B?N3hZcG84UDVzclJPU1ZuSGtDTCtQMk1LelorMThwUEpkeTZvQ1NmNXZXMUlZ?=
 =?utf-8?B?U1BQdUVSbU10c2RIbHN2SGJ3K1hDWlluaUhLZDUwNER1MkRwdi81VXlwM0Z0?=
 =?utf-8?B?S2xyOWJBVEJhaWFIT3RLK2VsMitGWFZTNlJwRlBXeW9ZRkl1M3VuM05jcVNk?=
 =?utf-8?B?VVdjT1EvaHdTQUM5eUVqaVVCMHNMcEpDdE51NGVzbkVUVHFjdUhabXJkVXR6?=
 =?utf-8?B?QXlXUU96SFpTS0xwMWs0Ly9pd0grVU13YURMbTdLeEFQTEF3cHhvYU1Vekpk?=
 =?utf-8?B?V1cvdWdrYmx1YVA1SUhOR3Rsa1pFLzZQVytVYng1RmcvNmd3ZTlzSDNtVVBk?=
 =?utf-8?B?Q0x2ZWVyeG5ITVlwRGdtUkNuUFJYZzRmUlB0clFBbWNwaVlrMjhxb3dHbTJX?=
 =?utf-8?B?WDErSEJuRThzTVJPWWZXeTgzSjY5dUQxdGVZVGVCc3I2c2s0YTBacEVJWFY1?=
 =?utf-8?B?UUlkMHJqd1J5aEhGek5PNFBRWDFEaW53WkdQTlRpSW94ZExQbkpoWklYZTJC?=
 =?utf-8?B?b0pKNkhBUjNZei90TXR0dFg3YTBMNHZXZ1VvdUJqeWxzRFR2WWpQTjlKcXRF?=
 =?utf-8?B?bTgxTTEzVVNYaUxvSElpci9oZ2lJLzhaWmFLZlp5aWtlUTlNR09GS0ZSbTFp?=
 =?utf-8?B?OWRtWVlQa001UEZjeTBHNUFrVDJmSzhPd1g0WERHU05nM0p4LzlHREtRMGFR?=
 =?utf-8?B?UTBzajljdUxSQXZqRlhyeFpENGZNNlQycnEzY0hNbVF1RFBWb0FMVFFHai85?=
 =?utf-8?B?cXV0WWlOMW9KWWp2d2RDbE1zd29LMU8xZzBiT09OZENvV0pCVmtpM1JGQ3hX?=
 =?utf-8?B?ajBjV2t1TDJwbDVwY3IrUDlrMXFwbUVjMG5SeGQ3WEhVbkNCRytVdTZzbkh6?=
 =?utf-8?B?UjNYbEd4SWsycVV1ekVCZUJUSjY2djFLN05iakY5VHczemQ0bUNoenpGNHZW?=
 =?utf-8?B?L1pTOWZvM2Q4cTFYY2Y2M2MzdnZGY1A1TDE3a3JXNm1KbUpXVjQyaTZGYytz?=
 =?utf-8?B?RnltdkRZajk4U2FqZjJjV0FKR2JvdUE0OTc3Z1BmRDhEYVg3WjEwbTQ0TGpp?=
 =?utf-8?B?cTMyWHptOHlDeTFRQU5yRmZQZktJdzBKWG03T0N4ckh4clFGZHVpcHpuSndi?=
 =?utf-8?Q?RoRb95yqaJa5sRnUdVacffiMf?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ca57021-c474-4309-b60b-08dd6095955a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2025 12:09:33.0180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MM6bGTZhGrxAaPesyhzBdSlYu8VgDUTR7qKbDBioTuuh6bF9F8XFhK8DtUcS01LBL+6huotL9My9TF0xavslrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5865
X-OriginatorOrg: intel.com

On Mon, Mar 10, 2025 at 10:33:20AM -0700, Chang S. Bae wrote:
>On 3/10/2025 12:06 AM, Chao Gao wrote:
>> 
>> Should patch 2 be posted separately?
>
>gfpu->perm has been somewhat overlooked, as __xstate_request_perm() does not
>update this field. However, I see that as a separate issue. The options are
>either to fix it so that it remains in sync with fpu->guest_perm consistently
>or to remove it entirely, as you proposed, if it has no actual use.
>
>There hasn’t been any relevant change that would justify a quick follow-up
>like the other case. So, I'd assume it as part of this series.
>
>But yes, I think gfpu->perm is also going to be
>fpu_kernel_cfg.default_features at the moment.
>
>> Regarding the changelog, I am uncertain what's quite different in the context.
>> It seems both you and I are talking about the inconsistency between
>> gfpu->xfeatures and fpstate->xfeatures. Did I miss something obvious?
>
>I saw a distinction between inconsistencies within a function and
>inconsistencies across functions.
>
>Stepping back a bit, the approach for defining the VCPU xfeature set was
>originally intended to include only user features, but it now appears
>somewhat inconsistent:
>
>(a) In fpu_alloc_guest_fpstate(), fpu_user_cfg is used.
>(b) However, __fpstate_reset() references fpu_kernel_cfg to set storage
>    attributes.
>(c) Additionally, fpu->guest_perm takes fpu_kernel_cfg, which affects
>    fpstate_realloc().
>
>To maintain a consistent VCPU xfeature set, (b) and (c) should be corrected.
>
>Alternatively, the VCPU xfeature set could be reconsidered to align with how
>other tasks handle it. This might offer better maintainability across
>functions. In that case, another option would be simply updating
>fpu_alloc_guest_fpstate().
>
>The recent tip-tree change seems somewhat incomplete — perhaps in hindsight.
>If following up on this, the changelog should specifically address
>inconsistencies within a function. I saw this as a way to solidify an
>upcoming change, where addressing it sooner rather than later would be
>beneficial.
>
>In patch 3, you've pointed out the inconsistency between (a) and (b), which
>is a valid point. However, the fix is only partial and does not fully address
>the issue either. Moreover, the patch does not reference the recent tip-tree
>change as it didn't have any context at that time.

Hi Chang,

All of the above makes sense to me. Thank you for your review and suggestions.

I will update the changelog to reference the recent change in tip-tree and post
it separately.

One thing I'm not entirely clear on is "the fix is only partial". I assume I
need to update gfpu->perm to reference fpu_kernel_cfg to complement the fix.
Is that correct?

