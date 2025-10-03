Return-Path: <kvm+bounces-59458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 84D80BB7151
	for <lists+kvm@lfdr.de>; Fri, 03 Oct 2025 15:55:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 373313B6F2C
	for <lists+kvm@lfdr.de>; Fri,  3 Oct 2025 13:55:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 478EC1DF759;
	Fri,  3 Oct 2025 13:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="faF+gDt8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722DC34BA50;
	Fri,  3 Oct 2025 13:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759499706; cv=fail; b=f2Egl09O97Jc0LHJjVep1tHI3b7v21LtK/vJ72QB8GHSOCJNTJfBjokxMHjb/j0E2v+VbUDCychuFPPyiWIl8McyFcYtHm8QKiZG/xq3tQJNhWLdirZtAJwwqK2nEcrSndtDrTgDPSQVUG3RrxTOJNa4JZWBqpwCu8H1IIBnfLw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759499706; c=relaxed/simple;
	bh=/eLdmc71xGmlOC1aSG71JxETMVHNBKizGzTfmkINvzw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Hb3AkHmsBz9+q9TkTmaaorHUtxbW6/jrNPS/TLoW0ltr/IvuLJe5JNDnL2j5sujWE2krjZDE18iu7sZ6UePChIJAGMiVaJR1CWKFBVUgGUjUYrHaCWGPlejHGmzQuMXppGNLKdboPSuTPs2iJhlRd7fY3J0jvgOrrbXXlYCGllk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=faF+gDt8; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759499704; x=1791035704;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=/eLdmc71xGmlOC1aSG71JxETMVHNBKizGzTfmkINvzw=;
  b=faF+gDt80+qfr5tb9WyA5h9lP1Caoh7Ge0KxiqcEYmJ8gUKROhjwczAO
   rCZ/IljyNS4cjCF73pGkZSLSQ+ZZOhFvsO+3Pcq6GKc6R5OMmynoeOgfl
   KvARpJoegWX2L6m1NcxQ2Znt/jkNuP0iE+Pt1/CcXnEjkqozbRpuoRK63
   5S1o+wxN3sIbpSLqJ8gQ8XTyfOLRLHoCWdUCfCTohLf8n2m3R/XALfFO2
   bJ14gMHBEjeRyoCngFxuPc193osPwskSL/fti90Sv3AMKTzNl6HKtO4DJ
   XqNzt1hLQX6gPFLwVPhc5PPVeYXmPdNrd7XXKVugjVGXheaYjky+AuRx3
   A==;
X-CSE-ConnectionGUID: ltqEkQdrTjeaCU8d3U7MEA==
X-CSE-MsgGUID: PdHvatbJQJ+0aHHYgkTJRA==
X-IronPort-AV: E=McAfee;i="6800,10657,11571"; a="73209537"
X-IronPort-AV: E=Sophos;i="6.18,312,1751266800"; 
   d="scan'208";a="73209537"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 06:55:03 -0700
X-CSE-ConnectionGUID: u0nn0QJ7TTKNgeNFiUsSJw==
X-CSE-MsgGUID: upntdiQnQKuC8FHHed+7Eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,312,1751266800"; 
   d="scan'208";a="178587894"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 06:55:04 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 06:55:02 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 3 Oct 2025 06:55:02 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.0) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 06:55:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eSzUzVMdTyriYdqS4dO1RdeBkE3veUdvb5+wNJ7vBwCzEiZZciyA+Nt1Vjz6DRIx84qtFKMmmiTYt4eKdOJcgQtBP+/+o/neqXNO9MrfOVuHq1+qhuJetUccvMhc5eUaIQL6phqRshIuyolVj6A+mbtMw6ULi41janSsX5/uD4WOiRiq6jJrjAJEWHsmuAyZxETvO0yLbAlwpQAKezh2qLJxp9AJpyrXONgqkmgo2oquE+PjLLFefKPTBMhiyLzTj046C1rAqFeZcOArjvY3l8MXbdCzMFk1myYMKzDBd+3SmSKzYso0jTLqY6TdW08EBTgj1T+7bfoi8oLM9qBtqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aVo2nMUarPGv+/dfmruHm8RAtDj9n6ViiPQLJWIOoKc=;
 b=fZWv8qPo1Qd8vVX3sFq8inrpTYz1NSOCjd9bnF0EYReLFo35Xve811xocz1IGHCNQulN+u02Q/+GE2bMgDLECXVuToWh57ms1YYEw5Lb4hjKWehOPtpW/lhp02z5rb3k1Tn9KLab7BJThO+c9glnfqPf90idi1QMMDjxt/tkeSaBqhB1aw2y90tv6AjpMNjsKay3+Bpod5OQL+zjaG8mm0SzgH4BWpw0ht49XMNcrWDWPFaH+iTS7faQ1g4+yhu9dN3EQEO/YAwpUUWgwoZw+y/XnI9e8eiSsUkErnntGwD6W98kFFrsZOhTSDYtdVUgK4Aj/Cl+hzNxITOHtFv0mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY5PR11MB6536.namprd11.prod.outlook.com (2603:10b6:930:40::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9182.16; Fri, 3 Oct 2025 13:54:56 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9160.017; Fri, 3 Oct 2025
 13:54:55 +0000
Date: Fri, 3 Oct 2025 21:53:45 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Xiaoyao Li <xiaoyao.li@intel.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH] KVM: x86: Drop "cache" from user return MSR setter that
 skips WRMSR
