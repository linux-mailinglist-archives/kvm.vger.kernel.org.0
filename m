Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D609788300
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 11:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239781AbjHYJHF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 05:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244222AbjHYJG6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 05:06:58 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2046.outbound.protection.outlook.com [40.107.92.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EBBD211F;
        Fri, 25 Aug 2023 02:06:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aai6LnLxzTOZ49e/h8zeQaGst1sNMqm93RZ9hRLONgoopRQdWqNOcXClnt265q2AlkO7ZlSXool9Ts/SEOx9rdDIUKYQ9c/SKcx8j47b4RgqaH2hDXBngUoHn033TVIRr+0GPkwF2qzLpDgxpYXWrk2Y06kGAV5QTtxPTlK55ZXXJx35GkuZQap2L2C67STj+Hu/nMCH5URtAX5RA6XTA+9r4OH2CmRpFCABDrdEoDZjD1hD78gtYC0WmaQeF6b0BiaofgiTShuu/bDjGQrIAWMhUAVujUpFSCUXNXpe1ZEu7TI8tLkR08ZB/O2jeTrKOhop6Mm34oPWESdUttAjLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wXde/p2Ani7U6WQdu+y0Uz903p+hEowN0iC5KmcTPi0=;
 b=dXsGxTVMxriUNOcHZgiu1eDwa3pjINQbRv3zUbDXwlz2JYMfXL2ed5Csyy8T8qoL1axYTK/D4eeoHd31Ht41hEUd8eAk9mjBUqulVJyMKQLl3txkCbtXRZty3e3vLqAx94SeTwLkK+CHCF2QvlVo/GfzUz2CsAzgBWK48K2jb5kuxoJ8PThfjGDnKMv/nekEU7VtdPYhncPmaPFAHKU2SbdDANJ66VfOwPmnDU3ueJx9YHQoONLcM6SBb9I9opjTiXY/I8JdKeYHVd+bJPPP6X6S03Jh9QJGmLh+AV+0YrW8Ob1OHAwnroO9rLFQfNgNY8QrzTh/QD6hOSfuTdhsiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wXde/p2Ani7U6WQdu+y0Uz903p+hEowN0iC5KmcTPi0=;
 b=K3HPBOZxJg5QJxSVeMO5feY1kWhnfzjVsDE+HuPWd8xRj+Uoali5lm01bb7bMgrLXiGBn5BhxBLiihzHwKGEK5xxUOe6JPrwbn4Tb9YV5Fid5NbiID7SRgRqD4XhvRskMTBKYf+jnU1jh3Jpnf2VpSQMGNZelfTeGYoNGM5iMts=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by PH7PR12MB6979.namprd12.prod.outlook.com (2603:10b6:510:1b9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.27; Fri, 25 Aug
 2023 09:06:30 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::78dd:2c9e:e2da:b32b]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::78dd:2c9e:e2da:b32b%5]) with mapi id 15.20.6699.028; Fri, 25 Aug 2023
 09:06:30 +0000
Message-ID: <cdad0a8b-0994-d2f3-7c68-e632ce4facf7@amd.com>
Date:   Fri, 25 Aug 2023 14:36:17 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: Question about AMD SVM's virtual NMI support in Linux kernel
 mainline
To:     Sean Christopherson <seanjc@google.com>
Cc:     =?UTF-8?B?6ZmI5Z+56bi/KOS5mOm4vyk=?= 
        <chenpeihong.cph@alibaba-inc.com>, mlevitsk <mlevitsk@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <67fba65c-ba2a-4681-a9bc-2a6e8f0bcb92.chenpeihong.cph@alibaba-inc.com>
 <ZOYfxgSy/SxCn0Wq@google.com> <174aa0da-0b05-a2dc-7884-4f7b57abcc37@amd.com>
 <ZOdnuDZUd4mevCqe@google.com>
