Return-Path: <kvm+bounces-39510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A0280A4729C
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 03:26:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5D4F67A73C0
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:25:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 860B522C35E;
	Thu, 27 Feb 2025 02:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H6SdjLeU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE9022C34A
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 02:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740622783; cv=none; b=mwa8bA648KKw25ZNFGzlYLAHCoyEYsNpV3P1JwDBSS8NaeEQB4RCt2q8NafmYOuVh++tYa36O+4Wga9T6e0GWSHGUTcqRbc/+bpTnRyWMHxQPMBnS8Z8bz8ZmDlJvHOm7MoefGNeeag6jkzuRDcPR/oX9tFFGWa2Gn2ch6KMhb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740622783; c=relaxed/simple;
	bh=xZNJmibFAKYDGISYNbW/hm8YjPy9RQVjkpaMVV1EGPI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fpAidrPfB/JEZAcm2gAxZ8hdf6z2f5/osPSK9sq9ASq9Yc7Ymac3T0PCnzW5D4XfDbne1OYU7ZINTXGpRI05b9uBPWZmss3BvAN+jFtZG1WbmhBdV39xn97wmMkZSgBatX99h+187mZZ2fOYyL5odnkmHaKGMopUvibUmcpRczs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H6SdjLeU; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc45101191so1080102a91.1
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:19:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740622781; x=1741227581; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=idfxGEE7w4MZK5vL28VhSjtN1o6ADW/NzBB0c7HM3Jg=;
        b=H6SdjLeU520UkDNHOZ//8MMHEiXmjYKiYsng1MVBe6W0d/x4XD19eza+Tm7qtpX5QC
         gEkpAbS5YN/zI2qMibEodzaquE4m8PxUZJo8qsoK2pWipEEngCBXIkwhM9RgonwL3NRD
         z++0ejZAJzx34aAMAGgrUT3fQJl7H+dwhh+egMvqqMiK9Jnd13gZWBxM79+zPY1wRIiv
         B0yUT+/9XyUO06TuvNE7aTwJnQ1OXhn08A0c0W+teCS0HmHP5CkF3GqPTGoTv9qdhP1P
         Pllgkn+I9zO4kfOBo73Vm14Emo7DHcUGCMZI63ifRJwoM9Y+0QR1mhYbAVUV2cmFovRn
         EnEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740622781; x=1741227581;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=idfxGEE7w4MZK5vL28VhSjtN1o6ADW/NzBB0c7HM3Jg=;
        b=a94yhWZdaLlz0zQ9vONQgIsm4/PFbcdIvQQckZbXvLYKMfbpP+ODrgf7fPbwaYOQ4v
         9p4BNZh9ExHcHEFkXJ3ExseMVsB5++6q6GAXiLwuLdJsTxVJ7/IEoSWr7jR6ktkvYhbT
         AIChdY8pQPcDrMUYeAU3CKTx4sVgusEhKJbuDsLL5UN5+ChK2anBwWuOKD3893YO3LUV
         YuYPvota6RrcwMCLZXAoT8cUg16041xDYjMnjZIR8l6Ti109V1ZdsdkA0A0PPb0YUvVE
         hQ30cL/8gSz9hEeOTUP1p6v6CLbGRRY0+aHpaVkkpO953WLnKdA4mGHPamaoFXUbbk7e
         RdKA==
X-Forwarded-Encrypted: i=1; AJvYcCXSkz7I/h8EsbXUJDTn/78JvAPTnl/klxSlhW9YOynX08vSI4u7LuKKlbFfYFltc49LPJ8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0MJxu1XLSFWL5RZQa3P49Q9RFrFluiwnoVLuPSMN2HB/+miVw
	fEf/99zaKYm5eeUrHxS8ldsDjUDFB/CMxVVzzs8sVTPAFupSrSElByVdd0eTA6lFBE1TIyrx3fh
	EwA==
X-Google-Smtp-Source: AGHT+IHCzPrRKHA3wP3HVgIKrQRSiWCMkFG4NMbhGFfjlCu1Pi9S6BKyZnSxtjm5Zx+28kwNIdNRFoi5Jdo=
X-Received: from pjbqi7.prod.google.com ([2002:a17:90b:2747:b0:2f5:4762:e778])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c04:b0:2fa:20f4:d27f
 with SMTP id 98e67ed59e1d1-2fce7b23bb5mr32633734a91.32.1740622781602; Wed, 26
 Feb 2025 18:19:41 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 18:18:38 -0800
In-Reply-To: <20250227021855.3257188-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227021855.3257188-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227021855.3257188-23-seanjc@google.com>
Subject: [PATCH v2 22/38] x86/pvclock: WARN if pvclock's valid_flags are overwritten
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

WARN if the common PV clock valid_flags are overwritten; all PV clocks
expect that they are the one and only PV clock, i.e. don't guard against
another PV clock having modified the flags.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kernel/pvclock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
index a51adce67f92..8d098841a225 100644
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -21,6 +21,7 @@ static struct pvclock_vsyscall_time_info *pvti_cpu0_va __ro_after_init;
 
 void __init pvclock_set_flags(u8 flags)
 {
+	WARN_ON(valid_flags);
 	valid_flags = flags;
 }
 
-- 
2.48.1.711.g2feabab25a-goog


