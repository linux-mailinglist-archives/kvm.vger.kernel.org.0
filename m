Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9B97960FA
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 15:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730324AbfHTNo2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Aug 2019 09:44:28 -0400
Received: from mga03.intel.com ([134.134.136.65]:8998 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730789AbfHTNnI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Aug 2019 09:43:08 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Aug 2019 06:43:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,408,1559545200"; 
   d="scan'208";a="172453032"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by orsmga008.jf.intel.com with ESMTP; 20 Aug 2019 06:43:05 -0700
Date:   Tue, 20 Aug 2019 21:44:35 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com,
        mst@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        yu.c.zhang@intel.com, alazar@bitdefender.com
Subject: Re: [PATCH RESEND v4 7/9] KVM: VMX: Handle SPP induced vmexit and
 page fault
Message-ID: <20190820134435.GE4828@local-michael-cet-test.sh.intel.com>
References: <20190814070403.6588-1-weijiang.yang@intel.com>
 <20190814070403.6588-8-weijiang.yang@intel.com>
 <5f6ba406-17c4-a552-2352-2ff50569aac0@redhat.com>
 <fb6cd8b4-eee9-6e58-4047-550811bffd58@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb6cd8b4-eee9-6e58-4047-550811bffd58@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 19, 2019 at 05:04:23PM +0200, Paolo Bonzini wrote:
> On 19/08/19 16:43, Paolo Bonzini wrote:
> >> +			/*
> >> +			 * Record write protect fault caused by
> >> +			 * Sub-page Protection, let VMI decide
> >> +			 * the next step.
> >> +			 */
> >> +			if (spte & PT_SPP_MASK) {
> > Should this be "if (spte & PT_WRITABLE_MASK)" instead?  That is, if the
> > page is already writable, the fault must be an SPP fault.
> 
> Hmm, no I forgot how SPP works; still, this is *not* correct.  For
> example, if SPP marks part of a page as read-write, but KVM wants to
> write-protect the whole page for access or dirty tracking, that should
> not cause an SPP exit.
> 
> So I think that when KVM wants to write-protect the whole page
> (wrprot_ad_disabled_spte) it must also clear PT_SPP_MASK; for example it
> could save it in bit 53 (PT64_SECOND_AVAIL_BITS_SHIFT + 1).  If the
> saved bit is set, fast_page_fault must then set PT_SPP_MASK instead of
> PT_WRITABLE_MASK.
Sure, will change the processing flow.

> On re-entry this will cause an SPP vmexit;
> fast_page_fault should never trigger an SPP userspace exit on its own,
> all the SPP handling should go through handle_spp.
> 
> Paolo
