Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0442AC3E26
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 19:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbfJARGs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 13:06:48 -0400
Received: from mga04.intel.com ([192.55.52.120]:12904 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726339AbfJARGs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 13:06:48 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Oct 2019 10:06:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,571,1559545200"; 
   d="scan'208";a="197915381"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Oct 2019 10:06:47 -0700
Date:   Tue, 1 Oct 2019 10:06:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
        "ehabkost@redhat.com" <ehabkost@redhat.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Hu, Robert" <robert.hu@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Subject: Re: [PATCH] x86: Add CPUID KVM support for new instruction WBNOINVD
Message-ID: <20191001170646.GA27090@linux.intel.com>
References: <1545227503-214403-1-git-send-email-robert.hu@linux.intel.com>
 <CALMp9eRZCoZbeyttZdvaCUpOFKygTNVF_x7+TWh6MktmF-ZK9A@mail.gmail.com>
 <263d31d9-b21e-ceb9-b47c-008e30bbd94f@redhat.com>
 <CALMp9eRFWq+F1Dwb8NcBd-Bo-YbT6KMOLo8DoinQQfK9hEi5Qg@mail.gmail.com>
 <20190930175449.GB4084@habkost.net>
 <CALMp9eR88jE7YV-TmZSSD2oJhEpbsgo-LCgsWHkyFtHcHTmnzw@mail.gmail.com>
 <9bbe864ab8fb16d9e64745b930c89b1db24ccc3a.camel@intel.com>
 <CALMp9eSe_7on+F=ng05DkvvBpnWhSirEpSVz9Bua4Sy606xJnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eSe_7on+F=ng05DkvvBpnWhSirEpSVz9Bua4Sy606xJnw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 01, 2019 at 07:20:17AM -0700, Jim Mattson wrote:
> On Mon, Sep 30, 2019 at 5:45 PM Huang, Kai <kai.huang@intel.com> wrote:
> >
> > On Mon, 2019-09-30 at 12:23 -0700, Jim Mattson wrote:
> > > On Mon, Sep 30, 2019 at 10:54 AM Eduardo Habkost <ehabkost@redhat.com> wrote:
> > > I had only looked at the SVM implementation of WBNOINVD, which is
> > > exactly the same as the SVM implementation of WBINVD. So, the question
> > > is, "why enumerate WBNOINVD if its implementation is exactly the same
> > > as WBINVD?"
> > >
> > > WBNOINVD appears to be only partially documented in Intel document
> > > 319433-037, "Intel® Architecture Instruction Set Extensions and Future
> > > Features Programming Reference." In particular, there is no
> > > documentation regarding the instruction's behavior in VMX non-root
> > > mode. Does WBNOINVD cause a VM-exit when the VM-execution control,
> > > "WBINVD exiting," is set? If so, does it have the same VM-exit reason
> > > as WBINVD (54), or a different one? If it does have the same VM-exit
> > > reason (a la SVM), how does one distinguish a WBINVD VM-exit from a
> > > WBNOINVD VM-exit? If one can't distinguish (a la SVM), then it would
> > > seem that the VMX implementation also implements WBNOINVD as WBINVD.
> > > If that's the case, the question for VMX is the same as for SVM.
> >
> > Unfortunately WBNOINVD interaction with VMX has not been made to public yet.

Hint: WBNOINVD uses a previously ignored prefix, i.e. it looks a *lot*
      like WBINVD...

> > I am reaching out internally to see when it can be done. I agree it may not be
> > necessary to expose WBNOINVD if its implementation is exactly the same as
> > WBINVD, but it also doesn't have any harm, right?
> 
> If nested VMX changes are necessary to be consistent with hardware,
> then enumerating WBNOINVD support in the guest CPUID information at
> this time--without the attendant nested VMX changes--is premature. No
> changes to nested SVM are necessary, so it's fine for AMD systems.
> 
> If no changes to nested VMX are necessary, then it is true that
> WBNOINVD can be emulated by WBINVD. However, it provides no value to
> specifically enumerate the instruction.
>
> If there is some value that I'm missing, then why make guest support
> for the instruction contingent on host support for the instruction?
> KVM can implement WBNOINVD as WBINVD on any host with WBINVD,
> regardless of whether or not the host supports WBNOINVD.

Agreed.  To play nice with live migration, KVM should enumerate WBNOINVD
regardless of host support.  Since WBNOINVD uses an ignored prefix, it
will simply look like a regular WBINVD on platforms without WBNOINVD.

Let's assume the WBNOINVD VM-Exit behavior is sane, i.e. allows software
to easily differentiate between WBINVD and WBNOINVD.  In that case, the
value added would be that KVM can do WBNOINVD instead of WBINVD in the
unlikely event that (a) KVM needs to executed WBINVD on behalf of the
guest (because the guest has non-coherent DMA), (b) WBNOINVD is supported
on the host, and (c) WBNOINVD is used by the guest (I don't think it would
be safe to assume that the guest doesn't need the caches invalidated on
WBINVD).
