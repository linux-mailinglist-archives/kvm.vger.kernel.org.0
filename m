Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1C59167F54
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 14:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbgBUNyr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 08:54:47 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60870 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727137AbgBUNyr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 08:54:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582293286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LrJP8CFwR0eYb5yjnCrrgpHe2D62qRQVD0aKyEgzsF4=;
        b=IDWBbSHT9bfpOlJ3Dwx8lUDbT1ZqPdJSoyYJPXZ3c+p1k11qzn6Thqn1nKt7gpWLLEteqe
        +WQdVO06ZZq4iHv/Cj9BhVy+L6X3AmjczBbU+2h4tluctJqiw8Wgu7fhxXC4UqjjJi0Gzm
        6SpXoJ7oI8+qFgxXMnUWHyBv8JL+N3I=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-c4LRBgOsPEat-sJQT9xVPw-1; Fri, 21 Feb 2020 08:54:45 -0500
X-MC-Unique: c4LRBgOsPEat-sJQT9xVPw-1
Received: by mail-wm1-f71.google.com with SMTP id t17so635813wmi.7
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 05:54:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=LrJP8CFwR0eYb5yjnCrrgpHe2D62qRQVD0aKyEgzsF4=;
        b=N3cS2NMt+jhIueaYVNHUZ5/PiL/rfwLmW/1gEry/O5SW+NCIIdO4GIM2V+6CvW4PJe
         HeT1djqPwj1T2pJeuBSHCGkEvdM6nynsVsJ6OVuc/LzIWVwn2szfKiB7BEqoBUOnIVGA
         sCU+KMQj9QtIFIf8hq8HOADqmVZnVtovL9/eEM+sWBOpRxnJutqMR/6S2+c8Edl6VMG7
         qIzn9Ws7G7THO0ya94Sit6LyCtdqpDYzk/FeLAy8tTin49c8cCo5/Gucew1mbl8pKnOK
         a1Xg57QwgjrFguWNYXbv0l0EE1ZEDeV2ze8dMSeaJIj+b/QhwJUvdf2az/2COjCr63A7
         9DxA==
X-Gm-Message-State: APjAAAXlo0cOKq2lC78Ytu9UuT19op25IpKkPUFLPjIdebhi9a0b5Ar/
        +NnlgtSgb4zfAGWegiZeBrthXUnWXm0+8DDPEDD38ufnT7x1Pwqlfz2SQZYkrY/FHQZNFk4PHzV
        Ycfw1C4PUc7EH
X-Received: by 2002:adf:e2c5:: with SMTP id d5mr48466797wrj.165.1582293283944;
        Fri, 21 Feb 2020 05:54:43 -0800 (PST)
X-Google-Smtp-Source: APXvYqypCQVdasfRnNXDTX4aGD7CTCMhAe0gR/KZ7ldH3C0p7fXCOZpqLU+JnrR0QV2HrEDGeiAu/Q==
X-Received: by 2002:adf:e2c5:: with SMTP id d5mr48466777wrj.165.1582293283691;
        Fri, 21 Feb 2020 05:54:43 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id i204sm3897111wma.44.2020.02.21.05.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 05:54:43 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/10] KVM: VMX: Clean up vmx_flush_tlb_gva()
In-Reply-To: <20200220204356.8837-8-sean.j.christopherson@intel.com>
References: <20200220204356.8837-1-sean.j.christopherson@intel.com> <20200220204356.8837-8-sean.j.christopherson@intel.com>
Date:   Fri, 21 Feb 2020 14:54:42 +0100
Message-ID: <87r1yorqot.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Refactor vmx_flush_tlb_gva() to remove a superfluous local variable and
> clean up its comment, which is oddly located below the code it is
> commenting.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 5372a93e1727..906e9d9aa09e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2824,15 +2824,11 @@ static void exit_lmode(struct kvm_vcpu *vcpu)
>  
>  static void vmx_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
>  {
> -	int vpid = to_vmx(vcpu)->vpid;
> -
> -	vpid_sync_vcpu_addr(vpid, addr);
> -
>  	/*
> -	 * If VPIDs are not supported or enabled, then the above is a no-op.
> -	 * But we don't really need a TLB flush in that case anyway, because
> -	 * each VM entry/exit includes an implicit flush when VPID is 0.
> +	 * vpid_sync_vcpu_addr() is a nop if vmx->vpid==0, see the comment in
> +	 * vmx_flush_tlb_guest() for an explanation of why this is ok.

"OK" :-)

>  	 */
> +	vpid_sync_vcpu_addr(to_vmx(vcpu)->vpid, addr);
>  }
>  
>  static void vmx_flush_tlb_guest(struct kvm_vcpu *vcpu)

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

