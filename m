Return-Path: <kvm+bounces-66428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 71E53CD2321
	for <lists+kvm@lfdr.de>; Sat, 20 Dec 2025 00:38:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D508530329D5
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 23:38:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E0252E975E;
	Fri, 19 Dec 2025 23:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qzVXrO4C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F442D0C82
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 23:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766187508; cv=none; b=WsLxJrlWcmOjjMtoV/en1KncOzPsn9yeqYN5m7e+FXgmBA4c0E+VYIOmc2rRU52O1L97qElNB4BDN44XQkBIYXhwR2gH5Vzq//omjdiwljnT4btbh0ZasUXnBMElM5C7hzW04ev4wQMNo15nxheAcvj+ouebaMjTProWAhM2a/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766187508; c=relaxed/simple;
	bh=gWkBvcfuGVaJU7c0pZvlXjWs8LTtl+kIyfhZgvSp3uU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=KVczgejNmnRZtxFzANnVHnM1f81bnTzeJijrIa/E/rlRptgIvETyQ8TI+WY5M2gI4DcMgp2iS+ZRHjJWhAKWmpi8mz4wg0UpZABq31A6PxbbdAYuBav08B8MgTLG00LN2UMNC0fyKeWfSxlg7rTQQxvQVWYVbMALf7B2H3EDxDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qzVXrO4C; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7bf5cdef41dso3790453b3a.0
        for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:38:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766187506; x=1766792306; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kLeYpHFU0qJxoGCe3vW6d6xnBDR0IX9QgTKUjJ39MqA=;
        b=qzVXrO4CUJWvy1/rm2sE1vtRq3FN3HU9Jo6l9V25FwO8GE3HFcw+f++116YygKlrRQ
         Y3p8/4p4m2/kx69wrqqVsvBezVMK72w/goNheuEwEA4RtRAFkyOB1uQmN5QwD/bz5oQ+
         vN3XCArMY6Q9zFPjO3S9EcvxgoIAHX6kxTY0syXoJ6E/tqekwNs8OKMvFGROfw3t85jv
         YEVHf4Ey/a2dF2aZRktDXndTv2vn/3p1SH2bAhRgxHPddmOwp49xSMxXPv+m2y8gcspY
         yelkCsqLWp84/ceZaB/xE3xtnMO67lR0hJKqAamk/B7KhthIn3IJxy3dyl3yTdKJRXkh
         iZAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766187506; x=1766792306;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kLeYpHFU0qJxoGCe3vW6d6xnBDR0IX9QgTKUjJ39MqA=;
        b=bQ0nb8Of7J+TIQ3kuyhU0AYzDByfITFEuCg4AnomrljwEzcz6+DqpD5bLYEKp/Sljx
         vJdf8ijMHA+JhpV/iXjZE4q/O2DyBtNAP69co+k31vJf5vclYfNW1+nMaaC4tUYsX7Cc
         2Gf8AS73LGhux0V1KMSS9adyWXluNJbGog3RxaMpmPrNLq4cRDR5GsdJce6pgXlTiYfH
         Oq7qLh4PL1SfIH+vbrRHSaHTX1FVUvsyQFtO5Xr3Dui/JPg70SzGZCbA3ZiQWcC1MvfG
         kWvuAKc4FYf2cgu0CPjfcCnu1zJSSvlYaHAqA2x7UZBGt6IF32hD92sbtYGLUaRmjZeh
         eF2A==
X-Forwarded-Encrypted: i=1; AJvYcCXBWhBHqHupcE9Z9NgHkK0TUL3KJl1rmaLlW1FIG9HVjc/e5FfWJkM608xV4jgHgDg7P30=@vger.kernel.org
X-Gm-Message-State: AOJu0YybB3HI1kz5fflYxITOxLbHlIBTM1hx+DMnL+JyuoSL5E59QxOg
	xG6vbOTQyKpp0KCqHcT0Ni91p5EVTySEJHtEtu0Dl4UR8Rz6d5tnCpCXBQ+WPcvfJcLvaGQf35Y
	FurUIddBV9X85VQ==
X-Google-Smtp-Source: AGHT+IHxXk0PLI2V2GRQ+RwGGonwIrXwA2Zwocg/8D3BApAUw73YmYP40hfZrHi6BH9fqD5vtdb6ZAzEtoP5PQ==
X-Received: from pfbkr2.prod.google.com ([2002:a05:6a00:4b42:b0:7a5:20e6:4185])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2a0c:b0:7f7:1cce:d7b4 with SMTP id d2e1a72fcca58-7ff657a1000mr3976026b3a.1.1766187506361;
 Fri, 19 Dec 2025 15:38:26 -0800 (PST)
Date: Fri, 19 Dec 2025 23:38:16 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219233818.1965306-1-dmatlack@google.com>
Subject: [PATCH 0/2] vfio: selftests: Clean up <uapi/linux/types.h> includes
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Alex Mastro <amastro@fb.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Matlack <dmatlack@google.com>, Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Raghavendra Rao Ananta <rananta@google.com>, Shuah Khan <shuah@kernel.org>, 
	Wei Yang <richard.weiyang@gmail.com>, Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"

Small clean up series to eliminate the extra includes of
<uapi/linux/types.h> from various VFIO selftests files. This include is
not causing any problems now, but it is causing benign typedef
redifinitions. Those redifinitions will become a problem when the VFIO
selftests library is built into KVM selftests, since KVM selftests build
with -std=gnu99.

Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Josh Hilke <jrhilke@google.com>

David Matlack (2):
  tools include: Add definitions for __aligned_{l,b}e64
  vfio: selftests: Drop <uapi/linux/types.h> includes

 tools/include/linux/types.h                               | 8 ++++++++
 .../selftests/vfio/lib/include/libvfio/iova_allocator.h   | 1 -
 tools/testing/selftests/vfio/lib/iommu.c                  | 1 -
 tools/testing/selftests/vfio/lib/iova_allocator.c         | 1 -
 tools/testing/selftests/vfio/lib/vfio_pci_device.c        | 1 -
 tools/testing/selftests/vfio/vfio_dma_mapping_test.c      | 1 -
 tools/testing/selftests/vfio/vfio_iommufd_setup_test.c    | 1 -
 7 files changed, 8 insertions(+), 6 deletions(-)


base-commit: d721f52e31553a848e0e9947ca15a49c5674aef3
-- 
2.52.0.322.g1dd061c0dc-goog


