Return-Path: <kvm+bounces-46554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 84201AB7971
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 01:31:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 206154C51FC
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 23:31:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B57EA226CF4;
	Wed, 14 May 2025 23:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rhS8+rB6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847361E833E
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 23:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747265455; cv=none; b=JzO27+iwhWlbeZaVEE70nt94dyPpum4jOwBvJrz0P1j3je/0M/trTbsxCQ/ganD1+AX8QSv8wfzCkSe7Cve3bsitALvDqkx6hb84x8FGtWWASamJyiRIOkjyrv8P1VD5eQEDOIAaFMPxZDM/qE1p9pS9hJUYqP9PAbfMgemHy3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747265455; c=relaxed/simple;
	bh=8IwAmJ0usLb0XmLJEmRAj1KQT7kUoSHh+GUD4ztFINU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aZ7YbfT2QtTMQFw4D6bB2TwEp76m4gj1Vuqskdgr4S+uogMWdv2CBOka+7+jIjKa76tqE4T8fDwyhWsbvM12P1MVd5xGApnuYkzYsfTJqJKKWlWh6N13DU0+hixuh83flP4QShZPUINFGxNCChTmAIHVjdA3hDHQ5DaG7kc68dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rhS8+rB6; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30c06465976so350465a91.0
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 16:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747265453; x=1747870253; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=K4/upwCU1p7ZhRZCIWHVB5zuv5a/gxQLx/KwiZLDsIs=;
        b=rhS8+rB6n5ez4I56fUlA2ea8yo2iMu8mHM4munJorrMkjZ4JK0fe6kOQpePclO/gRM
         LE8FWui0h6m8RKwc0n7dHRFM/H/lL5x+7xRFg6ALmnIL6k+oyWoGM3xGoB4MxX6ps6vS
         fM7R1ORHSZquSl8kYImaTs+VcCvSgf+IbOihdLZbZLxsat3vfEZBKkvjUfL2ZYCcXKdx
         9Q/jGgOLe3dEHLhW6D4TyNAsOofvZsbo7nKVs667kRgenKkZxkYqHIyHgc4kzRRGvfm3
         R+tpC7hEnI84pJufBOZtD9rb6+uiwieEEmV3SLGvNE/jrKCQbMpxKDCNZ02bEMRhAZwo
         Edaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747265453; x=1747870253;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K4/upwCU1p7ZhRZCIWHVB5zuv5a/gxQLx/KwiZLDsIs=;
        b=XYPA4/e8w4perssFdMjfe8zaNVCKeLTf1CXCJNYadQUxknKVGy+IDrU/AubvpGkJQc
         ve31LzOn9bR8aOshOlP0wMDSm/tUVc7yLyQmSVRyrqA4WKDbdx+/N/WI40ulYIYWjsNy
         HupgsLlfhDDRu5UOWVANi0246COD/oOIevyb3omEHsvGcp7gSS++y/aL5dO+bHcT9VEi
         DjoANEzJv6p1ZbH6hIoSp19uDPJA5exT7n2i54LWZOelg+r/4FVisAv9oH3KOPrzo+xK
         esDZ61wJU7pOuvOsiB/m9e/Vzj/rNIEDdnBdgLwL86e+VTSK6AMFl8x3jU55UksvKwE/
         3YbQ==
X-Forwarded-Encrypted: i=1; AJvYcCWxZvbfKCBzR5c4NKygc1yrs3IWtU40f0NaI+IcVwHyu+jrfitKYoNz4fGDbExPGr4gZiA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHLOKGe/NBjakoOzYiK767jjrD2wrLg7q6DRJ0y0rs0MTjkglk
	i+SiVN/vN64spkO5mOTBBPtqL8gjvQCsT9MsNf/AR7a88ZNW33ANoavO0fA0wS0tgtvyG1SryuW
	M0A==
X-Google-Smtp-Source: AGHT+IFAtfFAcg5G+bktrxdFp1CjONIgOLPqtbYX0j8nNBPhJiLTtnFl1U1b1LHV+tCsNxvNYjV//Y0pDCQ=
X-Received: from pjbee14.prod.google.com ([2002:a17:90a:fc4e:b0:301:1bf5:2f07])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5292:b0:2ff:5357:1c7f
 with SMTP id 98e67ed59e1d1-30e2e64260bmr8268883a91.30.1747265453399; Wed, 14
 May 2025 16:30:53 -0700 (PDT)
Date: Wed, 14 May 2025 16:30:51 -0700
In-Reply-To: <20250324173121.1275209-10-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250324173121.1275209-1-mizhang@google.com> <20250324173121.1275209-10-mizhang@google.com>
Message-ID: <aCUnq4M33yTj_t1F@google.com>
Subject: Re: [PATCH v4 09/38] perf: Add switch_guest_ctx() interface
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
> From: Kan Liang <kan.liang@linux.intel.com>
> 
> When entering/exiting a guest, some contexts for a guest have to be
> switched. For examples, there is a dedicated interrupt vector for
> guests on Intel platforms.
> 
> When PMI switch into a new guest vector, guest_lvtpc value need to be
> reflected onto HW, e,g., guest clear PMI mask bit, the HW PMI mask
> bit should be cleared also, then PMI can be generated continuously
> for guest. So guest_lvtpc parameter is added into perf_guest_enter()
> and switch_guest_ctx().
> 
> Add a dedicated list to track all the pmus with the PASSTHROUGH cap, which
> may require switching the guest context. It can avoid going through the
> huge pmus list.
> 
> Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  include/linux/perf_event.h | 17 +++++++++++--
>  kernel/events/core.c       | 51 +++++++++++++++++++++++++++++++++++++-
>  2 files changed, 65 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 37187ee8e226..58c1cf6939bf 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -584,6 +584,11 @@ struct pmu {
>  	 * Check period value for PERF_EVENT_IOC_PERIOD ioctl.
>  	 */
>  	int (*check_period)		(struct perf_event *event, u64 value); /* optional */
> +
> +	/*
> +	 * Switch guest context when a guest enter/exit, e.g., interrupt vectors.
> +	 */
> +	void (*switch_guest_ctx)	(bool enter, void *data); /* optional */

IMO, putting this in "struct pmu" is unnecessarily convoluted and complex, and a
poor fit for what needs to be done.  The only usage of the hook is for the CPU to
swap the LVTPC, and the @data payload communicates exactly that.  I.e. this has
one user, and can't reasonably be extended to other users without some ugliness.

And if by some miracle there's no CPU pmu in perf, KVM's mediated PMU still needs
to swap to its PMI IRQ.  So rather than per-PMU hook along with a list and a
spinlock, just make this an arch hook.  And if all of the mediated PMU code is
guarded by a Kconfig, then perf doesn't even needs __weak stubs.

