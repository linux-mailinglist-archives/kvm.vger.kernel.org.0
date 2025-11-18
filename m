Return-Path: <kvm+bounces-63615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 20B9CC6C004
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 00:29:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0F43335FFC9
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 23:28:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38E0B312807;
	Tue, 18 Nov 2025 23:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aFI3uxW7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9AC3126C2
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 23:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763508484; cv=none; b=bVjOfEKEZEdnGtlBkEyP6Q5o3oCSLFhpu2Z/ZcxZ1rIn1/3MJnodBTTBBF5CcefNeIzmEeqCO4HPJrwETDU8VypoutdDEaZQr9YSriD1f83xT7crxdv8pn5ZioMMPZdrhYC4yZCfK0mQYf+7EsfL8JHR4oUs9UjOX2/7mxNnfG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763508484; c=relaxed/simple;
	bh=vps6lRauIttvj+s5+KUftUHoHYrNDhdAp7e/CPGgRxA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fYnDNE4LwHh86dOZ2gQ3VcRBUMArAGvApDp6IFcm1xxs5TYWp1rRCzy+2dPu/Y9Vo1lKq4gHcbN3xTU5a8JWsVzMBbf8udtkaeZS7F+5t7fXu8zC3gDsjZa2/qEvciRabTWOibkM5jMwM+IFJHCZ43YWQfokCcgZkHHDVDyaYwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aFI3uxW7; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34176460924so5840499a91.3
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 15:27:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763508479; x=1764113279; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qHLsiaf+Gd7bP2runIKtFw9yObSat7An9kzl+7OrJhY=;
        b=aFI3uxW7U1wJor9d5TCpe+njJLkKnKLjNlwUtEgf48n3NLIwpZc8/oaW7zlC8yPE3K
         UR3QA42C2rL6cP5hBoI14VGtr+EX9NSedPFx7hKhkw5Jn3gErtbsLneuTGzA3Pxs+tMm
         Czm5fIfQRXsc1s1bdYD4VQZYPKfMJla+9WqTicrpwRRGtKsXnqQLjF6knA79GR6CLDYw
         BFxkFG3tFxHEK8bVg3JaXpSNaDvzBhjuFKOhVGajb5CWBh7mCgeuuvwcHq14PQRgj7Q1
         a6fD1AH/QbNkC2YPcJcsCg2K2YzhCsBLDIHRKZ4Sk1Jt8ZkAwW7OzsZu8MKuymfuNEQm
         yV5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763508479; x=1764113279;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qHLsiaf+Gd7bP2runIKtFw9yObSat7An9kzl+7OrJhY=;
        b=i6gzdlWXoIH40szNLXpSTTj3yvBb+8DRTSy9gd1vflcNx/6ZUHiP8MHqCxkgKRKG4g
         HcoPnYk2GNYiPAdNNxnzXKlB0RSSQUkkmeEyouWtawP+bkad4Yb7C2Rm/4zPSQrBKRRd
         e/O1LxOl+lSO1j5TAHr4WqYW8701YXgHNFqqaMsh9fWIuQhh2L+f6jyDZX4LWB3EWnlh
         lPoA9+jbCLZgK56z152fVMGdT24chCD2IIUJMb0ieDEWfDnwD7rex+D3llTtnX595bie
         9toYyOTa0LhBF8q8mymquKgoa/4upj6KEc+S1axoGpPPfDu6PNgtfi3EmxuDu54MSf/P
         XtvQ==
X-Gm-Message-State: AOJu0YxhD/VEn+Xycxedtuq543bl7xvmdp8V4K7uEAvLAOaSO/n7R8LS
	X7zlLJCg8RCca8p/O0srYXh0POdbw3+/631ihoOmRz4SxdJ2VO0asDi3nyOOEbW773gyOA/Vdqs
	/k1+mRg==
X-Google-Smtp-Source: AGHT+IFvbvnN5XF55Yr07t7HJgvAE7Z1IO3g2RjO3QCtlzpYbMlJTUzG+ECF0LwdGprAIymapDoABD2mSkM=
X-Received: from pgea7.prod.google.com ([2002:a05:6a02:5387:b0:bc1:587a:f2fc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:a125:b0:342:9cb7:64a3
 with SMTP id adf61e73a8af0-35ba22a4fcdmr23456437637.34.1763508479228; Tue, 18
 Nov 2025 15:27:59 -0800 (PST)
Date: Tue, 18 Nov 2025 15:27:43 -0800
In-Reply-To: <20250819152027.1687487-1-lei.chen@smartx.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250819152027.1687487-1-lei.chen@smartx.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <176350813109.2284323.14026861904244488067.b4-ty@google.com>
Subject: Re: [PATCH v1 0/3] kvm:x86: simplify kvmclock update logic
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Lei Chen <lei.chen@smartx.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 19 Aug 2025 23:20:24 +0800, Lei Chen wrote:
> This patch series simplifies kvmclock updating logic by reverting
> related commits.
> 
> Now we have three requests about time updating:
> 
> 1. KVM_REQ_CLOCK_UPDATE:
> The function kvm_guest_time_update gathers info from  master clock
> or host.rdtsc() and update vcpu->arch.hvclock, and then kvmclock or hyperv
> reference counter.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/3] Revert "x86: kvm: introduce periodic global clock updates"
      https://github.com/kvm-x86/linux/commit/43ddbf16edf5
[2/3] Revert "x86: kvm: rate-limit global clock updates"
      https://github.com/kvm-x86/linux/commit/446fcce2a52b
[3/3] KVM: x86: remove comment about ntp correction sync for
      https://github.com/kvm-x86/linux/commit/e78fb96b41c6

--
https://github.com/kvm-x86/linux/tree/next