Message-ID: <aN/VaVklfXO5rId4@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250919214259.1584273-1-seanjc@google.com>
 <aNvLkRZCZ1ckPhFa@yzhao56-desk.sh.intel.com>
 <aNvT8s01Q5Cr3wAq@yzhao56-desk.sh.intel.com>
 <aNwFTLM3yt6AGAzd@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aNwFTLM3yt6AGAzd@google.com>
X-ClientProxiedBy: SG2PR01CA0116.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY5PR11MB6536:EE_
X-MS-Office365-Filtering-Correlation-Id: b4c9d0bf-6db4-4356-fc54-08de02846eff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?S9Ti2nHP7m1ZOJLvgxWMWR96GhEFtKbLmYa/HKb0hW7u5FF+FVvYN0ZVMBap?=
 =?us-ascii?Q?18YCuB/5ar6jVmk3UzAYLbxxLR+Isp5/nQ5BZsOM5cKVzRtVEen/cl0wy2H0?=
 =?us-ascii?Q?Y1Ai4q9047UWFdj7S3F9KUKM+RRoeY4Fk6CIgoj3p45iyiKMSxyHronM93lY?=
 =?us-ascii?Q?SCETLbudEsaJUV9YqQHL9rV8VioXNGs5YhthVAdDmM+wdRNTVTF9zmGEbbF8?=
 =?us-ascii?Q?is6eCTloF9LrWprS15W9eUGb2KNrmXo+eXTghkcqMyVK7Cx9Dp9lsW5EFxqI?=
 =?us-ascii?Q?M+CplcwVlRSmKk98PhNzi/JukVThPVNNwoO+GVDIFaRp+0+bQsYLOHRWKLyu?=
 =?us-ascii?Q?h3//Yy0/VqJeqinqnP+VZJujPO3pROhSfZj7/r8ghKlZvARuGa79JzDvk1fa?=
 =?us-ascii?Q?b2bjHSElgQVdTPhhch9Oj+OGHC5ww5KxFRj6WzHZa7C6zrGD2LOb7gytnYoF?=
 =?us-ascii?Q?UKS/p3AulutSdlErcG7zZ2FBHB2YR/6tVIbNPUybsEc5Wc7JGlDFi8Y4sa3w?=
 =?us-ascii?Q?ffncY1zWMJEWfV/zMfDboIQIFTbB/iOFIUrMguVTYOVHjIxpmf7kOKZ8cnQG?=
 =?us-ascii?Q?Uq3I4IhtRcJLxzeWQzsi3fxAv4l27PcT71ofqRde9fkbW4vhaPLE+z3G2IAm?=
 =?us-ascii?Q?CChufOzRj4RRXplLx6/ZnxHIsNCyscnnDSDT51f18gFM0DioFpryOutMYKPC?=
 =?us-ascii?Q?LQhsOMNDi4jpZ0L+CdgivU+Z37mw+bMYKbgXJvAO1+GdxHvcWiiKWuXUNIpr?=
 =?us-ascii?Q?cY6IrQ2Nie3r+eHMi8oD0TAlbz4LnhIk2UH/5B5hrk2498exVW/hZAXBCtRW?=
 =?us-ascii?Q?lxgT5J5Vk4HwblMqiD1wa5lCMfvuiFqQ4pe8i7kWVwshLGfGwqYc6hnA5sft?=
 =?us-ascii?Q?9/ebk6bhHOr5uSQuDD3J6QgW2nSllmylMHOXYMJs/4MgMEAY3fZ3x7oCdzk9?=
 =?us-ascii?Q?AbmaSLA6YxmbRINVIJymOzp9FlHdfqbqEI0njOEgiJTxzSOS6bAo2p7mQy/I?=
 =?us-ascii?Q?kcKRuD4e+rKeTVcPOhO0NGCAvUjzNsr/aIS/Kp4FEUeGBgRTYja5EofR+Pz2?=
 =?us-ascii?Q?iHEIXb5ELON/qtNaRrk8s2SpqwjhCivSTjB3JjAl2hw7c4nbyt7O1F4t3+Ul?=
 =?us-ascii?Q?u55vAgv6YbwbtIiGL1pJZdml+v3gcIPbm6Tm8yfjj3rViye56saZs3P5K1+3?=
 =?us-ascii?Q?08JkGAbik4PKH5qJvLsXh5+P2OJu7aiBYwGtaI6KyPGi/a8rD9platn7rZ18?=
 =?us-ascii?Q?exIhQRQbvjWM03AFtu7VwQy9UW6bvQT5x06j3vphjJKr39AKx7kMECeGrH/f?=
 =?us-ascii?Q?GwUAe5nmnPajedMI7kEvVyyf/yxOpETkx47AqpNV7hvEnRi7IwfErp9S7u6H?=
 =?us-ascii?Q?4zdiUp5Aj+8wWAd4NcJZqNktwxiynA1B3PyfXka1g40LYNw8EERHpClDsrMN?=
 =?us-ascii?Q?aM0PYZ6jn9UQmcme8fdl4QIUW7zjaEiL?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AnnqodJhGMGEJ3Xg48Pzy+0PflfCZdpfN73QjVXybjV/VmbhGkoWsNlWwufC?=
 =?us-ascii?Q?568XceTe09b3ZoREB2AyeDnATnzdQNGxpOTuRxXrTnJvRpY+0RiAPkTxdj8M?=
 =?us-ascii?Q?1ZObvQv5aPgt5D+ljCj7BjrFJBNRYPwiGZFGsh5/WAeAfy27Bx/HY6x0yuza?=
 =?us-ascii?Q?Qbc1bfe1mXey3AcsmKNRpJHaxG1dDI+WFplOZUfrmx2GSHv4c/rCxLD1mHvB?=
 =?us-ascii?Q?WEgkgkSWVNMcze0qxHAyI5nku/JBe6I1n3nm6JNkblK9D05hbGj9SULCMMLJ?=
 =?us-ascii?Q?3ru38UFcoLkszfM9+fJOZl+4V2FqEm8tMxlRnvOZAQvSTv7Ksamualxhd+0P?=
 =?us-ascii?Q?C5Gkq2YnhxvUEvsYDrFx0LmYH6qP6gH02tjwll3Kt7yOFvw6HGAqcw3fHxPc?=
 =?us-ascii?Q?EK8UFY9Et13JqWYEt1njoq+CnZ4np+d/aIHkyfTdRjiiLQEWNP+VdO6UBkUX?=
 =?us-ascii?Q?gh5kRp+GlO344hzyN/Ovp2KYFh6D0cE58ohzOQfd9bA3U9JGpxBjZRIIjuJe?=
 =?us-ascii?Q?Mpz8ex30hxu6QYXP2vZDcsJsvVDyv2uO5/tQ6WxeHqeT+G90Gh7HP6a6jZk7?=
 =?us-ascii?Q?S3StXLObWQgBEQ3oVejIcOR40TyGlC1esg6gqA0exPaMdnR1j+F37LfYqQGr?=
 =?us-ascii?Q?tT+Ici0k2VjNs2XVyPfxpKv9tm3zv4HycHhZZ3nNrQ2dl3ZiNMq1004eEE8+?=
 =?us-ascii?Q?9RfYqhsh4gxB805aq6KigBnF+tCWj++IEi8RNait3lQEvZ0KQgJmOfNkPviq?=
 =?us-ascii?Q?Dr8Yhn9r/OuncTJdlwCQRDf8sLdKdYgh+ZYeEW6fGr808aR8M62RnsWlEKKs?=
 =?us-ascii?Q?Tl3bmXYE/H7tpw8QrqKaW1TSdEz488urfUAjF+epmH+MAoe5X9MlfQx0QP5D?=
 =?us-ascii?Q?FtpIejzDS62p67waD5R+rBa491t/kDbKBl2paiqzY2yw12+7W7nlBhnJXYfX?=
 =?us-ascii?Q?9vQA0vDMiMrS7INhNgDKJmdifboKg6NGI9mSkd3D6nLo6WxFsEQORCXS6C+0?=
 =?us-ascii?Q?twHzhNNuVWKV5iHxOApHgmYOb4/Nhwnyl70WsQrzYV1ugmAaTagZIUYJwTFr?=
 =?us-ascii?Q?NA7i+0qPiMsDXo7oTDzXaigMPSPR8A876VE7weRidiBV6/Pl0Lym7CSlZ98m?=
 =?us-ascii?Q?cCtOC57kLr/wShO9kxCNNlYU6KCV/dgQ4Z9EDjVnKnoBDL4GUvqfDQXRw/J6?=
 =?us-ascii?Q?ruBCWI2ZiGHj30cDl6mul+CerPeg6w90OUj4mOZu59COl6fm48OAQep1qcnz?=
 =?us-ascii?Q?7TRyTDF8vg+GJ8o8VMMdCM6MmGw1BYQzaRr/6i5BkgnFHQRpaF117rAIABrl?=
 =?us-ascii?Q?hSXAMt2dXaI+DgGYK6f4QslGaVp19KZjsLCRT0WaCYGP9eiT3wEltXlh46am?=
 =?us-ascii?Q?zJDmGexGjsmgKjs+5ovw8PrYFCjWHFx+R4Zdtlkc3IM8/HVdTx/wi4AJafDg?=
 =?us-ascii?Q?u1YRgEsMiPoyB7u4h7oKdV7/uc6S3hQOT/AWWuNFMf+5j1EwVYlxVo5sI4xj?=
 =?us-ascii?Q?VsuoXwehii2hY0dMXIVsroNxFWE4FH7QZ1oc4Lh7ce0GXXZNiKYTzwe+aRqF?=
 =?us-ascii?Q?af27fAwfUraM5D8AgQ3isFe4xCIlluGHnCG7P4rh?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b4c9d0bf-6db4-4356-fc54-08de02846eff
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2025 13:54:55.9149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nNNWYcyFBhhDASY1V0ZUVBX5wjZOJm1lVAIti5J5fUPSSW0SP+7Iog+alZXNQzFbl8XEySsELkUfNoyQO24aaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6536
X-OriginatorOrg: intel.com

