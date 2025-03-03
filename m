Return-Path: <kvm+bounces-39882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF58FA4C2B4
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 15:03:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E2533A8C1F
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 14:03:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09C7B2139A4;
	Mon,  3 Mar 2025 14:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XIjqL4YW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E811620FAB5
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 14:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741010604; cv=fail; b=iRQAd/+CIYoEJF/GA38dQWj1r1tCcBk6eKP9POpW+s9G3L91qVEDZzFQCCO+JYOBqdkEHu8NgMb4dt817d5OPf68jiDzfIPoFHcQ3+XQ1BzIZKVzbA9McirutG8kPKIHXFAlRE/hNcgYaI1Sn9kz+MlZlZNC8ZTQ03jOSD3dNys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741010604; c=relaxed/simple;
	bh=7cSfLgCX1+jyH/wMYUmjkKh0F3q1IpngnxrGVnyrmb8=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=EFXmjEZn9OOb14zUSQyJ9Q95THyQTbyWsp7aWRK5Gck/iGQ89NAtiZ9fbVYdlUJzjqvb9e3jlv/ltqqJ4pDAJvMvLS3Ku+300ctVOZTKPF43A9TkyK97kf4m/bpOnBNm8dHVypoN8hiQrQKUiauwpJ/NGVdEqhqEVwWz9SmmiSM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XIjqL4YW; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741010602; x=1772546602;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=7cSfLgCX1+jyH/wMYUmjkKh0F3q1IpngnxrGVnyrmb8=;
  b=XIjqL4YWQGi/LWAKfNCy8v6gpc3RExp5AQqMCEjyB8dUE3EUEwSvnGVO
   0AxXCbvmC+50DqyZs2dKYkVbI1bsrcA4nuuW6oEgK52EHiJgoGHduWOae
   FdbOAu4afECmpNCVdmAnwgTJLcLhX0xJNLdwmvX8IeNHyqSsV+pi+yBPA
   TSf//sy0ocgNDj+AR+uROrM0AUwMVKhZCrjZNzWW38wjRE9qzW9dATkwJ
   hvIDAS8/oivk3qtrq73gB5MSqYJMojE88iO5wT5evlyXkusmt5YCfOpWV
   ZvGfBUn0KCzqXEfv0MAu0nI44J3ivu074ci16TFNdC0CWW0/Pzuxg/e8r
   w==;
X-CSE-ConnectionGUID: 8MDn5jqLRCeXsWJmSxnAxw==
X-CSE-MsgGUID: RblGRfVoRdSexobrcxxQ0g==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="52863596"
X-IronPort-AV: E=Sophos;i="6.13,329,1732608000"; 
   d="log'?scan'208";a="52863596"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 06:03:21 -0800
