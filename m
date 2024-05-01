Return-Path: <kvm+bounces-16365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4CD28B8F4E
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 20:00:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E69A0B21F20
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 18:00:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E6DA1474B9;
	Wed,  1 May 2024 18:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l2U3kks0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE1F5024E;
	Wed,  1 May 2024 18:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714586429; cv=none; b=kpze8KVtXJTtd3fLyoUjE+W5souMCVp3REkYnHzsIVK/E7k34854p8VZRJXgoKnlyzOHSWzyh8AAX3ECxVvn1Y2iEQPduepyE9R5CCx6gtvT4+ve7asz6RjQzTBfBjJb2fpySfDJYt4FcqVlxP7Z+grbw7C+asb5jcHyin9ZrMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714586429; c=relaxed/simple;
	bh=k+dIFqMwQZ2aUiDi9ejc2u8LVegSYH+CS+A6rMZQZao=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gc3T49NwV1U7JMS6tKx6kyuB3QvNQvFTKHDrKzrkFy+4OwCUe82vzWLVfQEpj29ExH+hglhe7urPL05AyQd/2BS0xok+yP1P3hvlOyCN9OqWvENyqJfemWPlQLAyu8YuRQBG3bE2q012hR9L6FwbJ8Td0Dl9qO39CrsuVfdFbho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l2U3kks0; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714586427; x=1746122427;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=k+dIFqMwQZ2aUiDi9ejc2u8LVegSYH+CS+A6rMZQZao=;
  b=l2U3kks0iRB8jYGQG3x1sKgp6MHMsY3puPxNm32woUFqaanu2KzTzTEa
   UOr0SSlP7ikiSC0miQ2L0e5bFSHON/9I2ua93ajkNMbeOdt45vRF0G29u
   /Zxn9BYyrnKph7JmXOGCmZZ6X4sSPfNYyQTiwdlOPpareCWccBto+OOEY
   QwJEk36pJSEYrp5QCBfYtrBhZEopkipFbQrkVFrKAW6XATg9Nn0pk5RPb
   AYWA/SKdKM+WCMVR9KuUUbXodMbXQwMrJT63CCl/o3dkSkE6Nf602DzLn
   hUxHQcC9gnuuTWhdlE+wCYHxqT8K+ljZqPeBAw4LuJodqAidnkJuWbo+H
   A==;
X-CSE-ConnectionGUID: zNTOMlCdTUywh+crgY7l9w==
X-CSE-MsgGUID: WTeGrNNvRHqeb2hDMKNH/Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11061"; a="10454627"
X-IronPort-AV: E=Sophos;i="6.07,246,1708416000"; 
   d="scan'208";a="10454627"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2024 11:00:26 -0700
X-CSE-ConnectionGUID: 6yvooRm2TD+Bsr9luSpjyg==
X-CSE-MsgGUID: ykIbpHkiRSai8G40A9GwMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,246,1708416000"; 
   d="scan'208";a="26817144"
Received: from linux.intel.com ([10.54.29.200])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2024 11:00:26 -0700
Received: from [10.212.96.143] (kliang2-mobl1.ccr.corp.intel.com [10.212.96.143])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id 2AD8620B5739;
	Wed,  1 May 2024 11:00:23 -0700 (PDT)
Message-ID: <e1aae0a8-fcd8-42ea-81b2-0f95c9d7cc2b@linux.intel.com>
Date: Wed, 1 May 2024 14:00:21 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
To: Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>
Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>, maobibo <maobibo@loongson.cn>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com,
 peterz@infradead.org, kan.liang@intel.com, zhenyuw@linux.intel.com,
 jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com,
 irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com,
 chao.gao@intel.com
References: <ZirPGnSDUzD-iWwc@google.com>
 <77913327-2115-42b5-850a-04ef0581faa7@linux.intel.com>
 <CAL715WJCHJD_wcJ+r4TyWfvmk9uNT_kPy7Pt=CHkB-Sf0D4Rqw@mail.gmail.com>
 <ff4a4229-04ac-4cbf-8aea-c84ccfa96e0b@linux.intel.com>
 <CAL715WJKL5__8RU0xxUf0HifNVQBDRODE54O2bwOx45w67TQTQ@mail.gmail.com>
 <5f5bcbc0-e2ef-4232-a56a-fda93c6a569e@linux.intel.com>
 <ZiwEoZDIg8l7-uid@google.com>
 <CAL715WJ4jHmto3ci=Fz5Bwx2Y=Hiy1MoFCpcUhz-C8aPMqYskw@mail.gmail.com>
 <b9095b0d-72f0-4e54-8d2e-f965ddff06bb@linux.intel.com>
 <CAL715WKm0X9NJxq8SNGD5EJomzY4DDSiwLb1wMMgcgHqeZ64BA@mail.gmail.com>
 <Zi_cle1-5SZK2558@google.com>
 <CAL715WJbYNqm2SXiTgqWHs34DtRfdFE7Hx48X_4ASHyQXeaPzA@mail.gmail.com>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <CAL715WJbYNqm2SXiTgqWHs34DtRfdFE7Hx48X_4ASHyQXeaPzA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024-05-01 1:43 p.m., Mingwei Zhang wrote:
> One of the things on top of the mind is that: there seems to be no way
> for the perf subsystem to express this: "no, your host-level profiling
> is not interested in profiling the KVM_RUN loop when our guest vPMU is
> actively running".

exclude_hv? Although it seems the option is not well supported on X86
for now.

Thanks,
Kan

