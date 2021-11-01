Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7F4441E11
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 17:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232702AbhKAQYW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 12:24:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40417 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232677AbhKAQYU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Nov 2021 12:24:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635783706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D0pDbHtTcR82UVCQHWAbgqpuu1KGubZnwzSQ8mPGn+I=;
        b=i/02LgkUvloue5jfupZk1IncQ6Q8mOr5C6ymya0EbLkkFdRA5uH0OuJ0cxEZJhxtJQvBw2
        N6qj0wLnyh0i4A6AMLnpNg+KdoMggs9DYcph0QJ7nOLfV4AusSCKYW2svQhKTSYG+Sk4fa
        lZlSyJr9jWamWWYuNUtaCHlmpOOeE6o=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-569-s8wVpwymPBGa_SnnNS2YLg-1; Mon, 01 Nov 2021 12:21:45 -0400
X-MC-Unique: s8wVpwymPBGa_SnnNS2YLg-1
Received: by mail-wm1-f71.google.com with SMTP id 67-20020a1c0046000000b0032cd88916e5so4604435wma.6
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 09:21:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=D0pDbHtTcR82UVCQHWAbgqpuu1KGubZnwzSQ8mPGn+I=;
        b=kyWCpm/mGXXRw0vza7rOgHT9SYpuVf1wjrct1opXAzZ5rpJhvFI3BjPCbwHndcyOhv
         TCs0xGWP+LiytLVbT9V0RYLYxSrJnflmfQ6n2Nn7hX+znSbDzNwrq0lAnBQaVCDw1YC+
         U3dpBTxtSS82VFHWtBmFSbQ3GjddFaek6xLHDcSiq93a+IW8V1RXPCzi40NkZ0HDTzmX
         g93DpOoGIzr/zpOBz/cJQMzme9z0jHkhHPWnjJWqpKqcL2AdnEroGOeSn7enr4ee/FnZ
         lTYJMdACVunjD4LA8OfYRh8+ZO/U84mjpr+aBDiEoSJshjuq38Wy7b02vN3mevNJwnpN
         XJ1g==
X-Gm-Message-State: AOAM533lcZu5ON9L7pRMI3IKvAKRwcAPvRHUxRBQCc0I4YbmjFvzRwev
        tzxWI544YXvjeU6bm6LAz057MN3HJ/6LzdbSbPyMeORERXT99NMsKO5pPQhqA9tffeeOmPNmgYZ
        l2nWi5vNqKuPk
X-Received: by 2002:a05:600c:35cb:: with SMTP id r11mr32964158wmq.76.1635783704383;
        Mon, 01 Nov 2021 09:21:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzg54pONXTEoQJ+SUEIJ8W1KRheAbFXi6E/qkqBCPrstK3ffBjgfgu7fIfChSWRMD/80LyMAg==
X-Received: by 2002:a05:600c:35cb:: with SMTP id r11mr32964133wmq.76.1635783704156;
        Mon, 01 Nov 2021 09:21:44 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id z8sm8283223wrh.54.2021.11.01.09.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 09:21:43 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Shuah Khan <shuah@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bandan Das <bsd@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Wei Huang <wei.huang2@amd.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v2 1/6] KVM: x86: SVM: add module param to control LBR
 virtualization
In-Reply-To: <20211101140324.197921-2-mlevitsk@redhat.com>
References: <20211101140324.197921-1-mlevitsk@redhat.com>
 <20211101140324.197921-2-mlevitsk@redhat.com>
Date:   Mon, 01 Nov 2021 17:21:42 +0100
Message-ID: <87pmrjkfs9.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> This is useful for debug and also makes it consistent with
> the rest of the SVM optional features.
>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/svm/svm.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 21bb81710e0f6..2b5f8e10d686d 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -186,12 +186,13 @@ module_param(vls, int, 0444);
>  static int vgif = true;
>  module_param(vgif, int, 0444);
>  
> +static int tsc_scaling = true;
> +module_param(tsc_scaling, int, 0444);
> +
>  /* enable/disable LBR virtualization */
>  static int lbrv = true;
>  module_param(lbrv, int, 0444);
>  
> -static int tsc_scaling = true;
> -module_param(tsc_scaling, int, 0444);

Subject line says "KVM: x86: SVM: add module param to control LBR
virtualization" but the patch just moves 'tsc_scaling' param a couple
lines up. Was this intended or is this a rebase artifact and the patch
just needs to be dropped?

>  
>  /*
>   * enable / disable AVIC.  Because the defaults differ for APICv

-- 
Vitaly

