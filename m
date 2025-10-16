Return-Path: <kvm+bounces-60216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 12B62BE52B9
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 21:06:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF0624845F1
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:06:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED32F239E65;
	Thu, 16 Oct 2025 19:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p14gw84/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89FA19F43A
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 19:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760641608; cv=none; b=Rnbyv5LMo/IgmNhW2Lnr68O2/fgpOa7GzC3q5QA29irMKciRZfIWgMA7idQR4HsOoqUn5SwDD8Xm4Sm5a9N+xbbnNOVVQBckk7BPre1X+vx6ihDiKDtBEGYl8EuFQzHuEe69M1lJCrJQHVTtQVmpuiTup1C9iplcyfh0KcAEnCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760641608; c=relaxed/simple;
	bh=fHLCYT161lb+n1QIPDAmMQL9QlVrhfJ5AaY0+ax/iK8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=HwODNf/y4bVg3b7l5jwKrSxcNYT952ooBa3JH/DypfT0MzIApmrHbuBoqMD1HNPRHYs57Ne71fDS51Ofh/splOyJXFVDP8sO9rPTQZbb2CW3fFDVeWSZ1vxoPwd8zyFMxjEoEKuH4o4s5nU1ZEq9xeT1Zwy0gJj/rApRwNXlXOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p14gw84/; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ec69d22b2so1088265a91.1
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 12:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760641606; x=1761246406; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iIOb/2A/2ytYzJ0QwNwSePEDACaGWltHmU20VSHfFcI=;
        b=p14gw84/AUTFecag4h9Xe+nQBlKKMUv4RhUlLSogaPsXcjgB8nRmqO4bDZ/VzKquDh
         lXGfsCxChLi0n9xz2UThlZrrT8uRv4oVHnFetXlTRy76dyV2IYAIqnJgz0WSMu+xxhv8
         uW3pmSGdD7QZ0pPknj9MFC9ubHdMYrfkXlxD/XueRXY4VomapqAk9DMF3j4m0yrwZeyU
         fB7kbKwEQ9nyfkt3IiMrHUALToJ2lPoU6SZfxIdhH0IEK5bmargsyXeVxJyZiHYBKx72
         JzS+f1yPUIPEAatQ/BThqpHYvsKi6uXjNJqT6yeFVvdKUTsPjsr2M2dLcAnjqKRyXSDQ
         mr8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760641606; x=1761246406;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iIOb/2A/2ytYzJ0QwNwSePEDACaGWltHmU20VSHfFcI=;
        b=j/8zzLxjMMHeUZEyQbYohwehtkkXd66qsz6k8Aqnb2Dx5Dc3AiwpKjzoOuZIswbTr3
         CSnm7lpQQuV6vzgKJ1O5zr+4H6Ligm8Cazwa0HVbsG2AX7w83F/RsWBwgDNYqb/+MH3M
         qo7H8lG5bG0b6x7M4MmN7uQhso6vpiLEMYrd18lqd26fETIz3hQTZrxp4FJ2YvXtd6F/
         ilx2dv277U5t+Jr+8GbXTiU5yZd1bFGJj4UCGvzMT7YOwexMdzof22IsfHYK6Hct/WUA
         xjI9FYgYSJVx//Vu8Wl/lNnGi3ymcbPVd/L118tzZH6kv7Crc+Cg3uCLfNcaTqWNSE52
         ABCw==
X-Gm-Message-State: AOJu0Yy5jao8eCV6K64ym+NxN8fc8h/VPr2RC70fpQEVMMmAlfp0zmgV
	lJR2c7aZ2uje0/OzkQzn7r0hbP9rpQmCHR/EhjniC3By/AsEXdiXpQ6WoA3F+Pgp2LQKEhn3JiB
	r2fXPDg==
X-Google-Smtp-Source: AGHT+IG1fKP9GeKfZIf01S3NDQzTVcZoj6VlwLqo9WIAlfYNBF7WNVM9ajyc3SPTpy17QR7Cj18QLLW2Q54=
X-Received: from pjwx4.prod.google.com ([2002:a17:90a:c2c4:b0:33b:ab7c:3147])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5281:b0:330:a301:35f4
 with SMTP id 98e67ed59e1d1-33bcf8e95dbmr1079104a91.20.1760641606031; Thu, 16
 Oct 2025 12:06:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 12:06:40 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251016190643.80529-1-seanjc@google.com>
Subject: [PATCH 0/3] KVM: SVM: Unregister GALog notifier on module exit
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>
Content-Type: text/plain; charset="UTF-8"

Unregister KVM's GALog notifier when kvm-amd.ko is being unloaded so that
a spurious GALog event, e.g. due to some other bug, doesn't escalate to a
use-after-free.

I deliberately didn't tag this for stable@, as shuffling the setup code
around could easily introduce more problems than it solves, e.g. the patch
might apply cleanly to an older kernel, but blow up at runtime due to the
ordering being wrong.

My thought/plan is to get the fix into 6.18, where avic is first enabled by
default, but not bother getting it into older LTS kernels.

Sean Christopherson (3):
  KVM: SVM: Initialize per-CPU svm_data at the end of hardware setup
  KVM: SVM: Unregister KVM's GALog notifier on kvm-amd.ko exit
  KVM: SVM: Make avic_ga_log_notifier() local to avic.c

 arch/x86/kvm/svm/avic.c |  8 +++++++-
 arch/x86/kvm/svm/svm.c  | 15 +++++++++------
 arch/x86/kvm/svm/svm.h  |  2 +-
 3 files changed, 17 insertions(+), 8 deletions(-)


base-commit: 6b36119b94d0b2bb8cea9d512017efafd461d6ac
-- 
2.51.0.858.gf9c4a03a3a-goog


