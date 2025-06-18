Return-Path: <kvm+bounces-49826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B2779ADE5AB
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 10:35:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B0659188D468
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 08:35:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E608C28032A;
	Wed, 18 Jun 2025 08:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c0LPwnNw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3794227FB02;
	Wed, 18 Jun 2025 08:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750235619; cv=fail; b=og4bXDImafKPGNXg/rM6wgTGTJWegXyC0xfHD6tAO9JDnbs/MxXQZq6S4ErDTcnbCUSxXUAGD1xByFhzr5bF1z7POgSrMkihVxlsP9eIGQsXGfQWaj7FA/vggXVRcZu2niioIu1phTtw3+KomNN1Fanoms8GZ0BhJoA20DSt4ag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750235619; c=relaxed/simple;
	bh=x6bA8D8yf3PqJ3Hvf4dJlZvwQ1Z7x0rGtA/MPXQZ3+g=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XXKKXD6ERI3HoedJymxNOFNcJWEsSKLwDsxdhKcLZs8xfdgH5R0j1UepBLr+WFC3EwxJPXLk3OGuz1nnshCEjtMxfEYDmkLr0aTp5+0DxNcr932Oy3Swv6TiWP7OJTlq1sgYvoJZDzohDfwAvE1qh6BpRfS2YD9f/WaLztx5qL8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c0LPwnNw; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750235618; x=1781771618;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=x6bA8D8yf3PqJ3Hvf4dJlZvwQ1Z7x0rGtA/MPXQZ3+g=;
  b=c0LPwnNwXM88NafiJVuXYxDGoLBRiA9Vooc95LNSAXY4d7EX9n7SA/cq
   uF6qg120bOQ/FCpVWTf2gxQVIm6D0i7idMOEea4qpAs1DRwYIMUO8OleH
   NEQs8S7BruSUFFmCdVkYl9XtMXg4hqgMXiFTqrtfu4Nd2BqCkycRB0urF
   kw8elNaIYQTgqmWLUQeO7NPF3VGWxulxPSbEl+v4Zf2XDDUkj7P6rvD7q
   RE97sLI8507vt/xFJ+YHxrbE43Ac1OMl7kfSQ8IlEPBI2ATQBOEN2ZUfZ
   6CicPLxtfmfh8pn99ptP9F1FbTUcZztvfTw/q3YhnoK9wFG+EnQK1uenD
   g==;
X-CSE-ConnectionGUID: lmhXB1qwQ0uXZSdXyIyYyQ==
X-CSE-MsgGUID: eh2OURFqQPmb/dlF4ersow==
X-IronPort-AV: E=McAfee;i="6800,10657,11467"; a="74975580"
X-IronPort-AV: E=Sophos;i="6.16,245,1744095600"; 
   d="scan'208";a="74975580"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 01:33:34 -0700
