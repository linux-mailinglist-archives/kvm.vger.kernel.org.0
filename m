Return-Path: <kvm+bounces-13663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E885B899806
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 10:38:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8909FB21A79
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 08:38:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95061160782;
	Fri,  5 Apr 2024 08:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AS1UiTUZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FE015FCEA
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 08:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712306245; cv=none; b=A0TlZ5F6m4oHaBso6nmEYKwEd4noUS4C2BPKRdB2i9r1TW8vRT+JDZuEOjX2E14z5UslkMrEUFbs28eM9GzWKv8fHW7UU97brFDR/xJbO6FK6AvQ2jaIQuP3M8NWERP3pYlAHsnh+up1FkehkYvfDsHi/dvDDZVt0V2y3TFOYh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712306245; c=relaxed/simple;
	bh=jb4RFHJvBcmS+ImIPRs6ccRzGg00txZHgvvQgsoUsYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ie4GjtQP1TOBMf9j95aD3w77eLRWEyh2kkE1oWSZqRLixfUwYnHArorVaZYEgJuo3RD05aWwHhMMC5Qv8DUXTCiN/a9GYOdEH33IozC0R00E/MsP353wjJjfbQbkA0E/VisYxxnZoQg4NruE9vqw2Cu50/cGg6h5DPS7lQvchZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AS1UiTUZ; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-3c397193878so1021430b6e.3
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 01:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712306243; x=1712911043; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IKkjA7IfVI+VKitW9SdzPybHeE1UNWoe/mszWlluEsY=;
        b=AS1UiTUZvs5Hi1JnmVAIpen0LSwpg5QROtiPtoSiwhI2Uqewuy4JkguTpNJ7DSrkCF
         z0spJ7PsOROenGxH4Qn6Lv3JcwGuB5pJx+hsrjx8FR2S6QXr4K0P7hGt6rt7QP60Obqy
         EhR+kNN7GV4DBUctdEjD6LoaFX93S9rqNS3bAWO/2KNHaohBae798ocG3liJWFc5YQp9
         nGsAisLQE5J76DbgJhmEwSMzD7qE4gokXqe4RW91EEB+/7aiXTucJfF18+TOJIc5lyMX
         3eeIW7qvkP0xiF7m/vDtCcTJwDhtRjATARyzaKxKUH/idpSC8mg3PqrXRa+bAXVV/clC
         bXpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712306243; x=1712911043;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IKkjA7IfVI+VKitW9SdzPybHeE1UNWoe/mszWlluEsY=;
        b=IJWTfQ2DOw7Wp1kmxyN/Msu6n07CR1YKcP6m5QG55PNNzMxFG2/OrZMc7q1I+b2o45
         T0dD9Yvm2VI4ysh2IM+aO56jaI0Q+3NkDc8c40lzih84AGQ4WlCAa5bXA6XWaouhM+ov
         uyqwccUKg4bhPi27n+gCaN7bxepMxa1IZQuwemq7imfrjJPsKSoKuek9BbWBA6N2cOJB
         hA5fQmupOEtYejv3wg21CRD0yfwNecn7hYm0+sxgzD7W+HXcBeDuZQNPpzg679eBascZ
         dD0CnvkqzdNvgSboFPj6w7x32KnKSoO/TINiyUL0mIllu6PAPbHr9E6kcOjcnSfwH7Xa
         xKjg==
X-Forwarded-Encrypted: i=1; AJvYcCWloqu7+yKn5Zd0ntQ+whNIXCEVsumonMDdcsnMez8H5p/mU2EukDj35hXvcWBVD5+q7MS97fuGyOyp691J0KG7/kkW
X-Gm-Message-State: AOJu0YykZBSHG954BxG7+/vMdhQpeQroOnh3Z/0QpCNvLKaU+QozEO0o
	9MPqKnf2TvHdh0VRwGX9ylcIYlZc0G91cu1Zy17cz9bNSoUMwVl6
X-Google-Smtp-Source: AGHT+IFRqbUpDUDagRDS3ABNTAPHJ7QAg+lf/LEbp46fczhD/Tr6jlz/XlSB5uAQN4tx5GrzEuqszQ==
X-Received: by 2002:aca:d03:0:b0:3c3:739b:7635 with SMTP id 3-20020aca0d03000000b003c3739b7635mr885679oin.32.1712306243474;
        Fri, 05 Apr 2024 01:37:23 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id y7-20020a63de47000000b005e838b99c96sm808638pgi.80.2024.04.05.01.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 01:37:23 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v8 23/35] powerpc: Permit ACCEL=tcg,thread=single
Date: Fri,  5 Apr 2024 18:35:24 +1000
Message-ID: <20240405083539.374995-24-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240405083539.374995-1-npiggin@gmail.com>
References: <20240405083539.374995-1-npiggin@gmail.com>
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
index ddce409a8..71bfc935d 100644
--- a/powerpc/unittests.cfg
+++ b/powerpc/unittests.cfg
@@ -82,6 +82,12 @@ smp = 2
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


