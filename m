Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B78FD16838F
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 17:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgBUQdm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 11:33:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21268 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725995AbgBUQdm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 11:33:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582302821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+wtlMqiYMfAtECyCFeq4h5JvYyRA49l8lzkwzoiW88E=;
        b=Q+0GhxC0gqqoNYWP+gfMbm9lUQ6KMNT6I/qM3+Sm4pIwI8mRDlbHFFG1zWNyEDXieReNxc
        Yl/oRwnr2k56OPH+6kOl/SKaSxy1d+rY0seuCz6vA4nRp6OvCH8G5/14rMrtmv8L7gns3Q
        GtJ84A9oYjavIPyFyPJk8AimqX5ywPc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-J4iylRzPPHKjGG_XXxozeQ-1; Fri, 21 Feb 2020 11:33:39 -0500
X-MC-Unique: J4iylRzPPHKjGG_XXxozeQ-1
Received: by mail-wr1-f71.google.com with SMTP id t6so1260255wru.3
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 08:33:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+wtlMqiYMfAtECyCFeq4h5JvYyRA49l8lzkwzoiW88E=;
        b=T8fJ4WYn1R6a8nrzbBVWE1zRbNPgH4PsKdh7IOgormIpS3w3r8ZEsU+x9Z9DWn9Eud
         DUVENsuS4BSYU/ektjU8kF6yEwJmzGmmJcUSYTd/kysjxdYGOY86K1ypIT+tKyzw6Fi9
         WoVctmZwEFgy0d3H1Yh5YCEVrtyX2KLyT7lU0XZ4fxQyTg6TmN0mWIzogny76DlC7vDg
         2FqYZO6N87PQ9d2f/SPHWBrRfTbXlF6f2tqaK7vjh2443PRuhAFuiL1wUQ9KJ05aegWF
         UVa3i7KivEQgO68D7LZ9olw+/rCRSEsIoZtUHqOX+DlJoFPBZi2s+MSc7gK7YVhNa+wY
         teiQ==
X-Gm-Message-State: APjAAAXHuIe9qrgCkOYO4zc3z1QHrPT/6YKqYCNu47D1pucOuLpi2RtV
        S1QV9UJ2OAES1SmGMpgc93c2nA1Y7rEF3vk8srB7x/x8oc/A9iKn1pNcoBy7z5XCdP1Y7ln8pTt
        4Ka2b/cFGQ+uv
X-Received: by 2002:a5d:6411:: with SMTP id z17mr52257863wru.57.1582302818487;
        Fri, 21 Feb 2020 08:33:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqw/P0AiFwTiT7z/wiXEONKmFEX/+8KKpJaNr4hGDqfwDZfa9AgZLuHo195clbdhIrrAhDaBiQ==
X-Received: by 2002:a5d:6411:: with SMTP id z17mr52257842wru.57.1582302818224;
        Fri, 21 Feb 2020 08:33:38 -0800 (PST)
Received: from x1w.redhat.com (78.red-88-21-202.staticip.rima-tde.net. [88.21.202.78])
        by smtp.gmail.com with ESMTPSA id c15sm4522493wrt.1.2020.02.21.08.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 08:33:37 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH] accel/kvm: Check ioctl(KVM_SET_USER_MEMORY_REGION) return value
Date:   Fri, 21 Feb 2020 17:33:36 +0100
Message-Id: <20200221163336.2362-1-philmd@redhat.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_vm_ioctl() can fail, check its return value, and log an error
when it failed. This fixes Coverity CID 1412229:

  Unchecked return value (CHECKED_RETURN)

  check_return: Calling kvm_vm_ioctl without checking return value

Reported-by: Coverity (CID 1412229)
Fixes: 235e8982ad3 ("support using KVM_MEM_READONLY flag for regions")
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 accel/kvm/kvm-all.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index c111312dfd..6df3a4d030 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -308,13 +308,23 @@ static int kvm_set_user_memory_region(KVMMemoryListener *kml, KVMSlot *slot, boo
         /* Set the slot size to 0 before setting the slot to the desired
          * value. This is needed based on KVM commit 75d61fbc. */
         mem.memory_size = 0;
-        kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
+        ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
+        if (ret < 0) {
+            goto err;
+        }
     }
     mem.memory_size = slot->memory_size;
     ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
     slot->old_flags = mem.flags;
+err:
     trace_kvm_set_user_memory(mem.slot, mem.flags, mem.guest_phys_addr,
                               mem.memory_size, mem.userspace_addr, ret);
+    if (ret < 0) {
+        error_report("%s: KVM_SET_USER_MEMORY_REGION failed, slot=%d,"
+                     " start=0x%" PRIx64 ", size=0x%" PRIx64 ": %s",
+                     __func__, mem.slot, slot->start_addr,
+                     (uint64_t)mem.memory_size, strerror(errno));
+    }
     return ret;
 }
 
-- 
2.21.1

