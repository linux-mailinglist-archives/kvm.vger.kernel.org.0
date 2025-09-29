Return-Path: <kvm+bounces-58990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EB08BBA9D4A
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 17:45:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B40381C3800
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 15:45:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F292630ACF1;
	Mon, 29 Sep 2025 15:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="g+1H2NEq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E6D14286
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 15:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759160735; cv=none; b=iotrfnptf51Gvbe91pIV9iEtKBD2LHaRjRXz00lhvC6MIMmTmVoCaSN9a8Cmb0UmJblvc0QTDIaSh1gLxqFO6iuOrZ0aBLiwKf0emtsKq30ApthHecphm0ecs56t7W/CczRYJkMpAyftONsrHoZ+HZR1YgcpGgVYGNupoadhKv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759160735; c=relaxed/simple;
	bh=LDlzKU7ZrVnN7TjWLQCyO7I7dF55CrsR+SPRyLztZQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DwbTKMT3CUc22v5jMfDMRIOjoSnGv4gLC+POO4kFmPRLEsdq5gM0wO1mIo1F0EV2FtI4DHmShcEGf1Q3ebkw7PLxYP8Spk7ZvkSjW2vZOEPHIKhD+QNJmDwjnRsFURrt0JaVkAPsFADFhXea1kKUxHapmaPeXy0d190klzBdhc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=g+1H2NEq; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-46e34bd8eb2so1005615e9.3
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 08:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759160731; x=1759765531; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=y2BqBLcXOCVlrkuufChgWQXiOv3DJ8+apNhO7PXtQ28=;
        b=g+1H2NEqt7DrjkzFGApszJ/+7pgeC5yjLFa73VsJvTGmw8jIdHSReNomwSVgnF6gat
         /k+AOnz4ohhZB25ilSc7S7hlko0zHzLxZjeVPxgoYHo0IN+glqTUS2cwLN6yZcXnW4pg
         nf7HwH3He1SLXCE27SAnJKv6DrPGa7AG1EHfttnOzaSPz6O+TdBUdoAXwRmw8aSCyhJ8
         ISlwJzq5RSfiUCsqV2V7hOGtmP4h6qx1uVilQa6oegU4mIHxl3NiJaukCgNw0/11i4IF
         7y03hhm7/PEbDlpU/sszKKIHRixBcEPI9erz8+2x6No0St/YT6yAAvE1qHf2fUk4GEMV
         Xlvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759160731; x=1759765531;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y2BqBLcXOCVlrkuufChgWQXiOv3DJ8+apNhO7PXtQ28=;
        b=M+u+fZH+tRrcseVnk1h2oqBnUGJKeXv1SwFXRYkOYTEUjSDgJf0wTGjoKXDgUBSBmf
         eCa4Sai3t7tiuWiVdsYUTVkQAp+csTBT72BeLbAs37QWUzK9eBObIWgrSh9cLB7rH/Wk
         pa4a7oovkXJomm8KoIhEK0Z0HY2rVDWBTX4aW/4v7iA3oarzxledpKkuyH47rJ5cHtGJ
         upzwOSw5JE6bJVPnAuL94w/nWCsVavwBpuxYkI1W/lPQZME1GWAyXZxTecsbDQcZfFZt
         5eiiKWY3wtsZMaYdaFh3E0bBK5VEKjhR1JSW2HoTMIW4ohptCgRElRhzcPlm/D9K9Bhf
         Zvvg==
X-Forwarded-Encrypted: i=1; AJvYcCWbvu4j9+ngKldWCN49Wsxoav7+iRA7XN5Ub+Y7m0vDVOroSU9AfKZxzOXZpUguB2QWgQw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLjRUmxqskmQe+c3I4ugdrTnK/8BYSFL4+7Uvd0P9g/8Bi3buQ
	W+PkmtkoC+xrvpfvi3KUDlK4SVyWGN9rqmiFfxVK2/3wrYuV+InZAEJ2iJZ7n0ieFFU=
X-Gm-Gg: ASbGncs0L77gEYSjBPBUQeAy/WKP3l1Qy+/RsapVLbSpdb5rXbySRcC+f1jQcy3cEfQ
	HsTX5+21nUuo95IqFtPp4X1ySN7UTn6Jn6lu3D16CFzP2ZreKsNY8FBYeTi3QwfwVElyM38r1Bx
	Fvu69YXNCkoFjGrUby4FIFPS5t2KLXYiVw1Ya+T80GxJ7xzGoP0ZlOXlCSaNQ9+qyUUGfPY0iC1
	H2dQvaxIK7s9g3tx1bTWfEFUkU2t2bgtSpfwkXaEeCVErRih3R8VIL3ROqQd29q8Soin6YtSgXL
	kw+vy10ZqB0Dp4ri66vhwTNCBufy5J/YpOALGpFjGBIHpdOWpT2VbITrhu9XXx7ulsSbYj4gVDY
	Cu4SmKbvjy2ZW+aK2uuhVWx8lR0rENGOP7LLy5I+Ja8cnGy/UPypjrjwNBwjhc8SXBb5O0U+c
X-Google-Smtp-Source: AGHT+IEuhKbNb5pks8P6yOzotxlB7PvN7376bBGCHSTQ7yaWpATyoy9ea46zy2XTRQv+Klen0bxxMQ==
X-Received: by 2002:a05:6000:1866:b0:3eb:6c82:bb27 with SMTP id ffacd0b85a97d-40e4accc83dmr14058555f8f.61.1759160731258;
        Mon, 29 Sep 2025 08:45:31 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc8aa0078sm18625546f8f.59.2025.09.29.08.45.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 08:45:30 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Fabiano Rosas <farosas@suse.de>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Peter Xu <peterx@redhat.com>
Subject: [PATCH 0/6] system/ramblock: Sanitize header
Date: Mon, 29 Sep 2025 17:45:23 +0200
Message-ID: <20250929154529.72504-1-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Usual API cleanups, here focusing on RAMBlock API:
move few prototypes out of "exec/cpu-common.h" and
"system/ram_addr.h" to "system/ramblock.h".

Philippe Mathieu-Daudé (6):
  system/ramblock: Remove obsolete comment
  system/ramblock: Move ram_block_is_pmem() declaration
  system/ramblock: Move ram_block_discard_*_range() declarations
  system/ramblock: Use ram_addr_t in ram_block_discard_guest_memfd_range
  system/ramblock: Use ram_addr_t in ram_block_discard_range()
  system/ramblock: Move RAMBlock helpers out of "system/ram_addr.h"

 include/exec/cpu-common.h                 |  3 --
 include/system/ram_addr.h                 | 13 ------
 include/system/ramblock.h                 | 27 +++++++++---
 accel/kvm/kvm-all.c                       |  1 +
 hw/hyperv/hv-balloon-our_range_memslots.c |  1 +
 hw/virtio/virtio-balloon.c                |  1 +
 hw/virtio/virtio-mem.c                    |  1 +
 migration/ram.c                           |  3 +-
 system/physmem.c                          | 50 ++++++++++++-----------
 9 files changed, 55 insertions(+), 45 deletions(-)

-- 
2.51.0


