Return-Path: <kvm+bounces-39020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FAC0A429A4
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 18:27:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B69A188D22B
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 17:26:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7CF7265621;
	Mon, 24 Feb 2025 17:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0bcHHzWi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFD3265617
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 17:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740417938; cv=none; b=J+Vh1HrtAo30RAdLemut+G8UBzzrjCLK00AMOM5tZHezvdkwZo6Ib6rtTCGSM0c6pUGQ4bhTEI1J0luBznNfW4WYjVlcYWbKjX/h6NBcQpItIGZrUeRT1s6wQeLXNhMEDJ/EZSr11RRlZU9js0hjRumjMWOClwt/P3ViKQbp1PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740417938; c=relaxed/simple;
	bh=Sbl1TVKxykT+GiSID8jEGnYBtegPMiubI3LZvvLX/xM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VwCOxxifWm0cBqF4h+UhgBJ2rfseuroSYY+p0IgWZIEy1wKO+nK6Ieoz2qkNbJ9UEOhvtP/fA7Sm+e2MvO2TegFzzZk7ecPUIrZJtKbzQgA39ewALlg7MmWgIilWtntQ3oWYbm94ciFPsFX3uTjoO6zcJQt7GFYGApkZJTLpIn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0bcHHzWi; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc1e7efdffso15203133a91.0
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 09:25:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740417936; x=1741022736; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PqR/pdo/IAqExOZd7fqoAkskS8BPoBCONk1XQm8mEgQ=;
        b=0bcHHzWitf+PHJA2J5dhXISvMXYZ0JOYK1/65I9UftvFStAto8wnCLf1qwWpoJLp0D
         JgPL1qtQcMTJB0TdkFzp8xcfdzxyuj19DjmwI0OvcxoIozVYw29Ie3oaxB/RQ+/oyt8N
         KF9pJpiRxkK+WQjSSmwb781yR9jcc2hCa0GiAehy3gvzbQduE3gJpj3dQE7BjXCeCFv3
         VmSFr8jL5p/y2YIFyMjlhXSVCLrm+Fo/7YcVAsmvmyTfw/3ZP4SM0zo2PVmvikrZa5wI
         kKRxbhI7PMahGcJa5/7dtWHxGq4zJEC7bxJ+lmAkGrSXk5lJs9tPjS9uHx3C6kAvS1he
         LDIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740417936; x=1741022736;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PqR/pdo/IAqExOZd7fqoAkskS8BPoBCONk1XQm8mEgQ=;
        b=eqg4by+QFEOcq8naK+8lIh9pL4zxPXLJNq7GWhODvWXucfob4NipXViDnoANRZQPFM
         YdrGk+YgELERAoxbPE6DYnTc+j40OUyLS5DGmE9gnxjvIvmDnOI4HJDt9WnEKT7p6Y4S
         jsa/yG+MPzf110MqnUe5ThewEZp6GiFeifFlD34Zp+Gn63ggP6DHHZSenqBO57Pv085z
         82la2fWhiMxeYvLl+XvyElHBAV4b4C7sfNabbWHSJCbjjVGYTc5qzGF1snVdyiJEH80G
         yCbYCpmTbyI/FN34V5A0SiGoQ2+8xySX7ZGru8Hnlt41tYvxUXH2SHoq5+Vy1yxdKWmy
         TEPQ==
X-Gm-Message-State: AOJu0YxSu0k49R4ZLXRiQ0SW1Bm6yWa2y/NtSVs3DGMw8oHHxIJwRLx9
	CNlXzFsd5ReGtKCg+5KCRYcuGYkiXlKbsyXMRKPylFYERfTNZ2ahjQl6WPYtX62VgIOkdJcHjjc
	P/w==
X-Google-Smtp-Source: AGHT+IF8k10IIP1q4lac8itHXhJHJ4xkNsxJYtamXS4SYzmvrd9F++wPVFPk4K8t5CTHuaDSIabE8R/Dn1Y=
X-Received: from pgbbw33.prod.google.com ([2002:a05:6a02:4a1:b0:ad5:45a5:645c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6d94:b0:1ee:c8e7:2035
 with SMTP id adf61e73a8af0-1eef3c71f95mr23600441637.1.1740417936043; Mon, 24
 Feb 2025 09:25:36 -0800 (PST)
Date: Mon, 24 Feb 2025 09:24:01 -0800
In-Reply-To: <20250221225406.2228938-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250221225406.2228938-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <174041743074.2350880.3713231744900910128.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH 0/3] x86: Use macros for selectors in asm
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Hang SU <darcy.sh@antgroup.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 21 Feb 2025 14:54:03 -0800, Sean Christopherson wrote:
> Use macros for segment selectors in assembly instead of open coded literals.
> 
> v2:
>  - Commit to using __ASSEMBLER__.
> 
> v1: https://lore.kernel.org/all/20240621122640.2347541-1-darcy.sh@antgroup.com
> 
> [...]

Applied to kvm-x86 next (and now pulled by Paolo), with the fixup to use KERNEL_CS
instead of KERNEL_CS32.

[1/3] x86: Move descriptor table selector #defines to the top of desc.h
      https://github.com/kvm-x86/kvm-unit-tests/commit/4c5d37137baf
[2/3] x86: Commit to using __ASSEMBLER__ instead of __ASSEMBLY__
      https://github.com/kvm-x86/kvm-unit-tests/commit/f372d35fb1be
[3/3] x86: replace segment selector magic number with macro definition
      https://github.com/kvm-x86/kvm-unit-tests/commit/c8a8a35827d7

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

