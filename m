Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9CD6948A4
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 15:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbjBMOvn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 09:51:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbjBMOvj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 09:51:39 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2084.outbound.protection.outlook.com [40.107.244.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 620A61C5BC;
        Mon, 13 Feb 2023 06:51:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CLEY0Wi8IMGdGWcdJ/rbYQRWD6StODoYbkzZhctFL5gPDo4FxUmhapxvpQEHgFyKcO7yV79jkmXvWGbI8Tx9rt4CZ9W3puasRpjK5oYBKlWLRJ/XGmur9sm1yVKUAcI99TixwXUV3fISTY0OuawrNTgD1U1GlvyhPSTaJbQvbiTElpqvuiqu3jSAUQcK/rOkP0bTbnI85KZYB3iM4aWALdiN4jbnfsJA+lKfrbDyVwgAjGOm/9P3Pn8pJAwkU2LgOBQB6lSxq1lnXflGS9klbt+DpnENpVsZTKa8Y49DWN/zD7osPul73xt8GqZFbOi4qbl0xJbhltl3iKgzudSTSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xmT/mzGZRJFSaEZZlUzHg3zn4pNU2HIe4P4mcdpvo7I=;
 b=na0d22nhG5Oa/nw+B/bPlWdF2IwWsot/HggaEWlbrYAs1HXFWsd//i5BgWT7NTUcfi9rxJyxqVK4YRvq0sLjB/vZcJsYsgfC5itrbd8cdizORyI1LG3W3zwmn6EkxfXLTslLdJSr9tJ5sAUYKTOUvC2LANEnLAVbGkKaZhn5vnOZp//Ep3j4O4Zkrctb2IXBWfmVgenQkaZgfrnD752ZE0lKFVoWPloSARZ8lT7jn3GGorymsrYRsjZHCVA7FsvYY6S2AHE6DpKyfoPG45nSuDrjRRMcmpWiQ7125eu7ACB9uQInUZfoJsZ+mm7oU7bAW9HLcUtOVWuGt3oDQS+LBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xmT/mzGZRJFSaEZZlUzHg3zn4pNU2HIe4P4mcdpvo7I=;
 b=CUhmipnbm0rpIN3CUcSF+G8bXGpomDMrqV63JWi802DTnh6OpRCirkrUyMZW2Lf9VQbH+Aj4rGXPcWhx3BVMnjzJS6an8wU4y7gUdUAl41A+neJnn+tFlZexAAPn2uO9b/CiruD0PnEuYg5QCeizZ7NCRJ43+dwNenBRkJgp0gQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by DM4PR12MB6493.namprd12.prod.outlook.com (2603:10b6:8:b6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Mon, 13 Feb
 2023 14:51:05 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::c110:892:21d6:9a5f]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::c110:892:21d6:9a5f%3]) with mapi id 15.20.6086.024; Mon, 13 Feb 2023
 14:51:05 +0000
Message-ID: <a5d8307b-ffe6-df62-5e22-dffd19755baa@amd.com>
Date:   Mon, 13 Feb 2023 20:20:48 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 06/11] KVM: SVM: add wrappers to enable/disable IRET
 interception
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Santosh Shukla <santosh.shukla@amd.com>, kvm@vger.kernel.org,
        Sandipan Das <sandipan.das@amd.com>,
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
        "H. Peter Anvin" <hpa@zytor.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
 <20221129193717.513824-7-mlevitsk@redhat.com>
 <41abb37b-c74a-f2cf-c0ce-74d5d6487e92@amd.com>
 <181f437164296e19683f086c11bf64c11a3f380e.camel@redhat.com>
 <70078abb-f8b7-cd33-5bdd-bc6ee44c0bd3@amd.com>
 <06d12050eece922e786b7bee1254698466c6d3d4.camel@redhat.com>
 <Y9mDInNl65hjVblm@google.com>
