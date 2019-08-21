Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A979D987C4
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 01:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbfHUXUO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 19:20:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:38521 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727644AbfHUXUO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 19:20:14 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Aug 2019 16:20:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,414,1559545200"; 
   d="scan'208";a="196102624"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 21 Aug 2019 16:20:13 -0700
Date:   Wed, 21 Aug 2019 16:20:13 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Nikita Leshenko <nikita.leshchenko@oracle.com>,
        kvm list <kvm@vger.kernel.org>,
        Liran Alon <liran.alon@oracle.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [PATCH 1/2] KVM: nVMX: Always indicate HLT activity support in
 VMX_MISC MSR
Message-ID: <20190821232013.GM29345@linux.intel.com>
References: <20190819214650.41991-1-nikita.leshchenko@oracle.com>
 <20190819214650.41991-2-nikita.leshchenko@oracle.com>
 <20190819221101.GF1916@linux.intel.com>
 <CALMp9eR4zO=BOZKzDowkVSR7O9Y2aqBXEvwepv6j85z4wvSyxA@mail.gmail.com>
 <20190821222218.GL29345@linux.intel.com>
 <CALMp9eTT9AoytCKN8FmcKhfrsn4Pz=r8yDFe=_CEobpeOG6J6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eTT9AoytCKN8FmcKhfrsn4Pz=r8yDFe=_CEobpeOG6J6A@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 21, 2019 at 04:01:49PM -0700, Jim Mattson wrote:
> On Wed, Aug 21, 2019 at 3:22 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Wed, Aug 21, 2019 at 01:59:20PM -0700, Jim Mattson wrote:
> > > On Mon, Aug 19, 2019 at 3:11 PM Sean Christopherson
> > > <sean.j.christopherson@intel.com> wrote:
> > > >
> > > > On Tue, Aug 20, 2019 at 12:46:49AM +0300, Nikita Leshenko wrote:
> > > > > Before this commit, userspace could disable the GUEST_ACTIVITY_HLT bit in
> > > > > VMX_MISC yet KVM would happily accept GUEST_ACTIVITY_HLT activity state in
> > > > > VMCS12. We can fix it by either failing VM entries with HLT activity state when
> > > > > it's not supported or by disallowing clearing this bit.
> > > > >
> > > > > The latter is preferable. If we go with the former, to disable
> > > > > GUEST_ACTIVITY_HLT userspace also has to make CPU_BASED_HLT_EXITING a "must be
> > > > > 1" control, otherwise KVM will be presenting a bogus model to L1.
> > > > >
> > > > > Don't fail writes that disable GUEST_ACTIVITY_HLT to maintain backwards
> > > > > compatibility.
> > > >
> > > > Paolo, do we actually need to maintain backwards compatibility in this
> > > > case?  This seems like a good candidate for "fix the bug and see who yells".
> > >
> > > Google's userspace clears bit 6. Please don't fail that write!
> >
> > Booooo.
> >
> 
> Supporting activity state HLT is on our list of things to do, but I'm
> not convinced that kvm actually handles it properly yet. For
> instance...

I fully understand why you'd want to hide it from L1, I was just bummed
that we couldn't go with a quick and dirty fix :-)

> What happens if L1 launches L2 into activity state HLT with a
> zero-valued VMX preemption timer? (Maybe this is fixed now?)

I think that one got fixed in vmx_start_preemption_timer().

> What happens if "monitor trap flag" is set and "HLT exiting" is clear
> in the vmcs12, and immediately on VM-entry, L2 executes HLT? (Yes,
> this is a special case of MTF being broken when L0 emulates an L2
> instruction.)
> 
> I'm sure there are other interesting scenarios that haven't been validated.
