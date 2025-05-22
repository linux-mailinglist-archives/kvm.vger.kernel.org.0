Return-Path: <kvm+bounces-47422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DF701AC1813
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:37:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 204EF1C02DFD
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 23:38:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC1312494FC;
	Thu, 22 May 2025 23:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3gVqDZtO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4802494F2
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 23:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747957063; cv=none; b=n9+8orBg7hLh6tjwsv7Z618ERtflcR6NN+fJVi3OTq0xuw6zj/726GdKEcKzSTGFbCpC2bgZlqtSG3q9+THlkNasdC7A4OVw6PGKi6vgGWlsn95M/kVWAyP47gm0EVp/dnnt4sEWozZ2Tn5YfFeMLtPNHVW85E2J927kKvBHPnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747957063; c=relaxed/simple;
	bh=oTVlWh1gcp7bCeYlpUYBQDd7wlE8+qcbqgWaxSnQVpY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=nhSnB3XggvFBFwy5Xoy9JST+1txEgzSgR5JUA1bCJ+vUoH1eIta5tnhwxzld9SlQFM7DG0Bv7q8SRqfwBREC8y6skGO8mGy66xAMTF9idG2XPcdK1bb16+7kSMtTavV1stXyGGnRXnGe21xcikEh9YlxYCpWoGG1GJo0qdWS2W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3gVqDZtO; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30e9b2e7a34so4903292a91.0
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 16:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747957062; x=1748561862; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C/GMxUFWnxczBclfWAPbx8KCz76D46/EtIUMIe5GBKE=;
        b=3gVqDZtOgtdATAJrdcPO+6cdstCqUb9ZL/W8G6gTxdZyWGmb6VO7m7J9sr32vlgvOJ
         qWCPc73CWvk8u0DwJOK3NiM5cDDq0eYPbst3OiiiR69XLhmq9cwba9hYlKSzIe9cRmk+
         0k5v58Ab1/Re82sN+FnWQS0mB6bvudt8yAZ7oHSvAEoumP08qslNKY4S85dQhKPxxnEr
         NhO/tirC1WbGxTYTqLJN48NsrQGXLyfrcbJ/iEIU9QFgJ5HYzRtbwX+1QsjJ48e6yLPc
         +NH/6lvR0lxz3nbiqKU8uGH65R928caoVExgyrwkkprRW2nDSrfRuvkulLGWq8I/Sn60
         eTWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747957062; x=1748561862;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C/GMxUFWnxczBclfWAPbx8KCz76D46/EtIUMIe5GBKE=;
        b=e5q5qpgu+v/4vsu9R1PRGh/uSNVrsmFP/2xIby59WONmzWJ1iP7hRGA7pvzTV3k3U+
         a1H4yi/6HaHq9LZ3irT5jJMlpVK2s2796BdM84iTurrbSvbWuZQpBlB5Wk4YQ2yJGS/6
         YXCi2yQTZ7mm3sNI0xNakcD1xVNWYN77Y3GmkGj60AKBDc7AadX8Ckd1EttW8HLiOe1x
         hvMqYLtgFkVd2GTQkoiakOZp85l5Tg5ZQ+vgIe+va5ZqIhrfHf7mbiCmpymuxSgpiyuw
         9wiq/Vj8RgPmqZE3Ks59a9S29VWbAIQ5+KN0qqATXNH7sSNkYtZCHgIF+cdCcg+3uOhD
         BFxQ==
X-Forwarded-Encrypted: i=1; AJvYcCVDxay33fD4j/hwM9ue7enbQ3Cg50Ty69QgMD4VBX8FwG7q/C9jjS0fX2q/T9H8SpDAUSo=@vger.kernel.org
X-Gm-Message-State: AOJu0YweVYN/C8o6kOBs6nX5fBusgFwElV2bNjiLfsGSSUPCqWXUxbhR
	Erir4N+RoCIFRoeWvwSEOnIawHle2xnC4RX5gZXn5LbcDAVoUi3KZtivp16RQ6DK7Y7o2ZEDqMR
	MdUGXdg==
