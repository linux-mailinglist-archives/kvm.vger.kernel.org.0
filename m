Return-Path: <kvm+bounces-32089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7675E9D2DC0
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 19:17:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 00C1A1F23364
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 18:17:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 356421D1F4B;
	Tue, 19 Nov 2024 18:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H9TACT3N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFA61CF7C1
	for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 18:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732040242; cv=none; b=SgX3EmiY/5Nqn9QSdrHzSb9tLm0yTHdOft6XBhfeUvxBabOMdeMljOW10kfM9zorgMypr+p3LSMILsgI1gzrAwP+PVA7wBUPlE9r3pVLXSKXGncmhPBrpIDoWUNq5qZSPHMHmnddBUm5+rfL1L4G9970xHBVt4Widu5jLNkmp1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732040242; c=relaxed/simple;
	bh=yWAOfS70V7ykfbPo9lVakB+tpRxVE3dXUn/zuxg/4r0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HhbESeOEkzXx/aLkacYTdS0kV3fyr6pLEHHnw2/dQ10WZsFeVDRdYtcnh2CTd2rfsIYCSWHs24jpqTcWP46CYqY6fkgauTxTeNtE3RnOVOKIGp4gc7jOepVKj/7C7CDN9mNlDAdkC4cnLgrfU2wXvCm2ctSBQJLF5HcUC2VDdIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H9TACT3N; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2e9b1383da2so5447952a91.3
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 10:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732040240; x=1732645040; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yWAOfS70V7ykfbPo9lVakB+tpRxVE3dXUn/zuxg/4r0=;
        b=H9TACT3NRG8jDxbSIQ/MQ9mX7Se2Re7qQPT1DMX/Tincj0ZJMGEo6uUDe2MWEciAEs
         8EELel9zzTqFg5qfX+xG9WHg8JpY3osoaQDSzPOdfRgUAuU0paiuSwXoQTWdwnm0kZRk
         yI1atyNxX4gxJkoZ83Q2UKzhFS7v51gwCMwwRg2t2WL7WirzbaJF54PecfvZ7unn2/ZQ
         wJohWO2oEzSCH0kVuifi4O+yDO3EtkimSp1fuYE71gBNeXT2wotKpQwyp9NSufgH0Kr6
         cVu1t+SgsWYlQVbADQQ1Xe8c2tDbnHtp2d3IZvFJP7dc/m2t/YeYMBrJjhGiR+m8qfl3
         fdzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732040240; x=1732645040;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yWAOfS70V7ykfbPo9lVakB+tpRxVE3dXUn/zuxg/4r0=;
        b=ltLh5q4JiUMYnlj6Cm3aD8hARk905iMMx3aCTYn+x9Esd8D4eGgqN01iKurjIgL/dQ
         jQa2bTdH6C2TvOuBEEs0wsRXCLvaQVSLg8rUwyAPlZ0Fews9dflOqVACcRp1k4Mrn67T
         9j5TDpPnnDBCADxVJ43Q7+mOMMlNkR0SoAaCo7BLbZDwOI4MYlw50S8j8227zqJwUqfI
         y8LT0wkNzTmv4NNjVbvVoBq+6NdzfWdh7NqA8w0POLqeWThdUn5KerUojc+DEY42/55o
         tGxwW53NEFuDn+Ig2WiiKLuGTDOd9p00eUyWpq6thv8Ui0gP98PvhUdtRjaihDjZPXvJ
         a5dA==
X-Forwarded-Encrypted: i=1; AJvYcCWnO/BypUztQI7ppddgHk05d5nOlTUuR00zLC/Tp9/pJqExSt5MsA4hdwq+SSMYml1lpLE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxX6pyDO/7ZLm/M8QpwYGN47iD5yM6g7tGtTBsI/sDT6uU65mQA
	vGYbpMXnP0wLMJ8i+dL6WkiM3jnBKerJ5+MH7PNACTnWCdLuwUo9eujq3maVoNU9qxNdNTkAgDz
	CaQ==
X-Google-Smtp-Source: AGHT+IH0JFG9Lp8YAUzd3PBxQROrdMMVFBIgGsPAEiLH2cpW1JEThd9yz3YMCM/ceiGYf1Ip7w7GxgVlvIE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3912:b0:2ea:6f85:28d2 with SMTP id
 98e67ed59e1d1-2ea6f852a55mr21270a91.6.1732040240243; Tue, 19 Nov 2024
 10:17:20 -0800 (PST)
Date: Tue, 19 Nov 2024 10:17:19 -0800
In-Reply-To: <20240801045907.4010984-28-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com> <20240801045907.4010984-28-mizhang@google.com>
Message-ID: <ZzzWLyhFmwSON6K6@google.com>
Subject: Re: [RFC PATCH v3 27/58] KVM: x86/pmu: Create a function prototype to
 disable MSR interception
From: Sean Christopherson <seanjc@google.com>
To: Mingwei Zhang <mizhang@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@intel.com>, 
	Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla <manali.shukla@amd.com>, 
	Sandipan Das <sandipan.das@amd.com>, Jim Mattson <jmattson@google.com>, 
	Stephane Eranian <eranian@google.com>, Ian Rogers <irogers@google.com>, 
	Namhyung Kim <namhyung@kernel.org>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, Like Xu <like.xu.linux@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 01, 2024, Mingwei Zhang wrote:
> Add one extra pmu function prototype in kvm_pmu_ops to disable PMU MSR
> interception.

This hook/patch should be unnecessary, the logic belongs in the vendor refresh()
callback.

