Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21F62ECB90
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 09:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbhAGIGq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 03:06:46 -0500
Received: from mail-dm6nam12on2057.outbound.protection.outlook.com ([40.107.243.57]:42080
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726684AbhAGIGp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 03:06:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ef+w3Xcj+GM4phHM7ccxDsJNDk7F9q1Rnsg3MKrn0s/h0i2Q4H/MxVomF4CctLnNnrBC951iOXeVO8rdyKQZQCZlBEKDsCLNhjhq2ueDaGqHQ0BCoKndtwvM2/q8zhQdJzMUr2yMeogJ0iqHvJJdw/RkgjFZU4OEsqAFSTna6Hpur/N7BGA98OEIWgSgJu2MGojcrE2r6ASsFsa8xHZGl8bJ4iSLKaZO1PYgJ7FJiYzxdfVkxuPd8cWrcuW6Y1rkfdTZ6B2AoGKgCizZgRgbl/GRAzpZZDhs1btNYh1FUt8aufXcJJqiWMswKLkSRTJehsxHuE6e/cxQbAaxKK2EtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XRy7Rp7Yuqtzi3gSDCJeOc0lyrZ0ioafaBG7cXylA3Y=;
 b=O7lwFbNFELlX29o57FsaQd4n0c2a+fIFImVF5DpOWOa3kpa0oKfax6wFIv33UHUFc53GK/yclBvmUcQZvlbaOKkxA/A/ANUvA5h64dOqTeZeGXus7h38wRuzb1fcfQYOFWIDgCYuL3uH+XKK7ZSKXMGnFmWRIZIqPlEWqg6VDnD0t2qyr503DZF2J3GU8J+GG/5lJR7mH5Pra6SuRGrUr7CHr8TBXHCtna2/bnWq6FYZcZIpo4m9nFbLO8Do8eEHiQyJsrDinwg8Ztw/xD1WN5oLpaiZnOMD6U0GA7A7Ah9vouc78c0sfWwSPic0tLqJK4rXfXBcXES9grj79rLIUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XRy7Rp7Yuqtzi3gSDCJeOc0lyrZ0ioafaBG7cXylA3Y=;
 b=aNKdq48GP2V4H/JnyDLRkApohoDtk2v/TM9IP3Jjt9CZApPr8ZRaIETjEsJLg+7nSq3AKOPJLxU2N86IS2q3kSULLchoIrCxhW4lDl0DZF+fN18G5uXkQ59mbj4xghMLlGuj9Oa7BYpUDLX8gvpvWMB3JpgqtuuAkcEOY3SfAQE=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2781.namprd12.prod.outlook.com (2603:10b6:805:67::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20; Thu, 7 Jan
 2021 08:05:49 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::209d:4e20:fc9e:a726]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::209d:4e20:fc9e:a726%6]) with mapi id 15.20.3742.006; Thu, 7 Jan 2021
 08:05:48 +0000
Date:   Thu, 7 Jan 2021 08:05:13 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Steve Rutherford <srutherford@google.com>
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "dovmurik@linux.vnet.ibm.com" <dovmurik@linux.vnet.ibm.com>,
        "tobin@ibm.com" <tobin@ibm.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "frankeh@us.ibm.com" <frankeh@us.ibm.com>, jon.grimm@amd.com
