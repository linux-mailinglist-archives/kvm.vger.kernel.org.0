Return-Path: <kvm+bounces-28361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EE1D3997C5C
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 07:25:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 180671C21B2D
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 05:25:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25DD019F10A;
	Thu, 10 Oct 2024 05:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UAS/YGKk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D08D2AEEC;
	Thu, 10 Oct 2024 05:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728537937; cv=fail; b=nchn4xJuA4XAurzCtgp7iPlez147lWhaxsEnhnblUxTwy0UvpgWqXkdEqRnMTZR0ZCyUfiPnvQhvoE5GELsdL89GUNRgyuAq/qwRAqNHTofX2+NTzZW8hX7NSdyrebhByo2kEuQXrec3FzWQYu841eZDbm2jqcFFWQUM+hFh+hc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728537937; c=relaxed/simple;
	bh=aym4MDba8d//pWFcW4E1uqXeoiTLEtOIl3L1kK4EYQg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YUDUt9UkY+K2NN1vTp+EcJJRCmPZl5ql3DacWjCyGaTFkyRPrtuPEwEBuKA0eY+r+uybLjAnXSB26GC62jLUb0Acw6tHU6lQqchWqK0Q4OQrHmSGPWumwufz4Dk754d7XXv/rAPr+Vc73v4yztTDBo/joWUrtfbpnzReZBHLv04=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UAS/YGKk; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728537935; x=1760073935;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=aym4MDba8d//pWFcW4E1uqXeoiTLEtOIl3L1kK4EYQg=;
  b=UAS/YGKkLqVU7hl5hu4IxaiHf2ks0h4FlzVY6rfXd8GCk3BCzP3iiaCP
   4JXovyAvPWLAyCEQ+jEuWb5M+xlPRSzrh7E4U2y3uuix4zAfDkGRuxA19
   69gGABSp4v3Zf/tyW11ktc9UUJUX6mLLh5soPdNDb8c6T9c4xKIkB0hKs
   nTDPXX+OLuURVGMgOjJZlnuelCzyMDufpw7CzhBWfpTdFYQayauTrT3t3
   myqXBZgTiRnN5r4wW207AhrJIf2hG0he2NfzzoUGNX3yb97+wzamKdKk7
   +b5CSrbD1uoQrpEE51TIXAY7T6sowH0WYbh1hYXXFRF8iBnYfxKs8zREZ
   A==;
X-CSE-ConnectionGUID: 2uG+m7WSREGU5zvwND84wA==
X-CSE-MsgGUID: bduOHiwDSt2iLlQHqOr4Qg==
X-IronPort-AV: E=McAfee;i="6700,10204,11220"; a="15496604"
X-IronPort-AV: E=Sophos;i="6.11,192,1725346800"; 
   d="scan'208";a="15496604"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2024 22:25:34 -0700
