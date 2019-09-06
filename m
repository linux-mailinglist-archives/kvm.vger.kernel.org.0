Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFC12AB379
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 09:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730236AbfIFHt2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 03:49:28 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:38350 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727213AbfIFHt2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 03:49:28 -0400
Received: by mail-lf1-f66.google.com with SMTP id c12so4212011lfh.5
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2019 00:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=UvwpR0D53MJISg/ZERTKztEJ07NJptfmY7VJ59LQcZM=;
        b=cCzemkjLXSVSb5MJkMA2lAjuCJh79wlt2+KqFep+qrRTlGL41tJD/f8FCRKwWV2qWA
         /zawOez08ps09gy5cDB1Y2qjEebLaxLl1muZ1wNcKoqXSbti/2hxlRxOsVk0Ny0cJ6Ex
         zAm6aEemfjfDQJRJ+hhrRQMLjYq6ykHGeiUNVslcTUjw77erigHdat1s+7JBvVNbiznz
         90agUTPO38jnfJ2WJ0liQr125rJNk9QABk3jLCen23gLLAc2w6uA2apTVRmfjNWEp1aD
         QqEm9DCskmk1bSX5gOzF38WY+jEVvWULJa/RAFdL0wvF05O/EOCNrya/TuAyykRP/gqv
         mLQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=UvwpR0D53MJISg/ZERTKztEJ07NJptfmY7VJ59LQcZM=;
        b=tLVbQcA7HgrkrOlT5ADQL1NLFV9jzXzPNZ9UNfZgQWh+QFZS6p7KvDoXvgd9fpqmD1
         gB2YaDhhQTSezn+73nzZOR1Dw1BpYAVyXV2XMeDevqkijf7qYUdodjSw5TbqDSGQj1t1
         lb2Dod4jeRxxPPFxG1ROUQCz5DmE4VamyMa8PuO6eEzPjGnvVBptkmtiHhX19AtrrOab
         WYeJcIXQnrqsXyH1/twBCjtmEsPm4tv4zJ4GPhaP5+XUSg+iiucO5MWEEoXpjbK94ki5
         33OZrc9SlEjVmMl6yQldHhSzR8Ti2MdV8FU2GnlKtxs8hIKvDUfKfbByIfF8m02dcdx+
         lmEA==
X-Gm-Message-State: APjAAAXEfWZ0B24nWvrCuV4i1uvpxhEAmMIfqX043bbjzeeXFCYSPnLI
        25v3bXDae9zhbvgntG50HTWkDZ2U/4I=
X-Google-Smtp-Source: APXvYqxa6avYFbmfFBXmiFTLxIeErK/gT9+8P/j4rSf3RhM7mtTC5AulOvI1QItYttzx3d+gJmuRMQ==
X-Received: by 2002:a19:5215:: with SMTP id m21mr5427767lfb.89.1567756166352;
        Fri, 06 Sep 2019 00:49:26 -0700 (PDT)
Received: from wrfsh-ub14.yandex.net ([2a02:6b8:0:40c:f68c:50ff:fee9:44bd])
        by smtp.gmail.com with ESMTPSA id q13sm950702lfk.51.2019.09.06.00.49.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 06 Sep 2019 00:49:25 -0700 (PDT)
From:   Evgeny Yakovlev <eyakovlev3@gmail.com>
X-Google-Original-From: Evgeny Yakovlev <wrfsh@yandex-team.ru>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, yc-core@yandex-team.ru,
        wrfsh@yandex-team.ru
Subject: [kvm-unit-tests RESEND PATCH] x86: Fix id_map buffer overflow and PT corruption
Date:   Fri,  6 Sep 2019 10:49:19 +0300
Message-Id: <1567756159-512600-1-git-send-email-wrfsh@yandex-team.ru>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 18a34cce introduced init_apic_map. It iterates over
sizeof(online_cpus) * 8 items and sets APIC ids in id_map.
However, online_cpus is defined (in x86/cstart[64].S) as a 64-bit
variable. After i >= 64, init_apic_map begins to read out of bounds of
online_cpus. If it finds a non-zero value there enough times,
it then proceeds to potentially overflow id_map in assignment.

In our test case id_map was linked close to pg_base. As a result page
table was corrupted and we've seen sporadic failures of ioapic test.

Signed-off-by: Evgeny Yakovlev <wrfsh@yandex-team.ru>
---
 lib/x86/apic.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/lib/x86/apic.c b/lib/x86/apic.c
index 504299e..1ed8bab 100644
--- a/lib/x86/apic.c
+++ b/lib/x86/apic.c
@@ -228,14 +228,17 @@ void mask_pic_interrupts(void)
     outb(0xff, 0xa1);
 }
 
-extern unsigned char online_cpus[256 / 8];
+/* Should hold MAX_TEST_CPUS bits */
+extern uint64_t online_cpus;
 
 void init_apic_map(void)
 {
 	unsigned int i, j = 0;
 
-	for (i = 0; i < sizeof(online_cpus) * 8; i++) {
-		if ((1ul << (i % 8)) & (online_cpus[i / 8]))
+	assert(MAX_TEST_CPUS <= sizeof(online_cpus) * 8);
+
+	for (i = 0; i < MAX_TEST_CPUS; i++) {
+		if (online_cpus & ((uint64_t)1 << i))
 			id_map[j++] = i;
 	}
 }
-- 
2.7.4

