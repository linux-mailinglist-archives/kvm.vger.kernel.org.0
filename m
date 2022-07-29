Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B393584B53
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 07:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233974AbiG2FwP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 01:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiG2FwO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 01:52:14 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2043.outbound.protection.outlook.com [40.107.95.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242C54D4E7;
        Thu, 28 Jul 2022 22:52:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S04wK8LlXdFNRC8hPhf0US/SB2cExVSnHZpuDLI0GDc5/WCA+49QwqRMhbeR40v5+3jpso6gCKPhOwFE29R0J0rwMDkDBSP3QIzZ30CadNIg7arPA7NJMYSIZfDEAPb6NcWR3L9euKF3o7l2d/y3Rlw27g4uF/jQyozGIA5G5+Z5t/6QO6opPl3lCReJuewJc/XHnInFsXOLud6Kuiz9VmCLVcQzY69PS9pZxT3bRAGIwjPA25ADUMB9+taNI7QALIJsGt5p1g3RihTnhf5ITOScgz6Nd4BYkvmyrzrQAguAtU6vqlNIhsARdkX+ECFeGKDoRV6V/xTxURfktzm59A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sxHK1dHZLMYcxbl7E522aOESAQTc0m0SJsrxYgKSfc0=;
 b=QZq+/rTa+zkzEgQ2VZYUTzTe072mwYd8Na76jEAaMdgWom4/i/A6d5dhtKBUOqiKCGnSsDoFx79M5PvacBTLcd6nev/eyJtPDCuN9jot8wDHbWLkhqgGAfN1/0Q4yPWPeUlM6Drmf/HTt55ffqSp82KWQb9WbMkED4LwBvGNRF8yWc2wwV2Y/7bOyBLqHQTJBPkJxlLqBkyxCfi3YOnl2Gs2WycGVTieJLt6QVFSbe/UY99oWspB2AfS+thA/NrXRHCP9PL0BCFm0d9wvpFOGIeZcRxerrPQftNrdjDCfdj1cAIU6BwVRXbRUde2lLNuEBunUYybMM+EKluzxzk6QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sxHK1dHZLMYcxbl7E522aOESAQTc0m0SJsrxYgKSfc0=;
 b=biDodbtCSE97mwwK/94sQqQZRXUmw6RdXvENwOipx8Y+LAXVQHM9nXnI8MAx+yo6dKYZbpxeXjD9HlkYMnaho4YsZm98vJP3x3MVj3Gizh0km7fUQmvNi1yC3SBflpb8Kc28Kgfj4pqlAw7kTMNZLtDyyzXxnNR+d8Xj2hx2MvI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by CH0PR12MB5091.namprd12.prod.outlook.com (2603:10b6:610:be::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Fri, 29 Jul
 2022 05:52:10 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::1901:1d1e:a186:b37a]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::1901:1d1e:a186:b37a%8]) with mapi id 15.20.5482.006; Fri, 29 Jul 2022
 05:52:10 +0000
Message-ID: <20c2142a-ec88-02cf-01f2-cf7f8dfcef77@amd.com>
Date:   Fri, 29 Jul 2022 11:21:58 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCHv2 4/7] KVM: SVM: Report NMI not allowed when Guest busy
 handling VNMI
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220709134230.2397-1-santosh.shukla@amd.com>
 <20220709134230.2397-5-santosh.shukla@amd.com> <Yth5hl+RlTaa5ybj@google.com>
