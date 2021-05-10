Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D85DD37991B
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 23:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbhEJVYs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 17:24:48 -0400
Received: from mail-mw2nam10on2066.outbound.protection.outlook.com ([40.107.94.66]:61729
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231434AbhEJVYr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 17:24:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X8IdECnFlndcEA3tpUZxBFoG/JLq5HRhQe/rIQ34q3k1fGlX3ZGpSXc+QDhsuNtJ6c1V6WwOJovz9NTjPLV3NJZ65i/TKBzpi/ztUPwvdHDHBCbg7dVyGdvt0YBmcUGIJRdMgWdBZ78riLBlq1Y7uZYRHKbfYUioZ9YbMtoEUdN/qPpwrZEVZgjwY60LK+vV4PVFqt7Y+JngafiALhiqPoXUdlWYaSQ7GmVf/oiQ/wtpHq0Ox+E0KNxU/s+DXY4y8nkgc0ReoB4W3Kj7F6hsSO025FoSFsRkUh88sfsTPmLJnkykDlNDe63x9Lr/QWE7GJRNWsAQvTALS7Fj1SeA8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xtU5ciZJ7TSySAk9rSzC5YRoT+7R5fQbsynNiiyQsmM=;
 b=dK0YOpgtLmv5egJcJs2UTfgohCnyDlq0wwonzXBq7adbV37G/xYUMWsiQUWK7ew+gi045xyyaxEenN8kHCqKhht99duxKJjHBzmPKSZOz8JiRGHLFwkGtJqSdcPIsasudtUBxHacIZcbSxnv6KqQOkaUsqxWlqatjd1hbAw6EZpfoubXzMzQPOLlQpcrs3VbXgAs36LGbFK4cNe1w5FQ7x5dPKF/oc86TqVJ+NogktufQKU1t86VVY1hA7MzEZ/Qg0LoCuJaBvqq8ntGBflic3/6+IjetTfdF+nyBdk8rHPH0RO2mN12wHM/PshKXIIE1UTGXOZ5nZOfbhn+xYuHpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xtU5ciZJ7TSySAk9rSzC5YRoT+7R5fQbsynNiiyQsmM=;
 b=2PJAf+QTUNABdtVmB+xvGm54hEa8CFJIbJWOlck2neq8CQS9vDojk7ZV+XR6LACJdMPp5qrYX4S2ymLGdSTa7uBek8SAJTW0zp3sKMrgW5IAArWNhwX0DDwDVkPoy5qoNVqLnP1ZFX2zc5zFVFO9j0vvWqVu3nue60uyfaiIo28=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4108.26; Mon, 10 May 2021 21:23:40 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4108.031; Mon, 10 May
 2021 21:23:40 +0000
Subject: Re: [PATCH 2/2] KVM: x86: Allow userspace to update tracked sregs for
 protected guests
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20210507165947.2502412-1-seanjc@google.com>
 <20210507165947.2502412-3-seanjc@google.com>
 <5f084672-5c0d-a6f3-6dcf-38dd76e0bde0@amd.com> <YJla8vpwqCxqgS8C@google.com>
 <12fe8f83-49b4-1a22-7903-84e45f16c372@amd.com> <YJmfV1sO8miqvQLM@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <26da40a0-c9b4-f517-94a6-5d3d69c4a207@amd.com>
Date:   Mon, 10 May 2021 16:23:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <YJmfV1sO8miqvQLM@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA0PR11CA0171.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::26) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA0PR11CA0171.namprd11.prod.outlook.com (2603:10b6:806:1bb::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Mon, 10 May 2021 21:23:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 248aaaba-460d-4fa5-f59e-08d913f9e1bd
X-MS-TrafficTypeDiagnostic: DM5PR12MB1163:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1163292CB736292964B513D0EC549@DM5PR12MB1163.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CGA4YSu5sZCaY8b4X5y9i9Yr7F4cdM1ECogfMy66ItGDC9jeWaJ4GECJ+70VCE/605X07GflCoQsUgO0J5Gk80tO4pLCGrv+QguZrUgO+h5/I3AoP2GKVvauOwFIMxsXQIn2woyX9DuaTxzUHwSp6LsagGIWxUyV3wipN+UXNvwf6SZRUyJnPbO1+XG4lLWAjgOkvPjTYQpZXTr0gJA+oX2h2deLnP0/TurTdJ4miUrYdVcvyWWazA/9gXHnxPNLwCljhaaMBEbvcFKh4iVKsfSRL/ZGcBvpLRmQVgVwy/TSQI/HO3toblel5k3yGDrpxcHCmFM5TdLDIOfxfL8ylVuo6vW+iEOUzTkfpoaT/kfAYs5pPg7gNh+VMFjK1uClDb///QdhL9xU2uhwSLAr7oA8u6IDDkbbgcoQVGnAzMQWdhAegCypRM5/kutGE6Jm3kzngLxmulz6YcYU9ufxxJUD4WJ1Y48Brl5/g6M0lS05aqoLA6bzKp1WjUPysLU/mqpl/GQZi1Dts+ufqsAwEXgzSxOoqCjVFxUpdZDo2DeTXEsC6Hl1X+frqrKXUUyWJMmCuB1mMCHhNLb9gnMsYAMxl0CfsEUQKYJN0N+k/HeNuXYfAiSjQ5dEIdPv4kGFmwfN2Hd+SjsTiPZ2I7bqtBnCSYK9qNHWoT9pfcj2Cq36npVUXN162LOqQIh/TY1z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(396003)(366004)(376002)(26005)(7416002)(478600001)(86362001)(36756003)(6512007)(6486002)(38100700002)(956004)(2616005)(6916009)(2906002)(53546011)(83380400001)(16526019)(54906003)(31696002)(66476007)(66556008)(66946007)(316002)(8936002)(186003)(8676002)(31686004)(15650500001)(4326008)(6506007)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bnJYZWdSWVQrTzYwaWlUKy8zNmhpTjNmWU9lcjNpM2o1RWV5WkhMRUJjYWxM?=
 =?utf-8?B?c3p2eTBZZHN1OFV3U3dLdnVsRXRxSWcrVXRRWVVaY1N2L0o4MWJXTkJnRE9o?=
 =?utf-8?B?bGt1Nkc5cTVPRUZoNU1HN0UyYnFDcmRmRTQ3WVFrL2ZzRDVESTBtMk15YlRh?=
 =?utf-8?B?SWFJUTgvQWJ2RHJGTHFFL3QrNlpCZ3JCQkQvVW9zc2J0VnVsTGNDVW5mOWxY?=
 =?utf-8?B?dFZpZE5yM2VsLzR6elgvc1IzSktkdDU1QnUvdXFLNVpkMlIxcjVOQjdDVUw3?=
 =?utf-8?B?MFBsbzEyTTRDK0xqdFV0anU3Y0hQbVRZc1hPdEFWTGlOajNOdi9WQXBrR2VR?=
 =?utf-8?B?bXhXTGU0MStTOGgxSG02eEVCU2lIdG1odGhBNGxKK2ZYSjNOMkJ4VVJMUEVR?=
 =?utf-8?B?cWM3bVM3OURHSTYvUk5jQzF6SDZxWlJ0eVVlQWVqUmxQbUx5TmJ4bytYc3RH?=
 =?utf-8?B?T09pcmhDQ3VKaUUrMFVPcjZvWDZrbzlQb0tXR0dlS09WNXhnOEwwakJISXlv?=
 =?utf-8?B?TDFEekRBZ3BzNjZrRjk2Tkt3blAxTVpKVnZlRWRDTE44Q2xUV0paeHZ5WXZl?=
 =?utf-8?B?d3JjZEZBbjV4dnB3eWxWZ24xbHErZW1LQlA4QkxLSXBCcFcwV25KYVowNC93?=
 =?utf-8?B?RkZRRzVvTXZBMWRzT29VMm41RDl5V0NSQjNSbDJYWEJycnlmbmNYMThpYzdS?=
 =?utf-8?B?SzF0TXRvYUYxS0R4bm5qOXh5Wnc2TmRnZUxmc0h4V2VTdTZLc1oxempGNk9v?=
 =?utf-8?B?elZwVC9ITko5dTNvRkVMYnRHL2xwcjE0QnRtejgzQWw4bCtpNjZYUFdybEVz?=
 =?utf-8?B?MjhhYUlEbWFSaTEyZlRubjVWS0RKcllDbzBpcHI2dmxhVW55d0FPMnVYSXpL?=
 =?utf-8?B?aUh3T3Iyb2lzcjc1Y0J3R2I0UFZrQXVuYU9hdkdRbjdMMFZVZVBoTkNEY3VK?=
 =?utf-8?B?QXdUWjJJN0xJdFA2NHlIUVIwVGZGNEtXNmxTbWtkUExxMm5NYjA1alNFWWtR?=
 =?utf-8?B?U2QrVHE5SGNjOFpjV2tVbVlaZWdwNmdtQ0U2S3pIYXUwRVhWdHA2MnZzV0h4?=
 =?utf-8?B?cVRjbUpZWGNGM2dCa0RZQXhWKzR1c1ZLck5saGhYUVk0RzRuT2RBOGJSR0k1?=
 =?utf-8?B?Z0w4bUhBSEQ2RmgxSFM2MzlpYzBjK1M3cnh1WnJJcDVpQkhFT01MNXU2bG13?=
 =?utf-8?B?dkRLVGNWcmJ0Q0NvamdvakFVVTFkYzVOT1BmcHdDSzdQOE5zREFqZjEwYkxo?=
 =?utf-8?B?YkhadHBDVGJ2NldpY3g2dmFVUFErS1JyY2Z5OGVQM3Z2NG9FWGpoWGNFZE1E?=
 =?utf-8?B?U0FBZHJWVzBvbElYSmxWMU9mL2h0dlV4a3lGV3pjTmM1TVJKWlliNlpQZXcr?=
 =?utf-8?B?c2V5Y0Y1c0l4N1RRZ2J2Rll2M3RxbGVCc05xZTduUThsN2lpNUwrdWVTWTFl?=
 =?utf-8?B?bUdDSHR5RHJyZEFYT1BqZGJnSzRSbExZeEM0aG1HNkpaMnlvbkhHVTFGaXpZ?=
 =?utf-8?B?MUQvSlEyU21jUVZ1SmJHcjRidGRadXdRbXhOek9qNmlIUGhLQTJTcDd6MGN0?=
 =?utf-8?B?bGtPNkZ6bDhJbmJzTThaRS9DcUFjdGtRWndyWHNKMUpFOVJlRWl4M0VpNEVp?=
 =?utf-8?B?bTRGZmJ6cUFoaXlZMklYY0tBR2Fib2VkYnRyN1hZQmdrYXJJRFFnYUg3c0lT?=
 =?utf-8?B?NFk5TktmRDdnMTAyLzMxb0xMRWR1dktNRHY1TS9FVlcyQkpmWUdxQXlEdTdh?=
 =?utf-8?Q?7ipaY3LB6HZOEE+DWFIL9u1u9TzQSL1kmya4VV4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 248aaaba-460d-4fa5-f59e-08d913f9e1bd
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2021 21:23:40.6752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gC3SdCKB/j1JP0AWO4wc+U+A2z62tAUG/0WM2A9MR9Vi+wns+Kmqy0qKh5hYUaVZPdSw4buKO4zeTvaz1elPWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1163
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/10/21 4:02 PM, Sean Christopherson wrote:
> On Mon, May 10, 2021, Tom Lendacky wrote:
>> On 5/10/21 11:10 AM, Sean Christopherson wrote:
>>> On Fri, May 07, 2021, Tom Lendacky wrote:
>>>> On 5/7/21 11:59 AM, Sean Christopherson wrote:
>>>>> Allow userspace to set CR0, CR4, CR8, and EFER via KVM_SET_SREGS for
>>>>> protected guests, e.g. for SEV-ES guests with an encrypted VMSA.  KVM
>>>>> tracks the aforementioned registers by trapping guest writes, and also
>>>>> exposes the values to userspace via KVM_GET_SREGS.  Skipping the regs
>>>>> in KVM_SET_SREGS prevents userspace from updating KVM's CPU model to
>>>>> match the known hardware state.
>>>>
>>>> This is very similar to the original patch I had proposed that you were
>>>> against :)
>>>
>>> I hope/think my position was that it should be unnecessary for KVM to need to
>>> know the guest's CR0/4/0 and EFER values, i.e. even the trapping is unnecessary.
>>> I was going to say I had a change of heart, as EFER.LMA in particular could
>>> still be required to identify 64-bit mode, but that's wrong; EFER.LMA only gets
>>> us long mode, the full is_64_bit_mode() needs access to cs.L, which AFAICT isn't
>>> provided by #VMGEXIT or trapping.
>>
>> Right, that one is missing. If you take a VMGEXIT that uses the GHCB, then
>> I think you can assume we're in 64-bit mode.
> 
> But that's not technically guaranteed.  The GHCB even seems to imply that there
> are scenarios where it's legal/expected to do VMGEXIT with a valid GHCB outside
> of 64-bit mode:
> 
>   However, instead of issuing a HLT instruction, the AP will issue a VMGEXIT
>   with SW_EXITCODE of 0x8000_0004 ((this implies that the GHCB was updated prior
>   to leaving 64-bit long mode).

Right, but in order to fill in the GHCB so that the hypervisor can read
it, the guest had to have been in 64-bit mode. Otherwise, whatever the
guest wrote will be seen as encrypted data and make no sense to the
hypervisor anyway.

> 
> In practice, assuming the guest is in 64-bit mode will likely work, especially
> since the MSR-based protocol is extremely limited, but ideally there should be
> stronger language in the GHCB to define the exact VMM assumptions/behaviors.
> 
> On the flip side, that assumption and the limited exposure through the MSR
> protocol means trapping CR0, CR4, and EFER is pointless.  I don't see how KVM
> can do anything useful with that information outside of VMGEXITs.  Page tables
> are encrypted and GPRs are stale; what else could KVM possibly do with
> identifying protected mode, paging, and/or 64-bit?
> 
>>> Unless I'm missing something, that means that VMGEXIT(VMMCALL) is broken since
>>> KVM will incorrectly crush (or preserve) bits 63:32 of GPRs.  I'm guessing no
>>> one has reported a bug because either (a) no one has tested a hypercall that
>>> requires bits 63:32 in a GPR or (b) the guest just happens to be in 64-bit mode
>>> when KVM_SEV_LAUNCH_UPDATE_VMSA is invoked and so the segment registers are
>>> frozen to make it appear as if the guest is perpetually in 64-bit mode.
>>
>> I don't think it's (b) since the LAUNCH_UPDATE_VMSA is done against reset-
>> state vCPUs.
>>
>>>
>>> I see that sev_es_validate_vmgexit() checks ghcb_cpl_is_valid(), but isn't that
>>> either pointless or indicative of a much, much bigger problem?  If VMGEXIT is
>>
>> It is needed for the VMMCALL exit.
>>
>>> restricted to CPL0, then the check is pointless.  If VMGEXIT isn't restricted to
>>> CPL0, then KVM has a big gaping hole that allows a malicious/broken guest
>>> userspace to crash the VM simply by executing VMGEXIT.  Since valid_bitmap is
>>> cleared during VMGEXIT handling, I don't think guest userspace can attack/corrupt
>>> the guest kernel by doing a replay attack, but it does all but guarantee a
>>> VMGEXIT at CPL>0 will be fatal since the required valid bits won't be set.
>>
>> Right, so I think some cleanup is needed there, both for the guest and the
>> hypervisor:
>>
>> - For the guest, we could just clear the valid bitmask before leaving the
>>   #VC handler/releasing the GHCB. Userspace can't update the GHCB, so any
>>   VMGEXIT from userspace would just look like a no-op with the below
>>   change to KVM.
> 
> Ah, right, the exit_code and exit infos need to be valid.
> 
>> - For KVM, instead of returning -EINVAL from sev_es_validate_vmgexit(), we
>>   return the #GP action through the GHCB and continue running the guest.
> 
> Agreed, KVM should never kill the guest in response to a bad VMGEXIT.  That
> should always be a guest decision.
> 
>>> Sadly, the APM doesn't describe the VMGEXIT behavior, nor does any of the SEV-ES
>>> documentation I have.  I assume VMGEXIT is recognized at CPL>0 since it morphs
>>> to VMMCALL when SEV-ES isn't active.
>>
>> Correct.
>>
>>>
>>> I.e. either the ghcb_cpl_is_valid() check should be nuked, or more likely KVM
>>
>> The ghcb_cpl_is_valid() is still needed to see whether the VMMCALL was
>> from userspace or not (a VMMCALL will generate a #VC).
> 
> Blech.  I get that the GHCB spec says CPL must be provided/checked for VMMCALL,
> but IMO that makes no sense whatsover.
> 
> If the guest restricts the GHCB to CPL0, then the CPL field is pointless because
> the VMGEXIT will only ever come from CPL0.  Yes, technically the guest kernel
> can proxy a VMMCALL from userspace to the host, but the guest kernel _must_ be
> the one to enforce any desired CPL checks because the VMM is untrusted, at least
> once you get to SNP.
> 
> If the guest exposes the GHCB to any CPL, then the CPL check is worthless because

The GHCB itself is not exposed to any CPL. A VMMCALL will generate a #VC.
The guest #VC handler will extract the CPL level from the context that
generated the #VC (see vc_handle_vmmcall() in arch/x86/kernel/sev-es.c),
so that a VMMCALL from userspace will have the proper CPL value in the
GHCB when the #VC handler issues the VMGEXIT instruction.

Thanks,
Tom

> guest userspace can simply lie about the CPL.  And exposing the GCHB to userspace
> completely undermines guest privilege separation since hardware doesn't provide
> the real CPL, i.e. the VMM, even it were trusted, can't determine the origin of
> the VMGEXIT.
> 
