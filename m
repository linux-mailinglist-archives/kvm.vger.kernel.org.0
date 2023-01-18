Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 263A5672A2D
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 22:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbjARVPx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 16:15:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbjARVPT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 16:15:19 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2138.outbound.protection.outlook.com [40.107.8.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D728F613CB
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 13:15:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mC4oMI4FngZmZ6CqiYVsdRNE6q8/8DevslaOoZxKOOHentt8PXgVktoK0m8g8zMDGwCclzJSlZU2kPQnXARSj22IFMU2W3Oz+1ryGAZ0qdNgVUrfCZAIv97HE3q0xpGSnp5bh7uv74QBHENIq+mOdvomk+b2idy1sHWcEQFAipgrTPJtTcniRVn+vLL9NLZeEGYTZHijZY35mHzOGb/nka3VNtQ65/ElXKE6LE/Sky/fm2ar2jGZbrjhmTfjb6UhTcjwcc2aZLhXJs2R330NQCTya7kJWIwBeYn8NK1sD89nx+1B24gmLgZVWnC4+w/unk1VIC5zVMm/wT9UHPtC/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=77LELvDQqGJfAgoH8+XHEMPqH5wdmuGh2rQwoSKJCKQ=;
 b=DvIVbTPhpDjF0gicOLGdV/bkMC0ds23S1vDdylH2cLimBCB2qKA5nYRzVyl/se4FQRVzK+ohxC4RJTTq+LR+GccfcsqxPhxykD8w+0BoYF5bm/wqKMmFt8cN4NmlMk8q8/SVDx4OXIEWhg23ott8xIpR5cgH08uYvwHcYQcXJ6KxfmCeAtiWxbd+0RDXWNUgDhDf8KkE+bbw5RhLHt5dqb0ZgWbIYn5lCME6f+q4NOERG0kJWDePt6c7zN/na/Dm2em1T3vezx0xCJ1U5YAKIfu8O9P2mvSJWmoxX6ugnvTxy3eHVYc1wqcv2TtK/LJ/cOFALnPn5fOdpJ3ZMxfvBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=77LELvDQqGJfAgoH8+XHEMPqH5wdmuGh2rQwoSKJCKQ=;
 b=jsWFgKsh3gHl0oq1frBt2CZL9oCOrD1iGNDgJRMEf+ZccEg5sq7G0Umt2gKV3LkrMnF+J+F4u2zBDT7EzJ/ehkFkwigi6b+lyCeqlmaDZ4CLlwJGqGXQAsZnzPxZd/KI+gRBh+RyH36my2ppgV6QBW2hwOX9YaVis1cr2d+sZgs/BE1y9N5zoH1oC7xX+ZVbOOv+F7TTjzaEbIaf8a8rQp5td9pIMllvV2HTWMDgZ3jSGkX0XFNvGJdosYPigZ1LZ1aTY621iwvtlJG7ceIjale6SJUiRhuqjBWlFFLUM+d1lYZNz4ptZqc25zcJfhN+k2tH4uFlz9dAmlMKa4x37g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=uipath.com;
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com (2603:10a6:803:b1::28)
 by GV2PR02MB8625.eurprd02.prod.outlook.com (2603:10a6:150:76::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Wed, 18 Jan
 2023 21:15:10 +0000
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::e4e:96d4:38b1:6d]) by VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::e4e:96d4:38b1:6d%7]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 21:15:10 +0000
Message-ID: <ae135ae1-191b-1d58-f12d-38694889664c@uipath.com>
Date:   Wed, 18 Jan 2023 23:15:01 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] KVM: VMX: Fix crash due to uninitialized current_vmcs
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>,
        Alexandru Matei <alexandru.matei@uipath.com>
References: <20230118141348.828-1-alexandru.matei@uipath.com>
 <Y8gT/DNwUvaDjfeW@google.com> <87bkmves2d.fsf@ovpn-194-7.brq.redhat.com>
 <Y8gclHES8KXiXHV2@google.com> <878rhzerod.fsf@ovpn-194-7.brq.redhat.com>