Subject: Re: [PATCH v2 1/9] KVM: x86: Add AMD SEV specific Hypercall3
Message-ID: <20210107080513.GA16781@ashkalra_ubuntu_server>
References: <CABayD+esy0yeKi9W3wQw+ou4y4840LPCwd-PHhN1J6Uh_fvSjA@mail.gmail.com>
 <765f86ae-7c68-6722-c6e0-c6150ce69e59@amd.com>
 <20201211225542.GA30409@ashkalra_ubuntu_server>
 <20201212045603.GA27415@ashkalra_ubuntu_server>
 <20201218193956.GJ2956@work-vm>
 <E79E09A2-F314-4B59-B7AE-07B1D422DF2B@amd.com>
 <20201218195641.GL2956@work-vm>
 <20210106230555.GA13999@ashkalra_ubuntu_server>
 <CABayD+dQwaeCnr5_+DUpvbQ42O6cZBMO79pEEzi5WXPO=NH3iA@mail.gmail.com>
 <20210107013414.GA14098@ashkalra_ubuntu_server>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210107013414.GA14098@ashkalra_ubuntu_server>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR11CA0018.namprd11.prod.outlook.com
 (2603:10b6:806:6e::23) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SA9PR11CA0018.namprd11.prod.outlook.com (2603:10b6:806:6e::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Thu, 7 Jan 2021 08:05:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f2d5c00c-7ec0-48d6-c132-08d8b2e30b43
X-MS-TrafficTypeDiagnostic: SN6PR12MB2781:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2781B9FE0EEC6A0769829D8F8EAF0@SN6PR12MB2781.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H7PxtG3OurxMT3a72lYC2TDCt7OyjmAWZop77XqudYBvrg79BIOfNI/2C7DScxRLsJbsuMhcPUejg6zHk22IuuVztqd4dQY6iJQISIcJ2MDKrBi4UCJG8cj6WZJvrQI8edHw/W34tfy+nrf4HR/8e9D5BfCIwnRPajGW5hFJ1fSqfDcZXqqtyORmtSR/SF5PeZ7F0ffaOMlKPboFzhb/9hRjTbSTGTQN9ydBkWkI15gjru9UK42T5cxHGRmxKR3WkdHwNEYREd3MIt2YTOM/fmrPMpqhc5d3r1RB/jKjqjQ3cNG0uyQ9D4Gg/4kd9u4J2NSSCNLysUc//h8AxxfjmzOIZZARGlccaLKEavYTc4wPVZjXg/qowlZB2N/tFEwTdxDxykQIr5E08SuH0tVjDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(136003)(346002)(39860400002)(30864003)(66556008)(66946007)(956004)(33716001)(54906003)(6916009)(316002)(1076003)(186003)(66476007)(478600001)(5660300002)(6496006)(52116002)(44832011)(53546011)(83380400001)(9686003)(16526019)(8936002)(33656002)(6666004)(26005)(55016002)(7416002)(4326008)(2906002)(86362001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MnlDYVNVdDF2UWJnc2ROZ0xPRTFQVjlhT2tMd04zeDB1ZVF4OEJaTVRSaEpI?=
 =?utf-8?B?RnEwem41SWVoOEFIbm42elpPVW9yQWdXa1piS1JsNUhGQVlTVitVckR0YjZT?=
 =?utf-8?B?Vi83ZHhnanZJbHpEZFJKRGJCZG02TzVleUVTWlpTRVlNeEszckFvSldUa2ZE?=
 =?utf-8?B?Q3pTcHA0WEl2dGJrWnJuSUhtRm1JM3lkYjAwalA4R0RuaU9pNkNkSFR1RDFW?=
 =?utf-8?B?bk9mM09mdXphQk9GdkNtb0s4V2JtQVhSem5iRzkvdFZ6TVZVUzJEQWJna3dZ?=
 =?utf-8?B?d3BCREJJbXNiSk5qN2xibm5FWDA2UGlwNUl4S3EzZ3RrTjVHVFd3TXFsMmpO?=
 =?utf-8?B?NTZxejdNQnk3U2k1VnQ0ZzFtT1RvQXlMcHRBNEpuM3hmNEFEcGsvbmtXdGVo?=
 =?utf-8?B?b2FPWENvNHBsK2hsdFo0UnBUMWdtdWtHN0F6ckE0SHcvUmtMVEU1Q3ZPU1c0?=
 =?utf-8?B?c2p0S2hXdE4yUU1WaHYveVA4czlXUWc5dVNNNG9YRVV3UEhQSkpiT2pPN0Jn?=
 =?utf-8?B?SFg1MHJQNERTbHVCZUVSSzI2Q2JKZDdtdjNsSDNDZ0cxclV4SWNONk9PeVZE?=
 =?utf-8?B?c2Iya1FtTEpnUzlMYzZrQTZGOCtaQXpzOXQwZVJSWG5BcDRIZlZYbG5qYUxy?=
 =?utf-8?B?Qnh6cHJSK05lbmRIOWNyZXBYbG12MVNxck04aUJuOXZZVHVpQi9KNFNYWDAw?=
 =?utf-8?B?VitJR3JYNTkyMzY4SzhVMTNDbFJUVUpKYml2SXNJbXlxM0JBWUVJZXc3b2du?=
 =?utf-8?B?aHd2UStzdVFOckRlSFh3YTdwN29heERmTzZ1eE9abGFuNTBaY0ttOExKRGNa?=
 =?utf-8?B?RjI5QnFlVVlObkMyRVBvaTVib0paQXBza01ndUxVQjhZNExkYVZkOHoySlRl?=
 =?utf-8?B?Y0h1N1ljUVhvb0w1YTZ1TmNpQ1pKcDRkczFxTUZPWnFVOGhJUWlvcHRIbDNn?=
 =?utf-8?B?UE80NjB1MXlZcHpubGhZNVNaTEltSHhqWXVaampKdVhObVFkS2YrTlpEcEZ6?=
 =?utf-8?B?YTRIcVROei9rQm1adE9taWZhM05KS1JHMkE1elhZbWZuNC9rdzFSNU1reUlD?=
 =?utf-8?B?cjFjNzhmZThJZWpDU1RSek4ycHBtdTc4amRvV2dHaGJ6a1lIcUt5OFo2aUJP?=
 =?utf-8?B?QzBab0RqTlprMmdYdktkWExMVDVnY1BNcm1zWUYwemMySDhoWFhHNU5JalVv?=
 =?utf-8?B?VjdpdERIMWJ3ZkR1a3V6TW1PSlVvUjFOdHI0NjVmdEcwWG5NaWh3YnRwRTNj?=
 =?utf-8?B?bjhvbXh0S2dDZzhtc2ZRaHl5UnNjSUhOdGVMOTFnMXhMdmZXYW5weXQ5YnFN?=
 =?utf-8?Q?gHs7T+aG5TQc+iRLr4X9ViZglMBl8WFYpi?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2021 08:05:48.8265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: f2d5c00c-7ec0-48d6-c132-08d8b2e30b43
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aCi6ykIHxxvQys4obFKA2qx8ODMOSWtyWRCcf3BVKwTnPl1pwmz1x89qSX43bgPFQz6DTl3sdUWNVYPrwYQgsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2781
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Steve,

Sorry, i realized later that i replied to this email with regard to the
current bitmap implementation and not the unencrpyted region list
strategy.

I am now looking at your thoughts/questions with regard to the
unencrypted region list strategy and will reply to them accordingly.

Thanks,
Ashish

On Thu, Jan 07, 2021 at 01:34:14AM +0000, Ashish Kalra wrote:
> Hello Steve,
> 
> My thoughts here ...
> 
> On Wed, Jan 06, 2021 at 05:01:33PM -0800, Steve Rutherford wrote:
> > Avoiding an rbtree for such a small (but unstable) list seems correct.
> > 
> 
> I agree.
> 
> > For the unencrypted region list strategy, the only questions that I
> > have are fairly secondary.
> > - How should the kernel upper bound the size of the list in the face
> > of malicious guests, but still support large guests? (Something
> > similar to the size provided in the bitmap API would work).
> 
> Please note that in our current implementation, we don't do any bitmap
> resize based on guest page encryption status hypercall, the max. bitmap
> size is computed dynamically by walking the KVM memslots and finding the
> maximum guest physical address size.
> 
> So, malicious guests cannot do large bitmap allocations using the
> hypercalls. 
> 
> > - What serialization format should be used for the ioctl API?
> > (Usermode could send down a pointer to a user region and a size. The
> > kernel could then populate that with an array of structs containing
> > bases and limits for unencrypted regions.)
> > - How will the kernel tag a guest as having exceeded its maximum list
> > size, in order to indicate that the list is now incomplete? (Track a
> > poison bit, and send it up when getting the serialized list of
> > regions).
> > 
> 
> With reference to the serialization concerns with active live
> migration and simultaneous page encryption bitmap updates, please note
> that in our current VMM implementation, after each memory region
> migration cycle we pause live migration, re-sync the page encryption
> bitmap, XOR it to the last synced bitmap, and then re-transfer any
> modified pages accordingly. 
> 
> I have a prototype implementation for this in Qemu, which seems to
> work fine.
> 
> > In my view, there are two main competitors to this strategy:
> > - (Existing) Bitmap API
> > - A guest memory donation based model
> > 
> > The existing bitmap API avoids any issues with growing too large,
> > since it's size is predictable.
> > 
> 
> Yes, as i mentioned above, it's size is predictable and cannot grow too
> large. 
> 
> > To elaborate on the memory donation based model, the guest could put
> > an encryption status data structure into unencrypted guest memory, and
> > then use a hypercall to inform the host where the base of that
> > structure is located. The main advantage of this is that it side steps
> > any issues around malicious guests causing large allocations.
> > 
> > The unencrypted region list seems very practical. It's biggest
> > advantage over the bitmap is how cheap it will be to pass the
> > structure up from the kernel. A memory donation based model could
> > achieve similar performance, but with some additional complexity.
> > 
> > Does anyone view the memory donation model as worth the complexity?
> > Does anyone think the simplicity of the bitmap is a better tradeoff
> > compared to an unencrypted region list?
> 
> One advantage in sticking with the bitmap is that it maps very nicely to
> the dirty bitmap page tracking logic in KVM/Qemu. The way Brijesh
> designed and implemented it is very similar to dirty page bitmap tracking
> and syncing between KVM and Qemu. The same logic is re-used for the page
> encryption bitmap which means quite mininal changes and code resuse in
> Qemu. 
> 
> Any changes to the backing data structure, will require additional
> mapping logic to be added to Qemu.
> 
> This is one advantage in keeping the bitmap logic.
> 
> Thanks,
> Ashish
> 
> > Or have other ideas that are not mentioned here?
> > 
> > 
> > On Wed, Jan 6, 2021 at 3:06 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> > >
> > > On Fri, Dec 18, 2020 at 07:56:41PM +0000, Dr. David Alan Gilbert wrote:
> > > > * Kalra, Ashish (Ashish.Kalra@amd.com) wrote:
> > > > > Hello Dave,
> > > > >
> > > > > On Dec 18, 2020, at 1:40 PM, Dr. David Alan Gilbert <dgilbert@redhat.com> wrote:
> > > > >
> > > > > ﻿* Ashish Kalra (ashish.kalra@amd.com) wrote:
> > > > > On Fri, Dec 11, 2020 at 10:55:42PM +0000, Ashish Kalra wrote:
> > > > > Hello All,
> > > > >
> > > > > On Tue, Dec 08, 2020 at 10:29:05AM -0600, Brijesh Singh wrote:
> > > > >
> > > > > On 12/7/20 9:09 PM, Steve Rutherford wrote:
> > > > > On Mon, Dec 7, 2020 at 12:42 PM Sean Christopherson <seanjc@google.com> wrote:
> > > > > On Sun, Dec 06, 2020, Paolo Bonzini wrote:
> > > > > On 03/12/20 01:34, Sean Christopherson wrote:
> > > > > On Tue, Dec 01, 2020, Ashish Kalra wrote:
> > > > > From: Brijesh Singh <brijesh.singh@amd.com>
> > > > >
> > > > > KVM hypercall framework relies on alternative framework to patch the
> > > > > VMCALL -> VMMCALL on AMD platform. If a hypercall is made before
> > > > > apply_alternative() is called then it defaults to VMCALL. The approach
> > > > > works fine on non SEV guest. A VMCALL would causes #UD, and hypervisor
> > > > > will be able to decode the instruction and do the right things. But
> > > > > when SEV is active, guest memory is encrypted with guest key and
> > > > > hypervisor will not be able to decode the instruction bytes.
> > > > >
> > > > > Add SEV specific hypercall3, it unconditionally uses VMMCALL. The hypercall
> > > > > will be used by the SEV guest to notify encrypted pages to the hypervisor.
> > > > > What if we invert KVM_HYPERCALL and X86_FEATURE_VMMCALL to default to VMMCALL
> > > > > and opt into VMCALL?  It's a synthetic feature flag either way, and I don't
> > > > > think there are any existing KVM hypercalls that happen before alternatives are
> > > > > patched, i.e. it'll be a nop for sane kernel builds.
> > > > >
> > > > > I'm also skeptical that a KVM specific hypercall is the right approach for the
> > > > > encryption behavior, but I'll take that up in the patches later in the series.
> > > > > Do you think that it's the guest that should "donate" memory for the bitmap
> > > > > instead?
> > > > > No.  Two things I'd like to explore:
> > > > >
> > > > >  1. Making the hypercall to announce/request private vs. shared common across
> > > > >     hypervisors (KVM, Hyper-V, VMware, etc...) and technologies (SEV-* and TDX).
> > > > >     I'm concerned that we'll end up with multiple hypercalls that do more or
> > > > >     less the same thing, e.g. KVM+SEV, Hyper-V+SEV, TDX, etc...  Maybe it's a
> > > > >     pipe dream, but I'd like to at least explore options before shoving in KVM-
> > > > >     only hypercalls.
> > > > >
> > > > >
> > > > >  2. Tracking shared memory via a list of ranges instead of a using bitmap to
> > > > >     track all of guest memory.  For most use cases, the vast majority of guest
> > > > >     memory will be private, most ranges will be 2mb+, and conversions between
> > > > >     private and shared will be uncommon events, i.e. the overhead to walk and
> > > > >     split/merge list entries is hopefully not a big concern.  I suspect a list
> > > > >     would consume far less memory, hopefully without impacting performance.
> > > > > For a fancier data structure, I'd suggest an interval tree. Linux
> > > > > already has an rbtree-based interval tree implementation, which would
> > > > > likely work, and would probably assuage any performance concerns.
> > > > >
> > > > > Something like this would not be worth doing unless most of the shared
> > > > > pages were physically contiguous. A sample Ubuntu 20.04 VM on GCP had
> > > > > 60ish discontiguous shared regions. This is by no means a thorough
> > > > > search, but it's suggestive. If this is typical, then the bitmap would
> > > > > be far less efficient than most any interval-based data structure.
> > > > >
> > > > > You'd have to allow userspace to upper bound the number of intervals
> > > > > (similar to the maximum bitmap size), to prevent host OOMs due to
> > > > > malicious guests. There's something nice about the guest donating
> > > > > memory for this, since that would eliminate the OOM risk.
> > > > >
> > > > >
> > > > > Tracking the list of ranges may not be bad idea, especially if we use
> > > > > the some kind of rbtree-based data structure to update the ranges. It
> > > > > will certainly be better than bitmap which grows based on the guest
> > > > > memory size and as you guys see in the practice most of the pages will
> > > > > be guest private. I am not sure if guest donating a memory will cover
> > > > > all the cases, e.g what if we do a memory hotplug (increase the guest
> > > > > ram from 2GB to 64GB), will donated memory range will be enough to store
> > > > > the metadata.
> > > > >
> > > > > .
> > > > >
> > > > > With reference to internal discussions regarding the above, i am going
> > > > > to look into specific items as listed below :
> > > > >
> > > > > 1). "hypercall" related :
> > > > > a). Explore the SEV-SNP page change request structure (included in GHCB),
> > > > > see if there is something common there than can be re-used for SEV/SEV-ES
> > > > > page encryption status hypercalls.
> > > > > b). Explore if there is any common hypercall framework i can use in
> > > > > Linux/KVM.
> > > > >
> > > > > 2). related to the "backing" data structure - explore using a range-based
> > > > > list or something like rbtree-based interval tree data structure
> > > > > (as mentioned by Steve above) to replace the current bitmap based
> > > > > implementation.
> > > > >
> > > > >
> > > > >
> > > > > I do agree that a range-based list or an interval tree data structure is a
> > > > > really good "logical" fit for the guest page encryption status tracking.
> > > > >
> > > > > We can only keep track of the guest unencrypted shared pages in the
> > > > > range(s) list (which will keep the data structure quite compact) and all
> > > > > the guest private/encrypted memory does not really need any tracking in
> > > > > the list, anything not in the list will be encrypted/private.
> > > > >
> > > > > Also looking at a more "practical" use case, here is the current log of
> > > > > page encryption status hypercalls when booting a linux guest :
> > > > >
> > > > > ...
> > > > >
> > > > > <snip>
> > > > >
> > > > > [   56.146336] page_enc_status_hc invoked, gpa = 1f018000, npages  = 1, enc = 1
> > > > > [   56.146351] page_enc_status_hc invoked, gpa = 1f00e000, npages  = 1, enc = 0
> > > > > [   56.147261] page_enc_status_hc invoked, gpa = 1f00e000, npages  = 1, enc = 0
> > > > > [   56.147271] page_enc_status_hc invoked, gpa = 1f018000, npages  = 1, enc = 0
> > > > > ....
> > > > >
> > > > > [   56.180730] page_enc_status_hc invoked, gpa = 1f008000, npages  = 1, enc = 0
> > > > > [   56.180741] page_enc_status_hc invoked, gpa = 1f006000, npages  = 1, enc = 0
> > > > > [   56.180768] page_enc_status_hc invoked, gpa = 1f008000, npages  = 1, enc = 1
> > > > > [   56.180782] page_enc_status_hc invoked, gpa = 1f006000, npages  = 1, enc = 1
> > > > >
> > > > > ....
> > > > > [   56.197110] page_enc_status_hc invoked, gpa = 1f007000, npages  = 1, enc = 0
> > > > > [   56.197120] page_enc_status_hc invoked, gpa = 1f005000, npages  = 1, enc = 0
> > > > > [   56.197136] page_enc_status_hc invoked, gpa = 1f007000, npages  = 1, enc = 1
> > > > > [   56.197148] page_enc_status_hc invoked, gpa = 1f005000, npages  = 1, enc = 1
> > > > > ....
> > > > >
> > > > > [   56.222679] page_enc_status_hc invoked, gpa = 1e83b000, npages  = 1, enc = 0
> > > > > [   56.222691] page_enc_status_hc invoked, gpa = 1e839000, npages  = 1, enc = 0
> > > > > [   56.222707] page_enc_status_hc invoked, gpa = 1e83b000, npages  = 1, enc = 1
> > > > > [   56.222720] page_enc_status_hc invoked, gpa = 1e839000, npages  = 1, enc = 1
> > > > > ....
> > > > >
> > > > > [   56.313747] page_enc_status_hc invoked, gpa = 1e5eb000, npages  = 1, enc = 0
> > > > > [   56.313771] page_enc_status_hc invoked, gpa = 1e5e9000, npages  = 1, enc = 0
> > > > > [   56.313789] page_enc_status_hc invoked, gpa = 1e5eb000, npages  = 1, enc = 1
> > > > > [   56.313803] page_enc_status_hc invoked, gpa = 1e5e9000, npages  = 1, enc = 1
> > > > > ....
> > > > > [   56.459276] page_enc_status_hc invoked, gpa = 1d767000, npages  = 100, enc = 0
> > > > > [   56.459428] page_enc_status_hc invoked, gpa = 1e501000, npages  = 1, enc = 1
> > > > > [   56.460037] page_enc_status_hc invoked, gpa = 1d767000, npages  = 100, enc = 1
> > > > > [   56.460216] page_enc_status_hc invoked, gpa = 1e501000, npages  = 1, enc = 0
> > > > > [   56.460299] page_enc_status_hc invoked, gpa = 1d767000, npages  = 100, enc = 0
> > > > > [   56.460448] page_enc_status_hc invoked, gpa = 1e501000, npages  = 1, enc = 1
> > > > > ....
> > > > >
> > > > > As can be observed here, all guest MMIO ranges are initially setup as
> > > > > shared, and those are all contigious guest page ranges.
> > > > >
> > > > > After that the encryption status hypercalls are invoked when DMA gets
> > > > > triggered during disk i/o while booting the guest ... here again the
> > > > > guest page ranges are contigious, though mostly single page is touched
> > > > > and a lot of page re-use is observed.
> > > > >
> > > > > So a range-based list/structure will be a "good" fit for such usage
> > > > > scenarios.
> > > > >
> > > > > It seems surprisingly common to flick the same pages back and forth between
> > > > > encrypted and clear for quite a while;  why is this?
> > > > >
> > > > >
> > > > > dma_alloc_coherent()'s will allocate pages and then call
> > > > > set_decrypted() on them and then at dma_free_coherent(), set_encrypted()
> > > > > is called on the pages to be freed. So these observations in the logs
> > > > > where a lot of single 4K pages are seeing C-bit transitions and
> > > > > corresponding hypercalls are the ones associated with
> > > > > dma_alloc_coherent().
> > > >
> > > > It makes me wonder if it might be worth teaching it to hold onto those
> > > > DMA pages somewhere until it needs them for something else and avoid the
> > > > extra hypercalls; just something to think about.
> > > >
> > > > Dave
> > >
> > > Following up on this discussion and looking at the hypercall logs and DMA usage scenarios on the SEV, I have the following additional observations and comments :
> > >
> > > It is mostly the Guest MMIO regions setup as un-encrypted by uefi/edk2 initially, which will be the "static" nodes in the backing data structure for page encryption status.
> > > These will be like 15-20 nodes/entries.
> > >
> > > Drivers doing DMA allocations using GFP_ATOMIC will be fetching DMA buffers from the pre-allocated unencrypted atomic pool, hence it will be a "static" node added at kernel startup.
> > >
> > > As we see with the logs, almost all runtime C-bit transitions and corresponding hypercalls will be from DMA I/O and dma_alloc_coherent/dma_free_coherent calls, these will be
> > > using 4K/single pages and mostly fragmented ranges, so if we use a "rbtree" based interval tree then there will be a lot of tree insertions and deletions
> > > (dma_alloc_coherent followed with a dma_free_coherent), so this will lead to a lot of expensive tree rotations and re-balancing, compared to much less complex
> > > and faster linked list node insertions and deletions (if we use a list based structure to represent these interval ranges).
> > >
> > > Also as the static nodes in the structure will be quite limited (all the above DMA I/O added ranges will simply be inserted and removed), so a linked list lookup
> > > won't be too expensive compared to a tree lookup. In other words, this be a fixed size list.
> > >
> > > Looking at the above, I am now more inclined to use a list based structure to represent the page encryption status.
> > >
> > > Looking fwd. to any comments/feedback/thoughts on the above.
> > >
> > > Thanks,
> > > Ashish
> > >