From:   "Shukla, Santosh" <santosh.shukla@amd.com>
In-Reply-To: <Yth5hl+RlTaa5ybj@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0038.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:22::13) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c98fa337-c0da-44f1-8525-08da71267a2b
X-MS-TrafficTypeDiagnostic: CH0PR12MB5091:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Na7m+bu8j81fquT6zEMuRLJY8P55f5TIabQPkWX4ehV5oJRz3UZxJiiy4sfLHr2xaLyw9w7EBpqtj3zOTc45apk1Ep7aVZrwOPzJ5N0cJRLO+dNaHVnscdP1zQY2TxsldW1UecaCjtBMJ5A+N9H34Ghv3hrVb4J5CSEltEej1q0nW8qJT6m+tfQwbcX83SPVkp1e7PQdjzXYlRFNVITFUTU0HJC2Pf4axA8OGR57D/44X+TmN6qTw5SN5Ok/1gS1oIDWL9R8MF49vUvImgpy0dYbiP0hgbu5kx7fIBpR3ttrf0GPxbBcNqEOXFDAtk4oyJ9QYxGBqOj8NQ01qeX7+dPQtf94HpZPqdx+OLwygFkwC4SkzMJV/2uMJPGozoB7rfY3Fl2QZELqhRSXC82Iuufqj9GOfCJhfdzWgR+oQk+/KCeyYjmLlSSuPuA2tARq+sow6uk7L/zobsiJ9sjdE9hlDp5q+PT9JeW8luOGA7rw9nOV5c7rqOjcIv5TxUwJNenEeArOipE8pailsu460QV4aeEF97Qvm0iIswgak8uv0PYhlJhRi0eKwLZ/BqH4Zu6l6dkTi3T0C6YALgNJjiKLYPv2SI8QSk7rE2PGn9NV5ZBw6c9uBWJLEElLJsCNrGHu/7uT2964E4kLyIRbV6ZWbujrDHmD9YLrNmXdNdf8huGVGq6TUTHeWUA+r0dyb/3acnPC0DkZccrZK6uVJQRnLj4azIgFOajXchcNw8VXGqZX8+FQTS4CvMKat0/McftGhO8ULB7wglQ3EbFXPvaqTQ3y0BqHwOkxZeiNwteCMgft2Y4+JvKIiaV0DYB7t+mJT96dnqoC3cb97ULgHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(39860400002)(366004)(346002)(376002)(6486002)(6666004)(36756003)(86362001)(31696002)(6506007)(2616005)(478600001)(41300700001)(53546011)(38100700002)(31686004)(316002)(6512007)(6916009)(26005)(54906003)(4326008)(8676002)(186003)(2906002)(8936002)(66556008)(66476007)(5660300002)(66946007)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YTJCbmcvMTg4ZHMwMVp0MkJoUnhzTkVsd3NGS0l1L1kxcHRObW5TRHV3bkRk?=
 =?utf-8?B?MWFyM2ZENlYwaEs5ZjU5a0xpNThMb2Q3MG54Z2QwWmx3T1Vka0JucmR0bEF1?=
 =?utf-8?B?c01nU09CWU01d0VjOWp6QVRhVDFRZTkwSitHdUpQSEFHWFZ4TVY5Z0cvUlJU?=
 =?utf-8?B?ajNJSkxNcnhCNFF0OHk0QkFmeEU0dzloWHhndWlBeFBRajlOS20xTFlXMTZI?=
 =?utf-8?B?cEt3K3NQbm56TGdkRVkxenBBbmNBMXBMVDJWSGxMMlBXWDV0SE1TTGh1NWZq?=
 =?utf-8?B?bFNBMUVFbjZnOGdUTG1oOHVTZU8wVDRoZXRBWHJLTDJrNFVhSWIvK0FYQnNW?=
 =?utf-8?B?SGxCZGI1cmovT3JRMW1HWks0cWgzZjF2Y2h2NUhuYml4anJCMG15VkhJcDQ2?=
 =?utf-8?B?NHpNbnpvRUZyc2tSVFlieHRhdkJRU21SUDdUaUJEMm5tUmFGLzJnSm02M0Vk?=
 =?utf-8?B?bnQ0RGtMbHkzZnNFbXRqV3FmSjg2RTM4b3cvbmpLVUttY3lReGJod0t6Wm9m?=
 =?utf-8?B?cnZ4RDdtY3BEc3dhMStoN0FIUGdRQzFYenFsbEhGQ2Q5d2VJREdFWDJaWWQr?=
 =?utf-8?B?NWI4MlduQnZzeVhLelpwZVJYWDROQnNwWkRLS2RsOW15MkJtWFpRd0xXR01R?=
 =?utf-8?B?TkpxQWhlR2U0dHc4MUtlWngwM0FMSTAvS2RLT0dpMDJlRGo0d1pYN0w4bTRu?=
 =?utf-8?B?d09ndmZnQUNBVm5lb25VcTVqZzZtTDhtNU5qZXpVK1hWUzE3eUZ0V1RkZzJy?=
 =?utf-8?B?bzZlT0JHQTB4OVZ0cFhmdDh5MmxtZHdnTWN5K01EWllETnhFcDJrQmx3UGJV?=
 =?utf-8?B?ZTRlZVlCNXNWRjZPRXBnOHRLZUw0MC9MbjJWTDV4N3FYZmkxR29wSGRraUFq?=
 =?utf-8?B?dFYrNXJPdU1YczhxZG1uaVNUN2hITC93ajIzdTVuaWZGY1kwMHdjWUx4U1Jq?=
 =?utf-8?B?MlIxZUo5a09hZElGbnBTYlVLb3ZEUjV3cDRKQWpkSTlyT3gyUVM2QldmbVpB?=
 =?utf-8?B?a2hmczVWa2JaajRwNVoyV0lnL2JRQ3RGSlhWSEU0akRPMWJMTnBRV1V0WThr?=
 =?utf-8?B?eDNXTjFkQytEWkFtWm9SdjZDaGl4enpweXcrWGk2MlphdGxGVyt2VzhidzIx?=
 =?utf-8?B?Q1piN1daaU5PYWlhd0l1aWJud0M4dFVOeW5Bc0sza2xVVTV3bTE4cU54K0tv?=
 =?utf-8?B?Q09EN0F4Vnhja01EbGlDQ0JOVThpbHA3aXlSbGZwL3JVVEZHSHg0Ti9YZ1hT?=
 =?utf-8?B?Q284RkF1V3MvakZvTFg4VlI0bURZRVQzNHVwaXpQVFJjcUphalM3eWFnTUVh?=
 =?utf-8?B?Z0ZaeXNzdmZWWW1kdFV1SnZEZ1kwTTVoOUlYWGZQQXVjaDFmVkU0enFYR0pk?=
 =?utf-8?B?L3YwTnB3STZPTWdCaDVxWUh6bE14Y2pNU0FEMU8xcDRRcTN1aUNDU3RHeWZO?=
 =?utf-8?B?djVJdGlxemJ1alczemw4WnRNMXU4M1pYaDdad0VuR29mSHMyVGhTcW9DSDZx?=
 =?utf-8?B?MjlNd0xXOWI4QjNnbGR2U3FkMXNLckcrdFQycExMZkQxanJMTTl1SDNKcFFC?=
 =?utf-8?B?Y2hnWDFTa01Wb2toWFhZdFR0Ym8vOFltWTZncWNQdTgrVDVPSS9vVHhBOS9C?=
 =?utf-8?B?bGl5REhRM3czRG94d0kweUk0bjB4bkdQYjhlM0lkSFZqT1N3c001aWV5YWh3?=
 =?utf-8?B?aDB3b1ZlcG15YUp1R1ZyK201SHFJUGJ3dnFUWXVtL0xmMEt2UEI4NFpLbkZN?=
 =?utf-8?B?d2UyUzlBNllHUjU5Qk1oeHE5dDlFektyeFhjUDdXOGhSZUYrQThMUU1aYTNq?=
 =?utf-8?B?QjB1WlpZdGEzRlF4Z0NKM1haM01uZzQzK2l1SmFOVW5aVGJBa0RLbnVpc2Ri?=
 =?utf-8?B?REdMSHkxei80ZkgrYTEwMmNzV09UNEdGOHVvK3FZeTB3Yy9uNWoxZ1pyTi8v?=
 =?utf-8?B?bFcwZTRmbjl3M1A3WVNyTDBnbVhaSEs1aVhId1NWY1V4eUFvYWtlK0pWTGNZ?=
 =?utf-8?B?aXYybm1Zb0NSOW9NeWpYcmkzUHJBZUh5aVAyc0Zkbmt2c2dmRHBPalJPUGhn?=
 =?utf-8?B?TVdYK1gycjNDTWFIRW84RVdPWmNKYm4rNTRMS0l3cFkwY1dUMkszb0Ztck5j?=
 =?utf-8?Q?5O/xPOu5GIw8yFT0Y1zCGFIpD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c98fa337-c0da-44f1-8525-08da71267a2b
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2022 05:52:10.1995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rtfVTDMVuMjZ/oY/HVU1MaYEr40nVVsBD5FyqEqdC+m2VdqVLqmaCPHiEl707Ttq9Cf1WWFRKsMH/cFJPnCPIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5091
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Sean,

