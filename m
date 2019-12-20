Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFE791283B5
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 22:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727615AbfLTVQr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 16:16:47 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42992 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727607AbfLTVQq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Dec 2019 16:16:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576876605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5JYh7n3fhb27PXs/bYUs6lzlcg1ya8dgcofIlxRo1Jg=;
        b=U23Lnzhb2Qiie/Aj/7itv+XgvzIHmNzrfDRMQI4jztSx21i6C8OVCUCtEcWKJJuOuotQhX
        CN9Fa6Tpmw0L26SsMM1V3R18J8lQZia7LGtXvn+dNYKiHXkob5a4b9x34gSyMQ0kQbPLlq
        Dy/Asi/rYcadWEJcKJFzVmyH+pFYlx4=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-DSImLdaePHyRrNOSBJhLIQ-1; Fri, 20 Dec 2019 16:16:44 -0500
X-MC-Unique: DSImLdaePHyRrNOSBJhLIQ-1
Received: by mail-qv1-f70.google.com with SMTP id x22so5177558qvc.18
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 13:16:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5JYh7n3fhb27PXs/bYUs6lzlcg1ya8dgcofIlxRo1Jg=;
        b=CWsSeRCa6QItvv5VWoddAFHCwWZ+Gcz58d+76cJu5pq1qj2r/1nlNp/ZIy71v4Scgg
         w3bk0BVSpph8VbZ5RtWnrKzJz7Fb98/J9SE4HwAYGtymttfpFurbW2k4MPYDwcd9Iwrt
         tJWizRud+J12EfvPfYNLXwRjaDPPeEeaWVVgtINDBoXId3DwHD7+gAQBFdfBDbrZiZmj
         K9sFCtf6UVXWUsojIl2YTczNoGwrhWhAVCnc8yQAC5cNbbJfPnLTP64TvSfMtwy1GRky
         B2EZGHaZv1rg+xFr00a4N6sQ9mmdDIwnrab3hyiFeqfft6JR6Ij4R6YfAx90B8yXOVk6
         xBvQ==
X-Gm-Message-State: APjAAAWcEux8K6ifY0VYD3GLY259pbluIk3AnqvN2EXJKpmNMkbbQA/G
        yp1P4VuZZKsut4s9D2swgtLzFDmRMAXa9oSlgx+pjM8775FaZEL9M/gAu2eth8AmfOHs8Bpqkdh
        xTdwWFHXaPcvc
X-Received: by 2002:ae9:c112:: with SMTP id z18mr15163107qki.145.1576876603737;
        Fri, 20 Dec 2019 13:16:43 -0800 (PST)
X-Google-Smtp-Source: APXvYqwAmO40nZC7dbPfJX2XhfCkZXPmKEZhPwJA42MOu86eDa+UfyJLxLgNEvBl6nozan2fcmgbGQ==
X-Received: by 2002:ae9:c112:: with SMTP id z18mr15163085qki.145.1576876603519;
        Fri, 20 Dec 2019 13:16:43 -0800 (PST)
Received: from xz-x1.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id d25sm3385231qtq.11.2019.12.20.13.16.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 13:16:42 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, peterx@redhat.com,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>
Subject: [PATCH v2 04/17] KVM: Cache as_id in kvm_memory_slot
Date:   Fri, 20 Dec 2019 16:16:21 -0500
Message-Id: <20191220211634.51231-5-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191220211634.51231-1-peterx@redhat.com>
References: <20191220211634.51231-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's cache the address space ID just like the slot ID.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 include/linux/kvm_host.h | 1 +
 virt/kvm/kvm_main.c      | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4e34cf97ca90..24854c9e3717 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -348,6 +348,7 @@ struct kvm_memory_slot {
 	unsigned long userspace_addr;
 	u32 flags;
 	short id;
+	u8 as_id;
 };
 
 static inline unsigned long kvm_dirty_bitmap_bytes(struct kvm_memory_slot *memslot)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b1047173d78e..cea4b8dd4ac9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1027,6 +1027,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 
 	new = old = *slot;
 
+	BUILD_BUG_ON(U8_MAX < KVM_ADDRESS_SPACE_NUM);
+	new.as_id = as_id;
 	new.id = id;
 	new.base_gfn = base_gfn;
 	new.npages = npages;
-- 
2.24.1

