Return-Path: <kvm+bounces-58515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 21982B94B71
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 09:13:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D77801722EF
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 07:13:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C525330FC27;
	Tue, 23 Sep 2025 07:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n9imOxI9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2524502F;
	Tue, 23 Sep 2025 07:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758611572; cv=fail; b=n3rt08yME8ldZs0YCfcJ2J+lKwDJZ3275ndqZ433ZMu2pr9MsEldM+4aRa+2mcfXS39X9uxsyK2YWJGh7ZKfYXuvzMZai3atFeTki68GSS5wAf13X88XIHrT/0dpqj74F6Faxts4OQuYuxt9PWcdIMOh1Mx/nKeFOcbkbb1iUpY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758611572; c=relaxed/simple;
	bh=lgrmN8zHpLNzzmb4ce9ZZjvKk8t18JQ4PfM9wAVC738=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=elQMnWfAcE9XEuEo0ty0OHRKvRZKKheVu0WnHqHMdYlLZlh0wOnR0Vq0xiCYEeMm7xckkUx7oZHc8oM7vjmSya2f678Y2s68CGmJdSjUUqmXkPx4WtIHyJ0BjCoVkQVJ0emWNoo9LOlcZS4Nf9507hKk9/P00OA/qmf7DKWv7mw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n9imOxI9; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758611570; x=1790147570;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=lgrmN8zHpLNzzmb4ce9ZZjvKk8t18JQ4PfM9wAVC738=;
  b=n9imOxI94sxiQc52ZjeEIbiDVeiEPgfHq+TZQ6DYhzEnBWRiFkKAfLTi
   jKPoIUbnwDeVeKOQbsYda21p4oCFa9wFBhaDMLgb4YmXHbsDvRtavKu1p
   isbvgawtstvjTpy56qTeK5yCT4LgbGkP25z65x/s/srfVuIGU2AwPlXh/
   GoOreJ4LZ13nUpCILWpnkJu2eoEwpgQYrWZjePeJTp48tPi/H+P93IJhT
   re0CzypFhkRwhPQFNOpvoGgabzsKCKd+zuiwKXoZi4VvvycVoLluE9lau
   oNrgCnc5GtMM9k8HR9slB/KFwQHt1rYLeCpvGhqBJrp4wQn5CH+Ezb6Up
   g==;
X-CSE-ConnectionGUID: lUTrv+KuSmGolVKCXJADUw==
X-CSE-MsgGUID: gBVg1U9zTNixLXsOZM3IFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="83486693"
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="83486693"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 00:12:50 -0700
X-CSE-ConnectionGUID: 4FToouMUSAu7l/VcW0BZbQ==
X-CSE-MsgGUID: pQhaEgLyQSear+tJmkR4ag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="180986924"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 00:12:50 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 23 Sep 2025 00:12:49 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 23 Sep 2025 00:12:49 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.61) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 23 Sep 2025 00:12:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dXCTkhqatb1kf/Z4UWIpwQfSYpRl70Ppz7NHV9j15hr4Zolrd4p8KTPs9iblJf3BsuWfdYex3TVetZhKmyn9sEG6bsz3GGzWZjz9mygugssmHM/r/fnHKT7YNdwG0tTfJTksyUx23UlOd1u/olfHkE620/YlJWLBohCQNvAdUGzZ9VKPM0FmqtwgP7aAlrPjt7k5xIUH5bm9ijLQLRLAbBS/646JH/R8O61HMW4LwgtU+cHXfbIlp/ToN6H8vzy1ksAX8w2VDRoUFbOyx/VSjsK/ys5m5p+Bt5HMRXqz+UE4FYvWpYC6PWhxRLLtp7Fz1SVm4QYMlWA/x8eqEsNxcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2jIS6PPnrcOoCChC1x/L3LrmM4jfeh58re4m5htsTmI=;
 b=wUl80Mvrxgw5/ppglWkvjajol7R+ygPEoduPSRmfrN07rVUNGpViECRS14jqGPAVhx4ze7GY+5XLH+6UHgL+uTSDzVPtoDIXTgSf/8LceC8X16FDn0VMr0Plt/87lqca4EzAePoMu2Gp9XbA0gZItSoDVLPjFprCzNihCqzhA7IrbimeB+8/EkSZgB3PFzA6bNjA3yhKvlXu5Y6HFFUX83JYxOrpNTYXalZWZ3CYuC4oTQ1Uv2BsOUZ0lpH5CZ12T2j3R5PGNdcnvSIDG5TphRBX1ChRBgT8kul1+GjUqWBPQqubkT0ZEj7Y98YHVO1Jg0qSXmfP11oSnmLBwwgdRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CH3PR11MB7203.namprd11.prod.outlook.com (2603:10b6:610:148::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.20; Tue, 23 Sep
 2025 07:12:48 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%3]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 07:12:47 +0000
