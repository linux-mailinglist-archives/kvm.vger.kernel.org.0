Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 999F01CA8CF
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 12:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgEHK4E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 06:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726761AbgEHK4D (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 May 2020 06:56:03 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B590C05BD43;
        Fri,  8 May 2020 03:56:02 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x17so1343755wrt.5;
        Fri, 08 May 2020 03:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lthHnKv1xa7dAMrPglbDildZVLksCVCONvJYe6xZSkM=;
        b=rFuaDDjuIxkm3BEAh39hhXMNZEKBSZom2kyRejJhylcVac4esFQiv4lkl3zuEXgw/7
         RMoDPBwnrQ9D/NIIBK6Cp9Y6Z7tM6ml1pnuus6J3k+m700UG+CvtBYIfGCO/QZWDQxgw
         9d6JvukiWhq6Jfyi5iEC5lI3BFUyqi2igZ4C+nJWwBDSXA4/Ag2tZVWMTxjoOuSWFVA3
         u4gKyJIJxRCXYsGjFm4ijwFHb2snu6vm+1TYL5zm949FiGMmXSR29Xm4noiAUJZL1w8h
         G3JmoWrAOdlKRSo6CvM3t0EVkcYUznX4PTIOEZ1lPpF1P3vqqr7Pz7rtdphmQkH4rHcD
         REIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lthHnKv1xa7dAMrPglbDildZVLksCVCONvJYe6xZSkM=;
        b=s16HCijrvruh3MVYmwOOOAxExFy6PEi5NKKikYH1vflWKq76vS96/YK5j1yEkwwWYQ
         L2rSDPAds+oQQAJ7isVun6TAlLWd1G+AJW28wF3zzlHhjeOKyylsGUscYVY0K25GlweK
         RBcxGxmApC9bOSybcVe/Pf92qBngc1Fk1g70g2jsjrONRLghZk/uTsTLdMqie+y+D2Jz
         pgImASppgCE5Ix2CM0s5pwcXHb44oNW2J8r/EeppX4VT/vG2TQiNFov5Nhj41k5vJANo
         n1Uq+7zB+H/ePuPptHzLbEHgCtXEmnZA1hpgES/oT//cmiVF3LU3ypoyRd1Fo9fY/1Ow
         jROg==
X-Gm-Message-State: AGi0PuYwFelhArV6FzsQxK+BoZPDpW83ShuzH06G2793N7/Fbuc7eM0N
        QcpfIe3jOK3PV1UzcvaAZR8tCZYL1uEMGciS0jI=
X-Google-Smtp-Source: APiQypIIMIfUa+K2nKmANtc3Gp+42ZJ4YJxs91z7+lmWMPX2JbO8AkvjFrQVzZZGb8eWQl1f1YghymmN2lZW1j0n1+I=
X-Received: by 2002:adf:dc50:: with SMTP id m16mr2307167wrj.329.1588935360993;
 Fri, 08 May 2020 03:56:00 -0700 (PDT)
MIME-Version: 1.0
References: <1588500367-1056-1-git-send-email-chenhc@lemote.com> <1588500367-1056-9-git-send-email-chenhc@lemote.com>
In-Reply-To: <1588500367-1056-9-git-send-email-chenhc@lemote.com>
From:   Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Date:   Fri, 8 May 2020 12:55:34 +0200
Message-ID: <CAHiYmc65ctQgGicSJ4sB+pC1ZaGGLbJi7QWAERs2jDZb_8rWEg@mail.gmail.com>
Subject: Re: [PATCH V3 08/14] KVM: MIPS: Let indexed cacheops cause guest exit
 on Loongson-3
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

=D0=BD=D0=B5=D0=B4, 3. =D0=BC=D0=B0=D1=98 2020. =D1=83 12:13 Huacai Chen <c=
henhc@lemote.com> =D1=98=D0=B5 =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BE/=
=D0=BB=D0=B0:
>
> Loongson-3's indexed cache operations need a node-id in the address,
> but in KVM guest the node-id may be incorrect. So, let indexed cache
> operations cause guest exit on Loongson-3.
>
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---
>  arch/mips/kvm/vz.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
> index f9fbbc16..ab320f0 100644
> --- a/arch/mips/kvm/vz.c
> +++ b/arch/mips/kvm/vz.c
> @@ -2853,8 +2853,12 @@ static int kvm_vz_hardware_enable(void)
>         write_c0_guestctl0(MIPS_GCTL0_CP0 |
>                            (MIPS_GCTL0_AT_GUEST << MIPS_GCTL0_AT_SHIFT) |
>                            MIPS_GCTL0_CG | MIPS_GCTL0_CF);
> -       if (cpu_has_guestctl0ext)
> -               set_c0_guestctl0ext(MIPS_GCTL0EXT_CGI);
> +       if (cpu_has_guestctl0ext) {
> +               if (current_cpu_type() !=3D CPU_LOONGSON64)
> +                       set_c0_guestctl0ext(MIPS_GCTL0EXT_CGI);
> +               else
> +                       clear_c0_guestctl0ext(MIPS_GCTL0EXT_CGI);
> +       }
>
>         if (cpu_has_guestid) {
>                 write_c0_guestctl1(0);
> --
> 2.7.0
>

Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
