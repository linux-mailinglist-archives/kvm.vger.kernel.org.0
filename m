Return-Path: <kvm+bounces-35346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 55D8BA0FED9
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 03:40:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 679F1188636B
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 02:40:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B48E0230999;
	Tue, 14 Jan 2025 02:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sp/fKU8y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D848488
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 02:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736822437; cv=fail; b=Zneie0cP/rZjSatCFqHJ+d1DUqqZXEbLId26zUS9+U/dzLWWnSnOu0ol5or/9ifIQ3im0AUyu+is1kQ+qFdEG0ABAvidGR9euqNCLdmFbXc3Kfrvbh+WD+xVvhCmxJq5Rhr9+eHC8WRVamzRAbSfi2LBF1Pxkf+G7iQnnuo1mOU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736822437; c=relaxed/simple;
	bh=luH5rhv//GPTSsLHUOvhlNV93EGtyJJeTio57kurHvU=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=W66P7O1pzrgnZ5JDm4Eip4CN8hi+6Uo3YyynT9GeYhAcY/6k6NPS4daFJ7NBY8AziCvsnii5CjQzi2NRyPIhvvx16Bwa03dJS3jEvqBPZ/cCPJKtHsTpbSoQp/ZKndYjdP22PjMJWmlz5NBg6PeNu5YbeQLvv6xxGSlud0mt6W0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Sp/fKU8y; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736822436; x=1768358436;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=luH5rhv//GPTSsLHUOvhlNV93EGtyJJeTio57kurHvU=;
  b=Sp/fKU8ytYlgi1YTO39hNEobfgxDf9o6JbwyYApb++Mm0/2ghoUhcZ0W
   NSBES0eoqDFIpvVk/p0wPif+GvnxyMdvNuELE7BxfPmIcQ+ETBmpqi4Ay
   sBZ5S3pCvxj8P2wCSbUgHRp6VqBg4QKEhkuWrt/i2Y1VbrwT19JO4gyVO
   KugFnWtYF5lvJEvAtLdmcRPsB1nTn3iJgBAvmDXw4PW5+eEQ3CPCQZIjf
   q9wSXZyqLWPyu43+vRL3m3rsMKAbdDnCh9fTH4gQxt6HYTq0UiH1pkEtS
   7F5l2MfnzzSXrpe8Be7IhH1+h2OCLWU37uzjNMy4wg6UtFh7zpiDVEdao
   g==;
X-CSE-ConnectionGUID: V/yjzJO1RrWEKkVjLoJHYw==
X-CSE-MsgGUID: E2AO7F2JQv2kWhIzW1gwiw==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="37220558"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="37220558"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2025 18:40:36 -0800
X-CSE-ConnectionGUID: FmSsd5oeRreLvd7OSH8j/g==
X-CSE-MsgGUID: zL8MtHyZTVCVJU+9OXZkIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="127913566"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Jan 2025 18:40:35 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 13 Jan 2025 18:40:34 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 13 Jan 2025 18:40:34 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 13 Jan 2025 18:40:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=elyd9tEin+PLDnSABZs9oukA8cjLfXc4emuIjRGwJySbpEphHSSLlMs1YlM+JM5Sa86NZ2RNJiEkZ3mhuyyPUY/BRVsctZKAfLx6Z3p2Rcv0IFeDrNqs/wK4BX/i8MPZOx0lJMzBHPNAecglCpOU+09TOo2KzGlkHjXc3gjtFdBPnjjnZ3m5LiSfDbcxYoCBjZDSNkqkol1UBS63QlJeCQfZIdfOfuYPXawvcSsnss2SjZz+4eOLA58YjNTTsFHoJExXd+dNsPm7sA9WXbxCMXQBEhcjEfFpXr9/w2tL0M9fclSF+2OMXnAGrekfg2l4msi/I0RtqV1RqjtKssX9oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w4mVuz6wUA+5fmqKnR88sHqE4/VQ5p6HLwUVaJqMZ1U=;
 b=IeHYxtFZfGOkiMYG26kzH5rR5THldpzEEMDlhKA2Kra4FEFZKl8SapVPRfsr06slRIFxwJP86jVUUypjKBLj2T+/EbsAxbTh7+CeYh0rZAMYQfD7X0TSjjObT6p2clVODZDeIzb709GUlFEW2sw2XZgccL0WyD2sdof6kYXCUV0XZM/yNjZrw8tKONzLMrl//yX2E/LFxbkx9AWxVAG7zh/JSyjwy/19knEd4QQDkzzzYcJhJSX+v0q3eIHyXp9fzoU7ToE+/YP+hhM+N5TPY0+qSp8XUbXBNb6WjuBPEnNEZstiuBhf4hwaFoToXUfopINg2kTPxBjZyOtfMLzVtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by PH7PR11MB6547.namprd11.prod.outlook.com (2603:10b6:510:211::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.17; Tue, 14 Jan
 2025 02:40:31 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%3]) with mapi id 15.20.8335.015; Tue, 14 Jan 2025
 02:40:31 +0000
