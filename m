Return-Path: <kvm+bounces-57972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6467FB8302E
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 07:28:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20272620B9A
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 05:28:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC7AE29D29B;
	Thu, 18 Sep 2025 05:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MhKSaKPu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD02F27C162;
	Thu, 18 Sep 2025 05:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758173294; cv=fail; b=Rk0hWKqhbZApLvNNUdQ+H+G52LQLKRdoHE/AyFRoCxkKk6VgfkcIUk+J1ymOiiP8s1JuvzGAC8w15RYHS6G8AZ+k4fKDHMQth5nj/NvehUPRsyzkOfIHlX7HaHW3T33qMnlBVoqRRT4PimOczYvrI8mwhRdqCTeaq4dzivtELqE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758173294; c=relaxed/simple;
	bh=dlDO28B4zBdIQl3Bt70gcssL3qHwJUlio6hlwZKpW14=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=D3+c9o2EQwHMo09zOwFt6Wu5l/8ni3C015NP4CDpjEy359Ukr8XC1gM0dcYJepGMeMZKHloSkOjYX+PcDMxYRHU5myLXpO5ibOSKqb4RuNx6IfejgwbLMfdg9Ew+x6h9LUOVMuUiC+/06bHzjtMzn13lWv8xUK4QYr7b4E377dw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MhKSaKPu; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758173293; x=1789709293;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dlDO28B4zBdIQl3Bt70gcssL3qHwJUlio6hlwZKpW14=;
  b=MhKSaKPuEbVm64EAy6SQMu3LTso7Mg5nUbs4wOYynD4bX8aL6RuUwCEX
   i6R89iMClwj5+PMb+JUrfiO8YyZi7o/f0iJ1RdnOgdyjES0v6rc6rW83u
   v02RvZrTR3uGc66GK0tbgklIMW1lWiNT+v0x8xzYhbUZJusJ/meNf4/Kc
   ONT3OhR1iXLpMQozaw+Sj9wkd3r3TT7GK6LefgCAHFZXfe7Id3XI2ImsQ
   dhJ5lvrNmT+P494WzZ3LZz0t9KKicHErYA1HnUrPAorUYIo/Ly0dSx843
   Lz6XMmMNUqdJ04cPlREl4Fi6+TQfgC0JRcwx1K5CIM+7NrmAk8hy5FeBg
   g==;
X-CSE-ConnectionGUID: neMV8jSDR4GFgslxnVAdBA==
X-CSE-MsgGUID: znUR1p6IRLSPc31drKAJiA==
X-IronPort-AV: E=McAfee;i="6800,10657,11556"; a="60183786"
X-IronPort-AV: E=Sophos;i="6.18,274,1751266800"; 
   d="scan'208";a="60183786"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 22:28:12 -0700
X-CSE-ConnectionGUID: eYWNHPCOSIGu2ivGS2+J3g==
X-CSE-MsgGUID: yBY2L+fEQp6sozwe54+BwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,274,1751266800"; 
   d="scan'208";a="175035693"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 22:28:11 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 17 Sep 2025 22:28:10 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 17 Sep 2025 22:28:10 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.54) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 17 Sep 2025 22:28:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Oyxh6/sXkE+j58aQWlNsU8lGUGcftgX11wh4/48tjediXC0jAhuXxoWHAf/XJSqSTBo+NJcwBblZGxXDkVhbIPodCbC00dm0KQHAGW62CkdIYWxUGzMsurYWqh4YInRnwN+0tdIkyPvgFw/HSrarWVGBbZV6WGdU510jbXcjjZ36o8hLoteD2HAOh8mj7V3emF4ppu3H5JAvE8/dCrJXrjcHmnBAipH3sAlTeOR3YOUrFW9vGxoT7aj0Ap1Js+R4BFGLhkw/QI/0ZZYJZ37s5YFimj6izxhHcP/0EVb78oL9aYpPamN7iUwbi+fgdIKiZQgZeD8EDLX4AwBHxq9xnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZzRm8BcxP7gYf8wJd6djzeo7mRNMvgr85gjLn177q2Y=;
 b=xa+GUBexbhUGe3vUXHzFaQjLFv9eCy8nIHEVH/OYOJbJMrkB5DSivPyiE884/vowN3ZtcR2GPNBgBDajI1059iE5+ihLgykj9eEzOb+h57i5o+WoJipbZCLNx5tmWapiKbR2DreA+164kcKJSBXxbpkfpmvOAMKWhTR595vULSfJZJq4rQC408HjUmOasqkOIkB8UfB37xG5S1Qqa2BmoAi8vnt9ins44Ujh8s9ZxfMdCf67gjPdqts8uRXiAQGB37MjmiGUvP2Lzy5zSKMIguiBN9nqMGsOygB5pIPi16lDdLojKBnQjC/tX3/BJx4kZT4t5/6lXDRDyvsXrYT42Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB7703.namprd11.prod.outlook.com (2603:10b6:a03:4e6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Thu, 18 Sep
 2025 05:28:03 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 05:28:03 +0000
Message-ID: <7b1452b2-38d7-49e1-bd34-ea61eca01419@intel.com>
Date: Wed, 17 Sep 2025 22:28:00 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 05/10] fs/resctrl: Introduce interface to display
 "io_alloc" support
