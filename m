Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD26D14CCF9
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2020 16:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgA2PIj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 10:08:39 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58332 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726261AbgA2PIg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Jan 2020 10:08:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580310514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VLaqf7yP7bdIce/kL3zR7k5oqbUaX9ZjKFr0PkLcpeY=;
        b=i7wuk3zIzRTFJP4mMjdbLC2dBI7yxpAqXkz91WTVJjCXV62fTQph4skKohX1nH9MHRQ9Ug
        EH3oG3GQOAuXRi00NxFNj5nG9QrK0XRjoxRdGtG7+gYE7yWuHzNbFGx7HFe8ygE0hWNd5z
        uKmDlSO7xvA1nEe1rdNNOxAIDYgYVgc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-ZZUCwXdpOeaPgG2D_R5F7A-1; Wed, 29 Jan 2020 10:08:32 -0500
X-MC-Unique: ZZUCwXdpOeaPgG2D_R5F7A-1
Received: by mail-wr1-f72.google.com with SMTP id s13so2809097wru.7
        for <kvm@vger.kernel.org>; Wed, 29 Jan 2020 07:08:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=VLaqf7yP7bdIce/kL3zR7k5oqbUaX9ZjKFr0PkLcpeY=;
        b=XWV80wDDkpFp+0LQ7JPME9uezOjRkATLcA9TRu3krXqvndKO3pAEsg5h1qPfFV3FAt
         oBhFP4v/FWYy55qngvJHFcMPRag5ZgQxEbD+0Z1tqCW4Vd6Uih6sZmIwR74QibKL0QCb
         ErmLVtKbLhr7BTykrhg8wJtZK82qwEMK0ETuC+lbNDk0E3laYQTiQXf6TaHtnm1RqsYe
         jrEylSKWeoD5Zhi7KdMwgvSARcU69ZHOwFSeYuR+jJClqK6VYMZSY0270G4UtKrcaYwQ
         aYt2nEybIwtnLd+mQT7wIaNcCVispC12VoOQklpx6LN/GUTYMRAonK4xwd3EEfN5Tk8y
         q03g==
X-Gm-Message-State: APjAAAWfhCYpppAIJWsjIU14wI+h6Jm2ScR6N72IsoE6FgYX2pIDmc3a
        CJBCKnw1EgLbivPjEVSfF2J/EBIGMIQ9+9NQ26XlfNTJL/tqQt/2AxlLE0pEYXHp+EB2V4hBt5U
        4Ox5spv6kWnpY
X-Received: by 2002:a1c:3b0a:: with SMTP id i10mr12809540wma.177.1580310511003;
        Wed, 29 Jan 2020 07:08:31 -0800 (PST)
X-Google-Smtp-Source: APXvYqxd7v/TEekwH/byRnpgvATju+em8Xhl75IgAQQp0nHiS9nxjrgubYvBWuwl6+TdY5xHEk2Eyw==
X-Received: by 2002:a1c:3b0a:: with SMTP id i10mr12809521wma.177.1580310510755;
        Wed, 29 Jan 2020 07:08:30 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id a184sm2663689wmf.29.2020.01.29.07.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 07:08:30 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86: Mark CR4.UMIP as reserved based on associated CPUID bit
In-Reply-To: <20200128235344.29581-1-sean.j.christopherson@intel.com>
References: <20200128235344.29581-1-sean.j.christopherson@intel.com>
Date:   Wed, 29 Jan 2020 16:08:29 +0100
Message-ID: <87a7669u6q.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Re-add code to mark CR4.UMIP as reserved if UMIP is not supported by the
> host.  The UMIP handling was unintentionally dropped during a recent
> refactoring.
>
> Not flagging CR4.UMIP allows the guest to set its CR4.UMIP regardless of
> host support or userspace desires.  On CPUs with UMIP support, including
> emulated UMIP, this allows the guest to enable UMIP against the wishes
> of the userspace VMM.  On CPUs without any form of UMIP, this results in
> a failed VM-Enter due to invalid guest state.
>
> Fixes: 345599f9a2928 ("KVM: x86: Add macro to ensure reserved cr4 bits checks stay in sync")

This one in only in kvm/next so just in case another force-push is
around the corner I'd suggest we squash this change in :-)

> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/x86.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7e3f1d937224..e70d1215638a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -898,6 +898,8 @@ EXPORT_SYMBOL_GPL(kvm_set_xcr);
>  		__reserved_bits |= X86_CR4_PKE;		\
>  	if (!__cpu_has(__c, X86_FEATURE_LA57))		\
>  		__reserved_bits |= X86_CR4_LA57;	\
> +	if (!__cpu_has(__c, X86_FEATURE_UMIP))		\
> +		__reserved_bits |= X86_CR4_UMIP;	\
>  	__reserved_bits;				\
>  })

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

