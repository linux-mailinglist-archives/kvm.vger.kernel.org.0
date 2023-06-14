Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A051172F353
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 05:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241874AbjFND6X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 23:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232012AbjFND6V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 23:58:21 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2081.outbound.protection.outlook.com [40.107.92.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA33C1A5;
        Tue, 13 Jun 2023 20:58:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZryMotZ2bVEdZCNuj4ztMj8JSobPh+o4296vx5bh6aFTmgDHU0QDDGRReAUzP9o57kRds/6eYuJ1b5sTgo+QPYoD9Ug1sDSjXfC6FS4jWgApbKzno0wmMXJ5gMLR9ELqsxfyWnlU4NYBIZZ8IvNfkg8RLehp3c08tlIlCYFeT5rGUoohNQto49cJbj//ihX0zosqaMJVwo4Vf9LuB+cYkxLQ32EOLOS+B8dcuD9A9vdkdQrS32ba/MX7zUwtQLh6dObj8CWmTpqmwnorJqwKSIlqssvfPRBUbf7jv2+DH+Oz/5zJqTuu3cNimaGHoNt1/y8Hf9RmIXluuhQxvFks9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lYT030T6zgJkCzhD7zn4nYLqEdlTW+QVufF+VaI7OvQ=;
 b=DMycyd5qqaEpa10TAjiO1EeV8zgTVTYdEymk1JHW98/xwF5v4ZdwxcJqYeJdGpg2ghkMFuW3DNXcp0vRLe2tppXg+T0qwE18MlUkKACbv3hN1DJbdsdwfriAKp3+4R5tDrxe+Mpa6zsuktZVQ4uxjdqpjm2Y4dlCavr2bScDOvJtoPXFkaUwc7XW0+yNjiCwBEwRCEa+329n8yymCBHIrl1IOKCdoBFjXDFTUYSmuzQZWGlXRI+8Ipe1xMFbeywcqcvskp09FclkR5fIZHjtpci6pUPDMJ44OrxwkakQ98jsLgAM6oPhpPLRTDG7+cy3WUTSQTt1HNETjGyOg6gsng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lYT030T6zgJkCzhD7zn4nYLqEdlTW+QVufF+VaI7OvQ=;
 b=SnoX86LGRyI8Vyw27M6IcxPlyEMSxS7p3Bm61dBKPWQojpYW5Wyws6VEfqZIAPQRF388h6xMq7EuZoIPRwAIA9nqj05vb+J+n09KTIGwkOC2LEoHujrVffflOv5AQqR32Io6FTvSvMxRa8NVw4ovWbDLIjNsyjSC/vWtziwAbt0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 CY5PR12MB6431.namprd12.prod.outlook.com (2603:10b6:930:39::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.44; Wed, 14 Jun 2023 03:58:16 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::ff22:cffa:293:5cef]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::ff22:cffa:293:5cef%3]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 03:58:16 +0000
Message-ID: <9ccc37a9-4f0b-f662-4d1a-467d18bbe48e@amd.com>
Date:   Wed, 14 Jun 2023 13:58:06 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.1
Subject: Re: [PATCH kernel v5 5/6] KVM: SEV: Enable data breakpoints in SEV-ES
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Pankaj Gupta <pankaj.gupta@amd.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Santosh Shukla <santosh.shukla@amd.com>,
        Carlos Bilbao <carlos.bilbao@amd.com>
References: <20230411125718.2297768-1-aik@amd.com>
 <20230411125718.2297768-6-aik@amd.com> <ZGv9Td4p1vtXC0Hy@google.com>
 <719a6b42-fd91-8eb4-f773-9ed98d2fdb07@amd.com> <ZGzfWQub4FQOrEtw@google.com>
 <fc82a8a7-af38-5037-1862-ba2315c4e5af@amd.com> <ZHDEkuaVjs/0kM6t@google.com>
 <64336829-60c5-afe1-81ad-91b4f354aef3@amd.com>
 <5e7c6b3d-2c69-59ca-1b9f-2459430e2643@amd.com> <ZIj5ms+DohcLyXHE@google.com>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <ZIj5ms+DohcLyXHE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5P282CA0134.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:209::19) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|CY5PR12MB6431:EE_
