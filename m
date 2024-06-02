Return-Path: <kvm+bounces-18583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AE318D7554
	for <lists+kvm@lfdr.de>; Sun,  2 Jun 2024 14:26:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4CEEB1C2112A
	for <lists+kvm@lfdr.de>; Sun,  2 Jun 2024 12:26:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAD833BBCB;
	Sun,  2 Jun 2024 12:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q3mDTNkc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD39C38394
	for <kvm@vger.kernel.org>; Sun,  2 Jun 2024 12:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717331178; cv=none; b=e9sLT6uNw20W7E5YgTcNlk4HjerGFTtr4kFgocUXVXEhdOE4pishRlRsB4C/RoUEao8e20A/C3HPDb/vfg8YIUY0pAiZxusf7leSzDJx5ujcCJ2P0XZxtTEg4ubN3rNmgMVhAnaF5VSUi2REtvC++yGHnbxtdgQ3jN8sTxh7EEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717331178; c=relaxed/simple;
	bh=gsRT5t6+jA3o4L8RD/m+uIC3dRPDQ4MjOCQHSZzZJrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OuNCHfQOBgjmA6cZkibRwIy0nXljvKo4RcfKpsBjU7oJnRHt79dBU7I8zR0/SBkOFouU3Beuvh1081CD27xUGqCqYa0mguL3yr27AVp6ePsivZffMKQZuaHOBOSahHUsSZ3lcd8cK/OWGdrSq/NpDdTm6MVHVmadImAkoyT9BGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q3mDTNkc; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1f6134df05fso31919805ad.1
        for <kvm@vger.kernel.org>; Sun, 02 Jun 2024 05:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717331176; x=1717935976; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OXZgf1pKFq5fGU1GpMr45jMdo+zCiLBYYxUQq93K0No=;
        b=Q3mDTNkcSVmBzFYZhrhDmqS63P2eOMdN+tiljH6wabJaY6gkyGarcOwlijzfUrsXFK
         sAYm2oSKP5LDap7cR65wo8o//T8wpJJuDUyI7p6Mpn5oxl9R5gWs3sLYkhJZouAEs6MV
         8VTCEOd7wQMfVezfeAyotvnntW81bGDoEBxrS/tlh+zkVP/xXdrhTNA5F5bI6OB2mcxp
         W2fJ/hQMH3z22dAugLHU1AdvM8CnJ3Jve9i0hYFioVS8s1Ssg2s6gs4t2q22bPrBBHzj
         1IG3WC3fpzueGZMcR6ZzKIFbChhjtd8S59WFTuLXpu6eX6LGOWiGNBZd60/BgG9ml644
         /xPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717331176; x=1717935976;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OXZgf1pKFq5fGU1GpMr45jMdo+zCiLBYYxUQq93K0No=;
        b=aKPjBUtveJJprRtzWjNymkHUbfIKUU8Sff0sEnEopH6e8s8+JK8Yeb7RHuhAwP59CH
         yzZ54rjp869Fj4mltPjlwrjL6G9A792mu332U9cK326Cai1Ohrb0QpYZeTgzS0ugAlTS
         ZyJwwO2eG2bGe/rxe1w84i97j7wE1PKVxiXQfKPlOq/Tb1djYN7Bn2o3TptlFxi5Vv8+
         VS5veu1R2lw8UkfekCE5AqeKm0ILD2gUl8oPAQt341UnXFrg1UAQa7TDRxLsrbKwMKoe
         1utW3zxrCAJYcANQvIBzoZS9VNO/IUfGWDHzYYEoBr1GZr9bsdoOKgBfZUdkM0nVvZjh
         kk5A==
X-Forwarded-Encrypted: i=1; AJvYcCU1BiV3CXJ5YMWP+Vv7yFnzUvDEjQ2j8XbXhcfr7lp1IlATCIZaTWDyP2YSk5y/NclJLDM3GUPsMXWQeG6wavBe18M/
X-Gm-Message-State: AOJu0YySrMP8amLQ+Bnw1ZxP+jh+A5P/RYZGRKi1NnbFkBex7koJey4i
	/NLGMITI/QWPH3jS8OkApSmrQOwMRANGo7A1jVuT2v3pepRblAei
X-Google-Smtp-Source: AGHT+IFvYFv9tbJkpHAqUs/opvGz2POXfgYsghTc/L4heNtyJvJSpAwxIqzhp+UUZnVwtn4gqCN8DA==
X-Received: by 2002:a17:902:e84e:b0:1f6:6ad1:fdf9 with SMTP id d9443c01a7336-1f66ad21fb6mr15906425ad.57.1717331175907;
        Sun, 02 Jun 2024 05:26:15 -0700 (PDT)
Received: from wheely.local0.net (110-175-65-7.tpgi.com.au. [110.175.65.7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6703f7673sm7834145ad.210.2024.06.02.05.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jun 2024 05:26:15 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 2/4] doc: update unittests doc
Date: Sun,  2 Jun 2024 22:25:56 +1000
Message-ID: <20240602122559.118345-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240602122559.118345-1-npiggin@gmail.com>
References: <20240602122559.118345-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Document the special groups, check path restrictions, and a small fix
for check option syntax.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 docs/unittests.txt | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/docs/unittests.txt b/docs/unittests.txt
index 6ff9872cf..509c529d7 100644
--- a/docs/unittests.txt
+++ b/docs/unittests.txt
@@ -69,8 +69,11 @@ groups
 groups = <group_name1> <group_name2> ...
 
 Used to group the test cases for the `run_tests.sh -g ...` run group
-option. Adding a test to the nodefault group will cause it to not be
-run by default.
+option. The group name is arbitrary, except for these special groups:
+- Tests in the "nodefault" group are not run by default (with no -g option).
+- Tests in the "migration" group are run with the migration harness and
+  expects the test to make migrate_*() calls.
+- Tests in the "panic" group expect QEMU to enter the GUEST_PANICKED state.
 
 accel
 -----
@@ -89,8 +92,10 @@ Optional timeout in seconds, after which the test will be killed and fail.
 
 check
 -----
-check = <path>=<<value>
+check = <path>=<value>
 
 Check a file for a particular value before running a test. The check line
 can contain multiple files to check separated by a space, but each check
 parameter needs to be of the form <path>=<value>
+
+The path and value can not contain space, =, or shell wildcard characters.
-- 
2.43.0


