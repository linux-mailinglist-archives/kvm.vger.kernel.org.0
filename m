Return-Path: <kvm+bounces-39949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8155EA4D100
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 02:34:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F413118921B5
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 01:34:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F249B155CBD;
	Tue,  4 Mar 2025 01:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pQln1YOB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A179114F121
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 01:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741052021; cv=none; b=Jltj8ktl8DVrdFzmUNVKxqFChQIgHV8BshqD/Bkq4Kczb4cJ+KMIN7cqlYUpPLyhRwbiGnkz1BzwJ2w5A0W//TSRIfS3PdSMcwVlp+/QuJ0riJUHf7RfJ74mb03ln4cZDmbMxdpKcHwmtdT3+wd1qxg3VrBzuuRtM8v7seIOvH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741052021; c=relaxed/simple;
	bh=SIl8ho5t9EI4LTWKJyqZ5Q0RNUveM8TTZXpUMKr3JMs=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=JYZ8vXB4QXdu/ZrU5J0ocmV+IGLDPWdYUbEpdlqPbl0JtUgWFmcNraawd7mYFyIiCvXSKpoU+CCbiHjafIX8F0E4CBQJ7H2SPeGpX2tJ2S1accan7QXzd58MtP9aznx2RhWyPgdW2fhUmbRSovg5yni6OOAWdbwKmI67x6yZW+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pQln1YOB; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fecd603bb8so5661655a91.3
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 17:33:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741052019; x=1741656819; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ucq5/Kd4TvXDiuBl3Q8d5rnG9vbnh5K6yq9XVdM4wcE=;
        b=pQln1YOB5jlDl6iZ5o4p8C+V5ZWTaOltr091R7bFravLgWskdfGJdhuonW4fZ5OdLT
         8HKuvKzt2QhtKZv63TgN+tGgVKqUruBwxZpc/RvJmiBnrWXz2DIBG7o0aJpSyLj4Hd3i
         wupn5OaivhbcbzHz7i0jDoqMvsVuxZfVkWkZKAj20mtaYF29L7ri+XCtyAbLRvqOFGzv
         04U+3BzHhjqiJ6HcASjrY5/W4ioBQpAwZHwgG+nXLy4zWF8C/FzOZXkrQtRz0T24H0gf
         FLiV7dpsB2GtXBXMwlnlEbXIie632Sp9fYJ7taKKUf78YOtRJPA2DmYypME75YjwxwqQ
         3Enw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741052019; x=1741656819;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ucq5/Kd4TvXDiuBl3Q8d5rnG9vbnh5K6yq9XVdM4wcE=;
        b=iyiOEgZEAWHe+Zpb22i2jok6DqgKTyYdyEM6j5OJ5TfH1GptFatIkElPtBW6Za2kYy
         KY1VrlUjRMgVr8wUCr1Yac9a+AnqCgOsVmTPtenWSvPFSCBUCD7xHcD2WuagVMAARyRm
         A93YMiO2ZDtuCfMEJMg5mNbv23fU6N6B2dF8UV0Sr3gF2yBqdUi+VNntjBpHfwgGZjGA
         SOXgjHf6MkbCuJvwmxZu8lVNy8mfgyDdlJmIS5EjFxY44zHALgqz2uFOAz7uPbSBSyzW
         d3E5EA7Nn/eP91Cvq55LMyWPrj5QIHLOI3C4X7O0UI6/aAC1uju4cxhVfpRXWs+iq33p
         /0gw==
X-Gm-Message-State: AOJu0YxWElAYiV+hDpSwbyt8BBcse2WbFa6eoDOmkYdrHMi7d9Uxyl6K
	HUzr6PoY8jwkmmcuUH2r2HQ73HPADrx/JVpePR4MLY/LaHtc7Y4orQFR3WtAO8sDu8Eyw/t30Lh
	pWQ==
X-Google-Smtp-Source: AGHT+IEpHqEHsE2O9LE/UQmqGjjKfdFVaaCLQ3xRW5HZAI9zSYi8OXdvnTjdYVeBp8F7ytBDsguC8d+OIyY=
X-Received: from pjbsu16.prod.google.com ([2002:a17:90b:5350:b0:2fa:24c5:36e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:390b:b0:2ee:8e75:4aeb
 with SMTP id 98e67ed59e1d1-2febab7864bmr28054444a91.17.1741052018927; Mon, 03
 Mar 2025 17:33:38 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon,  3 Mar 2025 17:33:32 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250304013335.4155703-1-seanjc@google.com>
Subject: [PATCH v5 0/3] KVM: x86: Optimize "stale" EOI bitmap exiting
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>, xuyun <xuyun_xy.xy@linux.alibaba.com>, 
	weizijie <zijie.wei@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"

Slightly modified version of the patch (now mini-series) to optimize EOI
bitmap exiting for "stale" routes, i.e. for the case where a vCPU has an
in-flight IRQ when the routing changes, and needs one final EOI exit to
deassert the IRQ.

Kai, I dropped your Reviewed-by as the change was non-trivial.

v5:
 - Intercept EOI if and only if the IRQ is level-triggered.
 - Add helper to consolidate logic.
 - Tweak field name.
 - "Reset" field to -1, immediately before scanning routes.

v4: https://lore.kernel.org/all/20250303052227.523411-1-zijie.wei@linux.alibaba.com

Sean Christopherson (2):
  KVM: x86: Isolate edge vs. level check in userspace I/O APIC route
    scanning
  KVM: x86: Add a helper to deduplicate I/O APIC EOI interception logic

weizijie (1):
  KVM: x86: Rescan I/O APIC routes after EOI interception for old
    routing

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/ioapic.c           |  7 ++-----
 arch/x86/kvm/ioapic.h           |  2 ++
 arch/x86/kvm/irq_comm.c         | 37 ++++++++++++++++++++++++++++-----
 arch/x86/kvm/lapic.c            |  8 +++++++
 arch/x86/kvm/x86.c              |  1 +
 6 files changed, 46 insertions(+), 10 deletions(-)


base-commit: ead22377189e55ba0e9b637a8f48578cf84f5b9c
-- 
2.48.1.711.g2feabab25a-goog


