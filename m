Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D80E2DE9DB
	for <lists+kvm@lfdr.de>; Fri, 18 Dec 2020 20:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733248AbgLRTlg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Dec 2020 14:41:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52522 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733244AbgLRTlf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Dec 2020 14:41:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608320408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qTqL06D7b4fb7cUvZJDJjp0eb7f5gIGXVqXJeXuddJU=;
        b=BgsYPRV1z3Neo417ImsrLI9EKwxySRMIKyEkn+sxAdGo7jQQbSSJyZk00aybTFlluDOzo+
        dptVNVvOJzYBEbfQdL16U2Fe7UYgRQl08SlokvnP1wMNMWuzz8Nq02hy9/1ZYTGVYbBily
        nBu72br64nqJtX11JIB5wT65hkxNPNY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-yIelHva4MIC_T5AEBbVHEQ-1; Fri, 18 Dec 2020 14:40:06 -0500
X-MC-Unique: yIelHva4MIC_T5AEBbVHEQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 965086D522;
        Fri, 18 Dec 2020 19:40:03 +0000 (UTC)
Received: from work-vm (ovpn-114-200.ams2.redhat.com [10.36.114.200])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BD4172CE56;
        Fri, 18 Dec 2020 19:39:58 +0000 (UTC)
Date:   Fri, 18 Dec 2020 19:39:56 +0000
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>,
        Steve Rutherford <srutherford@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, dovmurik@linux.vnet.ibm.com,
        tobin@ibm.com, jejb@linux.ibm.com, frankeh@us.ibm.com
Subject: Re: [PATCH v2 1/9] KVM: x86: Add AMD SEV specific Hypercall3
Message-ID: <20201218193956.GJ2956@work-vm>
References: <cover.1606782580.git.ashish.kalra@amd.com>
 <b6bc54ed6c8ae4444f3acf1ed4386010783ad386.1606782580.git.ashish.kalra@amd.com>
 <X8gyhCsEMf8QU9H/@google.com>
 <d63529ce-d613-9f83-6cfc-012a8b333e38@redhat.com>
 <X86Tlin14Ct38zDt@google.com>
 <CABayD+esy0yeKi9W3wQw+ou4y4840LPCwd-PHhN1J6Uh_fvSjA@mail.gmail.com>
 <765f86ae-7c68-6722-c6e0-c6150ce69e59@amd.com>
 <20201211225542.GA30409@ashkalra_ubuntu_server>
 <20201212045603.GA27415@ashkalra_ubuntu_server>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201212045603.GA27415@ashkalra_ubuntu_server>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Ashish Kalra (ashish.kalra@amd.com) wrote:
> On Fri, Dec 11, 2020 at 10:55:42PM +0000, Ashish Kalra wrote:
> > Hello All,
> > 
> > On Tue, Dec 08, 2020 at 10:29:05AM -0600, Brijesh Singh wrote:
> > > 
> > > On 12/7/20 9:09 PM, Steve Rutherford wrote:
> > > > On Mon, Dec 7, 2020 at 12:42 PM Sean Christopherson <seanjc@google.com> wrote:
> > > >> On Sun, Dec 06, 2020, Paolo Bonzini wrote:
> > > >>> On 03/12/20 01:34, Sean Christopherson wrote:
> > > >>>> On Tue, Dec 01, 2020, Ashish Kalra wrote:
> > > >>>>> From: Brijesh Singh <brijesh.singh@amd.com>
> > > >>>>>
> > > >>>>> KVM hypercall framework relies on alternative framework to patch the
> > > >>>>> VMCALL -> VMMCALL on AMD platform. If a hypercall is made before
> > > >>>>> apply_alternative() is called then it defaults to VMCALL. The approach
> > > >>>>> works fine on non SEV guest. A VMCALL would causes #UD, and hypervisor
> > > >>>>> will be able to decode the instruction and do the right things. But
> > > >>>>> when SEV is active, guest memory is encrypted with guest key and
> > > >>>>> hypervisor will not be able to decode the instruction bytes.
> > > >>>>>
> > > >>>>> Add SEV specific hypercall3, it unconditionally uses VMMCALL. The hypercall
> > > >>>>> will be used by the SEV guest to notify encrypted pages to the hypervisor.
> > > >>>> What if we invert KVM_HYPERCALL and X86_FEATURE_VMMCALL to default to VMMCALL
> > > >>>> and opt into VMCALL?  It's a synthetic feature flag either way, and I don't
> > > >>>> think there are any existing KVM hypercalls that happen before alternatives are
> > > >>>> patched, i.e. it'll be a nop for sane kernel builds.
> > > >>>>
> > > >>>> I'm also skeptical that a KVM specific hypercall is the right approach for the
> > > >>>> encryption behavior, but I'll take that up in the patches later in the series.
> > > >>> Do you think that it's the guest that should "donate" memory for the bitmap
> > > >>> instead?
> > > >> No.  Two things I'd like to explore:
> > > >>
> > > >>   1. Making the hypercall to announce/request private vs. shared common across
> > > >>      hypervisors (KVM, Hyper-V, VMware, etc...) and technologies (SEV-* and TDX).
> > > >>      I'm concerned that we'll end up with multiple hypercalls that do more or
> > > >>      less the same thing, e.g. KVM+SEV, Hyper-V+SEV, TDX, etc...  Maybe it's a
> > > >>      pipe dream, but I'd like to at least explore options before shoving in KVM-
> > > >>      only hypercalls.
> > > >>
> > > >>
> > > >>   2. Tracking shared memory via a list of ranges instead of a using bitmap to
> > > >>      track all of guest memory.  For most use cases, the vast majority of guest
> > > >>      memory will be private, most ranges will be 2mb+, and conversions between
> > > >>      private and shared will be uncommon events, i.e. the overhead to walk and
> > > >>      split/merge list entries is hopefully not a big concern.  I suspect a list
> > > >>      would consume far less memory, hopefully without impacting performance.
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
> > > 
> > > 
> > > Tracking the list of ranges may not be bad idea, especially if we use
> > > the some kind of rbtree-based data structure to update the ranges. It
> > > will certainly be better than bitmap which grows based on the guest
> > > memory size and as you guys see in the practice most of the pages will
> > > be guest private. I am not sure if guest donating a memory will cover
> > > all the cases, e.g what if we do a memory hotplug (increase the guest
> > > ram from 2GB to 64GB), will donated memory range will be enough to store
> > > the metadata.
> > > 
> > >. 
> > 
> > With reference to internal discussions regarding the above, i am going
> > to look into specific items as listed below :
> > 
> > 1). "hypercall" related :
> > a). Explore the SEV-SNP page change request structure (included in GHCB),
> > see if there is something common there than can be re-used for SEV/SEV-ES
> > page encryption status hypercalls.
> > b). Explore if there is any common hypercall framework i can use in 
> > Linux/KVM.
> > 
> > 2). related to the "backing" data structure - explore using a range-based
> > list or something like rbtree-based interval tree data structure
> > (as mentioned by Steve above) to replace the current bitmap based
> > implementation.
> > 
> > 
> 
> I do agree that a range-based list or an interval tree data structure is a
> really good "logical" fit for the guest page encryption status tracking.
> 
> We can only keep track of the guest unencrypted shared pages in the
> range(s) list (which will keep the data structure quite compact) and all
> the guest private/encrypted memory does not really need any tracking in
> the list, anything not in the list will be encrypted/private.
> 
> Also looking at a more "practical" use case, here is the current log of
> page encryption status hypercalls when booting a linux guest :
> 
> ...

