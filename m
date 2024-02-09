Return-Path: <kvm+bounces-8443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 97CDE84F8F9
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 16:56:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F4651F259B7
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 15:56:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E028876058;
	Fri,  9 Feb 2024 15:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KKXdJuej"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABD17602A
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 15:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707494168; cv=none; b=OiNYLizYqWlyWCiiGbeEw9vxdNoefCTFCIapJkyiJnZraJta6koejQls02fhxjRSWOMSB4R15aRlF8bFl9r9qHKqLYXn1XdqftOGv4Cu2YxSXHdoOLu3iHP8Tg2qOH3MTKSY548a1dyDlNhvziYKNPgsWtxwEfWogEiM39dYOF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707494168; c=relaxed/simple;
	bh=O4mMyfRBTIPhFilk9L/2Uo6dbA1rbCJw2IWT4r5DZds=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y2W+8v4S9b6VGDRlfxCZAxlYWnVIDTAMuiDcogm1c1TwbQsA6GJLb9MySoz2mBi+SDiQo/j6AKUhKm02+BbAxOUkfbM8qYmOkz7rIzY+G3mOkHrepnlQH9OAVNj6fPo4yuGneBT336m4DZilNtTghT3nls7SEvhK6RKYm9pDa+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KKXdJuej; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55482C43394;
	Fri,  9 Feb 2024 15:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707494167;
	bh=O4mMyfRBTIPhFilk9L/2Uo6dbA1rbCJw2IWT4r5DZds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KKXdJuejX7guU7LUbEVxZ0uhsIuZzEa5R1o3RFTU9213PVqODCY+OlexLvhmNTX0p
	 HgqtjHf6bcafqhugr418INpA2wA1srqu1bvToovbMLZiWJRs4qu+ur1ncTgOML5v2M
	 D5KPvGCYZqcOpcJ3eVhXZFPq8wH51hGi//0m0PkpSAYswedcLenlP7SI8JzFSDZdCM
	 E1SePn2dGboAZb+QTpjeSwPjXkfFwv2qGVnypA5odNf5KF6A5oeAMW4Yc01+uT+1cX
	 bwxeUcHYXoKOmJjrvfWu/myEuEFNLKBwaaCpQUXhU9vZiNodAvHXDKkMlzOng7uxlw
	 yk5zZjM4UX8YQ==
From: Will Deacon <will@kernel.org>
To: maz@kernel.org,
	julien.thierry.kdev@gmail.com,
	Anup Patel <apatel@ventanamicro.com>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	kvm@vger.kernel.org,
	Andrew Jones <ajones@ventanamicro.com>,
	Atish Patra <atishp@atishpatra.org>,
	kvm-riscv@lists.infradead.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Anup Patel <anup@brainfault.org>
Subject: Re: [kvmtool PATCH] riscv: Fix guest poweroff when using PLIC emulation
Date: Fri,  9 Feb 2024 15:55:57 +0000
Message-Id: <170749363997.2620566.12528485009430198200.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20231130041633.78725-1-apatel@ventanamicro.com>
References: <20231130041633.78725-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 30 Nov 2023 09:46:33 +0530, Anup Patel wrote:
> Recently due to commit 74af1456dfa0, the virtio device emulation
> in KVMTOOL now calls irq__update_msix_route() upon guest poweroff
> which results in KVMTOOL crash when Guest uses PLIC emulation in
> user space. This is because irq__update_msix_route() expects the
> irq_routing table to be available but the KVMTOOL PLIC emulation
> does not populate any irq_routing entries.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] riscv: Fix guest poweroff when using PLIC emulation
      https://git.kernel.org/will/kvmtool/c/f6cc06d6b535

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

