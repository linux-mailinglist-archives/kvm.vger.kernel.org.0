Return-Path: <kvm+bounces-60495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A61BBF0975
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 12:39:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3EA733B490A
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 10:38:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39CFA2F6173;
	Mon, 20 Oct 2025 10:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mISwqSDF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C6025B30E
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 10:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760956701; cv=none; b=eC99TKh6/dOqPnGzX8Rn4el6p82K8nANhx+GlVDNo9gmrD9PtncUU/eTf9TBSOkUSokGDOiRrE5v/h5IuXpoc5uCwVKBq8OZdj80p+st2ALBD8nZLynDV1o9tdTkJEo171Q1Dnl0+G0f5z1sWIt7yRwqd8hLKRGt1R59QothJT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760956701; c=relaxed/simple;
	bh=/4EM1tdcLVfOuDGQn+34XWkmIrBbo4TxWZkZ+WeZSOo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ASNGiOT5Obvcm1PP8U5gx2DzlpN3dGCFK3u84/DUE2q+cYAtPhKOS5ZCbTKLp5D72HW6ny9o7BUVQgyF9ZGJiNJ3xoImIFwgNrmtWwuvNhNh2a9TWAwiDfaGIfJ0ES4t3X85r8+SjcLlnWZjpM3NmdsI60mir07zSX2PAKd4II8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mISwqSDF; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3ee15b5435bso4346025f8f.0
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 03:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760956697; x=1761561497; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SXVYYZzATC/E68BfF5OyOxwIvYVntwCirLZoygFZ/oU=;
        b=mISwqSDFqlKfqNfim8fXDzfaEDy5hOXWsLimvvqjFghLXvrLyvrp4Mqm0uCc9gjq3t
         Lz8dsldXS2c1jzQuVzRsMicHPeCJyjbFTkUokoZ2fzSkI95L5NXhbf6lMeWkM/SJRk+M
         8vv1lnOTOF46229KxPIdIeXdBcdbWstKkCvW3Rj7oOdWSRJli77bD7xqVu1dlgeHAzB9
         ndBeYaw7Q+qvMuk5rT+TrtdzZ7TurK16EzeOP65NzNiNePMzNkYy+O8lCoorQGKyT/XR
         i7iddKPTUCvnlLtNtIDBP+n+vMOExtt4JQsOfvoLFmSNTHakyRpxQTyOeJuQEnTOSAQ6
         1DVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760956698; x=1761561498;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SXVYYZzATC/E68BfF5OyOxwIvYVntwCirLZoygFZ/oU=;
        b=RJKt4V5XCUbizMHnqwK/NgaUcRNl3Th86RAlcohy3YrFawol4UzBrdLToJldn344qP
         U+GU6Uunanwoqw5ttAv1ssPeZSMfvILvJ9qTEV/K6EYeQs3Qz9IGaDOnwVRd1xJQCaU3
         MtOzkDoV1pWTEz9v2EUDOi+Hih4S0Q3+DvoIva7N3UJybkC/diLGMEwKCQIdwsZOfzqr
         W0VUf2vwjHjssd8Q5a0CVDZH9QOpo68AtNvYaePB8Ce+2iybwQkIoZT4wVc/jGLtsqrg
         gR05IBFC0Ec2Cym0REjQSxrJeSh/4adTkmRAUpEEE9KRkNbNqkRNZl3iHT2ielQlzWMZ
         RTvg==
X-Forwarded-Encrypted: i=1; AJvYcCUF9R0D0pkOYca9z4n90E94tM4I5Y8VfIoX3w9ZCoXRll/hpZhTFw/vT33eAI9/4JCc8/s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwoBrB8ZTPdJv1cDx0BOiePmu08KTEkEth3KFTZ9un+hMMV9Lhn
	Yqy84wNjREIYpDPEfRAhaFhnwP81Mv1m4HLxCsF62O8ec6/3JqFB19HL5Z2iQh7MLyQ=
