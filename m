Return-Path: <kvm+bounces-63572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 7390BC6B07E
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 18:44:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9C29E358F9F
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 17:36:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E28233C1BD;
	Tue, 18 Nov 2025 17:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P5bVruMQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90DD35A131
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 17:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763487257; cv=none; b=nz+fYMUYJPtRW9WoJMS/X/o+AdnczJKgqo65Z+WcgBwJGn8hganbD1Ain43rKs4bGoamqsykDCfQFooFIh31n/N57AFz5x8sgR/eTv/El3xVwD+gcsMsG2tuIi17oVcwhNvXh5Jo+Gfg5JlS1b94PJKN2kgKBVf+AM8DYTQLIqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763487257; c=relaxed/simple;
	bh=FXKaMwKamX9/4ZmJHnmHopZp0JW2t4vZ2mYBdT9KGok=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=LEc8TzE2vaSmU+QQP/Jzw+TURRWXAJV7l/arq1UqekUCsOs+H3+JUcbKbemQocqnIjSpuW/OXRjWIZ8h27nYkZk+9NV32zu6A9PhNe2zA8YwTN/i5lbv/u36HXmm6ffQQpI/u6dmYi1paw8V9qYUawtLz73mjRFwE9jrj3YF5Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P5bVruMQ; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-29557f43d56so71522555ad.3
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 09:34:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763487253; x=1764092053; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ylRxbTZll9WRBee9oH/7bFfEvYIQRoGaw5VeVmDXxrE=;
        b=P5bVruMQULnHOuunzCgsmi/1T4NR873cxj60kl3nFrlK0DxTfuEXoeMRLSzWCgD6El
         /vOwprl9hNsF8Gyobvkjc29K91QF+eYCRa53DBQ9jmzqDrDgD1RblqvSBYo6U9ul4Sqj
         h+GGCPRmnB4yqx5F+saKRCDp/xjT30rQTEHbptr3eiPLRKre4jx2+kdBmRC8rs3dPXpd
         azUo3EKf/Z50pgLQcoHVesWIbYGYRz8Jk/rQGPUBJ/CPxjmb3KqixuoYdeXxcXC+D+g+
         NAvluEj/4lXBKgRGfCgQtgsLgpRef80JVs7vII6vIzmEwJ3PJYeBNKCn1jX+FhS0WK01
         rDyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763487253; x=1764092053;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ylRxbTZll9WRBee9oH/7bFfEvYIQRoGaw5VeVmDXxrE=;
        b=tR/1dHjIRcqSn+J1en0OTT8fZmc4QC0YGcnZbJ9v5SufTfNZdoaKSTBzT76A1uAh+J
         xLKIFljunMGWxhVatSFzK6y+Ncv6MbS7Fy8GnYHLynuvx/kohNK0IStDc+C3EMYPtdMY
         s68dNpXVaz4YLdR1nK8WVZPbOUELaFADbhFQ6TxjyIwcirTsD+K2kAwVpwKDmEwKw4IM
         GG7szlelR5cCPucSicnV6hnEWZEsaXTJ88OCQVumt6A2J5FlLc9i6y8fcrIhX/SeJwbE
         OI0zWSD0MZ6KpiTs4HZFR0FBB46ahYlDKOWi8ghZ3eQaroqEETNgacaTw81BEczvx+2X
         /RCw==
X-Gm-Message-State: AOJu0YxVcbZJl6sU4MwRLyWbrVP5VqtAkH9p0wba9TUuroL2IswDEQOu
	yA2HHF8+TKzaxRzlymMqC7EunsNfUdrp+1fCk6FtIVx5vmKxisu7QdNaNM2E10XuBAIUEAUTH18
	x/Y8Qf19gXXb2bhv1y2QWqqMhFIPzluvPuTBPPtAcDfalLs35xV6ZVK1hUWBKyIf/BWy1UtteO/
	8LDievIgNzAKQDIiCbyMwymvjDD3wBOtQb7oFrBITaw+M=
X-Google-Smtp-Source: AGHT+IEKd7jaiVfrM+maURTSxeb8+dQdMAG7DDiMv0YW26G0viY0jRWBqiwbY82tVeT52lLG6lHivgSJQWZaqQ==
X-Received: from pjbee11.prod.google.com ([2002:a17:90a:fc4b:b0:33b:bb95:de6])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:38ca:b0:340:c151:2d66 with SMTP id 98e67ed59e1d1-343fa638ef3mr16219464a91.30.1763487252979;
 Tue, 18 Nov 2025 09:34:12 -0800 (PST)
Date: Tue, 18 Nov 2025 17:34:01 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251118173401.2079382-1-chengkev@google.com>
Subject: [kvm-unit-tests PATCH V2] scripts/runtime.bash: Fix TIMEOUT env var override
From: Kevin Cheng <chengkev@google.com>
To: kvm@vger.kernel.org
Cc: yosryahmed@google.com, andrew.jones@linux.dev, thuth@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"

According to unittests.txt timeout deinition, the TIMEOUT environment
variable should override the optional timeout specified in
unittests.cfg. Fix this by defaulting the timeout in run() to the
TIMEOUT env var, followed by the timeout in unittests.cfg, and lastly by
the previously defined default of 90s.

Fixes: fd149358c491 ("run scripts: add timeout support")
Signed-off-by: Kevin Cheng <chengkev@google.com>
---
 scripts/runtime.bash | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 6805e97f90c8f..0704a390bfe1e 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -1,6 +1,5 @@
 : "${RUNTIME_arch_run?}"
 : "${MAX_SMP:=$(getconf _NPROCESSORS_ONLN)}"
-: "${TIMEOUT:=90s}"

 PASS() { echo -ne "\e[32mPASS\e[0m"; }
 SKIP() { echo -ne "\e[33mSKIP\e[0m"; }
@@ -82,7 +81,7 @@ function run()
     local machine="$8"
     local check="${CHECK:-$9}"
     local accel="${10}"
-    local timeout="${11:-$TIMEOUT}" # unittests.cfg overrides the default
+    local timeout="${TIMEOUT:-${11:-90s}}" # TIMEOUT env var overrides unittests.cfg
     local disabled_if="${12}"

     if [ "${CONFIG_EFI}" == "y" ]; then
--
2.52.0.rc1.455.g30608eb744-goog


