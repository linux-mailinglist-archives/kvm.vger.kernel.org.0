Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAA6D5896B
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 20:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbfF0SBu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 14:01:50 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44534 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbfF0SBu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 14:01:50 -0400
Received: by mail-pf1-f193.google.com with SMTP id t16so1600836pfe.11
        for <kvm@vger.kernel.org>; Thu, 27 Jun 2019 11:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=nzDqGzdl7G2ODy1DKC/5xLs0B4YLweJhbbu3iqVK++M=;
        b=ZQMt1q4RhXW3ZQ42Dwwl2Q8UOsRd+0xC0c318NlRT/5fB04TpB1fkOb98WkZ2qhyED
         qRyFAMf/spieKkB8n3Qb2fbXEgVznip1aUV7W9J5b5F4FZmc6UWEyN3nvcXklh42VGbt
         WCz4f+iiBBOI8jP74K1rhSGoIovUsvBNMJDMTzPPx13C/ZhMwVHRJfGBRSYVOgBZyMp2
         N06zKAA0NIMhtDq661gAjbcXOdgG4a3iy317lxOE1wPLAOfxWQPToGL2ginm3BmoOCs8
         7bE7FkREEXXyYG6l7uba5R32oB1ffMIv3AYKJ6ch5Wz1X8YqnjcLpQPVcFsMp3YVP/HN
         sOiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nzDqGzdl7G2ODy1DKC/5xLs0B4YLweJhbbu3iqVK++M=;
        b=m9YY7Yat5Pdms/mea+2tTHkS1GvzWEAOSk/i9MB8uh1+mUoTj8AOVFy+H2CY4Rbbhn
         YEzGpPzbxdrCcAL/qYhR65rJMq89BP80dm1/q2WuH1X6oEUk4e5FfBEuCWn6B/vgk/Jj
         HE8CMulje+uMu3OQ4tifkQCGnFKn7cf00m4gLIX8F+IiEwSrfSnsZzP+RftR9JVbYpCW
         g4oaXZxYYjnHDFTKL44OSKgPf7Pk/uhL8nDYn/4TwG+Irt6xJrO4AwG+l2kyCubcu4Pe
         k55hSoKyUvcmGUMF1w+m7fIBLgV9YDQy1d8S13ZX6FfVhVDYOe2I3MksZRT94QZE6gYx
         ocLw==
X-Gm-Message-State: APjAAAUpRp+zuK0VM1b7nVv6h3Qa0QVgnQ/LbFFSkvesDHP5cbk4/dLf
        JtUWDZWehc6uTSRBGeQfOTU=
X-Google-Smtp-Source: APXvYqzEj6VykwQ4lvb7sCDvkNH4pizyZwrYOo7xD7aDyoAjXibE/puaP5AkRBSOKry0vUjdr1BVaA==
X-Received: by 2002:a17:90a:a00d:: with SMTP id q13mr7473623pjp.80.1561658509514;
        Thu, 27 Jun 2019 11:01:49 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id p68sm4058512pfb.80.2019.06.27.11.01.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 11:01:48 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: [kvm-unit-tests PATCH v2] x86: Reset lapic after boot
Date:   Thu, 27 Jun 2019 03:39:37 -0700
Message-Id: <20190627103937.3842-1-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do not assume that the local APIC is in a xAPIC mode after reset.
Instead reset it first, since it might be in x2APIC mode, from which a
transition in xAPIC is invalid.

To use reset_apic(), change it to use xapic_write(), in order to make safe to use
while apic_ops might change concurrently by x2apic_enable().

Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 lib/x86/apic.c | 2 +-
 x86/cstart64.S | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/x86/apic.c b/lib/x86/apic.c
index 1514730..b3e39ae 100644
--- a/lib/x86/apic.c
+++ b/lib/x86/apic.c
@@ -164,7 +164,7 @@ void reset_apic(void)
 {
     disable_apic();
     wrmsr(MSR_IA32_APICBASE, rdmsr(MSR_IA32_APICBASE) | APIC_EN);
-    apic_write(APIC_SPIV, 0x1ff);
+    xapic_write(APIC_SPIV, 0x1ff);
 }
 
 u32 ioapic_read_reg(unsigned reg)
diff --git a/x86/cstart64.S b/x86/cstart64.S
index 9791282..1889c6b 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -228,6 +228,7 @@ save_id:
 	retq
 
 ap_start64:
+	call reset_apic
 	call load_tss
 	call enable_apic
 	call save_id
@@ -240,6 +241,7 @@ ap_start64:
 	jmp 1b
 
 start64:
+	call reset_apic
 	call load_tss
 	call mask_pic_interrupts
 	call enable_apic
-- 
2.17.1

