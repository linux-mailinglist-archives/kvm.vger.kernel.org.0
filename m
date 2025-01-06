Return-Path: <kvm+bounces-34631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F1E0CA03103
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 21:03:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D56B9161783
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 20:03:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E84881DF24B;
	Mon,  6 Jan 2025 20:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Pbh92jEU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366271DD9A6
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 20:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736193787; cv=none; b=mmGifAMuP3gqGWRmzSVVKZDkzc07uEGKHmadNTPyLBMNnov1on7yNvFp+A65+e97Yu9GyVN9+pooDWj2vqOL59rjvznEhdZlJthrmy4HToJZXi+LhWaBfP5Ztq6CcPsbIWJP5bFcnAMfRMSSB0cpGqw0PJNO/boTmaeJkEsTolI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736193787; c=relaxed/simple;
	bh=BNHpS4glZyoiXUMHz6FKIlmB1PYCsfVOgxZrMXfj3Ms=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=g9Q/SixpJkgMpgCIZ6t/am1NdDUY6zeih7kDLrwCVTn/Tn/umSQK/ar9wOD3inCVWfcYoqwzWgTXMvbnkJBwi6tNwJOJOKP0DnUeng22ChlijrSGbd21UbWI2Jwhiv7A9UgmC7JwB7bA/SbrMMGX5AgU6AAmhq8pvCSFXiUPOgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Pbh92jEU; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-436281c8a38so105989715e9.3
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 12:03:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736193783; x=1736798583; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IVQDyU0aZGqnbGo58WYklNw0MeL8aFrKkG5Vri/XHzI=;
        b=Pbh92jEUeUYTsixLKUpcvfQeib7I8BSrZZ7YVeR4Jc5AwD/8ZatcatrLUjJgwB0KvV
         5eWuGVRGJpJwxkZe5AQuNKtpLhsi7VCtN7lNDAaZAKE8lVhCN9SMapkna8Atun4Dolst
         qs+RSegHvNNTunkT5wWcYdrYn+5Jltqv4PWLzPsyh0OWV13GEDGqvutSpnUG7BcG9EIY
         CAfrkRGspBd8Az8ImUl1547TQaG+DIGZ9UvA4u4X8Gdbc9YJuQpDKBmjNrrhKZz/0lUa
         bs9I4LWUK5j36W5wnXl0hxmSc7vDDPq8FiOi/ZRAPAX4Z7OjdJHZMyxBvUQ1Rbg7DtPT
         5c5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736193783; x=1736798583;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IVQDyU0aZGqnbGo58WYklNw0MeL8aFrKkG5Vri/XHzI=;
        b=ONCncTSkl8/Zl0MJzhy8IZpN4biashC8O1wFCtrlmf0cSAPusTp3ATQVJ3nfLvoUmM
         DmKVbL69km9nPqGCB7EC/MZOIXWGrDUcalOhXTnSxbrSBoRGhXm7o5Q6XPiYA/nYDQjj
         L4W40hM8mkvsS4cFoQnhpXFUodIqUnivvYg3K9q0cbP5jbqw+bXiPqkFdHesxCAmc/Zf
         ufsW+pwTB+x6jgXZP9JoRqRelSYAXivEHFG0UYpCr0ccUlAC8lPeuvQ5nR2RFOYUkzeM
         5Ma0VDPxSD9WwzLpw4ienvdIer0sNCBevD1lLNfEoCdJsMR0c5Sn3xkYgGFvBPljwRvk
         QQuQ==
X-Forwarded-Encrypted: i=1; AJvYcCVi3R7nnVPNm/3p3puQk6ii4tjUdc/UT2a75nj6Y8WPzj4y7uf4Fbj0oyWVQfX2Pr8SxJ8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxp8l/3sCRBXpiKq1qqiypmDp5A1jJmt5BGJYivar1zWYFC5BE/
	Ww1so4Zgz0S9R0UCjZktZDoqqi3pYPpTZtT0fFhYHWo9u5D0x/EPwojrAy3AaTE=
X-Gm-Gg: ASbGncupAQS/uT8boZTJgEDdQqjp1cQ5FyranbR60+gUP/QvDyXqcQyWUx3TzLS+5mZ
	d075qshguYTG/BTrRVTI9k0ZIAXSUcekrKT033Binn68n3p2zhbKnKfytUjopzaUEclyuLBlRUb
	FqtmWzyYKaNMNiw8fZoLHgx7+kM4UNgmw2POSz99Mzt/FTMkdcKk8MCRXgsuSYPbjE0LevQvpM0
	LCiJZ9wiY3og60N8+IrFgyBDd2HkndPsLCrXwN3m3Q/iK1DCDD1lRC1QgX3eyBfN8XXqER4dcas
	XLnJGX6XVmsqzVvsBN37SZLX1tx+HKw=
