Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 372402D8278
	for <lists+kvm@lfdr.de>; Fri, 11 Dec 2020 23:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436761AbgLKW5G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Dec 2020 17:57:06 -0500
Received: from mail-bn8nam12on2048.outbound.protection.outlook.com ([40.107.237.48]:52990
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2407062AbgLKW4q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Dec 2020 17:56:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IgstJggrJl2V3NGpcU1o1smZ3aGYMZDpT7w2AZD9T9/P5EaOdk51BjcoUcyKt5F+dXtCxwjU88Xj2DsK/MXbaaQ7Lf2FXV0g+y7CW2rSi4RpFJZibDNgNEW9df8gC8P6NUuSo4BW9Hj1m/vsB0+dR3MiViTJ/KzkyurTIQCigxWYnzcKW2FymA5nwXSiAHfUha7QlmnD+f09rokMGG8bC/KvZbs0NZuU9tSbVgnD9yMaMC6mS4qWzhAOYHV31Esbn0s8H2XvRWpRlEyJ1JwyKy6KlXlIlffca6JBYUgJjlxLk7nxyxlvvCm0TkAGD4oeAaLXDxhMzuwLxMeoHRSoXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V+ko9xvhh8hFi/u52K7YCwJqb7fVgmfmLVWf+OPAqPw=;
 b=KQQqdj0I+eEwgSYF3xKxXu8KyC3cRR2vf/aJ/q61yGwGj6k2Iyb3xMZOWBilIc5VC8LK93HhPFxav4rMKlchWRlQT7cO9azsHjxRgJX3UExgTzem+RCTQPGLrUeZDnN+1WBwJVfyTDx1B4L8qrqp/bVkjH7VcKBHfzJjch2nUkHBsHiNBqSl1JQOyXqXa2SXsItaP5Axv/6Epx6SdvHcCxQaGkxVTG6Tp4E2W33NSo/nDcR+Nf7UVtPWxkcVkVP00M+4vr5Wk1TYcfweXTAwTjOfNvjvXGw4aQyW5oogenWl+W0224Roi74kf9utov6qyK/2C3yKljeOhNmOzTq3Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V+ko9xvhh8hFi/u52K7YCwJqb7fVgmfmLVWf+OPAqPw=;
 b=uaseSILzzvPz05l68/ODSSB2HazEs3wtkczc3NMZiwseJfYlo1Ae/99B9JTFTrReosSQXCTFZdNJcVElpbDJmwN4mwlATQ85KQxUNOuh/uLZclOrP2cMYV9GilVEkhzecxUQUM5YYMSvyEsiNkxL1UnUgtknSsOS0XVwLa8FBGM=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4511.namprd12.prod.outlook.com (2603:10b6:806:95::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Fri, 11 Dec
 2020 22:55:51 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3632.021; Fri, 11 Dec 2020
 22:55:51 +0000
Date:   Fri, 11 Dec 2020 22:55:42 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     Steve Rutherford <srutherford@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
Message-ID: <20201211225542.GA30409@ashkalra_ubuntu_server>
References: <cover.1606782580.git.ashish.kalra@amd.com>
 <b6bc54ed6c8ae4444f3acf1ed4386010783ad386.1606782580.git.ashish.kalra@amd.com>
 <X8gyhCsEMf8QU9H/@google.com>
 <d63529ce-d613-9f83-6cfc-012a8b333e38@redhat.com>
 <X86Tlin14Ct38zDt@google.com>
 <CABayD+esy0yeKi9W3wQw+ou4y4840LPCwd-PHhN1J6Uh_fvSjA@mail.gmail.com>
 <765f86ae-7c68-6722-c6e0-c6150ce69e59@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <765f86ae-7c68-6722-c6e0-c6150ce69e59@amd.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR14CA0006.namprd14.prod.outlook.com
 (2603:10b6:610:60::16) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by CH2PR14CA0006.namprd14.prod.outlook.com (2603:10b6:610:60::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Fri, 11 Dec 2020 22:55:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9afd52eb-dca2-4353-7cb9-08d89e27e86d
X-MS-TrafficTypeDiagnostic: SA0PR12MB4511:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45116CC765FCF419E8DD072F8ECA0@SA0PR12MB4511.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XWat9os3HJVu8JcWmokXYxxzB7Yn0TDSbAK4YOjRuFhPtaBpX0BcHFKRUE0pveZr/ZLTahcCyRMjgV3MOR63Bcmq2LHx3h0II2+2Gg9leANXfnL19Y0MeLeKFSQS2S9nQaGvTOHw6F/0VZFdU5BbWrtw1EKTAexTHUt30gDWFhJ9TdL+qUyLvRw9pAbNXJDjJOO/JXfLxWIrD2yt3cmQQ0yF63gyS3qgXJTkECwkPYtyD6vqNF+c77IirYfxeFD/JyJU0k01pQv0tg+0fRLkPVHh4laan9PCz8dfLLvKLcR+YHRuXvYP246snlpEpBCVd6ICk1vL1gTAFEBvIc2pn3E5kxzNg1MX4nw9NQ0QnnqA46ZgpXzv1bkmZBTOFDyq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(366004)(86362001)(26005)(66476007)(956004)(52116002)(55016002)(186003)(33716001)(6496006)(7416002)(6862004)(508600001)(6636002)(2906002)(4326008)(8676002)(44832011)(5660300002)(9686003)(66556008)(1076003)(16526019)(8936002)(6666004)(83380400001)(53546011)(54906003)(33656002)(34490700003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?LZPkA+vMkEwEe/WX4iR24YAFagZcom5TtdS714MZ8YgEbXHRAWT7zbq/T/Pb?=
 =?us-ascii?Q?+9CG+3P1jqk/YTdNei3kJcyI0xpXHau82VSMNzRWukAt/rT/fFk4mdT1xYHk?=
 =?us-ascii?Q?41rAUcQ7YClrq/Sh4VQ5jx5GXHn6/Lnxt9pFNYBMLIe+FDN/0e0GiU2ifDfg?=
 =?us-ascii?Q?yneR97gEn04Qd+2q/FVTsy+AQLQT1a9T6JfjVQ8QIaiBfCIL2fCcNI/02SG5?=
 =?us-ascii?Q?xXXpkyioHCd4KloqUI8kFIuGR5E7toA2cSejTv9g2LLRI/6UPjjujWwtDL9Y?=
 =?us-ascii?Q?ft/jBnbtMU/SiDldMqdn5eygjmLj1Xavx5cwnh78X9w0Unph1hSwCWTXD5Hr?=
 =?us-ascii?Q?JTodZHooyaWdzS5IEbVV6cRDDqsyAhjbCFWH0O+87Q+SpU8SVRP/iHzKevMJ?=
 =?us-ascii?Q?cbTvjW5u38/YDmO4B11+DMhvUiBDQMIenE1SxW9F53dAyEhOSFI8c8vPxUW7?=
 =?us-ascii?Q?Ozx3tN8sFslLSmvxSOJsutXqPS2jqUr2yDsBHwzMmRNGfpbB71m3tzFO+fCm?=
 =?us-ascii?Q?mL2/ixoYVvchSIfD5N9CIxi+aUxHXD5EfPXvvdlbVEowx5Qso+mXcgekgeuc?=
 =?us-ascii?Q?+ogwcAWWCjTM78ncuFTKJGJxzRoDdHbhxt3KG8h+M6W04ciCyIrMu2jTKrOk?=
 =?us-ascii?Q?pb6ItiMk63+rKMt5CmeXnTbT6oza15lXa0rjf+Ew6NQ9M9xpHngEt9FjHktt?=
 =?us-ascii?Q?TWkaHIpeabgdlkLUyCZaiznUsIJHAv321SwsvbmNNnOcYTnh+prdbvZ3mhFO?=
 =?us-ascii?Q?u3LLKOf2EcTmnr+M25aVnul3HawPbC174v6/cl+qTEeX5mr5OKL4Tce/PSuZ?=
 =?us-ascii?Q?2kXSpjqcXkazQ7hrWVefi/7TG8dg5JhT0xwfFyrms6BcLMXzvC+ugEomwt0r?=
 =?us-ascii?Q?WOu0Af0MVYqEMH4+y+gVWXN+1GJ5/DRgNxDHPG+SC4k2qKFEbcSLbwRLt3Ej?=
 =?us-ascii?Q?9w7aiRCDYYrxuTenQ3M0QTvhRtEfBs7jILoRZtJ/Twc=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2020 22:55:51.2698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 9afd52eb-dca2-4353-7cb9-08d89e27e86d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ji4NbuLnUj9nJw4Tg+g52Rn7JyPW9pKHkAh8wvqvUIupqMc02mpB2JFhJgKs9ab4+NwWaEtAgY677CQfH9AgnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4511
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello All,

On Tue, Dec 08, 2020 at 10:29:05AM -0600, Brijesh Singh wrote:
> 
> On 12/7/20 9:09 PM, Steve Rutherford wrote:
> > On Mon, Dec 7, 2020 at 12:42 PM Sean Christopherson <seanjc@google.com> wrote:
> >> On Sun, Dec 06, 2020, Paolo Bonzini wrote:
> >>> On 03/12/20 01:34, Sean Christopherson wrote:
> >>>> On Tue, Dec 01, 2020, Ashish Kalra wrote:
> >>>>> From: Brijesh Singh <brijesh.singh@amd.com>
> >>>>>
> >>>>> KVM hypercall framework relies on alternative framework to patch the
> >>>>> VMCALL -> VMMCALL on AMD platform. If a hypercall is made before
> >>>>> apply_alternative() is called then it defaults to VMCALL. The approach
> >>>>> works fine on non SEV guest. A VMCALL would causes #UD, and hypervisor
> >>>>> will be able to decode the instruction and do the right things. But
> >>>>> when SEV is active, guest memory is encrypted with guest key and
> >>>>> hypervisor will not be able to decode the instruction bytes.
> >>>>>
> >>>>> Add SEV specific hypercall3, it unconditionally uses VMMCALL. The hypercall
> >>>>> will be used by the SEV guest to notify encrypted pages to the hypervisor.
> >>>> What if we invert KVM_HYPERCALL and X86_FEATURE_VMMCALL to default to VMMCALL
> >>>> and opt into VMCALL?  It's a synthetic feature flag either way, and I don't
> >>>> think there are any existing KVM hypercalls that happen before alternatives are
> >>>> patched, i.e. it'll be a nop for sane kernel builds.
> >>>>
> >>>> I'm also skeptical that a KVM specific hypercall is the right approach for the
> >>>> encryption behavior, but I'll take that up in the patches later in the series.
> >>> Do you think that it's the guest that should "donate" memory for the bitmap
> >>> instead?
> >> No.  Two things I'd like to explore:
> >>
> >>   1. Making the hypercall to announce/request private vs. shared common across
> >>      hypervisors (KVM, Hyper-V, VMware, etc...) and technologies (SEV-* and TDX).
> >>      I'm concerned that we'll end up with multiple hypercalls that do more or
> >>      less the same thing, e.g. KVM+SEV, Hyper-V+SEV, TDX, etc...  Maybe it's a
> >>      pipe dream, but I'd like to at least explore options before shoving in KVM-
> >>      only hypercalls.
> >>
> >>
> >>   2. Tracking shared memory via a list of ranges instead of a using bitmap to
> >>      track all of guest memory.  For most use cases, the vast majority of guest
> >>      memory will be private, most ranges will be 2mb+, and conversions between
> >>      private and shared will be uncommon events, i.e. the overhead to walk and
> >>      split/merge list entries is hopefully not a big concern.  I suspect a list
> >>      would consume far less memory, hopefully without impacting performance.
> > For a fancier data structure, I'd suggest an interval tree. Linux
> > already has an rbtree-based interval tree implementation, which would
> > likely work, and would probably assuage any performance concerns.
> >
> > Something like this would not be worth doing unless most of the shared
> > pages were physically contiguous. A sample Ubuntu 20.04 VM on GCP had
> > 60ish discontiguous shared regions. This is by no means a thorough
> > search, but it's suggestive. If this is typical, then the bitmap would
> > be far less efficient than most any interval-based data structure.
> >
> > You'd have to allow userspace to upper bound the number of intervals
> > (similar to the maximum bitmap size), to prevent host OOMs due to
> > malicious guests. There's something nice about the guest donating
> > memory for this, since that would eliminate the OOM risk.
> 
> 
> Tracking the list of ranges may not be bad idea, especially if we use
> the some kind of rbtree-based data structure to update the ranges. It
> will certainly be better than bitmap which grows based on the guest
> memory size and as you guys see in the practice most of the pages will
> be guest private. I am not sure if guest donating a memory will cover
> all the cases, e.g what if we do a memory hotplug (increase the guest
> ram from 2GB to 64GB), will donated memory range will be enough to store
> the metadata.
> 
>. 

With reference to internal discussions regarding the above, i am going
to look into specific items as listed below :

1). "hypercall" related :
a). Explore the SEV-SNP page change request structure (included in GHCB),
see if there is something common there than can be re-used for SEV/SEV-ES
page encryption status hypercalls.
b). Explore if there is any common hypercall framework i can use in 
Linux/KVM.

2). related to the "backing" data structure - explore using a range-based
list or something like rbtree-based interval tree data structure
(as mentioned by Steve above) to replace the current bitmap based
implementation.

Thanks,
Ashish

