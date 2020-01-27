Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4E1B149F28
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 08:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgA0HQS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 02:16:18 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:44622 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbgA0HQS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jan 2020 02:16:18 -0500
Received: by mail-ot1-f66.google.com with SMTP id h9so7404093otj.11;
        Sun, 26 Jan 2020 23:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ZTshCe94WzSsfXve6ziu+qTyps0fLQU+BDDkCbT6Bso=;
        b=tsfuDBGTQVhy70maJJPR3yaIKX8BjW23nAIzNWcWsDqNiB/oBXDoWDJ1whQefG8H5T
         qA+zgESqYPhbL05359SxdqjN7XPsc4ZCVcF60/E3vAaWD8dyjnpXX28Bw5HW44X/bShJ
         IspH7PC33TbNJdg9v4cXf5eQGf0WRNIbH5gI0DPlFwQAM2ZU/+tQtoN+KcJK15Uw4zgj
         AX5NwHYvM2nrcqgjzy2uOE8dE1NndLkC3lfJU+MUH4T9vVKIR5yoBQYrclHpQuUBjq5A
         MMAZ4I80FDACK65hhPDSWN3aS18HSk1chsTDXMUCsJy4Dh/Ppk5sCK+P9WP6kjloGkb6
         Lu+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ZTshCe94WzSsfXve6ziu+qTyps0fLQU+BDDkCbT6Bso=;
        b=oE35V4duXWT75m32qjpdodBvoe5fnRW5N+jSjPEmxTV8U1U2LQmzbWUMVJE1Kwb7vA
         Thc4hvMFWlaITAwG0KwPdEqVmXvuCcVJFOlrU+JiwAhJ6ny3KKbL1e7e4WnCIC1oBM0/
         mL8L+Hyb4GNO+dMi5571Z+tOchCy+Ehv//R/cuk+rfVLpjspUWsAjxZsMmpgIhhytvsR
         198qC9qmrOBhhREaCthwP2tElnn+myfv7uZQQanKdBEA+qST+l54uGSPo/SnlcO5Phfk
         QyHqC4UC9mDn5Hej9lsJHFZ8Z/blrzHD2VGJl/fLpGZcvzX9FtnUSzK1NSMSkREn62oi
         h8qA==
X-Gm-Message-State: APjAAAVqM5TAOgHE3z7rJpqmHcIqs0kKlAiz0hCIEyABkolwCylB0EUN
        p0TO5upCK9q6IgseX5jB8UI=
X-Google-Smtp-Source: APXvYqyBvsPV5HUfCbEOF6ZmFCmj7SSgxfXyaKHBatxbogtKM0leCRK+ExTQvjrYuSeo/zgeV0umsQ==
X-Received: by 2002:a9d:729c:: with SMTP id t28mr8584637otj.66.1580109377176;
        Sun, 26 Jan 2020 23:16:17 -0800 (PST)
Received: from nick-Blade-Stealth.attlocal.net (23-121-157-107.lightspeed.sntcca.sbcglobal.net. [23.121.157.107])
        by smtp.googlemail.com with ESMTPSA id n25sm4500248oic.6.2020.01.26.23.16.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jan 2020 23:16:16 -0800 (PST)
From:   Nick Desaulniers <nick.desaulniers@gmail.com>
To:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de
Cc:     Nick Desaulniers <nick.desaulniers@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH] dynamically allocate struct cpumask
Date:   Sun, 26 Jan 2020 23:16:02 -0800
Message-Id: <20200127071602.11460-1-nick.desaulniers@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This helps avoid avoid a potentially large stack allocation.

When building with:
$ make CC=clang arch/x86/ CFLAGS=-Wframe-larger-than=1000
The following warning is observed:
arch/x86/kernel/kvm.c:494:13: warning: stack frame size of 1064 bytes in
function 'kvm_send_ipi_mask_allbutself' [-Wframe-larger-than=]
static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int
vector)
            ^
Debugging with:
https://github.com/ClangBuiltLinux/frame-larger-than
via:
$ python3 frame_larger_than.py arch/x86/kernel/kvm.o \
  kvm_send_ipi_mask_allbutself
points to the stack allocated `struct cpumask newmask` in
`kvm_send_ipi_mask_allbutself`. The size of a `struct cpumask` is
potentially large, as it's CONFIG_NR_CPUS divided by BITS_PER_LONG for
the target architecture. CONFIG_NR_CPUS for X86_64 can be as high as
8192, making a single instance of a `struct cpumask` 1024 B.

Signed-off-by: Nick Desaulniers <nick.desaulniers@gmail.com>
---
 arch/x86/kernel/kvm.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 32ef1ee733b7..d41c0a0d62a2 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -494,13 +494,15 @@ static void kvm_send_ipi_mask(const struct cpumask *mask, int vector)
 static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int vector)
 {
 	unsigned int this_cpu = smp_processor_id();
-	struct cpumask new_mask;
+	struct cpumask *new_mask;
 	const struct cpumask *local_mask;
 
-	cpumask_copy(&new_mask, mask);
-	cpumask_clear_cpu(this_cpu, &new_mask);
-	local_mask = &new_mask;
+	new_mask = kmalloc(sizeof(*new_mask), GFP_KERNEL);
+	cpumask_copy(new_mask, mask);
+	cpumask_clear_cpu(this_cpu, new_mask);
+	local_mask = new_mask;
 	__send_ipi_mask(local_mask, vector);
+	kfree(new_mask);
 }
 
 /*
-- 
2.17.1

