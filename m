Return-Path: <kvm+bounces-36929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37025A23194
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 17:13:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BC35E7A10A0
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 16:12:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC43B1EBA19;
	Thu, 30 Jan 2025 16:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gY6fNpLE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C421DA5F
	for <kvm@vger.kernel.org>; Thu, 30 Jan 2025 16:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738253594; cv=none; b=mZwBlrPxzXn1/luZJiztBOH1BdxbDG0+97jVG429CDskBYh/rqF1+UQNTog8MLeNNoEfDt01xcgFfzBNjlHRuIFomS+2htsb3txrSlduxPh92CV9ZIylVbKHoTxKRGN1/KFfJHn+RsBa3dqfKe0YuwtKUeu59CmTf27KiGCRv24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738253594; c=relaxed/simple;
	bh=YgjLvPxUsVXB/Ck7rE6LUpuzJQUXjknahmAD8taoCkk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f6lTuKrH8tkj/ZI1gJmt12FLLWFR+VkzlbcZPfaeW9pxep2lftBSD51b8R1VqndUZG2xk6JtLlFBo/mIIhxhkWWTHobcT/wXqykuahxZo0PonSNdlJmePOJl4hz+4G4jID1BR63li2RldknHJppovLRyF42a/n9OKcAveyUS4aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gY6fNpLE; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-21681a2c0d5so17043245ad.2
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2025 08:13:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738253592; x=1738858392; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Go3yvVJD3fxZmgQHiBckK+umdJ8mXJIaI6+e2AHHzGM=;
        b=gY6fNpLEx34+2/whTrbnMBS3jZFH+LTQRtzikgUZBHzemLO7MCVUngDT2inI+ZtDEo
         YcZwd9oRkduj+X15P9ez0uNpE5pjhYBtAiGIH8MdO8FxX3RgUQp/KF12tDAzJh9WDpma
         OPhPPOL3G8ZAa3npUTYo1JSOwtqgB7abLMy8iilSONdGVVm1Ob/ctE6phwehs5oVJMQG
         k6FnK0E/QNabEFMSJ1ZdiP+EOedEExuOQKgD/s05tUq1z895rxxp588CJHCqOGJoMaje
         JbJCzfO4jerEsm4vlSmkK5vxN5m+N1/yx4S3/RX5pSsMLe4KtildXRFi/EXsmUqEp4CH
         lE9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738253592; x=1738858392;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Go3yvVJD3fxZmgQHiBckK+umdJ8mXJIaI6+e2AHHzGM=;
        b=p3a8xVTp1Y4XdlY4CoSuY86Yp6p5dQcVy/cejhFibx96A+Y5FKfRvKRgR8gqcTs2qF
         Kc+UJFaH+E6uv7znBT+moTWbFkf81IIJJYapZ+qhEzHYSWBW6gE+epf6Hq0/LP4SdBtl
         RpsRaAbpBhiWCcdLY0kLTM+b2fxAn79op/cw35KNRnsbPLIxxji7ScnZcXUcc9O/ru27
         QZxRiwhUQvG2kTs3aUU6hEag5QzDtxSOorT2H2p6wBT/uVoViP6eaZbZoSapSUYVvfA2
         6OYYhoXtAuJXpQySotfEXa0Oa5Fx5Unc/cpuZw8KHjY7giPjmH5JQb7kk9N2EQ3bOdjM
         6STA==
X-Forwarded-Encrypted: i=1; AJvYcCV55vlyJU0TSO5BBjTU9Dhyzv6WMr+5SkljM4P0EuplPYvN4ZMx4lUZK2wKUHJChVwSLPc=@vger.kernel.org
X-Gm-Message-State: AOJu0YymC+b9YGmtDP8ygbmxDPrWt38foklv6wXStbPHlHQ7IatIwUvm
	AsLypCGtls4RL23PiptjUTG98Mz9V27zXG0Exz3bL54kUpBajfuUaTL3xaNbgPnp8mkCViM5pe5
	nZA==
X-Google-Smtp-Source: AGHT+IE9MT8MEhg+Tsk3q1TDBqwdCo25qpv8AculmFcdDqrZwNhpbu2xmSgkCqtb13dCwecV7pSI7SAxOZw=
X-Received: from pfbea16.prod.google.com ([2002:a05:6a00:4c10:b0:728:aad0:33a4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:2d27:b0:1e1:a716:3172
 with SMTP id adf61e73a8af0-1ed7a4dcd4cmr11333694637.12.1738253592042; Thu, 30
 Jan 2025 08:13:12 -0800 (PST)
Date: Thu, 30 Jan 2025 08:13:10 -0800
In-Reply-To: <Z5rhH342Jghl2tgL@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250130010825.220346-1-seanjc@google.com> <Z5rhH342Jghl2tgL@google.com>
Message-ID: <Z5ulFoNRWGg3LOzA@google.com>
Subject: Re: [PATCH] KVM: nSVM: Enter guest mode before initializing nested
 NPT MMU
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 30, 2025, Yosry Ahmed wrote:
> On Wed, Jan 29, 2025 at 05:08:25PM -0800, Sean Christopherson wrote:
> > When preparing vmcb02 for nested VMRUN (or state restore), "enter" guest
> > mode prior to initializing the MMU for nested NPT so that guest_mode is
> > set in the MMU's role.  KVM's model is that all L2 MMUs are tagged with
> > guest_mode, as the behavior of hypervisor MMUs tends to be significantly
> > different than kernel MMUs.
> > 
> > Practically speaking, the bug is relatively benign, as KVM only directly
> > queries role.guest_mode in kvm_mmu_free_guest_mode_roots(), which SVM
> > doesn't use, and in paths that are optimizations (mmu_page_zap_pte() and
> > shadow_mmu_try_split_huge_pages()).
> 
> Just curious, what about kvm_mmu_page_ad_need_write_protect()?

Doh, I missed that usage.

> Is it also bengin?

Yes.  Better to be lucky than good :-)

That path forces KVM to use write-protection instead of dirty-bit based Page
Modification Logging (PML) when L2 is active, because the GPAs captured by the
CPU would be L2 GPAs, not L1 GPAs, and there's no guarantee that the L2=>L1
translation would be valid when KVM processes the PML buffer.  To ensure the
correct page gets marked dirty, KVM uses it's standard write-protect scheme when
running L2, even if KVM is using PML to dirty log L1 accesses.

Lucky for me, PML isn't supported on any AMD CPUs.

