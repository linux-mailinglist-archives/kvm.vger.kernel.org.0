Return-Path: <kvm+bounces-18522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 99A988D5E36
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 11:28:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4FDEC286362
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 09:28:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1889281724;
	Fri, 31 May 2024 09:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W9q0z7oR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD00F78C92
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 09:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717147679; cv=fail; b=uBnagLzXTKcKhgqfNgjlsM5jkUhJUXMWHsHqWXzd4SfcxONzq3AUGUIy4BGv3cRl1qyvmk19NBHT0L8GTC9rQHwfFjnhdFpzawvDiiIYVI+H62TsL4jXpbjVAxdS/hWersnC+faT0EMJioo0B5cuppoHZianxoVfmMD63LbmsYk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717147679; c=relaxed/simple;
	bh=6JklTK6qjAIanYusm7JukOE1fj0NGatO39FaO9NYIC0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Hprtm4+x+cjHzx9cOXzd8NyxAbI01ccQ85/x2x8MAn0V+l9qd2q3JuM5IEXdUU59gMDT5AMCKx/iN54JjAiz71hEHSNn0AWTxRYdiNx95Wab9DLN4VzLYuXPGyIvKO6Ea92gcXxz0ErTFWKL4tZhTxM63y6F9nYR+0jerhITJZs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W9q0z7oR; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717147678; x=1748683678;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6JklTK6qjAIanYusm7JukOE1fj0NGatO39FaO9NYIC0=;
  b=W9q0z7oRGCO6anXV7X6hAFapFBWvmh7lZlyVLNZWQyESqGa9rJxaiL3R
   zAdXDSlLZJHBd43nHSXAoSDyeb2dLY1bGMRyS+ExFVF6xL55mj6clBBbJ
   WmI/54hncqD75hlIcAQPp823IXhJu91h/KgjDjVvpkdEg00+t05qKqBrM
   6PHCJzz56Zr0Bafr3vGMPW1mCOMtAw4A01U+un/pw3FhHTHmLpYKHy2Bi
   zzr5OjIZ82BwsekiY5Ppt9kDQOMLHL4gQtcyvu3UyyJaQ8E2X5b+K68zp
   +1nvPm5v1mGrbUfUawlK4/WUcQ64bLIAbaIFAGP3pMHfmVfg/FLriEuum
   A==;
X-CSE-ConnectionGUID: 7Ij84BwcSbWa2VeBbbYSRQ==
X-CSE-MsgGUID: XZwdndImTduqMCUdZWjmWA==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="39076032"
X-IronPort-AV: E=Sophos;i="6.08,203,1712646000"; 
   d="scan'208";a="39076032"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 02:27:57 -0700
