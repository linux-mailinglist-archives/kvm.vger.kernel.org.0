Return-Path: <kvm+bounces-57831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 383B5B7C3EE
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 13:56:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E818463E9C
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 09:29:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A644F30C63A;
	Wed, 17 Sep 2025 09:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b="qqO+9jS1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66187309F0C
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 09:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758101316; cv=none; b=U7UlZQayiWqMom5gh7n6St3CYKoicM9NFmEKXez/byHmXbsGfywscu1v6nhPsj+qYu24gTy1sLdEPfMsGVZ4931RzmFSI6LiHKFsVomMnEhAEZ1LKmPqOtjLbzrQo2I9DKPSc2E0mm6nrtq+aDi9IYSExhwA2USRaM5oTzVP+4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758101316; c=relaxed/simple;
	bh=S0Oe46tsoZZQQ29GDYRq7t5r8AFIzm0CHvummlNxQQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y64eM5VzK7d43J0KEQlyK2WT+Z/owodvjD4zSARruf28TrdZLcmnhWn46md26j904Txuhj9xOEO++FGoo4qfKXXp6o/0wbJrOSjBlz1gqkLkDOKrssRna4nmtuYhqmEafhxy+i7iD7RjqoDAQ/wmBW9D8z9k/PuW8C3PYADwl2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=smartx.com; spf=pass smtp.mailfrom=smartx.com; dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b=qqO+9jS1; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=smartx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smartx.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-24cde6c65d1so56387185ad.3
        for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 02:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20230601.gappssmtp.com; s=20230601; t=1758101313; x=1758706113; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qEv+391m/JkY9kaqE3gl8eXIZOO7uG0r/XVqxW+72wE=;
        b=qqO+9jS18WyS5DjTAqTeCYlTmetT+jIq9JQ1M2munm6Wzg7o9cYhZ4g5OJ+ZmL4To0
         U7SlOQ+/+E5QIwLEcT9I84OHXy8zz65ZgkJuSRvjlhKxqNOS38rBEnipFg43UYWzv9+1
         C+G1Z1HqzlcBmDUdMTc1+ysRbnsgT3QYpBowtOxCLti2cFq0OYcrTpGDm5kOCRPm5vvb
         nftMn1iOgfJiJTDuk29ln863U+UXJQHPZmXCPQNjasBEfWQQJJ/Ybrt+QfjeDqSSH225
         v9gf6nVazi4ZMBUYN0wahZNTjbyElIklHAqDH7oj10pWg00toZGldjhey/lZ8qwCMEth
         Tbng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758101313; x=1758706113;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qEv+391m/JkY9kaqE3gl8eXIZOO7uG0r/XVqxW+72wE=;
        b=I1Z8meOtlSvv5nIkY/zvZ2OdZWOpoFvKXVd5u7e2Sb4e7m+b8du4gN/WqOE84pwhb6
         Hfl7zWXGvR0YdQVG118cAeP7g/iVD/yj4s8ua61K+JmG8Y9/nI6FTqMxvilXYAwU6QeI
         IMl6u0VkPEAkkWqX4U7hBO3YQhRAhBa1YzVxtdQWKxbqEY0R2wLKU5gDbgI4YOyeigvb
         HhWWHQAbLFjTJe3jzfrm7rwrBiCkMLYkeFjvSgGeILz1AhlDCAXVXhSHIzwYb5zwaHft
         ZAVHn707TjKLlDgtGvpBRaVJ06Pwr68AMP6nW2BlnyaGeQYT3UBhjbqJGmZGLgfXHcFd
         glWA==
X-Gm-Message-State: AOJu0YwxHqLhotX4C6cw8jGo5KhrBo1s6RJXaIvwQPxe8eP9yn1BnIRz
	we14H7gGUqZk5ZgDPiMpPhIypOBzU7ON5EN9RnXNTQnIXSY32h+/woHK83I2UAP+foA=
X-Gm-Gg: ASbGnct6ZwcgIV9NApcJM7EiRq+3PqcRbs9tD3EeLv9+QxNdlYV5EmLj4TUowS1r9wy
	fyg7ZCGaHz8L+RdeGo2xxq/mLUrMz9ccjf4CUrpnw4MiqteCTy0faLsQ5v3MlPgp5ITO078KRUm
	jrEJUscyHw9RhNU/7kFXoqzMwE5hy7Yl9HElaB1tn0erNR/x4oIIL7n887RSoLePir8YVqe/zoL
	sooO/gN26nhfClfDkOKlgfo300o4BYpADG0ghKo9wDFwMOLb1IItoyY9g6HwONEWLtQ2QSjG9GA
	XoqwoMyTMqjBi3pg7+i9lD6FCn5NGlebeJL8c5UbGERukOTq6kMvu1uEzN/yZkRMR4tkdTu7D/E
	WTV5n2ZL39U910IlvngHhQkdCbQDCkREjeZsRG65i8BztL2Xcp6I=