Sorry for the slow response due to the PRC holiday.

On Tue, Sep 30, 2025 at 09:29:00AM -0700, Sean Christopherson wrote:
> On Tue, Sep 30, 2025, Yan Zhao wrote:
> > On Tue, Sep 30, 2025 at 08:22:41PM +0800, Yan Zhao wrote:
> > > On Fri, Sep 19, 2025 at 02:42:59PM -0700, Sean Christopherson wrote:
> > > > Rename kvm_user_return_msr_update_cache() to __kvm_set_user_return_msr()
> > > > and use the helper kvm_set_user_return_msr() to make it obvious that the
> > > > double-underscores version is doing a subset of the work of the "full"
> > > > setter.
> > > > 
> > > > While the function does indeed update a cache, the nomenclature becomes
> > > > slightly misleading when adding a getter[1], as the current value isn't
> > > > _just_ the cached value, it's also the value that's currently loaded in
> > > > hardware.
> > > Nit:
> > > 
> > > For TDX, "it's also the value that's currently loaded in hardware" is not true.
> > since tdx module invokes wrmsr()s before each exit to VMM, while KVM only
> > invokes __kvm_set_user_return_msr() in tdx_vcpu_put().
> 
> No?  kvm_user_return_msr_update_cache() is passed the value that's currently
> loaded in hardware, by way of the TDX-Module zeroing some MSRs on TD-Exit.
> 
> Ah, I suspect you're calling out that the cache can be stale.  Maybe this?
Right. But not just that the cache can be stale. My previous reply was quite
misleading.

