Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56DB718A09D
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 17:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbgCRQiI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 12:38:08 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:52125 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727232AbgCRQiA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Mar 2020 12:38:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584549479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=21sofClSkTFdAbqYOhAifzJwk3zPehrCVdo8Kk9QLLk=;
        b=hR7HVNrt9/ho26wznye2DMxaszA+rzlmB332aM56kMLWpWXFnhRbZ0ab14h7iCN3ZCVq3s
        usZX+ipNR920n5FomQEhetrmgzRkYBj+h32ua9s+ImZ1b7b0pWUvia+byChLbCB4mn+ChP
        W5wIGzo1C81JW0e4gfzdkTKhrBKE8jE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-yuzmeBdWMN-gvi8L7IS8Lg-1; Wed, 18 Mar 2020 12:37:42 -0400
X-MC-Unique: yuzmeBdWMN-gvi8L7IS8Lg-1
Received: by mail-wm1-f71.google.com with SMTP id f185so1279620wmf.8
        for <kvm@vger.kernel.org>; Wed, 18 Mar 2020 09:37:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=21sofClSkTFdAbqYOhAifzJwk3zPehrCVdo8Kk9QLLk=;
        b=N85h6PzZXSLocA008cI+2grpYt+SlUZGUBR5phSeeb/ukTmLdPHUFcuWMTiVpcm2HJ
         dc21Krh8PNrYFrFKvD04bYlvAO+/j+5YIKnYcjphFkXlQa1FCpH4LN2uTGIcqNfjL/lY
         8rtfC0PFNXwa8Ua4kw/As7prLVa25yKZHQiVdDOP72DS3Aqq1lkRBGdSkHCWS4ZN0tYN
         UP0w4pj6NuFzqrWu4vs3idFE9MD85kbPzDEQD6ZJLqxtoPZLfeatx7kDXoKQXFOAj6wG
         Yd4StZPlEwR+qH/uoDw4roy0Syn17rEd0IsbGKa5IKy2whhUa6LD/4CivBVi4qZVhCIL
         unrQ==
X-Gm-Message-State: ANhLgQ0jtmf0jr79G9Z1vj9ifppkvcMnR4ODPUpZzcAlAWfJCnoE0iT6
        GoUKsyxci+Znu9vAqHP5BZ3cVMlHeaOXZZK7iLCWs0rIT1eh21GtjEVmtlr80tqpojjkmspkw7c
        Oo9grdgjf9NXs
X-Received: by 2002:a7b:c458:: with SMTP id l24mr5971064wmi.120.1584549460667;
        Wed, 18 Mar 2020 09:37:40 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vu6QMYREid4T3v+QT6mb4juZTk8sOTjJFcMXVrQf34I+KjMVmT6LOjD/v9zyyVBGzqkktKnHA==
X-Received: by 2002:a7b:c458:: with SMTP id l24mr5971041wmi.120.1584549460429;
        Wed, 18 Mar 2020 09:37:40 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id t1sm10316109wrq.36.2020.03.18.09.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 09:37:39 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>, peterx@redhat.com,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v7 02/14] KVM: Cache as_id in kvm_memory_slot
Date:   Wed, 18 Mar 2020 12:37:08 -0400
Message-Id: <20200318163720.93929-3-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200318163720.93929-1-peterx@redhat.com>
References: <20200318163720.93929-1-peterx@redhat.com>
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
index 35bc52e187a2..2def86edcd65 100644
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
index 28eae681859f..e24e7111a308 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1240,6 +1240,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (!mem->memory_size)
 		return kvm_delete_memslot(kvm, mem, &old, as_id);
 
+	new.as_id = as_id;
 	new.id = id;
 	new.base_gfn = mem->guest_phys_addr >> PAGE_SHIFT;
 	new.npages = mem->memory_size >> PAGE_SHIFT;
-- 
2.24.1

