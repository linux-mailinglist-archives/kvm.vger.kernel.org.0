Return-Path: <kvm+bounces-54997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F184B2C857
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 17:22:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 926CE189E69C
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 15:21:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EB97285041;
	Tue, 19 Aug 2025 15:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b="oec5CXSL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6DB261B93
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 15:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755616839; cv=none; b=Ca2Y8lYRhd4kf7F2g4p/AhmL6/PPSx/mr1I6bzzw8zlUn/Jz7H/XFi4n1waEbAEl0Vk7oG71FNbuvSytRayOl9/M3Pc9Fbit4eQ1DTCqwDQl5oTk83fK89ED3hSkjadJLFaUQNxldexy9e7c6dB6JFlHyqNNbaKbaL0PDcNBh00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755616839; c=relaxed/simple;
	bh=NrN1uqcJdpnrp2jcDM9mNdL4V79R23IZ3fHrn4EeoLs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WGBPbo7DPAG29ZnJ8vZGac9XJe5m3sVa6jdCDA7jRl2S61gGBXof/ftcj2NnIv4A+XnP++GsaHtQJzB4lqQgM6vOWayYvG+/Xmuw888KnRA25i0YRmEz3Rx+IPdxene9ieletkuxYnQcM3OBB8cxV8ibODsJRVtp9QU1lagUb2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=smartx.com; spf=none smtp.mailfrom=smartx.com; dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b=oec5CXSL; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=smartx.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=smartx.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-32326e20aadso6145086a91.2
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 08:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20230601.gappssmtp.com; s=20230601; t=1755616835; x=1756221635; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IEMm8uKDjjFHpgykUaxgoa+ApFNTkgehyJI7jW32h00=;
        b=oec5CXSLiZpDuztTTa13iJbcB/Zoh9yAUZVRW7DaydXtrgg2qD7hZ80oczvRs5ktFT
         XOd847wmrqGmO+r/qlSCBNo7hqmJvFQvXGL5Q6jstSoPu7DYFm0wU5C7ArRP/9Y/SsP3
         UcDCpFRytSEsW18XwnED0qGTP4S5pmASh2+RQMI7ytqJE8Qt8N3I1n+xECNWv7g89pLz
         RX1Vt4OsC8T2PcVmLx6EfaYGNVvEYmgoCCWcMWtCk9zQyN5tZTKwqrVksdmu8Peb1APt
         Raa9zDkrTnxgifBw77RALoRiJBjPszvWkhJP/NMjpNdfIbwcwIfDEqtOFlCs5wBTpeAc
         rHvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755616835; x=1756221635;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IEMm8uKDjjFHpgykUaxgoa+ApFNTkgehyJI7jW32h00=;
        b=XCacdt7VQqAm0PdMqKgt7xRZhnruZLWFzUzPTxMaCAwO4oakOrUGx1E1egJum+PSmS
         CYruPfKIBZbJkIal1BR9W7NRQ8KBIHeXuccbYY5AZmktRjhAoR3G4LZtqflaTWD7iSan
         9+PsE2wLDiL3siZF0OEbx58/CXMduCTM6gS1qMh7zBBjMw/ztirhiTod952YGZurmvud
         fR0VhbdVrcNAPREaHDLi0qypYZ9EiRT1kuwMxp6kaOZErA+LF5VhuPtM6nPwi8oSHrb/
         dlSIJm9W9MrgQpf0YVyud1TKHr2Dh2NbHh6yC1Ke+fl7CCwebr/iu7bim66josskGM81
         IstQ==
X-Gm-Message-State: AOJu0Yzjb10RfmnHObVGAgaJW0FZahg6+K6IRVhPozUi+WiWMjlLYRkv
	UsHihUtmcrRf8D4Bms6BVnzRLjkxyfdY/ES9NuwLUjq82yd4aead4zuDJ+1oQ0y9Bf8=
X-Gm-Gg: ASbGnctpnIaHBai2C/88r3ePXOwhbL7p6/8yVJLHoMzFGE1Wt4+DXOYhzTXyOMgW0Ei
	HPH7hvsA4E64uAzCF/+IzOJDP7m9+VDJko+hdJPuQqgJeeDfTA8PMhzHf+qCueWsi9/qo24SsMN
	FbJi6mpGY/Uw8Opv0VqciK52rMOR+2Gci4+/lIaYO46aW3SVqEVdhIW+RVNA114UgNi0fRBEpba
	8/FJBQ6nbNbAGbEBfWRhu6zPmFCl7QeUmyCGukZf2kINgCKCNbtHTG21Si78ZRe1uDLv1jSLexN
	9+x2CuiHPCrS6plNgoOJN8klb+qp84WsbqEpLG9/ZFyGTFfFZMJT8Ts1vCtBIczWjtvkx9Qoo9H
	LzBKdzYHdpdRe5HsePMMj/yhCq65x9DtguC4xAUsl92vgw94O
X-Google-Smtp-Source: AGHT+IGykYJRPbFbofmtPcUluhHPVwhSmJLbKeQ3EY9zb5I1jlXalnsi2pHhddtB8yOO4hX9AXZOnQ==
X-Received: by 2002:a17:90b:3cc5:b0:31f:762c:bc40 with SMTP id 98e67ed59e1d1-3245e59151fmr5112184a91.16.1755616834733;
        Tue, 19 Aug 2025 08:20:34 -0700 (PDT)
Received: from localhost.localdomain ([193.246.161.124])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76e7d546ce3sm2771227b3a.103.2025.08.19.08.20.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Aug 2025 08:20:34 -0700 (PDT)
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
Subject: [PATCH v1 0/3] kvm:x86: simplify kvmclock update logic
Date: Tue, 19 Aug 2025 23:20:24 +0800
Message-ID: <20250819152027.1687487-1-lei.chen@smartx.com>
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