As with below tables, where
CURR: msrs->values[slot].curr.
REAL: value that's currently loaded in hardware

For TDs,
                            CURR          REAL
   -----------------------------------------------------------------------
1. enable virtualization    host value    host value

2. TDH.VP.ENTER             host value    guest value (updated by tdx module)
3. TDH.VP.ENTER return      host value    defval (updated by tdx module)
4. tdx_vcpu_put             defval        defval
5. exit to user mode        host value    host value


For normal VMs,
                            CURR                 REAL
   -----------------------------------------------------------------------
1. enable virtualization    host value           host value

2. before vcpu_run          shadow guest value   shadow guest value
3. after vcpu_run           shadow guest value   shadow guest value
4. exit to user mode        host value           host value


Unlike normal VMs, where msrs->values[slot].curr always matches the the value
that's currently loaded in hardware. For TDs, msrs->values[slot].curr does not
contain the value that's currently loaded in hardware in stages 2-3.


>   While the function does indeed update a cache, the nomenclature becomes
>   slightly misleading when adding a getter[1], as the current value isn't
>   _just_ the cached value, it's also the value that's currently loaded in
>   hardware (ignoring that the cache holds stale data until the vCPU is put,
So, "stale data" is not accurate.
It just can't hold the current hardware loaded value when guest is running in
TD.

>   i.e. until KVM prepares to switch back to the host).
> 
> Actually, that's a bug waiting to happen when the getter comes along.  Rather
> than document the potential pitfall, what about adding a prep patch to mimize
> the window?  Then _this_ patch shouldn't need the caveat about the cache being
> stale.
With below patch,

