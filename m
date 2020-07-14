Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1CD21EFE8
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 14:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbgGNMAT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 08:00:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27192 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727772AbgGNMAR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 08:00:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594728015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2X7NACrHk+056/NrhRPs2QrhtNqs/Hn1NwOQ/IQB6FE=;
        b=RdcQA3255ljwIW97urQzH1nD5X99z/V+zEt0AVc9kxjsN9wUY2FdPuUN9SUsicO72sAiwG
        rr62A2YA1As6eXV6X/q+/ZjplEFZSGXJIF/lrUXHNI7urxVxoSJEWmnZPTJz+uCLvxXlOq
        0Qw9TOHyXox5iJcvtVCHSUpbLaXK+D4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-136-tmTQiCn6O26pa-G25L7AxQ-1; Tue, 14 Jul 2020 08:00:08 -0400
X-MC-Unique: tmTQiCn6O26pa-G25L7AxQ-1
Received: by mail-wr1-f69.google.com with SMTP id 89so21375236wrr.15
        for <kvm@vger.kernel.org>; Tue, 14 Jul 2020 05:00:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=2X7NACrHk+056/NrhRPs2QrhtNqs/Hn1NwOQ/IQB6FE=;
        b=jDOwYUjuj6eVxjZsW0oJEf2/pQqzurhN5jMYlZlCdZDRyWBdFTmx1pCNoGRsvbYUi4
         GFyKbPjMLGhvE4QpClo5LfwgrgbeV5dR2lgsew2CixHHZJfXsREMbCU3rE97PQdSf2sv
         ysPwrUXY6UlH5uk84nFzNgrV/hZMkeFsvYahgs6PS2M3VSBV44KNquI+UWATvG90fsSS
         DL79WBh1HLiLMTkHlq3eONOElQzAFDNuVNgtCJV2ESxpPMKiK3OUEDfr0Uheb5TlxPFA
         VGiXsjJTClFrpjBwzF83SHicQmY/oA4wLb6Ujgvt4Ib6731JUaV9E3/VAhiMSUW70xOz
         hhHA==
X-Gm-Message-State: AOAM5336bdHhluydIKTFnVBWdXhulG5iCoRMqwD9lRS9P/p1MXJcz6iI
        qrlIl7tB590+AA81xpwZoAXn2s7hXWeXGxVH3sW3HmP6rvc+6HTOa1erA9yIP+7Qx7/1GSY6S+c
        Yz8qx2TTlXgl5
X-Received: by 2002:a5d:6802:: with SMTP id w2mr4709004wru.88.1594728007119;
        Tue, 14 Jul 2020 05:00:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxfXD4PNiff8ppZAUdbaWET9RDCKzKfXPAFlhAMhdZ+fkuToo31w86c+WObTDjaxPLdR4o6oA==
X-Received: by 2002:a5d:6802:: with SMTP id w2mr4708961wru.88.1594728006852;
        Tue, 14 Jul 2020 05:00:06 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id z8sm4158901wmg.39.2020.07.14.05.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 05:00:05 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86: Don't attempt to load PDPTRs when 64-bit mode is enabled
In-Reply-To: <20200714015732.32426-1-sean.j.christopherson@intel.com>
References: <20200714015732.32426-1-sean.j.christopherson@intel.com>
Date:   Tue, 14 Jul 2020 14:00:04 +0200
Message-ID: <87wo36s3wb.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

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

it seems we have more than one occurance of "if (vcpu->arch.efer &
EFER_LME)" under "#ifdef CONFIG_X86_64" and we alredy have 

static inline int is_long_mode(struct kvm_vcpu *vcpu)
{
#ifdef CONFIG_X86_64
     return vcpu->arch.efer & EFER_LMA;
#else
     return 0;
#endif
}

so if we use this instead, the compilers will just throw away the
non-reachable blocks when !(#ifdef CONFIG_X86_64), right?

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

-- 
Vitaly

