Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAD43B21D6
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 22:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhFWUhx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 16:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFWUhx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 16:37:53 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1A2C061574
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 13:35:35 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id y206-20020a3764d70000b02903b2ff4c81b1so2553112qkb.21
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 13:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=z6BiOnPbP3qepOJOR/7I+Ocxp7AWb5zZlcqI2XTsa1c=;
        b=pI/NSBXHJxoHj6+urzDO8D9P14qul+dAhIgEDo2+2/1xVkr4Oixgmy1sIiOqsxXIBa
         N/kEnEsTr+t3LCFV071Of6XfTyrTVewu19zCAx0m02Vdyk8VxxtetaEXsYo3ee7z2J6C
         Y+qI2+Jb/acdFgoiM6SN0a44lp3pWydfReOIFeqhzn2ZkHyjA1cJo9622Rvs/ogkg2Bp
         qU4BfdmGi2Iaq9ih9FUChQi8z93QEd5WaR3FZATBgnfCrHZ67FOYdzh6ilWt9wtQjPJN
         qsGd4Um8aYUyDs4oDaVaKfknYUMNJbVEH4AB12jFkSw/MNXW1oCnRNRvmxUvNWEBUmky
         VhIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=z6BiOnPbP3qepOJOR/7I+Ocxp7AWb5zZlcqI2XTsa1c=;
        b=HJKBhTxaRt0Kb9RQB+eV9scvbqrZah4fbZeTVbyDDqel95F5ngBFn8yum0K0izCmLP
         XQ+W33WOb8moAFnqlhC1Kp8dyC09liYXgCDbh/nnA4Sscoa346oeiEJPihs5m85s7W6N
         PkAtdy2cmSe0C9FPlnjokFBvldiFJdY9i1Cgh1fPLTH+fYpwNp9saqN8CnKB7PzZiW7o
         sGDIUr3XaQSkmM60MiWXkq+pG2c/C6X5x2LzZSHKfDmjXtdye2/uQTxD2jkTGlb2Cg+x
         Lfm2Z16QiNjupibv0ZDh74OelqFwEiimbzeg2lyXTa2KTRMRm//rHrWpFvTfJTkGqvTn
         SehQ==
X-Gm-Message-State: AOAM532/ARa4/yCSuE/ndWU4OQWzJlaDRCHoi7THNmixPY0SrOyUxsPJ
        Tk7XNlhC/7whx/vQ5XAGllTCWV+mDeqKKW/twklb1zPN/QWpxeukMR3ZcXc8lL0RdS6FSwOQSMz
        EpZ2bbz+CUuvZPyGYRTfbvkBvk5eRrVRKpUrPWO4ed5AmFZx1bItzHUZpyh+W7PB1zdEK
X-Google-Smtp-Source: ABdhPJyHpNJW0LJNaT9dIkl9ks4fhuThZ7VJOetgFKCVp20QMfonoVTZvJ0zRwbGx5lOcvWbvI0A/isb33KqDBlF
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a25:aba3:: with SMTP id
 v32mr1735928ybi.307.1624480534317; Wed, 23 Jun 2021 13:35:34 -0700 (PDT)
Date:   Wed, 23 Jun 2021 20:34:27 +0000
Message-Id: <20210623203426.1891402-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH] kvm: x86: disable the narrow guest module parameter on unload
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     jmattson@google.com, pbonzini@redhat.com, mgamal@redhat.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the kvm_intel module unloads the module parameter
'allow_smaller_maxphyaddr' is not cleared because it is also used in the
kvm module.  As a result, if the module parameter's state was set before
kvm_intel unloads, it will also be set when it reloads.  Explicitly
clear the state in vmx_exit() to prevent this from happening.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c2a779b688e6..fd161c9a83fd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7996,6 +7996,8 @@ static void vmx_exit(void)
 	}
 #endif
 	vmx_cleanup_l1d_flush();
+
+	allow_smaller_maxphyaddr = false;
 }
 module_exit(vmx_exit);
 
-- 
2.32.0.93.g670b81a890-goog

