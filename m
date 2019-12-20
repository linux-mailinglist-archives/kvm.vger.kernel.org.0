Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE233128386
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 22:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbfLTVCc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 16:02:32 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:21929 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727567AbfLTVB7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Dec 2019 16:01:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576875718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5JYh7n3fhb27PXs/bYUs6lzlcg1ya8dgcofIlxRo1Jg=;
        b=R+EMY2ksp6+CtCRlHggj+R/UOMNX3XUsSO1qh/OK6wxB4HF2X5XTqL+TxuLN5tOhZXwyaN
        sZywXxbB6jxBJedQCnkWHWTTS6QS9Y5HU9/4XeQouva7if60UVOwt42VfGwCyUQlK3bRH0
        M36Abg+mwwL5tAwUe0GJO/h21n2BkLw=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-zQr5PqAqNN6EYAMkAUvBaw-1; Fri, 20 Dec 2019 16:01:56 -0500
X-MC-Unique: zQr5PqAqNN6EYAMkAUvBaw-1
Received: by mail-qt1-f197.google.com with SMTP id x8so6789202qtq.14
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 13:01:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5JYh7n3fhb27PXs/bYUs6lzlcg1ya8dgcofIlxRo1Jg=;
        b=qf1mKDs5prWqi8Ee8zRMJ/DXZACCGqjYyavau9aT/SDHZQul49zsOvFZGWPbdirHuu
         swL4HHVhQbRn81N0GCCkkVg+dibGZhXO0wwnnjxCe6HfBlWea3YkwexGxHYrgOkL9EE9
         BBYpfTY4XqhQ/oeSkSE1/xjYtxSfM5+lU9uwvP/cL4rCr1rd/nttp2rtyaJLYAEdFHcY
         GaGpH/UGEswzDLM9Oa47tLowJagcWETIXr/DPNWigzoAk7MahdtAz0i9AqZ13tj2gyre
         dI73Dl6ACV4xk71dnmA9M5Zr6DMn1lks5rRBaf1+iZ1DlUzr6kqlgfvZDhTsSi89g5hG
         chWA==
X-Gm-Message-State: APjAAAVo5rjQqqEpkwhXmI20IC2eJ4rvOFvvWuU/sfl0F42D7JhAB8B1
        OvUh7MOXHuzWc9P51Fm/1GwP/3b+UP7H3hGFVTn74t52hEdlncBlpOeRwdPsqCrrT+bc9NQx+08
        Yrkw7DOC5+wyG
X-Received: by 2002:a0c:e790:: with SMTP id x16mr13985279qvn.18.1576875715450;
        Fri, 20 Dec 2019 13:01:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqzxjMbl8dopUvmXOVnU59sQzlQMC13n1sxeg16FHaFklsjTG3gNoJMkd4GKQCJVP7iplYp8CA==
X-Received: by 2002:a0c:e790:: with SMTP id x16mr13985250qvn.18.1576875715239;
        Fri, 20 Dec 2019 13:01:55 -0800 (PST)
Received: from xz-x1.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id q25sm3243836qkq.88.2019.12.20.13.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 13:01:54 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>, peterx@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
Subject: [PATCH v2 04/17] KVM: Cache as_id in kvm_memory_slot
Date:   Fri, 20 Dec 2019 16:01:34 -0500
Message-Id: <20191220210147.49617-5-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191220210147.49617-1-peterx@redhat.com>
References: <20191220210147.49617-1-peterx@redhat.com>
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