From:   Santosh Shukla <santosh.shukla@amd.com>
In-Reply-To: <Y9mDInNl65hjVblm@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0152.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:c8::16) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6323:EE_|DM4PR12MB6493:EE_
X-MS-Office365-Filtering-Correlation-Id: e39e1d8b-a01f-4105-e088-08db0dd1bb91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gEFgwdtjeJ80AMXrnPy7Y53qFUws5+Ahqgbu5K1CkOIQYQSSb/dOG+CMvaYSB1rAAOZVxls+QV3Xn4Ksi9W60Cu1+fTnLc2tYxh77ojrMmycebshXdcvt/hN8BOYRk0lafEt+5JmxHUBdSE/E8eN4LBZkBx+CPrrCScLLJmhYCMrNV7MpPb8XuZPNa7ITdjbs06lXJXfKFaBvmng8XvzJYKOt6U0cC60U0uGa356WGqXYpImsKTO/rU2IzUhUdUCcdXfuZQKm/xy4PVLxaPzoVMMhtPLMhVus2RX2JBlwab8nJye6VGDPkp48vtqxRBEQv8L87HK0Y4jEjwEjRk3S9/m7Vuvb/ZrcRoi7n5cgucXnZty1sAGwtxvP1v5maFdOnZzPB8EGdz7OXW4v5QlNLsIVMaAsCf8ngGXg6j/dvRat7FIiwzZF/4LO5FGtRA42jWjPllgqeki2+07mKmLquUJ1C/d9MAcTVbkzUl3PZDbLaakI5ndXtb+1pu0BtjDvczs9K4j2um4q0SJpch04MPfZ4ngh6Pn0OVEB64CTar27YagmG60l6epja1msWuW6UFcKBX35a1QRB/ou0/tF2Sb7gu2vPO2/nZYR6VeX8+PSjlEYsSscXt7Gvnh9TtKWBVeEYzVyOKO/HkuTCGPzybS+mklomnXjHXXvaZ10117qNvlsq+jgT4M8SS5XoemTcg/NPYp1NEwj/V4akYy5LhemntGJbAnrAE54dedh50=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(396003)(136003)(366004)(346002)(451199018)(7416002)(38100700002)(8936002)(2906002)(31696002)(44832011)(66556008)(66476007)(66946007)(4326008)(8676002)(5660300002)(31686004)(36756003)(41300700001)(110136005)(53546011)(86362001)(478600001)(54906003)(26005)(6486002)(186003)(2616005)(6666004)(6512007)(6506007)(83380400001)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OHZpYUphdkJmRVl1YUVjY21iZW5jalRsbFoycXJGdzBtM1hjaTl1bE9rVEs3?=
 =?utf-8?B?N3hOZVFSeTYzMi9pZW92SGNaKytxWW9GR1YzZDIyd1lQN0xGbWxaNitZSkpL?=
 =?utf-8?B?OWRkRXBWdGxOUktjWHJycHI1THlFYnpJQ3dNaUdhWXJPYlg5dmo2ZlpTR1Z6?=
 =?utf-8?B?Q3pBbkVKS2lQemJLZWoxUVJ6azNvaHR3VEdSMzlYUDNxckRVZEN1NEhCYyth?=
 =?utf-8?B?S0lHR3puYTNQa2x1T0pJWGlCUzJQY2x3ZUZPeDZEejlVUTJndk02Rnd0dWFP?=
 =?utf-8?B?ZXN0RWEzZEJIRFpHSXJQdEJTK0JLcmVlNlNSbFlhTTljQ01wRzl2Q0NleXkx?=
 =?utf-8?B?K3pIUWdpUWZHNndBQUtxWldsQUZUaUpOYjhBOW5zOEJsZUxmeGZBNytSNFQw?=
 =?utf-8?B?Sm9CQlQ0azZHU29FMUU0TUVsZUhTNFBPVy9tMUE5bmZXbCtYbXYwNHhoNEFl?=
 =?utf-8?B?SEMwR2E1eHg2YUMzU0FZbTJaRFpLTXVWMlhyK1FFNyt6a3VnMDJhYjlTbnBR?=
 =?utf-8?B?MWhFQS9TNWI2NTNXSFVBVmRsbXV4dWFrYWY2N2pQc25CUlpyWHFhUktZYlhG?=
 =?utf-8?B?QldjUkpTeVgzbnpRemZZL1pIYXhWb1VNdmFFV1NBbjduUlBHUXJodDhmMnpy?=
 =?utf-8?B?ZDdWa1FDM2V2QmV4YmZ2bkl3MURQWnFQL1J0ZmEyLzlNUk5TdXhxdkFCUHJK?=
 =?utf-8?B?bURTVitNM1l1K1FyWVd0WTVzUnljNThnVmFXNk4zWmxYWUR1cVh0RWFSa1U0?=
 =?utf-8?B?VlNqcXhCSEM1b2VvMURhVnV3bWNjaHg5aEFNRUt3ZkMrR0xBRTdreDg0bUVZ?=
 =?utf-8?B?b2ZFdmtQSEdSQk9qUlFTbkdaTWNCaVpaRGR1cm5INDkrUW1NWEY2Rko1YWJm?=
 =?utf-8?B?VCtuSHVmK3FYRVRhMTdTREVDNnp2Y1B5akxOTmhFSFczU3B3aktSYW9wSWEx?=
 =?utf-8?B?Z3JZLzkvcHB2QWJNZjJRcVc5eHZvTWUzY3VmTkdJRDNVc3R3L3hTY2FlMmZH?=
 =?utf-8?B?TUQzNWRFRGFoYXlKeEdmR0dXN0FuVTdZTm5tVTNMUDFOeDVUWWROaG5JWDFV?=
 =?utf-8?B?aTVmWFlnRjZsYmRzb2JsN3hXTzd4a1phaXBYK0JheWlkVFErSithNlRWWHBh?=
 =?utf-8?B?YndRWkZKajFJL24yUW1RaWs3ZWtXeW15c0RkNUcxWC9lMTE1UzNuSm5rVjVy?=
 =?utf-8?B?M280TEplZGs3cXRDUnlwb3ZVa1FJMjFDMjRLQXUzcDJMQ1NKZjFJcnV3eVEy?=
 =?utf-8?B?VDdyR3B1TWtrOUtGanlvN0dMYURiMG12N1liWlYvVG5LY3MxT3lTUzdxVGdC?=
 =?utf-8?B?YzNaOGJHNUl0UXhVWm8wT3hxRUJPUnZsaW1GMGFVbzhHMmZoYU53RCtKblEz?=
 =?utf-8?B?bDJiV0I0L2NYYjVralBqOXZMM1U4QXQ3T0VwNDBrZTQvdS9KaTNzTWQ5alhM?=
 =?utf-8?B?UGNENzJMdlRlRWh1OVpSWExUM3d3VXpzRFBUNGhWYmtwOVZIcGxIOXhYMFpU?=
 =?utf-8?B?bGFiVkNQRXVqVVp6M1VScXNnTDJvNUJTa1ZiN2ViUlNFeU1Semh3b1EyQUpa?=
 =?utf-8?B?NEhtTXFkUCtQYVBsWGM2THphSEhzRWxMa0l0Rjloa3R0Mm1EL1QzQ05DN0pa?=
 =?utf-8?B?QlRNc1VRRGE2OFFaYzAzVGptZWVvM2Q0N2pldWV4bmpOZXpvVVUwMDcwc2lZ?=
 =?utf-8?B?d3F2Uk9lR3NDTmtzSnJFVjZSWnRPaTdZajJTV0YwSFlGVS83QXY3WkpKbUFQ?=
 =?utf-8?B?azl0b1FuUWlVMjdFVWljVXpPTjNSOUtBSTU1ZVJSNjVya05xb2tWSDV1Zk5Y?=
 =?utf-8?B?YlgvQkk5TGJ1RDBZSHQ2dDJmTHhKQ05Qd3JWK04rL0FRVStxN0l3QWZ5aFJk?=
 =?utf-8?B?VEtVTmVlUVU5aE1QNG9GZWZJY1ZuL3JYZloyb1RwTFRCVHd4UW1DWjdOUWpw?=
 =?utf-8?B?VnhhNEtZYTFUU28xVThuWUEzQVllYVdCeGxXTDd3Mmg2YzMvcUdjNG9QWFVQ?=
 =?utf-8?B?N0RkVGgwUUlCSGZteEtrOHlBTWxGK09UbmUxS1U2dUNnamY0UkMwRVNYTHdI?=
 =?utf-8?B?OVh3alpMQ2NCRng3N3NzTFI3Vm9CMEpGTU93S0ZPOVoybS83cWd2RXNHRHNS?=
 =?utf-8?Q?y63su2s/oaPy8K8P+BYOFYOYK?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e39e1d8b-a01f-4105-e088-08db0dd1bb91
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 14:51:05.3500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ty4AYglxp/nlhSrwSADlrIZMObg89rn0/gQ2+4Dck4Qk8zRyLsWUN8t/Ug8liuCPaeRnluKP1+Rz6p10h11vkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6493
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/1/2023 2:37 AM, Sean Christopherson wrote:
> On Thu, Dec 08, 2022, Maxim Levitsky wrote:
>> On Thu, 2022-12-08 at 17:39 +0530, Santosh Shukla wrote:
>>>
>>> On 12/6/2022 5:44 PM, Maxim Levitsky wrote:
>>>>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>>>>> index 512b2aa21137e2..cfed6ab29c839a 100644
>>>>>> --- a/arch/x86/kvm/svm/svm.c
>>>>>> +++ b/arch/x86/kvm/svm/svm.c
>>>>>> @@ -2468,16 +2468,29 @@ static int task_switch_interception(struct kvm_vcpu *vcpu)
>>>>>>  			       has_error_code, error_code);
>>>>>>  }
>>>>>>  
>>>>>> +static void svm_disable_iret_interception(struct vcpu_svm *svm)
>>>>>> +{
>>>>>> +	if (!sev_es_guest(svm->vcpu.kvm))
>>>>>> +		svm_clr_intercept(svm, INTERCEPT_IRET);
>>>>>> +}
>>>>>> +
>>>>>> +static void svm_enable_iret_interception(struct vcpu_svm *svm)
>>>>>> +{
>>>>>> +	if (!sev_es_guest(svm->vcpu.kvm))
>>>>>> +		svm_set_intercept(svm, INTERCEPT_IRET);
>>>>>> +}
>>>>>> +
>>>>>
>>>>> nits:
>>>>> s/_iret_interception / _iret_intercept
>>>>> does that make sense?
>>>>
>>>> Makes sense.
> 
> I would rather go with svm_{clr,set}_iret_intercept().  I don't particularly like

ok.

> the SVM naming scheme, but I really dislike inconsistent naming.  If we want to
> clean up naming, I would love unify VMX and SVM nomenclature for things like this.
> 
>>>>  I can also move this to svm.h near the svm_set_intercept(), I think
>>>> it better a better place for this function there if no objections.
>>>>
>>> I think current approach is fine since function used in svm.c only. but I have
>>> no strong opinion on moving to svm.h either ways.
>>
>> I also think so, just noticed something in case there are any objections.
> 
> My vote is to keep it in svm.c unless we anticipate usage outside of svm.h.  Keeping

ok.

Thanks,
Santosh
> the implementation close to the usage makes it easer to understand what's going on,
> especially for something like this where there's a bit of "hidden" logic for SEV-ES.

