Return-Path: <kvm+bounces-60638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DCEDBF5523
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 10:43:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F0BB8188B0E0
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 08:44:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6446831E102;
	Tue, 21 Oct 2025 08:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iQ9rMZ6G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A518B3164AF
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 08:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761036231; cv=none; b=avt7JpMPk4wSCy5gF/cTMNaczUC0oGQJHAVSzkwAGPLvUmCMefaOZxEgpmMOF7AdhFPConx5ct3+qtGJsHiiWBDfB2q3L5QzIeQHHdJ39zv+DGR7nf6wF1JQTRmXrafx5YEJca/PdPwzg2P1sOuBAe3TPAWCyUOD6pgpLI2DzxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761036231; c=relaxed/simple;
	bh=BsXFKOAXEwU4iRu+ImnldaL4c4eKv4xZuWca4EQfIzU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=J1JMuA20vDkcm3lQMlHEVtId8DtK6H5RIPLe+aCa+5i1fC3SssuhyDnf3VJlh9Gt+3xRRqEuwRLxGYFUY4Lgpmr+w6Wm5R9F1Qyx5lRlQqZOdyDLQfBxv0HYEHxgt0zUp6mfFPK4erabEReIlwD/asAVZpVHyGgNh+4inXcU6Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iQ9rMZ6G; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-47106fc51faso62617305e9.0
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 01:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761036228; x=1761641028; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+muwu4Xam5XibOYlX8DzcnL82BrVMx7yrTWGjYkAmmU=;
        b=iQ9rMZ6GsLvvdjTvRj0r5FBEVXHky2jnPBQTPS31RrGFb5LVP9zCFasPzbjB1KIvp1
         e0J8hVzKAQdBkxJj65ameoNGmaFAPF3f3nmi8SogQeoDIN+/KeitLWW8gisSSehuBGwn
         5bN225rEYUuNtJz9xt2WiKfdgohlrMAcG/V4tzz5zOmIJ8r/pknvnrQfS6+WGDO833MQ
         R4mdxEavSju0kNgTBhQUeFuCNT+jiAHZRNdVYdiyGnMk6CuNjmQ753+0bHI2MNh08fl4
         LhzIgoPsQuURc5HbxxVzyIe8o1mSJEvaE2+nxxiFsDfoINryRhko7fdnFzdyoilxWh9/
         VsaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761036228; x=1761641028;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+muwu4Xam5XibOYlX8DzcnL82BrVMx7yrTWGjYkAmmU=;
        b=Zja+RrAeUDqqDK6dAOLfssgfD8oZsuibiqETbzr4cTbvyfAAEOKeu0a09h1/a2NKve
         +SkRGWVb2bZ+QH+GyHRygjfz8eA3t/W5cf0p+w0PJyIOmkcl3w8xJ1WZlTie9b+sguc6
         HCs2VLYtKJW49SRzHG3pHA7cNUHDnip/0D2ix9TSy2rQVG6krquRAqx6Va7+mWh3KQS8
         dvSJGnWj0YoLBGO54d7fEW/RYhWKtRQk7ucO+/jhfBz3M4gKQxYYRmDr5BmhnOTkfETI
         kmN/UPRAWehqSMAxKZLv3cCo0ygZg/GKp3g92MphPkze0s/jozDYSDMzyHRwFC34jS6l
         RiJg==
X-Forwarded-Encrypted: i=1; AJvYcCVRvERwtDQHp9yfqe4WBOn9ADqmZaw8kHyDOlrSbftlEBWCAAxXaHq2KmXvRivI4j/NMBQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiZxFTYCib0Gm74wDiresE8NQlDLuuCGO8BXdfEJuorp1ms27V
	O0YY21aVV6AB2JqzhLQUahKkIko17EcEPOm7JQ6G7AjXysFW8fb0SR9PBtb9G1PVcKc=
