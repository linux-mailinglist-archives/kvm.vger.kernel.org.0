Return-Path: <kvm+bounces-18015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A8728CCB56
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 06:23:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B8DA91C212E0
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 04:23:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07BF155E73;
	Thu, 23 May 2024 04:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DNfOjXvS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D87273FD;
	Thu, 23 May 2024 04:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716438221; cv=fail; b=lUStcnGYnZvUNafqdbJYlmAV2AbjXrrtSR6NePnxFZGqflwxJYoPGTJnnse9EMYWwveE5wpuIk8nOmtNn9tI3n0P7xBCdavYgdBemBrOkq2KCcB2CB9C5+Y9+OuZhZ9h+7KJ1kdppx6uZlTtaErlwqzUAw3aJtY/2uGoBAn8lI4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716438221; c=relaxed/simple;
	bh=VfwDBBTSJ1jhgxwnBrBkysgD5ZNSr2SIChoefOfSadI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NAvbalvC8Dfl0i3ErYBvy/L0GmC0030wSVWtwZqn563IYXb2//HXlFSYLgRfVolN0/HTrgBbFG04Z+0/qdKRqdkCnz33z+7Iy3/LxRd+w85JtbOqrPPK7uo6pi1cE+EFzIviihtbTomDNAsv9N3dNJontPcCJ4ptOgr4J6hp/9g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DNfOjXvS; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716438220; x=1747974220;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=VfwDBBTSJ1jhgxwnBrBkysgD5ZNSr2SIChoefOfSadI=;
  b=DNfOjXvS8Ufkf2+0PI35oYvKrIy3EfS/8KbeOdYFH0weuWmx/L5riQNw
   32x1jbf/osrl7WJMsbzxM5HTSfBDcgBkqCHnj7L1KescAsaKGTnPUd+9a
   yICPtizF+vsSxi9mw2bErEXJg4/0Qjdefpmxnp7YvLEiK3Im7cg5QKdj/
   kUrWrJOC1xAFnWvQiWttnhSUCgFSfoQT2hmIlGZSsZ6wzB3BfA1nWlmGg
   TkptVYFZyavqf3iR8+QZSmv636hWDUwE1cufhiZlaK0lXH7yaIo4UV+Z6
   UmtGT1ej7dQHIKZ0XJ4VFQUYLdpU+ZtTNzHeKpPFd24A+VM+cIuNpW5ZI
   g==;
X-CSE-ConnectionGUID: qJnAKAAZRbGj8+CRvGYs+A==
X-CSE-MsgGUID: ebE619+FTpekDA+Xw87ERw==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="30229777"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="30229777"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 21:23:39 -0700
X-CSE-ConnectionGUID: SJjlAa3XSgy23+8xuY+5FQ==
X-CSE-MsgGUID: kyXge+UeRCCinsoA/xPDeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="33509634"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 May 2024 21:23:38 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 21:23:37 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 22 May 2024 21:23:37 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 22 May 2024 21:23:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=INHELQSASGv5xBijR/lvyvwFwOfu3qjwX+l9ElJvFrSWwqivswF45Of9B8bBFeEwzNd/CnSSUTRK/efMcWIanJ3AuhLzRxpST+K2DA9pioO3ZBeFM4+W5aKtP8yd38iOEqEjYfUM2kRjW6lAbGWEwABjl2fCDxvZf+Qs9Nuy25ufAhrMQBZ7tmv2wTljOolMRzlKSI0hOot3YL6BkelAtemaxVmSH08Shz4OinD7BtOhlCQYup1X11sr4LCMolPP8Tc4qETt9EKZb/EyDYJxVpO0YZCDQiYVYbfu/a0R+kpZUvoNY9LrxnNLWtXZHtJUVpqTR6XLUCI0sRqbFWpUag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P185sTEeVMp4Q1qxXP+W9VJnkg1n7j5QBdbMURq1ntc=;
 b=f75xykTnkAVBmyzRuQZztgTSD6rzAXXDJ71+fF1GI9PF/wIQ+KnKpFW6+kzZUyUeSAW+CtPUjiFa6djRtdCiqdQ554xXXu3HmCtAwDHT4sl9RI2/7Wb22vIpR9zQ9ojv8VwFI99mGnh66cAA812mInSo/AFPAFTr4XcpjWz62Fjw5C6uCc0nwFrG90VKn48wu7hd+2vN6Rvy7CGafQMHUN8GGb3WRMvDl2VzT0KW/Ldfe1N0u5JiN2VDvMQiEe+sOJ+Ai+lrGVxTDRlEmXY157ozK+K14fzg+dICsBeuvXb/wovRiiAb+UbS3zMJo0z05KRCqFwsAUiGw5ZhQwwXwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM4PR11MB6044.namprd11.prod.outlook.com (2603:10b6:8:63::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7611.20; Thu, 23 May 2024 04:23:31 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7587.035; Thu, 23 May 2024
 04:23:31 +0000
Date: Thu, 23 May 2024 12:23:23 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/6] KVM: Add a module param to allow enabling
 virtualization when KVM is loaded
