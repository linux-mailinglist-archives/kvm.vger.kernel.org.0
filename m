Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 127CB57E1CE
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 15:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbiGVNAW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 09:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiGVNAV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 09:00:21 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2057.outbound.protection.outlook.com [40.107.92.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7380E2B263
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 06:00:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KlVMwU7WSUCGmCmNbAUZTO12wrLJQWzSOOcNUS//mpgi9dhhec5lu1Z3BAQPUEza1A8nRNakgv00IMhEjc3FC/SI37wCVY2h6B/uFGi0wEznKqSXVYmgIBo8Sx86DAlwGCqX+8SgyVIO2wlZH3VclXYYO0jXLaw/2coa0Qrs9hFC870QZcRzc0doHyoz/XY9MyboLxidASE6l6okwymorXrLsX+JlciSrEkGobLY4Eoq5NVebtkwbTkcjssCjCrLOkch6/9JUuymCf6Iq/gTXSB7SrIsdM1gi1o5/sd5nKfsiCnrBUrQwHEf9CBno4GKM/c49huJpw+s6whVYrQffw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=szI8v3Wo7MAN0zjXUCJllfgHPBNdJwMRtQ1yJfQgLfI=;
 b=Wtab5mCshcQnXWMES2At5J64uG9Rw8fPXQBODUxQVjuE7yEvkCSjiyJuCQVYZGh+KgZsT3VCg9Mm1PRqcHcZhW+KBmRrsViyc01ocbcgGgMV/V4Za9EcJ78Fli+KZNPq8Vdc1kN22Cj/qXXISSsJIR7AUA0nVCLVY0lPyi2vSApigHKgJ9wFoRoBlnkCArvrf20ELfmXcqfHl3E7J03A++O5W71UqgU4UoNd1k+sCOOZ571CKrVQsR3kk3V0D/lmWdHbdLiic9KRcOYNJDRHnCC/I+ei0mtxKqvH64G4rPi5uLzOAwemcnKz0hkPjPwRpIQVUnR/qjUMEqj7s4RJtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=szI8v3Wo7MAN0zjXUCJllfgHPBNdJwMRtQ1yJfQgLfI=;
 b=eNya3VwQCGMdadNRsWECEcDGtw6hq7ZcQbaMui5xCKLXM6Hrg2qe3px0xYWL1yx5tjpTRV4giyEE5Nihe8/27b1WUzxFL9xXN7XLs5MxfR6pP9iSgm2OwiUnb2DcdbDQ6umiyTyQW5CcIicofeYv8tahRfl7hGJvtJE4SSpmp+A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6214.namprd12.prod.outlook.com (2603:10b6:8:96::13) by
 BN6PR12MB1923.namprd12.prod.outlook.com (2603:10b6:404:107::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Fri, 22 Jul
 2022 13:00:18 +0000
Received: from DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::8c4a:a8c9:c7d3:479]) by DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::8c4a:a8c9:c7d3:479%5]) with mapi id 15.20.5458.019; Fri, 22 Jul 2022
 13:00:18 +0000
Message-ID: <0f0b6fa6-0e74-9078-94d5-229ca34e9560@amd.com>
Date:   Fri, 22 Jul 2022 18:30:08 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [kvm-unit-tests PATCH v5 0/8] Move npt test cases and NPT code
 improvements
To:     Sean Christopherson <seanjc@google.com>,
        Manali Shukla <manali.shukla@amd.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
References: <20220628113853.392569-1-manali.shukla@amd.com>
 <Ytml0zc1cJh5tRG9@google.com>
