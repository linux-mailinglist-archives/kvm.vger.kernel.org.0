Return-Path: <kvm+bounces-65910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D3E8CBA18D
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 01:14:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 05013300DB9C
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 00:14:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF7BC17BED0;
	Sat, 13 Dec 2025 00:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ROJiaopo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B677B2110E
	for <kvm@vger.kernel.org>; Sat, 13 Dec 2025 00:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765584893; cv=none; b=FSp8igV3Be30pbfcBgZaXRBjGRJAcbeajoCnqGTyjARqtGax28MPlV4dT6j76NUhe1q8BZ+Lp7ud7sk2UQdEXfQQHY3S18ZEJvWuRs+vjZDNN4s5BYypNHqMPnmOukHvdDNr0wI8w0UEuomaiaXW4C7Ga4gXdTadaAEOcgxN3q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765584893; c=relaxed/simple;
	bh=l4/5hfZhIiwPFpuUS3JWHVI4BvHEO8FWQlRFzlmGUt4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=DHxrfk6IQjIMmf1K+HS1E2jLQZV5IsPTDS6OF5CKgnBS4O7plZ1SsZq3zMUBTxOb2f/8dvEGFHDFlMn+cnqQQj9uP6wAaZngtC3e9ppUrr0jI69lfkFAjzFX7FYvgYI6nEvz9SAXq94H/zCeTsE5BjMaYSiHM4h/8+rIUym8FkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--marcmorcos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ROJiaopo; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--marcmorcos.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-349a2f509acso2781483a91.1
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 16:14:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765584891; x=1766189691; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8tL7/RGN/sKACTO1/U808dKR26ztwxbHlqQIK/m5vG0=;
        b=ROJiaopoKACZoi10d9Txlx8ckmKhqbBUz+EvvN4KzRP97SjeBq7mWeSveDcBLhXvlt
         AAp9x6nu9DTP5kvn2t6DSg7bsDSwNWcOS6RXobTHVQ12EWdbQR8JQGP0iFEe3Y5bBBmA
         X+Cf5LSP2Eghskaa8SLKcfn1hGnV8KowdsGcKR7BO6dokOnVvshKymLWwnpHZck4FCoQ
         gjhQqqXfF2HEq8A1nP8yUkBXsJTBwz8u2xzOK9/0MCG+eggJmpDgpRgWVxkkfSu69x/r
         YtF/fK6FrmcZBSGKwa5gIYOnSrkrrsaJazK/MK4gjDCpEf9sNwXo7YMAf5ZVEagy/Q4M
         DrqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765584891; x=1766189691;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8tL7/RGN/sKACTO1/U808dKR26ztwxbHlqQIK/m5vG0=;
        b=wuqyvQxFl2BPzHKD4Xp7KUGKht5bYtbDdI04gagqFT4wzXZ1Jt1xXZ8or/DAAaCSra
         4D91XxgvAep+8kffIcRCAnl0Sn/2zsA4Mrxw4ShLEH3p8I0w3KTwDj1XotRp7KaWdRrS
         ony9NuAyBTBk3OPdVDb+dwM5/96jTLaJtE1T+KjG7WH9nx+w9D2cSuZRSHdFX7cmnn2U
         G5zOPEP7zLhiZDhlQ3IW6pzA5Xbi9P8sY0P7e+IsC45vzKZ5zC7Y3OvSHvxzptdmNdwz
         5fJBkJqC33P7VeC0gp3WIYZuydr7hMoMoUNiYRnRWRfr2ql/OKQ7X/Y6+N9SryEAckC7
         Zk5g==
X-Forwarded-Encrypted: i=1; AJvYcCV1dwzzwgJKWQrBGvjLjNF29mQXxHK0B3xKHT/Tp8Oex/OIgw+1hC/Zsfv36QpD47ZwlVY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvJ0sw2iCkeTm5S/FJtYeg+L47XaH1Odq3b4nNAJ/ODlh0mtbP
	NoC1UiDelzZUUI94y79AOXS2ModGcCrlb4dBtAxvmi5gXRvQXN8rItTza9lQd2N919T+cIvkYPH
	MbAiT8MMj5zbDGbJp679ZeQ==
X-Google-Smtp-Source: AGHT+IEk/EneiJL291SDXmhW6/pWcFWHFjoD4OjmgLdPzMcPD1d1qlCRdYtHtLu1AW5T+C/bWNgCkI8hcBP/vuAg
X-Received: from dlkk18.prod.google.com ([2002:a05:7022:6092:b0:11e:60ad:95af])
 (user=marcmorcos job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:982:b0:11b:ade6:45bd with SMTP id a92af1059eb24-11f35475c65mr2888073c88.8.1765584890841;
 Fri, 12 Dec 2025 16:14:50 -0800 (PST)
Date: Sat, 13 Dec 2025 00:14:39 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251213001443.2041258-1-marcmorcos@google.com>
Subject: [PATCH 0/4] Clean up TSAN warnings
From: Marc Morcos <marcmorcos@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, 
	Eduardo Habkost <eduardo@habkost.net>, "Dr . David Alan Gilbert" <dave@treblig.org>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, 
	Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org, 
	kvm@vger.kernel.org, Marc Morcos <marcmorcos@google.com>
Content-Type: text/plain; charset="UTF-8"

When running several tests with tsan, thread races were detected when reading certain variables. This should allieviate the problem.
Additionally, the apicbase member of APICCommonState has been updated to 64 bit to reflect its 36 bit contents.

Marc Morcos (4):
  apic: Resize APICBASE
  thread-pool: Fix thread race
  qmp: Fix thread race
  apic: Make apicbase accesses atomic to fix data race

 hw/i386/kvm/apic.c              | 12 ++++++++----
 hw/intc/apic_common.c           | 24 ++++++++++++++----------
 include/hw/i386/apic_internal.h |  2 +-
 monitor/monitor.c               | 11 ++++++++++-
 monitor/qmp.c                   |  6 ++++--
 util/thread-pool.c              | 30 ++++++++++++++++--------------
 6 files changed, 53 insertions(+), 32 deletions(-)

-- 
2.52.0.239.gd5f0c6e74e-goog


