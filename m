Return-Path: <kvm+bounces-16581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 310208BBB48
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 14:30:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C5CE51F21F7F
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 12:30:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 556BB364BE;
	Sat,  4 May 2024 12:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R1SEAZ/X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE4622F1E
	for <kvm@vger.kernel.org>; Sat,  4 May 2024 12:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714825802; cv=none; b=dj70SXxEu5NRnUPbV9fYs/0yZjjTkL4/pA63g2tMKZXaxjqqOipfXKdacCDvNwVYAP/4rMbxFHKadRBEgr77Junp8/ZRaGYLwmV6h+wyb8Yz4rHBu266QXq9x61dgwbx1Az/0beqjzTYs7muU7YTA0QS6EIoMUNck+K4qkcDqvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714825802; c=relaxed/simple;
	bh=bLgWQKMziaFfXXm0tNHQbZNeFsRAi0SRuS5vZ460W+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kms4RdWV6ZWjnehow1keDiHD08x8zEhqPQ6pVNT/iITL3KxvXl4tFYgVUH1szx2fYh0QaknbctMlE6B2nzH0P7b0r1cu1Qw9eMyPjr8Sw4rtUREEyDdJvDOFriq5O90wDvPCOXo3UA5NnO0zpCz2tICnEDDqEe9iD/3kvfJqQi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R1SEAZ/X; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-23d39e4c0d9so326827fac.0
        for <kvm@vger.kernel.org>; Sat, 04 May 2024 05:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714825800; x=1715430600; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z4h54USUHBKAJcfNGm1VvT3BcXAZlUGZA4uOX+ggTWE=;
        b=R1SEAZ/XWZw80hTzGcKPIwRQUAdUHgFRfn86T8SM1xg1CdkAZssI95IV0TMEkGUNVn
         gUke/WSWCOc7dCKulIFITqSclctboPQuVI83medkiMqOeFmZTWYnHL5PRNrH/AyPqFWZ
         loS1BukAPBVOjsi30BHuVM+3OYMwV91kFdgY2T82sE5+9jAQDwrhE+0MKjM7A3zMkvdv
         zr72lNjp+VsWPjgtBtCI3n2bNxojeE8p4+vWRYwdzmQpdRwZEKMszTjX3ZBh9PTBnJeP
         BeBXtfxJl2ob30rFXnkW2OEay1QnvZqsE9bo2LjtGVl3wfD2l7IH8UOoe6WlISiVej0r
         oAuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714825800; x=1715430600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z4h54USUHBKAJcfNGm1VvT3BcXAZlUGZA4uOX+ggTWE=;
        b=Uccxs92cl0Wcpk3QBdLIQiKrR0k8fU5p5fOQJ9sj3Ye3Jrv0V3oPh5lJhTMMV1GbjB
         EvUMBP+o/KnA9OSW1foZzapLz7kmlPuADOhTA8ViuZuYuVOHyJB5IEavWfDo3DfcUb0i
         IYJHWnjovvS+jHAFnTgnPunPFrQA60vUFfDzoWZ6rWz9R9FWBQ/sOGz6GgJK7f5eEvAE
         tPqzuSVPeCvqezn2nXXedAbHpYAAT7RiikkOv6CjSDp9UKuqBJlO/n9c+7bIltyCudnP
         f/0Ll2a4JIJXh6pQCDp2uxYzFh3Ex8OeJgPe8zQWXbGuUqRiio5KQcoClpsTYunUHFDV
         D6Cw==
X-Forwarded-Encrypted: i=1; AJvYcCUlUZjhX914FLAZ7vor7l/mm7SsuX2THDBPq81xOiC3LgJtfqb+vEW3XlfIIXHhLllXVj9e/5j23gxLve+HU3OyzNZQ
X-Gm-Message-State: AOJu0YzvS/SlyVNo362LnCCxQdAjNgRsTOON6tThTnqq5oIwUbuBs71F
	iBvxi6SXXqdXHqoGYDIkRAquU8Rh8G3WU8bT7TfJqhcQoiFBk0m48JE1QQ==
X-Google-Smtp-Source: AGHT+IEvzIyj5q/YWunpbhcGD2rfjuIoMmYhPDFOu5tKaJohsYhSC3wKPUC/yABZy9c9/DJ3fHCG+g==
X-Received: by 2002:a05:6871:5213:b0:23c:e7b:9208 with SMTP id ht19-20020a056871521300b0023c0e7b9208mr7091453oac.17.1714825800287;
        Sat, 04 May 2024 05:30:00 -0700 (PDT)
Received: from wheely.local0.net (220-245-239-57.tpgi.com.au. [220.245.239.57])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a000a9000b006f4473daa38sm3480068pfl.128.2024.05.04.05.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 May 2024 05:30:00 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v9 18/31] powerpc: Permit ACCEL=tcg,thread=single
Date: Sat,  4 May 2024 22:28:24 +1000
Message-ID: <20240504122841.1177683-19-npiggin@gmail.com>
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
index aa707e0f3..5c458996b 100644
--- a/powerpc/unittests.cfg
+++ b/powerpc/unittests.cfg
@@ -77,6 +77,12 @@ smp = 2
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
2.43.0


