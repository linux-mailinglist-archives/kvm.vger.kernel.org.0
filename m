Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD76DB68A
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2019 20:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403851AbfJQSuE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Oct 2019 14:50:04 -0400
Received: from mga18.intel.com ([134.134.136.126]:59129 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388823AbfJQSuD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Oct 2019 14:50:03 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Oct 2019 11:50:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,308,1566889200"; 
   d="scan'208";a="371227018"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga005.jf.intel.com with ESMTP; 17 Oct 2019 11:50:03 -0700
Date:   Thu, 17 Oct 2019 11:50:02 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [RFC PATCH 00/28] kvm: mmu: Rework the x86 TDP direct mapped case
Message-ID: <20191017185002.GG20903@linux.intel.com>
References: <20190926231824.149014-1-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926231824.149014-1-bgardon@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 26, 2019 at 04:17:56PM -0700, Ben Gardon wrote:
> Over the years, the needs for KVM's x86 MMU have grown from running small
> guests to live migrating multi-terabyte VMs with hundreds of vCPUs. Where
> we previously depended upon shadow paging to run all guests, we now have
> the use of two dimensional paging (TDP). This RFC proposes and
> demonstrates two major changes to the MMU. First, an iterator abstraction 
> that simplifies traversal of TDP paging structures when running an L1
> guest. This abstraction takes advantage of the relative simplicity of TDP
> to simplify the implementation of MMU functions. Second, this RFC changes
> the synchronization model to enable more parallelism than the monolithic
> MMU lock. This "direct mode" MMU is currently in use at Google and has
> given us the performance necessary to live migrate our 416 vCPU, 12TiB
> m2-ultramem-416 VMs.
> 
> The primary motivation for this work was to handle page faults in
> parallel. When VMs have hundreds of vCPUs and terabytes of memory, KVM's
> MMU lock suffers from extreme contention, resulting in soft-lockups and
> jitter in the guest. To demonstrate this I also written, and will submit
> a demand paging test to KVM selftests. The test creates N vCPUs, which
> each touch disjoint regions of memory. Page faults are picked up by N
> user fault FD handlers, one for each vCPU. Over a 1 second profile of
> the demand paging test, with 416 vCPUs and 4G per vCPU, 98% of the
> execution time was spent waiting for the MMU lock! With this patch
> series the total execution time for the test was reduced by 89% and the
> execution was dominated by get_user_pages and the user fault FD ioctl.
> As a secondary benefit, the iterator-based implementation does not use
> the rmap or struct kvm_mmu_pages, saving ~0.2% of guest memory in KVM
> overheads.
> 
> The goal of this  RFC is to demonstrate and gather feedback on the
> iterator pattern, the memory savings it enables for the "direct case"
> and the changes to the synchronization model. Though they are interwoven
> in this series, I will separate the iterator from the synchronization
> changes in a future series. I recognize that some feature work will be
> needed to make this patch set ready for merging. That work is detailed
> at the end of this cover letter.

Diving into this series is on my todo list, but realistically that's not
going to happen until after KVM forum.  Sorry I can't provide timely
feedback.
