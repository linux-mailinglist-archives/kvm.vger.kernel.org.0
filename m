Return-Path: <kvm+bounces-37999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66F2FA33556
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 03:13:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B1E7B167A8B
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 02:13:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92FCB14A095;
	Thu, 13 Feb 2025 02:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fcd8m4r2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6F2146588;
	Thu, 13 Feb 2025 02:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739412780; cv=fail; b=pLcstoSmpq0kz7exXH0yvKaRgeLShQqnAw4j1HllC9L9aFc6nAUCtCjJPjrjtpq8upp2smcIRq7W2QISyxQc37SyU1Y+q+PP6gSpxRVUh+QNBXa1vULqIlvSdN+OyWEVRze488yWvNc/boXsWiR+ibcK9snPXVOSajuNFM+ABfk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739412780; c=relaxed/simple;
	bh=6Xhf/qhLPebvBmfYZTbxvZQtqZHrfI55uP3ck1qMM7Q=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=X97oANQP2ZK5EddCynaP1+e/ISSeKLkO4Tk37NXj5O1Yco7jrZYm4Y2iBOK7ReqPDPGGP8XIf2uZwoRTvdZnpZwUpaul3CZQA+FC9ALnNs4+xZG6q2pI7zY+0ktmPlWk1yXmgvAMOpJcN7/181i5edz/bNntHmY8AevwGycGjLo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fcd8m4r2; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739412779; x=1770948779;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=6Xhf/qhLPebvBmfYZTbxvZQtqZHrfI55uP3ck1qMM7Q=;
  b=fcd8m4r2JVY+MVBPNbZpd9vkM2aHrAGii3PF/n816dqBsj8+pMghxzUQ
   YyErlyZRipYRAJHfHaLM6WGF+A7niL6tTsB5nytjGjJv/CBBKjHwkh2Xx
   ymjo+UaRCNcFrO7kpqeflI0fGAxtv+8145xigbFzW//hpk0AN5LZZz7J4
   HsZehUzElUaftJU9/prtgwagG0zeWyt7GnONbS80gzcxhiDhBmhUdwkcr
   KgNxY+mOVS1r8MBroEz6PUPiEkMEcB0uzx+89DPnbZKQuJUOoLllvbA+B
   +AgaNfqDZSGvbOg4/bSu1albtvojop/yktyKACWCCitU1pFbczaYQmMl6
   w==;
X-CSE-ConnectionGUID: 9zJN787OQOirqYdWb0RCnA==
X-CSE-MsgGUID: cmfkAS19RaKhuQX6BMyHGw==
X-IronPort-AV: E=McAfee;i="6700,10204,11343"; a="43753523"
X-IronPort-AV: E=Sophos;i="6.13,281,1732608000"; 
   d="scan'208";a="43753523"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2025 18:12:59 -0800
X-CSE-ConnectionGUID: THOiyXjxTg6TKFb8YgArMQ==
X-CSE-MsgGUID: MVhHwNJAQJmzexIIfouxxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,281,1732608000"; 
   d="scan'208";a="118008987"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Feb 2025 18:12:59 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 12 Feb 2025 18:12:58 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 12 Feb 2025 18:12:58 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 12 Feb 2025 18:12:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GtBT7J2gWtFtqoQ0ZJSzBXSVq30EiqE8TorCkKQNnVuCQMsmOU9nfeYa/BeinqBAHRBhAkqGVUVlQX77kdMnAtl1dQWeTZmALyW/o8Ic/1d42gwV1njgoSVlfH32TcWx5MnURzQRCQ1AY4OBgafvj7WnR2FRB8gHHo21r2o1+nUlehA2Io/gK3+98oe2gXTPm/MJsJd1ETcyuqRtV75lCSUUaT92fb9lGgTzPwxeMbDn9TJH0Zf71IPGj/hVQfyAXzXNVKyIR5ze1sq76G3i3v71vzfplll9jok8vl+aXkY8ipICS0EaF9JJjLaw02f6CPn/byKLOdc7Ctw8ICl9Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ebLK6L4jpm+E3fSec7o2Wbj3Q/f5QfGluqjJWf6393A=;
 b=JwnMoIbhPe+KqqaPLRdRmEwLO6wFgV94X4zKb/u9OXvndz/a5Gbz4D4v9whNsttKIi5I08H7YgXcy6D3BFOUWAB/jb1DDQGKi9mkVAqSSs4Ob0onuojlJaOF0AGL4GKcjJV/LGvgEegAG4G4b6vOWm2gcm3mpRj7ETFQ4xGO3pPceLcUk3sKQdcjvjOUY8NZuSqYDj/UqZE1uE5b7K/dx1tiCTGsRXKDN3T2o+jn8bQO2E/uzIguqf4SUZpjPgOlMcnSW6cpWrHWzGQtvc2bP7s9e18U/V3wybnmNrivhiKDj99DkgmuGnfQGwesvZuh7TYM7tuoHXaQr2u3iOFYMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB8665.namprd11.prod.outlook.com (2603:10b6:8:1b8::6) by
 SA1PR11MB8574.namprd11.prod.outlook.com (2603:10b6:806:3b1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.13; Thu, 13 Feb
 2025 02:12:56 +0000
Received: from DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::8e7e:4f8:f7e4:3955]) by DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::8e7e:4f8:f7e4:3955%4]) with mapi id 15.20.8422.015; Thu, 13 Feb 2025
 02:12:56 +0000
