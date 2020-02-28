Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DEFD1735CE
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 12:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgB1LGO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 06:06:14 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35767 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbgB1LGO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 06:06:14 -0500
Received: by mail-wm1-f66.google.com with SMTP id m3so2757422wmi.0
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2020 03:06:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=UtzqvagjojyZWesumE++cd2W7FJYGFwxDxrHDY41x2o=;
        b=toIkYrLRBouPK6oizZ7y+SqqNA29vHgT6MhAa2aDvwcsXEr5pQp/AWIlSEiJ6epfBj
         N963yT+TeOcDcHCMwy80Wc5smfySnydA4RnYYv+07pG2oa87l7MTBvPyfFcfqlOtUsrE
         03fvRBPz8yvg8BrhKyTJlg49xi0WCZvN4rh8wrW4O+rixjeTBWj5wJMcS0DRNIcXFenT
         JbMhk31Dg/QDoY2on09xitIl1N5uaOWiUB8C7ebluSV2SZ8RRJXCvEwX0UmBzOTNpss0
         EezuC/9im2sAXaGH6vhBYvRJb0mBbjGcPloGPQOYjxLqEqF6htrhJwD6nDYVtotj2oKb
         FRzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=UtzqvagjojyZWesumE++cd2W7FJYGFwxDxrHDY41x2o=;
        b=cjSEviPmXpMukA7CfeWOvX6ekV9t3agmyGy9wxH2t3RCvCIEBso0TTLQNFpl0AD1wX
         qBxwYcc/FLcmzFtmVDXyFvBQZ4IUS/1CWsi3El/klTe74eungASUSHUgLQbdy3QTV5Za
         1oI6AEnlxqGdMFunYpIHF5fe8qL08d1xIFWcdhKFRXVswgyVmsie3gVn2ki5/I1jXwSb
         TTDZFvggN8HVSO9/awizJiWqepnlyL9hbhLvOoptzJurjWJIQ4g4cS2Z+WmT2xEkiXti
         W28marNiVsusOuDW5hZ4tCD5HPjw+bmfPk5kOc0zx+bA2wI+UKr7AUDU2/H6j1x6m0TS
         cVtQ==
X-Gm-Message-State: APjAAAVLwAkVVDREUv4Vtbin5fCQv2PU638Oj+OWQRCVx9LQXN7otD05
        oEjrb8jV7UtB9DgP3bJELpOuHNwP
X-Google-Smtp-Source: APXvYqwLkSHBtmJX/D1dgMqT8zMqrKCZTQrT7FKG8xKsTyQaqQVSklvstMEH8b7aE20tUFVHO6XoqQ==
X-Received: by 2002:a1c:7512:: with SMTP id o18mr4392669wmc.110.1582887971806;
        Fri, 28 Feb 2020 03:06:11 -0800 (PST)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id j14sm12526467wrn.32.2020.02.28.03.06.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Feb 2020 03:06:11 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     morbo@google.com
Subject: [PATCH kvm-unit-tests] pci: use uint32_t for unsigned long values
Date:   Fri, 28 Feb 2020 12:06:09 +0100
Message-Id: <1582887969-48490-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Bill Wendling <morbo@google.com>

The "pci_bar_*" functions use 64-bit masks, but the results are assigned
to 32-bit variables; clang complains. Use signed masks that can be
sign-extended at will.

Reported-by: Bill Wendling <morbo@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 lib/linux/pci_regs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/linux/pci_regs.h b/lib/linux/pci_regs.h
index 1becea8..7c566d0 100644
--- a/lib/linux/pci_regs.h
+++ b/lib/linux/pci_regs.h
@@ -96,8 +96,8 @@
 #define  PCI_BASE_ADDRESS_MEM_TYPE_1M	0x02	/* Below 1M [obsolete] */
 #define  PCI_BASE_ADDRESS_MEM_TYPE_64	0x04	/* 64 bit address */
 #define  PCI_BASE_ADDRESS_MEM_PREFETCH	0x08	/* prefetchable? */
-#define  PCI_BASE_ADDRESS_MEM_MASK	(~0x0fUL)
-#define  PCI_BASE_ADDRESS_IO_MASK	(~0x03UL)
+#define  PCI_BASE_ADDRESS_MEM_MASK	(~0x0f)
+#define  PCI_BASE_ADDRESS_IO_MASK	(~0x03)
 /* bit 1 is reserved if address_space = 1 */
 
 /* Header type 0 (normal devices) */
-- 
1.8.3.1

