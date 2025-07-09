Return-Path: <kvm+bounces-51881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FCB0AFE0CD
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 09:05:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1FF5D1AA2AA8
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 07:05:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA39526E6EA;
	Wed,  9 Jul 2025 07:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fOy/yLxe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748B626CE21
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 07:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752044698; cv=none; b=RxgcQBnj9oo8bI0DNFqfOQUZhq+Pku5GROtONF+ols0VEkXGLUtdBwDtrOKYVHd6pgFEpEvW/MhsY/Nm4aY4byH/VpOk3JWQSoZXY639TV+jru70rRCZuJ8wbwIjFWAk1cvRtDvR1cTH88n79lYnYEEbLY6Qh1ID3ipNrqkLW8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752044698; c=relaxed/simple;
	bh=HQE/ReeVyazvpH4LrBHiy8IMnxQNSg2ydx4fd5xrWGw=;
	h=Date:Message-Id:Mime-Version:Subject:From:To:Cc:Content-Type; b=Z4lsOcHygXNTXFh+qjukLCHeHtKo4ozf3agCWj4H/1N6qhcmMI/+dR/invkbZOngBr2AVfK+ERdAU6ZmR6aKL3MiWx7E3JjwWkFKHmQEiSnhkR0PBUcqZtKOgJ6T+0ySAqz+5NNSLJ2/sAhBEWNKLp4UhBlF512r82Cx+p/Dtqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fOy/yLxe; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e81b2af4f92so1050342276.1
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 00:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752044695; x=1752649495; darn=vger.kernel.org;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qU47TFvcnC6XmmQdhr6RzfJRAjN1DEPce8n7XkqyXcU=;
        b=fOy/yLxeqwoU26qFO5UjRd47r5dRLmyETZLCizGdEnsGT/nHhFDzGNabWbXZNPf0bQ
         YX/fnPmpk6bHDZNzX0FmDRw0xtp17HyvJce7F6pkaUjTGv4bpj7s+gPM1f/7yBpc/S2/
         JFQQkjdAOe8CThpUxqhPPczS+2Lg17+LQsljITjND2u8ZW7/6rMAqmivQDfTfAh5aQ02
         YRxL1Jrir8hVs53ZT502QL9NK3Xufx5p+Luivm7eBIF3ygB1I5WZD3rpL7dW7BSys+8B
         yv/iacVMeUcfWDzX8ZZ80nHevVajRJsFuirU6PTSvT94Q+xcqqS68nMPMSM72lh8v5HK
         TC4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752044695; x=1752649495;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qU47TFvcnC6XmmQdhr6RzfJRAjN1DEPce8n7XkqyXcU=;
        b=rNthmUsD0bgzZndLsYGZmHuivRylKjrSj5oBphHN+jomgAYL4mh4nijI03htQ41M9V
         HWuTHjt4+GFY/YF78w+5zfvhIkgfAzuIqrZA9mfXS28kssvvyiaGqKRTAAzCBLvUJPr4
         AKB0D74mFiZ1mfAED/Kgj9a1OawoNSJKt7IcEWmm8NCeu/kr3QeJlmVUhmmbKJuVrXpo
         zQhfMVIw0alu2SetIkM506nxTDfcgjv1GeVYc8NzbpHx1He/VCIqFSvY3k+semSPsE5V
         QYv+6DfeZdObbiCD3kF8eKlqxn/ff1vzE+JtdgaLf0u+zpEi1khHVDLh+AztXP+LZvNT
         Gftw==
X-Forwarded-Encrypted: i=1; AJvYcCXR2dPebfBeimsVj1oQrHuca4c+KQZCP924jkFKJbHwTst9S6nN9ipeAy+AepEfc1++etc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtirgsPUOHF6+uO/YrQSZzUT85bBe0jTfCtDbrmY/wkNP+xuON
	MSow3+2uj0dOFyN0NjCvDDF1cpHWTYp1gzhvHHtzVnJQMI5IJ9WTCEAg8g2vh01wkGqh0W44exp
	Z3V+ix5ggevWp+w==
X-Google-Smtp-Source: AGHT+IG4MF1b0UhYNvoPcg3YGZ372MuwkqCpX7pOrOVrYzNo/IMRhknvGRb0k0FharKF+y8Ie0BQS790QHc/vQ==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:a92c:694f:82fe:62a])
 (user=suleiman job=sendgmr) by 2002:a05:6902:458a:b0:e86:3ad2:43c with SMTP
 id 3f1490d57ef6-e8b6f4fef3fmr765276.5.1752044695263; Wed, 09 Jul 2025
 00:04:55 -0700 (PDT)
Date: Wed,  9 Jul 2025 16:04:47 +0900
Message-Id: <20250709070450.473297-1-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Subject: [PATCH v6 0/3] KVM: x86: Include host suspended time in steal time
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

v6:
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
 Documentation/virt/kvm/x86/msr.rst            |  15 +++
 arch/x86/include/asm/kvm_host.h               |   4 +
 arch/x86/include/uapi/asm/kvm_para.h          |   2 +
 arch/x86/kernel/kvm.c                         |  15 +++
 arch/x86/kvm/cpuid.c                          |   4 +-
 arch/x86/kvm/x86.c                            | 108 +++++++++++++++++-
 8 files changed, 150 insertions(+), 7 deletions(-)

-- 
2.50.0.727.gbf7dc18ff4-goog


