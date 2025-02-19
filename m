Return-Path: <kvm+bounces-38574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F1DFA3C1D8
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 15:19:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D34783BEE18
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 14:12:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 154251FC0ED;
	Wed, 19 Feb 2025 14:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TccyuFSR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6841EB18E;
	Wed, 19 Feb 2025 14:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739974184; cv=none; b=g7eZHIslFkG1Nq5+ofJE/b+fe1JydejrA2ejORo5sRfwchjwxti4wsc/6slvDRcr2fivijklTZ6XOJgHdEi9vVbsygxUlk0rmNJu7pot25I3U78cYCOJ2tDFXDkiSMOVrCDuGOU8RT7CqLxjP459HRxf5hOlRQxHTWmK83Q2mAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739974184; c=relaxed/simple;
	bh=JWgcAq5A9ztdHbWMUTio29UETb/IscdfA8OBtkFemUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WvdAphAXxrk1I/biowJsz8a4SKGerFOPObNBgKiru749C00SOIurpHhLBa9DzBUi3xfDuZ05yCH/oD54zzLJtQAm1B8FsnK/QxsNl4i6KPLoZSB7rhsBbI0VD9nAzbQfIRXU4G21ztnmvz8tpUZZ+HOOxNp0LcjvRqb4oTf7G9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TccyuFSR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65FDAC4CED1;
	Wed, 19 Feb 2025 14:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739974183;
	bh=JWgcAq5A9ztdHbWMUTio29UETb/IscdfA8OBtkFemUU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TccyuFSRpBorHgFXQPF4jywQnxaSyjRv5kG0R1jqKWyU4qXc+AvWbZPQalZw47dNY
	 OIyGPzJhUXQrWy8URny+Ye7RihHebYiW0UsSKZCOe7SzmxKwsroHZhPWIgJqrwm7tO
	 w+f5r48Z4U/KBR7wKl5OsddGrT5Jiq7+apwAz3kkyOmUIjMPqxgUO9gVgi5hSyGJL4
	 /qs8Li8q3E432iMYZ4dvsHbL0Ymu6nVunLHBPYdZ1xsmtD3cdsjIwiRuvUhOPm1in5
	 He6Un2pb1KKcEuJxV9heTakSXyRZMo1BzaRq7puhdlvspqo+DvYQj80PmMMkrCByJx
	 EVxkVZcTdkhog==
Date: Wed, 19 Feb 2025 08:09:42 -0600
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Atish Patra <atishp@rivosinc.com>
Cc: Will Deacon <will@kernel.org>, Conor Dooley <conor@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Ian Rogers <irogers@google.com>,
	linux-kernel@vger.kernel.org,
	Arnaldo Carvalho de Melo <acme@kernel.org>, kvm@vger.kernel.org,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Anup Patel <anup@brainfault.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Conor Dooley <conor+dt@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
	Atish Patra <atishp@atishpatra.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-riscv@lists.infradead.org,
	Peter Zijlstra <peterz@infradead.org>,
	Namhyung Kim <namhyung@kernel.org>, devicetree@vger.kernel.org,
	kvm-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	linux-perf-users@vger.kernel.org,
	Adrian Hunter <adrian.hunter@intel.com>, weilin.wang@intel.com
Subject: Re: [PATCH v4 07/21] dt-bindings: riscv: add Smcntrpmf ISA extension
 description
Message-ID: <173997417868.2413662.12513351374335592804.robh@kernel.org>
References: <20250205-counter_delegation-v4-0-835cfa88e3b1@rivosinc.com>
 <20250205-counter_delegation-v4-7-835cfa88e3b1@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250205-counter_delegation-v4-7-835cfa88e3b1@rivosinc.com>


On Wed, 05 Feb 2025 23:23:12 -0800, Atish Patra wrote:
> Add the description for Smcntrpmf ISA extension
> 
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  Documentation/devicetree/bindings/riscv/extensions.yaml | 6 ++++++
>  1 file changed, 6 insertions(+)
> 

Acked-by: Rob Herring (Arm) <robh@kernel.org>


