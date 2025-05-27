Return-Path: <kvm+bounces-47782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 51503AC4CA9
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 13:01:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F5FC3A50A9
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 11:01:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9E17257430;
	Tue, 27 May 2025 11:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z/u9e17e"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1F9253F2D;
	Tue, 27 May 2025 11:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748343688; cv=fail; b=syQh+1a6WzfjJC5LlA0TgmFzRWksCIG/SZh/NT29lWWh++mvZLaQGRFX+s1Sb2dDA2tZHsi03dMokcNj3qlQZMxKKiG1LHX6dBgDPvlJTstGs6lMxXnOmEZtR3An4OSoP0oGF5FHEyXbZvexuhfAJxV4F9ss45JUPccbjX1xX5I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748343688; c=relaxed/simple;
	bh=+bKMYgrXVqOqloPJ3xY2e3OEm+zCLKoR2dkvekRrS1A=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Zz8JVp5tUxXEHN1kSJBWVhCYwB9a+AV4PDUrvDzuLRlQHkENabQ7GACCxK7Rk8kLQXDfm+coefq3iIrXaGzVc3HUyllZJiQVXN3IB+fkCEwXxDbyD0YfOzPZXUVooxnSIXfMgB37sbffYtn8TXgHBmN3c4e3dw9Tp1+KUUGu69w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z/u9e17e; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748343687; x=1779879687;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+bKMYgrXVqOqloPJ3xY2e3OEm+zCLKoR2dkvekRrS1A=;
  b=Z/u9e17edMceI064KH8d+563H6nCdaPYEK1Nonek5QQ7wNAtSC/nLMUD
   /pZ/yHUtcrsoN40fghGZ6Rtnh45gN+wITIUkb3KuCCPcfUyiXuvvg+6Qn
   83yKS1dvxHJmZdKL6hc1Sx38zGY7LsbkBTv69+8P/DQbqR2JdlLt/H2cM
   14cQK+5XiBmceddf3BzPFv9Pt+PLfi3WrhoGrd05Tto4ogGxL2wUuvSqG
   aiFk82xIuZahUBdzlPnT2+mOu1MR81ibjJ/bD20QZ+4zZ8Mx/2ji2SMjq
   fSkc1+QHxDypqLWGYWWtrdVWfdqRKsYHOmx4bkInCOjyrIzcIcQK8Xwvb
   g==;
X-CSE-ConnectionGUID: t0N/iM6NT8iMUyjGIprpVQ==
X-CSE-MsgGUID: J69ZBhshS2aI2p8VsrTw7g==
X-IronPort-AV: E=McAfee;i="6700,10204,11445"; a="50253538"
X-IronPort-AV: E=Sophos;i="6.15,318,1739865600"; 
   d="scan'208";a="50253538"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 04:01:26 -0700
