Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F404ED8FE
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 07:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbfKDG2M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 01:28:12 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43078 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727911AbfKDG2L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 01:28:11 -0500
Received: by mail-pf1-f193.google.com with SMTP id 3so11458799pfb.10;
        Sun, 03 Nov 2019 22:28:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2OtwjKZ1o9BlPFo9MmqlnhkpjgLbY+pfS9lNNjoKCmc=;
        b=T/npz0RdlYaEe1kuqJUtS2GEYAu4quFvYbf+oWj2p+3Wp8NDVAB0OFV7UcoxLCA/He
         tdIwotd2rfdjNJD5CeuzxfQTg6+zChJAnv7hmmIbA/JIjLUqnSdSUvMZHrthlYChwj4J
         Ng/cPF95vWdp4OCv/MLzzvnIQWAc/jG5RhMBXI4CWFCsDx083wqTW7XtEk8hbK0aM9nU
         t1v1nUrRNRQ+WomXz77Oz4Qgb29/SX9zqEif27/5MR24mv8FLdAjBdEwcr2ZrIv1x4lx
         Xb9bXFDSvZwRhG19G5FfF9kVSDcdfiiYcTLD0mB40AIGfoRRlJ92gygyu8vnkbk+Plfx
         cXGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2OtwjKZ1o9BlPFo9MmqlnhkpjgLbY+pfS9lNNjoKCmc=;
        b=fG9BViyoY3aNGI5A2QG16XqgKyKNc6UOkSeuD25UcnnoHoKzuAt4m8emIHuhZi6aNQ
         7goXUvmwVXxqKZ1fN2/dwDvoMehl2iZdtcf7wZ6mnO84idAN2tkoAgIAt9c+pk9XLbkc
         Z6pjCUVQYtUMdDfbkyYn/I39Jh5qnEyGpJrPQ+sc/RFzOHsb7Mo92hxlwFzTEqjhwcUz
         PEnr71k22qQhDLzBTl3mM2Zl4AsUGkprHCxuD//A9fCvSdXfkPjxldSQmKqvExf0twBG
         cSMEKNdNUw1Lf9gJKbrnrAa98gsJrowLc5YSc5hxoda9xCo6cMMyvQ4qmIlN++TgEfHv
         FGDw==
X-Gm-Message-State: APjAAAWu8Hqsw3bmfoh4XiF7m2Euc3pkufWaeTij5ESfTVdOaq9zA0DR
        oLzLjYGzpzvHLaEzjrPh05XUDp2v
X-Google-Smtp-Source: APXvYqweKAOvqr9QdiEMGxa1aKPl9xbFKqkAQoidoD1IYf0AjKuuICSneWHAk66sEBNGKRmOMZadIw==
X-Received: by 2002:a63:6cb:: with SMTP id 194mr1871805pgg.327.1572848890353;
        Sun, 03 Nov 2019 22:28:10 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id z7sm7810505pgk.10.2019.11.03.22.28.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 03 Nov 2019 22:28:09 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 2/2] KVM: Fix rcu splat if vm creation fails
Date:   Mon,  4 Nov 2019 14:27:59 +0800
Message-Id: <1572848879-21011-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1572848879-21011-1-git-send-email-wanpengli@tencent.com>
References: <1572848879-21011-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Reported by syzkaller:

   =============================
   WARNING: suspicious RCU usage
   -----------------------------
   ./include/linux/kvm_host.h:536 suspicious rcu_dereference_check() usage!
   
   other info that might help us debug this:

   rcu_scheduler_active = 2, debug_locks = 1
   no locks held by repro_11/12688.
    
   stack backtrace:
   Call Trace:
    dump_stack+0x7d/0xc5
    lockdep_rcu_suspicious+0x123/0x170
    kvm_dev_ioctl+0x9a9/0x1260 [kvm]
    do_vfs_ioctl+0x1a1/0xfb0
    ksys_ioctl+0x6d/0x80
    __x64_sys_ioctl+0x73/0xb0
    do_syscall_64+0x108/0xaa0
    entry_SYSCALL_64_after_hwframe+0x49/0xbe

Commit a97b0e773e4 (kvm: call kvm_arch_destroy_vm if vm creation fails)
sets users_count to 1 before kvm_arch_init_vm(), however, if kvm_arch_init_vm()
fails, we need to dec this count. Or, we can move the sets refcount after 
kvm_arch_init_vm().

syzkaller source: https://syzkaller.appspot.com/x/repro.c?x=15209b84e00000

Reported-by: syzbot+75475908cd0910f141ee@syzkaller.appspotmail.com
Fixes: a97b0e773e49 ("kvm: call kvm_arch_destroy_vm if vm creation fails")
Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d6f0696..62ae0c9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -662,11 +662,11 @@ static struct kvm *kvm_create_vm(unsigned long type)
 			goto out_err_no_arch_destroy_vm;
 	}
 
-	refcount_set(&kvm->users_count, 1);
 	r = kvm_arch_init_vm(kvm, type);
 	if (r)
 		goto out_err_no_arch_destroy_vm;
 
+	refcount_set(&kvm->users_count, 1);
 	r = hardware_enable_all();
 	if (r)
 		goto out_err_no_disable;
-- 
2.7.4