X-CSE-ConnectionGUID: X2/6wE0WSzWAAADrMrSong==
X-CSE-MsgGUID: 10WbQn20Rf+1pu967AVTog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,245,1744095600"; 
   d="scan'208";a="154987497"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 01:33:34 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 01:33:33 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 18 Jun 2025 01:33:33 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.52)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 01:33:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ne7/Fff/rvogJtaF/ZSJGU2OH6C7c7CraErMkrZaxaO7UK4ugn+8QLmzY6HwdMXgkc3roa8niKNB69h2F6e7n7dnwP+mD7Nu88YAoTyvhy+YLave8OafQInSNh7ZXYSBiHW3RYOU5qoWkJQregBaVVr/Ba7WROtTcqa9aYRwl9SZOl4Q7qbnAPrnu4+VdQDzeIHHdfWGPArg9qWmWMlz/LZO+fwvQK88llmmPUrUtVcCiBGZu3KIefm9PTeX56GSLn95KpptgvpCeg+H7nIdeEOFsLl64eBZzVD89N/FZtbLPb+FCUDJ0ltm5dTWM5j3YFjGn0fSmpCJX8AL0IFINA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EyjrjRawnK/Gra5jJm+NLZ1/LMAzizQSmyoGo7VY1rY=;
 b=gtCs7IX4zmnGYWrofGlRspyaglvNMMeKZ6gaFBbUpkXatXffciKoI2IbYzkjAuu1d/y/knudLcNejedclNxa/WplHyzydaGx5FZCT0Eg93e6ZmpLUDeVC4yCulRtvy8to/v44cTvlA35BCziDNwo70XEHWAr2+rmkEyPDSaIk8mBNiuJqr1As4aI6/zyW1aok8L3kmpbHCzJQueZSN5hIf0O4nOzUOelJn+N43HaNWVBJoDXHZEfJBaztE3CKpDwy/VvR99SS/60xXOsHT9y4H0cMyRH2KPxbJ6UcctZDc2qoCpCn2pTEocgmuqBecLxbdE6b1DhbAJElw49GHXNtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3206.namprd11.prod.outlook.com (2603:10b6:a03:78::27)
 by IA3PR11MB9374.namprd11.prod.outlook.com (2603:10b6:208:581::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Wed, 18 Jun
 2025 08:33:16 +0000
Received: from BYAPR11MB3206.namprd11.prod.outlook.com
 ([fe80::4001:1e6c:6f8d:469d]) by BYAPR11MB3206.namprd11.prod.outlook.com
 ([fe80::4001:1e6c:6f8d:469d%4]) with mapi id 15.20.8835.027; Wed, 18 Jun 2025
 08:33:15 +0000
Message-ID: <0df27aaf-51be-4003-b8a7-8e623075709e@intel.com>
Date: Wed, 18 Jun 2025 11:33:08 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
To: Vishal Annapurve <vannapurve@google.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kirill.shutemov@linux.intel.com>,
	<kai.huang@intel.com>, <reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<isaku.yamahata@intel.com>, <linux-kernel@vger.kernel.org>,
	<yan.y.zhao@intel.com>, <chao.gao@intel.com>
References: <20250611095158.19398-1-adrian.hunter@intel.com>
 <20250611095158.19398-2-adrian.hunter@intel.com>
 <CAGtprH_cpbPLvW2rSc2o7BsYWYZKNR6QAEsA4X-X77=2A7s=yg@mail.gmail.com>
 <e86aa631-bedd-44b4-b95a-9e941d14b059@intel.com>
 <CAGtprH_PwNkZUUx5+SoZcCmXAqcgfFkzprfNRH8HY3wcOm+1eg@mail.gmail.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <CAGtprH_PwNkZUUx5+SoZcCmXAqcgfFkzprfNRH8HY3wcOm+1eg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DUZPR01CA0010.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c3::12) To BYAPR11MB3206.namprd11.prod.outlook.com
 (2603:10b6:a03:78::27)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3206:EE_|IA3PR11MB9374:EE_
