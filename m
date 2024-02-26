Return-Path: <kvm+bounces-9823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CD6708670F7
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:29:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8189D1F29E5A
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:29:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60F3F5EE71;
	Mon, 26 Feb 2024 10:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gOYcA9Ai"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3062B5EE68
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 10:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942434; cv=none; b=Fu7BeAOAKEBVVoq2zIN/qhTWWVp23bIQlmSZuLK0pOpHRrRb6MW24LWPMDxoE20SBwq/5p9BiIMCT00eqiqX3ttBjkfJSAmwF5ka2QoRTIlSYTDbsQ67hZAplq+02QfDV3jqwmo3zgehLvFWm0ew0dQgXteIg9a2jeHxIjY4SV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942434; c=relaxed/simple;
	bh=qwPmKrTIpaQel08EbKiFVzmicH/I8d5GIVU/VxhMySk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IiH495eO11DEOPjVwFKB+im/9HMPoKeHW0XHi67N04CzZCINRLm1Wy00CF3t4t+kZC2EQuf8j9VkgKHLeCJGvn438UOMwzh139Ixg45o2luR5qv4ci5MvaNbMEHr/B/rt2/lZZ4u7tgPnjJ25QNmeAReRiCxOmklNVoXoW9vgcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gOYcA9Ai; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6e45d0c9676so1585059b3a.0
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 02:13:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708942432; x=1709547232; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LDeKQ2lObUUr4KHptgoHZEcycW9DzgxeUjc+q6aUnYk=;
        b=gOYcA9AilDCgSOzpb/PX4rL2HFMmwMDfVjB80eJfeqzG7Dz7yTnVehy5F0PGwXR+tf
         uoxJPEXK9sj6qYdW3w5Uf09ng7i2OY6G68MDRGl2Gon5ha4iVdazTQcvhqnO5K/Thm8+
         7ZpxQnWjoW3G1DjBXKO7O6IxHO/29NsRDsU5DXnNcqCWku4jcQhohCV5YG9jLzxGOFbN
         ZeRvRwotSOdPfhutitQM86cz2IdmrZ9P9Uxfzfaj87Bhcl055Kv0NgAil74RDminfYZ2
         DwaWZIJ4OAh4F7aHu1fjVIg3QUF/tUge3feftzGzi84iKYPZYXW3Yq+cbOu3oxQsV28+
         CDwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708942432; x=1709547232;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LDeKQ2lObUUr4KHptgoHZEcycW9DzgxeUjc+q6aUnYk=;
        b=GnGwUREF0co/xFmL7hCVSCiuLQ5fAkArQYGV3P/5k7OrU5UwELSj1FUFjh1ZtintRv
         zeYcySLdudwy44BrVvdYUwcspmz39JfmvPyu7KZ+rr1ToLkkd0HFp7bX7Yea5iiaIS7a
         gyu4YiHuRJxN+T+hHScXhCqv/MUvmVbyOEl312XrRFLza6BGyU9T3K0ShxzpaySr8XlT
         zAZzfNdbnQ5Gd39LeS6zweVnXEevglTM3J+eJ+vsKnU1xf3lNkbO0DSF3Xvw/CUGhyFi
         FZt6kEoUMX6SqaKWpdlY66C3hj9OmfPjeeYwfRh1FecHAieOnJ/8gkrN1WvnKm6PgXf6
         TwFw==
X-Forwarded-Encrypted: i=1; AJvYcCWSD4klHyNtPycuhTLFQxjFEBb2sBf6bKHF1+XNNeGxNfZYEH2kNaFWpRcXJUgm78JxWH2wKjHMZxe5WhezeCdP7bdb
X-Gm-Message-State: AOJu0YzYiDuX9OEq7APrmxbcEqAlAejU0wtjiEqDerYL95gKGpDludZg
	gReKEEh4rORZU9707PzELrWUASkpztO64SQnOsJB+dpXIOpNmhTz
X-Google-Smtp-Source: AGHT+IFOoUcECAFT4/BUkgpIcoKXR61NJdzPTx/1R4n+6sp35G90zSsoZYx8Hxeslp4JTEQ0PkUPIw==
X-Received: by 2002:a05:6a20:9f86:b0:1a0:b5cb:36d4 with SMTP id mm6-20020a056a209f8600b001a0b5cb36d4mr9052247pzb.19.1708942432602;
        Mon, 26 Feb 2024 02:13:52 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id x24-20020aa784d8000000b006e463414493sm3626693pfn.105.2024.02.26.02.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 02:13:52 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 19/32] powerpc: Permit ACCEL=tcg,thread=single
Date: Mon, 26 Feb 2024 20:12:05 +1000
Message-ID: <20240226101218.1472843-20-npiggin@gmail.com>
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

Modify run script to permit single vs mttcg threading, add a
thread=single smp case to unittests.cfg.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/run           | 4 ++--
 powerpc/unittests.cfg | 6 ++++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/powerpc/run b/powerpc/run
index 172f32a46..27abf1ef6 100755
--- a/powerpc/run
+++ b/powerpc/run
@@ -36,8 +36,8 @@ if ! $qemu -machine '?' 2>&1 | grep $MACHINE > /dev/null; then
 	exit 2
 fi
 
+A="-accel $ACCEL$ACCEL_PROPS"
 M="-machine $MACHINE"
-M+=",accel=$ACCEL$ACCEL_PROPS"
 B=""
 D=""
 
@@ -54,7 +54,7 @@ if [[ "$MACHINE" == "powernv"* ]] ; then
 	D+="-device ipmi-bmc-sim,id=bmc0 -device isa-ipmi-bt,bmc=bmc0,irq=10"
 fi
 
-command="$qemu -nodefaults $M $B $D"
+command="$qemu -nodefaults $A $M $B $D"
 command+=" -display none -serial stdio -kernel"
 command="$(migration_cmd) $(timeout_cmd) $command"
 
diff --git a/powerpc/unittests.cfg b/powerpc/unittests.cfg
index 97a549c0d..915b6a482 100644
--- a/powerpc/unittests.cfg
+++ b/powerpc/unittests.cfg
@@ -97,6 +97,12 @@ smp = 2
 file = smp.elf
 smp = 8,threads=4
 
+# mttcg is the default most places, so add a thread=single test
+[smp-thread-single]
+file = smp.elf
+smp = 8,threads=4
+accel = tcg,thread=single
+
 [h_cede_tm]
 file = tm.elf
 machine = pseries
-- 
2.42.0


