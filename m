Return-Path: <kvm+bounces-57536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D772B576CE
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 12:42:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 155771A23D7D
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 10:42:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 528572F39AE;
	Mon, 15 Sep 2025 10:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FKXB17uS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EDD2FCC17;
	Mon, 15 Sep 2025 10:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757932918; cv=none; b=SpWXYBkySYFf1Ck5O4JgLaF1N34q4lnf40C1z3HBINds7OIhAkM4FS7oiHQ47ypcAjrORvFYT8grdaCObADmedCghUUpCFR/8Jwq0WmNBNWkoZfe6xIlNdLPaa1iinuUuGzovuL4jU00btPLf8VC4DP6FT92xroDuOS/yQFqFuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757932918; c=relaxed/simple;
	bh=4BjLepU4AwvkrI0d43q0aFDK1GjRHaIm4CkmokzQ9SI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T2vINUS+kVK4LHucbCYcX0G9vaYMvYBtDYBij7uYxOdwcBrnLuiYtx4imLDidEItqhWYAUVRUaebS3XPo0JBhW/8dLKhmHUdCJy/UKlC0xWx0YTHgcmfviMm5PF2N0rewxP6oADq/nGNbX2C3ae3aIjzfHP4yv3LLMtGCe8DIZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FKXB17uS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F74C4CEF1;
	Mon, 15 Sep 2025 10:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757932917;
	bh=4BjLepU4AwvkrI0d43q0aFDK1GjRHaIm4CkmokzQ9SI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FKXB17uSwbZe+whIjd4zRzhq1ba+B4tNal7uYCuvuT/S8/7Sn8kRzxjdnJ+gtvsqK
	 l546xMXwcEVDqPsuJETGL6e77trVb+5Z3GKXvfhYlgO3+s8FHLeRluR7Nr0abCJB7x
	 /5d7O2U4kYzI0PIxAnvaJ1VLGj0xkcOQRQwVH3vORv+gBgYah0d7Z/JR5a+CMyAd8R
	 wPV05buDYcw0i+Z4IWXpGg9zVIZxh4Nc9t/JObhE0YSv0Ozc+nZyVH4eSD65CNx4l9
	 KHyqELQQiCrUtxxg8J7r0lBVLCiLdnTS2c61RWCVThb7jO+wL4FlUs5SCL7zrbEnji
	 Td6YbrVMt3Rgw==
Date: Mon, 15 Sep 2025 11:41:52 +0100
From: Will Deacon <will@kernel.org>
To: Paul Walmsley <pjw@kernel.org>
Cc: Atish Patra <atishp@rivosinc.com>, Anup Patel <anup@brainfault.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Mayuresh Chitale <mchitale@ventanamicro.com>,
	linux-riscv@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v6 0/8] Add SBI v3.0 PMU enhancements
Message-ID: <aMftcHLgBvH76erX@willie-the-truck>
References: <20250909-pmu_event_info-v6-0-d8f80cacb884@rivosinc.com>
 <f740b716-6c8b-46a5-31ae-ecc37e766152@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f740b716-6c8b-46a5-31ae-ecc37e766152@kernel.org>

On Mon, Sep 15, 2025 at 12:25:52AM -0600, Paul Walmsley wrote:
> On Tue, 9 Sep 2025, Atish Patra wrote:
> 
> > SBI v3.0 specification[1] added two new improvements to the PMU chaper.
> > The SBI v3.0 specification is frozen and under public review phase as
> > per the RISC-V International guidelines. 
> > 
> > 1. Added an additional get_event_info function to query event availablity
> > in bulk instead of individual SBI calls for each event. This helps in
> > improving the boot time.
> > 
> > 2. Raw event width allowed by the platform is widened to have 56 bits
> > with RAW event v2 as per new clarification in the priv ISA[2].
> > 
> > Apart from implementing these new features, this series improves the gpa
> > range check in KVM and updates the kvm SBI implementation to SBI v3.0.
> > 
> > The opensbi patches have been merged. This series can be found at [3].
> > 
> > [1] https://github.com/riscv-non-isa/riscv-sbi-doc/releases/download/v3.0-rc7/riscv-sbi.pdf 
> > [2] https://github.com/riscv/riscv-isa-manual/issues/1578
> > [3] https://github.com/atishp04/linux/tree/b4/pmu_event_info_v6
> > 
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> 
> For the series:
> 
> Acked-by: Paul Walmsley <pjw@kernel.org>

I was assuming this series would go via the Risc-V arch tree so please
shout if you were expecting me to take it via drivers/perf/!

Will

