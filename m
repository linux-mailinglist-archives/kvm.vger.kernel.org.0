Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC2C916102C
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 11:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgBQKgy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 05:36:54 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:35589 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgBQKgx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 05:36:53 -0500
Received: by mail-ot1-f67.google.com with SMTP id r16so15637143otd.2;
        Mon, 17 Feb 2020 02:36:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=ur/ztzg097hNdiOqNl8MURR6+AytvFPiL8IkE10Yl1Q=;
        b=NJoGVxJgA8Ke2CHUVj9hmcpI5GSEOxBa9au4sw2v0wW7hnClOJbAG2aCuVfJV7cJep
         CxKMl62BY6MY+WpZPIcbnvj5We8vw5q1pZNSenF4Xx7QpXnItnQyE5nJY0qC7hmdvvj3
         ITLmRwT3U41EBZds1mbQRQ63N7eOFzhAiI/gMJtDUQIH8DZPPe4o/L51/kLfYQrFyJo+
         JNoCN4TLAFPc4FT38cG9moYmFtzUvDNSU4bNfZcmz8zS/QPNSg6vge66CPPaL40DIQw9
         EDsNxTzzIkBrHMyyrxv+cak+suv4+jRWRvPNG4sVoteghhIN1Kj+pie6zjV4bF0nj59c
         cl1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=ur/ztzg097hNdiOqNl8MURR6+AytvFPiL8IkE10Yl1Q=;
        b=NOYC6RuPWxB5ZpyYR0+pF7pAebqG5MZ3xKKGCX7XmwnoXBlACKL66KjmOW1f0/D95+
         P20VZGgpKEY90FleyJI7Niso2ikMa2+OxPM2DvWaAkwkzgZ2/NnFLLbhlTiTAzmBQvqm
         sDB94XwcNL4uhhsAP0FzxXwVctRp7NqlGqWAUZq6x+tryu8xyHXH2/JT8lBbL+5UZaRE
         Yki8DA8RjbGrJiLww8znlT04ED8PsdRdkAYkbAF5ngT5Yv00N49FLrVzDFcmQ2xTthBZ
         vSBl4piy54v4oFPBavor/0e2iYVf+vsIeXvfpz2i4tCRASHBHIEh4Cbyw3kL9rKdRyZn
         i/bQ==
X-Gm-Message-State: APjAAAUpo3MxvczLtDJB3s4yT1Vfm6vgBgsS10lgPA63Ov/ubO0UIPrA
        agKtpFMeHA1wmhpeRFC7mdNu7XcRakWiAbm3MTxrtujQmS6l5Q==
X-Google-Smtp-Source: APXvYqx+pB+sFO42DRkAL0RCvyTGIbk1nCpM3Rl6C4VZ+Q++st91JjnhSvk4mXvlkrf0/U07A7VQF4bh5F4pNz5qn7I=
X-Received: by 2002:a9d:63d6:: with SMTP id e22mr11830539otl.185.1581935812830;
 Mon, 17 Feb 2020 02:36:52 -0800 (PST)
MIME-Version: 1.0
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 17 Feb 2020 18:36:41 +0800
Message-ID: <CANRm+Cz6Es1TLFdGxz_65i-4osE6=67J=noqWC6n09TeXSJ5SA@mail.gmail.com>
Subject: [PATCH v3 1/2] KVM: X86: Less kvmclock sync induced vmexits after VM boots
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

In the progress of vCPUs creation, it queues a kvmclock sync worker to
the global
workqueue before each vCPU creation completes. Each worker will be scheduled
after 300 * HZ delay and request a kvmclock update for all vCPUs and kick them
out. This is especially worse when scaling to large VMs due to a lot of vmexits.
Just one worker as a leader to trigger the kvmclock sync request for
all vCPUs is
enough.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/x86.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fb5d64e..d0ba2d4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9390,8 +9390,9 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
     if (!kvmclock_periodic_sync)
         return;

-    schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
-                    KVMCLOCK_SYNC_PERIOD);
+    if (kvm->created_vcpus == 1)
+        schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
+                        KVMCLOCK_SYNC_PERIOD);
 }

 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
--
2.7.4