X-CSE-ConnectionGUID: yNWqIK//ScqXPfAgTs2rIA==
X-CSE-MsgGUID: JfR/V3WfTTWVn9M5YKiScg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,318,1739865600"; 
   d="scan'208";a="147639019"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 04:01:25 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 27 May 2025 04:01:24 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 27 May 2025 04:01:24 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.73) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 27 May 2025 04:01:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZwYjYbdxjZhqDP+0srJvd2g5hmYmiWDsVd0vmRsPAulaq4fNdsaT4yFOWd0ZJHkgtK0yLURBUUILmWbgZ0iwaF4oNikWlemFzSKYXHi4Yg1YTmg6yndanupTqsfD1yZG0h5E8yyIzeL7zr1+7VyCNwj9evGSSmxg7bmYLbkTxnFlrYFYsDfNLPDQUryF8BzhhNAN/xL8NcHyv/RW1bKw6RtpObjcxpZyEAavLXDkdt+SK5TOjWJDPh8pxoAZUwqKth3VhsoQn7RKPyCkyWRynxw+BfVkAqLZq3W1WvFjOOV8cdtnz/22kCUxdh9UL6kxqj9nIJH4wSHsR7XBdoq/bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qkyl5NzOnkHEL8nReY6313f3tf6+9RMrBGpx8sH16y4=;
 b=Yll0c9U+ECIF5XiylXoHxLbk6z91cV/v4HB91fl+p2cezbFps7e4wNsLOHxc62G9rqCc6ZSIV0/2sjC9n62Ni2wGga3cSRtCbnZ+WrHXiA3tJi4c/mXi96kidOhhN/mslRkG5Pqm9C3hv6WoZBCxWvQgeexsf5akfVteNhbv+j4w+Lj+2Jh8tI+qGPQLrlwcs+h7r3URjf46voFTWupfgrrzImN+JV1lUX/kYQTDOSCu5ofG9BIIM2yBvLDRIBTRjvIi9rWzUhOkmqxuBOB8vEMwBkrTryE+yd4wgwOCIuRHTQaap3VgdfmmrzRAWBjVRy3Z6whsxfP9sco7WUjhJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ0PR11MB7701.namprd11.prod.outlook.com (2603:10b6:a03:4e4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.26; Tue, 27 May
 2025 11:01:22 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8769.025; Tue, 27 May 2025
 11:01:22 +0000
Date: Tue, 27 May 2025 19:01:06 +0800
From: Chao Gao <chao.gao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: Sean Christopherson <seanjc@google.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <tglx@linutronix.de>,
	<pbonzini@redhat.com>, <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>,
	<chang.seok.bae@intel.com>, <xin3.li@intel.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, Eric Biggers <ebiggers@google.com>, "H. Peter
 Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Kees Cook
	<kees@kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, Mitchell Levy
	<levymitchell0@gmail.com>, Nikolay Borisov <nik.borisov@suse.com>, "Oleg
 Nesterov" <oleg@redhat.com>, Sohil Mehta <sohil.mehta@intel.com>, "Stanislav
 Spassov" <stanspas@amazon.de>, Vignesh Balasubramanian <vigbalas@amd.com>
Subject: Re: [PATCH v8 0/6] Introduce CET supervisor state support
Message-ID: <aDWbctO/RfTGiCg3@intel.com>
References: <20250522151031.426788-1-chao.gao@intel.com>
 <aDCo_SczQOUaB2rS@google.com>
 <f575567b-0d1f-4631-ad48-1ef5aaca1f75@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f575567b-0d1f-4631-ad48-1ef5aaca1f75@intel.com>
X-ClientProxiedBy: KU0P306CA0021.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:16::17) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ0PR11MB7701:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d8f7868-ff2d-4618-2461-08dd9d0dd0a1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?meZShFDEg5IVWflUGxnnDf6bANBq11yRUxlaoWCJ6TTtxFoT6lRUHRHaLco/?=
 =?us-ascii?Q?rRErmtobo/uqOhXMC6F1F+jSi867KWCeRl0AOarx+xvxVnGBX/PiH0X9yhDq?=
 =?us-ascii?Q?ojJj8Ej+aE9ZQeGDxMLmSqOIk5McZo+OBqHI+7ZmyjlPJLgnsuXU6NXSUoUQ?=
 =?us-ascii?Q?fRXihyJ78WUdB6qCAhCuE+ov/qV0JAPx3l311E0v/fIiVhEBKKQ1h904rnnQ?=
 =?us-ascii?Q?reDs5BEkM2AnUFuWyU8Rwv17/I3PhRz6OqAEQCcb9eGVTXFTU+CuAtTYSSbt?=
 =?us-ascii?Q?/Atm8gJRpmJGE8xdOE+XZ9XBV3qe2LVSEdlUQLXVcN5m7npt1A6H8HBKlkio?=
 =?us-ascii?Q?ZBqvpOaZBW3nYb6mP4i/PhZtMMb6ZiDMGMeoFWWEHOWDJQyceLLP8zFtBif0?=
 =?us-ascii?Q?YSxADjGx8W9hf4cXknqy97irP/ZKMTNTmTfilR8GN/PozIoypYY7pH5ws8JF?=
 =?us-ascii?Q?I7v8Z130qHXVN2XCjsLlgdKiYe8vEzItfRccAA0QTZ2HWci43LhCSmGAmAq7?=
 =?us-ascii?Q?Rwls6DIe0QJD+gWVepUV8xmomh0JI3DSoaWs0iMOXEgq3Qw66TmW6Hyqg0dW?=
 =?us-ascii?Q?41TxsaiUyAyjgIyvR+9bLTum5DSfSi01zG0zNSpIAbduSnMC1Q1g2fAexYnH?=
 =?us-ascii?Q?84Of1QmQvyr1q+U0+zWdGWs4U8qGgnAURwv7zu4rxpASmLHIWxuFAPT97tMp?=
 =?us-ascii?Q?89sY7wrUICaHhnHchJ65rScsSe8GWPCR+i9MISBkKUMtRsVeTnuy4KgExk0P?=
 =?us-ascii?Q?SqYdeTPDBmUERD+iymgb9pKwcfD9igg8W0XVd3E2+ivfZWGWwNtxrY5xhsFi?=
 =?us-ascii?Q?7nkL2uPsfrOLlpzc2kW/0MxHrZSGJVrmlbilX95ARjsK7fm+RPTB1qvVZ9PS?=
 =?us-ascii?Q?dZVxYSaMqIZbHN88BAgFZs0Qavmno7apz31uhO5RIiGWGp8chdKG+ll2KL94?=
 =?us-ascii?Q?2rvr0/14ipHBIAraonEE2sQrAC4m2Odxoorwgzt/MOVBlDkdUVLGculrrJLs?=
 =?us-ascii?Q?2rJBKcUb1KCZHlWCTw8ropzu63i7C1YsqrYri6XW8+k5bIVrxtCy3Ex8z3Tl?=
 =?us-ascii?Q?Uh2OM9Q52kkt7CpgfyQi6F5hx3ASF7Hjbeg0XCh+mnycbWpEY9KAMePCPcRW?=
 =?us-ascii?Q?aTH4mn//hJDc4FkYExgxiWVqypXeICS3U2shhcmo/VGplxJhYIFV8z2JBwt5?=
 =?us-ascii?Q?b1Mg96EVDpuFVBikUgkJ7N2thbGzdx0RHDTpQdjgP3r54O0EG7DGw1CFYoWR?=
 =?us-ascii?Q?c6xH0QlewikmzDNP3nvI4wGG2Ros9jJg01MU/UpMFKn4foIURr10a7zBIzGU?=
 =?us-ascii?Q?OwgfmD41goxCN3KiAXQrEIY87hYGtsVisVYYslAhhd+QMGKpMXK9BULFAuao?=
 =?us-ascii?Q?qeLGH2BnrsaxPnxX39BuTzSPZYG7ckVQfQEtxXPetmuS5F83NNESl+i8wC9+?=
 =?us-ascii?Q?8y9hWUOa4fA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OBvsVneUp74Nns2ypaoXSh62QO8H0qOr2yEpL8J/XfXzgfzb197uIWRmVi0O?=
 =?us-ascii?Q?E37Pz2vbHZlK4g9tk6A0i28lWyCVUblWCc5NMxMqwPB4mpHjr/zRv19HgkMl?=
 =?us-ascii?Q?gTtyGQEccgjyUpqQgRRhRnDDMpyYjRivWzTv3SM72ni26QVeRTfi8gKk0JJJ?=
 =?us-ascii?Q?CFPLV0ajxnMoznQlkzsCJMRihp5Ctcq3NHtPiGTka4ZbgKKtrYNeubiIXZNr?=
 =?us-ascii?Q?ugMYtX9LPqdklu+dyCCeJwnNAmPvKbrOF3+LjSCVvN/QwwFZ71x+Dwf4xPL+?=
 =?us-ascii?Q?w0VMgg42SZzewuUOOUVl5bPIMvB47XVwazUxrxG1E6zwH/pIVyHvJ4bJOFgJ?=
 =?us-ascii?Q?BwFFxx+jTZ3wPVdPTB0UJKjtoHDobzChOWEJPGJDvZnkLnmT5HEQTZ5ij7uT?=
 =?us-ascii?Q?cxQs3SD6X5YW0lWjAtEsC2XwKhw+BQe9ag8IZb4KVFKwiPpidNQH9G0K+ua9?=
 =?us-ascii?Q?4ZTNbVVGBl/btl1nuHipc9IL/nh4PKJgPLq8PUoC1/jWse+M0UX9PmOZpp7D?=
 =?us-ascii?Q?C8FWJIMkhdA5WROnjEWsXNc//zf02mZSXZYnTibCtSLRiEc/gQ012QAaJ82s?=
 =?us-ascii?Q?XvzXBOCFQ7Trev4hpC6cDKzDXTHvvETflePB5xGOeWspKybCpAdILiVUEleg?=
 =?us-ascii?Q?kLWFe52pBypudtLbV9fjVLBBH7+Iv9t9ltdrMQ0/OJGAkFTMWCM3s+5bdqEv?=
 =?us-ascii?Q?UcOt3fOFcq41ZkiPl7HxVF5X5CecgvHC7kKgz3Dez/M5uJO9lmxmHQ+Y9Tqp?=
 =?us-ascii?Q?Vmcicw3/V5/9m3402LWVNKmqRlgOfXyRoLUnmSBcqW+/igm78Ro6Nt+EVEaT?=
 =?us-ascii?Q?dIHhyi39lPu4kG4lwLG+4aZ0gjvLNpnQxhOG/5p3+2KyW8U94Ny5XmzLoDQt?=
 =?us-ascii?Q?s/7lsuHL3MRiEjHAP4tHR/BsAL/pwuQYdxgrksd2PLWDXq9IBqthxCiiM0dv?=
 =?us-ascii?Q?D+qoAgEuyif3Q+lhyM+YivNIdUKWTRVyAP5T/jxJxot3q1F6oPy0JBUaU6Ym?=
 =?us-ascii?Q?e2SAv0fksE8BMdjt085OWvCZsHnWcsEN6aqZAboeON8a+Zyao9mt4HTCQxi0?=
 =?us-ascii?Q?p74W+0gzf8+UHFIOg8afC4gajRCnKp0akbJjcl1ubLn3bH/wCFl7YMnDiCXo?=
 =?us-ascii?Q?isXZjjxr/NIz9+MUglPjL3FHA2M3AihyLV4UlXnKNbNDdek87J1Go17pcc08?=
 =?us-ascii?Q?i4zw32/4/phi8CuvUjRk2AiorEdvWduzJVvDG6Ot/xTssEI8+qesmtZoVmV9?=
 =?us-ascii?Q?GmjP9BJL+cDMuy/bpTud/4ZyAukpJNB+AN5l3rBiX+cXTEhujSTk7LgC5bU6?=
 =?us-ascii?Q?1+U6njG4JBSyBt6dugdXXKQMm2xGPlu87SPaLe0h5xmEXJkMAk+Ds/S3C7sy?=
 =?us-ascii?Q?ntx/GdpQQUiIISdG2bQmvFj59chdDMO89JUQ0kdzk67xgE1jyZI1gyCfcVJn?=
 =?us-ascii?Q?L59JcQYiS1gG1hDeHxToorZgS3qi8zlEx41L/VFOo4nn4olZCY0yAd6GyJO8?=
 =?us-ascii?Q?QxH8Z/nZ/9buMjQczTHMrFiqIzoWqjnHS97LZlsOX8yu0h5YKntxybKxUAlD?=
 =?us-ascii?Q?ICoksTq1CTNjihMRQUv9k/QmdPb+KWfoIABXBNUM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d8f7868-ff2d-4618-2461-08dd9d0dd0a1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2025 11:01:21.9088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rcoFUkMQp+mHo3PtwmiQnmXmS86AxXjf+x/TJEkRyiqfWA3DEjt8MK56GclHW2RbGd/Dj0xYOs/UpToghoG4ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB7701
