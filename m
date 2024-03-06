Return-Path: <kvm+bounces-11207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0195B8742C1
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 23:26:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6EDAD1F25982
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 22:26:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B51EE1BDD8;
	Wed,  6 Mar 2024 22:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hn03Yafa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8861B947;
	Wed,  6 Mar 2024 22:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709763965; cv=fail; b=G/Sy1lHYtJKrwAxXGbUVYi9ly40PUE5IzNlTKhA6+EKRPw9WbwrcXPKxfWbzTiySPGFb8CH4cTB211OWMTFbvdt1v9k/kf9bW/gY0vdA1hsT3XFY1xM7nTQvY0gNALZLq3AfcDCKe2QBxpRnqpkBvtQdrrkFEx+fJyzb/CE+wAw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709763965; c=relaxed/simple;
	bh=9gLhdxM7E8tB3y9bTAw9EZbP7GlsZk56P4+FX+NAQrc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mFRJuOTJ7FuSBpnbzZLpgyiT2DUJThtrIWLXOFKG8PHpHHptHBzgzjHHk/GxWXo5L2a0dCLJdcrGpPLogSCKuOPOfrYixZYGkCHkP5a0iYtKSlvGdvxocyFuZz0LA3QG9UeOOZVKolucB2yjT/0amXpKQ6q0jv67aju4hOGGAgA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hn03Yafa; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709763964; x=1741299964;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9gLhdxM7E8tB3y9bTAw9EZbP7GlsZk56P4+FX+NAQrc=;
  b=Hn03YafaeCJ1qeeW55gMOsbqaV+xMiI/mYUcap+RXYxrPxj+9VbmXNu3
   AGLaiejEyYXFgULGwapTCAOenqRTQNK+314itnZCWOvI55ETtLic+me8q
   jwbTiA7QhpmMHti7saBEnIGV8ANi2JMuTD1sQVyUz4R1efPdE7EXRk2Si
   b0B6ZaBEJYETJRmK8CjqjPRPNib4PrzuK6nSarjOxKj3OjoPUlHPxlTgP
   mY/osKH80UQ+Nb5l9vXYD3z2zHanre2/GQaesqDLwaN2X4leWwnLQVJU9
   Z2Si49OTG3rFTSeBuODoh/6sZAObrc8iU2aio5ByBqubRA4sWzRT+62Qv
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="21927645"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="21927645"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 14:26:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="33050987"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Mar 2024 14:26:03 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 14:26:02 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 14:26:02 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Mar 2024 14:26:02 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Mar 2024 14:26:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M361eDNdEIfnUap7PsRgjEZf11dXDLRvrxpe/P281Fs8t2gt0CwUyxHj7KjL1mdegqi7BmlgmHaaNxSb6y7yu9zGXOamnbvOc/dXfZmSTcxwgapzaFokwarDYwCHSnGJ21eOYH37BRg8r+VPrH5vP3TQvCCnUGkiE5QA0zhpZ1ojwNA+PuZPzzCwYjmV1JXmdxO08WphM5FNZw2fwn4TDJHkwe2SoxEcl9lojnk3K7W6MDD6j0xwVPgEaHhkTseG4/j87CpDbdiY0AzQbaHrLdupstUt90PA3qUdVPJFy9pxQObicuuneXvrwIcHxnfahmyYo6mER1rG99I0w4pqeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pkp5twfWVkP/cogBnlBNSNEIFSVeLAA8Ik0a4UaQq2Q=;
 b=GvWxA5o+3u6ubTgYyB6IWr+WxmWK7oPcs/KrrsQdEpCkUMAwO3ns5mBQk/TxPUvdtyAhMrESt2ifwePD4mgVRmYlzY4nGGvCVPRXlpD7jIFQFMs198z+JWuW8ligVowvAyxX5krRAXHbE/Qz6LTs77N/sz/hZmKVLpBwwgRiGf+jLNfydYbYW7JGEC3WOkceW7viZATycN5Wa31W7DVTVqfQJigsH9Hd3Zq8CziOB/2MZ4Rb2BXNyGpgmz7Z8qPbGgpF6CxsBp/OfitJIOJeoUj2m9j4P8ij4NOhAK2x5h9aMhpaZIYfOF8TJMjuTOx1wO+WI6G2V+rNRn7E3bzMPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB6292.namprd11.prod.outlook.com (2603:10b6:208:3e4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.24; Wed, 6 Mar
 2024 22:25:58 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7362.019; Wed, 6 Mar 2024
 22:25:58 +0000
Message-ID: <6d92f593-77d8-4008-af3f-5b5bc790b87b@intel.com>
Date: Thu, 7 Mar 2024 11:25:49 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 008/130] x86/tdx: Warning with 32bit build
 shift-count-overflow
