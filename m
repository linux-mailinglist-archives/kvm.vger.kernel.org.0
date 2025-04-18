Return-Path: <kvm+bounces-43686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D57BA93FD2
	for <lists+kvm@lfdr.de>; Sat, 19 Apr 2025 00:16:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A5E9A17FA0A
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 22:16:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C3BC241103;
	Fri, 18 Apr 2025 22:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MKQ/CkBz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC83204F6F
	for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 22:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745014598; cv=fail; b=oRutbaPi3aH3nkDRh/0u+cngD7wGX49pgCsNfINA4UhDd3fK+c4JrVBn+xw+1z1YoAHvvVmrZcvgQfzirzBc2DlehzFqfGhCnaTKZQuwfqiVNJ/+7LVc5bHdddLyph4ytB1hFsd/llugXyocymBAibt1sfqalgU1lpcsmmpO1wM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745014598; c=relaxed/simple;
	bh=bVwT8Q6tABlKiRwLpy46JFq+QEtw2qI6g3uVu9NWYg4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=d0Wg+DOJ2FkoGe65LqoYjWjYUhj77Ka5yiFwtOzIf0E+H0T3qEdmY+8YBYbYuBXiWijQCsWsTaO7eimKqp0ihYr8dCCqN4SxZgd0YMz6ZcmYVNEbaH4JlKlbshbmb90FWNZ04g5HZ/XnF4GeZ9MrutRWorFESrzJ/BxXdtmpKXo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MKQ/CkBz; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745014596; x=1776550596;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=bVwT8Q6tABlKiRwLpy46JFq+QEtw2qI6g3uVu9NWYg4=;
  b=MKQ/CkBzx66Zz8fNSJJixYlCRuN7Sq3ObL5YXcJbdmvp8rkyK+rWQX5q
   XPRzzVYvvWqaBBeOBCuOVdjrKNBGbH/T32AH/ydDYnggFGaefsyNT7/LY
   jqtcUGB7hPVcpa603izcg/KkltRjsUueU/X4/+VvuVeW/gmGxWwgKnl4G
   tCwjZcADpsWIaShbB1w0hvCK6qDVwiaZET9ODSbYKtYBlVBcnpGQltNLK
   KBRYyiPK1b2a7etEfIXMfXoRt+vJZT8TZZJh5PybRQMvdWupscNeUDurK
   ZoqeEB4OlMj0KzjPalpU0NN10uK3Jtx+oILeUCrWNuR8yvD7Z4XLgKpMU
   g==;