X-OriginatorOrg: intel.com

On Fri, May 23, 2025 at 10:12:22AM -0700, Dave Hansen wrote:
>On 5/23/25 09:57, Sean Christopherson wrote:
>> Side topic, and *probably* unrelated to this series, I tripped the following
>> WARN when running it through the KVM tests (though I don't think it has anything
>> to do with KVM?).  The WARN is the version of xfd_validate_state() that's guarded
>> by CONFIG_X86_DEBUG_FPU=y.
>> 
>>    WARNING: CPU: 232 PID: 15391 at arch/x86/kernel/fpu/xstate.c:1543 xfd_validate_state+0x65/0x70
>
>Huh, and the two processes getting hit by it:
>
>   CPU: 232 UID: 0 PID: 15391 Comm: DefaultEventMan ...
>   CPU: 77  UID: 0 PID: 14821 Comm: futex-default-S ...
>
>don't _look_ like KVM test processes. My guess would be it's some
>mixture of KVM and a signal handler fighting with XFD state.

We are hitting the third case in the table below [*]:

 MSR | fpstate | cur->fpstate | valid
-------------------------------------
   0 |	   0   |	  x   |    1  // MSR matches @fpstate
   0 |	   1   |          0   |    1  // MSR matches cur->fpstate
   0 |	   1   |          1   |    0  <- *** MSR matches nothing!
   1 |	   0   |          0   |    0  <- *** MSR matches nothing!
   1 |	   0   |          1   |    1  // MSR matches cur->fpstate
   1 |	   1   |          x   |    1  // MSR matches @fpstate

