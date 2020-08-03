Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684D023AF99
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 23:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbgHCVXJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Aug 2020 17:23:09 -0400
Received: from mga07.intel.com ([134.134.136.100]:14126 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728256AbgHCVXJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Aug 2020 17:23:09 -0400
IronPort-SDR: NBMuFDmnPKx9NebyCT+vQyF5+jpekkC5oorRcrhjy4WI8uajBFLI6tpIj451/8laR59VHQNI9P
 86XAiX78JHYw==
X-IronPort-AV: E=McAfee;i="6000,8403,9702"; a="216609915"
X-IronPort-AV: E=Sophos;i="5.75,431,1589266800"; 
   d="scan'208";a="216609915"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2020 14:23:08 -0700
IronPort-SDR: hF6njcnE8SnJWNhsZBBlJ4cLXyJa3HDZs8WmMD5zJaubot2BsbrAgt77Fr3PwYgtXgDRFZKxf/
 VGAEpUe+uj2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,431,1589266800"; 
   d="scan'208";a="288237306"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga003.jf.intel.com with ESMTP; 03 Aug 2020 14:23:08 -0700
Date:   Mon, 3 Aug 2020 14:23:08 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Alexander Graf <graf@amazon.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        KarimAllah Raslan <karahmed@amazon.de>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] KVM: x86: Introduce allow list for MSR emulation
Message-ID: <20200803212307.GI3151@linux.intel.com>
References: <20200731214947.16885-1-graf@amazon.com>
 <20200731214947.16885-3-graf@amazon.com>
 <87zh7cot7t.fsf@vitty.brq.redhat.com>
 <2585c6d6-81b0-8375-78ed-862da226ad6c@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2585c6d6-81b0-8375-78ed-862da226ad6c@amazon.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 03, 2020 at 10:50:53PM +0200, Alexander Graf wrote:
> 
> On 03.08.20 13:37, Vitaly Kuznetsov wrote:
> >>+static int kvm_vm_ioctl_clear_msr_allowlist(struct kvm *kvm)
> >>+{
> >>+     mutex_lock(&kvm->lock);
> >>+     kvm->arch.msr_allowlist_ranges_count = 0;
> >>+     mutex_unlock(&kvm->lock);
> >
> >Are we also supposed to kfree() bitmaps here?
> 
> Phew. Yes, because without the kfree() we're leaking memory. Unfortunately
> if I just put in a kfree() here, we may allow a concurrently executing vCPU
> to access already free'd memory.
> 
> So I'll also add locking around the range check. Let's hope it won't regress
> performance too much.

What about using KVM's SRCU to protect the list?  The only thing I'm not 100%
on is whether holding kvm->lock across synchronize_srcu() is safe from a lock
inversion perspective.  I'm pretty sure KVM doesn't try to acquire kvm->lock
after grabbing SRCU, but that's hard to audit and there aren't any existing
flows that invoke synchronize_srcu() while holding kvm->lock.
