Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC9478BC55
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 17:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729840AbfHMPB3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 11:01:29 -0400
Received: from mga06.intel.com ([134.134.136.31]:50964 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729665AbfHMPB3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 11:01:29 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Aug 2019 08:01:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,381,1559545200"; 
   d="scan'208";a="351556260"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga005.jf.intel.com with ESMTP; 13 Aug 2019 08:01:28 -0700
Date:   Tue, 13 Aug 2019 08:01:28 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Adalbert =?utf-8?B?TGF6xINy?= <alazar@bitdefender.com>,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        virtualization@lists.linux-foundation.org,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        Samuel =?iso-8859-1?Q?Laur=E9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        Mihai =?utf-8?B?RG9uyJt1?= <mdontu@bitdefender.com>,
        Mircea =?iso-8859-1?Q?C=EErjaliu?= <mcirjaliu@bitdefender.com>
Subject: Re: [RFC PATCH v6 01/92] kvm: introduce KVMI (VM introspection
 subsystem)
Message-ID: <20190813150128.GB13991@linux.intel.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-2-alazar@bitdefender.com>
 <20190812202030.GB1437@linux.intel.com>
 <5d52a5ae.1c69fb81.5c260.1573SMTPIN_ADDED_BROKEN@mx.google.com>
 <5fa6bd89-9d02-22cd-24a8-479abaa4f788@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5fa6bd89-9d02-22cd-24a8-479abaa4f788@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 13, 2019 at 02:09:51PM +0200, Paolo Bonzini wrote:
> On 13/08/19 13:57, Adalbert Lazăr wrote:
> >> The refcounting approach seems a bit backwards, and AFAICT is driven by
> >> implementing unhook via a message, which also seems backwards.  I assume
> >> hook and unhook are relatively rare events and not performance critical,
> >> so make those the restricted/slow flows, e.g. force userspace to quiesce
> >> the VM by making unhook() mutually exclusive with every vcpu ioctl() and
> >> maybe anything that takes kvm->lock. 
> >>
> >> Then kvmi_ioctl_unhook() can use thread_stop() and kvmi_recv() just needs
> >> to check kthread_should_stop().
> >>
> >> That way kvmi doesn't need to be refcounted since it's guaranteed to be
> >> alive if the pointer is non-null.  Eliminating the refcounting will clean
> >> up a lot of the code by eliminating calls to kvmi_{get,put}(), e.g.
> >> wrappers like kvmi_breakpoint_event() just check vcpu->kvmi, or maybe
> >> even get dropped altogether.
> > 
> > The unhook event has been added to cover the following case: while the
> > introspection tool runs in another VM, both VMs, the virtual appliance
> > and the introspected VM, could be paused by the user. We needed a way
> > to signal this to the introspection tool and give it time to unhook
> > (the introspected VM has to run and execute the introspection commands
> > during this phase). The receiving threads quits when the socket is closed
> > (by QEMU or by the introspection tool).

Why does closing the socket require destroying the kvmi object?  E.g. can
it be marked as defunct or whatever and only fully removed on a synchronous
unhook from userspace?  Re-hooking could either require said unhook, or
maybe reuse the existing kvmi object with a new socket.

> > It's a bit unclear how, but we'll try to get ride of the refcount object,
> > which will remove a lot of code, indeed.
> 
> You can keep it for now.  It may become clearer how to fix it after the
> event loop is cleaned up.

By event loop, do you mean the per-vCPU jobs list?