Date: Thu, 13 Feb 2025 10:12:46 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Binbin Wu <binbin.wu@linux.intel.com>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>, <rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<adrian.hunter@intel.com>, <reinette.chatre@intel.com>,
	<xiaoyao.li@intel.com>, <tony.lindgren@intel.com>,
	<isaku.yamahata@intel.com>, <yan.y.zhao@intel.com>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 01/17] KVM: TDX: Add support for find pending IRQ in a
 protected local APIC
Message-ID: <Z61VHleTg9oV6xgY@intel.com>
References: <20250211025828.3072076-1-binbin.wu@linux.intel.com>
 <20250211025828.3072076-2-binbin.wu@linux.intel.com>
 <Z6xX6PCjW0PZe59D@intel.com>
 <Z6zGoXjONvY8wOgG@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z6zGoXjONvY8wOgG@google.com>
X-ClientProxiedBy: SI2PR01CA0051.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::6) To DS0PR11MB8665.namprd11.prod.outlook.com
 (2603:10b6:8:1b8::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB8665:EE_|SA1PR11MB8574:EE_
X-MS-Office365-Filtering-Correlation-Id: 38de4270-cd7b-4742-2543-08dd4bd3ee18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?NOEd1FYHPRvHiC4OHMWdztpveQRCO3qY4P2tKCOsAhyY8bUYgVWL8IsdKGt3?=
 =?us-ascii?Q?qPMG16SyjFlGpYOxPzW9hLcKuND9w01IJAl1wIemQTKqQobO4Aq48yZvrL0V?=
 =?us-ascii?Q?RUM0EcnVWCf/nq6//iMVNKJSMCb2j2YtuRiv/7hjTdc7SUTEarFTqrBpjZ1p?=
 =?us-ascii?Q?Or2OFHLgWN43gocIU3y7jSDCEj2kZ3fSs/iWN7qO4qB1rR35qtq5rbr4QBFF?=
 =?us-ascii?Q?mSFCMsmUyKFQINXkxz/a/Z8f1NXrKarZrCJ6eGok+7Vb8+qntCLvQBChaIbX?=
 =?us-ascii?Q?AmUhcyvrFngTMAJCadq9V9eJtQzwOMN6IvYtheZzSuu7FG4h9WV3wK2YcvKR?=
 =?us-ascii?Q?X5bWbNerMVe5F9g+5GR+nmpG2onRqdu+ggeof9IrEDuX+RhVgXUhgCoaUiN5?=
 =?us-ascii?Q?qnLyAUvFNzGVklS4u5t2F+5BfAbMAEOZ79BtLCQuB+Xbfa1/dx4WGkIO8UnG?=
 =?us-ascii?Q?9Bz+apOty+3H07Fs4F6nWNikC6by5exxBdA5XwwCQaiFY4fCbx6GSe8dIpEw?=
 =?us-ascii?Q?K7TcfcqckOe09OL2B/nc/PYrdyS/M2Yd+cc9i/6QWSuRBxD1Lv8wBwK2L/ta?=
 =?us-ascii?Q?V+8ymWQv2BU2xRNv2/+tNKJBAf6c4G626Mzakdmv68Jo1UdlfNAwA9MklQd6?=
 =?us-ascii?Q?Ixafsjt11l3F0oD08V/IhV2I2DAkrziPVU7ky4l6tBbwoqh7mFVhdwdysecA?=
 =?us-ascii?Q?QW3jiFOnUEKHCCKUzRXh2bbzJ/tkLnWcde3YXXp9u3RUEqTvDTswGq6s4dEn?=
 =?us-ascii?Q?nIouZFPLWkoeccMmikPV7Z1uOd6xX0311sE0dN6Lm4YnGUW4x55+59kAx1Kp?=
 =?us-ascii?Q?9MircMToZhpY8ttyxya6jQAsBuf3nkJCQ5zQqlyqiWO7HwPkZ2a+rF0ccT6e?=
 =?us-ascii?Q?9Umu4ARJqqwGQqxtV5gPAa73a3Wo4zC0teImsNIrAnK7eEqykljvp5iptViT?=
 =?us-ascii?Q?XPNzOhRbrGrc2Mo2X4/FM0LDCKhANb5J6Vg2X6hUqrk076cgMPmRm3pJR+H8?=
 =?us-ascii?Q?PobFIN/ODapX1sBW1bcJ9meVyz+bCV5O0CNsX7xYmjnRALL514Dxz6kt6XyX?=
 =?us-ascii?Q?hNMBiQsYhVyQjidFBcu8jNFVoExUhjvoSK70XkNTXBuRAfCIKeLA3MEP8Toz?=
 =?us-ascii?Q?gsPVnyuUktYu27yX72ZGMtIkk8XlZ7FGxC/7+EV9VlHmg1Pp9g5u3jzw5SmR?=
 =?us-ascii?Q?ST1PIl/8/b3/97igmm/7KcASRVSbFU01fv03Y7cen3MRcWl+9V69NTsAti6D?=
 =?us-ascii?Q?vJyyO2rAeioaxIfr5qd1yqjr3T6kALlxEJ3J8zgl4tUnlsymOppy82Sy0hsZ?=
 =?us-ascii?Q?mfFa7MPgleQBgKlInCxRGUHE1xmCipBUZMIOJUxgN0u758Adl/tkHe+OHo3y?=
 =?us-ascii?Q?AmYZR+m3tp+GivzXepCCPh3bOPzj?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8665.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MpcbOPyZLVWEQTqYHSnMeP7s/GdhP5bjUX3xb7pV8rIXygGgh2kteQkRxffb?=
 =?us-ascii?Q?ZkGP/eTxBdGCDKPOrcNzz7gd0jEsp82BSw7BRKMjQFJ/XLXkefNjhS5OyQss?=
 =?us-ascii?Q?x+8rpqpYVRNYCBu1NSpPIRQc93hsISBn1Bfsok5FkOsKMgASlWj083u6MB7/?=
 =?us-ascii?Q?fFcLSTEBGCRjruiTwFwfHGI61Kq3CxDWnbkcqpUBkJ+B4t8XABc44enKMuPT?=
 =?us-ascii?Q?wDmsxAK+uJb3ZrE11jFErMQ97+c3jJqm5akEymg5ezcf5CWDR7/FDTLfjQPa?=
 =?us-ascii?Q?PxWM3GeKaTZ2tyNORQuZTDlHM+V2rNziDAfpHtbqx5Vlm8JjNImbah0z9LaC?=
 =?us-ascii?Q?8FveQHP4Rqc0VYkR8bGkdDFW593nK7+DgnquwTXSkk8Ouo4/TL8gu/kwWjou?=
 =?us-ascii?Q?jizVJlotsaWyGLfgH6jJxcYhEh30kLmhO3R6Oz3M+LIM9NtdPd1QuD24SYOt?=
 =?us-ascii?Q?aRA6ZMpdOUwoYCySXjx0kxT6sx2M6cgf/sF49d1z5P1B4bGmq7laTSw8vtTQ?=
 =?us-ascii?Q?8Z3G3RDpyO1Gry+JLxjbp0roORiFJ0MW+eBVuQ+c+a0qzp6leg/P9/tDR9Sl?=
 =?us-ascii?Q?XB2DTaewb92vQ2lAjnldEItyxlf/qH3NbBqrG9THhGcSNmcaeV0LKLWicwvH?=
 =?us-ascii?Q?o4yW/wQPMTRjVMdHvM/boQQg3VkBM7L81kHmZvxhNYunlNkXlW2iMMzTlzzQ?=
 =?us-ascii?Q?3SNN1ZCj1/SdAx+oXEYADG4HJ22ghfMxPdis49MVa0A1B0n3aCGtlxlHO3Ty?=
 =?us-ascii?Q?x/4Z+IpxQaTVY8v6DyJz/pzPS1wTUvbCNFGvECIH+rG9iERnFPcSKjgFiV/0?=
 =?us-ascii?Q?sBoaM+WcUqZk1jX2sPU5dG638WjTabOob88/eieF3FLmmMLY4eB3zj8qm1t+?=
 =?us-ascii?Q?6ogGtwpfzKpTLgaj/A8wnEu6B4hhgGQ22EricNKUNqOyA2afjbqaEU/6AzPT?=
 =?us-ascii?Q?6F3AC8J1Ukh2XxgDBSnpV6/irtCRDz7561ZBK057JsgN2QcjL/Y7QgfOWdZe?=
 =?us-ascii?Q?Vaa0uG2umus2hY2jrUTnRz1h3vt35T5whZcwbQqT9MnT8PcToMkpga6KQePu?=
 =?us-ascii?Q?SZJZoBu+CFGRmX/jRoAOxCgZA+a6LmXjnyhZKcZvMPL477Uy90sWt8gEVXfb?=
 =?us-ascii?Q?j6Lvb5vZ8pOPEw+6osnBkOf1x0Gsrc+AFNkPfoqI3UeJBxEMMejxePtHLiZ1?=
 =?us-ascii?Q?bjbAai0CkT5vzE3DzDbKXLnjcpH9RMiw/wS3PlzkCovj35wWDT8aY0LRSzWy?=
 =?us-ascii?Q?TuWAQOU6r8PZfZoIp8jzuP7aiwcDWDy7HTtx8R2jGpSB0fTl/aap7pE1YQSt?=
 =?us-ascii?Q?3yywBQloVek40db6Y5IRIFhJR2L6AaoNLatPVDtx+ofDo7JKB/VgArPMYXmo?=
 =?us-ascii?Q?lCH0HUOlzlkMZb79Qpu7XJG6kbf99lKAHvP2R6ZOi9WX2/8hP9tmVupJoE2u?=
 =?us-ascii?Q?tlklJ9eGcKL2WeyHRTz2EBlASQlkEj0LpXRVxqwBSCBctYz4r/edMJffAg8m?=
 =?us-ascii?Q?ZLHtBrKB9O0QC4hjD4QRhPEQviiIO+ZVEGSn2DVJDkCSqccWZX5o8ueQHKXn?=
 =?us-ascii?Q?XIT2c3dP+kG0YM7EduqqRelHuueAvVwBJrsEB6NK?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 38de4270-cd7b-4742-2543-08dd4bd3ee18
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB8665.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2025 02:12:56.3096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jjqUz3QwD2xoSu4JR4ZenhSEmhHCVoy+rEHdwpQp2vJQyVudey2dGAUAlEbwxZqixiE6+U9jcrGcwkv2ZzORlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8574
X-OriginatorOrg: intel.com

On Wed, Feb 12, 2025 at 08:04:49AM -0800, Sean Christopherson wrote:
>On Wed, Feb 12, 2025, Chao Gao wrote:
>> >diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
>> >index 7f1318c44040..2b1ea57a3a4e 100644
>> >--- a/arch/x86/kvm/vmx/main.c
>> >+++ b/arch/x86/kvm/vmx/main.c
>> >@@ -62,6 +62,8 @@ static __init int vt_hardware_setup(void)
>> > 		vt_x86_ops.set_external_spte = tdx_sept_set_private_spte;
>> > 		vt_x86_ops.free_external_spt = tdx_sept_free_private_spt;
>> > 		vt_x86_ops.remove_external_spte = tdx_sept_remove_private_spte;
>> 
>> Nit: I think it would be more consistent to set up .protected_apic_has_interrupt
>> if TDX is enabled (rather than clearing it if TDX is disabled).
>
>I think my preference would be to do the vt_op_tdx_only() thing[*], wire up all
>TDX hooks by default via vt_op_tdx_only(),

Yes, that makes sense. I am fine as long as the hooks are set up in the same way.

>and then nullify them if TDX support
>isn't enabled.  Or even just leave them set, e.g. based on the comment in
>vt_hardware_setup(), that can happen anyways.

Indeed. No need to nullify the hooks.

>
>https://lore.kernel.org/all/Z6v9yjWLNTU6X90d@google.com
>

