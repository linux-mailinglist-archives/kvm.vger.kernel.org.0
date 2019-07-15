Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1790B6820F
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 03:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728996AbfGOB2z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Jul 2019 21:28:55 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39735 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbfGOB2y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 Jul 2019 21:28:54 -0400
Received: by mail-pg1-f195.google.com with SMTP id u17so6899652pgi.6;
        Sun, 14 Jul 2019 18:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J0uuieNJWIEqFucVVL6HHob/1V+xJ9X3pNwzM9VDJZ0=;
        b=i8NhfdRWTkmqEfZfCzU6oPHv7PGnVKfRg+X/b4xOt2S5SqMQ29UUIxVI2TlfpZu76f
         vOMoGM8eRo5AZgdPp1J8r7HMj+Ge6VoyzIGyVqiLtccwhIPCJtjH3W22rdKgjWO05S1I
         6T4XK6CF/169lYtJ41je6yOzqDUa7h/d2x5ZXm5s3J1Cimo6rI0gqMUFMdQ4A4CjH9PH
         fD3f404sOpFSlsFAw8Zy16LwPNz0YiT6YEDkvLqggQWB4gV5G7imDyKMkEqArivlODTP
         myfYxTKqPpkNZJPpbxYBKSW7rj7EZwTGw3oA0F6AzUBMzL6XYWKsEwYEDYUjlom36WEz
         Ic0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J0uuieNJWIEqFucVVL6HHob/1V+xJ9X3pNwzM9VDJZ0=;
        b=epmZ7ifMZkqDnVEAACgqjajXxSJ+o7nI8qSui8svCaP3xutXRVJ6dSgSI+Lar85YP7
         wFsIHnzyVpNXFV7Xxf34t9GrWF8dEo4ydj7PvQnqQrZgN22mfIT5Udi4u1AjB1STcB0d
         OYyZ7/IVoksMFjDCREeirYrKy/PO3kgfYBxVZ1QilQKQ44+7DtTCF4+5fA6nJhYfCvWA
         nyrfkozFzxSEriClLflkoCh/Zht6XhAX/SLo5TMsZPgPnIMCP1LBerCfkPAmguA32ch7
         +8eoIhzon7Ltl6XQYajjcuPNExS1rga8PYVslQNLcgRxZ5JGM1KeuJ0g7IoE1g4E8eqh
         V/Vw==
X-Gm-Message-State: APjAAAVZH6NnUGC6uttueW5m0Qv1YbNt6cJMzhrlmgwdoVKxDOk1qGzi
        aWuDuarRosbJJjxyzDQB734pBB2Za98=
X-Google-Smtp-Source: APXvYqxs3OG0BKcfq0rH3+05QtGWcstr5HpP1eAAxWdX97TW47eRmkiqekNJ2fdh2UAMVwsZROCxIw==
X-Received: by 2002:a17:90a:2247:: with SMTP id c65mr25371401pje.24.1563154133835;
        Sun, 14 Jul 2019 18:28:53 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id o14sm15386915pjp.29.2019.07.14.18.28.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 14 Jul 2019 18:28:53 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH RESEND] i386/kvm: support guest access CORE cstate
Date:   Mon, 15 Jul 2019 09:28:44 +0800
Message-Id: <1563154124-18579-1-git-send-email-wanpengli@tencent.com>
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

