Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2547E1D41B6
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 01:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728262AbgENXcK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 19:32:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:5585 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727956AbgENXcK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 19:32:10 -0400
IronPort-SDR: UCSX5GmE8G1uZTSUHPN1JibF3jGVsL6KZE/1yWKG4q3ES3N1Y9if7d57b6yUa+p6rXyfYYCiPJ
 prhpcslIlhbg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2020 16:32:09 -0700
IronPort-SDR: hag/P9iVoSNRCw+5TWpI+ii3mA+AAvc5yIwSVlTxUg74ofn6XhHd7CXmb/4pPGSfRJe9blrtCD
 AUtLqSb3lazw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,392,1583222400"; 
   d="scan'208";a="252217881"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga007.fm.intel.com with ESMTP; 14 May 2020 16:32:08 -0700
Date:   Thu, 14 May 2020 16:32:08 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Tsirkin <mst@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org
Subject: Re: [PATCH RFC 0/5] KVM: x86: KVM_MEM_ALLONES memory
Message-ID: <20200514233208.GI15847@linux.intel.com>
References: <20200514180540.52407-1-vkuznets@redhat.com>
 <20200514220516.GC449815@xz-x1>
 <20200514225623.GF15847@linux.intel.com>
 <20200514232250.GA479802@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514232250.GA479802@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 14, 2020 at 07:22:50PM -0400, Peter Xu wrote:
> On Thu, May 14, 2020 at 03:56:24PM -0700, Sean Christopherson wrote:
> > On Thu, May 14, 2020 at 06:05:16PM -0400, Peter Xu wrote:
> > > E.g., shm_open() with a handle and fill one 0xff page, then remap it to
> > > anywhere needed in QEMU?
> > 
> > Mapping that 4k page over and over is going to get expensive, e.g. each
> > duplicate will need a VMA and a memslot, plus any PTE overhead.  If the
> > total sum of the holes is >2mb it'll even overflow the mumber of allowed
> > memslots.
> 
> What's the PTE overhead you mentioned?  We need to fill PTEs one by one on
> fault even if the page is allocated in the kernel, am I right?

It won't require host PTEs for every page if it's a kernel page.  I doubt
PTEs are a significant overhead, especially compared to memslots, but it's
still worth considering.

My thought was to skimp on both host PTEs _and_ KVM SPTEs by always sending
the PCI hole accesses down the slow MMIO path[*].

[*] https://lkml.kernel.org/r/20200514194624.GB15847@linux.intel.com

> 4K is only an example - we can also use more pages as the template.  However I
> guess the kvm memslot count could be a limit..  Could I ask what's the normal
> size of this 0xff region, and its distribution?
> 
> Thanks,
> 
> -- 
> Peter Xu
> 
