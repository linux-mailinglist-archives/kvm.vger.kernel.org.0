Return-Path: <kvm+bounces-39018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FE26A42990
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 18:26:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C208188A1BA
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 17:26:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6053F264FB0;
	Mon, 24 Feb 2025 17:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U+o/L5ul"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF5E264F8F
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 17:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740417927; cv=none; b=GN8vqLquAlK5xtArtXzbto2RDNS/P78re6GYCKnSCQRDMxjJmXjcxHYtWodmuk5rXI24x1l3NCHaBeJOUzBVeqDy3tRevPzrL9RuqiWXgHo0seG71ZDNyWXO3qQAYWAn8BPmihF457W7WpY+U3qJOi6NecWrC34DFHyaKU2x1ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740417927; c=relaxed/simple;
	bh=ctbrTuFH7R2ueoO+oTy0O9jGNa4+fzFfILHht0X7Tww=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Km1lRMMXNR0nVFvHVPJ+FbFU8+Sam+qo9Pk2oRuTgqA96jvzL3vBjz6PKTh1jy5Y4ZqyuYeT95zzxbRTFmP6Sd8y7Z2ntO9ePrDpXKgkXb+A6qW7Tj9Jr2twWTRHYvn7vs2t2OhBIwmKI+LE1X87BjVO5BnYi7HcfW2fAus306k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U+o/L5ul; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc2b258e82so10102941a91.0
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 09:25:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740417925; x=1741022725; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OqjMK2X0JbNnmuLLOOLWghfw5pgxsv1mo5Czyx86hhQ=;
        b=U+o/L5ulR2IvAjHRqOSGJ00BX/SItW7+nYULn4bgT7mdnQZte0oIxX4BylwuFaz6wa
         KPIhcZ/5iO2EsKD0zho143EwdsfPreBw3Btr0ajTQIGHxwtItLox2xVw4vRDDJhhphgI
         EOEtYwaeKSuV5HICCi27KIK/gUQN2U+ec4+bl5g5Ltacvtgwn62CiduSTHDISXKKIyLK
         w8WX7HtgsI06yjB2KzEgzasORbMrvXW00AeqQ3xUcXHKyKuMDEO0msRJ9MWRSJ6XZPYb
         9SdkW2ofc+B9HFzdGS+4RNe+VmAYJQMXYy5uHFIhloklat60CasxBasJQ+fjDCzV4Bma
         ltHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740417925; x=1741022725;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OqjMK2X0JbNnmuLLOOLWghfw5pgxsv1mo5Czyx86hhQ=;
        b=rN202Cl+9+OwKjzMDH8Rh9KwqnXezm++fK7+Mf/ZS/tRgukLemf8b+34a0XZPrwu3Q
         H5pZpVjMP2iw/NnMcPCe8ugC2WZUAS4EghMOSSL3zY6uALRdPzXwGXkH2pAQ90u6zgSx
         UTUp9SGA5mhwPLvqHZsrWqH+vBD0jAtRxKqbi/S2IIvwMoW7gEAsEdtylaYBZyAJ8Xg9
         OrkKew2PuCPN7M+iSqAjp/J6ZFoc4bUAlCgK3nzs9smnI+pff77LVefDOZjuCpZemCPd
         VHkP+pIR+qXnVGH+KWE31myTzu14qkjSKgGXxaG28ERo2l5fc5ZHPNoopEukRdJ3wrAN
         4auA==
X-Gm-Message-State: AOJu0Yy+nDIpBJ2tzP79+IlPomEqWC/VmS2Ncs97RGLShTu+ajx8e8wC
	ywB07/oLz/NnwpENrbs415xTAHuldk1vucGUpvb9Iv2Uz2GABD/FODi5KUrdbkruSvenOfSm3uM
	+5g==
X-Google-Smtp-Source: AGHT+IHNsqwx9BOMFFnMW02CgqiF+yncw7JPaDh59sbv+dOMNnUmm+4PnYau5Ps79slituLL974AlKyoWhk=
X-Received: from pjbsl14.prod.google.com ([2002:a17:90b:2e0e:b0:2fa:2891:e310])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4ac7:b0:2ea:2a8d:dd2a
 with SMTP id 98e67ed59e1d1-2fce7af3f5fmr23342473a91.27.1740417925419; Mon, 24
 Feb 2025 09:25:25 -0800 (PST)
Date: Mon, 24 Feb 2025 09:23:57 -0800
In-Reply-To: <20250221204148.2171418-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250221204148.2171418-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <174041777392.2353674.17956869188310473818.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH 0/2] x86: Add split/bus lock smoke test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 21 Feb 2025 12:41:46 -0800, Sean Christopherson wrote:
> Add a testcase to verify the guest does NOT get hit with an #AC or #DB
> when generating a split-lock access.  Bus Lock Detect, a.k.a. BusLockTrap,
> enabling on AMD exposed a bug where KVM incorrectly runs the guest with the
> host's DEBUGCTL MSR.
> 
> Sean Christopherson (2):
>   x86: Include libcflat.h in atomic.h for u64 typedef
>   x86/debug: Add a split-lock #AC / bus-lock #DB testcase
> 
> [...]

Applied to kvm-x86 next (and now pulled by Paolo), thanks!

[1/2] x86: Include libcflat.h in atomic.h for u64 typedef
      https://github.com/kvm-x86/kvm-unit-tests/commit/36fb9e84a465
[2/2] x86/debug: Add a split-lock #AC / bus-lock #DB testcase
      https://github.com/kvm-x86/kvm-unit-tests/commit/8d9218bb6b7c

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

