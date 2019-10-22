Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14BEEE0CBF
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 21:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388650AbfJVTqR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 15:46:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:45093 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388205AbfJVTqR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 15:46:17 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Oct 2019 12:46:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,217,1569308400"; 
   d="scan'208";a="196549819"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 22 Oct 2019 12:46:15 -0700
Date:   Tue, 22 Oct 2019 12:46:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v7 1/7] KVM: CPUID: Fix IA32_XSS support in CPUID(0xd,i)
 enumeration
Message-ID: <20191022194615.GM2343@linux.intel.com>
References: <20190927021927.23057-1-weijiang.yang@intel.com>
 <20190927021927.23057-2-weijiang.yang@intel.com>
 <CALMp9eRXoyoX6GHQgVTXemJjm69MwqN+VDN47X=5BN36rvrAgA@mail.gmail.com>
 <20191017194622.GI20903@linux.intel.com>
 <20191018012809.GA2286@local-michael-cet-test>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018012809.GA2286@local-michael-cet-test>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 18, 2019 at 09:28:09AM +0800, Yang Weijiang wrote:
> On Thu, Oct 17, 2019 at 12:46:22PM -0700, Sean Christopherson wrote:
> > On Wed, Oct 02, 2019 at 10:26:10AM -0700, Jim Mattson wrote:
> > > > +                       entry->eax = 0;
> > > > +                       entry->ebx = 0;
> > > > +                       entry->ecx = 0;
> > > > +                       entry->edx = 0;
> > > > +                       return;
> > > > +               }
> > > > +               if (entry->ecx)
> > > > +                       entry->ebx = 0;
> > > 
> > > This seems to back up my claims above regarding the EBX output for
> > > cases 0 and 1, but aside from those subleaves, is this correct? For
> > > subleaves > 1, ECX bit 1 can be set for extended state components that
> > > need to be cache-line aligned. Such components could map to a valid
> > > bit in XCR0 and have a non-zero offset from the beginning of the
> > > non-compacted XSAVE area.
> > > 
> > > > +               entry->edx = 0;
> > > 
> > > This seems too aggressive. See my comments above regarding EDX outputs
> > > for cases 0 and 1.
> > > 
> Sean, I don't know how to deal with entry->edx here as SDM says it's
> reserved for valid subleaf.

The SDM also states:

  Bit 31 - 00: Reports the supported bits of the upper 32 bits of XCR0.
  XCR0[n+32] can be set to 1 only if EDX[n] is 1.

the second part, "Bits 31 - 00: Reserved" is at best superfluous, e.g. it
could be interpreted as saying that XCR0[63:32] are currently reserved,
and at worst the extra qualifier is an SDM bug and should be removed.

TL;DR: Ignore the blurb about the bits being reserved.
