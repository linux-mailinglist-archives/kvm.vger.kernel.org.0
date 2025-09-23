Return-Path: <kvm+bounces-58559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C326B969DB
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 17:37:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FCC03237F1
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 15:37:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98BAD24EF8C;
	Tue, 23 Sep 2025 15:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pRsKPOEM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573161B4248
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 15:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758641863; cv=none; b=MbEl9V8bON29p1u7cZxqQfmCO4fZ8Kx5scNRuZCv75yPa5o2y8rXEFLYs9Xnf7HWU4kwP5UKu+z5kHQQr+ME9F+vz+Ob9/HwjA/Pyw+c20dZ2Cpo8GEPMxUE2ttI2SwAhuqr1bfBgiZrTZmSqr8Q5h8jMnMzJd5LmG4II4OGoBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758641863; c=relaxed/simple;
	bh=kbAehCgUqodMp9rgJOuYJZ1txmGjosQohfqNc9YOHn8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=I0E+6AB/YWAmNhPcHZ6q6HksvydbU2YnJ+1mKMydt9/H4oEs7hF0QYpZbxZDyULhCVAi6Ozh24lfs3CH14QUdKe1bvSuaCrEpa67SokB6/32SavZMsJb/XJ1SItMhLgm3lOiJbOIMg9DB8WDUvNzYAZ8ZjIerWLtDTil5If2FJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pRsKPOEM; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-77df7f0d7a3so4716480b3a.2
        for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 08:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758641862; x=1759246662; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aPSnXDgTwBFFZSA2g+9Z8hmqmEgoZt1YklKuT8li5Ck=;
        b=pRsKPOEM/72ahMSpAofXv9VFP62zFmqznV7NNo4Y0dr+jO3LOWVoO7ySUqrA7QKGVl
         ewzLb3iW8QWmRK01gOCd3aAkVxQefvTkXe/u4waqGvbx3Xpal8DRRV+fWJweZSOtE8MT
         vysRUirwCSlY39DjoqZolMN4iY+PcPUSc1vxD3KbIvsXAv6u0nQBO8jSqj0409NNP+4n
         WN96EIlirVe6XIuAYK/S9QwYfHOur1kQieWpF6oLSXptQk12HiYrXSVjibeO9kmWKzs9
         4OW2cE1iIMbQcD9kGlqh0eqQ/THzFfMz1mu0likff3ruK4lwBofNh1713MLaTqU3c773
         ZPVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758641862; x=1759246662;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aPSnXDgTwBFFZSA2g+9Z8hmqmEgoZt1YklKuT8li5Ck=;
        b=mu1HxxnVI1GUuK1aeWOaN3VHtdKCIwP0EF8gHR6GJ2CccdFbG2b7gO8RzqZoPok5cq
         Tgp2ViL4D4svmEdVgNnstdX+pr/JhGm2l68xr+Vau7oUgtN+6isAFKoOCbUazgAJOQpE
         UwDebVDU3f1t8VtVN4GUdknU0cLgLlMycTjC9BJWkfbkqpwLt0A5HiP/zF7n1p6fDWua
         RJxzr4zhulRpYQmH3683om0MwjfgxuWyiMbMkKlPM4gjiW2V4Yk9Dz97uXHFI5r8tgiR
         DnuA9Lur/q9blrHk4dxs1OkJO4Zixgi6uGx2LUaZc5u9E1QyM19nBq0bT5Z2pTZWG2/Z
         pGHg==
X-Gm-Message-State: AOJu0YyHxKp/xrzMgtdkbGnGHXFsNQ4NI+e62ZUk3eHbMlN5YII/CiKP
	tm0A2XY9mgdst8WDvrnFXRfDMXoPtLi9bjRH+kfar91xN+q2T8bgedZ9VBD/AswIou+A3MrQixP
	i9h1YqA==
X-Google-Smtp-Source: AGHT+IH7hRrsrk0Rhbnod8BSQcKkiS7sbqT63RG9AzLphPusQzpwDuq24pErC23eKbIq89uVlZYpSTBgqO0=
X-Received: from pjv6.prod.google.com ([2002:a17:90b:5646:b0:330:6e2a:9844])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6a0c:b0:2cd:a43f:78fb
 with SMTP id adf61e73a8af0-2cffd79af47mr4299206637.48.1758641861700; Tue, 23
 Sep 2025 08:37:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 23 Sep 2025 08:37:36 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.534.gc79095c0ca-goog
Message-ID: <20250923153738.1875174-1-seanjc@google.com>
Subject: [PATCH v3 0/2] KVM: SVM: Fix a bug where TSC_AUX can get clobbered
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Lai Jiangshan <jiangshan.ljs@antgroup.com>
Content-Type: text/plain; charset="UTF-8"

Fix a bug where an SEV-ES vCPU running on the same pCPU as a non-SEV-ES vCPU
could clobber TSC_AUX due to loading the host's TSC_AUX on #VMEXIT, as opposed
to restoring whatever was in hardware at the time of VMRUN.

v3:
 - Collect reviews. [Xiaoyao]
 - Make tsc_aux_uret_slot globally visible instead of passing it as a param.
   [Xiaoyao]
 - Mark tsc_aux_uret_slot __ro_after_init.

v2:
 - https://lore.kernel.org/all/20250919213806.1582673-1-seanjc@google.com
 - Drop "cache" from the user_return API.
 - Handle the SEV-ES case in SEV-ES code.
 - Tag everything for stable@.
 - Massage changelog to avoid talking about the host's value and instead
   focus on failing to restore what KVM thinks is in hardware.

v1: https://lore.kernel.org/all/05a018a6997407080b3b7921ba692aa69a720f07.1758166596.git.houwenlong.hwl@antgroup.com

Hou Wenlong (2):
  KVM: x86: Add helper to retrieve current value of user return MSR
  KVM: SVM: Re-load current, not host, TSC_AUX on #VMEXIT from SEV-ES
    guest

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/sev.c          | 10 ++++++++++
 arch/x86/kvm/svm/svm.c          | 25 ++++++-------------------
 arch/x86/kvm/svm/svm.h          |  2 ++
 arch/x86/kvm/x86.c              |  6 ++++++
 5 files changed, 25 insertions(+), 19 deletions(-)


base-commit: c8fbf7ceb2ae3f64b0c377c8c21f6df577a13eb4
-- 
2.51.0.534.gc79095c0ca-goog


