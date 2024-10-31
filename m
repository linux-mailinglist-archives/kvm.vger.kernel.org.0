Return-Path: <kvm+bounces-30255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 881E49B852F
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 22:22:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8DE991C21482
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 21:22:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B16B41922F1;
	Thu, 31 Oct 2024 21:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A+8s7gxq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84D31CBE97;
	Thu, 31 Oct 2024 21:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730409718; cv=fail; b=QR3W4/1mLT5MnNDbHsTxp3Ms9suZbQU9cCj0dpjBIxFVlgSesZnjKN2khv3aJ4JQKfAtcmlHBNt/miXaaMji0F+Y11JI2CEVvF/8g/PLpSOsCXttDGTKdfAVqEOSv4IAu4FJPJNkRz+1L+ZkCBCFFJl1fzKWi6wCqyeycqHR/Jo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730409718; c=relaxed/simple;
	bh=kP801fBJbT9N16hS+kRWZuwtTjSk1UcnP6y+JuziKe8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uRoLAV0EJgHGqup6GM5TEj8IHj9q9+u6VO96cVYnlhWX32RDDcf7AOnCwfWe3p+HuDTmX5VbEVq8TNGk7mgPD/1yy4vE2/Sr88zq5CKQrN5kmpO45p93puYvEbtm7HVg+8SDhlltpESu7Db3TcW5dapJ4Pc8+9essUoTB7jxCLA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A+8s7gxq; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730409714; x=1761945714;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kP801fBJbT9N16hS+kRWZuwtTjSk1UcnP6y+JuziKe8=;
  b=A+8s7gxq71fawZ2xcL9BhjVt13BK7SSqgQUAWhMTlwbOvkL2W8xlqoks
   Ad+A0j1jJjksCyJPtN5+5fBWECHak8jJQB0c61JUbb+JQb9qOypT6FRFk
   3v0HwbCi09tdYRjYLfqcHfv0kuK8RqhTdd6LEkCbvfB3Ujc/+Hvcj4010
   WLGrV57WceT3umTo7o5pBrGl/1J6gXd6OfgxA5IPIzlkr+5UL5eiDI3IO
   nBLhWP9XE9ORV4l/A+4Cj6ad9OOU+rowkw1jOSaTmC/7NDdJR79E6u4tM
   fiZTe8OYJJXh6BSZFzOLbzqQwAeGp4IFaXpymwqaGKbrFzjUiKTHx4YaE
   Q==;
X-CSE-ConnectionGUID: 8pmjSCP0QwaZ2MczrnXDaQ==
X-CSE-MsgGUID: O5fxwtaDT72SGaBJ+M8APA==
X-IronPort-AV: E=McAfee;i="6700,10204,11242"; a="30288335"
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="30288335"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 14:21:50 -0700
X-CSE-ConnectionGUID: vXnmNIo1Qvm8o7r0B9GOgg==
X-CSE-MsgGUID: w0yqLm8SS+y6gyGuxb1xUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="82917608"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Oct 2024 14:21:49 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 31 Oct 2024 14:21:48 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 31 Oct 2024 14:21:48 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 31 Oct 2024 14:21:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IbWvTJSIhra5yQY6XjVulvUrot7b7J0jOmxFUQGUE8hEO6PnXx5XFwBrfpMrpKgytb6LUhXwpe1l4bC7WKqntZb8PsJQBmS4zMVXfdt1NsGndoE9MZEjFyls3nwkX56ZB7/lkbGg2M48TZA42EcWPPt/DbAnMNjQIU+Yg2WOYuhHdn0xTmbQ6a8Q4e1GDL2hMQGIFn1uBx4HMfA4HJ52XHJe1wFvmC9lsqD/BsIwLpElBCChIIuCEyxHIlBT12N+/MdEGRMtRlk1vsneGQwJt+sbv2sGR3xbcp0FAcxbpsNFNyhRrbIps31dNMtDG3Z2cgqQZgP6Y3VxtF7qHFLe2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kn8K4FbLJKLSF33Tyh4Ww5S2TDURsAyLrBDYm7wA3BI=;
 b=HXQNepCSMilq8reyFh3/vH4CnFkAOhYlxqseg9Z/SivWFv+y/H2quVDPUVJ2r2uc7XJAmFeJEfaWWFH9OcDpOhZ7ahhRkuBp9A/Y5uUd23girJMuUZGaRxoW3Dw1KJxL1jXAQ/+N1yC1bu0G55+cMpUBGVS1foBb2Nza3wApkdcBSnuahk1Y6dyTbR/taCAbiaFHSpHqdRhpq0gdcr8vbC9f3o/Cfa5v8FCLWLAMdbbEIm8OpxXr8Tzz4T/okRz1Ew1TQPjHeYKq0W0Tz8RiG4e4Ie3e8hqSjbpC9exCe3dcvVD/fqNx0Xau6qVMN1ReLcEVJnCRbU5S+Iz0LwYWAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB5221.namprd11.prod.outlook.com (2603:10b6:208:310::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.20; Thu, 31 Oct
 2024 21:21:45 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8093.027; Thu, 31 Oct 2024
 21:21:45 +0000
Message-ID: <2f56b5c7-f722-450b-9da8-1362700b77ef@intel.com>
Date: Fri, 1 Nov 2024 10:21:36 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] KVM: VMX: Initialize TDX during KVM module load
To: Sean Christopherson <seanjc@google.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "Lindgren, Tony" <tony.lindgren@intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"Li, Xiaoyao" <Xiaoyao.Li@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Hunter, Adrian" <adrian.hunter@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kristen@linux.intel.com"
	<kristen@linux.intel.com>
