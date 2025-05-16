Return-Path: <kvm+bounces-46810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ED37AB9E05
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 15:54:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 202584E1EDD
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 13:54:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AFFE136347;
	Fri, 16 May 2025 13:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cP1EnUur"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A273672601
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 13:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747403670; cv=none; b=fvbfbs93TQb/Ogx0mDxIp4Cc8QiAoKWOIcmUpTfGmI35u1tKTBPu9RQt5SWX72nEMPhV2W/66FfLXYNhJ+G2jyVUrD/bwroOH8jjI6hagQweac+67nZ4uFvm455pjOH+Yu8O1zNe++DtiIUywUR1V4ix0/MFqOU6vTA+DiJKFPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747403670; c=relaxed/simple;
	bh=C7Ii4OS+lxxxizXe6a0Y+j3ekj3OuHIkNw86WOZShJ4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZsfAVm/IAOTklVhe8mAWcc5JpooHf/biczixzhav41RqW1rVCLc1KDqE1l8MGmhoFLg89IE2CVVoK2GUXK7282kWM36LgA70wDglWnanNsf9Sw+mBpy+tTTahLBiUcdJpGiK49fJptaSindfSOwacYf+Gh7emcmD6IXTgKldGlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cP1EnUur; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2801C4CEE4;
	Fri, 16 May 2025 13:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747403670;
	bh=C7Ii4OS+lxxxizXe6a0Y+j3ekj3OuHIkNw86WOZShJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cP1EnUurIruml39wNmTO916nwYV+JYsFTfnPP4nmjkaih3cGNOdQ9z4N0TbXPE48V
	 zYmBC78TTb004+vCQE1NpvjKsIarFG4VohkLfJj6OiqAzaS8OZ28EXgDx0f0DrDa6h
	 1fNsWCOBqOuhZsjd4ADjabrCtgBEH/14EqvO0Vfn+datPh9GrRWBcgg3VicNv/0csM
	 ldMmmqXUbseIsffincpiS9ONc04q4SDM7QG65hs/WvPhdV3SG644WXYbgqh38S6ER4
	 3nISgaBqtAW5Km97OFt1D7bEVoH5+gg6NQd6GBw8kuTtzfu6oLlG4NBKBBoQDn0Ojh
	 /02Fxkf4SP4UQ==
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
Subject: Re: [kvmtool PATCH v3 00/10] Add SBI system suspend and cpu-type option
Date: Fri, 16 May 2025 14:54:24 +0100
Message-Id: <174740291953.2568869.1965604295335396910.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20250426110348.338114-1-apatel@ventanamicro.com>
References: <20250426110348.338114-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Sat, 26 Apr 2025 16:33:37 +0530, Anup Patel wrote:
> This series does the following improvements:
> 1) Add Svvptc, Zabha, and Ziccrse extension support (PATCH2 to PATCH3)
> 2) Add SBI system suspend support (PATCH5 to PATCH6)
> 3) Add "--cpu-type" command-line option supporting "min" and "max"
>    CPU types where "max" is the default (PATCH8 to PATCH10)
> 
> These patches can also be found in the riscv_more_exts_round6_v3 branch
> at: https://github.com/avpatel/kvmtool.git
> 
> [...]

Applied to kvmtool (master), thanks!

(I updated the headers myself after fixing the script we have).

[02/10] riscv: Add Svvptc extension support
        https://git.kernel.org/will/kvmtool/c/a9880860d781
[03/10] riscv: Add Zabha extension support
        https://git.kernel.org/will/kvmtool/c/8be1c78896b4
[04/10] riscv: Add Ziccrse extension support
        https://git.kernel.org/will/kvmtool/c/0641ed8c3763
[05/10] riscv: Add SBI system suspend support
        https://git.kernel.org/will/kvmtool/c/fcc316016e9f
[06/10] riscv: Make system suspend time configurable
        https://git.kernel.org/will/kvmtool/c/1132ace1c069
[07/10] riscv: Fix no params with nodefault segfault
        https://git.kernel.org/will/kvmtool/c/b6e9f38b28c9
[08/10] riscv: Include single-letter extensions in isa_info_arr[]
        https://git.kernel.org/will/kvmtool/c/d47ad017c404
[09/10] riscv: Add cpu-type command-line option
        https://git.kernel.org/will/kvmtool/c/a50e8d888be8
[10/10] riscv: Allow including extensions in the min CPU type using command-line
        https://git.kernel.org/will/kvmtool/c/1117dbc8ceb2

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