X-CSE-ConnectionGUID: 1xvEGnL/Q1qaTxp0o/fGRQ==
X-CSE-MsgGUID: l5PAousVQ0Sk8fx/v2kZvQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11407"; a="50313081"
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="50313081"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 15:16:35 -0700
X-CSE-ConnectionGUID: YdPbe52IRhWftgylVLcx4g==
X-CSE-MsgGUID: tYJvRIgeS/2nL75ie1+wKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="131231843"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 15:16:36 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 18 Apr 2025 15:16:34 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 18 Apr 2025 15:16:34 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 18 Apr 2025 15:16:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u1LBIyTPUBF4vBW2hyIWLPzK099OMR6JXNSnrMy+Kla29RG8PLlIlQ8QXGhZwsVGR7MiKbd+7jUm54ixRUUY4t88f0pTkzrzeMDs93L7JQmOOZMPqdq5lW1La/BA0dv55HxRn8WBL6oJzhLj2ECWTI3ktcSfR3Y+ff5MJlUBGYLDi/UeDZ6tTkwOmodxoLxanY7rMyClNWMA4GW7KVraUtdkcAXZ01qLnVRKtkOG5tgPe5OGrPRzYi6MQgG9VH2+rLULMgjBIH9+PBFXt5Ag6J4ZW4hG91UH2dmtm9r8nvlJnkFhVq6CMYavm5GvL7HFFK8JQSVgn4p1dop7F0zV8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bVwT8Q6tABlKiRwLpy46JFq+QEtw2qI6g3uVu9NWYg4=;
 b=secrthef9ygzSqZ/fo/Y2/2zq7Tvved8Zzl9JPRL3ERXsdAWNSYZYoKGiiLifkcJoJ31aEbHO+5IGMvRtRnd9Ok5I5aBEIMms0ZLD8rw/I/3HKa48thE/7LU7vZxysw3p0b129oec1SZB9XTOdRJSr+dDoBzPYe3qyNq4pQVvuz2a42BauXI6m8V6XLGo9NlZu3rk8gmLEuSkjmiSa7BI3NktcGHW1TS2Ert8woX+RDQyDBFRJ5vhx0ejtwdPpwR70tq6BK3wg7LMiWd0pZvcmjGyARp8o3Nyf0AL2AgM4sibriOSdkkGQDiKMTWLfk0ENOjnLEtfMb/GiKMpZ35hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB8327.namprd11.prod.outlook.com (2603:10b6:806:378::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.22; Fri, 18 Apr
 2025 22:16:32 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8655.022; Fri, 18 Apr 2025
 22:16:32 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Shutemov, Kirill" <kirill.shutemov@intel.com>, "Wu,
 Binbin" <binbin.wu@intel.com>
Subject: Re: Drop "KVM: TDX: Handle TDG.VP.VMCALL<GetTdVmCallInfo> hypercall"
Thread-Topic: Drop "KVM: TDX: Handle TDG.VP.VMCALL<GetTdVmCallInfo> hypercall"
Thread-Index: AQHbrn1r/RS1njTk+UWrxwhSHT7GDLOpbVqAgACUvoA=
Date: Fri, 18 Apr 2025 22:16:32 +0000
Message-ID: <86730ddd2e0cd8d3a901ffbb8117d897211a9cd4.camel@intel.com>
References: <da3e2f6bdc67b1b02d99a6b57ffc9df48a0f4743.camel@intel.com>
	 <5e7e8cb7-27b2-416d-9262-e585034327be@redhat.com>
In-Reply-To: <5e7e8cb7-27b2-416d-9262-e585034327be@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB8327:EE_
x-ms-office365-filtering-correlation-id: f593d71f-249e-44a7-7c4c-08dd7ec6ac98
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UlF6NlltTmdNeFo4Z21yeTgrSzltZTN2czA3SXhadWl3M1lyV3Fma1gyUS9t?=
 =?utf-8?B?NVFkaEorbW9QNUtqWm1tb2RoTkQ2YnJzbEZ0UElHQVN3SVM1d3pWb0VSMDdt?=
 =?utf-8?B?dDA1eERyZEwrUHZLQXBpM3FtWFEyNVYwRGlDRGdTWUlWMEhkVkx2cHcvLzN4?=
 =?utf-8?B?MEtDS1htbU11VEh5V3ZpOEgySEd3bUZ6TnBCVXpKUUhXeXI0cDR5QWRFaVYz?=
 =?utf-8?B?ZXhKTVFKb2xIV2I0Vml0Q0YyNnkvT0NvRUM1cTUvM0ZFbVhoOE5tNjFuN1Vr?=
 =?utf-8?B?aG05b1paejhmNk9ISkQzUVlhM3dlaUhYamdIMWI4QklLYUk5ZzYzb05SbGpH?=
 =?utf-8?B?WCs4bDI2RjhVZXk4bXcvZ0xwbWJtTVR5eXBjOElnY3BCQ3c2c0lBSFZDd1dp?=
 =?utf-8?B?TTl5dDJ0YzkremdpeUFialozSEkvNklYVG9MWi95N2kyaVNlOGhlUFJkUi9K?=
 =?utf-8?B?OXp0d2ZRK3g2Vnh4cm5XVWdWRWhjOEtkQzgrYmNValpERkZnOGM2QzJmczIv?=
 =?utf-8?B?TEdqazhzU1NrQmFhQ1VHeHBhTmJ0WDAyU01GWjVCa1F2dTg4Y0VRRncvNTI2?=
 =?utf-8?B?Q05VdTBkcWZQckFJR2RrMkg0bnZhbll0czZ0WlMvU1VWVm11U3h1cDUzOWlZ?=
 =?utf-8?B?Y01JaEZFRzR5RjVlRmhWeDZVZ0Y5cDZBODNLaGxDbWpjOUJnMk1Bcm1MUE1L?=
 =?utf-8?B?M1Z0Um1VMHl0Q3Y5NmpqNkpLMlhvTXNkYmJZaUJISytOeHpSWlFFMUhwQWR2?=
 =?utf-8?B?TnlhZlFDdHNXSVR4SFZYazFGa0hvSkc1SUc2ZUE2ZjVhTUZEcHBQSnhRU1Q2?=
 =?utf-8?B?bS8vRjd1OVFVTlBVRTlNMU52dHVCSUNtZUhDRlBRN25lbFllRkFKWmIxVHlL?=
 =?utf-8?B?SkprV1BIZHZ4L0VZY2dNLzEwNEJ0M2xhanFXdk1veTAzRk5ycDRGR3gwZGJB?=
 =?utf-8?B?eFF6VTlpMHlUcU5xSElhY3VlSTJ0ekdzbWo3WmtaQmhQQStNN0R6WmI0K0lF?=
 =?utf-8?B?TVpOLzlsM2tSOUFhS1pWdm53ZDZEa2NlZFRrQ0FmM3FUMFI0WDU4cll0cm5u?=
 =?utf-8?B?Wk4rdXloZThQKzh1dEc3a28vM25sTXhRUXd6QWFsRGx0dWNNbWRqMForbmR3?=
 =?utf-8?B?d2ROWHMxemxhRVJ1aHpqV0ZaV1U2czFSeGxJakowMEFMNlUvKzNyalBFZWJi?=
 =?utf-8?B?dVJHbE5DbDVOOXFKTTJlUUU5OUJwTndUcXM3aWV1OGcxUUE5dEpkRDB5dTVM?=
 =?utf-8?B?aGdUUGcrd2xWbllOL2dMM2hpVDRad2dpblQ3V2o4YlVFdktBMGdrMVdWQUkx?=
 =?utf-8?B?L0dqUlBNOFZKY3FKTG9lSENxREs4dGc1N3dEREFkbGpmSUI2bWJiNFlybXQy?=
 =?utf-8?B?eFMwQjZtYi83S1NGYk5acFBtb0M4Uk8rR0wzNStZV3cwVkU3ZEFjQS83Yncx?=
 =?utf-8?B?c2dDSXR4YkhrR1FkMXBqd05MUnFFcys3dldMbHI1c2ZLMEYyQTZ5MysrZnNO?=
 =?utf-8?B?Y09XUi9KVDE5cUtqbCs1RTBTdkdUZ1gyZklGbXdYakhOS093aTE1aVhCMVF2?=
 =?utf-8?B?TGdTMjZmRWVTVmJoY1MrcXJhaGdLdklOamhpLzl5Nk1DNU15bGhPTlZnVXFW?=
 =?utf-8?B?SVNTVWVkcEJKMWVRZGNtY0JlcCtuVzRQN0NhQVZoQlBXNE9aRHdEVHVXSDlY?=
 =?utf-8?B?OFFKQktJdGNXMnpBVkV2TTdKOGJLc2hNTmw2OWF4RHJ4NnN5ejU3VmNhOUQr?=
 =?utf-8?B?akkxR3hWZDdZejQzNFlxcmM2Z2JJMnM1UzgvM3B1STYzSDAxR2lQWjFqUyt1?=
 =?utf-8?B?ZkhpV2ZSM1pnYWVQd091dlFLRGprSVhVUHJzUmd0dFJWcVI0K0RUTkdtMit1?=
 =?utf-8?B?SW1VRmMyNHdrbkJLRkJlcHJ3eDNhUWNldUlHWllyOE9yZVNVajZSbVpjcEpl?=
 =?utf-8?B?QTFMVDJac3gyOUxFeU9vT0VXLzJXVjlVMmRZa0dXdHpraWRJRmhaN3JWM0d6?=
 =?utf-8?Q?ovjf9Vab03kMRIVXkMQzHVAgZM5+fs=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VE9mY3Z6dURqaVpWSmVlYklWdkEvamxvNFYwRFY0OEszOHVFdHh1OHZwZ21p?=
 =?utf-8?B?d1VWbkVlY1hjaWoydzl1WW02azNJTDlwdXNzTkVEa2RYMEtoNnQ3cU1aWnFJ?=
 =?utf-8?B?NmNaNkdmaWQ1bVFtY0RQamExWjJlcnVySjQ5b2U3c0tKQVp6UlEwZ0xLZG5i?=
 =?utf-8?B?RUprS2l2V25DS1BhRVdSdEpHUWY3RytxZTlsOWdUUTk1K2RmUXVmRTBXN1NZ?=
 =?utf-8?B?aThjSjY4L2UzbEFZbW9qTThIam83dUh1THZjNXNyOWlPVG1XUmhWbERhWWl3?=
 =?utf-8?B?Nk95RStucmxob09jVjhyem9QcEVsOUtvejVzRy9BWVd2aTd6TWoxZDZscEtq?=
 =?utf-8?B?ckcvT2lJWE9QRnZHa1BSSUF5ZDdpRzh0MU5BSVdHdGpXN1RZL0JZMXVQYW1F?=
 =?utf-8?B?SldkSzBRQ1Qwd1pyenUrSUFUYlFTQ0tPN0MxVTVITFk0cHJialBLZytrVmxO?=
 =?utf-8?B?UW9OWDZlKzN3TkJJSGFwWjNhU3c2QWpkVytjeW12R0NWem1nNVRWYUdVK1lI?=
 =?utf-8?B?MGU0SmRFUGs0Y2NSY00rVmVsWldjcG5aM1p4Z2svdHdFU0s2ZEdEUXRsVndx?=
 =?utf-8?B?UjJKZTlHMGhZYW9FL2dvQnBleFhUYUt4aFA2SXY0cjJRb0pTdFRLbXBBYzVp?=
 =?utf-8?B?Z1paeDNvNmc0ZVpMT3dsS0s4ekZZcE9UR3RUNXVYRWM2Vk5jSFdtSXF0cjN0?=
 =?utf-8?B?cHhSeFRZR1ZBOGhqRHpZbTg5OG0xdnlLbDlEZXV5R3J0dFhkbVFqeW8rb2Yx?=
 =?utf-8?B?bUsxV2U3K29GWFZWZGZwaWZYLzZ1WmVWNk1JclBiVFZNNWtWdVo3Q1NXb2lm?=
 =?utf-8?B?T3duTDRWa2VKSGRDUlkrcXR6cUkxdTgxbUdhdTl4QVNMUFdOeEpyb3pFc2hn?=
 =?utf-8?B?Q3JuTWFhajRzeU9pUkZ4VGR4cnZhQXhBUXEvR3lLMUxGbWMzS1NXaW5pUDhK?=
 =?utf-8?B?SDl2ZlIrMHVVUGNkdnZCcitENnhyRzFIZkI5RVYxOUlVbnhXb2JOY2N1UDU0?=
 =?utf-8?B?c3MrRTg2MDFkd2pWMVlmWjBSakdrV0JRcEtzUFhCNVVtajZvOHNkSHZWdURK?=
 =?utf-8?B?NmVZYWhaMEVqeWRDelIyaEhoeUxkRHN3MkxxZ1lhUHhEQnBPSElaSWN1LytM?=
 =?utf-8?B?SUZyU2R5b2J0YVJzK2gzdTVkeHB4UWNHendaWUMrNHF6amNxOCtEVmZMNkor?=
 =?utf-8?B?M2FNV3JXWUFvVE41cllSdmpFQm8zVXdXNHB6SXlOSlhkOGZONE1VS01EMzVt?=
 =?utf-8?B?cFQrNlQrM3dtc2VxUzIrZkI1MFdLUThiTnVUaTg5TDltbDJYaUxML0Q4blFm?=
 =?utf-8?B?LzRZeTNXVWNhMWY5ck1sVGZZQWZ1VEczMUpwMlFsRjJQN0pERjRXQkhEWVBR?=
 =?utf-8?B?MlFWWVp4cU51Yk52cnBQbzk4ZUo5RUMvR01OS1J4N1E3Mk9LODYxYXhCQUxV?=
 =?utf-8?B?ajZJSVRnOGdNY2ZSRXZzdlR2REU2MCtMZU9MRmtQNjk2Y0dMU2tXOXBzRi94?=
 =?utf-8?B?KzNLb2IyWGUvWHlBYTRsU0xVSU9nNTBxbTRhbTBQSkx2OFpjdVc5cWNlMnVY?=
 =?utf-8?B?VUdmcWR6U1RjU29TYmE0Z09aM3ZvNGRJVUJFSFlmSlJYRXRqNEtkZXpIdGwx?=
 =?utf-8?B?Sjg4L0RYZWdNVGVlU29YU3A3SGxQMHpBZkZBaGFLUVhLSzIvdDYwM1RNbW9Q?=
 =?utf-8?B?M3RZMCtaL2xsaDNRdFgrVFF0ZWFpb1RWa2FRaUVTUUJsZDR2QUUyWHZnbWNv?=
 =?utf-8?B?dmovVEl5eitneUpzajhoNk9TMjJDb25ZYTNuK05mZ3hoSlExeWxNWmFkaEpU?=
 =?utf-8?B?NWZ4UzZHRVR6bm1aTEVtc2pkY2dMSzlPbE5CVVhBWXlUejI4RXQ1K2FCZDlS?=
 =?utf-8?B?ZjUva1dxUkFYMVF4c1VzRzNuNjhoR0hBRDVVSUU1SGxCWUpqZnV4TnNoKzFQ?=
 =?utf-8?B?RWd3d2gxQUoyNHd1enNDVEE0UjVKK1h1djg5R1BseHJNc1VyaW83clZ4NEpS?=
 =?utf-8?B?dkRHanZYUlVsblVDQ1YxdTZ6R3N1QUQwOTd0ZjdVMUFZdFBBdVFBZXdRZits?=
 =?utf-8?B?by9nTy9ZcSt3YWo1OE5BRGRTQ0pNRUNRQTN6WHBNTFd0cHQ3SmdINlFEUTlQ?=
 =?utf-8?B?MWM2U2J1eGRuV2F2cFhob2taMUFIbzEyWkd5ZXRNb3llQm1KZ3ZIbi9HR2RU?=
 =?utf-8?Q?DdlxTPXKmzf/cF/iSl4h9NE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5C85A06B8F377A4897B01D3EE00FD73F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f593d71f-249e-44a7-7c4c-08dd7ec6ac98
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2025 22:16:32.0738
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vc2h6fvD78Tz42GVNyNO/h76epT8E6QCExVxbUaXLftABM4OHUgp06CkRrtxgEXzgylo/cmC0QKpezW7VIVdWWVZRKZJBGZDNPJvYTGfYwU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8327
X-OriginatorOrg: intel.com

K0tpcmlsbA0KDQpDb250ZXh0Og0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtL2RhM2UyZjZi
ZGM2N2IxYjAyZDk5YTZiNTdmZmM5ZGY0OGEwZjQ3NDMuY2FtZWxAaW50ZWwuY29tLw0KDQpPbiBG
cmksIDIwMjUtMDQtMTggYXQgMTU6MjQgKzAyMDAsIFBhb2xvIEJvbnppbmkgd3JvdGU6DQo+IEl0
IGRvZXMsIGJ1dCBJIHRoaW5rIHdlIHNob3VsZCBqdXN0IGltcGxlbWVudCB0aGUgcmVtYWluaW5n
IFREVk1DQUxMcyANCj4gYmVmb3JlIDYuMTYgaXMgb3V0LCB3aGljaCBpcyBpbiBhIHdoaWxlLsKg
IEFsbCB0aGF0IGlzIGxlZnQgaXMgcmVhbGx5IHRoZSANCj4gdXNlcnNwYWNlIFREVk1DQUxMcyBH
ZXRRdW90ZSwgUmVwb3J0RmF0YWxFcnJvciBhbmQgDQo+IFNldHVwRXZlbnROb3RpZnlJbnRlcnJ1
cHQuDQo+IA0KPiBGb3IgSW5zdHJ1Y3Rpb24uUENPTkZJRyBhbmQgZm9yIFZFLlJlcXVlc3RNTUlP
IGEgZHVtbXkgaW1wbGVtZW50YXRpb24gaXMgDQo+IHZhbGlkIGFuZCByZXR1cm5pbmcgc3VjY2Vz
cyBpcyBwcm9iYWJseSBldmVuIGJldHRlciB0aGFuIGludmFsaWQtb3BlcmFuZC4NCg0KWW91IG1p
Z2h0IGJlIGxvb2tpbmcgYXQgdGhlIDEuMCBzcGVjLiBUaGUgMS41IHNwZWMgaGFzIHRoZSBzYW1l
IEdldFRkVm1DYWxsSW5mbw0Kc3VjY2VzcyBjcml0ZXJpYSBvZiBzdXBwb3J0aW5nIGFsbCBjYWxs
cywgYnV0IGFkZHMgYSBjb3VwbGUgbW9yZS4gSGVyZSBhcmUgdGhlDQptaXNzaW5nIGNhbGxzIGxp
c3RlZCBpbiB0aGUgMS41IHNwZWMuDQoNClRERy5WUC5WTUNBTEw8R0VUUVVPVEU+IC0gSGF2ZSBw
YXRjaGVzLCBidXQgbWlzc2luZw0KVERHLlZQLlZNQ0FMTDxTRVRVUEVWRU5UTk9USUZZSU5URVJS
VVBUPiAtIEhhdmUgcGF0Y2hlcywgYnV0IG1pc3NpbmcNClRERy5WUC5WTUNBTEw8SU5TVFJVQ1RJ
T04uV0JJTlZEPiAtIE1pc3NpbmcNClRERy5WUC5WTUNBTEw8SU5TVFJVQ1RJT04uUENPTkZJRz4g
LSBNaXNzaW5nDQpUREcuVlAuVk1DQUxMPFNlcnZpY2UuUXVlcnk+IC0gTWlzc2luZw0KVERHLlZQ
LlZNQ0FMTDxTZXJ2aWNlLk1pZ1REPiAtIE1pc3NpbmcNCg0KVGhlIEdIQ0kgYWxzbyBoYXMgdGhl
IGZvbGxvd2luZyBkaXNjbGFpbWVyOg0KIlRoaXMgZG9jdW1lbnQgaXMgYSB3b3JrIGluIHByb2dy
ZXNzIGFuZCBpcyBzdWJqZWN0IHRvIGNoYW5nZSBiYXNlZCBvbiBjdXN0b21lcg0KZmVlZGJhY2sg
YW5kIGludGVybmFsIGFuYWx5c2lzLiINCg0KU28gSSdtIG5vdCBzdXJlIGlmIGZvbGxvd2luZyB0
aGUgR2V0VGRWbUNhbGxJbmZvIHNwZWMgdG8gdGhlIGxldHRlciBpcyB3b3J0aCB0aGUNCmNvc3Qg
b2YgdG9vIG11Y2ggZGVhZCBjb2RlLCBjb21wYXJlZCB0byBhc2tpbmcgdGhlbSB0byB1cGRhdGUg
aXQuIEhvdyB3ZXJlIHlvdQ0KbG9va2luZyBhdCBpdD8gSW4gYW55IGNhc2Ugd2UgY2FuIHByZXAg
c29tZSBtaW5pbWFsIGltcGxlbWVudGF0aW9ucyBhbmQgc2VlIGhvdw0KaXQgbG9va3MuDQoNClhp
YW95YW8gd2FzIHRvc3NpbmcgYXJvdW5kIHRoZSBpZGVhIG9mIGFkZGluZyBhIGRlZGljYXRlZCAi
bm90IGltcGxlbWVudGVkIg0KcmV0dXJuIGNvZGUgdG9vLiBJdCBjb3VsZCBtYWtlIGl0IHNpbXBs
ZXIgdG8gZXZvbHZlIHRoZSBHSENJIHNwZWMgdnMgdGhlIGFsbCBvcg0Kbm90aGluZyBhcHByb2Fj
aC4gVG8gbWUsIHRoZSBtYWluIGZpbmRpbmcgaGVyZSBpcyB0aGF0IHdlIG5lZWQgdG8gaGF2ZSBt
b3JlDQpjbGFyaXR5IG9uIGhvdyB0aGUgR0hDSSB3aWxsIGV2b2x2ZSBnb2luZyBmb3J3YXJkLg0K

