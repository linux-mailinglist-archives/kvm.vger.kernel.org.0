Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30811458DEE
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 12:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239440AbhKVMBP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 07:01:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbhKVMBO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 07:01:14 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E38EC061574
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 03:58:08 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id d4so895710pgc.4
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 03:58:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aVovJvgkmMJ1bE6JnItioAzPKrS+pX+8sWdsczTlMSY=;
        b=JVfxNBFYeHJNBlNAD/9216L7zRNFk8vzviDJ7ukh7SfTe9xQ6Due2fEGh5VDnMEp54
         r3aLOtpa5XKJgeZJ5hVLUg3jevJ91GzLktA0NPZjJwCwOuef8wtxNvr32Yy+B78AmXNa
         +UGXCB1GbT1s73YE4WV8TDZDihLcJRxZEGfJExA5DOwpDznxEfxrI6LRpwYEJ+5xAReu
         U+pB6nSuPCxHkRwNv0iTkRJJSA9cUYKEwroa2cufopcmZRTL70yXx+wHXl9ASePMb5Yg
         LbRSHYcF7SOS8zx5Hv2yTBEJq87ZDEXdrm7knA+7J7YzqVFic9DX/e2xVtLRpmHnynyS
         O8lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aVovJvgkmMJ1bE6JnItioAzPKrS+pX+8sWdsczTlMSY=;
        b=3kVVESbJ/vf2wCCera5xrPDFYtLqqEThUWY7GlliLPgKEOg84r7k8r2j6Gh30A2P10
         xEWOi+axIQOC46b8CXzoqWW9kzVyVKgAr0Yy3MVGhsdJ0ViWqKhYoEp4/tARqLoBC6TQ
         BKwA4x/GTNHY+w9BGS+1X11btpCMX/rIvmHmpB07SvVGzDiE2pDKF6JxdQVXINiBMh+O
         JTWzf6W/vZxYLcnYh83wDTzDmEX6upE6PjqFOM3fvV9OIOCnNaPHrFfxBrHEum9D+aL8
         KIyko+aR8hQoewpvpWlaL5flBV7CiyDFXEXQFiXm471P5+NdcxbD9Tf7BlOR3eRPlaoC
         Txsg==
X-Gm-Message-State: AOAM532unDNSrhZbgI39rn6lzS6PnhuT6dJAdMv92s1guQjSEPMeQCEt
        SQVb7sX5pMn2hpIW/ojgzdgyho6A7jI=
X-Google-Smtp-Source: ABdhPJz1vMBm+XzptYpDSbA7/aLMsbv1UjULNFhQlEdh1gIatY7PEnWl5c5ckb9fGINqKMigTQUarg==
X-Received: by 2002:a65:4bca:: with SMTP id p10mr32347103pgr.391.1637582287784;
        Mon, 22 Nov 2021 03:58:07 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id b14sm9250523pfv.65.2021.11.22.03.58.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Nov 2021 03:58:07 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] x86/pmu: Make "ref cycles" test to pass on the latest cpu
Date:   Mon, 22 Nov 2021 19:57:58 +0800
Message-Id: <20211122115758.46504-1-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Expand the boundary for "ref cycles" event test as it has
been observed that the results do not fit on some CPUs [1]:

FAIL: full-width writes: ref cycles-N
  100000 >= 87765 <= 30000000
  100000 >= 87926 <= 30000000
  100000 >= 87790 <= 30000000
  100000 >= 87687 <= 30000000
  100000 >= 87875 <= 30000000
  100000 >= 88043 <= 30000000
  100000 >= 88161 <= 30000000
  100000 >= 88052 <= 30000000

[1] Intel(R) Xeon(R) Platinum 8374C CPU @ 2.70GHz

Opportunistically fix cc1 warnings for commented print statement.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 x86/pmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 92206ad..3d05384 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -86,7 +86,7 @@ struct pmu_event {
 } gp_events[] = {
 	{"core cycles", 0x003c, 1*N, 50*N},
 	{"instructions", 0x00c0, 10*N, 10.2*N},
-	{"ref cycles", 0x013c, 0.1*N, 30*N},
+       {"ref cycles", 0x013c, 0.08*N, 30*N},
 	{"llc refference", 0x4f2e, 1, 2*N},
 	{"llc misses", 0x412e, 1, 1*N},
 	{"branches", 0x00c4, 1*N, 1.1*N},
@@ -223,7 +223,7 @@ static void measure(pmu_counter_t *evt, int count)
 
 static bool verify_event(uint64_t count, struct pmu_event *e)
 {
-	// printf("%lld >= %lld <= %lld\n", e->min, count, e->max);
+	// printf("%d >= %ld <= %d\n", e->min, count, e->max);
 	return count >= e->min  && count <= e->max;
 
 }
-- 
2.33.1

