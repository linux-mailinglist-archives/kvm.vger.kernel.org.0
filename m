Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7CBA39FCA1
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 18:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbhFHQi6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 12:38:58 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:37431 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbhFHQi5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 12:38:57 -0400
Received: by mail-pf1-f173.google.com with SMTP id y15so16107472pfl.4
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 09:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XwlxQ9Ne7VITYTrHKAQ6cxJKrlsTB+fMYIzZxCbcXyE=;
        b=YBJCDDFMd5CLaph7grIInggM9odiLuLNIv2Q1AIESL289DTpiTiUR60TnT+nuqNxwp
         DB5YdcpzPR+AXl90k3MbzBnQDQKv3zqTEilIaubJwyyME92ZWcFEebYUEpR1I1wpyp6v
         Xd1EqBXf9J+fwdV1/agx2kR5kmTOijQOkpPBTy8eUBy5vhlFQxkMh/Kp8dca+ayjIs9+
         CirrLPSDqStAiCS7bscw4AjIR5On2CIYmkowvyFq1nK61YsDqu3lG7/YF/9FrM+7Hmfd
         Ex+Bkq0nHRj4Rq0R5m9k5tN2SJRic+D11UwZ6K2TR+aQy14wEWN+XGzSyIgmxTqyml2w
         s7ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XwlxQ9Ne7VITYTrHKAQ6cxJKrlsTB+fMYIzZxCbcXyE=;
        b=eczMVFslkvOHWKwkk6JWol3ylhnmHrOQdseEQ4pscTo5ico+dhXo1InEvhlnKONh39
         Xeta4pu94YGKvRf/ugoOqs1+UZO7h1LrinmTwJ98TJokbjVEPaLESdnXksxlU+PUJv/3
         hpvPfC4pLNTt+wp4KupGPfNrJeMCOQB+1vAIh8ZaA7uXchJPKNHaIPfFnnxVsJqKFbYh
         F3ImgIbILl5Wt6/6eE1IXqrVVqJ+3Ysygywj4MwkFRKo5DC9/A5micErNYTO3af5PBBp
         WOA3XgrFlUsaV6jKC3KvfyZUjHyOlgt7UpUzyJowd4lgFh/eoxUlKMO++/jwV/x4icuX
         vh0w==
X-Gm-Message-State: AOAM532x2ijPN8ys6fUn5Lhwx1dZ0E20yExnSOD5hsmjJQx9MV0cJHsc
        a9WnS55xLU1Ks5L5pjI0StrmtQ==
X-Google-Smtp-Source: ABdhPJwZRW1K8PC+sMoGNNMG/GHxafaVF3z/pTKPdHK9OMzoQqeup74JyVPkOoSQg+2ZSr/AeS75Pg==
X-Received: by 2002:a63:1d61:: with SMTP id d33mr23265156pgm.331.1623170148297;
        Tue, 08 Jun 2021 09:35:48 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id m191sm11505013pga.88.2021.06.08.09.35.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 09:35:47 -0700 (PDT)
Date:   Tue, 8 Jun 2021 16:35:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2 3/3] KVM: X86: Let's harden the ipi fastpath condition
 edge-trigger mode
Message-ID: <YL+cX8K3r7EWrk33@google.com>
References: <1623050385-100988-1-git-send-email-wanpengli@tencent.com>
 <1623050385-100988-3-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623050385-100988-3-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 07, 2021, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Let's harden the ipi fastpath condition edge-trigger mode.

Can you elaborate on the motivation for this patch?

Intel's SDM states that the trigger mode is ignored for all IPIs except INIT,
and even clarifies that the local xAPIC will override the bit and send the IPI
as edge-triggered.

AMD's APM on the other hand explicitly lists level-triggered Fixed IPIs as a
valid ICR combination.

Regardless of which of the two conflicting specs we want KVM to emulate (which
is currently AMD), I don't see why the fastpath code should care, as I can't
find anything in the kvm_apic_send_ipi() path that would go awry if it's called
from the fastpath for a level-triggered IPI.

Related side topic, anyone happen to know if KVM (and Qemu's) emulation of IPIs
intentionally follows AMD instead of Intel?  I suspect it's unintentional,
especially since KVM's initial xAPIC emulation came from Intel.  Not that it's
likely to matter, but allowing level-triggered IPIs is bizarre, e.g. getting an
EOI sent to the right I/O APIC at the right time via a level-triggered IPI seems
extremely convoluted.

> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/x86.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b594275..dbd3e9d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1922,6 +1922,7 @@ static int handle_fastpath_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64 data
>  		return 1;
>  
>  	if (((data & APIC_SHORT_MASK) == APIC_DEST_NOSHORT) &&
> +		((data & APIC_INT_LEVELTRIG) == 0) &&
>  		((data & APIC_DEST_MASK) == APIC_DEST_PHYSICAL) &&
>  		((data & APIC_MODE_MASK) == APIC_DM_FIXED) &&
>  		((u32)(data >> 32) != X2APIC_BROADCAST)) {
> -- 
> 2.7.4
> 
