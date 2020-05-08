Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9647B1CA886
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 12:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgEHKrk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 06:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727067AbgEHKrk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 May 2020 06:47:40 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F6CC05BD43;
        Fri,  8 May 2020 03:47:38 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id i15so1300727wrx.10;
        Fri, 08 May 2020 03:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=k49C5zyuYWcuoY4kwjTau665FvHnQw5Q4jQ2RG6JlUs=;
        b=QguEcWV+11prMAuzF3jYEYwv5SxpfNZG2xQkTu11plqRp90UWMVo0aJa3HsD/iZFX8
         +WP/EuT13v01+If9nilD7Y9tX+8j4BtM86jUgNPW+OLFuoYNG8aDGRWiRLH7xGQPxG/8
         Y6pwl8sULQb4XOK1Y/P9TPGB0hnybV1E+FVKK4HpfIWNNo0MPZf9UoJhC6jeE+TujAd4
         gvFThLks4WjpZK3OEQoyGt32VkLrpEeNGRIOqN1X8uJeSr0yks9W5DPN+YuR0oLJbRE3
         VVujulFL+0Wio0rar075WJ39Lmc4alesuj7pQk9rHAk+D4H4ZcpT2HkwQiyocl2MMOuq
         5khg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=k49C5zyuYWcuoY4kwjTau665FvHnQw5Q4jQ2RG6JlUs=;
        b=nw2cmuDolrOl5G1lPADBNrCIZhNxJqCx5BRWWV8DFM5hZoeYR3LWK9N6y/pGuObuLD
         54RhRuaVInL6kibEOHsEnsSntUsTXrLnliov4O1+lQOuB4aud7so5UFTaj/RPHWarvRL
         gJ1wfxCm5E4RlqG/o7MADa3iVhUne7VDRRUfl4cSu32Ol1JwGLaBpd9dWCkFJs7qPhmd
         H0bVtFAXPoEVumAmMKLNWoIZWlWOOdyQAK9EXdtx1KaewBgN80xxDKYpFn9QrwT2rduq
         59jdbCqK/Ofzo7LpQKlB/ApDzeN7qcUuhuVr5bXbKGoDtGTkhjYtNrjNvoK9GQE7q6jt
         +YQA==
X-Gm-Message-State: AGi0Pualpd9NZWsri0vdx/QcEyIgCxixCurpDJPWP2BMs8v87FJ/uaFc
        mLD/TRtclAedDCy9DrmsUaOdH0RzK0G9KIt89/c=
X-Google-Smtp-Source: APiQypImQ782kwPY61AeIdZOXoSu5RXAc69bVqdP/Ob3z4w8gKoCL38Lf2ltKEyIaAFDNueYCjRRdJCrS8Nickb4kkY=
X-Received: by 2002:adf:94a6:: with SMTP id 35mr2213072wrr.420.1588934857318;
 Fri, 08 May 2020 03:47:37 -0700 (PDT)
MIME-Version: 1.0
References: <1588500367-1056-1-git-send-email-chenhc@lemote.com> <1588500367-1056-6-git-send-email-chenhc@lemote.com>
In-Reply-To: <1588500367-1056-6-git-send-email-chenhc@lemote.com>
From:   Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Date:   Fri, 8 May 2020 12:46:12 +0200
Message-ID: <CAHiYmc604JH9YVXMEVCFgrMvWqaAtWqWjF-iQjGTLZzpzC3dKA@mail.gmail.com>
Subject: Re: [PATCH V3 05/14] KVM: MIPS: Use lddir/ldpte instructions to
 lookup gpa_mm.pgd
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

=D0=BD=D0=B5=D0=B4, 3. =D0=BC=D0=B0=D1=98 2020. =D1=83 12:11 Huacai Chen <c=
henhc@lemote.com> =D1=98=D0=B5 =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BE/=
=D0=BB=D0=B0:
>
> Loongson-3 can use lddir/ldpte instuctions to accelerate page table
> walking, so use them to lookup gpa_mm.pgd.
>
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---
>  arch/mips/kvm/entry.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
>
> diff --git a/arch/mips/kvm/entry.c b/arch/mips/kvm/entry.c
> index 16e1c93..fd71694 100644
> --- a/arch/mips/kvm/entry.c
> +++ b/arch/mips/kvm/entry.c
> @@ -56,6 +56,7 @@
>  #define C0_BADVADDR    8, 0
>  #define C0_BADINSTR    8, 1
>  #define C0_BADINSTRP   8, 2
> +#define C0_PGD         9, 7
>  #define C0_ENTRYHI     10, 0
>  #define C0_GUESTCTL1   10, 4
>  #define C0_STATUS      12, 0
> @@ -307,7 +308,10 @@ static void *kvm_mips_build_enter_guest(void *addr)
>
>  #ifdef CONFIG_KVM_MIPS_VZ
>         /* Save normal linux process pgd (VZ guarantees pgd_reg is set) *=
/
> -       UASM_i_MFC0(&p, K0, c0_kscratch(), pgd_reg);
> +       if (cpu_has_ldpte)
> +               UASM_i_MFC0(&p, K0, C0_PWBASE);
> +       else
> +               UASM_i_MFC0(&p, K0, c0_kscratch(), pgd_reg);
>         UASM_i_SW(&p, K0, offsetof(struct kvm_vcpu_arch, host_pgd), K1);
>
>         /*
> @@ -469,8 +473,10 @@ void *kvm_mips_build_tlb_refill_exception(void *addr=
, void *handler)
>         u32 *p =3D addr;
>         struct uasm_label labels[2];
>         struct uasm_reloc relocs[2];
> +#ifndef CONFIG_CPU_LOONGSON64
>         struct uasm_label *l =3D labels;
>         struct uasm_reloc *r =3D relocs;
> +#endif
>
>         memset(labels, 0, sizeof(labels));
>         memset(relocs, 0, sizeof(relocs));
> @@ -490,6 +496,16 @@ void *kvm_mips_build_tlb_refill_exception(void *addr=
, void *handler)
>          */
>         preempt_disable();
>
> +#ifdef CONFIG_CPU_LOONGSON64
> +       UASM_i_MFC0(&p, K1, C0_PGD);
> +       uasm_i_lddir(&p, K0, K1, 3);  /* global page dir */
> +#ifndef __PAGETABLE_PMD_FOLDED
> +       uasm_i_lddir(&p, K1, K0, 1);  /* middle page dir */
> +#endif
> +       uasm_i_ldpte(&p, K1, 0);      /* even */
> +       uasm_i_ldpte(&p, K1, 1);      /* odd */
> +       uasm_i_tlbwr(&p);
> +#else
>         /*
>          * Now for the actual refill bit. A lot of this can be common wit=
h the
>          * Linux TLB refill handler, however we don't need to handle so m=
any
> @@ -512,6 +528,7 @@ void *kvm_mips_build_tlb_refill_exception(void *addr,=
 void *handler)
>         build_get_ptep(&p, K0, K1);
>         build_update_entries(&p, K0, K1);
>         build_tlb_write_entry(&p, &l, &r, tlb_random);
> +#endif
>
>         preempt_enable();
>
> --
> 2.7.0
>
Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
