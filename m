Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA31F1FC9AF
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 11:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbgFQJTl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 05:19:41 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44378 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725536AbgFQJTk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Jun 2020 05:19:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592385579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kkEXKyGt2pSGVeN/088gzrGbTggjvieYaVp7yoqIgIc=;
        b=J8dyiOGb+lYk2Kst4z1i+WgICtvpPbM6Xo43Ntbzkl+REzDJ+2M0hnZDQxheJgkqSi2PZv
        ctKrfjKgzO4B4UcLney+WFE3sGFd+v7zAMdUiNg7qxr+LF986dA/CaVv2VE2tccl5X5O9f
        bjRVCmCGsTwJhBFPtU+z3N+9JlP7z6U=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-WUcVAFRmNIiuO3KYBLBrYw-1; Wed, 17 Jun 2020 05:19:37 -0400
X-MC-Unique: WUcVAFRmNIiuO3KYBLBrYw-1
Received: by mail-ej1-f72.google.com with SMTP id e14so739382ejt.16
        for <kvm@vger.kernel.org>; Wed, 17 Jun 2020 02:19:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=kkEXKyGt2pSGVeN/088gzrGbTggjvieYaVp7yoqIgIc=;
        b=EXqSL6rWhC1JSqsZJmrHtC8wEaKAQnz66T77/Hf60shnFqSWsBtD6vnfggUrGDu+J3
         UCqhbsHydVxFzmelk2fUFRKk/khtzyIx/JeO2vsXsLRKV9Oth0cu/uRV9ClqHjS7aeSQ
         aHZJRxCPMwJ2OYa7EHSwT5MJdokJ9YBTAz93QKLmpB2EbcPpquXquPWVJi75XtAGevcI
         GlykSbe3I047iahzd2Hct9B/Dr7OKT8iOU/XFx4Cn7xUhc6Z4ABVcJdbQqpiwuxQogPV
         Du0wKcYJS9D7K9V8Ltlsz6KQ30jcgToj24M25UkMvpc1rywDiYXn1z93uPCmXfbZmdvL
         LV8g==
X-Gm-Message-State: AOAM533ZFfkC7Gva1/29bwtMlxD7ZLnION52A2dvwL30dJsrVnHiTxNF
        prUNgAP29a9Z7Gi535N2+DAcSJaYfjih9wIa2WrSeNJqOJrO8vpS6yJKyJvuh5G9+kIRWaj+tYu
        S23lT8AfsJ2n8
X-Received: by 2002:a17:907:217a:: with SMTP id rl26mr6508703ejb.209.1592385576317;
        Wed, 17 Jun 2020 02:19:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzrJXQCxLImLWsBTGLvp8iRfU4f8nD2ldLoRX71FQCLOBA0I2c2dEM5Z3bO5UcktbATy/FZlQ==
X-Received: by 2002:a17:907:217a:: with SMTP id rl26mr6508687ejb.209.1592385576150;
        Wed, 17 Jun 2020 02:19:36 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id z15sm13057695ejw.8.2020.06.17.02.19.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 02:19:35 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: VMX: Remove vcpu_vmx's defunct copy of host_pkru
In-Reply-To: <20200617034123.25647-1-sean.j.christopherson@intel.com>
References: <20200617034123.25647-1-sean.j.christopherson@intel.com>
Date:   Wed, 17 Jun 2020 11:19:34 +0200
Message-ID: <87zh92gic9.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

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

(Is there a better [automated] way to figure out whether the particular
field is being used or not than just dropping it and trying to compile
the whole thing? Leaving #define-s, configs,... aside ...)

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