Message-ID: <Zk7Eu0WS0j6/mmZT@chao-email>
References: <20240522022827.1690416-1-seanjc@google.com>
 <20240522022827.1690416-4-seanjc@google.com>
 <8b344a16-b28a-4f75-9c1a-a4edf2aa4a11@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8b344a16-b28a-4f75-9c1a-a4edf2aa4a11@intel.com>
X-ClientProxiedBy: SI2PR04CA0003.apcprd04.prod.outlook.com
 (2603:1096:4:197::23) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM4PR11MB6044:EE_
X-MS-Office365-Filtering-Correlation-Id: ef4a9d4a-d0a8-4f51-93a1-08dc7ae01a2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?FxHnC2pH2jXM9RPrzg4ryYsBpc6gBFiHVgtMoyWEBZukgn1bg4Od1ZUvZ/oY?=
 =?us-ascii?Q?eyZOmm4uJJpm57muoJz+g++KM0EhRbwcyP+IxaeyGDlmTOLu1Js0nUZPurOf?=
 =?us-ascii?Q?Yw/AkTobijWsn5TJtPb+0OYZd+TSWXnHIpNI4N0GeD5t5LEcPbishvJ2kmxS?=
 =?us-ascii?Q?BfsZ37W4rMBfjxditKt5zFtGkXn+PWlJiW91kiUSJrGeV1kE698bYIxSUTx7?=
 =?us-ascii?Q?CrGrheF/PSs43I1XV1UD9PXVXQLVyMKs8khyPpkd7Tit6cITQ2cNWt5ewhJJ?=
 =?us-ascii?Q?0k/mzK8aq5a94vxqwFUU4Fhi5QRwJcPFIPE52iyU3LS0b/fJsFjvoSfYelv8?=
 =?us-ascii?Q?BwzSX/c4ALysHdybRN41oKRjf650v0oYew6IzIBCmYtgfV0j7Oafk/gNskbG?=
 =?us-ascii?Q?2e+EMTiIkd4QAkXWBUmeKzB8OP0dgSBaTYpzfgWLBaG8vXvrjSvRC0/TB68Z?=
 =?us-ascii?Q?o3eW2cvkCcuqkifnRgX5WVTYSTlr0+SNnAYBX4zXkRzzg0k1yDm9jQCVwJ2b?=
 =?us-ascii?Q?8YH1tdhqsEf2bOEkuyD4vAHAUneYSo96aBLgrDVgaXO9abdUv7uv6/nYcTMn?=
 =?us-ascii?Q?0qNyoA4pAG67kG2GRV8WSh/KZQ1IJ01QcpSeQVfxBtc2cvz4vM9gQNYbyiIj?=
 =?us-ascii?Q?f3MN/usAUxEOgeE2r+JmHf3TzVh0KPsn7ws0B5V6GFiGJh9xJXPN4S0H8lXB?=
 =?us-ascii?Q?TBVj9DSEKOE5NKEb7mlEBI1pcd+kJMtBFAZkZt6PLfCLUY2W2f0BH21YOdEv?=
 =?us-ascii?Q?XUXX7N6kEwZgYfs3ffDCB2qd0FIyg9TjLdMDT2+P9Hp6QYtpEHHVDpeAVUgQ?=
 =?us-ascii?Q?GOtRA4RNwxpkUjSpGVBJFuCSWDY6Ml8PSEp2L2Lck+gz+tg8x+aQvSv9nUSU?=
 =?us-ascii?Q?mAH7tMh5uAtDbIs8j6OiJR7ywyTtexQk5pDayvphjB54bldWt8QucFEcVoj/?=
 =?us-ascii?Q?WPQUlLFirKXEFVLcfsMVOqbziKRxRh3TPJch3VQnVgdR3KHGQyrbfLbXxSO3?=
 =?us-ascii?Q?AVep5ujyYHHAowKoutjyYuUjg1bk0Nfoyl827j4rdadufwFxlClhjSN3vm+X?=
 =?us-ascii?Q?A4pZIjrh4rAjuo1ardSQJsKEnqRU7n1rtq3aFdOkj1PD8itXygIAdWjwxPhM?=
 =?us-ascii?Q?AiU4p+AuQKj3eHlqPecd3V/d3j3zX0Ikf/J2EHB7lxKvvlj4BE2Bc2B2Otis?=
 =?us-ascii?Q?4a6sgBhzHY9w9tmb9hyE8cE3IlvykxLHeZSX24V064ZVx2XcKEKBaAaGYX6E?=
 =?us-ascii?Q?bVx1KdduhM7urcXEcM8v0ahHs7joTwG8dgwddBn8tg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GeLVfI+wFTYPHqCj5wLyxATf+IZ4bMIP1L0P1n5/vQSAa7o87RPU0FaYWUkn?=
 =?us-ascii?Q?bdU2KrcGU7aeS7O/KLyFxmTn7/bslk9LnAlnasw/zYu6oMvoz40RzT0ygBtU?=
 =?us-ascii?Q?v8tRp/1oo3U84aJL11WIxlCjqfdFgR6rRoN9DhK2jf2co5awp1+T2maPi69Y?=
 =?us-ascii?Q?qSv4HZ4E9ANjR88xD3ONDrHxhweTpyxmof9Xl6VIa/5dIb99ZH5FsBUaMtH6?=
 =?us-ascii?Q?VoaCK3xNQp7sxFtSGcnIuoZl38ZVD4vwTt6lH1YJDPYEG+oA8FzxOHl4aFAp?=
 =?us-ascii?Q?+mIOmF4u0QrEI0uJamSkDH4XNQML9OkaJZn+Dpi6WS/Fdcxb6OMWERyrVW5A?=
 =?us-ascii?Q?Fea88sjs3ptEDK6jWT6bV1XCNHTReW4O0eELUysqkyVBJE9guTTiCxP3Voit?=
 =?us-ascii?Q?NAA02Ezw36GAblEOlO2xDc9/NCF3Bi88GMx2SwdyVAgfAKgvAHqair0a51PV?=
 =?us-ascii?Q?3Woo/in+551g4xCBZZxAIjNYZWZrWhe40PYCsCB6xm3SB9Rm++PZ1b4RQw5B?=
 =?us-ascii?Q?7L1mO9hcIoQUiiMbPYDfn7DbS0VlVg33c7BE4zHhp8Iw+YtXs0POUqDJyhcP?=
 =?us-ascii?Q?i2Z5MoKHZhuls4/NnCA8ElGIXiOu1akBxwLADLrnvaj8hSlycvin9WblIutA?=
 =?us-ascii?Q?slUBPR0VHTy+2k2ybQ5xW4u6C/KbCHSvyES+kJvt+23AYC3gmlbqmBdInnam?=
 =?us-ascii?Q?qxoKdEBMvyXIpSq7RPTjtgF4sY3FLrD9el9WxbKonUPUGjXDQ6gNmAd3mdw5?=
 =?us-ascii?Q?4qwikOp2pnjM7pUqqzkJ/6JwQNCpONos3whkVBlfN5biB8svY5LiikMbbyfR?=
 =?us-ascii?Q?hkAipFdKY6/lAURYUaYJf9vEW62YXWQn4CxOegXHRGMtA8EC2vxwzzdIYK12?=
 =?us-ascii?Q?Z7FpQ2Sb5yBIIl6onJWOy3FeMYAThYwQurOPJOQBxb2BlifQnrqHtrs9n628?=
 =?us-ascii?Q?57bU/2LtCgU5QIWKWY4VrB2ofGPIqSJpjk54/4ssqo5FvddLRuS1VhR+WUvx?=
 =?us-ascii?Q?UZ5odXxaDVlovHk4yw5jBhyf6Orykjpnj3Y6WflQhCO4RLQZ2w2qzxUTTQJb?=
 =?us-ascii?Q?Gx2QcVJF3vlsOxVt+nsVx+WlIlznJ2bhVyqtefPHIRwLW3Wc+yB2Itr8TnX4?=
 =?us-ascii?Q?1DDua8AqwTXIw7WsvnI6RU+TvMP1UB6LRqqfUaTKzyYpllNyI82TK34ED7KZ?=
 =?us-ascii?Q?vWDNBiBp7GaqB6q/Ba9/w/vtCSmYbYtubb6Atrn/LOM87CojfmyflGqwgPv9?=
 =?us-ascii?Q?qJKY8Sx63WTntQwP7jEDb41Z1/VP4MLpfmn8iSYt+COWWbptXMO7f4i3cFCq?=
 =?us-ascii?Q?hgyzVTMHiGP+PRsfFRT2ZLpVdGwyAArvoYzLBs34oQYQ6oE0Pa5MzsV9xwaa?=
 =?us-ascii?Q?ogcfAZ/OwvGPzc3ZEoVgU8GHR7Up/IFqQDKAmGwnIXBrnw0fJR42SLeOXNSW?=
 =?us-ascii?Q?OG1ppbxgKGOTD8elekEwECjTTjoqZK7qRFxeDa4lMbp7A9zgOXVKqFF8UWBp?=
 =?us-ascii?Q?fz3NP3mrkN/bblVeO/OjsQObM4d+wdcu6c6fwN0OJJBpI31cr0maQFit7Bdv?=
 =?us-ascii?Q?LMhbuHeoxLKUZlHIgzqG871rebq+8fl7Yhtl2M5a?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ef4a9d4a-d0a8-4f51-93a1-08dc7ae01a2e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2024 04:23:31.1438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UKrg1ovKBE0p1P98W1q5Wp87foHcSA/+Qv9YUXNB7GqA8ucG296dfQnlfYsRpQHMcQfSuyNNHiVd7BwTG66ntw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6044
