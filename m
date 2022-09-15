Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3165BA2F6
	for <lists+kvm@lfdr.de>; Fri, 16 Sep 2022 00:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiIOWrh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Sep 2022 18:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiIOWrf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Sep 2022 18:47:35 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A07D82D10;
        Thu, 15 Sep 2022 15:47:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LVmXdoiVNz0B/3axowlyrPfdunUsv123zFNSQiYHeweuxmHzvKUTbeHw9e5vdu/9qiC417HZtRy4/43AtO/GKwcesYTXgH5Uyf0JHeZiHa7CZzSF+7jyZuWZg96T249IZTdRc8GUSabsDPzPIlHKA3Ok0pzdzdjrZpYWOzZ6bPL2IASLdPl5uDWc/BOOi4gjFeiKGOzaiHulec9MVykAyFv/Vs2E183eR0EwmlaMJUzlSSy69L5XD+MrHB+n4TxwckQeiF0pFd6hcTxdAVyFhtenwlwsrXwTyyfWErgO0pSx45uFQSuSwx7CbzImA94nkd66fZGgCCeOKwVUyYF1UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3u9I/gsU6cWU0F6LGg70tTsUnPkNf8wBWEq5Vf0BQLs=;
 b=DjoYE4idwOuth16N6BQ0VXzN9OGfsFcTT429uytXGSfZhs6AQtiXqSD3AI8fMdMTnj/jNXdJ9CaBBzNm2U4NsuEN3lAHPMCQayL30J+i775uUCkXczkXI2JxgNiMzVfYPT95nJKQY2lAcgZD8LPAaMMNr1izmQdYUe+leajSzJZ0kR17mLafDswacrFbVfEYuanVQctFE1zR+CO6gzLj6dKSSRn8Iqw97FWCZQmLsDOOzKXqW+izsZZQ4zjRjDXq36fZpMc3tasrOLZd/gMlXFkw9NAGw/5nSOjNzesq06qUTf1EOkqcZ7aAPni4R32F7PzR/VHIJFYhs9kFUIfbyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3u9I/gsU6cWU0F6LGg70tTsUnPkNf8wBWEq5Vf0BQLs=;
 b=X5VGvDzq8+NRqtff9LYaHtNXqhortcZusRCUgUpRZP+rb3tyLYEvYArJbWeLo6jlkh9pXbg3Qs0/MMo7iFFn3X9VyCFRUltV9H4rkcjivxPkkdepfBt3U6IrwaNjRSfstTrinzKZ3pLd+P0au2S2/dw1kjJD9Kwie00i+Ktv2vE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DM6PR12MB4531.namprd12.prod.outlook.com (2603:10b6:5:2a4::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.15; Thu, 15 Sep 2022 22:47:29 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::2cdd:defc:a6d3:7599]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::2cdd:defc:a6d3:7599%3]) with mapi id 15.20.5612.022; Thu, 15 Sep 2022
 22:47:29 +0000
