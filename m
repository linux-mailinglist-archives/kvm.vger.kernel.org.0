Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2821642E5CF
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 03:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbhJOBSH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 21:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232345AbhJOBSF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 21:18:05 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB1FC061570;
        Thu, 14 Oct 2021 18:15:59 -0700 (PDT)
Message-ID: <20211015011538.551522694@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634260558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=+MrVSk/2pciJ3iChH2fVF59RQ2MRpjf0vm2riZZbUpw=;
        b=MXB83Z3K+K9pR4xdFQsZTDqe17dya/qIry7s151HSJRy/+9yNIFDQEq3c2GK4NkbPtofVl
        IlEHLAbBFl9+qyfWf/512xLCp4/ChoN4eRrmvaBc0+pSiYiEpybNdyU8kZklxkbMdss6yx
        WZkrfJMQ1tDgH5byLctRaRw7hPmd9vhwocqeLYS18D9OKyNqV3RUZFH4xZpv3Zz3zr2UX/
        sq7AD+OyAWkOQjZvYgRq9FvLLVecjEojizqXlugh63Bz/KOsaZ9Y4WjmgpvYpqQJ5PwVjU
        TnaGrZpVqDdRJQD9AeQqU+zB9YXAuARK4OSKI5lmnuk+w6fW7dE8uaFhbQai7Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634260558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=+MrVSk/2pciJ3iChH2fVF59RQ2MRpjf0vm2riZZbUpw=;
        b=5k3nH9qdwbC9lGFKIKwV45Ges8DtCgWK+z265NNrxBRdamTyjw05NqOg9j3PFcI5xQVh3J
        iyv9KRHi17gGCjCg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [patch V2 03/30] x86/pkru: Remove useless include
References: <20211015011411.304289784@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 03:15:57 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PKRU code does not need anything from fpu headers. Include cpufeature.h
instead and fixup the resulting fallout in perf.

This is a preparation for FPU changes in order to prevent recursive include
hell.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/events/perf_event.h | 1 +
 arch/x86/include/asm/pkru.h  | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)
---
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index e3ac05c97b5e..134c08df7340 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -14,6 +14,7 @@
 
 #include <linux/perf_event.h>
 
+#include <asm/fpu/xstate.h>
 #include <asm/intel_ds.h>
 #include <asm/cpu.h>
 
diff --git a/arch/x86/include/asm/pkru.h b/arch/x86/include/asm/pkru.h
index ccc539faa5bb..4cd49afa0ca4 100644
--- a/arch/x86/include/asm/pkru.h
+++ b/arch/x86/include/asm/pkru.h
@@ -2,7 +2,7 @@
 #ifndef _ASM_X86_PKRU_H
 #define _ASM_X86_PKRU_H
 
-#include <asm/fpu/xstate.h>
+#include <asm/cpufeature.h>
 
 #define PKRU_AD_BIT 0x1
 #define PKRU_WD_BIT 0x2