From:   Alexandru Matei <alexandru.matei@uipath.com>
In-Reply-To: <878rhzerod.fsf@ovpn-194-7.brq.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR0501CA0024.eurprd05.prod.outlook.com
 (2603:10a6:800:92::34) To VI1PR02MB4527.eurprd02.prod.outlook.com
 (2603:10a6:803:b1::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR02MB4527:EE_|GV2PR02MB8625:EE_
X-MS-Office365-Filtering-Correlation-Id: 05350fcf-197d-4192-63dc-08daf99914af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tNz7Mffk0LWaWEUIEcmutJ7/9NsnTV7SKwa7v9pj2Bsge0ATCbaHwgsZhhsgl3UIJzSyJo3Rac9XlvkJAxCZRSgo/97DocML+vS9cZx/96pr02nKnGaoDlimMXSSGGsykcudXYyRHiBx4sVdBqyqiMuny8oBvngR0+KNp6DTYIzIUhq02lsuduIUeh798uURnLlEpMeMcCLWbmYwxAhyJZrUXz4gDCaa7/YyE7z0LB8ZAXLAVaNlnSnuBdfW/s5kJf6Vuk6Ezx5bi380dTo0Xs3SabVIsnqk1x5X+eW2Kv/yyopWHmwuz7dF6wBtWGKv9g9bhZZj0/mB5SdV2nUUrXNScSeY+82joUvjZSTsTxAzCGiyN+YROrrlSBEx/b/TsiskvlCVI/n02S4hupP0N+zlAB5iEWyTIFK1/9aK9Ej1J9VahsrIqvuxGV4IRcti/+R1MFJAUCwusqtZypUmhwwkAUjZIQzM0BjYjsbRH7N3A1l7mks3CixY78NeSBMCG1atyovsMfeIpOtGBdGLz071USgAx0W/B/fwnM4QIkiP4eR9//4frJzw8Afiz3B9s51i0yedpCXdXvSyhSgt+wxxhu5ajFA1MvuH3qgC+ESVfY28tnhQ0w66d9F6GJ3ATJH7tyKRU0c3UBA06VTFCq988Wh8eUPlQM2bCqvpbHrkE35iMDsSaNseDzcseJZwGtzqyJ8DrQM7Un9WSEpy0nav4sCLd/ucinva0dsk1gU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4527.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(346002)(366004)(136003)(451199015)(31696002)(38100700002)(44832011)(66946007)(8936002)(66476007)(5660300002)(2906002)(66556008)(8676002)(4326008)(41300700001)(2616005)(26005)(6512007)(186003)(83380400001)(53546011)(54906003)(6666004)(110136005)(107886003)(86362001)(6486002)(478600001)(36756003)(316002)(6506007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OUszZ3k5bFMwZEl6Tm43UGNuTFZrZFdOK3Q4TmJCT2d1TjRWdGhxZ0Rza1h2?=
 =?utf-8?B?VFA1Z1ZEL3NnMTVxODAvR0RLVHEweVlCaWQxems1ajZ3YjNLRS85aXVvSzNs?=
 =?utf-8?B?eVRick4vRzlkdmJpU3kzNlh6QW92ajA4UDdUWDZOWXQ5bTMxdC9TWWw2ZjJQ?=
 =?utf-8?B?Z01GemlzY05VSkZQTEFlNEpCUkdYMXZXeXl4M1BWN3hGUUFKWnV3Q1VvYkdk?=
 =?utf-8?B?T3UvWnFpbmhEcm5IT0pOSjRNNjMvdHZ0VlpzYUJZNFlzSmhLcVA4aGdxSmFy?=
 =?utf-8?B?eFBHQUw0UTJhL3NKeVY2SW1LZUVOMVlEbVIxZWQrREZja3pzUDBzcjB3YU15?=
 =?utf-8?B?cTJhcUs3ZnV2bWJVMmpuVTVyWWxJKy8wMXhab0sra1VCY2dScFlXblBwU0h3?=
 =?utf-8?B?TWFZeFc0Q2Y3MkN2VjUzWU1Nc0R0RTFQMzRoSEZDbUVvZFp3OSs5bVhNTEtU?=
 =?utf-8?B?QUhHbk56dm50azVSeGUrdEk2ZmhBMlZISGpkNGdjQU5GK1VpVENwODArWnNY?=
 =?utf-8?B?OHJYUEJGbTJLbEJ6S3oyc0RNNSt0WGF0UUxkbTNyRGRlVlV0SURKNEtWVzgx?=
 =?utf-8?B?bGRkQnc4MDNHVzZ5MXRqSW9ZNlhib1kwbjRqWGxLUFlNa0tYRk8yRXJ4V3Bp?=
 =?utf-8?B?V0NSd3ZaTWFLQnU4eXIwaDFjc1RyaW41QVpPc1U3REhxWk9Dam5oMzBYN1FV?=
 =?utf-8?B?anlEQ0FrMVJIdU84SEhFSk96RHEwSDVBZG1PMU5oYkh6N1IxYTZqaVlzSXpo?=
 =?utf-8?B?ZmRzVDJSNjFWNXBudmhOYWtyQUE1VytlVkp0OWZkenBQQUZpT1h0VXR3QzRr?=
 =?utf-8?B?a1d6REdFbXBnNUs4TFJOZS84QURFenpib3NSa2pucC9UWFFpcG5VbklHY2xY?=
 =?utf-8?B?SFlkbTRJMDN4czRUSGlaZzNOUVA5bHNac1RxQmMwaUFld3NvM3NzTnYrSCtW?=
 =?utf-8?B?VHBNWHowa3JKV3llNk9JcjAvV0puNTV2WVlHWnVpejk1aXJyWnM2eER3K2FM?=
 =?utf-8?B?OXg3aEtkUUFhWmdGcnorYnJ2UlZVUjhkUjdTNnpkZDdqeDBkVDlDSnBPNUJq?=
 =?utf-8?B?L0VxMTVuck9aK1AxZGtlSTRRUS9yZ2QzaFJkNkhUL2kySDI0Z00yeCtyNml6?=
 =?utf-8?B?b0pIa2JhaUgrang0c1plSUxIT05pQThVL25jUHhyWlQ2eG1zRm9wQnFLSUJm?=
 =?utf-8?B?dmRkNGFSQjNsVEUyQVgremc0b2kwR0lvOWNvTlR5WVUyUkxOek03U2lGSVVC?=
 =?utf-8?B?ZkE0eURCVFN3OFh3cWxZbFEyOHI0aHp6Z21WSXVIQmpZcU1YbzJPK0dQL2pK?=
 =?utf-8?B?aHdwMXNhQnZHV2c1ZFRRRDhSYTJLUTVnaWRONGxMUGJCY1VsM2IwMnpkSllz?=
 =?utf-8?B?YytsVWdkSTZiMFZIUTg1S2lzaTNrVC9DdkNOYnFMV1h3b3FrMVFZSEpJWVRs?=
 =?utf-8?B?S1RYZ2k2SVlXMStrTFo3QWFyNnlaZVdQSUMvWWFES1pvd2RGZURYdS9aU3kw?=
 =?utf-8?B?TlNpcjcxdk9nWGpxZWdvbjBGbWdJTlY2MkdwQXY4ald0eXJPZDVuY1ZYNWN5?=
 =?utf-8?B?djhoVjhjSWtERTJ2Z290VlZ0OHp4dmFPaVZxRDVsd0R3ZlBVNk0wWGdPR0xE?=
 =?utf-8?B?a1pnRXNaOUptZzV0N2tnbEZLcFRhb2pyVUtuUFVsVUFPUUNmbTl6cWkvNm5F?=
 =?utf-8?B?N0o3cm1MVHNXUDhweklEUWdXYitWTThIZkNWaTk3bUZzRnhVZUZvQysyaUlt?=
 =?utf-8?B?K2NPRFZOdG9Td1k0R29CaHlpL2FMRHdKQ3V5MzBkaUROcXVtN1dBdmYrTVVY?=
 =?utf-8?B?K3Ivbmh6eVFOekFEaXo0Q0hhK2lpcktCVmFudm1TZ1NYUVU2NnJDUVBDblVH?=
 =?utf-8?B?b1NIdWg5NFRFcGFndDl3WE5Oci84NVRabEpBWldGU0JWY3JsSXpWa1RvRnRK?=
 =?utf-8?B?bVVOWFQzZ21LUWIvbm9ybkF0N0dOUm1sNHJXd2c1OG12UnRvNEZCK2NwTjV0?=
 =?utf-8?B?cnlhR1ZralpkWGNkWkllQ1hRcW5JaEtZcXA4YW1QZTMydXdnYjBtWkRLb0N3?=
 =?utf-8?B?cUdYMlYwVWp4b0JBY3dKWEt2UXZtWFdRd3kxUXdDYzhYY3NnQTFjcTZyNTho?=
 =?utf-8?B?WFo5Tm5QWjBSZDMyVnFFLzlvVjAyQUNpL2g4b1JER21tVlpTN1NUeWx2dVR2?=
 =?utf-8?B?RXc9PQ==?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05350fcf-197d-4192-63dc-08daf99914af
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 21:15:10.0885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rYT7vkjCQG7fAeVOHL0e6UAPrWazhHQt8bM8nvgLngrM0R7VjIlM6LtAp7Dsde2rDjwscQ35NZVWXPlpvttbm09SKAv7pLEnBNa0Nd7ZIpg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR02MB8625
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/18/2023 6:25 PM, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
>> On Wed, Jan 18, 2023, Vitaly Kuznetsov wrote:
>>> Sean Christopherson <seanjc@google.com> writes:
>>>
>>>> On Wed, Jan 18, 2023, Alexandru Matei wrote:
>>>>> KVM enables 'Enlightened VMCS' and 'Enlightened MSR Bitmap' when running as
>>>>> a nested hypervisor on top of Hyper-V. When MSR bitmap is updated,
>>>>> evmcs_touch_msr_bitmap function uses current_vmcs per-cpu variable to mark
>>>>> that the msr bitmap was changed.
>>>>>
>>>>> vmx_vcpu_create() modifies the msr bitmap via vmx_disable_intercept_for_msr
>>>>> -> vmx_msr_bitmap_l01_changed which in the end calls this function. The
>>>>> function checks for current_vmcs if it is null but the check is
>>>>> insufficient because current_vmcs is not initialized. Because of this, the
>>>>> code might incorrectly write to the structure pointed by current_vmcs value
>>>>> left by another task. Preemption is not disabled so the current task can
>>>>> also be preempted and moved to another CPU while current_vmcs is accessed
>>>>> multiple times from evmcs_touch_msr_bitmap() which leads to crash.
>>>>>
>>>>> To fix this problem, this patch moves vmx_disable_intercept_for_msr calls
>>>>> before init_vmcs call in __vmx_vcpu_reset(), as ->vcpu_reset() is invoked
>>>>> after the vCPU is properly loaded via ->vcpu_load() and current_vmcs is
>>>>> initialized.
>>>>
>>>> IMO, moving the calls is a band-aid and doesn't address the underlying bug.  I
>>>> don't see any reason why the Hyper-V code should use a per-cpu pointer in this
>>>> case.  It makes sense when replacing VMX sequences that operate on the VMCS, e.g.
>>>> VMREAD, VMWRITE, etc., but for operations that aren't direct replacements for VMX
>>>> instructions I think we should have a rule that Hyper-V isn't allowed to touch the
>>>> per-cpu pointer.
>>>>
>>>> E.g. in this case it's trivial to pass down the target (completely untested).
>>>>
>>>> Vitaly?
>>>
>>> Mid-air collision detected) I've just suggested a very similar approach
>>> but instead of 'vmx->vmcs01.vmcs' I've suggested using
>>> 'vmx->loaded_vmcs->vmcs': in case we're running L2 and loaded VMCS is
>>> 'vmcs02', I think we still need to touch the clean field indicating that
>>> MSR-Bitmap has changed. Equally untested :-)
>>
>> Three reasons to use vmcs01 directly:
>>
>>   1. I don't want to require loaded_vmcs to be set.  E.g. in the problematic
>>      flows, this 
>>
>> 	vmx->loaded_vmcs = &vmx->vmcs01;
>>
>>      comes after the calls to vmx_disable_intercept_for_msr().
>>
>>   2. KVM on Hyper-V doesn't use the bitmaps for L2 (evmcs02):
>>
>> 	/*
>> 	 * Use Hyper-V 'Enlightened MSR Bitmap' feature when KVM runs as a
>> 	 * nested (L1) hypervisor and Hyper-V in L0 supports it. Enable the
>> 	 * feature only for vmcs01, KVM currently isn't equipped to realize any
>> 	 * performance benefits from enabling it for vmcs02.
>> 	 */
>> 	if (IS_ENABLED(CONFIG_HYPERV) && static_branch_unlikely(&enable_evmcs) &&
>> 	    (ms_hyperv.nested_features & HV_X64_NESTED_MSR_BITMAP)) {
>> 		struct hv_enlightened_vmcs *evmcs = (void *)vmx->vmcs01.vmcs;
>>
>> 		evmcs->hv_enlightenments_control.msr_bitmap = 1;
>> 	}
> 
> Oh, indeed, I've forgotten this. I'm fine with 'vmx->vmcs01' then but
> let's leave a comment (which I've going to also forget about, but still)
> that eMSR bitmap is an L1-only feature.
> 
>>
>>   3. KVM's manipulation of MSR bitmaps typically happens _only_ for vmcs01,
>>      e.g. the caller is vmx_msr_bitmap_l01_changed().  The nested case is a 
>>      special snowflake.
>>
> 

Thanks Sean and Vitaly for your insights and suggestions. I'll redo the patch 
using your code Sean if it's ok with you and run the tests again.