X-MS-Office365-Filtering-Correlation-Id: 26632613-2528-4e02-c791-08ddae42c4ea
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Wk42bjZHN3YzUDJHV3g3Uk9NQVZrTnlYRzYwOU1IYXRrcW5pYzZEY2wzTXBX?=
 =?utf-8?B?ZEY4N1pHOGZtK2pjckpFY0RoTmZrQkFvWDJqUTllOTlTTDlEYnJLK09XS21Z?=
 =?utf-8?B?em9zd3pyQVJtVGtOYkt1ZEhaNDBjajJSOVBNdHdqZFN6WGRlTkpxMi8vbmtj?=
 =?utf-8?B?ckFZNHk4T2ROdHZCRnR4dVdvcjQzbUNaU2tnOGlDaTV4b1VlNUhQdHN0cDhw?=
 =?utf-8?B?SG5tOWdibnRoTloxeU5ueWpmY05sYXFpVVBTd1RJaFZMUGpwZy9NSksrd0N4?=
 =?utf-8?B?eFZtY3NlVnI5WDFvd2V3TlV3a0VWY3N2emdldmpIOTJTWWVGdnY2YTJTL0th?=
 =?utf-8?B?MFF4a2hFVEtudWhIeUNwOXBGWWx6ZEdQbzJSZGZqcGRWalpyRVNVY0pvZUxL?=
 =?utf-8?B?QkVYUk0zUW0wNDg3OGtpQnlIbWNJK25RZ1FNT0xYV3AwNHRoRklseDk0S3N2?=
 =?utf-8?B?Y2ZSN29MNTZ3RW1QZjFPNDJFaG8yT0gzSEVNWFJVdHFFV1FqT1A2cS9UWWJH?=
 =?utf-8?B?eVpUci80M2ZBVExGcHRPVWlmT1hKRk1WUU5FNEZUUlJFRzJIVnc4OHlGcG5a?=
 =?utf-8?B?eE1ZZ2F3VTh6WjQvUnlSbDBMUUZzWU5BeTZMWUQycmFGZFNlRU5lMU9IOHEr?=
 =?utf-8?B?YWNzT2V1d1JVSi9XQkRqb1BmRjFRM3FXT25NMjgzaStkVWt4MHVCK1RTL3pi?=
 =?utf-8?B?aVZRUi84WEhzS2VlMGhESFF0MVVOUElocXRZdXdrZnhNbWdjNzJockxhclB1?=
 =?utf-8?B?NUtUNGd2bVZVUmZjYWZidDlsSng3RWFaQ1pPZ3VlR0NTNnpjcE04ZWJOS0Nh?=
 =?utf-8?B?V0FvcXRrNVphVW9FY0prUUYwM2lwZnpXdmpSN0dMTXZDOUthMGk5ZGh0N21k?=
 =?utf-8?B?eGJBS1BQUzdqS3hSMStoQS9tZ3QrVWpPOHdnU0Q4eHJDVlQ1NFhqWEhXWWVh?=
 =?utf-8?B?ODJiNlk1RGtJZXk5QUw3MjZwa2ZSOEtFTmhrLy8wa1BHRUtnMnN2NzhZZGhq?=
 =?utf-8?B?dGRCYlp6RXJScytvTkVuODk4aU5CL3RaMVRwODJOSGVPOEZOWnlJdDlDYm9I?=
 =?utf-8?B?U0tvYjJXTEVhM1Jmb1NmZjZVdGFwandGdzlMMXhnSFM4bGc4bDFWM1JTbncv?=
 =?utf-8?B?K0UzaW1EOVp6WnBMNmlEbzlhbTB0ZTk3NUZtZWhmUEdnSzliRFpBOW1JMUtC?=
 =?utf-8?B?L2J4eHNWMTB3Qkw5dDNwTlYwenpGUU1lUlhqY21JL2ZiUVZEUWlxME5XR3hI?=
 =?utf-8?B?TVcrSWdZUmZwZU1LdUFMWnJLN3Y0bnV6a09GNE85UTFJNTVCQllsRGFXMm5I?=
 =?utf-8?B?WnRqc0dQZVNuSWNvZGtQS055ODhpQmZzWUxrV3RuWklXZWlrYU5GaW85cFIr?=
 =?utf-8?B?U3F2R2cxRTRRMUJ0YjBSczY2bWVUcU93ZmZIQnNUMW12K2VJTWtoQk5iUFRL?=
 =?utf-8?B?VWNVSmxMN1ZzSWJCc3hlYkxqL0k2MkFWK1grN2tjUW5LNkVzZTVveTdvQWFh?=
 =?utf-8?B?MGU0V0FyL0N6SWZoTG1MbFBybWs3SnN5RmdxWG5jRXp2TUVLMEdVQUl1TjRT?=
 =?utf-8?B?bXhOT1BxUUdxNGgzSE5BZ0pLcGdFUnllR1dqeHNFbEFBZFNsZndDNmdGQ0RN?=
 =?utf-8?B?c1ppaEk4ZmNzU2dtUzFKUEU0dHdKdjVLcWRxNWpVVVhRUzRScVpLNytPejZa?=
 =?utf-8?B?U001bWE3Tzd6RFNzdTZabXMyTEdaVSsxeEorYTNqcndHYjBFL1JzRzJKUnFM?=
 =?utf-8?B?TVhKZXhyL0JWRlBubkN0MjBRZVl3Q3pIeFRZOEs5QkhRWFVNUnFHc3RzaURB?=
 =?utf-8?Q?psIZ6QBxH8KU0nenPpSXl5tBCvZUmiTRLcCeU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3206.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cWpHS0RxV0pTTFV5SzlsakRhNmkxRTdpVFhabUp6L0NoazUwWm5NVWhGRkxh?=
 =?utf-8?B?dFB2dXNJQWFwYkQrWFlTdVFpZVpEYkxkb2ZMTVdiOFMrc2YwblJkOTJzZ2ZT?=
 =?utf-8?B?d21jcUhrcDBXOWtob0xVNDhkNlhWd2lhb1FNRUc3VEJUZXh3NjkraHF6TDVI?=
 =?utf-8?B?b0xQZXRBelRSdGNLTFpaSEYrOFpYMkt4RnZzTHN6QXc5M3BwbStqSW80cmtR?=
 =?utf-8?B?d0hEQ2w0YnpkOFBUbktXd2ljZkpwWE1pLzhicmRrbHY1aHNJN2pGWVdJekFQ?=
 =?utf-8?B?SURMd1V4ODh6R1dqWVNHUXB1WDYxL3NzYUFMZXU5NlRiRGVZMURHZnc4ckJI?=
 =?utf-8?B?L053OFB2MWswODhDdCt2ekJXRmplNTd0dTFlazYwVU16NWk5M3QxL0E3clhp?=
 =?utf-8?B?cUJ4cEcwZTVqYzJKSHcxUzBMdFhlN1dkVS9FL251ZEFkR3pYMU1NeU9YZVM2?=
 =?utf-8?B?cXNGckJQUFp6d3dCeGVhNkFjNDEvQ3puMzBiTEJUb0lnYzhCQ2FSaE9VekJi?=
 =?utf-8?B?eDFBVjdiOHRINldVOE95SnpyY253a1RGUjFBdkl6QW1mVnhUd21XNzk5MjIw?=
 =?utf-8?B?RXpYZXpWZHdaUzVxc09CLzVuMU1yQ2VMMTBtQTJsQTh6bUM1SWh2dHUvMVhG?=
 =?utf-8?B?SUk2ZDJCcG9WNjV2L3pXb3doZG03NFZaMFNVMGVNdkcvd1J5QmZkTTZBa1R3?=
 =?utf-8?B?ZHNLdCtWUXVBajN6K0Yza1pmeTNSajVUTnlOaWJYM0M1ZWRiOGZtUitGQWNt?=
 =?utf-8?B?ODBHZmsza2NIOWRQRUhCWjhXb2Z0L01pUTZ0QjUvMzZBV0krT1FRODU0MFdI?=
 =?utf-8?B?WFFEVGU5VWl3cVlFY2FPaXpoaTF2YmpBU00zUlZwTUIxUVZKblJtNk5ybXFv?=
 =?utf-8?B?elJkK3U5bU8vU2M0VEdzLzc3N1hRTEVCcVRJUXRLOXkxZzQ0T1ZDWStnK0RQ?=
 =?utf-8?B?d1BONmxEb0p2NlI3S0d0MW02TUszM0kvZkVKR1lONXgyQTYzUXhXR0lUNTFL?=
 =?utf-8?B?RVMzcWcvNWJ5eWthNXJSUjN3TS93bGtUODhKaVc5MzhGZDZEcFJML1VSRjRP?=
 =?utf-8?B?dyt4TEw4NXZJeTJxcHdyOU0vazNDMzRsQnRiNmVrZXdNbi96bGNHV3lmK3Uz?=
 =?utf-8?B?bmQveGJtdVNFZno5dnJGS0prQlhiazlTei9wS0RMblk5MkpUM0RlUWhxVSt3?=
 =?utf-8?B?T1h0L1I1QTgwMlExZWpPQnV2YzJ4VVAxU0Z4MkwyMEZaVkVISUFJY1FyR09F?=
 =?utf-8?B?d1ZtdzZPYnlMV2NEdm0vTWdsZWpWRzFQODhoUERHbm83UjlNNVVjQXEycVNh?=
 =?utf-8?B?WGl1ditBb3AxM3RrSlFaT2Rpd2dwL2ZxclJtVnpEZUZzRVRuTlpVNmg4cXVl?=
 =?utf-8?B?RUI3amZXMHVhY3BNQ2ZPNUZDb1JsSWk5RVJTVENjelJJOFJQQVJ0YSszUXpX?=
 =?utf-8?B?Q1RsY1ArSUVTTXp4blhMb1JIT3hSOUEwdVl0eWh3aDA5ZVlqRExOSCtFN1F5?=
 =?utf-8?B?TGRJVzU2eTJNOG51c3lJQjZhZ2lLUS9HVWZCQVg5WTdjZHBqdUZOeER1NGpE?=
 =?utf-8?B?MnJmL1lkMng1Rmd4b2x4ZXNRK1hrbjM2NDFUTDZyV1MyaUhUNVBwR1paOEtX?=
 =?utf-8?B?ejBJUDA3R3dtQUtsUHBrbXNGQ0pldVJKczZPdkhmS3NiS3ZLdlRSbmorWlE2?=
 =?utf-8?B?OEMwL3hhajlWUEkrTFFIQnNEUDRxWkxMeUtqYVZaUjNNMUtGaWZ5QVhqL0E4?=
 =?utf-8?B?ejhiL2Y3OGJjNUh4SFRGYld3UVMrVHB0VXNhVjFpWnNkaFljb1BFSjFlc1Yx?=
 =?utf-8?B?c3J6L1hwM0IvbHpGN0Fici95R3R6VFA5M25BUDZ3K2JzUlNKd0xyYXBERmhk?=
 =?utf-8?B?Si9wOWNDMHRUUjZNTmRvNG5DUjRacElFcG5LVWNEZzlVTGdsNGQrREJrR1lj?=
 =?utf-8?B?Z2dyODZPVHM0d2h2U2lIOUFPL1F6OFRscGkxRzdIZjJIQy9xK0kyMU9WSXNy?=
 =?utf-8?B?M1RVK1d3aVBKSHMzdUVwOFRwUEh5TmVYZ3gxOFNJK0k3clBpcEM5K2pCQ2NQ?=
 =?utf-8?B?dzVlSzN3QlpPNDdOaERSWHh2RlFrWVRhTFpBNjhTeTFjUm1JQkxCdi9xVVZN?=
 =?utf-8?B?cldxVjN1eFNxc2ZqMURrWkNmNG85ZDAxNEQ3d0VnQzNrZ29ab1pTdUkwV3J5?=
 =?utf-8?B?Z0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 26632613-2528-4e02-c791-08ddae42c4ea
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3206.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 08:33:15.5050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KgY1Adn4bwpFuJ7LFpgZR1Qn1smfXv0kXgdPYus489/1IiG44siI3NGDTWRQvQzAjwTEk6dmjr7YRTm2VdZyqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9374
X-OriginatorOrg: intel.com

