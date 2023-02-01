Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E85BE686C91
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 18:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbjBAROq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 12:14:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjBAROo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 12:14:44 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2057.outbound.protection.outlook.com [40.107.93.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28AB71AE;
        Wed,  1 Feb 2023 09:14:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dmw2zsKbl9nBgpreaaV+9qjvu1yYizgs0AE88Wsoi2XgYo1PGQyTDGqhhZTki6lylfkOza+dXHmTtFLjdWlr4AaatbQGtS27ZfGzehECN9o6k5/WRNzG+NFVwXgRssi3KKil1qUCP6uFmK1r5h0H2z0ODqw/cp1Er2BpC/AYaRf8XxQWGTfTfjQuLLtW4bj4dy3Dsj9565JdmuDEMkUGhZCuWdPPQb/mW2eu4KCB4Q5cMo35Te4D4yXnXyeN4c+ex3SoL93LN/PTZ4eEtjla5pD15IoPUe6oD/s3/+ny4uayiYMRghmWpTr4gdAeZorLbmNWanV5x3tLu7RDG+Pjkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dHg7VcZi6mhfgVEot8Xfo6rGddRf+Vq02u3jPhmUstQ=;
 b=AjEGYPcWvqOqpISTjJj5RQ7Up8b+ztx9gxAOHAEJ/KR4i6dO4h2Gv7NFEXqmESn7Ykm+fNBGnTDOzZs+QBphklFpUTypeod8xE5LAC9K0AwJpOmKZsoiZPmn3gaWb6WG02EQfFypMhYsDBAxNOl0/MhLotuX1aOra/zsU73vs2kXUQeKOlaqUEmyUdMHMz6JZH5rSQerm9bo/zrL9GS0LFbhXQOz2vch412FGKizU4PON2Gi+yJNZnHRVvk6g9HT9evHm7K7gt7gY0ZfdevmMcHMH6BTxMzfB5U29H4hgJ0B1pW9g8c2JqwYvyWDOhvlFZT9090Wb6f6wgMufV7Aww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dHg7VcZi6mhfgVEot8Xfo6rGddRf+Vq02u3jPhmUstQ=;
 b=0ypcZNBmRO444E1xgWtqFC3SBDnfJMz4EwULOdiN5O8nvAUEle68yaApjtNI0DYErSj3edXChCLXWTypsGq/kESF5EsPsxllMOFQRBb7kXzET9NVePv1AIHysXKHvsgxXqDjzo9B7GcP9faaySg/lxGQzu4EWcgdPIjQYz/Vsv4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by MN2PR12MB4454.namprd12.prod.outlook.com (2603:10b6:208:26c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Wed, 1 Feb
 2023 17:14:41 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::dc5d:6248:1c13:4a3]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::dc5d:6248:1c13:4a3%7]) with mapi id 15.20.6043.038; Wed, 1 Feb 2023
 17:14:41 +0000
Message-ID: <59dd6291-6a99-ab7a-865f-b333a5f57bb9@amd.com>
Date:   Wed, 1 Feb 2023 11:14:35 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH RFC v7 16/64] x86/sev: Add helper functions for RMPUPDATE
 and PSMASH instruction
Content-Language: en-US
To:     Alexander Graf <graf@amazon.com>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, harald@profian.com,
        Brijesh Singh <brijesh.singh@amd.com>,
        "Rapan, Sabin" <sabrapan@amazon.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-17-michael.roth@amd.com>
 <854a0caf-6940-8381-1e20-0ddb5ed94858@amazon.com>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <854a0caf-6940-8381-1e20-0ddb5ed94858@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR05CA0069.namprd05.prod.outlook.com
 (2603:10b6:610:38::46) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|MN2PR12MB4454:EE_
