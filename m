Return-Path: <kvm+bounces-47998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 89D21AC8369
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 22:58:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CCBC53BE2D6
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 20:58:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CEBD293474;
	Thu, 29 May 2025 20:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ytgtqldQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138C31DFE22
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 20:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748552305; cv=none; b=eVqCrm3h0+J9F8+tmdPXNsdxxH+I0Zbg8z5x5nOqXlFUquM/SYWHxfM95N4AGViL5qQrrbrCAUeDJvkXO8lyK9zW49BYJMPc/i49/asxm8Tjqp1rZmwuLDjeEY5vU1os6VAd4og245nzaWIoubo2F1X5WvBrMSe86oYC5OeGYO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748552305; c=relaxed/simple;
	bh=LEKbkvVXAnmd1ZGYou9Y0CQeJxk9jFy4xmiV7Y348I0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=C9l3dGuVr0GnKPszl9BrC+8Zh4D4JhQU7Q1xUgcEVDz1XNbw1J0WARhJNOB9B6tKgTfH8f3z3w/8C7i644iX7QpwL+VEBiQIEqlnb4SqDAJYelQLXON1zf1DrXJ1llHURpU0abaEfIZTo53aS030iFjmqfGJC0Qt6hH02Egpp/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ytgtqldQ; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b16b35ea570so1288348a12.0
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 13:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748552303; x=1749157103; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xfgc+2pzGxNuO3ns5U9aU3cNysWBFOfdKUQCSOCTulU=;
        b=ytgtqldQLb6foOXPgzKU9thiB7ehtO1feoNeuGYBAAx2+ybHQIXeIqm1elNR1PI0zh
         Zc3B3h0FMw5zhu21gpLL2w5nwWqidqXUY9C9QmVCrFLF2Ly8dDY4Pj14BHOcQhsyGQeA
         vMz1cCO7G+1MaVNgO3QDyxCTomDUP7lK+CA7zg8A9io5jMzE0yQ9N8YGhtf/Glo5P9LP
         XAJ0mmzoGgpsDKd8RuyKXWGTyFTiUtzb0K7Mq9EdM1KELasDo6Dy28e5H2tcj0Y7RJGH
         eheUYvOaQa5PsFT1//UxYXrRRFpPfCn/DnHV6Ijt+nE8wPh5cbEEV/8OCVzaQdcsQiLY
         5i/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748552303; x=1749157103;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xfgc+2pzGxNuO3ns5U9aU3cNysWBFOfdKUQCSOCTulU=;
        b=B/t5iNRx7K7NTlKbE6sP3Ifga/J6jJSF8Lr+Iovs0Ra6aa68zBqaCqsq30EnLiNoXU
         dRKedtQ/B64RKRPl0iQ+7Rfk/V7GALZRnnSrsAq/eNIUeVJPQQ4moEgfKWB6apqqjZ5f
         G8MiShM0tKlbJZR5QC0+aBSWxwdw5zYEoAWugNxUyuxKsZLUqI28WRpbWUusQWbz4s5O
         VzKuSALwBd++cc8RToDSp9wYQZcGqbjjIkmzwX7qPbY0PXbIgr3w+XLk0savN7q/JWb4
         ipoW01DO03Ejx/UdoNyL2LEj6WVXlOLIkl3g7HA7L+aF8N3jvvNPKUhOR+W4csqO8SrX
         J5bw==
X-Gm-Message-State: AOJu0YzBJfabDKrLyuB5+LltrfIcKyAIbWD5HG4nIBMZ8ivPLIIBQHoG
	XF62GPujht1u96f2J/xjSPKcJjKXS1v+DTRliBdCWa8rjocsVOW0q7yTd6aLD2RvZiO4ygNa8Uu
	uNbN9Iw==
X-Google-Smtp-Source: AGHT+IF5JB4c9NUi12imOrKSntIpihofNvGuMmmHp9/r9JaVfp81Ht58cctqzGsVN13bYYDJ0JL6Eb7/OZI=
X-Received: from pfld2.prod.google.com ([2002:a05:6a00:1982:b0:747:af58:72ca])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:9383:b0:1f5:8f7f:8f19
 with SMTP id adf61e73a8af0-21ad9535746mr1671039637.10.1748552303236; Thu, 29
 May 2025 13:58:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 13:58:20 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529205820.3790330-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH] runtime: Skip tests if the target "kernel"
 file doesn't exist
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>, 
	Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Skip the test if its target kernel/test file isn't available so that
skipping a test that isn't supported for a given config doesn't require
manually flagging the testcase in unittests.cfg.  This fixes "failures"
on x86 with CONFIG_EFI=y due to some tests not being built for EFI, but
not being annotated in x86/unittests.cfg.

Alternatively, testcases could be marked noefi (or efi-only), but that'd
require more manual effort, and there's no obvious advantage to doing so.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 scripts/runtime.bash | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index ee229631..a94d940d 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -150,6 +150,11 @@ function run()
         done
     fi
 
+    if [ ! -f "$kernel" ]; then
+        print_result "SKIP" $testname "" "Test file '$kernel' not found";
+        return 2;
+    fi
+
     log=$(premature_failure) && {
         skip=true
         if [ "${CONFIG_EFI}" == "y" ]; then

base-commit: 72d110d8286baf1b355301cc8c8bdb42be2663fb
-- 
2.49.0.1204.g71687c7c1d-goog