<snip>

> [   56.146336] page_enc_status_hc invoked, gpa = 1f018000, npages  = 1, enc = 1
> [   56.146351] page_enc_status_hc invoked, gpa = 1f00e000, npages  = 1, enc = 0
> [   56.147261] page_enc_status_hc invoked, gpa = 1f00e000, npages  = 1, enc = 0
> [   56.147271] page_enc_status_hc invoked, gpa = 1f018000, npages  = 1, enc = 0
....

> [   56.180730] page_enc_status_hc invoked, gpa = 1f008000, npages  = 1, enc = 0
> [   56.180741] page_enc_status_hc invoked, gpa = 1f006000, npages  = 1, enc = 0
> [   56.180768] page_enc_status_hc invoked, gpa = 1f008000, npages  = 1, enc = 1
> [   56.180782] page_enc_status_hc invoked, gpa = 1f006000, npages  = 1, enc = 1

....
> [   56.197110] page_enc_status_hc invoked, gpa = 1f007000, npages  = 1, enc = 0
> [   56.197120] page_enc_status_hc invoked, gpa = 1f005000, npages  = 1, enc = 0
> [   56.197136] page_enc_status_hc invoked, gpa = 1f007000, npages  = 1, enc = 1
> [   56.197148] page_enc_status_hc invoked, gpa = 1f005000, npages  = 1, enc = 1
....

> [   56.222679] page_enc_status_hc invoked, gpa = 1e83b000, npages  = 1, enc = 0
> [   56.222691] page_enc_status_hc invoked, gpa = 1e839000, npages  = 1, enc = 0
> [   56.222707] page_enc_status_hc invoked, gpa = 1e83b000, npages  = 1, enc = 1
> [   56.222720] page_enc_status_hc invoked, gpa = 1e839000, npages  = 1, enc = 1
....

> [   56.313747] page_enc_status_hc invoked, gpa = 1e5eb000, npages  = 1, enc = 0
> [   56.313771] page_enc_status_hc invoked, gpa = 1e5e9000, npages  = 1, enc = 0
> [   56.313789] page_enc_status_hc invoked, gpa = 1e5eb000, npages  = 1, enc = 1
> [   56.313803] page_enc_status_hc invoked, gpa = 1e5e9000, npages  = 1, enc = 1
....
> [   56.459276] page_enc_status_hc invoked, gpa = 1d767000, npages  = 100, enc = 0
> [   56.459428] page_enc_status_hc invoked, gpa = 1e501000, npages  = 1, enc = 1
> [   56.460037] page_enc_status_hc invoked, gpa = 1d767000, npages  = 100, enc = 1
> [   56.460216] page_enc_status_hc invoked, gpa = 1e501000, npages  = 1, enc = 0
> [   56.460299] page_enc_status_hc invoked, gpa = 1d767000, npages  = 100, enc = 0
> [   56.460448] page_enc_status_hc invoked, gpa = 1e501000, npages  = 1, enc = 1
....

> As can be observed here, all guest MMIO ranges are initially setup as
> shared, and those are all contigious guest page ranges.
> 
> After that the encryption status hypercalls are invoked when DMA gets
> triggered during disk i/o while booting the guest ... here again the
> guest page ranges are contigious, though mostly single page is touched 
> and a lot of page re-use is observed. 
> 
> So a range-based list/structure will be a "good" fit for such usage
> scenarios.

It seems surprisingly common to flick the same pages back and forth between
encrypted and clear for quite a while;  why is this?

Dave


> Thanks,
> Ashish
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