X-CSE-ConnectionGUID: RIB5R5a0TzmLzlDO7nNJig==
X-CSE-MsgGUID: ievPNq6WQP2ODM9aaVeI9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,203,1712646000"; 
   d="scan'208";a="36193260"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 May 2024 02:27:57 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 31 May 2024 02:27:56 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 31 May 2024 02:27:56 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 31 May 2024 02:27:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nQLsu7ul83sa42zhv6fduLy8AxaLZcADjqtfi6qA6sT+N5CH9Z+MKDSt6JOGus9HjDXCemix+WLl0+frn5WirIpW4Co76kLLNDpiUyuxrKRHLIblVOFuWy6pEOYhUe+2/2W3vIBUAJN9imuy5Kn9MWG6zlJRhBFqi+DG2KOMS0KKWz9v4NEa3iMoWLGGH1dM4Z5BMGoK9hwwhe2xFK+m+r7gcxZXexCCEXLyRgFYAM9K2uCqQFX8VyNcXwnr1rNxyVJx9q1znJRVCZnjMu9xekgm1qyXtXNt6pDu+JWv3Ty/dleJqi8KqRBMk+pa+6fmoY2/+cjC/g6u3P5e7lHilw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aWwyOZi/E1UkOe/y1n/kEHYr24gCZPMNuo4j5olHNmw=;
 b=CQr7zlsK/7I+eOWoGBsiK6spvL5y3VlQRPe8FNmScb2VhPArxx+kUdzGbjG5QQyw4fUNGWOUWEhBxo3qC+WP4muK8j5/lH8uoamwQ1w6aW37sj4BaORQ3LcOJwI/qdveC4UA/0lxwh/vGH4sRZOTLtnrS3MEAeAuhdUaZGph2Mme66cYDik0eaapaN9KCMjFCjUaa+KazFHjIZgRzZ3/EPOWVvadMqOJP2dClgWXHffSSsssFhaUNX3ClpXS6AA+8OJafzsxptIcRxgIX/0Y3eDdcE+KVrk8IhPR6BWq9fOnTQz7dybLEveH2OGG8Io2X3sx+ARt290QqLk0AJrtFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ0PR11MB6744.namprd11.prod.outlook.com (2603:10b6:a03:47d::10)
 by MN0PR11MB5987.namprd11.prod.outlook.com (2603:10b6:208:372::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.19; Fri, 31 May
 2024 09:27:54 +0000
Received: from SJ0PR11MB6744.namprd11.prod.outlook.com
 ([fe80::fe49:d628:48b1:6091]) by SJ0PR11MB6744.namprd11.prod.outlook.com
 ([fe80::fe49:d628:48b1:6091%7]) with mapi id 15.20.7633.021; Fri, 31 May 2024
 09:27:54 +0000
Message-ID: <59fec569-95e1-9024-77fb-b6d2f89b3951@intel.com>
Date: Fri, 31 May 2024 17:27:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH v5 18/65] i386/tdx: Make Intel-PT unsupported for TD guest
Content-Language: en-US
To: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>, Marcel Apfelbaum
	<marcel.apfelbaum@gmail.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?=
	<philmd@linaro.org>, Yanan Wang <wangyanan55@huawei.com>, "Michael S.
 Tsirkin" <mst@redhat.com>, Richard Henderson <richard.henderson@linaro.org>,
	Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>, Cornelia Huck
	<cohuck@redhat.com>, =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?=
	<berrange@redhat.com>, Eric Blake <eblake@redhat.com>, Markus Armbruster
	<armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>, Michael Roth
	<michael.roth@amd.com>, Claudio Fontana <cfontana@suse.de>, Gerd Hoffmann
	<kraxel@redhat.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, Chenyi Qiang
	<chenyi.qiang@intel.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
 <20240229063726.610065-19-xiaoyao.li@intel.com>