X-CSE-ConnectionGUID: LqrUilJbRk2M6NPT0A4Lfw==
X-CSE-MsgGUID: GyaJE7jhRsSuLQjO+XvVqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,192,1725346800"; 
   d="scan'208";a="107315496"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Oct 2024 22:25:34 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 9 Oct 2024 22:25:34 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 9 Oct 2024 22:25:34 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 9 Oct 2024 22:25:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SwGN+wMITzvQG0ESUu+Qj5sFPmI8z7nNhPLooIv7VI5wRskew0s9nDYX54kyhYteDrVLoiTpWlQ1oBsJQx7+iln3PLcRbLP7KVVNfV5V09bXBnYh8aRY181cl/X4ylwVP24E7F6cmMbP1SHEjFHyrV8BtEPJCrCS1mGTwcqxiQpWBo2fGLmezqrjScoDD25DIkawCEKjYDW6wrWnfVkLlGBhpflYCxNPW/hT2L/OO9zSmFinqNt3WcE+7nkNQs7h6TQmINYLiv4keuKtsu7IzxfWXVVS+y0nZ0WliJZ8og1IdIwD5TauqZ8+1GTM7ulZNCwxWm1OEOz8FeZ+bA5KQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ldx64DrucflNr0RK42UBcjAmGiypgt0seM3gbZnSUZ0=;
 b=Bja/NSIwrH+L0yMjVRTxUilLjDov4Z5RxKncfR7/2mcL9Ws81ixJmOc9QWNHOzfr1qcqJDjfplCk2HBvVOLDGGnWm+Hm7nRILY9dnDd7eo8Rp2/EN0n497ByftV3NOBBxatxYvuoDVZdk+3wdRJLdpzpfdz3a9ANK0/PgnVnUhplf/UfJXQ7I6r3TBZ2mQRYQ4LOtFHOj5wcyxK9cL78/k83XTLarmYFAD5JaNaXv64w6A2ap9TmI3cOQQZDUJpsWOaclp5s6mOQ/nmT6wwwFkeBdK+PHR3uNWuTgH73WSArLeIfX9V6n8mmNhSbQhhi6oYzVwPJhfO9LvjY8GQHSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CYXPR11MB8732.namprd11.prod.outlook.com (2603:10b6:930:d6::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8048.16; Thu, 10 Oct 2024 05:25:32 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8048.013; Thu, 10 Oct 2024
 05:25:31 +0000
Date: Thu, 10 Oct 2024 13:23:17 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, Yuan Yao <yuan.yao@intel.com>, Kai Huang
	<kai.huang@intel.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "dmatlack@google.com"
	<dmatlack@google.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY
 with operand SEPT
Message-ID: <ZwdkxaqFRByTtDpw@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <ZuBQYvY6Ib4ZYBgx@google.com>
 <CABgObfayLGyWKERXkU+0gjeUg=Sp3r7GEQU=+13sUMpo36weWg@mail.gmail.com>
 <ZuBsTlbrlD6NHyv1@google.com>
 <655170f6a09ad892200cd033efe5498a26504fec.camel@intel.com>
 <ZuCE_KtmXNi0qePb@google.com>
 <ZuP5eNXFCljzRgWo@yzhao56-desk.sh.intel.com>
 <ZuR09EqzU1WbQYGd@google.com>
 <ZuVXBDCWS615bsVa@yzhao56-desk.sh.intel.com>
 <ZvPrqMj1BWrkkwqN@yzhao56-desk.sh.intel.com>
 <ZwVG4bQ4g5Tm2jrt@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZwVG4bQ4g5Tm2jrt@google.com>
X-ClientProxiedBy: SG2PR02CA0104.apcprd02.prod.outlook.com
 (2603:1096:4:92::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CYXPR11MB8732:EE_
X-MS-Office365-Filtering-Correlation-Id: 893f8c6a-9db5-42d2-0938-08dce8ebf5c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?3AepLqE6xA29VbRVA/D8zNqYvoiKVWxG0OGgEoH39D51V4xhVoQkuj4walKm?=
 =?us-ascii?Q?MB45jVe3ZHYNlzv204GgLGCpGBsWSMmflarBtZN9L+epzlBoePxooxDYp538?=
 =?us-ascii?Q?N2dqIAn34JcjwJV1mNfXP0VFaK8xzHlgjVxLQDDzm4c+aZreA1Gnn9o5e3qx?=
 =?us-ascii?Q?QPhbEu4kvkfmmb7+urkPmlS5xuvidpXiQlKNtAFqLu6KTCVWW51clXu/Sh5w?=
 =?us-ascii?Q?pLHHTm5Z+H6Fb42O9R3nXsOzQZeH5ZwfWpT9htn9tkkwJv1bSlc1PMyj/HKu?=
 =?us-ascii?Q?D96sV/puCYSrcTxPg/rZUz5OigtMUesSKKZGTqDHWmlLnSHRxVUu9m5A6nlM?=
 =?us-ascii?Q?rm6m1xaB0SKZs5s7EGCOicaw4i8e4IxL75YSISXLyitw2NgCQgrGN0ERVI6P?=
 =?us-ascii?Q?PuGkFAFpJK0V0oYjTJ1pxkt9u0sYQAVXUVzMw0+4oRO/sbtyfkA2CgXBxEAM?=
 =?us-ascii?Q?pqEGODWzwjD7pZfbZzNzqf0KSut6iruHKqeQTumb4tbksdge2cnmCgDkacR1?=
 =?us-ascii?Q?9c3nXp8Sr1/FdCQuZY8Tuum249LO+1wC3EWRmfD72zBDJ7Jg8c1iWop4KwOK?=
 =?us-ascii?Q?G61lGs56xl8IdCNxKJv37V30NaRyK+nKCSn5EvPwB66tkY9rWFjY0Qc0Rxhh?=
 =?us-ascii?Q?DDM5lZzcDrRrWcqRv1eCBswzNrQ6SyxjU9mqe/Kefr3xgm1nyit9PWD6iISY?=
 =?us-ascii?Q?9AMUf7xQVno/G/igyOm71Qcogd4SUu6USPnHSuqXVAR+h9Rlvd3PqyHT2BCY?=
 =?us-ascii?Q?8EEevDNIKtu79Z6XKHo4hJ6XY+/S3Xc/+6kZvHZch/UH6KWrxB7keVOkK30z?=
 =?us-ascii?Q?zaSwMeh2sD+YTvfxeifbQM4zmLFalqLwAspcoEd/dF8IylQ9RLcQznKTdVrX?=
 =?us-ascii?Q?7F8A5EynieVIDeZ6nY2MpnGeV8r+B0um/I1cVgmm5K5vVnD6I7L3klpsWWp1?=
 =?us-ascii?Q?GGqpRQzok4zbGs/h+IhPrySdVP136ZtURLwDeYHyscrcHA8OEckO/UOnGpCA?=
 =?us-ascii?Q?VXA/Cv1e7labhkUK6LkZUYAI3yPcUvq01BSX4v5crLyMA7CWz17HWxnUM5Xm?=
 =?us-ascii?Q?iVagW/SLUJGgnhFSeIUXhnNnFHKSQRq1H3hHR9ZQoKxfnlNL55JBh/KpYgRS?=
 =?us-ascii?Q?0ChCYy/X8sSTySwsDD+GqrtvYAORFPW4imHaxE7Lzv1fma1yuhYjFXkkVoUx?=
 =?us-ascii?Q?Sk74I/A9PZpH74zauK7hUIsOaPcdeC0srFi7/wxQtewsdPW2YHYD45TSKfp8?=
 =?us-ascii?Q?4ZO1r1g2SGGLo9KmhDptScqqYXj/XqT5jT56E+2uow=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qbB5kxeaT5lAviLThRfnkIs4LBom3QBBL9FfW3mV2gHY7cz9IVWoRTfn/sTA?=
 =?us-ascii?Q?GBMmFYWBsMsP1N/kmqQX06DRNPUm+Qtc9Ulu79JO/VbmgigJdkm1YwL+/4tr?=
 =?us-ascii?Q?DBwHh5P6UsKxT3eEWrUWpsup85EJQmW4MOF/ig5XX80eSSDHIv47M7dH6+7e?=
 =?us-ascii?Q?Ceb+Q4FjzEBeiwlNtqg6k/xuIQmx9J4AN/FpyHjeXG6yF4safbAYjgEQRdne?=
 =?us-ascii?Q?BbOlLbsOlYuEaM2om70CwgqHUeEGtHa+0qbgGaIDzmvt3AU7imzTZ3ss8jkG?=
 =?us-ascii?Q?kQXHgtrXbHCRcfVoLwuES0PrVz79LwymFUft4sfjXFttzSrz1DQCr2xlHlDS?=
 =?us-ascii?Q?eCTSc/izmFJ7/5fAStt+ArhHFFAvnNJ5U1qdLJknv7oMQY0yQIzQi4fJEyte?=
 =?us-ascii?Q?l5l1rk9MUfdZ98Nz9e8d0fc+dyPcSpS/shkzsl8Ub7avbLxYAQlqRZtJUOdL?=
 =?us-ascii?Q?ft4FrYjiOrFBSu9n2XAYO9vIpxp88NYM2bZgN/sKex2yOWEM8ll3uJcT9UVG?=
 =?us-ascii?Q?/ogYW4HyH+4CesviM6oB6HZUrKoHqMrtoSC7lLrN0Z6c8OJBtU5gsdRQ3mbM?=
 =?us-ascii?Q?ok5WjIDzDq0RfbgEXHsP2NO/+B7KHRdFUVuCGJF2h78duDY5ruu+MOmlKbMh?=
 =?us-ascii?Q?MT4/IOVySzvBV1q42qPnxhSNQ20k5BDvRukZ/Tk8X8i5UiwfkoSUuYfHDPQw?=
 =?us-ascii?Q?vTx6GvmGVMiXPrZ1ywVrooMIoLKLFYXnvrUzQY+zHirg7fX0kuZvl/WFeV46?=
 =?us-ascii?Q?MZWCBZfu1eQQiUDCH75QEhaxPzu+qUxhTG08L1LCwF4vc7fFnYg073Ni6TIc?=
 =?us-ascii?Q?Wuk++enG7gj2BwYeOECSW2n9+EZKbn1m6+vkq3mkkrMQBvXSyzKiLrlVuLr9?=
 =?us-ascii?Q?V95VhNcJszoDLMblGhp8trC9tSqr74s1M2rXOIxe4GTR0JpZxXMPq8X+lJtJ?=
 =?us-ascii?Q?1Jwdhek7nUSfBv3oxCJ7czSR6/Fchr7UtReNMOdst6LJ7PeH7s6wx5eJjGEB?=
 =?us-ascii?Q?rtdyrAIycvXktX49b8SfzmMtlxWh/f1SwNk1DjqXFaBiTb2hSnfruSeOeSNM?=
 =?us-ascii?Q?VDMfKvjWAtypJ3MO6aQsl9rLTRk0R58Ov8UHEfR4/YMBSJcBrl481LokVnT4?=
 =?us-ascii?Q?+w7qM57dYDzkn7Tk2M/HkBTSQ98QJ6EVm+29I0loHzlxM8ylDS42jgIIFT8N?=
 =?us-ascii?Q?yKqR5UdNXhLGp470O8IhTJdSzDGiMVhTDQ0o+b34r41W084T12Wy0ysa1FLN?=
 =?us-ascii?Q?iw/tVKIRKKsJTLBRRx8j/cAT7V+ddPYuTZgZbsZ+koHGSr26/yUHE+y77sso?=
 =?us-ascii?Q?XZplTQiLvcqbJwFVMY9XUVgmzNUM4h2BISk0hDTccvR3PA+PUSIN/OtAehJx?=
 =?us-ascii?Q?SBZb8ipGHXhyB0S0f/Ir7xNFOuFyFRfck1TrGp9OFIOSYNDcfzdFf7WzjfGp?=
 =?us-ascii?Q?uR/a0IsSW5mtFCWTYa8OGLcXmdlaYFLhyQWKAg5qWRsvU18LYBQ8PotQl+OH?=
 =?us-ascii?Q?4P2U2Q9NEbqic8QaJzFo55Y28O/uxvjgsXgrXgfmZGGQ3FcSjOVayre6cQ4z?=
 =?us-ascii?Q?wo0//LEC8pVaB70MPxQi9SuAAOxjyQd1/nLkPRfb?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 893f8c6a-9db5-42d2-0938-08dce8ebf5c6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2024 05:25:31.9423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E5+2Z72AwTEaxNtLHPxrduSVPdqJy8R9D2g6WcxZA7XWsNQsARVOlewfe4tbCwkYEz4ai5EIMdDhbD5eSB3F1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR11MB8732
X-OriginatorOrg: intel.com

On Tue, Oct 08, 2024 at 07:51:13AM -0700, Sean Christopherson wrote:
> On Wed, Sep 25, 2024, Yan Zhao wrote:
> > On Sat, Sep 14, 2024 at 05:27:32PM +0800, Yan Zhao wrote:
> > > On Fri, Sep 13, 2024 at 10:23:00AM -0700, Sean Christopherson wrote:
> > > > On Fri, Sep 13, 2024, Yan Zhao wrote:
> > > > > This is a lock status report of TDX module for current SEAMCALL retry issue
> > > > > based on code in TDX module public repo https://github.com/intel/tdx-module.git
> > > > > branch TDX_1.5.05.
> > > > > 
> > > > > TL;DR:
> > > > > - tdh_mem_track() can contend with tdh_vp_enter().
> > > > > - tdh_vp_enter() contends with tdh_mem*() when 0-stepping is suspected.
> > > > 
> > > > The zero-step logic seems to be the most problematic.  E.g. if KVM is trying to
> > > > install a page on behalf of two vCPUs, and KVM resumes the guest if it encounters
> > > > a FROZEN_SPTE when building the non-leaf SPTEs, then one of the vCPUs could
> > > > trigger the zero-step mitigation if the vCPU that "wins" and gets delayed for
> > > > whatever reason.
> > > > 
> > > > Since FROZEN_SPTE is essentially bit-spinlock with a reaaaaaly slow slow-path,
> > > > what if instead of resuming the guest if a page fault hits FROZEN_SPTE, KVM retries
> > > > the fault "locally", i.e. _without_ redoing tdh_vp_enter() to see if the vCPU still
> > > > hits the fault?
> > > > 
> > > > For non-TDX, resuming the guest and letting the vCPU retry the instruction is
> > > > desirable because in many cases, the winning task will install a valid mapping
> > > > before KVM can re-run the vCPU, i.e. the fault will be fixed before the
> > > > instruction is re-executed.  In the happy case, that provides optimal performance
> > > > as KVM doesn't introduce any extra delay/latency.
> > > > 
> > > > But for TDX, the math is different as the cost of a re-hitting a fault is much,
> > > > much higher, especially in light of the zero-step issues.
> > > > 
> > > > E.g. if the TDP MMU returns a unique error code for the frozen case, and
> > > > kvm_mmu_page_fault() is modified to return the raw return code instead of '1',
> > > > then the TDX EPT violation path can safely retry locally, similar to the do-while
> > > > loop in kvm_tdp_map_page().
> > > > 
> > > > The only part I don't like about this idea is having two "retry" return values,
> > > > which creates the potential for bugs due to checking one but not the other.
> > > > 
> > > > Hmm, that could be avoided by passing a bool pointer as an out-param to communicate
> > > > to the TDX S-EPT fault handler that the SPTE is frozen.  I think I like that
> > > > option better even though the out-param is a bit gross, because it makes it more
> > > > obvious that the "frozen_spte" is a special case that doesn't need attention for
> > > > most paths.
> > > Good idea.
> > > But could we extend it a bit more to allow TDX's EPT violation handler to also
> > > retry directly when tdh_mem_sept_add()/tdh_mem_page_aug() returns BUSY?
> > I'm asking this because merely avoiding invoking tdh_vp_enter() in vCPUs seeing
> > FROZEN_SPTE might not be enough to prevent zero step mitigation.
> 
> The goal isn't to make it completely impossible for zero-step to fire, it's to
> make it so that _if_ zero-step fires, KVM can report the error to userspace without
> having to retry, because KVM _knows_ that advancing past the zero-step isn't
> something KVM can solve.
> 
>  : I'm not worried about any performance hit with zero-step, I'm worried about KVM
>  : not being able to differentiate between a KVM bug and guest interference.  The
>  : goal with a local retry is to make it so that KVM _never_ triggers zero-step,
>  : unless there is a bug somewhere.  At that point, if zero-step fires, KVM can
>    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>  : report the error to userspace instead of trying to suppress guest activity, and
>  : potentially from other KVM tasks too.
> 
> In other words, for the selftest you crafted, KVM reporting an error to userspace
> due to zero-step would be working as intended.  
Hmm, but the selftest is an example to show that 6 continuous EPT violations on
the same GPA could trigger zero-step.

For an extremely unlucky vCPU, is it still possible to fire zero step when
nothing is wrong both in KVM and QEMU?
e.g.

1st: "fault->is_private != kvm_mem_is_private(kvm, fault->gfn)" is found.
2nd-6th: try_cmpxchg64() fails on each level SPTEs (5 levels in total)

 
> > E.g. in below selftest with a TD configured with pending_ve_disable=N,
> > zero step mitigation can be triggered on a vCPU that is stuck in EPT violation
> > vm exit for more than 6 times (due to that user space does not do memslot
> > conversion correctly).
> > 
> > So, if vCPU A wins the chance to call tdh_mem_page_aug(), the SEAMCALL may
> > contend with zero step mitigation code in tdh_vp_enter() in vCPU B stuck
> > in EPT violation vm exits.

