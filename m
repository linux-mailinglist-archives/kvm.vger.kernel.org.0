Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98C8023C683
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 09:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbgHEHFJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 03:05:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36985 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728394AbgHEHEp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 03:04:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596611081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OllU2AtLxALI933xrusVDqtVc7Jp0X73cxjCgcSpPPs=;
        b=NEE4+B+uEWOzaqcFoJYtM9Vmuw0U/3GzD5CuREmUEtqYWDK6ANNvAxbSxWiE9hkk9w+2J3
        TsSd01HEalKVQxDiqhFTgLEP+S4SXnO4mdsdeZXTVPssNrw89I+KMORiS5VgX41PFXPy/q
        LU++aMz5IVjWVzNV5asC29QGM59KnDQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-zYa7F1cJNfOsJ3ezn09pKw-1; Wed, 05 Aug 2020 03:04:33 -0400
X-MC-Unique: zYa7F1cJNfOsJ3ezn09pKw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD99D101C8A9;
        Wed,  5 Aug 2020 07:04:30 +0000 (UTC)
Received: from starship (unknown [10.35.206.144])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E26571D35;
        Wed,  5 Aug 2020 07:04:27 +0000 (UTC)
Message-ID: <084a332afc149c0c647e86f71fea49bb0665a843.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86: Don't attempt to load PDPTRs when 64-bit mode
 is enabled
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Wed, 05 Aug 2020 10:04:26 +0300
In-Reply-To: <20200714015732.32426-1-sean.j.christopherson@intel.com>
References: <20200714015732.32426-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2020-07-13 at 18:57 -0700, Sean Christopherson wrote:
> Don't attempt to load PDPTRs if EFER.LME=1, i.e. if 64-bit mode is
> enabled.  A recent change to reload the PDTPRs when CR0.CD or CR0.NW is
> toggled botched the EFER.LME handling and sends KVM down the PDTPR path
> when is_paging() is true, i.e. when the guest toggles CD/NW in 64-bit
> mode.
> 
> Split the CR0 checks for 64-bit vs. 32-bit PAE into separate paths.  The
> 64-bit path is specifically checking state when paging is toggled on,
> i.e. CR0.PG transititions from 0->1.  The PDPTR path now needs to run if
> the new CR0 state has paging enabled, irrespective of whether paging was
> already enabled.  Trying to shave a few cycles to make the PDPTR path an
> "else if" case is a mess.
> 
> Fixes: d42e3fae6faed ("kvm: x86: Read PDPTEs on CR0.CD and CR0.NW changes")
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Oliver Upton <oupton@google.com>
> Cc: Peter Shier <pshier@google.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
> 
> The other way to fix this, with a much smaller diff stat, is to simply
> move the !is_page(vcpu) check inside (vcpu->arch.efer & EFER_LME).  But
> that results in a ridiculous amount of nested conditionals for what is a
> very straightforward check e.g.
> 
> 	if (cr0 & X86_CR0_PG) {
> 		if (vcpu->arch.efer & EFER_LME) }
> 			if (!is_paging(vcpu)) {
> 				...
> 			}
> 		}
> 	}
> 
> Since this doesn't need to be backported anywhere, I didn't see any value
> in having an intermediate step.
> 
>  arch/x86/kvm/x86.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 95ef629228691..5f526d94c33f3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -819,22 +819,22 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>  	if ((cr0 & X86_CR0_PG) && !(cr0 & X86_CR0_PE))
>  		return 1;
>  
> -	if (cr0 & X86_CR0_PG) {
>  #ifdef CONFIG_X86_64
> -		if (!is_paging(vcpu) && (vcpu->arch.efer & EFER_LME)) {
> -			int cs_db, cs_l;
> +	if ((vcpu->arch.efer & EFER_LME) && !is_paging(vcpu) &&
> +	    (cr0 & X86_CR0_PG)) {
> +		int cs_db, cs_l;
>  
> -			if (!is_pae(vcpu))
> -				return 1;
> -			kvm_x86_ops.get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
> -			if (cs_l)
> -				return 1;
> -		} else
> -#endif
> -		if (is_pae(vcpu) && ((cr0 ^ old_cr0) & pdptr_bits) &&
> -		    !load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu)))
> +		if (!is_pae(vcpu))
> +			return 1;
> +		kvm_x86_ops.get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
> +		if (cs_l)
>  			return 1;
>  	}
> +#endif
> +	if (!(vcpu->arch.efer & EFER_LME) && (cr0 & X86_CR0_PG) &&
> +	    is_pae(vcpu) && ((cr0 ^ old_cr0) & pdptr_bits) &&
> +	    !load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu)))
> +		return 1;
>  
>  	if (!(cr0 & X86_CR0_PG) && kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE))
>  		return 1;

I also investigated this issue (also same thing, OVMF doesn't boot),
and after looking at the intel and amd's PRM, this looks like correct solution.
I also tested this and it works.


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

