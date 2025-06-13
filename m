Return-Path: <kvm+bounces-49443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32F96AD912B
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 17:22:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F1D63BC08F
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 15:22:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DE8B1F4CA0;
	Fri, 13 Jun 2025 15:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KEHRQ0Eu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F901F2BAD;
	Fri, 13 Jun 2025 15:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749828122; cv=fail; b=X+wX4pAoB/dztFsBODWEllCMjHg4OYdeq9Il3V+3i8RI71DqMiEl57EJE7ARtWn5cO7OigoTIcyppE1pT8vQx3Pn4KXhutGe+lbt5N2i0B9VfRjrKxeoQo192GUt90/urCzZwy7o5GKDxMQ2sq9W6NHhETkBAHQBexV7jEemPwk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749828122; c=relaxed/simple;
	bh=h4RUeCw/ew0MpvFw0avCeHT8pa0rT7URv7z6oqamCv0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dEHV/lIYLt+Q0F1LT2SJvYKaVjKbwQ66u/LgJoK1GetFzAgk6XWQt/yPnK+lWngU43+7OOoq/7Np1oWVaQlmDto/i27J2rIdSBjbMwQLORBWY3Y0Mx36wIydHxhF0RiS3HQtrBH4RVwcmRsguMJBs86oQ2FB91HZOGU3Q3pMJZk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KEHRQ0Eu; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749828121; x=1781364121;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=h4RUeCw/ew0MpvFw0avCeHT8pa0rT7URv7z6oqamCv0=;
  b=KEHRQ0EunrPnZ3T44OvGIPGDeThugm4+rpf8EEbunIaJZKiW56405RU3
   t6U/42l/mhIvHesrMYTyyI5J5cXZa994h6lzIpsWsrQl/JYHz54n22ywR
   fEKdWEew6d6pdDRuxEtRjoqhWeVP/03y3QiUUsDadufKMtXXHtfupqP0D
   btacEKEpKYFfIE3qp00PlvGtDB+qXSpn8H/lmNOBr1b24+ZEFS7N7diVo
   Bw/I+pVrzWfSQnLSYujzQiO7qGetIuVC3v6sE8r1ThzUtWO1yaXDYKaAX
   Ru2vbKStMadI1KU5Ib3lhsOzn++UfwKbvmliru3GbWqwpzJeWMv2K2ADm
   w==;
X-CSE-ConnectionGUID: FJFsgk9yRfWbExOwD1cQZw==
X-CSE-MsgGUID: EtoejLklSSe/KEvVRGfs0A==
X-IronPort-AV: E=McAfee;i="6800,10657,11463"; a="63082095"
X-IronPort-AV: E=Sophos;i="6.16,234,1744095600"; 
   d="scan'208";a="63082095"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 08:22:00 -0700
X-CSE-ConnectionGUID: xlB0JfSdS1iUc4TXYXUp7A==
X-CSE-MsgGUID: CrK89pRqRFycEQFe1ZeP5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,234,1744095600"; 
   d="scan'208";a="153146203"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 08:21:59 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 13 Jun 2025 08:21:58 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 13 Jun 2025 08:21:58 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.47)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 13 Jun 2025 08:21:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kLbPmwcxlTL31jjTDkOcn2C8TRZPK/5S1H1E+FmYub60BqpsU+ZdQvjnH/fs1ngdTa4aQNw/urOCw+AlvEbPuG7KQ/Gn6uqMUV8Txv29RGVGDAfcFwcd0tkJPbEG9L56DGnfRgt5jLsAA3rk8f0vWcJRjxf42N57598t8rLirB4eDyfU+pqu3emMpQaiDtL7bGvZdJNH8jHOEj02U1xAh34XtJL+36xgCMU7p/nypyfwfaqf2qSJldE9lMH+Pzf+fwFe+4e8RwVdEdyOv4yKvfQlURq8Wu304nRhpfyyETTYxLWItb6kYW0GJuM2XfyNHwnTYCDEBu59hsfSR00+/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tp2OR7Uyuov4FBB2WviMt6Ir5A2+qN4QiURUn6+Q0ro=;
 b=otg3SU7NubVXN7ahlX9MrH4ohq926rjJ0thCZ+bGHdE1MQ/WsJXcBhd3pBjNVp+YimjWO398elAHkICLxcGDybUp3t+PX5q4phyqJAurcXfOzebTUemh/UmrZEAI8XC50xnZPybn36vElQVjxZmsXHycHFD89phVlEorWKgQ13eEDLoe+t8TbhyHNua9/ds/gGQff7vW/R7BfBUQ1PcJ9cdmY+q04G5CQShWwoRTucZQ4rRvr85Mb8fwWizWdk6ADRjIgQdoeasnkQrBRJ77O0qeYfIyUGXg/iOrhsGAUT1LaDkF4UAeT514Hk3exF4tKrfrdMnhnNyq248eBZKjdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by LV3PR11MB8532.namprd11.prod.outlook.com (2603:10b6:408:1ae::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Fri, 13 Jun
 2025 15:21:56 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b%4]) with mapi id 15.20.8813.024; Fri, 13 Jun 2025
 15:21:56 +0000
