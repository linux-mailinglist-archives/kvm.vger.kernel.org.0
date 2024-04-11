Return-Path: <kvm+bounces-14335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F4B78A2099
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 23:03:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D029E2830C5
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 21:03:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D36AF335DB;
	Thu, 11 Apr 2024 21:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F13iYDMX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D90517BCD
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 21:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712869385; cv=none; b=szvm7iMsy619n/PPDpG8oPKIRLP5eBm5lINe8y+j29dTZH5ZJw8fR2iSP+e6tf9sFnOyzDpHOHxMGqd13UxBQ1DVRYNth4LYFVeUYpmtHqHKN03rRk7rwtJRm4PGSOO1zw9XGKE5Btosp8lL5DZKFQ5/d9wdneucMlfI37avf/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712869385; c=relaxed/simple;
	bh=6ohnLm7z3PDG7MWeKCsPtN2uBOTfngdUGkrSE6HEqWQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BkO84lblfJdsE2k4StZ0u/UFRNG3QLGPqw+fwAHVdJnwsJB40rKX0NrhfVtBA9M4CJzneg8uUfE8rAdCP4eA3uJt5TyAtK/5y9nHJ4XVVgysqNcJATNhxDY6HrQv24r+taU1znVZu8e+Nm1FD2cpcAdZRd+RGFduscaDgKPaaLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F13iYDMX; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-609fe93b5cfso3590287b3.0
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 14:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712869381; x=1713474181; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LqNHTRbTBamf9CG0cXrMM0YOfuqafLOBk3xuoM8380s=;
        b=F13iYDMX7yW18JTzN5qfC/hm/ZPvBRTo5yh/aO1ndLxy0G0tLlFAbH5L5rTjJ56BBx
         ZO++GqvBmmI6zqXsVInX8cRsKLg1w5i4ZN+HzePNsubtpi6GnaprrsAA4vmHWhv7MUYz
         n/uiJin7NXSG2TlZ9ud4FUM1pE0eT29LWDaYFYR+mNq/W3QL38gcX0P5jOUaZO73xX34
         v4h6Wdgc/5HCNz4hdCblQcov/OfRN9Hik51ZyYhc/dJy8fYTIlYWilVrXy+1WpYO+O03
         peEj9axx1TS3N4J5BakoxcMmQFpcgONFrXYWgZJq7u7bv98gquaIuBgRALSy6vgCvQ69
         heyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712869381; x=1713474181;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LqNHTRbTBamf9CG0cXrMM0YOfuqafLOBk3xuoM8380s=;
        b=barSicaGVN47XhxjboORzSIcLTr5h4DDRggUgg/c3+4oSusNVIale+kwiYJOZvaD23
         la4QytbcuWPqi7h5XvyeBya/88nxkBnjdsYtQc/tY5avl6k46wH3fYRqV3qVjiiypPDo
         HBhFq6W2DnLFJprDVVt67TUeOzFywT1Y4bIfoARhKMDNAxCfdFQrRfEDZdmXSM6zdfjM
         MR8w7Epcl38EfWPvNcV81RE5X6/cBiWWdpXBGbeQgZuYJhW4SDhX7M2tkujTIT3YQVdK
         NHR1qMBYaHKKdIHiuuMpIriRDTvdAx+g+brbQ+yiMkqZXfqzx74vwsMi8YpJCvzUY89v
         OLAA==
X-Forwarded-Encrypted: i=1; AJvYcCWyxgfkmiVW7YAz8BYQS0WReNuSm29yn2ZNwe5KkZ9XXd6BhH7F3cjcGed7HZFosnFCZ7zEyDJTSQoxjEd5ju8xdAtZ
X-Gm-Message-State: AOJu0YzVRkFzxdryVWHFUd2rgztn209IY2eRd2XcV6XnJ87JyNMtYI2k
	OjFDSXGZGOd1Qvyy/JKYllZ5dC0VO4gi3lhAshhmTuiRWNYHa48WWVat5ZylP66x3/+IB9+770p
	Xfw==
X-Google-Smtp-Source: AGHT+IHLAavkjmCuRth9ZO5j6qCkcn9lXltBiSUO5FeZiNUU85dnwhoGihd7JtI7vD7CCsfcYc6LQX6nRa0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:70c:b0:dc6:e823:9edb with SMTP id
 k12-20020a056902070c00b00dc6e8239edbmr104731ybt.12.1712869381654; Thu, 11 Apr
 2024 14:03:01 -0700 (PDT)
Date: Thu, 11 Apr 2024 14:03:00 -0700
In-Reply-To: <20240126085444.324918-12-xiong.y.zhang@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com> <20240126085444.324918-12-xiong.y.zhang@linux.intel.com>
Message-ID: <ZhhQBHQ6V7Zcb8Ve@google.com>
Subject: Re: [RFC PATCH 11/41] KVM: x86/pmu: Introduce enable_passthrough_pmu
 module parameter and propage to KVM instance
From: Sean Christopherson <seanjc@google.com>
To: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Cc: pbonzini@redhat.com, peterz@infradead.org, mizhang@google.com, 
	kan.liang@intel.com, zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com, 
	jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com, 
	irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com, 
	chao.gao@intel.com, Xiong Zhang <xiong.y.zhang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 26, 2024, Xiong Zhang wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4432e736129f..074452aa700d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -193,6 +193,11 @@ bool __read_mostly enable_pmu = true;
>  EXPORT_SYMBOL_GPL(enable_pmu);
>  module_param(enable_pmu, bool, 0444);
>  
> +/* Enable/disable PMU virtualization */

Heh, copy+paste fail.  Just omit a comment, it's pretty self-explanatory.

> +bool __read_mostly enable_passthrough_pmu = true;
> +EXPORT_SYMBOL_GPL(enable_passthrough_pmu);
> +module_param(enable_passthrough_pmu, bool, 0444);

Almost forgot.  Two things:

 1. KVM should not enable the passthrough/mediate PMU by default until it has
    reached feature parity with the existing PMU, because otherwise we are
    essentially breaking userspace.  And if for some reason the passthrough PMU
    *can't* reach feature parity, then (a) that's super interesting, and (b) we
    need a more explicit/deliberate transition plan.

 2. The module param absolutely must not be exposed to userspace until all patches
    are in place.  The easiest way to do that without creating dependency hell is
    to simply not create the module param.

I.e. this patch should do _only_

bool __read_mostly enable_passthrough_pmu;
EXPORT_SYMBOL_GPL(enable_passthrough_pmu);