Content-Language: en-US
To: Isaku Yamahata <isaku.yamahata@linux.intel.com>
CC: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	<isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <isaku.yamahata@gmail.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <erdemaktas@google.com>, Sean Christopherson
	<seanjc@google.com>, Sagi Shahar <sagis@google.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <a50918ba3415be4186a91161fe3bbd839153d8b2.1708933498.git.isaku.yamahata@intel.com>
 <2f6897c0-1b57-45b3-a1f1-9862b0e4c884@intel.com>
 <jvyz3nuz225ry6ss6hs42jyuvrytsnsi2l74cwibtt5sedaimb@v2vilg4mbhws>
 <20240305081219.GC10568@ls.amr.corp.intel.com>
 <75adc31d-6632-4ea1-8191-dad1659e7b33@intel.com>
 <20240306221728.GB368614@ls.amr.corp.intel.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240306221728.GB368614@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P220CA0021.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::26) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|IA1PR11MB6292:EE_
X-MS-Office365-Filtering-Correlation-Id: f0f576f2-af85-4705-274c-08dc3e2c65ac
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1wFty8k94fNBq0aarHlgNm/TnxWIdUGqwenGFbHfCEMa+S+aNjvXvHYAPCSp1nLWsA7K2nBRRTyY1N5Mdd249/leDuLCLa69Ry+O5lMkGYi0ulmEeY0ncYzFZNtB83k/9Vkjx8D/0Bfayid73BtJyxc9Zb6G0Z9W+H45IBhjiiQKA645Uy+BJ2Hf+OXlYESvLp1yghfj6JtRgqHK0XFvs2e90Phueeef6KKgIgZhZKo5dP/XoxzTZal477hKk/k77XCtr2SohJkzB+0WWb7LzJOCBv30JxbWMP1mcJNSCnfp2zVB/4xM1tkyaEuoP74zA24Oyjs05EzvqQT9ZxoTe+r1pcdAfIAxBOVM16YII9mwyNTJyXJhjoPCzPt5qsK5xp2+dveRNY0HFCpD4sEVEszrAqXsxc9by8dodzCiWbcQRbwfRUCH+hbvFyQjZl6Q2xpUK/n/VFAOE0GhnlF1sU65ahQ/kFzpoBu2lNh2kJl6hAlKDfTna4GiKiJ67Wz0u23UTMXc5oH46c9wKbZKhTnIY4wO94gg4USR1SP+1oS/pJxzmFaMamwYudSMF//yoJZOSPi9z4qz9Kzcd2x+kKJe+PVwZhtnf22+LElA9WUzFnhXQO2akRQflzjBUMsz9hwPG5XcJZxyoKjIMyqSOSvN2u9lmYBY2rjKyTG3PHs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TVZWUzFKU2lQYzcrLzRkaDdHdWlIY2s2SHhEeVRVL2lYQ1Zoc0RWNklZSWlX?=
 =?utf-8?B?dVNSQXUyQTFybVE3UUYrN3JVSGRSN3FUS1lzcVdBTzVVbjRWaXMvaWFkc3NO?=
 =?utf-8?B?dVE1NXVlMEtmQ1NaRnZaVXFQL1E5MUdHRHNSQkdpK0RMZ3h4OHh5VlQrbkZH?=
 =?utf-8?B?VWpxc04wN1RrbjVtd1BZd3lwMXpYaC8yK1oxYWMwdGpTYjJFblFQN2MyYS9V?=
 =?utf-8?B?N1puN2tsQ21RSllFVlhDSHQ3Mjc4Q0I0R0doMnBtZis4ZjNmWkhySG42aUxI?=
 =?utf-8?B?UHhKcU12UTFJbmRFeWdtMHRHYWkxOG9hSVdMWld4Z3lycFpEbjhQU0c1WnRI?=
 =?utf-8?B?bDJqVmZBb2xwa0RQV0RPdU9aaGIwZGRlZHkxMmROVEdKd24yN1NXZUN6M040?=
 =?utf-8?B?M0FkeXY0VmxieUFqZnlIcjEvSFpuZFZpVmZlMCs2cmI2TDhHRDdUb1NoWVBR?=
 =?utf-8?B?eVV6eHVha2NYYmp1bTBhWmJYRElpUWUyWjJ4SnpLbUMyaTNpOCtuazFhaGVP?=
 =?utf-8?B?YWJ1WUkya05wN0ZOWk10VzRpLzFuRHczLzZCdGk5YlNqVWRJVEY1cStHZXFH?=
 =?utf-8?B?SDFqRm9JdjZtR24waWlOUzBFek9aOEI3OHd5K2l5UHVmTFBqMmgydGtYby95?=
 =?utf-8?B?aTJQMXRUdERpeGhMVklmWGs3UkJFWWJPMEdpSG1ORWI3UkpyeUcvRUhpRGRZ?=
 =?utf-8?B?cytZVmNQM1N4c3lFNlRQVzN1K29CUUVxWi8rdzdCYmxrejdhaWt4UWtIdmtY?=
 =?utf-8?B?UGhDMXNHRVh4K3hXNm5OLzRmcUtEUmk0WWErTVZWOHdhVGVIRWFGMGRlR1k3?=
 =?utf-8?B?aEYwcmo2NnJtZWtaZ2Fnem5XNXlTZDNSbnFYMlM3M2x2b1Z4SHJnWmlSYVZa?=
 =?utf-8?B?L0FBRmRaK21BbGNXNEMrbGtvTkpkbFMvVXJOd2pmYmdUa3RrL1Z4eVFSZStt?=
 =?utf-8?B?aEZ3eGkyeGp1Z1FuQmFzaWovTEpicmpXR1FwYlVvNDBSSkRkUExNS2MwdWRn?=
 =?utf-8?B?R0V0eUhldnd6ZGY3c0k4di9pV3V4aEhFR1plci9xcG5oakZ4RWljSEtoVVFM?=
 =?utf-8?B?L1RJWXRpek5DQUtnc2xIM1hOcVJVV1NOTEtsMXc4SHFmclNvY2JCZFZuaEFH?=
 =?utf-8?B?VGVQeGUxL2IyTTJCdFRSV3E1bk5DMmkvbTFsNS9ZRktsZGpPdjVTVHVRaHQ3?=
 =?utf-8?B?cDRTaW9renkxSTZkWU14c3R6YVdVT243NDBVS3l1OU5Nd1NlUE9kamZKMXN4?=
 =?utf-8?B?U0xTNVVuMG0xM2tTRFgvNHJFb2pCQmpBMytiYkhUVDBBTXZabzhIc1o5ekJW?=
 =?utf-8?B?enBRaHoxK1RkQUU0Mk92bG1iOGcxSlozR2ZrVGVHdDRFY2w4eHFCcTRFM0po?=
 =?utf-8?B?TXFMMENlVkgyUTlycHdZbGN0dmtEY1RiZUVtWVJsSElmaVU0aDkrVGkzVGRh?=
 =?utf-8?B?aXVaOTJUMVdtd21RV0FnbTRoSHBYVnRsS3RJMnM2Z1pPT1BQbS92QyttMjZw?=
 =?utf-8?B?SmFKa0MyYmhGdDJUc0VYdkZrODR1VENIb0ZrODBtVEttSUdUL2xjcDBtaVZZ?=
 =?utf-8?B?Yld0aStNN2RneEJoenVQclhHS3pWbElsSUxDY091ai9Nd0FrSkh5ZlJNa1Jo?=
 =?utf-8?B?TzVmbU1na3ZoV3J3K2RUOGFCcWFLc0pxVnh3VDBBV0pWMWtTRFlNWjZjQ0lF?=
 =?utf-8?B?MUJ2dW1pQWovem1jMzhzcHAraUMyc3BUS2lYT1cwMmxQSGN6RmJiNC9TTmdG?=
 =?utf-8?B?QWoxYkQ0ai9oRVJGL0grVkIwQ1JoWXVKNjBjc3ppV1dBdXA1V0NiK1haREpT?=
 =?utf-8?B?ZFRjZUhPNVp6TlpKS09wK0VrTEozVUNHZkdDMzkrNjAzRWhIRlhHdGgzeHhv?=
 =?utf-8?B?Y3FtTmNHWlNDbGRUaGNTVytNb0c3QWprRWdhVUpZYXlOYUVCVkd2czJCZzlu?=
 =?utf-8?B?bVA2UVgwVHRpd05WbllUdGRQejBTQWZrNVlYZWlMUi95L05ocTMybHY5cUox?=
 =?utf-8?B?eXlFQzRvWFlKZ1prU2NVNUpzbGoyZ0ovMnVYVXFlT3FZYStRV1k1djN1UTRk?=
 =?utf-8?B?MnRTQlFLelA4NHJmbmh0cnFJN3QrYnFOU3gvZERtdzNyUVpFK3hOemhJcUlG?=
 =?utf-8?Q?/DfMSdbXIr1JdGEf8L6D3LM4F?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f0f576f2-af85-4705-274c-08dc3e2c65ac
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2024 22:25:58.6485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0THpi9X6VBia6CnQAq5TkCXp3EkeqCjVDS/IZKGVQA++vKIYtfU0tB1Y2kFGbsfUueoGqcnh1f+4lhmhhOYmlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6292
X-OriginatorOrg: intel.com


>> Please just clarify (at least):
>>
>>   - Does this problem exist in upstream code?
> 
> No.
> 
>>   - If it does, what is the root cause, and how to reproduce?
> 
> v18 had a problem because it has stub function. v19 doesn't have problem because
> it deleted the stub function.

What is the "stub function"??

If "v19 doesn't have problem", why do you even _need_ this patch??

I am tired of guessing, but I don't care anymore given it's not a 
problem in upstream code.

