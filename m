Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47A3A29F16
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 21:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391667AbfEXT1A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 May 2019 15:27:00 -0400
Received: from mga14.intel.com ([192.55.52.115]:38373 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731979AbfEXT1A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 May 2019 15:27:00 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 May 2019 12:26:59 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga004.fm.intel.com with ESMTP; 24 May 2019 12:26:59 -0700
Date:   Fri, 24 May 2019 12:26:59 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     kvm@vger.kernel.org
Subject: Re: Interaction between host-side mprotect() and KVM MMU
Message-ID: <20190524192659.GE365@linux.intel.com>
References: <20190521072434.p4rtnbkerk5jqwh4@nodbug.lucina.net>
 <20190521140238.GA22089@linux.intel.com>
 <20190523092703.ddze6zcfsm2cj6kc@nodbug.lucina.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190523092703.ddze6zcfsm2cj6kc@nodbug.lucina.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 23, 2019 at 11:27:03AM +0200, Martin Lucina wrote:
> On Tuesday, 21.05.2019 at 07:02, Sean Christopherson wrote:
> > Not without modifying KVM and the kernel (if you want to do it through
> > mprotect()).
> 
> Hooking up the full EPT protection bits available to KVM via mprotect()
> would be the best solution for us, and could also give us the ability to
> have execute-only pages on x86, which is a nice defence against ROP attacks
> in the guest. However, I can see now that this is not a trivial
> undertaking, especially across the various MMU models (tdp, softmmu) and
> architectures dealt with by the core KVM code.

Belated thought on this...

Propagating PROT_EXEC from the host's VMAs to the EPT tables would require
having *guest* memory mapped with PROT_EXEC in the host.  This is a
non-starter for traditional virtualization as it would all but require the
hypervisor to have RWX pages.

For the Solo5 case, since the guest is untrusted, mapping its code as
executable in the host seems almost as bad from a security perspective.

So yeah, mprotect() might be convenient, but adding a KVM_MEM_NOEXEC
flag to KVM_SET_USER_MEMORY_REGION would be more secure (and probably
easier to implement in KVM).
