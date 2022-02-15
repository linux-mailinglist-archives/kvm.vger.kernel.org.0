Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2E04B6907
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 11:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236413AbiBOKQp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 05:16:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbiBOKQo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 05:16:44 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A61F27;
        Tue, 15 Feb 2022 02:16:34 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id x11so1128214pll.10;
        Tue, 15 Feb 2022 02:16:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=q3kUX6Dxx4EW1Q5ZjF1J+bSGyjInRYAGr/XgVtEwU/Y=;
        b=nPxTeFWWAv6mE/U4pkG4JwVAvqL0RRxxC40zcSM1FXMQvl8Rd4YmBff77YkqcJ++Uv
         x/qBLXXvsyhWtJYHp2m7R4tR2dheXwRNYXchhMSu9uUyoD9oXDWLOR6auGughQAxNDhT
         bKYqfj/mIEmYG3VyZQTaZN0b+6o/PIUdIFUCIK0xJ/7DnLxA5FvISyfvDNqU8P1gM9Co
         ox4Dflr9IDvhmKcFeuMPA8PQg8BOLpls2pFzxJpxoSN285yXNJxNJPg7B7psUkPSHNK9
         EY21opk6aBnTEO482iaVMAVdXRXOLEK8INAZZSCrYrpRWm3U7hJ8xhJSXDCwm5pnnpby
         cgdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=q3kUX6Dxx4EW1Q5ZjF1J+bSGyjInRYAGr/XgVtEwU/Y=;
        b=4lX6SMjMCnPuPsryeX0LOl4s0go+vN9eKT0gzYLdxSY6CyRLIibC3zAjoNbVXz6ima
         1vkgOzsB72sUhzvPrO+Q1RNiR/I2vXCxeXaC/Sd2xI0A7Ji+vC6XJgekQ4uh91DtkVIB
         nYFUo7rYcCBl3dNKVz8FLVuxmr5wJGs8CbF4/Ntnp+YRCloT1ZZ88tSVaeXUWTFfa5Fo
         66/TJOjPFEmbiYrj99ByVhz+JAQDcg5F8wTgQeVZqICJ+gAKrtX+MGG8c41lMq/lEIvm
         sPTvD/KnFT5Z29kgaUMI06rUXys1yop7Z19PNMSEzbkImq5uZMC3cfmHrdqlypr5eV8Y
         a9yw==
X-Gm-Message-State: AOAM533vKzJOiDJUMKI4JeYL7l0MWzddNS8Op+uv9LvzGcJUIX/9wWin
        eIfqwSdeRKzPy7i7RRiVMh+jGqGDZkM=
X-Google-Smtp-Source: ABdhPJzXLDtNDf6vXkKZ56LqEbeTEAdpk8VCEhQoieBRwJ8b41W4LvBIvkDnb1/Bl+VdPfI/6yB+2w==
X-Received: by 2002:a17:902:e889:: with SMTP id w9mr3350383plg.95.1644920193562;
        Tue, 15 Feb 2022 02:16:33 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.googlemail.com with ESMTPSA id gk15sm17798302pjb.3.2022.02.15.02.16.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Feb 2022 02:16:33 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] KVM: Fix lockdep false negative during host resume
Date:   Tue, 15 Feb 2022 02:15:42 -0800
Message-Id: <1644920142-81249-1-git-send-email-wanpengli@tencent.com>
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

I saw the below splatting after the host suspended and resumed.

   WARNING: CPU: 0 PID: 2943 at kvm/arch/x86/kvm/../../../virt/kvm/kvm_main.c:5531 kvm_resume+0x2c/0x30 [kvm]
   CPU: 0 PID: 2943 Comm: step_after_susp Tainted: G        W IOE     5.17.0-rc3+ #4
   RIP: 0010:kvm_resume+0x2c/0x30 [kvm]
   Call Trace:
    <TASK>
    syscore_resume+0x90/0x340
    suspend_devices_and_enter+0xaee/0xe90
    pm_suspend.cold+0x36b/0x3c2
    state_store+0x82/0xf0
    kernfs_fop_write_iter+0x1b6/0x260
    new_sync_write+0x258/0x370
    vfs_write+0x33f/0x510
    ksys_write+0xc9/0x160
    do_syscall_64+0x3b/0xc0
    entry_SYSCALL_64_after_hwframe+0x44/0xae

lockdep_is_held() can return -1 when lockdep is disabled which triggers
this warning. Let's use lockdep_assert_not_held() which can detect 
incorrect calls while holding a lock and it also avoids false negatives
when lockdep is disabled.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 83c57bcc6eb6..3f861f33bfe0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5528,7 +5528,7 @@ static void kvm_resume(void)
 {
 	if (kvm_usage_count) {
 #ifdef CONFIG_LOCKDEP
-		WARN_ON(lockdep_is_held(&kvm_count_lock));
+		lockdep_assert_not_held(&kvm_count_lock);
 #endif
 		hardware_enable_nolock(NULL);
 	}
-- 
2.25.1

