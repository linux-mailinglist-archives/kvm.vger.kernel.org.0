Return-Path: <kvm+bounces-2764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FADA7FD91E
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 15:18:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DF424B21612
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 14:18:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA4CA30656;
	Wed, 29 Nov 2023 14:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YR67yp2P"
X-Original-To: kvm@vger.kernel.org
X-Greylist: delayed 61 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 29 Nov 2023 06:17:55 PST
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00B95B6;
	Wed, 29 Nov 2023 06:17:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701267475; x=1732803475;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1cIh462QyH+nKPTTy/AtHk0VUwhwiS+Ogrp7VcQARrc=;
  b=YR67yp2PlGYbfAZ3d0wh5zr08MwOHtJ/NoIICpVgP49fXlDDhqAuHv/b
   m23xrMuY2LSQzNyg6sqVSgk98Sc5OY4lSaV01Jt8svSZeYsjlEbTzYIbh
   Nonzgsy6iJAgDakXPmAdq7to0Xu6uuqDVxEbhRhqeZBw0xYS+iHU8a02t
   IOYdrzTMORQc30FThxliu9wD/1eQ6QLluafR3HC/reVI5R+q6xnttu2hQ
   ackouxqcbl/kwl0vpY0znWnsAs4Pf4YrDLhfPzjzm/zHJgTWJBnw8Bclh
   ddygjGux5B3/w0qXCBW8mDJJ4svgCGlltADW+0w1MCt3F/lSouHfIOnR/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10909"; a="157950"
X-IronPort-AV: E=Sophos;i="6.04,235,1695711600"; 
   d="scan'208";a="157950"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2023 06:16:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10909"; a="859833148"
X-IronPort-AV: E=Sophos;i="6.04,235,1695711600"; 
   d="scan'208";a="859833148"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Nov 2023 06:16:45 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 29 Nov 2023 06:16:44 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 29 Nov 2023 06:16:44 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Wed, 29 Nov 2023 06:16:44 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Wed, 29 Nov 2023 06:16:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DdXjnmzZWFJK23Yug4gDcZcJcgRPlZ/anhZtJP2mvWf0TlhJXfJLsPTK5dSiF80T+Y5PmVx7mjA2vyqWhFZHB1r7Z/IVMy0qfnuq2OgWKstwIGXU4LUJbtXt9QZ2Bj3YswHjb1j0lKTZ7Cb7CxlxaQpAdwTuluEBsKZPMOuEttXkFWUHyLz2rw8Vv3uuCgZsDsQQ77MsTKOJvK8qzC7aS3EyRVfza4szw3QLfXt5ZnMXxC1mCm4F8ryaxQHogUGgmrrlFMsVcH2S2kn5MsTTt0t5s7wV3t5euSv2yYnK4ssDM0Rze5DRcxf7Svtp1v4Bmr0VlwP7PGjmHqZMGe/QPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OVzclDJVlS6kVQw9LuiquCNBFRRPB1U1uyo/HdZqWns=;
 b=e8igYNUt7bQiTKucmCo6bBx4kZU+E33rbnPgPUpqrbTNNFpd7Ez6ocBObLLh8wTz6BUJR1HHVX/m57wxvYo0CUzPPisox7Lx45FTMmTCm+/IK3GSFyjHCubeNNheFh8uTQ5MlXfY3eE//raN0V367u+n25ap8dqyIcg8zZ+vKhLUp6VM8pqpBXCp7uhwHMtIercOiXfFYTkv1nTZQg/txU8YgrHvYx8Rc0GZzsdPkTz8NczleO9F8CfBN+Te5pV94ss/JfnnQcmwAWss5cl5sJFR8OBCuDjGdbb4kfgsiDDK+sXrURj7zRNDGc90HrUJS/sPkuS6ZxfeZlQhZ2plRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CH0PR11MB8167.namprd11.prod.outlook.com (2603:10b6:610:192::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.23; Wed, 29 Nov
 2023 14:16:42 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.7046.015; Wed, 29 Nov 2023
 14:16:42 +0000
Message-ID: <68664795-87bf-4934-bbcd-f6d8701d051a@intel.com>
Date: Wed, 29 Nov 2023 22:16:32 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 06/26] x86/fpu/xstate: Create guest fpstate with guest
 specific config
