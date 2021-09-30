Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB7E41E510
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 01:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350444AbhI3Xnu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 19:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350111AbhI3Xnt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 19:43:49 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B771C06176C
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 16:42:06 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id 24so9475039oix.0
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 16:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gi00dUKbEnLBBRPaXgkT5o8maxEnkVJlIu1XQkEnZC0=;
        b=KbzcW1uCfgaHX1R4cGCWYPX7UdNQyYMdI2TaNa0i7HP9MHoSkC/vqAaGCgbin6mB6T
         se+E7M7c8NwmnlvSAHX5Ie1kV2dQUGPSOdeqqEWF3Lwk2UCXrVLeLlgFqq84wDU9ZO/z
         y5JKi+oFRhFbmcrebDHwOlzmSssggAwIKOW79O97lnO4uguXxhrzpEcb4eFn8kFc3SBB
         WMQvnY7IFk8eR6WWepatQtY23RGz9Az/Xqjs9nqtdJONqku7bY6wav7l+I/4l/ILJI+W
         aMPQGheTvyHDLJc6QYsimS5BjEn4+6tQhaUZjCY5c7157mhO7h89Kblg9SE+vbVy4BwF
         IkJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gi00dUKbEnLBBRPaXgkT5o8maxEnkVJlIu1XQkEnZC0=;
        b=GuJJbSi3aG3ZwqUfmpzbWSja/Mgvg1cC2upCaaxdr+0VUq7HbCo7I1YpxX038jYNG6
         vFcoWIBcFVmH1NVjdR+HEnCBViEjmrQ+xQ8fmgKvGbLcY4F8qS5FtWA2n9hcO7wX1IeT
         TJvxqM+aqh6dhwBdji6T3ouWn4qg6uf32WBd98HOsuFrNcfpqTE5Qqxgt/UgYIpkNJ0Y
         9bEEXT1RM4RmA3HBKhc4oyJoRL7C+UQVAj5XJPJa0r0QpAMqvjDb3SPStBjd6i3JBxCr
         BcrprBerTJMdWTS1jOg4DoO6K7xwqhg7zWOLe+HF2ESvJl/guF/ZMdT2/eulG9KO/ogf
         wvew==
X-Gm-Message-State: AOAM533dtwq9QzVlc5M7zra6TMpgjqrs54dNDDFMqC3DqdEZ3XubIt6Z
        nQZYr+8XvJBX7u5CYrLjP2cnLNqIIdyIuLHQH8eUFl5ORizzLw==
X-Google-Smtp-Source: ABdhPJwKPjQgHWUMf0Og0OYmzz1BYvLtSYzI/LiSuuHHPOcmotdMisrFNn74dwe+jncaX/uBBZp37kj5RhHAGMWQhf4=
X-Received: by 2002:a05:6808:60f:: with SMTP id y15mr1599090oih.15.1633045325230;
 Thu, 30 Sep 2021 16:42:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210820155918.7518-1-brijesh.singh@amd.com> <20210820155918.7518-33-brijesh.singh@amd.com>
In-Reply-To: <20210820155918.7518-33-brijesh.singh@amd.com>
From:   Marc Orr <marcorr@google.com>
Date:   Thu, 30 Sep 2021 16:41:54 -0700
Message-ID: <CAA03e5G-UX761uBAFLS3e1NuYZOh2v8b=UkrX+rZUviegyWVGQ@mail.gmail.com>
Subject: Re: [PATCH Part2 v5 32/45] KVM: x86: Define RMP page fault error bits
 for #NPF
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 20, 2021 at 9:00 AM Brijesh Singh <brijesh.singh@amd.com> wrote:
>
> When SEV-SNP is enabled globally, the hardware places restrictions on all
> memory accesses based on the RMP entry, whether the hypervisor or a VM,
> performs the accesses. When hardware encounters an RMP access violation
> during a guest access, it will cause a #VMEXIT(NPF).
>
> See APM2 section 16.36.10 for more details.

nit: Section # should be 15.36.10 (rather than 16.36.10). Also, is it
better to put section headings, rather than numbers in the commit logs
and comments? Someone mentioned to me that the section numbering in
APM and SDM can move around over time, but the section titles tend to
be more stable. I'm not sure how true this is, so feel free to
disregard this comment.

>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 109e80167f11..a6e764458f3e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -239,8 +239,12 @@ enum x86_intercept_stage;
>  #define PFERR_FETCH_BIT 4
>  #define PFERR_PK_BIT 5
>  #define PFERR_SGX_BIT 15
> +#define PFERR_GUEST_RMP_BIT 31
>  #define PFERR_GUEST_FINAL_BIT 32
>  #define PFERR_GUEST_PAGE_BIT 33
> +#define PFERR_GUEST_ENC_BIT 34
> +#define PFERR_GUEST_SIZEM_BIT 35
> +#define PFERR_GUEST_VMPL_BIT 36
>
>  #define PFERR_PRESENT_MASK (1U << PFERR_PRESENT_BIT)
>  #define PFERR_WRITE_MASK (1U << PFERR_WRITE_BIT)
> @@ -251,6 +255,10 @@ enum x86_intercept_stage;
>  #define PFERR_SGX_MASK (1U << PFERR_SGX_BIT)
>  #define PFERR_GUEST_FINAL_MASK (1ULL << PFERR_GUEST_FINAL_BIT)
>  #define PFERR_GUEST_PAGE_MASK (1ULL << PFERR_GUEST_PAGE_BIT)
> +#define PFERR_GUEST_RMP_MASK (1ULL << PFERR_GUEST_RMP_BIT)
> +#define PFERR_GUEST_ENC_MASK (1ULL << PFERR_GUEST_ENC_BIT)
> +#define PFERR_GUEST_SIZEM_MASK (1ULL << PFERR_GUEST_SIZEM_BIT)
> +#define PFERR_GUEST_VMPL_MASK (1ULL << PFERR_GUEST_VMPL_BIT)
>
>  #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |       \
>                                  PFERR_WRITE_MASK |             \
> --
> 2.17.1
>
