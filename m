Return-Path: <kvm+bounces-12099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BFEFB87F8BA
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 09:02:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F17331C210A7
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 08:02:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C237654908;
	Tue, 19 Mar 2024 08:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KEPF0ZLh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B981E536
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 08:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710835269; cv=none; b=dlt7l11YLHuUcQN0XWKtugG6HYRQLa3rsom01tFASKS1N9dqGcSoLCEw5P9xpw3wgz5nVvkIvp+cup/PH7SmcGPoZeUxqK7Kplvti7HNz8YsQhd3/aVA5zKr7rUC1Du4DZuc83z39744EU2jg9dCwS2EhsedwtvctsmNAkjvrSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710835269; c=relaxed/simple;
	bh=DXAUJHnLdBPMFoQlmyy5xuq3fvLHyM7RzgWWp91uu2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R6b81ZYbn+3BxvXdszPodt4aWzh3kmHML1oIhncMfJKzGhJmfuAgGYRxDTW8njKdUommmsOTf8uUTxMcMX5RJjQLMvu5niThz68UKJFbgFvAIfkc/FWtiRkwF5WlI4xxBema+Ow6kXf1OBMBznpFEt9uwo0mgytjOjIamYTJ3Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KEPF0ZLh; arc=none smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-5a49261093cso1825889eaf.3
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 01:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710835267; x=1711440067; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hLN2zrrkD0RDiFTSfzL8j8/r0UbtD91MkKEokRwP4k4=;
        b=KEPF0ZLhFRLf3UW4vkp4Afqaqwff5RXcsTZ+qotkECfuvOJIcY6z+xek4Rz2GysUYv
         +Dnzssf7C7YPprfnD+QIZelJN5OMGSgyjG1+c+M7hksgV2bZPmdM8atdrHePYPb1EcA8
         R0X+ida1OYGtTd8YvTNyffRR5i/tBRTj1PWWarv907/Yo1nyuKr+9v8bQt3gvepBOBpi
         ra9e8KGEPHwo0WFm9xvh+RFVHe7IWE75cZi25BwLr/tjAcpeyjuU/ZGjJF62pdHX3nEV
         evg5X2lUk2gS3OY1bpc9SiPgCrBsU26jxgXIjHEiE483zldAXLyo6V8L/g2AC5Nax0rw
         Dg9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710835267; x=1711440067;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hLN2zrrkD0RDiFTSfzL8j8/r0UbtD91MkKEokRwP4k4=;
        b=YfYyYefiVcRLgvnWfCtWBQs0YatWqhLJfpWa6RME9NNKP8FgazeoPF8KZDw+bZQDJK
         J0frh3PWMLOfLo+ShVX0e733GD6pnA4sq2SouuFgw6tLZtuP1HT2XqKzUEYfwm4B0ghJ
         Nq8KElgiXigPmv2dy+wlMZgU7I4uzmhobag6ArhZZetGGGhfzs4rwsdHjc4yD0QNJWXM
         rLZlWayzV5lUoXqmU20XfK1jkporAL0R9AzrkNvvHmBgSQpTxHaENkm/JrMkfeHypAo/
         +En5ZIAmRV7qiHpa5Wn9L8w2cUYKAd6PrRLp0C4Z4ZFTAVLJEoHsB674uwf1nhq7Qy3C
         SHmA==
X-Forwarded-Encrypted: i=1; AJvYcCULfS8GnKDFP38be7dVTwGwn9I3XrfikVxX+yBpDN280WbcHRCy7VlO96q5JGJvg7+g0kOvaLiPUqiId/dTvyT7LrIK
X-Gm-Message-State: AOJu0YwYdRMJL1YZM4+q0pdWSyoS3eijXx6G/hxOuYE3BKshIkjlhLGl
	G+Kqqj9u8Lje77vI6Fn6h2hsfr3L7YD4OG5gUBjkwHUR0LL8mCkY
X-Google-Smtp-Source: AGHT+IFeHmGB4ze6kUtSa/hewyRt16k7UnWrqRYoKu2IK3oRrizTCfSNflyjrRy8gEqvoy5Wcy9Hqw==
X-Received: by 2002:a4a:7614:0:b0:5a4:75f2:54d0 with SMTP id t20-20020a4a7614000000b005a475f254d0mr9007064ooc.9.1710835266777;
        Tue, 19 Mar 2024 01:01:06 -0700 (PDT)
Received: from wheely.local0.net (193-116-208-39.tpgi.com.au. [193.116.208.39])
        by smtp.gmail.com with ESMTPSA id q23-20020a62ae17000000b006e5c464c0a9sm9121283pff.23.2024.03.19.01.01.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 01:01:05 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 23/35] powerpc: Permit ACCEL=tcg,thread=single
Date: Tue, 19 Mar 2024 17:59:14 +1000
Message-ID: <20240319075926.2422707-24-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240319075926.2422707-1-npiggin@gmail.com>
References: <20240319075926.2422707-1-npiggin@gmail.com>
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
2.42.0


