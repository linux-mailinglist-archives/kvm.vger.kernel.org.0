Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB3051513F5
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 02:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbgBDBZK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 20:25:10 -0500
Received: from mail-pl1-f201.google.com ([209.85.214.201]:40973 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726872AbgBDBZJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Feb 2020 20:25:09 -0500
Received: by mail-pl1-f201.google.com with SMTP id p19so7190705plr.8
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2020 17:25:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=QUGZT2MVbSZ5vv9JAqfeam9eYCtpwd6NYyrPTQGL4Vw=;
        b=LMaPXvTVHWRjR4OY/kwNL2KfAHa8UpJCbQ0fB/vH0vTkR8weS3+o9HmWUvxODuRA4v
         9eGAqaftuBVncplz+Wug33AL9+V/WCN7uk+FPQfHd5+A1AsXHSPQlSeQaweYV0uSixD2
         +R7y90zPyGDs/57TAHOvUZrRDaToG9qNnQvZcYcBx92QXf7LzAJPBkrN8fwwAWzqO8xR
         z2+Fz4CR8lpoCEsdkzQo+V70TvTVhNfa5MSC3MpGeLYmhY9RxuxWO7+JNbPLoS67HTNK
         OLQ4bDNxSF/Zyg0ujWp5pA9GN9o3W70W9mJr4rJmiqr3bu4xFkH4ZeZl4YSzsyVQymwL
         IFJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=QUGZT2MVbSZ5vv9JAqfeam9eYCtpwd6NYyrPTQGL4Vw=;
        b=Az8qZy+pNCf6i8Auelh6q2K0p3k0cgfVyP+mJD/ILpZKH3XMf/FlPyywLsz6BP9Szz
         sODgQO+ePYpd+tcRmIB8vLbybNlAjoutTwUbM2++UFaPVxZf4PC3rpNTti2lkCGZ6bgk
         6r+Uz5Cymy2gWzia5+yLySFmY3T+B0cFetwKGi5qT0ctIOaBqxQUedPKd8vCtpeTscW8
         bvWV4mtxzgNX5Fz0EuGcgEitsfnuKxt5yCYHJJ098bsjF1FXzjRSQZl8wRDfwDXHuh7S
         1xM1RIfljlpajxFtQZGQOsNljfrpRY6klmxRpu/Xc0XgCfeWjrE0Xlk6qN4cggoww3Dm
         Y19Q==
X-Gm-Message-State: APjAAAVeTk/fVjEXXCuL+lZhUzVNRz33imuobVKxspIBI48xC3NpFVOJ
        GSQmIpdlyozdGKObQrmx1tBUw6Aeg2JSQRc=
X-Google-Smtp-Source: APXvYqyOkoVhkCWzz0zCy43+eQxoSu+yTApt3/SxLxfSIAKMDlDHWIT8cwq3rPNiC0x1HQmUNKFf5+CNs1BjSLo=
X-Received: by 2002:a63:cd04:: with SMTP id i4mr20017956pgg.281.1580779508971;
 Mon, 03 Feb 2020 17:25:08 -0800 (PST)
Date:   Mon,  3 Feb 2020 17:25:04 -0800
Message-Id: <20200204012504.9590-1-ehankland@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [kvm-unit-tests PATCH] x86: pmu: Test WRMSR on a running counter
From:   Eric Hankland <ehankland@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Eric Hankland <ehankland@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ensure that the value of the counter was successfully set to 0 after
writing it while the counter was running.

Signed-off-by: Eric Hankland <ehankland@google.com>
---
 x86/pmu.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/x86/pmu.c b/x86/pmu.c
index cb8c9e3..8a77993 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -419,6 +419,21 @@ static void check_rdpmc(void)
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
+	report("running counter wrmsr", evt.count < gp_events[1].min);
+}
+
 int main(int ac, char **av)
 {
 	struct cpuid id = cpuid(10);
@@ -453,6 +468,7 @@ int main(int ac, char **av)
 	check_counters_many();
 	check_counter_overflow();
 	check_gp_counter_cmask();
+	check_running_counter_wrmsr();
 
 	return report_summary();
 }

