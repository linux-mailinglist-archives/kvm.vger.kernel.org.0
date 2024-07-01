Return-Path: <kvm+bounces-20798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DDE4C91E022
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 15:01:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 901BF1F234EA
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 13:01:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03B3A15B113;
	Mon,  1 Jul 2024 13:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sX4NA97c"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B6114D6E1;
	Mon,  1 Jul 2024 13:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719838894; cv=none; b=ShfjQVUaeASf0flvVzvznc1YdmFBh1eY2iph2THtaRwTRsRZk4YdRLHG4HA7sPMUmIHoCoMtVNjlKyGbVW4ZUzSBAgl53JOW9zc1fINJ76rvea95eXZO7s9pRzDYV3sEunp44RyvmD0xJ5Voc6hYjevhbVopg3cvaU1A6czxdhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719838894; c=relaxed/simple;
	bh=mzcB+fYp3o9NJjTjsfH7uSf97jiaMjiCzdHrbPN4x/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mNneA+cMoLRzUtW7LCV5WutuAy7cbEzzuhmYX2eptLZw8Ibogb0kQ+UwRd0iHBTU1eVtQa5mTWgraCzoAIS37qWYgEA1kvjps0U6myZRD6y/wT3nJ+NFqP5e2avqCBj0CE14SvnFw8zTFI7n3K6u9p6VSnTmP6h0SPCEj0yBpME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sX4NA97c; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61DFC116B1;
	Mon,  1 Jul 2024 13:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719838893;
	bh=mzcB+fYp3o9NJjTjsfH7uSf97jiaMjiCzdHrbPN4x/0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sX4NA97c5+M3LFDkuGDmaVnn/H9lqdywQTGi+jxtly5k1AKfc5AdVHcAPDo+4ctLK
	 Yo31K7dSkmvLiKRA+jxdP0vmelQs2BzJm5Om54DuXw5S665Xop1Suz19U/xaui/sxx
	 /69EGjx8QiSxvyBUkFCafe/RV4ew1fGgVW3CI7Qy1uWSERd6c4/Kp8sM8fPfP8IvXV
	 7L0A1hcoerKhduog+LaCtUpLMV6f9YRybnBvrK0AlwLMvD80qee5VyvAdsc8n9UY5Y
	 cQsutZuPE+rGLLEPgfhltbn6nMO8wUtwwU4OzhFhMmLlu+1ih/2FHHNSqG+/J0dJtC
	 TLfebFRb2V83g==
Date: Mon, 1 Jul 2024 14:01:27 +0100
From: Will Deacon <will@kernel.org>
To: Atish Patra <atishp@rivosinc.com>
Cc: linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org,
	Atish Patra <atishp@atishpatra.org>,
	Anup Patel <anup@brainfault.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, garthlei@pku.edu.cn
Subject: Re: [PATCH v4 0/3] Assorted fixes in RISC-V PMU driver
Message-ID: <20240701130127.GA2250@willie-the-truck>
References: <20240628-misc_perf_fixes-v4-0-e01cfddcf035@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240628-misc_perf_fixes-v4-0-e01cfddcf035@rivosinc.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Jun 28, 2024 at 12:51:40AM -0700, Atish Patra wrote:
> This series contains 3 fixes out of which the first one is a new fix
> for invalid event data reported in lkml[2]. The last two are v3 of Samuel's
> patch[1]. I added the RB/TB/Fixes tag and moved 1 unrelated change
> to its own patch. I also changed an error message in kvm vcpu_pmu from
> pr_err to pr_debug to avoid redundant failure error messages generated
> due to the boot time quering of events implemented in the patch[1]

I'm assuming this series will go via the riscv arch tree, but please
shout if that's not the case.

Will