On 7/21/2022 3:24 AM, Sean Christopherson wrote:
> On Sat, Jul 09, 2022, Santosh Shukla wrote:
>> In the VNMI case, Report NMI is not allowed when the processor set the
>> V_NMI_MASK to 1 which means the Guest is busy handling VNMI.
>>
>> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>> ---
>> v2:
>> - Moved vnmi check after is_guest_mode() in func _nmi_blocked().
>> - Removed is_vnmi_mask_set check from _enable_nmi_window().
>> as it was a redundent check.
>>
>>  arch/x86/kvm/svm/svm.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 3574e804d757..44c1f2317b45 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -3480,6 +3480,9 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
>>  	if (is_guest_mode(vcpu) && nested_exit_on_nmi(svm))
>>  		return false;
>>  
>> +	if (is_vnmi_enabled(svm) && is_vnmi_mask_set(svm))
>> +		return true;
>> +
>>  	ret = (vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK) ||
>>  	      (vcpu->arch.hflags & HF_NMI_MASK);
>>  
>> @@ -3609,6 +3612,9 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
>>  {
>>  	struct vcpu_svm *svm = to_svm(vcpu);
>>  
>> +	if (is_vnmi_enabled(svm))
>> +		return;
> 
> Ugh, is there really no way to trigger an exit when NMIs become unmasked?  Because
> if there isn't, this is broken for KVM.
> 

Yes. there is.

NMI_INTERCEPT will trigger VMEXIT when second NMI arrives while guest is busy handling first NMI.
And in that scenario, Guest will exit with V_NMI_MASK set to 1, KVM can inject pending(Second)
NMI(V_NMI=1). Guest will resume handling the first NMI, then HW will
clear the V_NMI_MASK and later HW will take the pending V_NMI in side the guest. 

I'll handle above case in v3.

Thanks,
Santosh

> On bare metal, if two NMIs arrive "simultaneously", so long as NMIs aren't blocked,
> the first NMI will be delivered and the second will be pended, i.e. software will
> see both NMIs.  And if that doesn't hold true, the window for a true collision is
> really, really tiny.
> 
> But in KVM, because a vCPU may not be run a long duration, that window becomes
> very large.  To not drop NMIs and more faithfully emulate hardware, KVM allows two
> NMIs to be _pending_.  And when that happens, KVM needs to trigger an exit when
> NMIs become unmasked _after_ the first NMI is injected.
> 
>> +
>>  	if ((vcpu->arch.hflags & (HF_NMI_MASK | HF_IRET_MASK)) == HF_NMI_MASK)
>>  		return; /* IRET will cause a vm exit */
>>  
>> -- 
>> 2.25.1
>>
