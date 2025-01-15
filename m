Return-Path: <kvm+bounces-35486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 98BF0A11649
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 01:57:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF176188B544
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 00:57:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DA4A2E401;
	Wed, 15 Jan 2025 00:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dfybK6JS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6EE93C0B;
	Wed, 15 Jan 2025 00:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736902652; cv=none; b=tDeSH68VXDg2tBEufNi2TMf5z2JUR9gd83HydKhWXgX1bPTyRzZwhYrfAnObkppq1LgM4/YwZrb69ElRvKt2Khx132ZZJFRBMrCwLUXeKNmy3NsnWKkesl0WBnMrOVr0lsiiWurGlHRjnt/yJ/T/qme/CW+ih5zohy+omXarJDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736902652; c=relaxed/simple;
	bh=KGGNDzoaWvSUYYvzmYVu6FGehnU8B6otZzhgT9PcGl0=;
	h=Date:Content-Type:MIME-Version:From:Cc:To:In-Reply-To:References:
	 Message-Id:Subject; b=ktXDUfeDtxWMsbxluKwZwEeJQ3k2lrIVexAey+1Js9acnApNIGiOlE3f3BDIoqDQRUJUTbq8KXJBNYYywgmFwMAmix6uKIZGfEJ0UqP+XycU1a9XEYwy/96heQEXqztZPmuqohKunPtIIb3X8xyVrVZ5hkyMyQOAQrMPvSAC0YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dfybK6JS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9063C4CEDD;
	Wed, 15 Jan 2025 00:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736902652;
	bh=KGGNDzoaWvSUYYvzmYVu6FGehnU8B6otZzhgT9PcGl0=;
	h=Date:From:Cc:To:In-Reply-To:References:Subject:From;
	b=dfybK6JS3Et6WBGW9KdBFspT/KTVKi3djXQeQQ+vCsdquH0oxKA8TAiL2RBIHBQy3
	 qmvwqwUtlrFqOqAZDdiPT08X8XYi1ie6B4A7FIYnMtKbn66rkP4YHX3YrZuBmpTwyW
	 kvsPO6uwsv8Z6jpY2ht9krItPCPlEyVN2TaI0fTtoUtwKXGnZ0fXTP8dMxFQgZxigQ
	 09hHjXAJqFq/BF4e/FVLDH8UXVwJwOVHlMgiMFPsTr+YPtae310NzwKabz2CeZyAoF
	 Bd+CQUnkbufQIIAnLutb7IzJOpl4UK04alZfDJlsCw0seeI1zn2TfhBlDGH+CDEXu1
	 9Pi4ObO/0FpRw==
Date: Tue, 14 Jan 2025 18:57:31 -0600
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 linux-arm-kernel@lists.infradead.org, Anup Patel <anup@brainfault.org>, 
 Will Deacon <will@kernel.org>, weilin.wang@intel.com, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, kvm-riscv@lists.infradead.org, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, kvm@vger.kernel.org, 
 Atish Patra <atishp@atishpatra.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Conor Dooley <conor+dt@kernel.org>, linux-kernel@vger.kernel.org, 
 Conor Dooley <conor@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>, 
 Namhyung Kim <namhyung@kernel.org>, Palmer Dabbelt <palmer@sifive.com>, 
 linux-perf-users@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
 linux-riscv@lists.infradead.org, devicetree@vger.kernel.org, 
 Ingo Molnar <mingo@redhat.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Ian Rogers <irogers@google.com>
To: Atish Patra <atishp@rivosinc.com>
In-Reply-To: <20250114-counter_delegation-v2-4-8ba74cdb851b@rivosinc.com>
References: <20250114-counter_delegation-v2-0-8ba74cdb851b@rivosinc.com>
 <20250114-counter_delegation-v2-4-8ba74cdb851b@rivosinc.com>
Message-Id: <173690237126.2063459.986002304235117552.robh@kernel.org>
Subject: Re: [PATCH v2 04/21] dt-bindings: riscv: add Sxcsrind ISA
 extension description


