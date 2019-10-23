Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 912D0E0F94
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 03:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732186AbfJWBN5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 21:13:57 -0400
Received: from mga17.intel.com ([192.55.52.151]:19686 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727140AbfJWBN5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 21:13:57 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Oct 2019 18:13:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,218,1569308400"; 
   d="scan'208";a="188091893"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by orsmga007.jf.intel.com with ESMTP; 22 Oct 2019 18:13:54 -0700
Date:   Wed, 23 Oct 2019 09:16:46 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v7 1/7] KVM: CPUID: Fix IA32_XSS support in CPUID(0xd,i)
 enumeration
Message-ID: <20191023011645.GA27009@local-michael-cet-test>
References: <20190927021927.23057-1-weijiang.yang@intel.com>
 <20190927021927.23057-2-weijiang.yang@intel.com>
 <CALMp9eRXoyoX6GHQgVTXemJjm69MwqN+VDN47X=5BN36rvrAgA@mail.gmail.com>
 <20191017194622.GI20903@linux.intel.com>
 <20191018012809.GA2286@local-michael-cet-test>
 <20191022194615.GM2343@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022194615.GM2343@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 22, 2019 at 12:46:15PM -0700, Sean Christopherson wrote:
> On Fri, Oct 18, 2019 at 09:28:09AM +0800, Yang Weijiang wrote:
> > On Thu, Oct 17, 2019 at 12:46:22PM -0700, Sean Christopherson wrote:
> > > On Wed, Oct 02, 2019 at 10:26:10AM -0700, Jim Mattson wrote:
> > > > > +                       entry->eax = 0;
> > > > > +                       entry->ebx = 0;
> > > > > +                       entry->ecx = 0;
> > > > > +                       entry->edx = 0;
> > > > > +                       return;
> > > > > +               }
> > > > > +               if (entry->ecx)
> > > > > +                       entry->ebx = 0;
> > > > 
> > > > This seems to back up my claims above regarding the EBX output for
> > > > cases 0 and 1, but aside from those subleaves, is this correct? For
> > > > subleaves > 1, ECX bit 1 can be set for extended state components that
> > > > need to be cache-line aligned. Such components could map to a valid
> > > > bit in XCR0 and have a non-zero offset from the beginning of the
> > > > non-compacted XSAVE area.
> > > > 
> > > > > +               entry->edx = 0;
> > > > 
> > > > This seems too aggressive. See my comments above regarding EDX outputs
> > > > for cases 0 and 1.
> > > > 
> > Sean, I don't know how to deal with entry->edx here as SDM says it's
> > reserved for valid subleaf.
> 
> The SDM also states:
> 
>   Bit 31 - 00: Reports the supported bits of the upper 32 bits of XCR0.
>   XCR0[n+32] can be set to 1 only if EDX[n] is 1.
> 
> the second part, "Bits 31 - 00: Reserved" is at best superfluous, e.g. it
> could be interpreted as saying that XCR0[63:32] are currently reserved,
> and at worst the extra qualifier is an SDM bug and should be removed.
> 
> TL;DR: Ignore the blurb about the bits being reserved.
Thanks Sean, I'll follow it.
