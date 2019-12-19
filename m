Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67594126642
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2019 16:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfLSP5r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Dec 2019 10:57:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:9584 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726855AbfLSP5q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Dec 2019 10:57:46 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Dec 2019 07:57:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,332,1571727600"; 
   d="scan'208";a="228286793"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 19 Dec 2019 07:57:46 -0800
Date:   Thu, 19 Dec 2019 07:57:46 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org
Subject: Re: Async page fault delivered while irq are disabled?
Message-ID: <20191219155745.GA6439@linux.intel.com>
References: <20191219152814.GA24080@lenoir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219152814.GA24080@lenoir>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 19, 2019 at 04:28:15PM +0100, Frederic Weisbecker wrote:
> Hi,
> 
> While checking the x86 async page fault code, I can't
> find anything that prevents KVM_PV_REASON_PAGE_READY to be injected
> while the guest has interrupts disabled. If that page fault happens
> to trap in an interrupt disabled section, there may be a deadlock due to the
> call to wake_up_process() which locks the rq->lock (among others).
> 
> Given how long that code is there, I guess such an issue would
> have been reported for a while already. But I just would like to
> be sure we are checking that.
> 
> Can someone enlighten me?

The check is triggered from the caller of kvm_async_page_present().

kvm_check_async_pf_completion()
|
|-> kvm_arch_can_inject_async_page_present()
    |
    |-> kvm_can_do_async_pf()
        |
        |-> kvm_x86_ops->interrupt_allowed()
