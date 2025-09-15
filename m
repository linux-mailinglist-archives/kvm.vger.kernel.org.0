Return-Path: <kvm+bounces-57511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAE5BB5702B
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 08:26:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C08C174A0C
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 06:26:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5239A28000F;
	Mon, 15 Sep 2025 06:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NlJfJLF7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C44317C21E;
	Mon, 15 Sep 2025 06:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757917552; cv=none; b=WkbkOAMETfozVncTZhYxM4XtNu0Mh2KDhyafXvkaEKePP/WhkhsIZ4gRVy02ioS2yHyx4Gb6shWqvNs2mVFRuG5UVAjv9Z8FDxHvtbtm7xTz10d2XqGKnXDUe3GVwFhImhMOSALn56s9FnCoEuNVR0X6ARE2v1wzqgzJZzwDeyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757917552; c=relaxed/simple;
	bh=YXcIhrbg/wc7/PC0yhFG/NxcxwFsfdkDJDbFz4bgiJo=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=D3K3p9fPq25HyzWU692Bd/iydEuVbPFusiyRPM4HAMzQtkEwU9l37PmGG2UAQSgPzxeJoRcQa1lDOXHZtM5UBdPrqzCbk4FKDrOgDszJMBxtyfjJyIs7v9wp0GzjWPBw6VPvx/gasvbRed+qid+eYhaVQ9V2LdogrBQM6yPuLJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NlJfJLF7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D65C4CEF1;
	Mon, 15 Sep 2025 06:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757917552;
	bh=YXcIhrbg/wc7/PC0yhFG/NxcxwFsfdkDJDbFz4bgiJo=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=NlJfJLF7m2EQcyHFVyI/13N9QUB8Cft+tGjjcwm2v4qFJzXXHZcfIRcaPOKWtEm3Q
	 53a67rBuOs6EzCf1tJOPVATA/lku9Lqm64q8eQm0oyU8otM22h1qtPmBlYUfgazuIX
	 s2vckc1AEmG1XLvcJp0hmMA/Z0NSoElXF3If2J5IitpCaJkxwRs7dmLWQiBYHlyyw0
	 l1jdYhYCsltrJlJrNKjcaicpNUdONiCcNwwR+XNFL0yckEvExlW1ZK730jSMdIqkDT
	 trxkfG+Vyyhz95CaL1S3lhlvuXn4oCm7QBaA2oPoNnjxHqU5OViT/BuZrjgR6hLbe7
	 9oy4QSJJvrFdw==
Date: Mon, 15 Sep 2025 00:25:52 -0600 (MDT)
From: Paul Walmsley <pjw@kernel.org>
To: Atish Patra <atishp@rivosinc.com>, Anup Patel <anup@brainfault.org>
cc: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
    Paul Walmsley <paul.walmsley@sifive.com>, 
    Palmer Dabbelt <palmer@dabbelt.com>, 
    Mayuresh Chitale <mchitale@ventanamicro.com>, 
    linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
    linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
    kvm-riscv@lists.infradead.org, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v6 0/8] Add SBI v3.0 PMU enhancements
In-Reply-To: <20250909-pmu_event_info-v6-0-d8f80cacb884@rivosinc.com>
Message-ID: <f740b716-6c8b-46a5-31ae-ecc37e766152@kernel.org>
References: <20250909-pmu_event_info-v6-0-d8f80cacb884@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 9 Sep 2025, Atish Patra wrote:

> SBI v3.0 specification[1] added two new improvements to the PMU chaper.
> The SBI v3.0 specification is frozen and under public review phase as
> per the RISC-V International guidelines. 
> 
> 1. Added an additional get_event_info function to query event availablity
> in bulk instead of individual SBI calls for each event. This helps in
> improving the boot time.
> 
> 2. Raw event width allowed by the platform is widened to have 56 bits
> with RAW event v2 as per new clarification in the priv ISA[2].
> 
> Apart from implementing these new features, this series improves the gpa
> range check in KVM and updates the kvm SBI implementation to SBI v3.0.
> 
> The opensbi patches have been merged. This series can be found at [3].
> 
> [1] https://github.com/riscv-non-isa/riscv-sbi-doc/releases/download/v3.0-rc7/riscv-sbi.pdf 
> [2] https://github.com/riscv/riscv-isa-manual/issues/1578
> [3] https://github.com/atishp04/linux/tree/b4/pmu_event_info_v6
> 
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

For the series:

Acked-by: Paul Walmsley <pjw@kernel.org>


- Paul



