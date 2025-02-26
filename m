Return-Path: <kvm+bounces-39214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A085A452DB
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 03:11:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D4C3017AEB5
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 02:09:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68E06213229;
	Wed, 26 Feb 2025 02:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LZlOzHcl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C45D19ADA2;
	Wed, 26 Feb 2025 02:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740535768; cv=fail; b=kzlBRDMjwJGKCIZthx09PH9MHvoz5IyLVgF5TQY6MqIwV9b80wgVVP6oOd7TB1RPXSlQIve8EqwtV5b5X8H5xXrklRQx1C4LsrGTzk0P4JBStuP6WBsWLpYoxVi/utd3fd/Cwy89HXFTYme0G21Z6rhKypeSIk3gilTLO2+79Dw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740535768; c=relaxed/simple;
	bh=V1VLTGNOdwVwBKL3CftdmlQkb8Iwamb1SSjyESkQqgU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=thzpuWAQvgwgGP+fyVTY59Af0GiwWE2lYHhx3tKpLqa2gBY46pLapl6yWv7ZIu3XrnKaBO7cs1jyquDZR7E/kEj2gUXjPfN9D4qrbLS4zEXqBH9UNzgdq/nWkYy0v3v0Ivf6sutVgO1Nefv1AgUhNPNZoUs7XjjCQr0nCUdl+Dk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LZlOzHcl; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740535767; x=1772071767;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=V1VLTGNOdwVwBKL3CftdmlQkb8Iwamb1SSjyESkQqgU=;
  b=LZlOzHclAwvLGx8sOrUxCGDDvtoSiKMKMzbwu3kac6SRp91kqjixMpgV
   jN667MTUVDh6SA/VwV0tTStHG77wn+x+fekAVU/E9o5SIVdZzfGzXzVQr
   SO7ObyelIRiuHq6PQpaKOWJcejWiDDTdZXR7NYsVgL2avn17pZhq/NY9T
   vfXKq1zIrNnxnrv2+MKbVHKU+v0GDN9RltBy0lBapmYR0ptvSLiL0gvLh
   6eFNpxUnkioIE1x010JAj1/QEegyX86CGgDOE7st4qvO9IxxFGcNNUNap
   kCkGwSum7njRgbVgtL3C43hJzZ2W2OGjxoBVMeja8QWA/KpCtuX1q9yks
   A==;
X-CSE-ConnectionGUID: wTW+s1Y9S6u7/7tBRAs2zg==
X-CSE-MsgGUID: Nwi14xcgS8WiTraPc/P+Xw==
X-IronPort-AV: E=McAfee;i="6700,10204,11356"; a="41504722"
X-IronPort-AV: E=Sophos;i="6.13,316,1732608000"; 
   d="scan'208";a="41504722"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 18:09:27 -0800
