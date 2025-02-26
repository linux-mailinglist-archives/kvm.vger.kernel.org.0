Return-Path: <kvm+bounces-39413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE7EEA46EB7
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 23:45:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C31E43AF058
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 22:45:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AF8B25E82E;
	Wed, 26 Feb 2025 22:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eq+OZK6m"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88C025E80A;
	Wed, 26 Feb 2025 22:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740609927; cv=fail; b=k8+lIWKjWuMsWTzFILFguurfcxJ9HT3mT3Z/jhNxTs49JRpYxN8OqWeve8PHTB2/qhFp0KIOpmh7RmSuuTqrh04G1AYtqMqRzcqMgq30vfXIbk/nfh/h18gScVyP2KUH/Q5cbHjaCXzaQxV7+BMLzPDqH6YH8bh1Xf+p8MhHDq8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740609927; c=relaxed/simple;
	bh=2S4gUBwJQO/eC6t0Q8GeYfizSAX/RVl6cfYGen1fBS0=;
	h=Message-ID:Date:Subject:References:From:To:CC:In-Reply-To:
	 Content-Type:MIME-Version; b=SJ3GbLhHNl/XnIJDWMdbs+O9anEb/5oQZFwfCf92XWXQnfhIp4phUAZgl2bOXuSD88bOxrN91HcGEg+UL7vS/rGTCrjbNpRWIr+tD4IR68Xn9QgCNFo/Ea/E7ZijfD6rn/xG6ernysrb+2G9swxJ5PQjHLj2QX5u/8ufO6YWkKU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eq+OZK6m; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740609926; x=1772145926;
  h=message-id:date:subject:references:from:to:cc:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2S4gUBwJQO/eC6t0Q8GeYfizSAX/RVl6cfYGen1fBS0=;
  b=eq+OZK6mlYC7XL78TZ8iB2fEALNJyAeVYW0l49P//wTNszTFBTSGc0hx
   Ure+0xowxHs+uIT5gZQWdGDPbfLY0wCYoR3VU0QYRdOwKQKMe/MGGEA85
   KMR3w7T/NDaQJ1aMQ+NKAAFPO2PA32Xxt/aMJRXSTrjAKy6BTS3c+FHTd
   DkDT60+W+7lLZtvB59MSOJNqR0zoW8ywKhsKZJu3vl8Ln79HBrjDr8ysB
   wDs/QGvW/+uGjNKq2cJFal5dl3LOQ7svGbBIc0K0XgvSS8xy1y50Ff4n+
   9FDlCuY/GrIvlJxhJpeKv9LBVunZ5ktAsFXATzoS7MT5EC7WjbAVcQlQs
   A==;
X-CSE-ConnectionGUID: GH5kK9KvSiy2qzRYwp3dfw==
X-CSE-MsgGUID: gIesYaULQtSiE1CY4jJhng==
X-IronPort-AV: E=McAfee;i="6700,10204,11357"; a="41503426"
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="41503426"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 14:45:25 -0800
X-CSE-ConnectionGUID: ctl+OsQkQjG/0D9fzp1YWQ==
X-CSE-MsgGUID: ieWNbsxCRmekS12vyqz9IA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="117475279"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 14:45:24 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 26 Feb 2025 14:45:23 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 26 Feb 2025 14:45:23 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 26 Feb 2025 14:45:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GNShsYf60jpPhWV5wXjbQu7AK6x9epTniQFiXmnGJ5xcdnRWlwB4EOm5hTmnPsT5B4P5T72IrIaMkldzdr19rH6arm3hhvetEDRnfacu3nNt3deApuvWI5k7JvaE70KOV654D1HhxWx15KKqvFTCSLClYsfKFWZrZbY5fMMhwt2lxmyAtLy94txiCOe1QHI0Zi6pk3WNt1t+jN3MN2EVd8iEx/Diq7PlTDWdIlFBnSTzDd8zdrp4b0q2CoQf1oduefA+tn0D7EIU2Vkb/Qg429kDBLrC5U1vWrFNef/4XMy065FOBC1RWJ2t93f+N8orCK0OPULx2E4D5PCybW6F3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9I2oiZv3/HPRdrOUNsZY2Q5ZZq80GWNs0n3dQPBHO7w=;
 b=w7+o+Ngo+L765hn1j5BUvGrFUFs4YQpmeaSfM7oH1/KX37Imzl2daeqaYunJGuJ2u46qh1wnpTeKgzqRg6uKZLZpuK+ZFSf9G7o4UeZbRoS9ODFQgkLvSYEuH1bbkpv6z7VY6OTuN9xNix0S6b+D0Svsbmoqlu5uSc4WzGzoAIEDHNBksg+Ki5fJi8F4fT3jdM/vUNby0eJ9v3m9fPpCHnJ/j/dAXJgQgngLBgkJHvMcrY0Y6mypJd7JHcriTO9FJF1glAoIpHufcMtCkxFAcpj+gn+VQ9StoDZJ7D7VRHFYijO7XZjJsdIr3FUjCQLuVD2HMiu4j1OCi85fqaqwXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB4805.namprd11.prod.outlook.com (2603:10b6:510:32::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.21; Wed, 26 Feb
 2025 22:45:06 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%6]) with mapi id 15.20.8466.016; Wed, 26 Feb 2025
 22:45:06 +0000
