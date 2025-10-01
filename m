Return-Path: <kvm+bounces-59343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B927BB166C
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 19:55:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A7821942E46
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 17:55:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B82FF279334;
	Wed,  1 Oct 2025 17:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UJ0tfJG9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com [209.85.128.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00CD34BA32
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 17:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759341294; cv=none; b=SnrihxP3+Gcxafc919b8Fn7T+/XIjuYlEthYQ853qEAA3gpR52t9vUuRHNU1wB9aHWhjGLVY94fKf5ZVJgcAdeq484uQ4DLlloo57pVM6GpnlWaOYvFVFiZP3wvW3FlbxXFXm7W6NUMbVXi6kcO0W+ZSceW9S3T65rvBMR+PE40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759341294; c=relaxed/simple;
	bh=Y06aUgRD1LHHlbVbXBLm4mlOzUGzoYn9032a6o5d+1I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=f+fjXZBC84EjLjHT8lJnVV51uo/rTxN+hu+7C9DAcnEYjwwq++uMbN8EcuRrgoNQqt0mgQJ9gBmexmTH9herEivYepD81EBliuGhPS/iqNdw5m/2Tu/N6A3iw2aXYe/lHhJQtnAi5SPldHiHSH2lwnkOiZk4um3xIzIeJ6LQQ2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UJ0tfJG9; arc=none smtp.client-ip=209.85.128.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f67.google.com with SMTP id 5b1f17b1804b1-46e6771c523so501745e9.1
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 10:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759341291; x=1759946091; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MnPdbQAPiABKPnqv3H2yK8f0ztbp+cDIPhAAjXtVdbI=;
        b=UJ0tfJG9ZjaZ2cVPXsk+99cuNwQJY+DaDFo45hlUEJLHe5Mj7K5v167nbcqyFTyPxL
         rKZIaBouEn6aUITsxqZEVYAW5BGynXFSMS8/XEqHNzABQpqCcKoYbi1YE4QKWFHSVUAZ
         fwrl/doc+oyWJUF8WTdAAdlGUwpzO/GQGL/sKFXwIU0U7hkVud3upnA826LkjYfi+XdM
         v34TWbZAJr6xgLNK1ckjBMHlF8aLy2fxjwM2oMya/j0p1TMiV8o+OrKz2CTXhFXSB9Rt
         b4vRhb9QJf0qDjlB4PXRKIptN4od4fjiTvdGbVDGAfidDL4m3fC8B2sr722Ovi8V/yGk
         rhhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759341291; x=1759946091;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MnPdbQAPiABKPnqv3H2yK8f0ztbp+cDIPhAAjXtVdbI=;
        b=d4wTSiQspnD2KpwsBtsctbWKkxVvNu010J2ClyCIFM2uN7/Als+fAQweQONr8qR19a
         X1VbdYLIRqUFzsUJ0YGHJNU5UYyQejfnMA85iADNWlwB2Koams55JwQ2IKYPLMXZAQKJ
         ApDh7Q9ywAULGlrKiJ1A0HI0LS2KX0VQHwnxRnfsVmw3Mn3dnMD1Flnf/GkeIcuU9A3s
         sbvHyceyqYoPk3dubvYjVMzl9DuW1GyQZlyUNYl80YHOHf4ilUwxL8g02rlp4VqexXrl
         JI4eyMokCGLGlumPLd3FYSPsFUYpJ1a5bm9AWg2wrw2lVKtSneBYNM8I+TjT2om7v7sI
         AhWg==
X-Forwarded-Encrypted: i=1; AJvYcCW4A3c7lu82iyG+U35xeek5P8v1Ss6nvY13lSB4ShuHfWUrTyS3aELXnzK7RZ6gXepIcKY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxjap17DX1oKduqCjqSGMcp7prmCzSMzNhyF+HbEVz7Eax1+ZO6
	+3VKwlEPeHIJuL1LzBJncLlfqou4WWmFZIIjKly/f89N0yyTZKaioxp2mHFVyIR5iAQ=
X-Gm-Gg: ASbGnctSBqDgkt+QSEvWK48IFCosnadJTGB4av22kosxyIljzt4SlBsYJ2us5crnvJA
	X7bS89y1Wu2EYOWqLlwkhEJ6Aj8oz88exitR1Z44s6AY4vpOLg/wBIw4iVHwXHpwPf7ToO+vMB/
	vm0HwKISJkiL11T7i+p6PsoDHR4hkwgjVij7KRIHWa0XqjJhmu391tEpOqaEcYJYMy/a5elppau
	3ezDfhQ5L7Rr1mo2KRNwRwH73kOCbfifWl6UZ2eCAn6CdOFHDjx71EOGu8tDBJUpi2zSamwvGOn
	IoOqByRMzqRG8mmmt+myRjBEq+7pzhnQN3RgitIga81Edg3xFB++xm77ID2gVbqguax/Lcl+0R0
	LlO9gZkXM1Vmw/oUqZj7K7Qy5DpK/gDckBBPZ3D5fFJ7gNTOxy8zFeYqo+xND7GArwYtk5GIF5P
	U+LdS2hwwWLgWJ4orUKek6giwS5Q==
X-Google-Smtp-Source: AGHT+IEY+a8HI+AAlq63W8TJ12+BAD5/mJQ/zQWjsLUB6yTTngVUWSOFC3iLDhJTDi6PvB23sT2xjw==
X-Received: by 2002:a05:600c:468f:b0:46e:447d:858e with SMTP id 5b1f17b1804b1-46e612dce3dmr39375945e9.28.1759341291132;
        Wed, 01 Oct 2025 10:54:51 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e675b557fsm23898265e9.0.2025.10.01.10.54.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 10:54:50 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Jagannathan Raman <jag.raman@oracle.com>,
	qemu-ppc@nongnu.org,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	kvm@vger.kernel.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Fabiano Rosas <farosas@suse.de>,
	Eric Farman <farman@linux.ibm.com>,
	qemu-arm@nongnu.org,
	qemu-s390x@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v2 00/18] system/physmem: Extract API out of 'system/ram_addr.h' header
