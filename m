Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5A216FB2E
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 10:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbgBZJpN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 04:45:13 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:46955 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727980AbgBZJpM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 04:45:12 -0500
Received: by mail-pg1-f202.google.com with SMTP id s18so475598pgd.13
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 01:45:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Ah9fj7JtAe0j6A8x1RiJKFZEzov/GFH80/Ibe2QZOM8=;
        b=V8+V+7+By0hLRHH/bHg0KAMGdXJ+Ezd0QJVssFoLsh6Q1toFLr5hx9B65LXrTBShaZ
         81n9d7Y7u9QBZARqhMH1t9Bmkk+ugAsqmOEpN9ilochbl86siEOIYQ7mbl8sl/LO5Wh5
         elW+byh3EKKLC2fbSxyRfe0+ELJocchoRqplSn373R2Fxktkz1mkvjO4YnKz53PmFi4u
         BsPVtiBjZ51zsGErUk0b5pq1cMZEBd3fga4JVpWacNMTabysaDuSg4gXhxv+dsSVfMgh
         XvrtNnlf1iVkrs+fHSdg8fRtw9r86f6A03yUHa8Hq0Di630mgdADfPbaEtKYFW0jUc9c
         u1vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Ah9fj7JtAe0j6A8x1RiJKFZEzov/GFH80/Ibe2QZOM8=;
        b=TlhT7XLU0wtLCdBRR5B5LyuVX7ae+fBZ+ippE87y23/1hL0uuH7jARMHJ6oJDK6b0X
         kmqpkNqRVsKij6hUeCQw7GC5Qt/KGEpBAkfFvwACN2S8HcC7A67wIdajcFCtQip6Ok2l
         5EtCWB2gV8MByNkl2KyBu+F9c5HLWrm4mgFxdRl6qhABDzzyP0CRTycbNgltnDWk7SUh
         n4CPxdQYRDMgcB3ylzV8shyz8sAs/J7GXf/6Nn9ssKo8lHGxHsc2EMG08Ak46u5AVKAK
         2/YR++zXwQSnIQ6nRUdoDgzfXfKb5PZbeV2HrlIIgzcjUpUdv/jQfuye8Q7nP5z08ZuC
         1cVg==
X-Gm-Message-State: APjAAAWge4P/WQmH4HZDd36oZU9ERESdNT2rWbjuIRNCWKsOmNRkETOv
        YSY4UFS5lnvpykLEKV19FqNKwa/8W287/43gtMrOQGqx2xyWJWZ4xNaQ/q55HnJ3hf6ymW8DsDB
        +5p3R9WPpdKUXSZ4FuAFqPqOQrZi6OmuFYtfgT/gsu4cNXPcGJiCRLg==
X-Google-Smtp-Source: APXvYqynEJLL9m+cNuLZqnGQJYt4i6yeEc0NARRTFxRrFZBJ2YtadnaPBSO3O4wF1a3FRmUnVbuonuY0PA==
X-Received: by 2002:a63:2ac5:: with SMTP id q188mr2933481pgq.151.1582710310899;
 Wed, 26 Feb 2020 01:45:10 -0800 (PST)
Date:   Wed, 26 Feb 2020 01:44:32 -0800
In-Reply-To: <20200226094433.210968-1-morbo@google.com>
Message-Id: <20200226094433.210968-14-morbo@google.com>
Mime-Version: 1.0
References: <20200226074427.169684-1-morbo@google.com> <20200226094433.210968-1-morbo@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [kvm-unit-tests PATCH v2 7/7] pci: cast masks to uint32_t for
 unsigned long values
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
to 32-bit variables. Cast mask usages to 32-bit, since we're interested
only in the least significant 4-bits.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 lib/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/pci.c b/lib/pci.c
index daa33e1..1b85411 100644
--- a/lib/pci.c
+++ b/lib/pci.c
@@ -107,7 +107,8 @@ pcidevaddr_t pci_find_dev(uint16_t vendor_id, uint16_t device_id)
 uint32_t pci_bar_mask(uint32_t bar)
 {
 	return (bar & PCI_BASE_ADDRESS_SPACE_IO) ?
-		PCI_BASE_ADDRESS_IO_MASK : PCI_BASE_ADDRESS_MEM_MASK;
+		(uint32_t)PCI_BASE_ADDRESS_IO_MASK :
+		(uint32_t)PCI_BASE_ADDRESS_MEM_MASK;
 }
 
 uint32_t pci_bar_get(struct pci_dev *dev, int bar_num)
-- 
2.25.0.265.gbab2e86ba0-goog

