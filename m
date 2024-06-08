Return-Path: <kvm+bounces-19110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 28EAD900EB7
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 02:09:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E0811C20E2B
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 00:09:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA15E1EEF9;
	Sat,  8 Jun 2024 00:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="teDdsSyT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67061EB46
	for <kvm@vger.kernel.org>; Sat,  8 Jun 2024 00:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717805223; cv=none; b=dgYUOVaWqnpSllfZIelLmVSxn6g2Wn8kV74a1jDTt2KYyDoSsjKcrQKk2l6JuHoZ35Zm0zyML5qYZ0D1unLtTfWePnLsOisocZu+9n+weAbCS8iUlYo9o64zpMOHJcCZEaCdk5zMr+y8SP4uJN+IwVz8WhYQBLBy98E+llNvPkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717805223; c=relaxed/simple;
	bh=keNcwSMF4FkApxmQ2VK4QyKAfPOMI5FV7pwCXoqwCiw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uiWQYJNsiV7JXy/xkyzbKv54k3DjBeF9hkTqgJU2qLvLA6JqQE6p34rRo2CLxfGUgHspSFDCm3iURTjDHhm/iWKoZkbx4YISQgxEZ3F5dVR0JRWeiIDc/RMYRiC1hdVgYWDL9X8EIge5dBjLLaIiN+lJnPE3Z3RBlragtNLbMxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=teDdsSyT; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-627e4afa326so44057397b3.2
        for <kvm@vger.kernel.org>; Fri, 07 Jun 2024 17:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717805217; x=1718410017; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=BUjd1F/nSMBLgzmpYGS3K0aopy7os8Y5usHW0sJFCA4=;
        b=teDdsSyTCKURqYcoDOZTAbKcSPC/I+JFVsgAmD3RQIO8Tj1AZdWwdl0hlVq6qqIob+
         AY6n+mdi2I2ElQK0VdRAPccYgLo/mTzynKGXdxvDHfg3A6qziHEkqtfHAuAJ0f4uJn59
         HcjnrzFP4oQNd5ghpbOpQQyWIrfGlQfzHRhkLEh2T9EsjEB0D/gM0xY5hI5D87aQP+uE
         9s9gTobOxYOfn8rspF/3XBPYDfh4nhlHrvI96NFCUrvWn8L/viy/LHOlpPeXFd5uy/35
         gEpPWprrpdgn6XRtITCNsEiy1thtdHeoM+nAGRl+NJX/mRcPJaiPwWOOFGdAzd6Dj8dp
         2CVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717805217; x=1718410017;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BUjd1F/nSMBLgzmpYGS3K0aopy7os8Y5usHW0sJFCA4=;
        b=DaIfaObS5Zutsv/Q9UeKrKAsfLdZc2v7MmQsJfcLQ1otWnhRoQ8oEFwnzuoSClqFO9
         EbzpITU1adibVsEiyRObEVZWDsQvXoC7nbhlob+M0m5vqF29+aL4RCPFSMl5Apnuojkz
         3zomFKhNX7Q9PxDAsWuPDCwEjtsl+gGuu30EYJ/Kt5ptar6yzW5ioB3pbpEqR+7ih84C
         rpIWqSBc1uIsT2fKEMAl4OCoGVGHO2jKf9/+AgixLTDQMmmGncQ6ocMKWXzkSF8GHeFm
         dCVVGQe7Yi13sOcFOt6aLECbE7RyJk1Lqx0zHe/Fc6aKQVy0DZ3B5v/W1BEY7xb+8/d5
         tnwA==
X-Gm-Message-State: AOJu0YynXMVlP6oro5RJJZzuw6O3M95hQDZ+pWFyP0oVryqsCxdKpcD5
	bBwNvkB9uU2uWYHQcIQiS8YP7hNanCtOc1NNFe9cRW5y5XwxEIdQSzd1NPKIXWxPdZj71/vlCGX
	96A==
X-Google-Smtp-Source: AGHT+IGFTYtM41j5a9HMVGr+fnjy8o1+4kr7OtMPSRtzyUXfqtIDduBzI9p/ljDOhXVkr9L+HbkTuE5vn9I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:6609:b0:627:a97a:3bcc with SMTP id
 00721157ae682-62cd56e1bc9mr11028927b3.9.1717805216879; Fri, 07 Jun 2024
 17:06:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  7 Jun 2024 17:06:39 -0700
In-Reply-To: <20240608000639.3295768-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240608000639.3295768-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240608000639.3295768-9-seanjc@google.com>
Subject: [PATCH v3 8/8] KVM: Enable virtualization at load/initialization by default
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Enable virtualization when KVM loads by default, as doing so avoids the
potential runtime overhead associated with using the cpuhp framework to
enabling virtualization on each CPU.

Prior to commit 10474ae8945c ("KVM: Activate Virtualization On Demand"),
KVM _unconditionally_ enabled virtualization during load, i.e. there's no
fundamental reason KVM needs to dynamically toggle virtualization.  These
days, the only known argument for not enabling virtualization is to allow
KVM to be autoloaded without blocking other out-of-tree hypervisors, and
such use cases can simply change the module param, e.g. via command line.

Note, the aforementioned commit also mentioned that enabling SVM (AMD's
virtualization extensions) can result in "using invalid TLB entries".
It's not clear whether the changelog was referring to a KVM bug, a CPU
bug, or something else entirely.  Regardless, leaving virtualization off
by default is not a robust "fix", as any protection provided is lost the
instant userspace creates the first VM.

Suggested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e20189a89a64..1440c0a7c3c3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5495,7 +5495,7 @@ static struct miscdevice kvm_dev = {
 };
 
 #ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
-static bool enable_virt_at_load;
+static bool enable_virt_at_load = true;
 module_param(enable_virt_at_load, bool, 0444);
 
 __visible bool kvm_rebooting;
-- 
2.45.2.505.gda0bf45e8d-goog


