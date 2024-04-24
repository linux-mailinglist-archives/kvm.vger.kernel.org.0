Return-Path: <kvm+bounces-15872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C1228B1524
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 23:21:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3ED731C23AEF
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 21:21:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 441EC156C75;
	Wed, 24 Apr 2024 21:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dBhjoRID"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF2913C9DE;
	Wed, 24 Apr 2024 21:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713993663; cv=fail; b=Zw7jBbJzjTYxY/fyFvcxWrK82dZ+aWrYyz5EMlpfzptI3j/Ot3Z7vIAS3LjC4HMinADfKb4zArTBGrVyEtINqrjyxbC3R28Xjsq2aR0hleJ+rocgJQ4usnt6lcnX4iO/mXZs75eJjjLK7LR7rfJrNZ2GAQsRRhZ6ROrwaF/Ps3I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713993663; c=relaxed/simple;
	bh=9heOpbf2rkOUdMV8bwL87ihfETF+0W9et/I/NCDWAHI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=g0btvwDbja5LP/uU+frcLtaFADajVmFEHFfIPyaYrAtLn7SqbEbLCByvLghlWD8ZO6d1lmlyK6gibR0/6Ci9SV6FEeoxao4CDZV5LrPy3C5f7VO6UCgQYGwxJRaD+G3TcB5/6A3QXSosCx6siqNMfMDT0vNcYy5QauT4k9b2q+U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dBhjoRID; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713993663; x=1745529663;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9heOpbf2rkOUdMV8bwL87ihfETF+0W9et/I/NCDWAHI=;
  b=dBhjoRIDvOUsFSI8GsA0h1HZHmy97hZut91YZ4xwb1YSZuDJY5FrUIT9
   mEGZIPlbr/M6/NmwuLDAsWkv9hgrAJ6u/N2gc4sF+Z2a4pAyr/Tim549f
   9ztrTHDLxLpoL1mHNtvGRBO32tTuG3OOxUUj9FJP54C2UFH58uoUFV2tz
   98lBqIk1zyfzeqOGkl7BomQuNkhSLQqyh2B0u6274ZKuo8dX1HrSWLy+A
   yoC9gcNeqzcw5fz6iMgTa24kj4lZlRYJ3Bf0K+LdiCz/uqavkTSnarZri
   NdJr3fMrI3FTwjTYF6DdAc4DZPBpjYAOD5eY+kbgZWWEsbKOPrTKIQ/3y
   Q==;
X-CSE-ConnectionGUID: Sn0/CYLKQ/iYnruthiS03w==
X-CSE-MsgGUID: pJa+m0qlSXeZv1q81adslg==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9763357"
X-IronPort-AV: E=Sophos;i="6.07,227,1708416000"; 
   d="scan'208";a="9763357"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 14:21:03 -0700
X-CSE-ConnectionGUID: jKWsblE6TBakh/2i4+D6Iw==
X-CSE-MsgGUID: /+NbnWWLT+GwAzfoml1qrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,227,1708416000"; 
   d="scan'208";a="29473916"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Apr 2024 14:21:02 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 24 Apr 2024 14:21:00 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 24 Apr 2024 14:21:00 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 24 Apr 2024 14:21:00 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 24 Apr 2024 14:21:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Frwfcq4NrvbWzeRLWf1YjxK1F+70eW9LReBd0KxzrWDD3Ddd6os3b6uyUjaGITW8zTFdU16FDWCUws1NV7CQILpg1QwAUnepdgGoaj4aqdZmm0UaompwSdS9lTxMZl47zcCOSWRrLPSYjjfUYGQc8q7ZZCjtlykITXnGzD3JmVG5QFQ0V9JidHUM8qYMmLZHOixjWsIYf5b62zTJUKMB0uc4BgvvftJvA6BVdJ6eBIwJ9cJOhFxwp9V0nsTOErF8jJIZEMxEfqc2ez5sVebl72sULGK7t3H82D0nJFyFoYDktKfpLprUBqO9tl4e5r7wAALB3MVvxY49FkW04xohsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SPjBjQQpg2F+YkfwN92WQn0FpJTBdqm+HcON7blywhs=;
 b=R1Sj9dX9koWhHa0Wzss7D0huKXba5jOGUDEyqfg17qr7t7qLRc0nb7wEwkFJFcK5Htzn65yNtaprhZu3KEFylg/T2cmZiQj7Pi3fyeaK6gyiDx5AYus7k3CZtYT9n2jT8hf4myYFAlZw1amZ4BObPhNDzJr7kyFcNkRzyKz65TWMS8OAcmQORPLydwhHJg7HjSBl1RiuuMA27BQ7hFcbYfHXdq6q7d/nLDIugj1wWt3DMP+ohy9EJqQu2ZaRt011/Ltdi4sL5b/2MG4Kte8Tbygo3RhRrnyDAY9jlQyP3YCC2JWyMTTcMAkyACSOBQiyWDau0BjuDWoV4khSBuG40Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA2PR11MB5099.namprd11.prod.outlook.com (2603:10b6:806:f9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.24; Wed, 24 Apr
 2024 21:20:57 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::d610:9c43:6085:9e68]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::d610:9c43:6085:9e68%7]) with mapi id 15.20.7519.023; Wed, 24 Apr 2024
 21:20:57 +0000
