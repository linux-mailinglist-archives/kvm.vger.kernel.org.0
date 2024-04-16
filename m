Return-Path: <kvm+bounces-14820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D06B8A732A
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 20:24:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7396283DFD
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 18:24:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B753136E16;
	Tue, 16 Apr 2024 18:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XCP/RY0J"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A551F13664D;
	Tue, 16 Apr 2024 18:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713291866; cv=fail; b=jLNe16gqGf+eBKf/mZ1jdp3a2wCLIQsyBDCZdDy2jcTSMRkbtXWF5sYPZ+5eMBJd5FYxPSeRP3QMQ6C/7zY3i0v7swSstqO/uNYE42TRczdUOt4mU5bhosXF9NOa1YTLBVlPDsS3dzgTDZAZgm8FuJgGgNEVY3zLZ4eFW/BzybU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713291866; c=relaxed/simple;
	bh=tAoM3+woZYPE825dX/s3v0HliN+2B+sPH4AL1/pqlis=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=c7+6cywAR8Fod+k83UogkbjA/yYl4Vv5ScBcWaQCE/3+sVmbw4vljmb4fOIv/NKS9Q/GnoB1WtKmn2xFhk7cHktHBPcAIIUS8MGBW/SKI++g9ca7qWXXq7szszqxEKYEj1Qi4bvuT6phaBvgmryTDGGPQ/lpwQJeFAFWGNwIm0I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XCP/RY0J; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713291865; x=1744827865;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tAoM3+woZYPE825dX/s3v0HliN+2B+sPH4AL1/pqlis=;
  b=XCP/RY0JBeVKY0GoZO+gWNSwjlXrQKW4+ADApeT1JRFvIh+tLS+LDSGL
   RWUfmjs/x/J3pTUoVviB1asDt+5L3adqsQ0i++iKUq41FmVXstJEpEBJf
   swf/Q/nbmi86MX314oyybuFbo0/RKwnrXgfojywjSrkSSmqTTs7NqyBJU
   Qsnq3JRRerqCy1cOFPUX5gIuX27c2arOzImIfi+36MHcdiQVRuvGO+x5s
   +Ott2NCpn4Ljqcg+sirA3A+Rw+nIY5rsjWox6GAKt1wyWWbAEo7ck5JXR
   wxYnI5ULG38t8F6UfdzsDfl/iooN//o7QbWKNywcYz7t8z+hXizniFrvP
   w==;
X-CSE-ConnectionGUID: AXn3hlR7TEm57tl/cRPtbg==
X-CSE-MsgGUID: NmFhc6RsT2ip41SoZTnc4w==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="8922718"
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="8922718"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 11:24:23 -0700
X-CSE-ConnectionGUID: 2J2nRGacQM6S8WpmQn0MjA==
X-CSE-MsgGUID: R2prnpwpQua0TFS+z9TyTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="45631279"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Apr 2024 11:24:22 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 11:24:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 11:24:21 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Apr 2024 11:24:21 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Apr 2024 11:24:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z0UnKVr4AfdHcVZvi1g9KhUKuujMtIbvnCSmVv7eaPT8SN8fP1T7CXc1iJOKbEoB2j5pgRLs59fJKheuhVOdgGoHmB5ZIH+6FHkPifNwXT28VJT/eI6rniRNx7geLHYPa9h8w8lr0WjcJkPEXQ1ScGkFPhKOBIPdM0EUe6+qcp3NaFXcoTxc1pueLH7WJo4fnrDzK+dscBVkys6K+qRIAXUa8Ta+vDTRzyXoLvufWsZnySTPjAFJBKBGqnQLFs8KSMDrKLR33vitufSxIpJxJ0xXKeSGv3sOujwDbsWNwcwvUuw5S22eQdspCeTLyTjB3FiT6dC15uLzZr7aSCdsJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kkp9sg0hCpsYO07MJnN12zwav2A+DQP5MjMdU+SBtnA=;
 b=ckyK+0iJy+vro7Krkk1Ruk84Qp5lQzVml7V/Qp4mivs5KJrq67txS+FG6IGp/5ynFNhmeJR8GtYUTmy6BLNGqBM4HeGkZkpNGadK1lVUa08UZTxV5SSmf1KuLbtQq3vtglV4IyUMxrMpJlC9tQCJpDg4rMZiPUfQr8TvyYxz1D+l2YZf2noxLnuE7CM9Po43M027B99/1kmDwwMNMHu/y04z+m5AozUeRYcdwbw8iRvbd600pBb3KVKKN1WZRndJLr8WQXIkTExTQEpnTEIbyXY/MbIl+Nnl7btFAqCBxWD9yCxjLRk7w2mOGpiMge6m0HG/VhwYZ81Vb9rGPgQOQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MN2PR11MB4647.namprd11.prod.outlook.com (2603:10b6:208:262::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.29; Tue, 16 Apr
 2024 18:24:18 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::d610:9c43:6085:9e68]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::d610:9c43:6085:9e68%7]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 18:24:18 +0000
