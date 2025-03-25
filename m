Return-Path: <kvm+bounces-41887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BB6CFA6E8CE
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 05:14:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 49F5017202E
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 04:14:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81F3C1A5B86;
	Tue, 25 Mar 2025 04:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bTSvGoW2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A7353365
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 04:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742876041; cv=none; b=j8Qn//2N5KIyFatJSwCLEtcG/q++3iKjChR3kM5HoUucgvaGV82tP3vysrfgS5G2tvMHGjSpwtuyiy4WD6vBZYCVdq1l8kGn5JRYclIS72peuQNz5UsTnZ4hYBAgR4BVbLUfhnjfe9lZnCU2aToKiPmoGE8AQKjmIt9zIPPJys4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742876041; c=relaxed/simple;
	bh=3TAwYkMl/7Jrwu+foCwYFjf4/ZKYpnei3D4Wl9VvD1A=;
	h=Date:Message-Id:Mime-Version:Subject:From:To:Cc:Content-Type; b=Y+kaelzWfQmFtT/LsotD/BC5DttBtzJgOUERy7WcEVQDa2I0OlJjqsdSnsyA6Q2yTryFrQZCuUlgNMYjHVBsN7udG9B+bYpnHz/xS5l1TaOKkC+qekwPh+Xdrobdyfrpe88U5KMp4menm0hL0n1zgB8fTvMW5rokm4lSzUC3DXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bTSvGoW2; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e582bfcada6so8139386276.1
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 21:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742876039; x=1743480839; darn=vger.kernel.org;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EJASGRGmrPcwpU7CqSRwJwZcThKb/XyXZK/AkLrGpAk=;
        b=bTSvGoW2tcKUFol305j8zVwTqtJBPxwgMsiZ1O9M3/gj/0eG+pJ0eO+42EJNTIYkDj
         VJUdpk8zyIWkT9RXKickVnaRPogW0bHMT6kuyjKOa6Nd3LXWWD3Rz3v9eJDMTMITsNCB
         nuIQlff3Lf3EXwwkvBJL44aqlfeyEFy8qZDlWq87szTkkJdDhgBDZo6rjHPsyGnS562m
         YK6/2xsux1BRWqmzWEtPFp01TVd9vi3kuQz5y01XZRl7i6OsuQFLsRkuetx3TUzzc+h5
         1diN6d4W5ltYMNSbquVfC1ASBrDSEwda2vGn+ZdP5kGO9tYOtWwjc+C110ZlIWwyz53j
         D3Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742876039; x=1743480839;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EJASGRGmrPcwpU7CqSRwJwZcThKb/XyXZK/AkLrGpAk=;
        b=wwlEvkQsQRvgWAb0u/+eNmRZdyG7FLzeGtDVKOdMAGsR6C3zKw3JVKpyo6Miag/owp
         RjkzJAMd1vHAQBeXRBHgNwcfFLTXqfEu6U86Zzqu+W1UEw8ImE4NMjLE52YCD/hjjabZ
         ee474+jvdQ46hmjuQCOLhUoKRjUK/GIWrcLNnSQRNDjn7HSxLMFB+htHCUgYehBk4+ut
         GS46lSRx+8Gayx2UwRnpSv+yhWdGrWGACfDJTWCygn0Mt3C0A00eO1iWOQWb3v/2d+Kv
         /vzyCgncYD0z4i62bSrRLpqJrnRHsocLkJcrV6zrrxQiHpbe6vgO4j4TpkIiQ3ih5J8d
         8kkA==
X-Forwarded-Encrypted: i=1; AJvYcCU90xql0UAFSE3fq6zzMyUCDLFecuTPbAC6rSo6g+/dzFoTyfJFdYZ9lUzGHga6g2Aj64Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjH/TqCGLg49D/lHNS+Xlih6mrMB8IHaJRLvVGzy1vGWCQ7tV+
	cOsKtHX9lEgB56Mu/GLc96y/c3Kr9oYbU64u552OI4+cDtf+KMnPdh0b52CvcNaJC72WC0ivz3z
	W23Fsj9U7lA==
X-Google-Smtp-Source: AGHT+IFRXyADSH1VG1iqof3ddCopTGj+wUY0S7x/42w9GR77Lq+bRsylsnD/Z9GFSuEUsXLsmUb1Qkhap5kX8Q==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:858a:76d0:aa73:eec8])
 (user=suleiman job=sendgmr) by 2002:a25:b582:0:b0:e63:65c4:798a with SMTP id
 3f1490d57ef6-e66a4fd11a3mr11205276.7.1742876038884; Mon, 24 Mar 2025 21:13:58
 -0700 (PDT)
Date: Tue, 25 Mar 2025 13:13:48 +0900
Message-Id: <20250325041350.1728373-1-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.395.g12beb8f557-goog
Subject: [PATCH v5 0/2] KVM: x86: Include host suspended time in steal time
From: Suleiman Souhlal <suleiman@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	David Woodhouse <dwmw2@infradead.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ssouhlal@freebsd.org, Suleiman Souhlal <suleiman@google.com>
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

v5:
- Fix grammar mistakes in commit message.

v4: https://lore.kernel.org/kvm/20250221053927.486476-1-suleiman@google.com/T/
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

 Documentation/virt/kvm/x86/msr.rst | 10 +++-
 arch/x86/include/asm/kvm_host.h    |  7 +++
 arch/x86/kvm/x86.c                 | 84 +++++++++++++++++++++++++++++-
 3 files changed, 98 insertions(+), 3 deletions(-)

-- 
2.49.0.395.g12beb8f557-goog


