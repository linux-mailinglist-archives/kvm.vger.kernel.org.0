Return-Path: <kvm+bounces-37391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8DD8A29967
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 19:49:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EF2F87A1DF5
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 18:48:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55C441FECDC;
	Wed,  5 Feb 2025 18:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bc9D8d4q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B221885BE
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 18:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738781358; cv=none; b=ELCQj2sQ8C4FX75GS9yqKIy4L30V3Rs6m2qSdcOHOQ0kq+I96ll7vuGjsuCWSA4Rn5SifLaoMpU3KFR7LPq2/yiD21qpULTf1tIr2yE0z9UTPRobf903O2QHfy/oz96pdEMpksZgeHL7FlO1Mm9e9jKqxXpInKeh/0G5uz29zh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738781358; c=relaxed/simple;
	bh=RFLD5Y419LMLKxBPptSqSiuNprPZyJrTzacReh60S5o=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=nxf5JXxH0OXvb2ZdnAowRDjNGnzb0YXAeCAFKMzFP4hVFBzm7ByXfFAskyONYHG7T5jkWcA2yzqaYAVIMoSX1charj8VQa9kF7jZe+GW3mBs1hK0FX866yOlX4S1cGcjBYa5nzOu7q0XQ3BjQcTW5671Rn03RGhCXaILt+PF3fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bc9D8d4q; arc=none smtp.client-ip=209.85.210.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-71e27669befso106205a34.2
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2025 10:49:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738781355; x=1739386155; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RFLD5Y419LMLKxBPptSqSiuNprPZyJrTzacReh60S5o=;
        b=Bc9D8d4qjFNaT5FkZfMhsFHqzSswEmFapvHOzX0kieKcw7oX2WMIVzeNUoaQk64J1Y
         8wbMMbPxqnqFextlgTsqN7OEM1DlS6SRmHEO3D/JzTvtwI2yunWKojSY1YXbHMshNg8U
         wny07IX8eiQASToK82mgYuPiOBksDzf/rFpH0gwMHeMvhtIANY+8wtnoiz9sf/3pC/Qh
         0EFqRHJbvRQ1AjuEt421TG+VUVnZAng/d4lx4bp4FPy9xBfrdRg9GN7KxwbbI4TpAuqB
         iKT3eV4Hwn3mveJBIhKM1ten3V8pIB4EaAq/yJCUVWeiV0Kc3FFDYDpxExwIY0uUoJ1u
         vhbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738781355; x=1739386155;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RFLD5Y419LMLKxBPptSqSiuNprPZyJrTzacReh60S5o=;
        b=YspcQcSEObYs88pCMoQ1f5JOHAPWGl2bD+YUzkMU7itq48J7ISu6Iwo9DbeSu9JZJn
         +BClAoGjh3ot0dtO3A/m4WdK+hz98o67xdJmSvwgnUGrDCePJnVx0IcF/NLErGkRiGzw
         50aO6UFnjsCCQsLjRiXmLjoyEo1amuTiXE3nVLjHK+D5a0wss0/6RdtmdD+RdmYFP9m0
         L5fGySt9R1TrNI9wqRHTL6m6MWWVtf0ywh2PIv+drMMbIrZ7460+kkAMWrrm8d8N1c9x
         epDtszs8KypC2MJOmsPr7+FTdIAlXXlX3NuC21MuhJKOXIl+XebYox08WRJKO2qgyET7
         2Eiw==
X-Gm-Message-State: AOJu0YxOCrTMmGkSENi66x2dgdXw37ochIfRgxakxt8kqb5CSgpmX5lb
	KTsSznaBj7/I2zO0o+7N1zJINzhu9xKPOCj4nVS11SuVAztURMxZl+bx96R1VlY6vzqTnIXGBBt
	QhEtTeLDQGRHN1COAUA5CkQ==
X-Google-Smtp-Source: AGHT+IG1848Nyq0Ep5YZHUoXqdxSYPedyBRtjzatXIPDIYwQRd5LUrtw/B5zE5Ng8GmU9F7dXNmOSuoU4vizvGXdRQ==
X-Received: from otbcs10.prod.google.com ([2002:a05:6830:678a:b0:721:b316:918])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6830:71aa:b0:71d:f6d3:9fd2 with SMTP id 46e09a7af769-726a428cc52mr2331443a34.24.1738781355567;
 Wed, 05 Feb 2025 10:49:15 -0800 (PST)
Date: Wed, 05 Feb 2025 18:49:14 +0000
In-Reply-To: <Z6KoUBdmjVRuqPnU@linux.dev> (message from Oliver Upton on Tue, 4
 Feb 2025 23:52:48 +0000)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsntseos1b2t.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 1/2] perf: arm_pmuv3: Remove cyclical dependency with kvm_host.h
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, linux@armlinux.org.uk, catalin.marinas@arm.com, 
	will@kernel.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, mark.rutland@arm.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Oliver Upton <oliver.upton@linux.dev> writes:

> Hi Colton,

> On Tue, Feb 04, 2025 at 07:57:07PM +0000, Colton Lewis wrote:
>> asm/kvm_host.h includes asm/arm_pmu.h which includes perf/arm_pmuv3.h
>> which includes asm/arm_pmuv3.h which includes asm/kvm_host.h This
>> causes confusing compilation problems when trying to use anything in
>> the chain.

>> Break the cycle by taking asm/kvm_host.h out of asm/arm_pmuv3.h
>> because asm/kvm_host.h is huge and we only need a few functions from
>> it. Move the required declarations to asm/arm_pmuv3.h.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>

> Please do not move KVM namespaced functions into non-KVM headers. Having
> a separate header for KVM<->PMUv3 driver interfaces is probably the
> right thing to do, especially since you're going to be adding more with
> partitioned PMU support.

That seems like a good idea to me.

