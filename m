Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C922478667
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 09:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbhLQImG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 03:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbhLQImF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 03:42:05 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D54C061574;
        Fri, 17 Dec 2021 00:42:05 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id t11so1900845qtw.3;
        Fri, 17 Dec 2021 00:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=euNZsuO5chCnJL4h1RRy3rz6SEECSJxqExqR2vzYIgc=;
        b=JlZ33jI3dKjdOEJgC8wH4AilxnMZqHDPYsqsHW1wAOROGwwJZjFWb53ZKEPOaepKAJ
         n/hKq1qiMLl/EUBr6r9En2JP72cnEGK/S1xltCQNmn/2meQMvJG+YVrNCyvtfYsehQbb
         bw1O6fkyOj/emvJnQUCWIBA0DbycVeQeDUrOZhZc79RdM1Fh46jgdnzqpJJTWGzNLymH
         5BzVcJq740cmBHm0Gx/VotXUTXOi1R/FXV9rWEht8VYBW4eS+vtXyKDVElPXK53QMHby
         W8t0QCB0iQ2K8017GLS48aYOHjteDPQE+ixJM440251YVvYC02YVGwtRjAv8NRm6pUkZ
         PZsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=euNZsuO5chCnJL4h1RRy3rz6SEECSJxqExqR2vzYIgc=;
        b=o0GuPzn9nTiqyypf2y3MNbbINBDQErIc1rReamdvGCMz0zUg+I+aC6Fpk02QmCZ4FU
         GDOVtFCqgKQrl5ZhqD5IsIpxt1+1AKPKFMJfbNPaqhxoSZ5u8bs28IAy0E9xXtY+YcK/
         oqU45+HKB1LsUZ3grOPShr6hGIKX4dpoGmfvxK4+psv4TmZyqZsxJuQcZSxI6SsfG3yU
         1nUUDyrKWRiXmyl3v0LnJ4PV/5nQU4RyfpDUKc+5kDekSeFwrNNt3VJkgFctbq7Tim6P
         3FAucDP9j6L+t01zTIVXCjB4hMiMnsQN4+9Lf2rNRLfvqRgUQm6LznuqKIbaGWWhuTta
         ytlg==
X-Gm-Message-State: AOAM531j0fUSabrS69MlQLkbz2fWhha4xUaefMfuT7jcku3Ax3+yMYg9
        BR+8/vIhqIB19WQN6VhvfqE=
X-Google-Smtp-Source: ABdhPJxMefYN6bC4KnrtZQAOdWJ8jW/5MZDBAfR2DrXl7H+Ww4eegx09BSvolw6t8k5h+v92HXYLZA==
X-Received: by 2002:ac8:5c54:: with SMTP id j20mr1408448qtj.121.1639730524381;
        Fri, 17 Dec 2021 00:42:04 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id 14sm6436102qtx.84.2021.12.17.00.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 00:42:03 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: deng.changcheng@zte.com.cn
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Changcheng Deng <deng.changcheng@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] KVM: x86: Use div64_ul instead of do_div
Date:   Fri, 17 Dec 2021 08:41:55 +0000
Message-Id: <20211217084155.452262-1-deng.changcheng@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Changcheng Deng <deng.changcheng@zte.com.cn>

do_div() does a 64-by-32 division. Here the divisor is an unsigned long
which on some platforms is 64 bit wide. So use div64_ul instead of do_div
to avoid a possible truncation.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
---
 arch/x86/kvm/lapic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index c5028e6b0f96..3b629870632c 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1707,7 +1707,7 @@ static void start_sw_tscdeadline(struct kvm_lapic *apic)
 	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
 
 	ns = (tscdeadline - guest_tsc) * 1000000ULL;
-	do_div(ns, this_tsc_khz);
+	ns = div64_ul(ns, this_tsc_khz);
 
 	if (likely(tscdeadline > guest_tsc) &&
 	    likely(ns > apic->lapic_timer.timer_advance_ns)) {
-- 
2.25.1

