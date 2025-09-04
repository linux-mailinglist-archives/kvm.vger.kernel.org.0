Return-Path: <kvm+bounces-56722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9808AB4303F
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 05:09:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 62E645655AA
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 03:09:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC85F27FD5A;
	Thu,  4 Sep 2025 03:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q5kHFqPU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1546719F127;
	Thu,  4 Sep 2025 03:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756955353; cv=none; b=vDWQTuKwN6NW5X04YJyHDyhQWsY84OwjpGSKColDiGafrVWCeHiHwWYw+AWBHRSeCF+arh0CfJG808qj3n2BAfjnCXFUFLlvu9EWctAiv3UyAM3b6Mokqev1YRgg1pk93j+I/SFttQgzHC7RdhbDBrel+ED32C77pwNL1uf5txI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756955353; c=relaxed/simple;
	bh=2suWeNf3cFKy886NMzzbtvUL5qtLRZ5jEq1rGPIzRrU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oYWmU/HJrOGEpalx/Blx9r0sD5svZ/BtoHjuYhdgSJpCX4AOLDYdl+BoPWsuRiMkkOPINCacUpCjQvPcZjRS7VynPuPsvgqwo3azXxY0P3kA7ptxu9fWtsSm8o5nwKXp11ma3zFptGpKBsKHTs9atcPXuU5ouMzK0ULJ/GznUb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q5kHFqPU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E5E0C4CEE7;
	Thu,  4 Sep 2025 03:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756955352;
	bh=2suWeNf3cFKy886NMzzbtvUL5qtLRZ5jEq1rGPIzRrU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=q5kHFqPUgDVJ35myaiu8/I6sO2I+p0++BOU7ly0ZRRcYpQWXCJ4wETXIv3v6K8j5k
	 7oWZn2TjFrG7sFG2GfR0ZccNlQnELaJlJgcjzdCkuRABO1YuQUR0EtT9jQjZHJBzjY
	 FUNo4vCpQC0qKEhAJkwGcbES6WC7EEKSlB4ejI6pG3hYeKoYMnVOHDlmmiF5rwHp52
	 PK9O30TOBAgeOggzQSTGN1KEPbI7gkpoBtXzD+vVv2gj3tB7EZYlIF8ZmcM7dfTAfp
	 QqUKguG9SCekFEG3cJtAzErKDdsH69xU2A+sR2UKxe7OKPZVaZSBJ14J+1Z8xhA5Ca
	 xTBrFrlzf6U9Q==
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3dce6eed889so318134f8f.0;
        Wed, 03 Sep 2025 20:09:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVkqhyPIWd+42ZV16kfZdgDMmUrzfn8h3R2SWxBoWWkxfMl4HDx+xC9B7izNML1fVDA7o/9XlHkWIFk1HmP@vger.kernel.org, AJvYcCWcRBN75/ZVinOHjaoERkrw6BhI8IAjR/N6iErx7uQiyr5EdHlVoTCzpNGaPIqU/B8nWxw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxx0IcAV0AHejlmr1z+GJ7PyD4BagWxwLSEm37iRt09/FCklK4R
	EaSOeQWZKLDeMSt/0aAbCM5NwUgHdE3rsqKky5ZBAxsE5lCzR/H9tyH4o8ZP2YOAbpncBy+bOWR
	A6P8NAvU+/xbQNmH1upaKTgUdGy3EIRk=
X-Google-Smtp-Source: AGHT+IFR6aINYU7huKlE/OzhcrboCQPzjWOQtTxIkuqU3b3el3/Iaex4o/xeyeJwxdLpMr/sGoJWeT6JGXEg536d6+c=
X-Received: by 2002:a5d:5f95:0:b0:3bd:6308:a4bb with SMTP id
 ffacd0b85a97d-3d1e0c85701mr13117757f8f.59.1756955351097; Wed, 03 Sep 2025
 20:09:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250821142542.2472079-1-guoren@kernel.org>
In-Reply-To: <20250821142542.2472079-1-guoren@kernel.org>
From: Guo Ren <guoren@kernel.org>
Date: Thu, 4 Sep 2025 11:08:58 +0800
X-Gmail-Original-Message-ID: <CAJF2gTQ3XJB_UtziyfV0aFdg=L=mqc7KJPv4a8=3Z5pQYNDLng@mail.gmail.com>
X-Gm-Features: Ac12FXwfohQEMlAkgm0ZGL0DFWWPk2cp_RxqrogprJgi0tUpgxNcRoqaF99tnT0
Message-ID: <CAJF2gTQ3XJB_UtziyfV0aFdg=L=mqc7KJPv4a8=3Z5pQYNDLng@mail.gmail.com>
Subject: Re: [PATCH V4 RESEND 0/3] Fixup & optimize hgatp mode & vmid detect functions
To: anup@brainfault.org
Cc: alex@ghiti.fr, aou@eecs.berkeley.edu, atish.patra@linux.dev, 
	guoren@kernel.org, troy.mitchell@linux.dev, fangyu.yu@linux.alibaba.com, 
	guoren@linux.alibaba.com, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	palmer@dabbelt.com, paul.walmsley@sifive.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Anup,

Ping..., hope for feedback.

On Thu, Aug 21, 2025 at 10:26=E2=80=AFPM <guoren@kernel.org> wrote:
>
> From: "Guo Ren (Alibaba DAMO Academy)" <guoren@kernel.org>
>
> Here are serval fixup & optmizitions for hgatp detect according
> to the RISC-V Privileged Architecture Spec.
>
> ---
> Changes in v4:
>  - Involve ("RISC-V: KVM: Prevent HGATP_MODE_BARE passed"), which
>    explain why gstage_mode_detect needs reset HGATP to zero.
>  - RESEND for wrong mailing thread.
>
> Changes in v3:
>  - Add "Fixes" tag.
>  - Involve("RISC-V: KVM: Remove unnecessary HGATP csr_read"), which
>    depends on patch 1.
>
> Changes in v2:
>  - Fixed build error since kvm_riscv_gstage_mode() has been modified.
> ---
>
> Fangyu Yu (1):
>   RISC-V: KVM: Write hgatp register with valid mode bits
>
> Guo Ren (Alibaba DAMO Academy) (2):
>   RISC-V: KVM: Remove unnecessary HGATP csr_read
>   RISC-V: KVM: Prevent HGATP_MODE_BARE passed
>
>  arch/riscv/kvm/gstage.c | 27 ++++++++++++++++++++++++---
>  arch/riscv/kvm/main.c   | 35 +++++++++++++++++------------------
>  arch/riscv/kvm/vmid.c   |  8 +++-----
>  3 files changed, 44 insertions(+), 26 deletions(-)
>
> --
> 2.40.1
>


--=20
Best Regards
 Guo Ren

