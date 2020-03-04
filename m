Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA48B178B8F
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 08:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728530AbgCDHmF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 02:42:05 -0500
Received: from mga12.intel.com ([192.55.52.136]:2134 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728301AbgCDHmF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 02:42:05 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 23:42:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,513,1574150400"; 
   d="scan'208";a="440914043"
Received: from liujing-mobl1.ccr.corp.intel.com (HELO [10.249.174.187]) ([10.249.174.187])
  by fmsmga006.fm.intel.com with ESMTP; 03 Mar 2020 23:41:59 -0800
Subject: Re: [PATCH 3/4] KVM: x86: Revert "KVM: X86: Fix fpu state crash in
 kvm guest"
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Derek Yerger <derek@djy.llc>,
        kernel@najdan.com, Thomas Lambertz <mail@thomaslambertz.de>,
        Rik van Riel <riel@surriel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20200117062628.6233-1-sean.j.christopherson@intel.com>
 <20200117062628.6233-4-sean.j.christopherson@intel.com>
From:   "Liu, Jing2" <jing2.liu@linux.intel.com>
Message-ID: <ca47fce8-a042-f967-513c-93cabac2122d@linux.intel.com>
Date:   Wed, 4 Mar 2020 15:41:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200117062628.6233-4-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/17/2020 2:26 PM, Sean Christopherson wrote:
> @@ -8198,8 +8194,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>   	trace_kvm_entry(vcpu->vcpu_id);
>   	guest_enter_irqoff();
>   
> -	/* The preempt notifier should have taken care of the FPU already.  */
> -	WARN_ON_ONCE(test_thread_flag(TIF_NEED_FPU_LOAD));
> +	fpregs_assert_state_consistent();
> +	if (test_thread_flag(TIF_NEED_FPU_LOAD))
> +		switch_fpu_return();
>   
>   	if (unlikely(vcpu->arch.switch_db_regs)) {
>   		set_debugreg(0, 7);

Can kvm be preempt out again after this (before really enter to guest)?

Thanks,

Jing

