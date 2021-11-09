Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D58B44B1D1
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 18:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239808AbhKIRTc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Nov 2021 12:19:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239433AbhKIRTc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Nov 2021 12:19:32 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD794C061764
        for <kvm@vger.kernel.org>; Tue,  9 Nov 2021 09:16:45 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id 207so19478477ljf.10
        for <kvm@vger.kernel.org>; Tue, 09 Nov 2021 09:16:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q35c4TBKqxH8jpY3YlDH+A9sBZRnoj0usOTREmmIMGg=;
        b=PLxYuMMfyVFe9r7QMyiTV5P78gnjpA2IO8uyonA+ra9ni5lupMi0xwNsPF6JwZrDd9
         oh10PtSfVlLKB6ibdgqtze1W4pKxSocQ/vxFWFJtONYH7vRuIO6eB9Lh4/sKStgbJIPG
         EkkemhyQy9OP7JYTRowsovTSlazG2hlZ+8NMbGtir4pRTkRlIuUlXkHgY6xsMyETus9p
         7S6pSSzZx1UYxQnj8HUzUTVuUEZysxLhn7wm0Kul0EidYEJvPIkHKgSMGxlcEuBOUSLV
         te5F6RYTqEnVBqNOCiznsqspLS2jYFV8WTv+y4q1cxMasLaumQeNAwzMhB3ZXW0pU0y9
         RALw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q35c4TBKqxH8jpY3YlDH+A9sBZRnoj0usOTREmmIMGg=;
        b=e4aMQdHFTAuaMP0/eTLJW0ZtPaw5oP/bJVwLikKqSo2+nN3yezBfZziBV4tMQ8zZYD
         KSAsuy4FD585VqirugpAjKG5Akya5DNkNIH9o6YGXpM7iYXmv02BRNszP1eSVWNemd43
         uGLrJlsuIsQodmSBVHBtxjgAfsi5IgtZpYG9M7/rc/anERkCkZ9Feu494HFdjmmrQESD
         l+6gAMGsrkhmOBpiOdtdReOLgEMvQscjnKVJbDHL5W0uFKsODQI8GehDPNaZb8m6/uc+
         hN8jeY9s/Qk/CYHDsdLsqjbnfwU78AnNNaXuGg79MKFHZQieZNAzUGhmQc3rmBZMdG46
         OupQ==
X-Gm-Message-State: AOAM531EO5PZSW7gKZl+fAHCOJ+vKAU/bXDzbOiSw92F13pUruO+r3Si
        RQh6T1fe/uafLSuLmFBpLl/xdRQXkGOJ2fnyz7U=
X-Google-Smtp-Source: ABdhPJz1H9PpeYbAd+OJbS9asLpJiPci5T1n3SAgTw197BH/NIyQDlvLaDm43Mw3gOxmvscU5LVADSsCGYMnSis5zA8=
X-Received: by 2002:a2e:9708:: with SMTP id r8mr9809182lji.36.1636478204236;
 Tue, 09 Nov 2021 09:16:44 -0800 (PST)
MIME-Version: 1.0
References: <20211031055634.894263-1-zxwang42@gmail.com> <20211031055634.894263-3-zxwang42@gmail.com>
 <YYV9ztwl/7Z5LqyT@google.com>
In-Reply-To: <YYV9ztwl/7Z5LqyT@google.com>
From:   Zixuan Wang <zxwang42@gmail.com>
Date:   Tue, 9 Nov 2021 09:16:00 -0800
Message-ID: <CAEDJ5ZSVk=oMAxubgvzcmc7G6DGCbf6hJAnPtxKeLcfyXHChaQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v1 2/7] x86 UEFI: Refactor set up process
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Marc Orr <marcorr@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Joerg Roedel <jroedel@suse.de>, bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 5, 2021 at 11:54 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Sat, Oct 30, 2021, Zixuan Wang wrote:
> > +efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
> >  {
> > +     efi_status_t status;
> > +
> > +     status = setup_memory_allocator(efi_bootinfo);
> > +     if (status != EFI_SUCCESS) {
> > +             printf("Failed to set up memory allocator: ");
> > +             switch (status) {
> > +             case EFI_OUT_OF_RESOURCES:
> > +                     printf("No free memory region\n");
> > +                     break;
> > +             default:
> > +                     printf("Unknown error\n");
> > +                     break;
> > +             }
> > +             return status;
> > +     }
> > +
> > +     status = setup_rsdp(efi_bootinfo);
> > +     if (status != EFI_SUCCESS) {
> > +             printf("Cannot find RSDP in EFI system table\n");
> > +             return status;
> > +     }
> > +
> > +     status = setup_amd_sev();
> > +     if (status != EFI_SUCCESS) {
> > +             switch (status) {
> > +             case EFI_UNSUPPORTED:
> > +                     /* Continue if AMD SEV is not supported */
> > +                     break;
> > +             default:
> > +                     printf("Set up AMD SEV failed\n");
> > +                     return status;
> > +             }
> > +     }
>
> Looks like this is pre-existing behavior, but the switch is quite gratuituous,
> and arguably does the wrong thing for EFI_UNSUPPORTED here as attempting to setup
> SEV-ES without SEV is guaranteed to fail.  And it'd be really nice if the printf()
> actually provided the error (below might be wrong, I don't know the type of
> efi_status-t).
>
>         status = setup_amd_sev();
>
>         /* Continue on if AMD SEV isn't supported, but skip SEV-ES setup. */
>         if (status == EFI_UNSUPPORTED)
>                 goto continue_setup;
>
>         if (status != EFI_SUCCESS) {
>                 printf("AMD SEV setup failed, error = %d\n", status);
>                 return status;
>         }
>
>         /* Same as above, lack of SEV-ES is not a fatal error. */
>         status = setup_amd_sev_es();
>         if (status != EFI_SUCCESS && status != EFI_UNSUPPORTED) {
>                 printf("AMD SEV-ES setup failed, error = %d\n", status);
>                 return status;
>         }
>
> continue_setup:
>

I agree. The current setup_amd_sev_es() checks if SEV is available and
returns EFI_UNSUPPORTED if not, so it does no harm if called after
setup_amd_sev() fails. But I think we should not rely on these
underlying implementation details. I will include this part in the
next version.

Best regards,
Zixuan
