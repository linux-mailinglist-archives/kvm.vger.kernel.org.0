Return-Path: <kvm+bounces-46045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 83DADAB0ED2
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 11:23:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AA8EB1898A60
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 09:22:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66773279329;
	Fri,  9 May 2025 09:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XA9qQZoN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01627277031
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 09:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746782458; cv=fail; b=YHJ0PCKAIgg+U6kjtSNoALgXE/+gzhTIih1bL0wtPFKH7ikVdNSj18olkuAn9aBbgqYeIcWHaavgvfpG0eokLAfFQ2pH2dKMI/F29NpsIhKXU4YutAqPPgYmWuHT+X2/D9igAGpLP0bWqMcFWcunPxDHCGgx3gLtGCbyywXY5i8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746782458; c=relaxed/simple;
	bh=Sj0/4oU5C4KEwnre8vkIaiUNJGOadKc+039f4/z0xeM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SvpSVm/iqApMego3FRHFDJ0d1aIyautaZMNSVQJcyWws8wzfoIoQFNwFwTwzYfFgESm5AdriQQ4hHpJZDnUK9Nm65Huw2rQh0TGGRhxucbG9+0LwzJG3Rj4ksAJEic/H5Uey2UUDNmyZvFkvnQawvNpkTppGFqXTkJZQrv+MQSA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XA9qQZoN; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746782457; x=1778318457;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Sj0/4oU5C4KEwnre8vkIaiUNJGOadKc+039f4/z0xeM=;
  b=XA9qQZoNU3nLpsokMWdvKDpu41XzMxrWv7PlXvNuK/fZkWGZTH3Uf84V
   Rscz873QHh51YLte2aj71LAAVkbrSXmUBhHZ5i4yFyfaPJvZuaezXearc
   iWyo/P4g1fF+Qwr7jkjgHh1d+IOomIbU1mGAeLQM6o9AB4xtDQaBnQnj4
   f29cCdMPPY2vJpC8/jZ2V5krMx9I83ewdHRRAeWm6CRwnav3lPheCXTZw
   45O7adLkA92OORPQgRexTdhRQd3Cu19I8mjjUjrrYfd+vQwJ9d1/YftWp
   o5DxrfBr7Txol9QcNheiEKh2FBSFluziJzHpvez2z8Yhp6wTQjvA3/63Y
   w==;
X-CSE-ConnectionGUID: OKU9YA+URoqI+JL9ne+bCg==
X-CSE-MsgGUID: 9/wEMKIWTZelwwRnxiZ4mg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="52411594"
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="52411594"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 02:20:44 -0700
X-CSE-ConnectionGUID: TUdLnaU8QByBq4zcJRxSLg==
X-CSE-MsgGUID: TI29RoLETHiJzyIscEP2sg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="136519586"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 02:20:44 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 9 May 2025 02:20:44 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 9 May 2025 02:20:44 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 9 May 2025 02:20:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mkOfNzUxq6DUylSu1yEzhCwRVvm4SJkFYD6v4zMuuFH+/F3p6wsjc5aOCzR7g0ZjvGBkRszOQPoMzghmca8ZCWo+T5YIg2Dv/rQhXIt9HO2Al/RgcEW1rilCdbNnjbvQIwjT44Qao+0W5tsvM6H/kwktKEkZbNpwDNALY1Vu6cXNakeFULMOh0C26PTdTGLuzZJfAv7zPCeIvItkhSHpzXLQS+9yEKxc/RAH1wjrzJDE4YCoNXgdtpRuXudN10SLQUYX7KLdEbEdb/u+XvniwZ2gBcELaD2GULK1pHxtbAnJk6MmWvAKRINcip8KzjmaKJxQmiLr5I/LoIuCgcDkTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XNguffgN+NWZZo+y82/jboeKCGKtvMSJMggJdObccbo=;
 b=zUHgkl+o/ukcsN+zeQHwOeLNGM7q2P7v4Sagije+bWgfS0rUjV9hjTVmTB+Wmpf25tOkAX+QpJV0OqCIVR4lfyrTcJbV3xfJODKsCukMN858xvtVpE0TrKKNaJWcRSSC27n2++p0Bx0Yd6P+hUHxcgiV+6XlhV5R0zQXRrDwbmA6bhGPREsMSRS5dy7JzsT78Qt8UxDxqYfpKFjkQM8+bjS7rAJqKaD89t9gArZwQgGCra+qBi89bZl34YTQTP1UUoPQAfLQH/DTNzoFy1pbYN01BCdJiZDy3sxJ8J0hSROUnMHGBxcLBICzsCTCuw3h8iuv247cM5MOP0iH42MzWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 LV3PR11MB8695.namprd11.prod.outlook.com (2603:10b6:408:211::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.21; Fri, 9 May
 2025 09:20:07 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8699.021; Fri, 9 May 2025
 09:20:07 +0000
Message-ID: <18b560d8-0723-4032-be98-54d602a7fdcb@intel.com>
Date: Fri, 9 May 2025 17:19:58 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 10/13] memory: Change NotifyStateClear() definition to
 return the result
