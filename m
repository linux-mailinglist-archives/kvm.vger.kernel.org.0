Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6C12326B8
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 23:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgG2VXt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 17:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbgG2VXs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 17:23:48 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95736C061794
        for <kvm@vger.kernel.org>; Wed, 29 Jul 2020 14:23:48 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id z17so5609132ill.6
        for <kvm@vger.kernel.org>; Wed, 29 Jul 2020 14:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1yAh0Nb8RBXx/Dg8quoaFiNeVsKdfNd0tJqGuua5O5Q=;
        b=q4oE1uymGAyjZSxT2oNr7c/h/meq3PX77eRHDZz46aFCENlLQB49giKAGSwFCD7BDd
         HJExMuO9RqoIZ6SqNyIHc0zZwWGTNNixjxOZSikbXEp3Yd/pa6hEabFkY5Lcq5hSvS03
         /L4bYgNsyU+5j5X59xHMTUiYx1/Anx1IzzIAsbtxs4lRaT/ZgAqEsF+qDLo+n1N7pUYb
         Ur6hXaXRcwnbJLwxEShvY771sNpRvaalZ9yPWHXYBxKcE+FFvtIEm8KYbUsQpTYhEyfY
         wAbDUsz8NUFJkxgzafPoVQ7pMSmfbx2ZFAlf1I7bAIVWQzv8j06N7j2Z3zeHadGvDs8H
         VLoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1yAh0Nb8RBXx/Dg8quoaFiNeVsKdfNd0tJqGuua5O5Q=;
        b=kZosVfO5YivWLO1OHtwL76jLMxV7lhPTYtAO4XNWxQuESpyMpKPDD/8CdL5MlPFef1
         0ZI5WRaFX8d63kWuUP82JOByuenyKaisdH+0+S24Dras00Ra2Sp03WsDFkkgwH0aJKUE
         jmF9G6xV7esqcq6ovxLRCDpcMLTMtJO3JQhO+R4GHZlPrULiPiaaEsb8NF5b30Y0+bMO
         32/bR8mag/cj88P29K84yBDVUbiyJ/nkdlcXL9+F8iWblnNBDWDaVBudszgxExgtibYF
         jJ3WbYzQEI41SAvblxIP84glAJPJxXXIETKfLbzL4MT0pj15jYhG+yrqF8fJtQtgo3Js
         VQRg==
X-Gm-Message-State: AOAM533y4QfligavsqOyrVu954srub0pae3fmE0M2Wj+X8D3+QPGKATk
        4EgoAV2m411jUcE2w4WBPDbMQT2cQkyKyLGZQ76+lQ==
X-Google-Smtp-Source: ABdhPJzZwSom2NJHrADvd8thg40ia/i5aSoq1/32F72dab/LwaryY8svwIOWPJkOdFVDdXogcBYPlTnd9iOJZKPgqFI=
X-Received: by 2002:a92:790d:: with SMTP id u13mr30534775ilc.26.1596057827729;
 Wed, 29 Jul 2020 14:23:47 -0700 (PDT)
MIME-Version: 1.0
References: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu> <159597950612.12744.7213388116029286561.stgit@bmoger-ubuntu>
In-Reply-To: <159597950612.12744.7213388116029286561.stgit@bmoger-ubuntu>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 29 Jul 2020 14:23:35 -0700
Message-ID: <CALMp9eQUNLXgveya3TpyCH7L8EbEUEdPy+_ee_wSXwxqsKPDwQ@mail.gmail.com>
Subject: Re: [PATCH v3 06/11] KVM: SVM: Add new intercept vector in vmcb_control_area
To:     Babu Moger <babu.moger@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 28, 2020 at 4:38 PM Babu Moger <babu.moger@amd.com> wrote:
>
> The new intercept bits have been added in vmcb control area to support
> few more interceptions. Here are the some of them.
>  - INTERCEPT_INVLPGB,
>  - INTERCEPT_INVLPGB_ILLEGAL,
>  - INTERCEPT_INVPCID,
>  - INTERCEPT_MCOMMIT,
>  - INTERCEPT_TLBSYNC,
>
> Add new intercept vector in vmcb_control_area to support these instructio=
ns.
> Also update kvm_nested_vmrun trace function to support the new addition.
>
> AMD documentation for these instructions is available at "AMD64
> Architecture Programmer=E2=80=99s Manual Volume 2: System Programming, Pu=
b. 24593
> Rev. 3.34(or later)"
>
> The documentation can be obtained at the links below:
> Link: https://www.amd.com/system/files/TechDocs/24593.pdf
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D206537
>
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---

> @@ -16,6 +16,7 @@ enum vector_offset {
>         EXCEPTION_VECTOR,
>         INTERCEPT_VECTOR_3,
>         INTERCEPT_VECTOR_4,
> +       INTERCEPT_VECTOR_5,
>         MAX_VECTORS,
>  };

Is this enumeration actually adding any value?
vmcb->control.intercepts[INTERCEPT_VECTOR_5] doesn't seem in any way
"better" than just vmcb->control.intercepts[5].

Reviewed-by: Jim Mattson <jmattson@google.com>
