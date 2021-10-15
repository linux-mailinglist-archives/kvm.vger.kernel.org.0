Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8782342E5D5
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 03:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbhJOBSN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 21:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233020AbhJOBSK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 21:18:10 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF805C061570;
        Thu, 14 Oct 2021 18:16:04 -0700 (PDT)
Message-ID: <20211015011538.722854569@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634260563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=i1kz6jZJsBK77znZm+uKwkWxRf7TFLfVlxwf5q30Gk0=;
        b=DOTmXuXGVblCRPywIpGoR1TjViFut3fHZ+Hmro8oejUAcm0XpiiJN6/5AG86SOuYZILw66
        80LF0dR8qbnXhkExOxFYOA8S45RUNdSTH0S4YgXiJuJej8Kl2OfnWnjgmEGBK2APTeRu3+
        zFMrA9XF0ODUCAus8V8sDluh492p788FOvGcYhDXPg+EyctlwvJJBQZOLKUzBnF+ULd6Pt
        ja3gJH8sCVXMe60xZ8bPOYG4NUu6790VOC0msAJ/jBVIjIYsRgQhYoKWgvy5XHtifahyoq
        XMbAcivpjBX+qBIGKJNJUp+0S/I0KEmLpppVL+ATL+1IEpyrcmoo/3Xwtl4fSw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634260563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=i1kz6jZJsBK77znZm+uKwkWxRf7TFLfVlxwf5q30Gk0=;
        b=vJchbI6TWMY8QbTB0y9qZ6i4C1kU/HpVMArljnrkGYRNtmcaUn7AOnvoBcWqtUIxR5unhU
        GuOd6XQ08xpPBCCg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [patch V2 06/30] x86/fpu: Remove pointless memset in fpu_clone()
References: <20211015011411.304289784@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 03:16:02 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Zeroing the forked task's FPU register buffer to avoid leaking init
optimized stale data into the clone is a pointless exercise for the case
where the current task has TIF_NEED_FPU_LOAD set. In that case the FPU
register state is copied from current's FPU register buffer which can
contain stale init optimized data as well.

The alledged information leak is non-existant because this stale
init optimized data is nowhere used and cannot leak anywhere.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/kernel/fpu/core.c | 6 ------
 1 file changed, 6 deletions(-)
---
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 7ada7bd03a32..191269edac97 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -260,12 +260,6 @@ int fpu_clone(struct task_struct *dst)
 		return 0;
 
 	/*
-	 * Don't let 'init optimized' areas of the XSAVE area
-	 * leak into the child task:
-	 */
-	memset(&dst_fpu->state.xsave, 0, fpu_kernel_xstate_size);
-
-	/*
 	 * If the FPU registers are not owned by current just memcpy() the
 	 * state.  Otherwise save the FPU registers directly into the
 	 * child's FPU context, without any memory-to-memory copying.