To: David Hildenbrand <david@redhat.com>, Chao Gao <chao.gao@intel.com>
CC: Alexey Kardashevskiy <aik@amd.com>, Peter Xu <peterx@redhat.com>, "Gupta
 Pankaj" <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>, <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
	Williams Dan J <dan.j.williams@intel.com>, Peng Chao P
	<chao.p.peng@intel.com>, Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao
	<xiaoyao.li@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-11-chenyi.qiang@intel.com>
 <c7ee2562-5f66-44ed-b31f-db06916d3d7b@intel.com> <aB1qqUGEayKbkL+2@intel.com>
 <79730f95-6684-42fa-a6a4-630e3e346174@redhat.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <79730f95-6684-42fa-a6a4-630e3e346174@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KU2P306CA0057.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:3d::11) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|LV3PR11MB8695:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c6b772c-acc2-4e7d-68a7-08dd8edab094
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VW9JYjhDM21jeWNra0lvK2NEVFNBTVEwdngxdXpnUzZ2OUs3Q1dER3gzb0x2?=
 =?utf-8?B?TWJNbDNVM1NtWTdEOEhvQ295dnhteEdhUnpob0dvMVd4REJrMFpIcHk5MGxP?=
 =?utf-8?B?SnQyUll3RTdxWW1nZ20rMHI0bkVEenE4dWhQWG5VTTFsZ241bVRNalhuY1g5?=
 =?utf-8?B?RzBwVnpiR25mSmNYOThDZG9zSkJJRVhJTGhwQzlJRldmUHVxa2FvUFdteWp3?=
 =?utf-8?B?QkdzNUNMQitNYjFVU2xjSU1XZ3AxeXVFVjhWNTNiOXZOWjZjUzNzOWdpN0pF?=
 =?utf-8?B?Vk1ta1hiblJ2aEdUd0ZJb25PMXNhTmtmUnBvRDJ6YXlOWTRCbHBydEJqSTY1?=
 =?utf-8?B?bmE1V3lwTW5EalJVOUtXVkhsdTFnL0tEWjFrUFVlZ3U5VkNxa09tbmw3cVBH?=
 =?utf-8?B?emozL2VVTUZCZC9LQjRhUXVUbVFDcFFLQXdOQ25CeVpONDgzUWYvZWl6a1Vk?=
 =?utf-8?B?eHpkVGZrSUVwaEVHUzNyN2k0dFpuVkNoVXo4b1k5V0V6WElXZW9Sc2UyV0Qx?=
 =?utf-8?B?UVNZOVg5RmxvL29aQUhkUi9naGtsVnlQeHpXUCs3UnNzbnJvaWxuVFpHVDlp?=
 =?utf-8?B?amc4Q0IvZW9rbEJrRHQwNDFQcjdPcTVpS1A2WjBMYW5oVnJJZnB3bFJTTnhF?=
 =?utf-8?B?ZmNSemp5TlA0SDhpOUdyN1dwLzNqb3J0ZzNrSVp5VEFnUUtYcERKdktsUEVY?=
 =?utf-8?B?SSt6eXJWNktsMFJCSGV4VGFzQitHclhCMlZzU0lueUdEWnZHNEl4VEFmTmZZ?=
 =?utf-8?B?OURHQ1FFc3JoWjVIbjEyM1RFc01zbGMyWHRaVEtUKzI3OXpsS2xWS0w3Q0hj?=
 =?utf-8?B?SlhJSDNrR004WnQ4NFlvRGtuMVpScVdXaG8wNU82R1JnVGdUU21yU3hkcHJs?=
 =?utf-8?B?Nm9PN1NGOEtqRGhmNXBYaitsREpPWTZtb0k4S25mOG93V2xLbXZ0ck9hdWpa?=
 =?utf-8?B?SjdPMitkUHA3WlRZZVNCS2dUbENpaUZ1VFdLc2xnMTZoM1JkVXBmZmFDMmd6?=
 =?utf-8?B?SkVVYW9sejBaWDc4a0FCcmQveVQ3NFdyRW5EZFJEMlBsRmh0LzRHekpKcVVz?=
 =?utf-8?B?dUdqcWQzZXNYNGk0SUNHM3RNay9UNU9TL2V4UUFRUW1kZzNSa0lScmJiTmlS?=
 =?utf-8?B?KzJ4Y2FXMStqRlNYekdiampwZmJiZzNrK2RkdVNmYXdabEs5dS9UR1YxYlI3?=
 =?utf-8?B?aUJsS0xUK1FmRmRKWUQ0aXFOU0NOaDFsQkNzVE11WndXaVFZdmhEOEYxZXh3?=
 =?utf-8?B?NmkxdkdSUVVhdGRpdzJ1b2R4N1N0QWlJaXZYbGRLWFJBU29XbVNsZU90NjBU?=
 =?utf-8?B?MldHZnFPejI3RDdvMjdPWEFqRHp6L3lmblhwd3E4Q1pnMDhvT1c2UUxFYmZQ?=
 =?utf-8?B?TkxDUnhZYUxrd3hvQkV5SnNiWGl2aWRYWjhNMTlsMWRxY2lPWFdwTGI1QVhn?=
 =?utf-8?B?cXhuZXNCZkJaOEFJYlFIYURtUXBUMHFCVHVGbkg1bUZ6OVhNY0NtcmtzNGlG?=
 =?utf-8?B?UmRrQnplRmZpdnFhYUlKeXBBQlZINzM1YUxGUjM0bVQrYnlMU1krQ3RycDV3?=
 =?utf-8?B?Q09lYTVqMDhaeXZZTkZvYTI3c0RCa1FyUWJyaDc5T2tmV2hjRE5lSnY4Nkkr?=
 =?utf-8?B?M0NieGRpMUJFOHhkL2c3a0FUQlFvUHBUREp3aERVVXJnSjlKZnMvTGFwWmcv?=
 =?utf-8?B?ajJ3bmRLWUR5QUcvWGQxMWZva21sY2x6b0FZWTVCM0dVSmRsWXFoNjYweXhr?=
 =?utf-8?B?QTZrRHRJMmJhMkV5SzBSVTVlNEp2eU51ZmhCSldNOXVOS2Iza3B0Y2dmeVhh?=
 =?utf-8?B?Q2RTVzlUZjN0L1pJbXB3Y2I2bkpvRElVYUlTN2NxcTNwR3FCaVpXUnBLbHdv?=
 =?utf-8?B?bmpieWM5czM4M2xMRkFyK29TQzRzYXdUaStMYm9UWm9BZWRMbDhpTDRNdFk3?=
 =?utf-8?Q?4uujzO0lv4Q=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L0FhZDVMMWhaQUUrNXNYOWdNREtPQnhTLzQwQ1JWQnU4QTRhLzB1Zk5vd2Fn?=
 =?utf-8?B?N2Z2YUUxTFQ4VXloQm94TUZMMEJVdUJFd3VEaER3ZmEwVnFuWEIycUwyS1FO?=
 =?utf-8?B?ME1hT2pxcTJ1Nk1QVy9Tc3RSVjZTZnhTODVHWWgrd1hRYzVBV0FPL2ppSlpz?=
 =?utf-8?B?UWM0OEY0L2NzVGhlQlgyUGhxUURGNzRqbkNrU05RK0owZVh2M09vVVIrMGFJ?=
 =?utf-8?B?eFFnWlE5YzFzYTJkOHYrcnpNeTZkR3hNYmo3eHdzNVllMFR3T2J5amdDWUVh?=
 =?utf-8?B?ZUN6Ymp5blRIZndCcGE2Q3ZENU9PUDFQVS9vTTE2aUxoNWExTElLZjk2eHNW?=
 =?utf-8?B?SjJ1TWNDY1BwY2hhNytBOUVoMFptTENqd2Qyb0p6Y2Ezc1l6NGpLUGJKbC9X?=
 =?utf-8?B?b0pCNmF5QUo2MC96UTB4THNIekFvREd4aTNhMWVwNTBObzdHT0VjbFVUOHpK?=
 =?utf-8?B?YnBMRnZnaElnSytJVmZ2SXJzbXBnMGtPYWhmeFRPa2RRdloxU0k4OGd0VEdB?=
 =?utf-8?B?VXNVZHV5azJ0S1JRN0pPclBvWDg0REphdkNPcktZVVNheTRuQTB3Umhxb0lP?=
 =?utf-8?B?SWdXNW1ob25lRlpHQXhxVENEZlhNTWIxb1g4S1hhSXd0NWkvZENoNFJOb2lV?=
 =?utf-8?B?RVBJRjBtTnRRcWVwN1llL1NUcWVvc2NiclZsMVhGOWFUWFRhV0M2M2svSjR1?=
 =?utf-8?B?bE5FTW1JdGxSTS8rNmY0Lys5djR5K2ZDclRId3FCUS9UajZYYmpNc1QyajUv?=
 =?utf-8?B?TE92ZmovZHcxK0xGWFZNbmhkZGhIbTNQMWZDdmhPOERnbWt1eUNSYzd1TTN0?=
 =?utf-8?B?VkRJNjFtYTJ1ZEQzUzdaVU5lWlhoVkdWdEIzb3dPWm5ObWcyUVBkVk5yeWxt?=
 =?utf-8?B?M0xaZU5QZERrRU9hRys4Y09yaGdiRndlYldPZHU5RWIvcTNjK0hZdndKeGpr?=
 =?utf-8?B?REs1dW41Sm82Yk9GUFQydXdFaEJtdkU0eUhrMDJwSFRNS1krQVJETXlMaXF2?=
 =?utf-8?B?emZwYVZ0M0tQQy9DZ01wWVBJMjU0Yncyc01mY3dTNkQvZnk1NGk0bnZJQmRP?=
 =?utf-8?B?cWhVVTVmVDhFM2d4ZXdUWW5vdEUrRWpab2dyelFobWZpUUVLdUVLaHNUUk4w?=
 =?utf-8?B?bHkyZzExTkdjK0xqMjVyYUZyOUp2c0cwdnJtT1ZhUVJNN2dnNHRlMFpmK1Ba?=
 =?utf-8?B?eHBNaGF4bXV0andKdVMvcmR4NU1nb2F0aUlFazQ0dFpISXo5Q05idFpoRWcy?=
 =?utf-8?B?R3grQ3JNaENybTJjeUFTSmFpbGRrUEhYblFOVDFvM0YweHI4UUVSTGJDbksv?=
 =?utf-8?B?ZzdnTlB2Q2hDOTVyaTN0QmxDTXhUTkZHemZQcVVHaUM3bzdMZE1VNURPb3c4?=
 =?utf-8?B?NGZZV0cwcU4xbVV6eG9iV1JHOHRZQjVFMnVYOGxBeUhpOFA3TVZBT3liMjRp?=
 =?utf-8?B?SHdtbDBqanZvc2xPNWs2VU44YnVaQi9EQWhDaXVyWFAwY3VmeTI2N2MvVGVT?=
 =?utf-8?B?N1Q1cXpBUHVndFMyelo2ZjhPckt6bS9OdldtM1l6WE1iWHFxQ0xMM1ZSL0h0?=
 =?utf-8?B?WlplUE5MNTlWaEFJclJEUGVyTFdqVUJnUEd4VXpEZk9PbmlhMG41TC9EUTRl?=
 =?utf-8?B?ZkhLRzhZbVZLTFBZczVYUEpxTStvMGFWYkZyVkEzL0N3TnBIVlI0Y3ZucDVo?=
 =?utf-8?B?WjYzM293U1RZTzFaU1pYcE1vVktCSnlzSE8wM2xQUTg5M2kzSnd3NWQ0dDRo?=
 =?utf-8?B?UEZUM1Z6VGJXcUcrbzVjaW1qTFFwbjJpTkpNTTc2TzJOYUp2Kys1WFRQMytN?=
 =?utf-8?B?eXI5a0hVMjl2dktpUGUwQnVSOUN4NzFLMWRuUmxWYTFQYlVudVZPQmh6R0pE?=
 =?utf-8?B?dW9pNXR1M3NTeWZSNXRJU04rdGN3bzBKdnZpNmFNampLdGNiQ3dXV2VsMGls?=
 =?utf-8?B?S0FLc3NMWnlnakx1WDN1ZHZjVVFXcXlCR2NTQ3VQSXNWcUFCY3dpUTdkVVp5?=
 =?utf-8?B?b0xFN2VmU0ZzUGdYVzNULzNGVFhsOGdzQVFmTmlHZkp4Mm96bFZycnJ4L1RR?=
 =?utf-8?B?Lzc2V3E0S2x0TXRmQU9uR1gvUUlHYkEydmVSN0dFMXBHSUIzemlFeXg3Sk1M?=
 =?utf-8?B?UlRPbEo3TmU2ZmhaT3ZvOERNd1Q1WCt6MHIrOXIrd1dYWE95VkZnWS9Fajdr?=
 =?utf-8?B?TGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c6b772c-acc2-4e7d-68a7-08dd8edab094
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2025 09:20:07.6405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sSQv1Xw+ATqt3+iZko67QvDXlpHGGcQFS0vV9zPzRIdinDg616C6+opx5zlup5ProXjHlEtNeDmXhRkTMa4eKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8695
X-OriginatorOrg: intel.com



