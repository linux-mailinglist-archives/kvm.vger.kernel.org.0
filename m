Return-Path: <kvm+bounces-35940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C060A1668F
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 07:13:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A32DB7A40B1
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 06:13:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FC40185924;
	Mon, 20 Jan 2025 06:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bIV5VtNd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF27F2770C
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 06:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737353596; cv=none; b=efWkkCAU926T8CuvBMS4lVQzNnOE7PB2DzqOpee2jzoixtLQZFCrMR08T4eN7v8atNqsFR0o/Xds3Un0UqpcdNMC4hiQs9grO0JYJxIoojdNUdakDcz1ht4kDQX+Na3ZsKPSy5KjTvfi7MF2NugwDGN/QBdXRgsKhGvENWTAA8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737353596; c=relaxed/simple;
	bh=FTSsGQCBT7TTQNRMaAZ0cehKn017QIRWZKzWt3cJI9g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jfhUH/EolRmhc/f/MpP5J+qDtfcqqVJa+WXVOYr/lGwoMz9meYi7ON4kVefBgn5EWAT9uQDemFD7cs7Oz9pMnnnHeBF4LB00Wgy5q/RvTpku7tyJPLsH/oQlmn/8/nAfgtZj5S1FeeNLY7c697p26PuifrR6hwvRr4fuYGAVUBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bIV5VtNd; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-38a34e8410bso2091101f8f.2
        for <kvm@vger.kernel.org>; Sun, 19 Jan 2025 22:13:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737353593; x=1737958393; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fEc6Vq0amGObA0+1svRUeY/cgrZjsZmXB2GmgajUbwQ=;
        b=bIV5VtNdhvsYis6duLaWwaPmD5fgA4Jr5az3kQFlYh7q5AVrQvNwkj/+1DsxDRw5wF
         LzhjQqnpZ0oCzBu7sr+ZJa02Vt8RI2fMhoJf+uCAkpwo3+CcVYXxmOJHbmJQRS8p4DHq
         yaYIcHy59LoUnCKLjloHFiccPZxicPTsqrJKuhcHSXvPIClx/b+tpzdBhVV+qC8awZgK
         6iNW6pGTBE7JxyFtMs/dn9Hy1esV7aKPpzgjDmjFahmffnF1Hc/nS44lgOw8X0we9WD5
         fyJ5RWF7jRHUHqOd+K9MllIO9jgXDmeJ6rPKwmPyzWKaJkWe0ClEylIH+/g3zKhHkJcY
         PnDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737353593; x=1737958393;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fEc6Vq0amGObA0+1svRUeY/cgrZjsZmXB2GmgajUbwQ=;
        b=USS12iRvETUWo3xuJzMkigiRLtADvpWjos3UbX+R5VxhqflM8547Cg11+vD904krUE
         ejbbniAeFMSwauWxUtb5NAIbBE+KTNSzdezvJ23kT7QXolxVQjqfTGpzv/xyy+apN8e8
         TBAkdZaDmwdo6Nn0GpG2w5wQAac8MRTFIMqDxtRVtNLI0PdOUFXE1bKqUvXRKcvGkoqn
         kgCAQvx9Jchy5YaoB1zSThc0mwEdlno0X9JWyTXNPfv6mFKCZey+8cllJKpUjX7ZBqzC
         Tzn+1Hy55bX8Jr6MvFia6aAbAZuTEWAb7HJCxjuJ+RRCNwVSuuZUMOnibJS7wdZa3VVL
         1cGw==
X-Forwarded-Encrypted: i=1; AJvYcCWf0z6lUx05Da3zbhFCDVIVONjLLpnKDBqhDok/V3XwbOGP7G8ajixkVko5/UmO1/d+cCQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzN6RhcQHFjodfz0vj6SkLNdepPWHHwqoQGx0zf7stveY/7XHzB
	pIfHC9FaZuneU3KS3bl6F3rbMO/96+rDTEjxQaNZqX7BMsCcYX39MDx6vwY46I4=
X-Gm-Gg: ASbGncv8lp5gnQIBiX2Ce10d81aIrSjA2e1C3XJSX39lpa0a4aByFVwe+/rF6woxxPE
	/TyDtlv6djbACXZX4tQlpBns8anQdusLuy7vRuVNrfObZT+N1OueZmiMbABkZPe0NSIHtRA2zNl
	msqTq4wCgO4nJ1Jx91sIp9YY7BxbO1dWeng9NfbhNmwN50gMxIuJSdSHNHVdgbV+uGSiOY8Pa/b
	4ragNm5nm8qwhli8VGZDDlZV0HErjR464sewNCkUn61bX69F4QmoJjIowRUfzLNmx2p0/gy7vmy
	+dkElVctfl5SeFcpoPAnBF6l6qPo8vpSL3mtIwxqf4lD
X-Google-Smtp-Source: AGHT+IEokGRWo5DWwSsAK3uhifqL0RRGVzv58jj66VoHrUXkKS3qkXAk2JLOFZtlJhLFifcphcPtmw==
X-Received: by 2002:a05:6000:1fa4:b0:38a:8ed1:c5c7 with SMTP id ffacd0b85a97d-38bf59f00bemr10312946f8f.46.1737353592921;
        Sun, 19 Jan 2025 22:13:12 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf322aa40sm9315016f8f.45.2025.01.19.22.13.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 19 Jan 2025 22:13:12 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	Kyle Evans <kevans@freebsd.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Warner Losh <imp@bsdimp.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <laurent@vivier.eu>
Subject: [PATCH 0/7] cpus: Constify some CPUState arguments
Date: Mon, 20 Jan 2025 07:13:03 +0100
Message-ID: <20250120061310.81368-1-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

This is in preparation of making various CPUClass handlers
take a const CPUState argument.

Philippe Mathieu-Daudé (7):
  qemu/thread: Constify qemu_thread_get_affinity() 'thread' argument
  qemu/thread: Constify qemu_thread_is_self() argument
  cpus: Constify qemu_cpu_is_self() argument
  cpus: Constify cpu_get_address_space() 'cpu' argument
  cpus: Constify cpu_is_stopped() argument
  cpus: Constify cpu_work_list_empty() argument
  accels: Constify AccelOpsClass::cpu_thread_is_idle() argument

 include/hw/core/cpu.h             | 6 +++---
 include/qemu/thread.h             | 6 +++---
 include/system/accel-ops.h        | 2 +-
 include/system/cpus.h             | 2 +-
 accel/kvm/kvm-accel-ops.c         | 2 +-
 bsd-user/main.c                   | 2 +-
 linux-user/main.c                 | 2 +-
 system/cpus.c                     | 6 +++---
 system/physmem.c                  | 2 +-
 target/i386/whpx/whpx-accel-ops.c | 2 +-
 util/qemu-thread-posix.c          | 6 +++---
 util/qemu-thread-win32.c          | 6 +++---
 12 files changed, 22 insertions(+), 22 deletions(-)

-- 
2.47.1


