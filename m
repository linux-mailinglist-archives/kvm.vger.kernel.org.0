Return-Path: <kvm+bounces-19728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B029F9094E9
	for <lists+kvm@lfdr.de>; Sat, 15 Jun 2024 02:03:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 616391F21E12
	for <lists+kvm@lfdr.de>; Sat, 15 Jun 2024 00:03:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2AFC19D881;
	Sat, 15 Jun 2024 00:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wW2HkaXB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0398825
	for <kvm@vger.kernel.org>; Sat, 15 Jun 2024 00:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718409792; cv=none; b=HMW3Y8NSEsPyDfOlryRLW40xOeMi2OtWXXBHIvGNHexjFwj5IZw6OGRD4Qc1rk0zvCt3f82uIprIyvzh4XNVcQlk1eIno0WfUYEny5fpGwdVeATvZhb/V/mkZnOjIG/GerFbIEB4Lu/OYp7dlwazTBcBzh3iyo7dMJljT/sJ5Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718409792; c=relaxed/simple;
	bh=+W+P3ghI0cdEDSRq5OBbGrcTA7SHJqzSNkDVo/UHYFA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dXmfCdURv4spUDpfvA4NWxwhn96E+pAfeYcz08aoTtd1Yixnek3rKdkKtIdMdX/St55OK8vjONgH48Gd/13vT7ZOcFM409C5p5SFWgT0NRXbvps2RvX2pFtAsDVUp0gk27sv0vX5teyd/GqIufLUlDTq41EjWVASrJR/Jtwqgk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wW2HkaXB; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2c2def267dcso2421328a91.1
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 17:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718409791; x=1719014591; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+hxROs2pSwoWeVVbtORAVOqp5Opz2REudhGLc29IbW8=;
        b=wW2HkaXBZDgc2LydB7jPCFP/7lzSy/lFjjYf1gSi2mg5mgH+wpqCSeK0ALlwzRSiL+
         wTOWt9Ild/9VbTZxFGzz0M7blk21IRkBaLX4/OyVO0nJddd/Pxb51ea8Dp/9V19N3Cw5
         XZ1KWrWaoHCAyKIKLN9ozSzgyzF5/84q0U+xle5m+veX6OuGdNJV8Y//q0AuZPIlKRfV
         FVV1beL0Vq6YqlDvBUEUcD9KVMDukpR4YmCt/yRaq6ZtuX6CX19ZjXjvfmCqt2yMJI/q
         WUSwwKCkt3E0zg6aBVmal1jSi3zWhe2WXkKVVwl9XIqfV7fXb+EoCLoM2l0o4nhQROQY
         qCug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718409791; x=1719014591;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+hxROs2pSwoWeVVbtORAVOqp5Opz2REudhGLc29IbW8=;
        b=AXU6+Yb++mn7pB+ZWyfAIaz7mbCB8E1CxZCf0ZzxEV/zPClQfCGTvmXxcwt9BONUBJ
         KlTGDTXb1r9E5M/fWl0tY+XAxPa59S30qR4jilvOcx84aNhb7KDlAAvWb9BEakChl5Qx
         F72hnEW+FL785DDgVyWwmnM4EOPJTGq/OaU7WBRWX7nibSab1qxepkWGP3NHo1sfKejG
         dGEWkPSfBqiC5EdJwxFQiPymMrhfvVuXmEwT483KWYsrkx+5yjkp7N/1uASGw+hJXEcf
         S0t3eLX7B3ivBVs7Na4rV702SD42w2xMUJobDgHZWjgO5EL58OZ6Fm/t09lfP7TNq1Vd
         lOyg==
X-Gm-Message-State: AOJu0YzVhOMIMyyoaEKwhuFMBn6eqFIMpiQrvc4wD4cBmxsHOiVdDTze
	z5oFT0VpkahDc4592vJEgzfYRLnAljJvljCqVEFWnIHxsOFITJLpFxyamkDt3xN8SI+3Lad+lRa
	Gvg==
X-Google-Smtp-Source: AGHT+IEERIqsC1UTv45yfRqzlHV/LWimdqDoNgj35hhhJGbPhJwssS4xc0wqdW3ZZjB5Gf6V3u6siEnfZoM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1d0:b0:1f7:1706:ad6e with SMTP id
 d9443c01a7336-1f8625bb60amr122735ad.3.1718409790709; Fri, 14 Jun 2024
 17:03:10 -0700 (PDT)
Date: Fri, 14 Jun 2024 17:02:53 -0700
In-Reply-To: <20240611220512.2426439-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240611220512.2426439-1-dmatlack@google.com>
X-Mailer: git-send-email 2.45.2.627.g7a2c4fd464-goog
Message-ID: <171840976539.1411172.12319335016391468926.b4-ty@google.com>
Subject: Re: [PATCH v4 0/4] KVM: x86/mmu: Rework TDP MMU eager page splitting
 SP allocations
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Matlack <dmatlack@google.com>
Cc: kvm@vger.kernel.org, Bibo Mao <maobibo@loongson.cn>
Content-Type: text/plain; charset="utf-8"

On Tue, 11 Jun 2024 15:05:08 -0700, David Matlack wrote:
> Rework the TDP MMU eager page splitting code to always drop mmu_lock
> when allocation shadow pages, to avoid causing lock contention with vCPU
> threads during CLEAR_DIRTY_LOG (where mmu_lock is held for write).
> 
> The first patch changes KVM to always drop mmu_lock lock and the
> subsequent patches clean up and simplify the code now that conditional
> locking is gone.
> 
> [...]

Applied to kvm-x86 mmu, thanks!

[1/4] KVM: x86/mmu: Always drop mmu_lock to allocate TDP MMU SPs for eager splitting
      https://github.com/kvm-x86/linux/commit/cf3ff0ee24d6
[2/4] KVM: x86/mmu: Hard code GFP flags for TDP MMU eager split allocations
      https://github.com/kvm-x86/linux/commit/e1c04f7a9f42
[3/4] KVM: x86/mmu: Unnest TDP MMU helpers to allocate SPs for eager splitting
      https://github.com/kvm-x86/linux/commit/3d4a5a45ca26
[4/4] KVM: x86/mmu: Avoid reacquiring RCU if TDP MMU fails to allocate an SP
      https://github.com/kvm-x86/linux/commit/0089c055b560

--
https://github.com/kvm-x86/linux/tree/next

