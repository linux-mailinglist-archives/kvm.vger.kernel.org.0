Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98B1B4291FD
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 16:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238175AbhJKOhZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 10:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238101AbhJKOhY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 10:37:24 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25A1C061570
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 07:35:24 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id j21so56937146lfe.0
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 07:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KwV0j5l+6jp7oi03p9mWq74y0+pPufe5DR//TIJnJ0o=;
        b=tSlT/vaOIZ7/xP1SYtjDrUM6zeicsCDdfvQmPM0bhEaEe106g/25m1QWASj7TLzW/9
         DsOn6EGujLp17YIv7/Effv67U/zAr79cu3RUSBeiiip5hVaALHGajC6YeLmkQVGQ0C8S
         w7mEbguwEFrkl0xpyR9z7jGXRDQTRvsMWMlbrPvFO3naoD7VG+ujxFiZQRu+Ahy2Bzey
         Ow3Hw9kgiyzRRMY48ycOrOj1e0bHAnwCKdT1FEoOuHJWVQLc5aebEokPcv4C4Lp443Qs
         j3fCIezddi0EX9bSmjbA/1AApjzNwCrfNaOkoxTwADK3ImFvydV9qd75NUqYzbe5TX1i
         UY6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KwV0j5l+6jp7oi03p9mWq74y0+pPufe5DR//TIJnJ0o=;
        b=EHrCCvRJsnHaYEPj4lqzj/+QxnQR4FDFhPagDNOKI+DP345dmlc4aeOTGrMPGuru4Z
         vKt0+lDfMnmSMuVSqi2z9vsq3taUJ98YdQYvcRatcanN24vMdyu6zp62HPPlKg7Xmuua
         oIQfRyzxJpuZVcKylxPoIYYuJqManuj3++b3J5cIZArXnvxLFdZCAIycywE8cKwj+t7S
         hw4WqEeNxyixRF3CkERcB5q08Lu16269vbT2sfFLWy7HwhQEfhMfwLn0fJAYIo9215aW
         VI8X7rjgSeGEW0i4X9piUTZrefX9EtAGai0UZIO/nnfHHj1tEd0he2KNSzkTV5lHZ3mF
         2/2A==
X-Gm-Message-State: AOAM533bId3I1dqn705vws5QbBBdU7wbQkEbmO+lWFA8kLxFIHpfGrkz
        bB4bZ2u14UL83nBh8b+0m0c1ZppZ8cnJ9hAFZlKeBw==
X-Google-Smtp-Source: ABdhPJyvJq+EGbz0XK0ctDpXW9jQaqubWu99B3p6kIGl1Sf0AYzfikJ14IoEewM995n2g++yyMaWr8hqRWbIxDKMXPo=
X-Received: by 2002:a2e:8ec3:: with SMTP id e3mr8346534ljl.337.1633962922631;
 Mon, 11 Oct 2021 07:35:22 -0700 (PDT)
MIME-Version: 1.0
References: <20211007231647.3553604-1-seanjc@google.com>
In-Reply-To: <20211007231647.3553604-1-seanjc@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Mon, 11 Oct 2021 09:35:11 -0500
Message-ID: <CAOQ_Qsj9yiChnBZmotdYFYgsd=C0J5XXR8mthdiC+iXX22F7jw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Account for 32-bit kernels when handling
 address in TSC attrs
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 7, 2021 at 6:16 PM Sean Christopherson <seanjc@google.com> wrot=
e:
>
> When handling TSC attributes, cast the userspace provided virtual address
> to an unsigned long before casting it to a pointer to fix warnings on
> 32-bit kernels due to casting a 64-bit integer to a 32-bit pointer.
>
> Add a check that the truncated address matches the original address, e.g.
> to prevent userspace specifying garbage in bits 63:32.
>
>   arch/x86/kvm/x86.c: In function =E2=80=98kvm_arch_tsc_get_attr=E2=80=99=
:
>   arch/x86/kvm/x86.c:4947:22: error: cast to pointer from integer of diff=
erent size
>    4947 |  u64 __user *uaddr =3D (u64 __user *)attr->addr;
>         |                      ^
>   arch/x86/kvm/x86.c: In function =E2=80=98kvm_arch_tsc_set_attr=E2=80=99=
:
>   arch/x86/kvm/x86.c:4967:22: error: cast to pointer from integer of diff=
erent size
>    4967 |  u64 __user *uaddr =3D (u64 __user *)attr->addr;
>         |                      ^
>
> Cc: Oliver Upton <oupton@google.com>
> Fixes: 469fde25e680 ("KVM: x86: Expose TSC offset controls to userspace")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>

Reviewed-by: Oliver Upton <oupton@google.com>
