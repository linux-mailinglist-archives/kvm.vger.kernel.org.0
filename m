Return-Path: <kvm+bounces-34325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 141699FAA2E
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 07:04:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A91C1886455
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 06:04:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 924C016130C;
	Mon, 23 Dec 2024 06:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lmz/zKc3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45602F3E;
	Mon, 23 Dec 2024 06:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734933874; cv=fail; b=QETw0qiov1w+fZ1kWIvkEslERWnTxLiXe9UlmLO6wkiK5YoBpzcHMedxDxuOgPS4PdBTtCDokxcAwv8+bEAiEKyP4XfYQHXmCVnhpAjyPQ3YqqizxiUYKG3PZjn1A4O7IkGO4bTPAkGwkLHD5kR923qOT2EwucfpfBPrjpqxBg4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734933874; c=relaxed/simple;
	bh=fqpNX7IKi7Ocn5cKmFcDWShgkJk7qT51/YMhQ+iQ1LY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MFfrnx5AOv+CXR8SGd9XwNMDxybrwfENL1n8eIGrHTxPS/VL5lv95L3uLwpXnJwVHAOT5nNsCdbn+Qo2acKJgjZvvyuCkeFjWHEAFTmqFabBBGd+0/RsPXHZ7gaQI245EbYsWWPmgqze4zeWlxj3HjknDXtn7PkGbf7oO63wsRE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lmz/zKc3; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734933873; x=1766469873;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=fqpNX7IKi7Ocn5cKmFcDWShgkJk7qT51/YMhQ+iQ1LY=;
  b=Lmz/zKc3T5Z2LnDHQBZDRzQu+Fpnzr07Q7CHWV0/wvqMpmfSDDoPDD6Q
   IlbZiQ5hThyf4QACD1SVlCeHhG1e5v7v9spZHSU6loZVtZVIwkRRoJNco
   DH4MMUQ9VcCUNcxcT6dcxRVKgzSByMhn0TxAn4JH9etbtdUADAmmlNjdn
   NlTFULvfEdOtsVFBO38m96Sg6KAVCtJPKJ5zfonhMeySh4nKR8ZDDXeT8
   dojy08GLUcMHBx2G5BmZ5hA1ga65hlHVRiWMj0iz6XsuvXk8o0D6uUiWc
   X4UH+UcbWl+Np80U6WRaD/HoNsa2hRTfslG7L352JxtCMdoGnYzvHE8qd
   g==;
X-CSE-ConnectionGUID: X3g5qPLxQkak36dEwlUnQg==
X-CSE-MsgGUID: gzvf2oEEQTuoIbBT8Gue1A==
X-IronPort-AV: E=McAfee;i="6700,10204,11294"; a="39331751"
X-IronPort-AV: E=Sophos;i="6.12,256,1728975600"; 
   d="scan'208";a="39331751"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2024 22:04:32 -0800