Message-ID: <674cc297-f328-4987-9ecd-ca579c3b0971@intel.com>
Date: Fri, 13 Jun 2025 08:21:54 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 00/10] x86: Add support for NMI-source reporting with
 FRED
Content-Language: en-US
To: Peter Zijlstra <peterz@infradead.org>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, Xin Li <xin@zytor.com>,
	"H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "Sean
 Christopherson" <seanjc@google.com>, Adrian Hunter <adrian.hunter@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
	"Zhang Rui" <rui.zhang@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
	"Andrew Cooper" <andrew.cooper3@citrix.com>, "Kirill A . Shutemov"
	<kirill.shutemov@linux.intel.com>, Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>, Kai Huang <kai.huang@intel.com>, "Sandipan
 Das" <sandipan.das@amd.com>, <linux-perf-users@vger.kernel.org>,
	<linux-edac@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>
References: <20250612214849.3950094-1-sohil.mehta@intel.com>
 <20250613070619.GF2273038@noisy.programming.kicks-ass.net>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <20250613070619.GF2273038@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0112.namprd05.prod.outlook.com
 (2603:10b6:a03:334::27) To BYAPR11MB3320.namprd11.prod.outlook.com
 (2603:10b6:a03:18::25)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|LV3PR11MB8532:EE_
