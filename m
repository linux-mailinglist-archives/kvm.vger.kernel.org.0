Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEB46469BB
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 08:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbiLHHbb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 02:31:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiLHHb3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 02:31:29 -0500
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463BC46674
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 23:31:28 -0800 (PST)
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B7Nackt023040;
        Wed, 7 Dec 2022 23:31:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=mVL7NqpjJYfJMwj45jQvhKklplIzftQ88bG4BL2xEck=;
 b=qzk31cKlffSKMXxPfHhoRO3mOObeNQlFuDO8VgHL3qjHCQuA+F3Dse15wJVQorMUlUwB
 oaO6a8ffx87En6lEY792Rhizsu4UIa3MUJYr7rXyea8xtr3tq1JSiw952Q4qH6j13qOm
 gs74iKf9uNzy2ohvfnFCM+OeTY9Q7vskXRzAMVfofJ/nvL9MBplZ0LHJ5ykOphD4iADs
 Faarvq0KkPwo1uXvfOMlBTnCe6CTIU4+LJCgy/E4dhKBxXiqhNACOlCWCHmGkigTQvJI
 YKynYaFQSwAHB7I2Ihw4TO7NuhOW5xbHdEKqW+5Yrfh4yS02/m6ekKocvOXAng32B2k2 uw== 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2045.outbound.protection.outlook.com [104.47.73.45])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3m86dmk739-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Dec 2022 23:31:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mkeZ/i3qfgQ4JvuxHF+YHE0tfkar2GOP2NSC6ros+mKU3UDmE6gbDS/4aBVJvWGlwcHNcKVbWQPIB8Uy3Tcg81bAeGgw6SrYV2+694jbpvRt0Ne1PCcaKVH8omGJaSv0Dsw7ysxSYuZnqKbzMue550QkbztHHlSRaPrWbPd2sOCjMl3hiWaCo8zErxl2/lSFybkvED66UXxoIRGj2BuI+I+kugkUMMRMDacZSU1nLQAivKWn0q5/5moaTusaON6ralmuqHCCjk3Ugkz7RA7Neqw/HtvIdHibYPcOswu0Scggz+o25HtzJF6JWY6Uo/dvUWRk1k+1MPwsNJ5XPrIHGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mVL7NqpjJYfJMwj45jQvhKklplIzftQ88bG4BL2xEck=;
 b=Ds40iJhAHzu1rdQvW0vfHhLglS/OcFEaC8bEX20QiD75okthk18xIJ6nP2cRbPVX8iAWQMU6XO9Z7Hk+oWmLwYISqdCBBCnl3ltl3UpDSPuVWwZy4ZwEADM43U+zwcsBojUMsrZc7h3uyjjbYcXGyTETkRvAg9iPUysMLHY7B8gpEahpcoamW5hLtnnRFmgfSTcfHx3d9SNkZhIqInqTufb+3ezBJbVpDQ8r2glSECPdWlvufx6X0akyXQsCMSDVYlkcSDPOcjmOo98w52tFFhv1JK+wa9ZGNa0bBWV4isIT+tR50o6MIBNN4IYax8BKMUEzS73ArMsQzYuriFjvhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mVL7NqpjJYfJMwj45jQvhKklplIzftQ88bG4BL2xEck=;
 b=NB+Bt2+DwiCvOvIGltQwTNNs4jCovA2obMb5RevPtJeeqPEsWFzIlvZEfE7hN21yNjnaGys9+Au7V3k+dBYu9mNavnPoUABgyety9OBtE6GE3vmjIQAKW57VZEk8hmmv3anFsDeHjPvIVv4oyDBoBdus23XCZNJ9h5tASoNoG27F7E1LVGsiljEGDHGMqNtfWJd/f1YkR2v1Ts8U8lSmliVejMBbRN1HHkmF94BsZKiM87NsRtZiubDtF8KcPePwFTbInoL9S4rwWUFU+1Dw80lZ99YH6yV6cfdl/XH3Ljr3hKBpEoVnYbI7t22tYph59gyVGfUbxPzvaK7rSXkjUQ==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by DS7PR02MB9505.namprd02.prod.outlook.com (2603:10b6:8:e0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 07:31:09 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8779:9a4f:69d6:a301]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8779:9a4f:69d6:a301%6]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 07:31:08 +0000
