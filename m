Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09D6166A5F9
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 23:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbjAMWer (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 17:34:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbjAMWeo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 17:34:44 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1812176EDB;
        Fri, 13 Jan 2023 14:34:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EEtEaUZZ3h2ie7KO1y2nofkyIluO8l0ruiR/Ovh+n8p0weYFuGaHKO0HbH66jkndH36DHryWtx44i4GnmioGC5xn+vuxIIIl7TdbAeFYkF+z9MeoG5TMcEQ/5Y06pPdjy50HW3b7lP40/5NYVyWyMW4NAbrTrUSyFePQ64JRWxx4T7G+/xRTiZSP+SU5bE8qiUqGFnlEdI2M2KObFYxkkaRr0pswZHYES2jZ3g/EnSJm5/XAVkGlv0cLX5J/uZlLT9ymlgLk0dhbOJjJtd5Ovvf1Z7imVIF3tQxzwiNtZ7MYPpBB17kx8H8oodMDR50FjLXH5rOzO8mdf3l6dS0xLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/SdVHBiEQsWMk7gU6Jmu6U+mtQxL0Es8z6ubiO4u7+M=;
 b=amLJ2OVmyM6q3aziNpEFk5d0ezCyQgLLKow1GeAJTRbobOoOFRwUr9NSK1AiUVLHn9SJXIJJrOh8EHrUdxZT8fuufFGxiNDmZANvizYrQFETWJVPl3kVuxPQhCGhD1l0tPQja//G2/KoXI+wzQhUYxEZIbX4sAZ0l2qyEM4UCX4CCIImwD7mzxTBQy+BTrYRP2U1MSwGEbnHr9ekKo+kRIY/qrxPTjlgqHEHjUzfk5uuFRZbdRr5av22nsASNyb7mAHyEdOVDd4zvpnF6Zperp523fvEp3qQOLWyU0MnMWuQ14hO7IgViSbGB0JjR/ZrFIrSSpByezGEyb50jBj/Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/SdVHBiEQsWMk7gU6Jmu6U+mtQxL0Es8z6ubiO4u7+M=;
 b=W1UrIW3CFYsU7MOCqGQj0QFxoBeikO+PTilGXi5DCsTShGf2f0TXq7EMa482/fAXknRS1ZrhavQ5bObRQxRcPNZM0QC4XCL2OW5XVId4Lk/gKZZOg7kjWGAkM/wBl6Dk4oEtf/kiIAoWJYqDGSS44YbKHcJG6IM7YL3zW6NEbhw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by CH2PR12MB5019.namprd12.prod.outlook.com (2603:10b6:610:6a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.19; Fri, 13 Jan
 2023 22:34:39 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9%3]) with mapi id 15.20.5986.018; Fri, 13 Jan 2023
 22:34:39 +0000
Message-ID: <5f0322d6-e746-c29a-53ef-e5d168c3cf5b@amd.com>
Date:   Fri, 13 Jan 2023 16:34:31 -0600
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
 <CABpDEu=KTHp8Lp76JfzCdNZUAUj7FyYbfUHBTxGB2OGgBR1x5A@mail.gmail.com>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <CABpDEu=KTHp8Lp76JfzCdNZUAUj7FyYbfUHBTxGB2OGgBR1x5A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR14CA0010.namprd14.prod.outlook.com
 (2603:10b6:610:60::20) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|CH2PR12MB5019:EE_
