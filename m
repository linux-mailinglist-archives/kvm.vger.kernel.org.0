Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7401E3FE7E7
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 05:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239028AbhIBDME (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 23:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233071AbhIBDMD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 23:12:03 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B3EC061757
        for <kvm@vger.kernel.org>; Wed,  1 Sep 2021 20:11:06 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id x16so314645pll.2
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 20:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CHLsnGWpsJqK50+Ukbnar66EU9IVhNFBrNvVwTmtI4Q=;
        b=eBYcMoaeSAJ3sd3D/zptk6KVZGP+qEv0fP/9016YOGs+FhV3+q0ywaFIXTSOlVJ+F7
         4ssYGeAzoDLFnwX22eTDaGO1TPIJuGBe6pdBf3HwVHY+v2mBrTyR+KP91Qt+r5w9mOlM
         //E2XGGgLwgOCxnJ2351XzM9rCXVD6xBJ2GwY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CHLsnGWpsJqK50+Ukbnar66EU9IVhNFBrNvVwTmtI4Q=;
        b=iAWhdsXJWkweeDT+Uw6N5Eu34toZCl1hHLszNV5OJCswb2o7AYockuU3tr5k9jieb5
         w6owowMyeFTHQ2jsRa+MNMdjld5/La1RnAaO7CQyYrBdJiFFIiY3KQhtmoIwqImZVB1A
         Vlj7w+Gw6t513j1uIodV529hjy6lyFyjPi5eOx+CpZ6DihBNbNbqMaACZe0pf59yMEGv
         uuDr9eEbyv9NeKCZWFcOHaZ9+4b33x5/sMsV4tfopjvz4lCGoPjjeht3d3BGZ3YXMBUY
         kdXJ/77VpnwYmQapV65QyB616JvnfchUfqDwOAiTDqfFo4DNG2RAGfgBVXTfzjeyeNp9
         f+Kw==
X-Gm-Message-State: AOAM532ToFCtGcX8O7lAcS91Wl9tAESmEz3i03cBTyKaTULWUD2h7eUa
        gN96WDx2JytWXzq0zwwy/lLang==
X-Google-Smtp-Source: ABdhPJyAz5/uobWomjOh9Le2VVAiELvit+aqlMq5rd41EW7TeoaUyLmGL0aZsZOR1cjSF1HqXr0S1g==
X-Received: by 2002:a17:902:ff02:b0:138:b944:e0f0 with SMTP id f2-20020a170902ff0200b00138b944e0f0mr893276plj.34.1630552265751;
        Wed, 01 Sep 2021 20:11:05 -0700 (PDT)
Received: from senozhatsky.flets-east.jp ([2409:10:2e40:5100:156c:d5ce:54ea:e2cb])
        by smtp.gmail.com with ESMTPSA id g37sm339621pgl.94.2021.09.01.20.11.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 20:11:05 -0700 (PDT)
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Suleiman Souhlal <suleiman@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH] KVM: do not shrink halt_poll_ns below grow_start
Date:   Thu,  2 Sep 2021 12:11:00 +0900
Message-Id: <20210902031100.252080-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

grow_halt_poll_ns() ignores values between 0 and
halt_poll_ns_grow_start (10000 by default). However,
when we shrink halt_poll_ns we may fall way below
halt_poll_ns_grow_start and endup with halt_poll_ns
values that don't make a lot of sense: like 1 or 9,
or 19.

VCPU1 trace (halt_poll_ns_shrink equals 2):

VCPU1 grow 10000
VCPU1 shrink 5000
VCPU1 shrink 2500
VCPU1 shrink 1250
VCPU1 shrink 625
VCPU1 shrink 312
VCPU1 shrink 156
VCPU1 shrink 78
VCPU1 shrink 39
VCPU1 shrink 19
VCPU1 shrink 9
VCPU1 shrink 4

Mirror what grow_halt_poll_ns() does and set halt_poll_ns
to 0 as soon as new shrink-ed halt_poll_ns value falls
below halt_poll_ns_grow_start.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 virt/kvm/kvm_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b25cc69ab90f..c84b1447ca62 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3136,15 +3136,19 @@ static void grow_halt_poll_ns(struct kvm_vcpu *vcpu)
 
 static void shrink_halt_poll_ns(struct kvm_vcpu *vcpu)
 {
-	unsigned int old, val, shrink;
+	unsigned int old, val, shrink, grow_start;
 
 	old = val = vcpu->halt_poll_ns;
 	shrink = READ_ONCE(halt_poll_ns_shrink);
+	grow_start = READ_ONCE(halt_poll_ns_grow_start);
 	if (shrink == 0)
 		val = 0;
 	else
 		val /= shrink;
 
+	if (val < grow_start)
+		val = 0;
+
 	vcpu->halt_poll_ns = val;
 	trace_kvm_halt_poll_ns_shrink(vcpu->vcpu_id, val, old);
 }
-- 
2.33.0.259.gc128427fd7-goog

