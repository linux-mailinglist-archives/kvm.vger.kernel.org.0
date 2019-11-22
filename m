Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4CE31074BF
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 16:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfKVPXN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 10:23:13 -0500
Received: from mga05.intel.com ([192.55.52.43]:20463 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726633AbfKVPXN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 10:23:13 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 07:23:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,230,1571727600"; 
   d="scan'208";a="219496921"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by orsmga002.jf.intel.com with ESMTP; 22 Nov 2019 07:23:10 -0800
Date:   Fri, 22 Nov 2019 23:25:05 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmattson@google.com,
        sean.j.christopherson@intel.com, yu.c.zhang@linux.intel.com,
        alazar@bitdefender.com, edwin.zhai@intel.com
Subject: Re: [PATCH v7 6/9] vmx: spp: Set up SPP paging table at
 vmentry/vmexit
Message-ID: <20191122152505.GB9822@local-michael-cet-test>
References: <20191119084949.15471-1-weijiang.yang@intel.com>
 <20191119084949.15471-7-weijiang.yang@intel.com>
 <a7ce232b-0a54-0039-7009-8e92e8078791@redhat.com>
 <20191121152212.GG17169@local-michael-cet-test>
 <7cdcd2b2-ced8-4c08-82c7-b3a25ed8bb15@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cdcd2b2-ced8-4c08-82c7-b3a25ed8bb15@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 21, 2019 at 05:08:07PM +0100, Paolo Bonzini wrote:
> On 21/11/19 16:22, Yang Weijiang wrote:
> > On Thu, Nov 21, 2019 at 11:18:48AM +0100, Paolo Bonzini wrote:
> >> On 19/11/19 09:49, Yang Weijiang wrote:
> >>> +			if (spte & PT_SPP_MASK) {
> >>> +				fault_handled = true;
> >>> +				vcpu->run->exit_reason = KVM_EXIT_SPP;
> >>> +				vcpu->run->spp.addr = gva;
> >>> +				kvm_skip_emulated_instruction(vcpu);
> >>
> >> Do you really want to skip the current instruction?  Who will do the write?
> >>
> > If the destination memory is SPP protected, the target memory is
> > expected unchanged on a "write op" in guest, so would like to skip current 
> > instruction.
> 
> This is how you are expecting SPP to be used, but another possibility is
> to unprotect and reenter the guest.  In this case
> kvm_skip_emulated_instruction would be wrong (and once this decision is
> made, it would be very, very hard to change it).
> 
> However, you clearly need a way to skip the instruction, and for that
> you could store the current instruction length in vcpu->run->spp.  Then
> userspace can adjust RIP manually if desired.
>
Looks good to me, will add the length, thanks!
> Thanks,
> 
> Paolo
