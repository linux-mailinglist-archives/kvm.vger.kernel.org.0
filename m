Return-Path: <kvm+bounces-14819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DEA58A7326
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 20:24:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 910B71C2136F
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 18:23:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C87B61369B1;
	Tue, 16 Apr 2024 18:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bK9Vbwh/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0247D134CD0;
	Tue, 16 Apr 2024 18:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713291790; cv=fail; b=B7D2mNdUg2yEdDYYS7vDqth+RE8hgyRTz8SVEUL6euQp5Sdnnpv7iEoL/KD5R1wsHMuw6aM1DH1rX7MWPOjrvlg+3mywsizB8FZ8yIC9E3QPLBMBvvMTaWr1KOD5i2y/TCGR4v0piOBi6i1nTv47oTlg6wcYdXX9FvNjpHZzM6c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713291790; c=relaxed/simple;
	bh=wcTiQdp/yjsRYkuBRckWrmPkVexMXInyH6jItr61RZY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LiEhVN5OYVf0SXS4HTtfhIbGMHGM9Po9Lg5YX2uhjKP/E2XAtFvGEkSwq87yz3iQ3rARQlzGu5Feg+dt3k0a442Mtc3QdfQt51gfwcUbPXZw6l2QsFhfBDzb/lqb4yvHlgPCak1YG6kmIj/mLJnZpthxdqCyGU3i1azZYXrRuKQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bK9Vbwh/; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713291788; x=1744827788;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wcTiQdp/yjsRYkuBRckWrmPkVexMXInyH6jItr61RZY=;
  b=bK9Vbwh/E73TKcs4mDzjPwvNfZO/FxWDmv4HXrhE8fPLdEZ9rinsO00E
   8MrrhUPS17hxxRNXCSChd+IZD4LOs0oZN4cSTFOa2nhVs5c61ME4Oshr6
   g65WhcdMaKZ7MyJNtReU5aDVhOIaR4lolvnY++CByW7/10BwOYPMAxUJV
   DFEVTIOOyc1p1LU1XeQa5STDbKDW74aCBp2MH2eKhpplQ4hC2SaaCCLnn
   03ry4iiJv8LnYLmWcnwoUqMvy+PcFydHTsI9XZoi1+zLpufypqldlDcPB
   xaCRAT0ftfQ4vVKW2tPc3h+HwyKRbwFo0Y0BaH2BRrCJviLiTa34+fSR/
   g==;
X-CSE-ConnectionGUID: cZJIl0DPR0KOc7I1erzv1w==
X-CSE-MsgGUID: vDRbnKEPTK6SB4P5jWLfBg==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="12589997"
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="12589997"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 11:23:08 -0700
X-CSE-ConnectionGUID: 8EbHHkATQkKUZpJtQGPDnw==
X-CSE-MsgGUID: zLZydZ4JTiyfi1kwjVNraA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="27030157"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Apr 2024 11:23:08 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 11:23:07 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Apr 2024 11:23:07 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Apr 2024 11:23:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aBdP5XgadM2gcyFW8Q0dJCBdO7IT+jXlRMG9B2bG8nYahhPUaQfL8n5eg31PbMMaI63Z2rbCdL3759Tcl4jTQGIhTX+M7YUrgvvS8K5z8DVIFKdZ5/gd8NlN+tm0bK3RRjulc3r14XB8cbXGKic/rJv4EtGSrRS+u4OqsLgbbT2ayeHMUY/T5NNHtI+cjWUvaGL9Pc8LDE4mctLU8GJmA/G577EdP5te6JnyfFzepshqQbeTeN9Oh18sVZyKruisTKTjAa3pUIpKd+XXHjVyr1Nq14cFjOygQoMFvc5Rx5Wucl3u8rBnYdPq/iJHl86Y5a26o0WgZzjtJg66xyrvbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cvY0hkCdurnoSUpMA6PKhqKHWSYZJ5Xom4HvLqn2pRI=;
 b=eu5THeHONvcrgl7ii49rkhTkzU54lt/BswmACTp0hFXmRIOoMh6pyzfxnibjm9xZxnI7TIq8KhuI7FMFFUv1ea6XzEtb4LnnqksgWO44xVRDt9MjPsK7jrMl4gl/dsN5fMy907KMt3uarUE7J8iJ8dd2gHreHku5uoWbsWzJhPKuwmox4eGnWQ57irzF6Ze9vJbBBJ0cyNGjm9KVv6WaHQ8wYN26P9Nfngvb6BdneBonfQ2p0rfRWDQqQvnWvFuUKb0E+134zfwzXo9htprYgk8hHhX2ZIOnq3osriKGwQwW4hvbJx8pHW2zEtosG0l0+sxvP4XGeDpIfgpvDVafng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MN6PR11MB8101.namprd11.prod.outlook.com (2603:10b6:208:46e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.25; Tue, 16 Apr
 2024 18:23:03 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::d610:9c43:6085:9e68]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::d610:9c43:6085:9e68%7]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 18:23:03 +0000
