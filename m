Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 337571256A0
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 23:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfLRWYW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 17:24:22 -0500
Received: from mga06.intel.com ([134.134.136.31]:25121 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726387AbfLRWYW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 17:24:22 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 14:24:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="213054124"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 18 Dec 2019 14:24:20 -0800
Date:   Wed, 18 Dec 2019 14:24:20 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191218222420.GH25201@linux.intel.com>
References: <affd9d84-1b84-0c25-c431-a075c58c33dc@redhat.com>
 <20191210155259.GD3352@xz-x1>
 <3e6cb5ec-66c0-00ab-b75e-ad2beb1d216d@redhat.com>
 <20191215172124.GA83861@xz-x1>
 <f117d46a-7528-ce32-8e46-4f3f35937079@redhat.com>
 <20191216185454.GG83861@xz-x1>
 <815923d9-2d48-2915-4acb-97eb90996403@redhat.com>
 <20191217162405.GD7258@xz-x1>
 <c01d0732-2172-2573-8251-842e94da4cfc@redhat.com>
 <20191218215857.GE26669@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218215857.GE26669@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 18, 2019 at 04:58:57PM -0500, Peter Xu wrote:
> On Tue, Dec 17, 2019 at 05:28:54PM +0100, Paolo Bonzini wrote:
> > On 17/12/19 17:24, Peter Xu wrote:
> > >> No, please pass it all the way down to the [&] functions but not to
> > >> kvm_write_guest_page.  Those should keep using vcpu->kvm.
> > > Actually I even wanted to refactor these helpers.  I mean, we have two
> > > sets of helpers now, kvm_[vcpu]_{read|write}*(), so one set is per-vm,
> > > the other set is per-vcpu.  IIUC the only difference of these two are
> > > whether we should consider ((vcpu)->arch.hflags & HF_SMM_MASK) or we
> > > just write to address space zero always.
> > 
> > Right.
> > 
> > > Could we unify them into a
> > > single set of helper (I'll just drop the *_vcpu_* helpers because it's
> > > longer when write) but we always pass in vcpu* as the first parameter?
> > > Then we add another parameter "vcpu_smm" to show whether we want to
> > > consider the HF_SMM_MASK flag.
> > 
> > You'd have to check through all KVM implementations whether you always
> > have the vCPU.  Also non-x86 doesn't have address spaces, and by the
> > time you add ", true" or ", false" it's longer than the "_vcpu_" you
> > have removed.  So, not a good idea in my opinion. :D
> 
> Well, now I've changed my mind. :) (considering that we still have
> many places that will not have vcpu*...)
> 
> I can simply add that "vcpu_smm" parameter to kvm_vcpu_write_*()
> without removing the kvm_write_*() helpers.  Then I'll be able to
> convert most of the kvm_write_*() (or its family) callers to
> kvm_vcpu_write*(..., vcpu_smm=false) calls where proper.
> 
> Would that be good?

I've lost track of the problem you're trying to solve, but if you do
something like "vcpu_smm=false", explicitly pass an address space ID
instead of hardcoding x86 specific SMM crud, e.g.

	kvm_vcpu_write*(..., as_id=0);