On 5/9/2025 4:20 PM, David Hildenbrand wrote:
> On 09.05.25 04:38, Chao Gao wrote:
>> On Sun, Apr 27, 2025 at 10:26:52AM +0800, Chenyi Qiang wrote:
>>> Hi David,
>>>
>>> Any thought on patch 10-12, which is to move the change attribute into a
>>> priority listener. A problem is how to handle the error handling of
>>> private_to_shared failure. Previously, we thought it would never be able
>>> to fail, but right now, it is possible in corner cases (e.g. -ENOMEM) in
>>> set_attribute_private(). At present, I simply raise an assert instead of
>>> adding any rollback work (see patch 11).
>>
>> I took a look at patches 10-12, and here are my thoughts:
>>
>> Moving the change attribute into a priority listener seems sensible.
>> It can
>> ensure the correct order between setting memory attributes and VFIO's DMA
>> map/unmap operations, and it can also simplify rollbacks. Since
>> MemoryListener already uses a priority-based list, it should be a good
>> fit
>> for page conversion listeners.
>>
>> Regarding error handling, -ENOMEM won't occur during page conversion
>> because the attribute xarray on the KVM side is populated earlier when
>> QEMU
>> calls kvm_set_phys_mem() -> kvm_set_memory_attributes_private(). 
> 
> I'll note that, with guest_memfd supporting in-place conversion in the
> future, this conversion path will likely change, and we might more
> likely in getting more errors on some conversion paths. (e.g., shared ->
> private could fail).
> 
> But I agree, we should keep complex error handling out of the picture
> for now if not required.

OK, I'll keep the current to_private conversion path simple without
rollback. Just give an assert to kvm_set_memory_attributes_private() in
the listener.

Per the to_shared conversion, As Chao mentioned, since any
failure in page conversion currently leads to QEMU quit (as seen in
kvm_cpu_exec() -> kvm_convert_memory()), the complex rollback seems
meaningless as well. Not sure if we need to keep it with the expectation
that QEMU changes to resume guest with some error status returned in the
future.

> 


