Return-Path: <kvm+bounces-44363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6672BA9D506
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 00:06:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C0D6F467BFD
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 22:06:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DDAB227E8C;
	Fri, 25 Apr 2025 22:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SrVMUAhQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C72752F88
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 22:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745618762; cv=none; b=ZwsiCQu0frppdQx9UJ7WRwijoaLDeFiHiPvEyg6czdAIHnwIm63qnNCVjU6UCgPzRwwDdWGc+eSoNm8pHptuKmlW1gOaqneOA/VfstRD3Oegw1v3EDsItGIQIkFsEiWXVpWmQZAxgfwuAmIoGaYWt7nkNEptJc54nqyVAkkpP60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745618762; c=relaxed/simple;
	bh=Eby3fI1huX4/RdmysDqATVL53vuaJbvBADSlNAMITsM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=OU7gMzrT1XOuDQMXLPVk60jeilSwfcMcUAn0GOdzozx4f2CmTsDYTGkFHNfodGaxsr+KFD1fbDJbFi60kAGx8cOVmr6SrVL7BrJg52GPcj7paBWMznXTYBa8Py0DFYB1iwC5yoKeR/m32avNwTvCgNb7gpWjOGcX5x66NPzb+3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SrVMUAhQ; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b1442e039eeso1645495a12.0
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 15:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745618760; x=1746223560; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+F64d028KGAZtVO42dZa5glMoNqroKh2j9Vqgo+fbcU=;
        b=SrVMUAhQpbuI1sabB6eQMDsjVAxGqwzwF3LSdtJ597pohg/5MXuvPTpqex3h7L2Hgr
         0sWNxvyYcGzk6MuZIzNOZOW97RTydqYNkbf8txgcBu/6gFMk9LFvSAu4RcF/boHrn29G
         XqQLHe1WnYZUYYMhAye5WnF6gXrU61L7NIZ2HCPCcCEXiTiz1n2tlOLptJ5WOtqey7J+
         i68X9sxSCfucLqvGvlB5c03mkHI0KzkF/0H5P/ZJXFQsb3UTZTPtIbkPTD6xI9S0uXxG
         xHN67mYV1NuLfFflHPzK0uNM7HeQ0xBQw/E3GvLuuHFqVzFe6xDCVEnMvouAP+pz2Jli
         7U0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745618760; x=1746223560;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+F64d028KGAZtVO42dZa5glMoNqroKh2j9Vqgo+fbcU=;
        b=ACgMJ+DNqUe7ABa71MtfV7d6TYuLYGlN5uhIPVvEVrnx/iWedBIckSk0fQ3ykj1rdC
         WZEd8FGyauCQCQb23Zc+N9a0NeQWFtNXae4DptApccsm/JhqCuTxsvI8YGZSjZeL6nsH
         BmrlRA8SnFLqN29VdXeCyBW1YBf3sSOqILk6pIng7rc2aeAysdVcKOD5/jPPz4Ge4ffS
         cKe6T4b/RShJSy9reMCZrVjqs79AGZHBFmwBj3qU8KYUF49fNqlTbEeT9BTYpjKXjXRO
         YRlPdW2EOy1OVW786PszISvm3m0396ZTDq++QvFbS1K7keRLNVGtVijI8atRE7WarFnn
         hAUg==
X-Gm-Message-State: AOJu0YyfXHYo4kHUtFi/bmmAUzvqjZdGK86+eSOi1MGsTam2+jyaW+3N
	ijKCRWhyjFndjntkULmCAjZ2t83hv43LkVmhnQ2lLCLBrP4OVCjA11/W9RpFyNK94ajrMXDGEKQ
	MIA==
X-Google-Smtp-Source: AGHT+IG952Uv6/0hQPrnSvK5NLnUeXaBFENlC3zogSUimsHmc5rnqfKymqfteMyM1KnXwxjOmYcnWcv6fsg=
X-Received: from pjyp12.prod.google.com ([2002:a17:90a:e70c:b0:2fc:2ee0:d38a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5246:b0:2fe:e0a9:49d4
 with SMTP id 98e67ed59e1d1-309f7d876a2mr6375394a91.2.1745618760382; Fri, 25
 Apr 2025 15:06:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 25 Apr 2025 15:05:57 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.850.g28803427d3-goog
Message-ID: <20250425220557.989650-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH] scripts: Search the entire string for the
 correct accelerator
From: Sean Christopherson <seanjc@google.com>
To: Thomas Huth <thuth@redhat.com>, Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Search the entire ACCEL string for the required accelerator as searching
for an exact match incorrectly rejects ACCEL when additional accelerator
specific options are provided, e.g.

  SKIP pmu (kvm only, but ACCEL=kvm,kernel_irqchip=on)

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 scripts/runtime.bash | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 4b9c7d6b..59d1727c 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -126,7 +126,7 @@ function run()
         machine="$MACHINE"
     fi
 
-    if [ -n "$accel" ] && [ -n "$ACCEL" ] && [ "$accel" != "$ACCEL" ]; then
+    if [ -n "$accel" ] && [ -n "$ACCEL" ] && [[ ! "$ACCEL" =~ $accel ]]; then
         print_result "SKIP" $testname "" "$accel only, but ACCEL=$ACCEL"
         return 2
     elif [ -n "$ACCEL" ]; then

base-commit: 0d3cb7dd56ec255a71af867c2d76c8f4b22cd420
-- 
2.49.0.850.g28803427d3-goog


