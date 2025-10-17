Return-Path: <kvm+bounces-60300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 63F66BE86A0
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 13:38:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9C7C71AA148D
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 11:38:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25E9B243969;
	Fri, 17 Oct 2025 11:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jd3C2FXw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E28332EBB
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 11:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760700840; cv=none; b=ZKESq7q40UIbkPNcVaFOqUiqlL214xB2Ddzm5yo0CXCAyevPfDoeX/8ZaR3ZDI1fuJ4mhJfKLvDnrh+P/Ax2fWsfpbPKNAeA8y93evmlSjrv2VaSWCoK0DKQvJ8BeX19YG/HeykJ64mFzUT8zzQafIaRMfVwHD5V6xy7pBFWEMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760700840; c=relaxed/simple;
	bh=DrVx0l0oy9wvh2Hg94+gnu4d8nMgHddhBoaYCBEdqgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ub2AeF0XX67IUlV1L9ws5rcIU3p2adudgwH8sAvLsbSq7nMqoAyumc+/F7FB5QYxLVT0pY8y9MBr0VJiGMFS56kuCvzcaThesOOHKPb1DgzJHgSOP9QR9BCdRuq6rIvY89geQqaJ7xSCAqUJ7wpSVw93QwOD2VGBzcWT7mjqoZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jd3C2FXw; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-46e6a6a5e42so9977505e9.0
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 04:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760700837; x=1761305637; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QgCkk09CDJJJoCNRPQ1vxRSlp7Quspprhx550Eoot8g=;
        b=Jd3C2FXw4Bl97wK3RxRFiG4pzlXx54f3uZVCU4kfW9LsGL5RlV+0u9n7b7YGfYZ057
         32Hs6ctg+ZFl45BdQCgEx2/UIPugYZ+n0pAtweeYQSWvduzvrXK8HBOnufykUwTkAdoU
         Fg5acaUr2t9B+sxC2URxZhnZQ+0KVIUEOteFFQBRnIRh2DNkwG22ackf05FofE9TI7wa
         64m3eybZHBzko0LduGiwf1N5QQ9fgLZSe3UK+S936aUf2qSMlEf4v6sjhe/k2M8Nd7Ug
         z2AcvlB8neCp+8M33qwASlamDeiv45M8a+s7XshKhmJHQ6SPWTrAWF4/FTh697GegXmJ
         Hb0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760700837; x=1761305637;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QgCkk09CDJJJoCNRPQ1vxRSlp7Quspprhx550Eoot8g=;
        b=Xrnz+jZKm8lGVLN4AcrY1qpkTAsjG2YsIIz0meG9nPx9iqNxrwiPtHNp0hB+rOQ+LX
         0oIN4sQQZwEhurtOSgSdBXuDWZ6tkcCteVehibCmoK/VDpCslKiRfnXBkoYLqnaHFX6E
         Aik50t7WV85sGquYeVd6RPH0iNQsCZeOJQFyQ1fBx6HYT7p6eeXVJJ9WjnM9GwJ1UAoc
         TBWYzBS/Xu5NOOEXbzuKKjDcTHeskKpi7SnOSFmSQJJfdxDXQRydwbF9VgYNQ540vX92
         OBU4qmyBstG+bElNb/mF1RpMqiYwDdJd+GPn8XRSQtaZicfA7L9PDEK8XfFqvUwi+QLL
         xriA==
X-Forwarded-Encrypted: i=1; AJvYcCXuuW2HiIOCX4RbVR2mhhnzg7Sfg+ko+8mJ6BqK4VQtl/oJRXHGTuxUHBcOVPAGQ+XHGuw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5szYnH2AXRy70FYZhzvJkXXp7jxCYsUiVVucNmCglj/28TLNu
	+3CbmPtQ+eqvZr1Jeftj0v3ZWZMs/UiBd1HhzQEBCJPaj5jOvMP2e5ky
X-Gm-Gg: ASbGncsIwcSrnAnN5soQYBBsyPOJJBS86W4bOCUhhJWc2t/GNndCXpOwPGYHpbRq7CI
	pWGwiACZRvPfO8j688UG2Ujn5MRFS8ywO7G/mZp+34chywO1LfUe8+fLF0kDVYONK72r5jsCeny
	f0MltlfiMqB+0/Q58Oe2g6/nu1q25kV0YcDOWGry3E0h2vXCI2vCksRUKmznnjHtm8Y24Al63sk
	vuSFY8CoJY4nEJ8mwduRQokrAd6f+8RmroBjfQBgvQOV4OUVavbJosaaMo05PAF4yjVU4859t2E
	Y7WwAZI2U068W0bR+CPzGF4ctvAvBVfAVZ5pTpuwVtAoBkVYvlNcEuHRvwFzmiK20+p5dIJeWoz
	2Azq2mBSrmm0Mrmge98qi3SrIWrABBbTP6+Os5VNlCN95bfrY6lIeWSa8uOwbEXdQKFgSTMUPgD
	3JegTqE9wcK59MtqkKIPFI/JKL2vuvShjD
