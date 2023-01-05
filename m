Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39ED865F6F2
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 23:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236243AbjAEWkn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 17:40:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235478AbjAEWkk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 17:40:40 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2051.outbound.protection.outlook.com [40.107.243.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F7D11A1A;
        Thu,  5 Jan 2023 14:40:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V9/QULbbhuEyhnWrJ+pXaAp48T5nAGbtQMIieoMtiKL3mng9Jf9mPlbMB4hFfgBFz+/L3amywdvAw+71kUP9T3v3+MeiLlq1SsW3kxIHYyzig1kGV5XXKnJvYOrHnnt5fCKAA8qg3UzZ4VZGRKQM+xIEAAiKgvlO78rBAPo+6RHF08MAKeJvdeFddNYm2aE+lsf0g7kAK1Fpymc4BB8DNY/SyXFLtOXJAWxSGAyH/XL6B0wIjOr2f0zcNW8KpQqRW0Ad+ZrYiRgHjYd+0AUHi7r9u99djA+0z5R1bPSPVcT6ukHI6koBSCfe4d3SnuTZh/Z1ZynMMThT0mG/DilyEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wOoqv+uTlDPadvW8F7H2l7LVRPR5iaD4d0t56fvaUzg=;
 b=T6iyS+c5bk5V3cTl+LGpmjGOvswMQxovs6KHSwD1FUVpzJc+3g5LGhPmUOsFuw5QDMt3ndXhx9nUovfrH8gUtqTudH1kTz12uqJNbsJrxdjkagvFWPnnMQQwDBVOKRpraBDKwrp3niS0iWfed8qJPaWC6Ie41Bcv2Y3aDklkqq36/7SFDsMpm4euOmaaxJYpf+MpJIdNz4CKBIwf0xTepxaGCcrWbpu88z13FtQLrh5wfHoQX2+G1ozRXobSNOxc76E3N4c5G6WDIZI5Xb4Wo43c7r9Kf2sEqwssjHKYZaEbJ0+UZawj+EVNcR5Jcd0VOwgc8q264aLDKYDrwbdCvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wOoqv+uTlDPadvW8F7H2l7LVRPR5iaD4d0t56fvaUzg=;
 b=lALJ/7xQE56Mhwry6IR9q61JaCmsFWJwh+FlQOrnWGl4qWHPIkO/T7V4FG4Bz9PRckQBO0wz+C47USsuggjRCZf2TD/QdFgHYZ4I8D9O/Co9YA9I2IXYd0BD2SfC96HsX5GRaexdHDPGPLfeFqi6gfXKBJzKTdUrm3iiEX3YLsI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA1PR12MB5639.namprd12.prod.outlook.com (2603:10b6:806:22a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 22:40:35 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9%3]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 22:40:35 +0000
Message-ID: <5bb741b8-8daa-028d-d920-826e1396dd87@amd.com>
Date:   Thu, 5 Jan 2023 16:40:29 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH RFC v7 25/64] crypto: ccp: Add support to initialize the
 AMD-SP for SEV-SNP
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>,
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
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, harald@profian.com,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-26-michael.roth@amd.com> <Y7BWGvGj/Ky8RctP@kernel.org>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Y7BWGvGj/Ky8RctP@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0042.namprd03.prod.outlook.com
 (2603:10b6:610:b3::17) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|SA1PR12MB5639:EE_