Message-ID: <9785680f-1c30-456f-af49-b6d26dd38fdf@intel.com>
Date: Tue, 16 Apr 2024 11:24:16 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 086/130] KVM: TDX: restore debug store when TD exit
To: <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <b7a96654fa46593417afa6153959b2989a507842.1708933498.git.isaku.yamahata@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <b7a96654fa46593417afa6153959b2989a507842.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0315.namprd04.prod.outlook.com
 (2603:10b6:303:82::20) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MN2PR11MB4647:EE_
X-MS-Office365-Filtering-Correlation-Id: 8380b567-008b-4959-3b5f-08dc5e426dc6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hRnd2uN7hFdlYl8DAlCLP6AXNmsJ8PHFDVkyuJs7NPTCU+RVYXKXzj35NEoTmuXXJvWA+Eg6D6myTlylQ/oPpWS/1JLD9w23mNiChFW2O7SEix+i1obHxnGEPmkxoRUc4/4rEZABMa0985gnSqhOXoYAV08pRV/G633lupe6wgCpZcTN76BBji2MkZDXHZgfbAAxu7VCceZ1UG1erficeDKwIQyaTJBTyslo2xDVqUX2U6Lwhgg+DZEmyz5dk8ba0etPJJgbsguViomzriIjkpym5WqUJzD1ORNkEWsPgQiVZmo52c4mCrTvat9saclmzMoGgsN+OcVoJSGhYt2KoLG8acd2C/1e+afUIJAVGZRoLpIMpdUTzrVyte4utniMT1vGL03e+zq/XMNmOc+DjCjK2N7hpL6OYK0NV+noY1FI6aipJ6hXWE1z0jX06W0Py6EUpUNg435aXIcoLSTCIFAiQyUldDHeW7N21Yya+WhZcsq2Elbm8YQacBXNfDJIpJWcowymNLCul4/m0hDeItxNyiOcDjdgCAR+/tSlChhi1th8NdJFHgldGvRBvLeJSgBMhKhZPrGgDuuYRCikAZLGVicvlND8YGYuTM5kgu8ITYRWC6V3jQTNIiLCO9oy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SWFHVllIUmhsUjZ5ZGN6UWhCa21RODZyd3hsaFVqQkE5VTBIZ0V0M1J5aW9o?=
 =?utf-8?B?MTZzejBFdkVlVjh5TjNYdWEya0RmMlRRY1N0RSt1Wm1VUjVMMGpCSXhQM2dU?=
 =?utf-8?B?eFpqczhwOEg4V2k1Unp0dzI1MDNaRjh5cDF2NE8wK3Z2SG5IRHVtcUorSStE?=
 =?utf-8?B?dDhVeVFoRG1NNWlhelU4Tld6cjI0WWUrZUczT2VSWlcyc1M3WU04b0owMkU3?=
 =?utf-8?B?N29FOXlqTiszcTB0ZjcremUzdm1vQ2Qya25PY0VDRFU5Zm1pTUpYKzFIU1Ey?=
 =?utf-8?B?MHcwU25HbkZCd0d4a1ovT2RTdVByRExGaGhtMVBpcHc5RlRwT2RlL1JKMThJ?=
 =?utf-8?B?aGNZOTBIYzg2N0NxcHVGeUF2d2VYU1lxakt6VGowM3Joc29kbTlnSHpWcUd4?=
 =?utf-8?B?R0FhdzNKd3BhMGduQzNGd1RVRFRxbG1SNkVGMzdNMCt0OXVkNGhEbER0YkpD?=
 =?utf-8?B?cldNMHovRFZjSWdCY2lsN0czQmhUUEFPNWJFVTg4K2p4LzFnN0dvNlR5OFFG?=
 =?utf-8?B?U0FvVW1kS0hvSDdzRUpoaVJ0QU9vWGRXQWtYaUVGdFBJcGplUmVwVHJ3bm9W?=
 =?utf-8?B?RDF0RXpHSkxsd0tkOHRCWnFTc0VFUWU1RitPTDV3Y1RhdmZGREV1bUQrOHdx?=
 =?utf-8?B?bFBXS0o3S09kNUdLRjM5djdQN2xVM2RuVy9ZQWIrSEtqYkowcmZUcGtadWZp?=
 =?utf-8?B?VmxSTkljdHNEWFAxV3FXWGY1ejErclZNMUpoZ1VLR3Y5YkpvN3I4ZG9zQ0l5?=
 =?utf-8?B?WG03dWpXL2xBdDN0T3U2SFBEYVowZ3QvRlIxbkJ6UlJmYi9PUTB5bTFQR0hi?=
 =?utf-8?B?QzFIUVl6eVo3Szh0Zy9NUHVmcm9IUXh3YjEzclYrQ09QMFNiaEhBK0YwVERm?=
 =?utf-8?B?SUo2SGNMMHg2c09qWXRvT3VSWkQwZG9lL2JrK1B2ZzloSG1XNFpEUlgzb0NV?=
 =?utf-8?B?a3U1elFaTTUra1B1QWpidmU0aG9YUHhsMGgyQmo0SUs2ZVR1K0Q5bWUxaGVF?=
 =?utf-8?B?NW9keU9BQjFYNmhJTjhXQzR1SHJJdDhvRVlrSVRwSUpKa0xUMWU5eElUclhO?=
 =?utf-8?B?UkxLY0syY1R6anRyem9jMkN6aEFhK3lVdzE1dlBOMzJCczZxRWZSWUpoc2M3?=
 =?utf-8?B?VlR5RStrMHNWYk1PcnFqa2ZWMWUyVUl6YWd0NkVUQnQ3elQ4ZjVWbnJIcW04?=
 =?utf-8?B?dmk1QTFuSnQ5RmRMQVFEbjRyUzN1ZEY0ZWJHMlVCS1oyb1NJOVkzWVRINXZP?=
 =?utf-8?B?cFFVeVZMUmtmRHhQbTlOMDVCT0Nzdy9RemhPL0d0MzZzaDltbUdrYXJNdVp1?=
 =?utf-8?B?U21zcnRaSVozMnVCZGRvRmVRRm15Y3MxV3JFTHF3dUlEWnlGSndGUTM2YnFM?=
 =?utf-8?B?LzZ0cysvL29PanhuT25iQ1dpcDJ1cklrSlM2Rk82dFRVemxMenRpTFltamgx?=
 =?utf-8?B?R3hmL0RZTUF1aDEza3RCSEw4bU9jcHcyNW0wd0J4c1VQdjRWaGY0bk0xbFVx?=
 =?utf-8?B?TlhsT2V6QmJFTTc5K3VMZlBIS2YxRVp1VWtrT0FJWjJzTmR4eFBBME5nUHU5?=
 =?utf-8?B?QnlpdjA4am5Ddk1ENUhETzFBQVE2dk5QbjB3TzUxKzRWM1dFc3ZtWkJ4TXp3?=
 =?utf-8?B?MWd2RCtkK2htN2x3M3BsRHFBOWk3a0pZVXFleWgxUEhMeWNFZDMyVGxVVEw0?=
 =?utf-8?B?QlV3dzc2MkNhWWVuM1RLbEw3SHZYaU40TFRIVGZPOE9zVkpJdUJEOS9pUU4y?=
 =?utf-8?B?Uk8yTkNPTWYrMTFjK3Q3NjdZeG1XTXp4UWdKU3dTZG5nd2FWbVBEOGlKcitT?=
 =?utf-8?B?Z3M5alFwM2x1eGlCb2JVVzNFRjMrL29Ha1V1cTJGcWJ5ZFdxQm0rWDdTY2NB?=
 =?utf-8?B?VDA4T0cwTGRVWnhXQ0V4dTJabDdRSThtTnBRaDE2bWpwc0U4TmpqVzRQK0Iw?=
 =?utf-8?B?VDlGc3JqeHoxdEVEV09KTFBHd2NPWkgzVUZNMDN5VmdKYUd2blR6S25KUUlR?=
 =?utf-8?B?TUt3aC9BZHdyenVzbXBuQ2VwWEdGb3pRTFgwbCsxMzE0L2NNSWw5QmNydFFp?=
 =?utf-8?B?NXA4YzlDNTFHMCsrckhKbHl4bm56bjc5cFFXUEZja3pkc1ptRTBuN0tmWXk4?=
 =?utf-8?B?SEgzQmtvV3VhU1NLU2JzY0FiTnMrZERpQkgxeVp6ZkhpMUNacFRIV2dnYnRP?=
 =?utf-8?B?cHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8380b567-008b-4959-3b5f-08dc5e426dc6
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 18:24:18.3872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g4lgiZA6dDnK4s+7d2d0Wjm7yF3nz4wyhOD/AZF+JRKdfBSwxvzq+vZ4b6sKvOX4Uv9oD7D/6UWlZeENa+8bAsWDWMR7UBrm9sRZlSIQGFc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4647
X-OriginatorOrg: intel.com