X-Google-Smtp-Source: AGHT+IHSm7sbPUijyvF+pKq3GN2bRkSA6Knc8QK9FotWZGxL3nppVXhwWnhjgzynzLIZ6YqOyGWjDyGpsjI=
X-Received: from pjbsw4.prod.google.com ([2002:a17:90b:2c84:b0:2fc:c98:ea47])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5143:b0:310:cf8f:6724
 with SMTP id 98e67ed59e1d1-310e9740405mr1477484a91.30.1747957061777; Thu, 22
 May 2025 16:37:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 16:37:24 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250522233733.3176144-1-seanjc@google.com>
Subject: [PATCH v3 0/8] x86, KVM: Optimize SEV cache flushing
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, Kevin Loughlin <kevinloughlin@google.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Kai Huang <kai.huang@intel.com>, 
	Ingo Molnar <mingo@kernel.org>, Zheyun Shen <szy0127@sjtu.edu.cn>, 
	Mingwei Zhang <mizhang@google.com>, Francesco Lavra <francescolavra.fl@gmail.com>
Content-Type: text/plain; charset="UTF-8"

This is the combination of Kevin's WBNOINVD series[1] with Zheyun's targeted
flushing series[2].  The combined goal is to use WBNOINVD instead of WBINVD
when doing cached maintenance to prevent data corruption due to C-bit aliasing,
and to reduce the number of cache invalidations by only performing flushes on
CPUs that have entered the relevant VM since the last cache flush.

All of the non-KVM patches are frontloaded and based on v6.15-rc7, so that
they can go through the tip tree (in a stable branch, please :-) ).

v3:
 - Move the non-KVM patches to the front. [Ingo]
 - Add comments to document WBINVD vs. WBNOINVD. [Ingo]
 - Collect acks/reviews. [Ingo, Tom]
 - Rename xx_wbinvd_on_many_cpus() to xx_on_cpus_mask(). [Ingo]
 - Fix a repeated "be" in a comment. [Francesco]

v2:
 - https://lore.kernel.org/all/20250516212833.2544737-1-seanjc@google.com
 - Add a missing -ENOMEM in __sev_guest_init(). [Tom]
 - Collect reviews. [Kai, Tom]
 - Fix stub prototypes. [Zheyun]
 - Kill off dead pr_err() code on DRM's wbinvd_on_all_cpus() usage.

v1: https://lore.kernel.org/all/20250227014858.3244505-1-seanjc@google.com

[1] https://lore.kernel.org/all/20250201000259.3289143-1-kevinloughlin@google.com
[2] https://lore.kernel.org/all/20250128015345.7929-1-szy0127@sjtu.edu.cn

Kevin Loughlin (2):
  x86, lib: Add WBNOINVD helper functions
  KVM: SEV: Prefer WBNOINVD over WBINVD for cache maintenance efficiency

Sean Christopherson (3):
  drm/gpu: Remove dead checks on wbinvd_on_all_cpus()'s return value
  x86, lib: Drop the unused return value from wbinvd_on_all_cpus()
  KVM: x86: Use wbinvd_on_cpu() instead of an open-coded equivalent

Zheyun Shen (3):
  x86, lib: Add wbinvd and wbnoinvd helpers to target multiple CPUs
  KVM: SVM: Remove wbinvd in sev_vm_destroy()
  KVM: SVM: Flush cache only on CPUs running SEV guest

 arch/x86/include/asm/smp.h           | 23 +++++++-
 arch/x86/include/asm/special_insns.h | 32 ++++++++++-
 arch/x86/kvm/svm/sev.c               | 85 +++++++++++++++++++---------
 arch/x86/kvm/svm/svm.h               |  1 +
 arch/x86/kvm/x86.c                   | 11 +---
 arch/x86/lib/cache-smp.c             | 26 ++++++++-
 drivers/gpu/drm/drm_cache.c          |  9 +--
 7 files changed, 140 insertions(+), 47 deletions(-)


base-commit: a5806cd506af5a7c19bcd596e4708b5c464bfd21
-- 
2.49.0.1151.ga128411c76-goog


