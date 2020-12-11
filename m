Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF532D6C9E
	for <lists+kvm@lfdr.de>; Fri, 11 Dec 2020 01:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394564AbgLKAfE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 19:35:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730504AbgLKAeg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 19:34:36 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F75C0613CF;
        Thu, 10 Dec 2020 16:33:56 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id p4so5839111pfg.0;
        Thu, 10 Dec 2020 16:33:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ofn+qwCdvU5zL1EmyJaz3NlaG2uiyQzoZVTIMzLIfWM=;
        b=eiHHVhCkWHULf2Tt3Yob7BaBni3m9kP8aFddsiZrtL7lTW7djoG9/saJ4DlVrRAeiS
         Wuq+7nCel7krxILaE1lSAzMoGW9+UVQf6dhxAOLu2UsPH2ug7IbTVTYNfJWQvDdulvyJ
         /xIsVdhLZKs6nTOkwsJ0UzKMW9SRTWJjfRxg4QO5XBcYEd+hvDsRhq/7ouNKwLRI4trq
         grXiHTVQGkFS65CA7L6h26fSmy32bbhUvFc8QJ+dLBCP/wsXzL1BAUGmlMCmpo4AMi2f
         pWEUP8ylvFSLR28dFjurA5xRcyn1D6wF+4UwZ4+cJyegUbxrSSKUIWX35dOxkQ5ffsKP
         7g0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ofn+qwCdvU5zL1EmyJaz3NlaG2uiyQzoZVTIMzLIfWM=;
        b=H+aJvLVeyU1u8a4e4V+T+teKjPzUrf1Ocz8Wvonv8QloZxS+rF2fOzlODVtsigR02W
         21py6FsYsMyD1FzHeP5J2tvs82IQDY+QH9YTxnLNSGhNMMvN/1ZXcn2Di5/JmS1Q00cE
         JlMsYmoSX+nIWVo/Cc5f72awLWTRho0bFgh6jUzXYekwCoTxnpzlD1vNBE50xuGb5fCt
         s2w5cWYHjsbrE9G/obWp0TP5xvmnCBSSmBJy7IjvWQdlpyuB2zpiukXUo+/b7leScWyT
         R3/VnBB0lYPVX/t8sphtVgPOzx8MkN1nzMSi66NBzEhtfRY7svMlLcM6K0TWMkchBDrr
         ZcXQ==
X-Gm-Message-State: AOAM532PT8AICn+YnT3ktZyAJb6JLti9f2BUGXsRKimzwP11Zi+/Ma1S
        cYAkAKjalzXTI7YbFCf8nkw=
X-Google-Smtp-Source: ABdhPJzvxci3wICE8s2QLeWV/fRZEgpNiN2zMvjo9TGppkTlxV2fPkZIUiAWhM+q8laARvxiZEf25g==
X-Received: by 2002:a17:90a:380c:: with SMTP id w12mr10210531pjb.117.1607646835722;
        Thu, 10 Dec 2020 16:33:55 -0800 (PST)
Received: from localhost.localdomain ([168.63.153.116])
        by smtp.gmail.com with ESMTPSA id f90sm8216116pjd.32.2020.12.10.16.33.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Dec 2020 16:33:55 -0800 (PST)
From:   Stephen Zhang <stephenzhangzsd@gmail.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Zhang <stephenzhangzsd@gmail.com>
Subject: [PATCH] kvm:vmx:changes in handle_io() for code cleanup.
Date:   Fri, 11 Dec 2020 08:33:46 +0800
Message-Id: <1607646826-97297-1-git-send-email-stephenzhangzsd@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Stephen Zhang <stephenzhangzsd@gmail.com>
---
 arch/x86/kvm/vmx/vmx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 47b8357..e1954df 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4899,15 +4899,15 @@ static int handle_triple_fault(struct kvm_vcpu *vcpu)
 static int handle_io(struct kvm_vcpu *vcpu)
 {
 	unsigned long exit_qualification;
-	int size, in, string;
+	int size, in;
 	unsigned port;
 
 	exit_qualification = vmx_get_exit_qual(vcpu);
-	string = (exit_qualification & 16) != 0;
 
 	++vcpu->stat.io_exits;
 
-	if (string)
+	/* String instruction */
+	if (exit_qualification & BIT(4))
 		return kvm_emulate_instruction(vcpu, 0);
 
 	port = exit_qualification >> 16;
-- 
1.8.3.1

