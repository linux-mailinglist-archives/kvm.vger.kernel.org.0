Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C870F2E7D6B
	for <lists+kvm@lfdr.de>; Thu, 31 Dec 2020 01:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbgLaA2q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Dec 2020 19:28:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbgLaA2p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Dec 2020 19:28:45 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E51C0617A0
        for <kvm@vger.kernel.org>; Wed, 30 Dec 2020 16:27:32 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id l8so31411880ybj.16
        for <kvm@vger.kernel.org>; Wed, 30 Dec 2020 16:27:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=HWHVyAaYti5x+balTemYgWkWGZb6R5Q+IhblvNdSnA4=;
        b=nV2DAgOKUv74I0sZv6UestOBd9ZPiX0Tg5MXL0UKMx0mTWOjG9EEAeSfT6nwfqxPRj
         6t/C1W1GURdgv3QTtBSCN8b81oh7fE2Q2G4HbxZ2Mm+9RVaevdonszamXmqsXFNM758x
         UD6VC08n26QxwFOM5J+vGC8PPcp2RSuo9+SuvofXxCdzKM9IBjW+MzqLMi5MTi0ajuki
         3rm7j0OIibL6xxHQGGHqy+iire07vkRWSvljrKkw/0zP01hZXfC2eYNfVm2K5fWr2jtK
         AGcs8mqrD0yucFTdx23v4f3PSRG7f13gX2Zi4CI47A+2TV59R028P2RcCvd9Dlt6t9ud
         EaJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=HWHVyAaYti5x+balTemYgWkWGZb6R5Q+IhblvNdSnA4=;
        b=nDdeSmffxwmIRmZ1X8RZjR53EFRs5u3LhaWiTAeb4CbJz5Foo63jV0Gd63I13G5RFO
         7qAvCRg0RqWy2xhlVF5t7KnMjKApTw5Uq3F89FIomlO7lT5FJg18+88qaNFeL4k0SVLc
         E/+qrpBN5ou6Vhm3LDzmybC4rqlz1gYPR85/ys50Ko81AxRCFDuwxw7JGoFp1oLotJiD
         uXUMpHVCef+JmhLyFZf5ND3xTQkwguhzHZScGqHxt4g3VMRvpUB9gAbz4xwY5pmqmXDy
         WT8uDwVY22W5yqFSh4xvSKE7hfNO1QwtYzUUnmCElbYodumfZ6omNd1fRL5GD1ZDA+CZ
         mX2g==
X-Gm-Message-State: AOAM531CPyq3PHhT07/nnB41Oo+28zgH0ePHgLGkmLYm8JNBUeD/Nu0U
        IEnp45/e19loraimFh9d+jQaorVaoIQ=
X-Google-Smtp-Source: ABdhPJzomd7keOE6oEDsAyqrWFvuieTucqpMPjNu/+4bcm40AHqQpXUJW2cdRPQVL2sUb/ai4Rtsz9xIqdU=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a25:3206:: with SMTP id y6mr78907819yby.127.1609374451495;
 Wed, 30 Dec 2020 16:27:31 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 30 Dec 2020 16:26:56 -0800
In-Reply-To: <20201231002702.2223707-1-seanjc@google.com>
Message-Id: <20201231002702.2223707-4-seanjc@google.com>
Mime-Version: 1.0
References: <20201231002702.2223707-1-seanjc@google.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH 3/9] x86/virt: Mark flags and memory as clobbered by VMXOFF
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David P . Reed" <dpreed@deepplum.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Uros Bizjak <ubizjak@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David P. Reed <dpreed@deepplum.com>

Explicitly tell the compiler that VMXOFF modifies flags (like all VMX
instructions), and mark memory as clobbered since VMXOFF must not be
reordered and also may have memory side effects (though the kernel
really shouldn't be accessing the root VMCS anyways).

Practically speaking, adding the clobbers is most likely a nop; the
primary motivation is to properly document VMXOFF's behavior.

For the flags clobber, both Clang and GCC automatically mark flags as
clobbered; this is noted in commit 4b1e54786e48 ("KVM/x86: Use assembly
instruction mnemonics instead of .byte streams"), which intentionally
removed the previous clobber.  But, neither Clang nor GCC documents
this behavior, and there's no downside to including the clobber.

For the memory clobber, the RFLAGS.IF and CR4.VMXE manipulations that
immediately follow VMXOFF have compiler barriers of their own, i.e.
VMXOFF can't get reordered after clearing CR4.VMXE, which is really
what's of interest.

Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: David P. Reed <dpreed@deepplum.com>
[sean: rewrote changelog, dropped comment adjustments]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/virtext.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index fda3e7747c22..2cc585467667 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -44,7 +44,8 @@ static inline int cpu_has_vmx(void)
 static inline void cpu_vmxoff(void)
 {
 	asm_volatile_goto("1: vmxoff\n\t"
-			  _ASM_EXTABLE(1b, %l[fault]) :::: fault);
+			  _ASM_EXTABLE(1b, %l[fault])
+			  ::: "cc", "memory" : fault);
 fault:
 	cr4_clear_bits(X86_CR4_VMXE);
 }
-- 
2.29.2.729.g45daf8777d-goog

