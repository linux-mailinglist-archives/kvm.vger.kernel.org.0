Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3992C16FB22
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 10:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbgBZJop (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 04:44:45 -0500
Received: from mail-pf1-f201.google.com ([209.85.210.201]:36687 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbgBZJop (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 04:44:45 -0500
Received: by mail-pf1-f201.google.com with SMTP id 6so1758273pfv.3
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 01:44:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=PBRYnIoV16uqyH4JmWNsaFktK3dmGET/qpGByqmujow=;
        b=rhDAbplKaH64XrsJAmvMtnimK/aTADpfEVX3NKDL1B6aeVZ+3VhNR+mTrXm90edO9n
         jRVtaMzwDoEyBi6xOdPGFv8Cd2AEi8E9SOmhDvsUH9edYFs+29+z9Iz7ytafGfBv8RYM
         etIUL9uhMmhTyRIdbvVWtaRGs9EN4pCKUjcVJMyrzSRMsCA9HLDUHdm+99/5EtWWa4RM
         9mH+5MOOJJay2phpDrdb6VZ7GmLd9EcPJ3KRcv9VJkcGTR2QEs6pY5UvCBD5f0UfGe5s
         7HK3Z2oPV9PtaDluKp8SnIu6DAIDS1uWx++BQL+ua+wAHE+e7001UpG2539AVWbpAr/2
         NpNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PBRYnIoV16uqyH4JmWNsaFktK3dmGET/qpGByqmujow=;
        b=P9dPpOEbOkxgEp8oN0yWux1wuqRY1JB2yGj6JFLWcN8Jgdcj9MVlh1HeOj9L/WLuXD
         PrZY0Jsqf1BUNZP87yV3Q0LboLPmFXO42e67l3drCjgUD1A0OhOqT+3O1Ux5ZeV+/Q7l
         qqMFBHED5neH8IUwLCecV6ir6/MqpERDOnkrW6jZsDNL2kLAFVdocV2pibUkYtU8LE3U
         RB5N1ghjNLWkzAvCxj+TshGTiFFNuE9xYvAP5pr2JMR0alRSBNqGRC6uwAIL1PrtAMml
         c519N5vY2anoJQF2M8sx7S+lW+qX8W/lJVWQlGEzYl3WWIlH+frTxEYdHejaoyf0aLS0
         JPGg==
X-Gm-Message-State: APjAAAW9LtGUSiPrmkEmvrAnffOHfldDVXwUjdRaR1VSEcLfcKkPBVpV
        YalxEmV9S6vjZCBfuZ1+D2AprIY8i6gcEf89YhDCxSWdgpnHXCtBNuVwkcYy4/b+yJobZt7o9NT
        BadNhVJ/TjdzO4ngasyEHYydB7G7p54dF/sdLX8x8ul0+o48ifAgzuw==
X-Google-Smtp-Source: APXvYqwybOsPdYGUOXUMeRRh5YOjbhUYwb73Qj59M7gQNeQjD1IJSJ84ir742XGN3L9E8FM10rGu2bmnNA==
X-Received: by 2002:a65:40c8:: with SMTP id u8mr3040026pgp.188.1582710282232;
 Wed, 26 Feb 2020 01:44:42 -0800 (PST)
Date:   Wed, 26 Feb 2020 01:44:21 -0800
In-Reply-To: <20200226094433.210968-1-morbo@google.com>
Message-Id: <20200226094433.210968-3-morbo@google.com>
Mime-Version: 1.0
References: <20200226074427.169684-1-morbo@google.com> <20200226094433.210968-1-morbo@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [kvm-unit-tests PATCH v2 1/7] x86: pmu: Test WRMSR on a running counter
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org
Cc:     oupton@google.com, pbonzini@redhat.com, drjones@redhat.com,
        Eric Hankland <ehankland@google.com>,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Hankland <ehankland@google.com>

Ensure that the value of the counter was successfully set to 0 after
writing it while the counter was running.

Signed-off-by: Eric Hankland <ehankland@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Bill Wendling <morbo@google.com>
---
 x86/pmu.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/x86/pmu.c b/x86/pmu.c
index a4e483b..c8096b8 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -420,6 +420,21 @@ static void check_rdpmc(void)
 	report_prefix_pop();
 }
 
+static void check_running_counter_wrmsr(void)
+{
+	pmu_counter_t evt = {
+		.ctr = MSR_IA32_PERFCTR0,
+		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel,
+		.count = 0,
+	};
+
+	start_event(&evt);
+	loop();
+	wrmsr(MSR_IA32_PERFCTR0, 0);
+	stop_event(&evt);
+	report(evt.count < gp_events[1].min, "running counter wrmsr");
+}
+
 int main(int ac, char **av)
 {
 	struct cpuid id = cpuid(10);
@@ -454,6 +469,7 @@ int main(int ac, char **av)
 	check_counters_many();
 	check_counter_overflow();
 	check_gp_counter_cmask();
+	check_running_counter_wrmsr();
 
 	return report_summary();
 }
-- 
2.25.0.265.gbab2e86ba0-goog