X-MS-Office365-Filtering-Correlation-Id: a544b33f-34ad-4b10-cbb0-08db6c8b9538
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oS4TzQbfNuGmPCJa6bbqAiiiFRvZg6SrbBMOXlrmumFSjR8TzaTm4RGHjvYSx5FoJv5FgStU/rwt9/9Jfz39Djr8VtqfWhdTw/nu1dwK5A0jnXQ+Oo8UVk5r8RYq3d8pplD/bnh0m1j5jJ1qVu1i8Xgljl4QPvsP+agPHeICyh4XEDWIkXSSu3rwuwN2Tr5N/HLUDbFGQhT8/g91uapdKM9OOf3ipQdnunWsTDB8ncPIPMKYja0+j6qQCXwQ/qwNIKXoXlaenUFsYnL0R8N7vHfJqPvYa52pt19RfhrjrRQkFys9v5uADYXbDkiQYHNsaMK9SVaHoms39BJItSo2GH7J15oSgSdDHCKZF4Z3/YlE64NldGByYm8/KS3JUYwlNZynn3cExrkxVXiCa8Tfy0LdyZUhMiRsHG3Kz3FgcCh8S4sngYzg5oIsm3kxNjRBGW4N9dXWS5TA27MH2nrcedqBpUgPXWMjb8Pi6rpOAaXX+Z9Bmk/aCWuPCvMydQ+O2L8wW0/pLBn9RXSV12LZ+G3Ky54uaWE/ccVxkUeaZt+tyv086BtI9MtVJzKP9MWeo36k31pNtFnAyb4/PYtJWDzrQHWuBzEY0G/bjm5mOTk6JIHhi16Nby8Y38ZM7QeiGjOJXv0S7nz0U3hbKM63mEhkvI/Q8/upJAhzKabpUwk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(396003)(376002)(39860400002)(136003)(451199021)(31686004)(66476007)(66556008)(66946007)(316002)(966005)(54906003)(6916009)(478600001)(4326008)(6666004)(31696002)(36756003)(6506007)(6512007)(83380400001)(26005)(186003)(53546011)(5660300002)(41300700001)(8676002)(8936002)(2906002)(6486002)(2616005)(38100700002)(45980500001)(43740500002)(299355004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dFJQc3ZzRlZ2NlFxOGg3ZjZkUk52cWR6WDkwdlVWU2haY01YVHFtUjlDR1kx?=
 =?utf-8?B?elZKaUVodVRiek5vZHJ1Y0M1U1Erc0MySng5UHRRcUNPUlo3dTBWa0tMelRl?=
 =?utf-8?B?dXBlTnZhc2k5SU5XMzFRWXB6RERROHZuTkJoOVlnWFNDbFRNNEw4UWN2M0RG?=
 =?utf-8?B?b2VRL3NxQ1dxL3JxczRURkRyQjVZZzkxUUkyTWtuSjNpTTREVmx5M3pOUnlE?=
 =?utf-8?B?ZC84L3NEQ0VxT2g3c0o0N29nSWVsMkd0eE9jeDJjWWw1RWJSTmh6L29QSXlL?=
 =?utf-8?B?Q1FkdnRUeldwTEp2MVh0RDE1bUIya1RnbEVBdjV4OTc1N1hXVS9Jb3V3blBt?=
 =?utf-8?B?TjdhM1pHMjQyMEV1Wm1IUXdmZ2lSUG5ub0c3c2NCYmtwdVZNcjdXWW9YRjlU?=
 =?utf-8?B?UmNKSS9YenA3QzFITXlKVlFYVDRJbFhRUnU1MFJsWXFvUXB3V2ZmM2taU3VW?=
 =?utf-8?B?L0J3SGowSi9iWGVWeHpaVG4zcU1YRlByQ3RvV043UWJTdTZWNVk4dVorc1pt?=
 =?utf-8?B?dFplNnR2T0Q1ZXUybzZnZ2lHbXdzRFFtVCtwRFVKU0dRYXhnZ3JWc2RITDdk?=
 =?utf-8?B?d3Y2VTZpNFZmWHYyZngrSGdGc2VsZk4ycU5oMVRLL3lNS0YvWXY3aEx1a2J2?=
 =?utf-8?B?MVVxOWxEc1pFSEdla0hXbW9TNlhUZSs2a0Z2eEtWWDVRd1ZyZk8rN0greFhQ?=
 =?utf-8?B?a0pkZ0ZNMDIxTzRiUWFudzZ2c1IyY0xDa3QwSnd6UTYva3U4VkRpdnFtLy9q?=
 =?utf-8?B?Q29qSmgzbUQ2NlVzWEFwVUVjUHQ2N0hId08wVU5MZzd0Y0JoeGE5K1hxS1g2?=
 =?utf-8?B?YzY4WkpaWCtCVzhLYUxnbDNhWmwvNlM3T1VhbzF5Q0V1dlBTbmFMK1lDcjBP?=
 =?utf-8?B?Um42Z0xxa2xUdjJRdXNiVHgzR0loekFIQ1NUeGJkelNmYkoyL2RiTWE3amtL?=
 =?utf-8?B?N2VScEFRdUVwYk83SlVFSjhkQ3dkOXUzcVBJdmdFc09yK2RyTU5oQUxYZm1U?=
 =?utf-8?B?dTM1MGJMa2tZUGlyVi9rTGxnMkpOU0JaKzlBcmMySE9GMlRWLzdrbjNteStF?=
 =?utf-8?B?MC9QOUdXb3NpV0duL3Y3L1lLYXNRL0tyZkZvSXoraGp2dGVYdDgzV2xtU2ZY?=
 =?utf-8?B?dGU0Z1Fab0xSZWY1OFFPcnRmNkVXUW1iMWt0elcyYVQrRnJidXNCcGRIL1dU?=
 =?utf-8?B?dmtKRmV3SDJvZUExR1ZpbWEyK1pTK0ZLS3k4TjdyNFJHWXdWZVNuWUhoekR2?=
 =?utf-8?B?Q0FlRldYWmpvZ3g4OVhydzhjdTFrT0tkU0lCNml5YTU1WGZLNjM1TzQrT1li?=
 =?utf-8?B?OFRJK3Arbi9jUjZjdUFlbFlIVDJMVC9CdCtnS0ROUG1tSWlTV2VJNWs0cFlF?=
 =?utf-8?B?aHFNM2tsQzUySjVtVlViWlBUaXZFTTA1Wmh1d3NuUHdydlFMZy9LRFpCc3NV?=
 =?utf-8?B?VnFRTXdiRitVZkNhNkNlSFJXMGNzd1g5amNOWEZ1cFR4Vmt4RXZ4d1J4VXJx?=
 =?utf-8?B?eUpZdU95WTVlRG9GOUFoTGY0dFpONWdBS3oxd1Q1NytPYXo0Y1hoQnZ0NmJm?=
 =?utf-8?B?T3NueitKelpuQWUzN2s1Zi9GYXpPQ2c4VEhKZ0loUXYvdjg4TEpKWmhQamlh?=
 =?utf-8?B?VU5jM0JvSk93azYycVFWSjdldzkwQnhhT25oeVlXbmNUcytJd3cwa2pCWkpB?=
 =?utf-8?B?b3VFWWR6dXQvTU5jcHk0ZmJnK1VMT0d2MVllU3hTTUl5d1JhOHhpaGZwcXUw?=
 =?utf-8?B?eFlVeU5sNmRFdTd0U3d2YWRVaGFva1hQNkIvVE9BMXQwdERNVG5DcjFqYWcr?=
 =?utf-8?B?a2kwSGo4NkZBMitORHRseDE1VE0xdm5Na3hqUVRaU1pUUmM5WUZPaUxMUXVN?=
 =?utf-8?B?WWVtSk1xSDZuVHY3YzJmdUZmKzdyWkQyNVBlamNibWxzTkx6QkZyVHRsU29G?=
 =?utf-8?B?OWhDUGxFMmpnSnlOWGFNWkg1ZUlCYWpLTEVJcmZ0eWY2eTdHSkdnMkc4YWt0?=
 =?utf-8?B?VXF1ZERnU28wMHZMWnQ3UU4vWG0zVGg4NkwveUN4NnJkcDJMZ1NFVUh5YU9U?=
 =?utf-8?B?OTcwZUVraDRjdUY0WjFlOXR5WkxiL1JYNUFnZTRVRUpraUFRdURmTitxeFgr?=
 =?utf-8?Q?q5QJ473Oj81oJ8u+AF2OL0Ee4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a544b33f-34ad-4b10-cbb0-08db6c8b9538
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 03:58:16.6724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1K2bAsKrFtFpluGk/C2xA3c5L4A0aJTlncgtq33cLtgonwJQDznWZnyCrppcbX5kfdQroq4nnKoAl1ofVKoRVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6431
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/6/23 09:19, Sean Christopherson wrote:
> On Fri, Jun 02, 2023, Alexey Kardashevskiy wrote:
>> Sean, ping?
>> =20
>> I wonder if this sev-es-not-singlestepping is a showstopper or it is alri=
> ght
>> to repost this patchset without it? Thanks,
> 
> Ah, shoot, I completely lost this in my inbox.  Sorry :-/

I saw the "OOO" message the other day and relaxed :)