Message-ID: <7d19f693-d8e9-4a9d-8cfa-3ec9c388622f@intel.com>
Date: Tue, 16 Apr 2024 11:23:01 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 085/130] KVM: TDX: Complete interrupts after tdexit
To: <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>, Binbin Wu
	<binbin.wu@linux.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <aa6a927214a5d29d5591a0079f4374b05a82a03f.1708933498.git.isaku.yamahata@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <aa6a927214a5d29d5591a0079f4374b05a82a03f.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0131.namprd03.prod.outlook.com
 (2603:10b6:303:8c::16) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MN6PR11MB8101:EE_
X-MS-Office365-Filtering-Correlation-Id: 0024c8d0-e597-4a44-648d-08dc5e424149
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hhzsj9Gy4FS6sUKwaoy0fcIYCZMgDMw2pjGCEtRru+GsyaGAC3phancGri4jdTH99feoHgKfG3H5qx6iu+qiDZl3sXcdlHNL6D6s2xcOXRI2qZhKGdWuDo9R8gd8V+Db9ERzuq1Qz3H6BL5qknCfnTbv7qJZyHt7fPfGWvjZblVvJ08VXVrWjw2KKCUwJg/fpdPTQ1370XOnQcqNVL1zle9cnpsNb7qOJ18mRLG70wa2C7YYXMcwtx3Z8nlMYC6MBhUtZCgpGXtqec7L8V0OKMrCi4t1qnrK/iyvtz8C4KrMSUhep5hZ7LHKtt81Z+bIVNk0H6ncEUxYJLkwASTzsldxHfkOCBF/0YAgAnmFrnBj1M/aRMt2AhQ5coCqrmouhC8cezCLOcqO1paVBi5FL+rLU6uuEFhfEIuDsxEctFafQiTC1S9dncNu9uw5aAnuGsRyCsXEUpEoIhwIFiqaC7Xrh3CssIfXR+28UJ4S3znEOpdPnVRrE3KoVvn0M1S3IxeYsDjPsikGlqomShod011HSDqwABJ1NEiNXKjHlSxxfrtUu1oAB13y1xtgitV4JpjXkU9TqxzLIBrTG8+3PS7yAIwBLOS6SKycLxM/1jEWujlXb2pg9mW37hQ9P+JlsV4NI5HvR4gJhvALagEM/Q6Q4ZEwfXVhoqDVOYFUnck=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VXdoenZ2S1JzbkpZWDMzaFQrRnhQVDhrY0RyNjFzT29ydndISGlNSVVIQnlW?=
 =?utf-8?B?NGEyMk9LT0hBRmlWYWx1aExaL09NV1dTRDRaMTdkZnRuM3RxM3gxWVdQWjVm?=
 =?utf-8?B?S1dSaGdSWTM3Z0ZLc3FCTTlJcld2RWdxUjhNUnFzTnJaamxtUWsrYnZYYW1p?=
 =?utf-8?B?RVorQXRSY3BVU1FCR3hCdGd0b1dPdUxZd2krdDkwbmptZlAwNTJyOWxudnF0?=
 =?utf-8?B?WGtiVjNHeGJhWWM1T3pPM01SMEQyaytpYnB2ZzVDYklrNHQ0Y3FJOG53cjA0?=
 =?utf-8?B?MXM3WDhPS1hMS29KK3FWOEE0SytZenV5VU85WmdEOTkxZEdGMnRySU1YMFVM?=
 =?utf-8?B?LzhYWmt6aUdJSlBIU2tEU096dGNFVmJpTExReWZQM3hXaU5qbkRIRHhtZnBI?=
 =?utf-8?B?V2xkSkNLZzU5dkh4eldtV0FpWXBHbVVhL29tOW1FT0Y0QmpFdmZOa0l2aHV2?=
 =?utf-8?B?UFRibk8wQW1pNElGSEhkaEU3Tk5pRmNiRlVnZHpqV1AxS2kwTXVtVENkWlR6?=
 =?utf-8?B?OFpCMTNpa0EyeHVIaDdxajF2RmwvRTZ6V2c0b1RIUnlpM3lVV3VJZW1CL1Ry?=
 =?utf-8?B?M2xOc3JCTDY0VmZFbFQ2WVRtdmZuejRpTyszbnR6UWRkdml1aDBWTTZ5VXBB?=
 =?utf-8?B?UWNlMlNNMTdlcEtxVXM5bEdlQ2ZzeDlFSFJQS2FwN0Z3S2Q5bThYYURLWXUy?=
 =?utf-8?B?ejlzZXU3UXlZU1hPUEMwOEg2NG1yZ3BvTDVmdFBuN0ZTWTZqOExOVWprejRx?=
 =?utf-8?B?NStTczdrMFB0OUlJcnNIdnVPNUllcG93SFVPbmxURk5velcvb0FnTGloSWh4?=
 =?utf-8?B?UmhWeGZlQXBac3lEOXQyM0FRWlBTMGFkSld2RzR0YlZzQTdyZWY4aUpFanNN?=
 =?utf-8?B?b2lQbnExeGRXazVIWWFOQ2wyNzg1UnpuNnlXME1mU2NrYzRpTUVUQzNHV29C?=
 =?utf-8?B?d2hmbEhVUkNCR0c0c3U1V1k0VzN1ek5nVnZmRnZBb2QyZzJiUk9OUlQyZjRj?=
 =?utf-8?B?M0ZkYXVQQmZISStSR1FEWmpxVVJubXZUV3RjY0lrZ3BTYUlFaUF4d2h6RUd3?=
 =?utf-8?B?TXZNNTFBVXA2c1YwdkQzMC9SeEpwNXBQdEVhdDlqMnVsYUdTWEVCK1UxTW0y?=
 =?utf-8?B?YnpjbUd6YnZKdEhsb0VvYi9IbzV3STB1Q2doVnlVcjJkVHFBWmRTcEJBaUl3?=
 =?utf-8?B?VmNvT2p5K3hHQUpFMFBMMytJd0VRUUN3dlJPL2lTVEs4WTZ1L0RwQXMzUENq?=
 =?utf-8?B?cTNDMXhGcExSallTR0RzcVk0d1pHcllielBoTWllVGthSmNkQm5zZGNpMTBK?=
 =?utf-8?B?YWNmT2p0UElsaGZCaUFiK0xsbDZ4eXNqbXdXWXd0Y1pHS0kvbnBaM29LMVgy?=
 =?utf-8?B?OUdhMjlHTkJ1TWVvcGhMMUFsRmdLV25kWHJzbStZMlM2Lzd4NFdaNW54YTFP?=
 =?utf-8?B?OG1Ua043ZXNTQm9RenFFemhMdUxYMEFHSlg4bFpPYnd4a0Z3T0VKMDhYdjUx?=
 =?utf-8?B?VVcrdmRWRk1DWlhMMTA1NTNpVHMrM21DM3ZCQUR1bDE0YVZwbDJaUXNpRUNw?=
 =?utf-8?B?cStRejNxck9PWnhxbER0YzU5cTJQS3FFY0cvZU96RVBWck1DYXNBSkhJUmRs?=
 =?utf-8?B?Sy9uL24vUXVFRmNTblJCcHBnZWNjMW9kcGtqOHBvK0w2SlNRT0djNktpQnc2?=
 =?utf-8?B?Vjd1dFpReG83N2ZTckxBZkJ0RDZaZHl3SmlFcC96UWlxUmZPSGtXMHZIREdk?=
 =?utf-8?B?VzdrRjBwbnJyRmdpQ0NKc2d4ZnpXdXNZaHVrUEpVcFJmeUdxSHMyeTdrT2kr?=
 =?utf-8?B?bmJGZUdSNE9QRXRobDNVbkVMcUJkY3pWSUQ0emY2T2gxZzdnbnd4K1NBMzFr?=
 =?utf-8?B?S1U4ZmxORzEyLzB4UVc1eGU2ZkIva3NLWnlDN0VQVHc2TGtJbGllelc5S2Ra?=
 =?utf-8?B?ak9DSzhHMXNsSVBOYk0zNEtpTWw4a0JqSjBodUY1OEVTMjVldHZ0NW1MekFI?=
 =?utf-8?B?UUlxZVc5SGhIVXE3amNEb2RMWU9xaHc0d2hpbXZsZnFYK0FQTFFNS2UxSHAx?=
 =?utf-8?B?ZWNlWnBpWTl6c1ZYeFY4WlpHbDBHV1ZuTW1Ea1ZlUy9UNHhMMDZsdXBqOCtY?=
 =?utf-8?B?TUZEMTB4WFI2WUNMcFNSblY2N0xXY0wyQ1VIejQxZDkwVjBONEI5bTdzYnpr?=
 =?utf-8?B?SGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0024c8d0-e597-4a44-648d-08dc5e424149
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 18:23:03.8356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S+caTIqSlMclcWaeiypcuNqSQLga9kG6qBSmwLK4XbbuL/NFoA+bOn2gvOX1s5Sdw0I4FoKP3dl2MDWkwLU43r+INiWebJdQ5JOELHTXu8o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8101
X-OriginatorOrg: intel.com

