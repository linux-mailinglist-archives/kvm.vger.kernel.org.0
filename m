Return-Path: <kvm+bounces-57259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38C73B5240C
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 00:04:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E85A5487229
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 22:04:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36FBA3128A2;
	Wed, 10 Sep 2025 22:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wzJ8J6O+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDBF28B7D7
	for <kvm@vger.kernel.org>; Wed, 10 Sep 2025 22:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757541837; cv=none; b=J0BIkotsCrGQrz30mhBm1r6R14WGxwoWtJPJMQpSAvCOv9rh+Q+DZrqpH2P3fY7QGa+7sboaRALlRqgPMJIEdCc4BdRfGBdz33w2D4gy6HuZdspT/mZhzoHuVNxa+ekztjROT6Nb0O7QtZC3a/TM2tDiYFOP2pUZsoR5Wq+Vmk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757541837; c=relaxed/simple;
	bh=aE5uCNhs1u3g6pohgmpcLJXBRFNPdmYKr1kSz8VgOU4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j4bbmVtnAccWDOpLtbPBZKzHkfrq5QU/+WiaUuYtq2PQtIh1U5TkMPUVeVp9LZPoqSdz8kCQFGII08JeyVxwgsGNpSj85V5vQ7WayJeObl1N3SzjJYwSrWtRKSzSwJlVNoMpmOBEIsEYo25N/Z6XhteW2D5OYLjYoX+R4vSZyDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wzJ8J6O+; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32bbacf6512so55389a91.1
        for <kvm@vger.kernel.org>; Wed, 10 Sep 2025 15:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757541833; x=1758146633; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pk6OURjfr3XUwz7xuUVoE1kFuuE2okareB/QgbX6n30=;
        b=wzJ8J6O+iJeCoVwPfGt6MM+rxF9oxVertipMQA+WEzBFku6n7fEOqr1Px/2r1KA4Qw
         jSy21/DY3DA+SwIEzkWSpsdzpXJ8bPHjCvJIUtwGJjwNQ5AwgLT3uXwPKVAbheJ4xTIp
         G3fSycYFMFC3GeimkdqmjYhaigSzQnrXpBBeZZDtSDFBMtRXQwQ8iw02Eo9ipo+wQpXV
         JSH5YOcm5v2KKkZVBjp9TxsJIrjXPZIsu0eI9qKyDbMShHFLdzVdRp+YYXmWSM9pLmv7
         yB2B6Xpm7OT1h+sGQ1s7rCxO/1Y8RNzr+0Sp6yxj8od3Noz2vQk3HMCh9GVR/mR4TjLM
         40QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757541833; x=1758146633;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pk6OURjfr3XUwz7xuUVoE1kFuuE2okareB/QgbX6n30=;
        b=fI+lLKme1ZDh01GtAlIjsp8VlqM6YndF/O9l1icEujwknjPOvRkv6ScltlGH/GuqnK
         SRsMVp5ojiNknGJVvtlCVT2+YSITud6xdTF2P+f42L5A+Kyba48hXg+TrVJnjMnjCOIx
         q6iTsg2KEVShbpQ9WPl7jAFL4kFR+qWDIYMAhwl2ECju35o0hVkjDbYd2z7g5aU2qSbX
         EVbAv6wmS7IPNuI4pvGFMftB8GgpppLzD/X4j+80j4zr9MevP5B5tWcE8tz01UmaeBgX
         EeqkCwpnfpaAW+TgmckIp+2SrvkZnD/nmYp4iRk1w/OVzueRmTZjI65ISfysLECrtWRj
         xFqA==
X-Forwarded-Encrypted: i=1; AJvYcCXHsEUR3xV4O7q12ZdG0DyU8iF7tncvdMOiYtiWKCWnSGPoiHvIYVlTFQvIAAOPf3lf9ww=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNZLHUuiSnTaWUOC08+raWJ0hxcc7nPEkLyQq9gfk01XqLedQd
	4P8cjhsleexZtXDx0fed+rySPeYugDh/tU16ir1mC2en5PY2+KI7x8giI3vbesDjmv7T0opFiLN
	sMaeU9g==
X-Google-Smtp-Source: AGHT+IENXCH4SuSphP+WfGGDSdjGmLGhnHOBJ/boJsiqZ+MqMV4PbdSmBjtFRZdUumVba4F8E0AnJQ71O+s=
X-Received: from pjbsb16.prod.google.com ([2002:a17:90b:50d0:b0:32b:92ac:cfb9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4f:b0:32d:3713:5a4f
 with SMTP id 98e67ed59e1d1-32d43ef6e16mr23388863a91.3.1757541833526; Wed, 10
 Sep 2025 15:03:53 -0700 (PDT)
Date: Wed, 10 Sep 2025 15:03:51 -0700
In-Reply-To: <20250718001905.196989-3-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250718001905.196989-1-dapeng1.mi@linux.intel.com> <20250718001905.196989-3-dapeng1.mi@linux.intel.com>
Message-ID: <aMH1xwsK1eTjJh71@google.com>
Subject: Re: [PATCH v2 2/5] KVM: selftests: Add timing_info bit support in vmx_pmu_caps_test
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Zide Chen <zide.chen@intel.com>, Das Sandipan <Sandipan.Das@amd.com>, 
	Shukla Manali <Manali.Shukla@amd.com>, Yi Lai <yi1.lai@intel.com>, 
	Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 18, 2025, Dapeng Mi wrote:
> A new bit PERF_CAPABILITIES[17] called "PEBS_TIMING_INFO" bit is added
> to indicated if PEBS supports to record timing information in a new
> "Retried Latency" field.
> 
> Since KVM requires user can only set host consistent PEBS capabilities,
> otherwise the PERF_CAPABILITIES setting would fail, so add
> pebs_timing_info bit into "immutable_caps" to block host inconsistent
> PEBS configuration and cause errors.

Please explain the removal of anythread_deprecated.  AFAICT, something like this
is accurate:

Opportunistically drop the anythread_deprecated bit.  It isn't and likely
never was a PERF_CAPABILITIES flag, the test's definition snuck in when
the union was copy+pasted from the kernel's definition.

> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Tested-by: Yi Lai <yi1.lai@intel.com>
> ---
>  tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c
> index a1f5ff45d518..f8deea220156 100644
> --- a/tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c
> +++ b/tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c
> @@ -29,7 +29,7 @@ static union perf_capabilities {
>  		u64 pebs_baseline:1;
>  		u64	perf_metrics:1;
>  		u64	pebs_output_pt_available:1;
> -		u64	anythread_deprecated:1;
> +		u64	pebs_timing_info:1;
>  	};
>  	u64	capabilities;
>  } host_cap;
> @@ -44,6 +44,7 @@ static const union perf_capabilities immutable_caps = {
>  	.pebs_arch_reg = 1,
>  	.pebs_format = -1,
>  	.pebs_baseline = 1,
> +	.pebs_timing_info = 1,
>  };
>  
>  static const union perf_capabilities format_caps = {
> -- 
> 2.34.1
> 

