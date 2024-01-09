Return-Path: <kvm+bounces-5872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BA11827FC5
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 08:50:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1C4D8B24E90
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 07:50:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1D30B66C;
	Tue,  9 Jan 2024 07:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jwUqrDO8"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D25225102
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 07:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 9 Jan 2024 16:50:05 +0900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1704786616;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jC0LcHQAj5sU6xwMTRYWTxbuyexf66+yJ6ABxO0uBs8=;
	b=jwUqrDO82RRuyPdvS0rbiSFrAaCsnr36tatZfwTSAjpYXF/JsXX4ArfR4ppv7ySIAWpAWJ
	FVLMSBY8knAInm+HUW82uHpkXvVGvy6W3kgyNYyeKGazDmf+7NKAuNLfaYPmxbfgwEKX5M
	McDblqfMjuevQgCN5Hz1rstUOV5CBuk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Itaru Kitayama <itaru.kitayama@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Zenghui Yu <yuzenghui@huawei.com>, Eric Auger <eauger@redhat.com>,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org, Mark Brown <broonie@kernel.org>,
	Jing Zhang <jingzhangos@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>, Marc Zyngier <maz@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 5/5] KVM: arm64: selftests: Test for setting ID
 register from usersapce
Message-ID: <ZZz6rfBKsN14GMaq@vm3>
References: <20231011195740.3349631-1-oliver.upton@linux.dev>
 <20231011195740.3349631-6-oliver.upton@linux.dev>
 <e0facec9-8c50-10cb-fd02-1214f9a49571@redhat.com>
 <ab1337bc-d4a2-0afc-3e26-0d50dff4ea73@huawei.com>
 <ZZx5y_iy9kXg47SW@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZx5y_iy9kXg47SW@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 08, 2024 at 10:40:11PM +0000, Oliver Upton wrote:
> Hi Zenghui,
> 
> On Fri, Jan 05, 2024 at 05:07:08PM +0800, Zenghui Yu wrote:
> > On 2023/10/19 16:38, Eric Auger wrote:
> > 
> > > > +static const struct reg_ftr_bits ftr_id_aa64dfr0_el1[] = {
> > > > +	S_REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64DFR0_EL1, PMUVer, 0),
> > >
> > > Strictly speaking this is not always safe to have a lower value. For
> > > instance: From Armv8.1, if FEAT_PMUv3 is implemented, the value 0b0001
> > > is not permitted. But I guess this consistency is to be taken into
> > > account by the user space. But may be wort a comment. Here and below
> > > 
> > > You may at least clarify what does mean 'safe'
> > >
> > > > +	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64DFR0_EL1, DebugVer, 0),
> > 
> > I've seen the following failure on Cortex A72 where
> > ID_AA64DFR0_EL1.DebugVer is 6.
> 
> Ah, yes, the test is wrong. KVM enforces a minimum value of 0x6 on this
> field, yet get_safe_value() returns 0x5 for the field.

This is observed with the RevC AEM FVP as well.

Thanks,
Itaru.

> 
> Jing, do you have time to check this test for similar failures and send
> out a fix for Zenghui's observations?
> 
> > # ./aarch64/set_id_regs
> > TAP version 13
> > 1..79
> > ok 1 ID_AA64DFR0_EL1_PMUVer
> > ==== Test Assertion Failure ====
> >   include/kvm_util_base.h:553: !ret
> >   pid=2288505 tid=2288505 errno=22 - Invalid argument
> >      1	0x0000000000402787: vcpu_set_reg at kvm_util_base.h:553
> > (discriminator 6)
> >      2	 (inlined by) test_reg_set_success at set_id_regs.c:342
> > (discriminator 6)
> >      3	 (inlined by) test_user_set_reg at set_id_regs.c:413 (discriminator
> > 6)
> >      4	0x0000000000401943: main at set_id_regs.c:475
> >      5	0x0000ffffbdd5d03b: ?? ??:0
> >      6	0x0000ffffbdd5d113: ?? ??:0
> >      7	0x0000000000401a2f: _start at ??:?
> >   KVM_SET_ONE_REG failed, rc: -1 errno: 22 (Invalid argument)
> 
> -- 
> Thanks,
> Oliver