X-Gm-Gg: ASbGncsgmR5IUI2BBR/tCEZomdMCG2chNvL4DuNi5H3cXg54Nt8sQjSLENWjTm+gEXj
	PEWiaN8/SNF7yafdvEk8GvEN4RdUnGfi8VDiq7NfLEdtQhHLf1pE/je3TK21chfl0o7ierXyE9p
	B8274kVGF8fmaX0hgBUSYJcyYEmGPFN/n+k+9NKNLBJYxz8w9HZMIKZhj+79Q/HqIwyl0W1qD1F
	keBpIhY2Zedu9StrPvzDlHuyHw4EjDRdT2Ew1F3MTjDBJIn7J4u5yTi1QhEvjozPmIY98UlcCKh
	4j2djCbBj92qH1ltAvuf2VuEHBDkLb9FB/cxER7Lwl5mXTMq94BxB48N74HAt7IFl/WU0yF3xR6
	XJpkuLy7jU18vkaOWEC0Af6gJtv8UDb3lAZSb95lTOSaXumJaoLiXLIjNDQzztNW9VpNNg5tJGi
	pT8RKbGgkON57Y9hzKOzh/p1c1mdEo/G2SaZbvsdAzS6Ihqzou3A==
X-Google-Smtp-Source: AGHT+IEsi0dFkicIb9qfrLx6BzuXKcU/q9Gch4z8m56d2LnefsNIPkEC8bohEE/RQuoCpdMJImcuaQ==
X-Received: by 2002:a05:6000:186d:b0:3ed:e1d8:bd72 with SMTP id ffacd0b85a97d-42704d8d000mr8191167f8f.17.1760956697633;
        Mon, 20 Oct 2025 03:38:17 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f00b985esm15176777f8f.34.2025.10.20.03.38.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 20 Oct 2025 03:38:17 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	qemu-ppc@nongnu.org,
	kvm@vger.kernel.org,
	Chinmay Rath <rathc@linux.ibm.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 00/18] hw/ppc/spapr: Remove deprecated pseries-3.0 -> pseries-4.2 machines
Date: Mon, 20 Oct 2025 12:37:56 +0200
Message-ID: <20251020103815.78415-1-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Remove the deprecated pseries-3.0 up to pseries-4.2 machines,
which are older than 6 years. Remove resulting dead code.

Philippe Mathieu-Daudé (18):
  hw/ppc/spapr: Remove deprecated pseries-3.0 machine
  hw/ppc/spapr: Remove SpaprMachineClass::spapr_irq_xics_legacy field
  hw/ppc/spapr: Remove SpaprMachineClass::legacy_irq_allocation field
  hw/ppc/spapr: Remove SpaprMachineClass::nr_xirqs field
  hw/ppc/spapr: Remove deprecated pseries-3.1 machine
  hw/ppc/spapr: Remove SpaprMachineClass::broken_host_serial_model field
  target/ppc/kvm: Remove kvmppc_get_host_serial() as unused
  target/ppc/kvm: Remove kvmppc_get_host_model() as unused
  hw/ppc/spapr: Remove SpaprMachineClass::dr_phb_enabled field
  hw/ppc/spapr: Remove SpaprMachineClass::update_dt_enabled field
  hw/ppc/spapr: Remove deprecated pseries-4.0 machine
  hw/ppc/spapr: Remove SpaprMachineClass::pre_4_1_migration field
  hw/ppc/spapr: Remove SpaprMachineClass::phb_placement callback
  hw/ppc/spapr: Remove deprecated pseries-4.1 machine
  hw/ppc/spapr: Remove SpaprMachineClass::smp_threads_vsmt field
  hw/ppc/spapr: Remove SpaprMachineClass::linux_pci_probe field
  hw/ppc/spapr: Remove deprecated pseries-4.2 machine
  hw/ppc/spapr: Remove SpaprMachineClass::rma_limit field

 include/hw/ppc/spapr.h     |  16 --
 include/hw/ppc/spapr_irq.h |   1 -
 target/ppc/kvm_ppc.h       |  12 --
 hw/ppc/spapr.c             | 298 ++++++++-----------------------------
 hw/ppc/spapr_caps.c        |   6 -
 hw/ppc/spapr_events.c      |  20 +--
 hw/ppc/spapr_hcall.c       |   5 -
 hw/ppc/spapr_irq.c         |  36 +----
 hw/ppc/spapr_pci.c         |  32 +---
 hw/ppc/spapr_vio.c         |   9 --
 target/ppc/kvm.c           |  11 --
 11 files changed, 75 insertions(+), 371 deletions(-)

-- 
2.51.0