Content-Language: en-US
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "john.allen@amd.com" <john.allen@amd.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "Gao, Chao"
	<chao.gao@intel.com>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
 <20231124055330.138870-7-weijiang.yang@intel.com>
 <cf078e1600a1ead27ee382ae184aa9ac168205ad.camel@intel.com>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <cf078e1600a1ead27ee382ae184aa9ac168205ad.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2P153CA0018.APCP153.PROD.OUTLOOK.COM (2603:1096:4:140::9)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CH0PR11MB8167:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c9bdc02-a3a1-4962-883f-08dbf0e5cf1b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LH2Dro2zq/HZMokc+pgRzUQwtQH7Zxb0jj7Y1S3NQQ5JWl7nv61zMoxpyUVFzs306mv5Iv4YESz5bNG1cu2hOXkAqecQxI+HKg75hd+Z7EfEcJVjLnz5WBMPzTDEDJnYi1NvoD7G59TRigJIpXgQ3l502peTI0PKX4e2mq9t/J+9sgIINo1zwlgdyhlqdzwdbqlla712LTga34OXub/sR1nFrngPHXpE47vR9Upd8yO1lPO7SAlXIXPScklMqChNUcJp4VKIywn7j53DyGQG71sVtwOLnqJvogfxKTJ6PqRkmQUznfq7wqaPB01Rhc2ua0AH7TtmlOz4Uc2MKP9OpWARYOiCF56SGZdPhRtfICBHBhHD7G7M0Umlb8T6ollQdKHXvYPyhoUX4VNAMOoDpaWwwh7Sef7p1lS3rfNR6y4Y+4CIE/LSOguFhPS8ZpGcmWKuFURSQ3fLZygi2KZolOpk1mEjBNUuJSqgGPkBnDbS+P2YA3Eg1ToP/yBxH62VrtlTD1+VJa6RDCV7s/klM98mR2FZbYfj/MvdYEcBzVzqqVKxddHaFvR9AsO+OTV9o61Mxt0po/PY3XVErp1NfBMa64i88Mj2aUL8gG3hcF56TZpAZLmB3inH06YWkAj4L6+UgCMM7/bFdfpddGfGFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(346002)(39860400002)(376002)(136003)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(31686004)(478600001)(2616005)(26005)(6486002)(6666004)(53546011)(6512007)(6506007)(82960400001)(38100700002)(31696002)(86362001)(36756003)(41300700001)(5660300002)(54906003)(66946007)(66556008)(66476007)(6636002)(2906002)(4001150100001)(8936002)(6862004)(4326008)(8676002)(316002)(37006003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SVhuL2NNU0xZcEJSUVAzbGl6Z2lvNHhaOUlmbzRqa2pEc2EvNm8zeXJ2VGlC?=
 =?utf-8?B?R2NhV1ZMNlppVFlvenFQR2ZFZVVKMXIyMzRoeVpxeTdrZ0IybTUvN0IveExL?=
 =?utf-8?B?LzQ3enZpeExVVlJxY0ZwZ2NTT1FOUHZ0dGpYZWI5ZkZTS2VsZSs5ajZ6ZnEw?=
 =?utf-8?B?VktXQ3FZbEZOOHNqWUFPY0ZhSnNyUmZzVXludTlQdW93OW5ua1R6cTFmbnpG?=
 =?utf-8?B?dU8zOWVzcHcwNDl5b09rdUZsN2oxWnZYR081d3pOTGx6a0lMajhobTR1c09u?=
 =?utf-8?B?RmNoNXhOQjIrVWpjeFhQUDJybGhiVGN2T05XOE5BN1FKcGFyUVg3ZmljQ01Z?=
 =?utf-8?B?NFRiRlEwK3lBcjNwTDRpNEZIL1RHdEpIN3d5bzQ5bkNFRUhHTW1nTUU5OFNZ?=
 =?utf-8?B?T2F3SHRXaDNmV1l6Z0lGSnpSM0dDNzhGa3dtMkdTS1Y3V3REZ0RUT2tGWHJS?=
 =?utf-8?B?VWY2aDZTczVnT2xhNU1RV0NqUGpiQ1NEU1hsWFdtSkxwdDlyMjJRZm82WEg3?=
 =?utf-8?B?Z2ovcDdvaGVZOW9BUWNMU0wzcFBQbEJrbExDM2t0bitRU2dhT3NvT2pTaUJk?=
 =?utf-8?B?WnBRdGdCUzR5amNhTkZMTS80eWtFZU0vMmNHaVVQWkhPd09PZnJRSzVtMEFY?=
 =?utf-8?B?dVA3QnAybTF6YjlhT0FVY2ZEWGdpdklISlh2Y2ZRemZUbk9tRzZpcUdxZGVT?=
 =?utf-8?B?OXNyTUJOS3FJMEdSUEFrOVRzK2xnQkNWVkI4bDhvWjNTcnNTdERreSsveEU4?=
 =?utf-8?B?VmRMU3U4V1NMUTRHTW92WFRCcENocVI5R2V0dTg0dGMxeGU1RTZXdXZjd05M?=
 =?utf-8?B?RzMyaU94WDBsSDV6UmRkbklHbzg3OGt5RkZOMUQrL0g1WTB1ejBrdGorOTQ5?=
 =?utf-8?B?UlJCRkxCM1FBcFBYNjZ2Z25aYm5ZVVdpdGNmTG1EMFV1ZDlyYzloZ25sZTJM?=
 =?utf-8?B?TE1zV2h3d3A0eVUxOW4vSWltMGJzSU1LcFNLMkRpSTlOS2l0YnRNRkY1UmFI?=
 =?utf-8?B?NzN2L0dhM2gyZm8xOEhrY0Q0S2JBTU9UUEY5TXoxOE50RDRwc3ZDVGJkT21S?=
 =?utf-8?B?RSsvZVpBaEU3cnJmUVZiSTh3bG5yaFNIWEV2bDRUQmY4cTB2ZlV6dE5SQ0Ry?=
 =?utf-8?B?VlRZb3lOcUNvTE5lTHBUbWYvWEV5WkZuTlUrZUFzNUtyTnNKbHNISkM2T0ty?=
 =?utf-8?B?S0RMcWY0aEdCMFkzZm1DcjFHRHNLTE4wakxMQjV0UzJ4L1dUVEdnWnQzdnhI?=
 =?utf-8?B?eExuTHdiS3R3K1FITkhmYko1ZEVnZ01NdE12ZEVwZ3Y1OExJNmFYVnhLdzVD?=
 =?utf-8?B?WndweHFmbUdwS285NE5uK044SWkvR0VPV1RHMExEOXhPOTA5bnJxUlFxWXlT?=
 =?utf-8?B?Slk1NDU5SjlLSStPRWxhZHk0WW1Tb0h1UGJNM1BFMXhZai9KSnZldlpLR2tn?=
 =?utf-8?B?bmt3Y21KV0xxR1NsMXN5VWcwakszQURzcEFpM0VZV1ZheUVuZTNqWWtjY1lk?=
 =?utf-8?B?WXlyMlhGTkFzenhkeTVMZUlFdW1MT3AxWEtvcklzMXY3aG5GR3lMYjJOczNs?=
 =?utf-8?B?OCtiK0E2K2Nsd2NOcFhEc2hZeWUwRkVXNWc5RVNkVXMzdzFQaTJjZlE3aHQr?=
 =?utf-8?B?UjRqK090UlR2QjJWd0xpQzcveDltYnhUNWFSS1FHeUJCWHhmVEljWUovN2lx?=
 =?utf-8?B?YzRaM2NCb3BzZTdkVmlKa0RqdjRmOTZIbXE0Nld4TjJmWm15TVFaenNUeEhy?=
 =?utf-8?B?T0ZIWjhvSjQxWTRNb3Arb2xOdWo2cUNyYk9ORlcxUlZTQ0tHRUZoYzliaVAz?=
 =?utf-8?B?ZUtZaDI1bEVUcDFwSmxnVUtjdUlZYmtYYXVxY0JnaGgrbkFBUkx5cGNqbUhE?=
 =?utf-8?B?VFBjYk9xSW5aellvUC9XcmFsZWtXamVVL251UExQS2JqV3NNTjlXa1JHSHpa?=
 =?utf-8?B?empIcFVYUjN0ZUJYcm93RlhpMDNSbjlZYzFGYldHWVdrQjhHY1pISFZSSWpX?=
 =?utf-8?B?MlJ4bHNnZzdUeENlcEU5RVc5YTY0a3lCbDRNUWtpa1RnenM1cmJhSkJCZjA3?=
 =?utf-8?B?THMwOHF2dTlySkhydUNmeFdYZklCTXhyNnNUSlJlWWh4cUVVaGIxQWU1MDV1?=
 =?utf-8?B?UEo0YUZiOE52c0RhWE5udkNUYTJkb1dtK3ZvdzExMjNNNGNPS0taODFBdjNx?=
 =?utf-8?B?TVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c9bdc02-a3a1-4962-883f-08dbf0e5cf1b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2023 14:16:42.2213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bVJoCddPMkcmtdCQRxj21YudBO+15a2sk4WRJUMKLqK+4S4QSpUO7EMz9IrlX8t+KPS5mFOsxjXf8DB1Vin3bQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8167
X-OriginatorOrg: intel.com

On 11/28/2023 11:19 PM, Edgecombe, Rick P wrote:
> On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
>> +static struct fpstate *__fpu_alloc_init_guest_fpstate(struct
>> fpu_guest *gfpu)
>>   {
>> +       bool compacted = cpu_feature_enabled(X86_FEATURE_XCOMPACTED);
>> +       unsigned int gfpstate_size, size;
>>          struct fpstate *fpstate;
>> -       unsigned int size;
>>   
>> -       size = fpu_user_cfg.default_size + ALIGN(offsetof(struct
>> fpstate, regs), 64);
>> +       /*
>> +        * fpu_guest_cfg.default_features includes all enabled
>> xfeatures
>> +        * except the user dynamic xfeatures. If the user dynamic
>> xfeatures
>> +        * are enabled, the guest fpstate will be re-allocated to
>> hold all
>> +        * guest enabled xfeatures, so omit user dynamic xfeatures
>> here.
>> +        */
>> +       gfpstate_size =
>> xstate_calculate_size(fpu_guest_cfg.default_features,
>> +                                             compacted);
> Why not fpu_guest_cfg.default_size here?

Nice catch!
I should use fpu_guest_cfg.default_size directly instead of re-calculating it with the same manner. Thanks!
>
>> +
>> +       size = gfpstate_size + ALIGN(offsetof(struct fpstate, regs),
>> 64);


