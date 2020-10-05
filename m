Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F8B283A60
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 17:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbgJEPdw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 11:33:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47989 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728196AbgJEPdu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Oct 2020 11:33:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601912028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e+DWRUpbiQiXpTtH8uZPEzj9HagzEEg6X4PpDi9a9tQ=;
        b=TUtmXdPt4LkAjdlMCv/4ow5Zr7JuZBn71d0X6dr3UeCa4ktX/WOE09p5dP6H8zfxw+cwUQ
        N0JZESoN8N/SOStfcywJw3PF+RizVdqLAREAZaUChv2ypa9ibXb2Gk9IXQLw49v3z+jAZg
        Rc1fgbhofvjcJM/8p3GPapNmsjZRfz4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-l9Te37T8O5yKpmloldOQfQ-1; Mon, 05 Oct 2020 11:33:45 -0400
X-MC-Unique: l9Te37T8O5yKpmloldOQfQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B14AED58AD;
        Mon,  5 Oct 2020 15:33:19 +0000 (UTC)
Received: from horse.redhat.com (ovpn-114-167.rdu2.redhat.com [10.10.114.167])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 521CE9CBA;
        Mon,  5 Oct 2020 15:33:19 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id CAFB7220AD7; Mon,  5 Oct 2020 11:33:18 -0400 (EDT)
Date:   Mon, 5 Oct 2020 11:33:18 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtio-fs-list <virtio-fs@redhat.com>, vkuznets@redhat.com,
        pbonzini@redhat.com
Subject: Re: [PATCH v4] kvm,x86: Exit to user space in case page fault error
Message-ID: <20201005153318.GA4302@redhat.com>
References: <20200720211359.GF502563@redhat.com>
 <20200929043700.GL31514@linux.intel.com>
 <20201001215508.GD3522@redhat.com>
 <20201001223320.GI7474@linux.intel.com>
 <20201002153854.GC3119@redhat.com>
 <20201002183036.GB24460@linux.intel.com>
 <20201002192734.GD3119@redhat.com>
 <20201002194517.GD24460@linux.intel.com>
 <20201002200214.GB10232@redhat.com>
 <20201002211314.GE24460@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002211314.GE24460@linux.intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 02, 2020 at 02:13:14PM -0700, Sean Christopherson wrote:
> On Fri, Oct 02, 2020 at 04:02:14PM -0400, Vivek Goyal wrote:
> > On Fri, Oct 02, 2020 at 12:45:18PM -0700, Sean Christopherson wrote:
> > > On Fri, Oct 02, 2020 at 03:27:34PM -0400, Vivek Goyal wrote:
> > > > On Fri, Oct 02, 2020 at 11:30:37AM -0700, Sean Christopherson wrote:
> > > > > On Fri, Oct 02, 2020 at 11:38:54AM -0400, Vivek Goyal wrote:
> > > > > I don't think it's necessary to provide userspace with the register state of
> > > > > the guest task that hit the bad page.  Other than debugging, I don't see how
> > > > > userspace can do anything useful which such information.
> > > > 
> > > > I think debugging is the whole point so that user can figure out which
> > > > access by guest task resulted in bad memory access. I would think this
> > > > will be important piece of information.
> > > 
> > > But isn't this failure due to a truncation in the host?  Why would we care
> > > about debugging the guest?  It hasn't done anything wrong, has it?  Or am I
> > > misunderstanding the original problem statement.
> > 
> > I think you understood problem statement right. If guest has right
> > context, it just gives additional information who tried to access
> > the missing memory page. 
> 
> Yes, but it's not actionable, e.g. QEMU can't do anything differently given
> a guest RIP.  It's useful information for hands-on debug, but the information
> can be easily collected through other means when doing hands-on debug.

Hi Sean,

I tried my patch and truncated file on host before guest did memcpy().
After truncation guest process tried memcpy() on truncated region and
kvm exited to user space with -EFAULT. I see following on serial console.

I am assuming qemu is printing the state of vcpu.

