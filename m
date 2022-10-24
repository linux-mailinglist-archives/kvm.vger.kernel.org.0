Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC62609D97
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 11:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbiJXJN1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 05:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbiJXJNW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 05:13:22 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E27867C99
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:14 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id q71so8180612pgq.8
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1HCdfoJ+ufRET4NO1GLfMwugudiiGl/j2xp9aKOsdco=;
        b=HG/onTOfg/WGUNTCcxGcy6ULR4bPodLRPz6cptMTKyroFFng2v//dZPOjhUsHmQUgE
         X3e+5tmnTXL2GHbU6IhmJY1J2PgJi/X90DHCcJnweIfNzgOTweMyZtKZ/53ttI6FrD5G
         0hdBfsIHxo9sXyKnOi/7ZfBFG9A/6CYidWB13J9mBxS297MD9tlfbQnQOSTP/QeZ7k8C
         9xCnMXnxxdki0ByWs1mr+1i5OODh4MD/sAlZJwobdFie3Q1Qq8/Jtqcfl/R3pKNvvwxK
         aozix2UbCbH3Ai3lGy2zLUurdirLl/I5skvRK4RPZ9ls4H08ZWI9O0H9Ma65bqh3ZmUo
         SI3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1HCdfoJ+ufRET4NO1GLfMwugudiiGl/j2xp9aKOsdco=;
        b=7RS3lLorTlv5Eaj9/AwWviGc6HDQt0KvB7s55mswKo3qltRjbaA2kTL3ricN6qrOZg
         2rpiXkRnm5TQ52ITde18CwFVPDdIPyqDpCcCyvI8jjEyF6x3TRCsJwU1zL/M8zYbkhPZ
         GuRSyY00Lx+p/V3iUQzaCr4GZChLhf3ZCwhKVXI6pJkB+Ceg8sVo1uxu9mF1WfZS0vGy
         XCd1BGrPtsshUDkc573HgRZeq7YiJe7LsZTWB3YEbDljHQPL53TxCyY9WE10ElaVCbsM
         D2p2rfgU/8yaxMb6jt1xatSj0ehHVmf4LQ2BV5jSCLoO8nFbWUIQErEOxOMdI+pDfZpT
         oLVw==
X-Gm-Message-State: ACrzQf0OrWc96LsiThs5WebmZAjOyJj2oVtGk63jAJD5zo99NcsYkfK3
        qIeAzkekpXcaXbiaJoGwTmQ=
X-Google-Smtp-Source: AMsMyM5KXwR1ve7iqQ6Kfww7rCHheuMQSdq5NVx0XAWanm/Ohyu1WrwbIYVVW+9kWy1Age+86c1vKg==
X-Received: by 2002:a63:d845:0:b0:44b:d074:97d with SMTP id k5-20020a63d845000000b0044bd074097dmr27888531pgj.32.1666602793048;
        Mon, 24 Oct 2022 02:13:13 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id r15-20020aa79ecf000000b00535da15a252sm19642213pfq.165.2022.10.24.02.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 02:13:12 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 07/24] x86/pmu: Introduce multiple_{one, many}() to improve readability
Date:   Mon, 24 Oct 2022 17:12:06 +0800
Message-Id: <20221024091223.42631-8-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024091223.42631-1-likexu@tencent.com>
References: <20221024091223.42631-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The current measure_one() forces the common case to pass in unnecessary
information in order to give flexibility to a single use case. It's just
syntatic sugar, but it really does help readers as it's not obvious that
the "1" specifies the number of events, whereas multiple_many() and
measure_one() are relatively self-explanatory.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 x86/pmu.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index ba67aa6..3b1ed16 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -181,7 +181,7 @@ static void stop_event(pmu_counter_t *evt)
 	evt->count = rdmsr(evt->ctr);
 }
 
-static void measure(pmu_counter_t *evt, int count)
+static void measure_many(pmu_counter_t *evt, int count)
 {
 	int i;
 	for (i = 0; i < count; i++)
@@ -191,6 +191,11 @@ static void measure(pmu_counter_t *evt, int count)
 		stop_event(&evt[i]);
 }
 
+static void measure_one(pmu_counter_t *evt)
+{
+	measure_many(evt, 1);
+}
+
 static void __measure(pmu_counter_t *evt, uint64_t count)
 {
 	__start_event(evt, count);
@@ -220,7 +225,7 @@ static void check_gp_counter(struct pmu_event *evt)
 	int i;
 
 	for (i = 0; i < nr_gp_counters; i++, cnt.ctr++) {
-		measure(&cnt, 1);
+		measure_one(&cnt);
 		report(verify_event(cnt.count, evt), "%s-%d", evt->name, i);
 	}
 }
@@ -247,7 +252,7 @@ static void check_fixed_counters(void)
 
 	for (i = 0; i < nr_fixed_counters; i++) {
 		cnt.ctr = fixed_events[i].unit_sel;
-		measure(&cnt, 1);
+		measure_one(&cnt);
 		report(verify_event(cnt.count, &fixed_events[i]), "fixed-%d", i);
 	}
 }
@@ -274,7 +279,7 @@ static void check_counters_many(void)
 		n++;
 	}
 
-	measure(cnt, n);
+	measure_many(cnt, n);
 
 	for (i = 0; i < n; i++)
 		if (!verify_counter(&cnt[i]))
@@ -338,7 +343,7 @@ static void check_gp_counter_cmask(void)
 		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel /* instructions */,
 	};
 	cnt.config |= (0x2 << EVNTSEL_CMASK_SHIFT);
-	measure(&cnt, 1);
+	measure_one(&cnt);
 	report(cnt.count < gp_events[1].min, "cmask");
 }
 
-- 
2.38.1

