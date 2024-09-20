Return-Path: <kvm+bounces-27204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B011A97D2CD
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 10:35:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D4D72829CA
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 08:35:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB4307E107;
	Fri, 20 Sep 2024 08:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="HRvOPU+G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4757A3CF6A
	for <kvm@vger.kernel.org>; Fri, 20 Sep 2024 08:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726821301; cv=none; b=lxWw4qBdyOnwcRGbqpacxkTDfgRs4ihPQ98o6LOQKioYqwKq8cfeXKBn+gmgB9SJjGvkfTCiOSuio/Pt9wesrPow3gq7+aoDUpMepEUwQhBGN7vSKmArZWUanAtckjb0UBJ5TFfcXQ3tcdOGLv06XV0e1dqpc3yjYYs1JJM4zVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726821301; c=relaxed/simple;
	bh=I79psXUWQ0+2Lm/txwfde2VUpAtrxO/m/za3/igBxQI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YQjf64/xA8p3+Y00gmgXCI4wwRDMBI5HQV2xj/wKQAtdamvYF/HqvwJSbAjJ7Rl6zMSDxmGpLfD6Pad6Zulp+ZI9nEsfp4iCfXenn67c9LMrshFpGdZWn21OWBW4tOpZrmc6DakB5X14J6LFwsQ0fZ1QzS+w0PzTNsQlLG+vOmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=HRvOPU+G; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-82a151a65b8so86171439f.2
        for <kvm@vger.kernel.org>; Fri, 20 Sep 2024 01:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1726821298; x=1727426098; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xMiWTjaHnHS0JzzbhnLCVrfpCgiv+dcBe7V+IIK3140=;
        b=HRvOPU+G/4MCwYeh1LKmFC6J0A4ZTI10CRaqIec25BarEYyc6ltn1FuQwNW8N+hWqy
         Ip0BgIcPGSaGP+isDk32oyRWZQDT0Bxxo0WMGJYQ57AKmC6ahrnCPA74hvaS/beS5IaE
         IAS+2yMqy/OYicy0hauYXtwf9DBA9tP3g6K8KHdu5wIfDgVK1hdjjHZorkdvt8UqBQ7m
         LHKkCDZKTHrX1tj7X3Qbzun6EFGu7A//KL+XDv+JqcfYFRRwO8Kfi84lMdUaIRoRB8gs
         byWrGSz0OAVS9aEmYL85gvfIVPgRhq85/ndsRLT6rqvOp2kPL1XpsotpIGofiVheMoG8
         CQYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726821298; x=1727426098;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xMiWTjaHnHS0JzzbhnLCVrfpCgiv+dcBe7V+IIK3140=;
        b=QmLi0k+8ZWL/TZbNvb0GZQzBD7BSWBNOyn16+O2UKBZ5k6IWfYPGzTYoK2KsfjVvwL
         Tf0xDh+4d+4IatWIYJiFsjqyblGe15caffdvtBcFOTrKMVuDjiC2bDgtaw6S5Cis+QKs
         1cCw/t51uda809nUvn+D4lKCZuJpxWliHeXPWAX3KbKV8SWRak6rSmKwMni6sfmKjKDY
         xbLR18daiHxa6pqESA5VJSsaWkbGQhXR/eTCgBCufBqPKrGMjH7G+4pHkZHZZSkpeu5l
         nVcyzrkuUmIYIVxzL66GVUQziZCZs56c6YP0undPtcHHLVKAGCQ0so1Oo27iJydps/0k
         qmuQ==
X-Forwarded-Encrypted: i=1; AJvYcCWw0mudCphaMBfsZwnVLP/2kDNUGJIFZedpWjhoTTgXPBJk9X6nLfADvnaoKmfxZgpk/lY=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywx/1RW9OUNHuNBTdRZGLGyJ3nQuQAImXUD/C5En0muZkIdetAr
	hoOnVhzwHPwE/GnHPVeosjy2JdRvm5XyfXbkJdUmQprrCUWJRnqDWb5lQm7NBWZpTTVCdF1/+jE
	AFLong9lcHL/Qm0ujNBa6mQK56wiyLUp6YGl0sA==
