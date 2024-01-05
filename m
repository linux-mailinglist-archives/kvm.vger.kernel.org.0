Return-Path: <kvm+bounces-5708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A06B825091
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 10:07:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AFFBB1F227F7
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 09:07:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AF6822F04;
	Fri,  5 Jan 2024 09:07:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8E822EEB;
	Fri,  5 Jan 2024 09:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4T5yJQ5Yr4zZgNc;
	Fri,  5 Jan 2024 17:07:02 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id 23C8F140336;
	Fri,  5 Jan 2024 17:07:17 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 5 Jan 2024 17:07:15 +0800
Subject: Re: [PATCH v3 5/5] KVM: arm64: selftests: Test for setting ID
 register from usersapce
To: Eric Auger <eauger@redhat.com>
CC: Oliver Upton <oliver.upton@linux.dev>, <kvm@vger.kernel.org>,
	<kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
	<linux-perf-users@vger.kernel.org>, Mark Brown <broonie@kernel.org>, Jing
 Zhang <jingzhangos@google.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>, Marc Zyngier <maz@kernel.org>, Paolo
 Bonzini <pbonzini@redhat.com>, Adrian Hunter <adrian.hunter@intel.com>, Ian
 Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>, Jiri Olsa
	<jolsa@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>, Arnaldo Carvalho de Melo
	<acme@kernel.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra
	<peterz@infradead.org>
References: <20231011195740.3349631-1-oliver.upton@linux.dev>
 <20231011195740.3349631-6-oliver.upton@linux.dev>
 <e0facec9-8c50-10cb-fd02-1214f9a49571@redhat.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <ab1337bc-d4a2-0afc-3e26-0d50dff4ea73@huawei.com>
Date: Fri, 5 Jan 2024 17:07:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <e0facec9-8c50-10cb-fd02-1214f9a49571@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600007.china.huawei.com (7.193.23.208)

On 2023/10/19 16:38, Eric Auger wrote:

>> +static const struct reg_ftr_bits ftr_id_aa64dfr0_el1[] = {
>> +	S_REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64DFR0_EL1, PMUVer, 0),
 >
> Strictly speaking this is not always safe to have a lower value. For
> instance: From Armv8.1, if FEAT_PMUv3 is implemented, the value 0b0001
> is not permitted. But I guess this consistency is to be taken into
> account by the user space. But may be wort a comment. Here and below
> 
> You may at least clarify what does mean 'safe'
 >
>> +	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64DFR0_EL1, DebugVer, 0),

I've seen the following failure on Cortex A72 where
ID_AA64DFR0_EL1.DebugVer is 6.

# ./aarch64/set_id_regs
TAP version 13
1..79
ok 1 ID_AA64DFR0_EL1_PMUVer
==== Test Assertion Failure ====
   include/kvm_util_base.h:553: !ret
   pid=2288505 tid=2288505 errno=22 - Invalid argument
      1	0x0000000000402787: vcpu_set_reg at kvm_util_base.h:553 
(discriminator 6)
      2	 (inlined by) test_reg_set_success at set_id_regs.c:342 
(discriminator 6)
      3	 (inlined by) test_user_set_reg at set_id_regs.c:413 
(discriminator 6)
      4	0x0000000000401943: main at set_id_regs.c:475
      5	0x0000ffffbdd5d03b: ?? ??:0
      6	0x0000ffffbdd5d113: ?? ??:0
      7	0x0000000000401a2f: _start at ??:?
   KVM_SET_ONE_REG failed, rc: -1 errno: 22 (Invalid argument)