Message-ID: <7c43a6f2-ec11-5af2-6574-68a32eb7fd41@amd.com>
Date:   Thu, 15 Sep 2022 17:47:26 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] KVM: SVM: Fix x2apic logical cluster mode decoding and
 sanity check
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, jon.grimm@amd.com,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20220912214632.14880-1-suravee.suthikulpanit@amd.com>
 <YyAVOBXZ+O3hnU9y@google.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <YyAVOBXZ+O3hnU9y@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR05CA0057.namprd05.prod.outlook.com
 (2603:10b6:208:236::26) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5445:EE_|DM6PR12MB4531:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b5f8b9a-54ae-4b7b-46ac-08da976c44e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z43arpnwPaXk0GcuJi1Q638G7uXQhuneLcO+Pey2ZK5X8K2DylZu84Rfv6yRmst8EUvmzA0BGr6Kq5+TYGLCl9zl5WY3k7lXQMJZprcUB3ztr289/b6xJaoci6fTTD08ejq+Ht58lbwxGmFBebKUPxhtioxbsJ/XauF/AYrtn2EZYWO0Vi2pbKHQA9ZA20SNEIQetVSxvYQXlaPAnj3gTcKl1f/CwUs5z4Ij21PcK5vkROuZhGoxc9oeoAtjUiT5Qz4ez+LS0MBi0tWvdRwj/sxCV0/tOF3eMID8rP34DgK6FZXvZbNFpY3bRKZQU6keqyUND8UdVDELgmslyaZOn6Z2FEbN91UM4OBrUVanRSIrZYTALAp9W6SDxR1nsISrw04uQJCikRkaw0vdAF3guO8HyHoE3UFV1oTMdfcnQCPs3hKfLRgjmHVX8A2PZ9XZdab9960zRBqFCbl3tKK1gVRLT5n3Py8bF2sgWAYCIATVvfIbQB8i1V/F/LDuq/xNInbr+QqYwLGrxGyrF1T+eIb+ATCycAoveFpE6pl8GRRv7PdBAb5uKy1yBLs3cSAP56tyTcZJ9xUBUxQUPW7tJJW4bhH51P9AIG/nH5kjY0ycmGxYti+p279AdZbgDcL7EfsQz3nnikDPEEmANyonR4eCU4QSEyrQZbp3CYL+vFrPLFgLojjolvk6qQNy+5TCDWVYIq54IBHNrfjvGlwyCni9GelzmfPtQZYe0lVOa2BI7e0dsCuLCwGLKOwGSzE+hTgvxzTaTAZj0oWH2TdunGnAQ2S46V1kmjzZvDP5lQjIBwPrDtgcoG5vDaumOlbL3J8YcD8fcmA9GyNP9iB1UiAvrB0HtE+6tZ/57krFzbY/n9059ASco6x0CrucJ47W
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(39860400002)(366004)(376002)(136003)(451199015)(31696002)(8676002)(66556008)(6666004)(66946007)(2906002)(4326008)(6506007)(5660300002)(6512007)(2616005)(86362001)(66476007)(8936002)(53546011)(26005)(38100700002)(36756003)(186003)(41300700001)(83380400001)(966005)(6916009)(478600001)(31686004)(6486002)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NDJVaktJWFphWHNsYlR0MkVYczFCcDRLc1dpcjBOY3VZSG85OENHdHVuYjd0?=
 =?utf-8?B?MjhOdVZ1Wmg0RVdyMEJZb3Y4dnBDd2UvODRNM25TTTUrMUltTEdxNnZ4K1I3?=
 =?utf-8?B?WFN3bkdOVlVnWVVFMy9UYllBZHl3dnd6WnBld2FKdDJkOUh0cW44cHk2UUw1?=
 =?utf-8?B?Mmowb3R1cDVCaWF0SDdoYlFvSFJXbmFrc2hDUHhldlBzUjBnRExhelo4bVdI?=
 =?utf-8?B?c05LL1I1eVVGYXE0cU9CbmFES3ppUDdWanpNcmFqSHY3bHNTUStNa2Ztay9W?=
 =?utf-8?B?VU1DQVpaYkM5NUVPOHpwcUZUNFM0OGdjejN3cjliY0xJbGdCeFk0L0pyZmJj?=
 =?utf-8?B?K2xIK3B4OTdmSGZvM1FNTTNrRStNWWNhMkZMS1ZxRDU0eU0zOEp5RENuSjh0?=
 =?utf-8?B?YnNPTnNSRTBUUytsaitMMEZTeFJUU3RoQ2N2RWk0bWVLWDlGbWpmdkFydWZ3?=
 =?utf-8?B?cWx5cjRBQTlCakMrbUNrRlRjUS93eXdsRHMyZVYrM0JHOTU2U3hqL2NyVmRj?=
 =?utf-8?B?Rlc2cGZ4RDM4V0xxdGZWV3NiaXFLdUJLcFVNb2pOcU9kNVdSSHFCczdrOWFL?=
 =?utf-8?B?amROeU13MVp0dUs2SmkwZUxSV0pMVit0aWd6NkRVVXkwQyttNFp0M2tIWHpm?=
 =?utf-8?B?RFFSWXp4TXFnNGxQQnFwRGZ0ZzM0c25YUldCaTViU3A1TEVIUE9wdjBnQW01?=
 =?utf-8?B?M0crUG94cGhPWHZTaFdTbkFkTytsd0NieS9zVnlzN0g5ZzJSUlVKWFZNWVZ0?=
 =?utf-8?B?SjBSaFlXVzJGNjhoekVYaUFoQ29OdGVkMmRPU0F1Mi9KMnVvNlFKdk4rVTJS?=
 =?utf-8?B?aElPVTU5ZGwxM0o2eGRDQnd5aFBiR3JYSnR5Rk5SaXNsT0RyMEY2ai8yYlRh?=
 =?utf-8?B?OExBaGJzL2F0a1lndE9sbDJpbzRoYW1EQ1JDY2YvdzIyWTdEcGFHWU9oVEFQ?=
 =?utf-8?B?WWF5cTI1TXdiSUpqNk5XUWZkTXZ0c0xPQXNIamlKMHorbDdTQkNmRGJKOTdu?=
 =?utf-8?B?T3REVUtzVmFXaWZlVC8xeEUvMlA1MllRNmxQcU9lMkpWeW9LQU1EUDZ1REZz?=
 =?utf-8?B?d3poTFp5V0tqTm0vMm94OVR0cVoySFA2RHRVMTZzY3MxYnRQM0NDMUw0dHEw?=
 =?utf-8?B?NjN3bU9iYnZjaWwwMitURTlpS0ExeG5hTHhSVmRCbnBzcDhrR1JlbTIvRCtS?=
 =?utf-8?B?VC9ybUhjdmpyNm5hd1lkbnJoeTFab1FLYkpJZGVwU3VBbkNJWEVpbmdMUmVL?=
 =?utf-8?B?c3hsbFZ4N0JOZ3NNYm5KNksyZ04wN1lBRFpUVE55TGpLd1dPazBWZmZlcEFX?=
 =?utf-8?B?RTB4VWxDVHJqSGN6YWJUYU1VeUJyV3hyN1EzdXFxOVY3S0NLNlQ3Rmg5S1k0?=
 =?utf-8?B?Z3VqZ2VqMFArbC9RbFdtTWZ6VlNlWDRESGNQdUlwdUxCU3RESGJxcjQ0dVFs?=
 =?utf-8?B?MFBLVnRXeUVuZ1MxSGF0azNKRGx3Zzh1Y3BsYUdqeTBkSnF5eHlkakdrRjhJ?=
 =?utf-8?B?MFhLZngyRFZSalcvQUhpcitPQjdvNEtYWjJMbW1mL3I4bUc3S0hvT0NkSjY1?=
 =?utf-8?B?OGhtakhRVk9NNlo3Q0dYUXlhTlRsODlxenJQRGMrVjFqdlhhelRzbStUaWpt?=
 =?utf-8?B?TllBYUFyZ1M2VU5keEFja3JZMFVjaVg5ZnJZMlR6UXJad0tERmZpWlI3VEZ2?=
 =?utf-8?B?bmFmdzFoVFlrVjJlc1dBcUN2KzZ2c1FtWjlyTmFwekJqeitEODF2MVNVOWJF?=
 =?utf-8?B?aXpIRHp6S2hWUDJlM0pTMDlwZWhQQXJhaVVFTDdqWFFjRDVjRmJzS1E2aTVv?=
 =?utf-8?B?YS9vZDVGSEhPNjgzOVJldExUY25hVTFVVitmRXUyOXZSV3pFaXFXa2NjbnhU?=
 =?utf-8?B?NkRjOC9DNHhWZlE5ajNDMVlpV3JhL0ljQzFDMHViTTVBOENiOG9aSGJ6SVlM?=
 =?utf-8?B?bHhVWWJSMWdWb2lheFRib0drYVJsK2pMNWdhMHllN202b0N5MUhodTdNQ3l3?=
 =?utf-8?B?QVRPbW9jN2NCYUJpcERzNkNrWFA2Um9BdXZjbFRuajZmKzFYRDQwd2tmQnNJ?=
 =?utf-8?B?eE1oQytPUkxtWXBrODg3TEtsdkRtLzZrZDZjNThsck1CbEI1dFN6NTVLUHZW?=
 =?utf-8?Q?R6U85E4OxWXkATOwbOTcIrD5V?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b5f8b9a-54ae-4b7b-46ac-08da976c44e9
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 22:47:29.8821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cg/qtNIW75poibgbdBQfNWh3Y9t/6Dr74SDUJI4DEJzTyRM1TQcX4UiVQyAQmVdZCH9afEYsq3zzOMqD4DobCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4531
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/13/2022 12:29 AM, Sean Christopherson wrote:
> On Mon, Sep 12, 2022, Suravee Suthikulpanit wrote:
>> When sending IPI in the X2APIC logical cluster mode, the destination
>> APIC ID is encoded as:
>>
>>    * Cluster ID = ICRH[31:16]
>>    * Logical ID = ICRH[15:0]
>>
>> Current logic incorrectly decode the ICRH, which causes VM running
>> with x2AVIC support to fail to boot. Therefore, fix the decoding logic.
> 
> There are already patches pending[1][2] for the x2AVIC bugs.
> 
> [1] https://lore.kernel.org/all/20220903002254.2411750-9-seanjc@xxxxxxxxxx
> [2] https://lore.kernel.org/all/20220903002254.2411750-10-seanjc@xxxxxxxxxx

