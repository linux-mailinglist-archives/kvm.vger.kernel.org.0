Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55C4C367A2F
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 08:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234877AbhDVGvR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 02:51:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29088 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229962AbhDVGvQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 02:51:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619074241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fi/3M6cSDo3xMuL8XkHtN1SthVfdp8w1yaD/R2EQaLA=;
        b=N61ScnmGYIXhqCwZ4BkDIGqOAEyDPaAd+q0jLu+ujm2sPQQht+ZsTxkM9vUUBHEff8evND
        gXOnfJoFOV1HCNKYHF/ULA81I5aQ0rHc8grApva3lx0IhLgg4lo5G2wljx7sIvNKwydlhe
        kuAZbTxO2b5jXd2mC5MQeL+OKqUxhs0=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-Ssmxi-R_OVqF74ct7tr9vA-1; Thu, 22 Apr 2021 02:50:39 -0400
X-MC-Unique: Ssmxi-R_OVqF74ct7tr9vA-1
Received: by mail-ej1-f69.google.com with SMTP id t9-20020a1709069489b02903807ab24426so4291631ejx.2
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 23:50:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fi/3M6cSDo3xMuL8XkHtN1SthVfdp8w1yaD/R2EQaLA=;
        b=Aabqs+eA70jE3O/CX/ql3kXCSz2kQFE4pb2s4hvreujxVfZwuKlOdhu5hC5OoRe95l
         VCnnk0bLgCHuKrIcbXIVe9Ph7p9v340Kr7yRW//aqWuSr82APdM8pvsH01X2AILTK+J+
         XsCMi51ZyVFvatG45aV04hm7O430mnEJsmeMeoWGN5vVH67ERgjmX7seahStZnNAyPa1
         4LriIHqlQMNkTssATpXIBMnB9LjFsSRrZw+pyX09rNpUABHceYuUrVfG8gbqMaO7Mi9b
         Rcdm7JkqFopH8mSiZR6ndE6eN4l6+bgKVr3X1J7/x0AHSYESWCpICuE4dxztl2eJjhKe
         Glsg==
X-Gm-Message-State: AOAM531K+CAU2qe/DAYfCV0tGud0mKq8Cy2HKbhXK48BOKHAUo/WzNN+
        +9SQDN68jrC7DP0s+UOY9VbOTpTxUcdvEiLCzVj2QFhEF2pg36mEvk9evhVfXPYTSpixZm42BcS
        +wle1w/WmHJg7
X-Received: by 2002:a17:906:7206:: with SMTP id m6mr1759459ejk.281.1619074238436;
        Wed, 21 Apr 2021 23:50:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzRXHJPgqoumjrliCze9/fksB6akIOdDB7ZLqjIqj+F5zrQeJO/WTt++PWDJMplDtgXIcssSQ==
X-Received: by 2002:a17:906:7206:: with SMTP id m6mr1759449ejk.281.1619074238280;
        Wed, 21 Apr 2021 23:50:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id ce14sm1197654ejc.19.2021.04.21.23.50.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 23:50:37 -0700 (PDT)
Subject: Re: [PATCH v2 1/9] KVM: x86: Remove emulator's broken checks on
 CR0/CR3/CR4 loads
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Babu Moger <babu.moger@amd.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        David Woodhouse <dwmw@amazon.co.uk>
References: <20210422022128.3464144-1-seanjc@google.com>
 <20210422022128.3464144-2-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <856568f8-bf57-9806-a0f6-e5136a623be4@redhat.com>
Date:   Thu, 22 Apr 2021 08:50:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210422022128.3464144-2-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/04/21 04:21, Sean Christopherson wrote:
> Remove the emulator's checks for illegal CR0, CR3, and CR4 values, as
> the checks are redundant, outdated, and in the case of SEV's C-bit,
> broken.  The emulator manually calculates MAXPHYADDR from CPUID and
> neglects to mask off the C-bit.  For all other checks, kvm_set_cr*() are
> a superset of the emulator checks, e.g. see CR4.LA57.
> 
> Fixes: a780a3ea6282 ("KVM: X86: Fix reserved bits check for MOV to CR3")
> Cc: Babu Moger <babu.moger@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/emulate.c | 68 +-----------------------------------------
>   1 file changed, 1 insertion(+), 67 deletions(-)

This can be (opportunistically ;)) squashed on top:

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index f4273b8e31fa..abd9a4db11a8 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4220,15 +4220,7 @@ static bool valid_cr(int nr)
  	}
  }
  
