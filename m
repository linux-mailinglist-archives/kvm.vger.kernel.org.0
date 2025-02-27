Return-Path: <kvm+bounces-39518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66887A472CC
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 03:31:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42D5B166988
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:29:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31749236443;
	Thu, 27 Feb 2025 02:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UEbgBKOh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C6E235346
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 02:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740622797; cv=none; b=L3QO54Gmqca+sKMUuOLKfPeKqUQv69gBnFb/CFSmR5j0rXZzctIHN/5Ip8xolTenEzDV/RSOg7v6mTAhs4KP8Lscu+9iEJr7Ssdk6MmE20Qc400l95+TIWCupzj1ajgAZUZAGyv/U2Pb0ZLauaoFMkr3Sy7BIQgLcGB5s846IEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740622797; c=relaxed/simple;
	bh=9PNQlaFr17QsW09OA3IEH/cFSTquMC7pYNcyhSay2n0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HYscxsRHDWYLP+zB4FwmDdfA7YTE6k0/Cg+dwPXyKse4Efzkm6YGFgXL7CvHdruGUaeGKwF0vm/OyT16hTDYVfQ3o5DIn90Ms0P/kz2lihRA9Ej83Kifn46OOocu2uu2hmfyWgezD3dIJV7whxE6xMKHWiftsQNEIykhpKDnG70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UEbgBKOh; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fe86c01f5cso1042410a91.1
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740622795; x=1741227595; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=3F6YIZD9bSIlkGuU2KG3Ao1xkSJhhKmqbmLiePXFSIM=;
        b=UEbgBKOhDxMYxMoDIIGBV5uWU/Tnmn8nsHyXriJImPHhu0J0q/06xJVRquOlcg1V5K
         jL538nlnF5PiO95x4DhiJAIz63+eT/PmtCiiQ1OCc0h5rXnN0XLrOdrTUtbA/OILqljq
         RURh6o/gjgofzE1fD0MgXZyG1aH7sr+ak88LGum+GhqLSKNGv62kStd+75zMIYXX7OV3
         zhuPjdcwkYo9af3YLGjTgCEzColLONbqBDyHtBH98Kvrw6hNbu2M3Of2BEejO3D3Q6jV
         hU9NA3sLP3vXNJAStUWDxeNP5n/nyiWGVMaokES++xGuNfu6DmX4kagAdtwhrAF+Icq+
         ZNgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740622795; x=1741227595;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3F6YIZD9bSIlkGuU2KG3Ao1xkSJhhKmqbmLiePXFSIM=;
        b=w7KXPDbyhRHX8sSu6vzrzX2Q/PGNx8ujICvVFqwqyMjn865Y0sSKvSzgu4cE9Y6W1A
         hxO+owkLO2f4qsvzK6DIZwXLNO8qwSvKTUlbRWP6ei3QxX2LMl7chr5IB+yVQpXX7zhd
         mHmZkyqto7eU2XiWB2EBn4r6X93VDbMI3sL6+2PYkTeCt5LuQJn8YE6U5FiCWMV6TyCN
         eZUP7E/MKa0XwDC8hUmQB4V+YU+lw4wnYWn1o7Xk1Y7hHZEd14vAuIYuzvXzWkEpD9RA
         NLjkwN8W4T2wSvXkC1s3kY0D/p5VuLMSk9U7KeVhUwCou/65JLRTbB1ZN1JQOe6R7/iS
         D7CA==
X-Forwarded-Encrypted: i=1; AJvYcCVlFm7asZW8x6cjXZx0Miw1/hXOLC79XCJFEoXkAeV0z5u2p52CQb1sCQMRKcDATDCYD7c=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhY1WlBfYYFR1Wjji5zgNu0+jIq7JmPv7AbqogEY60fb2fca0+
	sNar0+xiQLPYc24Oa/KKmtJ4jzJdJG2euVoC1sMWJJjJbZXcFC7vly8KjTlXNAZXGJiJydmCe8r
	ZSg==
X-Google-Smtp-Source: AGHT+IGJ6z3saIzRbkZlSBZLnZw7mlbnCfDCjtlOA/kyHI3FVoB/Y5gfMuQ1H6WQ1/ZAhh6gzh0XRDRpGl4=
X-Received: from pfbfb4.prod.google.com ([2002:a05:6a00:2d84:b0:732:1ead:f8ac])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:1509:b0:1f2:e2b0:dd91
 with SMTP id adf61e73a8af0-1f2e2b0ddb7mr3698859637.21.1740622795028; Wed, 26
 Feb 2025 18:19:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 18:18:46 -0800
In-Reply-To: <20250227021855.3257188-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227021855.3257188-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227021855.3257188-31-seanjc@google.com>
Subject: [PATCH v2 30/38] x86/paravirt: Don't use a PV sched_clock in CoCo
 guests with trusted TSC
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Juergen Gross <jgross@suse.com>, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Jan Kiszka <jan.kiszka@siemens.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Daniel Lezcano <daniel.lezcano@linaro.org>, 
	John Stultz <jstultz@google.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	linux-hyperv@vger.kernel.org, xen-devel@lists.xenproject.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Nikunj A Dadhania <nikunj@amd.com>
Content-Type: text/plain; charset="UTF-8"

Silently ignore attempts to switch to a paravirt sched_clock when running
as a CoCo guest with trusted TSC.  In hand-wavy theory, a misbehaving
hypervisor could attack the guest by manipulating the PV clock to affect
guest scheduling in some weird and/or predictable way.  More importantly,
reading TSC on such platforms is faster than any PV clock, and sched_clock
is all about speed.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kernel/paravirt.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index a3a1359cfc26..c538c608d9fb 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -89,6 +89,15 @@ DEFINE_STATIC_CALL(pv_sched_clock, native_sched_clock);
 int __init __paravirt_set_sched_clock(u64 (*func)(void), bool stable,
 				      void (*save)(void), void (*restore)(void))
 {
+	/*
+	 * Don't replace TSC with a PV clock when running as a CoCo guest and
+	 * the TSC is secure/trusted; PV clocks are emulated by the hypervisor,
+	 * which isn't in the guest's TCB.
+	 */
+	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC) ||
+	    boot_cpu_has(X86_FEATURE_TDX_GUEST))
+		return -EPERM;
+
 	if (!stable)
 		clear_sched_clock_stable();
 
-- 
2.48.1.711.g2feabab25a-goog