Date: Wed,  1 Oct 2025 19:54:29 +0200
Message-ID: <20251001175448.18933-1-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Missing review: #12 (new)

Since v2:
- Dropped few patches
- Do not rename @start -> @addr (rth)

Following a previous comment from Richard in [*],
reduce "system/ram_addr.h" size by un-inlining a
lot of huge functions that aren't really justified,
and extract the API to the hew "system/physmem.h"
header, after renaming the functions (removing the
confusing 'cpu_' prefix).

(I plan to eventually merge this myself due to the
likelyness of conflicts).

[*] https://lore.kernel.org/qemu-devel/9151205a-13d3-401e-b403-f9195cdb1a45@linaro.org/

Philippe Mathieu-Daudé (18):
  system/ram_addr: Remove unnecessary 'exec/cpu-common.h' header
  accel/kvm: Include missing 'exec/target_page.h' header
  hw/s390x/s390-stattrib: Include missing 'exec/target_page.h' header
  hw/vfio/listener: Include missing 'exec/target_page.h' header
  target/arm/tcg/mte: Include missing 'exec/target_page.h' header
  hw: Remove unnecessary 'system/ram_addr.h' header
  system/physmem: Un-inline cpu_physical_memory_get_dirty_flag()
  system/physmem: Un-inline cpu_physical_memory_is_clean()
  system/physmem: Un-inline cpu_physical_memory_range_includes_clean()
  system/physmem: Un-inline cpu_physical_memory_set_dirty_flag()
  system/physmem: Un-inline cpu_physical_memory_set_dirty_range()
  system/physmem: Remove _WIN32 #ifdef'ry
  system/physmem: Un-inline cpu_physical_memory_set_dirty_lebitmap()
  system/physmem: Un-inline cpu_physical_memory_dirty_bits_cleared()
  system/physmem: Reduce cpu_physical_memory_clear_dirty_range() scope
  system/physmem: Reduce cpu_physical_memory_sync_dirty_bitmap() scope
  system/physmem: Drop 'cpu_' prefix in Physical Memory API
  system/physmem: Extract API out of 'system/ram_addr.h' header

 MAINTAINERS                       |   1 +
 include/system/physmem.h          |  54 ++++
 include/system/ram_addr.h         | 413 ------------------------------
 accel/kvm/kvm-all.c               |   5 +-
 accel/tcg/cputlb.c                |  13 +-
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
 migration/ram.c                   |  78 +++++-
 system/memory.c                   |   9 +-
 system/physmem.c                  | 322 ++++++++++++++++++++++-
 target/arm/tcg/mte_helper.c       |   5 +-
 system/memory_ldst.c.inc          |   2 +-
 tests/tsan/ignore.tsan            |   4 +-
 24 files changed, 475 insertions(+), 460 deletions(-)
 create mode 100644 include/system/physmem.h

-- 
2.51.0


