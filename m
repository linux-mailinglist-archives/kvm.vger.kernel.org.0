Return-Path: <kvm+bounces-8948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EAA6B858CF8
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 03:33:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 887651F22C4C
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 02:33:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3778D1B94C;
	Sat, 17 Feb 2024 02:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sTJPW/eQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D9023D0;
	Sat, 17 Feb 2024 02:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708137217; cv=none; b=fC99lcfEm5nqXfnFZL+8djZEAWIGsI6SJL5v0TDihELIa9rwmbHbd96/wW8c5nP07/M9gQtNd8dXX+Zbi/FJDXf+lRuWkt5I9qGJEf/s5TmqEofBO5rvnW+hxUiuqs9Md1kNu7k62U+vUmVPP5OMiZ3PFnObRXhuKVrrpMM+KtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708137217; c=relaxed/simple;
	bh=xyzc60yatFJ3EIuSM28pD2LFLavyJBimUvLYWwSqGOI=;
	h=Date:Content-Type:MIME-Version:From:To:Cc:In-Reply-To:References:
	 Message-Id:Subject; b=YcZllaY98H23hNstI4p3k0YmEmPLwsCjJ/tlfr6Rn5VfanTc8ynIBbrw74dvVKmlu8LO9DRIiVXBm/J6QlP/qv6Uf2gjzD7N+ArGEhrg6NH4huZTu25X2Mvq6Ye7efsobnMpBL8584/NcgV9/srmzXo87uVVt8HNu/OWi+w6Ki4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sTJPW/eQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798E9C433C7;
	Sat, 17 Feb 2024 02:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708137216;
	bh=xyzc60yatFJ3EIuSM28pD2LFLavyJBimUvLYWwSqGOI=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=sTJPW/eQmSYM5jfvpY6brmYtaPWJNo3jj3LCMDHpbISyWvMJywnH9SUxckYqsYXwe
	 Met6WrkeJNvdVxVqKCHOGe3QcOqdiiJJSwUFmv4/uotyTysZtcCGHW4Ozz4JaX9rg4
	 qQFYSq3iKbrJq01AHOQkYrAmIV6NNo3jPmhpgvr5Cwk//ixNXVww3fpOp1P4j/Y4zg
	 UOViqq42bLAFVDQuSCFY3LYzXKZajVbyNleMyesM1Q0GmGq5lBOkX4V2EcBgBkR+iC
	 7GDGmzoRRW0Ki6PaNObjW8F3YG4GDJsrVSQaoZHWTrN5MmEBEwTyP8ZfKJbQFeLUha
	 GEzJccGP/sANw==
Date: Fri, 16 Feb 2024 20:33:35 -0600
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Rob Herring <robh@kernel.org>
To: Atish Patra <atishp@rivosinc.com>
Cc: Evan Green <evan@rivosinc.com>, Atish Patra <atishp@atishpatra.org>, 
 Andrew Jones <ajones@ventanamicro.com>, Ingo Molnar <mingo@redhat.com>, 
 Jing Zhang <renyu.zj@linux.alibaba.com>, 
 Mark Rutland <mark.rutland@arm.com>, Guo Ren <guoren@kernel.org>, 
 linux-doc@vger.kernel.org, Will Deacon <will@kernel.org>, 
 kvm@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>, 
 kaiwenxue1@gmail.com, Ian Rogers <irogers@google.com>, 
 Yang Jihong <yangjihong1@huawei.com>, 
 Alexandre Ghiti <alexghiti@rivosinc.com>, devicetree@vger.kernel.org, 
 Conor Dooley <conor@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 linux-perf-users@vger.kernel.org, Palmer Dabbelt <palmer@dabbelt.com>, 
 Jiri Olsa <jolsa@kernel.org>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, 
 Adrian Hunter <adrian.hunter@intel.com>, kvm-riscv@lists.infradead.org, 
 Ley Foon Tan <leyfoon.tan@starfivetech.com>, 
 John Garry <john.g.garry@oracle.com>, 
 Samuel Holland <samuel.holland@sifive.com>, 
 Heiko Stuebner <heiko@sntech.de>, Anup Patel <anup@brainfault.org>, 
 Ji Sheng Teoh <jisheng.teoh@starfivetech.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Christian Brauner <brauner@kernel.org>, James Clark <james.clark@arm.com>, 
 Weilin Wang <weilin.wang@intel.com>, 
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, 
 Rob Herring <robh+dt@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
 =?utf-8?q?Cl=C3=A9ment_L=C3=A9ger?= <cleger@rivosinc.com>, 
 linux-riscv@lists.infradead.org
In-Reply-To: <20240217005738.3744121-9-atishp@rivosinc.com>
References: <20240217005738.3744121-1-atishp@rivosinc.com>
 <20240217005738.3744121-9-atishp@rivosinc.com>
Message-Id: <170813721337.1034359.14079032178586114678.robh@kernel.org>
Subject: Re: [PATCH RFC 08/20] dt-bindings: riscv: add Ssccfg ISA extension
 description


On Fri, 16 Feb 2024 16:57:26 -0800, Atish Patra wrote:
> Add description for the Ssccfg extension.
> 
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  .../devicetree/bindings/riscv/extensions.yaml       | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:
./Documentation/devicetree/bindings/riscv/extensions.yaml:131:1: [error] syntax error: found character '\t' that cannot start any token (syntax)

dtschema/dtc warnings/errors:
Documentation/devicetree/bindings/riscv/extensions.yaml:131:1: found a tab character where an indentation space is expected
./Documentation/devicetree/bindings/riscv/extensions.yaml:131:1: found a tab character where an indentation space is expected
  in "<unicode string>", line 125, column 24
  in "<unicode string>", line 131, column 1

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20240217005738.3744121-9-atishp@rivosinc.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.