X-MS-Office365-Filtering-Correlation-Id: 73d83674-8f16-4fc6-97a1-08ddaa8e0878
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dktqeWNvdVZXWVdiR1BlZUVJQXpReDFwSmRaUVNnVjRFNS95THN6NXpzbTZv?=
 =?utf-8?B?UDl0N3FHVi9yaW5QTUhVakRESmV4RTJnWFVzdFRiZ1NJYjR3MXpYem1QY0lj?=
 =?utf-8?B?VUgvekg2MzNaMU1XVTJ1cjF3ZDBYdWw0VUwyK0N3ODlzN09UekFkUUFOdGVv?=
 =?utf-8?B?TEszUVFiSUUrdmltT01MSVcxUXJtT25SV2JJTWNIc3VmZm5qdjRTbnQvcU85?=
 =?utf-8?B?cVRtaUp3Vjd4KzA0ZlNlZFV2bGZaRTBZTDB6QWlZbHZ6S2pmVThWYnZZWFpo?=
 =?utf-8?B?cTZoRVdhWTBPMHV6NU83enptSzFJUGVEQnhMMmp4dnZJblA1YWxNSjFhbzdn?=
 =?utf-8?B?T0VtalhGeVBvaWpNZ2hNNnFVN3BUT0pha2JMdFk0MW9Edk5IN25xdmpWb3Ft?=
 =?utf-8?B?TzV5R1ZxRFNnMTZVYkxlTTRXK1VwbmtpT3lJcFRuM0xYVUtIQkpMUjZlNThy?=
 =?utf-8?B?MnZySm5YV0w4RXhIdlkrNHNXZVNuWkJNYnRSZ2NSR2pra1RkMkVhajUxLzJO?=
 =?utf-8?B?aS9JWndWZWR5cjA1dkNLaG05c1VPQVhyTktWaDJtRWRrZTMvWmt1N3pPbThX?=
 =?utf-8?B?NmtJM01xUEpuQkNHa05tK1ZvTTBNeFdyY2dtbG1YTkJrK1M0bng5R3YwNkVV?=
 =?utf-8?B?NjRhWldQOVBmLzF6dEhqVENRRlpQSk4zYjU3NGMzbUc4NTNoZmhIRXVhOVln?=
 =?utf-8?B?N2FiNVpUN21ETjRPVHJiRHBySWFMZDhUQXJpYkRlUmpuRTVYd3ZZZElseDB2?=
 =?utf-8?B?YjNKd0ZnRU5NenNkK2VEMlJxRzJOdVB2djhkL2tvVnlJSnpZZlFEdnd5bk1v?=
 =?utf-8?B?WFprOVp1RFJycXMyRG5TTjNwY0VuKzBkZFZrcmlSNXlGSEVCeDAxTThlaXpJ?=
 =?utf-8?B?YWZhMU54ajUySVdabE5GalNMK1ZuU0ExdVB4bHlNNlRsVmpJbzMrby9ST2tE?=
 =?utf-8?B?ZHF4amQ0V3hXVHU3b2YwTnFhQ3FtTDhROFovelR3bW9DN3FyZ29RTHorVWR1?=
 =?utf-8?B?UjR3clpacmhVZHZMaUQrK1N1UXZQQXFES0JKRlBjeUQ2M2pFSWFob3g1VVlO?=
 =?utf-8?B?amdkQk16Wm5hSDZOaVo3SERVSzN3Y01QRUdEQ2JjQnpwOEpkT2F1UTJpSTlD?=
 =?utf-8?B?UEdRRXRZbmtzZTlwU09wcHNZZVl0QWVpN1Z2YkJHTWJNUlVHMnoxM1R2M1Fw?=
 =?utf-8?B?WnJybSsrTVd4SlVGUHlVczFVNkVVL3RWd0tPckdydUpTUkRVeXFkanRVeCtZ?=
 =?utf-8?B?c0xJby9ocndNMm5RdThpdDZWeGdnQU9YbG9GWW81LzBBcVVreXl5M1oraVVx?=
 =?utf-8?B?TEJqZWFhNFkrams3RGRPbGhjazNnSHB1V0RhTE1ScGRTUkdVZEdzM2dqdlFk?=
 =?utf-8?B?V0laSDF6dU9YbjBBbEE4cjV4ZWQxbDNNc0sxTXJtaFRzNU9jSGh1b05VODB0?=
 =?utf-8?B?RHpXS2xvZ29NY0F4YVB1SzhreEx4QVJnL1FtR3JuSVN5RjF1MTVOcTNHTVo0?=
 =?utf-8?B?Vm1EcWdsZ0RuWlRFTGxXK0podVBzWGNnMWxGQ2N1YXZhUk9YZDE0TjVQVnlL?=
 =?utf-8?B?K3pkbi82a2g2Q1VSdUZqK0Ivbm41eTQ0RHkyRXFvdXJMWjZrdXNnb3Y0dmF1?=
 =?utf-8?B?d0o0b2R3TkRHYXNkY0N1aFRaMUlkaENENExaL3pMQzY1bXNyNEcxRVg4YWxR?=
 =?utf-8?B?TVNYMjRtNVQvY0Q0WjhldHF4aFhGNHhYV0ZZLzd5UHdsVHZPa0phb09uMnNK?=
 =?utf-8?B?Zk1IcEhLOEFneG43ZHVEbENsZVE2NGYvN1R1WHNQTTNsUHo5TzRrM2pCcmFW?=
 =?utf-8?B?dGtIcm1SWTdZTm1MN25OZ2JmR0ZsOEVDa3hyam40Ry9GRVVUNWI1RTZsQTBU?=
 =?utf-8?B?VkU2RnpDYzZPRCtMK2h3UzdQdmFvM2JNMm1GemFFRkE0STdwaFJRYUpFV01v?=
 =?utf-8?Q?TWkvJAcLoSA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RVVGaE5iKzFka3FTb1hnNDZMZkU3b1h6Z2dxcGluRk5xT01XVWRMTm42RWhF?=
 =?utf-8?B?T1dtQXpYMXVLN21qWXRyNDRkYnVIN2RNRzJkZ0FGRFRHT1N5cXFGRnN6ZEM0?=
 =?utf-8?B?V2RyYlFPVzNoSiswYzdleUNJUE9oVUMzUWNiUTlWKzY0TWJ1cWZNc1JRR3k3?=
 =?utf-8?B?SFRRU3NMS1F1ZllWTS9NSkthZk16NEtFcnpNNmswamJ4ZS85eERRRUxkenlu?=
 =?utf-8?B?bzRobWtZMGdrVmd3RnBLeXVMTys3Qld5dWQ4MTd5OGRsZmVidWQvZWJYSjds?=
 =?utf-8?B?QVkzOTVrZjl6OHlFSnU3RDVaNFZQanRIY2JzVytzL3BlWHltTzJTNXFZWVVq?=
 =?utf-8?B?V2VBT3NPcGlLVHhDQ2h3aXFXdmxmTWt3b1M0ZlRrMGNtU2M1U0dIY2daUFVx?=
 =?utf-8?B?QWxvQ3dYclVqajlOTEFJSC9XTnhvVlR2ZngwdmFIbGF1U3ZRNHFqTG1LbEND?=
 =?utf-8?B?ZFpyamd2RUxrMDlKdGMzalRGcDR0emJ1cDdNdC9sOW5qMnAxSkZXc24wOFE3?=
 =?utf-8?B?U09ZVU0vNEFPK1Z5dFU4ellEMEhBOW9sTyt0ZlJQT0U5Q0hLMEdOeTQxODlF?=
 =?utf-8?B?WnFEMFJENWczZnNuT3dVQ1BtN0pMUlJmYVUvd3FHQUR5eCtyT05tVHEybXhU?=
 =?utf-8?B?ODE1aldUQkY3UzUzTHViTDJIRWcwUm4rWFh5cmVsTkt2MUVLR3puUDRUR1JF?=
 =?utf-8?B?VDArajRXRFNOQXcvS09MVmlScmhLVUxWUEdySXkzNHdSVDV3U3FOVHRNZHdx?=
 =?utf-8?B?Smw3M1VwTDlJVndHbkVxMzYySGtKSmFxV3FVakNxZXhDRG9aVGt5Wkp3UXZH?=
 =?utf-8?B?ci9CRTdEUXpOMGtzakh4bENiejcvRENVQ3JmUk5sZjN4TFdCelNzTmptcjFL?=
 =?utf-8?B?R1pWWUZmWHEzWThSMHJRSUt3NXduTjZXUXRVYnplYkQ2MkRFN1RGVkZ0WHRP?=
 =?utf-8?B?SEtpWlJzV0dBNjg0VDJxTXdwcy9YNlROeUdLVnkrNEdVaW1KZHpyY0NxejZV?=
 =?utf-8?B?ZHhvbGh2UWc4K0NGbDY5bHp4dllzazRRd2tXMVBOd01mR1BlbFBBTGxEajRi?=
 =?utf-8?B?YVo0SUxkcUIveE1jazA5U21DcUFDSjJzZ2x2bktlVnloeHZGS28zQUQ2RmdQ?=
 =?utf-8?B?S0EyUXhmNTNkSmtlbnEva2x2SzRzVmpkTEdHTVV2ZUZPQ3cvTkJ5cUprTVFU?=
 =?utf-8?B?ZlZxaHpEalB2QXgya05lUFlaZEt5ZUVwck4wRmRqT2NiNW9hSmkwdk9Kb2VT?=
 =?utf-8?B?SHZ0N0NyTHMzbDNoUkdGaTQyZGhyNW1xTzFiZlNmRklrRVd0b3lCempjQWJR?=
 =?utf-8?B?NFFvRUIrYnlabUMwYUNZRS91YmptQTRxMUV3bWFkTkE5aVIxNnRkdk9nS3ox?=
 =?utf-8?B?TFNlWTVsSklOdmdSQTJYQ09QcmRIZk9oQ3lHV0dvcDhqVkdUUUJUNVVxdVgw?=
 =?utf-8?B?R2ZsUnNGWCtEaG9oQitndzJCeFJ4WjcxOE05YXJJQ1dyZVkvbFFuNG1iRk0w?=
 =?utf-8?B?b2JIUllFakFUL2lSWHUzZS9qVzRmMHhyUkVEbUpPNllFdjl1blJRMCtCT0gy?=
 =?utf-8?B?U1UvcU5FSm1vZmduNEZHMWFaRGtycmZWTFVscW9yWFZwbS9PRUhuRFRXRFdY?=
 =?utf-8?B?Snh5eEtXTWJ4NnlPRTU4VCt5NkpKdTdqdnV6TTBtNHpGMnNNeE9Yd3BKZVkr?=
 =?utf-8?B?UXFQcDV6eFg4TVZyY1VZSnZITUNmUjJIK0wzUkJZTHcrNkdoeDlOUnZ1Z2lw?=
 =?utf-8?B?bGdWUDhuaHhOVmtzdmcvN29FYzFJZElWbmtGMUtaOURBU2M2c0dyTGxlYnFE?=
 =?utf-8?B?dGhkdTZZb2o1TEpzZTA2NEFqcHRYcmo1VjhncFA5VnZUUm9EZnVQS1lXUXRr?=
 =?utf-8?B?NHRpL0RDcTlXYjliWUM2VTY1VHZqUHhBYUtQYURSL1B6bHI5QVYvb2k1c3JC?=
 =?utf-8?B?OW5rS0xpa2lxbkRNNmJyc1NDT0dsRDFRRWxKbnVPd1BiMmo1STNpbmR3QStB?=
 =?utf-8?B?WDJxNEJqdUhLUWJaZG9hK0VBV3dETTJLWk12STJOM2NOSkg3Sm9YUEluYmpC?=
 =?utf-8?B?bzE2Nk95MmErSVl2N0p2ZW5QVFdRSmJsbW1uVVpZeC8vbzlqYVhWQ1puZkxt?=
 =?utf-8?Q?zomB2RGsFYDTn8pAWMXLwNKur?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 73d83674-8f16-4fc6-97a1-08ddaa8e0878
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 15:21:56.1969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SYov4/mpb/xpVxAx4YbiZ9NznpKTc3Zf05Erboz9fXlI25XBOQ3rlNfJHKN8p3noi9gjx+yt7BsBoX6SaOTS6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8532
X-OriginatorOrg: intel.com

On 6/13/2025 12:06 AM, Peter Zijlstra wrote:

> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> 

Thank you!

