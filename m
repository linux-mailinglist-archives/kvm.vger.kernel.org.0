Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C03F17861A5
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 22:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236462AbjHWUhE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 16:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236431AbjHWUgc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 16:36:32 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2071.outbound.protection.outlook.com [40.107.220.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F9E10D3;
        Wed, 23 Aug 2023 13:36:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fozbWuruEiC8rK9YTzsj9huoOreuVEpLCj9fK0TQoIUt7QUDFgWUGNx49U7p5sSzGe0svfVxOiQBNsqKvSPmd3ZlF8ypjeA1DpiCefnZww/NsVj7sBdP7rm2SgwO+vFiGvatyqhjQ96BGqk8zULn8HDKzwIMrlZYtL9MDB5RVIWekjS3QLgF4gnbqIBwVaDv1lveHU2fGwyBQA4pNy4qt63jQB0gEw4lAdTvoz0SiqRAMIeQZe8sueKxuP5PEMA1B6Q++DOnJL0mDHBgOctWfPXDuWJ9L+yRLjfFtpxWlEJ0LxKs+YjIT6lv1+asarTbokVzk/L/KLt5ZZ5b9UxUCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H3dukAcHOGIDZPr9kF0lCKa2a7C3p4kIk0sRiWZFPdI=;
 b=HaOdyjNJ8f9kxVfiwbZ2LaiiF7f6ysWNBttzrR5tylU+DxhrfyM6bgiw+aETGIlaejXZmTccv0fSLB8RnnZcnS4c3mHskmP9KRlMZbLi/KDXjPJdbuCMgbNKjEgy0AyD5MNIwcKrb9AYS1VQBkwvBY6WEB9NCPYCkbHJG7O1xiA9dB+Im/QHzdpF5LTHFb/3o2lFzb9wPhrQNvd5S4YKAvypOvJ8lCtIk7FX0NYUDXJtLGP1kL7G9RRDFUPx8w8WiakMzrUKPgHVOMVMMdqKlJOxpfV0OQK0hheDDDXiMfHO0yhiTEsxm7dRJRxLY4aPMraI5CptmmMAC7t3W2GzbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H3dukAcHOGIDZPr9kF0lCKa2a7C3p4kIk0sRiWZFPdI=;
 b=g6x59ygMMrsnQ3V6vm54ZEQPFERDVAXm8NORiKcdQm67aHIrVaoyUnjQxTArfpPptmuQPVcY4DZc+LGVmGA6/qM2Y1R60QNNHYcLNv7B/Pohp5RQiS9L5/kNCQ2bAOL8hCDg2ikWdwC6d5OxYq2pRHkGlgpX5PYVpmciTeTRZ6Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by MN6PR12MB8568.namprd12.prod.outlook.com (2603:10b6:208:471::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.26; Wed, 23 Aug
 2023 20:36:27 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd%7]) with mapi id 15.20.6699.026; Wed, 23 Aug 2023
 20:36:27 +0000