On Tue, 14 Jan 2025 14:57:29 -0800, Atish Patra wrote:
> Add the S[m|s]csrind ISA extension description.
> 
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  Documentation/devicetree/bindings/riscv/extensions.yaml | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:
./Documentation/devicetree/bindings/riscv/extensions.yaml:149:1: [error] syntax error: found character '\t' that cannot start any token (syntax)

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/riscv/extensions.yaml: ignoring, error parsing file
./Documentation/devicetree/bindings/riscv/extensions.yaml:149:1: found character '\t' that cannot start any token
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/cpu/idle-states.example.dtb: cpu@0: False schema does not allow {'device_type': ['cpu'], 'compatible': ['riscv'], 'reg': [[0]], 'riscv,isa': ['rv64imafdc'], 'mmu-type': ['riscv,sv48'], 'cpu-idle-states': [[13], [14], [15], [16]], 'interrupt-controller': {'#interrupt-cells': 1, 'compatible': ['riscv,cpu-intc'], 'interrupt-controller': True}, '$nodename': ['cpu@0']}
	from schema $id: http://devicetree.org/schemas/riscv/cpus.yaml#
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/cpu/idle-states.example.dtb: cpu@0: Unevaluated properties are not allowed ('riscv,isa' was unexpected)
	from schema $id: http://devicetree.org/schemas/riscv/cpus.yaml#
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/cpu/idle-states.example.dtb: cpu@1: False schema does not allow {'device_type': ['cpu'], 'compatible': ['riscv'], 'reg': [[1]], 'riscv,isa': ['rv64imafdc'], 'mmu-type': ['riscv,sv48'], 'cpu-idle-states': [[13], [14], [15], [16]], 'interrupt-controller': {'#interrupt-cells': 1, 'compatible': ['riscv,cpu-intc'], 'interrupt-controller': True}, '$nodename': ['cpu@1']}
	from schema $id: http://devicetree.org/schemas/riscv/cpus.yaml#
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/cpu/idle-states.example.dtb: cpu@1: Unevaluated properties are not allowed ('riscv,isa' was unexpected)
	from schema $id: http://devicetree.org/schemas/riscv/cpus.yaml#
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/cpu/idle-states.example.dtb: cpu@10: False schema does not allow {'device_type': ['cpu'], 'compatible': ['riscv'], 'reg': [[16]], 'riscv,isa': ['rv64imafdc'], 'mmu-type': ['riscv,sv48'], 'cpu-idle-states': [[17], [18], [19], [20]], 'interrupt-controller': {'#interrupt-cells': 1, 'compatible': ['riscv,cpu-intc'], 'interrupt-controller': True}, '$nodename': ['cpu@10']}
	from schema $id: http://devicetree.org/schemas/riscv/cpus.yaml#
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/cpu/idle-states.example.dtb: cpu@10: Unevaluated properties are not allowed ('riscv,isa' was unexpected)
	from schema $id: http://devicetree.org/schemas/riscv/cpus.yaml#
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/cpu/idle-states.example.dtb: cpu@11: False schema does not allow {'device_type': ['cpu'], 'compatible': ['riscv'], 'reg': [[17]], 'riscv,isa': ['rv64imafdc'], 'mmu-type': ['riscv,sv48'], 'cpu-idle-states': [[17], [18], [19], [20]], 'interrupt-controller': {'#interrupt-cells': 1, 'compatible': ['riscv,cpu-intc'], 'interrupt-controller': True}, '$nodename': ['cpu@11']}
	from schema $id: http://devicetree.org/schemas/riscv/cpus.yaml#
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/cpu/idle-states.example.dtb: cpu@11: Unevaluated properties are not allowed ('riscv,isa' was unexpected)
	from schema $id: http://devicetree.org/schemas/riscv/cpus.yaml#
make[2]: *** Deleting file 'Documentation/devicetree/bindings/riscv/extensions.example.dts'
Documentation/devicetree/bindings/riscv/extensions.yaml:149:1: found character '\t' that cannot start any token
make[2]: *** [Documentation/devicetree/bindings/Makefile:26: Documentation/devicetree/bindings/riscv/extensions.example.dts] Error 1
make[2]: *** Waiting for unfinished jobs....
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/riscv/cpus.example.dtb: cpu@0: False schema does not allow {'clock-frequency': 0, 'compatible': ['sifive,rocket0', 'riscv'], 'device_type': ['cpu'], 'i-cache-block-size': 64, 'i-cache-sets': 128, 'i-cache-size': 16384, 'reg': [[0]], 'riscv,isa-base': ['rv64i'], 'riscv,isa-extensions': [1761635584, 1627415296], 'interrupt-controller': {'#interrupt-cells': 1, 'compatible': ['riscv,cpu-intc'], 'interrupt-controller': True}, '$nodename': ['cpu@0']}
	from schema $id: http://devicetree.org/schemas/riscv/cpus.yaml#
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/riscv/cpus.example.dtb: cpu@0: Unevaluated properties are not allowed ('riscv,isa-base', 'riscv,isa-extensions' were unexpected)
	from schema $id: http://devicetree.org/schemas/riscv/cpus.yaml#
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/riscv/cpus.example.dtb: cpu@1: False schema does not allow {'clock-frequency': 0, 'compatible': ['sifive,rocket0', 'riscv'], 'd-cache-block-size': 64, 'd-cache-sets': 64, 'd-cache-size': 32768, 'd-tlb-sets': 1, 'd-tlb-size': 32, 'device_type': ['cpu'], 'i-cache-block-size': 64, 'i-cache-sets': 64, 'i-cache-size': 32768, 'i-tlb-sets': 1, 'i-tlb-size': 32, 'mmu-type': ['riscv,sv39'], 'reg': [[1]], 'tlb-split': True, 'riscv,isa-base': ['rv64i'], 'riscv,isa-extensions': [1761635584, 1627416064, 1677746944], 'interrupt-controller': {'#interrupt-cells': 1, 'compatible': ['riscv,cpu-intc'], 'interrupt-controller': True}, '$nodename': ['cpu@1']}
	from schema $id: http://devicetree.org/schemas/riscv/cpus.yaml#
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/riscv/cpus.example.dtb: cpu@1: Unevaluated properties are not allowed ('riscv,isa-base', 'riscv,isa-extensions' were unexpected)
	from schema $id: http://devicetree.org/schemas/riscv/cpus.yaml#
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/riscv/cpus.example.dtb: cpu@0: False schema does not allow {'device_type': ['cpu'], 'reg': [[0]], 'compatible': ['riscv'], 'mmu-type': ['riscv,sv48'], 'riscv,isa-base': ['rv64i'], 'riscv,isa-extensions': [1761635584, 1627416064, 1677746944], 'interrupt-controller': {'#interrupt-cells': 1, 'interrupt-controller': True, 'compatible': ['riscv,cpu-intc']}, '$nodename': ['cpu@0']}
	from schema $id: http://devicetree.org/schemas/riscv/cpus.yaml#
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/riscv/cpus.example.dtb: cpu@0: Unevaluated properties are not allowed ('riscv,isa-base', 'riscv,isa-extensions' were unexpected)
	from schema $id: http://devicetree.org/schemas/riscv/cpus.yaml#
make[1]: *** [/builds/robherring/dt-review-ci/linux/Makefile:1506: dt_binding_check] Error 2
make: *** [Makefile:251: __sub-make] Error 2

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20250114-counter_delegation-v2-4-8ba74cdb851b@rivosinc.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.


