Return-Path: <kvm+bounces-39495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 314C8A4723C
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 03:22:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 248B91889200
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:21:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FCB01D79A9;
	Thu, 27 Feb 2025 02:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fef7FjLd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE271C7004
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 02:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740622757; cv=none; b=JtdkObTdWn5J1KwKwvSsXesyLmIMQkuUZcbV/SFM3FsLlE6lzWTznJIZPSWBcL6qzBH4+HD3Z7lzpuBla4PczEzw33MfIpVWPGbRsvC5q8itpTkgu36+uUgiMdaYGr9nfnLmP+BZfjCkF0akcLA/eqAsDDTGA+bi6lRfTFH06gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740622757; c=relaxed/simple;
	bh=X5UL+eTktXYoDPfW4LhmVxWuD5wQW055Sxbi/QZyZe8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pj+a6FDK8XCidRGNwhaYhhkM1pu3IzMBVq/cy3qQjND08gcaRqraSiSXFNeDPQMvFepc95KwabBdsMwdPLg3HW8+bkn59H8jNxobXputB3QXYoU9EPU+mU0zfYaJtdS7yC3ivL9z3U4uHMcIGZTonPj7hPQUZbs+xBkH+HQA/7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fef7FjLd; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc1e7efdffso1555490a91.0
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740622755; x=1741227555; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YtBqucRQyVVjFtgUlGbh/U8C9xbSv2L/3t5kwpG/0fs=;
        b=fef7FjLdAGAJFHAV25KQWsC9t24sfQtyoidwN5PhExU2XZXQEHcBpReguAaITHeA2q
         euVkzCaUxnh9LnEd/DeVHueiSFgC48U8XOFiALyEo16At6ambnX0VOJMkcDU15wV4hF3
         zk8x9Mv5sfkkIB69g9s0MCeaXB9p2k9Fa1M+dFW1pasT5Dy0RIciAUEmWfkcpicm/oY6
         F3OJI5txJcOBanKjOnda7GPAL+1dGGB+UxbFzdFJ8pI9PhJ+2zZfIsCmEdqWbr3IPyQ/
         zPMgJfwb6fabO18/j/NRfzi/j3VtftBgDU9aJ7Sds2DYxf9xs5dUqTcKuGe1gJOPiBEY
         XuYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740622755; x=1741227555;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YtBqucRQyVVjFtgUlGbh/U8C9xbSv2L/3t5kwpG/0fs=;
        b=hnbVWbuJDhZl81mid1DLp7D32E3GwVG78+0i8Weh9xPOFrBeUNebv+S5zxkLl7J3SH
         No/Vvb1NdIHH7eJpz0rJjXuX0q+L8kKxWSA9yBIRZh6uUILUz0o7yjA3oCCj7XKhhDbm
         sPT7xQUU34ho7JZmogalyPwO9gzSkU2wuJ3ccTEYYez6zPZlS1u5/KlHX8mwBRrPAKAS
         NXlkc8Aq3cqk+wRBp3BidUMt0EPAhOc24BJDA288Z8H4S7Ahua+bLZS56vi1yTDQxgHb
         wf4VEC8l/hoz7V+gCNpwXuTRBIE6fw3YLUZePRZJcJ2pMTSmjr9iaZwo32yxM5o7MDzb
         7GDQ==
X-Forwarded-Encrypted: i=1; AJvYcCWnyMt0osUEgmSQIO/3DgzEDkJGFVEMAE24BBv1hT7zpHLQ1G/1QTxGA6gZKnxlRBSOCTY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAv4oF4qcEsfM7K3cZXsdOTwy+NB7y+XUj8WnqWp25VcaqHOvp
	suijHegKBPj0Ksd1suUbWspCLa0gRaXRLmz4SZFNW8UfKGtd5rm2mpPPq3aJtzelncSO7D1SzCv
	gxA==
X-Google-Smtp-Source: AGHT+IH9Y0SwBcAS02xHNq+a4IakpnWSLKqVw4P68iCQM2m6waYT1AwLAOPZPnrjzYdSpJiao+kBYkSTr34=
X-Received: from pjb4.prod.google.com ([2002:a17:90b:2f04:b0:2ef:78ff:bc3b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2dc8:b0:2fa:ba3:5457
 with SMTP id 98e67ed59e1d1-2fe68ae6c4fmr17520974a91.17.1740622755379; Wed, 26
 Feb 2025 18:19:15 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 18:18:23 -0800
In-Reply-To: <20250227021855.3257188-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227021855.3257188-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227021855.3257188-8-seanjc@google.com>
Subject: [PATCH v2 07/38] x86/acrn: Mark TSC frequency as known when using
 ACRN for calibration
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

Mark the TSC frequency as known when using ACRN's PV CPUID information.
Per commit 81a71f51b89e ("x86/acrn: Set up timekeeping") and common sense,
the TSC freq is explicitly provided by the hypervisor.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kernel/cpu/acrn.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/acrn.c b/arch/x86/kernel/cpu/acrn.c
index c1506cb87d8c..2da3de4d470e 100644
--- a/arch/x86/kernel/cpu/acrn.c
+++ b/arch/x86/kernel/cpu/acrn.c
@@ -29,6 +29,7 @@ static void __init acrn_init_platform(void)
 	/* Install system interrupt handler for ACRN hypervisor callback */
 	sysvec_install(HYPERVISOR_CALLBACK_VECTOR, sysvec_acrn_hv_callback);
 
+	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
 	tsc_register_calibration_routines(acrn_get_tsc_khz,
 					  acrn_get_tsc_khz);
 }
-- 
2.48.1.711.g2feabab25a-goog


