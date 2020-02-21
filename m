Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3C66168A0C
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 23:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729173AbgBUWmf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 17:42:35 -0500
Received: from mail-pg1-f201.google.com ([209.85.215.201]:54776 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgBUWme (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 17:42:34 -0500
Received: by mail-pg1-f201.google.com with SMTP id l17so1951047pgh.21
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 14:42:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=AYMrtaQFpEAhf4N2/PSLyY8BVuR8zCZktSQFDW5VeUU=;
        b=J41etYRpVeAqdqvHtns7EtNVVbjYCZAT4uPwTfXxmVxBP1EywH9V7naMIWd8JKOJSi
         K7Wn5PluMFO1qq21ZIL07fltzyJR/7kmvXNlng5dPs2SQ8GpoYrGYofV1WWHdxo3ts8x
         mrzNRWXAy2ANyWXWY9qp1ZADnIWwUhGpXShQ8UJAjBuePE7EXawDC7WOrps0GlX3lhfW
         nPR40Ce5lQAJwEmjc+x6h5EAsEP3JLWMUmEnEQA3zfzLNt9/C01LO/6l+IPk1wNCwsxz
         tNV/VKd+lyqLwVRLzzhKr/fkvAgWtgSWZREkCmpno7vHpmkwqywbD+kq5YMkBGM5Is2n
         4Gkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=AYMrtaQFpEAhf4N2/PSLyY8BVuR8zCZktSQFDW5VeUU=;
        b=D97JoEeQWPLAtBVPD6O6JlxNwwtrG4bp9eD7GP5SZ7kbg7hZyVMWkAxfNuTiP6h4rj
         ojbIeT7mue2FaBpBEN1kpo/Whf6izwQHiyrV3MjyIYSNk2XKarXiispqbA9riJord0VG
         4i4+xmxNYqnuEPI1+D2nTokt7iHWmDNKy5/2Y2dsmbQP90S5I+ow0g7hJwIQY0bAsFZN
         TJ5UF1iDiQCEXmBoCZf4judOTmePQllPIBrT0KC9105PhITyk/EZYXV1uDVA9avtnEL0
         zaM7xD9i4p9NbAcG+O0RZwO+reynPe44gUEwhnPt9ZO3j+ur8jOuySR8iAv48oGkXuhj
         7OQQ==
X-Gm-Message-State: APjAAAWcZvN/Hp8/0RFLUFYc/Wh1xvNfptBPs9gUX9SBFNFVw1Tt4TmI
        yVlrykKgMXnUhBDd8Ii+iIY+mlFR6HhoOog=
X-Google-Smtp-Source: APXvYqwhKRzJVoCpjzPLGuzmWUd8MIiF3zvv55ptCrBdix9MKGePuOLZi4sMXv45LyYtWbbT5/yE8lmhWXoMIAI=
X-Received: by 2002:a63:aa07:: with SMTP id e7mr40537889pgf.90.1582324952547;
 Fri, 21 Feb 2020 14:42:32 -0800 (PST)
Date:   Fri, 21 Feb 2020 14:41:33 -0800
Message-Id: <20200221224133.103377-1-ehankland@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [kvm-unit-tests PATCH] x86: pmu: Test perfctr overflow after WRMSR on
 a running counter
From:   Eric Hankland <ehankland@google.com>
To:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Eric Hankland <ehankland@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ensure that a WRMSR on a running counter will correctly update when the
counter should overflow (similar to the existing overflow test case but
with the counter being written to while it is running).

Signed-off-by: Eric Hankland <ehankland@google.com>
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