Hi Isaku,

(In shortlog "tdexit" can be "TD exit" to be consistent with
documentation.)

On 2/26/2024 12:26 AM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> This corresponds to VMX __vmx_complete_interrupts().  Because TDX
> virtualize vAPIC, KVM only needs to care NMI injection.

This seems to be the first appearance of NMI and the changelog
is very brief. How about expending it with:

"This corresponds to VMX __vmx_complete_interrupts().  Because TDX
 virtualize vAPIC, KVM only needs to care about NMI injection.

 KVM can request TDX to inject an NMI into a guest TD vCPU when the
 vCPU is not active. TDX will attempt to inject an NMI as soon as
 possible on TD entry. NMI injection is managed by writing to (to
 inject NMI) and reading from (to get status of NMI injection)
 the PEND_NMI field within the TDX vCPU scope metadata (Trust
 Domain Virtual Processor State (TDVPS)).

 Update KVM's NMI status on TD exit by checking whether a requested
 NMI has been injected into the TD. Reading the metadata via SEAMCALL
 is expensive so only perform the check if an NMI was injected.

 This is the first need to access vCPU scope metadata in the
 "management" class. Ensure that needed accessor is available. 
"

> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> ---
> v19:
> - move tdvps_management_check() to this patch
> - typo: complete -> Complete in short log
> ---
>  arch/x86/kvm/vmx/tdx.c | 10 ++++++++++
>  arch/x86/kvm/vmx/tdx.h |  4 ++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 83dcaf5b6fbd..b8b168f74dfe 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -535,6 +535,14 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	 */
>  }
>  
> +static void tdx_complete_interrupts(struct kvm_vcpu *vcpu)
> +{
> +	/* Avoid costly SEAMCALL if no nmi was injected */

	/* Avoid costly SEAMCALL if no NMI was injected. */

> +	if (vcpu->arch.nmi_injected)
> +		vcpu->arch.nmi_injected = td_management_read8(to_tdx(vcpu),
> +							      TD_VCPU_PEND_NMI);
> +}
> +
>  struct tdx_uret_msr {
>  	u32 msr;
>  	unsigned int slot;
> @@ -663,6 +671,8 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
>  	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
>  	trace_kvm_exit(vcpu, KVM_ISA_VMX);
>  
> +	tdx_complete_interrupts(vcpu);
> +
>  	return EXIT_FASTPATH_NONE;
>  }
>  
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 44eab734e702..0d8a98feb58e 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -142,6 +142,8 @@ static __always_inline void tdvps_vmcs_check(u32 field, u8 bits)
>  			 "Invalid TD VMCS access for 16-bit field");
>  }
>  
> +static __always_inline void tdvps_management_check(u64 field, u8 bits) {}

Is this intended to be a stub or is it expected to be fleshed out with
some checks?

> +
>  #define TDX_BUILD_TDVPS_ACCESSORS(bits, uclass, lclass)				\
>  static __always_inline u##bits td_##lclass##_read##bits(struct vcpu_tdx *tdx,	\
>  							u32 field)		\
> @@ -200,6 +202,8 @@ TDX_BUILD_TDVPS_ACCESSORS(16, VMCS, vmcs);
>  TDX_BUILD_TDVPS_ACCESSORS(32, VMCS, vmcs);
>  TDX_BUILD_TDVPS_ACCESSORS(64, VMCS, vmcs);
>  
> +TDX_BUILD_TDVPS_ACCESSORS(8, MANAGEMENT, management);
> +
>  static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx, u32 field)
>  {
>  	struct tdx_module_args out;

Reinette


