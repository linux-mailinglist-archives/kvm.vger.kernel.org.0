Return-Path: <kvm+bounces-43054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DABF4A838B6
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 07:54:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC595465925
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 05:54:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CE4A201278;
	Thu, 10 Apr 2025 05:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JYzcXl5Y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274A2201262
	for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 05:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744264487; cv=fail; b=CKxZC/mpcqRFgIvlDLhmovavfjLXT869LjxQPUuUM3ZJ4GZXWYNuS+Rb3mISyzO+wn/Y644oviUxj9xIBVbzRvZfnWs3lTYzcaeAgEyczatyBEdudFJYmTCWqH6sZDFKIkbvDbi3HMMB5cE/isMz8nHBtGzslwCb2WCZYmwqq/I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744264487; c=relaxed/simple;
	bh=1ijlZW/xyUvd7bpjVxaQNoqR/8wPtc51Z26YNDhy/wU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XW7FeOyqQGyLTKgMHRRxEWYKkiQ9XCf3al3sCX8JqPEzVVr8P+K4dqMUvjHgmUiTba6bSGJeKChNnRxUR1LB0ijMIt5o1KVTLjm4a5i/RGcDm/ju40qAdD1L7Tgar/ds33vazWIndDxRy3exk8AmOy757Hq6p9CgH23NKotYpQY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JYzcXl5Y; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744264485; x=1775800485;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1ijlZW/xyUvd7bpjVxaQNoqR/8wPtc51Z26YNDhy/wU=;
  b=JYzcXl5Yn7IWwo0tr7OxSEXjbni4YibgDQ5ibpgokH3VxELC8D45SciK
   SqHAOYD9BT+hyGPVT/quRiXsF9f3EeHKvyyQfBovdBM2/oerLlJfrfuid
   3nmPV/wkLZd3y5Z4RRKBaQy8FjhaN7jSXP6qQzZ189OCwssspPIxQJ8QK
   QsFHjtBzElaE6A/COfuhVnch0w/xUNlm822hOEEL/3yz7UXEwTskOtuJ1
   b5xq8kLtvZd/3USY1ex+kP3HAn5zV6yQhbKMBCuXKHoHGwlLwcMQcaEgd
   zP+jy2swhmNwnujKBXOAUDR1XAuP3FVcmtYB5nMIWecRfU0xFhaJEkKrK
   A==;
X-CSE-ConnectionGUID: T5pnphb6SoegWZiEeWXXBQ==
X-CSE-MsgGUID: rqn7Z/6TSvW0NYQnQ8pIdw==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="56404741"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="56404741"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 22:54:44 -0700
X-CSE-ConnectionGUID: ixWtLmEFRkig36+rPZLRjA==
X-CSE-MsgGUID: bRee88tcS2iyi1eZL7eyzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="129146040"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 22:54:44 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 9 Apr 2025 22:54:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 9 Apr 2025 22:54:23 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 9 Apr 2025 22:54:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fP9RZC7ed38rp+txsp49ZhTzAhC4HFxpkDaINPpikKceVVTqZquk/OZi7GzinKI/cP8pP0JX2XklHRaYGGf+0JdzT8PogPg+0Zp7XEcojQ6AHPWg1QsAQZQO69A1cZIlzeQX2l2faF/6N6qNGbOdc4Y5cGJcG/lQZ1T5XI0F7JOhbkOE9RZCRnOxNXTkcns69SxJxIYULZe8rCl5ZlaBGxK6TvUBuKUZSkv/GODT+BgHS50lKX97pjhUN2Z+O/LtVEVFYAGO4J04O1ZnVn8NgD84HY8dPnwsbv91W3zhtT1UuLXgvZEV8qxST2m8E3CxSpN3H83XdkBTZvxz10bljw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qniPMybsznQm0sZtykegMeMxSEt4U1U2vga06KztmwQ=;
 b=fR8TBzFBbbMWeSeSeHTIpZMqE5bfHH3+GUTv1sAsq+u1Hm/7Xx2a9p6EsKpbJDeDGMvbs8XSianXoL6YfISnR8wrcR8jiOcP92d5wbh8AQkxRyqCQkCW/xOQdc/GC4Vvaf74DfakcqBaxf3JBHHr0mGeXDrfR3Uqz46XkdTyNA4JNZOOx/FRO4QTI/YOUBmYgmkTGwX8qT/ERRPU2g9xf3HH9QNj5iS+CE69mBrVDwQmtIB0m+iqFMSfErp/RB6BMSZKXcLrO/ZBzUbmKxWr8NYTrYY7RjOvli4hPHVC6n/5Hw05z+dqW0T67t6NLMAXQx/ZBOhnYnnd9CL59vcwcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 PH7PR11MB6427.namprd11.prod.outlook.com (2603:10b6:510:1f5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.21; Thu, 10 Apr
 2025 05:54:06 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8632.021; Thu, 10 Apr 2025
 05:54:06 +0000
Message-ID: <53c87919-6836-4052-b87b-c8948304ff16@intel.com>
Date: Thu, 10 Apr 2025 13:53:57 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/13] vfio: Add the support for PrivateSharedManager
 Interface
