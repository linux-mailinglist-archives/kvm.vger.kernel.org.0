Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A689168281
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 16:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729260AbgBUP7l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 10:59:41 -0500
Received: from mga07.intel.com ([134.134.136.100]:7937 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728235AbgBUP7k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 10:59:40 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Feb 2020 07:59:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,468,1574150400"; 
   d="scan'208";a="225252206"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 21 Feb 2020 07:59:39 -0800
Date:   Fri, 21 Feb 2020 07:59:39 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Chia-I Wu <olvaffe@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Gurchetan Singh <gurchetansingh@chromium.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        ML dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: [RFC PATCH 0/3] KVM: x86: honor guest memory type
Message-ID: <20200221155939.GG12665@linux.intel.com>
References: <d3a6fac6-3831-3b8e-09b6-bfff4592f235@redhat.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D78D6F4@SHSMSX104.ccr.corp.intel.com>
 <CAPaKu7RyTbuTPf0Tp=0DAD80G-RySLrON8OQsHJzhAYDh7zHuA@mail.gmail.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D78EE65@SHSMSX104.ccr.corp.intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D78EF58@SHSMSX104.ccr.corp.intel.com>
 <CAPaKu7RFY3nar9hmAdx6RYdZFPK3Cdg1O3cS+OvsEOT=yupyrQ@mail.gmail.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D792415@SHSMSX104.ccr.corp.intel.com>
 <CAPaKu7RHu5rz1Dvkvp4SDrZ0fAYq37xwRqUsdAiOmRTOz2sFTw@mail.gmail.com>
 <CAPaKu7RaF3+amPwdVBLj6q1na7JWUYuuWDN5XPwNYFB8Hpqi+w@mail.gmail.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D79359E@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D79359E@SHSMSX104.ccr.corp.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 20, 2020 at 09:39:05PM -0800, Tian, Kevin wrote:
> > From: Chia-I Wu <olvaffe@gmail.com>
> > Sent: Friday, February 21, 2020 12:51 PM
> > If you think it is the best for KVM to inspect hva to determine the memory
> > type with page granularity, that is reasonable and should work for us too.
> > The userspace can do something (e.g., add a GPU driver dependency to the
> > hypervisor such that the dma-buf is imported as a GPU memory and mapped
> > using
> > vkMapMemory) or I can work with dma-buf maintainers to see if dma-buf's
> > semantics can be changed.
> 
> I think you need consider the live migration requirement as Paolo pointed out.
> The migration thread needs to read/write the region, then it must use the
> same type as GPU process and guest to read/write the region. In such case, 
> the hva mapped by Qemu should have the desired type as the guest. However,
> adding GPU driver dependency to Qemu might trigger some concern. I'm not
> sure whether there is generic mechanism though, to share dmabuf fd between GPU
> process and Qemu while allowing Qemu to follow the desired type w/o using
> vkMapMemory...

Alternatively, KVM could make KVM_MEM_DMA and KVM_MEM_LOG_DIRTY_PAGES
mutually exclusive, i.e. force a transition to WB memtype for the guest
(with appropriate zapping) when migration is activated.  I think that
would work?

> Note this is orthogonal to whether introducing a new uapi or implicitly checking
> hva to favor guest memory type. It's purely about Qemu itself. Ideally anyone 
> with the desire to access a dma-buf object should follow the expected semantics.
> It's interesting that dma-buf sub-system doesn't provide a centralized 
> synchronization about memory type between multiple mmap paths. 