Date: Tue, 23 Sep 2025 15:12:37 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Binbin Wu
	<binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, "Maxim
 Levitsky" <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>,
	"Xin Li" <xin@zytor.com>
Subject: Re: [PATCH v16 46/51] KVM: selftests: Add support for
 MSR_IA32_{S,U}_CET to MSRs test
Message-ID: <aNJIZVGcIoqkpKav@intel.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-47-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250919223258.1604852-47-seanjc@google.com>
X-ClientProxiedBy: SG2P153CA0008.APCP153.PROD.OUTLOOK.COM (2603:1096::18) To
 CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CH3PR11MB7203:EE_
X-MS-Office365-Filtering-Correlation-Id: b9cc2188-af17-4733-7928-08ddfa70999c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?rQ4ASeMvRFoIPSkPfPTUpCt+fLYk4jYbJqmwX2a0s4YBcAJXstExBlg9VKa9?=
 =?us-ascii?Q?T5ipdNB6dQxz7d6pNdo+Lvq72utZiEOEJKT+ObLlRs5wAvOZfU/1cjAymlS2?=
 =?us-ascii?Q?sM6zAkAQm3B7H/g6ytibzgc8dx9g7MlYCFyEu4gfK9adlL6SwArpoEbQs1BL?=
 =?us-ascii?Q?rUn3m/BqClatnDDbseaT0OT1bXSQ04gxF9Z/rx+GajiyYPReVt7cIVcFT+gl?=
 =?us-ascii?Q?skQejtELNe0ODZeMmXlnvLAdgVy54FUkbK/0hsupV+QwMSlqeSVdvZA0brvB?=
 =?us-ascii?Q?XUts38vZwTDL94NTJy79sYOZBlbIGCbOJm5d0oqy6Ld/QtI31McZkwEMXmrT?=
 =?us-ascii?Q?XbT9pnZZob10B17qFT0ICTcZKckFa0FI1xtAZpMXyqT7fwDGjgBmS/G9IaYS?=
 =?us-ascii?Q?ZP+ldq7pdNcPQTe3o5nm5QsPBpBe/G4eOtuzTtXqMi2Yr/Ekf7LshziKnyGR?=
 =?us-ascii?Q?a07XH47hp7FrNFer+pDpz/A4CXLFKKXIQFpr4SQydEFh4CVKFKbz1QvNYxJc?=
 =?us-ascii?Q?b67QQktikFqLHkhsLEFG6k5QvTf97t5QdOg4T0x4yPtmHVccqwxNFWKDpKe7?=
 =?us-ascii?Q?ruhQ7BXOFposwR4fFt5tDVVgpAPevy/V2L7msqAaYVvXcMtLmobSIsrB8bMd?=
 =?us-ascii?Q?xYRPIKevYnICCJv/+rQkYVoTwMrkt2RdQqpJ7Pc8TSDCBLejirbwllcWL+TS?=
 =?us-ascii?Q?1/odtPsWwUZ6uXGmCaojn/iE3Ds1KArTj+zziObIr5nD9zlVeqMLyxiCe7HH?=
 =?us-ascii?Q?lNt/p3ELe4WQmU90VmHEOH+K1ETdLoEWC2hu/DHJYEC69qzflYLjfH2ozoVq?=
 =?us-ascii?Q?t5Xj0bjuio/AmBmyYnvFukVer/vgbF84tufCurstQ2coU1i+HLkrzXaqIhvV?=
 =?us-ascii?Q?FnV8KXm/g8lVwBsmccT3s+cpcBYm6oIxD2q4YAiaIrKBocKr82QvcIYlT2tm?=
 =?us-ascii?Q?hGs4qh7l/7DzAX2tIvXeOrUkKJRsuPsI9Qo0aSS+4hayMAjlZPLwL5UlNnme?=
 =?us-ascii?Q?Oc40HRaU+MbeLXEhOArCmXRTYZGZvcfTJUzfCJyMWhDZIS17DEshBGisQJtu?=
 =?us-ascii?Q?KwjTWX0U+trBwQBGZ5KWw+LqtNx6YhsLJesLQzC3ckWq8kD0qSew6Qv2UZn5?=
 =?us-ascii?Q?qEAMHjFa5jxiCoKeesFum7+tj2Qz1ihKlriiDcUjplYyw/mw9tGT1rkJH9eK?=
 =?us-ascii?Q?DgJIHZIQP/kCKK6Kkq61h25uHcDXt9CQXzsu/SU5ypuZUKCH5bPUecczJgVB?=
 =?us-ascii?Q?OUsht6M+PjcrviqxOdLWzvnF5BZotucKJ/8JUfGtKByrX64KQxJIQf4pYcqv?=
 =?us-ascii?Q?X2iS8eoiPVnhCAJVENdQdi3KGUMbWcLXUfVoRXLfh+kaeFaNVoqkDAjzHZV+?=
 =?us-ascii?Q?00iHS1+tR3W/+OIWLs3dI8mIgW5Z3MMecsHErKwdquREyX8nEqWIpwOWQUqZ?=
 =?us-ascii?Q?htplQMGKlO8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BcyDkrAe3A9oxU3GfLI82dVYKF1Y5tVWUJenZfXVqohiNzGVMOrwu0zlES6K?=
 =?us-ascii?Q?rzic5fd9wO6btbRk7ouRCanpMIszNYjiSwx9jEA3uCvOEZ4vvYhuPA+byWV5?=
 =?us-ascii?Q?SZSC5b9WZ4Zirzum4rQfjH7/hSxO13eL5KxTLX6Po8tlwbeKVNmbQbTUZzz8?=
 =?us-ascii?Q?khe97n2BWcD63SmxLV1pWLFg4a4N3p21oDg6GsuCMmzWF3XNNbw94mhbEUA6?=
 =?us-ascii?Q?MjgBgA/YZRKio8DLrWquKVfgTI8L20B7H8PwSbZV7T1wsVDl7qa2sUmEztAb?=
 =?us-ascii?Q?DgCweBrkN/8KMZg8nPd0uG1bpEPubBsQwTjnfM1zGlBPldqpi8twktFzqo7p?=
 =?us-ascii?Q?u+CbEqOYmrF8FRQK65Dp4qadoqLmjYOH8cP5XZgvuRnUo3OqbvGapjK7XEc5?=
 =?us-ascii?Q?hgKV6HkMFenoPc+06+AXmWhI6HjSXNELVBxK2xLrxIFC7RjuBzbgvd5762UJ?=
 =?us-ascii?Q?hE4lHLqyFvUUPHZadEshRKH0VF6m8K2ARTXcFmIRLiPBw09Jlp3zRUQk3OrW?=
 =?us-ascii?Q?ooVyAtosEC+Kra/i41AaiJSbNsFrcHw0CEmUH1zGyU31KMfyhbIw0bqmpT8t?=
 =?us-ascii?Q?TXIpxHoNC4498EeZkYuPUCGokRcj3KHFqRdZMTG2XOX4n1rbv++nPi+lx8QE?=
 =?us-ascii?Q?PyFSw4V6dYvwg0aQaeHE9tpO/CYg4sSjR4+JH0xE4I608+HqOvGilDoIPyuk?=
 =?us-ascii?Q?rDJBMi+BdgMsumr/KSw0BfptQCCTlhfcpJ/EiqVR0th5g+PuZJ82IdQEmF2s?=
 =?us-ascii?Q?XW28otqBQfP79IDX7is30OmSSdBJ4kKTnrG4KxF9IN3QfJzJiWMYn7q3fnnr?=
 =?us-ascii?Q?z+uf7sQSAWvmKnxb7JbF6ap4uSgqUj+E1GKtCOtaH9VFQyZodR8y1oitFFMX?=
 =?us-ascii?Q?aMIdJDJTmbfCwMIIqCZmarhu6FxJPMFUB2PeuMXdDsWfYu4pJIXfW8AuxsiR?=
 =?us-ascii?Q?heLLqm+bzCOcULYEdZYnN7ycnbp5AJqfzhoXWORAfBW4KwWc79glUcsyM3b8?=
 =?us-ascii?Q?8CGg9m2h06p2UGj53NsV6BjHCUJAg/A9OIjzjoYHxIbDIqOcKM8jxhfswJH2?=
 =?us-ascii?Q?LLJtHzcFxO8CwusmMobmP5nRa/hiUWdMDnh2yKpvA/HG27th7dKhAUjAb+dB?=
 =?us-ascii?Q?tAH1tdr971Q4iW3gKa1ZTzXHrdZpYKSEDIr836eHcobnus44Le97yZblsIyh?=
 =?us-ascii?Q?2oSIHeiwYWCvH0VN+Sm8SDNx7EEColcJHByfu/7Z7PBjBI6LIxDY+MXFrZiE?=
 =?us-ascii?Q?kp7Cb9TmkcRTGDwHhqYl4OHER1n3u+/oMWBFwnfTQAca+3zA2fxbFiRtynoN?=
 =?us-ascii?Q?uoXgIuC5yjXWBzeZN+5J/USQPmuWYtxMQ4nO7wtGUuPADS02G+vSOZ6n/Mm5?=
 =?us-ascii?Q?qPnbTgYZnjBVI+fKac1XBtNbxsPQqinH/NvyKuIZ5fsLchoYbvBmO01TUOG4?=
 =?us-ascii?Q?k51odW7lPwgvZ+5xC8KAoVlxmxK+hQJ3mHP3UEtsVcshmHvzRm49fQKjt/B7?=
 =?us-ascii?Q?LDm6f34hzY9cy/yQL0zzi4yKk/l5ExrfOryvMDH0BiJMAWF0HB06dDlWBh0j?=
 =?us-ascii?Q?Vq75IJ00VwROVyCIgSR7Z1FXYQeQR2UEQNlPipR5?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b9cc2188-af17-4733-7928-08ddfa70999c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 07:12:47.8662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x0nu0WVZ4dZF3aXF4kt0efPZTw6NIUNQD4j/qu3wu11H+7MH4gfFp4IKfdok0I8gepj3kdtHSDIvyQ96loBbVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7203
X-OriginatorOrg: intel.com

On Fri, Sep 19, 2025 at 03:32:53PM -0700, Sean Christopherson wrote:
>Extend the MSRs test to support {S,U}_CET, which are a bit of a pain to
>handled due to the MSRs existing if IBT *or* SHSTK is supported.  To deal
>with Intel's wonderful decision to bundle IBT and SHSTK under CET, track
>the second feature, but skip only RDMSR #GP tests to avoid false failures
>when running on a CPU with only one of IBT or SHSTK (the WRMSR #GP tests
>are still valid since the enable bits are per-feature).
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

