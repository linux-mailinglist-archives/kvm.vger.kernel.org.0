Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B388138B8B5
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 23:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbhETVFp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 17:05:45 -0400
Received: from mail-bn8nam08on2081.outbound.protection.outlook.com ([40.107.100.81]:40385
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229786AbhETVFn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 17:05:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XxvR4xc79/nESrYNsqAPim+uUL07ppQW54ByPRykhO//Te1SHCrWPftubzpYVHWQOjYnJiY405VtOjBsHe1/LkUHlD13troy6wEXhBUT1IP24sE8uwLGXi/AUDbbDYh5b+zt82kzqDUPG6aUmq/kEOQBfZqtZCQOJOEvvUgHaexoKC3MmofXerAXnwClDwSmwvxct9f3rMLoC55hWG9PmTRAKOgycF8PtuD1rPdpufghmgAT8rmq2IYbpTfwbB1vdimgS/eO/D4lVXiBPmeGbpcR5l04aKAS6BFLc/yvBx2iVAS+OWJpROmQWPKVrrX1IUX+gNbX6THJb7DRe3iVaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ruSa2mHq5k+sTvwXEwxC10Q5jUzmpxOswgvEzAWgI/w=;
 b=Yw8oQetf1rm9rKJfuneiZQ3h6xm3NrOhJfmszi13sqxc4LqMu5Ct861Z7s26Hu6J6Wc7XIg/BDvBMFLzPFpWWt0wvRd0e6bQmkoNLjyq1HdEhlSA7pcqet9bbu7sSJGR2uXyA8+pepPUp+F4KOsoYIyOecPzSHAJEo9YG2Xv1Jwk6qwjcUMBp6pe/vjL1r1dYuaRNdaJEizm9f5eC593pODZP72UiS27amIymtqwt30aim1lhBkgzGfw6TA+LIoOdH8uNm/H8PS/IeeUqxJrwz7I7+kRdjQ0LkEqqwAj2ojpMMwqje4qnCnbijP8pEjvm7dCgPw53+PpeaYPBXV3Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ruSa2mHq5k+sTvwXEwxC10Q5jUzmpxOswgvEzAWgI/w=;
 b=dv4nz752ldUp2U+pOkUG8gbnSz7YcsL7/p000m7n1onwEL/43HH46QsRFdLssUeLUYjLRBTUQ7TW2/R340hc/Oil3vk0nNg8r10AFXxzPJveZXg4R8WUcJydK/+g7/pFBo7T0lfVLhXC0/OY4T+Jc2BCBKK3ErN4DnrnBis5+LA=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3180.namprd12.prod.outlook.com (2603:10b6:5:182::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.28; Thu, 20 May 2021 21:04:19 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4129.033; Thu, 20 May
 2021 21:04:19 +0000
Subject: Re: [PATCH] KVM: SVM: Do not terminate SEV-ES guests on GHCB
 validation failure
To:     Sean Christopherson <seanjc@google.com>
Cc:     Peter Gonda <pgonda@google.com>, kvm list <kvm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <f8811b3768c4306af7fb2732b6b3755489832c55.1621020158.git.thomas.lendacky@amd.com>
 <CAMkAt6qJqTvM0PX+ja3rLP3toY-Rr4pSUbiFKL1GwzYZPG6f8g@mail.gmail.com>
 <324d9228-03e9-0fe2-59c0-5e41e449211b@amd.com> <YKa1jduPK9JyjWbx@google.com>
 <YKa4I0cs/8lyy0fN@google.com> <YKbE7m40GnSRZsr1@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <8f500f3d-d3a8-c873-50b0-d3cc72ddb372@amd.com>
Date:   Thu, 20 May 2021 16:04:16 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <YKbE7m40GnSRZsr1@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN6PR04CA0088.namprd04.prod.outlook.com
 (2603:10b6:805:f2::29) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN6PR04CA0088.namprd04.prod.outlook.com (2603:10b6:805:f2::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.33 via Frontend Transport; Thu, 20 May 2021 21:04:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51894b06-2a22-41ad-29c7-08d91bd2d5a4
X-MS-TrafficTypeDiagnostic: DM6PR12MB3180:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3180E6CA97CD40C95557A747EC2A9@DM6PR12MB3180.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bulxzNuw0JJqtIz6ErmfsDT+MvL4fX8lM8kadMoybvFZEsm9ogwrNdaJPxiRHDZ2x6EWA8/J2FW+nQwkDqIVadJLBbtolog781hiC8Am3S+Xba/U0Nn8YDAHbY+ZF+VXEK8bFx3dsdLWn0koIoUCtWig2IGi/amoXMEIE8sXtwDQBYU3HkXcM/zflDzG25BCVIoSsWLexX8Ou71JXJPXOGtPjMbSB14IJWLD//xbHMg8hNC+34ZTAxheq5uO0xQieRTI+oXFnXl94SHThPeDQo+71vgCNIYY6uffP4naedQYWUpgTpKrxPgI3bCy4tDNCMMfb7PGGRcVVNzZuAbAudvpZCbY25/iF0JgddKYFikcs06YshSFJAlxndfrR36tUD9imx4EphqrViHsxxLzn3TkeZtHjYJ1JJoFl9ftOxAVw3ez9XJCjiFhKZ7VmNfFrREcKEW5mgGpEvOHY94hns4fcHNQT60E0XvDEQKR2JV+DStmzEczsSJF+5TDgr48Fq62dxGhiJ/sqFMrPJi+UYMi1LXmFjo1772qxYEK+Moog8nuiXsD4SVH20kHSSC1HfR6uND7RsmdfCRjyu4sVvKkkv6KArDtlIXH+dtd/UN5j9tpjJYbrw895quD11FH+oJPUL6yFm4of9q7WfiPupdxXQSz/lV+A8pSf1QdTm39xHcnf0e/vQmkckbFyOER
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(376002)(366004)(346002)(136003)(396003)(26005)(6486002)(316002)(54906003)(8936002)(36756003)(7416002)(2906002)(83380400001)(38100700002)(31686004)(2616005)(66476007)(16526019)(6512007)(186003)(8676002)(6916009)(478600001)(31696002)(4326008)(53546011)(6506007)(66946007)(66556008)(956004)(5660300002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZkhqajY0QTRBNHcrU0QwUHJNaGwreFN2VXgvRnFuYXl0blVMYmVyYTNMN0Zn?=
 =?utf-8?B?ajd4SEtCZGExQ1BCYis4U2NXd09QWHZVVEpKd1A4YS9NMVFyeVJkOWVGcHIy?=
 =?utf-8?B?ai9EaEFXc2phWTRmODc2dFlWM2RsTGdVUmZFZVJTQkJ4aUwwTm93WVhuVjlv?=
 =?utf-8?B?QllpZDFHNmFoamZYMU1pd0wyOGtXbS9JZUdUdmNjb29GM1B4eXNxUWo0b1hs?=
 =?utf-8?B?VitXN1J0T3pnLzNWdUhjaUhjOXo0OU54Zkd4TTduQXhRdEVaaTNrbEZ2SkI0?=
 =?utf-8?B?TXRiWEVVQmdKN0xONXMyME4xQU5GeUxVU2dHUHlwQUtYOS9aanNpcTBYNCtB?=
 =?utf-8?B?d3pQYnJRMDZVUXU5TW9wVFoxSjNKMnFvU2FvRGFEQnlZbGJ6dlJvbVdHc0xC?=
 =?utf-8?B?dmNDZ013SFJvTWRiSHVsZS9sN0VXaC9RYnIrNnFWcWdFc3lIRjBXa3g1OUxR?=
 =?utf-8?B?bHFscWQyRGtVMzcrUWtBVHdRRjQwVFhId3UyeGtkQVp5SEc5T2FBNXdSUmJ1?=
 =?utf-8?B?MUpNS3FWanNpdGUwd3lWallTMmEvTnd3QjFxMTdxZXlXbjJvVXhhdWNESE52?=
 =?utf-8?B?K1BzOTQ0SE9aSFpMK2N0TEVpS0xFMTFxTXR2TEpnOGxtNjJ6VWFNeHVZVVFp?=
 =?utf-8?B?bDY1WFdIa3gwSVNYNXVCUHpVMGdZVjRKSHcrY2VteURqRlAyRmRGTC9uZkNT?=
 =?utf-8?B?V1FDc1FOSEdlUndMZS9TSWtrQzNJaEkzM0VNWW04dlFmZnE3eXpobVp1d1l4?=
 =?utf-8?B?N3JOYys4UEtNSzJqTzI3eFgrdysrMmczdFIwTUhXS2NVSEtyOUZZZjl6d0lo?=
 =?utf-8?B?c08wMkU4Qk16Q01IbSsvaE0xdnJiMTBDLzFBT3l3WU04NzdHeEtuZ0srSE9M?=
 =?utf-8?B?bDJ6a3E0L2JWWW16Q1pVKy8yZlNQMldxUDdjMHdCbXkzaVdBZ3M2d1Qxa2Z5?=
 =?utf-8?B?endrYWdoNkZXQjVoeFpIVDFFNlZlUS9IcWRKaEp0RXFmRkNqVU9nR01IQUgw?=
 =?utf-8?B?SWhQQklLUHB5dEM5eXU4WlFkaktudVVqdFJWVGpOdFdJUG1FV2NZcHF6eFBt?=
 =?utf-8?B?bGdFV3l6QmNTTFczMjhTemNJLzJtdk9WZ0dJcExhdy9TaFY2Sk9EdjJ3V0JG?=
 =?utf-8?B?YXRad3NIMXJuaWg0VGNXNjRsbzdMUkNBUzhzZnVoVVJJTDIvZWoxbjZIY05z?=
 =?utf-8?B?aVVySDNTNnJoNDZSQ2JJNzJpejg5cjRJRnZYSnhVVTNtVWJac1JDR1ptNHUv?=
 =?utf-8?B?RjZ5MXZzSVNIY3kzV2g1ekwvRW1mNFdUd0dhaiszZ0w5T01rNkRlUUcxNFI1?=
 =?utf-8?B?Tk9ObmpJSFMyQ3JhQXJXSWV4d2RHKzZDUlpBd0drNWZudEhLc3A1WXh0OWow?=
 =?utf-8?B?UzE2TGJxdTUxWlZ5ZitFZWRjZDFYbE9ma2s1cC80djhLN2JDQUFKNHYyMUVh?=
 =?utf-8?B?d2ZZVUo0TTMxZU81MTdJQW5wS2lETUV4NUVxR0hEREVnNS9QNVU3NU1ucnJO?=
 =?utf-8?B?RFJRYUVaczZPUWs4UjhFMloxSlhnUlJFV0pybXU2aVlVSFRQYTJ0UHFjaDE3?=
 =?utf-8?B?MnpGbCs5VFpETWhUenRJMlo1UEd1V0ZackJWa0ZRN1VmdExZbTlzUFVsaTl0?=
 =?utf-8?B?TTlMdjJmQ2QwdEFUK1pTY2tIcXdybVJCc0lyN1FMUEs1SHZLWVl1NG1PS2Mw?=
 =?utf-8?B?ZFR1K0Z3ZVpNTW5acmE1T0h6bEZlRHJpRklWS2N6WnVvUmZOQVhCU2Rpa0Q1?=
 =?utf-8?Q?FSiSkCPkX2dzbVPi3jlObeSSFbj7ZF5KqZj3qdL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51894b06-2a22-41ad-29c7-08d91bd2d5a4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 21:04:19.4182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VJbAwnCqCROQBzCTn8owX+tFuSxSnnbcT0sywcg/feaA8huYJAKqzI3jphfeblfyNtGIUQYvIrxfWDPVLYys+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3180
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/20/21 3:22 PM, Sean Christopherson wrote:
> On Thu, May 20, 2021, Sean Christopherson wrote:
>> On Thu, May 20, 2021, Sean Christopherson wrote:
>>> On Mon, May 17, 2021, Tom Lendacky wrote:
>>>> On 5/14/21 6:06 PM, Peter Gonda wrote:
>>>>> On Fri, May 14, 2021 at 1:22 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>>>>>>
>>>>>> Currently, an SEV-ES guest is terminated if the validation of the VMGEXIT
>>>>>> exit code and parameters fail. Since the VMGEXIT instruction can be issued
>>>>>> from userspace, even though userspace (likely) can't update the GHCB,
>>>>>> don't allow userspace to be able to kill the guest.
>>>>>>
>>>>>> Return a #GP request through the GHCB when validation fails, rather than
>>>>>> terminating the guest.
>>>>>
>>>>> Is this a gap in the spec? I don't see anything that details what
>>>>> should happen if the correct fields for NAE are not set in the first
>>>>> couple paragraphs of section 4 'GHCB Protocol'.
>>>>
>>>> No, I don't think the spec needs to spell out everything like this. The
>>>> hypervisor is free to determine its course of action in this case.
>>>
>>> The hypervisor can decide whether to inject/return an error or kill the guest,
>>> but what errors can be returned and how they're returned absolutely needs to be
>>> ABI between guest and host, and to make the ABI vendor agnostic the GHCB spec
>>> is the logical place to define said ABI.
>>>
>>> For example, "injecting" #GP if the guest botched the GHCB on #VMGEXIT(CPUID) is
>>> completely nonsensical.  As is, a Linux guest appears to blindly forward the #GP,
>>> which means if something does go awry KVM has just made debugging the guest that
>>> much harder, e.g. imagine the confusion that will ensue if the end result is a
>>> SIGBUS to userspace on CPUID.
>>>
>>> There needs to be an explicit error code for "you gave me bad data", otherwise
>>> we're signing ourselves up for future pain.
>>
>> More concretely, I think the best course of action is to define a new return code
>> in SW_EXITINFO1[31:0], e.g. '2', with additional information in SW_EXITINFO2.
>>
>> In theory, an old-but-sane guest will interpret the unexpected return code as
>> fatal to whatever triggered the #VMGEXIT, e.g. SIGBUS to userspace.  Unfortunately
>> Linux isn't sane because sev_es_ghcb_hv_call() assumes any non-'1' result means
>> success, but that's trivial to fix and IMO should be fixed irrespective of where
>> this goes.
> 
> One last thing (hopefully): Erdem pointed out that if the GCHB GPA (or any
> derferenced pointers within the GHCB) is invalid or is set to a private GPA
> (mostly in the context of SNP) then the VMM will likely have no choice but to
> kill the guest in response to #VMGEXIT.
> 
> It's probably a good idea to add a blurb in one of the specs explicitly calling
> out that #VMGEXIT can be executed from userspace, and that before returning to
> uesrspace the guest kernel must always ensure that the GCHB points at a legal
> GPA _and_ all primary fields are marked invalid. 

Yes, the spec can be updated to include a "best practices" section for
OSes and Hypervisors to follow without actually having to update the
version of the GHCB spec, so that should be doable.

Thanks,
Tom

> 
