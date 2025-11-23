Return-Path: <kvm+bounces-64298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CC26C7DBB7
	for <lists+kvm@lfdr.de>; Sun, 23 Nov 2025 06:23:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E773334CA96
	for <lists+kvm@lfdr.de>; Sun, 23 Nov 2025 05:23:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79A6C23EA97;
	Sun, 23 Nov 2025 05:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="eQYmvvnj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1136E23956E
	for <kvm@vger.kernel.org>; Sun, 23 Nov 2025 05:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763875381; cv=none; b=lQ/OQv6jl62B6S+v2QKaHQ0I/ysj5w8deI1jmrGCqSevUfaEdTLKaZ3Uu4n18W7fidaaL+VJZn1SP5+4FMlLj6OEDy1a+WmVTEj6KIswxJvqOHgKgm2MLFX91K7/ZZWq/jXgub0txOZH3QWc3ZSUGZI4/ixKQV/hKtuO1zRoUPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763875381; c=relaxed/simple;
	bh=G6bR0WIE9PKOlK24ZTg7gD7xwOrnUryX5KRCDuX7OLk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sO0UpCREDLXvVWYpdJ5ouWs7fSO2MJFC0MBlWyxprDAG7FupyA3n7476NU+KmPJrdj4Bzj09V0wFihyQ8RrjMeWp+urcBB3NEetB6QJ2Hyes3tzQbQYhQ+PYCz1gdZJn3ivtygOizChnmUo0Hz1o1XP0VDdr4MwNbHWpgL18Gvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=eQYmvvnj; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-433692bbe4fso17653825ab.0
        for <kvm@vger.kernel.org>; Sat, 22 Nov 2025 21:22:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1763875379; x=1764480179; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9M+bsitxdcyHBcSA8b07GYs4Cob261gapfpxGSvBT4Q=;
        b=eQYmvvnjl6zjQBI2sOLcvyYllsbatTgErIY/m3xmkE3HGWgVtgKEWRnoxJHpdONLKj
         bdjkjBdY6eqyze8L/hwgHbeAKMzYyLIDihzl8xi05zo91B9iskIl5foLBU/5cXNB2ZwF
         CZ01bSQds0mkc0Ou7CSNHR/1EgUQkoQmsHMOWJfOqqdHSGHL5/kArY2A9m8z37uGztj1
         tAG6RYKxhJgXLny2T/UuHHmgxlx0e9IWkoD/zL+8EZOth8Tr8BoNJljUXki1PwbZESfj
         COCYOI3SfOE67w0q5m/J45Q99rFXc0jxVgUKhos+7Mbsw6qRT6L9mhN6f+fa+8cqq3Nx
         PwOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763875379; x=1764480179;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9M+bsitxdcyHBcSA8b07GYs4Cob261gapfpxGSvBT4Q=;
        b=PrUNN0g+F/E8wefhsj5JYmFLPZhWm/UBlyKLEQL6pPzTDLYDQlTDr9x7zyrPD3QBeJ
         LV/Bz1t9saH77MVmchMimk2wqcdNvGdK4V9CRhvwz+elmexi2t25dZis/hoV93YW3qVL
         nUK3LLi5Jh1TB5tXxwHKZiZFEkBA2ZBeS2m9+l7/X/Nd1emY7ykmqmExIjaqMSMXVi+s
         SATsAEafxGSc81pDq5uMCoNdk5m8Y/SzirDckAuywyX+F9QnuI2FuDepzSENzOh2v5ie
         2b03Asze7Fa/7dIssWbGAUVyiY+A9gF85CG5Wh54sGPyle15LvD/3WSHpCKa1OkW+Its
         N0Xg==
X-Forwarded-Encrypted: i=1; AJvYcCXMVIQBr9aDjs5Ru5sX+Cg6zi4x3WeJjbj54SgrEg8Znd2CtLejTlc/z0biIMP2dpmqIko=@vger.kernel.org
X-Gm-Message-State: AOJu0YzaSR2YWahQOWq4x5XbOskJsoo0Eo7zIRqM7NDWhaLdYGkW19YI
	m9CaYgpifpRmvWEjH7A91FcSKlAzoiUGjmfK319ihrtvxwaYIkU9D3ToXWk4KHmJJ/9NMyCPMOv
	2qHRcQ/UqcaSyEYcown5RBn+wpQERFU4eJ/xYujhb/g==
X-Gm-Gg: ASbGncsecR8wd7yC6Bsor+iZIugkUJ07JCN4U9rwZ5G8d24bbm32G7JyQMWnTGoN+Gg
	qOW1gjk/FsS9jwP0Rdh7b8aPNUJulFRHrWSSW1IPAHFllIbpMndkU+CNRXdMWN1wbb8138sUz5R
	C71a7wV9GdfpSzJNvOGAoBilvFw9FmKaSWVl4v1wyZX+G8BZqBVvItoGgp17khLePGitvd1wgi0
	QXGhmWebtu58bQGLageHyx6KotvSKADeZ29Bw0VVu3LFbIuVWTJio4ID2oSkN6A0hb6GETvfhSj
	4QCF3Dl3HvjtdOBl/myHIqSTO8YrsQ==
