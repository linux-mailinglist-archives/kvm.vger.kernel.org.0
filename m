Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2B78215AF
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 10:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728508AbfEQIuB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 May 2019 04:50:01 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35521 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728481AbfEQIuA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 May 2019 04:50:00 -0400
Received: by mail-pl1-f193.google.com with SMTP id g5so3056558plt.2;
        Fri, 17 May 2019 01:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5VREHkPw8R8lwRxH+KVXuUktO+8MCxC49x2eL5UCIow=;
        b=RPF5qcECkRQX0J004+yKvh9PHjuDP9QRAl1CTIGwYdfFjC73ZOLGRcxDyItiIW7XyA
         nbv2F1mtgRdvb5ihxRpkb3z/RtFdWaS3jZoQtTHtuZuaN+M96WdPShDILNxokcxMGmK7
         fRmgTv9Wt0N7ybh4BTAndZqH7yw/uUDNoe0JHoE3xA7owQGGbmrO/zzIsC10J4WDrEyJ
         WSfQKHZF4soeugQiLr5Qp2Kk1HO4TyKa5EWRgd2eL1cm66YKg1l6GYzikIeHsFV6SVXG
         cMYlPysB335VCYVBaSNNenhR8jQkxOVjEHMf0XmlklLT+MhhJ7V4gRkvDoXoX9NGDoMm
         60dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5VREHkPw8R8lwRxH+KVXuUktO+8MCxC49x2eL5UCIow=;
        b=TI1hwb2e8AuC8zzKWCHsFfPu3lqRQKdhO8xu1tWvk3LyOFbF4s+n5riZCwkm2s75Pc
         mKdKy3y2eNXFutAVycF5Wx9aTMfQ80uKlu3g8ZYtTz7J9AflsHHAwwmShbgIFuMVbX5Y
         1ZRAUewCLVAcJJjtfgfAkuGxIGOuZboQLfKqe7UN42DivCQXs/fO+O7CA65iHPHWo9QQ
         ZY2Dk3jWdwRGlgTxc+EApwJHEWrpoYVZRQQgr1LU4XNHJlNW5KpSOUl6Pt4a/7+UDv/E
         6ds7oe2QyBpiX6/tRxJFvMiOtTXV7uZNAz/ThrOSE1xlPptkUoSMW2GjgMPBQs5K8liq
         jccA==
X-Gm-Message-State: APjAAAXjW/PQL+Kt8nqjjXn7Dh32PRx6yjdiYxGCc3fIpxYUkDgKqva3
        gHhBEU36gnQx1lkiGYAMTOAfrOIe
X-Google-Smtp-Source: APXvYqxe4n7YAE9tLJpT4f6BzKilEwXE3tVIRNBySLRokH+e3XoGXrD1560o4yN2vgR74SJe88LRlA==
X-Received: by 2002:a17:902:aa95:: with SMTP id d21mr1072036plr.32.1558083000075;
        Fri, 17 May 2019 01:50:00 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id 63sm10417127pfu.95.2019.05.17.01.49.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 17 May 2019 01:49:59 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        "Paul E . McKenney" <paulmck@linux.ibm.com>
Subject: [PATCH 3/4] KVM: Fix spinlock taken warning during host resume
Date:   Fri, 17 May 2019 16:49:49 +0800
Message-Id: <1558082990-7822-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558082990-7822-1-git-send-email-wanpengli@tencent.com>
References: <1558082990-7822-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

 WARNING: CPU: 0 PID: 13554 at kvm/arch/x86/kvm//../../../virt/kvm/kvm_main.c:4183 kvm_resume+0x3c/0x40 [kvm]
  CPU: 0 PID: 13554 Comm: step_after_susp Tainted: G           OE     5.1.0-rc4+ #1
  RIP: 0010:kvm_resume+0x3c/0x40 [kvm]
  Call Trace:
   syscore_resume+0x63/0x2d0
   suspend_devices_and_enter+0x9d1/0xa40
   pm_suspend+0x33a/0x3b0
   state_store+0x82/0xf0
   kobj_attr_store+0x12/0x20
   sysfs_kf_write+0x4b/0x60
   kernfs_fop_write+0x120/0x1a0
   __vfs_write+0x1b/0x40
   vfs_write+0xcd/0x1d0
   ksys_write+0x5f/0xe0
   __x64_sys_write+0x1a/0x20
   do_syscall_64+0x6f/0x6c0
   entry_SYSCALL_64_after_hwframe+0x49/0xbe

Commit ca84d1a24 (KVM: x86: Add clock sync request to hardware enable) mentioned 
that "we always hold kvm_lock when hardware_enable is called.  The one place that 
doesn't need to worry about it is resume, as resuming a frozen CPU, the spinlock 
won't be taken." However, commit 6706dae9 (virt/kvm: Replace spin_is_locked() with 
lockdep) introduces a bug, it asserts when the lock is not held which is contrary 
to the original goal. 

This patch fixes it by WARN_ON when the lock is held.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.ibm.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5fb0f16..c7eab5f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4096,7 +4096,7 @@ static int kvm_suspend(void)
 static void kvm_resume(void)
 {
 	if (kvm_usage_count) {
-		lockdep_assert_held(&kvm_count_lock);
+		WARN_ON(lockdep_is_held(&kvm_count_lock));
 		hardware_enable_nolock(NULL);
 	}
 }
-- 
2.7.4