X-Google-Smtp-Source: AGHT+IHq6B1rRJenopqNmyWR6VL8HDws3rxiWv+qj9OzdKYH3N6807kKyhX5RCCNU3zx9rqm2laOp98JD8OY2gJr63k=
X-Received: by 2002:a05:6e02:1aa3:b0:3a0:a21c:d2b2 with SMTP id
 e9e14a558f8ab-3a0c8ca7795mr25933665ab.11.1726821298213; Fri, 20 Sep 2024
 01:34:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy05BXUZu6BNUoDWoEVd_YiM0Dpqg=t5WYUX7+cacnO2Hg@mail.gmail.com>
 <mhng-1e3d83bb-a7f4-4fa7-8cfa-2550835026de@palmer-ri-x1c9>
In-Reply-To: <mhng-1e3d83bb-a7f4-4fa7-8cfa-2550835026de@palmer-ri-x1c9>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 20 Sep 2024 14:04:47 +0530
Message-ID: <CAAhSdy08j_noBGi2CRf0oLBxFnmk983W24oQezmdg1pw6pFksQ@mail.gmail.com>
Subject: Re: [PATCH v8 0/5] Add Svade and Svadu Extensions Support
To: Palmer Dabbelt <palmer@rivosinc.com>
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, greentime.hu@sifive.com, 
	vincent.chen@sifive.com, yongxuan.wang@sifive.com, 
	Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 20, 2024 at 1:53=E2=80=AFPM Palmer Dabbelt <palmer@rivosinc.com=
