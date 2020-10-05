Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D667283EF7
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 20:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729097AbgJESrs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 14:47:48 -0400
Received: from mga18.intel.com ([134.134.136.126]:47742 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbgJESrr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Oct 2020 14:47:47 -0400
IronPort-SDR: l57Wjg1OwZ/uPavpltYCl9J4/6ewp6C7VMn0DYHu+pwTgW7llAXTUPvbS/DEjx/BAdFan3m8gO
 0fqhIog5KCvg==
X-IronPort-AV: E=McAfee;i="6000,8403,9765"; a="151622929"
X-IronPort-AV: E=Sophos;i="5.77,340,1596524400"; 
   d="scan'208";a="151622929"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 11:47:37 -0700
IronPort-SDR: VThCkMd3d/Yu3WZuz2UNoDj9UNgjNkNre9QkADdqhmiJoHFzSaVMzt901EXH2dOqxn1nDtrEOu
 7w01H7Th+tuA==
X-IronPort-AV: E=Sophos;i="5.77,340,1596524400"; 
   d="scan'208";a="459817381"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 09:16:32 -0700
Date:   Mon, 5 Oct 2020 09:16:20 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtio-fs-list <virtio-fs@redhat.com>, vkuznets@redhat.com,
        pbonzini@redhat.com
Subject: Re: [PATCH v4] kvm,x86: Exit to user space in case page fault error
Message-ID: <20201005161620.GC11938@linux.intel.com>
References: <20200929043700.GL31514@linux.intel.com>
 <20201001215508.GD3522@redhat.com>
 <20201001223320.GI7474@linux.intel.com>
 <20201002153854.GC3119@redhat.com>
 <20201002183036.GB24460@linux.intel.com>
 <20201002192734.GD3119@redhat.com>
 <20201002194517.GD24460@linux.intel.com>
 <20201002200214.GB10232@redhat.com>
 <20201002211314.GE24460@linux.intel.com>
 <20201005153318.GA4302@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005153318.GA4302@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 05, 2020 at 11:33:18AM -0400, Vivek Goyal wrote:
> On Fri, Oct 02, 2020 at 02:13:14PM -0700, Sean Christopherson wrote:
> Now I have few questions.
> 
> - If we exit to user space asynchronously (using kvm request), what debug
>   information is in there which tells user which address is bad. I admit
>   that even above trace does not seem to be telling me directly which
>   address (HVA?) is bad.
> 
>   But if I take a crash dump of guest, using above information I should
>   be able to get to GPA which is problematic. And looking at /proc/iomem
>   it should also tell which device this memory region is in.
> 
>   Also using this crash dump one should be able to walk through virtiofs data
>   structures and figure out which file and what offset with-in file does
>   it belong to. Now one can look at filesystem on host and see file got
>   truncated and it will become obvious it can't be faulted in. And then
>   one can continue to debug that how did we arrive here.
> 
> But if we don't exit to user space synchronously, Only relevant
> information we seem to have is -EFAULT. Apart from that, how does one
> figure out what address is bad, or who tried to access it. Or which
> file/offset does it belong to etc.
>
> I agree that problem is not necessarily in guest code. But by exiting
> synchronously, it gives enough information that one can use crash
> dump to get to bottom of the issue. If we exit to user space
> asynchronously, all this information will be lost and it might make
> it very hard to figure out (if not impossible), what's going on.

If we want userspace to be able to do something useful, KVM should explicitly
inform userspace about the error, userspace shouldn't simply assume that
-EFAULT means a HVA->PFN lookup failed.  Userspace also shouldn't have to
query guest state to handle the error, as that won't work for protected guests
guests like SEV-ES and TDX.

I can think of two options:

  1. Send a signal, a la kvm_send_hwpoison_signal().

  2. Add a userspace exit reason along with a new entry in the run struct,
     e.g. that provides the bad GPA, HVA, possibly permissions, etc...

> > > > > > To fully handle the situation, the guest needs to remove the bad page from
> > > > > > its memory pool.  Once the page is offlined, the guest kernel's error
> > > > > > handling will kick in when a task accesses the bad page (or nothing ever
> > > > > > touches the bad page again and everyone is happy).
> > > > > 
> > > > > This is not really a case of bad page as such. It is more of a page
> > > > > gone missing/trucated. And no new user can map it. We just need to
> > > > > worry about existing users who already have it mapped.
> > > > 
> > > > What do you mean by "no new user can map it"?  Are you talking about guest
> > > > tasks or host tasks?  If guest tasks, how would the guest know the page is
> > > > missing and thus prevent mapping the non-existent page?
> > > 
> > > If a new task wants mmap(), it will send a request to virtiofsd/qemu
> > > on host. If file has been truncated, then mapping beyond file size
> > > will fail and process will get error.  So they will not be able to
> > > map a page which has been truncated.
> > 
> > Ah.  Is there anything that prevents the notification side of things from
> > being handled purely within the virtiofs layer?  E.g. host notifies the guest
> > that a file got truncated, virtiofs driver in the guest invokes a kernel API
> > to remove the page(s).
> 
> virtiofsd notifications can help a bit but not in all cases. For example,
> If file got truncated and guest kernel accesses it immidiately after that,
> (before notification arrives), it will hang and notification will not
> be able to do much.
> 
> So while notification might be nice to have, but we still will need some
> sort of error reporting from kvm.

And I'm in full agreement with that.  What I'm saying is that resolving the
infinite loop is a _bug fix_ and is completely orthogonal to adding a new
mechanism to handle the file truncation scenario.
