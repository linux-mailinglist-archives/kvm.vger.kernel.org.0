Return-Path: <kvm+bounces-38573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 735C4A3C1C7
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 15:18:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D84FA16D86F
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 14:12:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 536011F8BBC;
	Wed, 19 Feb 2025 14:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="acUVZYzq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F7E1EEA54;
	Wed, 19 Feb 2025 14:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739974160; cv=none; b=l48XeH8lOji//l55hNFNtNOax69NxdWtA5EyPErSopbX3RjfDWZtiSYCWz5q79jGMzDWsSaFQ5PhCRFHDYFESDswB7mEyPTBoHJCw0N0IwI3RWcY+E81vhyXzwHRRIM3+z+pwpMacBE/CYHXG66fn7kN3AlstuCig+RIf4oOMLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739974160; c=relaxed/simple;
	bh=XltJ1uE6oJiW72uTsp9SrYcOrHJzHFDnZJnAMAUBblA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SZIBoGZ4Bv575F9B9ftu0qLNnd4v39/KN335eNaUVW2aS2CqT0ziqZOwuqEXX1i/FpcSKHYQh/g2a6aYve2rfvD7qGTrymZ7nBCK2iWsxMt18p5UBZEjaHkrYIQFK2JBEJsDRB/LJND7qXnMQ4okRa2HX65mssUwWzUIVVawV4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=acUVZYzq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88685C4CED1;
	Wed, 19 Feb 2025 14:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739974158;
	bh=XltJ1uE6oJiW72uTsp9SrYcOrHJzHFDnZJnAMAUBblA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=acUVZYzqAWbcvvKzl6CpR9f5/7Vrr3xgvB8rOS7mhJioQ8EbRLBSTpeq2HICycYiV
	 oJ59NEuQvlkJ+5C5H4H0oujqKYXh+kiYt+fX6gVaoX+vy/Cgl6aPL18Ccj6z4ESgfc
	 i6rwGjO/Af/76JpJWs7gNoov6dwDIHVwLUVHJlL7JLyfM5o7j10D/SEijAwXenL+ej
	 o+iK4JjxghZQjEZ2s5SotLHjrVTuPWdKVC3WOgh1QXCsFIsm0YwNS/DbC8Lw4vqFck
	 L/yZET9ERQBfsTzGnvjYdbpEtOfu1C3uzvwMUEbV8MmudDKE5F4JO9Fyt7uxeHiD0H
	 hI7hB4kktsANw==
Date: Wed, 19 Feb 2025 08:09:17 -0600
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Atish Patra <atishp@rivosinc.com>
Cc: Anup Patel <anup@brainfault.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Atish Patra <atishp@atishpatra.org>,
	Ian Rogers <irogers@google.com>,
	linux-arm-kernel@lists.infradead.org, weilin.wang@intel.com,
	Paul Walmsley <paul.walmsley@sifive.com>, kvm@vger.kernel.org,
	Jiri Olsa <jolsa@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>, devicetree@vger.kernel.org,
	Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, linux-riscv@lists.infradead.org,
	Peter Zijlstra <peterz@infradead.org>,
	linux-perf-users@vger.kernel.org, Conor Dooley <conor@kernel.org>,
	Will Deacon <will@kernel.org>, kvm-riscv@lists.infradead.org,
	Adrian Hunter <adrian.hunter@intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>
Subject: Re: [PATCH v4 04/21] dt-bindings: riscv: add Sxcsrind ISA extension
 description
Message-ID: <173997415655.2409606.4528669810137132252.robh@kernel.org>
References: <20250205-counter_delegation-v4-0-835cfa88e3b1@rivosinc.com>
 <20250205-counter_delegation-v4-4-835cfa88e3b1@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250205-counter_delegation-v4-4-835cfa88e3b1@rivosinc.com>


On Wed, 05 Feb 2025 23:23:09 -0800, Atish Patra wrote:
> Add the S[m|s]csrind ISA extension description.
> 
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  Documentation/devicetree/bindings/riscv/extensions.yaml | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 

Acked-by: Rob Herring (Arm) <robh@kernel.org>


