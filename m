Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755D02D2FB1
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 17:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730226AbgLHQaC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 11:30:02 -0500
Received: from mail-bn8nam11on2064.outbound.protection.outlook.com ([40.107.236.64]:12896
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729703AbgLHQaB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 11:30:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aPFDuwxnvrgyj6V8tjVJQs4jvsaoaU63RMn3H9idGutmgowi5z2poLw0orkWDk8rqvs/FCkv4fDsBJ+MIbdMnuUH+Ru18prqSR74rtkiA+m4TyTKQIHE8ISVul5PVSD+DatCWYkXuuG7uuB14FlCM5177l2oTiT3ncVsIb6dWjerPeQxT1x05DyW/bl0JZBZOAs9Wxyq3yJm1jFH7lJt41qTCEncLP+2Vev/TugFmGbHDwTSeagKCOO5VJKlIriYRZj+2tYR2Kt5W+fauJ+lu85cifOyDTBcGFmPAe3/lBGN5c987zS/9gXqtwMm34tLvC33GSFNgj7yI2xZrjLYkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8hvqRnlHSqI9ucmQqQC7Tb0AoYOD+jUMvXSZTzZMc50=;
 b=nzswlq6oK0aiDizz08GWc4nQjQ11yPzCn1p3LLnME0XBwSY20lBY763GR0z3kLZQzMZ2f4Ts0BkdF/2Hm5Ada5ebsyfFhFFiRGJM9nfMH/3UrSEPnSoFCi953FmPvudkYOxOfg8zVe6frHaU1C2L/yHF4gwylSkn3I2kNTCE6s8/Ya3bqoRPt9UQWm4+TqAMY8bTrpS/HEYdJVTvXlIWXPOe8Y5iy90eEnLOvTYQCT4UANtixwbk7Q0hBQFxpnZ2xqWUmZ0Qq5YHXEVRF5JdNDi3QBtX3RGjf1ZpsnFWcHilSGjpi11eS73RS4MeCYYgyl1rxLDLJfzeOh8F3jU7sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8hvqRnlHSqI9ucmQqQC7Tb0AoYOD+jUMvXSZTzZMc50=;
 b=SEmzMfNJ0btUr3jR4kMnoreck7/5tNsxOHj0Op7XKc0hxUPNx4053Xuw/3OC/4BDTlwmfs0tByRZei3crbWVMAqw7FmxT+4boSdI3eYY8hi0mZkeRjxGYHk16Flh12FVrr1m7YQqNevoQT6gg94chgJgeo0zJopuqWPV36Pe9a0=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4430.namprd12.prod.outlook.com (2603:10b6:806:70::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.20; Tue, 8 Dec
 2020 16:29:07 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a%6]) with mapi id 15.20.3654.012; Tue, 8 Dec 2020
 16:29:07 +0000
Cc:     brijesh.singh@amd.com, Paolo Bonzini <pbonzini@redhat.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, dovmurik@linux.vnet.ibm.com,
        tobin@ibm.com, jejb@linux.ibm.com, frankeh@us.ibm.com,
        dgilbert@redhat.com
Subject: Re: [PATCH v2 1/9] KVM: x86: Add AMD SEV specific Hypercall3
To:     Steve Rutherford <srutherford@google.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1606782580.git.ashish.kalra@amd.com>
 <b6bc54ed6c8ae4444f3acf1ed4386010783ad386.1606782580.git.ashish.kalra@amd.com>
 <X8gyhCsEMf8QU9H/@google.com>
 <d63529ce-d613-9f83-6cfc-012a8b333e38@redhat.com>
 <X86Tlin14Ct38zDt@google.com>
 <CABayD+esy0yeKi9W3wQw+ou4y4840LPCwd-PHhN1J6Uh_fvSjA@mail.gmail.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <765f86ae-7c68-6722-c6e0-c6150ce69e59@amd.com>