Content-Language: en-US
From:   Santosh Shukla <santosh.shukla@amd.com>
In-Reply-To: <ZOdnuDZUd4mevCqe@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA1P287CA0006.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a00:35::21) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6323:EE_|PH7PR12MB6979:EE_
X-MS-Office365-Filtering-Correlation-Id: 302e88dc-0a2a-4043-8dd9-08dba54a91c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DDCsAj3x4htwjz5uSMpYiKhLhLcl50dt4w9ZWsVzTnI0CaXGdtGaSI/2I+wx/Sx7tDs2lyEWx+hrcbsvhmxNezlc5akYpEuyiIqQF+AwOs1Y+VzB1eVjgf6SM/csajNK0cB184Nh3t735CAgL/TbLJibfm3jHx0bIroc/GNJypVGVoQf4eKhQAfUqE4Sz3zyn4XjB2SEdoW5nygFf6J7zdFqzt5sjd4tYDlM594p/ryE/K9+hcU+Es5v/Tg4GtkQ44i8XVU//GQ7IEwVHVnmJBz0Ir33ZtPgRc9gnbnSyu9mzXOXHFYxV31zKG067kPyN8XG4oXIquaFX6wpSeqUTa4nNvdID0aMw1Z345GHvELEKd7RvC6Pb6DDDJJAz99d7kkv8l1IxHjbQmu2c2Wjsca+BOcHDiS9rLPzeFAHRqfTjy3T4s+WQLv7izLwBQ3/VVl/k7l+N+l5Fh4NzEo3zSrogMzu1bxcIXPcMKh8xQsZs1/brqgQV0t6fiCZWs8WV3EAdDBosOmuiK9+LlyPwuE9vO6XFp2cWBrgT3tKtj1Yu2T64PM3DZvvZCacIeOCmQhLh94rKzZicj5EUTJoSpt2PllVHtZXHofA96VMvHpZlIeqmNIbG8T+P+mjOm/UXXrDtyL0T7ju75qyPeqVbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(366004)(346002)(376002)(396003)(186009)(1800799009)(451199024)(66476007)(54906003)(66556008)(66946007)(316002)(6916009)(478600001)(26005)(38100700002)(6666004)(41300700001)(31696002)(53546011)(6506007)(86362001)(6486002)(6512007)(2906002)(966005)(31686004)(4326008)(8676002)(8936002)(83380400001)(2616005)(5660300002)(44832011)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SzdXS2FtVndYbG1idUltY3NGZnduL0FsUGVtN2Z4ZmJDZ3RJVWxVYkZxMWM3?=
 =?utf-8?B?czcycm9KN05ZZzg2WHZFemVqc0d5S1BaRElraGl1Rmplbjlwd1RIK2xVb1E3?=
 =?utf-8?B?TVhkS3VGYmFLNjZRcXRkQXZhdEc3bGl1SmZ0czVrTVRtWk5PSDZHb2xUb2hY?=
 =?utf-8?B?bUFlaGhaZzRad1RvN3lHOEI1dTdsNU83ZGZ4SlBCYjNWaTBOVmNZM0c2dFp5?=
 =?utf-8?B?aXVyZitWUndHZlB6ZFkzYmpNRGhRdkQwKzhqRUZ0eTJ2bVRVRGFmb2hsT3RM?=
 =?utf-8?B?bnZ1TkVRU2ZVWXV3NURPQ0dzWitXVVl3RDJzMVM5ZWlYMWJ5NE50NXNDN2tW?=
 =?utf-8?B?YjF1SnFhekFNbDIrTE15NFJ0bC82R1lXTGV1VVFsQnFjT3RWM2c0WTE5UFlh?=
 =?utf-8?B?ZEk3SG9ZN3o3UmhMYk51dzBGVEc4Qjd6WEZ2OUx3dHpMT2grSlhZNUYxUXFS?=
 =?utf-8?B?Zmo5ZlVxM0dWc0Vuck9aUDRLQnoraWpDK3JvbVV3aWZQaVFwVVAvbXpZZjRK?=
 =?utf-8?B?SkVNSzBwWXNieFRwUElXRlF3VGVFZjZ6TFNWQVBWeFh0UXcwQitJTFR4L0E3?=
 =?utf-8?B?QXlKZEZ5bFNhVk1qQy84NjczQUMwQXdQMFZhWGorN0ljU2pKK0FNWE9mYU9B?=
 =?utf-8?B?M1dYWlhYbUdPT3psVHhuZUVjN2xxbEVNa1F5YytJVXZyZXo2Q3RDNjBSS1Uw?=
 =?utf-8?B?MHdqL3ZCY2l6c1VYWHQwelpRYkU0VE5mZTBrcCtjYTlNdTJtZks1ejRLYmNr?=
 =?utf-8?B?ZHFFL0JZN3UrSktuTHlEZVV4RjVtbmVJdjNpbGpLSnhwcFpDSkE1ZUJBUWRX?=
 =?utf-8?B?TUkweXJSNmlSb3U5Wm51MGo1UjlmTElGNm1WZ1RZS2FZckdsSmwvaGlCVlE5?=
 =?utf-8?B?V0NHbzlFeldrZ1hzM0tSazNzYitWc1o1VXVwMWdIeklhSkxoVTFBdXZCTTRn?=
 =?utf-8?B?RTF4S21iVXlyaXNXdzM4aHQ2SDNTTUg0UkpjNkhIYVk1WTNBZTVpSFFrTG9J?=
 =?utf-8?B?eXJYQk90NFZJSDhtUmgvUExLandCTG1LVEZxM2FKcDgyK2RMWkRjY0k5T3hq?=
 =?utf-8?B?Yk9wL1RJYnRiTkVPc1h5WThXWWNkMURJbkZTRnZzalMxUUdQNTFBRlBMNW9W?=
 =?utf-8?B?MXlaVGFvZTFrVWJqS29WUzBxRFJ4STRpbWZ5U2FQT1kzeEljUWp3Nm1mWGhM?=
 =?utf-8?B?MVBwbURVQ2JUbmE3YUw0eTcyc3ZIZ0oyaCtMSlJYRE8rbDNqSU92UUcxbVR6?=
 =?utf-8?B?RlU2dGR5bVhEcGlHMTJ4aU1oNWZPbU9mem1NdlIvY1RFelZXV0RNbGJESXlu?=
 =?utf-8?B?bWFDeU5ldnIvK2tBdGs5Zlo0ZDVoNHpVaEU5MlVvRGl2d2xjRExKelV1TFVw?=
 =?utf-8?B?cVYvVGZhNGtOSmN5ZmRxazR0TEtVR0FxaVZWQmpnNUZWQS9CaUNrZUZ4Qi9G?=
 =?utf-8?B?a0h3TGV5bjBTRzFzdTh4RStSa1BEQ0VwZTU1N085R0Y3TkdtdGlmaVhSTjhW?=
 =?utf-8?B?Y05tNVFnV2JjQzhSbTJrK25JSFB6QTd4Q0ZTOVZyYUhjSC9oNW1SVDBvTkpw?=
 =?utf-8?B?Vyt0UjRJUXIyZ2lvdzJuQ0RIUDV1MWlPWS8ydXh4NWh1RGxQaEQrNG9BRTAv?=
 =?utf-8?B?bjlUaTN5YmpqYm1LT29aN25QZEYzei9zT2ZVYUlPVXYrZ3hEWnNkVm5xOTNi?=
 =?utf-8?B?ZkswbjB4K2x1TkhXcnI1RGhXS09vZTFCSk9yNXJTUmJxdDBSUytKRFBsUFdq?=
 =?utf-8?B?QmdVVlREdDhRWnVXdW9vNXI0dkIrSy9ySWtlV1BqZnlsQ0lXQjA4VFZUSlJk?=
 =?utf-8?B?Tko4Q0xPNzlORVlUaGNPaURSU1B2ZHpkZ29MaFRvbEZIS3piZmN1S0JZZVIy?=
 =?utf-8?B?T0tVNTR5Zk1wZmVLZnorZ2hnTUh1ZU5TTmZaT0djbVdDSURQTkE4SHFRQ3Rx?=
 =?utf-8?B?SysraExuUkI2d1dkSDVlbFcvMGhzV2FTNk9sUkRyNXEwK3pLWE9sVVRQdjFO?=
 =?utf-8?B?N096U2hxSFhuVTRkRFhEVllLWjFySkZxUDFBM2E5NEExU09IRGYyS3Ercm5k?=
 =?utf-8?B?empES2d1cXFDRFJXN3JjVEd5K2lBdytJVVhiSGNXTmd6YmFkUFlrQjBjWURU?=
 =?utf-8?Q?k7Wa2RSJQoXsKcG6tGgGEO0ol?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 302e88dc-0a2a-4043-8dd9-08dba54a91c2
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2023 09:06:29.9277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jEefJzQzujVY/WjXza6AGfNC0nux4Tx78qWobMgXK6NKOD49ljSeIqSqLGR3AylHDyUCBChYEcwPlN99pFkxZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6979
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,


