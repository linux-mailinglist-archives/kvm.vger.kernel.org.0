Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1987A352D6B
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 18:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236238AbhDBP1L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 11:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235869AbhDBP1D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Apr 2021 11:27:03 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 090DCC0617AB
        for <kvm@vger.kernel.org>; Fri,  2 Apr 2021 08:27:01 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id b4so8052712lfi.6
        for <kvm@vger.kernel.org>; Fri, 02 Apr 2021 08:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NRukntRqIH9oIHyEudEHW0ud1MS+kv1ItAvshsRDqdY=;
        b=OpnsWKAM4VA/3UajjTCQJv0IEmv/0iPE0cJ2j+RQr1BHXgXYYceO6wtUvATOrb8yhE
         ROIE0NF0cuH3XzqzsGoFP1JH5Z9yBF0PahBLj0EICTqrjAVYZO4E2fXsJt2FgeUg/8U9
         ZRGRbz90+MPk3bQ4bB+VUAa43wHu4myuLLxb01b9PPkMBQm771dpsGaPFoITfHu7WFsv
         iM0kGJIR3O5KSYl9ajKvDg7zS0KcRszn2eh6ZuRc4lo67X7SLMiHDVAUTOAF6p4iwgt+
         WdofJyWwhCixbMTTAehF+H2czWQ42ICOYt0u0Kz7T8yHx9byTn7DeA7quwp3YYB0vhrh
         bE7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NRukntRqIH9oIHyEudEHW0ud1MS+kv1ItAvshsRDqdY=;
        b=MtMA/ngaJdUdqw7T8NSWtxBsOMdcFbI67AVLwvi9lInSroG37mAEGy775C711T5RzC
         He+zhlHX/NZ6MbYovWBse0jDHXubdPVQjpfGJQxi9H16TTy3Nb5HBd7zQTMQ1Hcj5PDD
         emqzF1HvvHaylM4xJYfeIVaEmHmXZUVjJt4tUxMRYcrbLxTsV+SSyDdhwvSO3ZbEIoGY
         TfrhfhiekP22Q8a3H1z7Zg/VuVoBdIgBMq1Vu97v59E2ZkBh3CeGMwtXNuSAICYw9LhI
         pcyAcaTA6JtDgGtgNBvzicu9n2V8vinpgU39Yrs9noP/xQN3FGHms8fxxlVY5CiIgj+q
         TOzQ==
X-Gm-Message-State: AOAM5323zseNxbsPq6KCAqo3pPET4VKQ17mWwMNO4wHNOqU7dXsjHRmV
        q2Mgs2pHLFi120OkXBeP4ah07Q==
X-Google-Smtp-Source: ABdhPJw++Ib9aIsPBwn/2Eq095u9hzk548gclpFwNAHjmRz4tdPGJM905f0xXlmoFAawzYOuJioEtg==
X-Received: by 2002:a19:b49:: with SMTP id 70mr9524337lfl.342.1617377220450;
        Fri, 02 Apr 2021 08:27:00 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id w23sm953636lji.127.2021.04.02.08.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 08:26:59 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 4E65C102678; Fri,  2 Apr 2021 18:26:59 +0300 (+03)
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     David Rientjes <rientjes@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFCv1 6/7] x86/realmode: Share trampoline area if KVM memory protection enabled
Date:   Fri,  2 Apr 2021 18:26:44 +0300
Message-Id: <20210402152645.26680-7-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210402152645.26680-1-kirill.shutemov@linux.intel.com>
References: <20210402152645.26680-1-kirill.shutemov@linux.intel.com>
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
index 22fda7d99159..f3b54b5da693 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -10,6 +10,7 @@
 #include <asm/tlbflush.h>
 #include <asm/crash.h>
 #include <asm/sev-es.h>
+#include <asm/kvm_para.h>
 
 struct real_mode_header *real_mode_header;
 u32 *trampoline_cr4_features;
@@ -75,11 +76,11 @@ static void __init setup_real_mode(void)
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
2.26.3

