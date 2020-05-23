Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 014CA1DFB7C
	for <lists+kvm@lfdr.de>; Sun, 24 May 2020 00:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388167AbgEWW5R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 May 2020 18:57:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22692 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388138AbgEWW5P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 May 2020 18:57:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590274633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V2vaOYux+g8r9FQrQ+JLM9qTkiUW1rAWuUxZinM0SyI=;
        b=Gd7L9SotTNpqXhL5wr9Gu1rMbCoiHuAH+mHDB6LgCnY2urW82wA8/FLTNcs5ULrlLHg9ki
        KNnNykraOJt71APvgQ40Vha1/T5lfN/5a/HUqOQJ870PaygzfVDmmG+aMpuY5pXzYKyWss
        LMcUTYmiSLHLaorXtE/p4Xo3wZapcgE=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-M01pGE7cMaW26EixwLDOEg-1; Sat, 23 May 2020 18:57:08 -0400
X-MC-Unique: M01pGE7cMaW26EixwLDOEg-1
Received: by mail-qk1-f198.google.com with SMTP id l4so14902358qke.2
        for <kvm@vger.kernel.org>; Sat, 23 May 2020 15:57:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V2vaOYux+g8r9FQrQ+JLM9qTkiUW1rAWuUxZinM0SyI=;
        b=cL/UdAgD0WYPaIeGrZJYxG0RQ8wd3iLr5sCTSMydBW1tre1SN0mRygkqqLrPS+hI79
         1zVLtS3j+3tZ06cQtWUokLKt9InR6P0837Ttjcx8vsn0fQN/zAR1HXiQjvZjZkULDkgq
         8onWkEPOwU8pEeCLrgRA9LVN0voNJTYXqNI1Th82qrOS632sdvNLLynVLnlw7yPHnrvb
         4+lU/88kMkGWWqUkGWH5ARO+7ZmcIO5/HlCIAC8+pC/Df3E/O8nXfyPOw0ZmTghVwlsc
         HSEInEV4HGkMtK44+PRGOyU/pLNsAMlBv4ZrhLH+FXCTkx84I1EMvwPnU5m/pp5LwICn
         MxuA==
X-Gm-Message-State: AOAM533gHhe04gia1TgALXwOJsDEqnETrH0FR6HCetM6By1/uNmzEBwr
        uHIGKnxHlKouPh5SFNuFf7zB14wcAN93a53wBW166rk/UbELKueAvV40VuS50XSapkcNZdKyyDb
        beWvZdzKPD6r7
X-Received: by 2002:aed:2fc6:: with SMTP id m64mr21701810qtd.201.1590274627523;
        Sat, 23 May 2020 15:57:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxyHfUpdzkaAG+qrmzGo3ardtWcNSWeeBDEJMAsakoieGi64jilBwNJLDSnB26H9LpKoSLinA==
X-Received: by 2002:aed:2fc6:: with SMTP id m64mr21701790qtd.201.1590274627283;
        Sat, 23 May 2020 15:57:07 -0700 (PDT)
Received: from xz-x1.hitronhub.home (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id w14sm11630979qtt.82.2020.05.23.15.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 15:57:06 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v9 02/14] KVM: Cache as_id in kvm_memory_slot
Date:   Sat, 23 May 2020 18:56:47 -0400
Message-Id: <20200523225659.1027044-3-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523225659.1027044-1-peterx@redhat.com>
References: <20200523225659.1027044-1-peterx@redhat.com>
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

