Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFC39646F57
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 13:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiLHMMa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 07:12:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiLHMMZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 07:12:25 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on20603.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8d::603])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 260AB8B1A4;
        Thu,  8 Dec 2022 04:12:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZXTlzuuoLNlZ1vO3dEVOTFf/DXsDn0WUq9T95AAdS+UsgMAqZTTaH7w2JaIh6PVO7oIJHIyga5gsVESK9KNc2+r4fQVwa5FAjcwK2lRWMRc2N6Yy1M2pomZ0M67VDmelMWNz5HzNnjYOinkA/Ky4cGCiUaVsJy4DS7H9ZQnsvwp/Nubxvfs8dD97/mhVUrjHD0raCAl/KAz62paQphmcECK37Q0K9YkuAD01w+KOoKXXpK5EtHlPU2nSib414hH8+iEH4gNpuVrCChEXFtQjG65snoK3xrfY5aM94juUhI+H5xfrv2J8+EuzoW0qAbjCj1K6r73ZYhUV5gBP4aK20Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2o3zOSUqhTtWTakzJkcaSU1LsBtV+XtVHVhTLwlct/o=;
 b=TEDXc4rORsM3BRlQ2GUgj83SyKF8jgwIhs5DtdTOu5b0ebb/2Nl46tiXOE8QhslULpiAHVoFVBT7Je3NaESJzI6kTo1457cHgX2/uy2g4WFMbfaOYg9iIwGTt0p0VMo++MT7Q3FUQOmHjMgPyhSB2Hh9fepYLBKNDfpe6Og2qDInPo+iXKiVO5W5ULyStMId3EjtFt5hJSOziJsv8Qu8/RhGEn4M8yK7XBvIPHDP40K9BoYhLO1LWHRdZuYoCsCTlzvNl8Ru7bRnhzvYynJ0BBdFHcGOg25ETw7DQPXXZ/wIgHB0IdC3UMe/UJSaiCYGh8aCCpjXzqE3qE7EqiTq7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2o3zOSUqhTtWTakzJkcaSU1LsBtV+XtVHVhTLwlct/o=;
 b=jNLHanzvW84Cwvxn9W1O350LPRi4YUUyct0TEZSkqsCuIV51iXkh3tXTA6EaYsOHlU3fJ5Z27l6o04YHqhJpJTz7oj48OSElfPHSCk8JrAmGPeCBSHe7Bspn9zYQuqrUL5rGecDEzEcUsrmBoTdCG+kaEouCwwjM98kYUpIOa2M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by CH0PR12MB5042.namprd12.prod.outlook.com (2603:10b6:610:e1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.16; Thu, 8 Dec
 2022 12:12:16 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::caf0:cffe:94c4:df18]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::caf0:cffe:94c4:df18%4]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 12:12:16 +0000
Message-ID: <ce38bb11-d8cb-5f02-36e9-01aec7bbefd3@amd.com>
Date:   Thu, 8 Dec 2022 17:41:57 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 11/11] KVM: nSVM: implement support for nested VNMI
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
 <20221129193717.513824-12-mlevitsk@redhat.com>
 <7efc45d1-4799-972b-cad7-482bb1662fa5@amd.com>
 <55177ebfc8962dd9f5318e6b6b8cefd0dba16359.camel@redhat.com>
