Return-Path: <kvm+bounces-25300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C00D96342F
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 23:58:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3939D283F05
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 21:58:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A27881AD5C1;
	Wed, 28 Aug 2024 21:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="reRMVEIZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646FE156875
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 21:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724882285; cv=none; b=JlqSmV2hGo3WpyQGAB5LmnKvxiN/NUcRw88OEh/UnnJm0DdB16iWgAeqUGBBc5Raz/EgcgR3y2iv/bVIsskWbrgJqOfSDsolZmTvGeGySj2p+eWcC61V0uJNzoNojMYHWGLkWUfCc6K5bae+Zzs26DALiK2JSkaD/HAkECYGikk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724882285; c=relaxed/simple;
	bh=OtyZGFXNJmaTgKJUaWxufZrcoMW8yy457X2gX7so+Y4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=uciQnzveIteWkdDBxygoWI1k6mWeIdJ8HYNkltLXKhbTphMQlhK1BmaWdYMeodnHPc2K3T6VgPXqFqb3hD6FjrStJa6fwZtDyiCtyKg22FZv4vYy1pHqa4H8F2MaTuc/zSE/GyyypZ7DpXGXnBWkYeaBDuFi9yL1D1p4S1s+DA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=reRMVEIZ; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e03b3f48c65so52993276.0
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 14:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724882283; x=1725487083; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wlgNMKNX5MS0ihntU6nNVvznZe2o+HmoUqQOC60ro98=;
        b=reRMVEIZLIND/yNtWuAe2ivXGA+VH0sroWZVggOMM9WDku5BVbFOARd7plrACpQtLw
         xHRRDE6C4f6X+epDoQRF1NJxP3VrOGEeRxlTGvDN9hoX12jcOHSuJDg4r5Pv9xf4z3Vo
         BH6fmQDHmCBMD7d0/FXPGA07J3WaYp1vLIr3L9ParwHrPquiXzwYsx2BmjWQeNTs4LFq
         a+A8Yl6UeOvp7cJeB8ui0rZdtSKn9ckBHVUpbnBGLbUOqEBqngtn9TduyCvLE5pzO5t5
         dp99bcs43Fz88iMxX4j5cAfTrjolIqFZKD7pSAOQTsj+QCofKPloHMyUaZH3a9vS5S41
         RPFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724882283; x=1725487083;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wlgNMKNX5MS0ihntU6nNVvznZe2o+HmoUqQOC60ro98=;
        b=YY4F9SNMOUrqZl/RnjfEAQoNYEIy0egY1knDlBN1nOs1+aH2f83acWoCuUN+mohyc3
         BeNA0VevJbsmB1oUpNDNTWJMdMHYaCshZlpvauO285gEGyA87szsxkdsg8QvNM5Srp9M
         X5XCEKtXwCgPQy0QVXmRm3JoCl6JQ89LEvbyVyO4JLyIue75QDT0rjdJGfSOB1T6p5Md
         bnewxNkXsWhPmPwVPUxAJY/Fp3zqXqxpbfCFxrJTHh15yqrDcMfMC3ktO9pk8bTJjTAB
         GgbKNVGWhYAkGRp5Wrjj5t8kWMBHWbzK9gGBvA9p2u1yLXiscu4ijZ9WW4W0G8o8Et7c
         NJ3g==
X-Gm-Message-State: AOJu0YzFvWIGdZyBdxnZfoPrTnn4n5fNskvorHpsGQRxiJf0RYOn0Nf2
	XkNCPuG2DcuB0O/GIOLAfivnTU+aeR0VfplmF0ncSblLjORySNnHchJJQJZ4S2qm4UsEkk2Obel
	1wQ==
X-Google-Smtp-Source: AGHT+IFt/U1L3elAJgmabyUwqBFMXxU/9PPvPxX8OhqgwG2AJc39YZ2qQsYr4fivt/vomf8f1YQpHuHB8ng=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:c54f:0:b0:e11:5f9f:f069 with SMTP id
 3f1490d57ef6-e1a5adf5550mr1448276.8.1724882282732; Wed, 28 Aug 2024 14:58:02
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Aug 2024 14:58:00 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240828215800.737042-1-seanjc@google.com>
Subject: [PATCH] KVM: selftests: Explicitly include committed one-off assets
 in .gitignore
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Add KVM selftests' one-off assets, e.g. the Makefile, to the .gitignore so
that they are explicitly included.  The justification for omitting the
one-offs was that including them wouldn't help prevent mistakes:

  Deliberately do not include the one-off assets, e.g. config, settings,
  .gitignore itself, etc as Git doesn't ignore files that are already in
  the repository.  Adding the one-off assets won't prevent mistakes where
  developers forget to --force add files that don't match the "allowed".

Turns out that's not the case, as W=1 will generate warnings, and the
amazing-as-always kernel test bot reports new warnings:

   tools/testing/selftests/kvm/.gitignore: warning: ignored by one of the .gitignore files
   tools/testing/selftests/kvm/Makefile: warning: ignored by one of the .gitignore files
>> tools/testing/selftests/kvm/Makefile.kvm: warning: ignored by one of the .gitignore files
   tools/testing/selftests/kvm/config: warning: ignored by one of the .gitignore files
   tools/testing/selftests/kvm/settings: warning: ignored by one of the .gitignore files

Fixes: 43e96957e8b8 ("KVM: selftests: Use pattern matching in .gitignore")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202408211818.85zIkDEK-lkp@intel.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/.gitignore | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 6d9381d60172..7f57abf936e7 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -5,3 +5,7 @@
 !*.h
 !*.S
 !*.sh
+!.gitignore
+!config
+!settings
+!Makefile

base-commit: 15e1c3d65975524c5c792fcd59f7d89f00402261
-- 
2.46.0.295.g3b9ea8a38a-goog


