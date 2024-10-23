Return-Path: <kvm+bounces-29571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEDF29AD01A
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 18:23:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 80D822845A8
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 16:23:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDFFF1CCB31;
	Wed, 23 Oct 2024 16:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FmHIMKBa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE981CC165
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 16:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729700489; cv=none; b=h0EWL3RVhw4UG+2U1429tfqg2x6G7RNwGg+GxRpBzXtJR6ZezYjScSicarSkyN9T1x3kqYiZVZ/oEDyXg+ywEKMiXapgTDuz+tH1jia13lmmLVGJ3SAM13Yrk9QuFjYOZjC/6+MQ6aTSJ6EWnk2w91CCKm1qhoc3U77PTtiYtGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729700489; c=relaxed/simple;
	bh=LMLpLHt8kwAaDEl60uON8JegiGocEBTK/aHPNGnDI6E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jebjPdJUjpVXAX9lIp9XpTpJZuAwuZIqI041W7wKa6tt03KcjUHwWoMpDH1AqqvFEP0ots70X9KKW9yTUoQracnw0ltu/+f7t3J/yx6nY1kLBI0gd0N+w/01y7w06VGu3e8zQTbe3RegGcxregZyVuDjw+38oLXXgVRu6Jtf2L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FmHIMKBa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8ABC4CEC6;
	Wed, 23 Oct 2024 16:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729700488;
	bh=LMLpLHt8kwAaDEl60uON8JegiGocEBTK/aHPNGnDI6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FmHIMKBaCKVte1ikiFN+Kl7yKklcVSkZjX6/X0CItn/WYotIh37l9tGPzPa8sAXAu
	 3omrV4DaaIuU7Eyytk3yB9GLy0FJv4p+kEI95P1nr7VG5ZbiLCa8PVfzfjddRLbPHR
	 RDVVFcua2pIYn2e0tIamLxcmW9BSiSrMIx5cvxnl3Sj+pWSlO6JVbBie9Qnj8N79uG
	 1pzuW6lI9mrqM8/DoAj25pU1d8S6Xg1cdCibQX2zW3TBo20r4Zis5sTwAQRDrrUwMv
	 JLmfreY0zFc2eYn/zaeLDMFGjgIr12zaKhFlsdxJfCmGYoyGT9qDZMDLp0+x0c5Szz
	 VEvp/AwwpsF/w==
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
Subject: Re: [kvmtool PATCH v2 0/8] Add RISC-V ISA extensions based on Linux-6.11
Date: Wed, 23 Oct 2024 17:21:20 +0100
Message-Id: <172969896377.3484512.14673006863985843861.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20241005080024.11927-1-apatel@ventanamicro.com>
References: <20241005080024.11927-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Sat, 05 Oct 2024 13:30:16 +0530, Anup Patel wrote:
> This series adds support for new ISA extensions based on Linux-6.11
> namely: Zawrs, Zca, Zcb, Zcd, Zcf, Zcmop, and Zimop.
> 
> These patches can also be found in the riscv_more_exts_round4_v2 branch
> at: https://github.com/avpatel/kvmtool.git
> 
> Changes since v1:
> - Updated PATCH1 to sync-up header with released Linux-6.11 kernel
> 
> [...]

Applied to kvmtool (master), thanks!

[1/8] Sync-up headers with Linux-6.11 kernel
      https://git.kernel.org/will/kvmtool/c/b862ed4bbe34
[2/8] riscv: Add Zawrs extension support
      https://git.kernel.org/will/kvmtool/c/c7a4bd93833f
[3/8] riscv: Add Zca extension support
      https://git.kernel.org/will/kvmtool/c/4b8b352b0c25
[4/8] riscv: Add Zcb extension support
      https://git.kernel.org/will/kvmtool/c/78bafd5691be
[5/8] riscv: Add Zcd extension support
      https://git.kernel.org/will/kvmtool/c/80d2e0cd1496
[6/8] riscv: Add Zcf extension support
      https://git.kernel.org/will/kvmtool/c/9f50870b2701
[7/8] riscv: Add Zcmop extension support
      https://git.kernel.org/will/kvmtool/c/1f0e5ba9e458
[8/8] riscv: Add Zimop extension support
      https://git.kernel.org/will/kvmtool/c/3040b298156e

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

