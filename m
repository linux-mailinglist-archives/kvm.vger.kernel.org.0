Return-Path: <kvm+bounces-392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B527E7DF4C1
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 15:17:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E564B1C20ED8
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 14:17:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF9EF1BDFD;
	Thu,  2 Nov 2023 14:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rdQAgKIZ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA54311185
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 14:17:25 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7EA12E;
	Thu,  2 Nov 2023 07:17:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NhtsDg6XHI41aXInjC8qBp4BvM1qBkgrA3vOhhXtyNzCCVKqiLURWFOVjWV64GKUEVGabLD6FoKarP0qAQDtj2xUAkTgtj6dUqGCiaOsSdqce/J34+BJM/A59dNWW/OlwNxD56XZHSP4vWoPDevvJ/nNf/5JNjacvwz2rP/rV2EcwIovwHFj9T2kI1oNdszH9dj5bUz6xV1bCDuHTQIpPlyLTtvR9q5kpkrVkyyuMMJHnWvY0JZ/gdLW9HQ2dzAl+GC8ou9TXoG+ACmOV4zefrN6wenIYeBnuS9Lopkckg2+0PaHzrIr7fOPyI2OFTOvSqZLSr6SIwiR/dKlL++5Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gL83Ew1qZX2Lp+WbdkhpETUlAJaBtUKLLV/rAYQuRks=;
 b=F+4Gu9v9xSmXGtnq2bTpEQeUas/vbnid6QwfmnmkdoRATFfWAkt5MBKDBAOaNtr4QHnwNwvkWd+D2hyH23L3oNvL7psNKMB0Hd7jdZAHwNQxurZ6EjYy39H7aolhR0NVyYsEPgwxopuJsrTFrKGeD1KI1TtX74CTZ96HHItNliUP6EISh7f72yIBjyMgCFc/AgOlslDAXc9nKrgl1HPN+XmHLeJhiWOX3z3pKhmM8eQBf4J/ildD4gZevzWDvrAb51syQ+VYVhMTras8+t4O+9sHpngphjo2xgzqctULy7JfGVd1tQsi/As3SOtLPgTJU3Vt7SVl6ImwFnlYsZnKyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gL83Ew1qZX2Lp+WbdkhpETUlAJaBtUKLLV/rAYQuRks=;
 b=rdQAgKIZLrnmbEuSQt4oaxI/GznO6S6dTD7tFusELzhjDl4ESRAXkWwv135Qka1ggqJMKZmgrYNObIGNnmMvRvRExGwAuP39jMgxWvQsJAKO8IH9YWCp8u3ZdAGUIZD4yAKhLxAnvGPeURRANI5WLLmvJjD/JffGg1bHRJU/5Ro=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by SN7PR12MB6814.namprd12.prod.outlook.com (2603:10b6:806:266::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.27; Thu, 2 Nov
 2023 14:17:17 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::e16e:d7f1:94ad:3021]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::e16e:d7f1:94ad:3021%7]) with mapi id 15.20.6933.030; Thu, 2 Nov 2023
 14:17:17 +0000
Message-ID: <d38bf900-98b0-479f-bcd5-7366f339938b@amd.com>
Date: Thu, 2 Nov 2023 09:17:14 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/14] x86/sev: Move and reorganize sev guest request
 api
Content-Language: en-US
To: nikunj@amd.com, linux-kernel@vger.kernel.org, x86@kernel.org,
 kvm@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, dionnaglaze@google.com, pgonda@google.com,
 seanjc@google.com, pbonzini@redhat.com
References: <20231030063652.68675-1-nikunj@amd.com>
 <20231030063652.68675-8-nikunj@amd.com>
 <d34d280d-badb-18e1-c17e-bcf079f368de@amd.com>
 <d1bb638b-cb7e-44d7-bd70-e1282c993ca4@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 1NhFSLKvfA==
In-Reply-To: <d1bb638b-cb7e-44d7-bd70-e1282c993ca4@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1PR05CA0013.namprd05.prod.outlook.com
 (2603:10b6:806:2d2::19) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|SN7PR12MB6814:EE_
