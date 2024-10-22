Return-Path: <kvm+bounces-29319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 360339A951A
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 02:47:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B7B7282D9C
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 00:47:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D27FE12D75C;
	Tue, 22 Oct 2024 00:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pbkfAGXs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52247335C7
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 00:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729558039; cv=none; b=DQHydXHnOihSMWsII2pHLMJ22zZ1+SplFNrKwUKudhpL3ZuVBVlIonxWjgEMdUEKr7e1THVc63rxQyrUaZ0idgc0++GHcWDG21BNpZY9SqGRLfp+EyLGUXTUU4PLYJpEDmFisSYtAX2sZayeL9imz/WB2UU2ucOQhpRG7LUNsic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729558039; c=relaxed/simple;
	bh=esQoNZuXsR24jwPl1DfQPAsmfQfBH1AfjOxCgQQxj50=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=irQ8RtLjGIbRtzWB6KSMmkn+1/JBli5KpmbOYvCz2+zYsa4HQE3WRcJ/h87mCkjPKNWPZCnwlkgargoxPB+r00ZBT1uKQvme60QtLLw1lYx7FyOX0rStEfDiVeYbL75cvHlnt2PeLIik4cXsAuFCBaasETw/2MxughZVq3itPgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pbkfAGXs; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e29135d1d0cso8131185276.1
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 17:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729558037; x=1730162837; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eTpDcLprhbUi5YHe62ZQ4u0o+/QxbhbJTnRiVU+yROI=;
        b=pbkfAGXsw5ltPJxt62qcFHuhxfOFJgiMyuPM/HYpxcY2SUq0RfxjBO/HeDkdl5EqCz
         9XK5P0Fl5EfRL1a09o4t/oyrMhg9xOIudUbtcCODAvaCcVF+R9uAcJvXC/GfrOGOH2x2
         nksiHK+71Mx4joys+NV7OWJYMt6a9j7e3YDcNSdu3a5bJGp3HH969rI9HHpWlREpwnfK
         gbNMBFRHU+0+W2TX+DkwftB/rLOvqGwP1It6xH4SXAXZDxIKlZ6ZGe2ojwzw6RdwPVq6
         4orxHk1NV/QCqSzxN9XF9r1C7oSY9VhiE/T1XM9FslfSwDxniWeYTUvwi3gY01vvPgbF
         XBGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729558037; x=1730162837;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eTpDcLprhbUi5YHe62ZQ4u0o+/QxbhbJTnRiVU+yROI=;
        b=gNAgiZQPipBd0IfQBT9aiTW5XkBpUlAcGjgsnG+Pyy9qQd5k45R4/VvZN1qAj1zZKp
         SlbxVncTFc8UovAiNB1QffkHJ5xtboLXWlEZFsKDKqcBgXGjppFrkDnnLhfBi9IU1Q18
         ZSEY1NOjwe97XUjbv3EhfHACY7T9P0LEQZMc3+b4WVsf24rjkArBvKw0Dbc0ww7GdV4N
         vRBuHPTAc23x5EGWni9Aq3YB1JSCHyarFrB+NS9w6MH3AlnzU51w9jVM8GacozCseDWC
         ewwH+6fhnw5fnwrDXJRrepeAVoxqCLA0XseNqmVDDmFX82tBMg1rjUj/bcQvsLoi/IH1
         RcWQ==
X-Forwarded-Encrypted: i=1; AJvYcCU0RieZZi+G9qLzE9SxBjRe+NmPnK8BcM4PjJggKkNzkfndynAbT8awygd8mDro2H2sw1c=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxI53ZmBHToliUmsl2R3YyPdFqWNcUZjC2/wbkNgIp+OTMToaG
	lK6kT0I1XYru8s27aUZe5m0WGu/aMY/F8f8VmXs+8X7OEZrp/XWi/KoDYAFWdgeHKGmGifiwnzn
	0MRVXPw==
X-Google-Smtp-Source: AGHT+IFHeu+s/6VJ8LwG/ln9c8VqGvj+9fWSI0sc1LDHdzQR9YS0qXRVl8XWuhvxBjalS3fnwkBU6xUhXVdb
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fac1])
 (user=rananta job=sendgmr) by 2002:a05:6902:1807:b0:e29:7454:a4da with SMTP
 id 3f1490d57ef6-e2bb12ed271mr8273276.4.1729558037283; Mon, 21 Oct 2024
 17:47:17 -0700 (PDT)
Date: Tue, 22 Oct 2024 00:47:08 +0000
In-Reply-To: <20241022004710.1888067-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241022004710.1888067-1-rananta@google.com>
X-Mailer: git-send-email 2.47.0.105.g07ac214952-goog
Message-ID: <20241022004710.1888067-2-rananta@google.com>
Subject: [kvm-unit-tests PATCH 1/3] arm: Fix clang error in sve_vl()
From: Raghavendra Rao Ananta <rananta@google.com>
To: Subhasish Ghosh <subhasish.ghosh@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Andrew Jones <andrew.jones@linux.dev>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Raghavendra Rao Anata <rananta@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Fix the following clang error in sve_vl():

In file included from arm/selftest.c:16:
kvm-unit-tests/lib/asm/processor.h:163:16:
error: value size does not match register size specified by the
constraint and modifier [-Werror,-Wasm-operand-widths]
                     : "=r" (vl));
                             ^
kvm-unit-tests/lib/asm/processor.h:162:14:
note: use constraint modifier "w"
                     "rdvl %0, #8"
                           ^~
                           %w0
1 error generated.

Fixes: d47d370c8f ("arm: Add test for FPU/SIMD context save/restore")
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 lib/arm64/asm/processor.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index b28d41fd..e261e74d 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -159,7 +159,7 @@ static inline int sve_vl(void)
 	int vl;
 
 	asm volatile(".arch_extension sve\n"
-		     "rdvl %0, #8"
+		     "rdvl %w0, #8"
 		     : "=r" (vl));
 
 	return vl;
-- 
2.47.0.105.g07ac214952-goog


