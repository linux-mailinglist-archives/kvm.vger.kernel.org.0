Return-Path: <kvm+bounces-66303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 30794CCE67D
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 04:59:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F14FF307A58D
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 03:55:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6224A2D5925;
	Fri, 19 Dec 2025 03:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G91n7riW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com [209.85.210.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D59C2D47F4
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 03:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766116456; cv=none; b=Ypcp6HsraFPHxx2YAjs/JgSBH5nHGP+JDJJCW1/dpfN4w2IgXc+0w1Iwpm5l3pgLCIV+KK8pmLO73mqb6iB8p1uxoLDJB5JbZW0sGnP5UAsq9tlXzhLDiLRLGaPm5Eb5FpKa9u6fjkoukm9bZhrv4hipZ96lUxtVFonzHBfQKGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766116456; c=relaxed/simple;
	bh=5W48IL3bdW1PhdyVuywXEKn2tfcpwop424aGol93d3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MrZ7JIyBH51YUMpjnvHN/CKXAhMVmdmOhGR3zS0UJNORsGzptIG9SDJ1CcxFmGdPTO0ZvbpG+gSA0HhL/5f1L+mgLBFJKXxxWknfkAb9WAK8wpopQINVYBaBf5uphbmphtirIVausF8GDXR8D8KM5PLAZLNQvrBF6pK2X3WPjCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G91n7riW; arc=none smtp.client-ip=209.85.210.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f193.google.com with SMTP id d2e1a72fcca58-7fbbb84f034so1155705b3a.0
        for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 19:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766116454; x=1766721254; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xHHylnVK4XkJx4ZGgOulzOiaDq14MqhIJ3X9iv/iIfM=;
        b=G91n7riWyNG1KnGQ6kaD2ozT8uIpBqxgB12Ho4gLs6pOfw3bIcst1lSQTyIfOkrQdz
         eUnnjMNDf9WecySbVmVWnrd9brDbJwgmJyRt5xND+HbJLGoiTzAFns0+5k4b16LCycun
         SooVA/gMeTmfpf107NuqLrntSrz6mLaPz3ZHna91Ed/VnM97OPVY3q6jPLyrldbEuecK
         Qr7tabDESc/mamAutdfDuR3f1bsHiQTnlwT3RTkFzjrc547FpD85g5ZCYWOOWR710zCp
         YczIsFgWdOWerSbhnntRJhFvN5DrLD3u6nbcexTsm2sw+Uf63vR5/2QXHz+O9f+dFvt+
         9onw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766116454; x=1766721254;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xHHylnVK4XkJx4ZGgOulzOiaDq14MqhIJ3X9iv/iIfM=;
        b=alMnm1Td5OsQWM1zUCyHLzvWHUZETLUSmIGQD5w78vZiVeAgfI0xGKa9XVIHfiXlML
         B7lyrD6+cIB7I7iyvDwzXNl6ZgE63ovS40IqxbRTcEVwBz6ABlF1TtzKtOe3YEIotcK+
         D0zlmTsr3je3mUZDCYKVxvUoK+yd5hdWXwsYXE1bdKWbzjtq5D8n418Deyk5ryyP6vjk
         TEyiEyONyC9gRJw7CfoUdcxqf+ZHpHDUL3R0MdHSRM+Gr2jb+hGNQ81aYuRLGkMcQU72
         lRsuXaalJyl5j0SKUE5ED9ykLQfkUvObGalxKJOsuLioZ+JiBzphie3kIoct4vBVmnGN
         /Ssw==
X-Forwarded-Encrypted: i=1; AJvYcCU3+henedtZQGWiOkJODyAZZGXZIO15r/Oz0aR2GKWJ+gV94O/ssF4NVPxNnYtD7aDqx+U=@vger.kernel.org
X-Gm-Message-State: AOJu0YxaEarwxEDE1TrLB1HsSikv0ky/P9MF/ikQHrTMgqMh88Ha/3Cl
	E+HvCdpsbjscWC7kf5Bh/Sbv4PjjiT2PFmiw3+Wl1sdgJ8YiRO+aHvwl
X-Gm-Gg: AY/fxX5h7Ord1xe5uuqEYhkkyY4Ahwkofa7gErt83kzS/RMkeL/eKSdHzeDAulyY3lv
	Ie/yNAjSksDf3BleXHfAps4a8VJCBdG7/SjvuT2OM6GhZvnILIYLqKuZsfg/PZYhO3FVnMHVBRM
	AGJ7LmcW4dN8rZsKhm9JuxDb/KXAK/2Dbe7eHAKy0Lda/UDjTDSu3VcEBluuyt4rhJNOtqNJvJ8
	YIqaKNfGGLEDPYbtLaUnNSfmZx1dkIuIsMYZgvezCMX/haubuLQ7uoRtOc9CYXXNZHLRxv8tjVf
	mqyEBhEBHD0qRHueZam8gxvzWYXr1uAxQF3hBjQ8LFmDmcuZPtRy9484UHnUt/7NY67Ze2Efee7
	IfMvDN745+D41DAqO1MtF/zY66UIajAndINpjuJEfP1gR1GvT8RVe5AcmL9Hj0Pp+bRlywwP/Z5
	/gPdCdKNUIDg==
X-Google-Smtp-Source: AGHT+IF0bhXQdMZ92vZEQxR6Fache4q5+RNfQoshWlrbjpqkOwVElhYo3bzP5BK/41CJOmVAmF81SQ==
X-Received: by 2002:a05:6a20:2583:b0:34e:4352:6c65 with SMTP id adf61e73a8af0-376a9acee63mr1654219637.38.1766116453636;
        Thu, 18 Dec 2025 19:54:13 -0800 (PST)
Received: from wanpengli.. ([175.170.92.22])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2a2f3d4d36esm7368135ad.63.2025.12.18.19.54.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 19:54:13 -0800 (PST)
From: Wanpeng Li <kernellwp@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH v2 9/9] KVM: Relaxed boost as safety net
Date: Fri, 19 Dec 2025 11:53:33 +0800
Message-ID: <20251219035334.39790-10-kernellwp@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251219035334.39790-1-kernellwp@gmail.com>
References: <20251219035334.39790-1-kernellwp@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wanpeng Li <wanpengli@tencent.com>