Message-ID: <b55b79b1-9c47-960a-860b-b669ed78abc0@nutanix.com>
Date:   Thu, 8 Dec 2022 13:00:56 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [PATCH v7 1/4] KVM: Implement dirty quota-based throttling of
 vcpus
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     pbonzini@redhat.com, james.morse@arm.com,
        borntraeger@linux.ibm.com, david@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20221113170507.208810-1-shivam.kumar1@nutanix.com>
 <20221113170507.208810-2-shivam.kumar1@nutanix.com>
 <86zgcpo00m.wl-maz@kernel.org>
 <18b66b42-0bb4-4b32-e92c-3dce61d8e6a4@nutanix.com>
 <86mt8iopb7.wl-maz@kernel.org>
 <dfa49851-da9d-55f8-7dec-73a9cf985713@nutanix.com>
 <86ilinqi3l.wl-maz@kernel.org> <Y5DvJQWGwYRvlhZz@google.com>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <Y5DvJQWGwYRvlhZz@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MAXPR01CA0104.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:5d::22) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|DS7PR02MB9505:EE_
X-MS-Office365-Filtering-Correlation-Id: 49a66c48-4078-4dca-2dd7-08dad8ee2c33
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OTU79qrWHWVobxbe23sGk/OFoeziY6rZ7youOmSMJ5l5YKRVFy21Vr/qAG6B6fp2n/w2WmDLppXMaz3s+kB+qzVejoXTmh8QZ6timIYGVt8cTX+/sqhc1O2pCJe3Z+PNLw1M/OJBFazv98fKUKpcMfufITyAMJNvtQc7XGpSMJ/ik8e+t0KRGC2D27uBr50dbzZEgvOGnzfOnH0zd7iQB+KZuTKBZMyqRhVsgV3c4IN09gudn6RKPV57BieqekjQxzKFcttSvjgERzJULavLuZPwGavCW+iH4i7tZXUVdqxIxVMStLise2wA6Y+Kz9EvYiqC0ISiLfUU2m3WED4NllxipiBjCT5CZJwsye0RcWL7mPcVgSnNzgyQdCnA0P1Rz2MvquPiBy6zG8su9uTHi1AeoSKITAOmO6HSpJN3aarEg29g4lLlmbbZkPt0/1vOTBYccIJjCQycef0MMhiLqAYWAhucSFy6Z55K+7//NzJVQMyawivGPPLVkpzn/4LH+TxQcq4Tt6f+/sT3XdzITSdDsqrfrE0e6kSQ38X/diR/rFEb1axkZc00IfAQvbDLSJyDbu8mZoEdT1RqyCgzjzfcHW48L92V++U06yHw++ZhnxVJC9zHwW7DEsd3uIqcYtm1zEB3OnDBzjWa0076zZEO0P6bPxAQc33Q32jcxoS9jFAA39lctbopjz8umxloCxoafPEvvXQnu+SJjU4dnLp0eevUZakKnaXjXDvWnDeKl/4+Uzt4SGcDh9Z2J4qS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(376002)(346002)(366004)(396003)(451199015)(2906002)(31686004)(83380400001)(15650500001)(2616005)(41300700001)(86362001)(31696002)(36756003)(66476007)(38100700002)(110136005)(26005)(6512007)(5660300002)(8676002)(478600001)(8936002)(4326008)(186003)(66946007)(316002)(6486002)(6506007)(6666004)(107886003)(66556008)(54906003)(53546011)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TmdnbHJkYnR1RnU3M29pOXpidmM2alRQNi83MEZEVzRhT2N1aG1pUEY5RlNk?=
 =?utf-8?B?cXFINE5jb3ZwZkRNZjhiU1hFY00yUktLWjB1dUdma0pjalVwMGVyVGcyTE1G?=
 =?utf-8?B?UytIV0RwYkw3c0JucGNyYitPempXYXFCUXhKVEZ4cEY3VU0rWkgzd05INmE2?=
 =?utf-8?B?RGFpdWl3WWw2MkUrMWUvck9hU3VFcWM0WWdNVlhMN0xoYjdaUDA3WTMzK3Fi?=
 =?utf-8?B?cWo3Z3ErOCtBTGR2NmhVSTFDRCt0aElMRjJMckhxU3d5OEtXck9GaHpmM00z?=
 =?utf-8?B?N2hZSlVQc1ZwTUVicVNheDNTNXgzckhpZzN5dGNRVTdCd1c0WFZzTTBnamhk?=
 =?utf-8?B?ODAvWVpTWXBmRGRRdWgxRDdGTno3U2h5UHljaTJhcGVaUEc1SnROMTdwdmty?=
 =?utf-8?B?K21JMkpydVRDcHV4bXloV1lZWGpvM1pnelRHNy91NmRuK01ndlA4bGorVDFO?=
 =?utf-8?B?TGplQTJSWEJqN3BXYzlTRXQrZ0d0S1p6dnFDNDhlYlZmdkUxYWo5WjhiOERQ?=
 =?utf-8?B?emNDZ1l4T0h1VjRQUzc1QkVnV1E5R2M0NFdnQzUrTWk5NzJDWUF3LzhmckFa?=
 =?utf-8?B?UWZsc0ozS3gvTnI4OC9pcE56MjhmcEtMSEZmL0xhbVBpNmFQREI5N3hmWDhZ?=
 =?utf-8?B?WlA0S2kyWVgvZzdvZlFSZkRkZHorZUtIcXBqY09NZEZ3TjV5S21SNzg5eGNn?=
 =?utf-8?B?dHdpbVJZS0lDVlB0UWhnM0xneWVhbjFob2U3U2hydVdCM1hXWWgyOWR2YmJQ?=
 =?utf-8?B?SDdVN0xaYkljaVFzN1JBVEhocmdxNVRwa0hRZE5LRElYNFR1Rm1hd0FwMGds?=
 =?utf-8?B?RS9oWk1wM2dyeHYrZTUwZlVJNFlrQmNUVGRnb2Foc2dtMlFxa0pjdWI2RUdY?=
 =?utf-8?B?WlZsbnhBaEZEUXl0NWZESmlUOGRpMGdvK3czMUpyV0tmbDR0SC84cVBueElm?=
 =?utf-8?B?d2lvNW5JTXA0MzVucTN3UGMwbmtoZjJXck40MWduUUhZRzBVSGc1VjdLQ3Ro?=
 =?utf-8?B?NTgrSVRSNUxubk1rYjAzK0xBektnRFZINDQrdmVsSGs2bFBwMEE5MnFqZHdh?=
 =?utf-8?B?bWxZMi9SM2dWSHdUbW9ta3N2ZnFZRUlhWjMxWXRqWFI4MEZ6NlZpY1ZuQVh2?=
 =?utf-8?B?c1p2ai8rUmQraDFSN1hqVkxjTXdET2t5MUx4THB4WXZmdmdQM0pDTFBNdkEr?=
 =?utf-8?B?SHVNam92cjQ5NTZ1ZkxJVTZzdFY0djZDR1Y2Z1Fza2tBTElDTDZmemNBeGQy?=
 =?utf-8?B?SmVKVzhYc0szM1orS3lKS0RLYUFId1h6VWY1aDlkZUFrOW91cnRBR0pQZjVU?=
 =?utf-8?B?Q2h2Y1dhOUNaNTFSR2tkVnUweFFmS3FSaXpOT0NZMTdJSWo3SnFFc2RWbGFW?=
 =?utf-8?B?UDNpazl1Q3M5ZkJVMHJIU2NiRUdoY0dJOTk0bHVVbFIzN2lySzg5UnRSQlkv?=
 =?utf-8?B?Wm1RcjhPeGNJR0FSTnk4WkR0VS9ZZW12RnNPUWV2UXk5MTZYS3liYURXZEJW?=
 =?utf-8?B?Z2NTT0R6OTA3c3drMEpSdmIvS3gvbDJzQzFtaThKcnJSUElKbjBsS2tmandF?=
 =?utf-8?B?Q3ZRWnJxa0pHQUt1OUw0M2EzakhzWnAwT2RNeXlRblVPWnZSWEprY0p0Vmpj?=
 =?utf-8?B?K2NiVFFxMHpoK2FjM0VMTkJ1dDRTaEdzOGhpbWFPd0JreEVKWnZ5U0p5LzMz?=
 =?utf-8?B?ODJmNnFicmRKRlpFaFh6aFZaN0ZKUUoweDdSZ29TR3VCWHdCcWJQcTB3azZ0?=
 =?utf-8?B?SGFjY09yMWxVRWUzaUdQQmg4c2xXQlNNYXRXZ3pBam9pOVlkNW9xUDdBWXFC?=
 =?utf-8?B?bnJVN1FPVTdvNm5TY1N3QVNKRjhMWG44MllYcUZySXpvYkFzWmdZUkZmSTRH?=
 =?utf-8?B?MGZhcW5DenMzc2dkRjZ5WmhTMnJnT1QwSkZyMkgxaFEvQmhpMW8vdSs1cmp2?=
 =?utf-8?B?aUYzQVpqOVYxOFBGTlJQcjVldUNLOXF5dHpSQldyNk1jWmZmRE5wcTR4dER2?=
 =?utf-8?B?T3Z5N2kyT1c5YzJvK1VHS2srYkc1UmlyRmFsU2p6eURnbDlUU1A3RUIrQTRq?=
 =?utf-8?B?dTJSTmROcEtHUi9VS1NvUUFoOHFCaUtZUWdpWXZKNUhPOVlLOVVxaXZrajdI?=
 =?utf-8?B?YXZtcE1SVFB6NUxyMFNZbE9WM3EyVklBQm9BZFpyVCsyemlXcm9OWDcwSTRy?=
 =?utf-8?B?OWc9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49a66c48-4078-4dca-2dd7-08dad8ee2c33
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 07:31:08.4682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +FigIE/gihYORYPAA4TsB2sNjHhcUFClT24XfZ1gHhFpv2TEVrljW9FeWpVBtKonrbU/AmMtYChKN6vvS81mzQsfBsviDb6owDfVZl2oqBM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR02MB9505
X-Proofpoint-GUID: gdQYm7CLsoO-xlIjZrYIvjjRv7Ait5-H
X-Proofpoint-ORIG-GUID: gdQYm7CLsoO-xlIjZrYIvjjRv7Ait5-H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-08_04,2022-12-07_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 08/12/22 1:23 am, Sean Christopherson wrote:
> On Wed, Dec 07, 2022, Marc Zyngier wrote:
>> On Tue, 06 Dec 2022 06:22:45 +0000,
>> Shivam Kumar <shivam.kumar1@nutanix.com> wrote:
>> You need to define the granularity of the counter, and account for
>> each fault according to its mapping size. If an architecture has 16kB
>> as the base page size, a 32MB fault (the size of the smallest block
>> mapping) must bump the counter by 2048. That's the only way userspace
>> can figure out what is going on.
> 
> I don't think that's true for the dirty logging case.  IIUC, when a memslot is
> being dirty logged, KVM forces the memory to be mapped with PAGE_SIZE granularity,
> and that base PAGE_SIZE is fixed and known to userspace.  I.e. accuracy is naturally
> provided for this primary use case where accuracy really matters, and so this is
> effectively a documentation issue and not a functional issue.