X-MS-Office365-Filtering-Correlation-Id: 5329fd1e-7dc2-474f-6999-08daef6ddc49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gw+nLOnygXrWuXkV0a16AVv9CS6IvaHkuLrhP6qAUeB5K124EQxDs/Ysa6rR7P2ud1fyg6P1B7+ytPVoKIAVS+zM80bKUWKClzItQU33LgqLe4UHoCW+j8CpcEOFo//EgxD0wSGeDzHgd9Zw/CKohrJOrUvkzKoSpZ8P3L2plcxJI+svzwtwEhmuiGXHGrDJ7vtvgRdtvZFC/byr+F8M/yXkJLT4caFi2KlFp51IHpljeO3SP7JVCE5Zkfhu5uObeFkWfz0t1sT7unpGFlxzZdFxzrdZnMXFMRufWWYtVMFp8OgqpNd3mGQpHJoFEnIbSZ9jpJhnFtZbu7F7lZ7JMC3i3vbIlfvXvHr1yyj9wwfI9ykami3xV56GOSow1YuNEDIur4FYf0/lYJXTLCqpQYu8Je7v2zGftjQQHE1W/vcKQlJpt1OJukW5hGVqtcAom6/YTgMVSiAeoZMCHcxPNv3HnxroWSI3BUkOMWxJsWHS+sxVdPQWevRDATd1slqCcfHpHgvHik2fbVXTkjic+rwQSNA7RoOfs9I6idYhDR70GjpgzrwAE4W1mnxj02d1Y3teKFi6C91dsfLer1SRWSPAHdVd+57/osat6TVHOkGl8IbHQor+InPMFQLZvF/SjDO6+pwFf2SQbc5KHLxXDtqLzFnRB38PVjyeCVchH4xyqgjnZY6kF8/VfFhH6sM6JKoYKU6v/CWzpRND1r+fbnJg3jWy8lTihybucVihJTI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(366004)(376002)(346002)(451199015)(38100700002)(36756003)(2906002)(7406005)(5660300002)(8936002)(7416002)(41300700001)(83380400001)(31696002)(6486002)(110136005)(31686004)(6636002)(66556008)(66946007)(86362001)(53546011)(66476007)(4326008)(6506007)(26005)(478600001)(6666004)(186003)(2616005)(316002)(6512007)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?alZ1OG1DeDRxdEhrZjVoY21SdkhocHRCK0cySG5aK1pPNmhnVDVsZU55UmEw?=
 =?utf-8?B?dDRzenowMWs4ODF5RXVMbS8zMGkwZi9ZeURyTXJ3Q2g3YjA3SVluSGxpcmp0?=
 =?utf-8?B?UmczWTUwcnZUc1NqK2k4VGRMQ05zYytSSWxVMWVndWoyRDd4OVl0eENkdU5z?=
 =?utf-8?B?UnA4N0V6eEpNb2NUZGhpUHU4cmtnM1VYaUpIb2xXcWlEeE5hRnVnWXQ0bGxI?=
 =?utf-8?B?UTc2djBsSmJBSUg0V0cxc3VZMGxMcGZ0OUFsS2ZrMnRoL0lPaHBnei9HTXpR?=
 =?utf-8?B?MTBUZktBbEpYNWtQL3BMOGpvclA0akdSWjN6eTJzb09vMHJ1ZmVITDNXYUFQ?=
 =?utf-8?B?bjZFZk5KSjlQMzNHVHZ2OVcxNVBOaDhscjdEaEpDOFZEc08zNmhEcWJ5eVNH?=
 =?utf-8?B?eWlpZUxUK3JSK3RiTktZZUNhdGpJOWlwN3hHbjNoN0xnMzFLaE9BOXBFc25k?=
 =?utf-8?B?VmNvMjZXL2s3MDdKVkdKUXExL25ZMG5EWUxxSTU5Ni84eXpFZUIxL2FKV05v?=
 =?utf-8?B?TzQ1NkdRQjl1RGhzbEZRZXlRVldMWlpBVWpxQXZWRm85RzAzUytGY1lSeGRI?=
 =?utf-8?B?Yktkb3ZNeWxkVzNtOEVCY0E3djQ1aE40MktOZzhVTndzemtOQ3B1aVd1M0xw?=
 =?utf-8?B?bWFOQUVjOWtaTzI2OHI1aURyS1RJeTJHT3diZVg3eFpGa3VtaUFweXhOVXZX?=
 =?utf-8?B?VDhxY1MvN0dPTnBoTFJBQWVld0VUTElGbkNFZzZLMUVSa1ZDeGxjb2JvQTVz?=
 =?utf-8?B?QWtVZXZJcHZ2Si9EaVA4TUs5UzRVRWlxVDRUSm1aaUxDRUZRTUczQnBHZWRo?=
 =?utf-8?B?NExaMlBkQWtlZmF1em5Td2RBTUJRQ2VNR1JYM3dTZ1dtdGpVOG9lU3RQcG8z?=
 =?utf-8?B?SVBtZHJxQUxyNng3a0NOUzhpMUs1VHMzS1EwdTRvNmJsRGlPZXBabll5T2RT?=
 =?utf-8?B?cTNUUXhlVk1JSzNxaWkyckZaL205WlVIVmIrWlp2ZnF6RzdKTVlYM2pZR1FY?=
 =?utf-8?B?dUJEUUdjSVlvaWg3eDllNjZCbjRya0Y0cWZibFFUek9ZTTU0VnVJY0J3OW1x?=
 =?utf-8?B?bUdCUlpreU5pbFdmSXU2RWpCU0l4OHJiUFBmZHhPYlRxa2hLZDJ3RHJsZ2RP?=
 =?utf-8?B?VmY3bTN1cUEvTEtON0hxK2FJQWV3WFZ0WHJ0WnJ5MTV0NHBWVXQraUYwWHUz?=
 =?utf-8?B?QnYwMnFkdW00YUxINEZ3UnVGV3JhRFc3RjU0bDhhRW1jSFhuUjN3ZjBENm5S?=
 =?utf-8?B?bzZzVGJTK0xpQ2dadkRvUXRRZnc0aHBHVGRHOWpDYmpQci8yb3g0VFNLU1dW?=
 =?utf-8?B?dmorNUNRWmo0amZpNVZYWlZ4M3YwcnpRbmNNamYxV0RPQnlKVnRDTlhqWlBz?=
 =?utf-8?B?b0lkOG1oT3ZIV3NjeVRjd25pUUhXM21UM3BCQ0JJOEZQZ1FXQTdqM2RBWkpM?=
 =?utf-8?B?eW5vSllxVkZzNzladlNSK3hCVHFib2tvMTRzckdsejNpZFYyUHpvME9GVWhH?=
 =?utf-8?B?Wk1rb1FUd3pEMCtIUDhSZFg4bFhRVDFzM01CbE9rbXBWaTRDNDhiVFJwWVA3?=
 =?utf-8?B?UHVzOVdRNFVVSmRuMlBQbTZ5aDJTSi9lYytJMHg4RDFVcVJybHozTmpZRmFa?=
 =?utf-8?B?SDEza0JQUDZjeVVjVWFVdnNOaE9UMHJWbld3bFRDa0JiOWVRUlMxRnhjVFZJ?=
 =?utf-8?B?N0g3L3B4bVBaMlBpa3czYVJzZTdEdGlXOVFhcXJFbGIraDQ1WkJrMStPSEhR?=
 =?utf-8?B?Z011OWVOcjFEN25idjNXNWpCUGxhRWp1aFMrSUpwQVVEV3NrSDZFMzRMTXFl?=
 =?utf-8?B?Q2hkTXdtK0VEckVsaVhIYVo1eE43dzZOWGZQSHE5djFnd1lGU0U2TUhzcmVs?=
 =?utf-8?B?d09xVzJoV3FFK1hWaU9YVUNOOWlVYVc1YmpzTHEzTGNaUmVJSy94b0ozVkRp?=
 =?utf-8?B?YllPaGNNTzh0MjlNT3hVOS8vOHdWdFQ0OXg5UUY5Q2kxek9jRnNiQ2s1eG96?=
 =?utf-8?B?OFBWL1lXYVFSN004NlhTSitUOXlldDgySG1OQjlCaEZ5d0VwVUR0aVNEb2Uv?=
 =?utf-8?B?QytSY25RWHJ2SDFuQjVMODJ2NHVVb0pVelZWeG82dFQ5a0NUUzZSUmxJWU8x?=
 =?utf-8?Q?46z31crGLExs7I0a5ZlSyWw4K?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5329fd1e-7dc2-474f-6999-08daef6ddc49
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 22:40:35.4493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xw4xiDfkYPyZApElfG72wSvsgA3QDk8GSB4Qu5LBQswAVJ/U63uMBQ6v3HQAUr6fZ+fM29LD12xK46XKSgPDIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5639
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Jarkko,

