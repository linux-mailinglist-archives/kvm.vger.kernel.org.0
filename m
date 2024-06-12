Return-Path: <kvm+bounces-19406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 65554904AD9
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 07:25:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B66D1F21C99
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 05:25:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37F3A3A1CA;
	Wed, 12 Jun 2024 05:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fao7eFn7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DF938382
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 05:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718169859; cv=none; b=gGTH8PIvgzZMLKDVr5CVyuyHI5vzWWZHJ9bIBBHHvsFLvtXiuk1WFrFH29PwVlDniEW5zI2L/0gngVR/piBe41SmKRXT1gEx1pwW1NbZyICnrySU7Sg2EPU34wLkqx0vl8ItMqz+ZJRTaGMgJElBkRwNH/uiQbrV3l3iHg2Orrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718169859; c=relaxed/simple;
	bh=Crr7kDwPWvntzfO+2p4xcjuyMJ9kb9pI7leZk5jIgZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lwL1yrkQrpidycQRIMGXTLp4BfU7vhCb0INKWDd8AvRCYd+HdZjmlhyTtCW9/aCGBmxyp6Tb2b0dA5oK79CI+uaNhbOlI8WxgeH2FmTHN6V1JFp29avwMUvPeHN/xQprIizUKA0wFD0mVmwnjufuk3/zuG68N9MIUxvSJ5ysyWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fao7eFn7; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1f64ecb1766so49618595ad.1
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 22:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718169857; x=1718774657; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5+0ku7WxXf8a4yF3c/GUIfqXl1O0gtCpT9pSJtDXNTg=;
        b=fao7eFn7qBEZAA4AG4q/LjEn/t6Lq5NhPDESegYxRVVcpvWUC/yVG+GrOkZ1HE00OQ
         LHMVGBPC7AEvtYDuCu4ZEkbm5Az4x3vugfoRN91ClhV803mcvR0W8PVNT5M4C8JG8k1P
         LxgEp99wiqGcEfN7NJ/7Y01Z6PhE6VL48IaNO6lQ3utJ3yPBSnwQ5o3PFb43FtVq7V7/
         X0cfX8xrf8CuIuW76WoGCom6U25cZl44Iwat/QRUXQ6SiFLxY+OMluM6kR2P2xeGbkNW
         EPUjjLO8lWdVmp/J1LxFX3ZDpYnLTl/ZX45GrV09c35RetAzn08e8DYRrB5gt6Lg0q//
         FkCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718169857; x=1718774657;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5+0ku7WxXf8a4yF3c/GUIfqXl1O0gtCpT9pSJtDXNTg=;
        b=PoCmSC0F3G3BM3EbxMk1Smvz37Ahj9Q6t52RjKL4Q2PydDEdpuq6kro4OC43JVPzcy
         bH13VpEpd4qy4l2hs5t+DAtj33ISRtxsAnzK3LhmiyKfHfPSvDCrnvnZMiaofLr9xmg8
         qA6puXzPiYriFksIfyAbM6yMztgXBLUfa2KPJCE6lCWZTpLFuEZCLYIRA24aE5KnluYf
         TutGix6hcoLv/+iSmFtDfEHjXDKaRTe/LTxV1z+a7yPKVtZeU8EN8iapm0e4UjMn1Imw
         31wRYa18Uzb1kM7mczgoVx+s6dKJ5D8IgAJGkihoW7HW9QLgAY00CErW8eD/P3an7SXI
         PF8g==
X-Forwarded-Encrypted: i=1; AJvYcCWGLTeguBczYeQftXJnNh2rqzS1AMSiCbSETXjYkGx88W3Go7cGyJfKXesU5ipw0xu4XRnDvzConUpTvq48JFy6X5jQ
X-Gm-Message-State: AOJu0YwWYaHNGDhKdQCKyg88Pov9UCyfYkY7edVGxwvIKrRjQWwz2OSs
	wyIrbaRsTi9tkh7JzR2XhaUoUYRrpQkG/MP2dtRw742bzz+7H0Jt
X-Google-Smtp-Source: AGHT+IGCLL/DTPwhOwjk642AnhNGlQKNEEILHB9BJlkhVGPvbyRYZRdbWL10EC7mbPbpB1nAF0YMiw==
X-Received: by 2002:a17:902:82cb:b0:1f7:210d:cbc with SMTP id d9443c01a7336-1f83b7df5b7mr6622685ad.56.1718169857338;
        Tue, 11 Jun 2024 22:24:17 -0700 (PDT)
Received: from wheely.local0.net (220-235-199-47.tpgi.com.au. [220.235.199.47])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6bd75f711sm112170705ad.11.2024.06.11.22.24.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jun 2024 22:24:17 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v10 12/15] scripts/arch-run.bash: Fix run_panic() success exit status
Date: Wed, 12 Jun 2024 15:23:17 +1000
Message-ID: <20240612052322.218726-13-npiggin@gmail.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240612052322.218726-1-npiggin@gmail.com>
References: <20240612052322.218726-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

run_qemu_status() looks for "EXIT: STATUS=%d" if the harness command
returned 1, to determine the final status of the test. In the case of
panic tests, QEMU should terminate before successful exit status is
known, so the run_panic() command must produce the "EXIT: STATUS" line.

With this change, running a panic test returns 0 on success (panic),
and the run_test.sh unit test correctly displays it as PASS rather than
FAIL.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 8643bab3b..9bf2f0bbd 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -378,6 +378,7 @@ run_panic ()
 	else
 		# some QEMU versions report multiple panic events
 		echo "PASS: guest panicked"
+		echo "EXIT: STATUS=1"
 		ret=1
 	fi
 
-- 
2.45.1


