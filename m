Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D00A28BE83
	for <lists+kvm@lfdr.de>; Mon, 12 Oct 2020 18:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390681AbgJLQye (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 12:54:34 -0400
Received: from mga07.intel.com ([134.134.136.100]:36740 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390107AbgJLQyd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Oct 2020 12:54:33 -0400
IronPort-SDR: b1/o4DUd8sDqRtLxkVducZCMNuAYPD8A7m53czrZgIIg2A2Hdjl96SgW9FIyOkNah5t+LR79cV
 4/8SnL3kr/2A==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="229950794"
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="229950794"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 09:54:29 -0700
IronPort-SDR: jSyO44s9n8XltW8LqS0g9zuGqteZB9zTJR4kslVJ1qFXgSbDZ937/ZbwcMk2FdRlzXkqw3qLIW
 8I5pwW2ivQPA==
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="317983474"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 09:54:29 -0700
Date:   Mon, 12 Oct 2020 09:54:28 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     harry harry <hiharryharryharry@gmail.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, qemu-devel@nongnu.org,
        mathieu.tarral@protonmail.com, stefanha@redhat.com,
        libvir-list@redhat.com, kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: Why guest physical addresses are not the same as the
 corresponding host virtual addresses in QEMU/KVM? Thanks!
Message-ID: <20201012165428.GD26135@linux.intel.com>
References: <CA+-xGqMd4_58_+QKetjOsubBqrDnaYF+YWE3TC3kEcNGxPiPfg@mail.gmail.com>
 <47ead258320536d00f9f32891da3810040875aff.camel@redhat.com>
 <CA+-xGqOm2sWbxR=3W1pWrZNLOt7EE5qiNWxMz=9=gmga15vD2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+-xGqOm2sWbxR=3W1pWrZNLOt7EE5qiNWxMz=9=gmga15vD2w@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 11, 2020 at 10:11:39AM -0400, harry harry wrote:
> Hi Maxim,
> 
> Thanks much for your reply.
> 
> On Sun, Oct 11, 2020 at 3:29 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> >
> > On Sun, 2020-10-11 at 01:26 -0400, harry harry wrote:
> > > Hi QEMU/KVM developers,
> > >
> > > I am sorry if my email disturbs you. I did an experiment and found the
> > > guest physical addresses (GPAs) are not the same as the corresponding
> > > host virtual addresses (HVAs). I am curious about why; I think they
> > > should be the same. I am very appreciated if you can give some
> > > comments and suggestions about 1) why GPAs and HVAs are not the same
> > > in the following experiment; 2) are there any better experiments to
> > > look into the reasons? Any other comments/suggestions are also very
> > > welcome. Thanks!
> > >
> > > The experiment is like this: in a single vCPU VM, I ran a program
> > > allocating and referencing lots of pages (e.g., 100*1024) and didn't
> > > let the program terminate. Then, I checked the program's guest virtual
> > > addresses (GVAs) and GPAs through parsing its pagemap and maps files
> > > located at /proc/pid/pagemap and /proc/pid/maps, respectively. At
> > > last, in the host OS, I checked the vCPU's pagemap and maps files to
> > > find the program's HVAs and host physical addresses (HPAs); I actually
> > > checked the new allocated physical pages in the host OS after the
> > > program was executed in the guest OS.
> > >
> > > With the above experiment, I found GPAs of the program are different
> > > from its corresponding HVAs. BTW, Intel EPT and other related Intel
> > > virtualization techniques were enabled.
> > >
> > > Thanks,
> > > Harry
> > >
> > The fundemental reason is that some HVAs (e.g. QEMU's virtual memory addresses) are already allocated
> > for qemu's own use (e.g qemu code/heap/etc) prior to the guest starting up.
> >
> > KVM does though use quite effiecient way of mapping HVA's to GPA. It uses an array of arbitrary sized HVA areas
> > (which we call memslots) and for each such area/memslot you specify the GPA to map to. In theory QEMU
> > could allocate the whole guest's memory in one contiguous area and map it as single memslot to the guest.
> > In practice there are MMIO holes, and various other reasons why there will be more that 1 memslot.
> 
> It is still not clear to me why GPAs are not the same as the
> corresponding HVAs in my experiment. Since two-dimensional paging
> (Intel EPT) is used, GPAs should be the same as their corresponding
> HVAs. Otherwise, I think EPT may not work correctly. What do you
> think?

No, the guest physical address spaces is not intrinsically tied to the host
virtual address spaces.  The fact that GPAs and HVAs are related in KVM is a
property KVM's architecture.  EPT/NPT has absolutely nothing to do with HVAs.

As Maxim pointed out, KVM links a guest's physical address space, i.e. GPAs, to
the host's virtual address space, i.e. HVAs, via memslots.  For all intents and
purposes, this is an extra layer of address translation that is purely software
defined.  The memslots allow KVM to retrieve the HPA for a given GPA when
servicing a shadow page fault (a.k.a. EPT violation).

When EPT is enabled, a shadow page fault due to an unmapped GPA will look like:

 GVA -> [guest page tables] -> GPA -> EPT Violation VM-Exit

The above walk of the guest page tables is done in hardware.  KVM then does the
following walks in software to retrieve the desired HPA:

 GPA -> [memslots] -> HVA -> [host page tables] -> HPA

KVM then takes the resulting HPA and shoves it into KVM's shadow page tables,
or when TDP is enabled, the EPT/NPT page tables.  When the guest is run with
TDP enabled, GVA->HPA translations look like the following, with all walks done
in hardware.

 GVA -> [guest page tables] -> GPA -> [extended/nested page tables] -> HPA
