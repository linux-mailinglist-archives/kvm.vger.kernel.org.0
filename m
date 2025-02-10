Return-Path: <kvm+bounces-37671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 36D9EA2E2F6
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 04:58:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 142123A51EB
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 03:58:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD06613AA41;
	Mon, 10 Feb 2025 03:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y3vdixJ9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F6C24337C;
	Mon, 10 Feb 2025 03:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739159914; cv=none; b=mA07/N92TraQdj2+LBIlpQEYHOuafgIu6QuLhASkYOGzyLPcQ5atwPGdHnvX1lD2zVRifcn7h8SHuoIW9PiulVD6z0pPD+b/x0EmGxGJiZeSPF8RjJAk/cBmIE0boihjy6Llwnd0FTJnBLloCHOXY6oRgO2+f1X+idFEgh5L/dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739159914; c=relaxed/simple;
	bh=eFEOFJW334jyZcovU+emYRencSopZhzN6Nl+8Tf89ro=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d7gA1GQtU4MK3fDe/OdnBAxqBsdSw23o2rfzrc+uQweQMMSEY3+MnYlD7jsy/cvgIrIE+lVzMKV8U3KDUKXd+gnoAYFdVyibIWVAGrqMUkJ6175wfcTH1GY7jhKrse7uHY5Zn10tETvbNxtMSB03m3fAo9Legr2r/OsLy+8Kujw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y3vdixJ9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6C3C4CEE4;
	Mon, 10 Feb 2025 03:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739159913;
	bh=eFEOFJW334jyZcovU+emYRencSopZhzN6Nl+8Tf89ro=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Y3vdixJ9W0gCLIg6IdxkVfe+Inku1hv7CiKB4EAXwBNKtSFf7dzyqe3hrE+Iqcjsz
	 ha+10+IjeSkm/qEiSbzwXQJZpKUeQCnacVNwUrxkGBfxa5Y3UOQTLsJqxMC8nCNgcy
	 WeEM6fdaytUYAs4wCxfRR9OE8gUQFYFZd2IM9LXFdf/h8QmecT678cPAU7tchcUhHy
	 yMki/b+En6orWGXv9CYuSKCoPzj8JCuGmRJeJrFIWeZOuINZxZXfdpoFaVK64wrr0l
	 IGmJUmbBa1poS1IU0eR/LFKYjQ+w+/LSXkP6+oMXuTveEuLHVQqApRuVIow/y+sNQ0
	 z+ncK7ViSpXdA==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-ab78d9c5542so446652266b.1;
        Sun, 09 Feb 2025 19:58:33 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVmL0zTG5y8atXe8uP22AwtT2dQUvMau8dS0Xb+DXURUWaEQoNkhj0M3LAB8g3DHr+nBnw2D36x0nobjuAF@vger.kernel.org, AJvYcCXs0Lu/51iA6DAsp7tAjiNPNP1UiihIQo4qgtFc994UAawDTve/3ElKvnbx2/Hbz0X/MWQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIRE7E6WVixQp90d4+DswPxFSn4Brbo2q+Knkrw7QhVvPzqHfv
	xffVp0QcAJQHzv2l4a70x3UcGWJLjYzwDVHUfoBjEnAIi/I6Lw/6VY4AMJEvOmCqcv9wLFZ3i4B
	jJvFtX73dHl5rt5OuIKHyvyLEj6Q=
X-Google-Smtp-Source: AGHT+IHsM2XDBBQpSKjFBxSpJSPgNNPJClqmpaAYB/PsC80+dF+8lDtI/MarpS97QsP6XrzNq75IXuraWPJfVtZLPu0=
X-Received: by 2002:a17:907:9815:b0:aa6:6c46:7ca1 with SMTP id
 a640c23a62f3a-ab789a688c0mr1158542966b.10.1739159912059; Sun, 09 Feb 2025
 19:58:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250207032634.2333300-1-maobibo@loongson.cn> <20250207032634.2333300-2-maobibo@loongson.cn>
 <CAAhV-H7p9G8At3Pz_o31u_Zpho2gfbe6WOxF6_WpebVfcfgaKQ@mail.gmail.com> <30caead6-5b12-638c-677d-dc1111aea43c@loongson.cn>
