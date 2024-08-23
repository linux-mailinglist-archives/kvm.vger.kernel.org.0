Return-Path: <kvm+bounces-24929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4191C95D4C4
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 19:58:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0AF828456D
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 17:58:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3121C191495;
	Fri, 23 Aug 2024 17:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fl2+xEKc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED07718DF81
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 17:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724435927; cv=none; b=Aayf4sLOKwbfhEnzS/iNZDh7KGwFq6+1tax/I579EF4tAuN9HHSWNH8IDZgBz9dXAJXljfDnejYXsxWv1Po0bg7D3o1qQZ96SAsoNN15FqSKtawmDiBcWtX2C0fUX6xFDwaqgCAZgD2sjbFy3CmQoMGtV5vsQYk5mBuxbCY+P8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724435927; c=relaxed/simple;
	bh=ZrBbX4IAY4APFGl+VtF/V7zyXDLhlwab546mwGx9K9Y=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=WhCRqAzqPjApKdw8dOINnoOxwTSvFFgjt/n1ny4YzDI6sMQ8noOIOxhvCdDG/m85SKQfOAktRSDknDhwtPvr1Y2Ntiscol1ZFFm+HPSO1X7zXtHLXw+DCiN9ivvnG8WBzblGoYUfzKhEuHsztiHytFXXVZCx1JAJ1o6so+uOqE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fl2+xEKc; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e13c4519ed6so4258637276.0
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 10:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724435925; x=1725040725; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aovTDxABZxi5GG8qaMnBrDvsDUlH3vVl2BH7R8uieXQ=;
        b=fl2+xEKcz5gHXa0g/rPOQheQvZCN3abWVMUq3r0y323yv4eRz3BR+q5kGfB3nH3X9u
         520Fu6fgE4ivfRkgf2UUFQCsH96V/XkJVERULKKO8x10UtODjWA+UCEfO2uwuSd7YfgU
         uhhmj8beUF4g3NrsTW15rD72kS53NqV78FV25ByAD6Pipc7UDtcTiGloebOL78q+jSgD
         7/3ylpQdAMiCETVFaFtp/LRPA1Ip2ET1x9f69/T69tuWqWqOM5ln982+73/nu5z9MFZ1
         J+bHp90LGbxORAYtr6q/DoucWv9qlMbrdYy7ciKzOs/IaQm7LWYnTY016jWUdy0Z4zdW
         7NUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724435925; x=1725040725;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aovTDxABZxi5GG8qaMnBrDvsDUlH3vVl2BH7R8uieXQ=;
        b=o4jsfSCegNJGXVrizJao1Un4QaiHQR81pneHrF9VqAbhsVUVKDT19M6poVTSriyZvj
         4XhDlXpO26NC9SeoRvWzBz/pW02XqZGAEx/PyU7W3E3BcHBycIjVAgJxYmn9t8oC1id4
         67aKuX+W6HdKR0O5K0mal9A6RtNMEI0IIL5+c8DZmib5CIUXWL3lIIsKq3M76sARZj1k
         urVtrY5O6MAagdpfSH2m54j1+0R5iMIW4lPs6WsmXIE0YhLz57xxVKar3ei8ZobnE6/c
         3Z+l2//fvkKgs1oroxOtiDShuEXEmPtgcNd6X+GDACLXZ2PtK4c2DwRVvxXKJ5Csh35h
         IBQg==
X-Gm-Message-State: AOJu0Yyjj5emnTPu0OxFxp+h2YMmqxupVXGQjK4HkepfUxxloK699vz0
	R0OsBZvTO8aTxjbuGqcN3f13qje5k7oPlpiI1LljbKo20FR096KwDYDeHaTNXERgh54FREKMxFo
	N2tSsw2ur1ws7nTTUUL9m7nnMyZsKFTTGeA4LLtBT3Bk480ae9b+qxumj+wAN+UgyujYBToO7EI
	qTIjZ/JnrfH8gLcuDD1xH8+AUZBBvChtLT689U7Tfko5G/+9d6OUMjqyY=
X-Google-Smtp-Source: AGHT+IFkyrdr/hjrrx1tXoTdyF02S4q2EiffbkYrsjU0HOMNyW6r1dKVSMDu0Wi5zJ/x2shxCnGRhHN1Em9j20Elhg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:7403:0:b0:e0b:df3f:7def with SMTP
 id 3f1490d57ef6-e176779f742mr80329276.2.1724435924660; Fri, 23 Aug 2024
 10:58:44 -0700 (PDT)
Date: Fri, 23 Aug 2024 17:58:34 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240823175836.2798235-1-coltonlewis@google.com>
Subject: [PATCH v6 0/2] Add arch_timer_edge_cases selftest
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ricardo Koller <ricarkol@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, kvmarm@lists.linux.dev, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Add arch_timer_edge_cases selftest to test various corner cases of the
ARM timers such as:

* timers above the max TVAL value
* timers in the past
* moving counters ahead and behind pending timers
* reprogramming timers
* timers fired multiple times
* masking/unmasking using the timer control mask

These are intentionally unusual scenarios to stress compliance with
the arm architecture.

v6:
* Remove unused headers
* Declare const variables as static
* Clarify by using INT32_{MIN,MAX}
* Remove silly enum magic value
* Instead of commenting a function should be called with IRQs disabled,
  just disable them in function
* Remove unnecessary loop in test_reprogram_timers()
* Lift some invariant assignments out of loops
* Add some comments around better explaining wm() (irq_wait_method)
  functions
* Fix typos

v5:
https://lore.kernel.org/all/20240809183802.3572177-1-coltonlewis@google.com/

v4:
https://lore.kernel.org/kvmarm/20240307183907.1184775-1-coltonlewis@google.com/

v3:
https://lore.kernel.org/kvmarm/20231103192915.2209393-1-coltonlewis@google.com/

v2:
https://lore.kernel.org/kvmarm/20230928210201.1310536-1-coltonlewis@google.com/

v1:
https://lore.kernel.org/kvm/20230516213731.387132-1-coltonlewis@google.com/

Colton Lewis (2):
  KVM: selftests: Ensure pending interrupts are handled in arch_timer
    test
  KVM: arm64: selftests: Add arch_timer_edge_cases selftest

 tools/testing/selftests/kvm/Makefile          |    1 +
 .../kvm/aarch64/arch_timer_edge_cases.c       | 1062 +++++++++++++++++
 .../testing/selftests/kvm/aarch64/vgic_irq.c  |   11 +-
 .../kvm/include/aarch64/arch_timer.h          |   18 +-
 .../selftests/kvm/include/aarch64/processor.h |    3 +
 .../selftests/kvm/lib/aarch64/processor.c     |    6 +
 6 files changed, 1094 insertions(+), 7 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c

--
2.46.0.295.g3b9ea8a38a-goog

