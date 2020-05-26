Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5105C1ACC5F
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 18:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633078AbgDPP7T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 11:59:19 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:36678 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2896590AbgDPP7J (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Apr 2020 11:59:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587052747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NILe1+M954ythiYZr78tAgB+rwYmZAWGI0SxXGC7+zU=;
        b=hI/gKD13+e9aColeHbuN+YIDrKo3gqodSJLC7SCsMqhpqPHilrtR4GiCrmbkDLu0KzuwQS
        umoAu0/vK56i0OZhCNPjHMWwtnFMIy4nNluvDBSxUtrL/383YZsXTLw/0gDJUhOwchbDem
        5sd0hA/F9WGONg7QvVZmKUkxEaWRqYo=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-gX9jz6bYPcmIrb7U7qG1Ng-1; Thu, 16 Apr 2020 11:59:06 -0400
X-MC-Unique: gX9jz6bYPcmIrb7U7qG1Ng-1
Received: by mail-qt1-f200.google.com with SMTP id y31so7657662qta.16
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 08:59:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NILe1+M954ythiYZr78tAgB+rwYmZAWGI0SxXGC7+zU=;
        b=O6yhNdr1HL6Ad82wstn6/h/sNAKKCm3hTSm64yenUq1yVx4BqVd63WtsVooujrtvsB
         pu95KtipGS++7Q/4c+2xzvT8ZqH3RgUFHwLG/HNk0qs8EUYZUgNUQ7yJ8tKXgenO8TZ6
         P96Iy4qFneYBM5ioT+kLDa3W07CaKjCodPoIKxeKJgoAYFX45mPJ+UO7dxy+W7Wd1Fuy
         Bi0BqasMxzLw8kLKuKoF7FpfT/LbbcDhNzK1ZGfTrKY4LIzHsoLy9gWlMkYe/YEp/BKW
         Cxn5QbFtExj1oUuj/dpP4FyaO9W6eEo2xV5rpPuqxfEJyzIpw6xYwK42Hvu1P6Lq0hRN
         bmVA==
X-Gm-Message-State: AGi0PuYLng91IzotHll2+oiA5pCIya1/OUB0r+dOHMyuwhkcJjEUfB2E
        SOVDOrs+QWylpc98Uve/b2fXQ+E3ZMJSBfLzABmVYf5+PN3vCVrWiFc0IlgNSyjfwmEo7jr5RWL
        SEP2Ir1SvlJqG
X-Received: by 2002:a37:9544:: with SMTP id x65mr29717672qkd.48.1587052745489;
        Thu, 16 Apr 2020 08:59:05 -0700 (PDT)
X-Google-Smtp-Source: APiQypJJ5SMoPDB1NgVBB/ZGS0WTscaGWTPbULSlx+L7FEDpFfiyYIzZe1vfM7SfBLlF0N9gw8P3gw==
X-Received: by 2002:a37:9544:: with SMTP id x65mr29717649qkd.48.1587052745214;
        Thu, 16 Apr 2020 08:59:05 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id v27sm6636870qtb.35.2020.04.16.08.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 08:59:04 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, peterx@redhat.com
Subject: [PATCH] KVM: Remove async parameter for hva_to_pfn_remapped()
Date:   Thu, 16 Apr 2020 11:59:03 -0400
Message-Id: <20200416155903.267414-1-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We always do synchronous fault in for those pages.

Signed-off-by: Peter Xu <peterx@redhat.com>
---

Or, does it make sense to allow async pf for PFNMAP|IO too?  I just
didn't figure out why not...
---
 virt/kvm/kvm_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 74bdb7bf3295..2f1f2f56e93d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1807,7 +1807,7 @@ static bool vma_is_valid(struct vm_area_struct *vma, bool write_fault)
 }
 
 static int hva_to_pfn_remapped(struct vm_area_struct *vma,
-			       unsigned long addr, bool *async,
+			       unsigned long addr,
 			       bool write_fault, bool *writable,
 			       kvm_pfn_t *p_pfn)
 {
@@ -1902,7 +1902,7 @@ static kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 	if (vma == NULL)
 		pfn = KVM_PFN_ERR_FAULT;
 	else if (vma->vm_flags & (VM_IO | VM_PFNMAP)) {
-		r = hva_to_pfn_remapped(vma, addr, async, write_fault, writable, &pfn);
+		r = hva_to_pfn_remapped(vma, addr, write_fault, writable, &pfn);
 		if (r == -EAGAIN)
 			goto retry;
 		if (r < 0)
-- 
2.24.1

