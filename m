Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01C803572E3
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 19:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354705AbhDGRP5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 13:15:57 -0400
Received: from mail-co1nam11on2046.outbound.protection.outlook.com ([40.107.220.46]:19137
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235711AbhDGRP4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 13:15:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ChaMafGLdiBsvR6pq9/XMoW8yk3dnZS+TbnHLfVQZ9h3BTlMGrNF2PRq5s53suinrEeDyo4l2kIkGdTrDmXo1MZFfusjdhg+0AJ6WU1XvvPVLm6I23GuY12+3F4U/fMAus2sVeSTjgkKwVbOedQfE3gy2mz1ZxGBL+kHzrQq+vOVFMhHo5XKLq5xoOwKWK3GPZeyq7Vzaa6PPPYg5+GWz+WdOD2vtgXW7y5LdpLPDRSw0JQ1OLTOrw8yHpCSwt6vF1Saw3V1UwOnKmm9JesTVLGiD/B2LESPx60vjV58Zg0fJyqLr0HX10z4OzGvQNlS8zS8Tdk26lxxpQljAMVryA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jIE7sL9FFLT9fRObRVbumMc1PAJKB9uzVRuNYl2T6JI=;
 b=Vaiob9Cqc8RASyGYnGoVHM5pJT2rlzXoDbUr7HhwVw/U+PMAlAftjw1Jz4G3dC+B5iSb7Lycqm0yibhOcOf8OzjFEej/JmswC36tFMjMCh+0+e7vGcz9looiR1LMkPgjNPefQ58Yqf+hpgnXOGhrsXj/y/SVSMVPJSq4yhPZKKmNIMvjtfGT2rY9n069aNeymFpiALJmrQUdDmK4LmVwOa3hrTKQsDG55g7Hq6pXM7ODv9opLCTr/idYDTqdVnEXLthVsrpI6wAuyF2QhtWMMfCBUUA9U3EGPNfb0SC2gSmcCEAqbQWlGRwi3j4tID8mY/58VQ4Mg9r1Uwo5VfQWGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jIE7sL9FFLT9fRObRVbumMc1PAJKB9uzVRuNYl2T6JI=;
 b=KAJE09aVVBmirkFJQFTqgVKKx2vV2DxzPKNqjlb4XK2rRmgY1XQEkH46kXDgWt7z9LzAqCFh50ne1bHt6rpte0ZbnDKugSz0N43rWyqDHj/FQkhcOMjn9UWuGbB3i9ny4C3mnG8HCJQzQEcny3f2BUNAJECR0jrrevrFPFeCFh8=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB4750.namprd12.prod.outlook.com (2603:10b6:805:e3::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Wed, 7 Apr
 2021 17:15:44 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4020.017; Wed, 7 Apr 2021
 17:15:44 +0000
Cc:     brijesh.singh@amd.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, ak@linux.intel.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part1 PATCH 06/13] x86/compressed: rescinds and validate the
 memory used for the GHCB
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@alien8.de>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
 <20210324164424.28124-7-brijesh.singh@amd.com>
 <20210406103358.GL17806@zn.tnic>
 <c9f60432-2484-be1e-7b08-86dae5aa263f@amd.com>
 <20210407111604.GA25319@zn.tnic>
 <9f43f7b2-d9aa-429e-eadd-dc3ea4a34d01@amd.com>
 <205cb304-8066-5049-9952-aac930cceb24@amd.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <cda55ba3-cb74-60d2-8591-0592093c5223@amd.com>
Date:   Wed, 7 Apr 2021 12:15:42 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
In-Reply-To: <205cb304-8066-5049-9952-aac930cceb24@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN7PR04CA0031.namprd04.prod.outlook.com
 (2603:10b6:806:120::6) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN7PR04CA0031.namprd04.prod.outlook.com (2603:10b6:806:120::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Wed, 7 Apr 2021 17:15:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b92f4f1-eecf-4865-262c-08d8f9e8c76c
X-MS-TrafficTypeDiagnostic: SN6PR12MB4750:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB4750EB521FF915C007B36CA7E5759@SN6PR12MB4750.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S+vHMtW83BeceqVju2Ek8EX2KIyj4qYmUqiVLoRT7mtQaLPN3umdemHj3UDsvX+WM7mYh71HdAR4TeUO/W2+K/GOTw5uRYANki0cn4XnKWD/XDrfHFbV4u8gh7Umkkn4PGUsBf2L1e4Eksq9C/tRsRmhjzSeN+2Iuday5vo8VJBDX1bIdi5fbplOX4O4lYA7eO3zZ63X48ajC3E5/AdG2kwJFX+VGPsTO53lpXrCI5ajBvkmW+TLx5lvfSNy3i4Aq1Q9LLM4H6G1sS9TQE4qRXO6cAcXa6q0DYgbUOOcLVA1NAuILQS1SZBUVY3OIxwB/Rowx4XtwgzIyW3j6Ui2MkXovqOttLvKoYVQqOSIkCRGZimXBwYSb1biw9r+Yf6M6xEd+8oaCL5jGUJU2rNKbbS0KWQWltQVXKlVMX3aROUnUmpUuYhWMZwFzOALzK8D5gIQda/N+k9Gbp4HT1lPdu+StosMm4bBgpqYM/lnaKMfQzTZeDUP4vM0g9Ee8BIGxllbzg4Ssu4ige+FbqRRRTJu0FjCAgdYDtwH9HiXA0b+62HxwyrqvXXhIg9UjaqtfTxYOoI8AE6U71F3SXnvg26UYMb5PCSdNxTweyhFvnCXCaBgkXz12TyTs+xUtI6ZdRzrjzWavY8mqTm1wNEkOwSNBD7YrZXcRGJD+GvhFvrC1iMOcmaPrswl1l+PxgnsYN7g6Xh8fEpnsmWeaooRoL4p+stkXy5FA0d0rvdvI8xKq0K1Jf+OBRXgDs1kJmYd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(366004)(39860400002)(38350700001)(2616005)(31686004)(5660300002)(53546011)(6512007)(110136005)(316002)(956004)(36756003)(26005)(186003)(7416002)(16526019)(8936002)(6486002)(478600001)(66556008)(66476007)(86362001)(66946007)(31696002)(2906002)(83380400001)(44832011)(8676002)(52116002)(4326008)(6506007)(54906003)(38100700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cGxGMENrSGwzUEgvWmFBMG9ZSXRvaGhNVUhudXpPejlTdk1QQXU3a0Q0T0N1?=
 =?utf-8?B?VjNRd1BrbXd5aVVOWmF0NTFOQWFzck9BQ2NNaDAxYUF3SXNGZHFkK1dPZS8y?=
 =?utf-8?B?ZkZDdTQwQVZHUFlwSTRUUHpUNFRCenpWdGNXWEZsSnFsMGk4U1BxcFEveEM0?=
 =?utf-8?B?SlBXLzJCKzlzT0tvYkdpWHpzZGpUSnFsZDNmTk03V0t4ZnNtcklXVXpxbWc1?=
 =?utf-8?B?KzZPVWhZVmE3dGowbm5wY3FMZFYzV3VFUG53TGFsMEVqNGZBWWVwN0RrcXFK?=
 =?utf-8?B?RldWTWlpbTN6NkxnQzNJb2U0c2luQmxmbHo5SllsQXhCK3UydjRyWERJdjVS?=
 =?utf-8?B?UDNwbldGZDBpMExMcHdsb0ltRzdzNkhJcDE0a1NsS2RucFZaTVBxL1FkSHhx?=
 =?utf-8?B?ai9FY3RYM2NLdXlIZXlleTIxbzJNdXFPaVpEcU5jbHNESjNUdFRIcWFaRGJB?=
 =?utf-8?B?TnEyb1NDTFg3QkZLUENva2x4aDhCYmdKZ1BvZk9zZExlbGhVMkZzQU9IU3RR?=
 =?utf-8?B?YmtiY0dSb2lNMWxERUlKTWEyY3N3RUUxd3JaOGVrMHMxUkZQem1pRWxLL09H?=
 =?utf-8?B?Z0QxcU9TbUo5QW1IUkQ5QkwzRGJMbG9XSitOYUpZL0prTkR0Mm1BRFk5L0dZ?=
 =?utf-8?B?SWhrY3VmWTFMelJEazd1VStwYWJRTU1FTGlvN3JpZGRrbG9XdEFYMnNxR0V6?=
 =?utf-8?B?cUJvazU4NHpUR3c0b1hZTVN1WHJ6a25nUTN6NEowRkxFZU9KWGxkaDdSc3ha?=
 =?utf-8?B?aXZySm0weEFSTzlMWkl3aEE2eEt4UHNxOVUyRDNES3FEOFdpU2ZwbUpRUnJK?=
 =?utf-8?B?aUlPWndVcjRPQnlLNTVGUjRWemJoTE4yUUZWaFZSWUFNRktBVVhIMm9JREhq?=
 =?utf-8?B?RUdRRUEzMmtIVUh2N0h0NlI3Qi84RzRYbjE2eWFweXZaRnA4Yk5oTm9sc3E0?=
 =?utf-8?B?aHFnTDlYU0xiNTFFb25neGJ3L1pLUmJacjlqVnZycmRZMUwyRlNQdVZDeDVm?=
 =?utf-8?B?bXpHcVVWa3l2dmNjWkxneEpUTVdtVTZnU1AyRkJDQW8ydGxyUjZwOUROc2Ur?=
 =?utf-8?B?T1N3YnhHSXJ6czE0czdPUnFqYkhPcnJ1UE1LWmYvSXdkTDJCQWtvM1pEV3Ix?=
 =?utf-8?B?bmhnNzNzK2huSUlITXVoRG1tSzFteWZHQ2ZhTjZvbm9SbzB5eFJJQ0k4bEpV?=
 =?utf-8?B?ZzlNOFZaeDlpbkl2T0VBaWlqM253dnFZRC8zQnU4VGgwKzFBWi9haE5SRndP?=
 =?utf-8?B?cHlzQTRzY29zYkRtc1V4MWFOY0syWTdPTjc3RjJYNUk0ajdubHFKbGhvV2lU?=
 =?utf-8?B?MzUvUU1LQjVLSjRFUlJGN2UrUGRIMHVIRldseUdtZmxPWjhBSTRKL09TSURz?=
 =?utf-8?B?Tzhrd3ErbVRNTEdRQUhnZmt3cEN6OExyblVKSnRKek1oSTFGSWFHS3Q3OEdI?=
 =?utf-8?B?a2pOQTFFM1ZnTzVmakJnL2ZJYTVKbVRwaUNoMHFXMVdweUw1anQxaTUwVzJq?=
 =?utf-8?B?Vk1mbXFUN2RPV2VJaWtoa1ZvWVVDQ3JYdlRVbnRpRUViL2xGWGRZWVMwV1FW?=
 =?utf-8?B?c2xIRDcrR09UbnpacU9mWVBlZERaNXJPSW16ZTVuOFF0YXczOGNQOENydzQy?=
 =?utf-8?B?UW56d2hpNEllMlBIa2d0UVNDSEFWMXFBMzVuVTRBdUdrRDZBVXVwTGJ2OHND?=
 =?utf-8?B?ejZVai9GaGk3ZHhNbzhpMWMvZDZoVit6bFYwRGpxMWdNU25uMVh4bFRpbzJ6?=
 =?utf-8?Q?swNztV6If3TM0A6lrjs3yU5WA3ZkrSV6iaXBPQD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b92f4f1-eecf-4865-262c-08d8f9e8c76c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 17:15:44.8306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 447yD6rxoT1rfDFQfh9LI+AQDIBcMOLI73B0ae8LmRTEQfRiv29YKkTfJlnZo2JOJr+CpfHhqXeLem9Sjtu/EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4750
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/7/21 9:21 AM, Tom Lendacky wrote:
> On 4/7/21 8:35 AM, Brijesh Singh wrote:
>> On 4/7/21 6:16 AM, Borislav Petkov wrote:
>>> On Tue, Apr 06, 2021 at 10:47:18AM -0500, Brijesh Singh wrote:
>>>> Before the GHCB is established the caller does not need to save and
>>>> restore MSRs. The page_state_change() uses the GHCB MSR protocol and it
>>>> can be called before and after the GHCB is established hence I am saving
>>>> and restoring GHCB MSRs.
>>> I think you need to elaborate on that, maybe with an example. What the
>>> other sites using the GHCB MSR currently do is:
>>>
>>> 1. request by writing it
>>> 2. read the response
>>>
>>> None of them save and restore it.
>>>
>>> So why here?
>> GHCB provides two ways to exit from the guest to the hypervisor. The MSR
>> protocol and NAEs. The MSR protocol is generally used before the GHCB is
>> established. After the GHCB is established the guests typically uses the
>> NAEs. All of the current call sites uses the MSR protocol before the
>> GHCB is established so they do not need to save and restore the GHCB.
>> The GHCB is established on the first #VC -
>> arch/x86/boot/compressed/sev-es.c early_setup_sev_es(). The GHCB page
>> must a shared page:
>>
>> early_setup_sev_es()
>>
>>   set_page_decrypted()
>>
>>    sev_snp_set_page_shared()
>>
>> The sev_snp_set_page_shared() called before the GHCB is established.
>> While exiting from the decompression the sev_es_shutdown_ghcb() is
>> called to deinit the GHCB.
>>
>> sev_es_shutdown_ghcb()
>>
>>   set_page_encrypted()
>>
>>     sev_snp_set_page_private()
>>
>> Now that sev_snp_set_private() is called after the GHCB is established.
> I believe the current SEV-ES code always sets the GHCB address in the GHCB
> MSR before invoking VMGEXIT, so I think you're safe either way. Worth
> testing at least.


Ah, I didn;t realize that the sev_es_ghcb_hv_call() helper sets the GHCB
MSR before invoking VMGEXIT. I should be able to drop the save and
restore during the page state change. Thanks Tom.