Date:   Tue, 8 Dec 2020 10:29:05 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
In-Reply-To: <CABayD+esy0yeKi9W3wQw+ou4y4840LPCwd-PHhN1J6Uh_fvSjA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN1PR12CA0054.namprd12.prod.outlook.com
 (2603:10b6:802:20::25) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN1PR12CA0054.namprd12.prod.outlook.com (2603:10b6:802:20::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 8 Dec 2020 16:29:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 595faf90-f3db-415d-3bee-08d89b9662c7
X-MS-TrafficTypeDiagnostic: SA0PR12MB4430:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4430301F8A157A2D434F2DECE5CD0@SA0PR12MB4430.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5qyXqvZuQjA5mgCcYxorEx8kEinDeTaCuc57VWARYQZXcAilW/ZVx4nBnYXNdESYtUej+BYqOzUW0pwxVLa+RlyihD+05ovBNL6Mb/Z1Pnrwj4h/PWVimyYBquhsNBneV0HnYI1ouFtBdhbdaD4uwCAaVtBsYHaoPa1P2KXpj8UtixOKDO8ugMQZ1iViQtIN7TcXsz5RmkozuTnu2xBPN1PT2fahSkQB79OrX3PqQbgoQo3qtdhm3dMVoBMiDQHoS0VFUDqSTBA3dT7fU1CRxJGdJxG7SwjMndLxyhl3SMidLDjX0ZPRY7POMsJmvb7K/e3cZ8mgec8juErSHIvepgNgni6EWEHAoLxYlcTsz6CmbEYbSlQ+NKoPsqU//Z8pU+95lRgp4gmY9zAfir4Tn5PY1Jm0o2+xWVFoVEOg+v8T8Wg4ZTSucMzk+ltIXOaU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(376002)(8676002)(66946007)(26005)(956004)(83380400001)(8936002)(4326008)(66556008)(66476007)(31696002)(5660300002)(34490700003)(2906002)(36756003)(44832011)(31686004)(7416002)(52116002)(186003)(6506007)(2616005)(16526019)(6512007)(508600001)(53546011)(86362001)(110136005)(6486002)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?d1AxZEhYVm5wOEdXWXVmQW4yQW1meitnbG81S2JqRDJKckRMMUs4TzhuUlF3?=
 =?utf-8?B?NXBKN0VyU3k3SmtxMkZCd08yZ29ZbzA4aUhFK0lvWlRodHZ0MDNScHhGbEpz?=
 =?utf-8?B?ZFdMTjNVMFh4MTZ0dm15L0NwZStITlMzdUlCM2Y3K1B6QjNSOU8wZ3VDbVdO?=
 =?utf-8?B?c2hZeWxRZVJwMHZrcjNlbzk1WUcxZTRJZE91NHNmeW5VOExrTWw4V1hxTG9F?=
 =?utf-8?B?bzg5TE9idGE5YkFjK2pYN0pUdTFuWXB6VVFpR3B3T2gzbnMrN2VSczZGdSt2?=
 =?utf-8?B?UGQxbHlPU3JjYU5MbWYrT1VrUmQ4dzNUTEpyRjZIMXFoSFErbWZPbktjWHZs?=
 =?utf-8?B?M0RtbGQvbGNHZU5tMEd4djhIdkkzbThBRDdLOU5zUmdTUUVQalFva0ttMGZX?=
 =?utf-8?B?cVpSZEgydUJsUnAvUS9Ub1V0NDJYZ3NPRzdyamUxd0M0QjdLMytjbkF0UUpk?=
 =?utf-8?B?QjR0ZGlGZ3ZEZ1NqM3lBNVUwcUlFN2RQbHRzL3VjbjJtdWkvZlloY2Q3eWdS?=
 =?utf-8?B?T0pCY1laUUdtQkRlMDI2STRwMDNqbHk4aFFScnJPb0YvZkYyc25Qakp4MCs0?=
 =?utf-8?B?ckpDUkQxbXVBMEp5QzN4ellZOEtoZ0dBcUIrZVJ5aUdEUTIvWXQrZ09QVXJ3?=
 =?utf-8?B?dHZoUDUyaCt4OERkYWpRUmdtVW1EeitjdHA4YWcwRE5YTlFsVWcwTEs2ODZE?=
 =?utf-8?B?Vmd2b3RkZUZJang5Q1VIOGdkM2kxTmNReHl6RFJtUWxIZXBFWXYyek10clB1?=
 =?utf-8?B?WUFKckREMlg2WUYzWVdkam5PbTR1Z1hqTjJza0pGU1ZLUDY2QmltQjcwWkRX?=
 =?utf-8?B?T1g4M2VPbkR0WXA3VUxyeWxCbnVIckdkU21ZMjNrL3BlR3ZieFAxSGhCazVR?=
 =?utf-8?B?U0U0WlI1UjNpNjY1Zm0vUmlMZjlaRzBudFNJLzZWRjc5dmFXZEpzUml6MFRs?=
 =?utf-8?B?azcvZzIyeVg0ZExnTEh3ZzYrenhEZ1pVUE8wRU9RalNZWjNxY2pjZWduT2Rm?=
 =?utf-8?B?RmRiZ0JzbUw1V3ZVRHdINU9XZlRGTEtOMCtVVGw2ckFiT2JLTTh1dkVuNGxV?=
 =?utf-8?B?ODVyNWJPeFpOWFhXYWk3TzVjUnozaWQyd2N4eWtPTjlWdmlUeGRUN1NxTVFB?=
 =?utf-8?B?UXM0TlM3Sjl6Y1RzUkRPRWw2cTRGRm96dlY3Um1GbXNOcWpldm1YUDZkRXJq?=
 =?utf-8?B?ekp6UzNMd0NyOFFpMFZZdjc5WmVmQ0FWR1Y3WnRIMmx0anpsRkhnbS9zRWlQ?=
 =?utf-8?B?NTROVDgzL1FYSjhVZll1ZmVyRm1ZODdRTUR4T29FUW1ScS9XS0ZiK3ZiSEFx?=
 =?utf-8?Q?2VlSlzYN/hNMkbRdVxCddfbpHeuEoQpHw6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 16:29:07.6689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 595faf90-f3db-415d-3bee-08d89b9662c7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NtcIbGs618SyBm84a78Ns0ABZ1OR2R3up5EMfu3rf5zcwY6ZB/qAKiENxy4Fr93KVPUC/42Roa7b99Yd6+Q+XA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4430
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/7/20 9:09 PM, Steve Rutherford wrote:
> On Mon, Dec 7, 2020 at 12:42 PM Sean Christopherson <seanjc@google.com> wrote:
>> On Sun, Dec 06, 2020, Paolo Bonzini wrote:
>>> On 03/12/20 01:34, Sean Christopherson wrote:
>>>> On Tue, Dec 01, 2020, Ashish Kalra wrote:
>>>>> From: Brijesh Singh <brijesh.singh@amd.com>
>>>>>
>>>>> KVM hypercall framework relies on alternative framework to patch the
>>>>> VMCALL -> VMMCALL on AMD platform. If a hypercall is made before
>>>>> apply_alternative() is called then it defaults to VMCALL. The approach
>>>>> works fine on non SEV guest. A VMCALL would causes #UD, and hypervisor
>>>>> will be able to decode the instruction and do the right things. But
>>>>> when SEV is active, guest memory is encrypted with guest key and
>>>>> hypervisor will not be able to decode the instruction bytes.
>>>>>
>>>>> Add SEV specific hypercall3, it unconditionally uses VMMCALL. The hypercall
>>>>> will be used by the SEV guest to notify encrypted pages to the hypervisor.
>>>> What if we invert KVM_HYPERCALL and X86_FEATURE_VMMCALL to default to VMMCALL
>>>> and opt into VMCALL?  It's a synthetic feature flag either way, and I don't
>>>> think there are any existing KVM hypercalls that happen before alternatives are
>>>> patched, i.e. it'll be a nop for sane kernel builds.
>>>>
>>>> I'm also skeptical that a KVM specific hypercall is the right approach for the
>>>> encryption behavior, but I'll take that up in the patches later in the series.
>>> Do you think that it's the guest that should "donate" memory for the bitmap
>>> instead?
>> No.  Two things I'd like to explore:
>>
>>   1. Making the hypercall to announce/request private vs. shared common across
>>      hypervisors (KVM, Hyper-V, VMware, etc...) and technologies (SEV-* and TDX).
>>      I'm concerned that we'll end up with multiple hypercalls that do more or
>>      less the same thing, e.g. KVM+SEV, Hyper-V+SEV, TDX, etc...  Maybe it's a
>>      pipe dream, but I'd like to at least explore options before shoving in KVM-
>>      only hypercalls.
>>
>>
>>   2. Tracking shared memory via a list of ranges instead of a using bitmap to
>>      track all of guest memory.  For most use cases, the vast majority of guest
>>      memory will be private, most ranges will be 2mb+, and conversions between
>>      private and shared will be uncommon events, i.e. the overhead to walk and
>>      split/merge list entries is hopefully not a big concern.  I suspect a list
>>      would consume far less memory, hopefully without impacting performance.
> For a fancier data structure, I'd suggest an interval tree. Linux
> already has an rbtree-based interval tree implementation, which would
> likely work, and would probably assuage any performance concerns.
>
> Something like this would not be worth doing unless most of the shared
> pages were physically contiguous. A sample Ubuntu 20.04 VM on GCP had
> 60ish discontiguous shared regions. This is by no means a thorough
> search, but it's suggestive. If this is typical, then the bitmap would
> be far less efficient than most any interval-based data structure.
>
> You'd have to allow userspace to upper bound the number of intervals
> (similar to the maximum bitmap size), to prevent host OOMs due to
> malicious guests. There's something nice about the guest donating
> memory for this, since that would eliminate the OOM risk.


Tracking the list of ranges may not be bad idea, especially if we use
the some kind of rbtree-based data structure to update the ranges. It
will certainly be better than bitmap which grows based on the guest
memory size and as you guys see in the practice most of the pages will
be guest private. I am not sure if guest donating a memory will cover
all the cases, e.g what if we do a memory hotplug (increase the guest
ram from 2GB to 64GB), will donated memory range will be enough to store
the metadata.


