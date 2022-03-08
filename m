Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4034D11FC
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 09:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344937AbiCHIUj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 03:20:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234091AbiCHIUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 03:20:37 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315263EF21;
        Tue,  8 Mar 2022 00:19:41 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id t187so11511575pgb.1;
        Tue, 08 Mar 2022 00:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=Nm51/asUFghrpGhLBb2l9PncUBM4Fnpu/MUp5DxQXsE=;
        b=c79I9kiJY1J6r2wf/s4lnZSp71zeNtQ2zuhM0ST/Hhusdmzk6evQR6moCABB6duP+V
         MTZkeyQw/CuDs/0gqUJOEdumJELtYZwaGNJQqm6lwlKyDsuufSOIaE4f44sYBWWvMb2e
         PrU8Avv2NLg8IoWkFsbE/cj2JvddveUjZPTUwRK7cntSpVT4POSJDHtveGmZUXrE/PxF
         buvQg6+W4YpZ+C9mNKBJFfEpvw4VNweqPe1cZkwBPi4UFAkuwnqV57DqdhLuR+qvrX9p
         Qw/UYD6qY1aKXRgn4YaRLn84e5loAmAixbWlD9DsXbXaveA4fNuwrJd5xqgMXOQ2en8b
         6mTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Nm51/asUFghrpGhLBb2l9PncUBM4Fnpu/MUp5DxQXsE=;
        b=7AvMHQ97Gm/3SjOgd4Q1VbLXhFPnsGcHDeXuoooicsA6PZnuyDnc1EPyiQAoacPfG1
         QmnOGQtZOncCZ0fIheLw0cyxfU2m7jbf+XiDYA36lMkXye/YsWQG80znk1pg/JLKX7ad
         fx8sI7KtDYuWKFy7dJiqay96TpVQlRBYdFyB3IWElWKtJ5dtc1grjn4un3QOZuX4PpGK
         mOtyeOJdWDwJYNtXhm7pnTUEwW4cjXV8tkgUdj8HOEdwXt4bj4CgnW9d+BVXU/DhKuoE
         9FdtX8A+QA5+rqHJUkjcaakPQFASgiEjpFbKAV/zyau+ZuKeIbXGrUv8ZNCMdUQgBKGl
         lRZg==
X-Gm-Message-State: AOAM532+Pp3TjmJNDc4qdBQuYD+9oJFPAoBY9TS8k3lcq9QArfOhTxyt
        seEDCp3UKdwhx5MQO1rPZeFWjeSWxbI=
X-Google-Smtp-Source: ABdhPJxiuB/vZK+oyI3F7Cw34nqjJeYWe2yjILgpOumEPTSbhfWLnmYLH93JVXrdbZGC1v1MEKjjHA==
X-Received: by 2002:a05:6a00:22c3:b0:4f7:7cb:26b0 with SMTP id f3-20020a056a0022c300b004f707cb26b0mr8171412pfj.47.1646727580533;
        Tue, 08 Mar 2022 00:19:40 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.112])
        by smtp.googlemail.com with ESMTPSA id mn3-20020a17090b188300b001bf3ac6c7e3sm1838677pjb.19.2022.03.08.00.19.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Mar 2022 00:19:40 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] x86/kvm: Don't waste kvmclock memory if there is nopv parameter
Date:   Tue,  8 Mar 2022 00:18:49 -0800
Message-Id: <1646727529-11774-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

When the "nopv" command line parameter is used, it should not waste 
memory for kvmclock.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kernel/kvmclock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index c5caa73..16333ba 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -239,7 +239,7 @@ static void __init kvmclock_init_mem(void)
 
 static int __init kvm_setup_vsyscall_timeinfo(void)
 {
-	if (!kvm_para_available() || !kvmclock)
+	if (!kvm_para_available() || !kvmclock || nopv)
 		return 0;
 
 	kvmclock_init_mem();
-- 
2.7.4

