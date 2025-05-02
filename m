Return-Path: <kvm+bounces-45266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF820AA7BAD
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 23:55:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 432037B0EB9
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 21:53:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AEA221B9F4;
	Fri,  2 May 2025 21:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rmHpAdGp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF9620E005
	for <kvm@vger.kernel.org>; Fri,  2 May 2025 21:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746222798; cv=none; b=eIqup0NgXCWs1WlN2gjXetVUuA/k8+G5nGe1JJFsWUS0Y9uRHrkjkwKC3cJUYvtPRVS75bPLuK6ncCr86NvZ23pvdFbiTlQeJ1XLMXsEePAb2+cXsDOsE4Ru6RQOjlT4+PGP8YML6gYF8LYp7Dhx7VashdGEUial7cwY3yteFLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746222798; c=relaxed/simple;
	bh=nCQfZRGnU7XdEzRqGD04fz4uMnP/E5gcgt1TqjuuJmE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=coJiEH2qCAbrw0TlCuhzB1k6GdBF/9JfRAFE2foTubDWRQ44w5z6moV+aqo8NRA7cKtHo3tcolIE/miEe4jjTYRCggdECRKv1WcvoNkEIJ6Pgk9hC3FOYXqvD29U4lBkfX2cjZhKoVElnOdy2Xyqm5noJIXN1dFiueeXx/1xkLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rmHpAdGp; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-225505d1ca5so24688355ad.2
        for <kvm@vger.kernel.org>; Fri, 02 May 2025 14:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746222796; x=1746827596; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TOOJN/3iLkJuzLWQ6HzhE0I5jjTP+F/Ic+GWLQnPrgs=;
        b=rmHpAdGpnl/AlAugtxLoRZytQrXzWjTZmljfrI24S3E061cfnjkFhRUo+uGWD73lmp
         6pL+2E03gn9Yr6hRJ2iZ3JdRlJYyqBBw5ur9/mTahYwd0OrGLP/4xoqK2kDWl6NxzuMV
         xpTUFqWMo1bHvgExx/TQpzhf1G23llH2t5iDN/h4wRxDqfY0YjFJtmwgFxVNy0BFWYQY
         Aw0EB3RXumzLMeoM/3RS4sHfEnnnxUMWGIq5m8ZxbWz21StY/aN53VBUtEqhIp+wchSc
         Tym3GMTHPI56jVGmaL7dDgDTNhmICsVf7LURnD+jQnttyY90C9kgNG/dHVxWJ5r9DnMT
         MdQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746222796; x=1746827596;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TOOJN/3iLkJuzLWQ6HzhE0I5jjTP+F/Ic+GWLQnPrgs=;
        b=bSeQXfX6zV5lVbw4CO6VVKiHIPqD7ofjhnGMoVKXeLXxr2Tx5oR77U6yAKUiTJf/Fw
         FJas0rIqn5oy1d+Kz7qwj0gaMvb+Vfst2Gpb5slOrP243Xh15qWVpxscqBIxcdVYFhtd
         2aU89rcJdAoWQZicm/9aTtRT4hAoz4BmeUwhVuj+UNNXXFh2s+tU4hmkfjxbRnlsGBPo
         aIDaPIctgaJxJyTYyxgvTHmy+higunPcClL/MYuOykX5JrlweYSWmCe5UHPZ8YR9fFpP
         DYjeF9LdlHO0ZEKKc7YfMp63I75K+mirReDJ2bLlB/Tb7Xc611kOJAnGY7aF6N9eC+gb
         089A==
X-Gm-Message-State: AOJu0Yy67PNxeDVQXaPYwUUeOzHpuhH4WR2Mdjw9OqwUXfaIflZ1ZukT
	iD1Z50cEypMGk6gxuldAf0L+t5KrzEqq/0T2NKyhhuXL0fClfG2FojRtM/HayZl8fP0hRRg7yAI
	l6Q==
X-Google-Smtp-Source: AGHT+IHYs1MEn10lvN07xty29oFw5oiyxFAmn6SFBXdP9nD8jAOeMnNJQ3el6hmUPc7oHdKrGD6YxS6KF80=
X-Received: from plbml6.prod.google.com ([2002:a17:903:34c6:b0:223:432c:56d4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3c25:b0:22c:3609:97ed
 with SMTP id d9443c01a7336-22e1031f6femr66397945ad.30.1746222796181; Fri, 02
 May 2025 14:53:16 -0700 (PDT)
Date: Fri,  2 May 2025 14:51:05 -0700
In-Reply-To: <20250502203421.865686-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250502203421.865686-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.906.g1f30a19c02-goog
Message-ID: <174622200919.880464.5585413953831680839.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Revert kvm_x86_ops.mem_enc_ioctl() back to an
 OPTIONAL hook
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 02 May 2025 13:34:21 -0700, Sean Christopherson wrote:
> Restore KVM's handling of a NULL kvm_x86_ops.mem_enc_ioctl, as the hook is
> NULL on SVM when CONFIG_KVM_AMD_SEV=n, and TDX will soon follow suit.
> 
>   ------------[ cut here ]------------
>   WARNING: CPU: 0 PID: 1 at arch/x86/include/asm/kvm-x86-ops.h:130 kvm_x86_vendor_init+0x178b/0x18e0
>   Modules linked in:
>   CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.15.0-rc2-dc1aead1a985-sink-vm #2 NONE
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>   RIP: 0010:kvm_x86_vendor_init+0x178b/0x18e0
>   Call Trace:
>    <TASK>
>    svm_init+0x2e/0x60
>    do_one_initcall+0x56/0x290
>    kernel_init_freeable+0x192/0x1e0
>    kernel_init+0x16/0x130
>    ret_from_fork+0x30/0x50
>    ret_from_fork_asm+0x1a/0x30
>    </TASK>
>   ---[ end trace 0000000000000000 ]---
> 
> [...]

Applied very quickly to kvm-x86 vmx, as I want to get the TDX macro cleanups
applied.  I'll force push if someone finds an issue.

[1/1] KVM: x86: Revert kvm_x86_ops.mem_enc_ioctl() back to an OPTIONAL hook
      https://github.com/kvm-x86/linux/commit/f2d7993314a3

--
https://github.com/kvm-x86/linux/tree/next

