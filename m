Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDFB143E85
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 14:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729094AbgAUNsL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 08:48:11 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52650 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728811AbgAUNsL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 08:48:11 -0500
Received: by mail-wm1-f68.google.com with SMTP id p9so3027503wmc.2;
        Tue, 21 Jan 2020 05:48:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:subject:date:message-id;
        bh=FZjCfdCwsLgD1MIWUQtYRR8hOJhqjphscHVRCJxvEAE=;
        b=et4rDCDCIEejNLTYKWnB7T64LDOz0nUySgRJ2whWdx6FTDx+fU1BYPsgI/fY9/8Bgi
         90e/RE1F5lqUDl2NigBVuF0aAF1LadwjJiG5C1VWdO7FTDfZYupmvQWH/IjHV0MmhGSP
         gFyXqEPhHnIBL5yxkD932+GNvsxjoj7VYWuXfTQt0fV4SAdHG7y1RrFw7cZHF3JkpIf7
         Xq6e5oUjg38yDd4M4M7NkLrzOoffEp31M746keTKJPMq6c/GIiH/GDiEs/7H4pVpKU+H
         XgYKLtImL4jd+oXzKGVMqKB/MQxwm6tJEHu+Mxdx2qfPfCXYy16afCfWYMBbOQ/apdWW
         6kmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:subject:date:message-id;
        bh=FZjCfdCwsLgD1MIWUQtYRR8hOJhqjphscHVRCJxvEAE=;
        b=hvD87kpver75Cj1qOL0YNdxS2MTZ3Mp42vbPRSktjAQN0u3yBxu8+Sj3GvT+SjHASf
         oyfI1KWrNvqBcbS3LlM1ujmhPaxtXD4n1vp4ZKMNclhrz9/Qq/IC81Mlqqx5C31f0dhR
         n2Nk2nqKxGM3BYZ1fA9oNe9a1aa2eIwFqj8yHHZUEKYfgboeBLaM81PUsSPUvQE80TkD
         Hc/YqqTftL8j+WYuH1Gz5pid0yGLBKU2qlyJOlbpA/n9qS4+DRf7tNe70/Ox3sXaranS
         GYb6b9e+QXLWW4ho+5Xh7wzH2fsIFIOmNceBJNXrlSxxuO+1EjqypfgbaZyeoH7BJWT5
         mUKA==
X-Gm-Message-State: APjAAAWlcvQPGfrkrCDuSRlVZhTpQLKmx7XbxMARhYmb4B/LsOkn+pGp
        aphjp0l5zbzmak4h6eEyVeoFPS3D
X-Google-Smtp-Source: APXvYqy+s2vCZ/TdTgraG4Nc6LKsnRVP6bkYC6XS72xKihGczMaMO4ER/PgAvwCBhaaRo4JKC9yngg==
X-Received: by 2002:a1c:a745:: with SMTP id q66mr4232830wme.167.1579614489036;
        Tue, 21 Jan 2020 05:48:09 -0800 (PST)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id b17sm51975006wrp.49.2020.01.21.05.48.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jan 2020 05:48:08 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: x86: list MSR_IA32_UCODE_REV as an emulated MSR
Date:   Tue, 21 Jan 2020 14:48:05 +0100
Message-Id: <1579614487-44583-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Even if it's read-only, it can still be written to by userspace.  Let
them know by adding it to KVM_GET_MSR_INDEX_LIST.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3e70af42f65b..9f24f5d16854 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1228,6 +1228,7 @@ bool kvm_rdpmc(struct kvm_vcpu *vcpu)
 	MSR_MISC_FEATURES_ENABLES,
 	MSR_AMD64_VIRT_SPEC_CTRL,
 	MSR_IA32_POWER_CTL,
+	MSR_IA32_UCODE_REV,
 
 	/*
 	 * The following list leaves out MSRs whose values are determined
-- 
1.8.3.1

