Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7590199E7E
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 21:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbgCaTAY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 15:00:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58183 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728301AbgCaTAW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 15:00:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585681222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SaPQXaz9TKeQDPqLSUMIea2gfLqrEOy+hFjS5pVMWw8=;
        b=drY80bYwEEaUZTCDRYn/JWhT9jhHjf3Qc/+yB9DZNyXymVIH8XhBg+g2ZrxvlIaaHGd8kP
        a9Ck0Ws9PIAFyd64QtEVVTBtqyHUAFnAkC/cnvVCbQgoy6ArhAek/Aca0zNsuO4wJsyQQg
        s7RfiMj2wiLTHCvGZY+i3YRfc52OEEg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-CdWQ95bjNVaGvkDeSs1nmA-1; Tue, 31 Mar 2020 15:00:16 -0400
X-MC-Unique: CdWQ95bjNVaGvkDeSs1nmA-1
Received: by mail-wm1-f71.google.com with SMTP id t22so1058707wmt.4
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 12:00:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SaPQXaz9TKeQDPqLSUMIea2gfLqrEOy+hFjS5pVMWw8=;
        b=QhMInD2FgmakSCij/ydI3OUgj6xX5lSy7j998E1JuDRplzU2oCcahU/ypLaOWHLvTe
         kmzttUhJm5tn/tkFmvRKFq27ziLl5lmk0svvDXXFZblI8Du1fKwCaU5Z8o0hbVEu6S/l
         cx9rI6R0haKUDa62B+0GtDE/99sOvQMpekP9ARTu1WmWLFGXtK+oB2iff7Auf3Ndj7rK
         8v31+BCDUc8MJ4T7nIYqmwQgltriYZZBfvi9Mb04SvNF4XXji2ObLvawRGnkBDdvKoLJ
         E+NO26n9mMunQW1wo5M7ezHi0opNCrXlQjKyxbF5kZn4JhozupgcGQkOZR7NE6zqKTfs
         DBZw==
X-Gm-Message-State: ANhLgQ2V2C2uv//MnQg1SOuQeWMm3Xg+/vo8+ULsVnmvmIUcqPaBsE2c
        SFXGOqoEGLeoJo4oMjXRnbZCVE9kD8brs9S8L2+gxKhI63suGEPHmfvGuqEW5a/9m9Xc502VulY
        uKY68WA0KmE5W
X-Received: by 2002:a05:6000:1142:: with SMTP id d2mr14417447wrx.320.1585681215825;
        Tue, 31 Mar 2020 12:00:15 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vs0Lmm2yi8/lUh7kTfD26unrSU3jTgx7/Q3MKzSFGqyTBAic1CzUicbDhtyuT9z9CxyagfGGg==
X-Received: by 2002:a05:6000:1142:: with SMTP id d2mr14417424wrx.320.1585681215622;
        Tue, 31 Mar 2020 12:00:15 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id a8sm4817655wmb.39.2020.03.31.12.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 12:00:15 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Kevin Tian <kevin.tian@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>, peterx@redhat.com
Subject: [PATCH v8 02/14] KVM: Cache as_id in kvm_memory_slot
Date:   Tue, 31 Mar 2020 14:59:48 -0400
Message-Id: <20200331190000.659614-3-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200331190000.659614-1-peterx@redhat.com>
References: <20200331190000.659614-1-peterx@redhat.com>
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
index f6a1905da9bf..515570116b60 100644
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
index f744bc603c53..c04612726e85 100644
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
2.24.1

