Return-Path: <kvm+bounces-38831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B6DBA3EC45
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 06:43:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F831421DF9
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 05:43:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13CEE1FBEA4;
	Fri, 21 Feb 2025 05:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U0n9GcLa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D8D4207F
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 05:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740116621; cv=none; b=HZLUCmtWMpLN+SlPPTN6Q7Jb8ows9NK2f1OK2k5fmt1CuQWPbkGy7LwsGR6iFoBvGBeN8KqcEHRvg3Zi0K+ikQTMGz8yoGK6yHwklWSOFzypKDylu4ID5d4jm/VGhyDB8alsKGDD+kaBtcveQzNpNQ2+iDefRmVUmAJKrpW3inI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740116621; c=relaxed/simple;
	bh=yGRsKQbAUF8yX6yPNg1x0BnaoKv1g2xJ0ViVAAluE/I=;
	h=Date:Message-Id:Mime-Version:Subject:From:To:Cc:Content-Type; b=Otd222VEVUC8Mp+NW2Y61uuDCtXP2MqqX8cVLiCQWNvj1za2oeOjOzhh3LQtPkB93e6gICfOMCjln6ryc+ePY9yj+oZI4eA1AX0jVPr2e/YmsT6nBVTI4KV4mFH2EYbzXr/P8EoRrlFtGyirTAJQupDXVXXQnh79z39dUNPa220=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U0n9GcLa; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e3a1bc0c875so2129775276.2
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 21:43:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740116619; x=1740721419; darn=vger.kernel.org;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=s9Uv+a28OGAxYy+jIkS9p7JciuptkwlOHtkNxL0+CyU=;
        b=U0n9GcLae8ONmtEJuhsEUXpok77kWyR52K+nZZbpwIU1VDtwItlJjAB+HxjUP6ZKS5
         NdoS41Zb1L+B/u1Fu1J40vDenKtJhySzt1B0VduA2vltftQafPQ/dbhsMEsvIb5Q9fWw
         NiJMJRdaMvr7rkbuqiEXEl//1rrkxoOROjUEL4lMV7cHXsvy3Bc51pKaNjqESNRZ7gbD
         5qeRVXYs6RJ2oVQTn4jKndK5LZLJh6nBd2h+VV6QRdMKVd+WRNgzbkLnqA4HeWg7plDx
         dgfqq1zSXAdkaKBTzHRHEbpfk+sWN2zmDOhiAbRygDNazXtBhnwyXmvz/Rj5UdKMX7nF
         0iCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740116619; x=1740721419;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s9Uv+a28OGAxYy+jIkS9p7JciuptkwlOHtkNxL0+CyU=;
        b=MyqZh8KwVOtevu0PiofdY1KcQ9Yw3c56wnCLdrz8mLhIuw0QdLYcp+reKY9F1XkYPy
         6MW2XR8Bl4fht3oq0CVbJes46gek01rbpoqdTTDfZElT2FVYnzgxQSIwI+Do2T0cXcZj
         154nc8fCdm6wwgLo6s0XRpS/VMuvD47jb0VblfMloz1QeUQDf81V8jAbJVCurrIX+1O6
         EGG6mYnWTxZTzXgzBQ+3sevUhiSDFUaAQZBC50BHIgXriknQXwNiWZW0iee+XQ7grw+m
         zTAsU26sr78sECXWQrPnKO/KkuQpzlBa+m1gRdKw7ZpP1+anofHO/qdmd82N54mYFW2S
         ye5w==
X-Forwarded-Encrypted: i=1; AJvYcCWaoBpKfGDMHdane57JTnG/ARCdgMPtHuyHePe0FPYHOgLz7ALsKmLy3KAHV22Ny9ms4wA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yza2Q9oAZ/HaBAxCibDemXbpFf/9y3lYZ4AUnRTZ1WgqtBHzQwD
	7kyTwjvuh/FCzUDUJm2FG2pGRhaaJYKXXWBk+MQ1CH5p/uTtd1Yl5sYThTf20TJps2U/yKDxBEI
	RsPk1vYgpJw==
X-Google-Smtp-Source: AGHT+IH4jso55cJhGbebGnuGmz3X5bTEqwPxcrgzCSj9Dcx5pOhp/DK4jr2l+1mNhLMw21o+4ggWGoXjiPG3PA==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:62aa:45ca:6f53:8c2a])
 (user=suleiman job=sendgmr) by 2002:a25:8184:0:b0:e5b:13ec:b38b with SMTP id
 3f1490d57ef6-e5e8b073744mr9935276.6.1740116618579; Thu, 20 Feb 2025 21:43:38
 -0800 (PST)
Date: Fri, 21 Feb 2025 14:39:25 +0900
Message-Id: <20250221053927.486476-1-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Subject: [PATCH v4 0/2]  KVM: x86: Include host suspended time in steal time
From: Suleiman Souhlal <suleiman@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	David Woodhouse <dwmw2@infradead.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ssouhlal@freebsd.org, 
	Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset="UTF-8"

This series makes it so that the time that the host is suspended is
included in guests' steal time.

When the host resumes from a suspend, the guest thinks any task
that was running during the suspend ran for a long time, even though
the effective run time was much shorter, which can end up having
negative effects with scheduling.

To mitigate this issue, we include the time that the host was
suspended in steal time, which lets the guest can subtract the
duration from the tasks' runtime.

In addition, we make the guest TSC behavior consistent whether the
host TSC went backwards or not.

v4:
- Advance guest TSC on suspends where host TSC goes backwards.
- Block vCPUs from running until resume notifier.
- Move suspend duration accounting out of machine-independent kvm to
  x86.
- Merge code and documentation patches.
- Reworded documentation.

v3: https://lore.kernel.org/kvm/Z5AB-6bLRNLle27G@google.com/T/
- Use PM notifier instead of syscore ops (kvm_suspend()/kvm_resume()),
  because the latter doesn't get called on shallow suspend.
- Don't call function under UACCESS.
- Whitespace.

v2: https://lore.kernel.org/lkml/20241118043745.1857272-1-suleiman@google.com/
- Accumulate suspend time at machine-independent kvm layer and track per-VCPU
  instead of per-VM.
- Document changes.

v1: https://lore.kernel.org/kvm/20240710074410.770409-1-suleiman@google.com/


Suleiman Souhlal (2):
  KVM: x86: Advance guest TSC after deep suspend.
  KVM: x86: Include host suspended time in steal time

 Documentation/virt/kvm/x86/msr.rst |  9 +++-
 arch/x86/include/asm/kvm_host.h    |  7 +++
 arch/x86/kvm/x86.c                 | 84 +++++++++++++++++++++++++++++-
 3 files changed, 97 insertions(+), 3 deletions(-)

-- 
2.48.1.601.g30ceb7b040-goog


