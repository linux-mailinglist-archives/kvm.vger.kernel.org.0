Return-Path: <kvm+bounces-28950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 02F9299F6B7
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 21:04:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B4C63283EF0
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 19:04:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1071F1F80CA;
	Tue, 15 Oct 2024 19:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KSJBgzwL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D4E1F80AB;
	Tue, 15 Oct 2024 19:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729019059; cv=fail; b=KQLVZ4q9/vOKRUCell1cm7yl5AByK8LQQlgrQurLbzpqT0o8EfyBsLHRIGn5B7nWp00VyiYcUCY0JrXngSOROB8jEQ/hv6y896DDCgoBy0dlWY3YfD9tgkRg1uFV+qhU7/o6ecK5ALOou/TjSErI2nlbHEkNQuBA8Ejt30CflL0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729019059; c=relaxed/simple;
	bh=1irnCYyE+IKX3XfzfnBEGqKPA1ykSpF+imcG/QYGOQc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QGfx56wfuBkDQ0yD4eeLbn7Kz1MamiAUp7/0LPX8YBJp4hJ2YjMRlL9mRQykFg0palaUqU/Dlj0fUR/vdMToJiZK7nw6BZN2lLhQ2VNpX8a3ZwJMtBdjH5gkj4ayhvl20d2DGopd9fHN25FDn4HiAeGxlCD0fm6PEPYLllvcjUE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KSJBgzwL; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729019057; x=1760555057;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=1irnCYyE+IKX3XfzfnBEGqKPA1ykSpF+imcG/QYGOQc=;
  b=KSJBgzwLfAXFTJNwCcjFv2CfdBqTGkh35uNjCf74Y5yGeV0pEWni0CnD
   A9x+9WSk6p3Or520s+w8VuoTVQ4DoJPrhi+McqkXIpyFODFir1PBJMIqh
   xhw6rlu4Z8qFPO/db9+6KyqMY9EzYXpDEzpVh7IIy9eTWwKmdJ0P1zSVk
   wrcVtz8sLIdxbDr+udjwpj4PbBu2Adv68KEM9xmq6XktyyeH+4IqQA40b
   NlUdxzwFTmSYtG8ZQKAfHrWj9l88VdfmAtyXoxaiff97SU2ThHCgMznO0
   0Mlw8REM3JyhUjGU2c0kfxXZf0GHdE0J8zS4gy5+V4BZfZGfRW57OVPGZ
   w==;
X-CSE-ConnectionGUID: MtF9+3L5TYWd9UNkCa6fLQ==
X-CSE-MsgGUID: ecljrSchQKS1YbtnjGMIrw==
X-IronPort-AV: E=McAfee;i="6700,10204,11225"; a="53844766"
X-IronPort-AV: E=Sophos;i="6.11,205,1725346800"; 
   d="scan'208";a="53844766"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2024 12:04:17 -0700
X-CSE-ConnectionGUID: OL2tHE4mSteq7lJlXq2lXg==
X-CSE-MsgGUID: vMhOG1k9QsextPlMasJ1UQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,205,1725346800"; 
   d="scan'208";a="77870865"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Oct 2024 12:04:16 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 15 Oct 2024 12:04:15 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 15 Oct 2024 12:04:15 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 15 Oct 2024 12:04:15 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 15 Oct 2024 12:04:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wub0GqddifsbpjzDxmbmHuy9WWEBOPpVhHln3Gcj41PAsSlml0tFXJvDevA5Zaqt66DkuXJaCMpHDj83rQpA7i2DlxZj5spTqcpXorxyKjH7dTJkNW2FXXcHF1+hsclMKXEM8780iVO2BMSnqYxCvkCJs5U2Sn8QjxreuKRyBU40htne1N+lAiMcxsvcphd9fOLsgSey6d87I5dPAVxnb3E1yxHSUkU/a+OtWm5DQaSctqMoBKU6Aj9jzELnRnsAiiHkcuv0Jid0O48pbu1N1LNwp5vP2Z+v8UtPukGr89yLu21c2+Vcq44oL9Tm50VStMwafWN1vMPNixC7FmL5Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4tzK62p/pBsRAentbN4ocX2nJngwBXcnY+wiHQoUTUg=;
 b=w0eVFlJVjpJkfrPWo/QPjfb1mRVudVsOpjrL9Ap94JGImCwPsFxdv/VFW6Z/+x2JbceiVTwvL1DA1CSTcsOagqPDm11r6H6i4NpeQuMYv41YvjJP52KyxTqVBhpvsVIFcyzNn6vGK7EB8plf/CL8fm5RQyY2Epd+udkMm2vahg2/TEn6jP1jvcrxnLXmvCdWM0N2F3cMFgJC3APIn3eZKDYRu75GFJY6R+Uba73+enFY0POD1/4cGxo4t7L4u2qvuD8wtyBY61BeBtvYK0Zum+y7kZPu305t2y1OI2OWidlUiAxXFWSr3YBSYiU+0BqriRChHZjUMLm72HY4DHg4GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by IA0PR11MB7864.namprd11.prod.outlook.com (2603:10b6:208:3df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Tue, 15 Oct
 2024 19:04:11 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%5]) with mapi id 15.20.8048.020; Tue, 15 Oct 2024
 19:04:10 +0000