On 18/06/2025 09:00, Vishal Annapurve wrote:
> On Tue, Jun 17, 2025 at 10:50 PM Adrian Hunter <adrian.hunter@intel.com> wrote:
>> ...
>>>>
>>>> Changes in V4:
>>>>
>>>>         Drop TDX_FLUSHVP_NOT_DONE change.  It will be done separately.
>>>>         Use KVM_BUG_ON() instead of WARN_ON().
>>>>         Correct kvm_trylock_all_vcpus() return value.
>>>>
>>>> Changes in V3:
>>>>
>>>>         Remove KVM_BUG_ON() from tdx_mmu_release_hkid() because it would
>>>>         trigger on the error path from __tdx_td_init()
>>>>
>>>>         Put cpus_read_lock() handling back into tdx_mmu_release_hkid()
>>>>
>>>>         Handle KVM_TDX_TERMINATE_VM in the switch statement, i.e. let
>>>>         tdx_vm_ioctl() deal with kvm->lock
>>>> ....
>>>>
>>>> +static int tdx_terminate_vm(struct kvm *kvm)
>>>> +{
>>>> +       if (kvm_trylock_all_vcpus(kvm))
>>>> +               return -EBUSY;
>>>> +
>>>> +       kvm_vm_dead(kvm);
>>>
>>> With this no more VM ioctls can be issued on this instance. How would
>>> userspace VMM clean up the memslots? Is the expectation that
>>> guest_memfd and VM fds are closed to actually reclaim the memory?
>>
>> Yes
>>
>>>
>>> Ability to clean up memslots from userspace without closing
>>> VM/guest_memfd handles is useful to keep reusing the same guest_memfds
>>> for the next boot iteration of the VM in case of reboot.
>>
>> TD lifecycle does not include reboot.  In other words, reboot is
>> done by shutting down the TD and then starting again with a new TD.
>>
>> AFAIK it is not currently possible to shut down without closing
>> guest_memfds since the guest_memfd holds a reference (users_count)
>> to struct kvm, and destruction begins when users_count hits zero.
>>
> 
> gmem link support[1] allows associating existing guest_memfds with new
> VM instances.
> 
> Breakdown of the userspace VMM flow:
> 1) Create a new VM instance before closing guest_memfd files.
> 2) Link existing guest_memfd files with the new VM instance. -> This
> creates new set of files backed by the same inode but associated with
> the new VM instance.

So what about:

2.5) Call KVM_TDX_TERMINATE_VM IOCTL

Memory reclaimed after KVM_TDX_TERMINATE_VM will be done efficiently,
so avoid causing it to be reclaimed earlier.

> 3) Close the older guest memfd handles -> results in older VM instance cleanup.
> 
> [1] https://lore.kernel.org/lkml/cover.1747368092.git.afranji@google.com/#t


