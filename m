Return-Path: <kvm+bounces-32209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D8299D422E
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 19:48:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12311280E23
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 18:48:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 148EB1AB6CD;
	Wed, 20 Nov 2024 18:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gXAFhMOg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BE315539A
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 18:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732128493; cv=none; b=pYa+ek/8xNtIbyzQAieHWJLydeXm9cCFU6fErdJjr/qdqoVmUJkPj7zKqqj2vHus+RLFo/K2gMTVmvo9+3SoiWUAIsGUkD2CAG87ZldZUCNgeVqVc/p+j60AFSN8BokEmizfOe+Gq/YLrTW8aOv3slOWAWcOi/Dp15gPu3I6hBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732128493; c=relaxed/simple;
	bh=SptbHGtr8HQe1kBejn+wyMTkN3CjsxNTQWkZROmQDYU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NiOSImpKX1UeKvCZ1kL8yxiuaPw3cg8qgPwTL6m+iKqQKClGnMzJQzWFFstiYsMJXGqtToRy6vEoyqlQ/hJxyEshzUbMDSn3iB/+4S7eyY72VPkzfmzUASSOXoR3oli96Z4BT0sGw9K26Ip8i+Ww8D4Poq0fJ31ZG8/tgyXCCcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gXAFhMOg; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e38aae1bdb8so53638276.0
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 10:48:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732128491; x=1732733291; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y3HR4g/sjzpAPcTclN1zbnC2rewykA7Pmn4Mi3H0FG4=;
        b=gXAFhMOg0blkWSWcwI1bM7VDXm03qOP7iChrf83B1rCf3m63OXhbZkYFae8SKpGqDi
         c0DILG74vmEM/9leJo7L6nA+ArVliwitEGbSHChI2uOdE3yvI63bZN2haiHOQ0BXAWye
         mI78bCwPLF/J+iUpmYh7Kk7rnFcTcmsakn5PyCG1zqF5WV6sTCeLXzejIrP4H3plxyU5
         kBae+x51sxX7PcwY8Qq2G2KxgeawKyXChP8F9SbJ1lkFHQfjBsnDOr4gHkL7cwJ1mouD
         QWPrg+ZBNYzX1YHkdo8oOthedAUVJh/k5wLSvaLw92neJT4YIYZC4MpJEA6bDpBqGPiz
         1wCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732128491; x=1732733291;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y3HR4g/sjzpAPcTclN1zbnC2rewykA7Pmn4Mi3H0FG4=;
        b=BKaaIB1WKrezn06zKp1QDXSnOUkg2KVQvQXDye8tUXeSKrnCDrjfE/oz13MCJzSatc
         BH2PsEGlpgmTwAKtagPma4sU4Q60BbA+lDrIZiaXDF/hx8z1T8TnjSWosabcQTBWxA4S
         xqJ2Zh2zx6ErihqFmBBXcPzy/WJgnrq10YlzRengsmEOUEpvEPjhZlrDSTSPOtPCmPCN
         9GQFPVrMEvFpOqyx4WfdkDZSgHcIOJuw/OezGavnewdwebiMUYz7HANXY6fKlNQZ2vGU
         BTYpS5QfuF8QRl8iuZoAA7SfKj2sWj3JICRWmvfVMLtPuDh4M5jo3nl77LRH4j3r/Jx8
         TNog==
X-Forwarded-Encrypted: i=1; AJvYcCWmPIIEWgbtT0f3Y/a30Jtp/tlp0GFpOVKZqryVLSqb03C3gYSqTMbKiBi6n2brgFdWne8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPiFzENSlZMk2r2sybxj+ArEPSgGJOc1CCwwvC2u+krxd/YKVz
	GdVZDrZJnpKshB4nG8qz6ebfZ0KLyD9E1FFhR2sskAl9b5D2C1HDf5CZXtli/7ia6sR44AgvhzX
	rcg==
X-Google-Smtp-Source: AGHT+IG1zJqbsPNNDJARQI6xoVNz95KgV4mE/AQmuyzu6CtgFyAtoag2o81vxx34sHHpDEQYWV+wCNJl0vE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1b04:b0:e38:840d:3a9e with SMTP id
 3f1490d57ef6-e38cb60a27fmr24897276.7.1732128491003; Wed, 20 Nov 2024 10:48:11
 -0800 (PST)
Date: Wed, 20 Nov 2024 10:48:09 -0800
In-Reply-To: <d0d8a945-1623-448a-b08a-8877464a4531@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com> <20240801045907.4010984-44-mizhang@google.com>
 <d0d8a945-1623-448a-b08a-8877464a4531@intel.com>
Message-ID: <Zz4u6ThdAZ9M83wf@google.com>
Subject: Re: [RFC PATCH v3 43/58] KVM: x86/pmu: Introduce PMU operator for
 setting counter overflow
From: Sean Christopherson <seanjc@google.com>
To: Zide Chen <zide.chen@intel.com>
Cc: Mingwei Zhang <mizhang@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>, 
	Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>, 
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>, 
	gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>, 
	Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>, 
	Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 25, 2024, Zide Chen wrote:
> 
> 
> On 7/31/2024 9:58 PM, Mingwei Zhang wrote:
> > Introduce PMU operator for setting counter overflow. When emulating counter
> > increment, multiple counters could overflow at the same time, i.e., during
> > the execution of the same instruction. In passthrough PMU, having an PMU
> > operator provides convenience to update the PMU global status in one shot
> > with details hidden behind the vendor specific implementation.
> 
> Since neither Intel nor AMD does implement this API, this patch should
> be dropped.

For all of these small APIs, please introduce and use the API in the same patch.
That avoids goofs like this, where something is never used, and makes the patches
far easier to review.