For TDs,
                            CURR          REAL
   -----------------------------------------------------------------------
1. enable virtualization    host value    host value

2. before TDH.VP.ENTER      defval        host value or defval
3. TDH.VP.ENTER             defval        guest value (updated by tdx module)
4. TDH.VP.ENTER return      defval        defval (updated by tdx module)
5. exit to user mode        host value    host value

msrs->values[slot].curr is still not the current value loaded in hardware.

> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index ff41d3d00380..326fa81cb35f 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -789,6 +789,14 @@ void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>                 vt->msr_host_kernel_gs_base = read_msr(MSR_KERNEL_GS_BASE);
>  
>         vt->guest_state_loaded = true;
> +
> +       /*
> +        * Several of KVM's user-return MSRs are clobbered by the TDX-Module if
Hmm, my previous mail didn't mention that besides saving guest value + clobber
hardware value before exit to VMM, the TDX module also loads saved guest value
to hardware on TDH.VP.ENTER.

> +        * VP.ENTER succeeds, i.e. on TD-Exit.  Mark those MSRs as needing an
> +        * update to synchronize the "current" value in KVM's cache with the
> +        * value in hardware (loaded by the TDX-Module).
> +        */
> +       to_tdx(vcpu)->need_user_return_msr_update = true;
>  }
>  
>  struct tdx_uret_msr {
> @@ -816,7 +824,6 @@ static void tdx_user_return_msr_update_cache(void)
>  static void tdx_prepare_switch_to_host(struct kvm_vcpu *vcpu)
>  {
>         struct vcpu_vt *vt = to_vt(vcpu);
> -       struct vcpu_tdx *tdx = to_tdx(vcpu);
>  
>         if (!vt->guest_state_loaded)
>                 return;
> @@ -824,11 +831,6 @@ static void tdx_prepare_switch_to_host(struct kvm_vcpu *vcpu)
>         ++vcpu->stat.host_state_reload;
>         wrmsrl(MSR_KERNEL_GS_BASE, vt->msr_host_kernel_gs_base);
>  
> -       if (tdx->guest_entered) {
> -               tdx_user_return_msr_update_cache();
> -               tdx->guest_entered = false;
> -       }
> -
>         vt->guest_state_loaded = false;
>  }
>  
> @@ -1067,7 +1069,11 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
>                 update_debugctlmsr(vcpu->arch.host_debugctl);
>  
>         tdx_load_host_xsave_state(vcpu);
> -       tdx->guest_entered = true;
> +
> +       if (tdx->need_user_return_msr_update) {
> +               tdx_user_return_msr_update_cache();
> +               tdx->need_user_return_msr_update = false;
> +       }
>  
>         vcpu->arch.regs_avail &= TDX_REGS_AVAIL_SET;
>  
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index ca39a9391db1..fcac1627f71f 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -67,7 +67,7 @@ struct vcpu_tdx {
>         u64 vp_enter_ret;
>  
>         enum vcpu_tdx_state state;
> -       bool guest_entered;
> +       bool need_user_return_msr_update;
>  
>         u64 map_gpa_next;
>         u64 map_gpa_end;
> 

