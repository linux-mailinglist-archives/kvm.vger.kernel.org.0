Return-Path: <kvm+bounces-52261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C207EB034FF
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 05:37:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35A603B2011
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 03:37:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48FBC1F2C45;
	Mon, 14 Jul 2025 03:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q9tB4nOY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033491F130A
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 03:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752464233; cv=none; b=dqwR0RXqHv7i0U1uHz1qGXBH+6Q+uqDsifWuQuA/lTJTw0ptZ6OGJh76/4Xw5ZUE7gPDd7S/SWFCMxgw8jd+gakZV6HIcBe900UOwjzOPXI91/cuOhKL6GKoGRIryx1aJ5ygCWyYsLHKtNqh9ZW0heESESOibdax8P8CSBKIDFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752464233; c=relaxed/simple;
	bh=OfpS65Wq2l4GZk7q+sltE7YIrOp6kC70YtIkuTw8Aj4=;
	h=Date:Message-Id:Mime-Version:Subject:From:To:Cc:Content-Type; b=PEbENxn2YVZ9mbnaKXR+CXFXtZ0bVij2/IjXJJgi7HxOSTTXAXHIvm1bCCGetPfldZ3XEOAck4HqNCSlQ5ZD56pu+mhJzTZcwVS63X0OIrofCHGBkW1mHisJHrwgQFEqoERguMzBRIqQuowr/ySh6/YyDsuhQcxlSQTXZOjUHZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q9tB4nOY; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-70e7f66cd58so56125567b3.1
        for <kvm@vger.kernel.org>; Sun, 13 Jul 2025 20:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752464231; x=1753069031; darn=vger.kernel.org;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=su7BCsoBhxlfoX9vtVyWNsaDnFW5ssEpsTKkRCgbFY4=;
        b=Q9tB4nOYAW8TgKr3ktqgqNLOt3pEtK1Ynq2Qqmj8lzM1UO+ivZZNWRZOQJJbDOV6Ni
         QvmL/rDUfYwklEAqHp1NfBCUPA3r+9JEcTS8oaeVEJ6omRq0+tEaVREENK92EAP158z5
         ZQgk6kK2DO2ggVqn5/BwZfQtkYuxmO+5OYwX3Kuqa9naUI+7WCkBkcwSdKxKVDmY+SGp
         Vi6TLVmL1TGtFoxKPINCofCglDNZFpGYB1YAQRrOQAMihVZ0DbJlPPKoAzSDs06vPQ55
         JFjd8Xlg3wyYXPTCS34D42Xr28BPailkq7YUvcgdZAmT22uowMzH7kUzlN+D0gWXm8iD
         e6Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752464231; x=1753069031;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=su7BCsoBhxlfoX9vtVyWNsaDnFW5ssEpsTKkRCgbFY4=;
        b=PD3KLnotXPIpeFOM0vtmGBE5MJR4Qq70SNL0m1JnMEQP5X91lDqkUI3VcfFtom3M+N
         UK6OOnox4FTeysbkTFwXup1x2CPYzIA3uC+CBoEQ/O0wYumBJT8sDTzHCajfUuvCoyyZ
         vlu7S+pdwwPvKl209U8tokBuRhGq8bhcbW1N7wBm9T6UAxP1u0xYuF1yEik6w43LgpHn
         YESwAf4JZUQGl//Aur1Apsynuz57HPSyFp51n3o/z7svu6MrSRXSFUsHvTA8zF3+aG4C
         HJ38brvEQNjWlsqdQm455As2I+rbV71Eldiji+hN/Km+vWnVMfXnjSzGDbREIC3uHQbZ
         3vlw==
X-Forwarded-Encrypted: i=1; AJvYcCUSvrfwgfbkSbGHuxoCPGqw4mervHq0onlJtMPjlpGiFrSwwVSeVXzX94HiEM7okdX8omw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhYj9jzrBrvCojDcRYeNaplPZgz9P4vyToE+eegJYWwZhjy77w
	AZAvsfRnZIvT60CytkEj2wRvFmqrQQlN6qSpVcVcEz/0jueAGNlPt6zYVwVOk9N7Owwm7OKatxC
	rFQIOla3/klc9ww==