X-MS-Office365-Filtering-Correlation-Id: ced064b8-1158-4b3b-577d-08db0477ce07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: juvK1depu2UTO4W9EXcYX+89lESqd0HhOI45KNLFmhD6Ok0XEGKpWzJ38RlmfmFI9BBumtWgSM/NH6xfzhwDfnDyn1rLXRfLFMTGUGBcLa6B9utrULccOAGlJOJjLi/IUppAUeZSy9yz15kqCX3PgrnMIrW6RA/PDCUiApiMUN4aFTARZ+RM9fzYRgnefeBfKl/t7CeAtILO1yhdQcghLpEpB+GM077qaX1X/MJMvjdnfucAqSTNFhIxxCf+AsqsFX2Se9mqaY1khTQxEnNDdOs1eRXZzAtRnYkMaM7NKP26fftRVXTWQeM47QAmuiuDzIlAoqjIzp4Z/s65jx7tTxQ0tm0xQaSuTHJJopyi6fHr//z9vO73gN2Nd/iCi2VehQneA+VpS+2m5C0S33dWq8PEBQLaG1RMiAV4LsvcA2WWTJQMCMjf73fRXz0CMNG+uM8SePWTEOh/QtPHDVpzCoTscC4mR1emb373ig/obZ4X7cNk98Oj64CCHDXOZaWRodrEc7GEu2uuDVxsPOf8lnjVj/reLbjV686wb4FNVeslpJviC5ZZRf6VDqZ0iWlQ3bRkGHN1Ce3SbhMXLqOXrcUq1DrNT+tGuqrySJoFi4GXISzL/xPAnHakvg3DNnDVooN4ufrM/17uhtSwe1InspnS/yKkaF2n3E+Q5jxRKirfJVrpMf2gMtvwlfapbDIiReSgc0RaUU52e2x4NGh+yg7ixCXpwYd9DU+urmdB6vD7obw+N56FsRescmmvTWDalQEBltMXqRfbNGvzRUL+og==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(451199018)(316002)(38100700002)(2906002)(6506007)(26005)(6512007)(5660300002)(186003)(36756003)(110136005)(2616005)(54906003)(53546011)(7406005)(7416002)(6666004)(6486002)(66476007)(31696002)(31686004)(83380400001)(4326008)(86362001)(478600001)(8676002)(66556008)(66946007)(8936002)(41300700001)(45980500001)(43740500002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M3lITUJVa0RoYzVzazFZNHhicVArVTNNUkJhQUJodjBtMmtWOElYU2xxakU2?=
 =?utf-8?B?WFlSQVFoRFkzdE9LQS9kRFA5c1pQTlBsNURLYjR0MGlld29ka2VKckc2ZVlW?=
 =?utf-8?B?WU9BVFh6QVArZVhPcm5LZURqWFRKVStnSitSaURONFB5UmYrU09KZ2YxK2hh?=
 =?utf-8?B?cndONmVZUGhrbXp0U3F6NVlOcDlWcEcwSnNreDRaRENmQnlGdjlsV2IyU1pj?=
 =?utf-8?B?bzdhejhFMnplSGFHd3dDVGJYem96N0Z0VEJzS0JZRTVDMVFMOWladVhLZjRo?=
 =?utf-8?B?MFYwWFFkOW1VMEJxd2QyRnBmSW16SmwrcXlNUkx3NVViS21OV1g0YjJ2YzZJ?=
 =?utf-8?B?OU1QTm11NHZKODhLRzJMcmptZThNdlRQSVZBdmY2VE5YbWpHanZTR2FJSUFT?=
 =?utf-8?B?ZG9QSDY0OGk4Q2tGUlBCczA3bW14U2ZmTy9XT04rNG96aUZVM2c5VjBqTjVO?=
 =?utf-8?B?bjlxUWx1Q2NZR2Ivc1BEZy9ZQUdIYmpUUGpsR1pWekF4emZ6VHMyTjhQWWpp?=
 =?utf-8?B?bzNRR2MwZkVkczFscHhucWdLV2hLUkpMUEUya1FQeUVnQXlZWDJmM0F3RSt2?=
 =?utf-8?B?SzhDa2U4aVFneW91NGFsdTJCZzRhTm05bWNqdHZNN1JYYnZ3cVFPNDZiRUx2?=
 =?utf-8?B?NVdyWFRubkRSQkUwcmxzNE1TSE1uVW16MTBwQ0JiOWRTQVNuNUMyZWVNcFZ2?=
 =?utf-8?B?NHBlZmErU24vUjBaYzEyV2gwWi9EKzRFMWVuWW1ZYU5GQUdFLzNKaEdROVNl?=
 =?utf-8?B?aHhjYXd1cmdpeXRPV0QybzZ3WVpCWmZ6SjFlZ2huS081d1pxUmV6eWlRWG5L?=
 =?utf-8?B?SlorNTFkdy9vUzFodTNFZ1lDaTNnZGo4MFJqdkVtRVZQRHhOMG9JaExuVUg4?=
 =?utf-8?B?VklUdVhvbloyUVgyYUZ5ME1CVXBxSjZ5M2FvYkRsY21UdVhZSitRVTRNamdY?=
 =?utf-8?B?QmE3TlZobllrVUdaQU9OMnYzeVRTbFAyTCtHQ2h0RWNIa0xnNW5GRUlFeFA2?=
 =?utf-8?B?RlArK3ljN0V2VXRRclBzSHg4YkhaTDRIY3NrRG1qZGVic0Q2V2w1eXo0TjVu?=
 =?utf-8?B?UzA3bkd5ZGUzUURlaUcvM2hJVjZzN0J0YngrZFdCYzBFWmE4ZnFRbHJVMFl0?=
 =?utf-8?B?WGxLcU1Ta2tqWGZneDF3aE9FYTNSZU5VMzliN3R3OTJsd2dJQkdmK3M3Rm9C?=
 =?utf-8?B?SHlHWFBJL1QzYVRRZUx3QktGdWdPblBRTFdNTCtMME1WR3dYMzQvbzR5dlkv?=
 =?utf-8?B?eWxnOEF6aHB5dmdnQkVxdXUxVEtoc1lMMlRYSENLalFBeU5NTlZoUk5ZQlp1?=
 =?utf-8?B?S0U3NTBhMUMzcldEd1YzVk85NnAyT0M1azRCb0E0WitxTi9RZGdCcDByNk84?=
 =?utf-8?B?TGFnTVJrYzJabFg0MXJyZE5nMkV3R2dNdElrU1F0cG5palBzTFBVbVZuNEtM?=
 =?utf-8?B?VVdvYkNveVM5M29HUWNUcXpsaWJ0a3owUVpaOGtnRGpMdGR0WXoyb1MzYXA1?=
 =?utf-8?B?WUlNOUc4T0s5TEdYd2ozaDNOUnpzRXI2blBjUHZJd0VWYlh0bFlpWnJ4RTV1?=
 =?utf-8?B?STRMbW8xU3c1S1NOVVFlNk1qeDVKeGZzdG9hRU1pdTNUeDh2dk9VY3BQZjVu?=
 =?utf-8?B?N1B5eE5xUlJmRUhWUnpWWXZ3NUx4c2dCcTZmMjUwMUxjYUpqZWtzby9CVlVq?=
 =?utf-8?B?a2hVS2N2ZUM2STY5VysyczBBd3RUSW4zb1IrbDgyWmVRN0ZlckNCOVczMStK?=
 =?utf-8?B?aDVLd2k3QXhnRFludGw3cVUrQWNDWUx2aDZQU3pRQ0tFb2srMlpQOXhVdU5D?=
 =?utf-8?B?ajNEUkl3OUt3MFJYTTk4ZVZxZTM2VU82Vjd2dFJYeDliemxLcnBEbzFCQVk2?=
 =?utf-8?B?VEo0R0tFSjMwbXFZQ2lwL1JHU0xYSUNRL1JZV2tSQXBOblFtK2ZpTHFIMWFJ?=
 =?utf-8?B?K3VkYWZlR0Z6bVhIQnMvREt5OW5GSi85Z05QaXZSb0FHb2xMdDBLRGtWK0tl?=
 =?utf-8?B?cWJ0eEZxQ0xmVDFXTjFLOTEwM0gvUjF6eWRhUVJsUGNyY2VNd1cvVVVhZndU?=
 =?utf-8?B?LzRJQXQzYzc5cVhtZE9ISTZmdDBlNVNoOXJWem5EUHZHblAzMG9BL2hUNSs5?=
 =?utf-8?Q?4PBfYo8Y9BTtRDih6ZgxLTnQZ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ced064b8-1158-4b3b-577d-08db0477ce07
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 17:14:40.9920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Y8a0z3HRhIpedlD5R2JFAYXlS3/4c6sxMM26x0VY156rxWjpT1ryUmqJPT2tPoeIy0kLk9esZM+EuOJ4hQqjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4454
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/31/2023 3:26 PM, Alexander Graf wrote:
> 
> On 14.12.22 20:40, Michael Roth wrote:
>> From: Brijesh Singh <brijesh.singh@amd.com>
>>
>> The RMPUPDATE instruction writes a new RMP entry in the RMP Table. The
>> hypervisor will use the instruction to add pages to the RMP table. See
>> APM3 for details on the instruction operations.
>>
>> The PSMASH instruction expands a 2MB RMP entry into a corresponding set
>> of contiguous 4KB-Page RMP entries. The hypervisor will use this
>> instruction to adjust the RMP entry without invalidating the previous
>> RMP entry.
>>
>> Add the following external interface API functions:
>>
>> int psmash(u64 pfn);
>> psmash is used to smash a 2MB aligned page into 4K
>> pages while preserving the Validated bit in the RMP.
>>
>> int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, 
>> bool immutable);
>> Used to assign a page to guest using the RMPUPDATE instruction.
>>
>> int rmp_make_shared(u64 pfn, enum pg_level level);
>> Used to transition a page to hypervisor/shared state using the 
>> RMPUPDATE instruction.
>>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> [mdr: add RMPUPDATE retry logic for transient FAIL_OVERLAP errors]
>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>> ---
>>   arch/x86/include/asm/sev.h | 24 ++++++++++
>>   arch/x86/kernel/sev.c      | 95 ++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 119 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
>> index 8d3ce2ad27da..4eeedcaca593 100644
>> --- a/arch/x86/include/asm/sev.h
>> +++ b/arch/x86/include/asm/sev.h
>> @@ -80,10 +80,15 @@ extern bool handle_vc_boot_ghcb(struct pt_regs 
>> *regs);
>>
>>   /* Software defined (when rFlags.CF = 1) */
>>   #define PVALIDATE_FAIL_NOUPDATE                255
>> +/* RMUPDATE detected 4K page and 2MB page overlap. */
>> +#define RMPUPDATE_FAIL_OVERLAP         7
>>
>>   /* RMP page size */
>>   #define RMP_PG_SIZE_4K                 0
>> +#define RMP_PG_SIZE_2M                 1
>>   #define RMP_TO_X86_PG_LEVEL(level)     (((level) == RMP_PG_SIZE_4K) 
>> ? PG_LEVEL_4K : PG_LEVEL_2M)
>> +#define X86_TO_RMP_PG_LEVEL(level)     (((level) == PG_LEVEL_4K) ? 
>> RMP_PG_SIZE_4K : RMP_PG_SIZE_2M)
>> +
>>   #define RMPADJUST_VMSA_PAGE_BIT                BIT(16)
>>
>>   /* SNP Guest message request */
>> @@ -133,6 +138,15 @@ struct snp_secrets_page_layout {
>>          u8 rsvd3[3840];
>>   } __packed;
>>
>> +struct rmp_state {
>> +       u64 gpa;
>> +       u8 assigned;
>> +       u8 pagesize;
>> +       u8 immutable;
>> +       u8 rsvd;
>> +       u32 asid;
>> +} __packed;
>> +
>>   #ifdef CONFIG_AMD_MEM_ENCRYPT
>>   extern struct static_key_false sev_es_enable_key;
>>   extern void __sev_es_ist_enter(struct pt_regs *regs);
>> @@ -198,6 +212,9 @@ bool snp_init(struct boot_params *bp);
>>   void __init __noreturn snp_abort(void);
>>   int snp_issue_guest_request(u64 exit_code, struct snp_req_data 
>> *input, unsigned long *fw_err);
>>   int snp_lookup_rmpentry(u64 pfn, int *level);
>> +int psmash(u64 pfn);
>> +int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, 
>> bool immutable);
>> +int rmp_make_shared(u64 pfn, enum pg_level level);
>>   #else
>>   static inline void sev_es_ist_enter(struct pt_regs *regs) { }
>>   static inline void sev_es_ist_exit(void) { }
>> @@ -223,6 +240,13 @@ static inline int snp_issue_guest_request(u64 
>> exit_code, struct snp_req_data *in
>>          return -ENOTTY;
>>   }
>>   static inline int snp_lookup_rmpentry(u64 pfn, int *level) { return 
>> 0; }
>> +static inline int psmash(u64 pfn) { return -ENXIO; }
>> +static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level 
>> level, int asid,
>> +                                  bool immutable)
>> +{
>> +       return -ENODEV;
>> +}
>> +static inline int rmp_make_shared(u64 pfn, enum pg_level level) { 
>> return -ENODEV; }
>>   #endif
>>
>>   #endif
>> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
>> index 706675561f49..67035d34adad 100644
>> --- a/arch/x86/kernel/sev.c
>> +++ b/arch/x86/kernel/sev.c
>> @@ -2523,3 +2523,98 @@ int snp_lookup_rmpentry(u64 pfn, int *level)
>>          return !!rmpentry_assigned(e);
>>   }
>>   EXPORT_SYMBOL_GPL(snp_lookup_rmpentry);
>> +
>> +/*
>> + * psmash is used to smash a 2MB aligned page into 4K
>> + * pages while preserving the Validated bit in the RMP.
>> + */
>> +int psmash(u64 pfn)
>> +{
>> +       unsigned long paddr = pfn << PAGE_SHIFT;
>> +       int ret;
>> +
>> +       if (!pfn_valid(pfn))
>> +               return -EINVAL;
> 
> 
> We (and many other clouds) use a neat trick to reduce the number of 
> struct pages Linux allocates for guest memory: In its simplest form, add 
> mem= to the kernel cmdline and mmap() /dev/mem to access the reserved 
> memory instead.
> 
> This means that the system covers more RAM than Linux contains, which 
> means pfn_valid() is no longer a good indication whether a page is 
> indeed valid. KVM handles this case fine, but this code does not.

Hmm...but then is also using max_pfn reliable ?

> 
> Is there any particular reason why we need this check (and similar ones 
> below and in other RMP related patches) in the first place. I would > expect that PSMASH and friends return failure codes for invalid pfns.
> 

Yes, PSMASH does out of bounds check on the input SPA and additionally 
checks if SPA is 2M aligned, so guess we can rely on using PSMASH 
failing on invalid pfns.

Thanks,
Ashish
