Return-Path: <kvm+bounces-25547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C513C96668D
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 18:12:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 425EBB21593
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 16:12:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E2E81B81A4;
	Fri, 30 Aug 2024 16:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HD5Endq0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8F3199FB7
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 16:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725034343; cv=none; b=frYoiBu0q3oBAitNcM8ERG99Huf2QNwphnPema4kI/TwpKj/KoZ5KZHrGmzhZWsqOYi34G5q160iCCsyOHDDUG6gdccpEnF0I6xr22nNyFnrg/s7zaiLLL5aUspj7hupHrnJ8LOkdzNGsArsgQ64SBAKBGB2yzIm6lIFFbIjSMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725034343; c=relaxed/simple;
	bh=I1i2BzEAAEyevh3ZSofzPelJM13eq7gz6Ec+pGTJBMA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p5r2rj2X2g/g4vKI0SowbGQVLKOC7JxpA9r9uj7hTS+W5x3N2n2yjB2Qbo43uBpEEfYVrAMUzmsEUEPyHhN6CUg4FymHNAx+nlNTTHl9T5Gdxiw7UexhiZWxRqKxu/fu+uwyKIc2wEa89LNZ1kRVubd+9LEsVUul2gw2g0Jm0/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HD5Endq0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB51C4CEC5;
	Fri, 30 Aug 2024 16:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725034343;
	bh=I1i2BzEAAEyevh3ZSofzPelJM13eq7gz6Ec+pGTJBMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HD5Endq0y6jXFlbN2tUIXXJrfHIb+8cfk+vdG+4BgDRg2Go/q3YsOJvmgoq3aiLgq
	 msajnfsG9vo9JJ009Xq56WEp9yNYk9tZKKn/QnAh4gcxn20a/Mco//6kn0f4afgj31
	 OKVenFmjoZ5ksEiYnAR77DQwjq+kNsre++Ci5Pd4xxd+07Yny1pdmGtZ+vjO0+FMux
	 9MkhVTl0YOSirsZnyC9eoioLjjliT/YuRt/tvJETVLTtQF/RpdhVhCooU05HSvmpVg
	 vgJadzMRFJNk4M0W7wIEqTg3YjT/kG+54E+dgfFl03zKr4oOM/VZ6wYCKqc2TaXAb7
	 5C3ZuOlvfPnxQ==
From: Will Deacon <will@kernel.org>
To: julien.thierry.kdev@gmail.com,
	maz@kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Subject: Re: [kvmtool PATCH v3 0/4] Add RISC-V ISA extensions based on Linux-6.10
Date: Fri, 30 Aug 2024 17:12:08 +0100
Message-Id: <172501224711.999016.8569782963205598241.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240821142610.3297483-1-apatel@ventanamicro.com>
References: <20240821142610.3297483-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 21 Aug 2024 19:56:06 +0530, Anup Patel wrote:
> This series adds support for new ISA extensions based on Linux-6.10 namely:
> Sscofpmf.
> 
> These patches can also be found in the riscv_more_exts_round3_v3 branch
> at: https://github.com/avpatel/kvmtool.git
> 
> Changes since v2:
>  - Include a fix to correct number of hart bits for AIA
> 
> [...]

Applied to kvmtool (master), thanks!

[1/4] Sync-up headers with Linux-6.10 kernel
      https://git.kernel.org/will/kvmtool/c/01171537bcc0
[2/4] riscv: Add Sscofpmf extensiona support
      https://git.kernel.org/will/kvmtool/c/fa958fb68cfb
[3/4] riscv: Set SBI_SUCCESS on successful DBCN call
      https://git.kernel.org/will/kvmtool/c/027784f4c67e
[4/4] riscv: Correct number of hart bits
      https://git.kernel.org/will/kvmtool/c/100fade1ac13

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

