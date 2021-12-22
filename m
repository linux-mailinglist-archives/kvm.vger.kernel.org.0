Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53E3D47CCB9
	for <lists+kvm@lfdr.de>; Wed, 22 Dec 2021 06:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242616AbhLVF4r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Dec 2021 00:56:47 -0500
Received: from mga01.intel.com ([192.55.52.88]:12332 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232036AbhLVF4q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Dec 2021 00:56:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640152606; x=1671688606;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DZBYbfDa1A+p7NnbPw2TybX+HHeuJXqrqke5gZFTDXE=;
  b=HNdtCHXgPA60J8ht651Shh+h7B3scxUKDz0Espo8gmuHqhn11qk3ecVi
   bKWWMu9aqsixuJa0UzqmA0cD1x6ovj7gWn0HV4PM863IQXxJFAUDTd2la
   t/Sr90Jdsm9JnOjRNQ1oe1iS2R2tduvbg3iU+nvghrzu00xZUQMgYO7ng
   srJ7WEdriRd8Lyu6iWQim2ub3CqWnkWkGUBvIULHf1Xlm+gQj1hHgPBFq
   tGSGfbzJZ2kT+PP9epFhx6naJmUShwAfCLSNA1Dj+q8bw7otrN7Z6uL2R
   NxGbvdWexR2lqUeSqG+jyVBrspXdLM6YH91if1rM5ipproKgTl4/RWhSL
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="264745941"
X-IronPort-AV: E=Sophos;i="5.88,225,1635231600"; 
   d="scan'208";a="264745941"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 21:56:46 -0800
X-IronPort-AV: E=Sophos;i="5.88,225,1635231600"; 
   d="scan'208";a="521545247"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.105])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 21:56:43 -0800
Date:   Wed, 22 Dec 2021 14:07:36 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Huangzhichao <huangzhichao@huawei.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: The vcpu won't be wakened for a long time
Message-ID: <20211222060735.GA22521@gao-cwp>
References: <73d46f3cc46a499c8e39fdf704b2deaf@huawei.com>
 <YbjWFTtNo9Ap7kDp@google.com>
 <9e5aef1ae0c141e49c2b1d19692b9295@huawei.com>
 <Ybtea42RxZ9aVzCh@google.com>
 <8a1a3ac75a6e4acf9bd1ce9779835e1c@huawei.com>
 <YcHyReHoF+qjIVTy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YcHyReHoF+qjIVTy@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 21, 2021 at 03:27:01PM +0000, Sean Christopherson wrote:
>On Sat, Dec 18, 2021, Longpeng (Mike, Cloud Infrastructure Service Product Dept.) wrote:
>> > Hmm, that strongly suggests the "vcpu != kvm_get_running_vcpu()" is at fault.
>> > Can you try running with the below commit?  It's currently sitting in kvm/queue,
>> > but not marked for stable because I didn't think it was possible for the check
>> > to a cause a missed wake event in KVM's current code base.
>> > 
>> 
>> The below commit can fix the bug, we have just completed  the tests.
>> Thanks.
>
>Aha!  Somehow I missed this call chain when analyzing the change.
>
>  irqfd_wakeup()
>  |
>  |->kvm_arch_set_irq_inatomic()
>     |
>     |-> kvm_irq_delivery_to_apic_fast()
>         |
>	 |-> kvm_apic_set_irq()
>
>
>Paolo, can the changelog be amended to the below, and maybe even pull the commit
>into 5.16?
>
>
>KVM: VMX: Wake vCPU when delivering posted IRQ even if vCPU == this vCPU
>
>Drop a check that guards triggering a posted interrupt on the currently
>running vCPU,

Can we move (add) this check to kvm_vcpu_trigger_posted_interrupt()?

	if (vcpu->mode == IN_GUEST_MODE) {
[...]
-		apic->send_IPI_mask(get_cpu_mask(vcpu->cpu), pi_vec);
+		if (vcpu != kvm_get_running_vcpu())
+			apic->send_IPI_mask(get_cpu_mask(vcpu->cpu), pi_vec);
 		return true;

It can achieve the purpose of the original patch without (re-)introducing
this bug.