X-Gm-Gg: ASbGncsnFOVwyjEXq0Wz5kVRHbIfScZf5Wuzx3tkeDx9kS/eXUihoaQMeFNTRSwrWlw
	U11oPT/Sd9bK2r1t3odz5LLTIaS2CqMrZcRA6PQPXdVkUbIsXfVckDagupWqF/vIm//7VIGmZ6L
	SXl9k1uZ9VRB4QMFUAZSY+MrBJ0GZKEMUPIu60/hFRuOhUPbm/xwvb/PnTdKSj6purXwjbIDQys
	2PXAXFVd4bqRwpi8hraOoaGRO696oEYpko03HwUsckCAq3wi4kWpET5Hy1ne1B4iNFC6HsgfyOy
	HGPYJxsed30RJ3LTRP1Uj39FPT6+v6wMj6bvIe4yRmc2MVTVBQlMp1eo3b3wUyL86iKjseE9nDT
	iKPhhgTT85xs6sa+xhtpW4E06MUXWYdu2IKAaqsr2lNWTaBsA8nXx+VbadZvMFesFFFJVTyoRSh
	xyMD1C0Bc/hDnkzpprwMSkmpGh6DH7hfNj2ChfczdIG0g+0Gw3lQ==
X-Google-Smtp-Source: AGHT+IE7GtUSdaMfEfq7t++7TU2o9GEgYfFa/E+TGLczbRaZ8WXh9AgLbbe349k38YMAGQbyuc2DBg==
X-Received: by 2002:a05:600c:4e0b:b0:46d:27b7:e7ff with SMTP id 5b1f17b1804b1-4711791f4e1mr112188045e9.36.1761036227949;
        Tue, 21 Oct 2025 01:43:47 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47496d269dbsm11269195e9.11.2025.10.21.01.43.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 21 Oct 2025 01:43:47 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Chinmay Rath <rathc@linux.ibm.com>,
	qemu-ppc@nongnu.org,
	Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 00/11] hw/ppc/spapr: Remove deprecated pseries-3.0 -> pseries-4.2 machines
Date: Tue, 21 Oct 2025 10:43:34 +0200
Message-ID: <20251021084346.73671-1-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

v2: Rebased on https://lore.kernel.org/qemu-devel/20251009184057.19973-1-harshpb@linux.ibm.com/

Remove the deprecated pseries-3.0 up to pseries-4.2 machines,
which are older than 6 years. Remove resulting dead code.

Harsh Prateek Bora (5):
  ppc/spapr: remove deprecated machine pseries-3.0
  ppc/spapr: remove deprecated machine pseries-3.1
  ppc/spapr: remove deprecated machine pseries-4.0
  ppc/spapr: remove deprecated machine pseries-4.1
  ppc/spapr: remove deprecated machine pseries-4.2

Philippe Mathieu-Daudé (6):
  hw/ppc/spapr: Remove SpaprMachineClass::nr_xirqs field
  hw/ppc/spapr: Inline spapr_dtb_needed()
  hw/ppc/spapr: Inline few SPAPR_IRQ_* uses
  target/ppc/kvm: Remove kvmppc_get_host_serial() as unused
  target/ppc/kvm: Remove kvmppc_get_host_model() as unused
  hw/ppc/spapr: Remove SpaprMachineClass::phb_placement callback

 include/hw/ppc/spapr.h     |  16 --
 include/hw/ppc/spapr_irq.h |   1 -
 target/ppc/kvm_ppc.h       |  12 --
 hw/ppc/spapr.c             | 299 ++++++++-----------------------------
 hw/ppc/spapr_caps.c        |  12 +-
 hw/ppc/spapr_events.c      |  20 +--
 hw/ppc/spapr_hcall.c       |   5 -
 hw/ppc/spapr_irq.c         |  36 +----
 hw/ppc/spapr_pci.c         |  32 +---
 hw/ppc/spapr_vio.c         |   9 --
 target/ppc/kvm.c           |  11 --
 11 files changed, 77 insertions(+), 376 deletions(-)

-- 
2.51.0