Content-Language: en-US
From:   "Shukla, Manali" <mashukla@amd.com>
In-Reply-To: <Ytml0zc1cJh5tRG9@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0140.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:bf::12) To DS7PR12MB6214.namprd12.prod.outlook.com
 (2603:10b6:8:96::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c63d8a5-5787-4f73-1bd1-08da6be22072
X-MS-TrafficTypeDiagnostic: BN6PR12MB1923:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e5TTVaRenQOFdNac+PI0bAgrXXvT5TqBRHcFWxnNlGvMUTSrTQR5ebljsAIUPkYbOhru7vbh7lMxu7XLYqCOBQX0ttrmOte7oHoG2CFBmWCzjBo9mTesCaKZPEMGAoWYnFenPAlxX/69EKGie6JDKmX755bqYvlxAGOas5x9ibaJdbstHYTMynADbPjM3PpkeZWINJgICRuH6ksjDYRQMD2h+nr9N8HyrrPfZCqKSGQVP3bsWoAfl0GHj35xarCRxUjvKMrqRTgcxNBRztPehMFYrsXfL6Ju9RUCj0HknJ6Dtogv8Z88FpQIQQAxG6ogNT0TyuZS/9qlOTXnOffWqSzai+HSaNFjnkStwLkMBNtfB1+kBeOgAL6iaJvU+UXSxpHeRNIF8btTAKS6aez9RChuAiKwimFf0WErsvjkAWFOLsuzU4U5wj/sJZh6IUVbJqUAKy0iN2FpfNDBsyV7jMM0kxGzNU7VL4sPJIquQ4Sj8h08t6mFa8bvN/cd3vm66FMl/hwOQEyixTb5wleJxJ14dBqrBjmY0vpRIapwnvaQsEzXuNYSBmh1NKMaXr4lSKNhGlv+x1i2xLujMQFX6MUO9ZA7OpDhNBh9LfNs6IrEc2QA/hGoOrmcY8dld95OePLEVpqh9J746LS9rr13d2Z/J1G1w+FkqIM05qsUXj5BAX3NHzWk+BSgBywBmGDeH5l2mf+FRMcmAsiyV8w5MBTgirJUMMldXUCw48tKzJBFtHH9Z/j9rcVdTam09P+R9M2hm8iVtc2m/N0KAObovb7OIl1xmYtX4+qfLCzawm20ouqOHlI3TF/NFU6O8yLT9e26bcIdsWWvvZ2jiBBFCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6214.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(346002)(136003)(376002)(39860400002)(6666004)(2616005)(110136005)(5660300002)(8936002)(31686004)(36756003)(478600001)(31696002)(2906002)(8676002)(83380400001)(4326008)(186003)(316002)(6636002)(38100700002)(6486002)(26005)(6512007)(66476007)(66946007)(66556008)(41300700001)(6506007)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2NyclFSdy9pYWQ3ZjJLZWJvem5EbEZabmhlQ1hOVXVsRE5xUHpkRlNDMkRC?=
 =?utf-8?B?QjlSS29ONUNnSTYzZEJBQ1ZBQ3JtU21JaG5LeEtWOEhDVjRHSkNaZUNrU096?=
 =?utf-8?B?dlJTRW4yWG9XQnFzYnhKRzFuWEg4bjdRYUMzUDYyMVR4N0lMMSswcWhjMkNy?=
 =?utf-8?B?T1Q1S2RvSUVzYWVtQmx6K2QyTi9KZEhYQkxKV3psek1CUERWNnVKV3BKeFNo?=
 =?utf-8?B?amZFSjdramVzQ1BlOVdqZHJaT052WFo5ZzhpTW9rUEowM1hBRE13alY0QW9z?=
 =?utf-8?B?ZDNnMlk1cDVBcER2eEpQRnBDRnNPQmpwd1VsWUNUQUdaOWlmM3pEcWtDNEE2?=
 =?utf-8?B?Q3VXbjhURlVRejh1Q25kZFFhK3hFeFhFZ01ERkJNUXpUQ3hENDdhTkdPQlUy?=
 =?utf-8?B?ZnBwQVhsTUdKeUV5ajB3MElQV3J0b2lWV3BGUSt3eTJxWldrOXFtNjNONkZ0?=
 =?utf-8?B?bm1wWGNDcllZNENTNzI1d21hS2ZxdzBrN0RRSDVJU1B4QXlPUCtaWFpKRVRH?=
 =?utf-8?B?K3I3c3BtTFVNT3JmZFQ2TDFoUjJHWHovZWwwU3RLc1NKbThkY1hCdzZOcHNP?=
 =?utf-8?B?RmJrLzZsV3dGREJiSDdJZHkwS0NqbU5tdmVCS2NpbXFrdG1sVUJaSEZqRFNy?=
 =?utf-8?B?UDBwVUpMaFcwQkI3aU1kc0NrMk9XSmMxTUhoUytmbEhQcmd1VVNZMTlFdklP?=
 =?utf-8?B?SXRjdS8wbEFHODQzeGllSjAzWmlwMlR1WlFBcUVZb1YzRUJlL0RkZmlhbWxj?=
 =?utf-8?B?WVVyU3JwNm43bU9MMzQ3TktUVUZSYllkaHlDbVM4Zng5bi9OZUUyRHdnak1Q?=
 =?utf-8?B?UGdLWVpDK0hFeFdreVdyWjJPS1FmWHJkLzJQSTZEb3hKWUo0NXRNZk95aFBL?=
 =?utf-8?B?Sy9sdTJxQ2dzNzhVaTZRTllGYXQ0dWY2bTlSdHJ6cjdBUk9ZeEVqbHVOVnAx?=
 =?utf-8?B?Q1B4ZnNzT3lUUHczUi9EWXJObG53bDdEcFp3a3d3ajAzSms2ejNBK28rK1I5?=
 =?utf-8?B?MWF0anRXeXY3UEhBVTZNQWZ5Y1MyQkhxU0lIMjJhVWtPbS96N3hLVWJrNzNC?=
 =?utf-8?B?NVErWjBuZ0xNbDMvMjVwZFVSL0h0Qkd6Qkd1bDc4TFBjb3hVZ1QxSStVNHV3?=
 =?utf-8?B?Z0E5bnk1RkVwdDNPMlMvRytaMWN0VzVkREVUbUhLVy8vSXJhYUQ2Snl4WTJI?=
 =?utf-8?B?ODM2TFlibGQxWmV0Z1IyUUtDVkFITk1XUUhGUjNuM2MvblphalVqV0kycDUy?=
 =?utf-8?B?LzZvNWtlL05iZzJpUFlSWGJzT1JDTDhDb29lQ2h4SlBrVDExTjQweEJMRWZD?=
 =?utf-8?B?VlpDZWZlSloyNFpSNnZCTVh4ZXMwLzUvNlFWckhSbTYydUlPTkNhaStWM2pT?=
 =?utf-8?B?SlFXV0QvS1pOWUNZYzl3cENaa2VERURVK2E0WWlSSnRhSnhYRE54R2NNZ2pG?=
 =?utf-8?B?Vjc3TDc0d2haR0VKc3E3K1d6Vk9TVzJoU1pqTEdPcU9mRFFiNFhncCtQalpU?=
 =?utf-8?B?RytOY052L0l4YVFZakRFWDRwVUpxWUVzU3YxaTJMQW9ZdjJCUlUwdzlEM2FR?=
 =?utf-8?B?ZE1DeWh2UUd0WGtYdG01NlhkNU5wb2tjUUpudnZEKzFPMFE0WW9XaVRlQklr?=
 =?utf-8?B?b0hVTE5ZNy80ZEV3OFBHUXVKY1RLRnhYaFVxNVhHZWVaVnVwZjhjNVdJNmtj?=
 =?utf-8?B?NjF5MWdGK1hsN01RTE5na2dRR2pmUjJGSkJ0K1Y1ZE5SNVBHaW5lZnJkTU8z?=
 =?utf-8?B?UDcwMHVlNTlueGFTWmowZjVIcmFKekl3cThuWlNwSEdYR242b1lrNVZvTUR3?=
 =?utf-8?B?RFMwVWhWVXpFNU5KejArQVVsMDVnbzhFeGJSSkdUeG1DNFVkeEJtOXhKL0F3?=
 =?utf-8?B?ZDFWT092YkNPc2lNQjVrcUdVVWhLblNEenAwZ3dWZ2lMdHl1dStpYzFrRmc3?=
 =?utf-8?B?VkRCNC9ZM1lkOFh5a0xqZFhwUU5sTWYrdHJuQzNXcjZXbFpkcCtuVUpEZDFN?=
 =?utf-8?B?R0d1Nktxd3lqR2h4ZGNyVGhsWDQyK1lZZEdaYzRYQ2V1UUdFSiszYjZwVHc4?=
 =?utf-8?B?a0loVHhzQmtTdlZBSXFGZ2srNys5QVR4U0pXampkNVEwZUgxTjZxWWVzUjRW?=
 =?utf-8?Q?w56YFBt5lFPiElQVW61nAI8UF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c63d8a5-5787-4f73-1bd1-08da6be22072
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6214.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 13:00:18.1069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +sixX5yipqk9yG8ouv3aC8Wq3jPATuxtN+tw3JmJfvTOOG9T/yPg4dP24HIC/IkS5Yjr2rntdotdbKtrxVBKIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1923
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/22/2022 12:45 AM, Sean Christopherson wrote:
> On Tue, Jun 28, 2022, Manali Shukla wrote:
>> If __setup_vm() is changed to setup_vm(), KUT will build tests with PT_USER_MASK
>> set on all PTEs. It is a better idea to move nNPT tests to their own file so
>> that tests don't need to fiddle with page tables midway.
>>
>> The quick approach to do this would be to turn the current main into a small
>> helper, without calling __setup_vm() from helper.
>>
>> setup_mmu_range() function in vm.c was modified to allocate new user pages to
>> implement nested page table.
>>
>> Current implementation of nested page table does the page table build up
>> statically with 2048 PTEs and one pml4 entry. With newly implemented routine,
>> nested page table can be implemented dynamically based on the RAM size of VM
>> which enables us to have separate memory ranges to test various npt test cases.
>>
>> Based on this implementation, minimal changes were required to be done in
>> below mentioned existing APIs:
>> npt_get_pde(), npt_get_pte(), npt_get_pdpe().
> 
> I have a variety of nits and minor complaints, but no need to send another version,
> I'll fix things up as I go.  I'm going to send Paolo a pull request for KUT, there's
> a big pile of outstanding changes that have been languishing.

Sure Sean,
Thank you for the review.

-Manali