************************************************************
error: kvm run failed Bad address
RAX=00007fff6e7a9750 RBX=0000000000000000 RCX=00007f513927e000 RDX=000000000000a
RSI=00007f513927e000 RDI=00007fff6e7a9750 RBP=00007fff6e7a97b0 RSP=00007fff6e7a8
R8 =0000000000000000 R9 =0000000000000031 R10=00007fff6e7a957c R11=0000000000006
R12=0000000000401140 R13=0000000000000000 R14=0000000000000000 R15=0000000000000
RIP=00007f51391e0547 RFL=00010202 [-------] CPL=3 II=0 A20=1 SMM=0 HLT=0
ES =0000 0000000000000000 ffffffff 00c00000
CS =0033 0000000000000000 ffffffff 00a0fb00 DPL=3 CS64 [-RA]
SS =002b 0000000000000000 ffffffff 00c0f300 DPL=3 DS   [-WA]
DS =0000 0000000000000000 ffffffff 00c00000
FS =0000 00007f5139246540 ffffffff 00c00000
GS =0000 0000000000000000 ffffffff 00c00000
LDT=0000 0000000000000000 00000000 00000000
TR =0040 fffffe00003a6000 00004087 00008b00 DPL=0 TSS64-busy
GDT=     fffffe00003a4000 0000007f
IDT=     fffffe0000000000 00000fff
CR0=80050033 CR2=00007f513927e004 CR3=000000102b5eb805 CR4=00770ee0
DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=000000000000
DR6=00000000fffe0ff0 DR7=0000000000000400
EFER=0000000000000d01
Code=fa 6f 06 c5 fa 6f 4c 16 f0 c5 fa 7f 07 c5 fa 7f 4c 17 f0 c3 <48> 8b 4c 16 3
*****************************************************************

I also changed my test program to print source and destination address
for memcpy.

dst=0x0x7fff6e7a9750 src=0x0x7f513927e000

Here dst matches RDI and src matches RSI. This trace also tells me
CPL=3 so a user space access triggered this.

Now I have few questions.

- If we exit to user space asynchronously (using kvm request), what debug
  information is in there which tells user which address is bad. I admit
  that even above trace does not seem to be telling me directly which
  address (HVA?) is bad.

  But if I take a crash dump of guest, using above information I should
  be able to get to GPA which is problematic. And looking at /proc/iomem
  it should also tell which device this memory region is in.

  Also using this crash dump one should be able to walk through virtiofs data
  structures and figure out which file and what offset with-in file does
  it belong to. Now one can look at filesystem on host and see file got
  truncated and it will become obvious it can't be faulted in. And then
  one can continue to debug that how did we arrive here.

But if we don't exit to user space synchronously, Only relevant
information we seem to have is -EFAULT. Apart from that, how does one
figure out what address is bad, or who tried to access it. Or which
file/offset does it belong to etc.

I agree that problem is not necessarily in guest code. But by exiting
synchronously, it gives enough information that one can use crash
dump to get to bottom of the issue. If we exit to user space
asynchronously, all this information will be lost and it might make
it very hard to figure out (if not impossible), what's going on.

>  
> > > > > To fully handle the situation, the guest needs to remove the bad page from
> > > > > its memory pool.  Once the page is offlined, the guest kernel's error
> > > > > handling will kick in when a task accesses the bad page (or nothing ever
> > > > > touches the bad page again and everyone is happy).
> > > > 
> > > > This is not really a case of bad page as such. It is more of a page
> > > > gone missing/trucated. And no new user can map it. We just need to
> > > > worry about existing users who already have it mapped.
> > > 
> > > What do you mean by "no new user can map it"?  Are you talking about guest
> > > tasks or host tasks?  If guest tasks, how would the guest know the page is
> > > missing and thus prevent mapping the non-existent page?
> > 
> > If a new task wants mmap(), it will send a request to virtiofsd/qemu
> > on host. If file has been truncated, then mapping beyond file size
> > will fail and process will get error.  So they will not be able to
> > map a page which has been truncated.
> 
> Ah.  Is there anything that prevents the notification side of things from
> being handled purely within the virtiofs layer?  E.g. host notifies the guest
> that a file got truncated, virtiofs driver in the guest invokes a kernel API
> to remove the page(s).

virtiofsd notifications can help a bit but not in all cases. For example,
If file got truncated and guest kernel accesses it immidiately after that,
(before notification arrives), it will hang and notification will not
be able to do much.

So while notification might be nice to have, but we still will need some
sort of error reporting from kvm.

Thanks
Vivek

