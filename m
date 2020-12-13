Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0AF2D8B36
	for <lists+kvm@lfdr.de>; Sun, 13 Dec 2020 04:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392992AbgLMDtV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Dec 2020 22:49:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbgLMDtV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Dec 2020 22:49:21 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340BAC0613CF;
        Sat, 12 Dec 2020 19:48:41 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id b5so4642983pjl.0;
        Sat, 12 Dec 2020 19:48:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/rkSHMlojCXH5HcNeMma4J+v/xy53IB23f7w2LPElmU=;
        b=EVNwfV5I90T9E5wxQytNgAQmw7uPec5es98+pvxsGjnTW7S/iPGeOo7aZMQAiZgHIt
         06YF0qpahKC/XxyUyA2bAS5k3o8V+hGGJ0FOK7UiuRCgcYPx2nlSnlQkx4+uj02rQdm5
         ibe1hUqytfRSIJ1NNKOD6SYITKDvGTbhqwtE0V+lxJPNoFyxkDhZGmV4wrneRZP67MGG
         /Q2GMASPZP55Kyz9a//iZpioORq3UaWF3bOYCZOrDzyxjsreOsAaJujfh6DMSkrVppD+
         TsApegmtJ1fCor7/11dN8syHiw9l24OWA3UyTaMkAgf2MySxKTB3lUAorY+KxMzI4KD+
         zOLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/rkSHMlojCXH5HcNeMma4J+v/xy53IB23f7w2LPElmU=;
        b=ICiI69eHIGOyWbreYBCH2tEY1uV7N5U2aKuNBSkkBUxa3dHwiOKKZ8Aar5txyxtO9N
         c/Xew16PMghix3HCK0iifHk7JSSLQApuYa2Shv9+2x19XbWG1I59vc8DnhNxJ03voVnL
         oY/b71fGQW0Iv5fHK8ZAB43Hv/4+acSRMI0QKORFDNK2QTUytqz7YTV06rZpPifeQ5tA
         aTipc0AxiP2+kya5ePTNif+6PTOd3HyANSe+FOGKMqp58Zk6QrW8FB/0YJjUol9naH8L
         xJ/S0sI+26EcQbLvz/RYe/wE5ZkCfNSBy7LuFsz7+Er0f/pxBJiJiuKkmNqwwHlVFXFE
         v1SA==
X-Gm-Message-State: AOAM533O7alzxh365cS9q9ruQHUJVBpFh2swxUR3qHJhZNE53JQlyfLh
        SMTqfUkgjNCcvDwiaGGt0D+pipM6r0rr/g==
X-Google-Smtp-Source: ABdhPJzzvPl38bay+gvAQcb3Ia9CmxQMfSPrl4F4mwZpCo0Vpc70AhI6Oj5UailreqoqW9vokCifFQ==
X-Received: by 2002:a17:902:8f82:b029:da:f37f:79bf with SMTP id z2-20020a1709028f82b02900daf37f79bfmr17520254plo.79.1607831320510;
        Sat, 12 Dec 2020 19:48:40 -0800 (PST)
Received: from localhost ([47.88.5.130])
        by smtp.gmail.com with ESMTPSA id l141sm16887356pfd.124.2020.12.12.19.48.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 12 Dec 2020 19:48:40 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] kvm: don't lose the higher 32 bits of tlbs_dirty
Date:   Sun, 13 Dec 2020 12:49:13 +0800
Message-Id: <20201213044913.15137-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

In kvm_mmu_notifier_invalidate_range_start(), tlbs_dirty is used as:
	need_tlb_flush |= kvm->tlbs_dirty;
with need_tlb_flush's type being int and tlbs_dirty's type being long.

It means that tlbs_dirty is always used as int and the higher 32 bits
is useless. We can just change need_tlb_flush's type to long to
make full use of tlbs_dirty.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 virt/kvm/kvm_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2541a17ff1c4..4e519a517e9f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -470,7 +470,8 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 					const struct mmu_notifier_range *range)
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-	int need_tlb_flush = 0, idx;
+	long need_tlb_flush = 0;
+	int idx;
 
 	idx = srcu_read_lock(&kvm->srcu);
 	spin_lock(&kvm->mmu_lock);
-- 
2.19.1.6.gb485710b