To: Babu Moger <babu.moger@amd.com>, <corbet@lwn.net>, <tony.luck@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <kas@kernel.org>,
	<rick.p.edgecombe@intel.com>, <akpm@linux-foundation.org>,
	<paulmck@kernel.org>, <pmladek@suse.com>,
	<pawan.kumar.gupta@linux.intel.com>, <rostedt@goodmis.org>,
	<kees@kernel.org>, <arnd@arndb.de>, <fvdl@google.com>, <seanjc@google.com>,
	<thomas.lendacky@amd.com>, <manali.shukla@amd.com>, <perry.yuan@amd.com>,
	<sohil.mehta@intel.com>, <xin@zytor.com>, <peterz@infradead.org>,
	<mario.limonciello@amd.com>, <gautham.shenoy@amd.com>, <nikunj@amd.com>,
	<dapeng1.mi@linux.intel.com>, <ak@linux.intel.com>,
	<chang.seok.bae@intel.com>, <ebiggers@google.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>
References: <cover.1756851697.git.babu.moger@amd.com>
 <5f368e4f65629c5bf377466e9004733b625c5807.1756851697.git.babu.moger@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <5f368e4f65629c5bf377466e9004733b625c5807.1756851697.git.babu.moger@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR20CA0035.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::48) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB7703:EE_