Hi Isaku,

On 2/26/2024 12:26 AM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Because debug store is clobbered, restore it on TD exit.
> 

I am trying to understand why this is needed and finding a few
places that seem to indicate that this is not needed.

For example, in the TX base spec, section 15.2 "On-TD Performance
Monitoring", subsection "15.2.1 Overview":
 * IA32_DS_AREA MSR is context-switched across TD entry and exit transitions.

To confirm I peeked at the TDX module code and found (if I understand this
correctly) that IA32_DS_AREA is saved on TD entry (see [1]) and restored on 
TD exit (see [2]).


> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/events/intel/ds.c | 1 +
>  arch/x86/kvm/vmx/tdx.c     | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
> index d49d661ec0a7..25670d8a485b 100644
> --- a/arch/x86/events/intel/ds.c
> +++ b/arch/x86/events/intel/ds.c
> @@ -2428,3 +2428,4 @@ void perf_restore_debug_store(void)
>  
>  	wrmsrl(MSR_IA32_DS_AREA, (unsigned long)ds);
>  }
> +EXPORT_SYMBOL_GPL(perf_restore_debug_store);
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index b8b168f74dfe..ad4d3d4eaf6c 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -665,6 +665,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
>  	tdx_vcpu_enter_exit(tdx);
>  
>  	tdx_user_return_update_cache(vcpu);
> +	perf_restore_debug_store();
>  	tdx_restore_host_xsave_state(vcpu);
>  	tdx->host_state_need_restore = true;
>  

Reinette

[1] https://github.com/intel/tdx-module/blob/tdx_1.5/src/td_transitions/tdh_vp_enter.c#L719
[2] https://github.com/intel/tdx-module/blob/tdx_1.5/src/td_transitions/td_exit.c#L130

