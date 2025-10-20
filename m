Return-Path: <kvm+bounces-60558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E08A0BF276D
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 18:36:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99ADD3A8C66
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 16:35:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BA8C29D26D;
	Mon, 20 Oct 2025 16:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n/dXFgmu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DB128E5
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 16:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760978084; cv=none; b=dch55ea1BZDTX4BRq0VbESc3+0M3MbttsmaG79JcynCkz2L6GPYNAHinCF6+u5ONjWdkhp5ZCsaKiz1gACC2jithn6PmMMWU2fQEE+V0Ck/xmBuo15l93anvPDKhKRYlTRGqe1deW/ymwwUq5K8Sgqoq21ms9Uc5losSjCbKIeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760978084; c=relaxed/simple;
	bh=EKnvTmQWXIb3QulB8OxEwhVGwFls1eJdoaM7jZiZ60E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FCMbYwiZaz5HMBcRqs8nyL0yE3KwqYGramzRoEuetW8vB2kYXNYUMT0Feqp0mWHiUultXpPPYgS74m5HOqp35DHvJNEZHaT+NbYeJDCLveCgNl5/XYKnGCSfdVxA0C/FPVRmyCx+6Xph+drsKP7/dv8mTEBxKnc0iswWUOG/eP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n/dXFgmu; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b6325a95e44so3837319a12.0
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 09:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760978082; x=1761582882; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fp2M7y/YIkoquLfcKGxuSyhApeoEnp7Mnl/v7xe2miU=;
        b=n/dXFgmuWRvUCLuK+lHCZg5+/VHIUUtOdcpfm3hyZK6D/T0AI4whW7uN/7Jh5+j4H4
         c2Q3NBuNAaCs5fauwCaRVnh8z44w+rPA1PDHgiVKT7QHMLJbvssvG7fOPU4k5LkYh68z
         cVhtrXeQSNIPCwGI9uCm47xpOKrNi4be5dMOQtGrpNwclgk2g9Kk9SHUsvthFExr8li7
         5zsLK+eJTm8WbFl234DRqicsfry+ExMCPnq+xBuAEEl3cY+eNkBNOlVeaUcyQqL66iM+
         CaiagWinsdl17qr51+n5dbw3N++X+nsZjQ8FqCRtMzKsabF4/uYYeqN18kHc4oD3COq1
         oH3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760978082; x=1761582882;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fp2M7y/YIkoquLfcKGxuSyhApeoEnp7Mnl/v7xe2miU=;
        b=L6s8mlmjemp4u6K2sAPeGpbGrqllqn25wBkGAq7OYC80ftM190Yzth2n8d2vlsQjUk
         Bt1hL7kWBTo9gK3X6HBaGuhAzj+M3SYkXoVXJnzmrp6sfXagvJzk+wVcjWYVCl9fu47+
         XUOwN/daOcJojk/vUzbLOaJXOg1oT/vduguYMyQRtKY+GKEGAQh523+rEkWqcgeQ8n1Q
         gii2EvjXzKlQmRu8WYOSHGCedB/Fey29rHbMuSQuQjS7LqE33b8PfhUXTfqv1g6jyF4z
         UCXJjE2RnUbFDarEYgpdgZbk2dHgMMMH+7EITCVTWFWE8gThjhR3t4LR6jeXFFwDmERp
         l4dA==
X-Gm-Message-State: AOJu0YwOsuvdHv4NXFqhULRfIxJ+OoAuJGki6RlZBV72cqGac5sXfSzJ
	tWdCVzRSz2s1Q0E1LwpI1m7llvjLTrmdlOLhyUsFbLqpHbcfC6ac3dfQJwJL0d+ACDz4pp2xzfu
	UD/pvKw==
X-Google-Smtp-Source: AGHT+IEfJBrBNRQn8+cn6fgmQOnDkh3t6dmbXJnUtpRU+T1/SW9hG6iOheIivj/skyPPBe7GkdNTpM1ILXI=
X-Received: from pjzj22.prod.google.com ([2002:a17:90a:eb16:b0:338:3770:a496])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:32a3:b0:32d:95f2:1fe
 with SMTP id adf61e73a8af0-334a786492fmr18401737637.2.1760978082232; Mon, 20
 Oct 2025 09:34:42 -0700 (PDT)
Date: Mon, 20 Oct 2025 09:33:11 -0700
In-Reply-To: <20250919005955.1366256-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919005955.1366256-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.869.ge66316f041-goog
Message-ID: <176097600449.438961.7346944615480363146.b4-ty@google.com>
Subject: Re: [PATCH 0/9] KVM: VMX: EPTP cleanups and nVMX fixes
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Thu, 18 Sep 2025 17:59:46 -0700, Sean Christopherson wrote:
> This started as a trivial series to cleanup KVM's handling of EPTPs in
> anticipation of eliding TLB flushes on task migration[*], but then I made the
> mistake of trying to test the nested_early_check change, and things snowballed.
> 
> Long story short, nested_early_check is obviously not being used as it's been
> broken for years, and it's not adding value.  E.g. doesn't help us find KVM
> bugs, and doesn't provide any meaningful protection for KVM (especially since
> no one is using it).
> 
> [...]

Applied to kvm-x86 vmx, thanks!

[1/9] KVM: VMX: Hoist construct_eptp() "up" in vmx.c
      https://github.com/kvm-x86/linux/commit/f48888bb8ad1
[2/9] KVM: nVMX: Hardcode dummy EPTP used for early nested consistency checks
      https://github.com/kvm-x86/linux/commit/a8749281e4c6
[3/9] KVM: x86/mmu: Move "dummy root" helpers to spte.h
      https://github.com/kvm-x86/linux/commit/a10f5cc3ac9b
[4/9] KVM: VMX: Use kvm_mmu_page role to construct EPTP, not current vCPU state
      https://github.com/kvm-x86/linux/commit/2f723a863423
[5/9] KVM: nVMX: Add consistency check for TPR_THRESHOLD[31:4]!=0 without VID
      https://github.com/kvm-x86/linux/commit/15fe455dd1a0
[6/9] KVM: nVMX: Add consistency check for TSC_MULTIPLIER=0
      https://github.com/kvm-x86/linux/commit/ae8e6ad84177
[7/9] KVM: nVMX: Stuff vmcs02.TSC_MULTIPLIER early on for nested early checks
      https://github.com/kvm-x86/linux/commit/f91699d5692d
[8/9] KVM: nVMX: Remove support for "early" consistency checks via hardware
      https://github.com/kvm-x86/linux/commit/a175da6d430e
[9/9] KVM: nVMX: Add an off-by-default module param to WARN on missed consistency checks
      https://github.com/kvm-x86/linux/commit/1100e4910ad2

--
https://github.com/kvm-x86/linux/tree/next

