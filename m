Return-Path: <kvm+bounces-28090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D933993BE3
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 02:46:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11A7B282FF0
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 00:46:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB012C147;
	Tue,  8 Oct 2024 00:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZFzSBh86"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BB510F1;
	Tue,  8 Oct 2024 00:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728348364; cv=none; b=X2XmbqELrkE/aPx+h1r0rRIWJ/CsVt7g6Hp73fs58OvrR5Bs/1RidGcLtbH8x14zu5dQN547OAiXL2NfLQpMmRoBKygVQslM2g+tHjz4deh1y2G9kMIcMuv2V+DzA7tCe+7q1OxXDPWpoiWQJ62PLlbEjGpzpAwu446ERlWuglk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728348364; c=relaxed/simple;
	bh=6Gor2689cfKtERd+MZJEELlNXHgAt1WIN5uGOjLUqsU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VAz36DfZC8FT6/8O0LsfWrxY6Wjy6u0J3MdboFlD1YvyuRLlPyJw5k5ut8/4F5B9FmIfTouF1FUfdMh+JTg+UdniCsIMf3puikM5o+UFPTBH3xR2AohcczRh34ODR3dMQp1Jku/H3C6fS60pF93vMULhq/+BQ38kdYCBsd68sc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZFzSBh86; arc=none smtp.client-ip=209.85.222.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-84f98af14a0so212509241.2;
        Mon, 07 Oct 2024 17:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728348362; x=1728953162; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DwrZU7+WRXa2SBCQtrdGDwpBC/7fI0xHGdzxrY4bl/4=;
        b=ZFzSBh86Dl7SKH0IChlQS8dgbXIOhCWDnsB5F3kzErZRYDdjthn1yec++yoHgXu2/L
         be4iwie9gRtzu4BTnQHT9FBsEJoILR+yf5CdcxSHIS943+ZEmSUGzdcDSv+n1p8M6n+3
         DxOz36v3JooI+jHd2xwrzaW/aaWkzFeiOhPttvDu9XUN/ZXh9qf9xnftCFNixVA8S2fO
         o1uieB8rMpXWzQSre5OXYqK7on9RWNpkp7t1Gb1BSdxTfHvDh5IxJk6l84OkzjG4q8yh
         0VQmdGlh0/1VFi/rYlB8xsiCvLbKhYXDmXVgEOh4Icrd+VNKKrFATd5YmxcYRm3nZaaw
         G0IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728348362; x=1728953162;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DwrZU7+WRXa2SBCQtrdGDwpBC/7fI0xHGdzxrY4bl/4=;
        b=WVejRz0pk64gJPsO3FXenF24BFYG45Wz4jKTROZqGJilrYjrdzxvNVUEmEBjNi3r62
         XxcxzcIrA1crZSGe3HCae+7nDrsfhH31l9ZYQXSgH+Y1Q4jKhjmTWxtymHMx2+FV8KHf
         8BKCKeEYH8CBmvv+Z8BHWEkEMNxVb+zg0hXX+8qobSuM9nnWcdPZiKlSMtAmY8WRGfL5
         7ou+z54ikLB9VhEc0Na3KXsrDenNDOoRTyiea8zCLIxGUKrdgHq1RBSxsQ5UcAfn+klT
         rN4T7lcDdcjZ2tuyvSar81WviS/VvhIwNy1oyAwvgvgZxIlNbzJW1WCXhdsrjzE9Wlhz
         ZdZA==
X-Forwarded-Encrypted: i=1; AJvYcCVc1NDi7fMpLzzFw2R7jzj0YpSFUenPJszoB+vL5sr5T0MUkfSab0ET5qdJBAQDksWf5OY=@vger.kernel.org, AJvYcCVc7yq/wEVxOUZuPCa0DINUHpdi1WeiIARH/OWG30Nc4ggMD9Q1sqXx6ZmSIasFlxEqieTkGQIIvF/qmG/t@vger.kernel.org
X-Gm-Message-State: AOJu0YwHiiAstFmLv1nFaowJCjx0pQD/r2+r4uQ8WgwlzqhChcYb3z1Z
	He9JuThnjBHKmedOlymOLJ0hq9/3Q9Uifky6zUhuo7iwZ5P6Fxy8n2rX8Ox2bEJuME6P1WEyqsJ
	kkufRJBDdBVKn97eQ3Y3pbEFbW9E=