X-OriginatorOrg: intel.com

On Thu, May 23, 2024 at 10:27:53AM +1200, Huang, Kai wrote:
>
>
>On 22/05/2024 2:28 pm, Sean Christopherson wrote:
>> Add an off-by-default module param, enable_virt_at_load, to let userspace
>> force virtualization to be enabled in hardware when KVM is initialized,
>> i.e. just before /dev/kvm is exposed to userspace.  Enabling virtualization
>> during KVM initialization allows userspace to avoid the additional latency
>> when creating/destroying the first/last VM.  Now that KVM uses the cpuhp
>> framework to do per-CPU enabling, the latency could be non-trivial as the
>> cpuhup bringup/teardown is serialized across CPUs, e.g. the latency could
>> be problematic for use case that need to spin up VMs quickly.
>
>How about we defer this until there's a real complain that this isn't
>acceptable?  To me it doesn't sound "latency of creating the first VM"
>matters a lot in the real CSP deployments.

I suspect kselftest and kvm-unit-tests will be impacted a lot because
hundreds of tests are run serially. And it looks clumsy to reload KVM
module to set enable_virt_at_load to make tests run faster. I think the
test slowdown is a more realistic problem than running an off-tree
hypervisor, so I vote to make enabling virtualization at load time the
default behavior and if we really want to support an off-tree hypervisor,
we can add a new module param to opt in enabling virtualization at runtime.

>
>The concern of adding a new module param is once we add it, we need to
>maintain it even it is no longer needed in the future for backward
>compatibility.  Especially this param is in kvm.ko, and for all ARCHs.
>
>E.g., I think _IF_ the core cpuhp code is enhanced to call those callbacks in
>parallel in cpuhp_setup_state(), then this issue could be mitigated to an
>unnoticeable level.
>
>Or we just still do:
>
>	cpus_read_lock();
>	on_each_cpu(hardware_enable_nolock, ...);
>	cpuhp_setup_state_nocalls_cpuslocked(...);
>	cpus_read_unlock();
>
>I think the main benefit of series is to put all virtualization enabling
>related things into one single function.  Whether using cpuhp_setup_state()
>or using on_each_cpu() shouldn't be the main point.
>

