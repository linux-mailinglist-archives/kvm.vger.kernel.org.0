Return-Path: <kvm+bounces-18369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 60FCB8D44CD
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 07:29:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA68D1F22B59
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 05:29:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51147143C49;
	Thu, 30 May 2024 05:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ORhCZBqG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBA6143C52
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 05:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717046932; cv=none; b=lNg3sF8W4Svg1niCRQV6OQl8ElrVqKeAuLNrf8ybyqrC+YMR0rzyjp6IxZZ4td7Ua3oAHRTkpbSDy0rBujOYifidaMdABMhyZYJwZpvcV4l7IQfHcL122L9PhcYJBYtZttF648Gi0bMLB3fD3Nur/R2nBpgdVEsBmMRAdK41BQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717046932; c=relaxed/simple;
	bh=v9jJLCeiAFLPf9YjhvostbXWDJY//Rqy+nYAZ6S5wWo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PqeMi2GZfBFnJRVG1oWIMsk9mIp+m1RsI3a0rB5Ec9c4oluCNhyV3TSn3b9hp5cqdy9ROcim94aWYW3/ZaRUDoYo2F+pld06NmTevZhEuUZiF+6J4hRma3PzK/1G5rYebb3+4yopDo1wUlESYJMg494c7UDe9MF7NPZP3Chxwpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ORhCZBqG; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6f8eaa14512so468931b3a.3
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 22:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717046930; x=1717651730; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vxpsU0fnxACaXJ9dwZah6/wvtHJUl8POw+WTjY9EqCE=;
        b=ORhCZBqGQP5QA2NbcUZNgXkDA3N8WzdYKhvYg9/J6E65qz+p/G/25cmiyOdldYXsPV
         /OA4iktuwYsvor3wEK63h5F0hDykB/CeqXl0co5oOnCu0sxpZ7hNtvIB6wVRy3dJ3ela
         GQ5VRAlE+HRYJiCsLt0gbRWXZgGYg78fAP6kDfufYCcv52mag69mGkdLXRpMou44t3Vq
         I3yZ0WM2syl4tgxPQFdBtmmC2wGlc8hY4Qx+wGr+LQL3WLmO/RL4lCEGQB9/N3G9Uogm
         y7UBt46gEBGALy1/NTUZFiS6Xrgvkw1RA1NtQsIVyOf7zDmhFph3lb6IoFzjGLj3QnNR
         p4Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717046930; x=1717651730;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vxpsU0fnxACaXJ9dwZah6/wvtHJUl8POw+WTjY9EqCE=;
        b=Pwu1VMLzlyhFquCzfiw85ADimxV0YjiIXBh7fiSUmEeaEoMmPGtVcPdzziR5nb5G4J
         nsNTMzJ1LSvPHRuN75kD/jv5ISIiBruLexs1HSa8HAVbYvybXwbWaJ/lZuc2XhHDhbau
         tgSGajZKDx8EEPgxxqJIeQFzuArMJXhHOM1GoXVUaORKUE5iwXUvN5+SaJ1RcjrmiyAf
         suGyyBVAWybgj0wa3zVsLDPiKzu1KIKAZCAUi4RH9t7aXalZ9xOUKwxPpNW0q7K7gSfl
         o9mJCQ/o4ctXh/ApONwujXY4jQhUNXCR0/oY/hquB5G1KsWDOZYtXYjgQi+V5v1NNbcB
         LNZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCJfbg0JbFYYTwVspqqSHlvydPzX/k/3kuxorx4EtGkNTcRWDg1i0kEjyr6MZ6rntzj4YsugZFUzdAdZj8zdUrVkd3
X-Gm-Message-State: AOJu0YxunUDVj6Kd+nDHZV69Bu2anYwCxmh/auk3L1K+T5/AamWeCKIO
	RrhmsA3ZB8g3ubl4M92SYym0ztTeGNQrm16jfKaDNikEW2jdhXW6wBWC4Ouu6A==