References: <cover.1730120881.git.kai.huang@intel.com>
 <f7394b88a22e52774f23854950d45c1bfeafe42c.1730120881.git.kai.huang@intel.com>
 <ZyJOiPQnBz31qLZ7@google.com>
 <46ea74bcd8eebe241a143e9280c65ca33cb8dcce.camel@intel.com>
 <ZyPnC3K9hjjKAWCM@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <ZyPnC3K9hjjKAWCM@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY1P220CA0010.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::12) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|BL1PR11MB5221:EE_
X-MS-Office365-Filtering-Correlation-Id: 21fb9f95-1474-4ac4-fe5c-08dcf9f20599
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZHNjb3o1T0c4NzRTTGxRL0FkSkJqMDBvUitXd1htU0lOWjlZMDhhQ3lyaW5k?=
 =?utf-8?B?M1Z2TzdWOXJHYWNBZUsvcitOV3F2U3A5bjFEd0FFNm5ZUUUvT0paclZIWTZm?=
 =?utf-8?B?K01VZllXT3djZi95UEtjcGtNdUJSK004QkwxdCtqRHlWbGhMZUl1alE4MkNM?=
 =?utf-8?B?eTdIc3U2Vi8wSGRPeUtic0Z1T2dIMHNsU09BcEpjY2YvWTZQYTE4RzcyMnFT?=
 =?utf-8?B?WmloSityU2dyTWFEV1hXZHgvdUxxQ0w5ZnVWU2xhemR5OFNCUTgvWjhzTUtj?=
 =?utf-8?B?ZER2Q1VwWnY1MjJJL3phb2pCZmlWTy9nUWZYVUdYYjZuTjlLblRpM2NrZ3h5?=
 =?utf-8?B?OVNMWXhkem16TkFTUFlUNnZYMm9DWUlubmJRTERoTzZzdjVGUW9BZjlySU94?=
 =?utf-8?B?S21wRTZUME9oMERSbjVBODV4TmtsTFpLdVBVc1U1V3pvUTRJa0k3eTNZbnhD?=
 =?utf-8?B?OVZPL2Jtb3M4bC9iZXN3ZzA1MzNVdG5aeU0vK2hhUTBFa1VRRm04R3E0OGJK?=
 =?utf-8?B?a0ZmSTNVZ01sclZldk0yeGFWZFMyZHg2TEYrUjgzQmszU2gxeVRhQW41SC9O?=
 =?utf-8?B?YnZOSUkyZTYxdWhPcHlPZkRlaTJYcGtOQnRqOWZQRzhXMmhNRWxaWEZ3MS9m?=
 =?utf-8?B?U0V2TTBsVHIvdWpiNllLR0ZHMVl1UFMrcURyUEI0eG1zdisyWFF3U3E5RUZr?=
 =?utf-8?B?UFcyMUFuRWxWUzJMWXNPOXUzMXNpSmh1alFENHJnOVFYN3h1dktUaCthTWE5?=
 =?utf-8?B?cnRWTHVoc2ovMEJwY1Bld0FyeTdSVU1ZRFFxblFvWDlQL0tJa2lOQWJ1NEth?=
 =?utf-8?B?UXZhbXBrbWU4UnBaYkhNWGZnZEhUaXdqQ3hiSkFUVnVIWkRQNjR3WFNOakRW?=
 =?utf-8?B?S2t2ajdTakdnRFcyWUp4TlRXb3dIUWdQMGlxU295VFlMcVpsUDZWdDdCTGZX?=
 =?utf-8?B?WlkySHJuOW1NR1U0ditFUE5xUVVMYnBIMEcrVzMxL2F3cHF5YXIvVWhXZmtL?=
 =?utf-8?B?TDV0dTJGOEFOOE50cGNPKzJtWmRGVkNkMVNVWVVkTlF0WXhwSXdDU21RMno2?=
 =?utf-8?B?bjFSOUVEbldWTHhBTjFFNFN3U25IZVcvOWxHZGZ3enZwNFlIZ2pqaTFLRFJQ?=
 =?utf-8?B?VDk0eG83M0w3Vk5CM2ZmTVpHWEFJK3BhMFhRcXorV2prSmxia0hMbEVvRWRK?=
 =?utf-8?B?a1gzc1l5WU50c2V3b29pS1hQSytZMndNVW4ybTBRWC9HTEp4MTd1WDV0WnU3?=
 =?utf-8?B?VmpQL0xZYWJoRDU2NGNYM050dnFVVWVZenVRVlJzVFBhMWwzTlozaGVYYTFn?=
 =?utf-8?B?enVTTDZMYmdwcjBpaENEMS94ODVma3NMWXNpQW9Gbk5wR0FnSDE5S00yUmJV?=
 =?utf-8?B?M24xdUlGbUxMMkorODBEYnYrN1BqckhoZEJjZytDdFZDek9WU0tXSUplMmtJ?=
 =?utf-8?B?WlFkUHdsaTA3UU5JZFlUb3h1ZEdsVUFndkx6SHdJUXhqMThNMS91cVZLbjBn?=
 =?utf-8?B?bm00MktDcjZNNW1rT2dKNm8zZ0Z4UzdBZ3pCdkNWV21qWkU4WjV3WGo5TW9w?=
 =?utf-8?B?eWpPZWJSRS96d3lValp2YjdySklqMENpckx1R1YzUVVtMVBXZzVyejRoOGYy?=
 =?utf-8?B?c2l2ek9kOE5mZlNtRVYwZlRMaG1JK1E5YkFQWlBtOURsYTVtSW1PODFYRndF?=
 =?utf-8?B?QklQcUtCOUhwdWNtZWljdExmcVd0ZnFEL0VUdXZJWWhDZ3FxVUc4WTc5L00x?=
 =?utf-8?Q?9JGqE7c+L+YS23qqeYxk0C5G0gjhY1cCSdPfgdD?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RDVRblZiUVFCMk1tWjFYUlRibXpUZkhhSUFIQ3NkZ3c2QUk3aVhRamYvU09i?=
 =?utf-8?B?aDBUVllYaW9ydmtaRGxzYThiV0dRUTdZT1NCQWMxQy94YzV4Vjk1QkdiY2VJ?=
 =?utf-8?B?dGhndUxQbTdvL1IxR1Z1bE1aRjgyRk5RSnh2RlZka2NSY1lBSjhZVG1lcVZ3?=
 =?utf-8?B?cndwL2hpZGsxVkRFTElOTGlCMDN6SGwvUWYrODU3QzRBMExOL1ZiV2RpMVFL?=
 =?utf-8?B?MkYyTHhYWHhNaEp1Z1NqVlplQVpUT1QrWnNyQWxjUFM1RDVhTU9aeHNTWURG?=
 =?utf-8?B?MFZ0YUFNN2lwMGgxbGZCeVBMYzdBVGFCWFVwNUVOakwzV1cra2NMQ2owRGl3?=
 =?utf-8?B?UEhEaklYRGYxazkzVkhMTUhITTVxMjh0K2kyZ0R2Y3FGVzJaVFhid3dMZDY3?=
 =?utf-8?B?QUNDMjM4Z3ZuVnpMTWZ4ZS9yNUNIT2g0eHFhemFSdDhDK0ZRS1ZCTmRmbUdI?=
 =?utf-8?B?UFk0STV5VzZrRG1UVlZ1eHE3V1A5V0JGTUFZVVJ6UGdzaThvWnZKODRQSGEz?=
 =?utf-8?B?S1VaWUNRRHdPYzQwbmNPNVFseEVESnB6cHZIdzNhdDVwTmpONkRJR2Q3VlJw?=
 =?utf-8?B?b05QOFdjTU9nVDJuamxubXlHT2c3T3h1RElxZTRjSnhJcEQ3S1RBQjBqczFv?=
 =?utf-8?B?bHNlWllZa21qeGNQdHNwQ0hnWTBqRENOb3RlYjZyamp0OU9hU2dZNXVhZ1Rr?=
 =?utf-8?B?RnNTcWREd0FUSFpoaUdVZU1kNUFsUjZVSTVBUHVjWHVnR1dYUURXc01qQlBR?=
 =?utf-8?B?eS9pOGZiQ0Q5KzFSanJYaXgxYXh5Y2h2YTZGUzhuSDVKQXBIMzljVGo4THdp?=
 =?utf-8?B?YU1qNFRyYWxCbGlqaTRrZGRUK2U3VWcxY21DQUo5b2F6ZDl5ZWZJZC9zbkdW?=
 =?utf-8?B?dmtQdjlMUVpPWEpUQ0ppZSt1NzNXRkRtSVhEelh4aG1HOG5kWkhjbUdUd0Fw?=
 =?utf-8?B?d045eVdhZlJLR3kzd1U3NHNEVzZ3bDdRdDZmMUo5OUlxeDZQMlkzT3RvNnYy?=
 =?utf-8?B?MC9XYXJyTGRLOXZFK0xDc3FFYytLbjI4MUVWRHYydXYvc09LdG1oQ0Fxei9y?=
 =?utf-8?B?a0RUeUVGeVVpTzZPYXRQbnRVZlltQy8rTDIxTkR4T0FxTGZ5RVE3azJoV2RK?=
 =?utf-8?B?blNkTlVQTVBkQ013bit6Z3hxbmI5a2xWb1NaYXBFejR0QWlWeUFJVmh6Wldn?=
 =?utf-8?B?cVBaZHhaTHBEUlRZb3UxN0VMejZTR281VW5XTVlyZlp2U0lnc01mNnNoR1J5?=
 =?utf-8?B?WHpKZEZpZzJSdGh2OWwwT21McTlqaWRtaFRRa2dwZkgzYzB5VkkvWkh3dnB4?=
 =?utf-8?B?T2hudjFaS2ErNnl5N2w5MkVRamZPNGcxeEJrc3ZieFp6RENEdnFQTFdEaVZT?=
 =?utf-8?B?czlnbGRDMXQwWmZVZThiNW84RlRhU1BqWDc0RW9zdFY4TnFBVC9tQ2ZGZjFS?=
 =?utf-8?B?Qk1Ea2hoQUsrb2MwbVdjcUhaMHdQaGdWdS9GZVIzTEk4RExUMXFQSTV6K1BE?=
 =?utf-8?B?T0cwMlNGaEltM2llZW9RejZtUmVoSlJkRGlFU1lidEJYaFRmaUdoK21uYkNC?=
 =?utf-8?B?VXVyMXRZc0VtUG5QRW93eDhSa21Tc0F0UVl1UmRVbkVBcFZIMHgrMERPVHE1?=
 =?utf-8?B?aFZ2NW5BR3JHYlVRRDVVZUh0WXoyWm1YazZSM1NsN0xHMlpreTdjWmNDV1pk?=
 =?utf-8?B?VENLZUhzcXJyNmxmZHdMZjU4TEU5UVd3L3g1NSs3cDBHd2xVazBwa281MlJR?=
 =?utf-8?B?c296bjRWbThlODdETm9Nb1VNLzNGU0hpZnZVaXNBMXMvOStkMjFKUXM0SnhU?=
 =?utf-8?B?eUE5cFo3T3JIQ3FTeG5wTWVXa1ZVd1Q2YVk1NGJra002QWM0ZzMzOUZCZitW?=
 =?utf-8?B?M3VHOVpUZ0V1RWVkTkRyRHF3eG9PYW1NTUUzTUtabkV3SmpUMzgzQ1pUYnlR?=
 =?utf-8?B?WXBOOTZUZkhxeklrNzBlT1dUMWdSK01QWXRTdlZFa3dYSWRrZ3cwRkd3bmtq?=
 =?utf-8?B?bS9SQi9DRWJmUndyeEdxQWFkNUpWKzFKbVBPWEdzR2FWMUZFT2FEbW1HVEx0?=
 =?utf-8?B?eDJKSGtRM1NYdmZNUnE2TkY4cG95Wm5kZlhSYjU4UWQ5enIxMlRwcGtlOTFW?=
 =?utf-8?Q?JMYPwLs09TrqHzrVMRxWcLAy5?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 21fb9f95-1474-4ac4-fe5c-08dcf9f20599
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2024 21:21:45.3245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C8e/dOYpRCKkkCQW38Nbd/dxq1srz8H47oGOND9LPDvj60fh5u1mV7q51IfdaVdXyN8I4QiS/yiMyd+veauE9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5221
X-OriginatorOrg: intel.com