X-Google-Smtp-Source: AGHT+IEvY1dOIYQWFga9MrJsSFG0JoKzIh1x57mMzgTfD/hBdAZ0c+WqLtNl81G5solsww92cOjYAA==
X-Received: by 2002:a05:600c:450f:b0:434:fb65:ebbb with SMTP id 5b1f17b1804b1-436686461cbmr539399575e9.17.1736193783280;
        Mon, 06 Jan 2025 12:03:03 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43656b3b2a4sm611962245e9.27.2025.01.06.12.02.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Jan 2025 12:03:01 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Barrat?= <fbarrat@linux.ibm.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Cameron Esfahani <dirty@apple.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Alexander Graf <agraf@csgraf.de>,
	Paul Durrant <paul@xen.org>,
	David Hildenbrand <david@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	xen-devel@lists.xenproject.org,
	qemu-arm@nongnu.org,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	qemu-s390x@nongnu.org,
	Riku Voipio <riku.voipio@iki.fi>,
	Anthony PERARD <anthony@xenproject.org>,
	Alistair Francis <alistair.francis@wdc.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	"Edgar E . Iglesias" <edgar.iglesias@amd.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	David Woodhouse <dwmw2@infradead.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	qemu-ppc@nongnu.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Anton Johansson <anjo@rev.ng>
Subject: [RFC PATCH 0/7] accel: Add per-accelerator vCPUs queue
Date: Mon,  6 Jan 2025 21:02:51 +0100
Message-ID: <20250106200258.37008-1-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Hi,

Currently we register all vCPUs to the global 'cpus_queue' queue,
however we can not discriminate per accelerator or per target
architecture (which might happen in a soon future).

This series tries to add an accelerator discriminator, so
accelerator specific code can iterate on its own vCPUs. This
is required to run a pair of HW + SW accelerators like the
(HVF, TCG) or (KVM, TCG) combinations. Otherwise, i.e. the
HVF core code could iterate on TCG vCPUs...
To keep it simple and not refactor heavily the code base,
we introduce the CPU_FOREACH_TCG/HVF/KVM() macros, only
defined for each accelerator.

This is just a RFC to get some thoughts whether this is
heading in the correct direction or not ;)

Regards,

Phil.

Philippe Mathieu-Daudé (7):
  cpus: Restrict CPU_FOREACH_SAFE() to user emulation
  cpus: Introduce AccelOpsClass::get_cpus_queue()
  accel/tcg: Implement tcg_get_cpus_queue()
  accel/tcg: Use CPU_FOREACH_TCG()
  accel/hw: Implement hw_accel_get_cpus_queue()
  accel/hvf: Use CPU_FOREACH_HVF()
  accel/kvm: Use CPU_FOREACH_KVM()

 accel/tcg/tcg-accel-ops.h         | 10 ++++++++++
 include/hw/core/cpu.h             | 11 +++++++++++
 include/system/accel-ops.h        |  6 ++++++
 include/system/hvf_int.h          |  4 ++++
 include/system/hw_accel.h         |  9 +++++++++
 include/system/kvm_int.h          |  3 +++
 accel/accel-system.c              |  8 ++++++++
 accel/hvf/hvf-accel-ops.c         |  9 +++++----
 accel/kvm/kvm-accel-ops.c         |  1 +
 accel/kvm/kvm-all.c               | 14 +++++++-------
 accel/tcg/cputlb.c                |  7 ++++---
 accel/tcg/monitor.c               |  3 ++-
 accel/tcg/tb-maint.c              |  7 ++++---
 accel/tcg/tcg-accel-ops-rr.c      | 10 +++++-----
 accel/tcg/tcg-accel-ops.c         | 16 ++++++++++++----
 accel/tcg/user-exec-stub.c        |  5 +++++
 accel/xen/xen-all.c               |  1 +
 cpu-common.c                      | 10 ++++++++++
 hw/i386/kvm/clock.c               |  3 ++-
 hw/intc/spapr_xive_kvm.c          |  5 +++--
 hw/intc/xics_kvm.c                |  5 +++--
 system/cpus.c                     |  5 +++++
 target/arm/hvf/hvf.c              |  4 ++--
 target/i386/kvm/kvm.c             |  4 ++--
 target/i386/kvm/xen-emu.c         |  2 +-
 target/i386/nvmm/nvmm-accel-ops.c |  1 +
 target/i386/whpx/whpx-accel-ops.c |  1 +
 target/s390x/kvm/kvm.c            |  2 +-
 target/s390x/kvm/stsi-topology.c  |  3 ++-
 29 files changed, 130 insertions(+), 39 deletions(-)

-- 
2.47.1


