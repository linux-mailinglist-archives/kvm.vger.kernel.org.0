Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAB0B38E5E1
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 13:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbhEXLyr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 07:54:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48087 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232665AbhEXLym (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 07:54:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621857194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zfCwhka2L7IMBYHuu50/MdZUm2+UjbEqYuiRuQJLXKE=;
        b=Rn7bA1+jC/ZaZu7RlWmeAy9h+Q8YMLpXZU10BgrXm9qFAqp+W47fmQIdKekIREQaVMKbju
        Y3zUbR/W7Qjuu3IetPPKJ3npHz+kqa+r3t/XtbEvmEVkBbVxyKmtaNvPDgqhAnG/4aSg51
        bLoIxPQLNniNQf3itM/npGUR/zYp5nA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-rpp-7mK3PLCaB9QqoTi54Q-1; Mon, 24 May 2021 07:53:13 -0400
X-MC-Unique: rpp-7mK3PLCaB9QqoTi54Q-1
Received: by mail-wr1-f69.google.com with SMTP id x10-20020adfc18a0000b029010d83c83f2aso12990199wre.8
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 04:53:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=zfCwhka2L7IMBYHuu50/MdZUm2+UjbEqYuiRuQJLXKE=;
        b=bgsn8iLdXrurlWAI30Fd0fWoBIlupSy7vELJued/be1DR3Kdkvn6byDbYaDTgneRba
         vJpqfGN2AKgMFjZUxWPLyEsbHI/ZbRidJPbmUcAniW0bNwVuPFVZLI4a64HPAGet6WzF
         OidGdGNGM2S72vzAoVTbuRaVCi7hqlKguCkad29YIRbJkHKQaF8wxU50UHHStW9vo56r
         OMFVOKUGDpbNVq3JNphtPZ7mPmOZVT20qkxeXHMnvBjhtORcGpMwvF8xv3EbEv2V7adp
         rJQprnCfs/fpHAblnw4bfau2GSxHs3ytDGcWH7dh29hB35u13++1gOm642fsD6irHKh1
         Aglg==
X-Gm-Message-State: AOAM531Xwr/aViWB/mtDfaS7WKxpeozsLn2E7zceU8LQOb47AaF3LHCe
        e2118n0dPnjFmiyresjmLsei5jaFw4P0rRncsvv/Rj04vO8Fq4kNg4/rLuQEgCjoNN1XJs7qnb4
        4bMmV1SxoymbM
X-Received: by 2002:a5d:4fce:: with SMTP id h14mr21348351wrw.239.1621857192033;
        Mon, 24 May 2021 04:53:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzj5hA+mPY/6z6A3gV4eFAIFa4rKF/d+NdxDU035q9t0Udwa9q9VgydrjfjXD6Zu3/m0314gw==
X-Received: by 2002:a5d:4fce:: with SMTP id h14mr21348330wrw.239.1621857191811;
        Mon, 24 May 2021 04:53:11 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id p14sm11925985wrm.70.2021.05.24.04.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 04:53:11 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] KVM: SVM: Assume a 64-bit hypercall for guests with
 protected state
In-Reply-To: <d0904f0d049300267665bd4abf96c3d7e7aa4825.1621701837.git.thomas.lendacky@amd.com>
References: <d0904f0d049300267665bd4abf96c3d7e7aa4825.1621701837.git.thomas.lendacky@amd.com>
Date:   Mon, 24 May 2021 13:53:08 +0200
Message-ID: <87pmxg73h7.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tom Lendacky <thomas.lendacky@amd.com> writes:

> When processing a hypercall for a guest with protected state, currently
> SEV-ES guests, the guest CS segment register can't be checked to
> determine if the guest is in 64-bit mode. For an SEV-ES guest, it is
> expected that communication between the guest and the hypervisor is
> performed to shared memory using the GHCB. In order to use the GHCB, the
> guest must have been in long mode, otherwise writes by the guest to the
> GHCB would be encrypted and not be able to be comprehended by the
> hypervisor. Given that, assume that the guest is in 64-bit mode when
> processing a hypercall from a guest with protected state.
>
> Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under SEV-ES")
> Reported-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  arch/x86/kvm/x86.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9b6bca616929..e715c69bb882 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8403,7 +8403,12 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  
>  	trace_kvm_hypercall(nr, a0, a1, a2, a3);
>  
> -	op_64_bit = is_64_bit_mode(vcpu);
> +	/*
> +	 * If running with protected guest state, the CS register is not
> +	 * accessible. The hypercall register values will have had to been
> +	 * provided in 64-bit mode, so assume the guest is in 64-bit.
> +	 */
> +	op_64_bit = is_64_bit_mode(vcpu) || vcpu->arch.guest_state_protected;
>  	if (!op_64_bit) {
>  		nr &= 0xFFFFFFFF;
>  		a0 &= 0xFFFFFFFF;

While this is might be a very theoretical question, what about other
is_64_bit_mode() users? Namely, a very similar to the above check exists
in kvm_hv_hypercall() and kvm_xen_hypercall().

-- 
Vitaly