X-MS-Office365-Filtering-Correlation-Id: 03e8dfec-211f-4d72-6256-08daf5b65b0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B4AYDF7jl9bqWn9xPeto+zAZ1fIgTqjpw+oxkJy3ddL6uVAfj+glWPawkPN8+U+pYRqty0BLr2HShVdLS7pihJHqYyGHbfn0LJGg8wByGAfB5q73ZmagQrmWRWiVH4hcwjPlhDsG/simsV4ek6aIO8qrYZvNtWAbUWD+LqJFy0vnt0NenbUIdtcQ0q44R7RXjSuVvrIz/6P9wsU9fzKhB2Wqf9441SKuIkobovBbVJ0x7fH9BofXAaqFPhUr3Zzrbe45AowOAa8uWoKWiq41QYl47gvkadp7UJx0ekZ3eHwm8RpA3MYmsHj0tIouaRyMpMWabzvkbSCAul5cue8R3fA5VgcdGBIVRC5pU7dnifRK8ER9u5tksbUtBx8818p1+hlMFoNVaB30zfQiJniQ609ngzx2kzAkz9Am3myTm0fTp4TjPRdu2mckHMAdWz8TGJbdBHB5FLWdaFOf5b+7YgG++i0xOHhJZYw2Ph6wrZqEigfRdsYaMxswvCK7gB8EIsn+HiU+0q/CorJ/PGD8OW+js5pS5/XaPrRrqplmthgsuzTP+Qpn/uTm1VszicXu+aOxDe73/6Oi8mCouWDukxgbIPAW++ISy+xUjQ9HFF2cQoEJ+32fQuxBIZbNCOEGPQxS/5rYj0M5d1FwrA5iEPI5QC9Khavl2qmwhpdfr4hHfsctNTMPaub1oaS83VoIc7c5ABYT4zUjtC34dv5DfXWlMy0JzcKyIIyZ/kwP5sQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(451199015)(2906002)(7416002)(5660300002)(110136005)(7406005)(30864003)(6636002)(36756003)(2616005)(316002)(38100700002)(83380400001)(6486002)(31696002)(26005)(86362001)(53546011)(6506007)(186003)(6512007)(478600001)(6666004)(31686004)(8936002)(66476007)(4326008)(66556008)(66946007)(8676002)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?emhoNU4yV3QyY1BDWnlIUEVGYXQ1OUhxTWZEZFVJMDdQRVR3d3N3Z3U0d2Z2?=
 =?utf-8?B?eGJ0WTA5aU0zSHpzeGVJMXhpL21lUFRyOEZ4VE9tRSswNkxsc05qQktxVG1C?=
 =?utf-8?B?TDJGMHJJSGdpZm5MTGVmbytoM1Y1RjdVREpORXVKQUU1UDJ3WGhiUHZrQyt2?=
 =?utf-8?B?TnhqenlUZWs3bzB3UVdkbHRhdUJPTno0VkpwK0xhVnNtdlZJV0pyVEx2c1Iy?=
 =?utf-8?B?N2hEenYweTZHY3NtRFFYbFFka0NMcVFFQm5NRTFEckFKbzl3djFkU09zbDBa?=
 =?utf-8?B?WXpRQlZ3SXk2Q01FSEYvRDRhNkE1YXRLV0gydElGOHJRU1JnK1ZhTE4zdGZq?=
 =?utf-8?B?b214bFd4WVJHOFBoZHgwUzhiM1VJMUlhL0oyMm1FbHlkWUhFcTRESTdJNVF6?=
 =?utf-8?B?WGFuS2tlN3VkZ1BmN3E3NkYyelBGaTZVR21uNVoxcXZkMkphYy93WVZNSk40?=
 =?utf-8?B?TS9UN1UzbG82YmxRRnpEZlhlOTFETDBId0VHb3hXR2JxelNTS3NMQTNnWEFx?=
 =?utf-8?B?YXlKTGZJYUMyTUpiRnluRDV3TU1jbktaNlU0OUpQb1A3Y0QzbENIRG93R3dG?=
 =?utf-8?B?Sm5JSWRKWGpSazVaajI5VVJ5ZU9kYWFBR2pyWUwrR0tYR0hJeGt3L3lOWUdI?=
 =?utf-8?B?TlF3OGJnRFdKZlR4S0luOEd0Szk4U3dwQmZZYmJpT0ttS1Z2QWJDa0JpZDZM?=
 =?utf-8?B?bTRNUzlqdWs2T3k3cnhFNlMxaFVwQWJsRjZvNmFvRm1TWVlDdTh6aDcxWTN2?=
 =?utf-8?B?ME9Gbzh4RmZOOUVtSW44Q0lRU2hiSStCSjhXQytEN0E3VWtqNGNTTUFSRDdV?=
 =?utf-8?B?NHM3c0VHMFZIZ3E5OG9YQU1nZks1WTR5b1FTSXBMOGEydUtsUVdkSDJTajhZ?=
 =?utf-8?B?SGEySDl0UUFTQytvYUowakR1aEhUbVlXWW9UZnhwUDBkSXFNWmwrekU1cjNL?=
 =?utf-8?B?V0tRa1B1MHpBQTRjSzdOQnFFM0tSOTB1L2p5WWdjN2FmbXFIWTY3MHByNHB0?=
 =?utf-8?B?aU91Ui9RT0tWeWVGNHRGeFdPMDYxcng3eEhkQ1MxcGtJdG9wekNTUjIxdEQ3?=
 =?utf-8?B?YWRxTU9Rb1VhanZxRU5oQXhkOFdBS25qY0dsMUIzZGQ1N0VqR3crUWNiUlpD?=
 =?utf-8?B?ZC91NitCT0IwelI2ZVFHVnVjZXJMQlNNcnpEUkVOTzlndlArUStveVR3ZkFl?=
 =?utf-8?B?ZUFKZG91UUQ5bHM0WG0xcGh6SzBPcm82Wm1jODJhQWVPSnBIc3B0NUdDa0Ji?=
 =?utf-8?B?OUthNG9ZclpnaVhXcEFtNUNoazFUa2N0OGRXR21IcS9zTGgyVVM1VnlhQTRJ?=
 =?utf-8?B?Rm9GSkZiMzR5ZnQ1Y2JsSFFWYm1IV3VqSitpQk8zMU1xUlFjRmxLQ1dnYTR6?=
 =?utf-8?B?YnFvUUV4c21SNytjbjFGcWFmWXZxK3JPRVhXdG9OMlNSYkJWbm5lL2VRakY5?=
 =?utf-8?B?cmRnUGgrQklnNVBiUk1mMGxUWHM0RDJ5YkZIcDdFRFF5c0JYaklnUzRhT2k4?=
 =?utf-8?B?Ti84WGdRa1BXOHlJM0wzeHhDVGVvc1VrclBMN1ZwNzlrL1FEditSY09oNkMr?=
 =?utf-8?B?MzN5SEZMek10SmdqR09kZTV6OEhLN0ltWmVqMGU1ZFM1ZVI0eGdFNEdWaFNN?=
 =?utf-8?B?MGxLMVBvc1NrUU9SYnkvVzhBN2pleDM2cDRrMGYzMG9kTXQ0TldiZFdlMlBN?=
 =?utf-8?B?aWM3TnNxcTkvdW1XTHU0L0ZaY1pJMC92aWZzTFlTSys1Z2tyQVE0SU5raFh1?=
 =?utf-8?B?QnQ2dUFycllwR0dYYzZLbUdZVkdDZk9DQVlaek4wSEdwMlNNYnZFZ3BwczNS?=
 =?utf-8?B?c3hnbHlnM3U2ZTBHZjc4ZDJ6THpMSWJITERwZENIVUxOelRwajFZbWtaNmIy?=
 =?utf-8?B?MjlrV3VMT2ViLzVSZndNSzdrLzBrTnU3OGl0YlM0dG1YTHRMYzdObEpKSFcx?=
 =?utf-8?B?MUJyWjQvS0lWVkNUa0F0Wko5UzZFTDBiYzN6YjdTeEJJcTNIOFU4d1hMM1NJ?=
 =?utf-8?B?WGd6aXBOZ2RjeWJETDlSWUlDOXlSbTV1bHkyMm5jWHlkdE5xcTB6VFlVc2Rp?=
 =?utf-8?B?WEJqeU94ZFY4QkN3dHhEeWdnbjUwYlEybXMyREtBaC9zaWMzZWxaZmtKOTZ6?=
 =?utf-8?Q?Zf9jcIeEFGO+UouqwaVu2Zdx5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03e8dfec-211f-4d72-6256-08daf5b65b0f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 22:34:39.0684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rdgwPJiRuKQ68JsKOQNvqVXrb6t6EsZ99fwWmkjeAwyjn1sBWcZpTrXXPw/zP2Cfr8jwOj74IzhWg3/cNqFJAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5019
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

On 1/12/2023 5:45 PM, Alper Gun wrote:
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
> I believe this should be cmd_buf instead of sev->cmd_buf.
> snp_aware_copy_to_firmware(cmd, cmd_buf)

Yes, you are right, this should be cmd_buf instead of sev->cmd_buf, will 
fix this accordingly.

Thanks,
Ashish

> 
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
