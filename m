Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0918E76F85E
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 05:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbjHDD0g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 23:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232883AbjHDD0G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 23:26:06 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2049.outbound.protection.outlook.com [40.107.93.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F03114C04
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 20:25:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TJasoyyNXz/3E9WEl7fsUx7zl3qLqJI/MlSomzhHYeVHmwE95mN36UiBZaM/KpPVeScwyYAulPqm+p+g20vSq116X+XIQkhTEH4uc+iLylBd90NLpAvhL0TOOSC3mWxK4ByVl+TtRjeOBTi/+x+7xWnqhE8Wj3/EX1Nxdl84OlSQ3xRHuviFdbfI7n7Cs5nrwRBO5FJFyf+vInZqIew1lsQtz8+gpTISsK8O8tJO7jV1rErHoeI60cUych3oeIEFUIKDqYUrUvfzgUm9K7iU+RESBfBeMlkou54ZcAy7Fr8Ob1j3G6tQTzdWx0PAIiv8jsSeFW3H+LtkdJqbPma9Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WQUHDaI6ptSo4QWpPnVUTzV09frD6SjY+dkAvy9ebXQ=;
 b=EztAHLKyongqNNx1uDjar6CFrGXRm4N0fzYywxI8wgV3FyRPWc807CMEZjtFXCUYMLsetAe95UlC3BPMeoSxMHt1/G+fdkj/8v+L7l7UD6OoiRx/HoOch8IRm8puFKIMgCy8VOddnXazafkhWyqqnJkCjVEke7/IMo7C5Fm56Hqm8y+iVq49Fe5VJkb/S6X0dHTVfjXSB2cguJ5kGJpbZ4vXohe9Zu9bKAZJgKW0arPOnGg+niAPW7oDTWj+NFiYF1kAGZEJzsxGEuv77SePj/mjdBXg1wWMNeqr3MaVO4RWjKpxQyYskBnloIRYxo4AB7Ac3czCFid9aNgtNhlpog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WQUHDaI6ptSo4QWpPnVUTzV09frD6SjY+dkAvy9ebXQ=;
 b=EITF7MHpG8pZmADLRuWJj5pHWTcQi+EkfYeOvbj9xDfFQMJMIfonag1vndZAEomLOP2r7oVIYiOZDBJoyL9Zyj/cthixmO00x3/Hn8QvoKihzJCER+pT386DhyDFTiaXwpe7PotNanBud8PT4iGO/HR2Cdp5qFe5u6a2uvpREK4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 CY8PR12MB8241.namprd12.prod.outlook.com (2603:10b6:930:76::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6631.47; Fri, 4 Aug 2023 03:25:44 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::9ade:451:96c3:7b54]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::9ade:451:96c3:7b54%3]) with mapi id 15.20.6631.045; Fri, 4 Aug 2023
 03:25:44 +0000
Message-ID: <8d1a4f69-161a-52b8-4a86-0be17f6fa0ec@amd.com>
Date:   Fri, 4 Aug 2023 08:55:30 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Reply-To: nikunj@amd.com
Subject: Re: [PATCH] KVM: SVM: Add exception to disable objtool warning for
 kvm-amd.o
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>
References: <20230802091107.1160320-1-nikunj@amd.com>
 <20230803120637.GD214207@hirez.programming.kicks-ass.net>
 <b22761ea-cab6-0e11-cdc9-ec26c300cd3f@redhat.com>
 <20230803190728.GJ212435@hirez.programming.kicks-ass.net>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20230803190728.GJ212435@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0058.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:99::17) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|CY8PR12MB8241:EE_
