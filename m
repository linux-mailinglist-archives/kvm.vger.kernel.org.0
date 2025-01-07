Return-Path: <kvm+bounces-34655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 098BAA036FC
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 05:26:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 93B5A18837D8
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 04:26:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C551194A67;
	Tue,  7 Jan 2025 04:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qkqbYOCY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129CD3F9FB
	for <kvm@vger.kernel.org>; Tue,  7 Jan 2025 04:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736223961; cv=none; b=RPw+dlbfqX85+oC8l2/Z1pJE1ZduYfAeXn0fPwZGi21aVOQ1kFewkfDjsenkOcf5Gw8qMz5UTBK01GlKc054Bk0+8ivg0JWUNjH8DOyo0f5bukPXOFQqsMSTjvPfl7H/KId1BUmbsWguxVFYuTMaRR/LTaXJDa6LPQ8mnY99S1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736223961; c=relaxed/simple;
	bh=q4XP1mcxyRTV8ljYZwLz2rFCo2d8/NzhcyRQyfQ6co4=;
	h=Date:Message-Id:Mime-Version:Subject:From:To:Cc:Content-Type; b=Miushoqnb9ta4JkTapcO5F/x/qkZexQc/ZXbzG1uCEwgydOoWO1zGf/5feJHjia3ZtHCURTGSafcCvBubcp3cNu4Ue7CeotZct5fMf9P7fIyNS3q3Y2wmpJMbZoICuMVYzQXRxzYk+E+MDNUni7Re5BVAq2x/uhI+LIyOEhzc40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qkqbYOCY; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e49803b3fe4so14279458276.2
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 20:25:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736223959; x=1736828759; darn=vger.kernel.org;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Xvyt7ISlXjtwBUhHlRKzb+2WR3hUAcYjIzDNfnfVyL8=;
        b=qkqbYOCYIoSJZgxe0bXidpQSsx0SsX6oo40tVgTHa2TGJOKjxQ8UmidPBrXBbvT/xf
         xn/jb5YEG6J3AxrIF2COqjzpjZ8cIR1v1pWAQTbYhlsnau0FDO013YBgqgDmHLRxLzrO
         gNX/P9PEI5nPDkbx/rySiCy64oPCso5/La8gA3bMzzgg4OLycy1gEJOThP93OyysoyDX
         pX6+ePRLjGJrqpAqNVafgpJEedu+D0XXxmPTqcXVqNj2HHCEe3qyfLZxjFdarjyDVDV/
         A1jeXKRDfwCaKEQxdKI8KFUlsFEq+hgAhsUYyxozyVg0+mwtUQpyFBxbFIwuKMslw6TD
         NNtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736223959; x=1736828759;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xvyt7ISlXjtwBUhHlRKzb+2WR3hUAcYjIzDNfnfVyL8=;
        b=lOBNoWqIyrFyHzgAUYpr28JS33RgEInpKUpHAx/vxq0T3xVIEItX7GgPXIX8kP5VwV
         5erAuaiQDOGkQA4gK7SjMFxNBLBrzcj3LSiM9ayV32mYDf4IZHde7aysHo6VRjB97GW0
         NO8Lwkw5KIqEOQRmRmW0fUEFVSyu+AbsFPp2hRzjSwWJDv2biFth8Lai+r5FHmLQp7dT
         Zum+rQTY+uDrduizslGs2JEwtc8ZVqtP1mkYBEEqBXmfLTuOd8hpmSLSG/saNtqCgKXy
         Q3CKMsVRNIy7HYFsecqjlB1SAZvvXSFimHsVGLWVTa6Ms8D2rgtEtXyQJ9ktEoauz66p
         /E6w==
X-Forwarded-Encrypted: i=1; AJvYcCUTAM9O7obWH8NFOkgmgPpgqjBqttW8sbiMb/x3gCIvmeaIOdyM6jl9tsDhDDFCCETq22o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0HK7N4B0bRiTfZeEuaR6c03vcf/BJZhOXfkVqux9vQp1yFlBG
	qkOHu9fjJk9eo4kcu9RcRBdJQJpGHYD/xQ7ojAKtS/q6XreJ9No9j4jnZC7/iX5ComNYK0I0Rwf
	G+6t393DZ2A==
X-Google-Smtp-Source: AGHT+IHqgvq01vvZI5gZw7/Qm7CxyJFta1CnaqIdyfdylw/V2kEeU4WaPTKKeWUqcuPrJ0Rb3xrNKJ26nJ7+2g==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:66b9:6412:4213:e30a])
 (user=suleiman job=sendgmr) by 2002:a05:690c:288f:b0:6f0:22ad:43f8 with SMTP
 id 00721157ae682-6f3f8246a83mr1672567b3.7.1736223959088; Mon, 06 Jan 2025
 20:25:59 -0800 (PST)
Date: Tue,  7 Jan 2025 13:21:58 +0900
Message-Id: <20250107042202.2554063-1-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Subject: [PATCH v3 0/3] KVM: x86: Include host suspended time in steal time.
From: Suleiman Souhlal <suleiman@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ssouhlal@freebsd.org, Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset="UTF-8"

This series makes it so that the time that the host is suspended is
included in guests' steal time.

When the host resumes from a suspend, the guest thinks any task
that was running during the suspend ran for a long time, even though
the effective run time was much shorter, which can end up having
negative effects with scheduling. This can be particularly noticeable
if the guest task was RT, as it can end up getting throttled for a
long time.

To mitigate this issue, we include the time that the host was
suspended in steal time, which lets the guest can subtract the
duration from the tasks' runtime.

v3:
- Use PM notifier instead of syscore ops (kvm_suspend()/kvm_resume()),
  because the latter doesn't get called on shallow suspend.
- Don't call function under UACCESS.
- Whitespace.

v2: https://lore.kernel.org/lkml/20241118043745.1857272-1-suleiman@google.com/
- Accumulate suspend time at machine-independent kvm layer and track per-VCPU
  instead of per-VM.
- Document changes.

v1: https://lore.kernel.org/kvm/20240710074410.770409-1-suleiman@google.com/

Suleiman Souhlal (3):
  kvm: Introduce kvm_total_suspend_ns().
  KVM: x86: Include host suspended time in steal time.
  KVM: x86: Document host suspend being included in steal time.

 Documentation/virt/kvm/x86/msr.rst |  6 ++++--
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/x86.c                 | 11 ++++++++++-
 include/linux/kvm_host.h           |  2 ++
 virt/kvm/kvm_main.c                | 26 ++++++++++++++++++++++++++
 5 files changed, 43 insertions(+), 3 deletions(-)

-- 
2.47.1.613.gc27f4b7a9f-goog