From: "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
In-Reply-To: <20240229063726.610065-19-xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0114.apcprd02.prod.outlook.com
 (2603:1096:4:92::30) To SJ0PR11MB6744.namprd11.prod.outlook.com
 (2603:10b6:a03:47d::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB6744:EE_|MN0PR11MB5987:EE_
X-MS-Office365-Filtering-Correlation-Id: 798b0415-873c-42fc-e876-08dc8153f34c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|7416005|366007|1800799015|921011;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YU92cUFXWi9OUGExRDdGNzlqaVFhUWNnb3RIM1hBNlVidUpPNFMyMStxN1pN?=
 =?utf-8?B?UXpzSk45RmQrSVBuUTMvZDJsdHM0YllLT0Y4OEVNMGpGYXNYS282bTRBYW5y?=
 =?utf-8?B?U3UwTmc1Q3pVYmQxUFFRZUxJdzhXeENMa1ViL2d4MlBub2haN3ovTFB3eFJs?=
 =?utf-8?B?dGsvRFU1YWJmOHdia0Q4Q3ZuTFFEVTV1NkYxYUpsaktSU3BxVU0zUHpJRVVr?=
 =?utf-8?B?aEUxcEcwR2hpU2tyZUdIUDZSWVp1TEQ4YUgyTWw0T0NLbnhtckVnaXBDT1Ev?=
 =?utf-8?B?dlk0R1JNbFkveS82amxTZ002elVkUTgrenpFNDY0L0xCVzJpSFhDRGh2d2tt?=
 =?utf-8?B?WFhjd2VSU2N1bXFsb1B4bXhScGh1dTdKVjJpZUlHTVJ6NnhrOGxpcTZ0eVBS?=
 =?utf-8?B?UnAyb0pkTUMrTTVFeDduZkloeWY2WXBBS1JkUkhQRkF2bldKR1Vvb0RHbDJM?=
 =?utf-8?B?Ni9tWEJ6eENrMCsvQXo2dGVNaDlmWCszbnV5d1AxRXBQYkdLYU12SU0vVkZn?=
 =?utf-8?B?M1JodmFXT2NGbG41YUJpNVg2Z1NUODIvMXFMK3ZQZVRBczBqdFdUUnVaeUdZ?=
 =?utf-8?B?T29uOHFkYkVUUUhDNFFqUjdkbE5Ra0k4Sk1RbXBVZWNhR0RtTXBJdWR4eVBq?=
 =?utf-8?B?NHVhK29JaFREdkh0THd2dHZ4ZHVLZy83dFh5YXUxa2V2TC9JSHdKSTlwUkVu?=
 =?utf-8?B?RUVoeVhiUnpvUWJqL0lEMHE1TDB5ZnBEcHp0Zk1IS2pyL3RSSUk2alBZT1Bw?=
 =?utf-8?B?U3ZMcmRJejlETk8xUlh3UWY3aUF3ZUdLRXlLV2x1UklUeDRLRE5WY0ZVMU11?=
 =?utf-8?B?ZzE0Z0hBWE5BMGFnZUNXKzdkLy95ODNrdVRnL2tNRW4wVmM5NzFCVk8xYUc1?=
 =?utf-8?B?YzJDQ1BZODB6NHpwRnJLR20xZEcvaEJoenkyWkpJckFPdXNxcU1Ga0ZEYytC?=
 =?utf-8?B?QXhXV2E3NW0vSHk1SGY5aERUckN3T0xobHExWmxmNnZyWkRuOUZzWlRsbVUx?=
 =?utf-8?B?bVNoREhLcmZQVVlPODVZQ0tKV0UyWVVaMGNiSTQyajc4UzQ4NXM0S2Z6eS9l?=
 =?utf-8?B?Y2pWYk5yRVA5U0J0d3dqNms4VFFEaC96V1N5a1AvaDVaNno0bnlHTmlXQldI?=
 =?utf-8?B?d1RNcVQzZ2twVlB3S3k3dElLdnpaU2ZtNExPYnNRZzlzOE9NTXBwRDZDanlr?=
 =?utf-8?B?UDlocE51TVdwT2pyMWVidFdKZkRBR083c1paQXBYUC9MRHhVdXE2Yy9hNTN6?=
 =?utf-8?B?clBHTUtFN05PbGdWSGxpSTU5SENEZGlkUGE4cTd2WlVCSzNBNjU5VEJVUXpF?=
 =?utf-8?B?MGFubkw3RnFaOEd5QVlXcFZwTUoxOTRldjM5eEpKalV6VmhXcU5QVHJqUExK?=
 =?utf-8?B?MUQ2WGp1bjlrcXk3SllIZW55MHJXSWl2VGsrNlU1M2FZR1BSREtwVDJVRjNV?=
 =?utf-8?B?YWtrcEhxNFpkQmJlOWxLVFRoUi9TUE42RFZzaG5DeVFtNGwycTBnaWo4QlZn?=
 =?utf-8?B?Zm5YVjd0TU1BSzRIcnBkRHhLMUNvZmJ0NlVPT054dFFRWGlUZ0JPR054QXZ5?=
 =?utf-8?B?bldqUnFjT1BRRHFyK1plTDdYdy9OZTY3OVhpVUFXTk9YNTRQeDN1elJqVkJu?=
 =?utf-8?B?U21yWWZ0MmdRRFJwT3JxdURRaVRpakJOWjk4b1FXQlVVM0NwcWtjWnltZm5l?=
 =?utf-8?B?eFNKbkR4ZnhPQ2Z4WmxiaW1DYUVDK0VoU01FdHNGOHlnaTdTY2xoblR3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB6744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(366007)(1800799015)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RkQ0TUdXY0F3RmlrWCtSMFByVnNPV2xqbUhzN1hkYXFYRkh4dXRYeDV0M25P?=
 =?utf-8?B?a0JaSWpha1pjb05ZUU1FZXI4OUhzZjgrc010RFdoQWc3aVJBd2tFOXFVV1Z6?=
 =?utf-8?B?M01qK3VGT2FyYlJuekpRaDcxU1dEMHdic3hqV0F0OHN5dzZFR1BQaU5nc3Uy?=
 =?utf-8?B?ZEMxakNTTUJCell2alBCRjh0dXUzN1MwR2NtZk9iWW5jVlJqQXBjMVdDY1Ni?=
 =?utf-8?B?Zk5CNE54YWp5Yzh2azZUNS9Ea0VBVitXVkY4aUFKWFlkMmtZVmlCWEpuN1l2?=
 =?utf-8?B?d0JGQ3pZbXQwS3hhK3R0RkNiZnJUZ0tmT1h6Y2xSZy9WRzhVQUwxZHhySU1z?=
 =?utf-8?B?SzJXWE52ME41WEZKelBNK1pCMVRYNDRkd1BCa0thMVNYN0pNU3ZwM1d3TkRv?=
 =?utf-8?B?QVJTbFBweEZjZDZWYnJQRnNzeGpYNDNLaVF6dlloZy9hMnFaTnVZaWF2KzJV?=
 =?utf-8?B?MmpTQXBXdUlrZXdLa0pHaldpMlVQTnRHeisvT2gremtsNVFYbzhNOXhCKzVC?=
 =?utf-8?B?U0h3bXp2OXdzcS9lbXFCNGtONHlTcUYydS9tL1UrK04ycGlUallhLzVtUVA4?=
 =?utf-8?B?TDNwcWprQW9meHFUZnI1bWJtNHJSeUkzRk41Sm1BMVhLVWpWWmlUa1VFRERF?=
 =?utf-8?B?LzAzZ2xTVGZrNjMyNTR2S0MxMHVmT2ZuWHN2K1FGamoyc256VDdDNkd1VVNG?=
 =?utf-8?B?T2d4TWxZeFJsTnYrUXJoMnZocXpFU3NKanQ3SVkzNkorWlRjWlNVVHpGSmhT?=
 =?utf-8?B?ajlzMlZUb1ZRRmtYSHFXTlY0TUNQZUNNSUZ3Z0xwdWtOemtNUUZLOEZKU1NH?=
 =?utf-8?B?a2lURzlHejhyYmlXTlhQbjB6b0JSTzRDN2hDdlJWRUlOWXhPUUx6enpuazY4?=
 =?utf-8?B?OW5CU29Hamc2L0RvaXEzNGJUcThxVFNSSmlCM1R0cGRaM3Z4azRvbmZ3dUl4?=
 =?utf-8?B?OWJKSlduNnlyRmlUd1dKTVNhWENEaVFxYTNzUDBic1VTVkE1Qks2cUdtancr?=
 =?utf-8?B?cHFtRjJ5Vm9WazBOSUdJZ3p0MW12M1ViUmxtWWVsTHZTMUxzd1VwM3QzSWtG?=
 =?utf-8?B?ajR0dlZFRVdOQndtMkVDcHpSTWhOWE5rSjBJVFF4ZFhyQW1VY3hsN0ZXeEd1?=
 =?utf-8?B?ck45UTBpcWc2ZnBJckIyVjd3dWwwVU1RY2dTTXNFYTZ3cEg1cnRRMWJtdHJH?=
 =?utf-8?B?YVBucStsVFlSM1c5RmtnUndMNTd3UGwxOS9kNDJJYmtHckJSdVFoSDhQMDl2?=
 =?utf-8?B?cHNoY09oVDErMGRMa0Y4WFpubGFUN0Y1My9ZRlVsWm03VFlKTTBmQ1Vyb2Z2?=
 =?utf-8?B?N1NMTms1N2piNjd4SzZrdGM3VEZUOCtwVnRNdDdtN2dxYzcyckRpcHlGT25U?=
 =?utf-8?B?SWZpR0ZJb1Y3VDQ5c2RndStqb2luUSsvN3NxUDBQMU16dzFlc0M3ZUR3RUN1?=
 =?utf-8?B?cnpaMURJOENMcDJHR1ErRU1UeGxnaEZ2YUxUNUIxcUdQRVcxeGp0SlZ4SnZG?=
 =?utf-8?B?aE1XcEkwKzZ5VkFBZHVKd1pybFM3OTdnTE9CWnBvT0hsNnRFVHMvZ2RxbzVs?=
 =?utf-8?B?d3VmSjZSSlRYMEpWQ1E3cjBvS2FBVGxONGRkODg5MVZDWjE0ZnVCRzZBMlNt?=
 =?utf-8?B?WTc4dEFjbVhVdmxyQ3dhRlcyVkNzSWs1U0Q1ME92L3hoK2R3SXZIRGdua2wx?=
 =?utf-8?B?NDV1elZMMjdMNnBRcXl5VmlrZ2htUjUwZkZsNUNUbWdHTFRacStIQUdKZ3ZJ?=
 =?utf-8?B?OHRtQWlsem16cEFWeTZVcGRITTBJN0NBMjJuUEFHV2pSelg0d3BtNG1LNUJX?=
 =?utf-8?B?cVNaNVloa1V4eWJ3QnY1S0RxZm4yUzlDNmsxc1NScGlTOEJTdU95RnB3SmhV?=
 =?utf-8?B?Z25EVldLVzBSWFhtVWNtODA2bHFVZFErNmlHOElUM2pZblhVbGpwK3JWTjNY?=
 =?utf-8?B?WnE5M2JPMWI1NGFqVjJ1R3B1YmdFMzNldWtXcG92eVdtcGRtclE3d05nQXJP?=
 =?utf-8?B?WmxSM3JuVTVGZENPQmE2SWR0ZkZuZlN1NmhjTUU2bWpma0VDbTM2bjBydi9j?=
 =?utf-8?B?K3VQZ2N5cFZkTDU2Y2FDci9xWEJZb2RqMkN1K2srZDZYM0c2REVuTjgwa1dQ?=
 =?utf-8?B?cEE4bHZpVVgrSEN0VndIbmNWMFhtcDZ6bWRTN3YyT1VNWjN1M25yVEtyZ1FJ?=
 =?utf-8?B?YVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 798b0415-873c-42fc-e876-08dc8153f34c
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB6744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 09:27:54.6398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: unYzWxG5WJRirpH0bbsWs11ML6D5us85cPoFyUbn5Nl5lW9Yf746KLPYkKApvB/OyGu5j4jwbV0IP07VerEzSIMcCeaDm0zXOMXHf40ssVY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB5987
X-OriginatorOrg: intel.com


On 2/29/2024 2:36 PM, Xiaoyao Li wrote:
> Due to the fact that Intel-PT virtualization support has been broken in
> QEMU since Sapphire Rapids generation[1], below warning is triggered when
> luanching TD guest:
>
>    warning: host doesn't support requested feature: CPUID.07H:EBX.intel-pt [bit 25]
>
> Before Intel-pt is fixed in QEMU, just make Intel-PT unsupported for TD
> guest, to avoid the confusing warning.

I guess normal guest has same issue.

Thanks

Zhenzhong

>
> [1] https://lore.kernel.org/qemu-devel/20230531084311.3807277-1-xiaoyao.li@intel.com/
>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
> Changes in v4:
>   - newly added patch;
> ---
>   target/i386/kvm/tdx.c | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index 85d96140b450..239170142e4f 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -292,6 +292,11 @@ void tdx_get_supported_cpuid(uint32_t function, uint32_t index, int reg,
>       if (function == 1 && reg == R_ECX && !enable_cpu_pm) {
>           *ret &= ~CPUID_EXT_MONITOR;
>       }
> +
> +    /* QEMU Intel-pt support is broken, don't advertise Intel-PT */
> +    if (function == 7 && reg == R_EBX) {
> +        *ret &= ~CPUID_7_0_EBX_INTEL_PT;
> +    }
>   }
>   
>   enum tdx_ioctl_level{