Date: Tue, 15 Oct 2024 12:04:07 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Dave Hansen <dave.hansen@intel.com>
CC: Kai Huang <kai.huang@intel.com>, <kirill.shutemov@linux.intel.com>,
	<tglx@linutronix.de>, <bp@alien8.de>, <peterz@infradead.org>,
	<mingo@redhat.com>, <hpa@zytor.com>, <dan.j.williams@intel.com>,
	<seanjc@google.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
	<isaku.yamahata@intel.com>, <adrian.hunter@intel.com>, <nik.borisov@suse.com>
Subject: Re: [PATCH v5 0/8] TDX host: metadata reading tweaks, bug fix and
 info dump
Message-ID: <670ebca6e8aa0_3f14294cf@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1728903647.git.kai.huang@intel.com>
 <f25673ea-08c5-474b-a841-095656820b67@intel.com>
 <CABgObfYXUxqQV_FoxKjC8U3t5DnyM45nz5DpTxYZv2x_uFK_Kw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfYXUxqQV_FoxKjC8U3t5DnyM45nz5DpTxYZv2x_uFK_Kw@mail.gmail.com>
X-ClientProxiedBy: MW4PR04CA0389.namprd04.prod.outlook.com
 (2603:10b6:303:81::34) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|IA0PR11MB7864:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e096bd3-626e-43c9-243e-08dced4c2695
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aTlJay9OU3RjdkVGVVU3Y2VVVVVvSTV2NjIyWDlINkFNZEh6SGFVUW1QY29V?=
 =?utf-8?B?SmdFd1Y2bEM1VFdWOGtrR0pFZVVSWDVCa21ndmdDcmluZ1NqS1Q0U21lOURw?=
 =?utf-8?B?cG0zZ0FMOHRmdnl3eE1VVWRGbktjWk02QXVPeGRqS1JLTHFqSWpXa1RXRXZR?=
 =?utf-8?B?bzF3V3RPWjZ3QjVvWm5ZVm95UDliZEZyN1RyOEpQbVlVMXkwY1hVNVZNQkw2?=
 =?utf-8?B?S2FwN0JMRGV6VzJEc1hqUkh1YmFXM3VwU2hmM3AwL0NyMFBsRWhsUWZjTm8v?=
 =?utf-8?B?K0hhb0ptV3BaMUExUkF4TlVjL1FCdjBjSGQ0aWRqRlFJNTlMaTRPVHF5anZx?=
 =?utf-8?B?ZzRqYUY2MVpGZWVmdXI4V3pxMGxrSE14eFRTdEtId2hwQkc0REx1Ynk0S213?=
 =?utf-8?B?MzVMQ2tTTmZVVm5KYTJtY2syQldXZDYxc1lJbElqTkxiOHY3dDR1ZXVrcUVo?=
 =?utf-8?B?MDV5RE8vRjd0aFZqTm91UDhYazVOdXRSV2ltMHVseDRKakdsY081TjU3ZXlh?=
 =?utf-8?B?aUE3RU5na2VGQWVHSGZWYjFTczN0enRmTjdMR0hrTXdvdWcxSDg0aTh1UU1q?=
 =?utf-8?B?c0R2OTRzUGJQTzhpWTlmK0ZkTGRDYVl2UjJzQWVNM2Raa2RwaFZUVjRQYVFn?=
 =?utf-8?B?NGRBcVlVR0srYmgrUVByWHdRMGNWdU92YXFlV3k4eXlzMHBvMmhJYVBQanJY?=
 =?utf-8?B?cmRUY1dNQ2RQMVVWdmZQbjRMdTIyTFRBU3ZBT3BLcmk2YjRkSFFLdW01YzNU?=
 =?utf-8?B?QkU5eHRlOGd2ZThyYlhRbzErSDdQeWRteVdIL1liWWlwMi82ZXlVNEV0NVlu?=
 =?utf-8?B?S1ExNmhwcUVLM0k5aHlISFVBaVIxem93cmp6ZDRzSTQ4YzBqTmJVcjJVV1dZ?=
 =?utf-8?B?eklFaDFMQ0ZwUkJZVlJTNlh4NlVkc1ZlbE94c3BsalpGYURPR3FRNnJKMVpH?=
 =?utf-8?B?SisvcVhsTExiWk9Yck9ra29oRFVyb3I4bVdscXM1ZUlIV1VuQVJKLzVnaUFK?=
 =?utf-8?B?ZWNZeDlKVnNuOVVUamxydHUvbEJDWjhrQUE2cGxEZnpwVi94NExkMllUNE9l?=
 =?utf-8?B?MWdxTXcxeGthVzNseGozSG1QV0RPTTJpZXRyTmdxQlBSbHhYZE5Ham1OY2Nx?=
 =?utf-8?B?Z1VxTVNYamk2YTVoSkp0SHBTcFIwUGFoTmR1SFNuSGdTcTdjZ0s3RVMxUVpE?=
 =?utf-8?B?b2FjMFVva05WQ1pLSFZPajVhalVJV004YjU2WkxXUldya2NQV0QvQzluQ1BI?=
 =?utf-8?B?SlJ1aThYNDR6NU16Q1RrOS81cytaaHhGQiswUnlGVTYxNnYzM1NEM2duUFZN?=
 =?utf-8?B?UWoxTFpHQWxhU204ZHRzbFY3SzVHTzhuQVhDd0d1bEt0Wll5ZmRtZ20xNm5X?=
 =?utf-8?B?OTdzY0tGL2w1d1NqUDR2Z0VTNW1XZ1JEaENLL1E4c21PTkhTY0lMallWK24v?=
 =?utf-8?B?Q0tJd1pZeWUybGx0THhsUGZLeDFBVkcyakpRUENwRmtZeURYQmhxa0VETjcr?=
 =?utf-8?B?WG0rLytVa3U3S2NTWGJnbDVuTkRYb2dZbG1qakRpUzZEeEJReSsyOXFlREVW?=
 =?utf-8?B?L0pZbWZOQ0RMc2lWaTZOMStBSFZXN1hUdjkvcFZIcWE4N3piRXlra0NlVDFL?=
 =?utf-8?B?MVhyMHlldVVXV0JEUGNLdnRXLzREV0JkRFJNek9BWkV6UFR5T3FuWjJZdW1S?=
 =?utf-8?B?elJ3WGJrY2k1WkJob1hUOWFka2JRRHoySGJDWVNFR1JIQkFKbC9OTkhBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q2FBeDM2NDFNbWJoelpkSUFKc2Q3SGUva2U4SDJGMml2SWs5NFU1b1hnYkpn?=
 =?utf-8?B?SDQ3QnFFVUkvcy9kNjlINE52cGxna2NUaHBUSE1Eajk3a08wcU5xNkdUWVJu?=
 =?utf-8?B?di8vajhRaEh3bFkrMHorRnlBVmJGcUxpYm5Ydi9BNUtNdGZsMVlVeXNNcmNu?=
 =?utf-8?B?KytWdXNxV21XdmI0eWFoNXhxcFQ2MGVpcjd5WDI3TndBSW9tWlJRKzQrT1Z2?=
 =?utf-8?B?ZmZ5cWhsVWpuV3cyQXk3SGJIWUU3TmdsMWFCcEN1dHh4WG5WaTFOd1pmdGtl?=
 =?utf-8?B?OGRsOHB2SXI3d05XNkkvSHVCVWp3Y1Y2M1d4TU1VUXJPN2hHSmRjYUQrc0ZH?=
 =?utf-8?B?ZnBua0dldy9JaVI5U0tyOGRaY0FaK3V6S3lZalpDYUxTVmRlOXArQjN6VkZr?=
 =?utf-8?B?VU9sLzNUdTZYTGhCME5NYnhvSnNtZ2JtNysvNG43SWdxckhmeFEwRHZTRjEy?=
 =?utf-8?B?OWFmdFFVaWVDZzAxMk5HTXJoRy83SDdrS3V1bzhsdWRPRERTSi9jZFZHaEo3?=
 =?utf-8?B?ZmlPSXBSekJiem92MVhWdEo2eHlJVUd2Z1JPR2h0UXhtQUFjODc0eXFaMnUr?=
 =?utf-8?B?R3F3aUU1L0RlVy9Kc2xrVVh1NXF4MzNlTzlxbmNpWTVsN1dVNG9icEF3QzIz?=
 =?utf-8?B?eDE0TEYydko1eStGUXVPRjFRNTI1UFJaUHk2TkJuK2ovMWI1K0pNbmlURXM3?=
 =?utf-8?B?RWwvSDFubDF4V1BQSXU0b1BHSHZWQUs2ZkE5QjhGTE1VTCtORGVFTGhVYk5w?=
 =?utf-8?B?eVFYYm50Q3VMUExGTGYwQ2ZXc0N6aVNlT3c5bGdScFlSY2RobE5hY1RoRitF?=
 =?utf-8?B?RmpNS2U0NUhRWE9XakMzRFdYREYxNG5QUE1lWlpxZldyTWFUUFZlTy9PVW1m?=
 =?utf-8?B?a0MrQmdHTk1zUE0rb3pyUEJTL3dIcjVSbUtpWFpwcTdERWVzUkNIN2d1Yis0?=
 =?utf-8?B?bFFKZHZ6aVVmemhQNXlBVFREdTZFTDlHM0pXV3JrdUUxRjJUMXY1YXlCSkFv?=
 =?utf-8?B?bncwQVdVYkZ3U3VYOGEvM0pFS2ZJMThtYnF5bURKQmowcXpPdlA5UzdTQXRD?=
 =?utf-8?B?Z21va285MllEOE4zVmRENFZHWTlpb0FXUFFXTXhPWTJxNXNLdEtrN1Zxd1E0?=
 =?utf-8?B?Mlg3WVpocjRMbDNLa1ptVzI3U2VhY3RWa0dTdTMyMjdEKzN1NFlFclduTXYx?=
 =?utf-8?B?Z3Rxb3g1dFMvQ1ZmOHFDaWQ3aEV3WVliVGN1ZWRpdXlQd29Ub3BNNE5zMnY1?=
 =?utf-8?B?QS9oOWRlVlE0S2tEbEZPbXRCSTd2MkUyYnNhcFYxNTNqaUd2Z21HV0EvYys1?=
 =?utf-8?B?TjlVdE1LdTA1M2gvc1U5bXQxNk9DVXVONEoyQlJYeU00ajB6WFlyb0lkSUV2?=
 =?utf-8?B?ZG1ySGdTOWZ3WW9veTI1ZjVLVEZKLzNMdk5nVDFmZk5IckQ0THdhcWpnRGpr?=
 =?utf-8?B?QWg3Q2NvajdsRE9wN1Jtd1hFK3dvaHJRRDJxcmJuY3dOeUc1TmhjclNDNFFH?=
 =?utf-8?B?eTRaS0ZzTHgvUHhIa0QzTWhySldRVEQwTU01UWtldDhSaWdxanlxalpVY3dh?=
 =?utf-8?B?dEY4cDVjSDZjakZiQ2YzRnBTNjYxS01GN1ZHNjU3dHR5R3I2cUg0ZlQ5MmxL?=
 =?utf-8?B?aUF3YWhpMnRQUmMrUmp2RHQvUnY3Sm0vUHBLK0Y2elZnUXZ4UVY3S3JtampY?=
 =?utf-8?B?RkFXZkhmeTRLL3FudXhhQTNzbEtRRVF1SHNiSUMwTjRXZzY2WEFNV3V3SS9M?=
 =?utf-8?B?Q0lIUC9hNHA3Rmt3SnpGOGFnbFB5NGpadzBTZStIQ2dJRWhVbjh5cG1yRCtN?=
 =?utf-8?B?K3JjSk1WUEMyYkZhLyt0cjdBdm1qdWg3T3RsOC92WUUyY28wbStUV0o2aTB6?=
 =?utf-8?B?UnZ6WFlrK0NaMXUyNWpIb1VTanRXek8xcU5KWnB6TjAzb0hTZC92S0pyTXVz?=
 =?utf-8?B?Vnl5d0NNMG5Sb1BTVXdHV25Jc1lWeFoyVXBCamVZQzdBYXVCRlhWWGxXYk1i?=
 =?utf-8?B?WlpIV0hUc25pMFN4eWx1RktYM0s4TGlPdjk2cUhmUDlCNGhPSGIzbS9tOHA3?=
 =?utf-8?B?ZlJpeEg4Lzg4YzZvYlJ1MzltOUVGMzQ0TlZMeUlaUzFLdWVGN1I4ODZtcUNH?=
 =?utf-8?B?VzFkYmx4cFh5ZWFoWkRDUjc3YzltSHJSNnBzWnhEcFRha2s1ZmNCUTRCTTl6?=
 =?utf-8?B?clE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e096bd3-626e-43c9-243e-08dced4c2695
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2024 19:04:10.1869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dbiHQhVSK4/NGvlIFA5jtXL25oFEySsOVTG0enHZFMk7KP1ILI2hMNHBiZw8oSfD2UB/tiPSRPgwommIC68Vb6wPYxkOu5phTHto7mSzrO0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7864
X-OriginatorOrg: intel.com

