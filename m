Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5451F45D2B0
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 02:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353121AbhKYCBP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:01:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349605AbhKYB7H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 20:59:07 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1360C061377
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:12 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id a16-20020a17090aa51000b001a78699acceso3865313pjq.8
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=YgauJc5tfU2Dmjf+vdTu1RJ3GMI0gzrKiXCdNb+KUdE=;
        b=SVkn5yTUzhgrlmF85ko+zRYUWxRlvdZHqfgLKxPbkAnQ4LI8uGJEaTYTR8LQAM/+Ux
         16y3963PFxYNovuFqQnvm5b86VxfnXGpRmVEgmBba+tlli2XMeHNsZBCmb2uJNISjudT
         foGls658c6hXZHxZkCr6pLGHjJ4rJZfm/hUvobCLbnC6bn42Xs7625W/vHDNZqfzqQc6
         SuZ3S009EXvzJ39gpG91xcSQcSXu4cYRCuuoPPWk6mc4gBL0yoe81wbFs7neFwyFkXKu
         MHbWaS6CZbcGaWPxkpPokr4axD4dx+J8BzDTByJrY3NjBpCD+6572PfA89jXxh7Hy/td
         Z3iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=YgauJc5tfU2Dmjf+vdTu1RJ3GMI0gzrKiXCdNb+KUdE=;
        b=HCvtFzSkWXndKouklv+M7VJgTGEA8deliyQBHEDdXX1EqpuSJR45lAaSX1lyjiCktO
         DQFFR/WeT8mTxVCUnv6hLS2HDsiuPUinH4hmGJ+3BShsTf79QBxxyZEqSktOZNfHA2Ba
         kq+lKzoBcrvaOHC6rA3v07RmwB/7qeNLnnYOTCoUzLfcG7fCtcL72TokkWnPQSZ40aRd
         +1IYmjtXNOs6m405a7lm9zuKeDFZBdw6V26abQMqGfYQP0DUcaZCcA6X+wRHlGcdch3E
         rUtdLZh+EoAT2r02xCasLyVhMtRD0NQD89YjcVmcBltjLwhYj4w4SICpzfxFf45c2mQ2
         9cSg==
X-Gm-Message-State: AOAM5326LX61yVYgZUVsprJP9LWwXrPRq25REGbrzoIxlyhhmF53OBhA
        BFwL58F9zdHwdK3NPcbER+6+ouyVi6g=
X-Google-Smtp-Source: ABdhPJwk2EJP1CaMrRb0i4W3RUPzXux694lvyHTAp9ulNgBb6gCOn4ML5V91vuyLBRauci3n0tpvshS+tVM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1486:: with SMTP id
 js6mr625978pjb.0.1637803752115; Wed, 24 Nov 2021 17:29:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:25 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-8-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 07/39] x86/access: Hoist page table allocator
 helpers above "init" helper
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the page table allocator above ac_test_init(), a future commit will
handle all page table allocation during init.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/access.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index ba20359..f69071b 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -281,6 +281,27 @@ static void ac_env_int(ac_pt_env_t *pt_env, int page_table_levels)
 	pt_env->pt_levels = page_table_levels;
 }
 
+static pt_element_t ac_test_alloc_pt(ac_pt_env_t *pt_env)
+{
+	pt_element_t pt;
+
+	pt = pt_env->pt_pool_pa + (pt_env->pt_pool_current * PAGE_SIZE);
+	pt_env->pt_pool_current++;
+	memset(va(pt), 0, PAGE_SIZE);
+	return pt;
+}
+
+static _Bool ac_test_enough_room(ac_pt_env_t *pt_env)
+{
+	/* '120' is completely arbitrary. */
+	return (pt_env->pt_pool_current + 5) < 120;
+}
+
+static void ac_test_reset_pt_pool(ac_pt_env_t *pt_env)
+{
+	pt_env->pt_pool_current = 0;
+}
+
 static void ac_test_init(ac_test_t *at, void *virt, ac_pt_env_t *pt_env)
 {
 	set_efer_nx(1);
@@ -360,27 +381,6 @@ static int ac_test_bump(ac_test_t *at)
 	return ret;
 }
 
-static pt_element_t ac_test_alloc_pt(ac_pt_env_t *pt_env)
-{
-	pt_element_t pt;
-
-	pt = pt_env->pt_pool_pa + (pt_env->pt_pool_current * PAGE_SIZE);
-	pt_env->pt_pool_current++;
-	memset(va(pt), 0, PAGE_SIZE);
-	return pt;
-}
-
-static _Bool ac_test_enough_room(ac_pt_env_t *pt_env)
-{
-	/* '120' is completely arbitrary. */
-	return (pt_env->pt_pool_current + 5) < 120;
-}
-
-static void ac_test_reset_pt_pool(ac_pt_env_t *pt_env)
-{
-	pt_env->pt_pool_current = 0;
-}
-
 static pt_element_t ac_test_permissions(ac_test_t *at, unsigned flags,
 					bool writable, bool user,
 					bool executable)
-- 
2.34.0.rc2.393.gf8c9666880-goog

