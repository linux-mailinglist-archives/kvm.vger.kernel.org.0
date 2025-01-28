Return-Path: <kvm+bounces-36771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A9DCA20BEA
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 15:22:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C3084162BCC
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 14:22:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E84561A3A8A;
	Tue, 28 Jan 2025 14:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fzxmuiGC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A37BE40
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 14:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738074119; cv=none; b=p2NhtvIsH6uhq0Wv5OjkQlTuslUEcKqdb55OhTi0rSpLgRPN0vuXV+hLNmaTW9tuhlrCQ2Ryv1gqeOJelAp2iA0gDPXuFFRxeFW020+WQiljqOSNt8r/sTHH/s/HCawWlHssDU+4gkopzr7rlfnBOAtkfj7gHb7kBxSPSXKE5kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738074119; c=relaxed/simple;
	bh=Un/rw+6V5UomQpYK+OJUchBg6fXs/dOzb4ChiYM0p5k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DWhWeoqKkiXHXUVqC0e+QVhafhhbvUwxQjV6Bqqcue/3oBTNhVNIumKoHVyGKzJmsC38gdk1qrTt2V5IVfnElLgogGjtcKacjoR8w3RC3PCgnDLK2bYou46BBuopJHjX/+rMAz5denyk8YLNn6Wd9XLmE1z8Hfy8yctDicg/xI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fzxmuiGC; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4361f796586so63105545e9.3
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 06:21:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738074114; x=1738678914; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GTWOcGkuvsTBXu5MPW4cUBKzI5fUdevEC8idGZXnYVo=;
        b=fzxmuiGCbbKQz0WU622pXc9C/pyB8jxmgKLJXoJ47OOIJLHQTomstvsx13p0lUiTmg
         v0fMunUURjDdTgTMlZV2WNZGxpQYHeGPl/DfPQ1YShsaGAKStZjH5md8XSBwc7U1HWuo
         p4GvHGq3VNPZWYlZ+jh/nDzI105PcyRWM5gEhtYeGjv5ok3QM4T4V+hHUoZYcthCBNaQ
         SGpwb69yZvyJ4U+ZiIIzO91CEfLSRSSOqDpawMyMlsFxceOqY8TbqwWHQlLTxYyIndTi
         XEQU76nXV6NOBKI9KPbOHgC87kO73Io+sNFsHob+f+adaY94e+mh2/b2jzulyOyDsF2D
         Iyhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738074114; x=1738678914;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GTWOcGkuvsTBXu5MPW4cUBKzI5fUdevEC8idGZXnYVo=;
        b=ug22ZHLUpJ1xFzTV+1CdoKV4MdcP7CE8Az+Xb7be5BrSsut+7MtWgRiJF+ROd8gIVB
         /n9s01H526GMnTf44rq3q8BBdjYhJvW+I1OrUja5HJrY8PHcveb5c9OmtXfHB2Vii3YJ
         MsyMKcdC0ovkC7kBnlR3ggBQmc6/81d+ZQu31j5ARWtjaTAP0lHDaxw7lKqPv52E96hT
         ry1BgnuP7WJFPn3UwyBIF7thEUGsdI0qFs2wl3uZXOoDWqK6maSzbHx83xk3qN49L+Me
         FF4Ai+8Cb8vug9sqHaqAQ4Khmoyuy83byDTVtxvXMdEjSkhW36mbI0T8quDAj2jSip3j
         Y0fw==
X-Forwarded-Encrypted: i=1; AJvYcCW2EJEdHLc7CA2yWzIhMl3uKxonNOlo0hvIVtWo1EzPwwlH/9NheLybZHEVc4ZkaxZYfFE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxArtYQYNB3sW85NgzKxm0cSh4paeuKUBKMG2RPzTs8Wiav3Vd3
	X0bf1aTwKEzUeyz/MK4rw53OFkzsadN8iFE2S9JROFTLbGqxFk+25+bxNrN8y0Q=
X-Gm-Gg: ASbGncuX5AYgIoGOYs0z6GZl8uiYugau9fZivgkdeqXMaxs0XbknkOmDG9m2fyrx3wM
	mRabiemQMLk60CgDiBEHB8MC9xN3e0OBFkO2bRXztvbUREqPpcwjYUnSczi9QeXGTp4p9sTXhDf
	ts8lUKPaw9FJCj1IPUQNNgaUH1SKYY96mcp5h+foYTGhH65F4rzqHP1Gd1pi3K8AiMCW1f+0KuT
	DpFv3/VbAXi+kNnG3dRcC8P76bnlICjVjo+PjYa3+MiJEzAM9zO/bGba3EyIpO/MNuflwaa5S2f
	MrMzN9gNVIGF6J/OsTruNJPXhKpYr4h+ZPrCVRNEp7ILL/3U/f4NwDN4wFBcwGzerw==
X-Google-Smtp-Source: AGHT+IEDmxhLcOfTcSEi37XXd9ud7b8QXTwfgTu2TslBgmGqCsHxl82T7fwyR9UndhuusIGzaqFKDw==
X-Received: by 2002:a05:600c:4e06:b0:434:fddf:5c0c with SMTP id 5b1f17b1804b1-438913c60e1mr415615875e9.4.1738074114496;
        Tue, 28 Jan 2025 06:21:54 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438bd47f367sm170386975e9.7.2025.01.28.06.21.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 28 Jan 2025 06:21:53 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>
Subject: [RFC PATCH 0/9] accel: Only include qdev-realized vCPUs in global &cpus_queue
Date: Tue, 28 Jan 2025 15:21:43 +0100
Message-ID: <20250128142152.9889-1-philmd@linaro.org>
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

The goal of this series is to expose vCPUs in a stable state
to the accelerators, in particular the QDev 'REALIZED' step.

To do so we split the QTAILQ_INSERT/REMOVE calls from
cpu_list_add() / cpu_list_remove(), by moving them to the
DeviceClass::[un]wire() handlers, guaranty to be called just
before a vCPU is exposed to the guest, as "realized".

First we have to modify how &first_cpu is used in TCG round
robin implementation, and ensure we invalidate the TB jmpcache
with &qemu_cpu_list locked.

I'm really out of my comfort zone here, so posting as RFC. At
least all test suite is passing...

I expect these changes to allow CPUState::cpu_index clarifications
and simplifications, but this will be addressed (and commented) in
a separate series.

Regards,

Phil.

Philippe Mathieu-Daudé (9):
  accel/tcg: Simplify use of &first_cpu in rr_cpu_thread_fn()
  accel/tcg: Invalidate TB jump cache with global vCPU queue locked
  cpus: Remove cpu from global queue after UNREALIZE completed
  hw/qdev: Introduce DeviceClass::[un]wire() handlers
  cpus: Add DeviceClass::[un]wire() stubs
  cpus: Call hotplug handlers in DeviceWire()
  cpus: Only expose REALIZED vCPUs to global &cpus_queue
  accel/kvm: Assert vCPU is created when calling kvm_dirty_ring_reap*()
  accel/kvm: Remove unreachable assertion in kvm_dirty_ring_reap*()

 include/hw/qdev-core.h       |  7 +++++++
 accel/kvm/kvm-all.c          |  9 ---------
 accel/tcg/tb-maint.c         |  2 ++
 accel/tcg/tcg-accel-ops-rr.c | 15 ++++++++-------
 cpu-common.c                 |  2 --
 cpu-target.c                 |  7 ++-----
 hw/core/cpu-common.c         | 18 +++++++++++++++++-
 hw/core/qdev.c               | 20 +++++++++++++++++++-
 8 files changed, 55 insertions(+), 25 deletions(-)

-- 
2.47.1