On 8/24/2023 7:52 PM, Sean Christopherson wrote:
> +kvm and lkml, didn't realize they weren't Cc'd in the original mail.
> 
> On Thu, Aug 24, 2023, Santosh Shukla wrote:
>> Hi Sean,
>>
>> On 8/23/2023 8:33 PM, Sean Christopherson wrote:
>>> On Fri, Aug 18, 2023, 陈培鸿(乘鸿) wrote:
>>>> According to the results, I found that in the case of concurrent NMIs, some
>>>> NMIs are still injected through eventinj instead of vNMI.
>>>
>>> Key word is "some", having two NMIs arrive "simultaneously" is uncommon.  In quotes
>>> because if a vCPU is scheduled out or otherwise delayed, two NMIs can be recognized
>>> by KVM at the same time even if there was a sizeable delay between when they were
>>> sent.
>>>
>>>> Based on the above explanations, I summarize my questions as follows:
>>>> 1. According to the specification of AMD SVM vNMI, with vNMI enabled, will
>>>> some NMIs be injected through eventinj under the condition of concurrent
>>>> NMIs?
>>>
>>> Yes.
>>>
>>>> 2. If yes, what is the role of vNMI? Is it just an addition to eventinj? What
>>>> benefits is it designed to expect? Is there any benchmark data support?
>>>
>>> Manually injecting NMIs isn't problematic from a performance perspective.  KVM
>>> takes control of the vCPU, i.e. forces a VM-Exit, to pend a virtual NMI, so there's
>>> no extra VM-Exit.
>>>
>>> The value added by vNMI support is that KVM doesn't need to manually track/detect
>>> when NMIs become unblocked in the guest.  SVM doesn't provide a hardware-supported
>>> NMI-window exiting, so KVM has to intercept _and_ single-step IRET, which adds two
>>> VM-Exits for _every_ NMI when vNMI isn't available (and it's a complete mess for
>>> things like SEV-ES).
>>>
>>>> 3. If not, does it mean that the current SVM's vNMI support scheme in the
>>>> Linux mainline code is flawed? How should it be fixed?
>>>
>>> The approach as a whole isn't flawed, it's the best KVM can do given SVM's vNMI
>>> architecture and KVM's ABI with respect to "concurrent" NMIs.
>>>
>>> Hrm, though there does appear to be a bug in the injecting path.  KVM doesn't
>>> manually set V_NMI_BLOCKING_MASK, and will unnecessarily enable IRET interception
>>> when manually injecting a vNMI.  Intercepting IRET should be unnecessary because
>>> hardware will automatically accept the pending vNMI when NMIs become unblocked.
>>> And I don't see anything in the APM that suggests hardware will set V_NMI_BLOCKING_MASK
>>> when software directly injects an NMI.
>>>
>>> So I think we need:
>>>
>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>> index d381ad424554..c956a9f500a2 100644
>>> --- a/arch/x86/kvm/svm/svm.c
>>> +++ b/arch/x86/kvm/svm/svm.c
>>> @@ -3476,6 +3476,11 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
>>>         if (svm->nmi_l1_to_l2)
>>>                 return;
>>>  
>>> +       if (is_vnmi_enabled(svm)) {
>>> +               svm->vmcb->control.int_ctl |= V_NMI_BLOCKING_MASK;
>>> +               return;
>>> +       }
>>> +
>>>         svm->nmi_masked = true;
>>>         svm_set_iret_intercept(svm);
>>>         ++vcpu->stat.nmi_injections;
>>> --
>>>
>>> or if hardware does set V_NMI_BLOCKING_MASK in this case, just:
>>>
>>
>> Yes, HW does set BLOCKING_MASK when HW takes the pending vNMI event.
> 
> I'm not asking about the pending vNMI case, which is clearly spelled out in the
> APM.  I'm asking about directly injecting an NMI via:
> 
> 	svm->vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
>