X-Google-Smtp-Source: AGHT+IFSQuYB9Qqx3hOktl8KWuEiEHrEiAeEfBnPpMVb4DDIpqlZOuwevngzjViNr7w7/cRhaz5TaA==
X-Received: by 2002:a05:6a20:2452:b0:1a7:2f39:f0cf with SMTP id adf61e73a8af0-1b2646ca7b9mr1254803637.26.1717046929419;
        Wed, 29 May 2024 22:28:49 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6176325e3sm6711275ad.165.2024.05.29.22.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 May 2024 22:28:48 -0700 (PDT)
Date: Thu, 30 May 2024 05:28:45 +0000
From: Mingwei Zhang <mizhang@google.com>
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
Cc: "Chen, Zide" <zide.chen@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Kan Liang <kan.liang@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Manali Shukla <manali.shukla@amd.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Jim Mattson <jmattson@google.com>,
	Stephane Eranian <eranian@google.com>,
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
	gce-passthrou-pmu-dev@google.com,
	Samantha Alt <samantha.alt@intel.com>,
	Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
	maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v2 26/54] KVM: x86/pmu: Avoid legacy vPMU code when
 accessing global_ctrl in passthrough vPMU
Message-ID: <ZlgOjRuqdK4ECZED@google.com>
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-27-mizhang@google.com>
 <d19e06e7-ed97-4361-a628-014e5670cf22@intel.com>
 <9b93c6bb-0182-4729-a935-2c05f1160a73@linux.intel.com>
 <e7bc3989-154b-42cb-9a6b-83b395f5d0ee@intel.com>
 <5e14e5bd-0125-4d56-953f-8ecdbe31668d@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e14e5bd-0125-4d56-953f-8ecdbe31668d@linux.intel.com>

On Thu, May 09, 2024, Mi, Dapeng wrote:
> 
> On 5/9/2024 9:29 AM, Chen, Zide wrote:
> >
> > On 5/8/2024 5:43 PM, Mi, Dapeng wrote:
> >> On 5/9/2024 5:48 AM, Chen, Zide wrote:
> >>> On 5/5/2024 10:29 PM, Mingwei Zhang wrote:
> >>>> Avoid calling into legacy/emulated vPMU logic such as reprogram_counters()
> >>>> when passthrough vPMU is enabled. Note that even when passthrough vPMU is
> >>>> enabled, global_ctrl may still be intercepted if guest VM only sees a
> >>>> subset of the counters.
> >>>>
> >>>> Suggested-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
> >>>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> >>>> ---
> >>>>  arch/x86/kvm/pmu.c | 3 ++-
> >>>>  1 file changed, 2 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> >>>> index bd94f2d67f5c..e9047051489e 100644
> >>>> --- a/arch/x86/kvm/pmu.c
> >>>> +++ b/arch/x86/kvm/pmu.c
> >>>> @@ -713,7 +713,8 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >>>>  		if (pmu->global_ctrl != data) {
> >>>>  			diff = pmu->global_ctrl ^ data;
> >>>>  			pmu->global_ctrl = data;
> >>>> -			reprogram_counters(pmu, diff);
> >>>> +			if (!is_passthrough_pmu_enabled(vcpu))
> >>>> +				reprogram_counters(pmu, diff);
> >>> Since in [PATCH 44/54], reprogram_counters() is effectively skipped in
> >>> the passthrough case, is this patch still needed?
> >> Zide, reprogram_counters() and reprogram_counter() are two different
> >> helpers. Both they need to be skipped in passthrough mode.
> > Yes, but this is talking about reprogram_counters() only.  passthrough
> > mode is being checked inside and outside the function call, which is
> > redundant.
> Oh, yes. I don't need this patch then.

Right. I am thinking about dropping [PATCH 44/54], since that one
contains some redundant checking. I will see how should this be fixed in
next version. Thanks for pointing it out though.

-Mingwei