>>>> Side topic, isn't there an existing bug regarding SEV-ES NMI windows?
>>>> KVM can't actually single-step an SEV-ES guest, but tries to set
>>>> RFLAGS.TF anyways.
>>> =20
>>> Why is it a "bug" and what does the patch fix? Sound to me as it is
>>> pointless and the guest won't do single stepping and instead will run
>>> till it exits somehow, what do I miss?
> 
> The bug is benign in the end, but it's still a bug.  I'm not worried about =


(unrelated) Your response's encoding broke somehow and I wonder if this 
is something I did or you did. Lore got it too:

https://lore.kernel.org/all/ZIj5ms+DohcLyXHE@google.com/


> fixing
> any behavior, but I dislike having dead, misleading code, especially for so=
> mething
> like this where both NMI virtualization and SEV-ES are already crazy comple=
> x and
> subtle.  I think it's safe to say that I've spent more time digging through=
>   SEV-ES
> and NMI virtualization than most KVM developers, and as evidenced by the nu=
> mber of
> things I got wrong below, I'm still struggling to keep track of the bigger =
> picture.
> Developers that are new to all of this need as much help as they can get.
> 
>>>> Blech, and suppressing EFER.SVME in efer_trap() is a bit gross,
>>> =20
>>> Why suppressed? svm_set_efer() sets it eventually anyway.
> 
> svm_set_efer() sets SVME in hardware, but KVM's view of the guest's value t=
> hat's
> stored in vcpu->arch.efer doesn't have SVME set.  E.g. from the guest's per=
> spective,
> EFER.SVME will have "Reserved Read As Zero" semantics.