Message-ID: <63886376-07d3-45f2-90b3-89e1b63501f3@intel.com>
Date: Thu, 27 Feb 2025 11:44:54 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH Resend] KVM: x86: ioapic: Optimize EOI handling to reduce
 unnecessary VM exits
References: <Z6uo24Wf3LoetUMc@google.com>
 <20250225064253.309334-1-zijie.wei@linux.alibaba.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
To: weizijie <zijie.wei@linux.alibaba.com>, Sean Christopherson
	<seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	"H . Peter Anvin" <hpa@zytor.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: xuyun <xuyun_xy.xy@linux.alibaba.com>
In-Reply-To: <20250225064253.309334-1-zijie.wei@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0010.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::12) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH0PR11MB4805:EE_
X-MS-Office365-Filtering-Correlation-Id: 97d15eca-05a3-4ed2-d65b-08dd56b7374a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dFRhOEQyalVpem5raGZnV0V0dHNSRFFiT2d6bURDcXRJNms1VGVzcUNEL0tU?=
 =?utf-8?B?NHNsNjc3RmY5ajZ4Y3k1NUZad3pJZUZsWlp4TzlOWGlXVWI5NFkzZ1laN1g4?=
 =?utf-8?B?dGZwem1PeGdkQllTUEJRMVByVHVyS2loZGM5K3ljOEU3TnJQcjZaeXQweXRQ?=
 =?utf-8?B?S2c4TmgraGd4SGZQVXBTVjRzc0ptVG9vNDdQMStvcTMzcnBBREpJeDNYMDRM?=
 =?utf-8?B?Wk52ZW1qaVZlSG5SVlc2bDBBTHlTQzJCcEV4TElRVmRLcXcyT1RKU05DeEZT?=
 =?utf-8?B?N2tQSGIwTG5NNVA2T1hBMzM5dHZySktDbHRWbGRHVUtKNHpldE5ydTlPZUdF?=
 =?utf-8?B?UGpsSjZyVi9nUDRjTy9GRnVGWEQ5UTZFRm5PNTNUY0hGYTkwclJFcEYvd2w2?=
 =?utf-8?B?UTVpM0dTaVY0bUp3dFFlYnNSWWhEazU0TzJaUjdDVFJXZCtEUW5pYnRjZGZz?=
 =?utf-8?B?R3JxcktxWWtiOStab2ovbUlOQjJqRDhKbUlra0VxSXdRTVY2S2hucVpsVzZp?=
 =?utf-8?B?WEt1bEtUQ3J1NjB4VkV0Zi9Xay9lazlQQmFsWTZvSTdkYzZDTll1NHZuT0dn?=
 =?utf-8?B?Qjh6eXZud1V5REwybzZibzRFOHN0L0h6d2I1eUR4MmhyRVhEckJzaERTd2Zm?=
 =?utf-8?B?SXNwSmxxUS8xUzZFWUtGS3lFRHFxcGZGd1l4Mk0yRk9MZWlCcW5VTXF1M2RU?=
 =?utf-8?B?MzMrWmFxY2NYdithYk1SSU45Z0c0aWFVdVRWYXRoM0wvWEFtcTI2T2xYN1hN?=
 =?utf-8?B?YS9NaFYwSXlUYkRrM3FBSkF6Yzh3WFJ3QnJVcnNaK1VQQnUva2RkNFNrYllS?=
 =?utf-8?B?bFZIclB5anpJdFU2aFZIQkt6eUZEQlE5YmV0NDV0bFFzRGg0YmhjdGlMd3I4?=
 =?utf-8?B?TGtqZndKUjlobjIzcUxTNDJPc2tJQjY3MjFiUmYwUVFDWDRjTTZzdVV3Ymh4?=
 =?utf-8?B?akJQOGJJVVhMWFI0TUJkZTROQy9iN3ZJSlVNeWovcjlOQWZMc2tEdnJINFUr?=
 =?utf-8?B?aTJxdXZrK3FCSG42UGVPUXRMK3BRYW8xQWVmTXdNNW1ZNXc3M2l5dmpPYlgx?=
 =?utf-8?B?b0EyTTc4L05SS3V2ZXhJN3pia1pJd1RqQ004VkxzdEJtZi90VFhid2t3YjhX?=
 =?utf-8?B?LzZ2ajBuSlQxM0pqNGhzT0tvbUZWYVFXOGJYSUlDbitUblNTaFQzTEM2bTNx?=
 =?utf-8?B?NU12SkNZNDZVbStPRXorT0hjOWtrb0ViZllENXNxUUlNT1k1Nmp3VVl6YXJG?=
 =?utf-8?B?Z0dCNjJTc2RmSHZNUVlxQTRVY3ZmTmRsZmgyYVZkcDc3R2RKd0d1S3dHRHJw?=
 =?utf-8?B?cHY0MXdoaDc0cVAxc2ZXQlVlZENqaWJpTjYyaVdSbmU4YVZ1S3F0ajBWdXVy?=
 =?utf-8?B?NSsvVFV0cExqKzhGVFV4djhhWUNPU0dKTGVQaTdsNk1Hb1ZZUlRpZzM5MWtp?=
 =?utf-8?B?OC9WTEpwaTN1SnpZRm9lV2lHTE0zaXczT3ljK3I0Y3J4aXpNYTNJR24wdHYr?=
 =?utf-8?B?VWdxaHRBZlB5U0xUekppcWJwZEhYdWdXVmN4Um84Nkl0THh6R2duV1NJVjBp?=
 =?utf-8?B?U2pGbWZFaW4rTnNLdXFQenRUNVhER3RQNEtLbVRLSUdJdUdCK05vaWJFeXhZ?=
 =?utf-8?B?T1FjM0VCcExwNnE0dmU0V28yckUrZ0JrUnNmMW1hbFduWHF4NkZrOHRDN1Y1?=
 =?utf-8?B?dFp5QjVxWGR3QlNaYlNnZGhsekU2UFByeU9nS1o5cTdtVmlGRWQwN2FEUGcx?=
 =?utf-8?B?NFJNbHdsSm1QbDhWS2MxSUlDRkhVQ3I1Z2xiRzY1RktUekRLTmxtRFZ2UkMy?=
 =?utf-8?B?SFhLWmxINHRzUVMvRkd6RmFlSzJZOVFlRzNueCtKS1B4RzdGbWxLTFRhNngw?=
 =?utf-8?B?bWlVK3g2c28xN2JZa2JmOE05WS81RENOK2hDQnhMNE5PZ3lEYmUzTEl6bVhK?=
 =?utf-8?Q?UmbCbBWVIEg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eEk5eGVJQTZXRFBzeXM4MjhVRW9UV0tMWG93UDlCYlprZjlFNlNYeEVQc1hh?=
 =?utf-8?B?U0lBb244V1d4a05VU0MzaXp0SndodWFjSTVOdGF5RHFZTS94Y0RqakxzeGc5?=
 =?utf-8?B?d1pGSndoOFBtWXNWcHV5U2dvdzBqWXBTaVdibndOT1VzOUZ6UVVKazRXRGJF?=
 =?utf-8?B?dlBKdkFNZFd5YnMvSzRBVkVvM0tWdjVwWDJ3MHdPMzJJOWVYTy9GM0pkMm1h?=
 =?utf-8?B?Sk1LanYwTGRMUVllK1dZa0hhb3lEWHRkbjhCd0N2VnJIUnpXdEpkaWJaZHow?=
 =?utf-8?B?VDNJSktBZ1pnWWd2OFVXR3FGOFlLNW9SUUNWQVJUcTVxcU9FYlphMUxHZlJM?=
 =?utf-8?B?Q3pHdTNaLzRXMmNyam9meUNXVEZjck5HdWZsaEw4V1NIc3o4eTM4aVVFRmQ5?=
 =?utf-8?B?NldmN1BKREJsdmVmUGkvWld0c25hZm9KNWFYMWphYzhXVU5ia09HSW1BZXJC?=
 =?utf-8?B?WGhLYS8vU2RjeWZTMVRKWExGalBKNjdMSFNOdHlpb2p4NDZUVjRsL0JWS3F1?=
 =?utf-8?B?dnlOWk5nMmZkckt3OC9rMTRsWkdGZU55Ri9pYlJ6TmJqVFJYeGE0SVdsRDYv?=
 =?utf-8?B?Q3AvZ3JhS09pUXlUL2t1Y2dPSkdwR082NFVLajJSalVHSmtXRmM4aTcwUExo?=
 =?utf-8?B?M1QvV3hhVVE2M2dxOUxYVHBYM1ZqekZWRnJSSTV2V2dLVUlHQ0hqY0s1UmR5?=
 =?utf-8?B?c2FuWFNETUxRd09Lc3p4ZjNwY2ZpcFcrbHl3MC9IYVFPSWJnTjJiU0VOOUls?=
 =?utf-8?B?bi9aUnJqSHBnTFZBOHJFTldURENORlJyQ1A0Zm9GeUtwZllPSnVXdVdHWHQw?=
 =?utf-8?B?b1JwMkZoVWlMa0RFZ2R2cks3RzFVM2xzMGsxb3BxbkJqYVgvTklobmtrNTE4?=
 =?utf-8?B?UW9aTFoxdzdqRHREcWFKMkl5M2wxemtReGlRWGtBbEZLOWlPQ2JtM3RaRExI?=
 =?utf-8?B?enpUcVVBMnlFRG52cGlTdjRrajI3TWlzSS9iRUY3ZjJWOGxyOHhVNWRpNUpo?=
 =?utf-8?B?Ni8wRE5GeWIwaDJOMXUyQk9FakpDbmVQeHBxMERuUDdCSkZ4Mk5ORVBLTEc2?=
 =?utf-8?B?WC9LcytWSStwSVMvbC9sL2pONzYwTHl1MzRzVTVpV2pYQXVNeURGbmxueFVL?=
 =?utf-8?B?dGV4SUZXMTNyZjdmVjV1bG9NMzlwdDFMb05XdnVySDV5TkdMNkpOckxkdmlO?=
 =?utf-8?B?OWF3NUdrQmsweE5KS05YWTBZejJ4eWRBUzBKcSs3QkZkRHIvaDFBZ0trT3BX?=
 =?utf-8?B?NDFybThwOGlwWWQ5L2RTYXdYOXZJRHZsVlhiSUpVLzlvWFZJWTErYmNNZVRJ?=
 =?utf-8?B?ZXBuL0Zkc3QxSGl4dW1lK1hVeFVHY0o5QWgwWk0zQVBWeDBramYxSGoyeUxR?=
 =?utf-8?B?ZzdBYWN0VzI0MnBDZ3A0NkZVaHgyakxvTzl5L1lheWxGNkpCSytNNTFNY3BQ?=
 =?utf-8?B?SmxnQnZvblpjcnFYSXlWWHJIbVNWYVZTcnpmeVhwK3JaWDdpUTdTOFNmVkNr?=
 =?utf-8?B?c3QyVDQ0YkpXQTh1T1dZTEx1K09QOUlCdm9BTFR4bUQySS8xYW1CS3dGeHdr?=
 =?utf-8?B?WVFyZmtLL3YvWjlBQUhrR1A0LzJJOUl2bkRtaVliTTR6emlsemorMWJRdy9D?=
 =?utf-8?B?UXpzN0MzalpZSDluNzN5NTU2QTBUZUNHWGU5Tlc1YzVDRHdiTUtkY1dlZTV4?=
 =?utf-8?B?MnMwQ2FzSS9RZ09GY1NGcVppVWhybk14TXhiSjRyN2lja24xRGdIenFMYXdK?=
 =?utf-8?B?bUM2NG9GUDZYMExLdUxMa3hiVFBYcDQvRGRBWVVpUUlUZEhSL0dwOFVGRjZK?=
 =?utf-8?B?M09vZ28yOU5HOEp2ajk0VlpsSHZ4QU92bWx3WUVhemJSZ3lFVlZaRCttQ0VR?=
 =?utf-8?B?RGpURWpqNjRRTkFhNzl4b3YxK1ZjV2w3SFowT3RBdWwwUkgxY3ZZNzY2WUcz?=
 =?utf-8?B?MFRxTUtkSTltaDRFZTNVeXY1YTh0dDJyNGhmZW1BTm5lcnZ3YWZhN1BZN1hJ?=
 =?utf-8?B?aS83U2pvS0pKK1NQd3NqQTRhcytaQ3drS2NpOUw0S0Y5YmEzN2lmOGIxb25C?=
 =?utf-8?B?elRyWnh3ZDBQVzNXWlBvdnV4KzFKR0ZlaGdIUWo2Q3dUa3RVSTcrNnZ4bytP?=
 =?utf-8?Q?F/jCoBZD+y+u3HVSiO9qBgGKH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 97d15eca-05a3-4ed2-d65b-08dd56b7374a
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2025 22:45:06.6754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vVmCSD8bCraVcLpBE/DWOXa0A6ZIXgGGk4D76HyiftMvBgVZAXZRhAStCH/5HX8gSyY3WXOlDSRyAGsyOhR9NA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4805
X-OriginatorOrg: intel.com



