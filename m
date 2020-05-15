Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70181D4FA9
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 15:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgEON6q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 09:58:46 -0400
Received: from mga04.intel.com ([192.55.52.120]:61836 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgEON6q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 09:58:46 -0400
IronPort-SDR: OGq3IR8w+oHQPmGqtHzryXLJ7lwESgqHP/kiJWPockLbAGC2gYyHIov0P3ttCv6AtcCryzNbbS
 vesz/c7mG9Lg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 06:58:45 -0700
IronPort-SDR: 5CspN23vJPkJAkRJdOn6Fp6bPqUcYsQaebPcgSXOauBg4miAci3znvxckFSlo7lUiwu68zlwMb
 EbSwGkxYn9Ww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,395,1583222400"; 
   d="scan'208";a="464734082"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga005.fm.intel.com with ESMTP; 15 May 2020 06:58:45 -0700
Date:   Fri, 15 May 2020 06:58:45 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Tsirkin <mst@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org
Subject: Re: [PATCH RFC 4/5] KVM: x86: aggressively map PTEs in
 KVM_MEM_ALLONES slots
Message-ID: <20200515135845.GA17572@linux.intel.com>
References: <20200514180540.52407-1-vkuznets@redhat.com>
 <20200514180540.52407-5-vkuznets@redhat.com>
 <20200514194624.GB15847@linux.intel.com>
 <87ftc1wq64.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ftc1wq64.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 15, 2020 at 10:36:19AM +0200, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> > IMO this is a waste of memory and TLB entries.  Why not treat the access as
> > the MMIO it is and emulate the access with a 0xff return value?  I think
> > it'd be a simple change to have __kvm_read_guest_page() stuff 0xff, i.e. a
> > kvm_allones_pg wouldn't be needed.  I would even vote to never create an
> > MMIO SPTE.  The guest has bigger issues if reading from a PCI hole is
> > performance sensitive.
> 
> You're trying to defeat the sole purpose of the feature :-) I also saw
> the option you suggest but Michael convinced me we should go further.
> 
> The idea (besides memory waste) was that the time we spend on PCI scan
> during boot is significant.

Put that in the cover letter.  The impression I got from the current cover
letter is that the focus was entirely on memory consumption.

> Unfortunatelly, I don't have any numbers but we can certainly try to get
> them.

Numbers are definitely required, otherwise we'll have no idea whether doing
something like the agressive prefetch actually has a meaningful impact.

> With this feature (AFAIU) we're not aiming at 'classic' long-living VMs but
> rather at something like Kata containers/FaaS/... where boot time is crucial.

Isn't the guest kernel fully controlled by the VMM in those use cases?
Why not enlighten the guest kernel in some way so that it doesn't have to
spend time scanning PCI space in the first place?
