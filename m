Return-Path: <kvm+bounces-24965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B844795D9DD
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 01:48:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E8D661C225DC
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 23:48:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E08521CC15B;
	Fri, 23 Aug 2024 23:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NxSvVtAI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D231C93B6
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 23:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724456897; cv=none; b=rwhZ+K32iT/U29GuZ2rNwYLbJ2fgNjXnLZrFdcN0m+c6BlYEu2gx8j5GwBeIv/9EOWrV0Yy5//mpXhwdaywo5sWp1wPniE7tVK6kc4qm/3VdhM/EGm4mLp8/bPg2QWjsyl50nvG11tcGqiLKNTlcWEOunSQrQZ9KM/6zWhNJuI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724456897; c=relaxed/simple;
	bh=sOOqwbBuXDTIyAtIxAQNmxTNNWUvnNEPZnlOI4qMhuE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fmjH9jz7nwaju1Fc/h44FYmKluDcSX7+XzS4Sf6Jz1voZqNla6nJVCgimJnfhBEatlb3zVoxuQ+/M6TlLBvOdjqC9gCaKAhPQLIt43gLoRRP+v3edLM/s/O9rbDR4u6HYG1gMm2A9Yw4o64EeyVsCPsASKdk86kCJ54PcdmklAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NxSvVtAI; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fc6db23c74so24423645ad.0
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 16:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724456895; x=1725061695; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=C+21cvWvA20RSCNk8Ww40uayuCkSP52UXC5UruboIXY=;
        b=NxSvVtAIISOx+DrrfDAi7Jrp2tDrG690a05cP73BbyS2HDqe1kqCakwHOPrujy0hPK
         kNvwQmJANV0fH74D04m3pvXcxos5R6TGGF+2iC/81e7L6MMseO8LRiZl2ucXkGzek2lQ
         g1p5DW1zlu9tp3AzXVZ2R7gDn5hCVoZmvHZ9mQ1oh310fyGxuVOsHmdwhgqQxH1kOhQn
         y88cILl2GR6kc8+QDpaqEgSh+lyMNMcGNcQDlhHjVCgZUVycP0zQckvWp7zpvPynwOmX
         TLwt2/Mroe/KX0c9+LZmaxAPOQnTDKsvFcUQWz7k5yOf51pi5wDuyGRg/s/RxpklI+2D
         2fqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724456895; x=1725061695;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C+21cvWvA20RSCNk8Ww40uayuCkSP52UXC5UruboIXY=;
        b=lHPIcP3tzDgEduCD4pGQkm0DgRAoRBEI+7ONCROz+4ZA30KAvNglWlx23LPnsXawLt
         31L0f2bOOosgBEcOWKgzMKwybb+aUIpfv0dJ47LesRotxPQbQpyY3VWODIe2OC7dPLXy
         Zy19biG7hpgRIRp24KxVhmQ+nRWFVs3sYUUSrBXRJl3fcLsiHXtCrj6SnM6Ya9DX94md
         c0KU4njrU2P1TCvR1vjSf/i/527AB8XS6Lsy9XWAL8xqI3OPI4egz1yjUnw+6Q446QWN
         eCM7hBNqAViiCv5i296X8gnzMiVe3nTQYkqjyNXmCgNXbVMDV5KYHvpoUgEezREruKXs
         dxjg==
X-Gm-Message-State: AOJu0YzMO1+j36Y1HBISzNSOlaAIoU3tjB0O8lqeD7veDdqxYr7cel/m
	16mB5kWU8yjK2UPu8WEYwdIiJBbYFk2myJtTtgyL8+R7QUeNKYe86RlQ20dTZb//ohlaEB1KHV9
	xmw==
X-Google-Smtp-Source: AGHT+IG1Zo4cycNEsNQ1ejGdL0ea+TYErjWLE5yXTXXnzMAU/RfsFWsp9nnDA+bxhWh8hhor5GQrcw7jXeY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c406:b0:202:156:c4c6 with SMTP id
 d9443c01a7336-2039e4d9ea9mr2586845ad.9.1724456894647; Fri, 23 Aug 2024
 16:48:14 -0700 (PDT)
Date: Fri, 23 Aug 2024 16:47:39 -0700
In-Reply-To: <20240723232055.3643811-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240723232055.3643811-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <172442179509.3955684.3431419416456573954.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Acquire kvm->srcu when handling KVM_SET_VCPU_EVENTS
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 23 Jul 2024 16:20:55 -0700, Sean Christopherson wrote:
> Grab kvm->srcu when processing KVM_SET_VCPU_EVENTS, as KVM will forcibly
> leave nested VMX/SVM if SMM mode is being toggled, and leaving nested VMX
> reads guest memory.
> 
> Note, kvm_vcpu_ioctl_x86_set_vcpu_events() can also be called from KVM_RUN
> via sync_regs(), which already holds SRCU.  I.e. trying to precisely use
> kvm_vcpu_srcu_read_lock() around the problematic SMM code would cause
> problems.  Acquiring SRCU isn't all that expensive, so for simplicity,
> grab it unconditionally for KVM_SET_VCPU_EVENTS.
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/1] KVM: x86: Acquire kvm->srcu when handling KVM_SET_VCPU_EVENTS
      https://github.com/kvm-x86/linux/commit/4bcdd831d9d0

--
https://github.com/kvm-x86/linux/tree/next

