Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64C7F66A5A5
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 23:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbjAMWFP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 17:05:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjAMWEx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 17:04:53 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2059.outbound.protection.outlook.com [40.107.244.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F59276817;
        Fri, 13 Jan 2023 14:04:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fKLDIh2vs1H+XxE2C/nRDibkypdKRaxiy+w/rEwCpXcZF8Cong3yHR+vfh2xJ5Q+TM8r2QJHLitnDetJemfkaMHjb8/KF9mbDiVrxyruNXDQNdbCNvgBRbi6Xnu7ZigtQB0yPbRDlVTpqms53UPoEjw6xpVOItk9YMEDVHV42p8BivGrxVIuhHqrsQkIlQhg01dQnKDR1H/et6i5gXe0Raq0Vavurcb0iimyMLenxEPWnve1FlL0TUKJyPT8bwA4r1EMidpvfu13M2WH9FlIc1HQqou+QXNed9DWe1YgrousThs1nP5nxJzynPO5siJhdRmoDn1bxvTWEoDZEaqv/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OKDQd169p9NHDkbPuWgw8BWvaXEMH4Oq2A0oQTuZano=;
 b=mRvPTL3htQN17squEcR/pNQPP+pTcedCufOiGiXake0nXXDSHsn2c59y4vXoXFeZ/NiSmy/H1Jo2sYF3U/h50yjSbXtijw7YPfLFrto7MZUBnyV+o3HNTPPO5eFU9RF21QqUvVM+0rRf32ZMwoFEoHKPvV24KUV2NR9Y9/U0O0feEMyJ+fm9qdG8/NHLRbxvQo7PxNHCCcfj/Cchs23NsxN8TkwZi1pbTB+Te7mFLCQ+sTNKrihjeTNWY5McbVDdFts26r7eqluqRSjS/ncTviOj/J2wKjBwh/BTYzuTJyE5ajEA9TkRHgRi1h2j/ZmRTTU/T+55tdjMjHo3ns8tlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OKDQd169p9NHDkbPuWgw8BWvaXEMH4Oq2A0oQTuZano=;
 b=QPu+FRwDLoj2KEJmV1YolF2ewsObfE0x+QtXx9kp3kc8P8DiNgOc72letlt79LfX9blSnZNJ1WUSsIDnKhRWXA7JJ4GUPefQV2tNpm3/YCO5nNMrQVxNuJvNohlt2Y88THL8JLPht3eZjovgSK6Kyv4C/07xy9YXf6TWtfF5ZCc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by PH7PR12MB7379.namprd12.prod.outlook.com (2603:10b6:510:20e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Fri, 13 Jan
 2023 22:03:59 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9%3]) with mapi id 15.20.5986.018; Fri, 13 Jan 2023
 22:03:59 +0000
Message-ID: <7f1a9568-a570-690e-4b74-22644a3e2094@amd.com>
Date:   Fri, 13 Jan 2023 16:03:52 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH RFC v7 29/64] crypto: ccp: Handle the legacy SEV command
 when SNP is enabled
Content-Language: en-US
To:     Alper Gun <alpergun@google.com>,
        Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
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
        sathyanarayanan.kuppuswamy@linux.intel.com, dgilbert@redhat.com,
        jarkko@kernel.org, harald@profian.com,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-30-michael.roth@amd.com>
 <CABpDEum=-3_izZJYzQb4B2ef699f2R+SDWC-L2Ca-rPE5-ekpw@mail.gmail.com>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <CABpDEum=-3_izZJYzQb4B2ef699f2R+SDWC-L2Ca-rPE5-ekpw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0037.namprd03.prod.outlook.com
 (2603:10b6:610:b3::12) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|PH7PR12MB7379:EE_