X-MS-Office365-Filtering-Correlation-Id: ceab8550-94b1-49e4-79d7-08ddf67423bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TXEzRW9DSzA0cWtlWTdFZnVuNW84VEZadjcvTTgzeU4rbEZpT0d6S2poNXdK?=
 =?utf-8?B?dWxHVktpeEVBMUR5NkpJcFFWSHlKWm9DYmZwbGNVazVzeEJGUUpQeFIyb01W?=
 =?utf-8?B?aHdaRklSQVQydmdNNlpQWncxcWkrNFluKzl2UzRDeXhmRkh1bkZnbmQ3RDN2?=
 =?utf-8?B?Q1FSS3pVVzVRUFI1bVptSkZwWmM1VjVBQk90dmhpMFlUUDBiRENJdm5STXFs?=
 =?utf-8?B?UmpUS2xPN2lsV25qc1ZmekVSdGtvdVc2M2Q0UTMwZk5kdi9xbkhGS1JEUncw?=
 =?utf-8?B?azVaa3dVejgzSDllU1JXNzRUVjk4c1BmUjJaQTFBR1R3U08wTEk2Q2Y4eHBa?=
 =?utf-8?B?ald1Q3BDL0wzd2Fvc1cyMmZPTWt3UDZ4dzBGOERBNSs3b3o2RkRqbVhRMlRR?=
 =?utf-8?B?dzRZZHY0YWNkNTNTaG45UGovaHZhdEhIb1htRDRoSnhMYk1MbzFFL3JTL21t?=
 =?utf-8?B?RUR6NFE1TFZhUW9haWYrMFNld2w3UWtodFhKeUt2b1YzMTNWQzA2azBGQWVq?=
 =?utf-8?B?ZHJReEpDWlBlSUZpaUJjVUxQSSs1SUxDRG9yU2gwaSszNnBWZTRkMkF1UlVz?=
 =?utf-8?B?WW85TDQ4YXRYN041K09DSDZwS2ZmZitkbXRXTzc1cGRsaTQ2aG9ETWJReExX?=
 =?utf-8?B?bjl4TjAvdDU1QTJ4VlkwRUtBeUk2YVFvNk1KK1BXYlFleisyNjdJckljdGJZ?=
 =?utf-8?B?VTRRSFFxaUNWSzZmZVBkR3g3bXBKZWVwWFgxS2p4MEZadnY5OEMwL3hCTmRr?=
 =?utf-8?B?aXVHOURISmVkenViaG1hdEV3bmdGSUExZy9rbjBDZ3g0L2hFSXJnL0pnNFFk?=
 =?utf-8?B?MFA3YkYrNTEwWlV4NkJ3UWp5bksvZmsyYUFFUVZnUC8vR2J6RmpCYW5DdC9u?=
 =?utf-8?B?ZnFhYkNmUFgzbVlwbm1Hb08vUC9FYzdpMG9ndXRFZWl6eXhzbUdMTmZxeG5s?=
 =?utf-8?B?VFdDYkxFQmJxb2o2MGZ3eGJ6dWI1RmxnUGtVZit2eHJtZk10ZTF3ajUzV2lq?=
 =?utf-8?B?RW5zZ1d5TFI2a0tYMkUzWkRpSEhYTGsrcFRzNEx1ODhkRzNyaU1xYkVGV3hx?=
 =?utf-8?B?Y25zVTlESng3TlczektjMDRpOEwwYktrTVY1bnRDclhPbG5iSnJEakZMMEY4?=
 =?utf-8?B?RXBKQ29IUWtBK25VQ2FuVllvWFF2OGNud0Zkd1MvSjVnZFFvVXplbzhORHlF?=
 =?utf-8?B?SWRIK2ljQkFZQnV5MU9lS1NJZjErYlgwMHhtUHZTWjYrWEJKRHM4Zk5od2hi?=
 =?utf-8?B?RXRTTklSb0FOZENQQzBxNHNqV1hnazMwRXVzekJERmNTMEN6TkxKWlBEVENu?=
 =?utf-8?B?WjlQMENFbTNESlRqQ2FFMFZqZmVoUFgza0JZeTBCMnFNUkJMVjBMZWI4dDVw?=
 =?utf-8?B?c0dMQ2lDNWJPVk5YS3dlbms3SXNMMmgxT1pGUC9UaVVlVmczUUdVRE9yNXBS?=
 =?utf-8?B?d2FucFJXbU96dEs0ZThoYWJLeW1Scm45eXFwdWdIb3ZvekJoY2pYZDRvRzlF?=
 =?utf-8?B?clRwMWMrVVJiQ1RiQlo5Wnk5Umd2RkVpK0VXK3BJaSsxZ0hhWGc1RUhNVGF0?=
 =?utf-8?B?VWhQY0c2T1pQanFKZ1lqQWRQZkF6TktxeXJyMHJGeXFRUS9UUVB0SzE1cXln?=
 =?utf-8?B?MldxbjVBNHNjUmVsOTNVYkdYN3ZJWFpHaUdabnlSanYvQkVwdm1lOWg0cFBX?=
 =?utf-8?B?MWZsSkg0U01yYTVraHZhODFTTHp0b3FVWjllei9NUktONmQxWHpIc25idzNB?=
 =?utf-8?B?V05kL09ud2lqZ1pMRHEwTFpoLzdranVQYzRwdTZmQi8wYldlWmhEa0VYMmkr?=
 =?utf-8?B?OHBFdzFZU2c4cWQrcE4vQ3pHMFN1UmxoRVhxdEdNVzZzaUc4K3JvVTV5WU4z?=
 =?utf-8?B?ejFNMzgyZlp2K2JzdzJ6MHNpN3NWOUI4STFic08rRkwyRmltWWY0RjdWcHR5?=
 =?utf-8?Q?EnMk+XaXxWA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZVJLM1JSSnhiNzVtZG4zZkZJSUlwSnJHdkdJVmQzOEttanhHN0laeDdRdUVh?=
 =?utf-8?B?bWZydDFCZEVwOFRqbkhuRUtvS0k1WUtkVVBBNldrcmNDQnlhK1NKczN5UWM1?=
 =?utf-8?B?R1pYM3RmZ3RPTVIwRXRvT0IzcUJMdXV4dWt4RHNqbjVsc1JmWWsxdS80Z3Fh?=
 =?utf-8?B?UHpaeit1MnFtVUhlY2pzbUtJdGFUQmI0cmREV0ZlYmJ5aUdmOGhQYzJKa3R4?=
 =?utf-8?B?MVZZcGw4WmhkYXdhdlBKZmRGRUtCSndGVWpSbnFvT1VSbHZPMmhGSm5NTzFK?=
 =?utf-8?B?RTJZM0FXeUk3Rm9FcUdwTXQzVEd2cFFNZnN6Q28xUWdmSmoxT2ZkK1VJTktM?=
 =?utf-8?B?UGdHUnorcVhNT1VDMnJxS3ZFZXZwaVNwZmxhRkljdVY3WDJGRUtvUitPZFhx?=
 =?utf-8?B?ZDJ1a3hUcjhZUG42Nm0rLzVML1dQUU0rMFBSVThSa1o2MThNN0pUdGR0dWZr?=
 =?utf-8?B?ZmFFeTc1U3ZVakNRblk3YjdIRE9MRzJlM2o2NGd0dHp3MFdLMHJqYnhyUWY1?=
 =?utf-8?B?VTJJc0JWQk51NmljZCtxS0xWSzBjemVldVFtenE4N1NxaE00TzZERXFVbzZ0?=
 =?utf-8?B?THQyVi81d0V2QnJhdS84YlZvOUd2S0o0WXlQMis1N0MyNEwyWWFMYWRzc3hh?=
 =?utf-8?B?ajNQUWRKWmtVcEw5V0hJVGk1S0R2dUo4V2wwV2k4ZmtPdHJpMnIrUWV1ZEV3?=
 =?utf-8?B?NHRJZXJiT3Q4RVhSRHdhOFFZck9aNG90YjJTWXpBVUVNb3BxK2s5cjAveXoz?=
 =?utf-8?B?TGJYeVIxUDFnb1BZMElOZmVENm4vT0JPQ1V6aHZhWTFYbjVEc2RWK01YRExO?=
 =?utf-8?B?R0lNRmd2RGRJc2gyT2xrYzYrdGNWZmtlajdsdjdyNVBaTDVEVDZlUWYvKy9D?=
 =?utf-8?B?VXRPdVA3T2crU1dPRlhoMFBQb2JHNm9saFNLSzJoMkxEbzNUR0VyYks5ZGZa?=
 =?utf-8?B?bllRcWVJWFdBTkE5RkFiUlUwNXVHdXlBTi9zUUtEREFqbnBrdGRCVFVxK3Yz?=
 =?utf-8?B?YWovWS9mK0dnajhOaEZYS1czYnh5dldQTVBoT0w1ZTloTWwrTDZrRUdjUVov?=
 =?utf-8?B?VGxtQXZSWk1yakhoVGxsWHVWYWxzZGY2dEJnSlZoVTkzZkVoNnI1OUdCRDgz?=
 =?utf-8?B?WXVOL2RXd3NTTlVCNVNUNFFlRjBBd0tBYWllUkV2NEwySlF6Zys0ZmMxbThU?=
 =?utf-8?B?VXgzTlRkMnRMTnFlQVFBN0NxczN2NlVkMTQvcTBJVUxHK0hlb3dVTFJyQ1p2?=
 =?utf-8?B?SFNNSWg1YjZsR2hTSDJxUHBCVlk5cE5vaGk2MFVHdzIvUGZYanhYKy9lUVY4?=
 =?utf-8?B?MFp0ZGFGZ2ZVSU5sTDhncyt4U2hzZDNFMjBTclhsZG5oRGpMTTIrMGNFRm93?=
 =?utf-8?B?MWJoL2R3dmJUdnE5VG9LWjZPU3Q2RVFwSFIyTGhMMFhudXJUYmNoTGJiV2dQ?=
 =?utf-8?B?N2o1MkJBdThuQldaak93Y0lkcGs3L3pwMWVPMVF2MUtKMTRSTzRTYVl1NkRN?=
 =?utf-8?B?dXlCYTJCQXc5aHZFd2VMYlZTZ1A4OVVtdHNhTHlOa0VSc2Nzd2VPVjZkSlZa?=
 =?utf-8?B?TnZrUkpKa20zSm1ISUg2bTU0SDd3Syt6VElJYTZPL1IwOGhGZHBiNElnbXdO?=
 =?utf-8?B?Z3dyOWlIQ0lUMitqRTNXQUhhY2V6NlltdGd6SlpMR2ZPc1hiRDNRZWQvajc4?=
 =?utf-8?B?RGtoWVYrZHlNRThUZWNadVdJcU00dGVYcjR4M0JmdXdWdWdYNFN6bVlqSGRx?=
 =?utf-8?B?bittekhLV3puVFlIV0t3WU9XVE9hSmlIQjMxcXRPN2VqeHFoWmV4L1RhUmto?=
 =?utf-8?B?aWkrRWR5ODA2ZG1UTGFOMHFoak5SQUpScGNVS1QxalR6Q1FnN3FLMFJXYlU3?=
 =?utf-8?B?TGdjc3YyVHQ0b0d0R25iVzR0R2tqK2Z5RE4xL1UwdXZFN29lTjdTdkgxaXlF?=
 =?utf-8?B?c2FJeHZrTkZ4Tk13bkRRZzROZ3VGR09KbW4yZnhGZFZVWW1qenFIV1RkYUQz?=
 =?utf-8?B?QU9qdDM5cnhqVENsU3hrYnRseGY0VGtwVGgyTjR3U0VCRWJYLy9kZDkvd2pM?=
 =?utf-8?B?bHU2MDJuSEJxV2drM3cwSUtIQVRKL1pNeWp6ZW1kaFBHYWdmU0tmZTRyQm84?=
 =?utf-8?B?NDBVZ0ZialpGNGRQYTZodDZKR1JJTUo3Nnk1TXMyYjdrbGhUc1BrSmJRRjdp?=
 =?utf-8?B?TFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ceab8550-94b1-49e4-79d7-08ddf67423bb
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 05:28:03.3733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I7o5acEsB+gwin/bFhdnT9T/7BaM7wRW2EIGx4wRwS7cwMVzBZRDEcjEMWAAYa+4vv1dssnBuf5lShlIN0f5pq2sgwNaVKV3DrwF2gOJjpo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB7703
X-OriginatorOrg: intel.com