Message-ID: <ad48dd75-3d14-461c-91e4-bad41c325ae7@intel.com>
Date: Wed, 24 Apr 2024 14:20:54 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 0/4] KVM: x86: Make bus clock frequency for vAPIC timer
 configurable
To: Sean Christopherson <seanjc@google.com>, Rick P Edgecombe
	<rick.p.edgecombe@intel.com>
CC: "jmattson@google.com" <jmattson@google.com>, Chao Gao
	<chao.gao@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "vkuznets@redhat.com" <vkuznets@redhat.com>,
	Vishal Annapurve <vannapurve@google.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
	Erdem Aktas <erdemaktas@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>, "Isaku
 Yamahata" <isaku.yamahata@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
References: <cover.1711035400.git.reinette.chatre@intel.com>
 <6fae9b07de98d7f56b903031be4490490042ff90.camel@intel.com>
 <Ziku9m_1hQhJgm_m@google.com>
 <26073e608fc450c6c0dcfe1f5cb1590f14c71e96.camel@intel.com>
 <ZilAEhUS-mmgjBK8@google.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <ZilAEhUS-mmgjBK8@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0279.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::14) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA2PR11MB5099:EE_
X-MS-Office365-Filtering-Correlation-Id: 550d7dca-2448-4c0b-c2c8-08dc64a46e7d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aHFPY0Z5K01JRitDc3hFT21XTFRZb3hzZ2pDOWhFcHZnSGxycnFHYnF4bUF2?=
 =?utf-8?B?Wk9Ub1RnMFhIZHRPWEJTRUpNb3dvZWhUL2Y5Z0NmNXFmVm5aYUhJUG5LZU5W?=
 =?utf-8?B?d0JrREJYQUw3Vk0rdk0yN2l5QWFHTG9sdC9RT2diRFJFSHFwdlhFYmZ3b0Ns?=
 =?utf-8?B?T1RReHlKV2lYWENWTTEzSGdBdEhDNThhNkpwcEphbXJqMFZsZEJGdE1tSkh4?=
 =?utf-8?B?YW9JUGhVK2pLSWxDTm1qUHRxbHMrRURHVnh3TWpsbFY5UUVUODhROGM4c21J?=
 =?utf-8?B?MkhwZ0xNZ25YcmUydzNNMllGUmJDOExkQWRlSUNobUMvV0RmQ3lvMENMWHVk?=
 =?utf-8?B?Q1lmYS81V2JnU3BTM0h0OGlHMmlyNzJWc0QzZEVwdC9JZkZZSDNIdTN1dGRl?=
 =?utf-8?B?NDdDS1I3QkE0aWVSQllPVk9zTUMyWUFVaTZhS3pmYjhRdG1LaUZod29IdUVZ?=
 =?utf-8?B?Wm9TdUxRYUZxWjZLMWQrUFZlOTJKdWxTQ0JHQTR2a2k4ZXhXK0o5ckdFaXM3?=
 =?utf-8?B?U1RiTFVPSTBBSXcyWXhGR0xUZlpUdGE2TlBmOEpwcVU5MFV5MW80T2FoMFRW?=
 =?utf-8?B?aXFRVFI4M0s1cWZEM0psWHJJY2JrVVdiQkNPdjFKUmc2V0VrNkJQUjRKcGJx?=
 =?utf-8?B?SUpIQVhDZG1OUXVtQmF2OExaYXZZYXAyd2Z4UU9DWTBEbVNHQlpCUSt0QXA5?=
 =?utf-8?B?RU5kei9jN2Zia3hLOUU4c1p6SzlqeHJ4TUc5blhsV0E2cGFvMUpNUUJXa1ZR?=
 =?utf-8?B?QzY4YXM2Nlk1SXhScmFWOENWUytjY0J4VXV4Z0NueG41QUEvL0hFam5aMUxN?=
 =?utf-8?B?RDBnNTQ3ZFRBOU5nRVduY2lBNllrSHZlbUpOVEtYVjVuTmlvUUw3cHdVSFFY?=
 =?utf-8?B?djhvbnExVFp6cjYvR1NMMGdKelY1MnhZR3FSV29XSytVVXliaFZUdnl5Tkk3?=
 =?utf-8?B?RWlZZnd6bldTKzJFL21ZM05EclJYbkVHMXJyUUE2VXQvNHNkcmtVNG96YWxG?=
 =?utf-8?B?UE1UTFoxb1prOWRFT2FiYzVHdzhWUE5Jc2JQSnJFY3QyYXc2LzduRk5CR25R?=
 =?utf-8?B?VUNwM1UxRGsvMVhnSG1Vc2NndVQ5MGNYYUZ4cVF5dTdUNmUwZWt5bnprbFBa?=
 =?utf-8?B?RnQwV2FWR1Zmb1ZRZ3pXK2RGN1h5Z084UlFhQlN0NlBISVpPVTlDdVNWQ2U5?=
 =?utf-8?B?NFp3alpaVEs5ZXVUdVllZERGY2tIalJRdmtmTTUxM1NqWTZRRytTVS90a0dW?=
 =?utf-8?B?dUdmQzVjQzZMYXlxaFRNaEg2V2pXWksxak5jVkwzR3V2WTBRQ0NXeloySkxh?=
 =?utf-8?B?bisxb0g5S3RDNWxRM0RycjBwZ2RiOFNJN20rK3RNQmF2cDgrQW1CYzUxNG9k?=
 =?utf-8?B?WUlYTnZXZUpRZzNHdk1HWnJPeHNYVnhxZ2lwUTZHUDRkTEZ6TUxtYXdHdFhx?=
 =?utf-8?B?aStKb3MxWVJBYXorNjdMbDBlRWZ0QjN0eUMreU9uODFsVnJ3OFFYYmFEOTBx?=
 =?utf-8?B?RnhiaHo3OEc0MGVRNGYwQm9kV1p3VHJWS2ZsV3J1U29VRjN0bmcrZDQ2M29u?=
 =?utf-8?B?dzFnUi9YbEl1WDFYTEQ1VzZaNlRaT1FZWS9ZZ1huQzF4M3pmS2ZmVmkrTTJ1?=
 =?utf-8?B?NE54WTh5ZHgwdWsyVi9WUS8xTmNxM20xb0lFVkVtTm50U2ROVmZLR0d4OG15?=
 =?utf-8?B?VFFhSzVROGxiQnBXYlorNTVYQ2RiNVhYclY4TXgvMC95MXhqUEwzSnJnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NzdMek50UXhhZUdheFNkQzNySGsyNVNsSTZ6dDArSlROOWhuWEpIRUZUSjZu?=
 =?utf-8?B?WnlLZHhkb3p1dGR4UmNzdEE1TVhnclEvbTZPRkNnNU1FNzRZcW0zbUJjSWJn?=
 =?utf-8?B?alpvQzRJQ0V4YnA3V283QVZKSmlMdHRhSjllWjRMcGVnQzVCQlVlQjNPY2ti?=
 =?utf-8?B?Zy94bDNadVV3SlNoSjI3V0FMdWFrTjRTSDhSRjhCUHdqdXZuRUFtT1pRWHc0?=
 =?utf-8?B?VUhRcmszc0JHeUNpMjh0STlZZEtlRkwyd1p4K1lCNWFNSTZqejRuM0llcmhB?=
 =?utf-8?B?dDlIT2lndzQwTWNTSTJXMFhEVUtQVWtQUjhRaHJmNHdlaE1Zem9sSDFjUmIr?=
 =?utf-8?B?QlRzU3dUTFRKMHBxQ0hicUhnbXJnQlp0aUIrMkJwRzUxMFpScmlmS2QrVDA0?=
 =?utf-8?B?OHhVVng0T3lvclBDVXlUaXFacExMeDZwR0xFQWlIazZxbE5lbzlEUEFjdDhP?=
 =?utf-8?B?RlFtQzI2WFlUOHhzOHZUMHFJODd0dUlLdVh1Y1Q2TjRRdFhuckZiMllvWElL?=
 =?utf-8?B?N0JKc0JWd3dDK0xudU5mOVFhV2lsMzJJakVscm5aU2oweWpUbm5BY0YrT1Ji?=
 =?utf-8?B?aDY0U3drc1UvdlJqUlZ6ZWkyZlk1a1JMUElRdWNTbUdPanU2dmVvQXQvUGVp?=
 =?utf-8?B?OGljaHd1eGRERE9DdzlWYk90ZXlrQTUzZVU5YzBiYVVjc1JEZW5IN3JVeUFP?=
 =?utf-8?B?Mmg0dFNzTzZMaWd6YVFYZHYrRnlocmhUNitrYVBFNE4ydS9uMFNxMkpZNWlG?=
 =?utf-8?B?clUrRU85bkFseVVQSjRjSXFGQ0l4MTlMMmtrUHh0amZTR3p2SytBZWh6NXJ1?=
 =?utf-8?B?ZnlxOXlvZDVtR1FXWXJTMG0yTmZrNk5kTDQ3TEkyTkt1aFNHL2twMjQyTDdQ?=
 =?utf-8?B?dkR4VWNadnExWms1RGVycVJiUTE1aFJqcHEvUnQ0cVlIZDVGTkk5QzRqMlla?=
 =?utf-8?B?Mjg4VUZteVR3Uyt2anYvNjBKNXAwVVFBMk5qUlRQLzVEeGxEaEtHZ08zZEMr?=
 =?utf-8?B?cmp5M01CYVJ1a3o0dHRVQzAwQXRKcFp0b0M1S0JxQ1pGZkp4Ui9wVDM2TzYy?=
 =?utf-8?B?aG5HZi9UcUZBU2VqK09oZ0VnOWpoZlRJdE9vYWpGQklVRDlocUV6NXBMaUVL?=
 =?utf-8?B?NmRuZzVhbVJvMENMbFdVd0YveHV1QjkrblN3bTFlclU3akF0ZTdJTHFUaTVC?=
 =?utf-8?B?RHNQekk2QUkzemxnN2MvOW5zanhxQlhORUZzdXZWMTVYL2NCRWVFSFFwS2wv?=
 =?utf-8?B?SmIwdlRDWUFnMnZBdEs4QVdid1JIRXp5bDA3aFFhWWYrcjBiVFFKYUJUZVB6?=
 =?utf-8?B?cTFBOXMzV2xiZXozSlFDTEltQ25UOFpUVHZpSUdhK1Y1Z0F2MElOaXMrSnVZ?=
 =?utf-8?B?d05UaGdMcmVGS1NQYnRWNzhYMHZLNGtXMVg5Nmd3R25QZDVnSWlUUFVrbmEz?=
 =?utf-8?B?Rnl3YVBtMWcxRkwvMEtuVnBHN0VmZDBRM0tJVmhFbHZIVExvZDc3b2pIakdj?=
 =?utf-8?B?aXlJK3lJbnR3bkF3Tkc5V0xpRG1aUXc5ZFRPYkRnOU81UEllTmNRMW5sZ0Fr?=
 =?utf-8?B?TjVkNC9FRk1MSXNtU0tyRy9jQ2wwajRqUXF4K3lEMFdrVTJxdjJ0Y0J4NXlz?=
 =?utf-8?B?aVNTN2lIYW9YOXJoMTNBMCtmSFM1RFRkNWVFdjJjS05hQjdJOGorWnk4ODF1?=
 =?utf-8?B?dERxUnIvSnVUdHpjMHZyc1o1NFBaejEzeTljVVVUc01lbzgzTXF1cUY0S2J2?=
 =?utf-8?B?VkZ2eW1SeXI1U3pneEx3NXY4N3JvbWttSUpiN3BrOFo4MUlBNGRWUVZPWmRG?=
 =?utf-8?B?SVUrUysxYy8wVzBoSHJLZGFYZnFCbFo5NktaOGJaRWg2cUJjUkhNaTJidkgr?=
 =?utf-8?B?YUI4SnZKdGRoY1BsVy93U0VOakhvcG92SDNoQk13MHRhYlc0RGRNNDhRbjc2?=
 =?utf-8?B?Y2Z4SFhKWTQ0R29PU0FnUEFkMEFTa2ZyQllnd2EvT3dMYUpKcVNMMUV1cWVl?=
 =?utf-8?B?WHVmSmlGcGUyc3YzeDAvRVpYb1QyZ0UvYmU3ZjBWaW85ZjNwNlJSMm9uV0Ri?=
 =?utf-8?B?UVhZMHF5STA5alp3RXY4WUtGYy9PbEdVVENGa2JCUFNaU0xibTNVQVMzdTRo?=
 =?utf-8?B?THVzUEh1MTdPQVhYdEp2MlhwQllvWk5Pd2svVlZSMk0xcDFBcWxBU3hVV01D?=
 =?utf-8?B?UXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 550d7dca-2448-4c0b-c2c8-08dc64a46e7d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2024 21:20:57.2294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: liZX7wryfW4fz2coNrVK8k1u4wXGJvKg7Y+BcTS8PVW+f1DHz57TXuYq8CLmQBpCx6kdr4hmX8HmdL0RWtDqd+z68m2czA2S0ZPlG9Z1qJM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5099