Add a minimal two-round fallback mechanism in kvm_vcpu_on_spin() to
avoid pathological stalls when the first round finds no eligible
target.

Round 1 applies strict IPI-aware candidate selection (existing
behavior). Round 2 provides a relaxed scan gated only by preempted
state as a safety net, addressing cases where IPI context is missed or
the runnable set is transient.

The second round is controlled by module parameter enable_relaxed_boost
(bool, 0644, default on) to allow easy disablement by distributions if
needed.

Introduce the enable_relaxed_boost parameter, add a first_round flag,
retry label, and reset of yielded counter. Gate the IPI-aware check in
round 1 and use preempted-only gating in round 2. Keep churn minimal
by reusing the same scan logic while preserving all existing
heuristics, tracing, and bookkeeping.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 virt/kvm/kvm_main.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 45ede950314b..662a907a79e1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -102,6 +102,9 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(halt_poll_ns_shrink);
 static bool allow_unsafe_mappings;
 module_param(allow_unsafe_mappings, bool, 0444);
 
+static bool enable_relaxed_boost = true;
+module_param(enable_relaxed_boost, bool, 0644);
+
 /*
  * Ordering of locks:
  *
@@ -4011,6 +4014,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 	struct kvm *kvm = me->kvm;
 	struct kvm_vcpu *vcpu;
 	int try = 3;
+	bool first_round = true;
 
 	nr_vcpus = atomic_read(&kvm->online_vcpus);
 	if (nr_vcpus < 2)
@@ -4021,6 +4025,9 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 
 	kvm_vcpu_set_in_spin_loop(me, true);
 
+retry:
+	yielded = 0;
+
 	/*
 	 * The current vCPU ("me") is spinning in kernel mode, i.e. is likely
 	 * waiting for a resource to become available.  Attempt to yield to a
@@ -4052,8 +4059,13 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 		if (kvm_vcpu_is_blocking(vcpu) && !vcpu_dy_runnable(vcpu))
 			continue;
 
-		/* IPI-aware candidate selection */
-		if (!kvm_vcpu_is_good_yield_candidate(me, vcpu, yield_to_kernel_mode))
+		/* IPI-aware candidate selection in first round */
+		if (first_round &&
+		    !kvm_vcpu_is_good_yield_candidate(me, vcpu, yield_to_kernel_mode))
+			continue;
+
+		/* Minimal preempted gate for second round */
+		if (!first_round && !READ_ONCE(vcpu->preempted))
 			continue;
 
 		if (!kvm_vcpu_eligible_for_directed_yield(vcpu))
@@ -4067,6 +4079,16 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 			break;
 		}
 	}
+
+	/*
+	 * Second round: relaxed boost as safety net, with preempted gate.
+	 * Only execute when enabled and when the first round yielded nothing.
+	 */
+	if (enable_relaxed_boost && first_round && yielded <= 0) {
+		first_round = false;
+		goto retry;
+	}
+
 	kvm_vcpu_set_in_spin_loop(me, false);
 
 	/* Ensure vcpu is not eligible during next spinloop */
-- 
2.43.0


