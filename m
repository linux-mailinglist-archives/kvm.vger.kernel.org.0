Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACD6F74C0
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 14:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbfKKNZy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 08:25:54 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45399 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbfKKNZs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 08:25:48 -0500
Received: by mail-wr1-f66.google.com with SMTP id z10so9322908wrs.12;
        Mon, 11 Nov 2019 05:25:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=blu77unpeE09r1JI0P7HpC+ivP/3zsMfpmusG6ey0wg=;
        b=L+CCZiO+UFIqbNPCkKohaXARPxLm4OT06+/QOuEWBybW/LIHrzhNwiKuciQxKfswY+
         KXwJW05Dy0LVOuhCA1C8/+hul9xuqPnyUJZo117/V2fODS1NGHyVTQSr4p8R056Av/HB
         wQ8vrJ6mtIdda4j2gmj85X4JIrdRrhefft9UQn2n6rPpSbho/Fa/cMTaV0UURpoSvWd4
         Llt/n1pflIAc7kCZOTzn1vJWTw9oKOLSW+sasRGYWItozOTquIWUeV9+S/OROXDP/XF6
         Cjc8/C0xqAPz5Jyi020yGnwQAIzsikynjIPFnLnElbACTll5DV2cfca/Dy1IoG89fHlA
         HsNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=blu77unpeE09r1JI0P7HpC+ivP/3zsMfpmusG6ey0wg=;
        b=Q1RLb8aWC8Uv46XrV7RCkAi3BAezGQsh4+tn/+T4uPZJH3F4OlJasj90kxukk8QPg1
         uLKKyWWe2rUpHVD9t26CW0rMb7ZoPo9PwNK0TfhOHDdqYULBSfeeVJOPU/HphQQbssWO
         rJJrs26NJQGvolb9puh2Ts19IKr0FiB/JSLuMDgYBYqmwmuggFXx23/4PhZteC8Oi0En
         hpXf60EhcPZrEbI/WmoiCkdJBA2r4s3osOa4lf2QxvOeO7vOKkeA+uhU4uQk6oQ4kOmb
         TVH6/4pfHlgYZuM2l/nCSd4sxdGn34FR6QneHbcl0rBLspivKaWmko70W4LMElwBrWpD
         Ynjw==
X-Gm-Message-State: APjAAAVVVn1MwUTN2MSM+v92q7vhFUyk6lAqlDNofuIgZ+mFQM1G7Fgz
        56DRPK3ae0D8uHpe+P3qrbJYfIkz
X-Google-Smtp-Source: APXvYqzWJFM4B0A4KrsqAdfd/MII9XmNRZJzIm9+qH0vj4F/tfYvEL2uZBIQa0A6litOzlc1ap+xJw==
X-Received: by 2002:a5d:4a45:: with SMTP id v5mr22352296wrs.288.1573478746007;
        Mon, 11 Nov 2019 05:25:46 -0800 (PST)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id p1sm7555131wmc.38.2019.11.11.05.25.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Nov 2019 05:25:45 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jmattson@google.com, wanpengli@tencent.com,
        Junaid Shahid <junaids@google.com>
Subject: [PATCH 2/2] KVM: fix placement of refcount initialization
Date:   Mon, 11 Nov 2019 14:25:41 +0100
Message-Id: <1573478741-30959-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573478741-30959-1-git-send-email-pbonzini@redhat.com>
References: <1573478741-30959-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
fails, we need to decrease this count.  By moving it earlier, we can push
the decrease to out_err_no_arch_destroy_vm without introducing yet another
error label.

syzkaller source: https://syzkaller.appspot.com/x/repro.c?x=15209b84e00000

Reported-by: syzbot+75475908cd0910f141ee@syzkaller.appspotmail.com
Fixes: a97b0e773e49 ("kvm: call kvm_arch_destroy_vm if vm creation fails")
Cc: Jim Mattson <jmattson@google.com>
Analyzed-by: Wanpeng Li <wanpengli@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/kvm_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e22ff63e5b1a..e7a07132cd7f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -650,6 +650,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	if (init_srcu_struct(&kvm->irq_srcu))
 		goto out_err_no_irq_srcu;
 
+	refcount_set(&kvm->users_count, 1);
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
 		struct kvm_memslots *slots = kvm_alloc_memslots();
 
@@ -667,7 +668,6 @@ static struct kvm *kvm_create_vm(unsigned long type)
 			goto out_err_no_arch_destroy_vm;
 	}
 
-	refcount_set(&kvm->users_count, 1);
 	r = kvm_arch_init_vm(kvm, type);
 	if (r)
 		goto out_err_no_arch_destroy_vm;
@@ -696,8 +696,8 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	hardware_disable_all();
 out_err_no_disable:
 	kvm_arch_destroy_vm(kvm);
-	WARN_ON_ONCE(!refcount_dec_and_test(&kvm->users_count));
 out_err_no_arch_destroy_vm:
+	WARN_ON_ONCE(!refcount_dec_and_test(&kvm->users_count));
 	for (i = 0; i < KVM_NR_BUSES; i++)
 		kfree(kvm_get_bus(kvm, i));
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
-- 
1.8.3.1

