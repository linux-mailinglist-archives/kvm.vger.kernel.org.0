Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6CA281AE4
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 20:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387935AbgJBSak (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 14:30:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:2785 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgJBSak (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 14:30:40 -0400
IronPort-SDR: 2SWHkPpRO0qtLCzvSrigKc4vmfWj5o6PXcIEDzutSdcByM1tH55Q0Vhl55dZXWchR2DTdq/COh
 duTOQxKYWdHQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9762"; a="160374675"
X-IronPort-AV: E=Sophos;i="5.77,328,1596524400"; 
   d="scan'208";a="160374675"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2020 11:30:39 -0700
IronPort-SDR: QM5tdP9JMZkaiRHIVtAyo1ij9Ez69aiKRchDZCrY/iloWU+N+xL1DilhsSPgxh3re0gxZy0vAw
 DZU3g3/L20+Q==
X-IronPort-AV: E=Sophos;i="5.77,328,1596524400"; 
   d="scan'208";a="313592886"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2020 11:30:39 -0700
Date:   Fri, 2 Oct 2020 11:30:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtio-fs-list <virtio-fs@redhat.com>, vkuznets@redhat.com,
        pbonzini@redhat.com
Subject: Re: [PATCH v4] kvm,x86: Exit to user space in case page fault error
Message-ID: <20201002183036.GB24460@linux.intel.com>
References: <20200720211359.GF502563@redhat.com>
 <20200929043700.GL31514@linux.intel.com>
 <20201001215508.GD3522@redhat.com>
 <20201001223320.GI7474@linux.intel.com>
 <20201002153854.GC3119@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002153854.GC3119@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 02, 2020 at 11:38:54AM -0400, Vivek Goyal wrote:
> On Thu, Oct 01, 2020 at 03:33:20PM -0700, Sean Christopherson wrote:
> > Alternatively, what about adding a new KVM request type to handle this?
> > E.g. when the APF comes back with -EFAULT, snapshot the GFN and make a
> > request.  The vCPU then gets kicked and exits to userspace.  Before exiting
> > to userspace, the request handler resets vcpu->arch.apf.error_gfn.  Bad GFNs
> > simply get if error_gfn is "valid", i.e. there's a pending request.
> 
> Sorry, I did not understand the above proposal. Can you please elaborate
> a bit more. Part of it is that I don't know much about KVM requests.
> Looking at the code it looks like that main loop is parsing if some
> kvm request is pending and executing that action.
> 
> Don't we want to make sure that we exit to user space when guest retries
> error gfn access again.

> In this case once we get -EFAULT, we will still inject page_ready into
> guest. And then either same process or a different process might run. 
> 
> So when exactly code raises a kvm request. If I raise it right when
> I get -EFAULT, then kvm will exit to user space upon next entry
> time. But there is no guarantee guest vcpu is running the process which
> actually accessed the error gfn. And that probably means that register
> state of cpu does not mean much and one can not easily figure out
> which task tried to access the bad memory and when.
> 
> That's why we prepare a list of error gfn and only exit to user space
> when error_gfn access is retried so that guest vcpu context is correct.
> 
> What am I missing?

I don't think it's necessary to provide userspace with the register state of
the guest task that hit the bad page.  Other than debugging, I don't see how
userspace can do anything useful which such information.

Even if you want to inject an event of some form into the guest, having the
correct context for the event itself is not required.  IMO it's perfectly
reasonable for such an event to be asynchronous.

IIUC, your end goal is to be able to gracefully handle DAX file truncation.
Simply killing the guest task that hit the bad page isn't sufficient, as
nothing prevents a future task from accessing the same bad page.  To fully
handle the situation, the guest needs to remove the bad page from its memory
pool.  Once the page is offlined, the guest kernel's error handling will
kick in when a task accesses the bad page (or nothing ever touches the bad
page again and everyone is happy).

Note, I'm not necessarily suggesting that QEMU piggyback its #MC injection
to handle this, but I suspect the resulting behavior will look quite similar,
e.g. notify the virtiofs driver in the guest, which does some magic to take
the offending region offline, and then guest tasks get SIGBUS or whatever.

I also don't think it's KVM's responsibility to _directly_ handle such a
scenario.  As I said in an earlier version, KVM can't possibly know _why_ a
page fault came back with -EFAULT, only userspace can connect the dots of
GPA -> HVA -> vm_area_struct -> file -> inject event.  KVM definitely should
exit to userspace on the -EFAULT instead of hanging the guest, but that can
be done via a new request, as suggested.
