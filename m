Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59AED1F5B08
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 20:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbgFJSOy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 14:14:54 -0400
Received: from mga18.intel.com ([134.134.136.126]:41611 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728505AbgFJSOy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 14:14:54 -0400
IronPort-SDR: e0RDWAiLHQLZ+2cCmEc18+3tUdLt5cE+1ZHa86ZjJRq3oBVPGf5ObY4AX9LSCKsIQ+uqV6oUP9
 78+ly9UBKb5g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2020 11:14:53 -0700
IronPort-SDR: VYx3YZq2AsV1y/w9LJ0lJC4l9tlcDIzPcl7g0qx2ku0MqCPCbFKCfOmOtR4i0o94fG2ZmM5CSK
 cJFuaNhkdocA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,496,1583222400"; 
   d="scan'208";a="447620613"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga005.jf.intel.com with ESMTP; 10 Jun 2020 11:14:53 -0700
Date:   Wed, 10 Jun 2020 11:14:53 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: async_pf: Cleanup kvm_setup_async_pf()
Message-ID: <20200610181453.GC18790@linux.intel.com>
References: <20200610175532.779793-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610175532.779793-1-vkuznets@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 10, 2020 at 07:55:31PM +0200, Vitaly Kuznetsov wrote:
> schedule_work() returns 'false' only when the work is already on the queue
> and this can't happen as kvm_setup_async_pf() always allocates a new one.
> Also, to avoid potential race, it makes sense to to schedule_work() at the
> very end after we've added it to the queue.
> 
> While on it, do some minor cleanup. gfn_to_pfn_async() mentioned in a
> comment does not currently exist and, moreover, we can check
> kvm_is_error_hva() at the very beginning, before we try to allocate work so
> 'retry_sync' label can go away completely.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  virt/kvm/async_pf.c | 19 ++++++-------------
>  1 file changed, 6 insertions(+), 13 deletions(-)
> 
> diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
> index f1e07fae84e9..ba080088da76 100644
> --- a/virt/kvm/async_pf.c
> +++ b/virt/kvm/async_pf.c
> @@ -164,7 +164,9 @@ int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  	if (vcpu->async_pf.queued >= ASYNC_PF_PER_VCPU)
>  		return 0;
>  
> -	/* setup delayed work */
> +	/* Arch specific code should not do async PF in this case */
> +	if (unlikely(kvm_is_error_hva(hva)))

This feels like it should be changed to a WARN_ON_ONCE in a follow-up.
With the WARN, the comment could probably be dropped.

I'd also be in favor of changing the return type to a boolean.  I think
you alluded to it earlier, the current semantics are quite confusing as they
invert the normal "return 0 on success".

For this patch:

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
