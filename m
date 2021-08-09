Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E623E42CA
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 11:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234545AbhHIJen (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 05:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234521AbhHIJem (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 05:34:42 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C55C9C0613CF;
        Mon,  9 Aug 2021 02:34:22 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id e19so2193114pla.10;
        Mon, 09 Aug 2021 02:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LMGJDyl7UhcfZwG/lrk8OVLrJYjfTuTv0zD0UPmM7+o=;
        b=SQqQMjjNJtk6SKMeeSexM65VwayfQgmINsOAHqkKJo7kzA1/yVXgQDnT8/H/wInPhb
         dwYT7HJKzbmzjFLykHB3wicVvn63a89l8CHHtM26NGaShcDuvTJFPZxluspYhjmGdNWE
         O76Wjlfp3KrKA6pA6CK4V+Zko6mbZPp1b8u3ZJZ/psSENk1VHfttgCj77mZeEL27iToZ
         b/+3oK5gl4a0XMjKO3NkVLFsLGyAx0PqTl1LKehnDbioClJgmJ2nkhBBWGSKPrrFDcoz
         FB/4IuAXqHTp5madlb8ZI2Ymi9J4/U4KARlKpFFdn4K6GVd9QXAZ/JoqYljC+d9vKBgr
         RojQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LMGJDyl7UhcfZwG/lrk8OVLrJYjfTuTv0zD0UPmM7+o=;
        b=cjHRyuIw+3Tn9YNl+A6HregJhceWtWZXMgdBQzbG/WXC8gnsXfXIe14WeFMTUJ8ZHg
         t3FBtOF3jNNDhcmQgxASMGBnfsh+mqdmMQLHAHjdaymeLUzuN73P14BhyKbAeig5X+uj
         nkPl4RzOYr9cou9K5trHHpjZ3HoIJzlk0VXegOSLK5PljoZ1Gy4c4YqY/C9duhAn7boy
         pW8+TPtW4sTNNzU/aA4eTNc1N1LkVGmARKrBYKRKLE5jizFSC9v1+JVtda64ICb56oOQ
         isjZXNXZEIgNIJaQUw6t2RrqzzKC6ELRWIliy2Db8Dy+s24tv1qwNmJt3QC0JlBgb1H/
         XYiQ==
X-Gm-Message-State: AOAM533QWYbTf7OaHgHZwJ/6QhdldCp62iyHDveNB/cA+n1If3BAPlXc
        fqJVxHaYORFlugvwr2Kubms=
X-Google-Smtp-Source: ABdhPJyZU6UtCWnNmc+vik8Zko8d4QMuc0ueQP8e8SRyNKnXWN87CtOVEYzgehdkvo5psjMlLMXh+g==
X-Received: by 2002:a63:7343:: with SMTP id d3mr87542pgn.169.1628501662437;
        Mon, 09 Aug 2021 02:34:22 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h188sm10839982pfg.45.2021.08.09.02.34.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Aug 2021 02:34:22 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] KVM: x86: Clean up redundant mod_64(x, y) macro definition
Date:   Mon,  9 Aug 2021 17:34:06 +0800
Message-Id: <20210809093410.59304-2-likexu@tencent.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809093410.59304-1-likexu@tencent.com>
References: <20210809093410.59304-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The mod_64(x, y) macro is only defined and used in the kvm/x86 context.
It's safe to move the definition of mod_64(x, y) from x86/{i8254lapic}.c
to the generic x86.h without any intended functional change.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/i8254.c | 6 ------
 arch/x86/kvm/lapic.c | 6 ------
 arch/x86/kvm/x86.h   | 6 ++++++
 3 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 5a69cce4d72d..81d2ba064dc3 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -40,12 +40,6 @@
 #include "i8254.h"
 #include "x86.h"
 
-#ifndef CONFIG_X86_64
-#define mod_64(x, y) ((x) - (y) * div64_u64(x, y))
-#else
-#define mod_64(x, y) ((x) % (y))
-#endif
-
 #define RW_STATE_LSB 1
 #define RW_STATE_MSB 2
 #define RW_STATE_WORD0 3
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 76fb00921203..6b3d8feac1d0 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -42,12 +42,6 @@
 #include "cpuid.h"
 #include "hyperv.h"
 
-#ifndef CONFIG_X86_64
-#define mod_64(x, y) ((x) - (y) * div64_u64(x, y))
-#else
-#define mod_64(x, y) ((x) % (y))
-#endif
-
 #define PRId64 "d"
 #define PRIx64 "llx"
 #define PRIu64 "u"
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 44ae10312740..6aac4a901b65 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -8,6 +8,12 @@
 #include "kvm_cache_regs.h"
 #include "kvm_emulate.h"
 
+#ifndef CONFIG_X86_64
+#define mod_64(x, y) ((x) - (y) * div64_u64(x, y))
+#else
+#define mod_64(x, y) ((x) % (y))
+#endif
+
 static __always_inline void kvm_guest_enter_irqoff(void)
 {
 	/*
-- 
2.32.0