X-CSE-ConnectionGUID: zkKV457oSiSH7B2m7o3E/Q==
X-CSE-MsgGUID: qgi9ADTSQ4SJ+ra4881pjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,256,1728975600"; 
   d="scan'208";a="103983241"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Dec 2024 22:04:32 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Sun, 22 Dec 2024 22:04:31 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Sun, 22 Dec 2024 22:04:31 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 22 Dec 2024 22:04:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x8HmA3p6FPyLCs/axjl/N4D0xyyz0Gw8BwmoRIn06Br7UMIiZ/wgjkKGqIUADi7SVREQhbH7isAG+tmtLZ+wORl4tCJtKfh2Nl4UgOG1VDnZgIzPSna6Q3US0SXN0tXFmG1D68lMxbxou1ypDCn0n2msKie8LE/E6oASBwNkkjgaLCtUV6rUZ/e39bB2zqLvD+jMMYYDpPxg22Z0C8cQyQVmNipIe8yzJd91RMNEwwCexsV+k0HD/bUD2ZbAJevN0tNTrTjuOZJ3eTJPaVuQ1EM+KtbPu4fEX3gqaZeovxmj1Y1h+hK9hLvQa8BO1+RGPnGZNeRBmgW6UbL+6M/1RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VEGe41N1DsQhamOAK9/zEQvQUdkyh0ks/knGU+u8V54=;
 b=ukdPHiPZazg3LYUebrHlt3tgmGx9APk34rAwACfm2Bze5JhYXUZaTlp6+J5bunVew0nfYe4/TetcHCSazu5i+ovdzP6OwI55OEAF8zwc6eHo2lIuDz2FrUEKBRmpeCY3G4j8eOY+i0rX0NNk8QBIUJv9RvfRpgESYrjQex+HndpwrMFZWTtOeeHr/q2EPdd9DJQfGkUZNYx2F/DClnta3NH+tVvx6Iwzj3eXGRK+GKmhe7HMpZMULYLjc27ye1kj3GZ7gGbXlkenEBOh5ZP4X0Nq7PAfrrQxFxqHoUx4uWxXKeGncrZFR2AoQUWtNm82QBQAZGFtbe3AMBzoKE6PBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB7287.namprd11.prod.outlook.com (2603:10b6:8:13f::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8272.18; Mon, 23 Dec 2024 06:04:24 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.8272.013; Mon, 23 Dec 2024
 06:04:24 +0000
Date: Mon, 23 Dec 2024 13:30:03 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <leiyang@redhat.com>,
	<rick.p.edgecombe@intel.com>
Subject: Re: [PATCH] KVM: x86/mmu: Treat TDP MMU faults as spurious if access
 is already allowed
Message-ID: <Z2j1W+xE1iwmANdY@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241218213611.3181643-1-seanjc@google.com>
 <Z2Th31I/0O/HY/Mb@yzhao56-desk.sh.intel.com>
 <Z2WTZGHmPDXHSrTA@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z2WTZGHmPDXHSrTA@google.com>
X-ClientProxiedBy: SI1PR02CA0006.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::11) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB7287:EE_
X-MS-Office365-Filtering-Correlation-Id: eaefa4d7-b857-4be0-fe62-08dd2317a6cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?7UqJxH6q25QeryIv+oB+e7WkH+Xri88RIRvsyjNzNXUzTXG+NE3MW9T6zOaY?=
 =?us-ascii?Q?jOZmjK01p4uweSWLVjGw4gI9DxezWChwQkQEQ+JbpUBQb5v4T2fR98+TKzkR?=
 =?us-ascii?Q?FXtlrhmne/csccRU9LWFm2CN5Y5pCLpVBgTvgm9EiMieT3VYNTxsdAb0Fx5g?=
 =?us-ascii?Q?0tcKAh9bNHrO9ICHWrPBBHF0vdDeDrS27pnx3i1WXPGaIf9seLH9GbrLhfXo?=
 =?us-ascii?Q?lBC0J1tLD2Lqu+U4sgINA/ikvheGg2JcEPVVlJkW9z+k2N/VK/LVFWe3BPXw?=
 =?us-ascii?Q?bpiWktnqcXqJr4h3Z9VQLnU9XUTiOTz3L1TkcmeODucqtjSRCNfz7bbYB4VR?=
 =?us-ascii?Q?3lBqAryc0+PsRneRP7PA/aomDbvx9YRc+UvR0M+BAE2jmnR62ZL2p68VGZaa?=
 =?us-ascii?Q?tWT2YCgFceu49VjV+fAJnnOAYqgZzIPBZO9iW8EWzOlnn/DYBVew5eFzJ/Le?=
 =?us-ascii?Q?ZFbBzGzgat6XlCzba+G4FKBhhwh95gZUvGdie8Bsr3kMpEARgNHp0Luv1weS?=
 =?us-ascii?Q?88HIafKmBlSTTh4ue1rL114SPpK9B+OHYgbCj2Iaq0Mgdtbggb+zXfZpkrxt?=
 =?us-ascii?Q?MrEi3tofVomU9ZOh2b8odwt6iE1S3zs5qfsI+vy1YvESF/lf+sfqI9dVr3Mp?=
 =?us-ascii?Q?y1a4njzl8u8FFybG8QE0rZ7IaW7WycpDCKFKwGz4DT1/79QFnQ0BKjEyN8hv?=
 =?us-ascii?Q?wwhEpvMNDISmrFebgVwCfCZIQQqJCFnphbWNx/zFr+7ToYF5rOO4YqWMOVC7?=
 =?us-ascii?Q?ppcyQTqAJbrM+zO+hy4gTMZncR3ovWBr/PCzEjl34WDT48BAtfi1t5gldeqS?=
 =?us-ascii?Q?hE6nAjy+ENa3a8uB6afJC0wgFpmcr8NhGtdBW0R47VjDfTU568u3Yp0nUH6t?=
 =?us-ascii?Q?4l/wyP77YDSU6WEMh05gv2Ab9mqAQ8Y486iSeuvD7ZwgBiFSXwkdUwnsjtSb?=
 =?us-ascii?Q?O4C3lymq46x7DT+Rl58BxLRQrw8WmaVoW0P9EAOA+PGNoW+IIXg1rNcAnkeo?=
 =?us-ascii?Q?eqUAYxdXOq1t1z6iQYXYnXRSxewF2TB402HO9U/yc67NqXe//EyoO57EPGfB?=
 =?us-ascii?Q?ABECooiMeBu9z4k/7JGYcSkAqPpHWWDX13DkbkJi3mRtG3CyO4LzEkpye06R?=
 =?us-ascii?Q?yQ63/eV5GyRDOsgUjH2ZVbOY7epVSlubXcOoPyskoxoJDUOOu7OTfZa9cDjr?=
 =?us-ascii?Q?Ah/X0+Y84KRWOxPyccpNbMnCiEG1xTahluM+c9g9URexVYZhTAK8J9yypdgK?=
 =?us-ascii?Q?UpWH1bIN/CAftso7xD9REfs+KOOEsoucaS2G5lwU7OihZkjZsiJXoO3eiyVD?=
 =?us-ascii?Q?8KV5mJTm5xyM1nr3lud93nHu6DhooJas+HOvXuMTG44SQs9BBVRbslqDA9Nm?=
 =?us-ascii?Q?EHd49B2tCmEGws1psnAEWvMVwfJ6?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kSYTTfA6tW20Sr20NUCEpM1sevW3x37D1B5GVw/5FVatWuWnAAQl15RTpHnj?=
 =?us-ascii?Q?NM6PwQ3DzflpppmivVLYNXZSzD+IQ3nT6OZ/Cc9m87d3Vej4LkWlcq6q2k7A?=
 =?us-ascii?Q?eRBYw4fRmwjajNpJFFmy9LjjxmB4J3efGGcNXk5wDUHbr5dkcc2m1uJH94NZ?=
 =?us-ascii?Q?vnYmKriZLP8gi1uvN4qOd3fs9TB+jB8OTNpH1LadjIie1lDzvtIg/UI4u23r?=
 =?us-ascii?Q?9QP6Rqc/34wryZVS0JjTyl4H4SfnoQOiBNCFHAB5c1DpYJN/vl940MOS6Seb?=
 =?us-ascii?Q?ztB5Ny/B+xqSjLbxPDkfDQvf3WDoe7cgpUzt4kDRfTMK6i8XJgSjvjZbRx5o?=
 =?us-ascii?Q?6HlV7VWrhCAx28l/wRwv0yXujM7Sjr3v3f9SHOVbWk3/g5U8LNCjHmkcsxEz?=
 =?us-ascii?Q?Fqec53lcJazB9/sNZTj4vb7rXn5JrJhUOd7k5mFW4Cd/+wLTpzw8Lum4uTFA?=
 =?us-ascii?Q?oF98CJ8IZ/sVU/cyUWFPXyx64j/wjTzT2kueEGKIu4dW68CxXJvHTdcgVqkt?=
 =?us-ascii?Q?03BbUnQ8G2QikBXGeywDI7l6XVDKRF0wWl6ZH13IKMfNZAH1bJecBtfKm/QA?=
 =?us-ascii?Q?tFV4HQtet6VYPK1KcJbP4jb0Rmow8XJdeCzO7bcd2QWZwO32ybDmem2QbIAe?=
 =?us-ascii?Q?f1jmc4aTO1vDnyL4DddLnAdz3fq9Hsx3e+plBpTY9BR9Xa8CHQWaFliE6xgM?=
 =?us-ascii?Q?wSMfdA0wJ8u9h3iG15pspuX6ETorYFMi6p4D5LGHbH9H7v+2EGWhvstIeoL0?=
 =?us-ascii?Q?ta7oLh8J82Zv4ei5aYdbwm3IfA+tj+fa2ZfPL6qpzhJUzeAcpB7bueFRWtEB?=
 =?us-ascii?Q?Mr7phfInPaXwBBtAEIjsA0ryAJyOSY7c/cb8SHQsDPj/+q1wQk4vH4sWDqfT?=
 =?us-ascii?Q?InL3L4e3KlMVxAU+JoCREmoWKXyWDT01RLf2R89wddJiak256b83aZwLG6xG?=
 =?us-ascii?Q?hCILxy5LXo6iTzaunopgrr9cmxXnTRL0sYOU5rjZr03YRjVDiSPLEWjPnCPx?=
 =?us-ascii?Q?F1g7apmRoUdIGGH/neRDR64eNU2N10zBVGcgmrvR1i5+nbZFJ5goE0RivjZQ?=
 =?us-ascii?Q?qTvDDcEjAuXBkozNienz9CB3Yjk61mTzhQhdD7JWEi73Cji02mHhap6QtrTc?=
 =?us-ascii?Q?I/rn5JFhyqj8xAXtTg/9kveieIq95OzyFjWUSz2pswoR+W+ERNiANw5497Pm?=
 =?us-ascii?Q?x5yQdru5+X7SiXDb0Ya9uiXWHVWc6xx6+CjrWfIIHCsolpfeEtX+sVfHJOIZ?=
 =?us-ascii?Q?vTR1bzLpDGGUDniPlR7GVD3cdrAIbNjDEuiVtQkcD6R0ewNRcTJidxWY3WjI?=
 =?us-ascii?Q?OS9gzTQgolZ2Uaym4CAGSj2tP6GGB+4yH3R28Nne8KKyjPneMpDseMg4471G?=
 =?us-ascii?Q?TRQ7d/fcG1qsp+Ph1WbG8WESdKMfO9RCPaq8ukzvQCf+N1OOTkzly06/BCGP?=
 =?us-ascii?Q?3nIWw9JzrrLkehj4HZXKjToXw8B7p3A0rNIhSRzeBGcN3b/EItk26DT+QEO3?=
 =?us-ascii?Q?pAWegU9pVIIurNkB1xpZX2j9nsyXmh4Jf2zv7Gwh8h6ob4GwUMnBcDXDlgUf?=
 =?us-ascii?Q?CfBE5XQOvPHDZu4YMWRgapc18FIVpLzraEPmMaT6?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eaefa4d7-b857-4be0-fe62-08dd2317a6cb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2024 06:04:24.7129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gvo9zXfzOr5ax2B3ihTpAMNH79qOsSTP0F6RLoHwbFwDu8QC7CwPqqF8USA9fMXunJVSIUdjGyY2fqwK+TUWIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7287
