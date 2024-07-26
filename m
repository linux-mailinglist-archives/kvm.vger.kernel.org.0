Return-Path: <kvm+bounces-22290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 553B493CE6E
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 09:05:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 09CC61F21EF4
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 07:05:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1872176235;
	Fri, 26 Jul 2024 07:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B9PZzVll"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841722C9A
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 07:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721977507; cv=none; b=qssUQn7PeI7FaPbZAVt84hwPZENoLt1f7wy06JsH5lh+iz89ES/5fCKLzJzx8D6LnuX7xi2dm3NjnhJtMcV8YqbeCD/2YgVM6GYURsjOznhpPUh3m5pL8jTaiGxAVLMcSv3TqS8TUGizvDMp/nNN/rHSFnX7V/0LPBaenWoEbPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721977507; c=relaxed/simple;
	bh=LF9/GB8frKhoGuD2HbQ6o5gKVsGYiXac822sYS2FhmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A93sLsKa96gqRjO0fM4mJA+SLMnBqErRaTzdQRbrYow2YIQIXBnFP31hOH+hbhWPBsdN1i2iAK5gNxoyCT15kcxMRIb4H5q6Fag65lkJ0twRgjjGrgSamI6UaWhBxVjQxgamx1tq9Jkzrun0QghpDsg+LFWNIfPHp2TP5N9PBHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B9PZzVll; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-75a6c290528so504979a12.1
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 00:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721977505; x=1722582305; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fkt/lVUQMJRuXw95ZbKfAfs9wcZ2vUkoB9BtsepnqRs=;
        b=B9PZzVllXBcdw4kDeeOrOL/iCUEdZrZqTbseWShQu1c2YIKZz/zAXAysq5COqK5e0t
         Zxa9wVIgtxhFqx7QDtRAwnnh+O1NVA73TbbB2tM4Inab487mW4lQAp3GKWoko9QPtZNx
         W7+3yKmmM9jKF6nDQ8GkIO88I0q+NQ7oXsKNmgr1nF2mF/NlOF8b9unnU+Bu6GnFWk8m
         tYnrn+RmI2gsD7LvorKeutLhtkxKo2yZn/2Vxv7KLz6SssnLLskPGwp3fiQv9SGGLnps
         NWJkMeQKprn8i+txxemxOfr7WWs+8o6B5nzO1HxZvJYlPrHVCxfjkVy9NueImCF2Fd+O
         h2AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721977505; x=1722582305;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fkt/lVUQMJRuXw95ZbKfAfs9wcZ2vUkoB9BtsepnqRs=;
        b=GKqA0B4vUQ7JZys8ZyflpA6nKMkGN4Y0IYQNqNZpqvRTW4FskZtlNgi+yJO++69ZZN
         xYw0U4qi/3ZHHe3MFR3s1hI8XTbd/JTgNfLRRHm4fKqUUjk67BlJ6j/OonkeXrXTMsbT
         hChZp1MlIXdICiVBhg/jWtEG5cTJKm21TV5PC8RWEVqw5LRk4fjb4oBLaY3O9oIgPo61
         LVO90VsSOXlYP1+4l8tlzPsPpiBOORVvrd//2WXA1w8138CHkfVjJb1bY6EBMd6f7K8J
         BLt/V08uQTyz2OoLTYlZIc44IGz6+dRdTLUHq04DuDg8yAhIIf+MjFe3I0U59xOmI3wY
         DIrw==
X-Forwarded-Encrypted: i=1; AJvYcCVx3XIOjK4oUw7GEZxxmtosPE6y4ESqAlRKWRE39GV2nJq8re/nDWBcZrLeRS+eC/x+p0UYMstkY4+f2i/jBWzR5+Rs
X-Gm-Message-State: AOJu0Yzxc7rMs4P6Dm8CsnEbPlWHSZZgi70IplsgfadByK84a4/vs8Tu
	s/tXVNdCMEe7iUX+jN1X49SW6CgjdnwytoFDeYFBWJPKO0+iIkoa
X-Google-Smtp-Source: AGHT+IG+SIKOM2Bvw4RAcGW9FNTDXdRSh26NvAX/OVjD7vBZzAOMKZI0Vc7mCT+nl2i3FuHPqjBkLA==
X-Received: by 2002:a05:6a21:32aa:b0:1c2:8949:5bc5 with SMTP id adf61e73a8af0-1c47b17b431mr5007208637.11.1721977504772;
        Fri, 26 Jul 2024 00:05:04 -0700 (PDT)
Received: from wheely.local0.net ([1.146.16.227])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fed7ee4d26sm25034215ad.166.2024.07.26.00.05.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jul 2024 00:05:04 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 0/6] Checking and CI improvements
Date: Fri, 26 Jul 2024 17:04:41 +1000
Message-ID: <20240726070456.467533-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Here's some assorted fixes and improvements to static checking
and CI.

checkpatch support is a big one and you could consider it RFC
for now. We may want to customise it somewhat (but IMO fewer
customisations the easier to maintain the script if we can agree
on close to kernel style). It's nice because it gets DCO, license
headers, etc., not just code style.

Here is a pipeline with this series applied:

https://gitlab.com/npiggin/kvm-unit-tests/-/pipelines/1388888286

Thanks,
Nick

Nicholas Piggin (6):
  gitlab-ci: fix CentOS mirror list
  arm: Fix kerneldoc
  gitlab-ci: upgrade to CentOS 8
  gitlab-ci: Move check-kerneldoc test out of the centos test
  gitlab-ci: add a shellcheck test
  checkpatch support

 .gitlab-ci.yml         |   83 +-
 arm/fpu.c              |   24 +-
 scripts/check-patch.py |   61 +
 scripts/checkpatch.pl  | 7839 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 7986 insertions(+), 21 deletions(-)
 create mode 100755 scripts/check-patch.py
 create mode 100755 scripts/checkpatch.pl

-- 
2.45.2


