Return-Path: <kvm+bounces-23225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97EA8947C21
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 15:45:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA11D1C21CDB
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 13:45:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E03CE40856;
	Mon,  5 Aug 2024 13:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h/Y+/zBf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F833F8F7
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 13:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722865397; cv=none; b=FnsV7EaS6I7hhiAYV2jEhTWK9J3lJfIRVbpCdiUoGeIW68z7vb0W6l8uutQTV66W7U1h1dMIkDgtzH/8LUejsSvAC1V46ZvBSGJicGSaL8noyYvMWKx8Bn2yFY+UFaqA0QaKSdDvR6xz7bZU4ty9QkShjs03MPxWx4fnVeYg0fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722865397; c=relaxed/simple;
	bh=c5+B+MXnRXdhqDRPGmas+FKaGdBPXX9Ji7C8FmRDXeI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V73ljOjtRLivVJH2FjkD1csBIGi1BiCmbKDqJqEFM+629Ay/qs0qqU9TXZcPdFSoLlfz3jzJPYaYs/6gGnKWoJ8stqABv6l/RR1qv+aOg6F+XW9b2xn5zeTNHLX1QbmCg1WWESCF9OzU0lQy06B3T3XbdWy62nrhy0J+cYiaXuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h/Y+/zBf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1EE8C4AF0E;
	Mon,  5 Aug 2024 13:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722865396;
	bh=c5+B+MXnRXdhqDRPGmas+FKaGdBPXX9Ji7C8FmRDXeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h/Y+/zBfYnHiAEd/t5VxfwZ2VLjY2Wfkz8glb9Aj8gVOHezSFXEHUKKRO4ZQudTsq
	 OcQW0dccwUyHOOyzVJaD5B0dxgUpoR/rB8nAQVnyiD/c5aLmiJD6w5NjDvcGjy20ex
	 m6hX0usOUuamFTq8rt9APDaB4Hknms7k9HtL4LUR9DiLYy5sgMsLWS7suHV2t5lEFz
	 6u6IMJ+m/RE6i5KQi3zILs4LbhnUi+tFgFH7CovCrAob6EHatnFovgSv/7khnL6vRv
	 7XjDmEIa9dx62YDZXk/YirVuIKf2WRSqZXsS6h+b98C+xKEjmiUMS7lXUiXOK8V4mN
	 HTr5HWbC7tmfQ==
From: Will Deacon <will@kernel.org>
To: Julien Thierry <julien.thierry.kdev@gmail.com>,
	Andre Przywara <andre.przywara@arm.com>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	kvm@vger.kernel.org,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	=?UTF-8?q?J=20=2E=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Subject: Re: [PATCH kvmtool] remove wordsize.h inclusion (for musl compatibility)
Date: Mon,  5 Aug 2024 14:43:11 +0100
Message-Id: <172286501786.1822259.14590771620477855919.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240801111054.818765-1-andre.przywara@arm.com>
References: <20240801111054.818765-1-andre.przywara@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 01 Aug 2024 12:10:54 +0100, Andre Przywara wrote:
> The wordsize.h header file and the __WORDSIZE definition do not seem
> to be universal, the musl libc for instance has the definition in a
> different header file. This breaks compilation of kvmtool against musl.
> 
> The two leading underscores suggest a compiler-internal symbol anyway, so
> let's just remove that particular macro usage entirely, and replace it
> with the number we really want: the size of a "long" type.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] remove wordsize.h inclusion (for musl compatibility)
      https://git.kernel.org/will/kvmtool/c/0592f8f829c8

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

