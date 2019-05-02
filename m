Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF43C125E7
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 03:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbfECBDV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 21:03:21 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40898 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbfECBDV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 May 2019 21:03:21 -0400
Received: by mail-pg1-f193.google.com with SMTP id d31so1859355pgl.7
        for <kvm@vger.kernel.org>; Thu, 02 May 2019 18:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=aZvP+zyYNFo4SLe3scQVRRCWwkZOcCsmHU1UU9V8wvo=;
        b=EuNCLAIgAuLn51zN96NEAlTy2T9KPaSafVDDOBReDyy7mIJy7cdi3w5iJHEHdcfGUo
         BRZbLG7ZQt7zwfAu255fxLs+5hr0xYNAuAwj02J6fha13FX4mPSOE3Cs3EI+3ALtdJZJ
         tkaSoEYVB7LeHRWK+tQMixYGUU6MygNL9g7P5WSyWHO1Z6JNHpBO/WhF+sg4g8EJWJXs
         NvgzhSS3H5o4b1PafU/P32NZpkQXbu6N+OkJfy0c6fy3YHfv3qSrg+qUg8UuPVH1S6HI
         Lw810AUb9MQPGxorRARZaqDowQT7W0cK1xdo+lz/Nx2W4v16lQILlcSIiBdM6ECFL+BC
         2zew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aZvP+zyYNFo4SLe3scQVRRCWwkZOcCsmHU1UU9V8wvo=;
        b=UmB2jL5z00IRlGBpEFruaGf5Ncwe651h2NEn69lCzzbi3ZTnVA6RGvF6hfm65eLwbV
         0SNFr0bGfgnq8jfNj2boJt17JyJ+PNrKsNJw8TjIbM7ewfgQYe6TPu829tO4DbF8oVRh
         +x4x7C7Bepk287vyYoudIRFuVu23zPAL6PByoZPIc/ajrRfUwi3jb8aKY9+qLOlBDM38
         C4YbnfURvlyMRxr7KncRkB0Rsd/z/4YZZjXk6me08KuityMPBjnpLl7VoYoBxqXTbpl3
         yoouMGhNGBA2KeBVlOBhBduH1ZbZFuY10/5U0CN3zQAAyPhBpu/yZpV67AcNrkWW2UAb
         769g==
X-Gm-Message-State: APjAAAUZIrczIBUdHDV+P/by5/kK9paIn1gER2KTOwLWHqsaYZmodVRZ
        k7/ntHcCmvTda2Mcsk0uOlo=
X-Google-Smtp-Source: APXvYqw9ztKOksvwl07y3GsKlIqPd4VmoM1kWKXXkMqxbQqWODRZ1hVkcMfwXbX0ojMDMkYNqY08Bw==
X-Received: by 2002:aa7:8e0d:: with SMTP id c13mr7606794pfr.193.1556845400163;
        Thu, 02 May 2019 18:03:20 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id 128sm501358pfg.70.2019.05.02.18.03.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 18:03:19 -0700 (PDT)
From:   nadav.amit@gmail.com
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH] x86: Unmask LVTPC on interrupt
Date:   Thu,  2 May 2019 10:41:25 -0700
Message-Id: <20190502174125.8706-1-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <nadav.amit@gmail.com>

According to the SDM: "When a performance monitoring counters interrupt
is generated, the mask bit for its associated LVT entry is set."

Unmask LVTPC on each interrupt by reprogramming it. As the old value is
known, no need for read-modify-write is needed.

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 x86/pmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/x86/pmu.c b/x86/pmu.c
index f7b3010..6658fe9 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -184,6 +184,7 @@ static void start_event(pmu_counter_t *evt)
 	    wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, ctrl);
     }
     global_enable(evt);
+    apic_write(APIC_LVTPC, PC_VECTOR);
 }
 
 static void stop_event(pmu_counter_t *evt)
-- 
2.17.1