On 12/31/2022 9:32 AM, Jarkko Sakkinen wrote:
> On Wed, Dec 14, 2022 at 01:40:17PM -0600, Michael Roth wrote:
>> From: Brijesh Singh <brijesh.singh@amd.com>
>>
>> Before SNP VMs can be launched, the platform must be appropriately
>> configured and initialized. Platform initialization is accomplished via
>> the SNP_INIT command. Make sure to do a WBINVD and issue DF_FLUSH
>> command to prepare for the first SNP guest launch after INIT.
>>
>> During the execution of SNP_INIT command, the firmware configures
>> and enables SNP security policy enforcement in many system components.
>> Some system components write to regions of memory reserved by early
>> x86 firmware (e.g. UEFI). Other system components write to regions
>> provided by the operation system, hypervisor, or x86 firmware.
>> Such system components can only write to HV-fixed pages or Default
>> pages. They will error when attempting to write to other page states
>> after SNP_INIT enables their SNP enforcement.
>>
>> Starting in SNP firmware v1.52, the SNP_INIT_EX command takes a list of
>> system physical address ranges to convert into the HV-fixed page states
>> during the RMP initialization. If INIT_RMP is 1, hypervisors should
>> provide all system physical address ranges that the hypervisor will
>> never assign to a guest until the next RMP re-initialization.
>> For instance, the memory that UEFI reserves should be included in the
>> range list. This allows system components that occasionally write to
>> memory (e.g. logging to UEFI reserved regions) to not fail due to
>> RMP initialization and SNP enablement.
>>
>> Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>> ---
>>   drivers/crypto/ccp/sev-dev.c | 225 +++++++++++++++++++++++++++++++++++
>>   drivers/crypto/ccp/sev-dev.h |   2 +
>>   include/linux/psp-sev.h      |  17 +++
>>   3 files changed, 244 insertions(+)
>>
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index 9d84720a41d7..af20420bd6c2 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -26,6 +26,7 @@
>>   #include <linux/fs_struct.h>
>>   
>>   #include <asm/smp.h>
>> +#include <asm/e820/types.h>
>>   
>>   #include "psp-dev.h"
>>   #include "sev-dev.h"
>> @@ -34,6 +35,10 @@
>>   #define SEV_FW_FILE		"amd/sev.fw"
>>   #define SEV_FW_NAME_SIZE	64
>>   
>> +/* Minimum firmware version required for the SEV-SNP support */
>> +#define SNP_MIN_API_MAJOR	1
>> +#define SNP_MIN_API_MINOR	51
>> +
>>   static DEFINE_MUTEX(sev_cmd_mutex);
>>   static struct sev_misc_dev *misc_dev;
>>   
>> @@ -76,6 +81,13 @@ static void *sev_es_tmr;
>>   #define NV_LENGTH (32 * 1024)
>>   static void *sev_init_ex_buffer;
>>   
>> +/*
>> + * SEV_DATA_RANGE_LIST:
>> + *   Array containing range of pages that firmware transitions to HV-fixed
>> + *   page state.
>> + */
>> +struct sev_data_range_list *snp_range_list;
>> +
>>   static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
>>   {
>>   	struct sev_device *sev = psp_master->sev_data;
>> @@ -830,6 +842,186 @@ static int sev_update_firmware(struct device *dev)
>>   	return ret;
>>   }
>>   
>> +static void snp_set_hsave_pa(void *arg)
>> +{
>> +	wrmsrl(MSR_VM_HSAVE_PA, 0);
>> +}
>> +
>> +static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>> +{
>> +	struct sev_data_range_list *range_list = arg;
>> +	struct sev_data_range *range = &range_list->ranges[range_list->num_elements];
>> +	size_t size;
>> +
>> +	if ((range_list->num_elements * sizeof(struct sev_data_range) +
>> +	     sizeof(struct sev_data_range_list)) > PAGE_SIZE)
>> +		return -E2BIG;
>> +
>> +	switch (rs->desc) {
>> +	case E820_TYPE_RESERVED:
>> +	case E820_TYPE_PMEM:
>> +	case E820_TYPE_ACPI:
>> +		range->base = rs->start & PAGE_MASK;
>> +		size = (rs->end + 1) - rs->start;
>> +		range->page_count = size >> PAGE_SHIFT;
>> +		range_list->num_elements++;
>> +		break;
>> +	default:
>> +		break;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int __sev_snp_init_locked(int *error)
>> +{
>> +	struct psp_device *psp = psp_master;
>> +	struct sev_data_snp_init_ex data;
>> +	struct sev_device *sev;
>> +	int rc = 0;
>> +
>> +	if (!psp || !psp->sev_data)
>> +		return -ENODEV;
>> +
>> +	sev = psp->sev_data;
>> +
>> +	if (sev->snp_initialized)
>> +		return 0;
> 
> Shouldn't this follow this check:
> 
>          if (sev->state == SEV_STATE_INIT) {
>                  /* debug printk about possible incorrect call order */
>                  return -ENODEV;
>          }
> 
> It is game over for SNP, if SEV_CMD_INIT{_EX} got first, which means that
> this should not proceed.


But, how will SEV_CMD_INIT_EX happen before as sev_pci_init() which is 
invoked during CCP module load/initialization, will first try to do 
sev_snp_init() if SNP is supported, before it invokes 
sev_platform_init() to do SEV firmware initialization ?

Thanks,
Ashish
