Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 828CA98712
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 00:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731110AbfHUWWU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 18:22:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:34265 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731105AbfHUWWT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 18:22:19 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Aug 2019 15:22:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,414,1559545200"; 
   d="scan'208";a="181178147"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 21 Aug 2019 15:22:18 -0700
Date:   Wed, 21 Aug 2019 15:22:18 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Nikita Leshenko <nikita.leshchenko@oracle.com>,
        kvm list <kvm@vger.kernel.org>,
        Liran Alon <liran.alon@oracle.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [PATCH 1/2] KVM: nVMX: Always indicate HLT activity support in
 VMX_MISC MSR
Message-ID: <20190821222218.GL29345@linux.intel.com>
References: <20190819214650.41991-1-nikita.leshchenko@oracle.com>
 <20190819214650.41991-2-nikita.leshchenko@oracle.com>
 <20190819221101.GF1916@linux.intel.com>
 <CALMp9eR4zO=BOZKzDowkVSR7O9Y2aqBXEvwepv6j85z4wvSyxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eR4zO=BOZKzDowkVSR7O9Y2aqBXEvwepv6j85z4wvSyxA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 21, 2019 at 01:59:20PM -0700, Jim Mattson wrote:
> On Mon, Aug 19, 2019 at 3:11 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Tue, Aug 20, 2019 at 12:46:49AM +0300, Nikita Leshenko wrote:
> > > Before this commit, userspace could disable the GUEST_ACTIVITY_HLT bit in
> > > VMX_MISC yet KVM would happily accept GUEST_ACTIVITY_HLT activity state in
> > > VMCS12. We can fix it by either failing VM entries with HLT activity state when
> > > it's not supported or by disallowing clearing this bit.
> > >
> > > The latter is preferable. If we go with the former, to disable
> > > GUEST_ACTIVITY_HLT userspace also has to make CPU_BASED_HLT_EXITING a "must be
> > > 1" control, otherwise KVM will be presenting a bogus model to L1.
> > >
> > > Don't fail writes that disable GUEST_ACTIVITY_HLT to maintain backwards
> > > compatibility.
> >
> > Paolo, do we actually need to maintain backwards compatibility in this
> > case?  This seems like a good candidate for "fix the bug and see who yells".
> 
> Google's userspace clears bit 6. Please don't fail that write!

Booooo.

Requiring CPU_BASED_HLT_EXITING to be forced to 1 is probably off the
table since the bits are in two separate MSRs, i.e. we run into a
chicken-and-egg scenario.

Silently forcing GUEST_ACTIVITY_HLT seems wrong, especially if userspace
has also forced CPU_BASED_HLT_EXITING, e.g. KVM would be letting L1 do
something userspace explicitly asked KVM to prevent.

Generally speaking, KVM lets userspace do dumb things so long as it
doesn't break the kernel, so, what if we change sync_vmcs02_to_vmcs12()
to propagate GUEST_ACTIVITY_HLT to vmcs12 if and only if the activity
state exists?  That might be better than causing a nested VM-Enter to
fail?  I'm also a-ok doing nothing and fulling putting the onus on
userspace to get the config correct.