On 25/02/2025 7:42 pm, weizijie wrote:
> Address performance issues caused by a vector being reused by a
> non-IOAPIC source.
> 
> Commit 0fc5a36dd6b3
> ("KVM: x86: ioapic: Fix level-triggered EOI and IOAPIC reconfigure race")
> addressed the issues related to EOI and IOAPIC reconfiguration races.
> However, it has introduced some performance concerns:
> 
> Configuring IOAPIC interrupts while an interrupt request (IRQ) is
> already in service can unintentionally trigger a VM exit for other
> interrupts that normally do not require one, due to the settings of
> `ioapic_handled_vectors`. If the IOAPIC is not reconfigured during
> runtime, this issue persists, continuing to adversely affect
> performance.

Could you elaborate why the guest would configure the IOAPIC entry to 
use the same vector of an IRQ which is already in service?  Is it some 
kinda temporary configuration (which means the guest will either the 
reconfigure the vector of the conflicting IRQ or the IOAPIC entry soon)?

I.e., why would this issue persist?

If such "persist" is due to guest bug or bad behaviour I am not sure we 
need to tackle that in KVM.

> 
> Simple Fix Proposal:
> A straightforward solution is to record highest in-service IRQ that
> is pending at the time of the last scan. Then, upon the next guest
> exit, do a full KVM_REQ_SCAN_IOAPIC. This ensures that a re-scan of
> the ioapic occurs only when the recorded vector is EOI'd, and
> subsequently, the extra bit in the eoi_exit_bitmap are cleared,
> avoiding unnecessary VM exits.
> 
> Co-developed-by: xuyun <xuyun_xy.xy@linux.alibaba.com>
> Signed-off-by: xuyun <xuyun_xy.xy@linux.alibaba.com>
> Signed-off-by: weizijie <zijie.wei@linux.alibaba.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  1 +
>   arch/x86/kvm/ioapic.c           | 10 ++++++++--
>   arch/x86/kvm/irq_comm.c         |  9 +++++++--
>   arch/x86/kvm/vmx/vmx.c          |  9 +++++++++
>   4 files changed, 25 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 0b7af5902ff7..8c50e7b4a96f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1062,6 +1062,7 @@ struct kvm_vcpu_arch {
>   #if IS_ENABLED(CONFIG_HYPERV)
>   	hpa_t hv_root_tdp;
>   #endif
> +	u8 last_pending_vector;
>   };
>   
>   struct kvm_lpage_info {
> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
> index 995eb5054360..40252a800897 100644
> --- a/arch/x86/kvm/ioapic.c
> +++ b/arch/x86/kvm/ioapic.c
> @@ -297,10 +297,16 @@ void kvm_ioapic_scan_entry(struct kvm_vcpu *vcpu, ulong *ioapic_handled_vectors)
>   			u16 dm = kvm_lapic_irq_dest_mode(!!e->fields.dest_mode);
>   
>   			if (kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
> -						e->fields.dest_id, dm) ||
> -			    kvm_apic_pending_eoi(vcpu, e->fields.vector))
> +						e->fields.dest_id, dm))
>   				__set_bit(e->fields.vector,
>   					  ioapic_handled_vectors);
> +			else if (kvm_apic_pending_eoi(vcpu, e->fields.vector)) {
> +				__set_bit(e->fields.vector,
> +					  ioapic_handled_vectors);
> +				vcpu->arch.last_pending_vector = e->fields.vector >
> +					vcpu->arch.last_pending_vector ? e->fields.vector :
> +					vcpu->arch.last_pending_vector;
> +			}
>   		}
>   	}
>   	spin_unlock(&ioapic->lock);
> diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
> index 8136695f7b96..1d23c52576e1 100644
> --- a/arch/x86/kvm/irq_comm.c
> +++ b/arch/x86/kvm/irq_comm.c
> @@ -426,9 +426,14 @@ void kvm_scan_ioapic_routes(struct kvm_vcpu *vcpu,
>   
>   			if (irq.trig_mode &&
>   			    (kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
> -						 irq.dest_id, irq.dest_mode) ||
> -			     kvm_apic_pending_eoi(vcpu, irq.vector)))
> +						 irq.dest_id, irq.dest_mode)))
>   				__set_bit(irq.vector, ioapic_handled_vectors);
> +			else if (kvm_apic_pending_eoi(vcpu, irq.vector)) {
> +				__set_bit(irq.vector, ioapic_handled_vectors);
> +				vcpu->arch.last_pending_vector = irq.vector >
> +					vcpu->arch.last_pending_vector ? irq.vector :
> +					vcpu->arch.last_pending_vector;
> +			}
>   		}
>   	}
>   	srcu_read_unlock(&kvm->irq_srcu, idx);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 6c56d5235f0f..047cdd5964e5 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5712,6 +5712,15 @@ static int handle_apic_eoi_induced(struct kvm_vcpu *vcpu)
>   
>   	/* EOI-induced VM exit is trap-like and thus no need to adjust IP */
>   	kvm_apic_set_eoi_accelerated(vcpu, vector);
> +
> +	/* When there are instances where ioapic_handled_vectors is
> +	 * set due to pending interrupts, clean up the record and do
> +	 * a full KVM_REQ_SCAN_IOAPIC.
> +	 */

Comment style:

	/*
	 * When ...
	 */

> +	if (vcpu->arch.last_pending_vector == vector) {
> +		vcpu->arch.last_pending_vector = 0;
> +		kvm_make_request(KVM_REQ_SCAN_IOAPIC, vcpu);
> +	}

As Sean commented before, this should be in a common code probably in 
kvm_ioapic_send_eoi().

https://lore.kernel.org/all/Z2IDkWPz2rhDLD0P@google.com/


