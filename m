Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59F9E1490D0
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2020 23:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729127AbgAXWWo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jan 2020 17:22:44 -0500
Received: from mga07.intel.com ([134.134.136.100]:50330 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727590AbgAXWWo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jan 2020 17:22:44 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jan 2020 14:22:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,359,1574150400"; 
   d="scan'208";a="426755932"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 24 Jan 2020 14:22:12 -0800
Date:   Fri, 24 Jan 2020 14:22:12 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, KVM <kvm@vger.kernel.org>
Subject: Re: linux-next: Tree for Jan 24 (kvm)
Message-ID: <20200124222212.GS2109@linux.intel.com>
References: <20200124173302.2c3228b2@canb.auug.org.au>
 <38d53302-b700-b162-e766-2e2a461fc569@infradead.org>
 <20200124213027.GP2109@linux.intel.com>
 <CALMp9eRvoZZ=7P3uCg3oqXzvV1WZc9mkzTJh8+=vmEh7xs5BTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eRvoZZ=7P3uCg3oqXzvV1WZc9mkzTJh8+=vmEh7xs5BTw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 24, 2020 at 01:48:07PM -0800, Jim Mattson wrote:
> On Fri, Jan 24, 2020 at 1:30 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Fri, Jan 24, 2020 at 12:51:31PM -0800, Randy Dunlap wrote:
> > > On 1/23/20 10:33 PM, Stephen Rothwell wrote:
> > > > Hi all,
> > > >
> > > > Changes since 20200123:
> > > >
> > > > The kvm tree gained a conflict against Linus' tree.
> > > >
> > >
> > > on i386:
> > >
> > > ../arch/x86/kvm/x86.h:363:16: warning: right shift count >= width of type [-Wshift-count-overflow]
> >
> > Jim,
> >
> > This is due to using "unsigned long data" for kvm_dr7_valid() along with
> > "return !(data >> 32);" to check for bits being set in 63:32.  Any
> > objection to fixing the issue by making @data a u64?  Part of me thinks
> > that's the proper behavior anyways, i.e. the helper is purely a reflection
> > of the architectural requirements, the caller is responsible for dropping
> > bits appropriately based on the current mode.
> 
> Why not just change that bad return statement to one of the
> alternatives you had suggested previously?

Because it's not consistent with e.g. is_noncanonical_address() and I don't
like dropping bits 63:32 of vmcs12->guest_dr7 when kvm_dr7_valid() is called
from nested_vmx_check_guest_state().  KVM will eventually drop the bits
anyways when propagating vmcs12->guest_dr7 to vmcs02, but I'd prefer the
consistency check to not rely on that behavior.

> I think "return !(data >> 32)" was the only suggested alternative that
> doesn't work. :-)