X-CSE-ConnectionGUID: pLQ4YfdxQu6HQtYbYW97PQ==
X-CSE-MsgGUID: +vJZZYg3RuyDVMuw16vj5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="log'?scan'208";a="123235645"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 06:03:20 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 3 Mar 2025 06:03:19 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 3 Mar 2025 06:03:19 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 3 Mar 2025 06:03:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xNUUEdsMPvrmO+av4dP9Kt9Q2fzLNzIsXQomTQCG2uWweU9WHsX2Qzw7vacO5qVbfUeUreyw1epcqt/H1SjP178B9wfZ1Ow6q6JP+K58P17bxkYdJMacG/yGfKfit2g3VS73YHEviaoXgZcEVX+XSv5oltoNxrLJTbqgYK2xRkS85kSfhh0O9vZyU37BxWstg7WH0Q3S68clqq7sxuiW7FIbpKx6CSckws3XHVBnf1YzjZGxRpfr3e5LyilqwNais/S9+g+n+YYjMHZ9eb0OYS3Gw+MLEfsSILCNq+6zC2N9O4HCcgH3lc+qD4vj4siZ2KJ8lQcCQiqknOmfTjYj1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pglIU2kGn03iOnLshxU2J6q6fL/2NGlchIw0ut/xwcI=;
 b=TWDRxBj8sDr8xouLPN0q4cwPaeW9N3DWIUd3XOWf+ZD1GvReDoYFDALLFys3kZt8U1nuzePFv5jLIWYBUBCtMrqOqYpX099SyaD/AS6Fdhi9Afg+9FeNkq3tAGRfz5GhLcVbCJtwv9x8Bwjqb3clHHxgHNlyNnea134wGPDGEX71iodiigsSSXd+dFoSYqvV6hGxpxx0EHl4dUAV2ebE4OqC7IsJgGE+wFUl5GG6MpYa+ZPXVzZkYKqBkd3gKH1fayHpOtkxmSLxGQtuW1qC4AhK0SEhPCe06hlIMLGw74HVmrnbL4HEClz6xCUx+alssYM5XeXBgY7FAoYbONzVQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by CH3PR11MB7675.namprd11.prod.outlook.com (2603:10b6:610:122::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.26; Mon, 3 Mar
 2025 14:03:03 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%4]) with mapi id 15.20.8489.025; Mon, 3 Mar 2025
 14:03:02 +0000
Date: Mon, 3 Mar 2025 22:02:54 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Liam Ni <zhiguangni01@gmail.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Sean Christopherson
	<seanjc@google.com>, <kvm@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [KVM]  4cad9f8787:
 kvm-unit-tests.vmx_apic_passthrough_tpr_threshold_test.fail