From:   Santosh Shukla <santosh.shukla@amd.com>
In-Reply-To: <55177ebfc8962dd9f5318e6b6b8cefd0dba16359.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0029.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:97::18) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6323:EE_|CH0PR12MB5042:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b5ee37c-1e9d-4f77-00c4-08dad91571eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vU8lWrU/v/CdeOryHnnKbKuXIILxNScx42zmz1JUvDuuWQEL1usZv1eNunUr4wxJDBIWlePO58D8CtaJxjjK7jX+8q+jETnckqyu2VplVL0a+qcn5E4sTjfveyIt0yZcRF/INk9jwkHoNuCSjvZiZJvqgiNUwuODJc0G/eet3vRzsD/f9umPO8goaJeFC8Q3NlAN50DsJzFew+CbfjGUHyACil8iwMpZPEWB0UO4yexPt6twh4b4hDParB0/dkwCN5eoF3wAnBNppbABtPvmiISvHdauLV3vHk6ZV+XRuMmg9tJt7SglOfQLg00t0gwPBCQzn5KqziWLMwPmam7TKHTEOrKTAv3JjZaEaCEH9p5SeD0ruE5ROEVSOiPeFPeGW2OX6p9HsLPxkt4/j+mhxWpK5lPJkgtZmtWvHx+/AVdsu9PJ9HDyLxYwvdLD3xH0SL2luaR778yXhPD9fVY5RfvzqgIFmv2uPsltZWiHLpQajHpGtnqzorAf8E7J0af25Z2J8nH9MVGAA5ISAaqUqm34xkRj1gakQmq80Ah7LPBnUlMnNJ3PmCEsvkmIzoRsCqOeWdHACmo50rFpVlo4SEEbFMlexkpEMHqqZjnWTZiEF1Jd6cTf+KIa5q1v4pWnsye2X34H1DqarXRCWU1lw+c/FANYz7RI1ixxXGBz1yiEofsRaEINEVgHthXZHYfoMXKpg4u2m7OaQXuBTcG2Bzbo0cwQQfYPCvgzji6gmhY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(136003)(366004)(346002)(39860400002)(451199015)(31696002)(186003)(7416002)(86362001)(5660300002)(2616005)(83380400001)(44832011)(8936002)(41300700001)(38100700002)(2906002)(36756003)(6512007)(26005)(53546011)(31686004)(6666004)(478600001)(6486002)(316002)(6506007)(4326008)(66946007)(66476007)(66556008)(8676002)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VVo1RW40Zk9WWXV6YUZ6OUVUcytNU0JvOUJjMXFyMUkvMTVPWk5uN0lTNzBJ?=
 =?utf-8?B?TUx3U3JnTlA4UmNzb1V5N1huMk5idzhURUZObGFVdFMvOTd0Y2txbVpuZTh5?=
 =?utf-8?B?bGhVS1lXY3NMZ3V0SUw5NjNreTV0V05zTGR4SHNWcjNRbW9LU05zOUxPYmhu?=
 =?utf-8?B?Z0xlWVdqaGV3aThCT21ueExlMkdlVW1vYTlKSGRNTkY1L3BWWHlUcHpTNHNG?=
 =?utf-8?B?K1pOczI2b0U1NlJQc2pYSUMzZGpjdjBKZEVkNlRpYUx3eTBHRjlYNHlYalpR?=
 =?utf-8?B?aGF0OUFHa3FLSWhscnNnWWtJdTJwL2I1QXBYSlZDVXRpVGtpVy9Hd3Uzam0x?=
 =?utf-8?B?dVFmVFhHZUNHVjJweGNXeGcwZm9aYmVLMzZSYk5hNUxzbXk3Sk5pdkFRVXBM?=
 =?utf-8?B?c1RtYkhIR3FsTVdZS3NXa0hxNVRtMXNlL2pRNWkrK1hPcE9XTW5Oa2x5eU9k?=
 =?utf-8?B?bFVsWjhGTHQrcllGYW1wdTUveGJJY1oxWTJZQzNNL1JnWFdzTVQyc0Fmd1Fy?=
 =?utf-8?B?ZXY1UmJyNW1lY0NoTzNLZUVPeFBhVlFPVFJkSjkxeE9oTFhoT2pnUkM1K2Iw?=
 =?utf-8?B?aTl0TjdLaUhRRWxhV0dLVllVbGUxaHh2Rk5oS2o4TmpyRkRwN3RXcjFvaDh3?=
 =?utf-8?B?cEhVNFFORXZUNjliSytnN0diNjR6cDFVZjRkeTNZTTFnZGZ3Y0VFVW92bmh0?=
 =?utf-8?B?S0dCc1EzQXBxcDMxVVNSTldNQ3NKTnVLWjVVWUhGUTdiTkZJSWRWL0FOU1ZB?=
 =?utf-8?B?OWhxVEgvMUNveUZaeG9PVHlQdXZZQnh0YTlYcVVHSGEzVzJZU2hid3EzajdH?=
 =?utf-8?B?S2xoa05rZ2Zyb0htQlp4T3ltVUZQYTJhbGZPVXByQ0lVQ1BHTkdnc0YxNlYx?=
 =?utf-8?B?aXg1TWlxdnFyb0QrZGN4Y1UwWUw2RllJYlNWc1djUVpRdkhkWVErSkw5OGhk?=
 =?utf-8?B?NjN2Sm1JcGpjaFNFUkNUcmNyU0VOTUZIaDNzQlpNZFhzc2t0b3pjUnREZ1l0?=
 =?utf-8?B?bVBVMEZBdTl6WitZK3lSajVab3lvV2dDWHBaRFlRa3FCeTUxRER4cWl4R2lU?=
 =?utf-8?B?Z3gwL1NGd1pZcExxUnpXcWtHVGZNTU1BYktlNHNXQVJFcjVuV1VvbVQ3OUlD?=
 =?utf-8?B?Nm43eEF5ZzFUQUFFMDRyM1FSRFM2MDZkd1pBemJyVDRzZGdpUndVcENGeENT?=
 =?utf-8?B?d05JL04vOEUxVm5DK3JBZDUvcnowZCtWTjZkelduUFV6bTY0WVBORkN2dGVW?=
 =?utf-8?B?UGJwMk82Wjh6SmphSkZXanY4UWV2WmlkbUdIV21UZTBnSkIvK3hZS2xHT3RW?=
 =?utf-8?B?OVRSaVBrQVpZVUE2eklSendhcWw5cnNkMktFcUI0bzBYZGdwS0JxeWZMbEND?=
 =?utf-8?B?OWR4Qm91bUhjVCt3czRyVFpwY0FGUEpYaHp6NHNzUnFVTStlOFgzbnJVb2Ey?=
 =?utf-8?B?UmtkczNLeE9OZ3crdFZGR3lRdzJoZWZpR1NOcjg2akQ2aGk5bS93NVY1b0VT?=
 =?utf-8?B?OTlwSDFyY2owdmx2aHI2U0lVTktQYTNUN2NBNGozNkI4TWRTTzVxVk5mTGth?=
 =?utf-8?B?cXd5d1VyZVhEMk96d2IydWlKV09TSnRxMzJjRERhREcxZ1pxUFlkSXAwTmxi?=
 =?utf-8?B?amU1NkRpMjN3QVdsUXlibUkremcyejNMQk1sUUZTZ1FmQ1hkZWhOZTlkeFNj?=
 =?utf-8?B?blZtcVFIaGdqM2EwSHJzRU1xU3hLQ2FtM2Zuajc2Z0ZoRmF0VGRiTE5JalhR?=
 =?utf-8?B?TVJrM2ozMUptZ1RSZGdKQWZuY1FDU0xubWswRGFBNVJZMW14WWdnWkhnVUht?=
 =?utf-8?B?NHVRblB0bGtmRnBNRWdQaWgwZHA5MGpYVUxkQ3VOUkxCbW00Q0tQbGNJYUNk?=
 =?utf-8?B?OW1tY2lEMytIdVF5WGVqbUk0dWl6MXlYclhsTkNLVHhDK0V6VER4WEVjenZD?=
 =?utf-8?B?YkJUTThRa0hENmwyMFpIc3JMc0FyN2d2T2pwUDYzajlodG1SSGRKbzVJajkv?=
 =?utf-8?B?T0wrOHQ1UnZ6c0U2bWlUUVhEeGZFTVVGb0NGZzFKeGw0N1JtY3huUE1FMndr?=
 =?utf-8?B?dTVGODJEVks3MThPS3JycHVEalJpR1BNdTIzaU5mSmQzMGZkVThQTHpoRDlh?=
 =?utf-8?Q?5spsEtjSzeQ3O5Dc/fIWs0sY7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b5ee37c-1e9d-4f77-00c4-08dad91571eb
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 12:12:15.9800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p9vSip84D8ZBzGWqS99TRCeKGoZ7BbE6Zk1OkT0aFGq3/mxiYxq+g8MhX1vlVUjoeJpD+sp+4cZMNz/y1e06uQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5042
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/6/2022 5:49 PM, Maxim Levitsky wrote:
> On Mon, 2022-12-05 at 22:44 +0530, Santosh Shukla wrote:
>> On 11/30/2022 1:07 AM, Maxim Levitsky wrote:
>>> This patch allows L1 to use vNMI to accelerate its injection
>>> of NMIs to L2 by passing through vNMI int_ctl bits from vmcb12
>>> to/from vmcb02.
>>>
>>> While L2 runs, L1's vNMI is inhibited, and L1's NMIs are injected
>>> normally.
>>>
>>> In order to support nested VNMI requires saving and restoring the VNMI
>>> bits during nested entry and exit.
>>> In case of L1 and L2 both using VNMI- Copy VNMI bits from vmcb12 to
>>> vmcb02 during entry and vice-versa during exit.
>>> And in case of L1 uses VNMI and L2 doesn't- Copy VNMI bits from vmcb01 to
>>> vmcb02 during entry and vice-versa during exit.
>>>
>>> Tested with the KVM-unit-test and Nested Guest scenario.
>>>
>>>
>>> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>>> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
>>> ---
>>>  arch/x86/kvm/svm/nested.c | 13 ++++++++++++-
>>>  arch/x86/kvm/svm/svm.c    |  5 +++++
>>>  arch/x86/kvm/svm/svm.h    |  6 ++++++
>>>  3 files changed, 23 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
>>> index 5bea672bf8b12d..81346665058e26 100644
>>> --- a/arch/x86/kvm/svm/nested.c
>>> +++ b/arch/x86/kvm/svm/nested.c
>>> @@ -278,6 +278,11 @@ static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
>>>  	if (CC(!nested_svm_check_tlb_ctl(vcpu, control->tlb_ctl)))
>>>  		return false;
>>>  
>>> +	if (CC((control->int_ctl & V_NMI_ENABLE) &&
>>> +		!vmcb12_is_intercept(control, INTERCEPT_NMI))) {
>>> +		return false;
>>> +	}
>>> +
>>>  	return true;
>>>  }
>>>  
>>> @@ -427,6 +432,9 @@ void nested_sync_control_from_vmcb02(struct vcpu_svm *svm)
>>>  	if (nested_vgif_enabled(svm))
>>>  		mask |= V_GIF_MASK;
>>>  
>>> +	if (nested_vnmi_enabled(svm))
>>> +		mask |= V_NMI_MASK | V_NMI_PENDING;
>>> +
>>>  	svm->nested.ctl.int_ctl        &= ~mask;
>>>  	svm->nested.ctl.int_ctl        |= svm->vmcb->control.int_ctl & mask;
>>>  }
>>> @@ -682,8 +690,11 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>>>  	else
>>>  		int_ctl_vmcb01_bits |= (V_GIF_MASK | V_GIF_ENABLE_MASK);
>>>  
>>> -	if (vnmi)
>>> +	if (vnmi) {
>>
>> To avoid above change, I think we should move nested bits from 10/11 to this i.e.. move function
>> (nested_svm_save_vnmi and nested_svm_restore_vnmi) to this patch.
>>
>> make sense?
> 
> 
> This is done on purpose:
> 
> For each optional SVM feature there are two parts in regard to nesting.
> 
> First part is the nesting co-existance, meaning that KVM should still work
> while a nested guest runs, and the second part is letting the nested hypervisor
> use the feature.
> 
> First part is mandatory, as otherwise KVM will be broken while a nested
> guest runs.
> 
Ok!,.

> I squashed all of the vNMI support including nested co-existance in the patch 10,
> and that includes the 'nested_svm_save_vnmi' and 'nested_svm_restore_vnmi'
> 
> Now this patch adds the actual nested vNMI, meaning that the nested hypervisor can
> use it to speed up the delivery of NMI, it would like to inject to L2.
>
Ok, Make sense to me.
Thank-you for the explanation.

Regards,
Santosh
 
> Best regards,
> 	Maxim Levitsky
> 
>>
>> Thanks,
>> Santosh
>>
>>>  		nested_svm_save_vnmi(svm);
>>> +		if (nested_vnmi_enabled(svm))
>>> +			int_ctl_vmcb12_bits |= (V_NMI_PENDING | V_NMI_ENABLE | V_NMI_MASK);
>>> +	}
>>>  
>>>  	/* Copied from vmcb01.  msrpm_base can be overwritten later.  */
>>>  	vmcb02->control.nested_ctl = vmcb01->control.nested_ctl;
>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>> index bf10adcf3170a8..fb203f536d2f9b 100644
>>> --- a/arch/x86/kvm/svm/svm.c
>>> +++ b/arch/x86/kvm/svm/svm.c
>>> @@ -4214,6 +4214,8 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>>  
>>>  	svm->vgif_enabled = vgif && guest_cpuid_has(vcpu, X86_FEATURE_VGIF);
>>>  
>>> +	svm->vnmi_enabled = vnmi && guest_cpuid_has(vcpu, X86_FEATURE_AMD_VNMI);
>>> +
>>>  	svm_recalc_instruction_intercepts(vcpu, svm);
>>>  
>>>  	/* For sev guests, the memory encryption bit is not reserved in CR3.  */
>>> @@ -4967,6 +4969,9 @@ static __init void svm_set_cpu_caps(void)
>>>  		if (vgif)
>>>  			kvm_cpu_cap_set(X86_FEATURE_VGIF);
>>>  
>>> +		if (vnmi)
>>> +			kvm_cpu_cap_set(X86_FEATURE_AMD_VNMI);
>>> +
>>>  		/* Nested VM can receive #VMEXIT instead of triggering #GP */
>>>  		kvm_cpu_cap_set(X86_FEATURE_SVME_ADDR_CHK);
>>>  	}
>>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>>> index 0b7e1790fadde1..8fb2085188c5ac 100644
>>> --- a/arch/x86/kvm/svm/svm.h
>>> +++ b/arch/x86/kvm/svm/svm.h
>>> @@ -271,6 +271,7 @@ struct vcpu_svm {
>>>  	bool pause_filter_enabled         : 1;
>>>  	bool pause_threshold_enabled      : 1;
>>>  	bool vgif_enabled                 : 1;
>>> +	bool vnmi_enabled                 : 1;
>>>  
>>>  	u32 ldr_reg;
>>>  	u32 dfr_reg;
>>> @@ -545,6 +546,11 @@ static inline bool nested_npt_enabled(struct vcpu_svm *svm)
>>>  	return svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
>>>  }
>>>  
>>> +static inline bool nested_vnmi_enabled(struct vcpu_svm *svm)
>>> +{
>>> +	return svm->vnmi_enabled && (svm->nested.ctl.int_ctl & V_NMI_ENABLE);
>>> +}
>>> +
>>>  static inline bool is_x2apic_msrpm_offset(u32 offset)
>>>  {
>>>  	/* 4 msrs per u8, and 4 u8 in u32 */
> 
> 

