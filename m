Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0140E160DD2
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 09:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728581AbgBQIwp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 03:52:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43766 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728217AbgBQIwo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 03:52:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581929563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9G4eC97MKUgP+cXhellYbHRQe5FYP3q5I9qDq+0E3so=;
        b=HjDJfbLGFUsmqUwA2r96Zqdz8IKrLorWvN+uLIiGls9NoUWqn3w48CMy7iwoAeYHlico+O
        bJAYYec97Xx5A3OpzGwuGLU8+KuztcuG/a2WrZMO/gA0LZys2C/RCZAZD/SbJdUojbSLJh
        g7uwdVyQTzNpE3yj2L9kA4ebjtyaTd4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-ZMFD5DLdMvuDeYjX5QAOBw-1; Mon, 17 Feb 2020 03:52:38 -0500
X-MC-Unique: ZMFD5DLdMvuDeYjX5QAOBw-1
Received: by mail-wm1-f69.google.com with SMTP id y125so2368754wmg.1
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2020 00:52:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=9G4eC97MKUgP+cXhellYbHRQe5FYP3q5I9qDq+0E3so=;
        b=exL0HbALmRr3765LWEq7jOV1dc8G6cheoYH3danFm88KgQRgzLqJHTzt/0xG8VD9DO
         a1cFeURwnpi5wDp1umQd4JqJ1bdVGcMFQEjferxPfvfSqrbM32GC5VXO/DPicNuhGMbP
         gy2071cOj3Dvp7CRTiFGIl5S3LwoLdpQERurvMhF6CdLgnUIuw2Zi4XZLF1uXQmJy7ZZ
         HZ/zMHH9Z0+5Fss9HgC40yowBIzeBsHkO62eVMYi1SNKdW2eipPhOjNGvgrvza7jqlr5
         DU/Ej5gV2XiY1JRwLK2EShhOZnKJoMVzte7FBfsFigyUub5Xfe2/Y6V2T0UxSpYlIndi
         eWEQ==
X-Gm-Message-State: APjAAAWj3pC6RY4gKQB0EPWxONhKknyn4ydbs0J+AHSNPityuJJHZjHp
        LW9SX92fBdfly1o4gyyF7kSbV9Fy3iEwtwLVXOeVqUkF5kn2DadLaaGJmWPp2KvB6kMbfm3S7fi
        zOxlsLjyYWkxp
X-Received: by 2002:a05:600c:2c01:: with SMTP id q1mr20672141wmg.179.1581929557588;
        Mon, 17 Feb 2020 00:52:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqyMpzIPVEU5r46mv5Dyf9+hTP7Dzsi4UbPKOlvpGkJxEH57K69N/xQw0jEso6nxioT5dTqnvg==
X-Received: by 2002:a05:600c:2c01:: with SMTP id q1mr20672122wmg.179.1581929557376;
        Mon, 17 Feb 2020 00:52:37 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id h13sm21908626wrw.54.2020.02.17.00.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 00:52:36 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] KVM: VMX: Add VMX_FEATURE_USR_WAIT_PAUSE
In-Reply-To: <20200216104858.109955-1-xiaoyao.li@intel.com>
References: <20200216104858.109955-1-xiaoyao.li@intel.com>
Date:   Mon, 17 Feb 2020 09:52:36 +0100
Message-ID: <87r1ytbnor.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> Commit 159348784ff0 ("x86/vmx: Introduce VMX_FEATURES_*") missed
> bit 26 (enable user wait and pause) of Secondary Processor-based
> VM-Execution Controls.
>
> Add VMX_FEATURE_USR_WAIT_PAUSE flag and use it to define
> SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE to make them uniformly.
>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  arch/x86/include/asm/vmx.h         | 2 +-
>  arch/x86/include/asm/vmxfeatures.h | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index 2a85287b3685..8521af3fef27 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -72,7 +72,7 @@
>  #define SECONDARY_EXEC_MODE_BASED_EPT_EXEC	VMCS_CONTROL_BIT(MODE_BASED_EPT_EXEC)
>  #define SECONDARY_EXEC_PT_USE_GPA		VMCS_CONTROL_BIT(PT_USE_GPA)
>  #define SECONDARY_EXEC_TSC_SCALING              VMCS_CONTROL_BIT(TSC_SCALING)
> -#define SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE	0x04000000
> +#define SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE	VMCS_CONTROL_BIT(USR_WAIT_PAUSE)
>  
>  #define PIN_BASED_EXT_INTR_MASK                 VMCS_CONTROL_BIT(INTR_EXITING)
>  #define PIN_BASED_NMI_EXITING                   VMCS_CONTROL_BIT(NMI_EXITING)
> diff --git a/arch/x86/include/asm/vmxfeatures.h b/arch/x86/include/asm/vmxfeatures.h
> index a50e4a0de315..1408f526bd90 100644
> --- a/arch/x86/include/asm/vmxfeatures.h
> +++ b/arch/x86/include/asm/vmxfeatures.h
> @@ -81,6 +81,7 @@
>  #define VMX_FEATURE_MODE_BASED_EPT_EXEC	( 2*32+ 22) /* "ept_mode_based_exec" Enable separate EPT EXEC bits for supervisor vs. user */
>  #define VMX_FEATURE_PT_USE_GPA		( 2*32+ 24) /* "" Processor Trace logs GPAs */
>  #define VMX_FEATURE_TSC_SCALING		( 2*32+ 25) /* Scale hardware TSC when read in guest */
> +#define VMX_FEATURE_USR_WAIT_PAUSE	( 2*32+ 26) /* "" Enable TPAUSE, UMONITOR, UMWATI in guest */

"UMWAIT"

>  #define VMX_FEATURE_ENCLV_EXITING	( 2*32+ 28) /* "" VM-Exit on ENCLV (leaf dependent) */
>  
>  #endif /* _ASM_X86_VMXFEATURES_H */

With the typo fixed (likely upon commit),

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

