Return-Path: <kvm+bounces-22123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66B2593A3F8
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 17:47:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1AB562843A6
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 15:47:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF74315821A;
	Tue, 23 Jul 2024 15:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pXoHB8h1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E027C1581F9;
	Tue, 23 Jul 2024 15:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721749630; cv=none; b=o8OE/nReAiqTzlRiyDgqdTCz5Zx9tvFOS9k1imUaoSbgovu3WO7TCfHcQ9OpxX00F+Equd9Y0S6L26kk3MrD3yZY4UuhF7vxb8hJGpa3HUn16C8Gt+CIF+Jwh4ZK6NwRKuIO0dzXWKYqY9VIUevldXoznpTxfZOC1Oq1MGNNCwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721749630; c=relaxed/simple;
	bh=3JN9dxvighzfjpWzdv9paN8pIPJJZsF8guaPs2MGAIc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BK5/dudUEMJVxeSdjwZFdp8LnRVJEbvBFFCjybF8CORJM/ffKRCLLUEOB9n4R26aFGqHcQ2YJKa2tskLXHrWQOeWEg3O/d1+NO6olze6E0ynVaEvBj0ItoEx/wQ6oVOb0ohtU3Kf9rfMrN/7MhAbxaLpCvdLsX0W9CzmhOQGB6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pXoHB8h1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D88CC4AF09;
	Tue, 23 Jul 2024 15:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721749629;
	bh=3JN9dxvighzfjpWzdv9paN8pIPJJZsF8guaPs2MGAIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pXoHB8h10BCHCuePeUGpHInmQ1Rx1Sefy+sCD6JFM+7smOyM2rsy4LfrXcEm0yC+h
	 4+phxQfV16AYMiWAIjOYA+QATBHb+H5TvH6vnufnnVyrBW9mtQVPE9AadfntHAGk16
	 iF7OI7GmZpbeRb0fB0K6XzOk3NUUEuwAtCPOpgw0hycePcxVEmbPnpChDrrFMWyVvV
	 jyDbNU/BSrC1W5N2+SuUvABJHOUpyZbFycua8lD3AyEAEb05+NeFbj8z/jNG5aZu8s
	 jEzvT3lty3ihH54m9/13lzEdsR2QQn+HZcG0Jivb+EYCGHzzM1QYc1jyrym7Fqxkdr
	 /07wq/ihb1NAw==
From: Will Deacon <will@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>
Cc: kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH] arm64/sysreg: Correct the values for GICv4.1
Date: Tue, 23 Jul 2024 16:46:55 +0100
Message-Id: <172174496081.280066.12871333713705365586.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240718215532.616447-1-rananta@google.com>
References: <20240718215532.616447-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 18 Jul 2024 21:55:32 +0000, Raghavendra Rao Ananta wrote:
> Currently, sysreg has value as 0b0010 for the presence of GICv4.1 in
> ID_PFR1_EL1 and ID_AA64PFR0_EL1, instead of 0b0011 as per ARM ARM.
> Hence, correct them to reflect ARM ARM.
> 
> 

Applied to arm64 (for-next/core), thanks!

[1/1] arm64/sysreg: Correct the values for GICv4.1
      https://git.kernel.org/arm64/c/f3dfcd25455b

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