X-OriginatorOrg: intel.com

On Fri, Dec 20, 2024 at 07:55:16AM -0800, Sean Christopherson wrote:
> On Fri, Dec 20, 2024, Yan Zhao wrote:
> > > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > > index 4508d868f1cd..2f15e0e33903 100644
> > > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > > @@ -985,6 +985,11 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
> > >  	if (fault->prefetch && is_shadow_present_pte(iter->old_spte))
> > >  		return RET_PF_SPURIOUS;
> > >  
> > > +	if (is_shadow_present_pte(iter->old_spte) &&
> > > +	    is_access_allowed(fault, iter->old_spte) &&
> > > +	    is_last_spte(iter->old_spte, iter->level))
> > One nit:
> > Do we need to warn on pfn_changed?
> 
> Hmm, I definitely don't think we "need" to, but it's not a bad idea.  The shadow
> MMU kinda sorta WARNs on this scenario:
> 
> 	if (!was_rmapped) {
> 		WARN_ON_ONCE(ret == RET_PF_SPURIOUS);
> 		rmap_add(vcpu, slot, sptep, gfn, pte_access);
> 	}
> 
> My only hesitation in adding a WARN is that the fast page fault path has similar
> logic and doesn't WARN, but that's rather silly on my part because it ideally
> would WARN, but grabbing the PFN to WARN would make it not-fast :-)
Thank you for supporting this idea!

 
> Want to post a patch?  I don't really want to squeeze the WARN into 6.13, just
> in case there's some weird edge case we're forgetting.
Yes, I'm willing to do that after this patch is merged :)

