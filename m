Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D26C016FB21
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 10:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgBZJos (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 04:44:48 -0500
Received: from mail-pj1-f74.google.com ([209.85.216.74]:32793 "EHLO
        mail-pj1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727755AbgBZJor (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 04:44:47 -0500
Received: by mail-pj1-f74.google.com with SMTP id d22so3176441pjz.0
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 01:44:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8jRgCwzJ8Nd5T5rE+lPl847X85QqKrhxlvETBwwHawg=;
        b=R5M4gSi27/8wsScH9vepQ3Uuh5AkuTjH6OT+QnjVn/HcIXRUy9PbUBtT5BqxBuBgtz
         F2U7omZOs04LRhZVdpmjfaiNAFg35HMWsKYTnPCkRgdde2Vcp7MKX1NWcZNgVLWlMIQJ
         bkl+CshsGp4AkzQ8BwXKr/L/++BL1ufGka3MGek/W13nFL1O7iaebhxVGblm5N6W3l1L
         uKtUupLZ+zGJ3X5sJVqFkBETvs48o6J+VLYjjQsvdQKr9m86ZBf67yJqfYBYZIYpeBjz
         GKfsQ+S3fV5Mrdy+CgD7zkUEfP7h/mLE50Mshd+KlqtAwM2DZXMU5YAIXCvEr7kpk8+y
         1vMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8jRgCwzJ8Nd5T5rE+lPl847X85QqKrhxlvETBwwHawg=;
        b=UYTbN7xOm0cO1cFH+bENQRInWl7c1yIL8bGnY8a6R9KV6hWlliYEDkj/pDvJNRKbAA
         eIHXyd1bUvsiei/Tq9gG5jJEDHYxBr/qJ1WMBxe413n3k1j4JbWjDv23nZGPZaPg2jsL
         IjScVzfcfIKy4sXm4S0dAtY1Jb0XobqVKyEzREgMzp3Pespf09ak3aLyRjtruemxQmOr
         JMy5NBjEsMKe0zRkGf2/JPeWAEEMRwZJFvA9AjpPxuNEPCWcp4I53xFJNPP2tK1QeJuF
         j+4z721gJUU+O3j1Ejb7CK5jaOR1TZeSD5NyY0k8yMiHCh8hZ4EX8G+30VD6RQa1bYS6
         LV8Q==
X-Gm-Message-State: APjAAAW+4QOjVDu+rSAe62fqMR8Irq8s4B2fepzqDz0jlWCWmMeY40Pe
        f47UQEURr/OuEA98tzX2GjPYVJZapzzBdin1Q/BdEPXkiP96TXrVUvNvx4hF9Pl+SafdEMYGTJ4
        ZJmBL8x4k7jZ+uv+3nMBOip0kKnDKxaCLPoXsBZjVlvTA3m0nuIEnPA==
X-Google-Smtp-Source: APXvYqy55lxnOwrmr4cVBxjt/WHLFMdv985OaFcEYKv1KhZHyC3wJJH8OI2XglbYDbZfK0aa/5BDm1uVFQ==
X-Received: by 2002:a63:7013:: with SMTP id l19mr3013777pgc.58.1582710284776;
 Wed, 26 Feb 2020 01:44:44 -0800 (PST)
Date:   Wed, 26 Feb 2020 01:44:22 -0800
In-Reply-To: <20200226094433.210968-1-morbo@google.com>
Message-Id: <20200226094433.210968-4-morbo@google.com>
Mime-Version: 1.0
References: <20200226074427.169684-1-morbo@google.com> <20200226094433.210968-1-morbo@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [kvm-unit-tests PATCH 2/7] pci: use uint32_t for unsigned long values
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org
Cc:     oupton@google.com, pbonzini@redhat.com, drjones@redhat.com,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The "pci_bar_*" functions use 64-bit masks, but the results are assigned
to 32-bit variables. Use 32-bit masks, since we're interested only in
the least significant 4-bits.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 lib/linux/pci_regs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/linux/pci_regs.h b/lib/linux/pci_regs.h
index 1becea8..3bc2b92 100644
--- a/lib/linux/pci_regs.h
+++ b/lib/linux/pci_regs.h
@@ -96,8 +96,8 @@
 #define  PCI_BASE_ADDRESS_MEM_TYPE_1M	0x02	/* Below 1M [obsolete] */
 #define  PCI_BASE_ADDRESS_MEM_TYPE_64	0x04	/* 64 bit address */
 #define  PCI_BASE_ADDRESS_MEM_PREFETCH	0x08	/* prefetchable? */
-#define  PCI_BASE_ADDRESS_MEM_MASK	(~0x0fUL)
-#define  PCI_BASE_ADDRESS_IO_MASK	(~0x03UL)
+#define  PCI_BASE_ADDRESS_MEM_MASK	(~0x0fU)
+#define  PCI_BASE_ADDRESS_IO_MASK	(~0x03U)
 /* bit 1 is reserved if address_space = 1 */
 
 /* Header type 0 (normal devices) */
-- 
2.25.0.265.gbab2e86ba0-goog