X-Google-Smtp-Source: AGHT+IGnQksW0zPWdjhkjwOREfIiyIqVZ2bVZfTEIzZnRt/TAh/MLlgY8SmTZvmAkNa4/iIaySpxP5ExwXSsmw==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:4f90:1ee3:198b:1fe4])
 (user=suleiman job=sendgmr) by 2002:a05:690c:8682:20b0:712:c55c:4e6e with
 SMTP id 00721157ae682-717d5925b6bmr20447b3.0.1752464230093; Sun, 13 Jul 2025
 20:37:10 -0700 (PDT)
Date: Mon, 14 Jul 2025 12:36:46 +0900
Message-Id: <20250714033649.4024311-1-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Subject: [PATCH v7 0/3] KVM: x86: Include host suspended time in steal time
From: Suleiman Souhlal <suleiman@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	David Woodhouse <dwmw2@infradead.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Tzung-Bi Shih <tzungbi@kernel.org>, 
	John Stultz <jstultz@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ssouhlal@freebsd.org, Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset="UTF-8"

This series makes it so that the time that the host is suspended is
included in guests' steal time.

When the host resumes from a suspend, the guest thinks any task
that was running during the suspend ran for a long time, even though
the effective run time was much shorter, which can end up having
negative effects with scheduling.

To mitigate this issue, include the time that the host was
suspended in steal time, if the guest requests it, which lets the
guest subtract the duration from the tasks' runtime. Add new ABI 
to make this behavior opt-in per-guest.

In addition, make the guest TSC behavior consistent whether the
host TSC went backwards or not.

v7:
- Fix build.
- Make advancing TSC dependent on X86_64.

v6: https://lore.kernel.org/kvm/20250709070450.473297-1-suleiman@google.com/
- Use true/false for bools.
- Indentation.
- Remove superfluous flag. 
- Use atomic operations for accumulating suspend duration.
- Reuse generic vcpu block/kick infrastructure instead of rolling our own.
- Add ABI to make the behavior opt-in per-guest.
- Add command line parameter to make guest use this.
- Reword commit messages in imperative mood.

v5: https://lore.kernel.org/kvm/20250325041350.1728373-1-suleiman@google.com/
- Fix grammar mistakes in commit message.

v4: https://lore.kernel.org/kvm/20250221053927.486476-1-suleiman@google.com/
- Advance guest TSC on suspends where host TSC goes backwards.
- Block vCPUs from running until resume notifier.
- Move suspend duration accounting out of machine-independent kvm to
  x86.
- Merge code and documentation patches.
- Reworded documentation.

v3: https://lore.kernel.org/kvm/20250107042202.2554063-1-suleiman@google.com/
- Use PM notifier instead of syscore ops (kvm_suspend()/kvm_resume()),
  because the latter doesn't get called on shallow suspend.
- Don't call function under UACCESS.
- Whitespace.

v2: https://lore.kernel.org/kvm/20240820043543.837914-1-suleiman@google.com/
- Accumulate suspend time at machine-independent kvm layer and track per-VCPU
  instead of per-VM.
- Document changes.

v1: https://lore.kernel.org/kvm/20240710074410.770409-1-suleiman@google.com/

Suleiman Souhlal (3):
  KVM: x86: Advance guest TSC after deep suspend.
  KVM: x86: Include host suspended duration in steal time
  KVM: x86: Add "suspendsteal" cmdline to request host to add suspend
    duration in steal time

 .../admin-guide/kernel-parameters.txt         |   5 +
 Documentation/virt/kvm/x86/cpuid.rst          |   4 +
 Documentation/virt/kvm/x86/msr.rst            |  14 +++
 arch/x86/include/asm/kvm_host.h               |   6 +
 arch/x86/include/uapi/asm/kvm_para.h          |   2 +
 arch/x86/kernel/kvm.c                         |  15 +++
 arch/x86/kvm/cpuid.c                          |   4 +-
 arch/x86/kvm/x86.c                            | 112 +++++++++++++++++-
 8 files changed, 156 insertions(+), 6 deletions(-)

-- 
2.50.0.727.gbf7dc18ff4-goog


