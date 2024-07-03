Return-Path: <kvm+bounces-20915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B5C68926A69
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 23:38:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3606C1F230E4
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 21:38:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7643149636;
	Wed,  3 Jul 2024 21:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cJU7PCgD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177EA2BD19;
	Wed,  3 Jul 2024 21:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720042685; cv=fail; b=IQZgEGCl1dYV0CccMv0NVqLw1Yzpc6N4oWSgvOkalvq8NdtMF9QUWve4zD0jEuz9qWax3VdBHR8vwUMnTL2nHQqwCFpiZAoMpDY9KLN0cC7WWZr6QUZ/LInpcZYp0ntVMdtiSty3NDH713ybcbspH7HMhfKqp4XmCfoo2i1pD+c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720042685; c=relaxed/simple;
	bh=ygCFcCgOFxTeCsRHpsoPJJckcu19QoNQfnc+c38IfGY=;
	h=Message-ID:Date:Subject:From:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=u0N7GAn5wH/ndhWwVWvB0LA8gkNGtdkW11WPK6Y/1x4Fh5iTe1F1tAuCgG7i9r9s3McuoQbq79kNwYEdkjWpGn5lYyIBc3IxoJlZB2gOdRIn8zO+lvFOz6pS0RDAJiuyI0T+EtpPp9UW7zDBwuEH51/c8cOWVd3DvUvq85U42Wk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cJU7PCgD; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720042684; x=1751578684;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ygCFcCgOFxTeCsRHpsoPJJckcu19QoNQfnc+c38IfGY=;
  b=cJU7PCgD0RG1W0i05hUB40gh4RWz7jIUB7ZBTLrL8iUnWf6BuRMdXfRH
   dGG+CAfz9PWr0r2GCyRVhuFOjtpzkuh+kAdYnNExHFVB7nhDkQWn3AZgF
   uK1lXGT4ZsVDtY5AkYnJDAhhY+8JZV1lxtgz0Vk0WBjvi3gZcVAHNgyKJ
   0Jtka9++epDyOdvhsneAJ9wO74gd62Vd0J+H9VreHtlr8lBfgS0O3XTVo
   JaUSlDbxJLYzLAG96LEBarsPG7ShrxSv3C46j7cli7SnQBQXOlLaixpVI
   Dt3mCXzE6B3YSIcaH2pEktcuijYANQlVFya9Mhre16QaqpDmJs6FSs1Nq
   w==;