X-MS-Office365-Filtering-Correlation-Id: 968e8385-9d30-42a4-9e3f-08daf5b2128b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7mXwalxz/m4O8YkiW2rOEgl2X2l0rlVXXjUtKBrz0CpGCvIDoJdOmy2ckrqn0ZBuy0DfmqG+2ta4oQo6sGP7cYaBKmhRfDn9Q1oUaPPy1f6AZsSdw+0as+IQlB1t+L4QWWuxfzNZ7S+hUP7U9+0hIYSLCFy0wZgshfa67RUj7KTb4sHAM/12iWqoH27PNjMcxK8LVyFNlC4yla/tgYrZJtDcW2DxqfhnMjNhYusDg1CkndbHFLrrPSiROtVEcaPNdhB9JyiWEO/1GFWsvGcq66zOyzkS5ndKO28PTey94YG7fB9KKDvsgptd1FZfeqlZ9eX/DO0Y0NWPzUzAEV7ReIPSSuRGOga8LHVEb7vXxjVE10ILAtdqQetBLxWcE69WZ/Kg4a/0SdjT7nx+owypiD7HZHyBUqXr9ztgOgmdoouEeLKV8bYbas+7aSW1h8CMTzqXxIzwXtE//x2P1U/st7DCtLa5By8HeOnoG5oeS102HHvb7P6ZR6OQtWnO7EDaI77mbn4AL73bt8TApvqphMmhI1rf40WFas53PHKJUXsWlk2w1bYd8GG7cH7FxV+OHMqDLVHYsrWXrU/EXQHAUzCW516ucHFfPGDQHfvFW2DpOFvworGJ8ZqOAN21PMgrHncD7/Gj1Ru7dlDakqNAqp2W/CWRO73/XrLlcFR10MoHR9D3ZrsgM5tazbXPgH1WfBauepv3LLuM+tXKmMo1VWHUv4im2Q9TkpPOLLGPwFc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199015)(6506007)(38100700002)(6666004)(31686004)(53546011)(2906002)(6486002)(478600001)(5660300002)(2616005)(7416002)(30864003)(86362001)(6512007)(186003)(7406005)(316002)(26005)(8936002)(36756003)(83380400001)(8676002)(31696002)(41300700001)(66556008)(66946007)(110136005)(6636002)(4326008)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VEp6N3YzdDFxMmVBVktYV09IaXpaRCtocUZ6WFlxa0dkRDVJeVR0VlExQUhr?=
 =?utf-8?B?QWhoZ0xYQU9vSUxQUmcrOUJheGUxZ0FXejE0VnpldXF6YXdYTzR0dktlTURt?=
 =?utf-8?B?RG41alY3ZU1yakphMWxkejNSWGVwSEdZTStOS2ZVREQrWkI2YWQySUFXRytE?=
 =?utf-8?B?bU9hOFZXTUNWcnB2Vk9rMUVvYjlQR3FtQVduRHQ1dUNES2RxdVZLMmZqOUpC?=
 =?utf-8?B?QzlqR1gwNURYald2cUphRzdBelF6dm1ERWF1RUhTZURpd0FkL1lTWjVjdWxM?=
 =?utf-8?B?WnVXc21SQytLWm4yR0hRUWhHcWRVbjN4a2FOWHRXRVlTb05DSGhSY2cwWmpD?=
 =?utf-8?B?Y0lSSEprMTllSW9KUVljNjFxKzRrYjlzZ2tMSisrMVE5M0tRRzcwRTB5ekNT?=
 =?utf-8?B?dzZRUGhuYm5IZnl2SXFZb2FrUDdBUXZIdTZpQjk5NUR1eDRXTTFpTXoxOFhm?=
 =?utf-8?B?bmZiaC9CSWE5NzlyblQyNjdPVnJEeVNnQUZjNG4zTGNVN3pmK0dnbzRwUW9z?=
 =?utf-8?B?T21wd1N1cnpOa0wrYXZkamxTODhZWHhIZEVVcTRoemJ1ZXJORGpHNHhUZVVz?=
 =?utf-8?B?bjJJNnNoUWNHUG5OcVBKNkxlS0RqWjVncDZpd3lkLy9aSzZoOEZ3UXZRWTN6?=
 =?utf-8?B?VW9yR2RkcUdKWE9aZExxRTNEL29SbXl6YkFDMVRoSWpIa2MyT0J5VDVQVmZm?=
 =?utf-8?B?Tm0xckdkdy8rVFpMaytCWXZKc1VPTTlNRExrOXJrRTh2bWRJOXFtWTkvL1V4?=
 =?utf-8?B?bWg1VnMvMmN5dndHRXZTYzV6OXhkSFBYazhSRVNpTm5iTEUwNkZacGJiSGxv?=
 =?utf-8?B?cHk4UEhUcndzOFBLTHpsN25MY0xlQmg3MmFYZERiZlUyQUFTZE9qbWNsU2c4?=
 =?utf-8?B?Wk9PaGJDZnpjMFFFOUYwVlpiWjh6ZnpGS3lhNXhMS2tvWGJ1MzlhOVc0d2N5?=
 =?utf-8?B?WlZjdzdLN0dqNC9qdzJHOWpNNGwxVE5VSHhkOXoxdE90NFlHdHNqSHlwbTR4?=
 =?utf-8?B?djBmSUNPZUE4aXJ1ZDE1VXpnQ2lpZS94cGNMbFVzZ3lYMWs5cU5FMDBmemNt?=
 =?utf-8?B?MVg5VjVIcXBHK3Z6cjY0bExOREJwblJ3RldYUDkvdkt5dUc5MG1jNXowaDRk?=
 =?utf-8?B?VkVETnRxWUx2N1FiM0hXOTB4SS8xa1FtMi84blU0Q3Z3czJmN1ZDM1NKNDB2?=
 =?utf-8?B?cCtKbjJDckRkTmhvUlVQZjExVDV4aW91Qk83S1FFbDJmTWZuZmQvWkxTR1p5?=
 =?utf-8?B?d1duTnhqbWdQN3o4QnRkcit6eXh4YWQvNXhoTTljOURHREFJQ1VwTWZ0SWx3?=
 =?utf-8?B?K0hmRHUxVWtZVnUxQVdRQ3NBUlo3T1JMMEM1cXRMVmNEY3YwSEpadk9sOEhQ?=
 =?utf-8?B?UG1ITXpjSGkyQng1YngyWnAyMmNLdjFrR3dKYWc3OUFKa1pVY2xnZE81Y2dD?=
 =?utf-8?B?bnpUUndia1RpZG4wRXA3ei9qTTFKZlp3UWhLbWthVGFScjhwbXlPSkswSkNX?=
 =?utf-8?B?Q0xEMDEreEl5VXU0ZFNVNGhocThqMzVMR0J2MjRteTZERDNyWXBUQk1ORXVs?=
 =?utf-8?B?UzN6SUlxRk9SOHRvMHVSM1ZQODV3RjlLd0VQV29VSVpYMXg0d1Ryak1UUjBs?=
 =?utf-8?B?cGluM3dNcHlmS0k0bHoyNVFkajBOR0pzUXJra3ZGcXhWcC82azBxcGViU2xD?=
 =?utf-8?B?dTJoVG1mdmFpaWpxeXh1cWtSKzBjR2lWK3hocWgrQS9PbnN6eWM2MkZ1cUtQ?=
 =?utf-8?B?c1pwOWl5V0RhZ3hMTDFWY0pnZFlnMzZoTWluRU1RZmE4N2ZkcUNFUDd0Y1hR?=
 =?utf-8?B?Nkxia1NEK2xwQU1GWlFjZ2pmUHdlLzU3cFY1eDhsYU1BOW84QUROMWtzWGRs?=
 =?utf-8?B?T0FDR2paZHBHbHk2NFJFblE5ak1zTXlaV1JTTEh5MzY1UnRiZENtSFhoVEhT?=
 =?utf-8?B?a21mUG9pTnZQVm41R3BaOG0rTDR3VWpsV0ZMaG1POHFoMGtwRWl3YlBmZ21u?=
 =?utf-8?B?MFA5eUJjRStIMTA2T3o4NHlDY01mdGQ3eEtSbVRTWkZtWk5wa08wU3NNeENT?=
 =?utf-8?B?MnRDSlVONnU5L0lsdm9lSTU5UHdDNzU0WWQ4Nk9HS0VLaHpHeU9JazRwenRu?=
 =?utf-8?Q?O9JJj9CPUlg9Et077Nx5tRuIb?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 968e8385-9d30-42a4-9e3f-08daf5b2128b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 22:03:59.3438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dUGEJpVasricZWbpCVsg02ve1yar5m2zKRQcPAn8QJO9m//VdXTv4vqivTLLmoZRZrweh8O7l8Cabk9UIBtg3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7379
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Alper,

