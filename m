Return-Path: <kvm+bounces-2765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B46887FD921
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 15:19:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 27079B2160D
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 14:19:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D05330659;
	Wed, 29 Nov 2023 14:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gf465kev"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C39D1;
	Wed, 29 Nov 2023 06:19:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701267548; x=1732803548;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MWjGys52u4MoGvdW4gb+qAj1USHN8dazCJ1YQIsgtdk=;
  b=Gf465kevZ25zaODXr9SMEG1yPwLqMZn+LafMvEaHmJcqoZnmwxQV42Dx
   lppKmKgIRUiUvNaS/rKWUA7YzJ93Bkimeo0w4H7ujxXYmQig5rgnpFew3
   LLeVSE8enjt2n4FWzPbZC6RQfKavl9qWyPqjGxYAZs4OOUqzu+EMn6ZIZ
   uXpNmfLE2u+2oeuDyhOFiHt7ZWWmj6dKuBWPv+vkRolA+Dwht3zL9V1qh
   7C+EYS0e17oh3MZv65uAjwnfFx5da+UKpFThcooCCxnGzwwTFaBPjLrMQ
   /9iw+7aH6c7dYfGlGoXUmkaxPCKTxzTCfLnXlQ6Qr4D62aw2LJ+JvsS7a
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10909"; a="68114"
X-IronPort-AV: E=Sophos;i="6.04,235,1695711600"; 
   d="scan'208";a="68114"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2023 06:19:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10909"; a="768930722"
X-IronPort-AV: E=Sophos;i="6.04,235,1695711600"; 
   d="scan'208";a="768930722"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Nov 2023 06:19:07 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 29 Nov 2023 06:19:06 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 29 Nov 2023 06:19:06 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Wed, 29 Nov 2023 06:19:06 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Wed, 29 Nov 2023 06:19:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gWDgChhJ5SDb9/t/S1cbw8XWYfLjPJRvKiyr1rdemsz4o8VYa/t/LvHoyu7lMHj54hzlqwBxq0rSPC+CXFfQmjoTD7Wzck5TXDTvOPU3edi6XlY1lfijPGghGqDwPBl7OTpZZl4zN8BoEGZXnfNDeHml2gxusl0ngGhEV1Fi3OqXZCfsFNyloNwPnBrvmT4DJaauzo6Kmvd5BoV7in/BJW4H7400ty12J329X//X/8mobTsWU+yHI6dLmQ9iZdOzmn4OJTSHzNff56woSY+XfeZRfYE5vz0pPUZ7PwEXtfd45MJ8gEHtZMlF1Z3+P+qavjGpaYxLofJJgE+XyBKuLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=niulWFI4oRY1JBwO4F2cDpitEIkHfYrnFeJ4pqg1frM=;
 b=C1NbrjmqP7pyY2NVFxGWmkMtpUalstrNOXQhKPuTVdIaYt+JKTiC0yDUswGztl5mSEqUNaN8tVe65QchyPF+u0zLhL1Upu1pmFIpbKn14GyO3z13MraBO0fSH3Wi3aDbIcRjwSFJ+EYwjepqRsULIXkEWVObSJrRL0PUze03pa/3Sc73gQ0NKc8JhQLVP18j3m60acBxHO4n3BAixze7xWEO1VjtoxnXJMq/fEgHRGQCkcJWVtVt7mjagV25ih60nyh1NI10MsVY3TPJiGJrq1F05iu9frhWMneH1xY6NT1N3pCDhpyG6GulX1Ob16md2E1Xe4oFyXAO8FIWjIv9Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by MW3PR11MB4618.namprd11.prod.outlook.com (2603:10b6:303:5f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29; Wed, 29 Nov
 2023 14:19:04 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.7046.015; Wed, 29 Nov 2023
 14:19:03 +0000
Message-ID: <f51647de-f427-45fc-a754-0029096fd5d7@intel.com>
Date: Wed, 29 Nov 2023 22:18:53 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 07/26] x86/fpu/xstate: Warn if kernel dynamic xfeatures
 detected in normal fpstate
