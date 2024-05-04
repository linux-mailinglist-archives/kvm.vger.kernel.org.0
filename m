Return-Path: <kvm+bounces-16567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A9DC8BBB38
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 14:29:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB72A1C2128F
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 12:29:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7022622F0F;
	Sat,  4 May 2024 12:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NSdcxgvz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F7C24A08
	for <kvm@vger.kernel.org>; Sat,  4 May 2024 12:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714825748; cv=none; b=b8f2Xpkys7kWUnPfyXaL+L/VzDkRXxKJk1Bf7XpCZOhvsR6kNgIpGI3lxo7Pkyv6Up1owXUkhPaAQUyTBxdHVKroyYtU3UHEVBavcTkQoMHEmdC0Kovw+7+akIlEn4yxTkTQPrn5SqAsUWwLlCn4TkBKfJ8frFKdrOFF2ZBx2uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714825748; c=relaxed/simple;
	bh=583O/yP6e1RQvrSNJEzf80sZPaoiB80BQ81A/+0YdwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ee5oLFhilCFycYj+51oqQgiIkW7pxpD8jmbp3vsHetIIP4dII0vyQBCnhPC9MVwV2M+RikWugFicsWDQ+Ddf51mKg1Vg40GOh6yKnzrOHa/XFiPf9cP9Hm1ggwVnsiKI+lZVdPCDYwRx/THZvmPbVSEuzo7LR5hcyCtHY/nURRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NSdcxgvz; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6f44d2b3130so512116b3a.2
        for <kvm@vger.kernel.org>; Sat, 04 May 2024 05:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714825747; x=1715430547; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nbmc3N7ayQQTSkTEYRPQXziyE3JeoYhuY3oQWrhsIyA=;
        b=NSdcxgvz7p+ZwQcIiaYVieJTYP6ef/PKm7K9NnqgE2vnkAE0UnEMEBJv2Jat/vOZxA
         pWL28g2bTNFv59HSxPYMw8PVfJSKHR7Cs67luSimCyWgRKMoBSS+hgSPMZR3vyyb1BDL
         Ee1PjOq9GJsDcR5YFENhmbvI95WT4pM664bDrVmJVDZf13RO10Fnu9WC0+J++MANp3lZ
         fyou2JBCRT3VyDuWCKkhm8CJfyToPKXav62LGg+8Phj+qoPIEMMonxowrF929X9U4NXN
         nXTcXtAchfOm0a7opBZBnPbbvqTgN6inmvF7yc9OKEW8l5p6ReUQADPj2lCOxEJsMBsR
         gLQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714825747; x=1715430547;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nbmc3N7ayQQTSkTEYRPQXziyE3JeoYhuY3oQWrhsIyA=;
        b=IWVzZNWG/ZKqiBKlYJz0FfwcRtwAZj2qmBn1Ux+SqmJwixXOSyQ5a4tI1sApGXkO4/
         0Cm0cUmO+pdgbXVbUSEHDNByuDT812JJMl/l7UYD8EGoq6k9SOGb0s0HuUDwokxNFVpA
         zGyu00F1LUn9xRutoextpgFg2ntQS7Ht7p70lq7oCsCrpgUWG1BYbwmkNBsOL00+YfNe
         PYQWdGegQegNtxXVl6OyOwByOwAKJo8bb1mlkdbirhM285wDjVWTkZCKznhrlfndnygm
         4I0c572VD6LTNEP0qUjx02FwCGXh2YcwVRGKkj2MiM0mQlrDgiF5mMY7RTIhcY7k9up3
         XygQ==
X-Forwarded-Encrypted: i=1; AJvYcCVbISpCfn5DJLBIen4BHRQN3zN5Mcrw/qrAvR5LL3jdHWPYMLltfkn7NRnAISCQpzBvKmZfFvY7HBhnz++7Vr7c7mRO
X-Gm-Message-State: AOJu0YwmTGKmnqqvVNQJZxPSBK0gbMh7ZZHEZdg+9ObW73BsW16jVQHn
	kJoMxHPBR2wHFLbMQPJzSrx6UJ/NXCMY9rPO6DoQuT7we7JiFEtv
X-Google-Smtp-Source: AGHT+IEZFDAiDCpXRWqjZJD9ozdG8fcKWo3qQoDgM90MYAfLLB66dy82b1Qj+GOfJf6+77IQHdV5SA==
X-Received: by 2002:a05:6a00:4f83:b0:6ee:1c9d:b471 with SMTP id ld3-20020a056a004f8300b006ee1c9db471mr5947858pfb.25.1714825746767;
        Sat, 04 May 2024 05:29:06 -0700 (PDT)
Received: from wheely.local0.net (220-245-239-57.tpgi.com.au. [220.245.239.57])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a000a9000b006f4473daa38sm3480068pfl.128.2024.05.04.05.29.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 May 2024 05:29:06 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v9 04/31] powerpc: Update unittests for latest QEMU version
Date: Sat,  4 May 2024 22:28:10 +1000
Message-ID: <20240504122841.1177683-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240504122841.1177683-1-npiggin@gmail.com>
References: <20240504122841.1177683-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The latest QEMU fixes some known bugs in migration which allow
some migration tests to be re-enabled on tcg.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/unittests.cfg | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/powerpc/unittests.cfg b/powerpc/unittests.cfg
index 432c81d58..699736926 100644
--- a/powerpc/unittests.cfg
+++ b/powerpc/unittests.cfg
@@ -20,9 +20,6 @@ groups = selftest
 [selftest-migration]
 file = selftest-migration.elf
 groups = selftest migration
-# TODO: Remove accel=kvm once the following TCG migration fix has been merged:
-# https://lore.kernel.org/qemu-devel/20240219061731.232570-1-npiggin@gmail.com/
-accel = kvm
 
 [selftest-migration-skip]
 file = selftest-migration.elf
@@ -30,10 +27,8 @@ machine = pseries
 groups = selftest migration
 extra_params = -append "skip"
 
-# This fails due to a QEMU TCG bug so KVM-only until QEMU is fixed upstream
 [migration-memory]
 file = memory-verify.elf
-accel = kvm
 machine = pseries
 groups = migration
 
-- 
2.43.0


