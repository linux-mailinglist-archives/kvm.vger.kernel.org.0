Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032563B59F5
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 09:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232433AbhF1Hqr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 03:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232103AbhF1Hqq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Jun 2021 03:46:46 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D288C061574;
        Mon, 28 Jun 2021 00:44:20 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id e22so14741992pgv.10;
        Mon, 28 Jun 2021 00:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KS1knKUidrLccDLlGBOty0Yju70nzZmvxoRoS1cSJVE=;
        b=nRd3J1xMnY6Xmw0GJVc0BWZ7l/pv3U9rgVw4iBoKDGvq8ANN2Obcu5daAIjBvi/zsX
         sqlmgvPeh13khN48H4yEVRbNlLY3PBH4Z5r8UoAQFy6J5uZWPzBwlcVgJJcD6U8odJ/h
         bUraAVbfiazQycaeDbviXSJSVFAg5R7ENG6vUbP6b7TQOW23vLQBWb8eYWA1zgdZ6cah
         pQAN0AfSuhxtebZWwwP89Kst2RnpfYuY+hL38B9yzhiHz/LETwx2cicuVq/4vKjeSrmS
         ofKXYhlby4z5Re14WPhlUxbe23Z7V8MSE3I8N8ORqazoYxe+/lLbS4ZMPs+8jhrcRS/b
         GdWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KS1knKUidrLccDLlGBOty0Yju70nzZmvxoRoS1cSJVE=;
        b=GjqH6wmnKJI0gBy3PgZ52DN+C+ZqzfeIgBGuGKgmpyy750WQQsEykVrnAGBxebnwBB
         G6CaFQ9E37cz1jrnBk57/CKgk1a/LY9zaKrDI/w+08hG4CgMUOVRapkrCPWZD46GnHpK
         y7e2kdMKvltyWZpNZdR/Ppx/a4llJadpFpsZ1ZAewIjOIaZGxxn6HUq77PZs20o0kxkh
         kEpZH2mT4g/yQGFxCFZgvgkzy6ghImt5cmSADs00MJ1maHfVK+N7OLMc1MsYqnvrWkrJ
         gwEpS5LBD9nYRLN4zWJbwWrbz83JVVVV0sb33jsp362bwq0AF3j0duKY4V+GnNJrS8tW
         KfDg==
X-Gm-Message-State: AOAM530Dl4kEgC6CFcVS1dNQLNXHIvwiOpycSbLRff9T3EKVhXCK97SJ
        fGrbr1BdMWv9nU0V9LGgRjQ=
X-Google-Smtp-Source: ABdhPJydhq4EWutI0RUsW02q2keZzoybl7UllfYxVKqZbLAM8pco2qa1sne4FC1Vc1sjobfNReJ7FA==
X-Received: by 2002:a62:768c:0:b029:2ff:2002:d3d0 with SMTP id r134-20020a62768c0000b02902ff2002d3d0mr23409719pfc.70.1624866260185;
        Mon, 28 Jun 2021 00:44:20 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id l10sm19016634pjg.26.2021.06.28.00.44.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Jun 2021 00:44:19 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/pmu: Clear anythread deprecated bit when 0xa leaf is unsupported on the SVM
Date:   Mon, 28 Jun 2021 15:43:54 +0800
Message-Id: <20210628074354.33848-1-likexu@tencent.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The AMD platform does not support the functions Ah CPUID leaf. The returned
results for this entry should all remain zero just like the native does:

AMD host:
   0x0000000a 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
(uncanny) AMD guest:
   0x0000000a 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00008000

Fixes: cadbaa039b99 ("perf/x86/intel: Make anythread filter support conditional")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/cpuid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0edda1fc4fe7..b1808e4fc7d5 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -765,7 +765,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 
 		edx.split.num_counters_fixed = min(cap.num_counters_fixed, MAX_FIXED_COUNTERS);
 		edx.split.bit_width_fixed = cap.bit_width_fixed;
-		edx.split.anythread_deprecated = 1;
+		if (cap.version)
+			edx.split.anythread_deprecated = 1;
 		edx.split.reserved1 = 0;
 		edx.split.reserved2 = 0;
 
-- 
2.32.0