Content-Language: en-US
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "john.allen@amd.com" <john.allen@amd.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "Gao, Chao"
	<chao.gao@intel.com>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
 <20231124055330.138870-8-weijiang.yang@intel.com>
 <8dafb9cb4cb7054ae2a0c1bd19062937148d668b.camel@intel.com>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <8dafb9cb4cb7054ae2a0c1bd19062937148d668b.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGAP274CA0011.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::23)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|MW3PR11MB4618:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e2c0b1a-089e-4cd6-3651-08dbf0e622b1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UBrcvyUxt+3Vn1rpwrtw0O1UZ8b3dlqqM4UzlWPl1dF4/Slr999Zs+cI+0Du97ZL/y3USFQCsKbp7LhD/ECMV98i5sMAWSA2f8tbIDnCBlw2s+DAcJ0R2m17YGyd5OPqE7ggOLh2jmEMJD3yIsCKVE+DZutzIllZVa+qofwbOBAf5BoM8NUeehO/jNaYQ/9+z4gvPmjOHDtC+hY3K2pDKfnMS4pyd9KN1NQw4AMQM8sLJLQuU82wQEdVz2LZ7zJ9HrJTe+Ni8uFXGCqz7gNwIok3bRLoWdKS60TdgdcbO3iWw2b8v4i4ya1OIIyh6QZQQ8AqCXr4ID7HURT5Anz7braPaBwNjXHggF1WiM7d12FghSzMwjCgu/KMM/xQ5vvrzKlkLvLpNc4SDp3ghvE4B7WSrDbT4Svdj6Yw923Rr7EtRlmAQlI/No6stqOMp2Qg4/i3FlF5F3Rz03KdpuQCv96T5PIViyp1YGT86eAhLHI7yq5CgXa2lJIs/+EEA5SxQYyVlS/HqNuL+52/HHJlzzQyvLZQwcxXZcL07HaZJYnA0POjijDAUoxV3pun+qLvsp5NbSBsEoI1jzHpVX9fcL+mrgGaKoUQaoNhfFR/YGVkrqrrM+XHuCKYlBAQ0u4o+zhbzSVXWk8PWr4OvKg3Lg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(136003)(39860400002)(376002)(346002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(83380400001)(38100700002)(31686004)(53546011)(82960400001)(6862004)(8936002)(5660300002)(31696002)(37006003)(6506007)(6512007)(8676002)(478600001)(316002)(66476007)(4744005)(54906003)(6636002)(66946007)(86362001)(4326008)(66556008)(6486002)(2906002)(36756003)(41300700001)(4001150100001)(6666004)(2616005)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RlE2d1JuZFZ5UXVyWU8rN085N0Q4Wis0b2pWdWVzamtySG1xclI5RDdpT1BL?=
 =?utf-8?B?U1FXWlc2ZU5Hc0Zydyt2ZmQ2bFRjLzVUK1N5ZExGNzhidVhBdlVtRmgzMU9G?=
 =?utf-8?B?YW5aQldkUTJnYk9OeFdTaG1XdDFuNjhUNldHRHRkdUk0Mm8rSUoxQ0lmT1d6?=
 =?utf-8?B?UlZzZHNKZEZSZStPN3IvbjBQZzhKeDY3OXhZYmQ5MWNYc09GQkdodmlYRTNn?=
 =?utf-8?B?WXNNL1NpNld2M1Jxd01NbjVZWENEMDJFZUJpZE56NENjMjNRMG84UXFPcVRU?=
 =?utf-8?B?QTlELzBWUXI0SWVuZVJFODNZSGp5UE1LWURCNi9QWlZUQVhKZ0t3M0l5UGlN?=
 =?utf-8?B?cHlueXg4NEgyNmF4WFRydWlXNTBoT1N2TWg2U2xlYkZmY0xiVzRkZEFEZzFt?=
 =?utf-8?B?d09idUkrcHN4UE1CeUNPdTdDWEZvMHA5amcyeXFGWTUxeGxJYm9EVjloWXI3?=
 =?utf-8?B?M0pNL1NTV0pVMll0bklUU3NIRFlCY1J6NzBYY0JCRVhsd2ZObzNIaDcyMWZi?=
 =?utf-8?B?SHNhU3ExM045WTFDK0lTbHZld3VSWFRzU21ZMndpV0dWKzJWODJlWVJRTDJO?=
 =?utf-8?B?Zmo3M2crSGhNS1VtRjJKRWhFTDBxUXVZczZYQ3RweHFJU1N4c1Ywcm5TYnEy?=
 =?utf-8?B?ZTVoNXYzcEFadTdheE5paEI3a0M1NE9UYU5lckhZYUNmand1UjF2MmZiaWcw?=
 =?utf-8?B?TFVVRFJGOTRtS3M0czdTZ2UzaTl4ZW9EZ0dRczlDcGZsWlFRUHZPRmZUNGU1?=
 =?utf-8?B?Vlh3emFkaVB1WU5rMk9XeWNSTG1OWm5ndlNWa2l0ck5XY0lnUDhkUlozYi9Q?=
 =?utf-8?B?R0ZuV2wvMEFWQjFCRkN2QlZkckF1SzRBMEtQVXEwQlBvalpiTzNURDdqTVkv?=
 =?utf-8?B?VFBXTDliMmc0MGtJY0E2TWY1Rk4zc2F6ekVWVDFZZDVZQnBKU2Nwd3RtSk5l?=
 =?utf-8?B?akQ1dkt4Um1lY1RnaDJkSkNwVEdLOFlWVHFEQUJBUGJtcjh2YmFDMnd5YzVl?=
 =?utf-8?B?cFl5SEg5Zk4wUkVVTXlreEdudHZ0bURmMDZxdnRWMGdFYUx6NWp6aGpmNy9t?=
 =?utf-8?B?K3VLaytSemFOTHd5ZHRIcG5kb2NLeG53MjgyU29xM0RJMndmcEUzcVNGODh5?=
 =?utf-8?B?ZFVLYkF2R0QwMmNGelZLSWRPU2oxUWIzNTdUTW14VWZaT3JJblR6Y1hhWk1Y?=
 =?utf-8?B?NEdHMWtpaFA4MmVhM2sza3ozSm5FMUE0dVEzYlRsd252Lzh6R2dOWmNTOGU2?=
 =?utf-8?B?N0xoZU9hUFNkUDBoK2hvMHIzQ0lWdVhRbjRveER6eTVYL1RwZ0xJSllNMWVI?=
 =?utf-8?B?K3dGV0dOQWdlekR6alBhVjNINzEvMmg3bFVXYzhRamRKVjU1KzJIaDd1dXJv?=
 =?utf-8?B?bHJoeUhRNi9PazF2Y3lwdlFkcEtpaHZrTE9IdzQ0dUY1cUZFY044MG0xVUhW?=
 =?utf-8?B?azg1UlBkekVIdURhTkcvaW1sdm4xdnFBNE1heTRLV3Y3OFlqUTVMOU9lNzhY?=
 =?utf-8?B?T05rNmtqYWNYeWJ1Ry9zQnVCMTBxSXB3aXdDZVNyQk1sTmtKWVliaDU1MFV1?=
 =?utf-8?B?aXZRakRVa3hrQlhDWGdDTldiMUtEQzZldnkyMVN3VWpNR0Q5UUl2TGRFNWFQ?=
 =?utf-8?B?ZG9ndy9oeURCVitqUkxEMzNMUFVRenRpb2tpc2ZkNWFoK0prOTFxa2k5Z0VI?=
 =?utf-8?B?QWttYXhtTm5lenNabWpGc2Y5N1FUT1NZS1ArNnhxNHQ4WTlFMlNjRnprVko5?=
 =?utf-8?B?N2lLcEJMZmxmZE4yTUd6QU5aZHlReTNZTkc0WjMvZFNrdzNyakxpalRyc05M?=
 =?utf-8?B?V3V6YUNKM1J0MVpobHN5VFdVMEZ2ZENhdDJ3a3RJRjZxWXdjUGJweW9Pa0d1?=
 =?utf-8?B?bktIM043b25WL2twRHZOZnFtMmNIYWk1ejRHRGg5ckM2UlhvWGZpS2pBekpV?=
 =?utf-8?B?a1A2K1lzcTFEQnl3cmx1cE44K0ZtWXFlNmRsL21MNTZxbm5wRE1CY2djSmxK?=
 =?utf-8?B?VCtSNXE0YmJTZXJXdVFqdkxnRG4yYitGbzN3REpGVTkrTUh0RWtGazhRc1g5?=
 =?utf-8?B?SEVvVHprRnJMQTI4UmtMYUxpRmJIS1VGcGJPKzFwVHRsYjFkUGowSUNJeTdm?=
 =?utf-8?B?ZDZZTU13SWwvNVpNbGhPeEpOSmRKc25QeC9MeGtvN3RGTllUYmlFSnVPN0Ns?=
 =?utf-8?B?cXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e2c0b1a-089e-4cd6-3651-08dbf0e622b1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2023 14:19:02.6801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4d+edmFvX0OrVtqoSohrWXnfoAda83gh+wrzK3z5mjaxKZA36zo5TjbeYMGz2t35DVzrV/8w0DUpXFvYIIZhQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4618
X-OriginatorOrg: intel.com

On 11/28/2023 11:25 PM, Edgecombe, Rick P wrote:
> On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
>> Kernel dynamic xfeatures now are __ONLY__ enabled for guest fpstate,
>> i.e.,
>> none for normal kernel fpstate. The bits are added when guest FPU
>    ^never?

Sure, will change it, thank you!

>> config
>> is initialized. Guest fpstate is allocated with fpstate->is_guest set
>> to
>> %true.
>>
>> For normal fpstate, the bits should have been removed when
>> initializes
>> kernel FPU config settings, WARN_ONCE() if kernel detects normal
>> fpstate
>> xfeatures contains kernel dynamic xfeatures before executes xsaves.
>>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Otherwise...
>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>


