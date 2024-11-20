Return-Path: <kvm+bounces-32208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D38E59D422B
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 19:46:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F3AB282502
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 18:46:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1A0D1BBBC1;
	Wed, 20 Nov 2024 18:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DYHtIMoZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5B514D70E
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 18:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732128394; cv=none; b=dDwxZoaOy9JZvfc7SkQWjNRaaZ7cGgBLKypH+nfH6mT0K6IymC+gsbElAk+zn8QUqPhWtuONp9ew72PvaQHF1j19jNpWxoZwlmbA9VlWxAdhD6m+K8Z7r2IYgYBRDrUDX4g/ews2lZ6dC8bSzDmxyHX/DU1uVWctJ34gSDiKuNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732128394; c=relaxed/simple;
	bh=bz7OpvOpy6atS7GrkuQ8mLzLRHkVDfHP67FoEXcJdv8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lXH2kT1HEdRdNBvPucuIUfuv64K1GPmeqBkhXx2/0UzEhcfBePsPl0zGAxSLMb5yckdHnzZMQLNUVzclsgN43eB2F+gKVhJQcs42caAdCCAaZhSrYKCRtcfHdgwjPcSRkJwMUTyatDqQVyJhna+u5ie0u80hzu1w6sfdkeZrmrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DYHtIMoZ; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-211fcbf699fso48325ad.2
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 10:46:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732128392; x=1732733192; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1Os80MhRhGqXp5ke/1Vxt/rcMZ16KsE7OPEZ8dzr9R8=;
        b=DYHtIMoZN4xFoWpRvwXz7GJ85mr5Irs9xkyVitPxt7/taPMZLHSpRek3MbQuHrdFPw
         /LhdCDCdqUyS80xhA+cbPVe5BAkpyCJxBkyLiuTDHVcxQzXUK6b/i6c0Q8fhvmHJdFJR
         fRe9SRxskFzP8uBNceeT4IBjkpluqvh4E7cJUieOEqgaZKGuEwaHBOn6BruI4CvjzRtB
         3L/nQbTzrtMy798AJIVxQ46QO637PQuzLoI9jl0IzOUo/+KDXJEVBrUMNUzwUW32DW9w
         RQ732V5HzTkl1XB2x29ni92xC7hMWj0v6YrDXACJx578nNXZ47knYN8DIu43W1hUXPw7
         dzzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732128392; x=1732733192;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Os80MhRhGqXp5ke/1Vxt/rcMZ16KsE7OPEZ8dzr9R8=;
        b=ZvPoP07+RN/4xzeGcwhZ2TFnOLDRWCYdHsgIGnHIzpjaS8CLZn6VxCsb/3gBVGze7i
         1F3vcd09aEnoRKPlgLE26dSIkVOFanURoY8/bdlE47SpAwcadSAIh7AjMMa0Ua6/7hGh
         zm2m6Pbmaiyw24VitQtBxoG5rRXfL5YeL2MA83WAj29SKjFz4uRUpTfXtOKyhsLevogW
         Dn4a+48mLm9Tc4x4DSpSnOAcSjs4hQQDF0hk24040QGpHxlPU1fMoe0uW9iijzEzBg1i
         bNt+cqLDXdv4rhuvXqqWO1QUSOYsGwD8mwQ60C459C//GmoUSwym0CLGWKXuDLQg8z5a
         WErQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4f1ATPqup8vK2JBoSukxpT/BE4myzCzPY3dt7M6BxY8f3eFkVAauztM4huGT2jU6MqGo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHi3l0+6Zje7YOj+d1MdzSiT9Q7+M1OOmQJ6EXnEa5h8D96A45
	83DaBBXjKN8O73iT9Qu8EvlczAks7w1m9iLYdsRdQsvb0PlFmjpGxyxkK+H9OooAd4hI9OhqR0v
	HdA==
X-Google-Smtp-Source: AGHT+IFJzrweiSMHDQwuusG00tZ0L3OBUwopKy6Nr208yDx/fXeQeozBoXUMG6gBsgZPojGUxMGBmM72sP8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:903:788:b0:212:f64:de11 with SMTP id
 d9443c01a7336-2126a336564mr12995ad.2.1732128391948; Wed, 20 Nov 2024 10:46:31
 -0800 (PST)
Date: Wed, 20 Nov 2024 10:46:30 -0800
In-Reply-To: <20240801045907.4010984-41-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com> <20240801045907.4010984-41-mizhang@google.com>
Message-ID: <Zz4uhmuPcZl9vJVr@google.com>
Subject: Re: [RFC PATCH v3 40/58] KVM: x86/pmu: Grab x86 core PMU for
 passthrough PMU VM
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
> From: Xiong Zhang <xiong.y.zhang@linux.intel.com>
> 
> When passthrough PMU is enabled by kvm and perf, KVM call
> perf_get_mediated_pmu() to exclusive own x86 core PMU at VM creation, KVM
> call perf_put_mediated_pmu() to return x86 core PMU to host perf at VM
> destroy.
> 
> When perf_get_mediated_pmu() fail, the host has system wide perf events
> without exclude_guest = 1 which must be disabled to enable VM with
> passthrough PMU.

I still much prefer my idea of making the mediated PMU opt-in.  I haven't seen
any argument against that approach.

https://lore.kernel.org/all/ZiFGRFb45oZrmqnJ@google.com