X-CSE-ConnectionGUID: VVIt46n/T4COhsJxsZIkiw==
X-CSE-MsgGUID: 2yhw1+3ERESGVzgRdBKBFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="147478007"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Feb 2025 18:09:26 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 25 Feb 2025 18:09:25 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 25 Feb 2025 18:09:25 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 25 Feb 2025 18:09:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=arxs3P7xdW3wtyga5K7q5wepCLREwChy4+FOCmjOHeTM9bk3FdSYGnFQWlalZyA5IO46ywScGd09KpFnm0ukyrsPxaYtYYJ5M6JXn6TtaTwHQ9optCPRtUZGIKjhO8pSeOTRNBq8pmbtMDH5LQEyeFvJ/+TLlg6I2h6XfB0m+UD8lUxKss1b+SaWhlMAt95CNwuQN1w4t/Xut4SUvcFNGzB9fRoxGnw6YDphSgQyvSgyjVSOZ8Ab26x2q/G0QLwB4pURe1xa00dIVgwypsCkMpxo71pSYxXKK/Dm7dSODs8cWxNMN6yyPCyE0Lc+P6ccA7kQxxa1xJvQii3+OxK0jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f6w8hqlP7DakTKcD1uo3n+nGLXdhhWgtkZAbtOND/aw=;
 b=IZ43KBqnH4jkOruaPJTM6WfcW2oZBm++h4IXR3XVSKBKqZqHqRKeXgsO2JsY/XCYNLqVEWTgWV7KjMx4Tl22+M5O/8SjtbRgxIkDLMOifKpZsoWPBCJUbvqwOC7DjPJ5UgT3RZpKG5nALrEcYPJat0L9nSG83MbBPSKjyOhtrbyBtGzlSUUjqN1RAUymFgxF3tRVzhvU7xrG2bnTGSPxYaX57PL39UM3EczSW20hnroyi7N9p7uO67/eyotZ5CjKItfrnyYY8sdJLxpgnbWm1sk1dDYgfMnUTG2YnowyOU1E4PA4c3v4pXr5ehx0tVMnKVnrvv/DprKvmIl46JX2Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB5885.namprd11.prod.outlook.com (2603:10b6:510:134::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.19; Wed, 26 Feb
 2025 02:09:10 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8466.016; Wed, 26 Feb 2025
 02:09:10 +0000
Date: Wed, 26 Feb 2025 10:07:53 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: selftests: Wait mprotect_ro_done before write to RO
 in mmu_stress_test
Message-ID: <Z753eenv5NKkw2j/@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250208105318.16861-1-yan.y.zhao@intel.com>
 <23ea46d54e423b30fa71503a823c97213a864a98.camel@intel.com>
 <Z6qrEHDviKB2Hf6o@yzhao56-desk.sh.intel.com>
 <69a1443e73dc1c10a23cf0632a507c01eece9760.camel@intel.com>
 <Z750LaPTDS6z6DAK@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z750LaPTDS6z6DAK@google.com>
X-ClientProxiedBy: SGBP274CA0021.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::33)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB5885:EE_
X-MS-Office365-Filtering-Correlation-Id: c5b35eec-87a9-4b7a-4d7e-08dd560a8ec1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?2fFxrwa7mL4Ywtz2PnM24CojqfveTMoEz9aJChmPF29H0q0URD3p6nmE1Jmf?=
 =?us-ascii?Q?xZrW1VwrIEoLEGRYF0OdGkwNSHrHBAD7LxKlNcql3UJot6hJ3XjC7LPynifp?=
 =?us-ascii?Q?8mkJ8E0lbc0fWJ4RlefVcKWT8uDFkWwRos1Ne0rKBu74Oi0XbsR3/XFDCUIU?=
 =?us-ascii?Q?r2Du2ucfBe5Clzwhpe7iArEizdsD6UeHvtQDxsLkYfSSVwIOX+9+NrQmp2Vw?=
 =?us-ascii?Q?tnO7lmf6GO6oKZxOZ5GWrk7RJhCwldOiusQQMeWRqpv8ZKdLsACB0mzEeOtI?=
 =?us-ascii?Q?tU1GdlY9R6Z1TrUUDQOBmQS4YRpQMdzdylV7dnMGUudPStrZIdsqKxwvL7By?=
 =?us-ascii?Q?VvEFjudclNpdOjOgYSlK5b29PLy6TLBVuVt4SW/z7OmpBC9x9WJ/Fsx3bnX9?=
 =?us-ascii?Q?dsD43J6gSW7U7SE1Pv2FI1QKOKHoTvoZcdEh5iIB6Z4SunwMZqVani3vEj99?=
 =?us-ascii?Q?W14Rd9K2W3GqfD8pnmNtc+au2SLmgIhTyFhzljlO/4XvT48cFDk5RpHFryX+?=
 =?us-ascii?Q?JwPATaGlOy35Svc+MuUQEl7TP/Gr1W+aXeyViE4liBhA7qbGhHAivEqi0ZD1?=
 =?us-ascii?Q?EIrhFyNMeWxuC0VWJVp8mf1IJfoCNGPfv0lvGN+puvkcgl21GMxlVEnyDP3U?=
 =?us-ascii?Q?F/SRP7yyKjqrtq99p7VEUyz2B8u1tJzc00ynNDughqvc3tcr6l+dQNy8auyL?=
 =?us-ascii?Q?eg8Gg192p36/XCj7i4SZfb5rv/q0wblNWoTaDB4dooDwGLfxNb5J80zTJTx3?=
 =?us-ascii?Q?mWTGe5KBiPC/z6R1nSzaY0cT0FzQaCScbasrzH5mQZmY6xrsXyyvzofxTn0o?=
 =?us-ascii?Q?9mStXhyDFGTpkAJMiPLAzbxZhgqRTQA1zkg0SXBR/XnDINp+L4pAYY90jvAH?=
 =?us-ascii?Q?N7BEuClx0sk1x9SbpkiBsLyia92Ou+QDjc387JUcnKO+cSKhxNbGvYs5BFqK?=
 =?us-ascii?Q?ZaeU9FYjVKuTL5O/uHzlWJMGsmlJyeh7eTgs0w8A1nHHoj0WagagEcyxfpMe?=
 =?us-ascii?Q?FMogmWCO5oElb2Kf6YKOoyXEsdN9pjBE0P+w2VMfgeo/1ABsuYQdESIHl/l2?=
 =?us-ascii?Q?DcPuqsb8vgQKIReoZGmp1S/VN7ABIG+BCkNm1cwX1rOZPaYpvdW1Iv3vzaqn?=
 =?us-ascii?Q?BjdI1cPxjapYyjkIzIwlNbErIYED0dHVl4PrVeEHkJSfyDywIvNNb9y1d8g6?=
 =?us-ascii?Q?nwlsQQs4ASMf1qvjq0oy2gKr2BEfzrUzWjTnfAKn9cdAf/fh4aWpU/eqm05s?=
 =?us-ascii?Q?JfU+M3Yg+ciLHG4m3ywuS5jTq7FpLJQD60hVTCPqApMPdXBQ4W0m0KwGgabh?=
 =?us-ascii?Q?69CRIOKW50lYzH5CLQ5hqi2Ilq1STz3yGriQ69nWR2uxvujnu9/A01SAkB81?=
 =?us-ascii?Q?Uw9qicVvlvrlwTbQXFn7y0VPwA1/?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JkoK/FajejQyzvhCiSPh4qlaucG0GS0h9nO2ZxuKuNPy0+6txnHmEpaQOERH?=
 =?us-ascii?Q?dZO55iDiDAqkzzb0slEPAtssophH2yyLshMW9ISu70cLoi/E/JUbBqwZYB5C?=
 =?us-ascii?Q?seOtIp32mO4MAG1XJPzPE4R2hZ4U9RyMVoEsAulid3xe97Fvs4aferB+J8mz?=
 =?us-ascii?Q?RrkBm54qZLWCzCdsQyfY7fqgXJOS8/euXhQDDQ31fx7CSYSJCWFa0Xo8tKk8?=
 =?us-ascii?Q?kmlpRhIBEZbmqEfwOs5ZgsUcKO9lhurz+kjm3AbQqL0XoEYI2iopzTKkeM/w?=
 =?us-ascii?Q?rHjNi4YZV8fLVjyaN/pJd0bdmzN1nV4EZR6Tk8m/JodncxvCQuMX4IZfqqo/?=
 =?us-ascii?Q?wPnMMN0iiZguUfXrRljHXJzBoVuz8LT1o/SZpzsQaqV+TdfS90VIk04Cp3Uk?=
 =?us-ascii?Q?Hkc+U00zR5tHyglk8IN5QbK5x5wqz/YXoCh46QrmAYdCa6XAPy3Q6NraCh2+?=
 =?us-ascii?Q?h4mjXFJLOYWCv3VYJOFRA5Kan4mb165PR+Dpl3iyjIOJYSR2CnFgVaMQV0Hh?=
 =?us-ascii?Q?69YFQC0sPCsFjDPOLjI9VT4A/nd0tAbPxkpEv5be/Qd2At8rkPRsjaBEfGHu?=
 =?us-ascii?Q?BeDana4ASsgDgiHjNSfCq8ZXKEdidewghfa48rqztdDNlqv5o63OIVGMPu77?=
 =?us-ascii?Q?pFNi2IDuYr0E1Msg/IN4ao/HrksSZIoW9upktAkj9GRiqUT6CHGdzmgfJEKh?=
 =?us-ascii?Q?zrL0ODEoem21otp4kZG2xCiEvOMBc1iaStIJda5xbucvtqhlljFy8Wf5TYXp?=
 =?us-ascii?Q?wuHh0ZnVO+zyhr3r8txPw4d1fMJwK4G2+AzigzBPl+5TkE4kIhjrevXmOuf9?=
 =?us-ascii?Q?k1jOPNCbiw5NmaT7KSHVC0BUANvx4BLR1ReMQJ1D0xduWMhwvOTK2p/iCA9L?=
 =?us-ascii?Q?Z2wloln1jppayXPptrnXDHxHNGGUjOOS4iZ8EVPx2yOfvkB7spW3cXMPWBmD?=
 =?us-ascii?Q?WGr0XO1RPO4a4KusGjuO+fO5YIRe4Enkits33RaQybcvfMUEWVClEYWTUOlv?=
 =?us-ascii?Q?N9O2PVcM7he9bFCEhS+SBe0WsSVtuIG1HrhR5jzFz4kkBcy4odk+l8CJbzD6?=
 =?us-ascii?Q?GUv2eEQjg83DV3Mfrfi+nH5X8C0N8GQFcDjUPnW18B95mMvX6RWdGrjG4DNu?=
 =?us-ascii?Q?MnZ9XxqaGyvlL67426aB8EQWZj+y1Zdwc30pFXl1Sde2waFi/uwVTeoW6Ira?=
 =?us-ascii?Q?qRf8NoK5F/kyc2qIcGo2J0XtQmQlRGRkbuv0s3rqWGR0qAqmkAdEDdWCmfxK?=
 =?us-ascii?Q?tBy46XRN4g5o1pblbipdO8BzUjmHAQvLfFGGfWXK5PgVMZqz+m5rjyF1jJv6?=
 =?us-ascii?Q?Ze/bTdtyThl6435CUS5T/l7WU50nyVaDm0R2gvwG9IJCwFsQ3KRmxZ+VhqNS?=
 =?us-ascii?Q?26T1UWYYE/2JJ+eta8Rrbv+26tkDdolfqwjOXxFfAYwviXB+mJcWXcPtRlk9?=
 =?us-ascii?Q?4iUkdTPpxcI02UTmh229hgi7Y0+1mu4MAvnyq+jgTDJrWq5+VXrWIwx/GZow?=
 =?us-ascii?Q?/OhUGUxKV/qDexb7Rbqt5iIQ7trGEFKqZJqn1+daFG29GU6lRzi0wDWiWKq8?=
 =?us-ascii?Q?szrOeLy4z/blNLECo+aszpFNJWG7M15bFHdmmmUC?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c5b35eec-87a9-4b7a-4d7e-08dd560a8ec1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2025 02:09:10.3401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0bVpsfPdF2LgLzKtrEy0Gr47hG8QJfoFoCsQ68TdRpybzJ8Ie70GSDRRLV0oCVPlulMjaPKsPVUeLCCOq5RKhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5885
