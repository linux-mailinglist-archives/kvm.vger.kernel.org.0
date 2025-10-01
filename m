Return-Path: <kvm+bounces-59242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id E94CABAF92E
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 10:21:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9B8B44E1A9B
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 08:21:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7888627D771;
	Wed,  1 Oct 2025 08:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dHbEIOyt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com [209.85.221.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E9E19DF4F
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 08:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759306893; cv=none; b=PBeACmaEm/hxktkuy/lbrNliuAeoUntdhBsNl6YytJBzw1CM1XIPT62BDLDtlEwhQiWbhltenPVesxam4aYRB8kFxne0HskJRNXmwE4zJ9CGWcBF4+wm0VgcRN4OXjbU/xh8zsl8As6h/A/uBtZamLoxiO+CuRTIuR3Y1mPC2Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759306893; c=relaxed/simple;
	bh=GQc+UN5FthX5dgvHGCUoBL/3QCykQk14VbR13XAGTus=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Nq9ta80LBrafgZ5hn0I26ZwhSGat1Npk2T2Am/yErsB26NNloUC2Zdp3FXdcLayMlbrTpN9dIUASdl3vnxixF3EJ/mKTgZQpuut2QEnbyhsQtHE7fbXvUupCNgALTTJ5CzhADWyKHA3FBhcVWQxT9dNVE8Fu+gy63MOhLYv+7MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dHbEIOyt; arc=none smtp.client-ip=209.85.221.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f66.google.com with SMTP id ffacd0b85a97d-3f0ae439b56so3951734f8f.3
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 01:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759306890; x=1759911690; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UYQLfS3wHinTh/qC50pdHFAAD2+v7Vtk7mze5MUxp5E=;
        b=dHbEIOytZdO8Kta5T2p19b+r59dOY81ZMckdgtjkc+Q0TdxDJ8RAfD9DeLL3rHLiZx
         HgWWDvY+Pf/pBPQsDidqUXcK1vjMIxneFisO738F9cG2vstOeeTWLIkSqMWJcGUfl7vd
         s3qnDZvlREnUGL2B67kJUHxC33oMNTC4pNCWgswBK4UTAhpOQz1OQJnfmVPgYRIvcduL
         fr4I4fURkyesnxzE99CqU2Y/oqf5NVJ9YjntzmHTU5UGwAz/QUQehaQFhA1eYn6kDw9p
         PTQPiICvAm2Cw09pMsXLAeSKSbkSIo2ZMUbymMnPjY6zyU9iK0QbF3TgVVoqRr7K7yTk
         u23w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759306890; x=1759911690;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UYQLfS3wHinTh/qC50pdHFAAD2+v7Vtk7mze5MUxp5E=;
        b=g3EKqyoGZYMXv6andX5epox8acW3f5WRrWNPgiWZwZPUH3k2ccDeRHIX/yi2iFXL2M
         ei9VKQoVy9EVgfIel4nLxa75qyAgaWqu/5870NS6lMJj1yczQgORKqtARqUlDxGn7xy8
         tnGH7fjYS5VXhEa5P2CWAjNJ78x0itP6LM+sJWQr/Hxyo/gRSKRjY3VWq860Uqp5id0s
         cTm2FN+4wOIN0Vq7iWxDJuZvVTBLQClG0+l2cI51sEnCySD+XFJDvm/f+P8OymEqyAY8
         xm3feM0jmLhYKriUuadKN6C19U69N8xEo1JhYHY2S2MEpQ8Lo8fTarLlNtSJdTGkPGbE
         wVDQ==
X-Forwarded-Encrypted: i=1; AJvYcCUW0IpmYMAMzXBTd1wlbOblIuJQbpFNeaHWeQreo0VlwS0wvyp18fPyxqWhZkdgyFFkSoc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKYRCJWpzQu7h4pEwPHeWmmTIaJt3xjeAerVscKRLmoZ5tBQJa
	/lGaqw+u4leZnCXKsIEohlGhqIpg1oBbdKntEfkfslMPWwlc5cprInI0z925fZkWMso=
X-Gm-Gg: ASbGnctI83xNB9W6HMThZvIwiR5GgCjJBGC+eVzYudTBuAswKTzuzr8PB1wXsP0hGsV
	+JKi/ZT7Qb//vxY6gsa+j5+eYZzZEAFwT7ZL1XKSLduFM/yMm4Mz3IdzLOMcxkxZSZW2Xt003Lg
	lL73ItFAEtBlmAPK1YTQrckZZNIAKPAhSMTq5QMiqIxAvPHZaGvsFhOiyi+1L/SN8fYBCN0l+CM
	K8YlYr/SUC5B0twXHs01dBSaQgfMjVYRNskdEboOkH94UVpyCH7I3wtuvqybiOV/ENR1yvXEQq2
	a0yH8e5cW5nkijKdrvBSaCM/jRXqLVU8TVyHbJ2m16+UwyaYK59/J6cB62Kx6mDUMT2JC4MHd6F
	VT7idoFTlq1CgFswJ45IOconMJYC2u/RyWCS/fLlZ00VMo0PgR0DPrL6YsYfxw39g/muD/6Szc5
	BU6skEj91eZ9eZok6aBxPV
X-Google-Smtp-Source: AGHT+IHKt/ivTsoC6PZcZTjZzL5LDs95xiGR88ZSKusdRALPX64xSrvTFt9lt4nGAnJGd8G2pFxftQ==
X-Received: by 2002:a05:6000:310d:b0:3ee:af89:a68 with SMTP id ffacd0b85a97d-425577f321dmr1791557f8f.22.1759306889640;
        Wed, 01 Oct 2025 01:21:29 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc8aa0078sm25842872f8f.59.2025.10.01.01.21.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 01:21:29 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	qemu-arm@nongnu.org,
	Jagannathan Raman <jag.raman@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Halil Pasic <pasic@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	kvm@vger.kernel.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	qemu-ppc@nongnu.org,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Fabiano Rosas <farosas@suse.de>,
	Richard Henderson <richard.henderson@linaro.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-s390x@nongnu.org,
	Peter Xu <peterx@redhat.com>
Subject: [PATCH 00/25] system/physmem: Extract API out of 'system/ram_addr.h' header
Date: Wed,  1 Oct 2025 10:21:00 +0200
Message-ID: <20251001082127.65741-1-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Following a previous comment from Richard in [*],
reduce "system/ram_addr.h" size by un-inlining a
lot of huge functions that aren't really justified,
and extract the API to the hew "system/physmem.h"
header, after renaming the functions (removing the
confusing 'cpu_' prefix).

(I plan to eventually merge this myself due to the
likelyness of conflicts).

[*] https://lore.kernel.org/qemu-devel/9151205a-13d3-401e-b403-f9195cdb1a45@linaro.org/

Philippe Mathieu-Daudé (25):
  system/ram_addr: Remove unnecessary 'exec/cpu-common.h' header
  accel/kvm: Include missing 'exec/target_page.h' header
  hw/s390x/s390-stattrib: Include missing 'exec/target_page.h' header
  hw/vfio/listener: Include missing 'exec/target_page.h' header
  target/arm/tcg/mte: Include missing 'exec/target_page.h' header
  hw: Remove unnecessary 'system/ram_addr.h' header
  accel/tcg: Document rcu_read_lock is held when calling
    tlb_reset_dirty()
  accel/tcg: Rename @start argument of tlb_reset_dirty*()
  system/physmem: Rename @start argument of physical_memory_get_dirty()
  system/physmem: Un-inline cpu_physical_memory_get_dirty_flag()
  system/physmem: Un-inline cpu_physical_memory_is_clean()
  system/physmem: Rename @start argument of physical_memory_all_dirty()
  system/physmem: Rename @start argument of physical_memory_range*()
  system/physmem: Un-inline cpu_physical_memory_range_includes_clean()
  system/physmem: Un-inline cpu_physical_memory_set_dirty_flag()
  system/physmem: Rename @start argument of physical_memory_*range()
  system/physmem: Un-inline cpu_physical_memory_set_dirty_range()
  system/physmem: Un-inline cpu_physical_memory_set_dirty_lebitmap()
  system/physmem: Rename @start argument of physmem_dirty_bits_cleared()
  system/physmem: Un-inline cpu_physical_memory_dirty_bits_cleared()
  system/physmem: Rename @start argument of
    physmem_test_and_clear_dirty()
  system/physmem: Reduce cpu_physical_memory_clear_dirty_range() scope
  system/physmem: Reduce cpu_physical_memory_sync_dirty_bitmap() scope
  system/physmem: Drop 'cpu_' prefix in Physical Memory API
  system/physmem: Extract API out of 'system/ram_addr.h' header

 MAINTAINERS                       |   1 +
 include/exec/cputlb.h             |   5 +-
 include/system/physmem.h          |  56 ++++
 include/system/ram_addr.h         | 413 ------------------------------
 accel/kvm/kvm-all.c               |   5 +-
 accel/tcg/cputlb.c                |  19 +-
 hw/ppc/spapr.c                    |   1 -
 hw/ppc/spapr_caps.c               |   1 -
 hw/ppc/spapr_pci.c                |   1 -
 hw/remote/memory.c                |   1 -
 hw/remote/proxy-memory-listener.c |   1 -
 hw/s390x/s390-stattrib-kvm.c      |   2 +-
 hw/s390x/s390-stattrib.c          |   2 +-
 hw/s390x/s390-virtio-ccw.c        |   1 -
 hw/vfio/container-legacy.c        |  10 +-
 hw/vfio/container.c               |   5 +-
 hw/vfio/listener.c                |   2 +-
 hw/vfio/spapr.c                   |   1 -
 hw/virtio/virtio-mem.c            |   1 -
 migration/ram.c                   |  79 +++++-
 system/memory.c                   |   9 +-
 system/physmem.c                  | 342 +++++++++++++++++++++++--
 target/arm/tcg/mte_helper.c       |   5 +-
 system/memory_ldst.c.inc          |   2 +-
 tests/tsan/ignore.tsan            |   4 +-
 25 files changed, 495 insertions(+), 474 deletions(-)
 create mode 100644 include/system/physmem.h

-- 
2.51.0