It is not zero, why? From inside the guest, rdmsrl(MSR_EFER, efer) reads 
0x1d01 from that msr where 0x1000==(1<<_EFER_SVME),  _EFER_SVME==12.


> 
>>>> but I suppose since the GHCB doesn't allow for CLGI or STGI it's "fin=
> e".
>>> =20
>>> GHCB does not mention this, instead these are always intercepted in
>>> init_vmcb().
> 
> Right, I'm calling out that the absense of protocol support for requesting =
> CLGI
> or STGI emulation means dropping the guest's EFER.SVME is ok (though gross =
> :-) ).
> 
>>>> E.g. shouldn't KVM do this?
>>> =20
>>> It sure can and I am happy to include this into the series, the commit
>>> log is what I am struggling with :)
>>> =20
>>>> =20
>>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>>> index ca32389f3c36..4e4a49031efe 100644
>>>> --- a/arch/x86/kvm/svm/svm.c
>>>> +++ b/arch/x86/kvm/svm/svm.c
>>>> @@ -3784,6 +3784,16 @@ static void svm_enable_nmi_window(struct
>>>> kvm_vcpu *vcpu)
>>>> =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
> =BD if (svm_get_nmi_mask(vcpu) && !svm->awaiting_iret_completion)
>>>> =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
> =BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
>   return; /* IRET will cause a vm exit */
>>>> +=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD /*
>>>> +=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD * KV=
> M can't single-step SEV-ES guests and instead assumes
>>>> that IRET
>>>> +=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD * in=
>   the guest will always succeed,
>>> =20
>>> It relies on GHCB's NMI_COMPLETE (which SVM than handles is it was IRET=
> ):
>>> =20
>>>   =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD case S=
> VM_VMGEXIT_NMI_COMPLETE:
>>>   =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
> =BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD ret =3D =
> svm_invoke_exit_handler(vcpu, SVM_EXIT_IRET);
>>>   =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
> =BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD break;
> 
> Ah, right, better to say that the guest is responsible for signaling that i=
> t's
> ready to accept NMIs, which KVM handles by "emulating" IRET.
> 
>>>> i.e. clears NMI masking on the
>>>> +=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD * ne=
> xt VM-Exit.=EF=BF=BD Note, GIF is guaranteed to be '1' for
>>>> SEV-ES guests
>>>> +=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD * as=
>   the GHCB doesn't allow for CLGI or STGI (and KVM suppresses
>>>> +=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD * EF=
> ER.SVME for good measure, see efer_trap()).
>>> =20
>>> SVM KVM seems to not enforce EFER.SVME, the guest does what it wants an=
> d
>>> KVM is only told the new value via EFER_WRITE_TRAP. And "writes by
>>> SEV-ES guests to EFER.SVME are always ignored by hardware" says the APM=
> .
> 
> Ahhh, that blurb in the APM is what I'm missing.
> 
> Actually, there's a real bug here.  KVM doesn't immediately unmask NMIs in =
> response
> to NMI_COMPLETE, and instead goes through the whole awaiting_iret_completio=
> n =3D>
> svm_complete_interrupts(), which means that KVM doesn't unmask NMIs until t=
> he
> *next* VM-Exit.  Theoretically, that could be never, e.g. if the host is ti=
> ckless
> and the guest is configured to busy wait idle CPUs.
> 
> Attached patches are compile tested only.

Well, NMIs still get injected from QEMU so I guess it is a pass? Thanks,

-- 
Alexey