X-OriginatorOrg: intel.com

On Tue, Feb 25, 2025 at 05:53:49PM -0800, Sean Christopherson wrote:
> On Tue, Feb 11, 2025, Rick P Edgecombe wrote:
> > On Tue, 2025-02-11 at 09:42 +0800, Yan Zhao wrote:
> > > > On the fix though, doesn't this remove the coverage of writing to a
> > > > region that is in the process of being made RO? I'm thinking about
> > > > warnings, etc that may trigger intermittently based on bugs with a race
> > > > component. I don't know if we could fix the test and still leave the
> > > > write while the "mprotect(PROT_READ) is underway". It seems to be
> > > > deliberate.
> > > Write before "mprotect(PROT_READ)" has been tested in stage 0.
> > > Not sure it's deliberate to test write in the process of being made RO.
> 
> Writing while VMAs are being made RO is 100% intended.  The goal is to stress
> KVM's interactions with the mmu_notifier, and to verify KVM delivers -EFAULT to
> userspace.
> 
> Something isn't quite right in the original analysis.  We need to drill down on
> that before change anything.
> 
> FWIW, I run this test frequently on large systems and have never observed failures.
Could you try adding CONFIG_LOCK_STAT=y?

With this config, the failure rate is more than 90% in my SPR non-TDX machine,
and 20%~80% in my TDX machine.

> Maybe Rick and I should go buy lottery tickets?

