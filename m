Return-Path: <kvm+bounces-9465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C1ED8860852
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 02:37:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 001051C225D3
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 01:37:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0ED2101E3;
	Fri, 23 Feb 2024 01:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uh2wCVIs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F3C101DE
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 01:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708652175; cv=none; b=bMEBC427O9jMLWuMgG+EuoKJ+mtCBvxEq72Y/mHDvOVNQzXFrnNf9pmUQtouCg91yEi/S6QzJF1pIvGL9/+/ibvt1O2s8IsHxDheBP0ClwR6GP0XOt0FePuCkhvj/94RNWAzUYXQg/1imna5qalvu4ugHgr0W2sb4LJpNzX/cHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708652175; c=relaxed/simple;
	bh=sKrhHjuZBnoJEAjzckFbQFS67R7q0pZfm+I3DqlFuOM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Rb1/j1zQGELHKS1KH1xVgC1ee2+QYOVxPpdryFV1z2INWizUZnQAZVg8i9Kf1J1PBWZE+mR+5cejLmoLsIVcQ7lmkIYhx9avkZxHSOuysEIHqLiYORYrw00TdUSk912lj6v434zm/IcWIZpWAi4pBFu1FA6RlyFW9bjKG606PQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uh2wCVIs; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1dbfc059751so3696735ad.2
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 17:36:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708652173; x=1709256973; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=h9lxD8rtJGOtHzWHBkC2Cn8UibSydBlXaSYkj0vfMms=;
        b=uh2wCVIsC7kEvemdnqrV8R8sjfwefeP4YpqsCg9RWiJTE9ZGpyIstQELxKnzK/pUfs
         KIo6RO6sizFyulDvI9FpFegALD4y0wC0peK9vtwywZtHYjXayZHNwhUbf700wk+lXr3p
         YbhTlb8AZbrSn6FI1l4FOUuiz2agotGyv0x6KBsjDTOnILfUdvEy0H5sxY53TEy1K92u
         MrDoMvax2nM5vNHllKgcVl8vzuzqI9mLg3HFa7c+O2LBPLw4CG/xcJhBx86fH88FhjNs
         V/ZcSs9BN+KbHk49/5bVbgiGuHdQu5SAAAEM/4kZQfXyQ4awOoCyvp97rXE88jxAQXw3
         eZrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708652173; x=1709256973;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h9lxD8rtJGOtHzWHBkC2Cn8UibSydBlXaSYkj0vfMms=;
        b=cgNfmf2Fe6Q7EI3eDijtRh+DuhwOg77voPv+7tyLm8pbYOTvVHToRSA5VejdEPxUNU
         3Cl3c5dJzZIWUQg2WCt8IU6NtIeOAFh0gQgwALZm1X2rweMLEZySFI4XbcCEZBRIjpre
         8sRHg9JfA3Khkr6ERPztGfjxgDCjHZMrc+9KvYJBWb2odPNDTOHo9TevYQTiApDgnvaJ
         ldhYNuq5Jc5V6poJmji6/X7pj9a2bD+lFi0rQ83vF8f2AkelDGPOXULMSUL6jpJe/b/B
         mwg7yoeihyX0aM5Wno1TjTOkieXJn/L0gc9eQ2rfUtx0uzVH0E7B0RvGWFAzx38VsekQ
         30wg==
X-Gm-Message-State: AOJu0Yy7kgVf1zQSYdwvHW/YwdEQ85g5AKguqD2rqte9o009IglzKPq/
	dlV4W3C/5zYIY1G6UfdsLSDQheX6O1IaSk62CyQ5WMVourCDq9ZY7nO72t5cIyhnV1UWUP527Vd
	0vQ==
X-Google-Smtp-Source: AGHT+IHnOxCfD8my0/2WhdbsmRzLGDIKJXPzf6QwrhuktCCwyrgQ67HqOMXSjHERWHC4u6alq80dk51rC/Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2351:b0:1db:c4b8:694f with SMTP id
 c17-20020a170903235100b001dbc4b8694fmr1555plh.11.1708652173025; Thu, 22 Feb
 2024 17:36:13 -0800 (PST)
Date: Thu, 22 Feb 2024 17:35:38 -0800
In-Reply-To: <20240209220752.388160-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240209220752.388160-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <170864750298.3085684.5517698484958714659.b4-ty@google.com>
Subject: Re: [PATCH 0/2] KVM: x86: Cleanup kvm_get_dr() usage
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Mathias Krause <minipli@grsecurity.net>
Content-Type: text/plain; charset="utf-8"

On Fri, 09 Feb 2024 14:07:50 -0800, Sean Christopherson wrote:
> Make kvm_get_dr() use an actual return instead of a void return with an
> output, which led to a _lot_ of ugly code, and then open code all direct
> reads to DR6 and DR7, as KVM has a goofy mix of some flows open coding
> reads and some flows bouncing through kvm_get_dr().
> 
> Sean Christopherson (2):
>   KVM: x86: Make kvm_get_dr() return a value, not use an out parameter
>   KVM: x86: Open code all direct reads to guest DR6 and DR7
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/2] KVM: x86: Make kvm_get_dr() return a value, not use an out parameter
      https://github.com/kvm-x86/linux/commit/fc5375dd8c06
[2/2] KVM: x86: Open code all direct reads to guest DR6 and DR7
      https://github.com/kvm-x86/linux/commit/2a5f091ce1c9

--
https://github.com/kvm-x86/linux/tree/next

