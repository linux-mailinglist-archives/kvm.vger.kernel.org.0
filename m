Return-Path: <kvm+bounces-54870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA3B9B2998B
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 08:18:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A778F7A6E09
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 06:16:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB3492741A6;
	Mon, 18 Aug 2025 06:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="laMUJFQX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8ECB26E710;
	Mon, 18 Aug 2025 06:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755497889; cv=none; b=Ij6GKaPmQCYX8HuC7xa/GxUm4k4bvme2ViTgKDi84zjAb4tFY9lRuhF9HekGiiiMocb6fgaMC9F/PI2k98kN2LKdpsc6fGCHiVU91ww5lZT1K04zpzYISPi973h0Z5RnN3GffirR1ar1HiAxJDk9o2gb9ehLQiNxWBjUZwjrtSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755497889; c=relaxed/simple;
	bh=SxRnpB9Bal81XXxAIu3Q8ZpoPbgIPFb2u57i3OfkJn4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TPJNqwQsWpmDdWwNAqQD54FwqA99Ty7/LC5HnXTmkBkM/hmbwdokcR2TvL+WNY6Ghc2TN7WQ2wb8nHGpJVlWybNFxqCL37pl3sS0X+WZ3tA2DgJSQJvnLlTHl2rH/oIR8KPx+u0Km/padn/W5zr6HpRkorTXiLpz5mZ130/iex8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=laMUJFQX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71BE3C4CEED;
	Mon, 18 Aug 2025 06:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755497889;
	bh=SxRnpB9Bal81XXxAIu3Q8ZpoPbgIPFb2u57i3OfkJn4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=laMUJFQXl2mCTsBR8Aj8KWJCfW9gocrsjiFvWEqQkqQoCFAtT0GXb/LbwyS0+lvd+
	 Dj3Oh7ExjaL5Msh0jTbPparqfDvl/oPOytkYYYwXmcQExM7aguQuBzTSuQk1B0KwVv
	 TUUa+8nwaN8wUacIzkpv1BrvQQPdjTLtmJDSVX6OLjuM9Y7x5nEQRfbdEyOwnlXFan
	 dUgqRX+foCqpMpErfuTtRvwGggtdQ7unEyEUzasS/hytnqWa4HTTZs7RICVmEx8O7S
	 kQqdxMrmpIoXhy92bY7vVrIRORG2FO9GcKmwAOh+aFVVsUek7vuIrzTR8Eb6DOf7uz
	 q4p4mnGEjrSAw==
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3b9e418ba08so2124218f8f.3;
        Sun, 17 Aug 2025 23:18:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVRLzt60xhuyBMwzkoNP5oONYGXTs9qGmJoNQNgVMvzveQyu7Aqiv8Y4dQbcAwvLQwF1c3ZqkJXvHcqHvCo@vger.kernel.org, AJvYcCWUfi/JT6ShVdgCgBkGd8M69LdFwKNhD24K4Ygxtwa5af7UvD9ozIX8dy0l0TAvTX/htE4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiBkAVyn71wdRYJRlC1+lDTFRco+0HJZ6+pKTJh34oSIyswYzP
	jP0rbodNdS6gFk3eDFtxuSyi0Bo8/sjeyaBQPVymqx31Ugpo7oUZPdl2+YoKnicm2L1rFZuTtKd
	jRbbqO0n4CxaeCAk83Up/wjN8dJi7OIs=
X-Google-Smtp-Source: AGHT+IGBvHqXTFBiXkW4Wmjw2VtbPEWEJ5aSZd47qOUAUK/NhJrcIBKM4XbpKEJyrLNJfIG5cFebxW0rtn6XVIe7mOQ=
X-Received: by 2002:a05:6000:26c4:b0:3b4:9b82:d42c with SMTP id
 ffacd0b85a97d-3bc68b89d03mr4788942f8f.17.1755497887956; Sun, 17 Aug 2025
 23:18:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250818054207.21532-1-fangyu.yu@linux.alibaba.com>
In-Reply-To: <20250818054207.21532-1-fangyu.yu@linux.alibaba.com>
From: Guo Ren <guoren@kernel.org>
Date: Mon, 18 Aug 2025 14:17:55 +0800
X-Gmail-Original-Message-ID: <CAJF2gTTqPMVTNdHL7PUwobXQr3dwzKPi13ZDpmkVz+3VXHLZVw@mail.gmail.com>
X-Gm-Features: Ac12FXyXjItsm--fBQaoqgkGrtBgmoHkt-wNlAEue7p0M-vAfPTlga2pclf0gMI
Message-ID: <CAJF2gTTqPMVTNdHL7PUwobXQr3dwzKPi13ZDpmkVz+3VXHLZVw@mail.gmail.com>
Subject: Re: [PATCH V2] RISC-V: KVM: Write hgatp register with valid mode bits
To: fangyu.yu@linux.alibaba.com
Cc: anup@brainfault.org, atish.patra@linux.dev, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
	guoren@linux.alibaba.com, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 18, 2025 at 1:42=E2=80=AFPM <fangyu.yu@linux.alibaba.com> wrote=
:
>
> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>
> According to the RISC-V Privileged Architecture Spec, when MODE=3DBare
> is selected,software must write zero to the remaining fields of hgatp.
>
> We have detected the valid mode supported by the HW before, So using a
> valid mode to detect how many vmid bits are supported.
Good catch! It's a bug. The code seems copied from asids_init(), whose
old value is not bare mode. For real hardware, it would cause
problems, but the qemu buggy code hides the problem.

It needs a tag: Fixes: fd7bb4a251df ("RISC-V: KVM: Implement VMID allocator=
")

Others, Reviewed-by: Guo Ren <guoren@kerenl.org>

>
> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>
> ---
> Changes in v2:
> - Fixed build error since kvm_riscv_gstage_mode() has been modified.
> ---
>  arch/riscv/kvm/vmid.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
> index 3b426c800480..5f33625f4070 100644
> --- a/arch/riscv/kvm/vmid.c
> +++ b/arch/riscv/kvm/vmid.c
> @@ -14,6 +14,7 @@
>  #include <linux/smp.h>
>  #include <linux/kvm_host.h>
>  #include <asm/csr.h>
> +#include <asm/kvm_mmu.h>
>  #include <asm/kvm_tlb.h>
>  #include <asm/kvm_vmid.h>
>
> @@ -28,7 +29,7 @@ void __init kvm_riscv_gstage_vmid_detect(void)
>
>         /* Figure-out number of VMID bits in HW */
>         old =3D csr_read(CSR_HGATP);
> -       csr_write(CSR_HGATP, old | HGATP_VMID);
> +       csr_write(CSR_HGATP, (kvm_riscv_gstage_mode << HGATP_MODE_SHIFT) =
| HGATP_VMID);
>         vmid_bits =3D csr_read(CSR_HGATP);
>         vmid_bits =3D (vmid_bits & HGATP_VMID) >> HGATP_VMID_SHIFT;
>         vmid_bits =3D fls_long(vmid_bits);
> --
> 2.49.0
>


--=20
Best Regards
 Guo Ren

