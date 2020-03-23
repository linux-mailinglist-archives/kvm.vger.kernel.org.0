Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD6AD18F9AC
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 17:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727488AbgCWQ2J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 12:28:09 -0400
Received: from mga14.intel.com ([192.55.52.115]:19414 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727411AbgCWQ2J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 12:28:09 -0400
IronPort-SDR: PemWAPFAARcZfG57unigBTJa7mROMKjtmRzVQNAuc8iItqWr02lOdbCCo0097sniHLeBZQ5NaL
 VbZKqsfT+UtA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2020 09:28:08 -0700
IronPort-SDR: XPZx971dDGnd9cKSbQiWD0/HHL19uFvggUQ2Hst80Tdn9KI/0UgJ/II+SVwVpelPbl4X/UNJG0
 Pg7JNSBGD3Yg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,297,1580803200"; 
   d="scan'208";a="237948059"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga007.fm.intel.com with ESMTP; 23 Mar 2020 09:28:07 -0700
Date:   Mon, 23 Mar 2020 09:28:07 -0700
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
Message-ID: <20200323162807.GN28711@linux.intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
 <20200320212833.3507-4-sean.j.christopherson@intel.com>
 <CALMp9eR5Uu7nRDOS2nQHGzb+Gi6vjDEk1AmuiqkkGWFjKNG+sA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eR5Uu7nRDOS2nQHGzb+Gi6vjDEk1AmuiqkkGWFjKNG+sA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 23, 2020 at 09:24:25AM -0700, Jim Mattson wrote:
> On Fri, Mar 20, 2020 at 2:29 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > Free all L2 (guest_mmu) roots when emulating INVEPT for L1.  Outstanding
> > changes to the EPT tables managed by L1 need to be recognized, and
> > relying on KVM to always flush L2's EPTP context on nested VM-Enter is
> > dangerous.
> >
> > Similar to handle_invpcid(), rely on kvm_mmu_free_roots() to do a remote
> > TLB flush if necessary, e.g. if L1 has never entered L2 then there is
> > nothing to be done.
> >
> > Nuking all L2 roots is overkill for the single-context variant, but it's
> > the safe and easy bet.  A more precise zap mechanism will be added in
> > the future.  Add a TODO to call out that KVM only needs to invalidate
> > affected contexts.
> >
> > Fixes: b119019847fbc ("kvm: nVMX: Remove unnecessary sync_roots from handle_invept")
> 
> The bug existed well before the commit indicated in the "Fixes" line.

Ah, my bad.  A cursory glance at commit b119019847fbc makes that quite
obvious.  This should be

  Fixes: bfd0a56b9000 ("nEPT: Nested INVEPT")