X-Google-Smtp-Source: AGHT+IHSJlvK4jZXDTbKT7zFv1I0YNJsGBRL7BUreec71rnnZExDUt435St1qHWdGUc4qJLEHqo7Brx0xwV9I6zN6Oo=
X-Received: by 2002:a05:6102:440b:b0:4a3:c830:81e9 with SMTP id
 ada2fe7eead31-4a40574966fmr11623307137.6.1728348362222; Mon, 07 Oct 2024
 17:46:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240916181633.366449-1-heinrich.schuchardt@canonical.com>
 <20240917-f45624310204491aede04703@orel> <15c359a4-b3c1-4cb0-be2e-d5ca5537bc5b@canonical.com>
 <20240917-b13c51d41030029c70aab785@orel> <8b24728f-8b6e-4c79-91f6-7cbb79494550@canonical.com>
 <20240918-039d1e3bebf2231bd452a5ad@orel> <CAFEAcA-Yg9=5naRVVCwma0Ug0vFZfikqc6_YiRQTrfBpoz9Bjw@mail.gmail.com>
 <bab7a5ce-74b6-49ae-b610-9a0f624addc0@canonical.com> <CAFEAcA-L7sQfK6MNt1ZbZqUMk+TJor=uD3Jj-Pc6Vy9j9JHhYQ@mail.gmail.com>
 <f1e41b95-c499-4e06-91cb-006dcd9d29e6@canonical.com> <CAFEAcA_ePVwnpVVWJSx8=-8v2h_z2imfSdyAZd62RhXaZUTojA@mail.gmail.com>
In-Reply-To: <CAFEAcA_ePVwnpVVWJSx8=-8v2h_z2imfSdyAZd62RhXaZUTojA@mail.gmail.com>
From: Alistair Francis <alistair23@gmail.com>
Date: Tue, 8 Oct 2024 10:45:36 +1000
Message-ID: <CAKmqyKPoom+iQbrNn7xuebRdd9DfX3GAJQQM+8fswEqfRi3e_A@mail.gmail.com>
Subject: Re: [PATCH 1/1] target/riscv: enable floating point unit
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Alistair Francis <alistair.francis@wdc.com>, Bin Meng <bmeng.cn@gmail.com>, 
	Weiwei Li <liwei1518@gmail.com>, Daniel Henrique Barboza <dbarboza@ventanamicro.com>, 
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, qemu-riscv@nongnu.org, qemu-devel@nongnu.org, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 19, 2024 at 1:34=E2=80=AFAM Peter Maydell <peter.maydell@linaro=
.org> wrote:
>
> On Wed, 18 Sept 2024 at 14:49, Heinrich Schuchardt
> <heinrich.schuchardt@canonical.com> wrote:
> >
> > On 18.09.24 15:12, Peter Maydell wrote:
> > > On Wed, 18 Sept 2024 at 14:06, Heinrich Schuchardt
> > > <heinrich.schuchardt@canonical.com> wrote:
> > >> Thanks Peter for looking into this.
> > >>
> > >> QEMU's cpu_synchronize_all_post_init() and
> > >> do_kvm_cpu_synchronize_post_reset() both end up in
> > >> kvm_arch_put_registers() and that is long after Linux
> > >> kvm_arch_vcpu_create() has been setting some FPU state. See the outp=
ut
> > >> below.
> > >>
> > >> kvm_arch_put_registers() copies the CSRs by calling
> > >> kvm_riscv_put_regs_csr(). Here we can find:
> > >>
> > >>       KVM_RISCV_SET_CSR(cs, env, sstatus, env->mstatus);
> > >>
> > >> This call enables or disables the FPU according to the value of
> > >> env->mstatus.
> > >>
> > >> So we need to set the desired state of the floating point unit in QE=
MU.
> > >> And this is what the current patch does both for TCG and KVM.
> > >
> > > If it does this for both TCG and KVM then I don't understand
> > > this bit from the commit message:
> > >
> > > # Without this patch EDK II with TLS enabled crashes when hitting the=
 first
> > > # floating point instruction while running QEMU with --accel kvm and =
runs
> > > # fine with --accel tcg.
> > >
> > > Shouldn't this guest crash the same way with both KVM and TCG without
> > > this patch, because the FPU state is the same for both?
>
> > By default `qemu-system-riscv64 --accel tcg` runs OpenSBI as firmware
> > which enables the FPU.
> >
> > If you would choose a different SBI implementation which does not enabl=
e
> > the FPU you could experience the same crash.
>
> Ah, so KVM vs TCG is a red herring and it's actually "some guest
> firmware doesn't enable the FPU itself, and if you run that then it will
> fall over, whether you do it in KVM or TCG" ? That makes more sense.
>
> I don't have an opinion on whether you want to do that or not,
> not knowing what the riscv architecture mandates. (On Arm this
> would be fairly clearly "the guest software is broken and
> should be fixed", but that's because the Arm architecture
> says you can't assume the FPU is enabled from reset.)

RISC-V is the same. Section "3.4 Reset" states that:

"All other hart state is UNSPECIFIED." (the paragraph doesn't mention
the FS state).

So it's unspecified what the value is on reset. Guest software
shouldn't assume anything about it and it does seem like a guest
software bug.

In saying that, we are allowed to set it then as the spec doesn't say
it should be 0. So setting it to 0x01 (Initial) doesn't seem like a
bad idea, as the name kind of implies that it should be 0x01 on reset

Alistair

>
> I do think the commit message could use clarification to
> explain this.
>
> thanks
> -- PMM
>