Yes. This is documented in APM as well.
https://www.amd.com/system/files/TechDocs/24593.pdf : "15.21.10 NMI Virtualization"

"
If Event Injection is used to inject an NMI when NMI Virtualization is enabled,
VMRUN sets V_NMI_MASK in the guest state.
"
 
>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>> index d381ad424554..201a1a33ecd2 100644
>>> --- a/arch/x86/kvm/svm/svm.c
>>> +++ b/arch/x86/kvm/svm/svm.c
>>> @@ -3473,7 +3473,7 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
>>>  
>>>         svm->vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
>>>  
>>> -       if (svm->nmi_l1_to_l2)
>>> +       if (svm->nmi_l1_to_l2 || is_vnmi_enabled(svm))
>>>                 return;
>>>  
>>>         svm->nmi_masked = true;
>>> --
>>>
>>
>> Above proposal make sense to me, I was reviewing source code flow
>> for a scenarios when two consecutive need to me delivered to Guest.
>> Example, process_nmi will pend the first NMI and then second NMI will
>> be injected through EVTINJ, as because (kvm_x86_inject_nmi)
>> will get called and that will set the _iret_intercept. 
>>
>> With your proposal inject_nmi will be set the env_inj NMI w/o the IRET,
>> I think we could check for "is_vnmi_enabled" before the programming
>> the "evt_inj"?
> 
> No, because the whole point of this path is to directly inject an NMI when NMIs
> are NOT blocked in the guest AND there is already a pending vNMI.

I agree, Your patch looks fine.

I'll do the testing on above patch and share the test feedback.

Thanks,
Santosh