> wrote:
>
> On Wed, 21 Aug 2024 07:43:20 PDT (-0700), anup@brainfault.org wrote:
> > Hi Palmer,
> >
> > On Fri, Jul 26, 2024 at 2:19=E2=80=AFPM Yong-Xuan Wang <yongxuan.wang@s=
ifive.com> wrote:
> >>
> >> Svade and Svadu extensions represent two schemes for managing the PTE =
A/D
> >> bit. When the PTE A/D bits need to be set, Svade extension intdicates =
that
> >> a related page fault will be raised. In contrast, the Svadu extension
> >> supports hardware updating of PTE A/D bits. This series enables Svade =
and
> >> Svadu extensions for both host and guest OS.
> >>
> >> Regrading the mailing thread[1], we have 4 possible combinations of
> >> these extensions in the device tree, the default hardware behavior for
> >> these possibilities are:
> >> 1) Neither Svade nor Svadu present in DT =3D> It is technically
> >>    unknown whether the platform uses Svade or Svadu. Supervisor
> >>    software should be prepared to handle either hardware updating
> >>    of the PTE A/D bits or page faults when they need updated.
> >> 2) Only Svade present in DT =3D> Supervisor must assume Svade to be
> >>    always enabled.
> >> 3) Only Svadu present in DT =3D> Supervisor must assume Svadu to be
> >>    always enabled.
> >> 4) Both Svade and Svadu present in DT =3D> Supervisor must assume
> >>    Svadu turned-off at boot time. To use Svadu, supervisor must
> >>    explicitly enable it using the SBI FWFT extension.
> >>
> >> The Svade extension is mandatory and the Svadu extension is optional i=
n
> >> RVA23 profile. Platforms want to take the advantage of Svadu can choos=
e
> >> 3. Those are aware of the profile can choose 4, and Linux won't get th=
e
> >> benefit of svadu until the SBI FWFT extension is available.
> >>
> >> [1] https://lore.kernel.org/linux-kernel/20240527-e9845c06619bca5cd285=
098c@orel/T/#m29644eb88e241ec282df4ccd5199514e913b06ee
> >>
> >> ---
> >> v8:
> >> - fix typo in PATCH1 (Samuel)
> >> - use the new extension validating API in PATCH1 (Cl=C3=A9ment)
> >> - update the dtbinding in PATCH2 (Samuel, Conor)
> >> - add PATCH4 to fix compile error in get-reg-list test.
> >>
> >> v7:
> >> - fix alignment in PATCH1
> >> - update the dtbinding in PATCH2 (Conor, Jessica)
> >>
> >> v6:
> >> - reflect the platform's behavior by riscv_isa_extension_available() a=
nd
> >>   update the the arch_has_hw_pte_young() in PATCH1 (Conor, Andrew)
> >> - update the dtbinding in PATCH2 (Alexandre, Andrew, Anup, Conor)
> >> - update the henvcfg condition in PATCH3 (Andrew)
> >> - check if Svade is allowed to disabled based on arch_has_hw_pte_young=
()
> >>   in PATCH3
> >>
> >> v5:
> >> - remove all Acked-by and Reviewed-by (Conor, Andrew)
> >> - add Svade support
> >> - update the arch_has_hw_pte_young() in PATCH1
> >> - update the dtbinding in PATCH2 (Alexandre, Andrew)
> >> - check the availibility of Svadu for Guest/VM based on
> >>   arch_has_hw_pte_young() in PATCH3
> >>
> >> v4:
> >> - fix 32bit kernel build error in PATCH1 (Conor)
> >> - update the status of Svadu extension to ratified in PATCH2
> >> - add the PATCH4 to suporrt SBI_FWFT_PTE_AD_HW_UPDATING for guest OS
> >> - update the PATCH1 and PATCH3 to integrate with FWFT extension
> >> - rebase PATCH5 on the lastest get-reg-list test (Andrew)
> >>
> >> v3:
> >> - fix the control bit name to ADUE in PATCH1 and PATCH3
> >> - update get-reg-list in PATCH4
> >>
> >> v2:
> >> - add Co-developed-by: in PATCH1
> >> - use riscv_has_extension_unlikely() to runtime patch the branch in PA=
TCH1
> >> - update dt-binding
> >>
> >> Yong-Xuan Wang (5):
> >>   RISC-V: Add Svade and Svadu Extensions Support
> >>   dt-bindings: riscv: Add Svade and Svadu Entries
> >>   RISC-V: KVM: Add Svade and Svadu Extensions Support for Guest/VM
> >>   KVM: riscv: selftests: Fix compile error
> >>   KVM: riscv: selftests: Add Svade and Svadu Extension to get-reg-list
> >>     test
> >>
> >>  .../devicetree/bindings/riscv/extensions.yaml | 28 ++++++++++++++++++=
+
> >>  arch/riscv/Kconfig                            |  1 +
> >>  arch/riscv/include/asm/csr.h                  |  1 +
> >>  arch/riscv/include/asm/hwcap.h                |  2 ++
> >>  arch/riscv/include/asm/pgtable.h              | 13 ++++++++-
> >>  arch/riscv/include/uapi/asm/kvm.h             |  2 ++
> >>  arch/riscv/kernel/cpufeature.c                | 12 ++++++++
> >>  arch/riscv/kvm/vcpu.c                         |  4 +++
> >>  arch/riscv/kvm/vcpu_onereg.c                  | 15 ++++++++++
> >>  .../selftests/kvm/riscv/get-reg-list.c        | 16 ++++++++---
> >>  10 files changed, 89 insertions(+), 5 deletions(-)
> >>
> >> --
> >> 2.17.1
> >>
> >>
> >
> > Let me know if this series can be taken through the KVM RISC-V tree.
> > I can provide you with a shared tag as well.
>
> I think the patchwork bot got confused by patch 4 going to fixes?  It
> says this was merged.
>
> Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
>
> if you still want to take it, otherwise just LMK and I'll pick it up.
>

I already sent KVM RISC-V PR for 6.12 which has been merged
as well. Please take this series (except PATCH4) through the
RISC-V tree.

Thanks,
Anup

