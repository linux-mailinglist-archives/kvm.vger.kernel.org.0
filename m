Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9BF21EA352
	for <lists+kvm@lfdr.de>; Mon,  1 Jun 2020 14:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728207AbgFAMBg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 08:01:36 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:21131 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725886AbgFAMAM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Jun 2020 08:00:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591012811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V2vaOYux+g8r9FQrQ+JLM9qTkiUW1rAWuUxZinM0SyI=;
        b=NTH/NVJuQ57IGSiGQnoEW3MsZWXqK7wa4i1Tt/Nu6a9p8EgudpBHKJa/21d7/9Kh2KmvUS
        AspnYqrt6/biuTUmH4i6wvoquFniya+5bJxyhvJPicqFT/uraKw8EtTWfrTOyMFhA9a1q1
        yuwmLk4h5cz/4JZRNidx1yWQDEejeZE=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-AIvXbhIWOuOCgDu4pKQ84w-1; Mon, 01 Jun 2020 08:00:06 -0400
X-MC-Unique: AIvXbhIWOuOCgDu4pKQ84w-1
Received: by mail-qv1-f72.google.com with SMTP id t20so2408184qvy.16
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 05:00:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V2vaOYux+g8r9FQrQ+JLM9qTkiUW1rAWuUxZinM0SyI=;
        b=IouFKkLZzNh01YaO4SNyEvRZZ4IX4jjILJ/s9eQSDKeFlZPdsKclzVyFwJBY2jXvxg
         yWR9tkM+GO2K0eOL34VwOqDbC89fyhLwTABp+SyhsqN/wHd73dJ2hjEJB8k7mB9QgoDL
         Lejk1282tZgn3Ekuws09ZU18q42pHLDYFmINd64g1+a6oZGyE8yBBKfXn1dwTpPg3/x2
         QMoS8KslVcL3+kYKEkKkuMK2J56TparXRLyk0lNJ9Aze7VtHal3kRYdfRbhURR8GDrbG
         EHX7bKxSz1Oj1FL+3kJbb+3/+OhYiE6z+Xmi2ULTCiqVTEPM/TX1eSwzIMH2XVs4GhnK
         kh7w==
X-Gm-Message-State: AOAM532X0XLx0bICa1MJhdD3ELtNWeU66XzcawumCXNreXjjtdFZP70T
        Setl0EhVjAkqyzLElLvOTqHDalCDxSBAKp7v7FGedsbknobQIp2/HZRzVZT+JhkbPic89rOH1Bu
        Hxr9Mm8lf10Gw
X-Received: by 2002:ac8:38d8:: with SMTP id g24mr21955554qtc.360.1591012805499;
        Mon, 01 Jun 2020 05:00:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxSyAI13lKJj29QiphxO0kMgJRdgJ352fnuCkEvomwDAkqADNTYqonnUCGWQwYiQSsRYeIUDA==
X-Received: by 2002:ac8:38d8:: with SMTP id g24mr21955513qtc.360.1591012805113;
        Mon, 01 Jun 2020 05:00:05 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id l9sm14474185qki.90.2020.06.01.05.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 05:00:04 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v10 02/14] KVM: Cache as_id in kvm_memory_slot
Date:   Mon,  1 Jun 2020 07:59:45 -0400
Message-Id: <20200601115957.1581250-3-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601115957.1581250-1-peterx@redhat.com>
References: <20200601115957.1581250-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cache the address space ID just like the slot ID.  It will be used in
order to fill in the dirty ring entries.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 include/linux/kvm_host.h | 1 +
 virt/kvm/kvm_main.c      | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 01276e3d01b9..5e7bbaf7a36b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -346,6 +346,7 @@ struct kvm_memory_slot {
 	unsigned long userspace_addr;
 	u32 flags;
 	short id;
+	u16 as_id;
 };
 
 static inline unsigned long kvm_dirty_bitmap_bytes(struct kvm_memory_slot *memslot)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 74bdb7bf3295..ebdd98a30e82 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1243,6 +1243,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (!mem->memory_size)
 		return kvm_delete_memslot(kvm, mem, &old, as_id);
 
+	new.as_id = as_id;
 	new.id = id;
 	new.base_gfn = mem->guest_phys_addr >> PAGE_SHIFT;
 	new.npages = mem->memory_size >> PAGE_SHIFT;
-- 
2.26.2

