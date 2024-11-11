Return-Path: <kvm+bounces-31505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 18F439C433D
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 18:11:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF846285EBD
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 17:11:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E70781A4E9E;
	Mon, 11 Nov 2024 17:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JmK7W7bu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1594E2AF1C;
	Mon, 11 Nov 2024 17:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731345060; cv=none; b=tyTEeZGvoyPXPUqZtVrPQaroco3mP9VhhKvui+W3ZvKY1prUae65PUh245j8Cro5UqueZT8RjlPneENQ9AQVtfitEi3H0bfoCoIt9+kcyOaILC5irculzUDNgepe/A0fd+ZY6ncN37BUUVlruZtitTqibO86teml6mV2L2sV6vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731345060; c=relaxed/simple;
	bh=mQcF4blWKVkXGoS5x+iNT1y37ntZRzSWV0O2NUHI8Pw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eBP04xPKzFTxtBmGUzouXZvcJUh2fcVbAeKKxDDtopHpBMIAyS769kyiVkdHzJzwBpPb8ccqX4dCBxcXLsY+MqzJHfjVxr5iSblrAvOfdRpHQNRifJgrLfw4e6LAXX6mWjToIGlzgIrxTxzJVZP3X5ZhaKyroJrur25TbeeBv50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JmK7W7bu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A663C4CECF;
	Mon, 11 Nov 2024 17:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731345059;
	bh=mQcF4blWKVkXGoS5x+iNT1y37ntZRzSWV0O2NUHI8Pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JmK7W7bu5pSk75hDiHLH5W/ZjQRfG+BAkS6pMUPUO3ENDcPfrmtjJqHUClZ2VfenK
	 2VF93iYVT2jnTNrML4DysmzIiDIPGjmZh640ebKA1RZ+qVxv0bKhxa4thVkuRN1vfj
	 OJp0t6sPobdonn7QuVuq7Q7uyXY/gth/J3mfppkICuwb0/HyBF6pPRY/4msl5+vNUV
	 NRfpxkNwl52+ZalTbHcm7zmOJrgUHtYBsWHAJdgLkZwm0gm6El2OOyISKMmPLJ5piP
	 Wo1AQTLKwscxyQYNYCJv3Z+0VL2yS6EJuVjXr6u+5NpDGfSY8bG3nUXjcrh9AlNw1C
	 aeLB630sHmHeA==
From: Will Deacon <will@kernel.org>
To: Julien Thierry <julien.thierry.kdev@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH kvmtool] riscv: Pass correct size to snprintf()
Date: Mon, 11 Nov 2024 17:10:53 +0000
Message-Id: <173134344938.1668143.13537130235205302790.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20241104192120.75841-1-bjorn@kernel.org>
References: <20241104192120.75841-1-bjorn@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 04 Nov 2024 20:21:19 +0100, Björn Töpel wrote:
> The snprintf() function does not get the correct size argument passed,
> when the FDT ISA string is built. Instead of adjusting the size for
> each extension, the full size is passed for every iteration. Doing so
> will make __snprinf_chk() bail out on glibc.
> 
> Adjust size for each iteration.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] riscv: Pass correct size to snprintf()
      https://git.kernel.org/will/kvmtool/c/574bd7b432ec

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

