Return-Path: <kvm+bounces-16330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A36548B8933
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 13:30:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4409B1F22D1C
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 11:30:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A1268287C;
	Wed,  1 May 2024 11:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QDK2eKH3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E297F496;
	Wed,  1 May 2024 11:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714563007; cv=none; b=OCW+II1eel/gKw4xG5+EF6ddJHFLXo5qX7iJb12xOPx65CfnIEgpMNPQOCdhhjBoX+WlFpanNJanO4XH2DRbb4/VuzvOem8pPJ8h7+c1/fmdt+QCQ20Y9WpJQK7t4yCQVXQ1uGRhu9mqobDhUjzwn1HbAo/6RLk3FVlyz7voti0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714563007; c=relaxed/simple;
	bh=S4jV/8eYOhGDWL6g6A7riEff5ftAxPJaEFHHPj7QQDU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gxIO8HJRXcmvxbwkX46Vt8i86LOww+taydWfaOQrP4xh31vJ4nL2ulFc/nW/U5LvPs1Mjp/X9402XVwENJG5Ea9DNKeCNF9wLHal1YTSmVWdLOsOORFKtHXO4sb+Dd3OiTmTloWcjbhtG2h6I8aXOxa4iwFUOV+p9VmII56DIIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QDK2eKH3; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1e3c9300c65so56764255ad.0;
        Wed, 01 May 2024 04:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714563006; x=1715167806; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3fmFcqT8F5hSXNzxYTaKRltCUOtWspR7LmgtxcvUq6o=;
        b=QDK2eKH3w9Y9xJi7IJM3SXzoW8IFs8ni+JMOeDkjoNGwh8qqCun3PrI+DwJoK+cLFj
         X66y/OLSEFTnNtu7klWkhhUO/fOSW4N0SJ+rL15WHNTdUPVVksa0lWyUdLBw8mJ7HNBs
         uJXKXBsfJzdmMVmpiBLclB2SuyA6vojbCMpMee97A8fDhnvhCGSwWh5H4/Hrt65oJhjz
         tDVDEqcblDB7FWJYK6LC3eKd+tU9Mzq4tWwCR41tDKeXS4LY38IbE2hMHkMAyJfwsQdg
         Xy0IZMPIIeS3pfUhRXjX2Y9RjymDbt20Tm3BO+OYuHbAS50TxgtmpPu5RQmBCHACrvBv
         bTcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714563006; x=1715167806;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3fmFcqT8F5hSXNzxYTaKRltCUOtWspR7LmgtxcvUq6o=;
        b=SDxNJEzAqIgsOPvo9abe3rdMcsj2162xb+lzCcSStiLN1My9eIxeo0VLXEuR0tl1WE
         U1wj2LRDbUBxJpXa65rDK4kAwDI+Bc2lPoBytcA7Fw4Z59U+NaN/+8zb7AgbgTf7NXC0
         OXfz+IubXLzB5wRGiSEPMWL6ZI7kxHP5rRAtVlpWjv5IYUkInwnCvGc2rqKC5UUp5BNW
         WUtY0Lj+qHIBZSkFSu6L1MckNNSwjcBH0HtUEEXpgjfSC/zGWP3u0zp/JgCmd+TLbOtI
         ZlFZPV4YLQnIAieMzFRgzF//MXXfleoGNZZmhOjVDuVB4VxFQsabSjAd0Izr0YdgYSJr
         7iRw==
X-Forwarded-Encrypted: i=1; AJvYcCX/nihohqs6gR/wdY6Ea383t2Dxkv0/A5imX2lwHG33pZzb39AeJZspv/ttt0X82gpSgnER9tWchMtlmfj/ja//6ny8b1GOu7c5ztOELZL+fEYvTInqmjupVMTD+spmzA==
X-Gm-Message-State: AOJu0Yw4kb+CtS9yHFjcOnaqEz50mU1Y4BUcWiOahCJdxx3yW/6PP66y
	fwMFMVtDojjFULIMa3sCpoUjyTHqkeaoom0uAQqzwXxMB/oK4Eqh
X-Google-Smtp-Source: AGHT+IEkpQzYXzXYbs/gHLYdwxpBH/OK++tJH0WUUPJ3AyO4M069a98H6ricGGv8iuSezFZMDa/htA==
X-Received: by 2002:a17:902:e841:b0:1eb:156f:8d01 with SMTP id t1-20020a170902e84100b001eb156f8d01mr1930616plg.40.1714563005516;
        Wed, 01 May 2024 04:30:05 -0700 (PDT)
Received: from wheely.local0.net ([1.146.40.196])
        by smtp.gmail.com with ESMTPSA id y22-20020a17090264d600b001ec64b128dasm2267150pli.129.2024.05.01.04.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 04:30:05 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Ricardo Koller <ricarkol@google.com>,
	rminmin <renmm6@chinaunicom.cn>,
	Gavin Shan <gshan@redhat.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 0/5] add shellcheck support
Date: Wed,  1 May 2024 21:29:29 +1000
Message-ID: <20240501112938.931452-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is based on upstream directly now, not ahead of the powerpc
series.

Since v2:
- Rebased to upstream with some patches merged.
- Just a few comment typos and small issues (e.g., quoting
  `make shellcheck` in docs) that people picked up from the
  last round.

`make shellcheck` passes with no warnings for me after this series.
(You should be able to put patch 1 at the end without conflicts if
you prefer to only introduce the shellcheck Makefile target when the
tree is clean.)

Thanks,
Nick

Nicholas Piggin (5):
  Add initial shellcheck checking
  shellcheck: Fix SC2155
  shellcheck: Fix SC2124
  shellcheck: Fix SC2294
  shellcheck: Suppress various messages

 .shellcheckrc           | 30 ++++++++++++++++++++++++++++++
 Makefile                |  4 ++++
 README.md               |  3 +++
 configure               |  2 ++
 run_tests.sh            |  3 +++
 scripts/arch-run.bash   | 33 ++++++++++++++++++++++++++-------
 scripts/common.bash     |  5 ++++-
 scripts/mkstandalone.sh |  2 ++
 scripts/runtime.bash    |  6 +++++-
 9 files changed, 79 insertions(+), 9 deletions(-)
 create mode 100644 .shellcheckrc

-- 
2.43.0