Paolo Bonzini wrote:
> On Tue, Oct 15, 2024 at 5:30 PM Dave Hansen <dave.hansen@intel.com> wrote:
> >
> > I'm having one of those "I hate this all" moments.  Look at what we say
> > in the code:
> >
> > >   * See the "global_metadata.json" in the "TDX 1.5 ABI definitions".
> >
> > Basically step one in verifying that this is all right is: Hey, humans,
> > please go parse a machine-readable format.  That's insanity.  If Intel
> > wants to publish JSON as the canonical source of truth, that's fine.
> > It's great, actually.  But let's stop playing human JSON parser and make
> > the computers do it for us, OK?
> >
> > Let's just generate the code.  Basically, as long as the generated C is
> > marginally readable, I'm OK with it.  The most important things are:
> >
> >  1. Adding a field is dirt simple
> >  2. Using the generated C is simple
> >
> > In 99% of the cases, nobody ends up having to ever look at the generated
> > code.
> >
> > Take a look at the attached python program and generated C file.  I
> > think they qualify.  We can check the script into tools/scripts/ and it
> > can get re-run when new json comes out or when a new field is needed.
> > You'd could call the generated code like this:
> 
> Ok, so let's move this thing forward. Here is a more polished script
> and the output. Untested beyond compilation.
> 
> Kai, feel free to include it in v6 with my
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.om>
> 
> I made an attempt at adding array support and using it with the CMR
> information; just to see if Intel is actually trying to make
> global_metadata.json accurate. The original code has
> 
>   for (i = 0; i < sysinfo_cmr->num_cmrs; i++) {
>     READ_SYS_INFO(CMR_BASE + i, cmr_base[i]);
>     READ_SYS_INFO(CMR_SIZE + i, cmr_size[i]);
>   }
> 
> The generated code instead always tries to read 32 fields and returns
> non-zero from get_tdx_sys_info_cmr if they are missing. If it fails to
> read the fields above NUM_CMRS, just remove that part of the tdx.py
> script and make sure that a comment in the code shames the TDX ABI
> documentation adequately. :)

Thanks for doing this Paolo, I regret not pushing harder [1] / polishing
up the bash+jq script I threw together to do the same.

I took a look at your script and the autogenerated code and it looks good
to me.

Feel free to add my Reviewed-by on a patch that adds that collateral to
the tools/ directory.

[1]: http://lore.kernel.org/66b19beaadd28_4fc729410@dwillia2-xfh.jf.intel.com.notmuch