Hi Babu,

On 9/2/25 3:41 PM, Babu Moger wrote:
> "io_alloc" feature in resctrl allows direct insertion of data from I/O
> devices into the cache.
> 
> Introduce the 'io_alloc' resctrl file to indicate the support for the
> feature.

Changelog that aims to address feeback received in ABMC series (avoid repetition
and document any non-obvious things), please feel free to improve:

	Introduce the "io_alloc" resctrl file to the "info" area of a cache
	resource, for example /sys/fs/resctrl/info/L3/io_alloc. "io_alloc"
	indicates support for the "io_alloc" feature that allows direct
	insertion of data from I/O devices into the cache.                                                         
                                                                                
	Restrict exposing support for "io_alloc" to the L3 resource that is the        
	only resource where this feature can be backed by AMD's L3 Smart Data Cache
	Injection Allocation Enforcement (SDCIAE). With that, the "io_alloc" file is only
	visible to user space if the L3 resource supports "io_alloc". Doing     
	so makes the file visible for all cache resources though, for example also L2   
	cache (if it supports cache allocation). As a consequence, add capability for
	file to report expected "enabled" and "disabled", as well as "not supported".                  


> 
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---

...

> ---
>  Documentation/filesystems/resctrl.rst | 30 +++++++++++++++++++++++++++
>  fs/resctrl/ctrlmondata.c              | 21 +++++++++++++++++++
>  fs/resctrl/internal.h                 |  5 +++++
>  fs/resctrl/rdtgroup.c                 | 24 ++++++++++++++++++++-
>  4 files changed, 79 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
> index 4866a8a4189f..89aab17b00cb 100644
> --- a/Documentation/filesystems/resctrl.rst
> +++ b/Documentation/filesystems/resctrl.rst
> @@ -136,6 +136,36 @@ related to allocation:
>  			"1":
>  			      Non-contiguous 1s value in CBM is supported.
>  
> +"io_alloc":
> +		"io_alloc" enables system software to configure the portion of
> +		the cache allocated for I/O traffic. File may only exist if the
> +		system supports this feature on some of its cache resources.
> +
> +			"disabled":
> +			      Resource supports "io_alloc" but the feature is disabled.
> +			      Portions of cache used for allocation of I/O traffic cannot
> +			      be configured.
> +			"enabled":
> +			      Portions of cache used for allocation of I/O traffic
> +			      can be configured using "io_alloc_cbm".
> +			"not supported":
> +			      Support not available for this resource.
> +

After trying to rework the changelogs I believe the portion of doc below is better suited for
the next patch that adds support for enable/disable where CLOSIDs are relevant.

> +		The underlying implementation may reduce resources available to
> +		general (CPU) cache allocation. See architecture specific notes
> +		below. Depending on usage requirements the feature can be enabled
> +		or disabled.
> +
> +		On AMD systems, io_alloc feature is supported by the L3 Smart
> +		Data Cache Injection Allocation Enforcement (SDCIAE). The CLOSID for
> +		io_alloc is the highest CLOSID supported by the resource. When
> +		io_alloc is enabled, the highest CLOSID is dedicated to io_alloc and
> +		no longer available for general (CPU) cache allocation. When CDP is
> +		enabled, io_alloc routes I/O traffic using the highest CLOSID allocated
> +		for the instruction cache (L3CODE), making this CLOSID no longer
> +		available for general (CPU) cache allocation for both the L3CODE and
> +		L3DATA resources.
> +
>  Memory bandwidth(MB) subdirectory contains the following files
>  with respect to allocation:
>  

Reinette