Ok. Thanks for the pointer.

>>
>> The commit 603ccef42ce9 ("KVM: x86: SVM: fix avic_kick_target_vcpus_fast")
>> also added a check for multiple logical destinations before using
>> the fast-path. However, the same logic is already existed prior to
>> the commit. Therefore, remove redundant checking logic.
>>
>> Fixes: 603ccef42ce9 ("KVM: x86: SVM: fix avic_kick_target_vcpus_fast")
>> Cc: Maxim Levitsky <mlevitsk@redhat.com>
>> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>> ---
>>   arch/x86/kvm/svm/avic.c | 19 ++++---------------
>>   1 file changed, 4 insertions(+), 15 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
>> index 6919dee69f18..45ab49d1f0b8 100644
>> --- a/arch/x86/kvm/svm/avic.c
>> +++ b/arch/x86/kvm/svm/avic.c
>> @@ -378,8 +378,8 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
>>   
>>   		if (apic_x2apic_mode(source)) {
>>   			/* 16 bit dest mask, 16 bit cluster id */
>> -			bitmap = dest & 0xFFFF0000;
>> -			cluster = (dest >> 16) << 4;
>> +			bitmap = dest & 0xffff;
>> +			cluster = (dest & 0xffff0000) >> 16;
>>   		} else if (kvm_lapic_get_reg(source, APIC_DFR) == APIC_DFR_FLAT) {
>>   			/* 8 bit dest mask*/
>>   			bitmap = dest;
>> @@ -387,7 +387,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
>>   		} else {
>>   			/* 4 bit desk mask, 4 bit cluster id */
>>   			bitmap = dest & 0xF;
>> -			cluster = (dest >> 4) << 2;
>> +			cluster = (dest & 0xf0) >> 4;
> 
> This is wrong and unrelated.  The cluster needs to be shifted back by 2, i.e. multiplied
> by 4, to leap over each cluster of 4 IDs.

Ah, I missed the logic that was using the _cluster_ value below.

Thanks,
Suravee
