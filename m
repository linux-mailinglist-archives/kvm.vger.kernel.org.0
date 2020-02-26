Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD79116FB24
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 10:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgBZJow (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 04:44:52 -0500
Received: from mail-pf1-f201.google.com ([209.85.210.201]:51472 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727889AbgBZJow (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 04:44:52 -0500
Received: by mail-pf1-f201.google.com with SMTP id z19so1730797pfn.18
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 01:44:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wRyIfQ+yBKlCBnulhiFZpryj2XrdoxqaIouRCyTVEcI=;
        b=fXil2h7j1nvN0SHTLgrUoFkyyXOUU9jFN2TWm7a+czvs8tLQkRKWf4JYGallaA7PQv
         ke9GdHezApgCAEMbRLGsyVhwO5Gg1SYmV8gSLnNushipgE2aYwdJuGmB56Yk1PK2nTYl
         sSU88etPZCDfXd6YW/Fx16WbGfimQPWDK09skMGdSdmH0NDKKCP+RRxkxE0hXiWWrews
         9kQ4th79GG88zak/jAL5/qsHJ/T6wBJwuWwuehIaEyF7js/oGLsUek3szS1r4HPtrojW
         EQgEsNsgce5fbWCPUxKLDfSvPFOYZuynOz5XLk+G+p/eHEUiGf2RgA8ORZkX/1GsyRtE
         Kjlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wRyIfQ+yBKlCBnulhiFZpryj2XrdoxqaIouRCyTVEcI=;
        b=DLzSXcbEdV/4zXRkSeWn83sxevNvEy4TqGGAbJEh/MPCwK6PiG/Tf6L5tDg8a4uEtt
         6P5k8chGnZ56r4HL98RfW/xJnVpYzxkktcQn+6JmPlXjmhozYP5NHYnEj+FTfpMdRHST
         /5UK79keURYTwHvdk+JEIrDmA49PFIs8hC6pwa/rYEuBLfcnB4EY8NQhY0LbWQWd36g1
         F2Z2mFaBcs113kdDvO2m4zl7Y+oaHip1u68EF5C4C/DSKLwxVm0KWqkJfO1k36a64Vaq
         n8wCt+A8qIwABqP6imDEWTCD27tNArZnb0VBWf+sgqDRM3I4cDhKJ+jreWNwAEgnykGp
         FfVg==
X-Gm-Message-State: APjAAAUxSo3dbj9DAbgjquh/d7bzuWepZAtTDtNSHkpTwEp2jtvGQNUi
        qYmPFW+DT9xvijN2RI/DjDNE1QEASpeLWJ04EQds26I7L+7YMVymi3N9Lzet7rqlw9o39Ts7oOg
        psRUNnMdIaF0Pdyj4WBlyuc2JbLJ++CKZr2SI+oTTx/4EF6kmtnzdlQ==
X-Google-Smtp-Source: APXvYqyrKWxW8wFhBJQbSxhK1me3NTwfu/AyUNmB4a6X6kKdJ7kVSJcZUtNuk444qNx4q6IJxOSyxZHCJg==
X-Received: by 2002:a63:9143:: with SMTP id l64mr2933069pge.75.1582710289699;
 Wed, 26 Feb 2020 01:44:49 -0800 (PST)
Date:   Wed, 26 Feb 2020 01:44:24 -0800
In-Reply-To: <20200226094433.210968-1-morbo@google.com>
Message-Id: <20200226094433.210968-6-morbo@google.com>
Mime-Version: 1.0
References: <20200226074427.169684-1-morbo@google.com> <20200226094433.210968-1-morbo@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [kvm-unit-tests PATCH v2 3/7] x86: pmu: Test perfctr overflow after
 WRMSR on a running counter
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

Ensure that a WRMSR on a running counter will correctly update when the
counter should overflow (similar to the existing overflow test case but
with the counter being written to while it is running).

Signed-off-by: Eric Hankland <ehankland@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Bill Wendling <morbo@google.com>
---
 x86/pmu.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index c8096b8..f45621a 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -422,17 +422,34 @@ static void check_rdpmc(void)
 
 static void check_running_counter_wrmsr(void)
 {
+	uint64_t status;
 	pmu_counter_t evt = {
 		.ctr = MSR_IA32_PERFCTR0,
 		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel,
 		.count = 0,
 	};
 
+	report_prefix_push("running counter wrmsr");
+
 	start_event(&evt);
 	loop();
 	wrmsr(MSR_IA32_PERFCTR0, 0);
 	stop_event(&evt);
-	report(evt.count < gp_events[1].min, "running counter wrmsr");
+	report(evt.count < gp_events[1].min, "cntr");
+
+	/* clear status before overflow test */
+	wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL,
+	      rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
+
+	evt.count = 0;
+	start_event(&evt);
+	wrmsr(MSR_IA32_PERFCTR0, -1);
+	loop();
+	stop_event(&evt);
+	status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
+	report(status & 1, "status");
+
+	report_prefix_pop();
 }
 
 int main(int ac, char **av)
-- 
2.25.0.265.gbab2e86ba0-goog