X-Google-Smtp-Source: AGHT+IF3ZWc6BVs/qnp6JVjeRuVjtLvXZFrwRaO7n86z12z++IOhhL2xCPtbec14Mlr9CpeaMcgcwA==
X-Received: by 2002:a05:600c:1d9b:b0:471:a3b:56d with SMTP id 5b1f17b1804b1-4711792006bmr28578385e9.34.1760700836583;
        Fri, 17 Oct 2025 04:33:56 -0700 (PDT)
Received: from archlinux (pd95edc07.dip0.t-ipconnect.de. [217.94.220.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4711444c8adsm80395435e9.13.2025.10.17.04.33.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 04:33:56 -0700 (PDT)
From: Bernhard Beschow <shentey@gmail.com>
To: qemu-devel@nongnu.org
Cc: Laurent Vivier <lvivier@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	John Snow <jsnow@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Laurent Vivier <laurent@vivier.eu>,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>,
	qemu-trivial@nongnu.org,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Michael Tokarev <mjt@tls.msk.ru>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-block@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Bernhard Beschow <shentey@gmail.com>
Subject: [PATCH 0/8] Trivial patches, mostly PC-related
Date: Fri, 17 Oct 2025 13:33:30 +0200
Message-ID: <20251017113338.7953-1-shentey@gmail.com>
X-Mailer: git-send-email 2.51.1.dirty
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

This series mostly contains PC-related patches I came up with when doing=0D
"virtual retrocomputing" on my via-apollo-pro-133t branch [1] which include=
s=0D
improved tracing and type safety. The remaining patch resolves duplicate co=
de=0D
in the test of DS1338 RTC which is used in e500 machines.=0D
=0D
[1] https://github.com/shentok/qemu/tree/via-apollo-pro-133t=0D
=0D
Bernhard Beschow (8):=0D
  hw/timer/i8254: Add I/O trace events=0D
  hw/audio/pcspk: Add I/O trace events=0D
  hw/rtc/mc146818rtc: Convert CMOS_DPRINTF() into trace events=0D
  hw/rtc/mc146818rtc: Use ARRAY_SIZE macro=0D
  hw/rtc/mc146818rtc: Assert correct usage of=0D
    mc146818rtc_set_cmos_data()=0D
  hw/i386/apic: Prefer APICCommonState over DeviceState=0D
  hw/ide/ide-internal: Move dma_buf_commit() into ide "namespace"=0D
  tests/qtest/ds1338-test: Reuse from_bcd()=0D
=0D
 hw/ide/ide-internal.h            |  2 +-=0D
 include/hw/i386/apic.h           | 33 +++++------=0D
 include/hw/i386/apic_internal.h  |  7 +--=0D
 target/i386/cpu.h                |  4 +-=0D
 target/i386/kvm/kvm_i386.h       |  2 +-=0D
 target/i386/whpx/whpx-internal.h |  2 +-=0D
 hw/audio/pcspk.c                 | 10 +++-=0D
 hw/i386/kvm/apic.c               |  3 +-=0D
 hw/i386/vapic.c                  |  2 +-=0D
 hw/i386/x86-cpu.c                |  2 +-=0D
 hw/ide/ahci.c                    |  8 +--=0D
 hw/ide/core.c                    | 10 ++--=0D
 hw/intc/apic.c                   | 97 +++++++++++++-------------------=0D
 hw/intc/apic_common.c            | 56 +++++++-----------=0D
 hw/rtc/mc146818rtc.c             | 20 ++-----=0D
 hw/timer/i8254.c                 |  6 ++=0D
 target/i386/cpu-apic.c           |  4 +-=0D
 target/i386/cpu.c                |  2 +-=0D
 target/i386/kvm/kvm.c            |  2 +-=0D
 target/i386/whpx/whpx-apic.c     |  3 +-=0D
 tests/qtest/ds1338-test.c        | 12 ++--=0D
 hw/audio/trace-events            |  4 ++=0D
 hw/rtc/trace-events              |  4 ++=0D
 hw/timer/trace-events            |  4 ++=0D
 24 files changed, 136 insertions(+), 163 deletions(-)=0D
=0D
-- =0D
2.51.1.dirty=0D
=0D

