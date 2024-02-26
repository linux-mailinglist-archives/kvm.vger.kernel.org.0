Return-Path: <kvm+bounces-9807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B8EE8670D3
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:27:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D3641F2BFD3
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:27:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3BD55A7AB;
	Mon, 26 Feb 2024 10:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fuuulr8b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B882C869
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 10:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942367; cv=none; b=dnT+9QONO1iwINbkIlnrjdm72f7+tezAHgnrogNvQ103Bwpa8tD0LeJAbtgGuaqrgHVgPK3CXXuyDA0yBe+MqcjuonVaDitt2c1jMr0tjwZtQoImL4mXvJR9FxZ6PUhpL8VVI1xW0R3gblFPTz0Y6Y6jFiy9fPtRwo+kqwUyrOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942367; c=relaxed/simple;
	bh=w+U8pQ6bal7bS65aVrAZ36nO7kr4EGroeYSstYjYIaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R2MoHbNE3H4X8rIv6JXtuCRF9OpUBOoMuhwD65m3HPwy95cB9Q+aP/aU5GAmyejN9nozisx7wH5MhtMgzLBP8g1LH3QHL4UJZy/Jnt3y5FaDa18ZpwB4cuFbDh+sLNjl+A0eu9Cz7u+yEsU/sdRS5CIF0cxEX47p3YgO9g8/j2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fuuulr8b; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6e53f19f407so12114b3a.3
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 02:12:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708942366; x=1709547166; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=shnB3ixuxx3Kr4XN7+1/U2M5BodUI+jg6wVI3q2X2XY=;
        b=fuuulr8bWfZ5UH+Cqs/mumXZ88VYhW8+pDBRTJ9NGVluZvpirn/BqISVzsTj0QTeJR
         9p24T4a7wyMcoXVZnERS/Y7HY7Ow1TZcKj2Lmsn2Fpl4/G9bGApH+/zkKRCBWn5qDzaH
         CFYTscCmQrNQvnqSzz5I74j7G+HhteVayb1nXfqLn6L3k195iaMmhYqG+De/PwkwYJEA
         u84RLsxxYDD4CR9xJ3z80gv2wbUW6o6NGybadQnS+hFdLan7hAsTKL6NRlic2FrcGHCX
         BOS8GIxPSHcuLFR8PKu8fwYQTChNNn/W1vhwz0g0oWEDUaYsXuLeakKpk3jmGKKBEdeW
         /g0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708942366; x=1709547166;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=shnB3ixuxx3Kr4XN7+1/U2M5BodUI+jg6wVI3q2X2XY=;
        b=kCV9sIIbXJtYaji9wbk6hywAPfcxXzCda8eOdz9mDehK+3vkIEH8rF0TDOs5WrEFk6
         QjLO6SYOzb5uSst5njL8R3z3ht8eEyPpJchbfiESFM3nJ8zdDssd9SUHsofUegSuMGvk
         7U4VnRPpjaP866evuWf9wIfTxbWQxP0Lsa52ZKh9sFcc++MUUdHab0P44EQ0CnKwha2q
         EXZaN8ZPgse8mcTdKnpoXHgziO+e7tTAb6iBVRQfRFIhozi7tbxn+wXzJAgNaO98r2Wd
         o6ydQ2akNTUSuv5zqOF7Kj5EEub5nCiEgSiimqAssIbQNLreKzt0XS2VZBtP/2TA+Wo7
         5eIA==
X-Forwarded-Encrypted: i=1; AJvYcCW28x3yktz6T1UvEpo6hsWWK7SkcGh61G5IFc2OblxuABCI/QvCkVVVByIdXqW3zHoc61aSh7S+JzPjoDEI917LPZmn
X-Gm-Message-State: AOJu0YwGCDuWbzPd0sbnBInmfqHciiXoHo0dnwNmAOiqWcUxLUuzKNKp
	OJadHKY28EgA8m2/sF0ZGUnVPsIWDXxoo9uBNMguCKEFuwG0hzfHbqYLifVN
X-Google-Smtp-Source: AGHT+IFbe53n97yqDfweZxoom0Dd+DN8TQfpYMvjWilXLpYWRPk9UDIH5PI6pg2py4hep8BPKcZ4Jg==
X-Received: by 2002:a05:6a00:1949:b0:6e3:1fde:cb72 with SMTP id s9-20020a056a00194900b006e31fdecb72mr7900566pfk.23.1708942365663;
        Mon, 26 Feb 2024 02:12:45 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id x24-20020aa784d8000000b006e463414493sm3626693pfn.105.2024.02.26.02.12.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 02:12:45 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 03/32] powerpc: Fix stack backtrace termination
Date: Mon, 26 Feb 2024 20:11:49 +1000
Message-ID: <20240226101218.1472843-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240226101218.1472843-1-npiggin@gmail.com>
References: <20240226101218.1472843-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The backtrace handler terminates when it sees a NULL caller address,
but the powerpc stack setup does not keep such a NULL caller frame
at the start of the stack.

This happens to work on pseries because the memory at 0 is mapped and
it contains 0 at the location of the return address pointer if it
were a stack frame. But this is fragile, and does not work with powernv
where address 0 contains firmware instructions.

Use the existing dummy frame on stack as the NULL caller, and create a
new frame on stack for the entry code.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/cstart64.S | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
index e18ae9a22..14ab0c6c8 100644
--- a/powerpc/cstart64.S
+++ b/powerpc/cstart64.S
@@ -46,8 +46,16 @@ start:
 	add	r1, r1, r31
 	add	r2, r2, r31
 
+	/* Zero backpointers in initial stack frame so backtrace() stops */
+	li	r0,0
+	std	r0,0(r1)
+	std	r0,16(r1)
+
+	/* Create entry frame */
+	stdu	r1,-INT_FRAME_SIZE(r1)
+
 	/* save DTB pointer */
-	std	r3, 56(r1)
+	SAVE_GPR(3,r1)
 
 	/*
 	 * Call relocate. relocate is C code, but careful to not use
@@ -101,7 +109,7 @@ start:
 	stw	r4, 0(r3)
 
 	/* complete setup */
-1:	ld	r3, 56(r1)
+1:	REST_GPR(3, r1)
 	bl	setup
 
 	/* run the test */
-- 
2.42.0