X-Google-Smtp-Source: AGHT+IHhbsgB2Q3Kh5WyQVZOJDD1xHNwQPX/mtP3TCwpKgY/yR9ATV1q0YKkCnNjtrFK1Y6/JhyJeA==
X-Received: by 2002:a17:903:2f87:b0:262:4878:9dff with SMTP id d9443c01a7336-268118a5cb9mr19386995ad.12.1758101312823;
        Wed, 17 Sep 2025 02:28:32 -0700 (PDT)
Received: from localhost.localdomain ([193.246.161.124])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25f4935db09sm137047885ad.61.2025.09.17.02.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Sep 2025 02:28:32 -0700 (PDT)
From: Lei Chen <lei.chen@smartx.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND v1 0/3] kvm:x86: simplify kvmclock update logic
Date: Wed, 17 Sep 2025 17:28:21 +0800
Message-ID: <20250917092824.4070217-1-lei.chen@smartx.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit


This patch series simplifies kvmclock updating logic by reverting
related commits.

Now we have three requests about time updating:

1. KVM_REQ_CLOCK_UPDATE:
The function kvm_guest_time_update gathers info from  master clock
or host.rdtsc() and update vcpu->arch.hvclock, and then kvmclock or hyperv
reference counter.

2. KVM_REQ_MASTERCLOCK_UPDATE: 
The function kvm_update_masterclock updates kvm->arch from
pvclock_gtod_data(a global var updated by timekeeping subsystem), and
then make KVM_REQ_CLOCK_UPDATE request for each vcpu.

3. KVM_REQ_GLOBAL_CLOCK_UPDATE:
The function kvm_gen_kvmclock_update makes KVM_REQ_CLOCK_UPDATE
request for each vcpu.

In the early implementation, functions mentioned above were
synchronous. But things got complicated since the following commits.

1. Commit 7e44e4495a39 ("x86: kvm: rate-limit global clock updates")
intends to use kvmclock_update_work to sync ntp corretion
across all vcpus kvmclock, which is based on commit 0061d53daf26f
("KVM: x86: limit difference between kvmclock updates")


2. Commit 332967a3eac0 ("x86: kvm: introduce periodic global clock
updates") introduced a 300s-interval work to periodically sync
ntp corrections across all vcpus.

I think those commits could be reverted because:
1. Since commit 53fafdbb8b21 ("KVM: x86: switch KVMCLOCK base to
monotonic raw clock"), kvmclock switched to mono raw clock,
Those two commits could be reverted.

2. the periodic work introduced from commit 332967a3eac0 ("x86:
kvm: introduce periodic global clock updates") always does 
nothing for normal scenarios. If some exceptions happen,
the corresponding logic makes right CLOCK_UPDATE request for right vcpus.
The following shows what exceptions might happen and how they are
handled.
(1). cpu_tsc_khz changed
   __kvmclock_cpufreq_notifier makes KVM_REQ_CLOCK_UPDATE request
(2). use/unuse master clock 
   kvm_track_tsc_matching makes KVM_REQ_MASTERCLOCK_UPDATE, which means
   KVM_REQ_CLOCK_UPDATE for each vcpu.
(3). guest writes MSR_IA32_TSC
   kvm_synchronize_tsc will handle it and finally call
   kvm_track_tsc_matching to make everything well.
(4). enable/disable tsc_catchup
   kvm_arch_vcpu_load and bottom half of vcpu_enter_guest makes
   KVM_REQ_CLOCK_UPDATE request

Really happy for your comments, thanks.

Related links:
https://lkml.indiana.edu/hypermail/linux/kernel/2310.0/04217.html
https://patchew.org/linux/20240522001817.619072-1-dwmw2@infradead.org/20240522001817.619072-20-dwmw2@infradead.org/


Lei Chen (3):
  Revert "x86: kvm: introduce periodic global clock updates"
  Revert "x86: kvm: rate-limit global clock updates"
  KVM: x86: remove comment about ntp correction sync for

 arch/x86/include/asm/kvm_host.h |  2 --
 arch/x86/kvm/x86.c              | 58 +++------------------------------
 2 files changed, 5 insertions(+), 55 deletions(-)

-- 
2.44.0


