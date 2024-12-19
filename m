Return-Path: <kvm+bounces-34116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 305759F7519
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 08:04:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA9FB188CA04
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 07:04:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFBA321766A;
	Thu, 19 Dec 2024 07:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="PRo+qPHR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A31521661D
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 07:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734591834; cv=none; b=enPGsZiJPvi8pSsKAvok8xIaYsiHRQIJDDLuO1OEbX4CarnB9xOAH4y1XAjhmPm5Xuth/SIe603D3gxARbaCOHuaDQFZKEzIk24sdNCPKFmWhzusVRqhYrk4poZS7zJ9jX6dPpKI7Ptx/ke+Ny2CKrTZAmxQdyGKyrAhcBOuiQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734591834; c=relaxed/simple;
	bh=o3wu1szBs7EtCgty0EAt12temOthTdgB9zA8Y56lQz4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pfy6cVrOVzsUydsCV4JVKkc3LsUH7f9EYH+6hcw59jrqpz4OqkR4o41ry7Q/OBqNjwjua2Uw4S5SmkNuYSSBtyutbw6eKlkGEZsPRgxzkBNU/uqS6BgoecYT90EqEivhtDnvA467G2XiXYMMEXaA1xcwMjr926TyIrO0UjUpLDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=PRo+qPHR; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-844df397754so16996139f.2
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 23:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1734591831; x=1735196631; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4IyRYMrQ+U88prMKntBAgM3/KLNAlFs7l2A7rj6Z5wI=;
        b=PRo+qPHRfwt70tJ3h4NA1sBOnsJJYK2XEJE1L+xjwqXGdiuqgrqrrGC+A7Zjmt+a7t
         AiayedXzGPe8TPCdcD5xeEH5+LWopE2Mz/IFVzcE1nCM8RTq/vC0xjdhPVXQQeZT1/pp
         fIh6Ee0N6ricH+M5aEeZ3xe/lDAAqYNpT7kYHyoCk8JLjXUee1Ep1Atv4XZEKxy/ERVm
         QFsNNUA1Cnthyqpz3U7fBfG1A6LTv6ViXY9b/5noIJq/J83uzIxtY0j9KbUYInKYyU/u
         lbK86CyA24fLbefKslv/FMr7rtcbwEnb0OsgafaGxTXOAfGel9PtVmdjUzL8kIUqfCWj
         1JXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734591831; x=1735196631;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4IyRYMrQ+U88prMKntBAgM3/KLNAlFs7l2A7rj6Z5wI=;
        b=G+/jywgZ1B9omDZ2okVO/mgbaD3U6qq3ntMtSBubS9x5Tuprm3IF6FXf1YVAfv4TV6
         E0BJ46101UzNmLHRefDIZojF0JfE1hzRqHD/Kh6iA/R1ViOHaS8fgMY7bH8EHhAEKxyp
         ms+V1nE4C4Qpl2LrzpmC7mvl/3lQkEqboRU8c1eXJ4NTldXZS367Tcq0yWpLU6GZxS+C
         /g1XTW1QFfSm0Tl8HYIh0/vlmBSEYwqcMwUPRliGATYMXFJ+/7am2hGwpbRuGPGMqQ86
         05hx9fabiJVrwkCQRFFGj7Njr0aHxRZLHl/F5PVIqhfY8qGT7fbYAqIY/gMvuRD1yMeb
         VGwg==
X-Forwarded-Encrypted: i=1; AJvYcCVeBFFUZrhJSUNBNgR3rZc7I17yhhsYTCN1lRJz5g5BiA9DoELyAzjMQLEz+Kwc368OewY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyk8VhNqmrMaYuHVGv9sqGaP3goiC7z/iMZy/0Uwk+rcFYN5Wev
	wp/0omLhAYLFfBx+F0AQfZuvOXi42SkNn+BDPPuLR3paLHK+O/YZ0apoI6Aapny0Clg7X0vpPuN
	dg0bRG5BdbNT+BfsluG9lOYygZK8i5bZNfG+hug==
X-Gm-Gg: ASbGncsHUyya+2LJGifjH3OFR7v6fNtlaOO/xIB3Uue0iiYSnJUNWA89BkRxZLFLGVU
	lmbsw9DQobSMbvsJ1Bn2jzs9fxdP+nUG2/3MDPdty
X-Google-Smtp-Source: AGHT+IG7K8LVwmKDLwQagB5eeJHC8noPY3o49G9HivcQ4b1KpCh7GGt+VMTIDEX4ZGjSzWgbcXm6Uq3kn17dO0L7Z2c=
X-Received: by 2002:a05:6e02:1c0a:b0:3a8:1195:f216 with SMTP id
 e9e14a558f8ab-3bdc0bc8506mr46871165ab.10.1734591830886; Wed, 18 Dec 2024
 23:03:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241213-dev-maxh-svukte-v4-v4-0-92762c67f743@sifive.com>