To: Alexey Kardashevskiy <aik@amd.com>, David Hildenbrand <david@redhat.com>,
	Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao
	<xiaoyao.li@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-7-chenyi.qiang@intel.com>
 <5d35d719-4640-4c11-9691-689d5ef38887@amd.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <5d35d719-4640-4c11-9691-689d5ef38887@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0043.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::19) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|PH7PR11MB6427:EE_
X-MS-Office365-Filtering-Correlation-Id: 473852d8-abf7-4096-320f-08dd77f41a83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ckNxdXlyS3hIZCtnbGtNV2FsaTFiZVN1L0EwODlQSzlIL3hWVkVsWU9qMVV5?=
 =?utf-8?B?Zy9lTHd2ZnA5TlV4UnkrRFROY0F1dHZqbHNWUVArZmhXWUlpTTh4bVVadkdE?=
 =?utf-8?B?NUl5YUZWN1JxOFhFUmZMMWV5bDJRQWJhZFRZVWlVTE5GSzlBZVAxYitBT3hR?=
 =?utf-8?B?ZTJOdVdyQXN6UHNEaEdpUGxmbStXNkhmcC83cnFiMW5jZVFLd3UyUmxQdTJa?=
 =?utf-8?B?VmxZU0d0Vkozczc3bW9DOHN6VU9Bd1Bqc0IySGlIejFnZE5qck9uRjN0c2sx?=
 =?utf-8?B?NGZXcEoweUpBREhZNnZIemdSUjF5TzVQeWUxamV1T0lZdmpvOEJIVjdlMTBv?=
 =?utf-8?B?VnZSN1lDelhWanR1VlgvaUhrdXRqNm1MYUJFbE5QKzVUbmVDbk9kK1ppQ2wv?=
 =?utf-8?B?d0c0d3FJaFVWbmtNWmI1amRVODF3OUFhd0h1c1FXUzJ5akcwT2VvR0RycDlv?=
 =?utf-8?B?WEVJZllDaWNXNlFWdXRaWjF2QUF2TG5mWVUzcUI4eGlPM3FCcEZVemFzS3ZR?=
 =?utf-8?B?czhsUlZNc0R6QVJhMFB6S0FDZXRoTkdad0xVV3hBNXgvYWJKb0EybkM4UkZL?=
 =?utf-8?B?WjA4dWxGRzRZSk1PZ1NlblErRy9wOXpkU0VOUlhidWVkaUZuSDR2Qjc1NDNn?=
 =?utf-8?B?aE5rUTRBb2M5MTJTNk8zZ1VwQlJKamFGUTRBdnQ1cUIwVmR2WHNzUW5Ic0pr?=
 =?utf-8?B?SWxBMVY5UjdoZWhmWlVQQk1LUFl3QWpLMDk1d3ZOdUg4QThFOG01TFlIaytC?=
 =?utf-8?B?M2E0Zng5QkE0bkNSam5tVXBQT0xEVEt1TjNNMVF0eTF4dTFJbC9qZmFMYU0y?=
 =?utf-8?B?UytGeHZJbm1YTjllbldLcWQwdkYrL3U3QzFDWTZzcm1QY3VueWQ4WmpPWXZx?=
 =?utf-8?B?Um81d281UHE1dlc1b2RhVlBMeVB0QzJnUld4NHkwSDhvK2ZBTVlxUU1UeEc4?=
 =?utf-8?B?bmpVdlowUHBMTm1qbk8vT3Z1ZjczQ2d4cmpxODErdnRNNC9JOWhhcnV3eWZz?=
 =?utf-8?B?OHVYYW4xbFdSWDdnNGVHaTR2VklPMHFRQXo1UUgrNEl1d1VhaUhEbkZRSGly?=
 =?utf-8?B?WlhzTlNYSktZR3JnK1Q1MnY3Skw0WlBlazVlSTE4N1Q2OVNrRW00K2pHbHFo?=
 =?utf-8?B?aCs2bW9QS2JuVThFbGFJU3l6a2pTbDZrelFscEJ3b0UreTlsKytRZHRSMlRL?=
 =?utf-8?B?Z1lTTXJWeFRGQXJaMWY0V3pjaEVENXdrL2lCRlA4ZXhSUmJ6YlZUcEtnQ1p5?=
 =?utf-8?B?V1cvMnlOcHlGNzlMSkN5YnRqakc2dFdicDJ0MTgwNm5LNkVOamVod2RPVTNR?=
 =?utf-8?B?eExSWmNqQk9jTG51R2hVSENTVnY0eWdON3lkUHBlTzJVM3MzN1UwVWFFS1k1?=
 =?utf-8?B?NzZ5K2hPZEMrck50dlkrWEpkM2Q1QkJUSnVHZTRsalRNbU9NR1NWWDlmdllV?=
 =?utf-8?B?c0ZjZVNpZjFpT3VMdkNISlp1c1BBVzY1b2lxWk1aNDR4MTIrRlZHc2RxZWh6?=
 =?utf-8?B?a29xdVZ6TVFFTkdRSWxSM1NlVTBVOUZYUkxNNzJKL1NJek9SWC9uR2prSUpr?=
 =?utf-8?B?bURUNWJ2VVlxVWswMStWclFGMzF0eUJpeWNtTmN6Yk5lREFqY2tuRzVTTkR2?=
 =?utf-8?B?R0RRakEwcDJjR082d2VydmZkVndDWmVidHNhaERvTTJOd0pZTzRGUFc4QTZE?=
 =?utf-8?B?SzlEOXJQNmIvdkFVaHA2TWlKVVh2OHZGQnR2TnFCemxqVDZraDJqSmhZbjdz?=
 =?utf-8?B?bUZQbUJMZzhESDYzUm1BbnI1SnhJNXNLcTdXaTNVU08yQUZ0TmZlaFM5N3pM?=
 =?utf-8?B?ZFFhajA0eFZWbXAwSEViaFlBK3hhZ1V3YmVIWUIzeldDOWZidUNCYVM4Q3Vl?=
 =?utf-8?B?SWtvT2tBaDZlZ0JUdUxDa1JackVLK3VlY1JtelZlZGdIekw3SHFKcjA5bW9x?=
 =?utf-8?Q?9OQ7vqHF1ME=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VFF2emhWam5MVEQ0Z2NLZWNMdFFYRXorT0NTVXdwYUwrV2ZxSkI1UGxWaHE4?=
 =?utf-8?B?aE5YMU5LOE9xdzNlb0N1b3M4cWF5YTBQajY4SHlzZVVxeURabmF2dHZOdGc1?=
 =?utf-8?B?YVVhcmJYY250alVaM0pMSzA5a09sTWRNZDBINmJXRTZ3blRjekVNd2NQdDlN?=
 =?utf-8?B?VWp2OElLVWs5YnNGYnV4Zkx4bjFXa0hDRmFHTW15SzFpd0hkVmlJUzJxYm9T?=
 =?utf-8?B?SEtpV25WdFR6ZTIzVXU4NkxmSVRmUzFMY0VUc1RxdW02eDE0cEhiYkt3NTRD?=
 =?utf-8?B?MHJSbkV2NVVRazVCOFZBY2R2Wkc0Ti90TklxVWVKRU5STGRUQW8vTXJCV1pT?=
 =?utf-8?B?M09HMG5ZNUhkaXhRVmZnWjhXM2tnUGJvbTU0emxNaHFVWUJqOENwcklHZXJX?=
 =?utf-8?B?WHJuQ1Jha0x1UzZ4TDNZeHc0LzdReGZaSGR5OC8rSDJmMmx0TjE0d3NlcW1N?=
 =?utf-8?B?S3pqU1pPY1d6ZnRzM3FhclJuY0E2Vm5hN2JSaGg1YmFzV1Q3c2VaOTVqd0lq?=
 =?utf-8?B?WnJ3RDhDOGU5UjBjSTllUHc1WnRNdVR6V3FkYTNjWlFlcU1yT0Nla01hSjNQ?=
 =?utf-8?B?QXVHbzB6QnR4SlNKQVJEcW5rM2xrWlkvZ1kzSUNaTytIdkcybC9pNWFQbnk4?=
 =?utf-8?B?K3BVeWViM1ZvaWxGeC9kQ2FRamhMZ042c0k2U1Y0djFQdXExUTQ2cVM3eGcw?=
 =?utf-8?B?QnZnZktLYTFsZXQxR0tyQ1JKMFJWWXNRVlplVmM2Z1NjREpibkt5ay81WkEw?=
 =?utf-8?B?RE8xUFpXT01ucUxvWUM5MG1zUHVhajBwc214bEZYa2t3ZFd3SWxwS2ZTYnpM?=
 =?utf-8?B?YXUrcEtqSDJUVVFvUzZCYzlGZjJqaE9ZYUgyaWVjREZLNkdJVnNwNEwwL28z?=
 =?utf-8?B?K0RMclFsS1RCRHh0R083ZGJ5YUd3NDQ0MWhyOENwM3drSXlBQmVOc0JvTm5i?=
 =?utf-8?B?STlFYWY5RXgyMUtiZ2RFMDdwbUNyNmtZUlR2dXNGTTgzWkxwMVdWanNOTDJJ?=
 =?utf-8?B?eS8zZXc3TUptQklKcXVBL0xJT3VRS0R2U2lqeWpmbkI1WG5PUS9jREkvMHk2?=
 =?utf-8?B?dkc1RFZFQUJUNTVOTFpEbGc0dlRWckFIMDJtVXlDZkhMK0JLWmVvUWVlYjF1?=
 =?utf-8?B?QW45WHFVekhaa0xTc3NVMUE1ZDM2eGlKMlJFaEZYTFVkcFU5VngwZlg1MWhI?=
 =?utf-8?B?aDRLc3Nabk12Y1NNYTBvYWM2N3NpbEJXUUwxbXQ3NXJpQVNuK2RHVVNSZU5k?=
 =?utf-8?B?K2I5MnM1blB6ZEVVR3ZwazI1S2s3UTY4dDRoUzNmV0paN0NpeFVCVDVBQ3ZI?=
 =?utf-8?B?djI3OS9KZjlXWktlWW9Fd21uMUg2OXdoaTV1YjlSS3VuR09NYnI4bG9wM1Vn?=
 =?utf-8?B?K2ZPckVmTzZpb1VFdjhzeE5IYVBtYVROTTU5bTh1KzB5a1NuQkU3UWpWVHBQ?=
 =?utf-8?B?dTQ1ZE50Zm5Naytwa2c0YXdkcUxDR1ltaXdCaG5wUzhKUnBSZ2dOc2ZNcGgr?=
 =?utf-8?B?MHozbUVFL1hteVA5NVRGbEEwcEJiUXZmYTArQm5RWjd4RXdrOFdpazhGcURq?=
 =?utf-8?B?SGhycHNUeXkwTUZsZGhwQjE0VGVrVmpFMGlDdmtaQkZiNU9YNnMxanpFaUo2?=
 =?utf-8?B?QzRHQk85elc0RmJQZGNOTm52K1VwejRTeEpaVVBjRzBGQlpyN2hLbG5Nc0Fq?=
 =?utf-8?B?MGgvbVJBMjUyY2VFNGVvYytJZFpEUGdGRGpqbTFlS1dUcjV1RXNIcGZWZUpQ?=
 =?utf-8?B?bmNqVDVUK2FSc1ErTzNGUWJGSFFxdjlCWG5xOUNqTjdZRWN3ZDhFTlhIcmNI?=
 =?utf-8?B?TGk2eVFOYy9wTW1hb04wV0pYdGRYd3F0SXBxTXo5OFJ3bEZQZlpKMTBXVURu?=
 =?utf-8?B?dWo4UTRHU0NwVzU2N3V6clY5bUpWNVBZSm5KL3lRVzY2aDNyUC9ETXh6SjE4?=
 =?utf-8?B?UkRsVlk2RWlMVkpJcGJCcExHUFVocnc0T3ZpZnpDeVVMYXdtcHdUOFQyTnhs?=
 =?utf-8?B?K3pEOHd5SElUT3NRWGZaOXZDRGxteS94TlBzRm1qV0NRYVZsc1FtTlpVT3ZQ?=
 =?utf-8?B?bkZPRTJJemlQbUNUQjYrN21rZTZpWFhVMXpiUmVrRjZ2VU9hTXZnYm5MSk1L?=
 =?utf-8?B?WmlpdHpFdU5GQU50dWRSNFI5ZWloUmJSd0EyS3czcmNEdWVZdWRxOXJnWUIx?=
 =?utf-8?B?bEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 473852d8-abf7-4096-320f-08dd77f41a83
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2025 05:54:06.0497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xs53+IvOtSqgioE3x4bmdD0wzHsPok0kiLsejXCkzov23c0NX+bjFptykYrJKH2aZ6LgR0G6PMsJyHjDTlMhRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6427
X-OriginatorOrg: intel.com