Message-ID: <202502271500.28201544-lkp@intel.com>
Content-Type: multipart/mixed; boundary="XmqCeNDaaVDiBrg5"
Content-Disposition: inline
X-ClientProxiedBy: SI2PR01CA0018.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::7) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|CH3PR11MB7675:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bbd703d-590a-442c-ac9e-08dd5a5c1cf3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|4053099003;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ptoSEmSr9JFLgFz+ymbpEVXecvXFeaVlWBDgjbj2hcOBxBfJeGrIONVvhlLa?=
 =?us-ascii?Q?LF4voEAb0tHFlrNrOMJ86yaDMclDBqIqSjhaSj5aPUuybkGciy7fdKnvBy01?=
 =?us-ascii?Q?E7j6SJiuffs0wMpnfgfC1cmAnsQoMxZYo9v9/f5Bd26UhrENSB/7V+opc3Cw?=
 =?us-ascii?Q?ydaUR7e8btFzYIjIeY+HV8U9C2Bg7nuDCqrPi6F19eTSlJEfXz4cZr7wkBOu?=
 =?us-ascii?Q?TghK/d90vpdqdvupGEMzgXDxJgJGuD6QRPJBidBzyq5cGyhrB3tD7Zo5rYo4?=
 =?us-ascii?Q?G3v0Q1stEIpozJv9n70E7xQENjN9x1PO3p1YfyOS/RrU+1Bh72geX3fpn3b+?=
 =?us-ascii?Q?Ks/wcRu27sL7spgWReY8JyWAKpCoywfmzxGM9EPPLcKx8Hq0LJyFxEgbJMWY?=
 =?us-ascii?Q?rlowipg1x2patSimW4gSSyfJ/9TmdsnHbfXGSQ+C6xQSfNS+Xz/asMeIklWa?=
 =?us-ascii?Q?y20wTkJjGUnUsDQrEVBjfd4V9FzIRLRu1xfaPQatMdApIAjGHWNK2B9RzBEP?=
 =?us-ascii?Q?89OQ3tPkofigN2tsYQyaVgBHGuokdNFT22iqeFGGgR9z+UF1eSCpsCTjZahU?=
 =?us-ascii?Q?DvKf6TPTdS6Hj2w0/o1KKUNnx+P8e9a0p82Sof73dl6GB294liojehzF83wZ?=
 =?us-ascii?Q?yLi4pRFktGG0YmQiT2+7JhIpbwHTiZEK8jCb5zjqcH8Zvf99G9DfzpwFsQ6Y?=
 =?us-ascii?Q?o1Yn6DkiBeGFPX/aHbkA2PjWhP7BoUBCWOZtBflQ3PDCKDbS6zeGpVsX9+p8?=
 =?us-ascii?Q?3zsfxMtgHLRAxWWIKCpQ+Iq9jnYstq9l7HaUZ0/i/wHGQIBicEcktbhaOLR4?=
 =?us-ascii?Q?kTIynBeGf3sqxs0YmJph5FaEKj0/YXT9DqlvnWWzVjwJ4/RUkMPfC6uOtJ1T?=
 =?us-ascii?Q?3MwNLf8dfjK5YDgPRytfT5HGJXAXzgpSxTh7ePto04MxET80f7rsD9SedqoY?=
 =?us-ascii?Q?oPWaaYPRc4Qexz5TXHo4sSKkRMMXC7irG77Jv3W5EMDTWXVHawoQXg08AvW5?=
 =?us-ascii?Q?GvJ5ZYOPg92DKJinaQuFdufsvELDvFpSfJPm+AOd4h7TZvDOATdUb5vwB+Ac?=
 =?us-ascii?Q?2w7mVkQJCFJmI05DJDgdRRYN6qJmxvm8S2rrDCxLW1e4IG++S7vg7CNBDY2L?=
 =?us-ascii?Q?a14GeGKL6LT2XnEf9q/qpoC9JyFIeiE/vZhqoo0S8HDzYXFFHpV1wxrL7HOa?=
 =?us-ascii?Q?bTT+K2Kw7AOUmeJ3AA2LQvOqRLsfqjWjSXXNJgbwPdaQIgrOwK1eIjxZWuMG?=
 =?us-ascii?Q?iQJlHPJoaEuomkyYWZ3NXdMXT2rAfdb9tTi55zc4GCMj+2bmWgZhHGQASJ3m?=
 =?us-ascii?Q?7cRf4fddTEJykflYNUYUYOkq7oPoR8HzJ8xhX+lNHOApwg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(4053099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tt/fwYwrGE6vMGeq7ZcNXPhGns6Hc4MRl8KTnyillhoqWiC035U6MSM9v8CR?=
 =?us-ascii?Q?7xtJ3l2CeWn09EilCkUXHfNhVXNIfDD7CbVHgD7oxTNsrIyF4ff7e1Wn6rfs?=
 =?us-ascii?Q?YTBxlFCHCnc7ks54LRfINXBYZ4MDQY2WAV2NMzPCxSgbkkuhWzN6bC9bSey9?=
 =?us-ascii?Q?WdOG73dZ9Gw6XPOlvyq0cD3ygvB/oOWSMvMgaU0sqbfgI26dWZ3bk0VHdV60?=
 =?us-ascii?Q?j+dFHhSmRWvJuRSqJkUf4eAY0pboGLyct+NaEnifZ4Oo8NjZ2op9BN7jHsJA?=
 =?us-ascii?Q?iS1HGSeqFsxedPX+lMLiaJaQHaXcvsF09WA3OJCcipgV2Lp7VV8/ZOHwSTOi?=
 =?us-ascii?Q?/KDSarcu7noXj/TzwUhiM2Fxx1LEWhdh6U8cv2Z6DUr2yOS5JGtz5W2P89dl?=
 =?us-ascii?Q?tcseEZRKbQvbxVKURtcOpXuL00seXRlj1kxTp4j9WTWYJyxAkYS01oq06wKf?=
 =?us-ascii?Q?NrKlRZl2w70HcupVialmXmqZNzEYxRcNvE6hFtvxtKjKmb1pWR55/A1+xxQ+?=
 =?us-ascii?Q?fnV0RkV3kg9AH5cvziWqm7Jh9RB2tx4LWkNc0vLZRZXcU/T6PjsSp62eb44s?=
 =?us-ascii?Q?uyLsyMctfhT9BafByzmVD637iF1IgvrxGhjJ9zSkTVW5v6dEVtz/seEioUqR?=
 =?us-ascii?Q?Hbc6qhcvA0qZGgEfdkX9o+El6jDSQUOqiek9LAkk7Nkjux4neXmZSmV+X+JP?=
 =?us-ascii?Q?KB7MEHfxZ67Ab9h4aiWz6fPQ+bIkZlNvTEhUJRTjfv2njFnuITBOc8FOiavu?=
 =?us-ascii?Q?fs1xPAQ7mNr6EArNI1MHLGs+sKDCoRUFtwjliKpWrmd4iOx9bwnbUyMJ7BE8?=
 =?us-ascii?Q?ZZAjbLhKjRGQhFVgNTCd84d1Z9biBoNebxCijQmxDhxsO18QNYvQ2nN/6s2s?=
 =?us-ascii?Q?/naTMowDJsouF4lVjQkOs/8QbY2DqcVDAEu/EmfbX3JckCwSdCsbPHC9vJit?=
 =?us-ascii?Q?3Ph+FXohRYkhQcq0jzlHf2kgdLHLbSWIZ5FbcDMhVbOWu+6XKfKsKFwHF9Zz?=
 =?us-ascii?Q?M3TWL6PhdA8gi7AolWej4JJQcC3HrzEhbu/9TGUYEFSs4kZMM6o0Rh4GvS1L?=
 =?us-ascii?Q?awDKAedQp3Qac+tJLKcbqyQplQVVZWINC+l97/OryBgYCAZ6Nrg/VMTYYkrE?=
 =?us-ascii?Q?e1p2E4LYhMjkoaHRGNMs7dIkLXN2IorzbtA0Cd7m/suL5ubuYtetUd46xlcK?=
 =?us-ascii?Q?XSoIkqzRgxK2EKpM2O8BgqxLI3tZT3FNGYOpYXS2dmbj54jiYhzU0LMKJPaw?=
 =?us-ascii?Q?d4TEQzwpVXiWwVlFxjTeTbU4emrQX7QrPHMlkjrwY3wcYMwgiMBcA/gerZ2j?=
 =?us-ascii?Q?dAtjWiTvk2KEvlj1/4PNzYyrfqgwzNQ+35WxGyFQ013TPWDxayX0eEGggIrI?=
 =?us-ascii?Q?idIYYevrWiAWpgzAwqoLg5fdF3gRDWhBFhED57fZm8vv/1PZJ7gnkPvEygRB?=
 =?us-ascii?Q?KLG21R3UecHhCCwfTz/lTy2GgWp1jGpYy9JKAVpNlGYoerWGkL/Ze86ZA1P2?=
 =?us-ascii?Q?+I1icYmqjACg1ktMdqBa7UQjkvBdKusKgf+4+7I8z6TmTKM3tWuusdazkGjl?=
 =?us-ascii?Q?p4r7sQ2otVB6d13s7c7CXCSL1NyEgDV93L01YL+x?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bbd703d-590a-442c-ac9e-08dd5a5c1cf3
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2025 14:03:02.7154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4dm4GTLV9e8yPttll4WkgOhdx2YU/X68W1bPun+O8f45aGwd7mf9p+c4Hr1nLohI5zlnoh8HlaGxyqE7q+FDJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7675
X-OriginatorOrg: intel.com

--XmqCeNDaaVDiBrg5
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline



Hello,

kernel test robot noticed "kvm-unit-tests.vmx_apic_passthrough_tpr_threshold_test.fail" on:

commit: 4cad9f87876a943d018ad73ec3919215fb756d2d ("KVM: x86: Wake vCPU for PIC interrupt injection iff a valid IRQ was found")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

in testcase: kvm-unit-tests
version: kvm-unit-tests-x86_64-f77fb696-1_20250207
with following parameters:




config: x86_64-rhel-9.4-func
compiler: gcc-12
test machine: 4 threads 1 sockets Intel(R) Core(TM) i3-3220 CPU @ 3.30GHz (Ivy Bridge) with 8G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202502271500.28201544-lkp@intel.com



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250227/202502271500.28201544-lkp@intel.com


[FAIL] vmx_apic_passthrough_tpr_threshold_test (6 tests, 1 unexpected failures)


also attached a log


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


--XmqCeNDaaVDiBrg5
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment;
	filename="vmx_apic_passthrough_tpr_threshold_test.log"

timeout -k 1s --foreground 10 /usr/bin/qemu-system-x86_64 --no-reboot -nodefaults -device pc-testdev -device isa-debug-exit,iobase=0xf4,iosize=0x4 -vnc none -serial stdio -device pci-testdev -machine accel=kvm -kernel x86/vmx.flat -smp 1 -cpu max,+vmx -m 2048 -append vmx_apic_passthrough_tpr_threshold_test # -initrd /tmp/tmp.VfFmc6Myze
enabling apic
smp: waiting for 0 APs
paging enabled
cr0 = 80010011
cr3 = 107f000
cr4 = 20
filter = vmx_apic_passthrough_tpr_threshold_test, test = test_vmx_feature_control
filter = vmx_apic_passthrough_tpr_threshold_test, test = test_vmxon
filter = vmx_apic_passthrough_tpr_threshold_test, test = test_vmptrld
filter = vmx_apic_passthrough_tpr_threshold_test, test = test_vmclear
filter = vmx_apic_passthrough_tpr_threshold_test, test = test_vmptrst
filter = vmx_apic_passthrough_tpr_threshold_test, test = test_vmwrite_vmread
filter = vmx_apic_passthrough_tpr_threshold_test, test = test_vmcs_high
filter = vmx_apic_passthrough_tpr_threshold_test, test = test_vmcs_lifecycle
filter = vmx_apic_passthrough_tpr_threshold_test, test = test_vmx_caps
filter = vmx_apic_passthrough_tpr_threshold_test, test = test_vmread_flags_touch
filter = vmx_apic_passthrough_tpr_threshold_test, test = test_vmwrite_flags_touch
filter = vmx_apic_passthrough_tpr_threshold_test, test = null
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmenter
filter = vmx_apic_passthrough_tpr_threshold_test, test = preemption timer
filter = vmx_apic_passthrough_tpr_threshold_test, test = control field PAT
filter = vmx_apic_passthrough_tpr_threshold_test, test = control field EFER
filter = vmx_apic_passthrough_tpr_threshold_test, test = CR shadowing
filter = vmx_apic_passthrough_tpr_threshold_test, test = I/O bitmap
filter = vmx_apic_passthrough_tpr_threshold_test, test = instruction intercept
filter = vmx_apic_passthrough_tpr_threshold_test, test = EPT A/D disabled
filter = vmx_apic_passthrough_tpr_threshold_test, test = EPT A/D enabled
filter = vmx_apic_passthrough_tpr_threshold_test, test = PML
filter = vmx_apic_passthrough_tpr_threshold_test, test = interrupt
filter = vmx_apic_passthrough_tpr_threshold_test, test = nmi_hlt
filter = vmx_apic_passthrough_tpr_threshold_test, test = debug controls
filter = vmx_apic_passthrough_tpr_threshold_test, test = MSR switch
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmmcall
filter = vmx_apic_passthrough_tpr_threshold_test, test = disable RDTSCP
filter = vmx_apic_passthrough_tpr_threshold_test, test = exit_monitor_from_l2_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = invalid_msr
filter = vmx_apic_passthrough_tpr_threshold_test, test = v2_null_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = v2_multiple_entries_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = fixture_test_case1
filter = vmx_apic_passthrough_tpr_threshold_test, test = fixture_test_case2
filter = vmx_apic_passthrough_tpr_threshold_test, test = invvpid_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmx_controls_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmx_host_state_area_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmx_guest_state_area_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmentry_movss_shadow_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmentry_unrestricted_guest_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmx_eoi_bitmap_ioapic_scan_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmx_hlt_with_rvi_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = apic_reg_virt_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = virt_x2apic_mode_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmx_basic_vid_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmx_eoi_virt_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmx_posted_interrupts_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmx_apic_passthrough_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmx_apic_passthrough_thread_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmx_apic_passthrough_tpr_threshold_test

Test suite: vmx_apic_passthrough_tpr_threshold_test
PASS: TPR was zero by guest
FAIL: self-IPI fired
PASS: vmx_apic_passthrough_tpr_threshold_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmx_init_signal_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmx_sipi_signal_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmx_vmcs_shadow_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmx_ldtr_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmx_cr_load_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmx_cr4_osxsave_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmx_no_nm_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmx_db_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmx_nmi_window_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmx_intr_window_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmx_pending_event_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmx_pending_event_hlt_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmx_store_tsc_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmx_preemption_timer_zero_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmx_preemption_timer_tf_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmx_preemption_timer_expiry_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = ept_access_test_not_present
filter = vmx_apic_passthrough_tpr_threshold_test, test = ept_access_test_read_only
filter = vmx_apic_passthrough_tpr_threshold_test, test = ept_access_test_write_only
filter = vmx_apic_passthrough_tpr_threshold_test, test = ept_access_test_read_write
filter = vmx_apic_passthrough_tpr_threshold_test, test = ept_access_test_execute_only
filter = vmx_apic_passthrough_tpr_threshold_test, test = ept_access_test_read_execute
filter = vmx_apic_passthrough_tpr_threshold_test, test = ept_access_test_write_execute
filter = vmx_apic_passthrough_tpr_threshold_test, test = ept_access_test_read_write_execute
filter = vmx_apic_passthrough_tpr_threshold_test, test = ept_access_test_reserved_bits
filter = vmx_apic_passthrough_tpr_threshold_test, test = ept_access_test_ignored_bits
filter = vmx_apic_passthrough_tpr_threshold_test, test = ept_access_test_paddr_not_present_ad_disabled
filter = vmx_apic_passthrough_tpr_threshold_test, test = ept_access_test_paddr_not_present_ad_enabled
filter = vmx_apic_passthrough_tpr_threshold_test, test = ept_access_test_paddr_read_only_ad_disabled
filter = vmx_apic_passthrough_tpr_threshold_test, test = ept_access_test_paddr_read_only_ad_enabled
filter = vmx_apic_passthrough_tpr_threshold_test, test = ept_access_test_paddr_read_write
filter = vmx_apic_passthrough_tpr_threshold_test, test = ept_access_test_paddr_read_write_execute
filter = vmx_apic_passthrough_tpr_threshold_test, test = ept_access_test_paddr_read_execute_ad_disabled
filter = vmx_apic_passthrough_tpr_threshold_test, test = ept_access_test_paddr_read_execute_ad_enabled
filter = vmx_apic_passthrough_tpr_threshold_test, test = ept_access_test_paddr_not_present_page_fault
filter = vmx_apic_passthrough_tpr_threshold_test, test = ept_access_test_force_2m_page
filter = vmx_apic_passthrough_tpr_threshold_test, test = atomic_switch_max_msrs_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = atomic_switch_overflow_msrs_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = rdtsc_vmexit_diff_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmx_mtf_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmx_mtf_pdpte_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmx_pf_exception_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmx_pf_exception_forced_emulation_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmx_pf_no_vpid_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmx_pf_invvpid_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmx_pf_vpid_test
filter = vmx_apic_passthrough_tpr_threshold_test, test = vmx_exception_test
SUMMARY: 6 tests, 1 unexpected failures


--XmqCeNDaaVDiBrg5--

