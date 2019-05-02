Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0757E123D3
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 23:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfEBVGt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 17:06:49 -0400
Received: from mga12.intel.com ([192.55.52.136]:25583 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbfEBVGt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 May 2019 17:06:49 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 14:06:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,423,1549958400"; 
   d="scan'208";a="170078992"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by fmsmga001.fm.intel.com with ESMTP; 02 May 2019 14:06:46 -0700
Date:   Thu, 2 May 2019 14:06:45 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Jintack Lim <jintack@cs.columbia.edu>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH] KVM: nVMX: Set msr bitmap correctly for MSR_FS_BASE in
 vmcs02
Message-ID: <20190502210645.GC26138@linux.intel.com>
References: <1556762959-31705-1-git-send-email-jintack@cs.columbia.edu>
 <20190502150315.GB26138@linux.intel.com>
 <CALMp9eQot5jqiN4ncLDCPt_ZiVvtmEb_zeMp=1gkOChTrgL+dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eQot5jqiN4ncLDCPt_ZiVvtmEb_zeMp=1gkOChTrgL+dg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 02, 2019 at 10:59:16AM -0700, Jim Mattson wrote:
> On Thu, May 2, 2019 at 8:03 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> 
> > That being said, I think there are other reasons why KVM doesn't pass
> > through MSRs to L2.  Unfortunately, I'm struggling to recall what those
> > reasons are.
> >
> > Jim, I'm pretty sure you've looked at this code a lot, do you happen to
> > know off hand?  Is it purely a performance thing to avoid merging bitmaps
> > on every nested entry, is there a subtle bug/security hole, or is it
> > simply that no one has ever gotten around to writing the code?
> 
> I'm not aware of any subtle bugs or security holes. If L1 changes the
> VMCS12 MSR permission bitmaps while L2 is running, behavior is
> unlikely to match hardware, but this is clearly in "undefined
> behavior" territory anyway. IIRC, the posted interrupt structures are
> the only thing hanging off of the VMCS that can legally be modified
> while a logical processor with that VMCS active is in VMX non-root
> operation.

Cool, thanks!

> I agree that FS_BASE, GS_BASE, and KERNEL_GS_BASE, at the very least,
> are worthy of special treatment. Fortunately, their permission bits
> are all in the same quadword. Some of the others, like the SYSENTER
> and SYSCALL MSRs are rarely modified by a typical (non-hypervisor) OS.
> For nested performance at levels deeper than L2, they might still
> prove interesting.

Agreed on the *_BASE MSRs.  Rarely written MSRs should be intercepted
so that the nested VM-Exit path doesn't need to read them from vmcs02
on every exit (WIP).  I'm playing with the nested code right now and
one of the things I'm realizing is that KVM spends an absurd amount of
time copying data to/from VMCSes for fields that are almost never
accessed by L0 or L1.

> Basically, I think no one has gotten around to writing the code.
