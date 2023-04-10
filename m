Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BECF66DC5E8
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 12:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjDJKvd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 06:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbjDJKv3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 06:51:29 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24BF65591;
        Mon, 10 Apr 2023 03:51:27 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id j8so2214182pjy.4;
        Mon, 10 Apr 2023 03:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681123886; x=1683715886;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D3qItoPbhd1cS9wC/WtD5ihRlrUlFhuVlKz/oT0HlAk=;
        b=Hle8piowxX0J3XV9psl9ZEffGVGw/830cfh4j8jEWWSDjf+8wbg0iu/kbODfn9I3mf
         vZOgoFcbyGhG1YtybxsbVDbjCK+esSuZYvsBP/MAyqFmm/BSN3REl6qODlbXPFcAWFRF
         HK9bowYAX1p0s2u/EhhWzYT4ZduBa0OhsO0h4Dj7cZEkyWA+NGF+d4Ulc5dNbQcs95et
         kwyOsjf5R+YvjVv9L3lJZ4Xehz10C9jdqrpAc2FPPT1Y0FyA9xp3TW1uudGmDKpfkv5K
         KEi1f9ZY6XpE7FS+zD3PN4jnwX6qExOI/Hid7/SmdHKr0HtjEM7CpOdsmrbkkRPqXwrT
         pAfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681123886; x=1683715886;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D3qItoPbhd1cS9wC/WtD5ihRlrUlFhuVlKz/oT0HlAk=;
        b=T9o1IkPVKOdKVsFFOm5KSehqEEqkEqN+Q4xC7U4CeZyyfiP1mzcoLbCnFGAVbaf9+8
         CLYll3BbhFv3pp/tCSNht7ukBmhad1/vQfT4PUmTReT1JFFxX4fAgUwKqLfzhPYHelw5
         r+W+N9yezortM/mZGpm/b99t9D/LSxfpOXZQdeUB5fEo4IjXXxN09o46VcmqsXwZjIpn
         lYQ0O8pbJEKyryyTmJ16lX/CZDX6fC9/eTx8gwRHb3A8o7iYTPtHtkFRmR0b1yRabw41
         uZ7oD4nGkteznTm4Ys0UiuuazF0/58EN/2TdmGkPtOI1GlO7jf1v0BvSBi9lkeIw1C2b
         aCfA==
X-Gm-Message-State: AAQBX9dz2nqaQeIu1O/WlgJ2qeJiBKpAi5RdPH7C6fIZVVF+FL6cqyeP
        Q2b45Z3MgGC2oZSY5kTN1yvhbodTC+/YOA==
X-Google-Smtp-Source: AKy350bbohQFgi2m1hoUFUcSDjYbtbfgxweMKUYNJ1MsEQFKEzptj+2n3eKbO59XTHe7h3J0eIzyMA==
X-Received: by 2002:a05:6a20:1221:b0:e7:c39a:8823 with SMTP id v33-20020a056a20122100b000e7c39a8823mr10787565pzf.12.1681123886452;
        Mon, 10 Apr 2023 03:51:26 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h4-20020a056a00170400b0062e032b61a6sm7783252pfc.91.2023.04.10.03.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 03:51:26 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V5 05/10] KVM: x86/pmu: Disable vPMU if the minimum num of counters isn't met
Date:   Mon, 10 Apr 2023 18:50:51 +0800
Message-Id: <20230410105056.60973-6-likexu@tencent.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230410105056.60973-1-likexu@tencent.com>
References: <20230410105056.60973-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Disable PMU support when running on AMD and perf reports fewer than four
general purpose counters. All AMD PMUs must define at least four counters
due to AMD's legacy architecture hardcoding the number of counters
without providing a way to enumerate the number of counters to software,
e.g. from AMD's APM:

 The legacy architecture defines four performance counters (PerfCtrn)
 and corresponding event-select registers (PerfEvtSeln).

Virtualizing fewer than four counters can lead to guest instability as
software expects four counters to be available.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index dd7c7d4ffe3b..002b527360f4 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -182,6 +182,9 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
 			enable_pmu = false;
 	}
 
+	if (!is_intel && kvm_pmu_cap.num_counters_gp < AMD64_NUM_COUNTERS)
+		enable_pmu = false;
+
 	if (!enable_pmu) {
 		memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
 		return;
-- 
2.40.0

