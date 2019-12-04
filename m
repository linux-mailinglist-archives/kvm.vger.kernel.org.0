Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43E111125F3
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 09:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbfLDIwU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 03:52:20 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45752 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbfLDIwU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 03:52:20 -0500
Received: by mail-qt1-f196.google.com with SMTP id p5so6911571qtq.12
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2019 00:52:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=EOhS8JDsg867aMPTPPeteOvbmqqjsw5vk6vXxMRaXi4=;
        b=pxvE9MO5f9p/yUNdCgDLZQPjNTm3GpliVlCjX11Hc+NODaKH6B35Fyscwpgn+cqcL7
         zgpfCuNw51xheY4xzL8Y/cgbvP6WlKdZaPbxpSYadkpH0eOPZyVMUet8SINxpFRAT5C5
         8j1P+Zuhjznd1SmYvp+uwrQ1JYs6dhjkzGCBzq9SbfWoGrSeZbbJrHDRuqLjtbZMrLtJ
         qkg6dWhdASyMNvhH2pr3ApZYbmEXt5U2Zn/8K3L2ljh7h/hrcc0+R+vHa0C7+5xaH6LU
         AM5skbDP2Holn90xSPgdwTNonumP/m7RHu92H28cMcYVjPihj0ltD2J+iW6sO6ZjRqWP
         MQKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=EOhS8JDsg867aMPTPPeteOvbmqqjsw5vk6vXxMRaXi4=;
        b=XNt3ch2fqnnsaUYjCOzPQR2xi4x47DrgGBwmPiEj6idkZ46aij0mao3Mwr0U8QwhEA
         i6nx8k+343ouOjbfstZW4osqlgfP4JByeBlM2Wd/mJqH/oqxr0QSQj+d6QCYMAYhmqXT
         ppnXyA25Cdxrf3TOyCG5U+dk5YmqKrNrwzJRPEiQTCCMWlpm+cYB1WpXKyuleKOnZ9fb
         Zn6jaPj/tPO6oO07p7Vb05K0Jf1L8G8vDWOMtE9zpd/VmdHsFXXkQEr65lhjy+1h4kzn
         y+5L93AJAc4hqoaidkjq3rYbpreStdmZzQzymKfLq6PilKmx5+pM6RNujB3d8xqNFSzC
         Royw==
X-Gm-Message-State: APjAAAXPJbetp7N+jkamEwHn5Ru/ifBfxTadYw7G7n78tjtdQEomxDhU
        ylWsm+1o3QzhfUez+mY32Io=
X-Google-Smtp-Source: APXvYqzTEn4f5QtgZACc5msyimnIHXttn0a0OY37DJuQ0hHUQX9gHuGApLqlXXYZrGFZEr/p65/7TQ==
X-Received: by 2002:ac8:23a5:: with SMTP id q34mr1570560qtq.83.1575449539835;
        Wed, 04 Dec 2019 00:52:19 -0800 (PST)
Received: from host.localdomain (104.129.187.94.16clouds.com. [104.129.187.94])
        by smtp.gmail.com with ESMTPSA id q187sm3351795qkd.92.2019.12.04.00.52.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Dec 2019 00:52:19 -0800 (PST)
From:   Catherine Ho <catherine.hecx@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org
Cc:     Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Catherine Ho <catherine.hecx@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] target/i386: relax assert when old host kernels don't include msrs
Date:   Wed,  4 Dec 2019 03:50:30 -0500
Message-Id: <1575449430-23366-1-git-send-email-catherine.hecx@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 20a78b02d315 ("target/i386: add VMX features") unconditionally
add vmx msr entry although older host kernels don't include them.

But old host kernel + newest qemu will cause a qemu crash as follows:
qemu-system-x86_64: error: failed to set MSR 0x480 to 0x0
target/i386/kvm.c:2932: kvm_put_msrs: Assertion `ret ==
cpu->kvm_msr_buf->nmsrs' failed.

This fixes it by relaxing the condition.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Catherine Ho <catherine.hecx@gmail.com>
---
 target/i386/kvm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index bf16556..a8c44bf 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -2936,7 +2936,7 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
                      (uint32_t)e->index, (uint64_t)e->data);
     }
 
-    assert(ret == cpu->kvm_msr_buf->nmsrs);
+    assert(ret <= cpu->kvm_msr_buf->nmsrs);
     return 0;
 }
 
-- 
1.7.1

