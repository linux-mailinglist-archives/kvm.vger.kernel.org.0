Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B04310553C
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 16:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfKUPUS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 10:20:18 -0500
Received: from mga04.intel.com ([192.55.52.120]:35756 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726774AbfKUPUS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Nov 2019 10:20:18 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Nov 2019 07:20:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,226,1571727600"; 
   d="scan'208";a="201151528"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by orsmga008.jf.intel.com with ESMTP; 21 Nov 2019 07:20:15 -0800
Date:   Thu, 21 Nov 2019 23:22:12 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmattson@google.com,
        sean.j.christopherson@intel.com, yu.c.zhang@linux.intel.com,
        alazar@bitdefender.com, edwin.zhai@intel.com
Subject: Re: [PATCH v7 6/9] vmx: spp: Set up SPP paging table at
 vmentry/vmexit
Message-ID: <20191121152212.GG17169@local-michael-cet-test>
References: <20191119084949.15471-1-weijiang.yang@intel.com>
 <20191119084949.15471-7-weijiang.yang@intel.com>
 <a7ce232b-0a54-0039-7009-8e92e8078791@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7ce232b-0a54-0039-7009-8e92e8078791@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 21, 2019 at 11:18:48AM +0100, Paolo Bonzini wrote:
> On 19/11/19 09:49, Yang Weijiang wrote:
> > +			if (spte & PT_SPP_MASK) {
> > +				fault_handled = true;
> > +				vcpu->run->exit_reason = KVM_EXIT_SPP;
> > +				vcpu->run->spp.addr = gva;
> > +				kvm_skip_emulated_instruction(vcpu);
> 
> Do you really want to skip the current instruction?  Who will do the write?
>
If the destination memory is SPP protected, the target memory is
expected unchanged on a "write op" in guest, so would like to skip current 
instruction.

> > +		pr_info("SPP - SPPT entry missing! gfn = 0x%llx\n", gfn);
> 
> Please replace pr_info with a tracepoint.
> 
OK.

> > +		slot = gfn_to_memslot(vcpu->kvm, gfn);
> > +		if (!slot)
> > +			return -EFAULT;
> 
> You want either a goto to the misconfig case, so that there is a warn
>
OK.
> > +		spp_info.base_gfn = gfn;
> > +		spp_info.npages = 1;
> > +
> > +		spin_lock(&vcpu->kvm->mmu_lock);
> > +		ret = kvm_spp_get_permission(vcpu->kvm, &spp_info);
> > +		if (ret == 1) {
> 
> Can you clarify when ret will not be 1?  In this case you already have a
> slot, so it seems to me that you do not need to go through
> kvm_spp_get_permission and you can just test "if
> (kvm->arch.spp_active)".  But then, spp_active should be 1 if you get
> here, I think?
> 
Hmm, getting permission bits from gfn directly should work here. 
Thank you!

> > +	pr_alert("SPP - SPPT Misconfiguration!\n");
> > +	return 0;
> 
> 
> pr_alert not needed since you've just warned.
>
OK, will remove it.

> Paolo
