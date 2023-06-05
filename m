Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A887722D12
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 18:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234995AbjFEQz3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 12:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234284AbjFEQzY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 12:55:24 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA54F3
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 09:55:22 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id d75a77b69052e-3f98276f89cso531cf.1
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 09:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685984122; x=1688576122;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o2y10YuUFmG8KRHYWCAPkl6GMbIuHJBgvVBZeZ3IUOI=;
        b=Egaxijz25IFotxjFqZJVSc5/ZObLF+Dbgfr0DLhKTjOC/hST1y0UjlH9vMBNlaN6ol
         i9V+qeM+4sDnQmT3Dv6Fdx0YZoH3wHjTZDzAkLNvRpl82rtLqttyEXhfJkSmfShODU0Y
         3/piup5l5NaeweKvRw24482R3KmZqYcNZ8MptR8zGidQvQ04zr8XSZxfSb/ah0CS0KyC
         IIhRubwyLD2i3i2mAIvfgxd5iGUXTuoqsjyH8JQgu6ZnWW1ZUy0/FpWLIOABhrV7A4zq
         2u3YKHsJmshUsmzTzrMzpI/yc90NBLFPzDW+Iac7W7Rznpsaa3HkJb9yb6pW44eM0bZn
         lOWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685984122; x=1688576122;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o2y10YuUFmG8KRHYWCAPkl6GMbIuHJBgvVBZeZ3IUOI=;
        b=dRCPXjMv7QQYAsUJ+x34/NJEQ3YVhDThtVBtMTmDO3bgUq8rhphgNNmcHTeWpjUMXW
         x9CnfVGqqpbF2R6ggT3xV70vAwLk4PFfiOUUzJBZoCA394YUhEH3RE4AeJ+Zcagkycb8
         5MSFZXagcbnjvH8YrKykf+58Ot7gQ3zp3kCxqtzxS457gbPJRjHGN8lK6J82VikJ3OS4
         TEiaSmC7hucQ0/tcvl7h47X6Ed1J+FhWKW4Trb13GWI2sAMLz/xhZAT8jLJMAV+Sn0A1
         81K0VzsbqbJZ6UEa5A+M5zkPWY0ePo//v4/fQYpfh4mDiY+Bd2Z+MiZ0Z7EyhOHvJNna
         MXnA==
X-Gm-Message-State: AC+VfDxToFMDi1yljbY2C3WJGqr9n8iRQK7hKXuUosBe3jl1JQywF9PT
        IBgMSlcTZMMqKvWPKtKSLp9tHvC0XBqHDOxLjbgR2w==
X-Google-Smtp-Source: ACHHUZ7gOrwQJeZtk6yMaDaxSB932Rw8X+QudMZQUB4UKkVEH5FwVCVR1s/S5qOQwxikCa/kcOCZ/HnZnQaaUVJYNXg=
X-Received: by 2002:a05:622a:1d5:b0:3f9:a986:f3a4 with SMTP id
 t21-20020a05622a01d500b003f9a986f3a4mr146271qtw.25.1685984121608; Mon, 05 Jun
 2023 09:55:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230605004334.1930091-1-mizhang@google.com>
In-Reply-To: <20230605004334.1930091-1-mizhang@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 5 Jun 2023 09:55:10 -0700
Message-ID: <CALMp9eSQgcKd=SN4q2QRYbveKoayKzuYEQPM0Xu+FgQ_Mja8-g@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Remove KVM MMU write lock when accessing indirect_shadow_pages
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jun 4, 2023 at 5:43=E2=80=AFPM Mingwei Zhang <mizhang@google.com> w=
rote:
>
> Remove KVM MMU write lock when accessing indirect_shadow_pages counter wh=
en
> page role is direct because this counter value is used as a coarse-graine=
d
> heuristics to check if there is nested guest active. Racing with this
> heuristics without mmu lock will be harmless because the corresponding
> indirect shadow sptes for the GPA will either be zapped by this thread or
> some other thread who has previously zapped all indirect shadow pages and
> makes the value to 0.
>
> Because of that, remove the KVM MMU write lock pair to potentially reduce
> the lock contension and improve the performance of nested VM. In addition
> opportunistically change the comment of 'direct mmu' to make the
> description consistent with other places.
>
> Reported-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/x86.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5ad55ef71433..97cfa5a00ff2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8585,15 +8585,9 @@ static bool reexecute_instruction(struct kvm_vcpu =
*vcpu, gpa_t cr2_or_gpa,
>
>         kvm_release_pfn_clean(pfn);
>
> -       /* The instructions are well-emulated on direct mmu. */
> +       /* The instructions are well-emulated on Direct MMUs. */
>         if (vcpu->arch.mmu->root_role.direct) {
> -               unsigned int indirect_shadow_pages;
> -
> -               write_lock(&vcpu->kvm->mmu_lock);
> -               indirect_shadow_pages =3D vcpu->kvm->arch.indirect_shadow=
_pages;
> -               write_unlock(&vcpu->kvm->mmu_lock);
> -
> -               if (indirect_shadow_pages)
> +               if (READ_ONCE(vcpu->kvm->arch.indirect_shadow_pages))

I don't understand the need for READ_ONCE() here. That implies that
there is something tricky going on, and I don't think that's the case.

>                         kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa)=
);
>
>                 return true;
>
> base-commit: 31b4fc3bc64aadd660c5bfa5178c86a7ba61e0f7
> --
> 2.41.0.rc0.172.g3f132b7071-goog
>
