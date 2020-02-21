Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90064167EE2
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 14:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgBUNnO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 08:43:14 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40919 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727161AbgBUNnN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 08:43:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582292592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jxnMeM03TNX5Hwe3Ya5c3ghPkANO7e19ew4skX/ljXI=;
        b=Tx3jv+sjDZDGcZsnTUxafmFAaumRvEHEmZ3I1NIeQiKmlr7ooNCOWZ79/Yk+JsDNiAMvAM
        gXxIs2Aeh9wYPp2i+2oTrPzjjhL/gSqfVk0TnzBDh4ofgKBbPVJw5+JtFu2B73qZz8bzYp
        cH0CtxzhfOQ8cWiEv7vLwzuT3/jV82o=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-p86oXb9LNWGOTgIa6aorFA-1; Fri, 21 Feb 2020 08:43:11 -0500
X-MC-Unique: p86oXb9LNWGOTgIa6aorFA-1
Received: by mail-wr1-f72.google.com with SMTP id w6so1025888wrm.16
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 05:43:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=jxnMeM03TNX5Hwe3Ya5c3ghPkANO7e19ew4skX/ljXI=;
        b=EQcOhk3FeZYqxdX99T0/22+m+rVftsFcLzXAjOpaFI/gfDLrCFVo4fc+fuykRdgaVZ
         tAl+gZd/84Gc/hqDmoplz3IGu7D6iqo3rFjoa0X9Eh/GixKTeGX4VynnJmIXpGBD6zYa
         nnBML21IByFfSGjjXgNevzJlHrVETKsg3LkXIvCYgYvlhvBGHjqzsrVBsANDGB3vJWQB
         SJfO2qtWzo+EjZOEUI48AmsDIRzKDgyWwrpinQJOYjz8jARUEw77yIG+5mmbJODy0ueM
         L4BAu6YREPhzvvq4XCVL82mNlyJ54ytgkMftakFhwPQ9HpkkizQRayA/dCbrPXYD1oN3
         w3dw==
X-Gm-Message-State: APjAAAUIZSiah7yAtgrRa4KRPdeO4rOouhejoS2Ls6FJaxJt+axTkzv4
        7L4/lC/0vJkcu2jJqLUSqvxq1PxhLjiHJRWyP6l8vysvu0AWRwMDu0gnSIUUiYN3xPcQkQsTLcE
        5EtcsZm3HfqNa
X-Received: by 2002:a5d:62d1:: with SMTP id o17mr50232131wrv.9.1582292589889;
        Fri, 21 Feb 2020 05:43:09 -0800 (PST)
X-Google-Smtp-Source: APXvYqwYjfMp0GXLA0Adtce96YFtLai3dGPE9oQ19+qhhnyjr/+5T/nNg1RRP70iIAwzi8r4Uxbw6w==
X-Received: by 2002:a5d:62d1:: with SMTP id o17mr50232104wrv.9.1582292589636;
        Fri, 21 Feb 2020 05:43:09 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id h18sm4214888wrv.78.2020.02.21.05.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 05:43:09 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/10] KVM: nVMX: Use vpid_sync_vcpu_addr() to emulate INVVPID with address
In-Reply-To: <20200220204356.8837-6-sean.j.christopherson@intel.com>
References: <20200220204356.8837-1-sean.j.christopherson@intel.com> <20200220204356.8837-6-sean.j.christopherson@intel.com>
Date:   Fri, 21 Feb 2020 14:43:08 +0100
Message-ID: <87wo8grr83.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Use vpid_sync_vcpu_addr() to emulate the "individual address" variant of
> INVVPID now that said function handles the fallback case of the (host)
> CPU not supporting "individual address".
>
> Note, the "vpid == 0" checks in the vpid_sync_*() helpers aren't
> actually redundant with the "!operand.vpid" check in handle_invvpid(),
> as the vpid passed to vpid_sync_vcpu_addr() is a KVM (host) controlled
> value, i.e. vpid02 can be zero even if operand.vpid is non-zero.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 19ac4083667f..5a174be314e5 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5150,11 +5150,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
>  		    is_noncanonical_address(operand.gla, vcpu))
>  			return nested_vmx_failValid(vcpu,
>  				VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
> -		if (cpu_has_vmx_invvpid_individual_addr()) {
> -			__invvpid(VMX_VPID_EXTENT_INDIVIDUAL_ADDR,
> -				vpid02, operand.gla);
> -		} else
> -			vpid_sync_context(vpid02);
> +		vpid_sync_vcpu_addr(vpid02, operand.gla);
>  		break;
>  	case VMX_VPID_EXTENT_SINGLE_CONTEXT:
>  	case VMX_VPID_EXTENT_SINGLE_NON_GLOBAL:

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

