Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF3DEEC890
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 19:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbfKASfy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 14:35:54 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:44086 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbfKASfy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 14:35:54 -0400
Received: by mail-il1-f196.google.com with SMTP id w1so634184ilq.11
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2019 11:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GfaxDeopuNa0dXDvZ92N+KU9hxmW5s0v5yugFygMjC0=;
        b=G+srrPkOdg6Gn6KDILn67Ot0L8IsUkUbFo9C5u/X4dPXxgM/+1TmEewkrPK8AR+BA3
         KNg+IVuG18plQ9mwpeil2HvEejEJtx/iuhIE107LA3Fb33K1SauVlSD0eQZ7ogLtghwh
         6YOR4XLneLs2DSPNXCZzY7MBeOwFK5ZST9B3ippqK3Zw1AgC+NH8fSxvP20GWW4HXC1P
         5k4kEXcszA9C85DGP0fwdtYijWiq+7h59bQ5QToP6mX112UaBRI6jnNCmpmq4L5bJA08
         Qb5OJ3PQUp02nEgqZpQLvy9Ye1oFhtb/9++m07SkujICwsNOGAdELW9bi2hPu706u8ZH
         SWaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GfaxDeopuNa0dXDvZ92N+KU9hxmW5s0v5yugFygMjC0=;
        b=Wmg3ZSm8GAEpFjluIA5zpm78a2vCoF+Wy6TU5q6mp1J7c9Md9kCO4VV7sRTr5spTDf
         bxmA2yIpUCLZ33YkT3Yr/evYFlYh1d4OoCqeDUYpIaILsXkRGzgAgMwRa4WzH0pFXOtZ
         pdnzChcdZ4OsZUNve9Eb03iVAp2TTT5WsE4t+axVux65xKlafddzVvruL115N9Chccyp
         xatQX3v9Nn+/Fo4sUPzOokMmv2CJDTdBc/U9YyuUXwxemp32I1MMN+D4M2m8Ao7R9+WG
         Rmb6p30IQwQGI/BtdRGqeO6nkUkxDXDOsirSFs59T+touKBMdpXG7sLDTeNx4FCAngeh
         cY7g==
X-Gm-Message-State: APjAAAUDJTUAI/1IbIDMskDFe+4GPO5LaMGE6So5kXuGEV4mf7hFBtNM
        naVMZkBl2fZxKtGSjBNOV5U0SDHNJDeCW72alZdK1Q==
X-Google-Smtp-Source: APXvYqzOn7ah6e5vdLNDoO5HN6CVIW1sVXN9pQz44iNP/TMk3A841MlGik3ysrzpLSLNTr0J7P2ReSu8pUDjDYt7cb4=
X-Received: by 2002:a05:6e02:4c3:: with SMTP id f3mr3852324ils.296.1572633353353;
 Fri, 01 Nov 2019 11:35:53 -0700 (PDT)
MIME-Version: 1.0
References: <157262960837.2838.17520432516398899751.stgit@naples-babu.amd.com> <157262961597.2838.16953618909905259198.stgit@naples-babu.amd.com>
In-Reply-To: <157262961597.2838.16953618909905259198.stgit@naples-babu.amd.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 1 Nov 2019 11:35:42 -0700
Message-ID: <CALMp9eTb8N-WxgQ_J5_siU=8=DGNUjM=UZCN5YkAQoofZHx1hA@mail.gmail.com>
Subject: Re: [PATCH 1/4] kvm: x86: Dont set UMIP feature bit unconditionally
To:     "Moger, Babu" <Babu.Moger@amd.com>
Cc:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "nayna@linux.ibm.com" <nayna@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 1, 2019 at 10:33 AM Moger, Babu <Babu.Moger@amd.com> wrote:
>
> The UMIP (User-Mode Instruction Prevention) feature bit should be
> set if the emulation (kvm_x86_ops->umip_emulated) is supported
> which is done already.
>
> Remove the unconditional setting of this bit.
>
> Fixes: ae3e61e1c28338d0 ("KVM: x86: add support for UMIP")
>
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---
>  arch/x86/kvm/cpuid.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index f68c0c753c38..5b81ba5ad428 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -364,7 +364,7 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
>         /* cpuid 7.0.ecx*/
>         const u32 kvm_cpuid_7_0_ecx_x86_features =
>                 F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
> -               F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
> +               F(AVX512_VPOPCNTDQ) | F(AVX512_VBMI2) | F(GFNI) |
>                 F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
>                 F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/;
>

This isn't unconditional. This is masked by the features on the boot
CPU. Since UMIP can be virtualized (without emulation) on CPUs that
support UMIP, you should leave this alone.