-static int check_cr_read(struct x86_emulate_ctxt *ctxt)
-{
-	if (!valid_cr(ctxt->modrm_reg))
-		return emulate_ud(ctxt);
-
-	return X86EMUL_CONTINUE;
-}
-
-static int check_cr_write(struct x86_emulate_ctxt *ctxt)
+static int check_cr_access(struct x86_emulate_ctxt *ctxt)
  {
  	if (!valid_cr(ctxt->modrm_reg))
  		return emulate_ud(ctxt);
@@ -4775,10 +4767,10 @@ static const struct opcode twobyte_table[256] = {
  	D(ImplicitOps | ModRM | SrcMem | NoAccess), /* 8 * reserved NOP */
  	D(ImplicitOps | ModRM | SrcMem | NoAccess), /* NOP + 7 * reserved NOP */
  	/* 0x20 - 0x2F */
-	DIP(ModRM | DstMem | Priv | Op3264 | NoMod, cr_read, check_cr_read),
+	DIP(ModRM | DstMem | Priv | Op3264 | NoMod, cr_read, check_cr_access),
  	DIP(ModRM | DstMem | Priv | Op3264 | NoMod, dr_read, check_dr_read),
  	IIP(ModRM | SrcMem | Priv | Op3264 | NoMod, em_cr_write, cr_write,
-						check_cr_write),
+						check_cr_access),
  	IIP(ModRM | SrcMem | Priv | Op3264 | NoMod, em_dr_write, dr_write,
  						check_dr_write),
  	N, N, N, N,


> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index f7970ba6219f..f4273b8e31fa 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -4230,75 +4230,9 @@ static int check_cr_read(struct x86_emulate_ctxt *ctxt)
>   
>   static int check_cr_write(struct x86_emulate_ctxt *ctxt)
>   {
> -	u64 new_val = ctxt->src.val64;
> -	int cr = ctxt->modrm_reg;
> -	u64 efer = 0;
> -
> -	static u64 cr_reserved_bits[] = {
> -		0xffffffff00000000ULL,
> -		0, 0, 0, /* CR3 checked later */
> -		CR4_RESERVED_BITS,
> -		0, 0, 0,
> -		CR8_RESERVED_BITS,
> -	};
> -
> -	if (!valid_cr(cr))
> +	if (!valid_cr(ctxt->modrm_reg))
>   		return emulate_ud(ctxt);
>   
> -	if (new_val & cr_reserved_bits[cr])
> -		return emulate_gp(ctxt, 0);
> -
> -	switch (cr) {
> -	case 0: {
> -		u64 cr4;
> -		if (((new_val & X86_CR0_PG) && !(new_val & X86_CR0_PE)) ||
> -		    ((new_val & X86_CR0_NW) && !(new_val & X86_CR0_CD)))
> -			return emulate_gp(ctxt, 0);
> -
> -		cr4 = ctxt->ops->get_cr(ctxt, 4);
> -		ctxt->ops->get_msr(ctxt, MSR_EFER, &efer);
> -
> -		if ((new_val & X86_CR0_PG) && (efer & EFER_LME) &&
> -		    !(cr4 & X86_CR4_PAE))
> -			return emulate_gp(ctxt, 0);
> -
> -		break;
> -		}
> -	case 3: {
> -		u64 rsvd = 0;
> -
> -		ctxt->ops->get_msr(ctxt, MSR_EFER, &efer);
> -		if (efer & EFER_LMA) {
> -			u64 maxphyaddr;
> -			u32 eax, ebx, ecx, edx;
> -
> -			eax = 0x80000008;
> -			ecx = 0;
> -			if (ctxt->ops->get_cpuid(ctxt, &eax, &ebx, &ecx,
> -						 &edx, true))
> -				maxphyaddr = eax & 0xff;
> -			else
> -				maxphyaddr = 36;
> -			rsvd = rsvd_bits(maxphyaddr, 63);
> -			if (ctxt->ops->get_cr(ctxt, 4) & X86_CR4_PCIDE)
> -				rsvd &= ~X86_CR3_PCID_NOFLUSH;
> -		}
> -
> -		if (new_val & rsvd)
> -			return emulate_gp(ctxt, 0);
> -
> -		break;
> -		}
> -	case 4: {
> -		ctxt->ops->get_msr(ctxt, MSR_EFER, &efer);
> -
> -		if ((efer & EFER_LMA) && !(new_val & X86_CR4_PAE))
> -			return emulate_gp(ctxt, 0);
> -
> -		break;
> -		}
> -	}
> -
>   	return X86EMUL_CONTINUE;
>   }
>   
> 

