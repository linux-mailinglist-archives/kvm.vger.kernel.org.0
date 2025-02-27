Return-Path: <kvm+bounces-39505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C24CA4727B
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 03:25:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 23754188871B
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:24:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C3EA1EFF9E;
	Thu, 27 Feb 2025 02:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u0Xr9RMN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66EB81F7904
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 02:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740622776; cv=none; b=rkSux4EP93lqNIYEMUZFxp0jiz+d9HAl4cH1RHa2JYqLGDV/W/Wtr38uEDoPj2ZcP4sMz7F125g0melYSd4XdoKlAEa7cIrMfs/smhxDEM6nLcu2oubquuxIkNdJGVniKAQN15E9ZSvZhChv3aEdo0a/2WbMTv/4HHTBAOEvRZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740622776; c=relaxed/simple;
	bh=P0O5mmkSnDe0SpsR7bTvnzJu0+xYte77F3QT24wbpm0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=M6KfPdHlJ9TGs4b9RlRhC4enfMKL73f7mFMu773upBam+F9zTpzMq4OQdrCCblSpu/gW6NNiohQwDKBvpaIkAVX1/1miy+cz7EWVpT67L+9pYVqtM9n3hrxmVM5JsoXUvJBQLKJBPeM4LImmt+woFf/32sf7H2oyCUGwobmwsFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u0Xr9RMN; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-220caea15ccso12391755ad.2
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:19:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740622773; x=1741227573; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=iUPGjlm6EABKAwlimnT9Yj0uy9Y0kc3vikfZk6zMyUM=;
        b=u0Xr9RMNsxVJE42Vyec4L7wv5hwQgKsHPCI3qt4/2eAdpgqeuhscM35oaMtq/TN3P2
         0OL5Txkr+v59vkD/mQGlG90xMPNHr40hnGkbTwftTkLVtbOsVSgmfMBTB2/okKnbuO6U
         I08xs79VLD3mMj0ZX2U1dFjUshA+JEDeSWuZjbvha2ZGCyzE1VmYZVwWkUxNTfFlmEwW
         +CXuxQD+e14M/diL8RKMkb93imPLoOwAJz/t5B8BqysLfCdpBRmyYfe8JsKHa2ayQ0NZ
         oCSyKNzdol48LlKRhGIhJrUhnIssbmQX/do7B4kVJDZqguvFRCbsK1mAWt8mim4PFa3z
         P1mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740622773; x=1741227573;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iUPGjlm6EABKAwlimnT9Yj0uy9Y0kc3vikfZk6zMyUM=;
        b=kOhIPOwcIR4f6nyOsSbjbrWbfQYuy3/1LYPzpHlMYaGcvUXSqflFKZCteQahos9UW1
         R773ZZKArO2wr1UvyQcpBGfkYktT4fiLbcwarCvKI7SnkEXL7cRB+TozUrFBq36kNxYw
         auhTDH1/dRyRwhXr8lArH7fe5Xdf5sv5TcYhzUt2n4dFs2v7g4qKy5QzXJP781aBd1B1
         7SvPA5yRx49diibAA0Xfgnfrvs345XzLjGwTJnNSKXEzwNAiINlFzTsdrrZRwuRcFoxF
         2WTOS1sjso3B+Eankubh94+tcqXAg1/Buj0BZxwLPXnHRa7XyPoFWrYrbgsSzE5ECkuJ
         HXhg==
X-Forwarded-Encrypted: i=1; AJvYcCUh4q+kCvnXPOqctYGOvZOOLovyk/tRrChAsYSSDE+Z/i40BH+dLB23pcjv+dyt8RnDMbQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzC4nw8coyMmk8C8kH6MeH0Jiyx2+IlnDryFcCqUoIWmVOw3dz4
	QMI8ixbNp+HYW3HMuY4D6041aH/Xr31sqD2osxb7xJiNjjnfCAa7kds2A4oQJw1TYpDNS+sstaT
	FkQ==
X-Google-Smtp-Source: AGHT+IESbVD77xvo7C+ciGzHtrGqGL0Rj+DzLIK2/TaODo5QawXajXsWSJTUc7OSugj7U0H5GgKBaGLNEhI=
X-Received: from pfld12.prod.google.com ([2002:a05:6a00:198c:b0:732:7e28:8f7d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1813:b0:732:6221:7180
 with SMTP id d2e1a72fcca58-73426c943c4mr38161657b3a.5.1740622772828; Wed, 26
 Feb 2025 18:19:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 18:18:33 -0800
In-Reply-To: <20250227021855.3257188-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227021855.3257188-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227021855.3257188-18-seanjc@google.com>
Subject: [PATCH v2 17/38] x86/tsc: WARN if TSC sched_clock save/restore used
 with PV sched_clock
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

Now that all PV clocksources override the sched_clock save/restore hooks
when overriding sched_clock, WARN if the "default" TSC hooks are invoked
when using a PV sched_clock, e.g. to guard against regressions.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kernel/tsc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 472d6c71d3a5..5501d76243c8 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -990,7 +990,7 @@ static unsigned long long cyc2ns_suspend;
 
 void tsc_save_sched_clock_state(void)
 {
-	if (!sched_clock_stable())
+	if (!sched_clock_stable() || WARN_ON_ONCE(!using_native_sched_clock()))
 		return;
 
 	cyc2ns_suspend = sched_clock();
@@ -1010,7 +1010,7 @@ void tsc_restore_sched_clock_state(void)
 	unsigned long flags;
 	int cpu;
 
-	if (!sched_clock_stable())
+	if (!sched_clock_stable() || WARN_ON_ONCE(!using_native_sched_clock()))
 		return;
 
 	local_irq_save(flags);
-- 
2.48.1.711.g2feabab25a-goog


