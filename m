Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F5B32C74B
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348455AbhCDAb0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:31:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:58952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350709AbhCCTHM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 14:07:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A50B460295;
        Wed,  3 Mar 2021 18:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614797686;
        bh=VvdHgeO+iQVf3eIjuMwh61McP98q/nFsCYMgj2hHtHY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F+3vRqPw29Z34PJSpXoiojQjxz+xVAP2QoOiLhr1TYNJpnpJ9wZ1mL8hManZDugh4
         cYgJLjGjUSOHa4IaW3rObM7WSl7wnkMAg7jjh/4aazxCC9p7dJu/YTIplwEj/w2cNa
         GOQ6eKCSjU0qWhAdxqUtdeJMmfX7Sg7udBlkVSt0M18aLgVIVRHzf/AM/Q/J5KXLJ4
         FP1izSPsRg06eSzw/UZrUBe4THImi3mkqbyWuLJeLpHaEbZpYxHMYNCBzA8B08aXZq
         hXSfzZ23DIclBgG9arVJJdDZGbz1KdpESzYmJ1+So2oZs7IdUwdKxtiZLllqTc/HQg
         5hQXMHeYFkNKw==
Date:   Wed, 3 Mar 2021 18:54:41 +0000
From:   Will Deacon <will@kernel.org>
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Steve Rutherford <srutherford@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "venu.busireddy@oracle.com" <venu.busireddy@oracle.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Quentin Perret <qperret@google.com>, maz@kernel.org
Subject: Re: [PATCH v10 10/16] KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIST
 ioctl
Message-ID: <20210303185441.GA19944@willie-the-truck>
References: <7266edd714add8ec9d7f63eddfc9bbd4d789c213.1612398155.git.ashish.kalra@amd.com>
 <YCxrV4u98ZQtInOE@google.com>
 <SN6PR12MB27672FF8358D122EDD8CC0188E859@SN6PR12MB2767.namprd12.prod.outlook.com>
 <20210224175122.GA19661@ashkalra_ubuntu_server>
 <YDaZacLqNQ4nK/Ex@google.com>
 <20210225202008.GA5208@ashkalra_ubuntu_server>
 <CABayD+cn5e3PR6NtSWLeM_qxs6hKWtjEx=aeKpy=WC2dzPdRLw@mail.gmail.com>
 <20210226140432.GB5950@ashkalra_ubuntu_server>
 <YDkzibkC7tAYbfFQ@google.com>
 <20210302145543.GA29994@ashkalra_ubuntu_server>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210302145543.GA29994@ashkalra_ubuntu_server>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[+Marc]

On Tue, Mar 02, 2021 at 02:55:43PM +0000, Ashish Kalra wrote:
> On Fri, Feb 26, 2021 at 09:44:41AM -0800, Sean Christopherson wrote:
> > On Fri, Feb 26, 2021, Ashish Kalra wrote:
> > > On Thu, Feb 25, 2021 at 02:59:27PM -0800, Steve Rutherford wrote:
> > > > On Thu, Feb 25, 2021 at 12:20 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> > > > Thanks for grabbing the data!
> > > > 
> > > > I am fine with both paths. Sean has stated an explicit desire for
> > > > hypercall exiting, so I think that would be the current consensus.
> > 
> > Yep, though it'd be good to get Paolo's input, too.
> > 
> > > > If we want to do hypercall exiting, this should be in a follow-up
> > > > series where we implement something more generic, e.g. a hypercall
> > > > exiting bitmap or hypercall exit list. If we are taking the hypercall
> > > > exit route, we can drop the kvm side of the hypercall.
> > 
> > I don't think this is a good candidate for arbitrary hypercall interception.  Or
> > rather, I think hypercall interception should be an orthogonal implementation.
> > 
> > The guest, including guest firmware, needs to be aware that the hypercall is
> > supported, and the ABI needs to be well-defined.  Relying on userspace VMMs to
> > implement a common ABI is an unnecessary risk.
> > 
> > We could make KVM's default behavior be a nop, i.e. have KVM enforce the ABI but
> > require further VMM intervention.  But, I just don't see the point, it would
> > save only a few lines of code.  It would also limit what KVM could do in the
> > future, e.g. if KVM wanted to do its own bookkeeping _and_ exit to userspace,
> > then mandatory interception would essentially make it impossible for KVM to do
> > bookkeeping while still honoring the interception request.
> > 
> > However, I do think it would make sense to have the userspace exit be a generic
> > exit type.  But hey, we already have the necessary ABI defined for that!  It's
> > just not used anywhere.
> > 
> > 	/* KVM_EXIT_HYPERCALL */
> > 	struct {
> > 		__u64 nr;
> > 		__u64 args[6];
> > 		__u64 ret;
> > 		__u32 longmode;
> > 		__u32 pad;
> > 	} hypercall;
> > 
> > 
> > > > Userspace could also handle the MSR using MSR filters (would need to
> > > > confirm that).  Then userspace could also be in control of the cpuid bit.
> > 
> > An MSR is not a great fit; it's x86 specific and limited to 64 bits of data.
> > The data limitation could be fudged by shoving data into non-standard GPRs, but
> > that will result in truly heinous guest code, and extensibility issues.
> > 
> > The data limitation is a moot point, because the x86-only thing is a deal
> > breaker.  arm64's pKVM work has a near-identical use case for a guest to share
> > memory with a host.  I can't think of a clever way to avoid having to support
> > TDX's and SNP's hypervisor-agnostic variants, but we can at least not have
> > multiple KVM variants.
> 
> Looking at arm64's pKVM work, i see that it is a recently introduced RFC
> patch-set and probably relevant to arm64 nVHE hypervisor
> mode/implementation, and potentially makes sense as it adds guest
> memory protection as both host and guest kernels are running on the same
> privilege level ?
> 
> Though i do see that the pKVM stuff adds two hypercalls, specifically :
> 
> pkvm_create_mappings() ( I assume this is for setting shared memory
> regions between host and guest) &
> pkvm_create_private_mappings().
> 
> And the use-cases are quite similar to memory protection architectues
> use cases, for example, use with virtio devices, guest DMA I/O, etc.

These hypercalls are both private to the host kernel communicating with
its hypervisor counterpart, so I don't think they're particularly
relevant here. As far as I can see, the more useful thing is to allow
the guest to communicate back to the host (and the VMM) that it has opened
up a memory window, perhaps for virtio rings or some other shared memory.

We hacked this up as a prototype in the past:

https://android-kvm.googlesource.com/linux/+/d12a9e2c12a52cf7140d40cd9fa092dc8a85fac9%5E%21/

but that's all arm64-specific and if we're solving the same problem as
you, then let's avoid arch-specific stuff if possible. The way in which
the guest discovers the interface will be arch-specific (we already have
a mechanism for that and some hypercalls are already allocated by specs
from Arm), but the interface back to the VMM and some (most?) of the host
handling could be shared.

> But, isn't this patch set still RFC, and though i agree that it adds
> an infrastructure for standardised communication between the host and
> it's guests for mutually controlled shared memory regions and
> surely adds some kind of portability between hypervisor
> implementations, but nothing is standardised still, right ?

No, and it seems that you're further ahead than us in terms of
implementation in this area. We're happy to review patches though, to
make sure we end up with something that works for us both.

Will