X-MS-Office365-Filtering-Correlation-Id: 76466e18-6165-43a0-aebf-08dbdbae6b1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ZimlL9fI8XReqO8vv2cfcDvo/SXOTMZwJtCmUdhvHrr9NVxr/zR8/wK0lPFg8v5AwSNso1tlJd/HeST6syIxSgHVNCnQsfN7onrVQSioe9grkMseXcBXM8/4UkfKhiOot9dT1wLDs4dTxFiU2tSvdc7zz59ecMDYt0MielxvXVkm338bM0Gdj2KKrK3gyOpoR3TYNIGdjYMuYpRjzeuhuR5R09FLJoMHCaWkJ7mSkaDCJ9ygL3SeBYTcXEDGx64R1XLGdMvL6HQUKR1pqqTKtrYB1XNdxUTk219bP1+2erC18flX/vb/+aFvPGxePbnX3X3Ukc1SmziNg+/er8hfAI0QFhHPEOsXrcCXYlzL7H9NlHgzTxR/RC8W9077PYjl/aoganQkQMRazCksQ14NXd3ytYvdVA6BoWsbDCHB/Bc/1OTeLCnSXosgEfw8WYIA3YkS/FNTWwVuy4OnPk2opnsewlx0lpyc9rItMwFOxSR3EKsOe3A3yzTDQYA8/wg2qyBXpwE4etmNP/BVKYGkDTgZxtT4Eut6I4ovX/ce0e5CwdgSTpx1bIOwwMhdicfxPpJgnlBWOjJy8gLoeSD5sysq/s2h9p2IqlKtwd7ZSwZDcug4eiVRYMJPD0m9TRshedikcC1vlHNrSMBHU24vdQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(39860400002)(376002)(366004)(396003)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(6512007)(36756003)(83380400001)(26005)(7416002)(5660300002)(53546011)(6666004)(6506007)(2616005)(8936002)(66476007)(8676002)(66556008)(316002)(41300700001)(31686004)(66946007)(86362001)(478600001)(6486002)(38100700002)(2906002)(4326008)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?blNOQ21GMnVCNnpMWkFwOGJBQzdpVTJIMGxQN3k0N2xIUFFzV0ZwQnk2MVN2?=
 =?utf-8?B?aEhSZ2h1ZUF5Vm8wUnlHZW9pZisvWmJDK2V6MnJoNTNFY2FKSXhWNzduU1Qw?=
 =?utf-8?B?YWlSWC9VeXBMN05UTUdhQ1A0Y2YzRzl5QVpiSHB3Rk1DMnMrZlgxR1JzY3dR?=
 =?utf-8?B?Y1dkK0V5QWcyUThHb255bkRjTDg0Y2RIK09ZNFJUT1ZIbEhXOGFYd2hESVl1?=
 =?utf-8?B?QlJGR1V4L0FSN2cvSXhjMm4vOGgyZ1FQeXpiS2hXdG13SjRiRFh6YmNiK3ls?=
 =?utf-8?B?cUZpb0oveVI2L2luVjJHWE1tOVRWSTlYMWVRcUlJSWpsb0F0WVVndEttUkJD?=
 =?utf-8?B?c29XVU9nT1RhVkQzMVZYanJiUVJSdXhZN2t6ajJuN0VRdkxFNmxmQW5GdC9D?=
 =?utf-8?B?OWFBcUhtVGhzeXhldnlqVFdyWmVkd0pNZ3VwOHdHS0xhZGtmeFN0dG52SVVM?=
 =?utf-8?B?U0VYT0FGNFBVbUgycWUzdm9ya2g3UHBIeExYSCt0Z09nbU5XYllza285YWxR?=
 =?utf-8?B?Z09ETlI1UVpkdmpIUTNTSXlQQTNTU0VGdFpDU3lwaHlub2JIZ3M5YUhyT1JD?=
 =?utf-8?B?RkRmZUxOUXZHMXNzLzIveHNEVDBXaTJSOEZOZ21zRER0TWY2R3BqcE5tbGF3?=
 =?utf-8?B?K3JGUXJvOEVUWEVsVEFBd2hlU1dmeVhkU1ByQ2RrN3pVaGJzZW5PR1hteWZ4?=
 =?utf-8?B?NjZnMnR5M2NGMWF6a1JFdnM4T3ErN1dGRFg0OHE5dkJrelhxaFBxYXZzTVNk?=
 =?utf-8?B?NjRJbEpwRGM4KzQzanVvU2d1eTZOcGFJQThQcWlFemV3ak0zRVFKSDFnQ1dF?=
 =?utf-8?B?TXN1WjZKOVJ6eWI3blcwK1JSamJQclEvcFJra0NYOXZWV0t1bUVRQ0RQbjJz?=
 =?utf-8?B?Z2pYTkMzWFZvSHhQeXhZQzBFTHNkUFhNT3ZNN2lBdG9qdVZ0QWZzdHRtV0h1?=
 =?utf-8?B?UTZjdTZlSTk0MldjYVNFK1pBZGs4Q29NRC9nTmJRSFd2YWlsVHpZM0daTlZa?=
 =?utf-8?B?YkhZTHNxOTBad1V5MUNrVDJXeGZ3NlhtUlFNbmtoVk9PVEN0ZXVSZHdLM2JX?=
 =?utf-8?B?L2V6WWxPSjh3Y0JFUFVISWVVNGxCM3pmbCtXTjhpZEdJOTcvczBBZTBJV1BP?=
 =?utf-8?B?NnhlRi9MRzBoTzdXSXh6UVNHMGFiSVRrY1lMSFlUNTczOW5ObEl2cW12ZHhw?=
 =?utf-8?B?Q1RWUU1WZ2Q1RWthcXdWbjBGM0NKRDNPTHdqSUlxV01paUVVTC84Qkl2ZHBY?=
 =?utf-8?B?QVhJRlpDZzNkeXZOMEloZ3I4MXZQUWl3NW1Kbm1Pb2QzMld4ejJLbGhBalBP?=
 =?utf-8?B?RkNGS0krcnZhRE1ETmZTRVNGMzU5eFBjQTRXMS9jTG1LS3Vpajhvd2pXTVFM?=
 =?utf-8?B?MzVOSzdVWkhOcEUvRnUzMWFQelZDQkIvNWJwbVF4QjkvaEFHUDRROEFOMm5k?=
 =?utf-8?B?QVVXNmlsQ0UyMmF0TnVwbzVkbFQrU2RxMFRIZmhodlJzMkFqakdMQ2VrKzQ5?=
 =?utf-8?B?R3krM1JJQXVEakVmRUNWS1JqU3JTcG5WTG9pY3VsdU9aZGZ2eGJsTzhRR0p6?=
 =?utf-8?B?M3ZxZGFBSmZVQkIwWVdJQ0ZyNnIwZkJqSEo0ZXZ2WVY3cWxzOGNXUHJPL3lh?=
 =?utf-8?B?V3V6YXBMMy9rc0xzL2huWHFlQ3ZCUmN5b1BtOTY4ZGFPNE90K1dqVFlTMUta?=
 =?utf-8?B?SUNNUGFzdENqSVNBNDFTRTdXQlczMHRYWHF2bEhxVTBhMys2QXI0OGJxQzNO?=
 =?utf-8?B?SUphdUxwTkFBRTRaVEpVa1JQdy9qakRDWXY1ZkVNczFGNmE2a0dNdGlLdnJX?=
 =?utf-8?B?SmtreVk0cysya2JFb290UzlJWHpnTDdXWUNZd2JUYUZHT3dvTmpsTWg3SGdQ?=
 =?utf-8?B?WC9HRTZQV084RHRyd3FoYjNVYkIvYzN0YnJJTWtEKzEydkxHVnVDb0Y0anI0?=
 =?utf-8?B?NytWajh0YjI2RERpdkJpaHJ0ZWdvTUFZbWJtWGNsSkptTC9iVVlQUTcyNEZH?=
 =?utf-8?B?dDVrTU1SM29nbGQwbDArUTExMWJOQmU0alRsZEsvU2h1NGh5b3puRXMzejVW?=
 =?utf-8?B?K25ST3VDM3NXbFcwVHgrbUJJZkN2MTRUSndMSlJvT01yVmV1dGR1SVV1YlNT?=
 =?utf-8?Q?fZ904ReJP844KGIJwtL41SFNT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76466e18-6165-43a0-aebf-08dbdbae6b1b
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2023 14:17:17.6275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kZY9IXXrrcgfIah2AFBqYqi4dpXts0NxYLZtY9te0NJbcMff+nDCdveulybE4rOfyqNzfduYdfu+uD5SzismNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6814