Date: Tue, 14 Jan 2025 10:40:22 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Maxim Levitsky
	<mlevitsk@redhat.com>, <kvm@vger.kernel.org>, <xudong.hao@intel.com>,
	<oliver.sang@intel.com>
Subject: [linux-next:master] [KVM]  7803339fa9:
 kernel-selftests.kvm.pmu_counters_test.fail
Message-ID: <202501141009.30c629b4-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SG2PR06CA0192.apcprd06.prod.outlook.com (2603:1096:4:1::24)
 To LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|PH7PR11MB6547:EE_
X-MS-Office365-Filtering-Correlation-Id: 5105f1b7-c378-4906-f3df-08dd3444d032
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?v9Ph8Iji1mBb6CCzTPB4VBOnV9ufbLdXDurvhtyz6KLh7B1dMHvF+mJU6LQf?=
 =?us-ascii?Q?cPcR2/bptaLjqO+dz4g32OlcE2/gRWv/jSZIgUdlPV+0chDvjtZKagUQ9nOH?=
 =?us-ascii?Q?hjJgJI49I06HpqpnCthYRLMgR5NVWHU3DuwRhJE1sINMBlElSgVGAEeQmFte?=
 =?us-ascii?Q?y2I4CVD3UHQ8AOe/Yt463nhHC8s2w4thEQ13Ni4OtwprZ0jT7Zr3q7FamyzW?=
 =?us-ascii?Q?aiOrYK1zdI5YJi+7aElSifR+qYEVexk7lIrMUqE1lJVPpsMT8xzxHc0pLyPq?=
 =?us-ascii?Q?gZPyFawkiEnFFemMj7ElchUFk8399+uWwZ1IAfegNNdoyefuJYKcGqjN2dkc?=
 =?us-ascii?Q?ijXIxbz6nukVghqgSFS0GLaQnye1rZr7IphMV07bv5VenoG9BS8IgKus63zq?=
 =?us-ascii?Q?+nJ/lwnTfbyEAH9Zme/OgcQnb0RhGVlSYx3NrVTB9pj5a3Lx4j14fdHMoxRO?=
 =?us-ascii?Q?qfjdfCjYB8gcwcaQn36MXWJb2LtpHPF0/0I1ycLM47HZZggQAczvIb+mnqq5?=
 =?us-ascii?Q?V5anhSdcMzAw64CEJ8DdFnBMJea19ld3x1EbfeAh1Q2MsUCLR4ruGrRmAcbo?=
 =?us-ascii?Q?eJCQzXAsdbSwHEMeooMUc8eTgzGn/nKuUaMQ2E9X1+hhYe6/T6tJh2lyb2ei?=
 =?us-ascii?Q?k3jP68vB6gldkYfXMuCtRhx8PMGEEUqOBVEPGZFR8l5H3oJggCCyJsPisaqy?=
 =?us-ascii?Q?SjhABHTkCL/iwGMlqHVJPpPdx738/Ufm7TI87n042QsuLeYx3YwUeJgoSNLU?=
 =?us-ascii?Q?yLRM63Ne80Etn/3qu6WSBssePbOJRLKOIH7yeiWvr8sSK44UAfa3TiKBL0nW?=
 =?us-ascii?Q?vhfsZQ9GR0JI0ytZ3efOSO9j2vsbeZtAAKrnY6S/rvyuWpaLWweafO+J5eh3?=
 =?us-ascii?Q?g3HpGxTksP/T9WyYJFWtVAwzeuvoJyeCt0urMCOmcYV9doMg0MCJGqTZ1Tes?=
 =?us-ascii?Q?4qckWuj3PVNdwU94AYeHzJj/Smlo1LY/AU+KR6kdQV49bmLtKmV7Ge3V+uWC?=
 =?us-ascii?Q?T68w34IMyBO6YE/9w7sNeejjlxQ2ES9Ji5FouSkFBoc8MKwAl3lswN5+BqSQ?=
 =?us-ascii?Q?0TJuxXhocKpQAKzYYupg+TleGWuY12WQwGrp533rLg3dgRL2e03vrW8bHaYc?=
 =?us-ascii?Q?8R+lQpaiGEjSiWyfo3m7Ycy5LvQNTBOby9xSc4XIhqvKh0wCyl7iLgb1DmoJ?=
 =?us-ascii?Q?PjOJL0sFzkLDzZWqq9mGsQ65OhEJnpyKKQBmo97JypNP+eHYKurBE0DO/Qut?=
 =?us-ascii?Q?qYIhOsc3CejWqx6PkFvQRMBdebXUHztUr6ibxM3dfo6OmIr46Ptyw/+6Przi?=
 =?us-ascii?Q?OTgjUwuq62fQXI/CpS+QUhdkcPowBG7bBxS3N23uvsD+Ew=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WyepScdhVRVHshkVD6ZZa0VJage7JdnDUSQ2DbcbcCdh9SSewqQ24Hr0zogr?=
 =?us-ascii?Q?thryU05mjOfgWsV1FuNpc9vy75ontlJwfS4fscXqktXdk0B+dX5tv0CDrKMB?=
 =?us-ascii?Q?bMXlyGHQPztcK4k81jOixqFczxZIE3EaanFBPM7ei0qQwgYQOI9KnKtQjrS9?=
 =?us-ascii?Q?qEAZI3kBZFmg2iMy6nDQqXRQObop77nK1pqDPWEgSgLU8SEtyeQX0gv41RsJ?=
 =?us-ascii?Q?xjArRKoOsG37uYN66qBez2IbeWnx3vaZwOGahrP6nbxUu03BRxcSQhsQwSTA?=
 =?us-ascii?Q?XUOEWEzcltLvMSyWmL/m8v/dUcdNTM9NDQncRjeAkkntTcOxCVXB0UobII0C?=
 =?us-ascii?Q?cbw5WjP0/K8IqUCUAVGqUmaFDHGoFpfw26kcyRMWLjhm7thJc0j2j7fzCKTT?=
 =?us-ascii?Q?tMaSEx2W1OE9/6fVxlORVApheWSGaPQSn7Ei7W+iEvlfbLqVjm4T7UC8TxeT?=
 =?us-ascii?Q?vWU7WYrIqBcxwc3y6YjTNKls4GmgK9ce04miSJqsHfg0a0Kh5EmKjCsdjqGF?=
 =?us-ascii?Q?O1bE/ApQXZ2UK1MK+hAQcGCwte708lZ4eCtWlxkzCpATJJVWNWEoLVgIImNR?=
 =?us-ascii?Q?LEVRf2lspbrs7V2hPr5Jq2tgwk0pXpBVXhDS7mC/yMWylchTcm/qiVFkiptC?=
 =?us-ascii?Q?OASKQrw1Jd40H0R/vekLcL0QM6A1njO07z+FKHpU1YT+Oy/JslLgQRyAqgCe?=
 =?us-ascii?Q?esLwpTYNq8Bv1N+7+J/B3lVZ797J174MPA1+IhveRB/SYzw8QGZ3H60ao8Nt?=
 =?us-ascii?Q?If8eqxNS0pT1f0TwfLQe/4KPJ3ZAJZ+alJrg085fsq1lnX6Dy4bV1Ity9xmR?=
 =?us-ascii?Q?Nc41DLGGKvcoFsO5X4YabsfDDHzN3XJl5fuZLF7h/DE7g198LXF4pD04R+QN?=
 =?us-ascii?Q?F4CTBbde5XX546bvCAuf789nsf+WUnwSSSPSBXaHE0U3O/cGKsJtffyfln/Z?=
 =?us-ascii?Q?1Vtvfd2ayBP1jIheNXTgShhVGep/mxwHL5SajypVihISQ9nCh5aHrCOVagWK?=
 =?us-ascii?Q?Ida7EH+Nex3Heemb83bQjCngMRAU7eRqj+7hfBA15FdLF2/JsJSdLoEDUQhG?=
 =?us-ascii?Q?umEvfJYX5HEOP4GYhKsWyS48czuulbBWjGdjzAFFkyXzKKcA4WIvEytwlfuZ?=
 =?us-ascii?Q?+fCdLP6YpmXiwdhg5s2vLUb5kBiJcB9+YBL6XyUmbqsF72RBAR0sV/riZTMV?=
 =?us-ascii?Q?PIfR4vJ9Gu+IkD/q2nlXx5GgqpVY39aS5neC1+mNn1hVsi6eLXLHoUliFQNv?=
 =?us-ascii?Q?aHM19euoUYXymhre1oKo583DgeLXaP/eiBT2owe8W//i0T/RTYnusSTElxLg?=
 =?us-ascii?Q?n92AUjwTnvcFX1/PQO/rWC4XEAVVSRnlmpvUM9uPWQ5+WO46W7XYwyg63MpQ?=
 =?us-ascii?Q?Srqpp3ZMibw+vqzFmZ5HKEdn2gxfZ32hrQi0YA7gMhqMh9jI86Ts5DL+hyIV?=
 =?us-ascii?Q?O31H499XGv7cr8F8L52oaSRUbMjIkau2xhF/RFDmwLfztIk11NsJsAAnKwsx?=
 =?us-ascii?Q?u4WGR4vMGzq4Dewy/JawKJp9/qNnS1LZpIQnKRD7VukmCOSkEIRtSpJqn1dy?=
 =?us-ascii?Q?qnjzGTSFPQmCZee5l5P9omPN/COrlpo1TqI9RfgRRrBJHWlDcuzameCxYg9f?=
 =?us-ascii?Q?hg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5105f1b7-c378-4906-f3df-08dd3444d032
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2025 02:40:31.3145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Iyn3O1FwRHl6FjunAXVQX44el342TCR17oaOrakjinlQf579ROsDQYF18UrhcOTIG9R3Mr8s/2dWPSEgm+XmUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6547
X-OriginatorOrg: intel.com