X-CSE-ConnectionGUID: B/xmXGiZTJaJ1G9piYFteQ==
X-CSE-MsgGUID: W6W95T12RXSGDvBzIm4ZSg==
X-IronPort-AV: E=McAfee;i="6700,10204,11122"; a="20202510"
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="20202510"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2024 14:38:03 -0700
X-CSE-ConnectionGUID: w/byZf30QQaWuZGdeKyCnA==
X-CSE-MsgGUID: C5uFQ54lSxmiMQWfzkVU1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="50836347"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Jul 2024 14:37:44 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 3 Jul 2024 14:37:44 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 3 Jul 2024 14:37:43 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 3 Jul 2024 14:37:43 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 3 Jul 2024 14:37:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f+IFoT+yuBgrI/HXoOBdeI6b0QDVY3LphOxL9ZuR1Fjnj5LW1SQxne1cXE/DLSlIMpbLekP2ucc3oY+CjFPiIHcDE3hL5Vm60myd4up/CCcYvQ8kwzHoTTT/efXf8arz1ODTZXGB/mV/+ulZ51hHcwRGkrhvgLCujhOAK28n6t0lmmRP5MHke/9YatAzTdITNEkC1TgnUPVNUY8ZLdlRI2pf+oiTKWmEjKTa9ECc1aCBLOmjn1sto+Wk69Q3VzNSo8f5YWa5VyWxVlXSW3bEE0ZNKqQR/uCNQSyj47583rRm95vkzeom6TcUGoYqSS1tgwzL3tFgYZy6U1I1HA2tdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aAcBdTQTieWS14AH77vpV0aGeTu7NvrEKr5+MRy6DaI=;
 b=QjslywrjTuN0VML81LWUcj75MzcXmYqe7qIpNjCKFIIKxv0K0LO5FO2uMlfwWuS+hSQsrG7GJRSvkfY2ZZrGvgzWUHVulGePh7VBxbJDTF56rCj+nD6FEuAjWaNn1Za+Qs16gkX/grrQHQ3QZWq8qcQjq+aparnxpzC0P/WvocTDBgjqosfxbr37bt9ZqpxiQm6aEGVqY38tftpq9jW5oPDWWjzJGtpeGDEEF7E87VTyNB1LCMQXXKFn279WX6BXdwaqRfxcyXnYVgmxNGtCu6g89fVCGREfjijXEhW287Uyjvt4d98r8kPfL6hpzKZXgelgikPlIfVkx/OPhoRTLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA0PR11MB7934.namprd11.prod.outlook.com (2603:10b6:208:40d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.36; Wed, 3 Jul
 2024 21:37:40 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7719.029; Wed, 3 Jul 2024
 21:37:40 +0000
Message-ID: <9b19f440-ee78-4a4f-ab87-e9fff26ea6a4@intel.com>
Date: Wed, 3 Jul 2024 14:37:37 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: VMX Preemption Timer appears to be buggy on SKX, CLX, and ICX
From: Reinette Chatre <reinette.chatre@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <isaku.yamahata@intel.com>, <pbonzini@redhat.com>,
	<erdemaktas@google.com>, <vkuznets@redhat.com>, <vannapurve@google.com>,
	<jmattson@google.com>, <mlevitsk@redhat.com>, <xiaoyao.li@intel.com>,
	<chao.gao@intel.com>, <rick.p.edgecombe@intel.com>, <yuan.yao@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Hao, Xudong"
	<xudong.hao@intel.com>
References: <cover.1718214999.git.reinette.chatre@intel.com>
 <2fccf35715b5ba8aec5e5708d86ad7015b8d74e6.1718214999.git.reinette.chatre@intel.com>
 <Zn9X0yFxZi_Mrlnt@google.com>
 <8a34f1d4-9f43-4fa7-9566-144b5eeda4d9@intel.com>
Content-Language: en-US
In-Reply-To: <8a34f1d4-9f43-4fa7-9566-144b5eeda4d9@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW3PR06CA0027.namprd06.prod.outlook.com
 (2603:10b6:303:2a::32) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA0PR11MB7934:EE_
X-MS-Office365-Filtering-Correlation-Id: 49f5154b-ae15-4dfe-0256-08dc9ba85d5f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?T3E0SHdNaExpOGE0MVRiRFRlOVAwSHJreDZnTlM3QVUvaWh5aXIwSGUrc0pP?=
 =?utf-8?B?SnFMTFVmZS9pY3hMTDZTRVpiclFVTzU4ei9tblhkd2kvTFVXQlkvS0pzbXcz?=
 =?utf-8?B?Ym5oSEhmS3VEYy9NTnhiL0o2YTIzY3czSGRheGhBT0ZVaTRFMncvYTh6aGJ0?=
 =?utf-8?B?c2hwYmQ0VTAwekd3eUJVUlNObi8rOGJyVFB0enVsdUZWSTFqblQycjJtaHJK?=
 =?utf-8?B?MFBOUWswWFZXOTJSeDl1UjdpaWxzeDhUSGFiWW9seU10djMvT2NDeEpia1Ri?=
 =?utf-8?B?KzhxSjcrYXY0UitlTm5Kc3dmMmFqODFpQ2NIb21WOWF2dWZBd3VySks1VmxW?=
 =?utf-8?B?QUpnV0dBNWh4ZkVKRkZpUUdlRU5MbHptNmhTeWdsYXlhV2NTUTJOd3ZnYmlP?=
 =?utf-8?B?djZ4ZlpXWm9OOVJvS2xBbEJtZGgrNkV4eGw0d0hQOXJYSUtpQlZLTWtmTkc3?=
 =?utf-8?B?VzRxZ0NWZURzTUFIOW0yZm41bjc0MlJpOHA0ekowVUd2WUJETndOTUZhQklF?=
 =?utf-8?B?U0NYVUxrdkdQRm1RUkplaS9DcHRSOFBMNlo5MG9WWERmQklCRm5JVmZjaDhE?=
 =?utf-8?B?UTZkY2ZaUEFrNlRhZys5aEpQUDRVaGgxVnZ3TEVZZHdiUG50Z2FaQzlySzIz?=
 =?utf-8?B?TWNEWlpwVzUvQUhvK3dTZGo2cERIQ2ZQd1BJemlZeTlleEd4QVByR2RFUm03?=
 =?utf-8?B?bDVkRVZZN1hpOFU0VWFFK1owak9iSXp0MzBHVm13UzlBT0IrVnUwSDEycUtZ?=
 =?utf-8?B?UjlQRGo0RCtjVDFkZVk0NkNRb2VON1p5U1h3QWJiakVXc3hVSGoyRlRwdzJF?=
 =?utf-8?B?TFpoOHNVV0hyMUoydVl5STlPTW5KejZobU5Nak1hSUUrWGkzUmpxMm56T04z?=
 =?utf-8?B?VldYRVlkamJRUEtldCtEVmE3RWxteUVtWmJmZGI2T3Z3Y1loQlE3N3h3Z2ND?=
 =?utf-8?B?NTVQcm1OTEZIMTN3ZHhDUWphVnRhdFFXdEg5dDJuSmF1SkdqVFhLeGlIa3ZR?=
 =?utf-8?B?UC8zeUYzOGtNd2NQSHR0dkxxMksxeDgyRWNNVmxEb0JVUFk0RjRwcWZSeVBC?=
 =?utf-8?B?WVpEZmppUVUyUE1kcENMYU5WOCtpdVdkU0Z6R3cwSitnT29MdUt1VHIyYlRk?=
 =?utf-8?B?aTM1UzJRRmpJTFFOL2JtUjVMMnpac01HR2RVT2JPZ0JrVUtjQXVJcm1vZlRj?=
 =?utf-8?B?VnNsSFk1V3NyRXhRenc4aHZJdWpPOHN2VzRTa2dqMG1oSElOQ2NFRXM4eExi?=
 =?utf-8?B?dC83RTkzci9CVm85eGo4Z2lFRTlIb0hEK2NqMkdsZzRKQ2ZxVmRsemRmOW5W?=
 =?utf-8?B?dU5vVFJRT0xhMVg0K2RzOHpCcVVaYy9SODd6SW00dG1raWs2eVpuemgvcG9z?=
 =?utf-8?B?NXB0bEN5SWJnOUhxM09LMXBMVFQ2azhUd3BmQU80dHA1cG5Yd1FTaXdra2ZN?=
 =?utf-8?B?SUd3RUZTVDhGS3Y2aXZSUWNHL09KTlZRbkNPNHBqZkhaeW5mQ3ZOWnV1S096?=
 =?utf-8?B?U0dMN2lqOVNkRXYzcm92T21Jc3JwbDhlZnVLMmdpWmV4bWhLejhaT0VrZHVW?=
 =?utf-8?B?c2tvVmlOWTFGU3JsV25NTUxCVHdjVEF2T3Z6R3NyQnJPYkw4aElqN1BVMnZ4?=
 =?utf-8?B?WWIwUEJhS1U2UmROSWpCOGpqNUJ1a2w2S213SHJzK2JsNWVoODV3T2pobnRm?=
 =?utf-8?B?bGZ6R1dLRFV3UmdZRFVzRlJMaXhOVUl4NGdhZ2lMQkRUMkxoZjM3SkhxRXY2?=
 =?utf-8?B?MkRkaXp0SlQ0WDZvMTNvQStWNXlja1pBQm55UlJUbmtQZE0rdW95dVdCUCtw?=
 =?utf-8?Q?ppnIzdoL7dkv1g2M8cTL5XsSL24w7g/ANi7rI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aFBxMGZSMzNxSm4vR3BGTndJUGxKaVBvQ0VIYktHWTdMNFl4Tkk1Wkk1cHRE?=
 =?utf-8?B?Q05IcmM4b2xKUVJGaGM3emdOS1ZWT2tkV2drcXhSZXU3K2pNM1BrNXpDaEV3?=
 =?utf-8?B?NHdUT3p1TW1WK2V6VEtsQlF5azBDUVo3SmtHdWlsSXV0dXhEN05BK01NcGJP?=
 =?utf-8?B?bVBXWk4rRG9wbjJmcUZqTHhjaUxXa2I0L3JoSnQycVNyeXZoaFpRdWNWK2ho?=
 =?utf-8?B?enZWZE5PRkJoNm4vYUJvUWFjL0pGMyszL1RMVXRrbE9UYmtkcXZ0TmRJcmFs?=
 =?utf-8?B?Z3VRcmYzZFVlZUJ4SEtsTFJHRy9yK0pFK0QyOXhIU1A5dDJ0eVNQK2RlSW50?=
 =?utf-8?B?d0NHVkc0S3FoYjUzNnRNbmtISXJBRTRMUW1ubW04NE1mdXpyZzRjdHpTRkN2?=
 =?utf-8?B?Z0c4WTBzcTF5MHhiOEN2STJuUXJzanM0dzZ2R3RRaHZ5dVJNUTI5cVpDWUFK?=
 =?utf-8?B?ZTNrWTQ3RVFVWnhGeFZ6a2x5MEFFb3poZEZHZ3pYQWFzMm4vdGk0U1NSVEQy?=
 =?utf-8?B?WGUyRUpvMnlENVd1SWlSNERxc2Z5djZTTDM5bE0ySDJ5dlQvQ0F2aU9zYVky?=
 =?utf-8?B?RGtuc3JrWEdqdU5keEJKRjBkWUhjcjY4dWt6ejRNWVdhbjlPTkZXS3JnQTAw?=
 =?utf-8?B?WFNzT0w1UXBTOWZqakhBcGQrMHJ5OGZwaVBSRE5kampobTMrRkpCcE4rL0RO?=
 =?utf-8?B?dS9ndGxEUlVvaVZGOHNUZlBnL1pVUXZtbUx6Sk4wZW9tNWptM1pXbitHbnZO?=
 =?utf-8?B?Yy8wV1l3RVMxQmJwOW42bmt5cm5seXl4YzY0Z2tHQUc4SVZDdUxIY1hKcGtN?=
 =?utf-8?B?V1BMZ0RKZGJpL0MrdXVqS3JycklxSHlDNnRpZ3c3Y0cwK0pBZGhWemppdW9z?=
 =?utf-8?B?SEx2YkhMYlRlVUlUYzR1eEtjcmpudFNUc1lpZ2hhZmtYNEpTZ01RSC9ZUlhh?=
 =?utf-8?B?N2Z2dlBwNTV3Zkg3S3NQcEcybWsyMTRTcmVCeDM1Nlk3TXdZOVB5TWZYUklC?=
 =?utf-8?B?aUU2R2RPNndhNTB5bU9adFpKLzNUUmh1ZDM1SEVaaG5aNWtRb1o2eWpZQ3Ez?=
 =?utf-8?B?MXN5K1FFdUFOdHl6a1BIQlo0aEZtZWtNaFV4K3Y5NGJ0REJUNGErcklqWnE1?=
 =?utf-8?B?ZmlJKzZsWUxqenI0MS94d2RxbmYvZXJFTGs2ZEc3bW00RlhPdFRqdHpFY09W?=
 =?utf-8?B?WmNnUTdrVm42NzZlR0RQTHFGdlAvTzU2V1JTZzRmTitZUlc1VmFEdG40RXJJ?=
 =?utf-8?B?a0puQzIzQmVUMktheU1HcXVDbldSbEJaUUNVOFphUUtmbWZZK1hCTGhQSi9o?=
 =?utf-8?B?VVU5RkpIY1p5d2JzTERxZXdjK0RFaUFoQ3RXWER6ZDV0V3l1NFdrdlM2NXFq?=
 =?utf-8?B?S1ZHdXpLL3RlM2lWdGRkd0RuYU51SERNV2Y2UzZ3QTF0TkQzN0xaSkZpT3Np?=
 =?utf-8?B?WklFTlRodWkvQUNQeHloaGNvdFVGRVZhMmRBcGJNblJjR0JreUxIWitiOUJ6?=
 =?utf-8?B?VEdDS01ERDJVUk9aWGZkNnhwNGZjck9kWlBNRFZKazdqUWxBYWhvakp3a09v?=
 =?utf-8?B?ZkoreHJpd0JJVDB5TkpQbVU5V3FZRENIc09LNng2VzJnYnFUWnVEdjZRVjNE?=
 =?utf-8?B?dmhnQkZLU0VxU3htMDBmR1p6bjlycEpibjJCNDJOd1BCUllpMWRzaVFyRGRJ?=
 =?utf-8?B?TWdyYkEwV0RlOEhPenVMcGh4amR3TDU5WEczYnhsNmdaNGhCQmxhbTFBaDM5?=
 =?utf-8?B?MGJrOXNPOVc4ek56RFIzcmJXd0tXSnFvZ2pJLzNOcDhTL25WT25SMGM0ZitX?=
 =?utf-8?B?SGpoa0NHcnVRTjArUzQwWHRWSHgrQjJnenhXcnYvVzZiZFZGbjJ3S3RuVk1s?=
 =?utf-8?B?YkRnNzF2UjBXbTNaMjY4VHh1cExVWXk4TWU1aWJZVklRdDBpSEFFNCtoNFE3?=
 =?utf-8?B?OFNWWDBHa0MwOWFKVXRHUGMwV1J2WElCYXZnak1BMndjM3RhaE9ETWFBMjNB?=
 =?utf-8?B?S3dmbkQ5cTJ3Ym9LQ0FLYWVrd0N5RjYyU1FxT2pnSHZDZkpUVVo2MTlIVUhL?=
 =?utf-8?B?QWNjYU1UTW1wV0pQSCtZZk9PUDUwUFhtWS8yM3BWbEwxNVNrREwyM01VcFUr?=
 =?utf-8?B?dkp4bU5nWGs4NzI5VVlHK0h5ZkNPN0JzZHV4MGRicHBDRitESDAwSkJhbTN5?=
 =?utf-8?B?U1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 49f5154b-ae15-4dfe-0256-08dc9ba85d5f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2024 21:37:40.4101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0d5Y3Y+mu+IUd5L/hp/a0lueZiEO0QWFVWKBHNquI0WYHGr1fIsmHydFRBP9KHv9VVo0AljBFltC7nVnyII1OHYY9yAg0FLTY+iedi65N5Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7934
X-OriginatorOrg: intel.com


(a short update ...)

On 7/3/24 1:14 PM, Reinette Chatre wrote:
> On 6/28/24 5:39 PM, Sean Christopherson wrote:
>> Forking this off to try and avoid confusion...
>>
>> On Wed, Jun 12, 2024, Reinette Chatre wrote:
> 
> ...
> 
>>> +
>>> +        freq = (tmict - tmcct) * tdcrs[i].divide_count * tsc_hz / (tsc1 - tsc0);
>>> +        /* Check if measured frequency is within 1% of configured frequency. */
>>> +        GUEST_ASSERT(freq < apic_hz * 101 / 100);
>>> +        GUEST_ASSERT(freq > apic_hz * 99 / 100);
>>> +    }
>>
>> This test fails on our SKX, CLX, and ICX systems due to what appears to be a CPU
>> bug.  It looks like something APICv related is clobbering internal VMX timer state?
>> Or maybe there's a tearing or truncation issue?
> 
> It has been a few days. Just a note to let you know that we are investigating this.
> On my side I have not yet been able to reproduce this issue. I tested
> kvm-x86-next-2024.06.28 on an ICX and an CLX system by running 100 iterations of
> apic_bus_clock_test and they all passed. Since I have lack of experience here there are
> some Intel virtualization experts helping out with this investigation and I hope that
> they will be some insights from the analysis and testing that you already provided.

I have now been able to test on SKX also and I am not yet able to reproduce. For
reference, the systems I tested on are:
SKX: https://ark.intel.com/content/www/us/en/ark/products/120507/intel-xeon-platinum-8170m-processor-35-75m-cache-2-10-ghz.html
ICX: https://ark.intel.com/content/www/us/en/ark/products/212459/intel-xeon-platinum-8360y-processor-54m-cache-2-40-ghz.html
CLX: https://ark.intel.com/content/www/us/en/ark/products/192476/intel-xeon-platinum-8260l-processor-35-75m-cache-2-40-ghz.html

Reinette