On 4/9/2025 5:58 PM, Alexey Kardashevskiy wrote:
> 
> 
> On 7/4/25 17:49, Chenyi Qiang wrote:
>> Subsystems like VFIO previously disabled ram block discard and only
>> allowed coordinated discarding via RamDiscardManager. However,
>> guest_memfd in confidential VMs relies on discard operations for page
>> conversion between private and shared memory. This can lead to stale
>> IOMMU mapping issue when assigning a hardware device to a confidential
>> VM via shared memory. With the introduction of PrivateSharedManager
>> interface to manage private and shared states and being distinct from
>> RamDiscardManager, include PrivateSharedManager in coordinated RAM
>> discard and add related support in VFIO.
> 
> How does the new behavior differ from what
> vfio_register_ram_discard_listener() does? Thanks,

Strictly speaking, there is no particular difference except the embedded
PrivateSharedListener and RamDiscardListener in VFIOXXXListener.

It is possible to extract some common part between
VFIOPrivateSharedListener and VFIORamDiscardListener and some common
part of vfio_register/unregister_xxx_listener(). But I'm not sure if it
can become more concise.

> 
> 
>> Currently, migration support for confidential VMs is not available, so
>> vfio_sync_dirty_bitmap() handling for PrivateSharedListener can be
>> ignored. The register/unregister of PrivateSharedListener is necessary
>> during vfio_listener_region_add/del(). The listener callbacks are
>> similar between RamDiscardListener and PrivateSharedListener, allowing
>> for extraction of common parts opportunisticlly.
>>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
>> Changes in v4
>>      - Newly added.
>> ---
>>   hw/vfio/common.c                      | 104 +++++++++++++++++++++++---
>>   hw/vfio/container-base.c              |   1 +
>>   include/hw/vfio/vfio-container-base.h |  10 +++
>>   3 files changed, 105 insertions(+), 10 deletions(-)
>>
>> diff --git a/hw/vfio/common.c b/hw/vfio/common.c
>> index 3172d877cc..48468a12c3 100644
>> --- a/hw/vfio/common.c
>> +++ b/hw/vfio/common.c
>> @@ -335,13 +335,9 @@ out:
>>       rcu_read_unlock();
>>   }
>>   -static void vfio_ram_discard_notify_discard(StateChangeListener *scl,
>> -                                            MemoryRegionSection
>> *section)
>> +static void vfio_state_change_notify_to_state_clear(VFIOContainerBase
>> *bcontainer,
>> +                                                   
>> MemoryRegionSection *section)
>>   {
>> -    RamDiscardListener *rdl = container_of(scl, RamDiscardListener,
>> scl);
>> -    VFIORamDiscardListener *vrdl = container_of(rdl,
>> VFIORamDiscardListener,
>> -                                                listener);
>> -    VFIOContainerBase *bcontainer = vrdl->bcontainer;
>>       const hwaddr size = int128_get64(section->size);
>>       const hwaddr iova = section->offset_within_address_space;
>>       int ret;
>> @@ -354,13 +350,28 @@ static void
>> vfio_ram_discard_notify_discard(StateChangeListener *scl,
>>       }
>>   }
>>   -static int vfio_ram_discard_notify_populate(StateChangeListener *scl,
>> +static void vfio_ram_discard_notify_discard(StateChangeListener *scl,
>>                                               MemoryRegionSection
>> *section)
>>   {
>>       RamDiscardListener *rdl = container_of(scl, RamDiscardListener,
>> scl);
>>       VFIORamDiscardListener *vrdl = container_of(rdl,
>> VFIORamDiscardListener,
>>                                                   listener);
>> -    VFIOContainerBase *bcontainer = vrdl->bcontainer;
>> +    vfio_state_change_notify_to_state_clear(vrdl->bcontainer, section);
>> +}
>> +
>> +static void vfio_private_shared_notify_to_private(StateChangeListener
>> *scl,
>> +                                                  MemoryRegionSection
>> *section)
>> +{
>> +    PrivateSharedListener *psl = container_of(scl,
>> PrivateSharedListener, scl);
>> +    VFIOPrivateSharedListener *vpsl = container_of(psl,
>> VFIOPrivateSharedListener,
>> +                                                   listener);
>> +    vfio_state_change_notify_to_state_clear(vpsl->bcontainer, section);
>> +}
>> +
>> +static int vfio_state_change_notify_to_state_set(VFIOContainerBase
>> *bcontainer,
>> +                                                 MemoryRegionSection
>> *section,
>> +                                                 uint64_t granularity)
>> +{
>>       const hwaddr end = section->offset_within_region +
>>                          int128_get64(section->size);
>>       hwaddr start, next, iova;
>> @@ -372,7 +383,7 @@ static int
>> vfio_ram_discard_notify_populate(StateChangeListener *scl,
>>        * unmap in minimum granularity later.
>>        */
>>       for (start = section->offset_within_region; start < end; start =
>> next) {
>> -        next = ROUND_UP(start + 1, vrdl->granularity);
>> +        next = ROUND_UP(start + 1, granularity);
>>           next = MIN(next, end);
>>             iova = start - section->offset_within_region +
>> @@ -383,13 +394,33 @@ static int
>> vfio_ram_discard_notify_populate(StateChangeListener *scl,
>>                                        vaddr, section->readonly);
>>           if (ret) {
>>               /* Rollback */
>> -            vfio_ram_discard_notify_discard(scl, section);
>> +            vfio_state_change_notify_to_state_clear(bcontainer,
>> section);
>>               return ret;
>>           }
>>       }
>>       return 0;
>>   }
>>   +static int vfio_ram_discard_notify_populate(StateChangeListener *scl,
>> +                                            MemoryRegionSection
>> *section)
>> +{
>> +    RamDiscardListener *rdl = container_of(scl, RamDiscardListener,
>> scl);
>> +    VFIORamDiscardListener *vrdl = container_of(rdl,
>> VFIORamDiscardListener,
>> +                                                listener);
>> +    return vfio_state_change_notify_to_state_set(vrdl->bcontainer,
>> section,
>> +                                                 vrdl->granularity);
>> +}
>> +
>> +static int vfio_private_shared_notify_to_shared(StateChangeListener
>> *scl,
>> +                                                MemoryRegionSection
>> *section)
>> +{
>> +    PrivateSharedListener *psl = container_of(scl,
>> PrivateSharedListener, scl);
>> +    VFIOPrivateSharedListener *vpsl = container_of(psl,
>> VFIOPrivateSharedListener,
>> +                                                   listener);
>> +    return vfio_state_change_notify_to_state_set(vpsl->bcontainer,
>> section,
>> +                                                 vpsl->granularity);
>> +}
>> +
>>   static void vfio_register_ram_discard_listener(VFIOContainerBase
>> *bcontainer,
>>                                                  MemoryRegionSection
>> *section)
>>   {
>> @@ -466,6 +497,27 @@ static void
>> vfio_register_ram_discard_listener(VFIOContainerBase *bcontainer,
>>       }
>>   }
>>   +static void vfio_register_private_shared_listener(VFIOContainerBase
>> *bcontainer,
>> +                                                  MemoryRegionSection
>> *section)
>> +{
>> +    GenericStateManager *gsm =
>> memory_region_get_generic_state_manager(section->mr);
>> +    VFIOPrivateSharedListener *vpsl;
>> +    PrivateSharedListener *psl;
>> +
>> +    vpsl = g_new0(VFIOPrivateSharedListener, 1);
>> +    vpsl->bcontainer = bcontainer;
>> +    vpsl->mr = section->mr;
>> +    vpsl->offset_within_address_space = section-
>> >offset_within_address_space;
>> +    vpsl->granularity = generic_state_manager_get_min_granularity(gsm,
>> +                                                                 
>> section->mr);
>> +
>> +    psl = &vpsl->listener;
>> +    private_shared_listener_init(psl,
>> vfio_private_shared_notify_to_shared,
>> +                                 vfio_private_shared_notify_to_private);
>> +    generic_state_manager_register_listener(gsm, &psl->scl, section);
>> +    QLIST_INSERT_HEAD(&bcontainer->vpsl_list, vpsl, next);
>> +}
>> +
>>   static void vfio_unregister_ram_discard_listener(VFIOContainerBase
>> *bcontainer,
>>                                                    MemoryRegionSection
>> *section)
>>   {
>> @@ -491,6 +543,31 @@ static void
>> vfio_unregister_ram_discard_listener(VFIOContainerBase *bcontainer,
>>       g_free(vrdl);
>>   }
>>   +static void
>> vfio_unregister_private_shared_listener(VFIOContainerBase *bcontainer,
>> +                                                   
>> MemoryRegionSection *section)
>> +{
>> +    GenericStateManager *gsm =
>> memory_region_get_generic_state_manager(section->mr);
>> +    VFIOPrivateSharedListener *vpsl = NULL;
>> +    PrivateSharedListener *psl;
>> +
>> +    QLIST_FOREACH(vpsl, &bcontainer->vpsl_list, next) {
>> +        if (vpsl->mr == section->mr &&
>> +            vpsl->offset_within_address_space ==
>> +            section->offset_within_address_space) {
>> +            break;
>> +        }
>> +    }
>> +
>> +    if (!vpsl) {
>> +        hw_error("vfio: Trying to unregister missing RAM discard
>> listener");
>> +    }
>> +
>> +    psl = &vpsl->listener;
>> +    generic_state_manager_unregister_listener(gsm, &psl->scl);
>> +    QLIST_REMOVE(vpsl, next);
>> +    g_free(vpsl);
>> +}
>> +
>>   static bool vfio_known_safe_misalignment(MemoryRegionSection *section)
>>   {
>>       MemoryRegion *mr = section->mr;
>> @@ -644,6 +721,9 @@ static void
>> vfio_listener_region_add(MemoryListener *listener,
>>       if (memory_region_has_ram_discard_manager(section->mr)) {
>>           vfio_register_ram_discard_listener(bcontainer, section);
>>           return;
>> +    } else if (memory_region_has_private_shared_manager(section->mr)) {
>> +        vfio_register_private_shared_listener(bcontainer, section);
>> +        return;
>>       }
>>         vaddr = memory_region_get_ram_ptr(section->mr) +
>> @@ -764,6 +844,10 @@ static void
>> vfio_listener_region_del(MemoryListener *listener,
>>           vfio_unregister_ram_discard_listener(bcontainer, section);
>>           /* Unregistering will trigger an unmap. */
>>           try_unmap = false;
>> +    } else if (memory_region_has_private_shared_manager(section->mr)) {
>> +        vfio_unregister_private_shared_listener(bcontainer, section);
>> +        /* Unregistering will trigger an unmap. */
>> +        try_unmap = false;
>>       }
>>         if (try_unmap) {
>> diff --git a/hw/vfio/container-base.c b/hw/vfio/container-base.c
>> index 749a3fd29d..ff5df925c2 100644
>> --- a/hw/vfio/container-base.c
>> +++ b/hw/vfio/container-base.c
>> @@ -135,6 +135,7 @@ static void vfio_container_instance_init(Object *obj)
>>       bcontainer->iova_ranges = NULL;
>>       QLIST_INIT(&bcontainer->giommu_list);
>>       QLIST_INIT(&bcontainer->vrdl_list);
>> +    QLIST_INIT(&bcontainer->vpsl_list);
>>   }
>>     static const TypeInfo types[] = {
>> diff --git a/include/hw/vfio/vfio-container-base.h b/include/hw/vfio/
>> vfio-container-base.h
>> index 4cff9943ab..8d7c0b1179 100644
>> --- a/include/hw/vfio/vfio-container-base.h
>> +++ b/include/hw/vfio/vfio-container-base.h
>> @@ -47,6 +47,7 @@ typedef struct VFIOContainerBase {
>>       bool dirty_pages_started; /* Protected by BQL */
>>       QLIST_HEAD(, VFIOGuestIOMMU) giommu_list;
>>       QLIST_HEAD(, VFIORamDiscardListener) vrdl_list;
>> +    QLIST_HEAD(, VFIOPrivateSharedListener) vpsl_list;
>>       QLIST_ENTRY(VFIOContainerBase) next;
>>       QLIST_HEAD(, VFIODevice) device_list;
>>       GList *iova_ranges;
>> @@ -71,6 +72,15 @@ typedef struct VFIORamDiscardListener {
>>       QLIST_ENTRY(VFIORamDiscardListener) next;
>>   } VFIORamDiscardListener;
>>   +typedef struct VFIOPrivateSharedListener {
>> +    VFIOContainerBase *bcontainer;
>> +    MemoryRegion *mr;
>> +    hwaddr offset_within_address_space;
>> +    uint64_t granularity;
>> +    PrivateSharedListener listener;
>> +    QLIST_ENTRY(VFIOPrivateSharedListener) next;
>> +} VFIOPrivateSharedListener;
>> +
>>   int vfio_container_dma_map(VFIOContainerBase *bcontainer,
>>                              hwaddr iova, ram_addr_t size,
>>                              void *vaddr, bool readonly);
> 


