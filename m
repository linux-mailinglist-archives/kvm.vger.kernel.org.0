Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9F42ED52B
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 18:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728887AbhAGRIb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 12:08:31 -0500
Received: from mail-co1nam11on2076.outbound.protection.outlook.com ([40.107.220.76]:17248
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727978AbhAGRIa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 12:08:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kx2CZN0bkFRv3h5u4QdGRnC9+REiAwvK9ghT+mfJ0y92rK7qy1TKkgBOQPmFpCGSeCinah8Khn5D2MOE2vvBgthwMSrTKRLcvLkCe2zZV2v1A6xwQ+WDQEp19M44FdlyFB6yl/oCpg2Bhgr4xn4VuABKuBR5leENzDtQalriuxmOA0bTq6VRG98Z+SB6T9K+AIaQ94GilT59G/udhUMoimjtkfNmVF8ibUB1wzmjQCiBKWzL+DazWQEY03MUimFlth/fHEIubdoM5j2HuTE8hh9/a581y/uW1cUO0o7uz125mF0NvjS37zRZfzEiiCXtQAKIvf1gLV+ukl3JqGP9Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TLpkbpQ9wGRQ944sbPameo8/SFmw1SVBSYRFK5JGuwk=;
 b=l365xfkvN99X7VHy+ASruFEEqoYt5gvNdC2+WqZTs39g7G0wW6aQ+AGcWsAFCvqcxUTho6NpI4tpKypb8bpxySbIxTQQPiq0gPNtMpq3iSFG9U8ejjkfCdcfogk6m6C7PgKaIfpBlGh/KeLs4QAuwakQf72zEJw2v1KWONPe2qdgpsoAWJ56Vrn84PWZ93ZPUiQfLRcFQkODJUnjs8fCb8clDanjH28Hg2rVn20q5QsjlezxWl1zh0qz1NE23G0Exm3fk6d1KKt+31tXq+wDLojx9Nh5gNJYFThXyjFfQhu8ZslPDxmqzC+hCM4ptlCRp5CxtVt9jGAZU0zBL/nmPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TLpkbpQ9wGRQ944sbPameo8/SFmw1SVBSYRFK5JGuwk=;
 b=vdJf5roHJsOul3mHjX0VQcV89WruHziOJ+RR7pGuTM4lgGT2/BQNbZ0JA+mWj/PdWPypWYTPUvNybTkMVFaqetf2jKEXaXtHkAysjlKLjmjqbmPZ2Jh0P6PGD+fCBDpKD1Rvqg6gqsiR2qX3cgvtseSqpPTO1JiowuDBS3Jj+Ik=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4431.namprd12.prod.outlook.com (2603:10b6:806:95::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20; Thu, 7 Jan
 2021 17:07:35 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::209d:4e20:fc9e:a726]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::209d:4e20:fc9e:a726%6]) with mapi id 15.20.3742.006; Thu, 7 Jan 2021
 17:07:35 +0000
