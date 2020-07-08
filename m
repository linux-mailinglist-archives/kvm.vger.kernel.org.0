Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 171722190D0
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 21:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgGHTfY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 15:35:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29212 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726788AbgGHTeZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 15:34:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594236863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hN7D86/UKZ9ErRoXs9fnrDlDCnq5Xvm3yeUIpEDme08=;
        b=d3tG82PYhJ0bDf+ex8D5kPfvYomp0TsTQM2gfbXNU9mDFHcH9VcLA0xucFLy65JVksOGkK
        7jJi8hkzRdLhsPzD31Hyai/m/503HSIzqTQxVRHsfMdIzkXs7jpSOrbvkNYfSXOcruZtIw
        VnoR/IdvHoqhndRkS6bNDTiy7Neg0wo=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-Yl_xmVRwM4O4ApWcHinlKA-1; Wed, 08 Jul 2020 15:34:14 -0400
X-MC-Unique: Yl_xmVRwM4O4ApWcHinlKA-1
Received: by mail-qt1-f198.google.com with SMTP id u93so33861893qtd.8
        for <kvm@vger.kernel.org>; Wed, 08 Jul 2020 12:34:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hN7D86/UKZ9ErRoXs9fnrDlDCnq5Xvm3yeUIpEDme08=;
        b=BD5seqDcw+Mm+Zv4Kpil3W7ASmzTdvlwUYyPH6K9yiKFKRRBhJHXhWiRghPXAxTInE
         kfOIn87kYkqBWQ2BoTCJFHjHgw3xH6xDI1SZj/5elKq7XikOiJH1F3WFfdhY5PnfbKbR
         WtORRYr5H1lwlYBQ7er+1o0V+rHJAzeqg1NuU3BLPtR4V/tb/HygCFnxa9Q3i1fkT23C
         rX7Y8zu86AqPr0p4dsRYCEXc9fI9XL0st8vLazIWB5Nfwtid7z34peJ1y9RJlZ9YYjfu
         THTGMCPrSmQJ/n411sirQocJCVfNSyagBJlbrDkuyXZ0HmQ7A3nda+Sq2F3IJkMnbkTp
         r6lQ==
X-Gm-Message-State: AOAM532LSI6qzr+I3tm1xVI3ar0+CH62elmQ4bLEi2BMP3CnIKP8KrXe
        /YzeE5truZ0k/6jS3bAWkToty44xipc+ZW18NqtpeuLngGQ3mLea4/awNXxqziKo2PXRKGQ6LiH
        7G0jbinJ7KW4W
X-Received: by 2002:a37:b701:: with SMTP id h1mr56064803qkf.335.1594236853828;
        Wed, 08 Jul 2020 12:34:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxd0GzOBMQ1NmDsTj1gJlUvriObJFrFgIgsPO2Y2kMXMZ0+3c7pEyiE7fyyqU0Z8irQDaMDNQ==
X-Received: by 2002:a37:b701:: with SMTP id h1mr56064782qkf.335.1594236853604;
        Wed, 08 Jul 2020 12:34:13 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c8:6f::1f4f])
        by smtp.gmail.com with ESMTPSA id f18sm664884qtc.28.2020.07.08.12.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 12:34:12 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v11 01/13] KVM: Cache as_id in kvm_memory_slot
Date:   Wed,  8 Jul 2020 15:33:56 -0400
Message-Id: <20200708193408.242909-2-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200708193408.242909-1-peterx@redhat.com>
References: <20200708193408.242909-1-peterx@redhat.com>
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
 virt/kvm/kvm_main.c      | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9edc6fc71a89..346ee5905359 100644
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
index a852af5c3214..62b7d537e179 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1191,6 +1191,11 @@ static int kvm_delete_memslot(struct kvm *kvm,
 
 	memset(&new, 0, sizeof(new));
 	new.id = old->id;
+	/*
+	 * This is only for debugging purpose; it should never be referenced
+	 * for a removed memslot.
+	 */
+	new.as_id = as_id;
 
 	r = kvm_set_memslot(kvm, mem, old, &new, as_id, KVM_MR_DELETE);
 	if (r)
@@ -1257,6 +1262,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (!mem->memory_size)
 		return kvm_delete_memslot(kvm, mem, &old, as_id);
 
+	new.as_id = as_id;
 	new.id = id;
 	new.base_gfn = mem->guest_phys_addr >> PAGE_SHIFT;
 	new.npages = mem->memory_size >> PAGE_SHIFT;
-- 
2.26.2

