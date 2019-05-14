Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE10C1E533
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 00:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbfENWi0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 18:38:26 -0400
Received: from mga18.intel.com ([134.134.136.126]:22218 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbfENWiZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 18:38:25 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 May 2019 15:38:24 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by FMSMGA003.fm.intel.com with ESMTP; 14 May 2019 15:38:23 -0700
Date:   Tue, 14 May 2019 15:38:23 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        jan.setjeeilers@oracle.com, Liran Alon <liran.alon@oracle.com>,
        Jonathan Adams <jwadams@google.com>
Subject: Re: [RFC KVM 18/27] kvm/isolation: function to copy page table
 entries for percpu buffer
Message-ID: <20190514223823.GE1977@linux.intel.com>
References: <b8487de1-83a8-2761-f4a6-26c583eba083@oracle.com>
 <B447B6E8-8CEF-46FF-9967-DFB2E00E55DB@amacapital.net>
 <4e7d52d7-d4d2-3008-b967-c40676ed15d2@oracle.com>
 <CALCETrXtwksWniEjiWKgZWZAyYLDipuq+sQ449OvDKehJ3D-fg@mail.gmail.com>
 <e5fedad9-4607-0aa4-297e-398c0e34ae2b@oracle.com>
 <20190514170522.GW2623@hirez.programming.kicks-ass.net>
 <20190514180936.GA1977@linux.intel.com>
 <CALCETrVzbBLokip5n0KEyG6irH6aoEWqyNODTy8embpXhB1GQg@mail.gmail.com>
 <20190514210603.GD1977@linux.intel.com>
 <A1EB80C0-2D88-4DC0-A898-3BED50A4F5A8@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <A1EB80C0-2D88-4DC0-A898-3BED50A4F5A8@amacapital.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 14, 2019 at 02:55:18PM -0700, Andy Lutomirski wrote:
> 
> > On May 14, 2019, at 2:06 PM, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> > 
> >> On Tue, May 14, 2019 at 01:33:21PM -0700, Andy Lutomirski wrote:
> >> I suspect that the context switch is a bit of a red herring.  A
> >> PCID-don't-flush CR3 write is IIRC under 300 cycles.  Sure, it's slow,
> >> but it's probably minor compared to the full cost of the vm exit.  The
> >> pain point is kicking the sibling thread.
> > 
> > Speaking of PCIDs, a separate mm for KVM would mean consuming another
> > ASID, which isn't good.
> 
> I’m not sure we care. We have many logical address spaces (two per mm plus a
> few more).  We have 4096 PCIDs, but we only use ten or so.  And we have some
> undocumented number of *physical* ASIDs with some undocumented mechanism by
> which PCID maps to a physical ASID.

Yeah, I was referring to physical ASIDs.

> I don’t suppose you know how many physical ASIDs we have?

Limited number of physical ASIDs.  I'll leave it at that so as not to
disclose something I shouldn't.

> And how it interacts with the VPID stuff?

VPID and PCID get factored into the final ASID, i.e. changing either one
results in a new ASID.  The SDM's oblique way of saying that:

  VPIDs and PCIDs (see Section 4.10.1) can be used concurrently. When this
  is done, the processor associates cached information with both a VPID and
  a PCID. Such information is used only if the current VPID and PCID both
  match those associated with the cached information.

E.g. enabling PTI in both the host and guest consumes four ASIDs just to
run a single task in the guest:

  - VPID=0, PCID=kernel
  - VPID=0, PCID=user
  - VPID=1, PCID=kernel
  - VPID=1, PCID=user

The impact of consuming another ASID for KVM would likely depend on both
the guest and host configurations/worloads, e.g. if the guest is using a
lot of PCIDs then it's probably a moot point.  It's something to keep in
mind though if we go down this path.
