Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E04D890305
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2019 15:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbfHPN34 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Aug 2019 09:29:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:21164 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727246AbfHPN34 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Aug 2019 09:29:56 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Aug 2019 06:29:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,393,1559545200"; 
   d="scan'208";a="188814716"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.128])
  by orsmga002.jf.intel.com with ESMTP; 16 Aug 2019 06:29:53 -0700
Date:   Fri, 16 Aug 2019 21:31:30 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        yu.c.zhang@intel.com, alazar@bitdefender.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH RESEND v4 5/9] KVM: VMX: Add init/set/get functions for
 SPP
Message-ID: <20190816133130.GA14380@local-michael-cet-test.sh.intel.com>
References: <20190814070403.6588-1-weijiang.yang@intel.com>
 <20190814070403.6588-6-weijiang.yang@intel.com>
 <87a7cbapdw.fsf@vitty.brq.redhat.com>
 <20190815134329.GA11449@local-michael-cet-test>
 <CALMp9eTGXDDfVspFwFyEhagg9sdnqZqzSQhDksT0bkKzVNGSqw@mail.gmail.com>
 <20190815163844.GD27076@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190815163844.GD27076@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 15, 2019 at 09:38:44AM -0700, Sean Christopherson wrote:
> On Thu, Aug 15, 2019 at 09:25:41AM -0700, Jim Mattson wrote:
> > On Thu, Aug 15, 2019 at 6:41 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
> > 
> > > Hi, Vitaly,
> > > After looked into the issue and others, I feel to make SPP co-existing
> > > with nested VM is not good, the major reason is, L1 pages protected by
> > > SPP are transparent to L1 VM, if it launches L2 VM, probably the
> > > pages would be allocated to L2 VM, and that will bother to L1 and L2.
> > > Given the feature is new and I don't see nested VM can benefit
> > > from it right now, I would like to make SPP and nested feature mutually
> > > exclusive, i.e., detecting if the other part is active before activate one
> > > feature,what do you think of it?
> > > thanks!
> > 
> > How do you propose making the features mutually exclusive?
> 
> I haven't looked at the details or the end to end flow, but would it make
> sense to exit to userspace on nested VMLAUNCH/VMRESUME if there are SPP
> mappings?  And have the SPP ioctl() kick vCPUs out of guest.
> 
> KVM already exits on SPP violations, so presumably this is something that
> can be punted to userspace.
Thanks Jim and Sean! Could we add a new flag in kvm to identify if nested VM is on
or off? That would make things easier. When VMLAUNCH is trapped,
set the flag, if VMXOFF is trapped, clear the flag.