In-Reply-To: <30caead6-5b12-638c-677d-dc1111aea43c@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 10 Feb 2025 11:58:22 +0800
X-Gmail-Original-Message-ID: <CAAhV-H43Y4-oN9SVDWBhQ7nunYS08r5at+hVbtsdbWmKGDBMZw@mail.gmail.com>
X-Gm-Features: AWEUYZkKen1ccP4U4UifU7lsJQI4UfvIramv-tzZg9dkEHhMx_3c6BGGJNyUOHA
Message-ID: <CAAhV-H43Y4-oN9SVDWBhQ7nunYS08r5at+hVbtsdbWmKGDBMZw@mail.gmail.com>
Subject: Re: [PATCH 1/3] LoongArch: KVM: Fix typo issue about GCFG feature detection
To: bibo mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 10, 2025 at 9:42=E2=80=AFAM bibo mao <maobibo@loongson.cn> wrot=
e:
>
>
>
> On 2025/2/9 =E4=B8=8B=E5=8D=885:38, Huacai Chen wrote:
> > Hi, Bibo,
> >
> > On Fri, Feb 7, 2025 at 11:26=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> =
wrote:
> >>
> >> This is typo issue about GCFG feature macro, comments is added for
> >> these macro and typo issue is fixed here.
> >>
> >> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >> ---
> >>   arch/loongarch/include/asm/loongarch.h | 26 ++++++++++++++++++++++++=
++
> >>   arch/loongarch/kvm/main.c              |  4 ++--
> >>   2 files changed, 28 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/i=
nclude/asm/loongarch.h
> >> index 52651aa0e583..1a65b5a7d54a 100644
> >> --- a/arch/loongarch/include/asm/loongarch.h
> >> +++ b/arch/loongarch/include/asm/loongarch.h
> >> @@ -502,49 +502,75 @@
> >>   #define LOONGARCH_CSR_GCFG             0x51    /* Guest config */
> >>   #define  CSR_GCFG_GPERF_SHIFT          24
> >>   #define  CSR_GCFG_GPERF_WIDTH          3
> >> +/* Number PMU register started from PM0 passthrough to VM */
> >>   #define  CSR_GCFG_GPERF                        (_ULCAST_(0x7) << CSR=
_GCFG_GPERF_SHIFT)
> >> +#define  CSR_GCFG_GPERFP_SHIFT         23
> >> +/* Read-only bit: show PMU passthrough supported or not */
> >> +#define  CSR_GCFG_GPERFP               (_ULCAST_(0x1) << CSR_GCFG_GPE=
RFP_SHIFT)
> >>   #define  CSR_GCFG_GCI_SHIFT            20
> >>   #define  CSR_GCFG_GCI_WIDTH            2
> >>   #define  CSR_GCFG_GCI                  (_ULCAST_(0x3) << CSR_GCFG_GC=
I_SHIFT)
> >> +/* All cacheop instructions will trap to host */
> >>   #define  CSR_GCFG_GCI_ALL              (_ULCAST_(0x0) << CSR_GCFG_GC=
I_SHIFT)
> >> +/* Cacheop instruction except hit invalidate will trap to host */
> >>   #define  CSR_GCFG_GCI_HIT              (_ULCAST_(0x1) << CSR_GCFG_GC=
I_SHIFT)
> >> +/* Cacheop instruction except hit and index invalidate will trap to h=
ost */
> >>   #define  CSR_GCFG_GCI_SECURE           (_ULCAST_(0x2) << CSR_GCFG_GC=
I_SHIFT)
> >>   #define  CSR_GCFG_GCIP_SHIFT           16
> >>   #define  CSR_GCFG_GCIP                 (_ULCAST_(0xf) << CSR_GCFG_GC=
IP_SHIFT)
> >> +/* Read-only bit: show feature CSR_GCFG_GCI_ALL supported or not */
> >>   #define  CSR_GCFG_GCIP_ALL             (_ULCAST_(0x1) << CSR_GCFG_GC=
IP_SHIFT)
> >> +/* Read-only bit: show feature CSR_GCFG_GCI_HIT supported or not */
> >>   #define  CSR_GCFG_GCIP_HIT             (_ULCAST_(0x1) << (CSR_GCFG_G=
CIP_SHIFT + 1))
> >> +/* Read-only bit: show feature CSR_GCFG_GCI_SECURE supported or not *=
/
> >>   #define  CSR_GCFG_GCIP_SECURE          (_ULCAST_(0x1) << (CSR_GCFG_G=
CIP_SHIFT + 2))
> >>   #define  CSR_GCFG_TORU_SHIFT           15
> >> +/* Operation with CSR register unimplemented will trap to host */
> >>   #define  CSR_GCFG_TORU                 (_ULCAST_(0x1) << CSR_GCFG_TO=
RU_SHIFT)
> >>   #define  CSR_GCFG_TORUP_SHIFT          14
> >> +/* Read-only bit: show feature CSR_GCFG_TORU supported or not */
> >>   #define  CSR_GCFG_TORUP                        (_ULCAST_(0x1) << CSR=
_GCFG_TORUP_SHIFT)
> >>   #define  CSR_GCFG_TOP_SHIFT            13
> >> +/* Modificattion with CRMD.PLV will trap to host */
> >>   #define  CSR_GCFG_TOP                  (_ULCAST_(0x1) << CSR_GCFG_TO=
P_SHIFT)
> >>   #define  CSR_GCFG_TOPP_SHIFT           12
> >> +/* Read-only bit: show feature CSR_GCFG_TOP supported or not */
> >>   #define  CSR_GCFG_TOPP                 (_ULCAST_(0x1) << CSR_GCFG_TO=
PP_SHIFT)
> >>   #define  CSR_GCFG_TOE_SHIFT            11
> >> +/* ertn instruction will trap to host */
> >>   #define  CSR_GCFG_TOE                  (_ULCAST_(0x1) << CSR_GCFG_TO=
E_SHIFT)
> >>   #define  CSR_GCFG_TOEP_SHIFT           10
> >> +/* Read-only bit: show feature CSR_GCFG_TOE supported or not */
> >>   #define  CSR_GCFG_TOEP                 (_ULCAST_(0x1) << CSR_GCFG_TO=
EP_SHIFT)
> >>   #define  CSR_GCFG_TIT_SHIFT            9
> >> +/* Timer instruction such as rdtime/TCFG/TVAL will trap to host */
> >>   #define  CSR_GCFG_TIT                  (_ULCAST_(0x1) << CSR_GCFG_TI=
T_SHIFT)
> >>   #define  CSR_GCFG_TITP_SHIFT           8
> >> +/* Read-only bit: show feature CSR_GCFG_TIT supported or not */
> >>   #define  CSR_GCFG_TITP                 (_ULCAST_(0x1) << CSR_GCFG_TI=
TP_SHIFT)
> >>   #define  CSR_GCFG_SIT_SHIFT            7
> >> +/* All privilege instruction will trap to host */
> >>   #define  CSR_GCFG_SIT                  (_ULCAST_(0x1) << CSR_GCFG_SI=
T_SHIFT)
> >>   #define  CSR_GCFG_SITP_SHIFT           6
> >> +/* Read-only bit: show feature CSR_GCFG_SIT supported or not */
> >>   #define  CSR_GCFG_SITP                 (_ULCAST_(0x1) << CSR_GCFG_SI=
TP_SHIFT)
> >>   #define  CSR_GCFG_MATC_SHITF           4
> >>   #define  CSR_GCFG_MATC_WIDTH           2
> >>   #define  CSR_GCFG_MATC_MASK            (_ULCAST_(0x3) << CSR_GCFG_MA=
TC_SHITF)
> >> +/* Cache attribute comes from GVA->GPA mapping */
> >>   #define  CSR_GCFG_MATC_GUEST           (_ULCAST_(0x0) << CSR_GCFG_MA=
TC_SHITF)
> >> +/* Cache attribute comes from GPA->HPA mapping */
> >>   #define  CSR_GCFG_MATC_ROOT            (_ULCAST_(0x1) << CSR_GCFG_MA=
TC_SHITF)
> >> +/* Cache attribute comes from weaker one of GVA->GPA and GPA->HPA map=
ping */
> >>   #define  CSR_GCFG_MATC_NEST            (_ULCAST_(0x2) << CSR_GCFG_MA=
TC_SHITF)
> >>   #define  CSR_GCFG_MATP_NEST_SHIFT      2
> >> +/* Read-only bit: show feature CSR_GCFG_MATC_NEST supported or not */
> >>   #define  CSR_GCFG_MATP_NEST            (_ULCAST_(0x1) << CSR_GCFG_MA=
TP_NEST_SHIFT)
> >>   #define  CSR_GCFG_MATP_ROOT_SHIFT      1
> >> +/* Read-only bit: show feature CSR_GCFG_MATC_ROOT supported or not */
> >>   #define  CSR_GCFG_MATP_ROOT            (_ULCAST_(0x1) << CSR_GCFG_MA=
TP_ROOT_SHIFT)
> >>   #define  CSR_GCFG_MATP_GUEST_SHIFT     0
> >> +/* Read-only bit: show feature CSR_GCFG_MATC_GUEST suppoorted or not =
*/
> >>   #define  CSR_GCFG_MATP_GUEST           (_ULCAST_(0x1) << CSR_GCFG_MA=
TP_GUEST_SHIFT)
> > Bugfix is the majority here, so it is better to remove the comments,
> > make this patch easier to be backported to stable branches.
> How about split the patch into two for better backporting? With comments
> it is convinient to people to understand and provide LoongArch KVM
> patches in future, after all it cannot depends on the few guys inside.
I don't suggest splitting, just removing it is better (developers
still need to read the user manual even if there are such comments).
But if you insist, then keep it as is (keep this version).



Huacai
>
> Regards
> Bibo Mao
> >
> > Huacai
> >
> >>
> >>   #define LOONGARCH_CSR_GINTC            0x52    /* Guest interrupt co=
ntrol */
> >> diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
> >> index bf9268bf26d5..f6d3242b9234 100644
> >> --- a/arch/loongarch/kvm/main.c
> >> +++ b/arch/loongarch/kvm/main.c
> >> @@ -303,9 +303,9 @@ int kvm_arch_enable_virtualization_cpu(void)
> >>           * TOE=3D0:       Trap on Exception.
> >>           * TIT=3D0:       Trap on Timer.
> >>           */
> >> -       if (env & CSR_GCFG_GCIP_ALL)
> >> +       if (env & CSR_GCFG_GCIP_SECURE)
> >>                  gcfg |=3D CSR_GCFG_GCI_SECURE;
> >> -       if (env & CSR_GCFG_MATC_ROOT)
> >> +       if (env & CSR_GCFG_MATP_ROOT)
> >>                  gcfg |=3D CSR_GCFG_MATC_ROOT;
> >>
> >>          write_csr_gcfg(gcfg);
> >> --
> >> 2.39.3
> >>
>
>

