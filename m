Return-Path: <kvm+bounces-19408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 44F91904ADC
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 07:25:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE3551F21219
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 05:25:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C70647A4C;
	Wed, 12 Jun 2024 05:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HTefxumO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249E8376EC
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 05:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718169866; cv=none; b=QDG1OL5/1UDVvl+pYv/t3gf5NtqIOaqi/pAgR8fg5FXcpS7o0iGVBM1Tkf9ELOE3Kobvbx5uHUyarGsTD74E14vpQYmPJMv5uNHerL19hmCAz7EH8wkLU/5B4oOTm7egkIk9cnb7N2kGpfG99V2FWmsaplkSxP/Y3MuJ3kJdSYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718169866; c=relaxed/simple;
	bh=yDuGrupJPqU/qH7mA60OyALH8EV2F1waSBvyey8sFNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XIGcZNvIsJiN7snS0IFtLPRRwtTTg3HLGrhBuCRAnSr3BYBSrz58h0JVr3g/z0885DinCPd6vShG8ryiqijIDnP/St2CD9hGoR8+qmdZ3dJZk5ZEd7jKhWH53TBQBAnDLzZTH2qOzLuJSauZgIl84VH2JYLrdJ4KrUC4ZfdXFHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HTefxumO; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-6bce380eb96so1388224a12.0
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 22:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718169864; x=1718774664; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5Bc9UTJvjHe4RlGMnD7m65uYeeccHrpEGPbkyj3pP6o=;
        b=HTefxumOXDO0aX0NMszPojoBrcoC1T+11V96S6bTbKPSOtoAAVMvcvsb67W3lT8CDH
         6J/CkPR3GBBhX1D10u+dgSghA/I5gY8Bil01/3i/TqmfLPHZemRNgT0UyRHljPYz4ORN
         9mFw2AhxuYwT03DYtilgPZNv8yjs8SyB72E2Mcq5Gnw5S2L0tYT2WBgAEHBcOjDRtqMu
         NhzhccUqf3mp/eWWJxq8U31CWpA9YWTaSzRmUAOroRBCPkHcVshGCtsA/hzm6d9/kn6T
         T9aPAdgsqDtsksuy7OP4yyMcLby3eUU0UsKQOsi3tmGeWt1CJAPgmkmOCNzN1EEHqDpm
         l1xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718169864; x=1718774664;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5Bc9UTJvjHe4RlGMnD7m65uYeeccHrpEGPbkyj3pP6o=;
        b=Br81FmeRkJmC8Bat3UtOrDdGT2IyR4kO/sCqd08F6PtstftWWn9VDs1KeHDKn6i9MF
         DbUuWRyN0YXKw1UVacXgerNSTkGoVeoITPztCKVzT+n8M/DS0p/7+WZvbroRnKBggUBB
         VKUqUohLuYmc5RbzJ+rLFwuknhyJcOujsdWvKa4QzS7/IGAJki7cECMqej8m7CUskayg
         BqDUtLzqyTFr3gNLTGVwGWMsPLyEJBY/JexQ+9Ck+EcgkWMv8K3pFDY1nziF+/ty6nv8
         V8Hgl9+v16pSvDgY0MCfutLDKvcPTaQ1tw+TKXXnwTGTJEV12VaSbGlUm0QWjRF0TlBF
         WmeQ==
X-Forwarded-Encrypted: i=1; AJvYcCWorSUZynq95jWTz388F3w39HCcRSxYbDdVtslQnwOsxRM9m5BA7fLXxUOVs1UTFEOTxICRgnbR/C6uBhopXZmqgAdC
X-Gm-Message-State: AOJu0YwjB9R0raKwEtY0PKR7SgnaWZIAJq4vlCvyELyn1QwAhZgkheZd
	YPyfGNzpW1T8mF1oeXVqT4mAKYHEuw/+3Fctw0wg7V1onmB1FfEN
X-Google-Smtp-Source: AGHT+IH9+Xd6lUiJ24ooIzSZ6C97JAO5455r4+dra0H8lUoyTuJiwIb7nGdiQKLtXGs25ppqqhR9FA==
X-Received: by 2002:a05:6a20:7489:b0:1b5:ba37:9dac with SMTP id adf61e73a8af0-1b8a9c50fa1mr1037167637.57.1718169864462;
        Tue, 11 Jun 2024 22:24:24 -0700 (PDT)
Received: from wheely.local0.net (220-235-199-47.tpgi.com.au. [220.235.199.47])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6bd75f711sm112170705ad.11.2024.06.11.22.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jun 2024 22:24:24 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v10 14/15] powerpc/gitlab-ci: Upgrade powerpc to Fedora 40
Date: Wed, 12 Jun 2024 15:23:19 +1000
Message-ID: <20240612052322.218726-15-npiggin@gmail.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240612052322.218726-1-npiggin@gmail.com>
References: <20240612052322.218726-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

QEMU has fixed a number of powerpc test fails in Fedora 40, so upgrade
to that image.

Other architectures seem to be okay with Fedora 40 except for x86-64,
which fails some xsave and realmode tests, so only change powerpc to
start with.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 .gitlab-ci.yml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index b5fc0cb7d..ffb3767ec 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -95,6 +95,7 @@ build-arm:
 
 build-ppc64be:
  extends: .outoftree_template
+ image: fedora:40
  script:
  - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu
  - mkdir build
@@ -107,6 +108,7 @@ build-ppc64be:
 
 build-ppc64le:
  extends: .intree_template
+ image: fedora:40
  script:
  - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu nmap-ncat
  - ./configure --arch=ppc64 --endian=little --cross-prefix=powerpc64-linux-gnu-
-- 
2.45.1


