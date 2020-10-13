Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99AB328C80C
	for <lists+kvm@lfdr.de>; Tue, 13 Oct 2020 06:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731913AbgJMEws (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Oct 2020 00:52:48 -0400
Received: from mga17.intel.com ([192.55.52.151]:56981 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728945AbgJMEwr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Oct 2020 00:52:47 -0400
IronPort-SDR: xPL/UcbOW7Q8tm0E1LOHBF15D8BJe4/Q36M4KFAolSTrEOs0R0eWSPXUESJCVXPUKlQurPByAi
 i77w3tF2WYtA==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="145713579"
X-IronPort-AV: E=Sophos;i="5.77,369,1596524400"; 
   d="scan'208";a="145713579"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 21:52:47 -0700
IronPort-SDR: JTyvnc12S1kQiiZJgg4rnYCcYaPtwvgUrkZPyP0bv8wO6HSf5x4alc6NZwBMKoVhy+rMETozEw
 1HoTSMgPCsFg==
X-IronPort-AV: E=Sophos;i="5.77,369,1596524400"; 
   d="scan'208";a="463353306"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 21:52:46 -0700
Date:   Mon, 12 Oct 2020 21:52:45 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     harry harry <hiharryharryharry@gmail.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, qemu-devel@nongnu.org,
        mathieu.tarral@protonmail.com, stefanha@redhat.com,
        libvir-list@redhat.com, kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: Why guest physical addresses are not the same as the
 corresponding host virtual addresses in QEMU/KVM? Thanks!
Message-ID: <20201013045245.GA11344@linux.intel.com>
References: <CA+-xGqMd4_58_+QKetjOsubBqrDnaYF+YWE3TC3kEcNGxPiPfg@mail.gmail.com>
 <47ead258320536d00f9f32891da3810040875aff.camel@redhat.com>
 <CA+-xGqOm2sWbxR=3W1pWrZNLOt7EE5qiNWxMz=9=gmga15vD2w@mail.gmail.com>
 <20201012165428.GD26135@linux.intel.com>
 <CA+-xGqPkkiws0bxrzud_qKs3ZmKN9=AfN=JGephfGc+2rn6ybw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+-xGqPkkiws0bxrzud_qKs3ZmKN9=AfN=JGephfGc+2rn6ybw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 13, 2020 at 12:30:39AM -0400, harry harry wrote:
> Hi Sean,
> 
> Thank you very much for your thorough explanations. Please see my
> inline replies as follows. Thanks!
> 
> On Mon, Oct 12, 2020 at 12:54 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > No, the guest physical address spaces is not intrinsically tied to the host
> > virtual address spaces.  The fact that GPAs and HVAs are related in KVM is a
> > property KVM's architecture.  EPT/NPT has absolutely nothing to do with HVAs.
> >
> > As Maxim pointed out, KVM links a guest's physical address space, i.e. GPAs, to
> > the host's virtual address space, i.e. HVAs, via memslots.  For all intents and
> > purposes, this is an extra layer of address translation that is purely software
> > defined.  The memslots allow KVM to retrieve the HPA for a given GPA when
> > servicing a shadow page fault (a.k.a. EPT violation).
> >
> > When EPT is enabled, a shadow page fault due to an unmapped GPA will look like:
> >
> >  GVA -> [guest page tables] -> GPA -> EPT Violation VM-Exit
> >
> > The above walk of the guest page tables is done in hardware.  KVM then does the
> > following walks in software to retrieve the desired HPA:
> >
> >  GPA -> [memslots] -> HVA -> [host page tables] -> HPA
> 
> Do you mean that GPAs are different from their corresponding HVAs when
> KVM does the walks (as you said above) in software?

What do you mean by "different"?  GPAs and HVAs are two completely different
address spaces.