In-Reply-To: <20241213-dev-maxh-svukte-v4-v4-0-92762c67f743@sifive.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 19 Dec 2024 12:33:39 +0530
X-Gm-Features: AbW1kvaeKrmON3-aRkJn8oFVJnZKK1n-LGgp_tS3faKBQ12slThrlN-_Fqb1ysk
Message-ID: <CAAhSdy3pHHJ7hqEvjnhFaTW7SQTmAU67b8KXgbtwi6-YHv_pwQ@mail.gmail.com>
Subject: Re: [PATCH RFC v4 0/3] riscv: add Svukte extension
To: Max Hsu <max.hsu@sifive.com>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Atish Patra <atishp@atishpatra.org>, Palmer Dabbelt <palmer@sifive.com>, 
	Conor Dooley <conor@kernel.org>, devicetree@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Samuel Holland <samuel.holland@sifive.com>, Deepak Gupta <debug@rivosinc.com>, 
	Alexandre Ghiti <alexghiti@rivosinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 13, 2024 at 5:03=E2=80=AFPM Max Hsu <max.hsu@sifive.com> wrote:
>
> RISC-V privileged spec will be added with Svukte extension [1]
>
> Svukte introduce senvcfg.UKTE and hstatus.HUKTE bitfield.
> which makes user-mode access to supervisor memory raise page faults
> in constant time, mitigating attacks that attempt to discover the
> supervisor software's address-space layout.
>
> In the Linux kernel, since the hstatus.HU bit is not enabled,
> the following patches only enable the use of senvcfg.UKTE.
>
> For Guest environments, because a Guest OS (not limited to Linux)
> may hold mappings from GVA to GPA, the Guest OS should decide
> whether to enable the protection provided by the Svukte extension.
>
> Since the Guest OS may utilize the Svukte extension simply by setting
> the senvcfg.UKTE without any trap to host. In the view of VMM, the
> Svukte extension should be always presented. Therefore adding an
> extra entry in kvm_riscv_vcpu_isa_disable_allowed().
>
> If the Guest environment wants to change senvcfg.UKTE, KVM already
> provides the senvcfg CSR swap support via
> kvm_riscv_vcpu_swap_in_(host|guest)_state.
> Thus, there is no concern about the Guest OS affecting the Host OS.
>
> The following patches add
> - dt-binding of Svukte ISA string
> - CSR bit definition, ISA detection, senvcfg.UKTE enablement in kernel
> - KVM ISA support for Svukte extension
>
> Changes in v4:
> - rebase on riscv/for-next
> - add kvm_riscv_vcpu_isa_disable_allowed() entry addressed by Anup
>   and Andrew from v2/v3 patches.
>   - update the cover letter for the detailed reason
> - update the commit message on dt-binding for the Svukte ISA string
> - Link to v3: https://lore.kernel.org/all/20241120-dev-maxh-svukte-v3-v3-=
0-1e533d41ae15@sifive.com/
>
> Changes in v3:
> - rebase on riscv/for-next
> - fixed typo in the dt-binding for the Svukte ISA string
> - updated the commit message for KVM support for the Svukte extension
> - Link to v2: https://lore.kernel.org/all/20240927-dev-maxh-svukte-rebase=
-2-v2-0-9afe57c33aee@sifive.com/
>
> Changes in v2:
> - rebase on riscv/for-next (riscv-for-linus-6.12-mw1)
> - modify the description of dt-binding on Svukte ISA string
> - Link to v1: https://lore.kernel.org/all/20240920-dev-maxh-svukte-rebase=
-v1-0-7864a88a62bd@sifive.com/
>
> Link: https://github.com/riscv/riscv-isa-manual/pull/1564 [1]
>
> Signed-off-by: Max Hsu <max.hsu@sifive.com>
>
> ---
> Max Hsu (3):
>       dt-bindings: riscv: Add Svukte entry
>       riscv: Add Svukte extension support
>       riscv: KVM: Add Svukte extension support for Guest/VM

Overall, this series looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>

As-per Linux RISC-V patch acceptance policy, we will have to
wait until the spec is frozen.

Regards,
Anup

>
>  Documentation/devicetree/bindings/riscv/extensions.yaml | 9 +++++++++
>  arch/riscv/include/asm/csr.h                            | 2 ++
>  arch/riscv/include/asm/hwcap.h                          | 1 +
>  arch/riscv/include/uapi/asm/kvm.h                       | 1 +
>  arch/riscv/kernel/cpufeature.c                          | 5 +++++
>  arch/riscv/kvm/vcpu_onereg.c                            | 2 ++
>  6 files changed, 20 insertions(+)
> ---
> base-commit: fac04efc5c793dccbd07e2d59af9f90b7fc0dca4
> change-id: 20241213-dev-maxh-svukte-v4-34101ec945e9
>
> Best regards,
> --
> Max Hsu <max.hsu@sifive.com>
>

