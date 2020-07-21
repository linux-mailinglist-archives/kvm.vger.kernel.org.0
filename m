Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A55227D25
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 12:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgGUKfH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 06:35:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59393 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726084AbgGUKfH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 06:35:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595327706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+QcQANYSd60hPwsM1oi+9jY7lQaINgY8Mg9f0/qdPFw=;
        b=hx674mbYFxNsPxmfRw4iTn6kFCxENHv9Udzd4zU01flkmHIfIQe/LaC0kyBISWDCqvvRMG
        oK3dYDnbYT8hKVfbkM/Ei557UOCzGPBaDl6oT2NHJINvRFGjRksBdPq0waEBjQLX/9P9C8
        w2KSD63NuNDe5PnG4d77J2yS54jNvHo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-Oa8wcXvvOmulsz3JKDwyYg-1; Tue, 21 Jul 2020 06:35:04 -0400
X-MC-Unique: Oa8wcXvvOmulsz3JKDwyYg-1
Received: by mail-wr1-f71.google.com with SMTP id f7so347589wrs.8
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 03:35:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=+QcQANYSd60hPwsM1oi+9jY7lQaINgY8Mg9f0/qdPFw=;
        b=jlkPaO3+R8jZuAMUlwx2c1OiIja8hK+EtVq5hVm4vOEjD+qCRCekq6ApfOfCSU5T9C
         YJ3Rn0uKXL1rAVW5xH2/c1Z7OnOVUIpY0PVAXM1zY1auFMs2YQKNrba2k4JbDLO4UPe4
         0zSkPc20UfCsDnB7s84HPsm2iAgPYCKr96oyue2h+fI+F/mkXL9BLtUH/vL1LAP+Yav2
         UO2uup9qJS9Ffy/Z3UUQQCdfyCMtEdhE7zfYDNqv4FZxSVxv7B2zq2HBZjo5udp8B9o/
         qiItFCCMkUt5rzpB1bXE2nMTEW+hK4KJ2mR2m9Dz2MQm4bLK8l5pXpMBv5V0ZcnU6Nd5
         YQbQ==
X-Gm-Message-State: AOAM531DArkoOtL4jlMTgX1fkvL27j+c0rvOKvaF3gCIn3cqcXPlhBU/
        jseOr36+t8Qzyn0tyBRJkAs+Zk1Vpx12+40Cpeg+B1XRB7095XF8+TDy8X05gxEJ6WtiHGfwVlw
        Gtw92CwJmX0YB
X-Received: by 2002:adf:ee05:: with SMTP id y5mr27007281wrn.185.1595327703544;
        Tue, 21 Jul 2020 03:35:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwv0DP3FjlddJPF+5lYujXxuycYk0rvKz4/nKB/2vjz0RMXFM7kJkZtlYaitG1SsPgtRKexoA==
X-Received: by 2002:adf:ee05:: with SMTP id y5mr27007267wrn.185.1595327703348;
        Tue, 21 Jul 2020 03:35:03 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id g144sm2604256wme.2.2020.07.21.03.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 03:35:02 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 1/2] KVM: LAPIC: Prevent setting the tscdeadline timer if the lapic is hw disabled
In-Reply-To: <1595323468-4380-1-git-send-email-wanpengli@tencent.com>
References: <1595323468-4380-1-git-send-email-wanpengli@tencent.com>
Date:   Tue, 21 Jul 2020 12:35:01 +0200
Message-ID: <87o8o9p356.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng Li <kernellwp@gmail.com> writes:

> From: Wanpeng Li <wanpengli@tencent.com>
>
> Prevent setting the tscdeadline timer if the lapic is hw disabled.
>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/lapic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 5bf72fc..4ce2ddd 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2195,7 +2195,7 @@ void kvm_set_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu, u64 data)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
>  
> -	if (!lapic_in_kernel(vcpu) || apic_lvtt_oneshot(apic) ||
> +	if (!kvm_apic_present(vcpu) || apic_lvtt_oneshot(apic) ||
>  			apic_lvtt_period(apic))
>  		return;

Out of pure curiosity, what is the architectural behavior if I disable
LAPIC, write to IA32_TSC_DEADLINE and then re-enable LAPIC before the
timer was supposed to fire?

-- 
Vitaly

