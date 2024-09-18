Return-Path: <kvm+bounces-27091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B6FB297BEA7
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 17:32:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DBD071C20A41
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 15:32:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FD311C8FC5;
	Wed, 18 Sep 2024 15:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UmZHSiE1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D663ED299
	for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 15:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726673566; cv=none; b=gakoJN4McKAkGt17u40JSgS07x3+CAV33WEHHY7XKl11KKYFWxXbqsddFD78e2Y7SkTXKpScYswavyCKPY2V3O1xLYEK9JFbVOVkvte9LNOa31Gyh+GReBjFVjIEG5uEGStenCZqcMhII7z3ounn5tjmzsMecJ5kmZ4JUEQlW0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726673566; c=relaxed/simple;
	bh=1+x3ddyd1Ig4e2B+IIMCjxcdZbik6arsfDYYLqbozvw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NJAV46atUs034XSdUYcU0mOJbQq9wDFSuv6UP6rbAh8YHb9pSHfntvLopuk8rike7VytGBbQKiomoArp30bFQiu+pmGGSdOOSAYe7DjIkdtOPN0VFOqmOGH+bR+ZgdmgTFRhGCVp9BeWf++jnrtbf2Es6y8yJRVT2lmVMaI+75E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UmZHSiE1; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5c3ca32974fso8739171a12.3
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 08:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726673563; x=1727278363; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DCpTEL/dYMB7Uol2NlYZ7DCyhiPYwgEy6rc2BA5KywU=;
        b=UmZHSiE1Sc1/08SxqCRHjRj3wXg46gBAqjeOd1S2XumLZGgrhe48JvcPQsBtZgFiVy
         9Yq/npVTI660uwVXAQL7rnVHlOXxtFtbLgiydVApq2x1Ed9su3Y55/UXaBvmXAKWeaBv
         e3f9P4AcRaK7dhdYA+kLYgS1FUgeytFyZcMaNXAl8sn3H4InCKRMr63qiBuUYJaIkXuA
         YjEpqMj2S04poebVhGCZhrDYHDK36jtP9zfl22uEbcc0Q4nw6L8+kzryrY9lZSSiQ6X6
         dMUsvdcVHdQO/MPsDvTLR+45fGRU10fMjEIS5uj0ykWB2GM4BN8FkmYRVQK5wwXgvtv9
         aTvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726673563; x=1727278363;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DCpTEL/dYMB7Uol2NlYZ7DCyhiPYwgEy6rc2BA5KywU=;
        b=HTsmmNnOIavIf4OctH3wWDAI1umVlKHpOUMYx2m3ZYIosbgZYad/sccDdi8SDhoQvN
         TgOiJhxQD1xGo1uxnom98BJvSSISBFt6kroMrfqmtihtZEHJcm5GaxemwM9WfCqO0tqJ
         srqgFnYB80CodOWgoEgcUPnb1sFxuawoDO8vwODKAgMO9dZPN0U7aF2USWq4Av7Um8Z7
         z627IsVIZEyab66BkZsTGEpOviaTRXuzkNMGLP72Q4kCn+/8gq66sJ3RtenAmuMvdOVu
         E2CRMdWGh/MOjtuE5uB+EZ9GSul3HDmdMnstGSVv6pR6hX9S2WnVE2lqxbPHrTDZ78LB
         kh0A==
X-Forwarded-Encrypted: i=1; AJvYcCVhoJZai3WQOxKNUEk3NfkgT8OQk0FOyZKEs2DCpAZ/ZaxZT6r4Saavyahl7nIMfTAawA4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUbBdM6ixx0vnTKl7feTU0j6ygUfZ+fU+KD2ZmUvmJTbrrZ7wE
	ex1uHjTRH+n/V6pjDWQSyOu+khFOoRbVHG0sFeu1zPFkeN+11HqfjaKWuy/3bwDirYlu08UXhQ8
	H7wKxhRmpN9IYHGy+F9PpI6yWZnwuqfCrAZ9ruQ==
X-Google-Smtp-Source: AGHT+IHUXyXfmA5Am44lE06hFsf1unXiUfxYsmWUCGV8LXPzN024Cxhz2eXy8PcJcIICTPqY5rE5RE0MwfG5g8Mtkro=
X-Received: by 2002:a05:6402:280a:b0:5c2:8249:b2d3 with SMTP id
 4fb4d7f45d1cf-5c413e4c51fmr18852185a12.26.1726673562914; Wed, 18 Sep 2024
 08:32:42 -0700 (PDT)
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
 <f1e41b95-c499-4e06-91cb-006dcd9d29e6@canonical.com>
In-Reply-To: <f1e41b95-c499-4e06-91cb-006dcd9d29e6@canonical.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Wed, 18 Sep 2024 16:32:31 +0100
Message-ID: <CAFEAcA_ePVwnpVVWJSx8=-8v2h_z2imfSdyAZd62RhXaZUTojA@mail.gmail.com>
Subject: Re: [PATCH 1/1] target/riscv: enable floating point unit
To: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Alistair Francis <alistair.francis@wdc.com>, 
	Bin Meng <bmeng.cn@gmail.com>, Weiwei Li <liwei1518@gmail.com>, 
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>, Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, 
	qemu-riscv@nongnu.org, qemu-devel@nongnu.org, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 18 Sept 2024 at 14:49, Heinrich Schuchardt
<heinrich.schuchardt@canonical.com> wrote:
>
> On 18.09.24 15:12, Peter Maydell wrote:
> > On Wed, 18 Sept 2024 at 14:06, Heinrich Schuchardt
> > <heinrich.schuchardt@canonical.com> wrote:
> >> Thanks Peter for looking into this.
> >>
> >> QEMU's cpu_synchronize_all_post_init() and
> >> do_kvm_cpu_synchronize_post_reset() both end up in
> >> kvm_arch_put_registers() and that is long after Linux
> >> kvm_arch_vcpu_create() has been setting some FPU state. See the output
> >> below.
> >>
> >> kvm_arch_put_registers() copies the CSRs by calling
> >> kvm_riscv_put_regs_csr(). Here we can find:
> >>
> >>       KVM_RISCV_SET_CSR(cs, env, sstatus, env->mstatus);
> >>
> >> This call enables or disables the FPU according to the value of
> >> env->mstatus.
> >>
> >> So we need to set the desired state of the floating point unit in QEMU.
> >> And this is what the current patch does both for TCG and KVM.
> >
> > If it does this for both TCG and KVM then I don't understand
> > this bit from the commit message:
> >
> > # Without this patch EDK II with TLS enabled crashes when hitting the first
> > # floating point instruction while running QEMU with --accel kvm and runs
> > # fine with --accel tcg.
> >
> > Shouldn't this guest crash the same way with both KVM and TCG without
> > this patch, because the FPU state is the same for both?

> By default `qemu-system-riscv64 --accel tcg` runs OpenSBI as firmware
> which enables the FPU.
>
> If you would choose a different SBI implementation which does not enable
> the FPU you could experience the same crash.

Ah, so KVM vs TCG is a red herring and it's actually "some guest
firmware doesn't enable the FPU itself, and if you run that then it will
fall over, whether you do it in KVM or TCG" ? That makes more sense.

I don't have an opinion on whether you want to do that or not,
not knowing what the riscv architecture mandates. (On Arm this
would be fairly clearly "the guest software is broken and
should be fixed", but that's because the Arm architecture
says you can't assume the FPU is enabled from reset.)

I do think the commit message could use clarification to
explain this.

thanks
-- PMM

