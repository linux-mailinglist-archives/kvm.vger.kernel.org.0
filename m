Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 985A31DE744
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 14:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730195AbgEVMxV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 08:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729922AbgEVMw0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 08:52:26 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3A6C08C5C1
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 05:52:25 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id c11so10326248ljn.2
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 05:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pE6faVejbkAIUEORvfpEBGX8dWE5OEtccf8+g3bpDfA=;
        b=RPoE0F31yzBfOvWe7SLr/WKR/C2Sx4Gh7bwAeclpxq0/Vb+GNjxAJuEDdywAhAV+rG
         LPSwpxjdhaPrO6tPK9kLyU9lN+J2ICMlxxas0V3l5kGBMo3GGtqma7ZKf2e7FtyzTZqS
         KG5R8274XsAkdGpxCT1EQsqp3V4eoAOQ4oqvJ4wtWaqB9Ir9xHzwM7bFrSpATnNTj6er
         1QQiE6gfmsKimMLDlHETHNkpXH6oKGpbXDEkowiisx49AcyncgVvc25A2cOV7mVWKXHV
         79ghSiISaygzuziCXm5Lg5/wF/eQqqmW0HwJzq/V+XbVuTqhqr1DrqhesngodJsRG9EX
         SMCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pE6faVejbkAIUEORvfpEBGX8dWE5OEtccf8+g3bpDfA=;
        b=Ap7dnJHJCVusquAUguMotGrjrAMKFgEE/OAgpPL6hn534+Oixv2K6lUlxTMGPkJsSp
         r576uy5cADE/7pDDl4/J8Ei0nfSjEK2ydktATI/gR71YjAnkTcT2RPK701dUGP+JFSG7
         Wio3PPV4PxUB3X6JmSa9/yG9O+UyILd0x6SFu6Q/i2d0QG4mPK7BfiGppJXCtD5aWNVa
         i8OGStlj4LJOiEn9b7rfM7d6Gmj/66DT/IgJw0q5x04peHfgeo8iCJVp+NLX6kno66Py
         ssR4XpZWWrtNdJl78sR1XH0CYJgRLJEXB1L5nhSPPReR89pCZAzI1GmebbM4fulZx+77
         U5mg==
X-Gm-Message-State: AOAM533cP9TIle+VeSbSluplAqoonPvPeifReS9hX6+d9ksAZ1Cf1cAh
        rvv/kTMc26rw7Shu4TCFwnaEYA==
X-Google-Smtp-Source: ABdhPJxgFPaCjAkcKRCcIN9VQB3EgCJQ/VVHg9h7HUrXezHSNTMlbVQq98oVAeqSL+RKdW5J2/HvFQ==
X-Received: by 2002:a05:651c:2ce:: with SMTP id f14mr7217431ljo.87.1590151944358;
        Fri, 22 May 2020 05:52:24 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id t22sm2303766ljk.11.2020.05.22.05.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 05:52:22 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 0ABFA10205B; Fri, 22 May 2020 15:52:20 +0300 (+03)
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFC 13/16] x86/kvmclock: Share hvclock memory with the host
Date:   Fri, 22 May 2020 15:52:11 +0300
Message-Id: <20200522125214.31348-14-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

hvclock is shared between the guest and the hypervisor. It has to be
accessible by host.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/kernel/kvmclock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 34b18f6eeb2c..ac6c2abe0d0f 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -253,7 +253,7 @@ static void __init kvmclock_init_mem(void)
 	 * hvclock is shared between the guest and the hypervisor, must
 	 * be mapped decrypted.
 	 */
-	if (sev_active()) {
+	if (sev_active() || kvm_mem_protected()) {
 		r = set_memory_decrypted((unsigned long) hvclock_mem,
 					 1UL << order);
 		if (r) {
-- 
2.26.2