Message-ID: <bc6a9c1f-d41e-ef81-3029-04c2938b300c@amd.com>
Date:   Wed, 23 Aug 2023 15:36:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 0/2] KVM: SVM: Fix unexpected #UD on INT3 in SEV guests
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wu Zongyo <wuzongyo@mail.ustc.edu.cn>
References: <20230810234919.145474-1-seanjc@google.com>
 <bf3af7eb-f4ce-b733-08d4-6ab7f106d6e6@amd.com> <ZOTQ6izCUfrBh2oj@google.com>
 <d183c3f2-d94d-5f22-184d-eab80f9d0fe8@amd.com> <ZOZmFe7MT7zwrf/c@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <ZOZmFe7MT7zwrf/c@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR07CA0049.namprd07.prod.outlook.com
 (2603:10b6:5:74::26) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|MN6PR12MB8568:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b6c7edb-0327-437b-09ce-08dba4189fb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2N0Vg3C9tSEhDzZfh2Va6ugSgdMmcsKQ2FI6ujAH2SXiD32Zfk5Vubi+xXZmzLdjHxVaynCXHkprPsGLu27P+o2iKwiZDtGnW2PAUSOUYXXHRO5pzpI0/p7lumq1jKwtKbOenhiT7UvazxaTn3JgMbMGdmHQN+erSFWD8p4ezd+CbH3iAM3S8riPKScwgJoG+iRUaipgXUGiCzxSx8MMpbcjqkCgIp54ZGdwsv2DlK5NEln6kprgnHPCnVnE5F80yVCs34uKRBW8DscjykiW3LUWRTICqoTwhBM/bmpxySly3XTKWYO7QolGUMLgYS/Dyk4zreerf3xV9k5qry5eb5rmI8zSrRsw7Az1EIRJIJQ0t0uBnIJfrWEFMr5sVL93eHA2Rhzm9AB6K4+kGn/1PMQ1p5WPAl1sKJxO2y7mq9xhVua9OgfRFUTZzgxdqxClvImZafEj9P/AtVDlCKnlHmXO3SclGlOnNHjXRKC0Zru8ZcPX+Z9APSF6bDUxHcXqtqoKV0DdmKCS6C5BOZBfKI4ulJcPRDXpPJwExrzHGsGwBOOT2gcw/tq8+hjrvUSjNgX/wiyxdv8D/xTxhzIdOF00xTODzjKKVnaaO+HPXQ+1/XBROBKhL1Au4GlmsnDk+aBIfsqMVHfUAf7M7XzL8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(366004)(396003)(376002)(39860400002)(1800799009)(186009)(451199024)(5660300002)(36756003)(83380400001)(2906002)(38100700002)(31696002)(86362001)(41300700001)(6512007)(66556008)(66476007)(66946007)(54906003)(6486002)(6506007)(6916009)(316002)(2616005)(4326008)(8676002)(8936002)(53546011)(478600001)(31686004)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?endjZ0ozRXJLSXNsK3djN1Y0eVVxVVZOdDFzbUs2VWZZdU03RFhONHNaaXEw?=
 =?utf-8?B?ZkpHYmVsOG96SjB6RjNGRDdIeWY3aERNZTJORHpnY3QrYkY2T092UEtlUWc3?=
 =?utf-8?B?S1ljdWZYOUtTdjdwU1M2UUl5Q0ZibWw3aTlXcGlQSzduOGI0Y0ZVSmp3Lytq?=
 =?utf-8?B?Z0xyQTJXRUhjWURXc2F5Zzg3Z3dweFZBcGIxaVhtSEp5ODdXOWk4Wnc3VWlV?=
 =?utf-8?B?Sjd3TEZEenJQM2t5bVJiSlhzc05MR2pCTVI5RG1jWFJwV24xcVExUUo3amgr?=
 =?utf-8?B?NTBFSUhxa1laNUFRL0ZFN25BU0pnSHF1R1duckZaaFkrbndNVXpObTRjcE1t?=
 =?utf-8?B?RlpVVTkyREVEdmFmQ1FOeWtoKzV4a2JtS1UwK1UzMnJXVHNpMFdXNmw0UWhR?=
 =?utf-8?B?ektrYlVZa2QvUG9ITW1aYmt4aWljR0craGZhNHZ4WTlERGI1ak5ZYWNPUVc0?=
 =?utf-8?B?OVJ2aUFrNWNKY3JmbnJuTEgzdTIrcGRReWJDeFFEZVEzVG1BcTY2bGV1Wm41?=
 =?utf-8?B?R2p2c2s3Zm5SU2Z0WmswQnR6dGx3VHA0NVlZT25OSGdZQ2dLTEtSQ3Rabi94?=
 =?utf-8?B?NEVwME9VdGJxV3JoTHlDUDRUVkk2UmZPWDJ4dVU1WTVEcWp1OXc4NjJWb1h1?=
 =?utf-8?B?ajEwZlZjQXB5UDVDd1Z0dHFPNmZNKzRDS1ExVG9QSGtlZ3hBM1NQc3cxbVVY?=
 =?utf-8?B?bEM0UHFEN3lPNzkyMlNscEFwZm9Idm9WUW41bzF6NCtwMHBWbmZSL2JiNjV4?=
 =?utf-8?B?YXM4dHFycmR1RTBzZU5mTWxZSURjbVlzaCtHRC91YVI3clZ1L0pieUNWOVdU?=
 =?utf-8?B?WHpibEZuSjMxS2JEb0cza1BFWGx5dlp0SFlnNmlVYlRCY1lMNnBTWUVBYkxR?=
 =?utf-8?B?SlVnazFzazkzYnRIbFh3OUpqQ0kzekx2ZENGK3dmQlBjRXFtNU1HcFcwNWxW?=
 =?utf-8?B?ejQ3cHBBbGlYLzFic3UycUhPejVHOVBLLzM4Uk1YRGJYQUcvbmlSaGI1bjl4?=
 =?utf-8?B?VlJMZndYa3JabjFLeHBRcElIRlZkV21MYWtYeEFsSm5BRUdRNDZWQm85ZWdz?=
 =?utf-8?B?V2s1dEpuZFlSQmk2YzFQL2RVZ2VJUUxUNTFBN05QdnZTMkdxWjFIWHFpejhl?=
 =?utf-8?B?RFJ0SjgrWUFQOUJTM0lkeGhwdnhlTnh2SzJreENjb21LQkZ5VVNsRUpZNWV3?=
 =?utf-8?B?U3NPdi9rc2Y1WFEyVWFweGxLMnpISUQyQXI5MTNQUW1xbmN5aTNPQy9ZUUFZ?=
 =?utf-8?B?UDZ4ODJENWVZMUExbGVzZzBDTlE1bVJFSmFTeEl2bWo2SjVaQUJuV2lnRnlS?=
 =?utf-8?B?NjFBV3k4cURwTWZpQlNJZWxsUXEzb2NhSkM0MWxNR3kxTFdtSWtQYzd6TFpR?=
 =?utf-8?B?V3JpTVNRdXBTRnBoSFJ6bXJ5djNGdEtIT1RXM1lnZXN4M2ZJN21uVlZPNW5Q?=
 =?utf-8?B?VVh0cWp6NzhaZnZCUXAwN051ZTI2akJUeUgyUEtlcVQ3TnhJOTcrcVBuVFRn?=
 =?utf-8?B?bUlHUEFzOUU5RStNRzZLY2xiUEdleG1tazcxdGQzb0dvTmZLWVpKK0psZS80?=
 =?utf-8?B?Rk9aemt6bnZsZHhNYytZMDNCT3EwNTh2a1J1Z1Uza3FyL3NMeEhLVHRKRlY2?=
 =?utf-8?B?bjUwUFpkd3VET282NytQUlFjZEhPaWhpSEpGbGRnK0xEN1ZJNmZXNXZlK2t0?=
 =?utf-8?B?SllVMHh1UGlWNGJKNnFsVm8vZi95Q2U3emd0Mm9CbERLdUY1QmRydi8vVWY3?=
 =?utf-8?B?ZVZXZlVGRmcwNVdDZzZyTElMbFNIa1kvM3FoRnVlRWZPWG56bkZobGVUUSt5?=
 =?utf-8?B?dHRGYXJmVWJWTXNaK1VOak9QYUY4dWhSOUFwbENsSzFZMzBobkRyR2lwZm5h?=
 =?utf-8?B?dWZJaytiYmx5aDVnL0x2YW44MFhWalF5MzIrK3E3Y3oyT2lab1o5WnRjbXdx?=
 =?utf-8?B?NVBQamNPVTE5SjBYbkpLbmFQUVJXcDNKSkJUR2pScnBwVXZoUVpQNlJoTUZk?=
 =?utf-8?B?WFFZSjhvVUdOdDdkbjlYUFFOeUFZVGVWTkpMZlpHWmVnVEJBT3VUMjAyaVRH?=
 =?utf-8?B?anJ0eG9Qc1hPcnBSc2hKL09Oc1BOcWlvR3FKWFN3VzdLWC9RaUZPdzdBL2Nu?=
 =?utf-8?Q?OD1BJ7ZIz5Sg0uIAvJ4+FLUce?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b6c7edb-0327-437b-09ce-08dba4189fb2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2023 20:36:26.9969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J2DrajSHWAUQZYzVa6ozufrE3QFhTcwjXN2k5QTNrYvpw5gPPsZ8UuuaEOz1hg9QuA3hLtPBraekO4S4alftug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8568
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/23/23 15:03, Sean Christopherson wrote:
> On Wed, Aug 23, 2023, Tom Lendacky wrote:
>> On 8/22/23 10:14, Sean Christopherson wrote:
>>> On Tue, Aug 22, 2023, Tom Lendacky wrote:
>>>> On 8/10/23 18:49, Sean Christopherson wrote:
>>>>> Fix a bug where KVM injects a bogus #UD for SEV guests when trying to skip
>>>>> an INT3 as part of re-injecting the associated #BP that got kinda sorta
>>>>> intercepted due to a #NPF occuring while vectoring/delivering the #BP.
>>>>>
>>>>> I haven't actually confirmed that patch 1 fixes the bug, as it's a
>>>>> different change than what I originally proposed.  I'm 99% certain it will
>>>>> work, but I definitely need verification that it fixes the problem
>>>>>
>>>>> Patch 2 is a tangentially related cleanup to make NRIPS a requirement for
>>>>> enabling SEV, e.g. so that we don't ever get "bug" reports of SEV guests
>>>>> not working when NRIPS is disabled.
>>>>>
>>>>> Sean Christopherson (2):
>>>>>      KVM: SVM: Don't inject #UD if KVM attempts emulation of SEV guest w/o
>>>>>        insn
>>>>>      KVM: SVM: Require nrips support for SEV guests (and beyond)
>>>>>
>>>>>     arch/x86/kvm/svm/sev.c |  2 +-
>>>>>     arch/x86/kvm/svm/svm.c | 37 ++++++++++++++++++++-----------------
>>>>>     arch/x86/kvm/svm/svm.h |  1 +
>>>>>     3 files changed, 22 insertions(+), 18 deletions(-)
>>>>
>>>> We ran some stress tests against a version of the kernel without this fix
>>>> and we're able to reproduce the issue, but not reliably, after a few hours.
>>>> With this patch, it has not reproduced after running for a week.
>>>>
>>>> Not as reliable a scenario as the original reporter, but this looks like it
>>>> resolves the issue.
>>>
>>> Thanks Tom!  I'll apply this for v6.6, that'll give us plenty of time to change
>>> course if necessary.
>>
>> I may have spoke to soon...  When the #UD was triggered it was here:
>>
>> [    0.118524] Spectre V2 : Enabling Restricted Speculation for firmware calls
>> [    0.118524] Spectre V2 : mitigation: Enabling conditional Indirect Branch Prediction Barrier
>> [    0.118524] Speculative Store Bypass: Mitigation: Speculative Store Bypass disabled via prctl
>> [    0.118524] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
>> [    0.118524] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.2.2-amdsos-build50-ubuntu-20.04+ #1
>> [    0.118524] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>> [    0.118524] RIP: 0010:int3_selftest_ip+0x0/0x60
>> [    0.118524] Code: b9 25 05 00 00 48 c7 c2 e8 7c 80 b0 48 c7 c6 fe 1c d3 b0 48 c7 c7 f0 7d da b0 e8 4c 2c 0b ff e8 75 da 15 ff 0f 0b 48 8d 7d f4 <cc> 90 90 90 90 83 7d f4 01 74 2f 80 3d 39 7f a8 00 00 74 24 b9 34
>>
>>
>> Now (after about a week) we've encountered a hang here:
>>
>> [    0.106216] Spectre V2 : Enabling Restricted Speculation for firmware calls
>> [    0.106216] Spectre V2 : mitigation: Enabling conditional Indirect Branch Prediction Barrier
>> [    0.106216] Speculative Store Bypass: Mitigation: Speculative Store Bypass disabled via prctl
>>
>> It is in the very same spot and so I wonder if the return false (without
>> queuing a #UD) is causing an infinite loop here that appears as a guest
>> hang. Whereas, we have some systems running the first patch that you
>> created that have not hit this hang.
>>
>> But I'm not sure why or how this patch could cause the guest hang. I
>> would think that the retry of the instruction would resolve everything
>> and the guest would continue. Unfortunately, the guest was killed, so I'll
>> try to reproduce and get a dump or trace points of the VM to see what is
>> going on.
> 
> Gah, it's because x86_emulate_instruction() returns '1' and not '0' when
> svm_can_emulate_instruction() returns false.  svm_update_soft_interrupt_rip()
> would then continue with the injection, i.e. inject #BP on the INT3 RIP, not on
> the RIP following the INT3, which would cause this check to fail
> 
> 	if (regs->ip - INT3_INSN_SIZE != selftest)
> 		return NOTIFY_DONE;
> 
> and eventually send do_trap_no_signal() to die().

Thanks for figuring that out so quickly!

> 
> I distinctly remember seeing the return value problem when writing the patch, but
> missed that it would result in KVM injecting the unexpected #BP.
> 
> I punted on trying to properly fix this by having can_emulate_instruction()
> differentiate between "retry insn" and "inject exception", because that change
> is painfully invasive and I though I could get away with the simple fix.  Drat.
> 
> I think the best option is to add a "temporary" patch so that the fix for @stable
> is short, sweet, and safe, and then do the can_emulate_instruction() cleanup that
> I was avoiding.
> 
> E.g. this as patch 2/4 (or maybe 2/5) of this series:

2/4 or 2/5? Do you mean 2/3 since there were only 2 patches in the series?

I'll apply the below patch in between patches 1 and 2 and re-test. Should 
have results in a week :)

Thanks,
Tom

> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 7cb5ef5835c2..8457a36b44c1 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -364,6 +364,8 @@ static void svm_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
>                  svm->vmcb->control.int_state |= SVM_INTERRUPT_SHADOW_MASK;
>   
>   }
> +static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
> +                                       void *insn, int insn_len);
>   
>   static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
>                                             bool commit_side_effects)
> @@ -384,6 +386,14 @@ static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
>          }
>   
>          if (!svm->next_rip) {
> +               /*
> +                * FIXME: Drop this when kvm_emulate_instruction() does the
> +                * right thing and treats "can't emulate" as outright failure
> +                * for EMULTYPE_SKIP.
> +                */
> +               if (!svm_can_emulate_instruction(vcpu, EMULTYPE_SKIP, NULL, 0))
> +                       return 0;
> +
>                  if (unlikely(!commit_side_effects))
>                          old_rflags = svm->vmcb->save.rflags;
