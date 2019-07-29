Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72700791C0
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2019 19:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbfG2RFt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 13:05:49 -0400
Received: from mga14.intel.com ([192.55.52.115]:57308 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727487AbfG2RFt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 13:05:49 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jul 2019 10:05:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,323,1559545200"; 
   d="scan'208";a="190627735"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 29 Jul 2019 10:05:47 -0700
Date:   Mon, 29 Jul 2019 10:05:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-sgx@vger.kernel.org
Subject: Re: [RFC PATCH 04/21] x86/sgx: Add /dev/sgx/virt_epc device to
 allocate "raw" EPC for VMs
Message-ID: <20190729170547.GH21120@linux.intel.com>
References: <20190727055214.9282-1-sean.j.christopherson@intel.com>
 <20190727055214.9282-5-sean.j.christopherson@intel.com>
 <CALCETrXLE6RpR9p9eGPNvU+Nt=yyCkqsQHv7hzmNaC61sFK7Jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXLE6RpR9p9eGPNvU+Nt=yyCkqsQHv7hzmNaC61sFK7Jg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 27, 2019 at 10:44:24AM -0700, Andy Lutomirski wrote:
> On Fri, Jul 26, 2019 at 10:52 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > Add an SGX device to enable userspace to allocate EPC without an
> > associated enclave.  The intended and only known use case for direct EPC
> > allocation is to expose EPC to a KVM guest, hence the virt_epc moniker,
> > virt.{c,h} files and INTEL_SGX_VIRTUALIZATION Kconfig.
> >
> > Although KVM is the end consumer of EPC, and will need hooks into the
> > virtual EPC management if oversubscription of EPC for guest is ever
> > supported (see below), implement direct access to EPC in the SGX
> > subsystem instead of in KVM.  Doing so has two major advantages:
> >
> >   - Does not require changes to KVM's uAPI, e.g. EPC gets handled as
> >     just another memory backend for guests.
> 
> This is general grumbling more than useful feedback, but I wish there
> was a way for KVM's userspace to add a memory region that is *not*
> backed by a memory mapping.  For SGX, this would avoid the slightly
> awkward situation where useless EPC pages are mapped by QEMU.  For
> SEV, it would solve the really fairly awful situation where the SEV
> pages are mapped *incoherently* for QEMU.  And even in the absence of
> fancy hardware features, it would allow the guest to have secrets in
> memory that are not exposed to wild reads, speculation attacks, etc
> coming from QEMU.
> 
> I realize the implementation would be extremely intrusive, but it just
> might make it a lot easier to do things like making SEV pages property
> movable.  Similarly, I could see EPC oversubscription being less nasty
> in this model.  For one thing, it would make it more straightforward
> to keep track of exactly which VMs have a given EPC page mapped,
> whereas right now this driver only really knows which host userspace
> mm has the EPC page mapped.

Host userspace vs VM doesn't add much, if any, complexity to EPC
oversubscription, especially since the problem of supporting multiple mm
structs needs to be solved for the native driver anyways.

The nastiness of oversubscribing a VM is primarily in dealing with
EBLOCK/ETRACK/EWB conflicts between guest and host.  The other nasty bit
is that it all but requires fancier VA page management, e.g. allocating a
dedicated VA slot for every EPC page doesn't scale when presenting a
multi-{GB,TB} EPC to a guest, especially since there's no guarantee the
guest will ever access EPC.
