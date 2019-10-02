Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 232F8C4B43
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 12:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727724AbfJBKWa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Oct 2019 06:22:30 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44870 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbfJBKWa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Oct 2019 06:22:30 -0400
Received: by mail-wr1-f68.google.com with SMTP id z9so5855398wrl.11
        for <kvm@vger.kernel.org>; Wed, 02 Oct 2019 03:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IYA27I4k+X20iMhTgUDiQt+Kq5nsLRsXVXPBklSSwWM=;
        b=K5gVLW+/19CuDqiUfAEqgTBp/wCUKyTN5LGJLQuQEV0ROhN/YiKVvzv+uC39cqKd1V
         hXrbf+0jiyIRoEzMGw5Jf77iBQLv883VS/43ka06txWzjYI4lDoVqB1v53Qog3TwJvdW
         PdKs61iUxcxfEFzgkeqGhDOf77tlV6FRIMm+DrwTUonYA5nAAh2QRjUA29vquUWnk1K+
         W+d5nrP398aE8LKZMDDubIm30ooGPm3kVdAx+1V8G3XxDEWSglkQFpTuI4ihZJHgbbun
         tewpIxjnqOozbwtNIQT+5xRbjcjAsm3bJ/YDaElpPjGpMG+z7wbBmJtmrgveBlf8Auz7
         QLOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IYA27I4k+X20iMhTgUDiQt+Kq5nsLRsXVXPBklSSwWM=;
        b=dXpqJePT5GKrQyHU9rsYWmDPx4U2LdBFjFB8UFzgueqkcPNLP4YYWkY7TwbzL/ASxw
         odzZMGlIcXXFzrY22zAEOXfu0boL/ppRDcPI5h1P/RC1OHL1b3QqvBzrOPjnoVTsZfVd
         HqK0WmoIJ8xvPcu0L7JISCeluMKS9kMZ3ymotlltq+p7jKORbj1mm6QacCckUg+Byl3I
         2te4c3Ujm5cZqXYnr2hiyHiBNPcGp9XM2yR7tQQVu/+OXY1VQ1SWyiLNCCYpwh+ruQwd
         RbjJTRZjo8F4MOnrmY9d4V4QHspIgdKyUk6iLnbvme/ELBU67GmUU8yLvqnSoojCnt9s
         0EEw==
X-Gm-Message-State: APjAAAVVUTgHwwNUEKt7wBSExX3fJQ1f4imHYopuBLslWZOOmuP2u4XP
        8ajFqV82+HhsDZbokCYUTVbq7Q==
X-Google-Smtp-Source: APXvYqxgRqSiSoPjrsprBlIeWNOCrME4vyWqfcmoAgUJonf+cuG6+6hd0A+XGFvc82HBKSLBvZpRYw==
X-Received: by 2002:a5d:63ca:: with SMTP id c10mr2195782wrw.314.1570011748341;
        Wed, 02 Oct 2019 03:22:28 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id a13sm48250121wrf.73.2019.10.02.03.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 03:22:27 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id DC71E1FF87;
        Wed,  2 Oct 2019 11:22:26 +0100 (BST)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org (open list:Overall KVM CPUs)
Subject: [PATCH] accel/kvm: ensure ret always set
Date:   Wed,  2 Oct 2019 11:22:12 +0100
Message-Id: <20191002102212.6100-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some of the cross compilers rightly complain there are cases where ret
may not be set. 0 seems to be the reasonable default unless particular
slot explicitly returns -1.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 accel/kvm/kvm-all.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index aabe097c41..d2d96d73e8 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -712,11 +712,11 @@ static int kvm_physical_log_clear(KVMMemoryListener *kml,
     KVMState *s = kvm_state;
     uint64_t start, size, offset, count;
     KVMSlot *mem;
-    int ret, i;
+    int ret = 0, i;
 
     if (!s->manual_dirty_log_protect) {
         /* No need to do explicit clear */
-        return 0;
+        return ret;
     }
 
     start = section->offset_within_address_space;
@@ -724,7 +724,7 @@ static int kvm_physical_log_clear(KVMMemoryListener *kml,
 
     if (!size) {
         /* Nothing more we can do... */
-        return 0;
+        return ret;
     }
 
     kvm_slots_lock(kml);
-- 
2.20.1

