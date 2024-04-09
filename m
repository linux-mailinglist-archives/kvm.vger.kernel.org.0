Return-Path: <kvm+bounces-14007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B532D89E0F5
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 19:02:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 07D47B268A6
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 17:00:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E101115381F;
	Tue,  9 Apr 2024 16:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KioPySOp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0826C15380D
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 16:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712681997; cv=none; b=HOhJI2MDpvTvtqnD2HLyvG0YUct4aGt+wE6xsocLjH8Sj0z06gZarXQp03rTNGmDOAL92waWDjDlhWZLXIUVs/X746YDXP9q5/FZsek6NknsNO6JjV1BJxupUCMgk8P2we85cYuaFP3ejavw8WU4l0I1B42/hI5iz0S0Xo38SWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712681997; c=relaxed/simple;
	bh=MIgHlkPBbkchIpcQAjUGVqe4R1hezaP1c12tE0nrjE0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P6A7+LYOpNLD41ik9TWWSpcA6HPy75aK733krUkacs9Sy7bYC74tz6fbsqZMuYV3bvdTtgdwqlQQ7ahsFoNQiTgGDbqFC2EfsTN/tQG8R2xhpV/16pJfFWrOCgYK8fIM9gS6MhumeC7KBGSK6g3bX5Unb91Re0jxs76I1ivjBwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KioPySOp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242EDC433B2;
	Tue,  9 Apr 2024 16:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712681996;
	bh=MIgHlkPBbkchIpcQAjUGVqe4R1hezaP1c12tE0nrjE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KioPySOphC0hzKU0m5kdLQOIJhq5nU9979Yo0a5EHHKP3b7cSigD6eByU+IJCsNng
	 bCCyNC3fh5AOpGRDDRJRFd8tciltxdR3S2mOfuwZKxD1vkhdrPk9W8X132CTryBQT6
	 xSe83gHKLInRRmG2uFVHOHmAzyd/7Fw8GgP6B0L/sPaH/sSU8Del1CmJr36Bmad5it
	 5A19nlP0K2OCI8NFJ0+KN/UiBEHsOUrBoK2Gg9mvCClfbT4nNrI/hxbyTGw1/DF44y
	 mzVXdscMQWlEapN2CvU5yL/5puJi1actsOuK6zCxuPHJowOcQZ3vttcYw4UYmDmTBA
	 JurK7YV3td+/Q==
From: Will Deacon <will@kernel.org>
To: kvm@vger.kernel.org,
	Sicheng Liu <lsc2001@outlook.com>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	julien.thierry.kdev@gmail.com
Subject: Re: [PATCH kvmtool v3] x86: Fix some memory sizes when setting up bios
Date: Tue,  9 Apr 2024 17:59:36 +0100
Message-Id: <171267519022.3165670.17623125713640397552.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <SY6P282MB373318D6241D56E074B040DFA3392@SY6P282MB3733.AUSP282.PROD.OUTLOOK.COM>
References: <SY6P282MB373318D6241D56E074B040DFA3392@SY6P282MB3733.AUSP282.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Sat, 30 Mar 2024 08:41:49 +0000, Sicheng Liu wrote:
> Sorry for this resending. Delete redundant auto-added header "kvm/bios.h".
> 
> In e820_setup(), the memory region of MB_BIOS is [MB_BIOS_BEGIN, MB_BIOS_END],
> so its memory size should be MB_BIOS_SIZE (= MB_BIOS_END - MB_BIOS_BEGIN + 1).
> The same thing goes for BDA, EBDA, MB_BIOS and VGA_ROM in setup_bios().
> By the way, a little change is made in setup_irq_handler() to avoid using
> hard coding.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] x86: Fix some memory sizes when setting up bios
      https://git.kernel.org/will/kvmtool/c/da4cfc3e5403

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

