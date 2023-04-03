Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23376D4153
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 11:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbjDCJxN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 05:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbjDCJwt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 05:52:49 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACAC1BF54;
        Mon,  3 Apr 2023 02:52:06 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id z19so27470084plo.2;
        Mon, 03 Apr 2023 02:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680515525;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IYesVtVaAhJA/ajSb+Aj1pLBMVkQO/KZX+wBwWZpDAQ=;
        b=SumYnLdjpOzBVt//ygioA9IzfhC6Y6LOmYxdP9b8AEi7kazu6WTW2wt4sVREo92fcz
         FGi9e9OPvj3jCrDA5uIFawTFKnaPZttEhgMxR9GrbrRBH9o/w8xQfI9iSb6eAahr7MV1
         uSb5fD3Hf7HdXLA776uhhqfxE43ZjmwJA8X6D4fPL+vsSqRO4+f2GTqCUhiXyYOtINlF
         Jt1X5j1Xkl85B4iHKrvLJKEFQk+H1SF/6V/kpS2UPqrKbtkCaaOnBmrVHmXJ2nz2j03r
         JnXDiFdoWukzLyxU4TvVo70fbqSmsqh82tj4K8vnDznBn7J+ZBGZiGNVDwHknYabMgyY
         Ck3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680515525;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IYesVtVaAhJA/ajSb+Aj1pLBMVkQO/KZX+wBwWZpDAQ=;
        b=jDHc5lJXDsyDjavKKjMZJUNUwXKplR6exMNNqqg/tkgGJ+4c2PRB1ARyQzI5X/zunY
         dAKXZrO/5evtJ2HJS+BiVkIC9Q7P7pdSpzgj3TOS8yprUXeLMXgpokGVsMWeO6i6eVEd
         0cB/cICguZ1xmnDUN1YBd6QNTwdpuCYLPIOLYVU3lh9MV1IM0YnyNbYzEnPur14n+gYi
         hUr06fwbjABd5n0ruhDgIK6eb7Ve8MwtyChc61fipntU+1WXHJFMimMfxwLn4avNMStD
         syxPmQuxPpZ65yF/vv8AhYjFn4FNQuiVfxecz+0dxDVrvAntuDEa45/etQ1WfjItTefX
         RyWQ==
X-Gm-Message-State: AAQBX9cbW9xZ4UJzZ0Z62yWsMQwNlvcP/0wnm2HpUhjtc91fldF1ayxK
        QGemX7sFqIeew9n6w2iNyFwJ44lj6kAX+CvZ
X-Google-Smtp-Source: AKy350ZnqrX6xM9QXo0wBf0NtDkge7mQaP0DWDiv5Mzz5/7YCh8PBAod1H9O+HCE7oBybsImJb/UJQ==
X-Received: by 2002:a17:90b:4ac8:b0:23d:3761:6087 with SMTP id mh8-20020a17090b4ac800b0023d37616087mr38197065pjb.1.1680515525644;
        Mon, 03 Apr 2023 02:52:05 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.4])
        by smtp.gmail.com with ESMTPSA id gx3-20020a17090b124300b002311c4596f6sm9260763pjb.54.2023.04.03.02.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 02:52:05 -0700 (PDT)
From:   korantwork@gmail.com
To:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, mlevitsk@redhat.com
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Xinghui Li <korantli@tencent.com>
Subject: [PATCH REBASED] KVM: x86: SVM: Fix one redefine issue about VMCB_AVIC_APIC_BAR_MASK
Date:   Mon,  3 Apr 2023 17:52:00 +0800
Message-Id: <20230403095200.1391782-1-korantwork@gmail.com>
X-Mailer: git-send-email 2.31.1
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

From: Xinghui Li <korantli@tencent.com>

VMCB_AVIC_APIC_BAR_MASK is defined twice with the same value in svm.h,
which is meaningless. Delete the duplicate one.

Fixes: 391503528257 ("KVM: x86: SVM: move avic definitions from AMD's spec to svm.h")
Signed-off-by: Xinghui Li <korantli@tencent.com>
---
 arch/x86/include/asm/svm.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 770dcf75eaa9..e236b896f8b4 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -278,7 +278,6 @@ static_assert((AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == AVIC_MAX_
 static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_MAX_PHYSICAL_ID);
 
 #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
-#define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
 
 
 struct vmcb_seg {
-- 
2.31.1