On 1/12/2023 2:47 PM, Alper Gun wrote:
> On Wed, Dec 14, 2022 at 11:54 AM Michael Roth <michael.roth@amd.com> wrote:
>>
>> From: Brijesh Singh <brijesh.singh@amd.com>
>>
>> The behavior of the SEV-legacy commands is altered when the SNP firmware
>> is in the INIT state. When SNP is in INIT state, all the SEV-legacy
>> commands that cause the firmware to write to memory must be in the
>> firmware state before issuing the command..
>>
>> A command buffer may contains a system physical address that the firmware
>> may write to. There are two cases that need to be handled:
>>
>> 1) system physical address points to a guest memory
>> 2) system physical address points to a host memory
>>
>> To handle the case #1, change the page state to the firmware in the RMP
>> table before issuing the command and restore the state to shared after the
>> command completes.
>>
>> For the case #2, use a bounce buffer to complete the request.
>>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>> ---
>>   drivers/crypto/ccp/sev-dev.c | 370 ++++++++++++++++++++++++++++++++++-
>>   drivers/crypto/ccp/sev-dev.h |  12 ++
>>   2 files changed, 372 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index 4c12e98a1219..5eb2e8f364d4 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -286,6 +286,30 @@ static int rmp_mark_pages_firmware(unsigned long paddr, unsigned int npages, boo
>>          return rc;
>>   }
>>
>> +static int rmp_mark_pages_shared(unsigned long paddr, unsigned int npages)
>> +{
>> +       /* Cbit maybe set in the paddr */
>> +       unsigned long pfn = __sme_clr(paddr) >> PAGE_SHIFT;
>> +       int rc, n = 0, i;
>> +
>> +       for (i = 0; i < npages; i++, pfn++, n++) {
>> +               rc = rmp_make_shared(pfn, PG_LEVEL_4K);
>> +               if (rc)
>> +                       goto cleanup;
>> +       }
>> +
>> +       return 0;
>> +
>> +cleanup:
>> +       /*
>> +        * If failed to change the page state to shared, then its not safe
>> +        * to release the page back to the system, leak it.
>> +        */
>> +       snp_mark_pages_offline(pfn, npages - n);
>> +
>> +       return rc;
>> +}
>> +
>>   static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order, bool locked)
>>   {
>>          unsigned long npages = 1ul << order, paddr;
>> @@ -487,12 +511,295 @@ static int sev_write_init_ex_file_if_required(int cmd_id)
>>          return sev_write_init_ex_file();
>>   }
>>
>> +static int alloc_snp_host_map(struct sev_device *sev)
>> +{
>> +       struct page *page;
>> +       int i;
>> +
>> +       for (i = 0; i < MAX_SNP_HOST_MAP_BUFS; i++) {
>> +               struct snp_host_map *map = &sev->snp_host_map[i];
>> +
>> +               memset(map, 0, sizeof(*map));
>> +
>> +               page = alloc_pages(GFP_KERNEL_ACCOUNT, get_order(SEV_FW_BLOB_MAX_SIZE));
>> +               if (!page)
>> +                       return -ENOMEM;
>> +
>> +               map->host = page_address(page);
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static void free_snp_host_map(struct sev_device *sev)
>> +{
>> +       int i;
>> +
>> +       for (i = 0; i < MAX_SNP_HOST_MAP_BUFS; i++) {
>> +               struct snp_host_map *map = &sev->snp_host_map[i];
>> +
>> +               if (map->host) {
>> +                       __free_pages(virt_to_page(map->host), get_order(SEV_FW_BLOB_MAX_SIZE));
>> +                       memset(map, 0, sizeof(*map));
>> +               }
>> +       }
>> +}
>> +
>> +static int map_firmware_writeable(u64 *paddr, u32 len, bool guest, struct snp_host_map *map)
>> +{
>> +       unsigned int npages = PAGE_ALIGN(len) >> PAGE_SHIFT;
>> +
>> +       map->active = false;
>> +
>> +       if (!paddr || !len)
>> +               return 0;
>> +
>> +       map->paddr = *paddr;
>> +       map->len = len;
>> +
>> +       /* If paddr points to a guest memory then change the page state to firmwware. */
>> +       if (guest) {
>> +               if (rmp_mark_pages_firmware(*paddr, npages, true))
>> +                       return -EFAULT;
>> +
>> +               goto done;
>> +       }
>> +
>> +       if (!map->host)
>> +               return -ENOMEM;
>> +
>> +       /* Check if the pre-allocated buffer can be used to fullfil the request. */
>> +       if (len > SEV_FW_BLOB_MAX_SIZE)
>> +               return -EINVAL;
>> +
>> +       /* Transition the pre-allocated buffer to the firmware state. */
>> +       if (rmp_mark_pages_firmware(__pa(map->host), npages, true))
>> +               return -EFAULT;
>> +
>> +       /* Set the paddr to use pre-allocated firmware buffer */
>> +       *paddr = __psp_pa(map->host);
>> +
>> +done:
>> +       map->active = true;
>> +       return 0;
>> +}
>> +
>> +static int unmap_firmware_writeable(u64 *paddr, u32 len, bool guest, struct snp_host_map *map)
>> +{
>> +       unsigned int npages = PAGE_ALIGN(len) >> PAGE_SHIFT;
>> +
>> +       if (!map->active)
>> +               return 0;
>> +
>> +       /* If paddr points to a guest memory then restore the page state to hypervisor. */
>> +       if (guest) {
>> +               if (snp_reclaim_pages(*paddr, npages, true))
>> +                       return -EFAULT;
>> +
>> +               goto done;
>> +       }
>> +
>> +       /*
>> +        * Transition the pre-allocated buffer to hypervisor state before the access.
>> +        *
>> +        * This is because while changing the page state to firmware, the kernel unmaps
>> +        * the pages from the direct map, and to restore the direct map the pages must
>> +        * be transitioned back to the shared state.
>> +        */
>> +       if (snp_reclaim_pages(__pa(map->host), npages, true))
>> +               return -EFAULT;
>> +
>> +       /* Copy the response data firmware buffer to the callers buffer. */
>> +       memcpy(__va(__sme_clr(map->paddr)), map->host, min_t(size_t, len, map->len));
>> +       *paddr = map->paddr;
>> +
>> +done:
>> +       map->active = false;
>> +       return 0;
>> +}
>> +
>> +static bool sev_legacy_cmd_buf_writable(int cmd)
>> +{
>> +       switch (cmd) {
>> +       case SEV_CMD_PLATFORM_STATUS:
>> +       case SEV_CMD_GUEST_STATUS:
>> +       case SEV_CMD_LAUNCH_START:
>> +       case SEV_CMD_RECEIVE_START:
>> +       case SEV_CMD_LAUNCH_MEASURE:
>> +       case SEV_CMD_SEND_START:
>> +       case SEV_CMD_SEND_UPDATE_DATA:
>> +       case SEV_CMD_SEND_UPDATE_VMSA:
>> +       case SEV_CMD_PEK_CSR:
>> +       case SEV_CMD_PDH_CERT_EXPORT:
>> +       case SEV_CMD_GET_ID:
>> +       case SEV_CMD_ATTESTATION_REPORT:
>> +               return true;
>> +       default:
>> +               return false;
>> +       }
>> +}
>> +
>> +#define prep_buffer(name, addr, len, guest, map) \
>> +       func(&((typeof(name *))cmd_buf)->addr, ((typeof(name *))cmd_buf)->len, guest, map)
>> +
>> +static int __snp_cmd_buf_copy(int cmd, void *cmd_buf, bool to_fw, int fw_err)
>> +{
>> +       int (*func)(u64 *paddr, u32 len, bool guest, struct snp_host_map *map);
>> +       struct sev_device *sev = psp_master->sev_data;
>> +       bool from_fw = !to_fw;
>> +
>> +       /*
>> +        * After the command is completed, change the command buffer memory to
>> +        * hypervisor state.
>> +        *
>> +        * The immutable bit is automatically cleared by the firmware, so
>> +        * no not need to reclaim the page.
>> +        */
>> +       if (from_fw && sev_legacy_cmd_buf_writable(cmd)) {
>> +               if (rmp_mark_pages_shared(__pa(cmd_buf), 1))
>> +                       return -EFAULT;
> 
> If we return here, we will skip calling unmap_firmware_writeable and
> we will leak some pages in firmware state.

Do you mean those (guest) pages which were transitioned to firmware 
state as part of 
snp_aware_copy_to_firmware()->_snp_cmd_buf_copy()->map_firmware_writeable()?

> 
>> +
>> +               /* No need to go further if firmware failed to execute command. */
>> +               if (fw_err)
>> +                       return 0;
>> +       }
>> +
>> +       if (to_fw)
>> +               func = map_firmware_writeable;
>> +       else
>> +               func = unmap_firmware_writeable;
>> +
>> +       /*
>> +        * A command buffer may contains a system physical address. If the address
>> +        * points to a host memory then use an intermediate firmware page otherwise
>> +        * change the page state in the RMP table.
>> +        */
>> +       switch (cmd) {
>> +       case SEV_CMD_PDH_CERT_EXPORT:
>> +               if (prep_buffer(struct sev_data_pdh_cert_export, pdh_cert_address,
>> +                               pdh_cert_len, false, &sev->snp_host_map[0]))
>> +                       goto err;
>> +               if (prep_buffer(struct sev_data_pdh_cert_export, cert_chain_address,
>> +                               cert_chain_len, false, &sev->snp_host_map[1]))
>> +                       goto err;
>> +               break;
>> +       case SEV_CMD_GET_ID:
>> +               if (prep_buffer(struct sev_data_get_id, address, len,
>> +                               false, &sev->snp_host_map[0]))
>> +                       goto err;
>> +               break;
>> +       case SEV_CMD_PEK_CSR:
>> +               if (prep_buffer(struct sev_data_pek_csr, address, len,
>> +                               false, &sev->snp_host_map[0]))
>> +                       goto err;
>> +               break;
>> +       case SEV_CMD_LAUNCH_UPDATE_DATA:
>> +               if (prep_buffer(struct sev_data_launch_update_data, address, len,
>> +                               true, &sev->snp_host_map[0]))
>> +                       goto err;
>> +               break;
>> +       case SEV_CMD_LAUNCH_UPDATE_VMSA:
>> +               if (prep_buffer(struct sev_data_launch_update_vmsa, address, len,
>> +                               true, &sev->snp_host_map[0]))
>> +                       goto err;
>> +               break;
>> +       case SEV_CMD_LAUNCH_MEASURE:
>> +               if (prep_buffer(struct sev_data_launch_measure, address, len,
>> +                               false, &sev->snp_host_map[0]))
>> +                       goto err;
>> +               break;
>> +       case SEV_CMD_LAUNCH_UPDATE_SECRET:
>> +               if (prep_buffer(struct sev_data_launch_secret, guest_address, guest_len,
>> +                               true, &sev->snp_host_map[0]))
>> +                       goto err;
>> +               break;
>> +       case SEV_CMD_DBG_DECRYPT:
>> +               if (prep_buffer(struct sev_data_dbg, dst_addr, len, false,
>> +                               &sev->snp_host_map[0]))
>> +                       goto err;
>> +               break;
>> +       case SEV_CMD_DBG_ENCRYPT:
>> +               if (prep_buffer(struct sev_data_dbg, dst_addr, len, true,
>> +                               &sev->snp_host_map[0]))
>> +                       goto err;
>> +               break;
>> +       case SEV_CMD_ATTESTATION_REPORT:
>> +               if (prep_buffer(struct sev_data_attestation_report, address, len,
>> +                               false, &sev->snp_host_map[0]))
>> +                       goto err;
>> +               break;
>> +       case SEV_CMD_SEND_START:
>> +               if (prep_buffer(struct sev_data_send_start, session_address,
>> +                               session_len, false, &sev->snp_host_map[0]))
>> +                       goto err;
>> +               break;
>> +       case SEV_CMD_SEND_UPDATE_DATA:
>> +               if (prep_buffer(struct sev_data_send_update_data, hdr_address, hdr_len,
>> +                               false, &sev->snp_host_map[0]))
>> +                       goto err;
>> +               if (prep_buffer(struct sev_data_send_update_data, trans_address,
>> +                               trans_len, false, &sev->snp_host_map[1]))
>> +                       goto err;
>> +               break;
>> +       case SEV_CMD_SEND_UPDATE_VMSA:
>> +               if (prep_buffer(struct sev_data_send_update_vmsa, hdr_address, hdr_len,
>> +                               false, &sev->snp_host_map[0]))
>> +                       goto err;
>> +               if (prep_buffer(struct sev_data_send_update_vmsa, trans_address,
>> +                               trans_len, false, &sev->snp_host_map[1]))
>> +                       goto err;
>> +               break;
>> +       case SEV_CMD_RECEIVE_UPDATE_DATA:
>> +               if (prep_buffer(struct sev_data_receive_update_data, guest_address,
>> +                               guest_len, true, &sev->snp_host_map[0]))
>> +                       goto err;
>> +               break;
>> +       case SEV_CMD_RECEIVE_UPDATE_VMSA:
>> +               if (prep_buffer(struct sev_data_receive_update_vmsa, guest_address,
>> +                               guest_len, true, &sev->snp_host_map[0]))
>> +                       goto err;
>> +               break;
>> +       default:
>> +               break;
>> +       }
>> +
>> +       /* The command buffer need to be in the firmware state. */
>> +       if (to_fw && sev_legacy_cmd_buf_writable(cmd)) {
>> +               if (rmp_mark_pages_firmware(__pa(cmd_buf), 1, true))
>> +                       return -EFAULT;
> 
> This function moves two separate pages to firmware state. First
> calling map_firmware_writeable and second calling
> rmp_mark_pages_firmware for cmd_buf.
> In case rmp_mark_pages_firmware fails for cmd_buf, the page which has
> already moved to firmware state in map_firmware_writeable should be
> reclaimed.
> This is a problem especially if we leak a guest owned page in firmware
> state. Since this is used only by legacy SEV VMs, these leaked pages
> will never be reclaimed back when destroying these VMs.
> 

Yes, this looks to be an inherent issue with the original patch, as you 
mentioned there are two pages - guest owned page and the HV cmd_buf, and 
failure to transition the cmd_buf back to HV/shared state has no 
corresponding recovery/reclaim for the transitioned guest page.

Thanks,
Ashish

>>
>> +       }
>> +
>> +       return 0;
>> +
>> +err:
>> +       return -EINVAL;
>> +}
>> +
>> +static inline bool need_firmware_copy(int cmd)
>> +{
>> +       struct sev_device *sev = psp_master->sev_data;
>> +
>> +       /* After SNP is INIT'ed, the behavior of legacy SEV command is changed. */
>> +       return ((cmd < SEV_CMD_SNP_INIT) && sev->snp_initialized) ? true : false;
>> +}
>> +
>> +static int snp_aware_copy_to_firmware(int cmd, void *data)
>> +{
>> +       return __snp_cmd_buf_copy(cmd, data, true, 0);
>> +}
>> +
>> +static int snp_aware_copy_from_firmware(int cmd, void *data, int fw_err)
>> +{
>> +       return __snp_cmd_buf_copy(cmd, data, false, fw_err);
>> +}
>> +
>>   static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>>   {
>>          struct psp_device *psp = psp_master;
>>          struct sev_device *sev;
>>          unsigned int phys_lsb, phys_msb;
>>          unsigned int reg, ret = 0;
>> +       void *cmd_buf;
>>          int buf_len;
>>
>>          if (!psp || !psp->sev_data)
>> @@ -512,12 +819,28 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>>           * work for some memory, e.g. vmalloc'd addresses, and @data may not be
>>           * physically contiguous.
>>           */
>> -       if (data)
>> -               memcpy(sev->cmd_buf, data, buf_len);
>> +       if (data) {
>> +               if (sev->cmd_buf_active > 2)
>> +                       return -EBUSY;
>> +
>> +               cmd_buf = sev->cmd_buf_active ? sev->cmd_buf_backup : sev->cmd_buf;
>> +
>> +               memcpy(cmd_buf, data, buf_len);
>> +               sev->cmd_buf_active++;
>> +
>> +               /*
>> +                * The behavior of the SEV-legacy commands is altered when the
>> +                * SNP firmware is in the INIT state.
>> +                */
>> +               if (need_firmware_copy(cmd) && snp_aware_copy_to_firmware(cmd, sev->cmd_buf))
>> +                       return -EFAULT;
>> +       } else {
>> +               cmd_buf = sev->cmd_buf;
>> +       }
>>
>>          /* Get the physical address of the command buffer */
>> -       phys_lsb = data ? lower_32_bits(__psp_pa(sev->cmd_buf)) : 0;
>> -       phys_msb = data ? upper_32_bits(__psp_pa(sev->cmd_buf)) : 0;
>> +       phys_lsb = data ? lower_32_bits(__psp_pa(cmd_buf)) : 0;
>> +       phys_msb = data ? upper_32_bits(__psp_pa(cmd_buf)) : 0;
>>
>>          dev_dbg(sev->dev, "sev command id %#x buffer 0x%08x%08x timeout %us\n",
>>                  cmd, phys_msb, phys_lsb, psp_timeout);
>> @@ -560,15 +883,24 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>>                  ret = sev_write_init_ex_file_if_required(cmd);
>>          }
>>
>> -       print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
>> -                            buf_len, false);
>> -
>>          /*
>>           * Copy potential output from the PSP back to data.  Do this even on
>>           * failure in case the caller wants to glean something from the error.
>>           */
>> -       if (data)
>> -               memcpy(data, sev->cmd_buf, buf_len);
>> +       if (data) {
>> +               /*
>> +                * Restore the page state after the command completes.
>> +                */
>> +               if (need_firmware_copy(cmd) &&
>> +                   snp_aware_copy_from_firmware(cmd, cmd_buf, ret))
>> +                       return -EFAULT;
>> +
>> +               memcpy(data, cmd_buf, buf_len);
>> +               sev->cmd_buf_active--;
>> +       }
>> +
>> +       print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
>> +                            buf_len, false);
>>
>>          return ret;
>>   }
>> @@ -1579,10 +1911,12 @@ int sev_dev_init(struct psp_device *psp)
>>          if (!sev)
>>                  goto e_err;
>>
>> -       sev->cmd_buf = (void *)devm_get_free_pages(dev, GFP_KERNEL, 0);
>> +       sev->cmd_buf = (void *)devm_get_free_pages(dev, GFP_KERNEL, 1);
>>          if (!sev->cmd_buf)
>>                  goto e_sev;
>>
>> +       sev->cmd_buf_backup = (uint8_t *)sev->cmd_buf + PAGE_SIZE;
>> +
>>          psp->sev_data = sev;
>>
>>          sev->dev = dev;
>> @@ -1648,6 +1982,12 @@ static void sev_firmware_shutdown(struct sev_device *sev)
>>                  snp_range_list = NULL;
>>          }
>>
>> +       /*
>> +        * The host map need to clear the immutable bit so it must be free'd before the
>> +        * SNP firmware shutdown.
>> +        */
>> +       free_snp_host_map(sev);
>> +
>>          sev_snp_shutdown(&error);
>>   }
>>
>> @@ -1722,6 +2062,14 @@ void sev_pci_init(void)
>>                                  dev_err(sev->dev, "SEV-SNP: failed to INIT error %#x\n", error);
>>                          }
>>                  }
>> +
>> +               /*
>> +                * Allocate the intermediate buffers used for the legacy command handling.
>> +                */
>> +               if (alloc_snp_host_map(sev)) {
>> +                       dev_notice(sev->dev, "Failed to alloc host map (disabling legacy SEV)\n");
>> +                       goto skip_legacy;
>> +               }
>>          }
>>
>>          /* Obtain the TMR memory area for SEV-ES use */
>> @@ -1739,12 +2087,14 @@ void sev_pci_init(void)
>>                  dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
>>                          error, rc);
>>
>> +skip_legacy:
>>          dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_initialized ?
>>                  "-SNP" : "", sev->api_major, sev->api_minor, sev->build);
>>
>>          return;
>>
>>   err:
>> +       free_snp_host_map(sev);
>>          psp_master->sev_data = NULL;
>>   }
>>
>> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
>> index 34767657beb5..19d79f9d4212 100644
>> --- a/drivers/crypto/ccp/sev-dev.h
>> +++ b/drivers/crypto/ccp/sev-dev.h
>> @@ -29,11 +29,20 @@
>>   #define SEV_CMDRESP_CMD_SHIFT          16
>>   #define SEV_CMDRESP_IOC                        BIT(0)
>>
>> +#define MAX_SNP_HOST_MAP_BUFS          2
>> +
>>   struct sev_misc_dev {
>>          struct kref refcount;
>>          struct miscdevice misc;
>>   };
>>
>> +struct snp_host_map {
>> +       u64 paddr;
>> +       u32 len;
>> +       void *host;
>> +       bool active;
>> +};
>> +
>>   struct sev_device {
>>          struct device *dev;
>>          struct psp_device *psp;
>> @@ -52,8 +61,11 @@ struct sev_device {
>>          u8 build;
>>
>>          void *cmd_buf;
>> +       void *cmd_buf_backup;
>> +       int cmd_buf_active;
>>
>>          bool snp_initialized;
>> +       struct snp_host_map snp_host_map[MAX_SNP_HOST_MAP_BUFS];
>>   };
>>
>>   int sev_dev_init(struct psp_device *psp);
>> --
>> 2.25.1
>>
