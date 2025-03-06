Return-Path: <kvm+bounces-40214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B1D7A542E8
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 07:41:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 63C0616C252
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 06:41:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 986A51A3149;
	Thu,  6 Mar 2025 06:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MjMrlU1t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3057617583
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 06:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741243288; cv=none; b=k/YIJTu+Ly7jXukROsjSr+/udODAAms9dFJyXx9rPJ3AFkIw1/GCjpvzDbkv723L/VUHTF+SLulfNShaJN4h0NSCF0gRDBcC5jrAx2eNLXFJ96spGPAnLnpms2PDTsXcP8cvG5c6yyXXXVWuYnuFDyTwTfcMrcL377YigKNkJdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741243288; c=relaxed/simple;
	bh=Hw5zDbj3YqHdrzLQZe2gGYgf/faN/DEI6OBrfkDKxpA=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=FSEjdCwSjJfq1qFyn6GnhdZzYHB+qJW1J05cMG4XWVWECedlsNoj+MJStqllmkJqPfB0xxu+4Oz71nfYmbsXWugEVqjW21ChvBMpsCZ5iZ9qxQiOwzjk7cUSmwF+g9liCWtuuJLhC58VR7xW5gmVIXQ1teAmiOa4pRJKNBJt8U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MjMrlU1t; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-22356471820so3671965ad.0
        for <kvm@vger.kernel.org>; Wed, 05 Mar 2025 22:41:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741243286; x=1741848086; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FkqugfpLmgZAYLYj9EQO2VXghr69/Qi0X4/l0AwFoQQ=;
        b=MjMrlU1tbgaomt89eVWEL+77GOnIvJq3SGET+zHuwFqBp5SvKlkJQkJ0FtFY3z2sTR
         UE3LFSwrnWzWX9O0/iUehmjmiH/G7OCm6wFowebJn+SkxocPYUayWhuI/CbFObNEW2Vb
         ALeBwcMwHRFdlm4At52QAoNdJjIc8hqbqHuhobsPuS9MXXDq7I6OCUj3eQFf0LrBUbe3
         eBGTOgX2V9xV8hpTXSBC79UovuyEkCzvw4lv2x26eSxwHf1zJoarQ3WHvppWA951ve6/
         DtPGmZ6WLzzbkx5OJQkzZr/Uxx2sMoe7fhVX9JZ91AEPQDf8pPaBghbFyPesKy+ikGw+
         qrrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741243286; x=1741848086;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FkqugfpLmgZAYLYj9EQO2VXghr69/Qi0X4/l0AwFoQQ=;
        b=lpkv9BDwH+TnCZZu3HWXUHPP31gH68C41lWRi+F1WarmGOaMrTAuHKZFbefJ5a2jrF
         b2FYkIPbaxWFJJQ74QOthh2sTVI+u3IXk3CoyvzTUfbi3C8FZKOQXeKTU/wEwO1fj18L
         1Zpfpup5m4g5umqGY8SL9OtKrarrTJ+KV6q1Tm32SXcT+ZqZUM9eKt9uBI2sYWsuNVRE
         6Oy5oavbtAQhSOYqQhZtswF9kCQ62uHwDuUB7Y/pWL/RquBNjq/8TneUT/eEO6bJZXLc
         W7ByGAfwZg4bU0EDrrnXgd5fRd7wLZ4ewpKOsH24nRqrfk4kbxho+3qdqoImUktpxzCQ
         IsOA==
X-Gm-Message-State: AOJu0Yyg/bb5cxjMz+bb+aBCfHaCXDLYiYitXv7gEiOTCGYagyN/1NVT
	X/XMBbeUvrDx3i5pKqxNEzdDyvuYvCKVqJDc4M+G/IhC1//CyKJBGS5c1UsQ/eLcg+1taRON3iA
	N
X-Gm-Gg: ASbGncsY0mAfqfaHUIjVd1t9kd7UlNCuS5DYDxkFAmhnHSpaOpx2T7On02wBUB2R2nB
	Dggfvex8dADTjVWRL2U2Ql2BaB4WXboSIZx64QRMIJQ3Z1gmJKjkhmP/OHWY7iuC2M3tfyp7HRy
	YFqlW2xmeh4pGaB4vWh3fs65yjBS8NLxXsUmDPeF5G3/XBoblvSdFMkoEvcW6q05Vpw0E3MAg4b
	e8YFAcjXyWKO1xa+s/W1PbkttSAmPJMidVYSyxS91I618sBlhm15I87FSvRiA+GiTp2RpZBCW7I
	3L8pfRqzBIxrFg991hZGRTAD/MTVSUZtTAoRdAL+KPG0
X-Google-Smtp-Source: AGHT+IEEsF3k9RGAHKI6byG+A+vkqd0wzsLFy6cQsq4ZWFCLH3YwKFMsHMGnrfim33vYZLZM3MjK9Q==
X-Received: by 2002:a17:903:11c3:b0:215:4a4e:9262 with SMTP id d9443c01a7336-223f1c6af8fmr81636785ad.8.1741243286218;
        Wed, 05 Mar 2025 22:41:26 -0800 (PST)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22410a91cffsm4769355ad.174.2025.03.05.22.41.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 22:41:25 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	philmd@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	pierrick.bouvier@linaro.org,
	manos.pitsidianakis@linaro.org,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	richard.henderson@linaro.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	alex.bennee@linaro.org
Subject: [PATCH 0/7] hw/hyperv: remove duplication compilation units
Date: Wed,  5 Mar 2025 22:41:11 -0800
Message-Id: <20250306064118.3879213-1-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Work towards having a single binary, by removing duplicated object files.

hw/hyperv/hyperv.c was excluded at this time, because it depends on target
dependent symbols:
- from system/kvm.h
    - kvm_check_extension
    - kvm_vm_ioctl
- from exec/cpu-all.h | memory_ldst_phys.h.inc
    - ldq_phys

Pierrick Bouvier (7):
  hw/hyperv/hv-balloon-stub: common compilation unit
  hw/hyperv/hyperv.h: header cleanup
  hw/hyperv/vmbus: common compilation unit
  hw/hyperv/hyperv-proto: move SYNDBG definition from target/i386
  hw/hyperv/syndbg: common compilation unit
  hw/hyperv/balloon: common balloon compilation units
  hw/hyperv/hyperv_testdev: common compilation unit

 include/hw/hyperv/hyperv-proto.h | 12 ++++++++
 include/hw/hyperv/hyperv.h       |  4 ++-
 target/i386/kvm/hyperv-proto.h   | 12 --------
 hw/hyperv/syndbg.c               |  7 +++--
 hw/hyperv/vmbus.c                | 50 ++++++++++++++++----------------
 hw/hyperv/meson.build            |  9 +++---
 6 files changed, 49 insertions(+), 45 deletions(-)

-- 
2.39.5