On 1/11/2024 9:22 am, Sean Christopherson wrote:
> On Thu, Oct 31, 2024, Kai Huang wrote:
>> On Wed, 2024-10-30 at 08:19 -0700, Sean Christopherson wrote:
>>>> +void __init tdx_bringup(void)
>>>> +{
>>>> +	enable_tdx = enable_tdx && !__tdx_bringup();
>>>
>>> Ah.  I don't love this approach because it mixes "failure" due to an unsupported
>>> configuration, with failure due to unexpected issues.  E.g. if enabling virtualization
>>> fails, loading KVM-the-module absolutely should fail too, not simply disable TDX.
>>
>> Thanks for the comments.
>>
>> I see your point.  However for "enabling virtualization failure" kvm_init() will
>> also try to do (default behaviour), so if it fails it will result in module
>> loading failure eventually.  So while I guess it would be slightly better to
>> make module loading fail if "enabling virtualization fails" in TDX, it is a nit
>> issue to me.
>>
>> I think "enabling virtualization failure" is the only "unexpected issue" that
>> should result in module loading failure.  For any other TDX-specific
>> initialization failure (e.g., any memory allocation in future patches) it's
>> better to only disable TDX.
> 
> I disagree.  The platform owner wants TDX to be enabled, KVM shouldn't silently
> disable TDX because of a transient, unrelated failure.
> 
> If TDX _can't_ be supported, e.g. because EPT or MMIO SPTE caching was explicitly
> disable, then that's different.  And that's the general pattern throughout KVM.
> If a requested feature isn't supported, then KVM continues on updates the module
> param accordingly.  But if something outright fails during setup, KVM aborts the
> entire sequence.
> 
>> So I can change to "make loading KVM-the-module fail if enabling virtualization
>> fails in TDX", but I want to confirm this is what you want?
> 
> I would prefer the logic to be: reject loading kvm-intel.ko if an operation that
> would normally succeed, fails.

OK will change to what you suggested.  I'll need to take a deeper look 
though since later patches will add more checks.

Thanks for the comments!


