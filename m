Return-Path: <kvm+bounces-39503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 52FA3A4725E
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 03:25:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A18AB3A662B
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:23:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39EF81F5855;
	Thu, 27 Feb 2025 02:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YyyjItTo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1401EB5E8
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 02:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740622772; cv=none; b=h4vrn5awYTu76NKjppJoKux1Y12kz3NmT0u5BvkaHa5GqJJR3HszKS3h14ivZBt9Vq4tHxEWMcuwLcOQGqWg3hZIAEinZX7g9vFwpHvpCJ2VWS4lCISWKV+R4GiJ95KgMkuhdBoVETbSU3+lu5nOtpIB+GS9HPxWxONlkq3uv08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740622772; c=relaxed/simple;
	bh=qrmPmOcptAmLgQCle3N1kl8WrTK3PJ1AWETKMFIpJ6A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cKeqpnpbn86yAV12l+g0OQdTIgQ5FK2D8YdgYuQDtOkFFXLTNlEo0fGfND9EqkLVdpsBW5i4kFPMdhTdQR+ySHzWE/Dp/kqaYLRB+iJlChCFYNXtiS5rnGEEaYSlNQHNymg4dExRlQdtnlCgvad2YM2ISDfI40ubM5oNfmciGso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YyyjItTo; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fe8fa38f6eso1026734a91.2
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:19:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740622769; x=1741227569; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4/yyaam3CnBmuwJ2ykq85CXFFo+ZsEjkVRvpD/uHncQ=;
        b=YyyjItToezQre9Sp01FKz3/7BsTNQhUdFKJMw2FCdGitER6cRnXEiuR7eMqIFgv4zC
         PLy6jO7yEgX0/h7b4T4480H5nNOVyoMeImsS77tMwMKZrrjMNqQIQfPKp0Iv7FumPaQK
         bWD/p7tGewBNhN/NL3DiD6yQcpmzqEIqrJvJE57/KdS0d2Msc1qMh2xcpYB7Gb+H22iV
         DUMuS3CztnCUtLtwLuv77Dpel0sFQDymf6jrKezXH3NftvLI46FWf3eLzgvzIpQMyhHU
         0/HPDoqeCT1joGoj4juYfoSnNmkbGynN6PXOHEJPfg8feaXrpAMyeWDgvmmYxwEYLTrK
         VvoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740622769; x=1741227569;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4/yyaam3CnBmuwJ2ykq85CXFFo+ZsEjkVRvpD/uHncQ=;
        b=G/OVngtsfOl2gGoq2dV/RBQMfA8DlBprWTIPc05DeL8VX5EAsz3I1agXxxZGdlB1ij
         WA4ptIGKTLwam50RdtR/ka2H92pUnAJ/aSNSa0aDCN9EBMsVMJsmFKde+IE9pakmQPaV
         op7NVZzciqfjgID/EK9NuUZPkVz7m7+S1tGaZ4S/e+DQ+LFbdsZWTL4C5p+Qt4P6yR8f
         oioIXJdLZNDmHIlnmgNIYXfAx7e6lzva/gvQ2A9vjjzGW0TluRtywVqOmh7zlPaY6c0B
         xr6gTswps5VZAR39tZcXEqm2UmkJnxD2sAoVa2Al3zOvnIxdtqLekd1n4eREEhnw2iJA
         mRxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUVziQ6VXkvllviZwD/3uB083yO5PVgGT43zF0+9owc9MTcXHwMtZcOATtOTHe59YmTz70=@vger.kernel.org
X-Gm-Message-State: AOJu0YzD6YDTiz5lqXQ0fxWTwJje4eJqs0GsUWI9TVgyfVZtMdRpYbIv
	xYwAJxtjooVesJPQoyTEEU7rAu1cuDU/m6qzTtxqnlKS4aqFQutJa0L4xE9InhQUSMppmdsnV/r
	T7Q==
X-Google-Smtp-Source: AGHT+IHB6t2yNhuRRLSjnQcCsiQss9r1P7c1nIVM64h4xrkl38FU8N4jisiF+hTwqGE4B/+REyTZDinhF2Y=
X-Received: from pjbqb10.prod.google.com ([2002:a17:90b:280a:b0:2e0:915d:d594])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:280c:b0:2ee:5bc9:75c7
 with SMTP id 98e67ed59e1d1-2fe68ac9330mr14041142a91.5.1740622769336; Wed, 26
 Feb 2025 18:19:29 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 18:18:31 -0800
In-Reply-To: <20250227021855.3257188-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227021855.3257188-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227021855.3257188-16-seanjc@google.com>
Subject: [PATCH v2 15/38] x86/xen/time: Nullify x86_platform's sched_clock
 save/restore hooks
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

Nullify the x86_platform sched_clock save/restore hooks when setting up
Xen's PV clock to make it somewhat obvious the hooks aren't used when
running as a Xen guest (Xen uses a paravirtualized suspend/resume flow).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/xen/time.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 9e2e900dc0c7..51eba986cd18 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -565,6 +565,12 @@ static void __init xen_init_time_common(void)
 	xen_sched_clock_offset = xen_clocksource_read();
 	static_call_update(pv_steal_clock, xen_steal_clock);
 	paravirt_set_sched_clock(xen_sched_clock);
+	/*
+	 * Xen has paravirtualized suspend/resume and so doesn't use the common
+	 * x86 sched_clock save/restore hooks.
+	 */
+	x86_platform.save_sched_clock_state = NULL;
+	x86_platform.restore_sched_clock_state = NULL;
 
 	tsc_register_calibration_routines(xen_tsc_khz, NULL);
 	x86_platform.get_wallclock = xen_get_wallclock;
-- 
2.48.1.711.g2feabab25a-goog


