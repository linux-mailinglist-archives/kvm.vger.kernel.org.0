Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4375BD4E46
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2019 10:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbfJLI02 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Oct 2019 04:26:28 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:55520 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728886AbfJLI02 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Oct 2019 04:26:28 -0400
Received: by mail-pf1-f201.google.com with SMTP id u21so6420811pfm.22
        for <kvm@vger.kernel.org>; Sat, 12 Oct 2019 01:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=mE3OAeOE/eYuT5ARQUE6mDRHkwycMi2Fh29zXTPw2/A=;
        b=kbHL3GIfkJgldeU+DhHMBH2y8H7A2yBAorSwuDzUCWdBceeDijoKWTqJx0SUtmgXBG
         28PgdlKbGSc+PODN7x1v1GBxUqQ1x8HoVmi64/LNEf/eIKm44YURxqTeRodAVaj+xd4s
         +BAFAw47eI1eAv69Q9s4QJjxHk+ZGKLVtuBfwm9FLwUmPAgp6ImKLrWn4eN+2hOq3waX
         AoWZGSo3JiOCVkPF+uGM5T0OBTk61Q16pOOEVeslq+3dvQWykUbgw0JOMjEzdK+tcjz1
         EyxkqMlWvlshGEobgM9LU1kN+52noICVpQjc2as2Id1ybH24RiQfmRA1bHhZrDJOMzAl
         fa7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=mE3OAeOE/eYuT5ARQUE6mDRHkwycMi2Fh29zXTPw2/A=;
        b=rEsQmXXXgxF8WvuxEaTl5C9kBk1OwlY7eM/F24HYaoipauw1/nSLTGj1+2HI/O0s8E
         vIB2CcwK/S/Pa8ZEpVTYaNDMN3I+hPmmzF0XF5eujiZFtYAs8Jq7zTjSHW6WnqsvHL2k
         Fo5yr+7Xm1qCNGTLQUhP9hecjkXmBhCU/isgokaoALtFceUOV+eviuA09cvac+nUO9jP
         8bhLrZ/DgDjxJUv/jKkaG1oQrTxgcTMmvqq3IkY2/1K4kNy3scp3gFrENqkiETvLlj76
         oy4YWTOjl2R74Lf4d9J1pHap0htu0r6Fv1nWghKk2TWs2jGvw/lvCSs+GbQTOtmmsQyj
         r7HQ==
X-Gm-Message-State: APjAAAVubdWolNlbPJ0Md/+N9CAj2DYyGKE5sHzHy19GxAxpI+hfx7Bq
        wwrlk7IlsVnFZyprje3iDbxDUTJOaS4ZtXGtxx1D1scpA27S7xNepFcaQS39FZ8KfiKzVQwm9yO
        nK3ak2Ew0KfRGJniuCWH2+ODsr2cwzTdzEWy+D7xO4fgXKG5Y5nHKaQ==
X-Google-Smtp-Source: APXvYqzkv5IT+m8HeDRkDddUX/rYRW6cGmJw/DYW9p/YGkuLUwtd3wS6ODZp6QTbTyfqh1emcLZRxKHFag==
X-Received: by 2002:a65:685a:: with SMTP id q26mr3471031pgt.32.1570868787641;
 Sat, 12 Oct 2019 01:26:27 -0700 (PDT)
Date:   Sat, 12 Oct 2019 01:26:23 -0700
In-Reply-To: <81990077-23b0-b150-1373-2bb5734d4f23@arm.com>
Message-Id: <20191012082623.249497-1-morbo@google.com>
Mime-Version: 1.0
References: <81990077-23b0-b150-1373-2bb5734d4f23@arm.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [kvm-unit-tests PATCH 1/1] pci: use uint64_t for unsigned long values
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, alexandru.elisei@arm.com
Cc:     jmattson@google.com, Bill Wendling <morbo@google.com>
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
2.23.0.700.g56cf767bdb-goog

