Return-Path: <kvm+bounces-35487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 777D0A1164D
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 01:58:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E8ED47A326A
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 00:57:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 148104436E;
	Wed, 15 Jan 2025 00:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E8ZC0HYh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2623835969;
	Wed, 15 Jan 2025 00:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736902655; cv=none; b=cT4pGDW3BvbahCgR6QSwN+UhvtwEwRndaRs1CDnVAOS09iz+nWA6HPAJH01uiIef/nQa9D5x8C8c+bvFY/LBiB8j1eNqukSWVGpd9PEfe0t+G8safiZW6oQnOzKTMLYlAHzMl812SypPGvWRiL4e4ftUETq+S4XcV+Ne+L4Fnl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736902655; c=relaxed/simple;
	bh=E5F1TruT3qFWIpE0gZRapnmjQqlLtDzwzVIONB+NJTE=;
	h=Date:Content-Type:MIME-Version:From:Cc:To:In-Reply-To:References:
	 Message-Id:Subject; b=nqwvXz5go12ApNKR8OAgFVhsqIjTL9zU8A/6Yo5QPy/nD50kKG9lr9k6G/Ch4OrQO3wxV2t+RwYpykmO7em6PfmQhMDrzQV/Prm/hKh8g2Pnbv2ruKUNbe9D04tkvHcxKelRCErkDzX7nULgd1Lm3BOvD2WmEmb9CGGlP9brmog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E8ZC0HYh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D69C4CEDD;
	Wed, 15 Jan 2025 00:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736902653;
	bh=E5F1TruT3qFWIpE0gZRapnmjQqlLtDzwzVIONB+NJTE=;
	h=Date:From:Cc:To:In-Reply-To:References:Subject:From;
	b=E8ZC0HYh+oK/S/g901Rmeb7kofhXSeYcTgsyYLyVs01V883b8eg+oCadnzsZvyeHp
	 BBbx2G2QIX9txI1ZtB+hGYcFwvr/WDeGaNyPWrvJyOOo/YH2pRBGt43opN+oZ8yq1U
	 qwx2J0scKU3mRlexxp5YzcFLMdMW5EtJKiVAc1ZM8kXrKNOeFmm7A4uGUgIobo4SZX
	 ikraH3oUGbksFIpGx2qcBZ8cX59cEqLtYtIR2r/FABlpSbkEp1WBX0B/MjAEi6snUx
	 YJv4kW7KwjO99j2P0HfBeK9q6LRNZU0Y/NJRo/nc2CXdPxEFtRIYEVHwcSTQoQUFHx
	 fWa8rEKKXtaog==
Date: Tue, 14 Jan 2025 18:57:32 -0600
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Palmer Dabbelt <palmer@sifive.com>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Will Deacon <will@kernel.org>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Namhyung Kim <namhyung@kernel.org>, Ian Rogers <irogers@google.com>, 
 linux-riscv@lists.infradead.org, Atish Patra <atishp@atishpatra.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, Anup Patel <anup@brainfault.org>, 
 Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org, 
 Ingo Molnar <mingo@redhat.com>, kvm-riscv@lists.infradead.org, 
 linux-perf-users@vger.kernel.org, weilin.wang@intel.com, 
 Conor Dooley <conor@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, kvm@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, Palmer Dabbelt <palmer@dabbelt.com>, 
 Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>, 
 linux-kernel@vger.kernel.org
To: Atish Patra <atishp@rivosinc.com>
In-Reply-To: <20250114-counter_delegation-v2-8-8ba74cdb851b@rivosinc.com>
References: <20250114-counter_delegation-v2-0-8ba74cdb851b@rivosinc.com>
 <20250114-counter_delegation-v2-8-8ba74cdb851b@rivosinc.com>
Message-Id: <173690251211.2066548.13200770896119335906.robh@kernel.org>
Subject: Re: [PATCH v2 08/21] dt-bindings: riscv: add Ssccfg ISA extension
 description


On Tue, 14 Jan 2025 14:57:33 -0800, Atish Patra wrote:
> Add description for the Ssccfg extension.
> 
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  Documentation/devicetree/bindings/riscv/extensions.yaml | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:
./Documentation/devicetree/bindings/riscv/extensions.yaml:131:1: [error] syntax error: found character '\t' that cannot start any token (syntax)

dtschema/dtc warnings/errors:
./Documentation/devicetree/bindings/riscv/extensions.yaml:131:1: found character '\t' that cannot start any token
Documentation/devicetree/bindings/riscv/extensions.yaml:131:1: found character '\t' that cannot start any token

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20250114-counter_delegation-v2-8-8ba74cdb851b@rivosinc.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.


