Return-Path: <kvm+bounces-18431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 074068D5274
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 21:43:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 91BA11F222A5
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 19:43:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFBCB158A0B;
	Thu, 30 May 2024 19:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xMFHGDS5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C8212E6D
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 19:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717098174; cv=none; b=Hjf7hlHWptizbxgtsVU/zCKuKSZB3E5MxhU+Ds6rwde+nSGLlYdupmENqwoLqiqyNlkh2dkf1DDrpt3jCY1J1pjjjWTLH5KU+ZLj7BoGlBCfDRhGOhhbBPmi/X2nNWF6dtJKwJz3ORubZZVnAruEfp7mtxJetFHbQcaHMM0CFI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717098174; c=relaxed/simple;
	bh=HeU9K7S9fx/xHzsVZ0R8F6zkS52H6j0kd5MZGqMNndU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=DUdf/oaeF2PDzrzqob784HPRskOPLlXSgf2rYf8DxhdDvv3cIR3An6JfIvfm7KqVYA3sV4xG+HLpDcEcZcWYIJN0G3lN1pntUWY+C7f5UXFgjImDuXuiNtwiGSscjGUR5IpZsKU900WjzY4Mvj1EPsTpnuLniimPzq0QxgvI+BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xMFHGDS5; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4211e42e362so13850005e9.1
        for <kvm@vger.kernel.org>; Thu, 30 May 2024 12:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1717098171; x=1717702971; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=65gU5Nwavd2bAlOw69K09QPcTa07oz7htXi9Z4Z1lS8=;
        b=xMFHGDS5HgoUXO4c5zh0nkG3HUJDpTy+XATlz1FVgm5ShPzS7NtWeN6sIGbtdtqean
         wENrV0AI+Yoo6yT+TUGYB+FDjGo6IfQUld+W+69jrkffFqF5as3k/h1Vw350mYAH9k1p
         xFefjssNh5FCz8W3P+I+mmD0HHQ3/+0fqC3tOk0v2yBCiloVB4rcgkv2jtEfdF56X+Gt
         dO70046+m0VvEWWDbkWH9tNyy/KlluzJ9sSCyDQY6khCZwVdH9/ORyEk5vv9yTt0GMnf
         FM1mpzd3LdXn+FOB1H2qofTY4/w4B5F+GO4Np1xuxM2KBThspiTevU/qdDCkxhv/Nfiq
         5EIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717098171; x=1717702971;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=65gU5Nwavd2bAlOw69K09QPcTa07oz7htXi9Z4Z1lS8=;
        b=e1LeaXiBr/jmDsVNVoWV5BM3rOvpPBs1LMadB0t6eA+j8XuHWVlcQEKT/KaRKDmfhr
         cklknl2/DWfTE1m/QbVwWjHsIdxmgZxmFqfLKH5zTLpaVjJqxkI5pF0zmFYgkuCzB1wb
         kNrIc4mhZ7sLyYkqlcr0TXk7yZAwEngZ2VFtldbqaas6IFswuHrXKZ2RVUQ50LQtLcbT
         eCz7K+5NGSEbDuO0WMyJLH43pcGKlu+qTLKxy1u5suCMIwyFd+K4IbVJdqzrAb9x5Jz6
         WQ7D+pwstghlQH2tT36+lR9bFZ8mlWMlpazR/uvErq8H4CKQCpyEQm3fMftmjtt3uJtc
         CK0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXkIF73bFGKrmF/p27UMYJ9ZbWGhJijWu8nPumpgpE6yY/0sDeeVylGq9Oe3c11FE0DRhCGLo9lB8RUYr7PiY8nqH6Y
X-Gm-Message-State: AOJu0YwOOM0tR10bVFXKnMcHyk2/uICguhmDQ2NI0pKHE17KxG3jDQyZ
	A4xRzCgHAj1e2UalON0HCU3TqnmT7KAcJ7kbRmDfh2GtA4WOG/mH2ov09DZCjuw=
X-Google-Smtp-Source: AGHT+IGnhu+Xh1JjChr4iKUj2Ca55eLgAratzb7EDCz14TwRVJ/zNB6z8fllVZMm/qeVhs4rR5CTgQ==
X-Received: by 2002:a05:600c:470a:b0:41a:e995:b915 with SMTP id 5b1f17b1804b1-421278130cbmr28854985e9.1.1717098171508;
        Thu, 30 May 2024 12:42:51 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57a31bb8253sm146492a12.29.2024.05.30.12.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 May 2024 12:42:51 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 8D54E5F8CB;
	Thu, 30 May 2024 20:42:50 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Cameron Esfahani <dirty@apple.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	kvm@vger.kernel.org,
	Roman Bolshakov <rbolshakov@ddn.com>
Subject: [PATCH 0/5] cpus: a few tweaks to CPU realization
Date: Thu, 30 May 2024 20:42:45 +0100
Message-Id: <20240530194250.1801701-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

The recent IPS plugin exposed a race condition between vcpu_init
callbacks and the other vcpu state callbacks. I originally thought
there was some wider re-factoring to be done to clean this up but it
turns out things are broadly where they should be. However some of the
stuff allocated in the vCPU threads can clearly be done earlier so
I've moved enough from cpu_common_realizefn to cpu_common_initfn to
allow plugins to queue work before the threads start solving the race.

Please review.

Alex Bennée (5):
  hw/core: expand on the alignment of CPUState
  cpu: move Qemu[Thread|Cond] setup into common code
  cpu-target: don't set cpu->thread_id to bogus value
  plugins: remove special casing for cpu->realized
  core/cpu-common: initialise plugin state before thread creation

 include/hw/core/cpu.h             | 18 ++++++++++++++----
 accel/dummy-cpus.c                |  3 ---
 accel/hvf/hvf-accel-ops.c         |  4 ----
 accel/kvm/kvm-accel-ops.c         |  3 ---
 accel/tcg/tcg-accel-ops-mttcg.c   |  4 ----
 accel/tcg/tcg-accel-ops-rr.c      | 14 +++++++-------
 cpu-target.c                      |  1 -
 hw/core/cpu-common.c              | 25 +++++++++++++++++--------
 plugins/core.c                    |  6 +-----
 target/i386/nvmm/nvmm-accel-ops.c |  3 ---
 target/i386/whpx/whpx-accel-ops.c |  3 ---
 11 files changed, 39 insertions(+), 45 deletions(-)

-- 
2.39.2


