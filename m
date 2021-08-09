Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4AD83E42CE
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 11:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234630AbhHIJev (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 05:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234564AbhHIJeu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 05:34:50 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF97C061796;
        Mon,  9 Aug 2021 02:34:30 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so33546164pjr.1;
        Mon, 09 Aug 2021 02:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=paMMYKKDNMpKtXFsce6OcCMqHzENmTbIMXLEYEGC9LM=;
        b=YfmvDMH8vOx5dSG8Iguhx/ExPkvGJl8W2PJzWwEQW/MIoVsUOMmL4izX0nfphOurzh
         na2Qo3OOnJ3MjgfVaaBkqYZGkvv98IgzooTQfDOR6+hdvzIyjegHOs1y4G6l8DSl5I3n
         bmXZ+x2zT32FtOtyp3eliwY35QHyzy+Ag3lUrh1nGVU6VzBcyG5GfgdO88hfm4zfJF09
         JPi+pS8fokwdf9IQa5HWikZgCf6YjolZ7oswnKOOS98439Mbms6N5yODv+Xo1v0KiG5x
         IlVoghL9vGtld7yrCXXHouj2M9RF9urgQd6dnnoAKURgU1onxLYmMOAGYyxEh8pG3nxP
         2/zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=paMMYKKDNMpKtXFsce6OcCMqHzENmTbIMXLEYEGC9LM=;
        b=iC5ycX0OiHNE0SnatQHYpB/K7nRsZWIykxJGZGEcE32mMftboggvhLxPtsuF4lwvoI
         +1gvAahNBY+c7KUbtYJ2bMmNt/9TP8xgvxlBGnxRGjiuZYEdwC9WlD5A/qip/0bYjV9g
         UC94tl8TtboQ+rFfqd9zCVTluve/B1wl6AQkGFOOaGn3BzCzRWOLdptmMZ0k+bFlvcNM
         iXOPgMx8hnb6Ks/epoGEPeom7kostNrKZaq8vjnvBUarNSTTIjYk1VyBC/h/+BAew42l
         DM5QlC60w/fT/qVSqotFiiTuOgenkWfpeujmNswI2cqetA4EobuWssByN+iLoO6nb9nI
         31lA==
X-Gm-Message-State: AOAM533G5MLjgTnICemiUcrjzhqgzQksxEak5jhBHdbKXwzJbmD1aSJ/
        PEECtFFl4RoxfN/EOq14ryI=
X-Google-Smtp-Source: ABdhPJymEN9P+1KmLocw1I3tK+cZ/V7imfxvFX/+U6VG93/lGJn536uhRiVpRcCOaE36oGuGcVSvXg==
X-Received: by 2002:a17:902:6ac8:b029:12d:632:ffcf with SMTP id i8-20020a1709026ac8b029012d0632ffcfmr8948632plt.28.1628501670386;
        Mon, 09 Aug 2021 02:34:30 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h188sm10839982pfg.45.2021.08.09.02.34.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Aug 2021 02:34:30 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] KVM: x86: Clean up redundant __ex(x) macro definition
Date:   Mon,  9 Aug 2021 17:34:09 +0800
Message-Id: <20210809093410.59304-5-likexu@tencent.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809093410.59304-1-likexu@tencent.com>
References: <20210809093410.59304-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The __ex(x) macro is repeatedly defined in sev.c, svm.c and vmx_ops.h,
and it has never been used outside the KVM/x86 context.

Let's move it to kvm_host.h without any intended functional changes.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/svm/sev.c          | 2 --
 arch/x86/kvm/svm/svm.c          | 2 --
 arch/x86/kvm/vmx/vmx_ops.h      | 2 --
 4 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4c567b05edad..7480d31463bc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1823,6 +1823,8 @@ asmlinkage void kvm_spurious_fault(void);
 	"668: \n\t"							\
 	_ASM_EXTABLE(666b, 667b)
 
+#define __ex(x) __kvm_handle_fault_on_reboot(x)
+
 #define KVM_ARCH_WANT_MMU_NOTIFIER
 
 int kvm_cpu_has_injectable_intr(struct kvm_vcpu *v);
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 9f1585f40c85..19cdb73aa623 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -28,8 +28,6 @@
 #include "cpuid.h"
 #include "trace.h"
 
-#define __ex(x) __kvm_handle_fault_on_reboot(x)
-
 #ifndef CONFIG_KVM_AMD_SEV
 /*
  * When this config is not defined, SEV feature is not supported and APIs in
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9d72b1df426e..2b6632d4c76f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -46,8 +46,6 @@
 #include "kvm_onhyperv.h"
 #include "svm_onhyperv.h"
 
-#define __ex(x) __kvm_handle_fault_on_reboot(x)
-
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
diff --git a/arch/x86/kvm/vmx/vmx_ops.h b/arch/x86/kvm/vmx/vmx_ops.h
index 164b64f65a8f..c0d74b994b56 100644
--- a/arch/x86/kvm/vmx/vmx_ops.h
+++ b/arch/x86/kvm/vmx/vmx_ops.h
@@ -10,8 +10,6 @@
 #include "evmcs.h"
 #include "vmcs.h"
 
-#define __ex(x) __kvm_handle_fault_on_reboot(x)
-
 asmlinkage void vmread_error(unsigned long field, bool fault);
 __attribute__((regparm(0))) void vmread_error_trampoline(unsigned long field,
 							 bool fault);
-- 
2.32.0

