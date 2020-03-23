Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0F618FA3D
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 17:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgCWQou (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 12:44:50 -0400
Received: from mga06.intel.com ([134.134.136.31]:57127 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727686AbgCWQot (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 12:44:49 -0400
IronPort-SDR: gIg3r+Q83T7TZgiyL8OxMB2naREdc4tuoom1DfP32+qZ1tBX21qDoAmQLRCTFbRN8+iuZALAn9
 SldYZfAKy7nQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2020 09:44:48 -0700
IronPort-SDR: Hm+eB0RfVMBxxIF+g7Epr9a3bkiwXrIn7Kxppf3oUdQ+3yzvX3qwOUw+bTO9FJ5fn651hqMx1T
 hvtlOT5il54A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,297,1580803200"; 
   d="scan'208";a="246253181"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 23 Mar 2020 09:44:48 -0700
Date:   Mon, 23 Mar 2020 09:44:48 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v3 03/37] KVM: nVMX: Invalidate all EPTP contexts when
 emulating INVEPT for L1
Message-ID: <20200323164447.GQ28711@linux.intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
 <20200320212833.3507-4-sean.j.christopherson@intel.com>
 <CALMp9eR5Uu7nRDOS2nQHGzb+Gi6vjDEk1AmuiqkkGWFjKNG+sA@mail.gmail.com>
 <20200323162807.GN28711@linux.intel.com>
 <CALMp9eR42eM7g81EgHieyNky+kP2mycO7UyMN+y2ibLoqrD2Yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eR42eM7g81EgHieyNky+kP2mycO7UyMN+y2ibLoqrD2Yg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 23, 2020 at 09:36:22AM -0700, Jim Mattson wrote:
> On Mon, Mar 23, 2020 at 9:28 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Mon, Mar 23, 2020 at 09:24:25AM -0700, Jim Mattson wrote:
> > > On Fri, Mar 20, 2020 at 2:29 PM Sean Christopherson
> > > <sean.j.christopherson@intel.com> wrote:
> > > >
> > > > Free all L2 (guest_mmu) roots when emulating INVEPT for L1.  Outstanding
> > > > changes to the EPT tables managed by L1 need to be recognized, and
> > > > relying on KVM to always flush L2's EPTP context on nested VM-Enter is
> > > > dangerous.
> > > >
> > > > Similar to handle_invpcid(), rely on kvm_mmu_free_roots() to do a remote
> > > > TLB flush if necessary, e.g. if L1 has never entered L2 then there is
> > > > nothing to be done.
> > > >
> > > > Nuking all L2 roots is overkill for the single-context variant, but it's
> > > > the safe and easy bet.  A more precise zap mechanism will be added in
> > > > the future.  Add a TODO to call out that KVM only needs to invalidate
> > > > affected contexts.
> > > >
> > > > Fixes: b119019847fbc ("kvm: nVMX: Remove unnecessary sync_roots from handle_invept")
> > >
> > > The bug existed well before the commit indicated in the "Fixes" line.
> >
> > Ah, my bad.  A cursory glance at commit b119019847fbc makes that quite
> > obvious.  This should be
> >
> >   Fixes: bfd0a56b9000 ("nEPT: Nested INVEPT")
> 
> Actually, I think that things were fine back then (though we
> gratuitously flushed L1's TLB as a result of an emulated INVEPT). The
> problem started when we stopped flushing the TLB on every emulated
> VM-entry (i.e. L1 -> L2 transitions). I'm not sure what that commit
> was, but I think you referenced it in an earlier email.

Hmm, true.  I was thinking it was the original commit because it didn't
operate on guest_mmu, but guest_mmu didn't exist back then.  So I think

  Fixes: 14c07ad89f4d ("x86/kvm/mmu: introduce guest_mmu")

would be appropriate?