So, does defining "count" as "the number of write permission faults" 
help in addressing the documentation issue? My understanding too is that 
for dirty logging, we will have uniform granularity.

Thanks.

> 
>> Without that, you may as well add a random number to the counter, it
>> won't be any worse.
> 
> The stat will be wildly inaccurate when dirty logging isn't enabled, but that doesn't
> necessarily make the stat useless, e.g. it might be useful as a very rough guage
> of which vCPUs are likely to be writing memory.  I do agree though that the value
> provided is questionable and/or highly speculative.
> 
>> [...]
>>
>>>>>> If you introduce additional #ifdefery here, why are the additional
>>>>>> fields in the vcpu structure unconditional?
>>>>>
>>>>> pages_dirtied can be a useful information even if dirty quota
>>>>> throttling is not used. So, I kept it unconditional based on
>>>>> feedback.
>>>>
>>>> Useful for whom? This creates an ABI for all architectures, and this
>>>> needs buy-in from everyone. Personally, I think it is a pretty useless
>>>> stat.
>>>
>>> When we started this patch series, it was a member of the kvm_run
>>> struct. I made this a stat based on the feedback I received from the
>>> reviews. If you think otherwise, I can move it back to where it was.
>>
>> I'm certainly totally opposed to stats that don't have a clear use
>> case. People keep piling random stats that satisfy their pet usage,
>> and this only bloats the various structures for no overall benefit
>> other than "hey, it might be useful". This is death by a thousand cut.
> 
> I don't have a strong opinion on putting the counter into kvm_run as an "out"
> fields vs. making it a state.  I originally suggested making it a stat because
> KVM needs to capture the information somewhere, so why not make it a stat?  But
> I am definitely much more cavalier when it comes to adding stats, so I've no
> objection to dropping the stat side of things.

I'll be skeptical about making it a stat if we plan to allow the 
userspace to reset it at will.


Thank you so much for the comments.

Thanks,
Shivam
