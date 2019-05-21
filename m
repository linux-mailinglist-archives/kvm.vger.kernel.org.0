Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAF0925165
	for <lists+kvm@lfdr.de>; Tue, 21 May 2019 16:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728201AbfEUOCj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 May 2019 10:02:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:13837 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726750AbfEUOCj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 May 2019 10:02:39 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 May 2019 07:02:38 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga006.fm.intel.com with ESMTP; 21 May 2019 07:02:38 -0700
Date:   Tue, 21 May 2019 07:02:38 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Martin Lucina <martin@lucina.net>
Cc:     kvm@vger.kernel.org
Subject: Re: Interaction between host-side mprotect() and KVM MMU
Message-ID: <20190521140238.GA22089@linux.intel.com>
References: <20190521072434.p4rtnbkerk5jqwh4@nodbug.lucina.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521072434.p4rtnbkerk5jqwh4@nodbug.lucina.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 21, 2019 at 09:24:34AM +0200, Martin Lucina wrote:
> Hi all,
> 
> as part of an effort to enforce W^X for the KVM backend of Solo5 [1], I'm
> trying to understand how host-side mprotect() interacts with the KVM MMU.
> 
> Take a KVM guest on x86_64, where the guest runs exclusively in long mode,
> in virtual ring 0, using 1:1 2MB pages in the guest, and all guest page
> tables are RWX, i.e. no memory protection is enforced inside the guest
> itself. EPT is enabled on the host.
> 
> Instead, our ELF loader applies a host-side mprotect(PROT_...) based on the
> protection bits in the guest application (unikernel) ELF PHDRs.
> 
> The observed behaviour I see, from tests run inside the guest:
> 
> 1. Attempting to WRITE to .text which has had mprotect(PROT_READ |
> PROT_EXEC) applied on the host side results in a EFAULT from KVM_RUN in the
> userspace tender (our equivalent of a VMM).
> 
> 2. Attempting to EXECUTE code in .data which has had mprotect(PROT_READ |
> PROT_WRITE) applied on the host side succeeds.
> 
> Questions:
> 
> a. Is this the intended behaviour, and can it be relied on? Note that
> KVM/aarch64 behaves the same for me.
> 
> b. Why does case (1) fail but case (2) succeed? I spent a day reading
> through the KVM MMU code, but failed to understand how this is implemented.

Case (1) fails because KVM explicitly grabs WRITE permissions when
retrieving the HPA.  See __gfn_to_pfn_memslot() and hva_to_pfn().
Note, KVM also allows userspace to set a guest memslot as RO
independent of mprotect().

Case (2) doesn't fault because KVM doesn't support execute protection,
i.e. all pages are executable in the guest (at least on x86).  My guess
is that execute protection isn't supported because there isn't a strong
use case for traditional virtualization and so no one has gone through
the effort to add NX support.  E.g. the vast majority of system memory
can be dynamically allocated (for userspace code), which practically
speaking leaves only the guest kernel's data sections, and marking those
NX requires at a minimum:

  - knowing exactly what kernel will be loaded
  - no ASLR in the physical domain
  - no transient execution, e.g. in vBIOS or trampoline code

> c. In order to enforce W^X both ways I'd like to have case (2) also fail
> with EFAULT, is this possible?

Not without modifying KVM and the kernel (if you want to do it through
mprotect()).

> 
> Martin
> 
> [1] https://github.com/Solo5/solo5