Date:   Thu, 7 Jan 2021 17:07:28 +0000
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
Message-ID: <20210107170728.GA16965@ashkalra_ubuntu_server>
References: <X86Tlin14Ct38zDt@google.com>
 <CABayD+esy0yeKi9W3wQw+ou4y4840LPCwd-PHhN1J6Uh_fvSjA@mail.gmail.com>
 <765f86ae-7c68-6722-c6e0-c6150ce69e59@amd.com>
 <20201211225542.GA30409@ashkalra_ubuntu_server>
 <20201212045603.GA27415@ashkalra_ubuntu_server>
 <20201218193956.GJ2956@work-vm>
 <E79E09A2-F314-4B59-B7AE-07B1D422DF2B@amd.com>
 <20201218195641.GL2956@work-vm>
 <20210106230555.GA13999@ashkalra_ubuntu_server>
 <CABayD+dQwaeCnr5_+DUpvbQ42O6cZBMO79pEEzi5WXPO=NH3iA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABayD+dQwaeCnr5_+DUpvbQ42O6cZBMO79pEEzi5WXPO=NH3iA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR13CA0217.namprd13.prod.outlook.com
 (2603:10b6:806:25::12) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SA9PR13CA0217.namprd13.prod.outlook.com (2603:10b6:806:25::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.4 via Frontend Transport; Thu, 7 Jan 2021 17:07:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 637d141f-9465-4d79-f9d2-08d8b32eba92
X-MS-TrafficTypeDiagnostic: SA0PR12MB4431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44312664B8FC68E81CD644328EAF0@SA0PR12MB4431.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lFj1WnHj2yA9r1cgflxba9V32aU7KTfZWuDL+gPj8BBiUR7aT5UtGLrhXEqnpJNA8zeclRerR4QcwA0zT0uDwif+rMT6clEcQpuUYUc1OCs+8joycXXP4cCWub4FSwRZAkNZwMYoSls3SAHBLEeOY7OibQ6S+c+c0BX1D86Q70B/NuDHTxXeauDMLqEpr3nsMj68KzwlFl0tT0YzzMkQg7NCbzJ/PZN5/DdWh200NOdDRY1TbZ73Q0jsjeh6+Rx4O3Cwxfpm4SrklwZb1jnXogsxTWgZSWflq/qIZmVU6VpgdNFHxT0zmU3lhiGh3oGj49HXEetqvHzEQA3V7RDGC9xqcF9d/tnqQCBOX5FLcmXWZ9kCGtBpJWLqeDVISxrnn0sf7fPYVFR7ajzZidKPhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(396003)(136003)(39860400002)(30864003)(26005)(6916009)(5660300002)(44832011)(83380400001)(1076003)(478600001)(16526019)(956004)(66556008)(66946007)(6496006)(186003)(33716001)(52116002)(55016002)(53546011)(86362001)(7416002)(66476007)(316002)(6666004)(54906003)(8936002)(8676002)(2906002)(33656002)(4326008)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MXQxa3NsMFYyQ3Q4bVdjaUNhWU5PUlE3SE42aWg2MnErUXlYUjAwdWZnMzlN?=
 =?utf-8?B?VEl2UTIxV2tJUUlCWmh4SGpXSVFjOGZOU0g1ekljWTVXdHJ1amJxMEJQS0dZ?=
 =?utf-8?B?ZFhha1l1UmZQYkRVUkF1QnAzOFVpYUxZVlVzSHRKd1hmeUthLzJIdUJBRUdw?=
 =?utf-8?B?RDlWSXZXY3pIZkgvZkZGT0Z2b0FjWjhjNzVlZ2p4NWJtbnlwK3ozVE1UcFNT?=
 =?utf-8?B?aGM0VUZHTTJyZjV0TUR2MXZRMGVSWjNac3ZCY2RDQTBLSUs2Qmd4c0dGczVF?=
 =?utf-8?B?SkwzU0E4RExHN0ovTC9oNzNqQUpjaWZIWjRWcGVwdnFYUVorUmh4VzF4Yy9E?=
 =?utf-8?B?S3ZWVFBEc2hFdkhNRXkzM3lpcFQ0TTd6cDhSMW1uY0JXanNzSitibk5sQUtj?=
 =?utf-8?B?Zkd4VVI1WlJ4NjUzUHFKNTRsM1dYTDl6YjZEeDAyTmM4VlJ1Q0xiZlFsOFE3?=
 =?utf-8?B?NExadzJZNlNrakFEMXh6NFBVeWhZeVpuVUZpNzNNMmpaQUx3ZDE4QUlXVW8r?=
 =?utf-8?B?SlJWNUY0SEpzVmFDR3h2aDdySjF5Slh5M1JyREJwQWlYWkVEb1V2RmQ2aFpO?=
 =?utf-8?B?YzgxOVVPNE9FM1lHcUVnbk1jcm9IVW1wclNiL2lDVCtIYkIvSzMwSnZic2Fw?=
 =?utf-8?B?TnBnVjNMQXUxbExlRzlITzdCdkFwUyt2OE1JVlpSVkZ0N3RWNVcyaUFjNkg0?=
 =?utf-8?B?YmcwdFdsVHRxNDRBeDVFbFpDc000RUlHcGsvOGdNa21UTUV6S2g3R3R2N0t1?=
 =?utf-8?B?ZnZxU0hoeVhvU1JBekJkVmd1MDA5aHRseXp2UGZQalk4VmlWNUZTdGVtNTRI?=
 =?utf-8?B?QWUyMUNCeUJwSGZhZFJRcm5VM1p2dXZ0c3RRcFA2ZmVCV3BsU0xIWHJuUC9o?=
 =?utf-8?B?ak9CRCtqcVFIUWh6NGpITCtVYnJBcEtWN1oxRmdPMFBMKzFtRCsvbDYwdTAw?=
 =?utf-8?B?eDd5aUw0blZuRlpYeW5FMm1wZThRT3hsMjM1UTd4QVhIMWxJclUrcEhlV3lY?=
 =?utf-8?B?dmZONk5waDhvWnFHL0o4L1Z0WitXcGgrS3pqUHB3ejNBT3VMZTNIeFc5bXBq?=
 =?utf-8?B?U2txbUxjcHNZNmY1ZjFHUkUrTUhadE1KbGc4ZE0xanVPWnh1cHFyeDUyMEVK?=
 =?utf-8?B?aDlpalEvR0tMQlZ4cmhHWGg4cTc5bkhPVVMrbFpySmp1Ryt3ditwd1hWOXZz?=
 =?utf-8?B?akVuRWFOOENIZkpJaHg2aWxnT1M5NWRFWlRTY2VBb3hzRmRKcXNsczRpY0J5?=
 =?utf-8?B?RU9GKzQwVE5PRE53dXd1d1VFMlZoL0wveWZJMm00QnJzRDlFR05qVTdyZ0l2?=
 =?utf-8?Q?pjPXcBoa58sCqfHyC0nGhyUxWTD1Jx/Noc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2021 17:07:35.2507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 637d141f-9465-4d79-f9d2-08d8b32eba92
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: use2J71zvXYuYDzOT6Z5u92vvIi+K1hkl9cOCDvYlX9lO89VuYKBCMp46DxKfGe0haQz3lsc+XoEXANY8amNzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4431
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Steve,

On Wed, Jan 06, 2021 at 05:01:33PM -0800, Steve Rutherford wrote:
> Avoiding an rbtree for such a small (but unstable) list seems correct.
> 
> For the unencrypted region list strategy, the only questions that I
> have are fairly secondary.
> - How should the kernel upper bound the size of the list in the face
> of malicious guests, but still support large guests? (Something
> similar to the size provided in the bitmap API would work).

I am thinking of another scenario, where a malicious guest can make
infinite/repetetive hypercalls and DOS attack the host. 

But probably this is a more generic issue, this can be done by any guest
and under any hypervisor, i don't know what kind of mitigations exist
for such a scenario ?

Potentially, the guest memory donation model can handle such an attack,
because in this model, the hypervisor will expect only one hypercall,
any repetetive hypercalls can make the hypervisor disable the guest ?

Thanks,
Ashish

> - What serialization format should be used for the ioctl API?
> (Usermode could send down a pointer to a user region and a size. The
> kernel could then populate that with an array of structs containing
> bases and limits for unencrypted regions.)
> - How will the kernel tag a guest as having exceeded its maximum list
> size, in order to indicate that the list is now incomplete? (Track a
> poison bit, and send it up when getting the serialized list of
> regions).
> 
> In my view, there are two main competitors to this strategy:
> - (Existing) Bitmap API
> - A guest memory donation based model
> 
> The existing bitmap API avoids any issues with growing too large,
> since it's size is predictable.
> 
> To elaborate on the memory donation based model, the guest could put
> an encryption status data structure into unencrypted guest memory, and
> then use a hypercall to inform the host where the base of that
> structure is located. The main advantage of this is that it side steps
> any issues around malicious guests causing large allocations.
> 
> The unencrypted region list seems very practical. It's biggest
> advantage over the bitmap is how cheap it will be to pass the
> structure up from the kernel. A memory donation based model could
> achieve similar performance, but with some additional complexity.
> 
> Does anyone view the memory donation model as worth the complexity?
> Does anyone think the simplicity of the bitmap is a better tradeoff
> compared to an unencrypted region list?
> Or have other ideas that are not mentioned here?
> 
> 
> On Wed, Jan 6, 2021 at 3:06 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> >
> > On Fri, Dec 18, 2020 at 07:56:41PM +0000, Dr. David Alan Gilbert wrote:
> > > * Kalra, Ashish (Ashish.Kalra@amd.com) wrote:
> > > > Hello Dave,
> > > >
> > > > On Dec 18, 2020, at 1:40 PM, Dr. David Alan Gilbert <dgilbert@redhat.com> wrote:
> > > >
> > > > ﻿* Ashish Kalra (ashish.kalra@amd.com) wrote:
> > > > On Fri, Dec 11, 2020 at 10:55:42PM +0000, Ashish Kalra wrote:
> > > > Hello All,
> > > >
> > > > On Tue, Dec 08, 2020 at 10:29:05AM -0600, Brijesh Singh wrote:
> > > >
> > > > On 12/7/20 9:09 PM, Steve Rutherford wrote:
> > > > On Mon, Dec 7, 2020 at 12:42 PM Sean Christopherson <seanjc@google.com> wrote:
> > > > On Sun, Dec 06, 2020, Paolo Bonzini wrote:
> > > > On 03/12/20 01:34, Sean Christopherson wrote:
> > > > On Tue, Dec 01, 2020, Ashish Kalra wrote:
> > > > From: Brijesh Singh <brijesh.singh@amd.com>
> > > >
> > > > KVM hypercall framework relies on alternative framework to patch the
> > > > VMCALL -> VMMCALL on AMD platform. If a hypercall is made before
> > > > apply_alternative() is called then it defaults to VMCALL. The approach
> > > > works fine on non SEV guest. A VMCALL would causes #UD, and hypervisor
> > > > will be able to decode the instruction and do the right things. But
> > > > when SEV is active, guest memory is encrypted with guest key and
> > > > hypervisor will not be able to decode the instruction bytes.
> > > >
> > > > Add SEV specific hypercall3, it unconditionally uses VMMCALL. The hypercall
> > > > will be used by the SEV guest to notify encrypted pages to the hypervisor.
> > > > What if we invert KVM_HYPERCALL and X86_FEATURE_VMMCALL to default to VMMCALL
> > > > and opt into VMCALL?  It's a synthetic feature flag either way, and I don't
> > > > think there are any existing KVM hypercalls that happen before alternatives are
> > > > patched, i.e. it'll be a nop for sane kernel builds.
> > > >
> > > > I'm also skeptical that a KVM specific hypercall is the right approach for the
> > > > encryption behavior, but I'll take that up in the patches later in the series.
> > > > Do you think that it's the guest that should "donate" memory for the bitmap
> > > > instead?
> > > > No.  Two things I'd like to explore:
> > > >
> > > >  1. Making the hypercall to announce/request private vs. shared common across
> > > >     hypervisors (KVM, Hyper-V, VMware, etc...) and technologies (SEV-* and TDX).
> > > >     I'm concerned that we'll end up with multiple hypercalls that do more or
> > > >     less the same thing, e.g. KVM+SEV, Hyper-V+SEV, TDX, etc...  Maybe it's a
> > > >     pipe dream, but I'd like to at least explore options before shoving in KVM-
> > > >     only hypercalls.
> > > >
> > > >
> > > >  2. Tracking shared memory via a list of ranges instead of a using bitmap to
> > > >     track all of guest memory.  For most use cases, the vast majority of guest
> > > >     memory will be private, most ranges will be 2mb+, and conversions between
> > > >     private and shared will be uncommon events, i.e. the overhead to walk and
> > > >     split/merge list entries is hopefully not a big concern.  I suspect a list
> > > >     would consume far less memory, hopefully without impacting performance.
> > > > For a fancier data structure, I'd suggest an interval tree. Linux
> > > > already has an rbtree-based interval tree implementation, which would
> > > > likely work, and would probably assuage any performance concerns.
> > > >
> > > > Something like this would not be worth doing unless most of the shared
> > > > pages were physically contiguous. A sample Ubuntu 20.04 VM on GCP had
> > > > 60ish discontiguous shared regions. This is by no means a thorough
> > > > search, but it's suggestive. If this is typical, then the bitmap would
> > > > be far less efficient than most any interval-based data structure.
> > > >
> > > > You'd have to allow userspace to upper bound the number of intervals
> > > > (similar to the maximum bitmap size), to prevent host OOMs due to
> > > > malicious guests. There's something nice about the guest donating
> > > > memory for this, since that would eliminate the OOM risk.
> > > >
> > > >
> > > > Tracking the list of ranges may not be bad idea, especially if we use
> > > > the some kind of rbtree-based data structure to update the ranges. It
> > > > will certainly be better than bitmap which grows based on the guest
> > > > memory size and as you guys see in the practice most of the pages will
> > > > be guest private. I am not sure if guest donating a memory will cover
> > > > all the cases, e.g what if we do a memory hotplug (increase the guest
> > > > ram from 2GB to 64GB), will donated memory range will be enough to store
> > > > the metadata.
> > > >
> > > > .
> > > >
> > > > With reference to internal discussions regarding the above, i am going
> > > > to look into specific items as listed below :
> > > >
> > > > 1). "hypercall" related :
> > > > a). Explore the SEV-SNP page change request structure (included in GHCB),
> > > > see if there is something common there than can be re-used for SEV/SEV-ES
> > > > page encryption status hypercalls.
> > > > b). Explore if there is any common hypercall framework i can use in
> > > > Linux/KVM.
> > > >
> > > > 2). related to the "backing" data structure - explore using a range-based
> > > > list or something like rbtree-based interval tree data structure
> > > > (as mentioned by Steve above) to replace the current bitmap based
> > > > implementation.
> > > >
> > > >
> > > >
> > > > I do agree that a range-based list or an interval tree data structure is a
> > > > really good "logical" fit for the guest page encryption status tracking.
> > > >
> > > > We can only keep track of the guest unencrypted shared pages in the
> > > > range(s) list (which will keep the data structure quite compact) and all
> > > > the guest private/encrypted memory does not really need any tracking in
> > > > the list, anything not in the list will be encrypted/private.
> > > >
> > > > Also looking at a more "practical" use case, here is the current log of
> > > > page encryption status hypercalls when booting a linux guest :
> > > >
> > > > ...
> > > >
> > > > <snip>
> > > >
> > > > [   56.146336] page_enc_status_hc invoked, gpa = 1f018000, npages  = 1, enc = 1
> > > > [   56.146351] page_enc_status_hc invoked, gpa = 1f00e000, npages  = 1, enc = 0
> > > > [   56.147261] page_enc_status_hc invoked, gpa = 1f00e000, npages  = 1, enc = 0
> > > > [   56.147271] page_enc_status_hc invoked, gpa = 1f018000, npages  = 1, enc = 0
> > > > ....
> > > >
> > > > [   56.180730] page_enc_status_hc invoked, gpa = 1f008000, npages  = 1, enc = 0
> > > > [   56.180741] page_enc_status_hc invoked, gpa = 1f006000, npages  = 1, enc = 0
> > > > [   56.180768] page_enc_status_hc invoked, gpa = 1f008000, npages  = 1, enc = 1
> > > > [   56.180782] page_enc_status_hc invoked, gpa = 1f006000, npages  = 1, enc = 1
> > > >
> > > > ....
> > > > [   56.197110] page_enc_status_hc invoked, gpa = 1f007000, npages  = 1, enc = 0
> > > > [   56.197120] page_enc_status_hc invoked, gpa = 1f005000, npages  = 1, enc = 0
> > > > [   56.197136] page_enc_status_hc invoked, gpa = 1f007000, npages  = 1, enc = 1
> > > > [   56.197148] page_enc_status_hc invoked, gpa = 1f005000, npages  = 1, enc = 1
> > > > ....
> > > >
> > > > [   56.222679] page_enc_status_hc invoked, gpa = 1e83b000, npages  = 1, enc = 0
> > > > [   56.222691] page_enc_status_hc invoked, gpa = 1e839000, npages  = 1, enc = 0
> > > > [   56.222707] page_enc_status_hc invoked, gpa = 1e83b000, npages  = 1, enc = 1
> > > > [   56.222720] page_enc_status_hc invoked, gpa = 1e839000, npages  = 1, enc = 1
> > > > ....
> > > >
> > > > [   56.313747] page_enc_status_hc invoked, gpa = 1e5eb000, npages  = 1, enc = 0
> > > > [   56.313771] page_enc_status_hc invoked, gpa = 1e5e9000, npages  = 1, enc = 0
> > > > [   56.313789] page_enc_status_hc invoked, gpa = 1e5eb000, npages  = 1, enc = 1
> > > > [   56.313803] page_enc_status_hc invoked, gpa = 1e5e9000, npages  = 1, enc = 1
> > > > ....
> > > > [   56.459276] page_enc_status_hc invoked, gpa = 1d767000, npages  = 100, enc = 0
> > > > [   56.459428] page_enc_status_hc invoked, gpa = 1e501000, npages  = 1, enc = 1
> > > > [   56.460037] page_enc_status_hc invoked, gpa = 1d767000, npages  = 100, enc = 1
> > > > [   56.460216] page_enc_status_hc invoked, gpa = 1e501000, npages  = 1, enc = 0
> > > > [   56.460299] page_enc_status_hc invoked, gpa = 1d767000, npages  = 100, enc = 0
> > > > [   56.460448] page_enc_status_hc invoked, gpa = 1e501000, npages  = 1, enc = 1
> > > > ....
> > > >
> > > > As can be observed here, all guest MMIO ranges are initially setup as
> > > > shared, and those are all contigious guest page ranges.
> > > >
> > > > After that the encryption status hypercalls are invoked when DMA gets
> > > > triggered during disk i/o while booting the guest ... here again the
> > > > guest page ranges are contigious, though mostly single page is touched
> > > > and a lot of page re-use is observed.
> > > >
> > > > So a range-based list/structure will be a "good" fit for such usage
> > > > scenarios.
> > > >
> > > > It seems surprisingly common to flick the same pages back and forth between
> > > > encrypted and clear for quite a while;  why is this?
> > > >
> > > >
> > > > dma_alloc_coherent()'s will allocate pages and then call
> > > > set_decrypted() on them and then at dma_free_coherent(), set_encrypted()
> > > > is called on the pages to be freed. So these observations in the logs
> > > > where a lot of single 4K pages are seeing C-bit transitions and
> > > > corresponding hypercalls are the ones associated with
> > > > dma_alloc_coherent().
> > >
> > > It makes me wonder if it might be worth teaching it to hold onto those
> > > DMA pages somewhere until it needs them for something else and avoid the
> > > extra hypercalls; just something to think about.
> > >
> > > Dave
> >
> > Following up on this discussion and looking at the hypercall logs and DMA usage scenarios on the SEV, I have the following additional observations and comments :
> >
> > It is mostly the Guest MMIO regions setup as un-encrypted by uefi/edk2 initially, which will be the "static" nodes in the backing data structure for page encryption status.
> > These will be like 15-20 nodes/entries.
> >
> > Drivers doing DMA allocations using GFP_ATOMIC will be fetching DMA buffers from the pre-allocated unencrypted atomic pool, hence it will be a "static" node added at kernel startup.
> >
> > As we see with the logs, almost all runtime C-bit transitions and corresponding hypercalls will be from DMA I/O and dma_alloc_coherent/dma_free_coherent calls, these will be
> > using 4K/single pages and mostly fragmented ranges, so if we use a "rbtree" based interval tree then there will be a lot of tree insertions and deletions
> > (dma_alloc_coherent followed with a dma_free_coherent), so this will lead to a lot of expensive tree rotations and re-balancing, compared to much less complex
> > and faster linked list node insertions and deletions (if we use a list based structure to represent these interval ranges).
> >
> > Also as the static nodes in the structure will be quite limited (all the above DMA I/O added ranges will simply be inserted and removed), so a linked list lookup
> > won't be too expensive compared to a tree lookup. In other words, this be a fixed size list.
> >
> > Looking at the above, I am now more inclined to use a list based structure to represent the page encryption status.
> >
> > Looking fwd. to any comments/feedback/thoughts on the above.
> >
> > Thanks,
> > Ashish
> >