X-OriginatorOrg: intel.com

Hi Sean,

On 4/24/2024 10:23 AM, Sean Christopherson wrote:
> On Wed, Apr 24, 2024, Rick P Edgecombe wrote:
>> On Wed, 2024-04-24 at 09:13 -0700, Sean Christopherson wrote:
>>> On Tue, Apr 16, 2024, Rick P Edgecombe wrote:
>>>> On Thu, 2024-03-21 at 09:37 -0700, Reinette Chatre wrote:
>>>>>
>>>>> Summary
>>>>> -------
>>>>> Add KVM_CAP_X86_APIC_BUS_FREQUENCY capability to configure the APIC
>>>>> bus clock frequency for APIC timer emulation.
>>>>> Allow KVM_ENABLE_CAPABILITY(KVM_CAP_X86_APIC_BUS_FREQUENCY) to set the
>>>>> frequency in nanoseconds. When using this capability, the user space
>>>>> VMM should configure CPUID leaf 0x15 to advertise the frequency.
>>>>
>>>> Looks good to me and...
>>>> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>>>>
>>>> The only thing missing is actually integrating it into TDX qemu patches and
>>>> testing the resulting TD. I think we are making a fair assumption that the
>>>> problem should be resolved based on the analysis, but we have not actually
>>>> tested that part. Is that right?
>>>
>>> Please tell me that Rick is wrong, and that this actually has been tested with
>>> a TDX guest.  I don't care _who_ tested it, or with what VMM it has been
>>> tested, but _someone_ needs to verify that this actually fixes the TDX issue.
>>
>> It is in the process of getting a TDX test developed (or rather updated).
>> Agreed, it requires verification that it fixes the original TDX issue. That is
>> why I raised it.
>>
>> Reinette was working on this internally and some iterations were happening, but
>> we are trying to work on the public list as much as possible per your earlier
>> comments. So that is why she posted it.
> 
> I have no problem posting "early", but Documentation/process/maintainer-kvm-x86.rst
> clearly states under Testing that:
> 
>   If you can't fully test a change, e.g. due to lack of hardware, clearly state
>   what level of testing you were able to do, e.g. in the cover letter.
> 
> I was assuming that this was actually *fully* tested, because nothing suggests
> otherwise.  And _that_ is a problem, e.g. I was planning on applying this series
> for 6.10, which would have made for quite the mess if it turns out that this
> doesn't actually solve the TDX problem.

There was one vote for the capability name to rather be KVM_CAP_X86_APIC_BUS_CYCLES_NS [1] 

I'd be happy to resubmit with the name changed but after reading your statement above it
is not clear to me what name is preferred: KVM_CAP_X86_APIC_BUS_FREQUENCY
as used in this series that seem to meet your approval or KVM_CAP_X86_APIC_BUS_CYCLES_NS.

Please let me know what you prefer.

Thank you.

Reinette

[1] https://lore.kernel.org/lkml/1e26b405-f382-45f4-9dd5-3ea5db68302a@intel.com/

