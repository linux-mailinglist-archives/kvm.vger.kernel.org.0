Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2457204EB1
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 12:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732271AbgFWKB1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 06:01:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20732 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732056AbgFWKB0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 06:01:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592906485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IQEOlaY8lxWBLhrq3UdUAQbRpH9mXTgZnwUd3lDN5GM=;
        b=DL2Ro76oByhd4hbudVqp72gyHK0ATINEnbr4w3zCl0b2Nl7JX/J+nPAZwJXwwcDzvuU85L
        0XDqRR9vZGN6dwHEYOpS0ZWaX4x5vjZwkej+3EkLB8KtGQUNec6Jf3H7EdO6CCMNkwL0mu
        5LIzdhfCj4CutolLeEFk74GUUm+mZ4U=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-88-Lhecx49UMrCX-LY6Vqqp2Q-1; Tue, 23 Jun 2020 06:01:24 -0400
X-MC-Unique: Lhecx49UMrCX-LY6Vqqp2Q-1
Received: by mail-wm1-f72.google.com with SMTP id h25so2008964wmb.0
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 03:01:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IQEOlaY8lxWBLhrq3UdUAQbRpH9mXTgZnwUd3lDN5GM=;
        b=JWqjjPq3r2icWGvuPVvUmo/w8nFCQe+fkRPxzJ+vaKJEkwdc2kyqGi1De1+TXfU+j0
         pWG0+lTStVtBj1qGKz5cr3R7b4Yb+BUEmRBFDOoUfpp0wo2QE2mMm1NCDSQeGUHx+jmS
         zviOJSggxvTX5dV9zBUaFF7ZP19Agq1A6iJNarShvG7piBeY3INC4PVdYneGc7zDLPCs
         O9QdPDcVcbOr+TW97acYyqZ+A6uRebH9sWuWL89nLxRtl8oyEbAxg1jTQlWMHTSt2zhR
         +hNXSQ0jFPkjq9bgUcs7z2VOWFb5hR72h0ChxDfe8RnLVp32hmfDlqoI1LtvbY2zHnoq
         5unw==
X-Gm-Message-State: AOAM533/+62ruLx2H71+bptAM0g+xQ9yb3LgWXEfqPXpIxKr4cMpKSUm
        inbaHEstOV7pDOP33L62sE/snqihs68K3sdHtiUctHyydcR4YV59qtVi+k7IzrbU9yUR3q0YKs5
        pKM06p22g5l8h
X-Received: by 2002:a1c:7fd7:: with SMTP id a206mr15910104wmd.104.1592906482794;
        Tue, 23 Jun 2020 03:01:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyfjQfcrfEvAiyMmTmFbpV5259IlrHhUHT8iGhKenG96MPP3HDlHdZJMiu3eN2Qsh/PdP0hPQ==
X-Received: by 2002:a1c:7fd7:: with SMTP id a206mr15910080wmd.104.1592906482548;
        Tue, 23 Jun 2020 03:01:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:24f5:23b:4085:b879? ([2001:b07:6468:f312:24f5:23b:4085:b879])
        by smtp.gmail.com with ESMTPSA id z16sm12335961wrr.35.2020.06.23.03.01.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2020 03:01:21 -0700 (PDT)
Subject: Re: [PATCH] KVM: VMX: Remove vcpu_vmx's defunct copy of host_pkru
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200617034123.25647-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <49c2b03c-900b-864f-2eae-770068908ad9@redhat.com>
Date:   Tue, 23 Jun 2020 12:01:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200617034123.25647-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/06/20 05:41, Sean Christopherson wrote:
> Remove vcpu_vmx.host_pkru, which got left behind when PKRU support was
> moved to common x86 code.
> 
> No functional change intended.
> 
> Fixes: 37486135d3a7b ("KVM: x86: Fix pkru save/restore when guest CR4.PKE=0, move it to x86.c")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.h | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 8a83b5edc820..639798e4a6ca 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -288,8 +288,6 @@ struct vcpu_vmx {
>  
>  	u64 current_tsc_ratio;
>  
> -	u32 host_pkru;
> -
>  	unsigned long host_debugctlmsr;
>  
>  	/*
> 

Queued, thanks.

Paolo

