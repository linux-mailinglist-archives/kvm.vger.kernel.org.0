Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D90BDE112A
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 06:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732243AbfJWErc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Oct 2019 00:47:32 -0400
Received: from ozlabs.org ([203.11.71.1]:38879 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732196AbfJWErc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Oct 2019 00:47:32 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 46ydCP1cVdz9sNw; Wed, 23 Oct 2019 15:47:29 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1571806049; bh=/YK+vBaEWKaoc23KPP6XQqhJWrglauOV26W4r56w/HM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DQXAbDZhExYmGmQ+aSXSqHxbSR0ySdVk7+XZLGC5+YHJCQvdTsy0hr/qpkSKkPLOd
         i/n1chZT15n3KBJlPD27zBJnxmNf9BJBbw3xWXJ9soPhIEm4kS+Fd00CZ6ask6uDN3
         7N9tHLKZ6QFdxeq6yGxM1R97POhkqomua5eBWJO6W2Q84XIP+Tj5BzV7e4P6mezgHZ
         0DcJB8b+kviL6aGcJmLgWpnNOQcszZgJdKfscArPIiBZYa+T7WpYLTOV8JvXkKasi0
         V/clZVJqOUwhovggT2OyIGEOUa2cRHB0hLHcfZbA9P1nIYglKaimUdG6yO9MRXk54e
         kML/GQXIxbWGg==
Date:   Wed, 23 Oct 2019 15:47:24 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Cc:     kvm-ppc@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 03/23] KVM: PPC: Book3S HV: Nested: Don't allow hash
 guests to run nested guests
Message-ID: <20191023044724.GA29241@oak.ozlabs.ibm.com>
References: <20190826062109.7573-1-sjitindarsingh@gmail.com>
 <20190826062109.7573-4-sjitindarsingh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826062109.7573-4-sjitindarsingh@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 26, 2019 at 04:20:49PM +1000, Suraj Jitindar Singh wrote:
> Don't allow hpt (hash page table) guests to act as guest hypervisors and
> thus be able to run nested guests. There is currently no support for
> this, if a nested guest is to be run it must be run at the lowest level.
> Explicitly disallow hash guests from enabling the nested kvm-hv capability
> at the hypervisor level.
> 
> Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
> ---
>  arch/powerpc/kvm/book3s_hv.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index cde3f5a4b3e4..ce960301bfaa 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -5336,8 +5336,12 @@ static int kvmhv_enable_nested(struct kvm *kvm)
>  		return -ENODEV;
>  
>  	/* kvm == NULL means the caller is testing if the capability exists */
> -	if (kvm)
> +	if (kvm) {
> +		/* Only radix guests can act as nested hv and thus run guests */
> +		if (!kvm_is_radix(kvm))
> +			return -1;
>  		kvm->arch.nested_enable = true;
> +	}

I don't think this is necessary, and is possibly undesirable, since a
guest can switch between HPT and radix mode.  In fact if a guest in
HPT mode tries to do any of the hcalls for managing nested guests, it
will get errors, because we have this:

static inline bool nesting_enabled(struct kvm *kvm)
{
	return kvm->arch.nested_enable && kvm_is_radix(kvm);
}

and H_SET_PARTITION_TABLE, H_ENTER_NESTED, etc. all return H_FUNCTION
if nested_enabled() is false.  (This is as the code is today without
your patch).  Furthermore, kvmppc_switch_mmu_to_hpt() does this:

	if (nesting_enabled(kvm))
		kvmhv_release_all_nested(kvm);

So I think it is all covered already without your patch.

Paul.
