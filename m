Return-Path: <kvm+bounces-46550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 78725AB7937
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 00:52:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9D67C7B3C5F
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 22:50:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF20F2253FD;
	Wed, 14 May 2025 22:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zHwJj5sP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818E1222584
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 22:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747263114; cv=none; b=ZcKv44XzGsezebX2qBZe28iLyrk3CY5mQx1K0sl3j8FF/3YGf8rxyEq3e1tt4azSnmTdj/IWFcgnWvYrxVzE7R2OrwtPG4ljPsA8RXw1yv/XiTlQMZwn1Zt7vLciid4ltQhiiIau+n7HgLne9+7Zoc9LES+bp66ZikJXecQHaSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747263114; c=relaxed/simple;
	bh=Yx+Zjd8gx710Elu7lbxjIezJyJKnaGlVtZTgTBUAk5U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KaHhcHQRqTFhhiN0XiI634mfhkMSgN47YR60jIwjCNHbpSuoUVkm2/XWWV6i1kZt+Zw1L0rQPYS6V4L+5V0N0iBRkuNGFgChpBIt7APLeXFHa/4OqMXEBQe511rceappjlxnBDKJngq+8RWZu/eVci1ixsiEJeO+9QNZyV2H2TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zHwJj5sP; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30ac9855e35so387271a91.2
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 15:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747263113; x=1747867913; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B0WOTyEDxpBiCPv/Xdx7yM3kU9rNcMVnr1WH3Yxgiaw=;
        b=zHwJj5sPB+wVJnHx8XBE0J9CpK8+pIwdmKYZ6JwznOTr2IZ4LF1tbmCeWUeak481by
         ndoJBkUgYaO7V0PmAXrmPl9u51iydjwjvXxiGb/l6qwgsBI2oc3I3xep9fO3jpTgrTzV
         xuXF8uzuVGeQnAfY11SC3fuf3wrHVIXC4e0i1B7vUJIz1iT9/oPxua98vZUdUiShtqFL
         c1EZ+2isAW6s/YXRjMbxQGXeTR2JkcbNqPTYHNjxchQIsw3h0VLVUm5El9ESPuadKuff
         8xUSpeVH9xuI/TjWtEhnq52f0vJ5azqjVR5R90kiuyAeZCdy9LaxKshWAiGgln9mwtYc
         wbjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747263113; x=1747867913;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B0WOTyEDxpBiCPv/Xdx7yM3kU9rNcMVnr1WH3Yxgiaw=;
        b=Q0VuJb2z7XjsWp+h1z5GrgXwWRK11FBAlEP+kIf5rDbZqwxG3gVvOq6qkN0mwwgJrz
         iZysphYxLfoM69czgpdJWvUUPvVngEr7XLTiw1g35UXsCjQFX9g370QCmQa4PmkKZTA6
         4ZWVajzdHbG4UgzTX3OJYdBbKE0Djxr1zORzt/mq4qoAGQcZBV4ItTj8KkwlD8kgB7ee
         clHHnov0kpjQyI+gvWi+SE0tTWLW3d2Vu163WtRqScUuA2O5HgZkMqX9tNuATX9Vt19J
         6joUBQ93Kz3bGkAUCSlDGLd5p8Mn3xhS7ed9bnyyhcuaVtrWzYzqq6HZN1mXXlKBks2/
         rG4w==
X-Forwarded-Encrypted: i=1; AJvYcCXHigz/zFuGw4/b13UxmxcDJjOE7P8ew4hWR80StDZXUgfW0LDpdrbQSpYwvNxjdFeo+xg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKL3p/hQtsMRY3qzP7VUVKYNeNqpfiMjIOznxKksZI+xx2PwmY
	dTb9nwjGJ3D5XKLLkQVAafvQl76joVHF9fb2eM7V0KMvhZ9S3EvfOy51/MtIxeF72qEzu3xDkCQ
	A9g==
X-Google-Smtp-Source: AGHT+IFm68kMFpJ/kQ76jO9savH4B9EySo+tG8YG2y7wJxByjQiqkMjXPWcqCUmtRI40yW50UEhrsS4l6KE=
X-Received: from pjbqc8.prod.google.com ([2002:a17:90b:2888:b0:2fc:2ee0:d38a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5403:b0:309:e351:2e3d
 with SMTP id 98e67ed59e1d1-30e2e5bb679mr9123064a91.12.1747263112755; Wed, 14
 May 2025 15:51:52 -0700 (PDT)
Date: Wed, 14 May 2025 15:51:51 -0700
In-Reply-To: <20250324173121.1275209-5-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250324173121.1275209-1-mizhang@google.com> <20250324173121.1275209-5-mizhang@google.com>
Message-ID: <aCUeh6KxgjLxd-MK@google.com>
Subject: Re: [PATCH v4 04/38] perf: Add a EVENT_GUEST flag
From: Sean Christopherson <seanjc@google.com>
To: Mingwei Zhang <mizhang@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, Liang@google.com, 
	Kan <kan.liang@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Yongwei Ma <yongwei.ma@intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Jim Mattson <jmattson@google.com>, 
	Sandipan Das <sandipan.das@amd.com>, Zide Chen <zide.chen@intel.com>, 
	Eranian Stephane <eranian@google.com>, Shukla Manali <Manali.Shukla@amd.com>, 
	Nikunj Dadhania <nikunj.dadhania@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Mar 24, 2025, Mingwei Zhang wrote:
> +{
> +	if (event->attr.exclude_guest && __this_cpu_read(perf_in_guest)) {

My vote is for s/perf_in_guest/guest_ctx_loaded, because "perf in guest" doesn't
accurately describe just the mediated PMU case.  E.g. perf itself is running in
KVM guests when using an emulated vPMU, or no vPMU at all.

And with a Kconfig to guard the mediated PMU, this check (and others) can be
elided at compile time for architectures that don't support a mediated PMU (or
if KVM is disabled).

> +		/*
> +		 * (now + times[total].offset) - (now + times[guest].offset) :=
> +		 * times[total].offset - times[guest].offset
> +		 */
> +		return READ_ONCE(times[T_TOTAL].offset) - READ_ONCE(times[T_GUEST].offset);
> +	}
> +
> +	return now + READ_ONCE(times[T_TOTAL].offset);
> +}
> +