X-MS-Office365-Filtering-Correlation-Id: a8b89ee8-7d01-472e-b14f-08db949a7ca7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lGCeiLzC94q8Li5pvryfA77zCu8yeYLKA8elCiAZ1Z/FBsEYxUQDad66QJj1n6Ysq8mpFqG9vudl0J3lqtErfOj7sRUfBOALUqV8jWGUqEf8TkbcUPil7UaKbS8HGncReVEgPTymHjp3pG5Z40fGIiNri3dnVe7JGeY9aMwpQGms5jnWEMAj4YDaB29OaokBJaeriawypA1gIZvDrfzlzY6ZU8cAbNbJ6rUwu6wi8OXgWaiwh0m1xPQaBqoQfcytPB9uiJ12WaVkFQ3y0cXbY2mhrU1whME1TSycIM0Ld+YXS4L0CIQCeJHeZn+dUpXChxMiRAniRSBXXx8TLH2mGmbmOzAp8QdAV1f6U0ZZKrCsKdp67W9ZwrcPpRFtomxE3LfwtCmZBDAbLsG2rojivOoFzD319NmZYICxAHMr1S72A/3Hq41jBVHEq7KIgl+evXY47vxunmYkZEjCJmzs83vmoB+/Ev3gYbHANbFnuRGJdEJHEF6NHwNbV4EFC0TotfzMl3fhcTM8cqj6AsD7x8cYZKWIz+vq4U6n2qaa6rCTvQY8nBxrdfBw12jta/5zpNJwTrxNI6euCtppATJv/JTs+VMs+/rlduLA9m7Gh/X9qNyweYnw3AYTqUwGQZZx8JnukKqHf90i73ze8KwKYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(396003)(376002)(39860400002)(346002)(1800799003)(186006)(451199021)(8936002)(2616005)(8676002)(26005)(83380400001)(6506007)(53546011)(66556008)(3450700001)(2906002)(4326008)(66946007)(5660300002)(66476007)(316002)(6486002)(6666004)(6512007)(478600001)(54906003)(110136005)(38100700002)(36756003)(31696002)(41300700001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TExPU3M2dDdIVndSTVZCQmFkenEzZ0UxNGEwb3ZqZVBqZXlGUTNVYitTbkVG?=
 =?utf-8?B?cHhUbTMvbHcrL0hqV3MvcVlGTDdzQTJBdkVWOTBvR2pwRG5rMUFwcktCVXR0?=
 =?utf-8?B?Sk9SMER4VjR2bjQwejhxNGlZL0JqOVFFRmk5TGdROFpUeTBJKzhXTU9qSHRY?=
 =?utf-8?B?bmF2N2tKQXg5M3FjYUZoUkU4NDZ5WjhGS2tmUzRHVFVvMVEwVkQ3RXgwY2NT?=
 =?utf-8?B?Si81Q3FwVUJkT05SU2hNeXZXMWdqY1lGWUZzRlRyWmVSeVo2N29DR3FqdzFC?=
 =?utf-8?B?MUc1UHlDM2JNZVZITERiSjU4VXovTFRIRkM3WUx0WmNzdzdLZmNxWmk4bDZj?=
 =?utf-8?B?aWlWNlZaSitmRGRqcXFuVnFYaGh0V2dmaEY3WlZCOFBuNXRtTHo1N1UyVVU2?=
 =?utf-8?B?Skw4Zm04ajF2SVpsS3VLVERMeWpNdkZ2cXpMY3ZrREoxMjEwUThiUXFDaXVT?=
 =?utf-8?B?U1BMKzQ1a1ozRnc3ZXhhd09jcWdYTEJzOTBidXZMSWN1aWtUa1ZISVdSVjdD?=
 =?utf-8?B?UzBhOU1jNk5tVjd5enViWXE2dzhyS2tReElEWTh1UFA1UTNHcTFrL2RvWUtJ?=
 =?utf-8?B?ZmN6QjVneGprNi9wUnp1RmFabG9YZ3hmWVJjMnQxWVV6djZsZFlwbWMxR2dO?=
 =?utf-8?B?SGRCb2FFY254SjFKc3p0LzIrdm5mb2tWQVlnUVVUaVkzKy9RODlsNXdOU1hz?=
 =?utf-8?B?Wk1MYnlTRVcxUjJJME1HY2p3OEU0YjlZd3hjRXQ0b3MyS2Q3L1ppcHgrYVBl?=
 =?utf-8?B?WmMya0VzV1drVmZYdHBLOXdaRkRmV0k0Y2gvbVMvcHVKa25wc3VIVkRCOElC?=
 =?utf-8?B?U0lUL2srMWVWckpjV0lvYTF5YTdWY1ArRWhHRlFWNFRMN0JybzlTcHlZcm5s?=
 =?utf-8?B?enFRdmJsSDN5MEVtU2t3TmFJbk5UbFhmMDZQTmhScURQSXdJV29xUzJ1VFNr?=
 =?utf-8?B?UUtqLzBaNnkya3BTVVd4R1pISHlHbmpVUHUxb004UE5CZm9NZGFmTmprTTRG?=
 =?utf-8?B?aysrcWdRN0E1OFRzVWl4OE5mNTBBSXlWOUdSdHd2ZXVRdFhVR2pTZDRGWFJY?=
 =?utf-8?B?cnd3YlZLaUFVWUtwdEhVd1MyTWdkVEJZdElPZlFpTUtXaHd5VUw4K1FlQm80?=
 =?utf-8?B?ajhabmxpRGpiMFl3Y2Y2RVRiL0FwYWFJcjIwUW1xbWF1NnVGZHI2YlFjcVdi?=
 =?utf-8?B?VkozK2M5ems2LzdZWlRrZXdZaHNxSDc3VDViUk00YWhvR05FMnlDK2d5V0J1?=
 =?utf-8?B?bDdIMTZMYjVEYjUzV1hWd1hIbEJDVFRkbFQ4Y0RES3NtdjFJd1lMdFBJTWxp?=
 =?utf-8?B?U2I2OW1wY3UzNmRiZFRERmJXRUl2dFZPQnpGRnZOUEM2bFRpWDc0N0JVSUFh?=
 =?utf-8?B?ckVRMW1FY253dDBiYkZ5RXIvcUlObU01RzU1Z3o1aUFZbDZTcmY5Tkt2MnFa?=
 =?utf-8?B?czRjTSttdW1KL0VmMHRLMDdCUVdXTUNWMGc1QU45dUFvTVB3dWpQR1lYbm1X?=
 =?utf-8?B?K1Eyd3A3UlFCRDd5bkFiN0VSdnJCM293aXo0VG8xQlNNTkJNSWF1d1NuZXJm?=
 =?utf-8?B?Z2Y1MUljd0gvY3FpRkxEWjgxVnowbitieDdYU2lVTUl5WlZBUG1FdUJiU0ZK?=
 =?utf-8?B?VVRpR3MvWmtvaDk2K2Y2ckhFNVo2NEdodXU4NXYyMXZKSUNmVTNjR2FQNkFD?=
 =?utf-8?B?SzZtZ3E4TUNtY2RDWW1udGNIbkJsVmxVQmtXREh2S21DaUw0MENQZndFK3gr?=
 =?utf-8?B?LzBLekVVUzdTOHp3czNGZEU1ZUlvZTVtY1JBbllFRGtGKzNXdmN4K1NjQkxI?=
 =?utf-8?B?cHBVSEp6d2s1TE0zdVJCeVRUV1l0S0ZTcVNjVlBKdldCZTVTQTEvd1ZqcmJU?=
 =?utf-8?B?Y1JDTDROdGNEMFYyRDk0OW5HZDV5RkJhbUx4Q2wzMW1pdk1GcXdsQURybk5W?=
 =?utf-8?B?QVl4VTBtbzVMRWZLdnJYTmo2Q1lzY2JYTC9ZdlRJejhzbVRBZDJQWmQ4bDlI?=
 =?utf-8?B?Z3dyWHZrYzB6VkxqYkRNUWRIOStIK0JQbjY0czg0dkhSZGp2cnBib1pkbGhv?=
 =?utf-8?B?WUlCcVFrNkJSeXJUcENQbExmNlFCKzFIMFpoVXR4UitFUzdUWXlYcVBnakFp?=
 =?utf-8?Q?0QMXX3oRb7U8uVgBnnRJdsCK2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8b89ee8-7d01-472e-b14f-08db949a7ca7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2023 03:25:44.4104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hsD0rVzdCx8FxSNMUq/fwJ13knkBz1DkhNwa9KwiD1pEJO6CPxeiWS+YrIOHBXcv/rchTFFUKOtoeZGxJDVg8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8241
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/4/2023 12:37 AM, Peter Zijlstra wrote:
> On Thu, Aug 03, 2023 at 08:06:20PM +0200, Paolo Bonzini wrote:
>> On 8/3/23 14:06, Peter Zijlstra wrote:
>>>
>>> By marking them with STACK_FRAME_NON_STANDARD you will get no ORC data
>>> at all, and then you also violate the normal framepointer calling
>>> convention.
>>>
>>> This means that if you need to unwind here you're up a creek without no
>>> paddles on.
>>
>> The only weird thing that can happen is ud2 instructions that are executed
>> in case the vmload/vmrun/vmsave instructions causes a #GP, from the
>> exception handler.
> 
> This code is ran with GIF disabled, so NMIs are not in the books, right?
> Does GIF block #MC ?
> 
>> If I understand correctly those ud2 would use ORC information to show the
>> backtrace, but even then the frame pointer should be correct.  Of these
>> instructions, vmrun is the only one that runs with wrong %rbp; and it is
>> unlikely or even impossible that a #GP happens at vmrun, because the same
>> operand has been used for a vmload ten instructions before. The only time I
>> saw that #GP it was due to a processor errata, but it happened consistently
>> on the vmload.
>>
>> So if frame pointer unwinding can be used in the absence of ORC, Nikunj
>> patch should not break anything.
> 
> But framepointer unwinds rely on BP, and that is clobbered per the
> objtool complaint.
> 
> Also, if you look at the makefile hunk that's being replaced, that was
> conditional on CONFIG_FRAMEPOINTS, while the annotation that's being
> added is not. 

Even with the hunk present with CONFIG_FRAME_POINTER=y, I was getting 
the warning. That is why I had added the STACK_FRAME_NON_STANDARD and
removed the hunk in makefile.

Do you recommend using the below instead ?

#ifdef CONFIG_FRAME_POINTER
STACK_FRAME_NON_STANDARD()
#endif

Regards
Nikunj

