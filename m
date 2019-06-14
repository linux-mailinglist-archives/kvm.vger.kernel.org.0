Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0343C463A6
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 18:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbfFNQKz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 12:10:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:48053 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbfFNQKz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 12:10:55 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jun 2019 09:10:54 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga008.jf.intel.com with ESMTP; 14 Jun 2019 09:10:54 -0700
Date:   Fri, 14 Jun 2019 09:10:54 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com
Subject: Re: [PATCH 12/43] KVM: nVMX: Add helpers to identify shadowed VMCS
 fields
Message-ID: <20190614161054.GE12191@linux.intel.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
 <1560445409-17363-13-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560445409-17363-13-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 13, 2019 at 07:02:58PM +0200, Paolo Bonzini wrote:
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index fc2b8f4cf45f..a6fe6cfe96f6 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4503,41 +4526,27 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
>  	vmcs12_write_any(vmcs12, field, offset, field_value);
>  
>  	/*
> -	 * Do not track vmcs12 dirty-state if in guest-mode
> -	 * as we actually dirty shadow vmcs12 instead of vmcs12.
> +	 * Do not track vmcs12 dirty-state if in guest-mode as we actually
> +	 * dirty shadow vmcs12 instead of vmcs12.  Fields that can be updated
> +	 * by L1 without a vmexit are always updated in the vmcs02, i.e' don't

Minor typo (from my original patch), should be "i.e.", not "i.e'".

> +	 * "dirty" vmcs12, all others go down the prepare_vmcs02() slow path.
>  	 */
> -	if (!is_guest_mode(vcpu)) {
> -		switch (field) {
