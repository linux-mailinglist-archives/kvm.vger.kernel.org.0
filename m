Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D858125CFE2
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 05:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729627AbgIDDrT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 23:47:19 -0400
Received: from mga17.intel.com ([192.55.52.151]:5919 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729550AbgIDDrS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Sep 2020 23:47:18 -0400
IronPort-SDR: QG8vhPin+sU3aLuNrRl+gtUFRTomoJHmfiQhf78D+CB2vfGCo7uKue4eiUKnDrEr9V0CDw9hXj
 L//3GSH+Wp/Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9733"; a="137741692"
X-IronPort-AV: E=Sophos;i="5.76,388,1592895600"; 
   d="scan'208";a="137741692"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2020 20:47:17 -0700
IronPort-SDR: l80ZKwhyHrrNVLW2qWFsR+EQpGT1/DUhufk6hBFi7IfbRxdUGVll6g8fe5DQptPXoM3Iz4g8lR
 8RVhfqTAMG0g==
X-IronPort-AV: E=Sophos;i="5.76,388,1592895600"; 
   d="scan'208";a="478304823"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2020 20:47:17 -0700
Date:   Thu, 3 Sep 2020 20:47:16 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>, Michael Tsirkin <mst@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] KVM: x86: move kvm_vcpu_gfn_to_memslot() out of
 try_async_pf()
Message-ID: <20200904034714.GA22394@sjchrist-ice>
References: <20200807141232.402895-1-vkuznets@redhat.com>
 <20200807141232.402895-2-vkuznets@redhat.com>
 <20200814014014.GA4845@linux.intel.com>
 <87k0xdwplg.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k0xdwplg.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 01, 2020 at 04:15:07PM +0200, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > On Fri, Aug 07, 2020 at 04:12:30PM +0200, Vitaly Kuznetsov wrote:
> >> No functional change intended. Slot flags will need to be analyzed
> >> prior to try_async_pf() when KVM_MEM_PCI_HOLE is implemented.
> >
> 
> (Sorry it took me so long to reply. No, I wasn't hoping for Paolo's
> magical "queued, thanks", I just tried to not read my email while on
> vacation).
> 
> > Why?  Wouldn't it be just as easy, and arguably more appropriate, to add
> > KVM_PFN_ERR_PCI_HOLE and update handle_abornmal_pfn() accordinaly?
> >
> 
> Yes, we can do that, but what I don't quite like here is that
> try_async_pf() does much more than 'trying async PF'. In particular, it
> extracts 'pfn' and this is far from being obvious. Maybe we can rename
> try_async_pf() somewhat smartly (e.g. 'try_handle_pf()')? Your
> suggestion will make perfect sense to me then.

Ya, try_async_pf() is a horrible name.  try_handle_pf() isn't bad, but it's
not technically handling the fault.  Maybe try_get_pfn() with an inverted
return?

	if (!try_get_pfn(...))
		return RET_PF_RETRY;
