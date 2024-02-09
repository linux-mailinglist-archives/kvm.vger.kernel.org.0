Return-Path: <kvm+bounces-8442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B56E84F8F8
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 16:56:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21BFF28E693
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 15:56:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 365307603D;
	Fri,  9 Feb 2024 15:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bxTLuUda"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6273E74E3E
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 15:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707494165; cv=none; b=S40+uGIt8mlAE1sopQ85sSyCxBxqjzzZAyvLa0KkLWsupo3SipaZFJtqW/+F/yOWrw0/oumxVEnxhvcbQC+bi2M5Nesa6z0qv9mdTFRmuDUqF5rZQQiII01F8AOfcOZvwBkPrT2G37hpQshffhBc7GnQ4FcwVeIspyMuwsZ0yes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707494165; c=relaxed/simple;
	bh=4jHBISDBZSlDvEZ0jrvuuCxv1NHOPsT/1c/QLHc2XS0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jq5t+3XntdTTLUnGDHHpPu1FtRF8u9dcZ4ESB0dSXXRr4oIIwowQ48QHoL9EJx4zFFZCQUJchJa/AygTMRkByUPTVGtlEYOVeY8QX0u2cV4dkt7qsq9ptLIEw4hIKvR5523772GtlKT7ZfK9e58V4r2uW3lJjd5I71VMUm50UH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bxTLuUda; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD29C433F1;
	Fri,  9 Feb 2024 15:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707494164;
	bh=4jHBISDBZSlDvEZ0jrvuuCxv1NHOPsT/1c/QLHc2XS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bxTLuUdaLh+we7LpW7RUvuINZvzp/+cSCUnn/g77ssBSfhSVvcvaGthyGv9k+qVb4
	 Nfg5UHbOHamjidQ9SvDArrp/PXiVW+ouTrDrEJe8Ift2YKntkXPkymku1xC9ls3o65
	 Fw3zNK44B3Ht9xG35Zs2QFIQotVZ9DG2Jaz8KQ4XibAhgdo4IuCwLFA8SEW7YmZb3c
	 CiZDhhwoUSUjQaaKiZkRGaTQOOfS7ETCS7waijwuB/uBZIwkdqymmWN3yzy/UxO1TN
	 WN8DMLtY6fOazNRxGjqwcGFcS3ZFLpNJVqswn65iApbZcmoDMiEzZewZCtVzuCellD
	 5Z7w1pYX+gl2g==
From: Will Deacon <will@kernel.org>
To: Anup Patel <apatel@ventanamicro.com>,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	kvm-riscv@lists.infradead.org,
	Anup Patel <anup@brainfault.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	kvm@vger.kernel.org,
	Atish Patra <atishp@atishpatra.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvmtool PATCH 00/10] SBI debug console and few ISA extensions
Date: Fri,  9 Feb 2024 15:55:56 +0000
Message-Id: <170749352335.2620327.13138913157188078368.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20231128145628.413414-1-apatel@ventanamicro.com>
References: <20231128145628.413414-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 28 Nov 2023 20:26:18 +0530, Anup Patel wrote:
> This series adds support for:
> 1) ISA extensions: Zba, Zbs, Zicntr, Zihpm, Zicsr, Zifencei, Zicond,
>    and Smstateen
> 2) SBI debug console (DBCN) extension
> 
> These patches can also be found in the riscv_zbx_zicntr_smstateen_condops_v1
> branch at: https://github.com/avpatel/kvmtool.git
> 
> [...]

Applied to kvmtool (master), thanks!

(I updated the headers to 6.7 separately)

[02/10] riscv: Improve warning in generate_cpu_nodes()
        https://git.kernel.org/will/kvmtool/c/fcb076756ab2
[03/10] riscv: Make CPU_ISA_MAX_LEN depend upon isa_info_arr array size
        https://git.kernel.org/will/kvmtool/c/7887b3989ac2
[04/10] riscv: Add Zba and Zbs extension support
        https://git.kernel.org/will/kvmtool/c/6331850d6bc0
[05/10] riscv: Add Zicntr and Zihpm extension support
        https://git.kernel.org/will/kvmtool/c/667685691c5d
[06/10] riscv: Add Zicsr and Zifencei extension support
        https://git.kernel.org/will/kvmtool/c/3436684940bc
[07/10] riscv: Add Smstateen extension support
        https://git.kernel.org/will/kvmtool/c/8d02d5a895c3
[08/10] riscv: Add Zicond extension support
        https://git.kernel.org/will/kvmtool/c/8cd71ca57fb0
[09/10] riscv: Set mmu-type DT property based on satp_mode ONE_REG interface
        https://git.kernel.org/will/kvmtool/c/ef89838e3760
[10/10] riscv: Handle SBI DBCN calls from Guest/VM
        https://git.kernel.org/will/kvmtool/c/4ddaa4249e0c

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

