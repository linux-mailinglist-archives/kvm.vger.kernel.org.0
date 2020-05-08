Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C17EF1CA8C4
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 12:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgEHKy0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 06:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726948AbgEHKy0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 May 2020 06:54:26 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018B3C05BD43;
        Fri,  8 May 2020 03:54:25 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id u127so10092303wmg.1;
        Fri, 08 May 2020 03:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tRc1wFGoADt31h04bCok03WJLaNfqn/3kUZGVULqzzQ=;
        b=qg0xLkSj0rReMs6wUMdkgawQJduE6glcaZ3M/JJNhVwkt47v2fVBPJJfVKzDv432mw
         ycNE8i27pktwDKHPaeE2/BEh+ZLyMzY1uorEcKg6cQpuYDvvKsZZX6cRFcxS930xQ9d7
         b8c+P0Fv6oahC72K3eG1xJ5V1UetdetBoEL4CBnzGBvSKpvc9X19XtU0Q+vE8Xasm3lM
         /ZqXjKMndFB856wEA0onmOGrGXS8RRGDJMN9GI9tSFRS+3XK2LyYguZgjEMzZEINky13
         ww7r+oMl/P05KRjXICcDy7c1Zy7mFiQEGlESv+q9v67NuzTKadDw9o0BaUecJJySfyUe
         LNVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tRc1wFGoADt31h04bCok03WJLaNfqn/3kUZGVULqzzQ=;
        b=Oco+kT1mpL+EtKythhWSuPPJCs4Ac0WDrmZXpagey+BdqEXriuA2QtFUclS1sYDwy2
         12bS34cky/cgQ7/IOOZKi0/OzXZ0U/qOxmstFppHKCPUh5g91UKKEI+2pi3U8JKWY0qj
         7zRxw+mviEBJCzJEE/q/YkAkMaRCXysR2XXlAa7pm8xsFXseiJADG7Mx07YyW36KK6l5
         VKRCBVp24MBLsYo6/SZUmoHh0dPP/stai+ViuCQZhuylJ8dByBRjxHTln9xSPDBRAeVZ
         ksusIFjBVV94seg/Ct1DGqhBb6KbOYcmngSMl8BhpF9xBUfqp3KhEUD2/WT61930pzEE
         J19A==
X-Gm-Message-State: AGi0PuYgMgLIZHmY2Z9jxPSixozMUpq1i0w8SDte8PQgUabFEwc3dARn
        S/iPaBrP4GJwUMQv1wiYm82iY5csJs8kbAm8tSk=
X-Google-Smtp-Source: APiQypJ9ewqTeRIergKcspUnlfNfDA/Isven7yFAosfVEH3inHBXuq+mw/Q2T5qLTRjRDQYvID21eFcXo7IpnBuaqco=
X-Received: by 2002:a1c:f211:: with SMTP id s17mr17073649wmc.168.1588935264569;
 Fri, 08 May 2020 03:54:24 -0700 (PDT)
MIME-Version: 1.0
References: <1588500367-1056-1-git-send-email-chenhc@lemote.com> <1588500367-1056-8-git-send-email-chenhc@lemote.com>
In-Reply-To: <1588500367-1056-8-git-send-email-chenhc@lemote.com>
From:   Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Date:   Fri, 8 May 2020 12:53:35 +0200
Message-ID: <CAHiYmc4auUtJayvB-qTFNsv5BGhe0FaTTRxODZLw+yNRzwHB_Q@mail.gmail.com>
Subject: Re: [PATCH V3 07/14] KVM: MIPS: Use root tlb to control guest's CCA
 for Loongson-3
To:     Huacai Chen <chenhc@lemote.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        kvm@vger.kernel.org, QEMU Developers <qemu-devel@nongnu.org>,
        linux-mips@vger.kernel.org,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

=D0=BD=D0=B5=D0=B4, 3. =D0=BC=D0=B0=D1=98 2020. =D1=83 12:12 Huacai Chen <c=
henhc@lemote.com> =D1=98=D0=B5 =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BE/=
=D0=BB=D0=B0:
>
> KVM guest has two levels of address translation: guest tlb translates
> GVA to GPA, and root tlb translates GPA to HPA. By default guest's CCA
> is controlled by guest tlb, but Loongson-3 maintains all cache coherency
> by hardware (including multi-core coherency and I/O DMA coherency) so it
> prefers all guest mappings be cacheable mappings. Thus, we use root tlb
> to control guest's CCA for Loongson-3.
>
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---
>  arch/mips/kvm/vz.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
> index 422cd06..f9fbbc16 100644
> --- a/arch/mips/kvm/vz.c
> +++ b/arch/mips/kvm/vz.c
> @@ -2871,6 +2871,12 @@ static int kvm_vz_hardware_enable(void)
>         if (cpu_has_guestctl2)
>                 clear_c0_guestctl2(0x3f << 10);
>
> +#ifdef CONFIG_CPU_LOONGSON64
> +       /* Control guest CCA attribute */
> +       if (cpu_has_csr())
> +               csr_writel(csr_readl(0xffffffec) | 0x1, 0xffffffec);
> +#endif
> +
>         return 0;
>  }
>
> --
> 2.7.0
>

Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
