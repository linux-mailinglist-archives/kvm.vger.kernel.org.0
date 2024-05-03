Return-Path: <kvm+bounces-16477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8105A8BA698
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 07:25:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12D1F28303B
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 05:25:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAA79139596;
	Fri,  3 May 2024 05:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gGSGmLSv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47B72C181
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 05:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714713922; cv=none; b=JIgC0r7EjdjRb23va6VCChFFDt4727u+oAlqKyrCDFUfQbCeS6SkvKJWjDlTDzsqVxPBd8uxQayoQ/W7X6O2kEfUVCCCOG66Snj+9L2cw2qMg09oA0k4j5/oadVdH+jdo616cd8VVcMNPfMhZLOjKh6lK6yYPMZmxQvxXmfSwbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714713922; c=relaxed/simple;
	bh=hujr2hJRG1QFpIQVVEy55YEB9nVugABk03o/R8v3tyA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dRV32HJ49w4lkulqlCTSWJE28cul2WBb+huVUsJAuaYE2hpp+Ny9fq5eJlf3yAjvcoyO3kcjfcScEd2iO+YNwBK6CmGnXQwvvlTWKBdpgMjQGyPLZtjZubI/8bxY6nYkLlGp7RMCt1MDMAkGgcJgsx/wwaI7xHXiFbHAd1UHl2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gGSGmLSv; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-22ed075a629so3591638fac.3
        for <kvm@vger.kernel.org>; Thu, 02 May 2024 22:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714713920; x=1715318720; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gve4LJmh/O0Qj6MqIbaQYyQ7Zh0pLazfl2F5VQdN9Yc=;
        b=gGSGmLSvzd0MDKl5B9o9TRMKu4ZEJ2k48YRjkDt5AW4J0jLW1s9T14BoyiDtqcexzn
         eOV3oq2xb60anwZgCmoxq4uWI+mO36jcqz81NIMWsESgQ7CU1bDpgLI2NURA0cS65Ieb
         GpxFmY7zDYk3Bq7smBb+6HCg513U07UvL1kM5uRruK/hgVjbPC3rzw6VJa4IOGCYMrTo
         QSwH/klIojKrHUcklaXVcWA0LcuBiAXvkT2CKzFH3IB4F0yWJaN/RlZCtmc3cCtj62b0
         ngpAZcQyUG6XDUspefPc2y0B84eUL+1RzsvixEbARs/NkpNzL2J0SIORB7RHoNVSPje8
         wNJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714713920; x=1715318720;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gve4LJmh/O0Qj6MqIbaQYyQ7Zh0pLazfl2F5VQdN9Yc=;
        b=AJQxbkbyoKGpBmqjUdlA7Kg5sqIGbj4/4uKWrVeZvf4xoT9cl+VLKJQxNZevx/nv4O
         NviEeNfUNq9MC8a/xnq7CMKZU1TMPF+AO7c2RHwXTAazLrG9RscaEl2VOAi8525XPoI+
         Mcjw+eIWeV9njlgeFizGVh+U2bhD8hDGlfFCwnyZIA1o0YzixBiiZGudwSoyWliwRwvD
         9Ysh2vUEwv7ebRx3XDO2HiWftXN4OquEDjPi8aoQ8tltI7kNb/yYqxtlbc0qsf7mWLd/
         4NQ9xO7NDoMTTO3nxAmKoBVxepnKLaAUNpUX1hWBnp+0GiZwG1IAEwshHae6Tkw2JLTR
         jk/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUGfLdQlqLtbFAhCz102tqdGXZJhzv6fleETaPDm+OfvzI6T0RUiAkh9SZkI13TTzc/ngf6rCm9FOxU6xcR33u+Z+06
X-Gm-Message-State: AOJu0YwYZ+o3mjhsgZWHAfM4WVaMhGc0Y/zB7GAj3sqx4nxbPAjVadLU
	wDzoNlB7QeYpfVKsTh1SmkMn8v5JaDOJypHkSqxAP4megKGwZSXf
X-Google-Smtp-Source: AGHT+IG+aNx4Zq3d5GpfuGDXF5te83Hb2RWefCWiPbPlWPUtq9yR8nckp0k3ySlm7TpSsauodXdnFw==
X-Received: by 2002:a05:6870:9d86:b0:22e:ca72:faad with SMTP id pv6-20020a0568709d8600b0022eca72faadmr2022115oab.43.1714713919790;
        Thu, 02 May 2024 22:25:19 -0700 (PDT)
Received: from wheely.local0.net ([1.146.23.181])
        by smtp.gmail.com with ESMTPSA id y21-20020a056a00191500b006ece7bb5636sm2205571pfi.134.2024.05.02.22.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 May 2024 22:25:19 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 0/2] shellcheck: post-merge fixups
Date: Fri,  3 May 2024 15:25:05 +1000
Message-ID: <20240503052510.968229-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thomas noticed a couple of issues after merge (did you report at
least one before merge and I didn't notice? -- apologies if yes).

Thanks,
Nick

Nicholas Piggin (2):
  shellcheck: Fix shellcheck target with out of tree build
  shellcheck: Suppress SC2209 quoting warning in config.mak

 Makefile  | 2 +-
 configure | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

-- 
2.43.0


