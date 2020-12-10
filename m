Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9857D2D552E
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 09:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387657AbgLJIQ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 03:16:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387639AbgLJIQL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 03:16:11 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F03C061794;
        Thu, 10 Dec 2020 00:15:31 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id u4so2372289plr.12;
        Thu, 10 Dec 2020 00:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=1rCIZ2aFQJb9JggKwJdiRgk6PJ0mPfhOdiJnDt3jhOo=;
        b=lFPUvVgKLCb8cKfBI6Axvd/IQCepYEs4CksDpqIJjvTNRMkbc7z8zsgW0LM+RLJorT
         NKQR/c6VdD5A71ojCvDSNOj0wTszbLhRSsRY8Qha7utYuuo91F/OaFrFRQumz+LQHuBH
         CWuiFtNbDBp8Dd32oWDu+EMpuG88Q1sqLIXeq7OCF21l5sE008HV1sSZ2vLKstkT19v9
         SpiUUJomSwL+q8HgC3ifq22IKALy3WoBnhDw5LX5r4qLBBAadwG944I3gdcQs3mVH9v4
         0YO+/jxtEB5PBMBZcXUDt0XAKNzj24FOsJLOy/ZA/SzRspXV9tm3rt2ojlyLcBAbc4wT
         McTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1rCIZ2aFQJb9JggKwJdiRgk6PJ0mPfhOdiJnDt3jhOo=;
        b=qyd+5LMW73EOgQ2DYO8BtJehzfqLU+MocqLHbkV5TQw9fZetwutQMIYpTEkIx4TEol
         x/b5W0xU3ZNerKBGDIjI1pl89DgsdWd68C1nU/reaidJ4rXtXPfjmeZhiXt9v3ZXsPtz
         QXHYbXH+/xNviQEaqUomf2vFU4w4OyvaSjGv50QtXeqJC371s3mJHWK11aUbP8ngqW0U
         jn1N/c4V469CEMcSJy0YrzilZH0apm9YBYVHECbE77uyW87tRp2fj+04eKsphn/KhA6f
         IEyKSkGhhYRcu3gzj5UEz8IvcNfTpG3+gZLnL7R3v7ARRiZ2PO9Wh94CEtsbbAW+51A/
         cvnQ==
X-Gm-Message-State: AOAM532OfjA55rsjq9wTL0PgpQsMLoB4OQ4+Ti40Ip8Aw3k3T5z6qaQN
        vBf9lsZr4zlQAa0Dw4EAtIY=
X-Google-Smtp-Source: ABdhPJwm8acp3VmSgLF4pkd4f+rev8FIhe932yQHoQ7mQ7d4+mL2H0/sL0SbBBfGsl4vQ+vszUpsAw==
X-Received: by 2002:a17:902:ea89:b029:da:539e:9bb with SMTP id x9-20020a170902ea89b02900da539e09bbmr5826549plb.52.1607588130780;
        Thu, 10 Dec 2020 00:15:30 -0800 (PST)
Received: from localhost.localdomain (ec2-18-162-59-208.ap-east-1.compute.amazonaws.com. [18.162.59.208])
        by smtp.gmail.com with ESMTPSA id q70sm5129650pja.39.2020.12.10.00.15.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Dec 2020 00:15:30 -0800 (PST)
From:   Stephen Zhang <starzhangzsd@gmail.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Zhang <starzhangzsd@gmail.com>
Subject: [PATCH] kvm:vmx:code changes in handle_io() to save some CPU cycles.
Date:   Thu, 10 Dec 2020 16:15:15 +0800
Message-Id: <1607588115-29971-1-git-send-email-starzhangzsd@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

code changes in handle_io() to save some CPU cycles.

Signed-off-by: Stephen Zhang <starzhangzsd@gmail.com>
---
 arch/x86/kvm/vmx/vmx.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 47b8357..109bcf64 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4899,15 +4899,14 @@ static int handle_triple_fault(struct kvm_vcpu *vcpu)
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
+	if (exit_qualification & 16)
 		return kvm_emulate_instruction(vcpu, 0);
 
 	port = exit_qualification >> 16;
-- 
1.8.3.1

