Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 419E53B356C
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 20:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbhFXSQb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 14:16:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54843 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232618AbhFXSQ2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 14:16:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624558448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nhjhdzRJGuZzb8Uq4F9J7OQePoxIE2i+1r2VEiCpXU8=;
        b=DYT1DXMznO/hHwYtbY5UN5sa+Qoc/SstcTqB5NiPHqCWDxnGq2Zi1ouV/xJZqBvDwEBiol
        Wth08y5mtwpSESirbhfOqmcyemrjzUCsdlXT/4sR5JshdxsE/sDQ6BGEnj4hxw57W+VGjJ
        JxBPJocbNWuCl4+4zY5zoS07PYFFv9c=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-vAZyZzScOPSBKuCua49sQg-1; Thu, 24 Jun 2021 14:14:07 -0400
X-MC-Unique: vAZyZzScOPSBKuCua49sQg-1
Received: by mail-qv1-f72.google.com with SMTP id es19-20020a0562141933b029023930e98a57so7875995qvb.18
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 11:14:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nhjhdzRJGuZzb8Uq4F9J7OQePoxIE2i+1r2VEiCpXU8=;
        b=UllBbehs7pxB8xQ+XiSl0SBAHS7FMaVuOpzvrp5NK8l9OJ9C6KM28CHEBwZ26v2ulR
         XwbjrueZPe0mAhgv/8ekCujZzjc1NrN2cbgnP02LbiaAA59lZpIQSs07pJcAyPDmLWsA
         FOafRH/z7dIFkKE8JYgAsAkIKfEQdCzGmBRkCjf8DqMSj1OQGiXL72tWWMmIX8uj93Oo
         36gXkV/w7CLtx4vqHYsWm85vUvJfNfalcXU7nPH8gS1pLzV+4QUHguRNQO6uasBS+dBW
         v8wrBgW4J7M6FNRSSxTf3jWX02G5ydXdqgnW7DbW6FRHlNmdFfP+yeL+Lau57f8rtYbi
         2F4A==
X-Gm-Message-State: AOAM531XdgOGYnPzwK2uJvJgaooFWQ0mWkMOdzeWoPJDsO9qLyQDtXiz
        DH0EBnIXQjxCYc7nxCU380Hj1fo4DoVqxuL4KFVjWQbGECcb1FiCC7/SgOeGZLgOaGVsX6gIIBh
        3OqJbPU/cfYZfpiAuKJy3SaJsAQgDoGqREjkv35F4meX77UPI6Z0X+P8bJg3jFw==
X-Received: by 2002:a37:b947:: with SMTP id j68mr7058574qkf.486.1624558446728;
        Thu, 24 Jun 2021 11:14:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzyi77u9hQpo3cu5comp042O3ws2nw3qgLSs4sLThHjFTBtBf8S3k7Or4hGpuETo3oZS4Dx5w==
X-Received: by 2002:a37:b947:: with SMTP id j68mr7058543qkf.486.1624558446472;
        Thu, 24 Jun 2021 11:14:06 -0700 (PDT)
Received: from t490s.redhat.com (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id b7sm2529301qti.21.2021.06.24.11.14.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 11:14:05 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, peterx@redhat.com,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5/9] KVM: X86: Introduce kvm_mmu_slot_lpages() helpers
Date:   Thu, 24 Jun 2021 14:13:52 -0400
Message-Id: <20210624181356.10235-6-peterx@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210624181356.10235-1-peterx@redhat.com>
References: <20210624181356.10235-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce kvm_mmu_slot_lpages() to calculcate lpage_info and rmap array size.
The other __kvm_mmu_slot_lpages() can take an extra parameter of npages rather
than fetching from the memslot pointer.  Start to use the latter one in
kvm_alloc_memslot_metadata().

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/x86.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4aa3cc6ae5d4..d2acbea2f3b5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -269,6 +269,20 @@ static struct kmem_cache *x86_fpu_cache;
 
 static struct kmem_cache *x86_emulator_cache;
 
+static inline unsigned long
+__kvm_mmu_slot_lpages(struct kvm_memory_slot *slot, unsigned long npages,
+		      int level)
+{
+	return gfn_to_index(slot->base_gfn + npages - 1,
+			    slot->base_gfn, level) + 1;
+}
+
+static inline unsigned long
+kvm_mmu_slot_lpages(struct kvm_memory_slot *slot, int level)
+{
+	return __kvm_mmu_slot_lpages(slot, slot->npages, level);
+}
+
 /*
  * When called, it means the previous get/set msr reached an invalid msr.
  * Return true if we want to ignore/silent this failed msr access.
@@ -10933,8 +10947,7 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
 		int lpages;
 		int level = i + 1;
 
-		lpages = gfn_to_index(slot->base_gfn + npages - 1,
-				      slot->base_gfn, level) + 1;
+		lpages = __kvm_mmu_slot_lpages(slot, npages, level);
 
 		slot->arch.rmap[i] =
 			kvcalloc(lpages, sizeof(*slot->arch.rmap[i]),
-- 
2.31.1