On 11/1/23 23:28, Nikunj A. Dadhania wrote:
> On 10/31/2023 12:46 AM, Tom Lendacky wrote:
>> On 10/30/23 01:36, Nikunj A Dadhania wrote:
>>> For enabling Secure TSC, SEV-SNP guests need to communicate with the
>>> AMD Security Processor early during boot. Many of the required
>>> functions are implemented in the sev-guest driver and therefore not
>>> available at early boot. Move the required functions and provide an
>>> API to the driver to assign key and send guest request.
>>>
>>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>>> ---

>>> +static void snp_inc_msg_seqno(struct snp_guest_dev *snp_dev)
>>> +{
>>> +    u32 *os_area_msg_seqno = snp_get_os_area_msg_seqno(snp_dev->vmpck_id);
>>> +
>>> +    if (!os_area_msg_seqno) {
>>> +        pr_err("SNP unable to get message sequence counter\n");
>>> +        return;
>>> +    }
>>
>> I probably missed this in the other patch or even when the driver was first created, but shouldn't we have a lockdep_assert_held() here, too, before updating the count?
> 
> As per the current code flow, snp_get_msg_seqno() is always called before snp_inc_msg_seqno(), maybe because of that the check wasnt there. It still makes sense to have a lockdep_assert_held() in snp_inc_msg_seqno().
> 
> Should I add this change as a separate fix ?

It can be sent as a separate patch (I don't think it is a fix) either 
before or after this series.

Thanks,
Tom

> 
>>

