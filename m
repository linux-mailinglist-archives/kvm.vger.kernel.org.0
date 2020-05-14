Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 494B91D415A
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 00:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbgENW4Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 18:56:25 -0400
Received: from mga06.intel.com ([134.134.136.31]:13422 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728862AbgENW4Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 18:56:25 -0400
IronPort-SDR: XphbPiXGjZAD186beeRF5JMSXyddNu1UZHFdpvcRyDN59DpTv0jA3QzOToCtS845aFVSY+sPbA
 W35l45EhAKUA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2020 15:56:24 -0700
IronPort-SDR: 9IPy1ey2zPzinB0+KceUVPbReTGR4tDznmIBjxl+aauDbvEmBhEfcj2wcRxbH2Wk/GPYgzj9qh
 su334FQ0+vhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,392,1583222400"; 
   d="scan'208";a="438093378"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga005.jf.intel.com with ESMTP; 14 May 2020 15:56:24 -0700
Date:   Thu, 14 May 2020 15:56:24 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Tsirkin <mst@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org
Subject: Re: [PATCH RFC 0/5] KVM: x86: KVM_MEM_ALLONES memory
Message-ID: <20200514225623.GF15847@linux.intel.com>
References: <20200514180540.52407-1-vkuznets@redhat.com>
 <20200514220516.GC449815@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514220516.GC449815@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 14, 2020 at 06:05:16PM -0400, Peter Xu wrote:
> On Thu, May 14, 2020 at 08:05:35PM +0200, Vitaly Kuznetsov wrote:
> > The idea of the patchset was suggested by Michael S. Tsirkin.
> > 
> > PCIe config space can (depending on the configuration) be quite big but
> > usually is sparsely populated. Guest may scan it by accessing individual
> > device's page which, when device is missing, is supposed to have 'pci
> > holes' semantics: reads return '0xff' and writes get discarded. Currently,
> > userspace has to allocate real memory for these holes and fill them with
> > '0xff'. Moreover, different VMs usually require different memory.
> > 
> > The idea behind the feature introduced by this patch is: let's have a
> > single read-only page filled with '0xff' in KVM and map it to all such
> > PCI holes in all VMs. This will free userspace of obligation to allocate
> > real memory and also allow us to speed up access to these holes as we
> > can aggressively map the whole slot upon first fault.
> > 
> > RFC. I've only tested the feature with the selftest (PATCH5) on Intel/AMD
> > with and wiuthout EPT/NPT. I haven't tested memslot modifications yet.
> > 
> > Patches are against kvm/next.
> 
> Hi, Vitaly,
> 
> Could this be done in userspace with existing techniques?
> 
> E.g., shm_open() with a handle and fill one 0xff page, then remap it to
> anywhere needed in QEMU?

Mapping that 4k page over and over is going to get expensive, e.g. each
duplicate will need a VMA and a memslot, plus any PTE overhead.  If the
total sum of the holes is >2mb it'll even overflow the mumber of allowed
memslots.