Hello,


we fould the test failed on a Cooper Lake, not sure if this is expected.
below full report FYI.


kernel test robot noticed "kernel-selftests.kvm.pmu_counters_test.fail" on:

commit: 7803339fa929387bbc66479532afbaf8cbebb41b ("KVM: selftests: Use data load to trigger LLC references/misses in Intel PMU")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[test failed on linux-next/master 37136bf5c3a6f6b686d74f41837a6406bec6b7bc]

in testcase: kernel-selftests
version: kernel-selftests-x86_64-7503345ac5f5-1_20241208
with following parameters:

	group: kvm



config: x86_64-rhel-9.4-kselftests
compiler: gcc-12
test machine: 224 threads 4 sockets Intel(R) Xeon(R) Platinum 8380H CPU @ 2.90GHz (Cooper Lake) with 192G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202501141009.30c629b4-lkp@intel.com



# timeout set to 120
# selftests: kvm: pmu_counters_test
# Random seed: 0x6b8b4567
# Testing arch events, PMU version 0, perf_caps = 0
# Testing GP counters, PMU version 0, perf_caps = 0
# Testing fixed counters, PMU version 0, perf_caps = 0
# Testing arch events, PMU version 0, perf_caps = 2000
# Testing GP counters, PMU version 0, perf_caps = 2000
# Testing fixed counters, PMU version 0, perf_caps = 2000
# Testing arch events, PMU version 1, perf_caps = 0
# ==== Test Assertion Failure ====
#   x86/pmu_counters_test.c:129: count >= (10 * 4 + 5)
#   pid=6278 tid=6278 errno=4 - Interrupted system call
#      1	0x0000000000411281: assert_on_unhandled_exception at processor.c:625
#      2	0x00000000004075d4: _vcpu_run at kvm_util.c:1652
#      3	 (inlined by) vcpu_run at kvm_util.c:1663
#      4	0x0000000000402c5e: run_vcpu at pmu_counters_test.c:62
#      5	0x0000000000402e4d: test_arch_events at pmu_counters_test.c:315
#      6	0x0000000000402663: test_arch_events at pmu_counters_test.c:304
#      7	 (inlined by) test_intel_counters at pmu_counters_test.c:609
#      8	 (inlined by) main at pmu_counters_test.c:642
#      9	0x00007f3b134f9249: ?? ??:0
#     10	0x00007f3b134f9304: ?? ??:0
#     11	0x0000000000402900: _start at ??:?
#   count >= NUM_INSNS_RETIRED
not ok 21 selftests: kvm: pmu_counters_test # exit=254



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250114/202501141009.30c629b4-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


