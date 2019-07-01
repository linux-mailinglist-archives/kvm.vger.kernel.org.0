Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18719247EC
	for <lists+kvm@lfdr.de>; Tue, 21 May 2019 08:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbfEUGRw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 May 2019 02:17:52 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42043 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbfEUGRv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 May 2019 02:17:51 -0400
Received: by mail-pf1-f195.google.com with SMTP id 13so8489701pfw.9
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 23:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J0uuieNJWIEqFucVVL6HHob/1V+xJ9X3pNwzM9VDJZ0=;
        b=iAILzZqNIPswUqlH8JOZ7+vNDvmfXLVoXJIxX2pMr6K+W+bYWxejR2GHSWRq5E47A9
         +VOfS8YbrQHfhFr7ihHe+UDBs8GsWPVm81gOqbikTXUXTinXaK5hYC9uAXP7euPrkAfO
         W3z6pM1PlpsNwjc9CsNyroG7N/i0J/9W/pNuTtwQQA+p2+FPHbalQl4hDooMHBBpiEN5
         2kicJrYTxu1HzkN0+pbwtNM4BG2RgcgDdPdSPEQ4ZAXh+ARZzdnmstNsaTbUrM8BeTh3
         EawOZc3DzJIcULJcNysgL7W1kitDu+KytOK29j4bZlaQ3PjMG64tGQ/8f/P6Cc5JOZOR
         NJ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J0uuieNJWIEqFucVVL6HHob/1V+xJ9X3pNwzM9VDJZ0=;
        b=pFNOxJSs/Kp/0Yd766UM6+Vt30FG9MZ2sZrQ9GTJShjIsZaANNH1/ULQA3K8fIRRB7
         qsQPlfyeaqjYItyWyWRCDdcdhQM4oirpcVowCPKsR09MisBaKzGyLKHyk7Qk2clyizul
         N2Rk3Wrl/+b80/fot8Y9xLXCZV/iBUtfpCAfCKk5dX4P77DnZVclnOf20wwhcBq5bKmv
         WQMUetZ4nJOYczl4Zae4euIUP9j3NChGraRfhDYm6hoXMYFMrBg1u7w5kXYcoev2JHE9
         kQDJlt9wZN6k6mg8FH4dEeSPawZe14AerUN3/86OXZS/3xcfbRP4oDG6RdHGS2MGVaPp
         953A==
X-Gm-Message-State: APjAAAXPqX6dVrDKakrkYad9y7Eh0Y0KjAhK+bZWOJTf90aK+51co4E6
        E/pYh1snuFjhDpoSEcAUEGk=
X-Google-Smtp-Source: APXvYqw2zFKfTVHfge7XSBqtWwR0RD497wZjCcT/BNKF+0TPFWkQe97zoVI6lF5pwDcUzRZL6LH/JQ==
X-Received: by 2002:a63:1460:: with SMTP id 32mr80416982pgu.319.1558419471484;
        Mon, 20 May 2019 23:17:51 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id o66sm23112295pfb.184.2019.05.20.23.17.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 20 May 2019 23:17:51 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH] kvm: support guest access CORE cstate
Date:   Tue, 21 May 2019 14:17:47 +0800
Message-Id: <1558419467-7155-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Allow guest reads CORE cstate when exposing host CPU power management capabilities 
to the guest. PKG cstate is restricted to avoid a guest to get the whole package 
information in multi-tenant scenario.

Cc: Eduardo Habkost <ehabkost@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 linux-headers/linux/kvm.h | 4 +++-
 target/i386/kvm.c         | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index b53ee59..d648fde 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -696,9 +696,11 @@ struct kvm_ioeventfd {
 #define KVM_X86_DISABLE_EXITS_MWAIT          (1 << 0)
 #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
 #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
+#define KVM_X86_DISABLE_EXITS_CSTATE         (1 << 3)
 #define KVM_X86_DISABLE_VALID_EXITS          (KVM_X86_DISABLE_EXITS_MWAIT | \
                                               KVM_X86_DISABLE_EXITS_HLT | \
-                                              KVM_X86_DISABLE_EXITS_PAUSE)
+                                              KVM_X86_DISABLE_EXITS_PAUSE | \
+                                              KVM_X86_DISABLE_EXITS_CSTATE)
 
 /* for KVM_ENABLE_CAP */
 struct kvm_enable_cap {
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 3b29ce5..49a0cc1 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -1645,7 +1645,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         if (disable_exits) {
             disable_exits &= (KVM_X86_DISABLE_EXITS_MWAIT |
                               KVM_X86_DISABLE_EXITS_HLT |
-                              KVM_X86_DISABLE_EXITS_PAUSE);
+                              KVM_X86_DISABLE_EXITS_PAUSE |
+                              KVM_X86_DISABLE_EXITS_CSTATE);
         }
 
         ret = kvm_vm_enable_cap(s, KVM_CAP_X86_DISABLE_EXITS, 0,
-- 
2.7.4