*: https://lore.kernel.org/all/88cb75d3-01b9-38ea-e29f-b8fefb548573@intel.com/

The issue arises because the XFD MSR retains the value (i.e., 0, indicating
AMX enabled) from the previous process, while both the passed-in fpstate
(init_fpstate) and the current fpstate have AMX disabled.

To reproduce this issue, compile the kernel with CONFIG_PREEMPT=y, apply the
attached diff to the amx selftest and run:

# numactl -C 1 ./tools/testing/selftests/x86/amx_64

diff --git a/tools/testing/selftests/x86/amx.c b/tools/testing/selftests/x86/amx.c
index 40769c16de1b..4d533d1a530d 100644
--- a/tools/testing/selftests/x86/amx.c
+++ b/tools/testing/selftests/x86/amx.c
@@ -430,6 +430,10 @@ static inline void validate_tiledata_regs_changed(struct xsave_buffer *xbuf)
		fatal_error("TILEDATA registers did not change");
 }
 
+static void dummy_handler(int sig)
+{
+}
+
 /* tiledata inheritance test */
 
 static void test_fork(void)
@@ -444,6 +448,10 @@ static void test_fork(void)
		/* fork() succeeded.  Now in the parent. */
		int status;
 
+		req_xtiledata_perm();
+		load_rand_tiledata(stashed_xsave);
+		while(1);
+
		wait(&status);
		if (!WIFEXITED(status) || WEXITSTATUS(status))
			fatal_error("fork test child");
@@ -452,7 +460,9 @@ static void test_fork(void)
	/* fork() succeeded.  Now in the child. */
	printf("[RUN]\tCheck tile data inheritance.\n\tBefore fork(), load tiledata\n");
 
-	load_rand_tiledata(stashed_xsave);
+	signal(SIGSEGV, dummy_handler);
+	while(1)
+		raise(SIGSEGV);
 
	grandchild = fork();
	if (grandchild < 0) {
@@ -500,9 +510,6 @@ int main(void)
 
	test_dynamic_state();
 
-	/* Request permission for the following tests */
-	req_xtiledata_perm();
-
	test_fork();
 
	/*


>
>I take it this is a Sapphire Rapids system? Is there anything
>interesting about the config other than CONFIG_X86_DEBUG_FPU?