X-Google-Smtp-Source: AGHT+IEeM18++lwaiORFJZl8Hjs+peRhie1yZlJt5sthIKBDB3m3u408rffnRcPQtJ+QKEExmaV3WTWoC+TcPLmKbAA=
X-Received: by 2002:a05:6e02:3f09:b0:433:7826:2b69 with SMTP id
 e9e14a558f8ab-435b8e4fcb7mr70415215ab.11.1763875379029; Sat, 22 Nov 2025
 21:22:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251121133543.46822-1-fangyu.yu@linux.alibaba.com>
In-Reply-To: <20251121133543.46822-1-fangyu.yu@linux.alibaba.com>
From: Anup Patel <anup@brainfault.org>
Date: Sun, 23 Nov 2025 10:52:46 +0530
X-Gm-Features: AWmQ_bmj4zuHx-QBwVeyguW577J_Oqmu-RcG3kza0f4RZhq14OWm6aCQT2gQVtM
Message-ID: <CAAhSdy2Y=qk27Khy+fzOCidop7+tNqoDb0CFwAJ_p090NV46vQ@mail.gmail.com>
Subject: Re: [PATCH v3] RISC-V: KVM: Fix guest page fault within HLV* instructions
To: fangyu.yu@linux.alibaba.com
Cc: atish.patra@linux.dev, pjw@kernel.org, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, alex@ghiti.fr, guoren@kernel.org, 
	ajones@ventanamicro.com, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 21, 2025 at 7:06=E2=80=AFPM <fangyu.yu@linux.alibaba.com> wrote=
:
>
> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>
> When executing HLV* instructions at the HS mode, a guest page fault
> may occur when a g-stage page table migration between triggering the
> virtual instruction exception and executing the HLV* instruction.
>
> This may be a corner case, and one simpler way to handle this is to
> re-execute the instruction where the virtual  instruction exception
> occurred, and the guest page fault will be automatically handled.
>
> Fixes: b91f0e4cb8a3 ("RISC-V: KVM: Factor-out instruction emulation into =
separate sources")
> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Queued this patch for Linux-6.19

Regards,
Anup

>
> ---
> Changes in v3:
> - Add a helper function to avoid repeating the same paragraph(suggested b=
y drew)
> - Link to v2: https://lore.kernel.org/linux-riscv/20251111135506.8526-1-f=
angyu.yu@linux.alibaba.com/
>
> Changes in v2:
> - Remove unnecessary modifications and add comments(suggested by Anup)
> - Update Fixes tag
> - Link to v1: https://lore.kernel.org/linux-riscv/20250912134332.22053-1-=
fangyu.yu@linux.alibaba.com/
> ---
>  arch/riscv/kvm/vcpu_insn.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>
> diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
> index de1f96ea6225..4d89b94128ae 100644
> --- a/arch/riscv/kvm/vcpu_insn.c
> +++ b/arch/riscv/kvm/vcpu_insn.c
> @@ -298,6 +298,22 @@ static int system_opcode_insn(struct kvm_vcpu *vcpu,=
 struct kvm_run *run,
>         return (rc <=3D 0) ? rc : 1;
>  }
>
> +static bool is_load_guest_page_fault(unsigned long scause)
> +{
> +       /**
> +        * If a g-stage page fault occurs, the direct approach
> +        * is to let the g-stage page fault handler handle it
> +        * naturally, however, calling the g-stage page fault
> +        * handler here seems rather strange.
> +        * Considering this is a corner case, we can directly
> +        * return to the guest and re-execute the same PC, this
> +        * will trigger a g-stage page fault again and then the
> +        * regular g-stage page fault handler will populate
> +        * g-stage page table.
> +        */
> +       return (scause =3D=3D EXC_LOAD_GUEST_PAGE_FAULT);
> +}
> +
>  /**
>   * kvm_riscv_vcpu_virtual_insn -- Handle virtual instruction trap
>   *
> @@ -323,6 +339,8 @@ int kvm_riscv_vcpu_virtual_insn(struct kvm_vcpu *vcpu=
, struct kvm_run *run,
>                                                           ct->sepc,
>                                                           &utrap);
>                         if (utrap.scause) {
> +                               if (is_load_guest_page_fault(utrap.scause=
))
> +                                       return 1;
>                                 utrap.sepc =3D ct->sepc;
>                                 kvm_riscv_vcpu_trap_redirect(vcpu, &utrap=
);
>                                 return 1;
> @@ -378,6 +396,8 @@ int kvm_riscv_vcpu_mmio_load(struct kvm_vcpu *vcpu, s=
truct kvm_run *run,
>                 insn =3D kvm_riscv_vcpu_unpriv_read(vcpu, true, ct->sepc,
>                                                   &utrap);
>                 if (utrap.scause) {
> +                       if (is_load_guest_page_fault(utrap.scause))
> +                               return 1;
>                         /* Redirect trap if we failed to read instruction=
 */
>                         utrap.sepc =3D ct->sepc;
>                         kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
> @@ -504,6 +524,8 @@ int kvm_riscv_vcpu_mmio_store(struct kvm_vcpu *vcpu, =
struct kvm_run *run,
>                 insn =3D kvm_riscv_vcpu_unpriv_read(vcpu, true, ct->sepc,
>                                                   &utrap);
>                 if (utrap.scause) {
> +                       if (is_load_guest_page_fault(utrap.scause))
> +                               return 1;
>                         /* Redirect trap if we failed to read instruction=
 */
>                         utrap.sepc =3D ct->sepc;
>                         kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
> --
> 2.50.1
>

