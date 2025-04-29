Return-Path: <kvm+bounces-44665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 96E22AA017E
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 07:00:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E3301B6159B
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 05:00:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A813270EAF;
	Tue, 29 Apr 2025 05:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hIXipLsE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9B886338
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 05:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745902818; cv=none; b=gWBuc+YdpPicGSrygAbRfpetLrY0tDqrVUYwj7oMpleX/3CpFK9nQmJY9aixjakElPPcUp7roQSTOqmR93mH/zO4Xw3wO69o/YsbUxciyeXadk1tvzrvCh8OLeknCNYf5CH687pK1DvJi/TPV3ZpoTR/jK9y8buFnKGdbyETgmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745902818; c=relaxed/simple;
	bh=tBlCfVbaxBnOtPkuXQSa4s+a2mYTCFGwKB1i3Bn8nws=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TTn01Bs/WbUBet11VD0VmqYjFqM++ApVJ9WlZVS+6Xev7FjRK21I18iAnptHl2ut9OcKXK3bDvR1qW8mVD5YmpFc9w7JZ8bV6IIbiaQhcBEXAOAwTIxgHBVW/pq4egdGPsjZbHp+GnJLOcx8kHsiagT2XWvb/0vQLusj95Ah/AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hIXipLsE; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b074d908e56so4141259a12.2
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 22:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745902816; x=1746507616; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=E7e6flwrW0Xr7srdLRTYqMhF0r9DLRZRxyW/leVX1gE=;
        b=hIXipLsEPiS78IxapgQ54YBshgw5l94e2AOuZifxxCq8oy0ONEkhelxUa1CFhv6CTs
         djt7PdYVctcunBDke9gabuhUYDygWo6nNHgg5broGBllibAkXqcsfTMcFk7UzTEKW5SN
         RZfiv0xuUGKS+XbFtsZcFFWxhCau53ls0UGJUvVGNE69DwmR/mmdubGu4tRlLHbe5Ywr
         kMZKXTqYysoNcWwDVfsWMe92uZAc0QbD6poKqVc3sh5JuRlUkXL9s03+bHV4GuuwzWif
         elu8u3sAskYNEtpjyTdyAmIKT0H4vtCKtp/ascJ59ac1sWCn4wVGyH6F+6LRQiWniN4T
         1EIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745902816; x=1746507616;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E7e6flwrW0Xr7srdLRTYqMhF0r9DLRZRxyW/leVX1gE=;
        b=HWG70YSbuuvmYzv2XkBbP91s/lFt6Pvl/+fqHGHKJ+i/Xs4LhSsyO7B7ycDJC6mpNJ
         ajknYILwLOZZ8gmT8ZQO0oUZ9r7WxxrKFpVanCGB8JK0mWMZ1Ja1D9DUjEZzEaX4pTC3
         eHPrEzV98NghYg88s1Tdde4KIvmMKjHxWCzdTad7UO8xODaFVMRaAil8n+hiu/tnTLNE
         rPCkfO9TUt6JkOGzqXCA4UJFCMZAoZ2464twewal4NDKK9bTSYOvc8ZHMQuuBc5skxzm
         8E4DLnw+h2tjIYEL5BiwigWLLKvPC/PhpPxYH4+1O9yhUJKwlQwHzc9CTeP0iwYDfylP
         XzGg==
X-Forwarded-Encrypted: i=1; AJvYcCUhPiqNPd0C6VRz4HUzyMNh9PyJDw5NmrMFcjdSKroMY0J5apsnVFx2BX6WFbkPSwJpIWc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrWe71hasljhyOtodM0mzihgXNHREVNlNRuCj7YthWCnwvRvX3
	GTC6AbW6nNkqfOrsokFKiOo1UmCdKb4DtYB2r6tk8LorallLy2C9jpgIF4IRuz4=
X-Gm-Gg: ASbGncvDVoVBMRaAmBBqCWB8MEv4uK9UqkFAtyWUeAJhhExP13y7XriXMu9xXF5X1NV
	u1Bn15THrxFe3ZY5PT5T7lGqZo5G/Er626ZbPGyo09l8Te6PP1X0YT1IqHpkx4/9pmoFTfryxjz
	SziqYyLGIFUWXdq3i5KxsaJzE0bjNzfQxdL8ySMEd9kpZ/9pkNRrjmYSU945rgFY/XDpBif7brd
	LjlATGBJDVK39O3g49np0ulBWpSJKplB5nkIyBt8yeZ71/4nmr9inPaV7tnwYlUxIExNfQIU3xi
	M8pHpsS47beiqDF9FfNrocP4rcMrZuJyVvU78qv2
X-Google-Smtp-Source: AGHT+IGtTYums0vJIYUAxvrHOiwYyUcioYLnqAFsCGQIOBOAUh+3sHRwCcQhNBYfSH9HQfYcsvlOJQ==
X-Received: by 2002:a17:903:2ec8:b0:216:6901:d588 with SMTP id d9443c01a7336-22dc69ffb69mr175276195ad.15.1745902816496;
        Mon, 28 Apr 2025 22:00:16 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db4dbd6f7sm93004015ad.76.2025.04.28.22.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 22:00:16 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	richard.henderson@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 00/13] single-binary: compile target/arm twice
Date: Mon, 28 Apr 2025 21:59:57 -0700
Message-ID: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

More work toward single-binary.
This series convert target/arm/cpu.c.

Built on {linux, windows, macos} x {x86_64, aarch64}
Fully tested on linux-x86_64
https://github.com/pbo-linaro/qemu/actions/runs/14722101993

Philippe Mathieu-Daudé (1):
  target/arm: Replace target_ulong -> uint64_t for HWBreakpoint

Pierrick Bouvier (12):
  include/system/hvf: missing vaddr include
  meson: add common libs for target and target_system
  target/arm: move kvm stubs and remove CONFIG_KVM from kvm_arm.h
  target/arm/kvm_arm: copy definitions from kvm headers
  target/arm/kvm-stub: add missing stubs
  target/arm/cpu: remove CONFIG_KVM from arm_cpu_kvm_set_irq
  accel/hvf: add hvf_enabled() for common code
  target/arm/cpu: get endianness from cpu state
  target/arm/cpu: remove TARGET_AARCH64 around aarch64_cpu_dump_state
    common
  target/arm/cpu: remove TARGET_AARCH64 in arm_cpu_finalize_features
  target/arm/cpu: compile file twice (user, system) only
  target/arm/cpu32-stubs.c: compile file twice (user, system)

 meson.build              | 78 ++++++++++++++++++++++++-------
 include/system/hvf.h     | 15 ++++--
 target/arm/internals.h   |  6 +--
 target/arm/kvm_arm.h     | 99 +++++++---------------------------------
 accel/hvf/hvf-stub.c     |  3 ++
 target/arm/cpu.c         | 37 +++++----------
 target/arm/cpu32-stubs.c | 24 ++++++++++
 target/arm/hyp_gdbstub.c |  6 +--
 target/arm/kvm-stub.c    | 87 +++++++++++++++++++++++++++++++++++
 accel/hvf/meson.build    |  1 +
 target/arm/meson.build   | 15 ++++--
 11 files changed, 233 insertions(+), 138 deletions(-)
 create mode 100644 accel/hvf/hvf-stub.c
 create mode 100644 target/arm/cpu32-stubs.c

-- 
2.47.2


