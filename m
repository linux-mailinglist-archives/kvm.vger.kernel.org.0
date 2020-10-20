Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733A62934C6
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 08:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403893AbgJTGTO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 02:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403871AbgJTGTM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 02:19:12 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDAB2C0613DA
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 23:19:10 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id a5so725953ljj.11
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 23:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vaud5LDoCMN7VYhH4oLnzKJ275PDylYsQEFgwO7dM1A=;
        b=uRxBxRP022DKNAknogcT1hVjFyXYSFc3HjPH/yHkhWIPPZ5/a2m0cy+pO6EHn8x+pC
         cQccGGl77VGFHrSaBgF+dCQv80xDnzvt3ORVquoJbp2plCK9KYKacYaCn7Neqkm4B/oD
         Mk6URhr1Qqhh+mYOKukSQtQDPQXG6MeJ6XHh1md445K+c2dAh4xTMEIdBd8bBqtmOkoO
         N8KVTNaKjDwZsA2HgAIOOPvnPvR33QIlN1BUfsiBOvcOUnrulKXPrMyZnAwoH6v9AQrT
         /jXZ+Yj6YnnKzR2FB/soZsY6Ey6nxbP1P2AfmLn38McxO4SUWVgzzZmVm2UilsP0hTxY
         2sjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vaud5LDoCMN7VYhH4oLnzKJ275PDylYsQEFgwO7dM1A=;
        b=E4uzDyetJIhMSSVuVwNj0y9RQH5n31jZt2/+A9JyhabkGCKv8CVz2URBvOZ5VfqsIi
         CnORtqwgv+LQgzSijXMqKHQEoPCvz0EPUppgBZ/ohpmKmlxUHV4zVPuDHcRD5mP1eKbd
         WT5GBKtybUM6g0r3KgPqIwblo38Ey5b2nRhTXgWmGsaDnCK0OyWWAXx6OEiwA2FQkNQO
         0Al2M2JIPtG8cjf3t5Cm2TmNFeU6iGdYyBYqQTFZzUspwDNUnpvS7G8Z0VzT+Qj50elS
         5bhm33nAvK5RPG1OzP33xsbHNbGjDEVdtSRptf+8esJisgY9iPz18opG3bWyFDiVnwft
         Z7qg==
X-Gm-Message-State: AOAM533dL51tRW6tCRB1AzG1i5pX3Xa5KKzWvb0kUmOXUGhEr1wxD4Q7
        rpNnQnJ3/uW+sHQxHpq1Y5yF2A==
X-Google-Smtp-Source: ABdhPJywmvEpa7Ydh3L77EwVrCq7+3fO4YdtEd4vP4JBqRv2DbR3YE4NZhPbQkl4Hp+GW9rY1xZDOQ==
X-Received: by 2002:a2e:9f49:: with SMTP id v9mr512286ljk.369.1603174749329;
        Mon, 19 Oct 2020 23:19:09 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id k19sm194793ljg.88.2020.10.19.23.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 23:19:07 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id E7995102F66; Tue, 20 Oct 2020 09:19:01 +0300 (+03)
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
        "Kleen, Andi" <andi.kleen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFCv2 07/16] x86/realmode: Share trampoline area if KVM memory protection enabled
Date:   Tue, 20 Oct 2020 09:18:50 +0300
Message-Id: <20201020061859.18385-8-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If KVM memory protection is active, the trampoline area will need to be
in shared memory.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/realmode/init.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index 1ed1208931e0..7392940a7f96 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -9,6 +9,7 @@
 #include <asm/realmode.h>
 #include <asm/tlbflush.h>
 #include <asm/crash.h>
+#include <asm/kvm_para.h>
 
 struct real_mode_header *real_mode_header;
 u32 *trampoline_cr4_features;
@@ -55,11 +56,11 @@ static void __init setup_real_mode(void)
 	base = (unsigned char *)real_mode_header;
 
 	/*
-	 * If SME is active, the trampoline area will need to be in
-	 * decrypted memory in order to bring up other processors
+	 * If SME or KVM memory protection is active, the trampoline area will
+	 * need to be in decrypted memory in order to bring up other processors
 	 * successfully. This is not needed for SEV.
 	 */
-	if (sme_active())
+	if (sme_active() || kvm_mem_protected())
 		set_memory_decrypted((unsigned long)base, size >> PAGE_SHIFT);
 
 	memcpy(base, real_mode_blob, size);
-- 
2.26.2

