Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEF992A4DE9
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 19:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbgKCSKM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 13:10:12 -0500
Received: from mga05.intel.com ([192.55.52.43]:49720 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727706AbgKCSKM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 13:10:12 -0500
IronPort-SDR: xvMNNypQfzeMnCSKXXRKC/KZtU9I1TDUWhZ4i3gj3Ji2uKNQZJsuoXysYw68u/NloUNyxb4wx0
 oPVyBeUGUYxw==
X-IronPort-AV: E=McAfee;i="6000,8403,9794"; a="253813450"
X-IronPort-AV: E=Sophos;i="5.77,448,1596524400"; 
   d="scan'208";a="253813450"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2020 10:10:11 -0800
IronPort-SDR: EnuKWw9b8qb1LuDgOXw8oYS0Pp14A8Tpmqa/Wd4i9cXFcno0nH47ivzeVfNGqfG0OGkpp7gPtk
 7M3VQfXzf8Bg==
X-IronPort-AV: E=Sophos;i="5.77,448,1596524400"; 
   d="scan'208";a="357763196"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2020 10:10:11 -0800
Date:   Tue, 3 Nov 2020 10:10:09 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Vipin Sharma <vipinsh@google.com>, thomas.lendacky@amd.com,
        pbonzini@redhat.com, tj@kernel.org, lizefan@huawei.com,
        joro@8bytes.org, corbet@lwn.net, brijesh.singh@amd.com,
        jon.grimm@amd.com, eric.vantassell@amd.com, gingell@google.com,
        rientjes@google.com, kvm@vger.kernel.org, x86@kernel.org,
        cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dionna Glaze <dionnaglaze@google.com>,
        Erdem Aktas <erdemaktas@google.com>
Subject: Re: [RFC Patch 1/2] KVM: SVM: Create SEV cgroup controller.
Message-ID: <20201103181007.GB28367@linux.intel.com>
References: <20200922004024.3699923-1-vipinsh@google.com>
 <20200922004024.3699923-2-vipinsh@google.com>
 <94c3407d-07ca-8eaf-4073-4a5e2a3fb7b8@infradead.org>
 <20200922012227.GA26483@linux.intel.com>
 <c0ee04a93a8d679f5e9ee7eea6467b32bb7063d6.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0ee04a93a8d679f5e9ee7eea6467b32bb7063d6.camel@HansenPartnership.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 03, 2020 at 08:39:12AM -0800, James Bottomley wrote:
> On Mon, 2020-09-21 at 18:22 -0700, Sean Christopherson wrote:
> > ASIDs too.  I'd also love to see more info in the docs and/or cover
> > letter to explain why ASID management on SEV requires a cgroup.  I
> > know what an ASID is, and have a decent idea of how KVM manages ASIDs
> > for legacy VMs, but I know nothing about why ASIDs are limited for
> > SEV and not legacy VMs.
> 
> Well, also, why would we only have a cgroup for ASIDs but not MSIDs?

Assuming MSID==PCID in Intel terminology, which may be a bad assumption, the
answer is that rationing PCIDs is a fools errand, at least on Intel CPUs.

> For the reader at home a Space ID (SID) is simply a tag that can be
> placed on a cache line to control things like flushing.  Intel and AMD
> use MSIDs which are allocated per process to allow fast context
> switching by flushing all the process pages using a flush by SID. 
> ASIDs are also used by both Intel and AMD to control nested/extended
> paging of virtual machines, so ASIDs are allocated per VM.  So far it's
> universal.

On Intel CPUs, multiple things factor into the actual ASID that is used to tag
TLB entries.  And underneath the hood, there are a _very_ limited number of
ASIDs that are globally shared, i.e. a process in the host has an ASID, same
as a process in the guest, and the CPU only supports tagging translations for
N ASIDs at any given time.

E.g. with TDX, the hardware/real ASID is derived from:

   VPID + PCID + SEAM + EPTP

where VPID=0 for host, PCID=0 if PCID is disabled, SEAM=1 for the TDX-Module
and TDX VMs, and obviously EPTP is invalid/ignored when EPT is disabled.

> AMD invented a mechanism for tying their memory encryption technology
> to the ASID asserted on the memory bus, so now they can do encrypted
> virtual machines since each VM is tagged by ASID which the memory
> encryptor sees.  It is suspected that the forthcoming intel TDX
> technology to encrypt VMs will operate in the same way as well.  This

TDX uses MKTME keys, which are not tied to the ASID.  The KeyID is part of the
physical address, at least in the initial hardware implementations, which means
that from a memory perspective, each KeyID is a unique physical address.  This
is completely orthogonal to ASIDs, e.g. a given KeyID+PA combo can have
mutliple TLB entries if it's accessed by multiple ASIDs.

> isn't everything you have to do to get an encrypted VM, but it's a core
> part of it.
> 
> The problem with SIDs (both A and M) is that they get crammed into
> spare bits in the CPU (like the upper bits of %CR3 for MSID) so we

This CR3 reference is why I assume MSID==PCID, but the PCID is carved out of
the lower bits (11:0) of CR3, which is why I'm unsure I interpreted this
correctly.

> don't have enough of them to do a 1:1 mapping of MSID to process or
> ASID to VM.  Thus we have to ration them somewhat, which is what I
> assume this patch is about?

This cgroup is more about a hard limitation than about performance.

With PCIDs, VPIDs, and AMD's ASIDs, there is always the option of recycling an
existing ID (used for PCIDs and ASIDs), or simply disabling the feature (used
for VPIDs).  In both cases, exhausting the resource affects performance due to
incurring TLB flushes at transition points, but doesn't prevent creating new
processes/VMs.

And due to the way PCID=>ASID derivation works on Intel CPUs, the kernel
doesn't even bother trying to use a large number of PCIDs.  IIRC, the current
number of PCIDs used by the kernel is 5, i.e. the kernel intentionally
recycles PCIDs long before it's forced to do so by the architectural
limitation of 4k PCIDs, because using more than 5 PCIDs actually hurts
performance (forced PCID recycling allows the kernel to keep *its* ASID live
by flushing userspace PCIDs, whereas CPU recycling of ASIDs is indiscriminate).

MKTME KeyIDs and SEV ASIDs are different.  There is a hard, relatively low
limit on the number of IDs that are available, and exhausting that pool
effectively prevents creating a new encrypted VM[*].  E.g. with TDX, on first
gen hardware there is a hard limit of 127 KeyIDs that can be used to create
TDX VMs.  IIRC, SEV-ES is capped 512 or so ASIDs.  Hitting that cap means no
more protected VMs can be created.

[*] KeyID exhaustion for TDX is a hard restriction, the old VM _must_ be torn
    down to reuse the KeyID.  ASID exhaustion for SEV is not technically a
    hard limit, e.g. KVM could theoretically park a VM to reuse its ASID, but
    for all intents and purposes that VM is no longer live.
