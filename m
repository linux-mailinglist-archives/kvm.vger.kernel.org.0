Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20D5E17EBF2
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 23:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbgCIWYK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 18:24:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47669 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726698AbgCIWYK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 18:24:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583792649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gz4cVZBWbRKHAvLf/UbUUA3uFSN9eBglr4ne2SLrQGM=;
        b=RMccKAxXFZdXdxyruzVSxM1IKQd2azZkn0mSckC3MzOTPeHITtExx1gJOTNrLMvif6gD44
        DS1XY1Bf+Wu3CBM6tpcneXd+gg4dg8yq4OwzxDUJFmOu629hOoZiTBJUWPAY8LXn4+DqeS
        TECfqX7znXy9Cm8skSRdQRrgUpo3Gz4=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-eJ3o5ylfMmKbmOhApSUnyQ-1; Mon, 09 Mar 2020 18:24:08 -0400
X-MC-Unique: eJ3o5ylfMmKbmOhApSUnyQ-1
Received: by mail-qv1-f70.google.com with SMTP id g12so4325500qvp.20
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 15:24:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gz4cVZBWbRKHAvLf/UbUUA3uFSN9eBglr4ne2SLrQGM=;
        b=sLCbhL//hO6VVPna32hLvM8hamocYRe2zP4f7B9opI/E0G5bD0LoTv2q9XS2mn2+kF
         BR7RCcB0FAxmqkCL+4SokXYJPGgXa9p3ldA74Xcvz8igMN5MwMj4ZU7cIiQRYlpn9dJM
         Xb/RLt8NRwI79556TghxfkBiJUlN1mkSqZLnRxfIn4s8cdc2cW+WRVMBL72WBnW3YmFq
         Tr8U/cL0r/J6i6E3Wzo6X7pBcEncHkJYp8LSwfGNSo7vYnqar4wyHMyVA6OxgKwzRhWs
         9BcThAgMD+Luz4KdRLORyhKvIMj5Es04Phil68CmNygMAwBq3lo6b10ZnjH3/11+Vvnn
         O2Eg==
X-Gm-Message-State: ANhLgQ37wwjce2Fpo2i5VZmh2IhhsDNy9xxuyqlf1yyQF0qBFTJlCTt3
        lBG5THqfSYB1Rso7zNtLqodDeFMJNBT+HATyOCsGNnP3eMmMwdkXKlfRlV+lyK3ulIP/tmfWb9g
        O/8PNgAUAaQvd
X-Received: by 2002:ae9:edd2:: with SMTP id c201mr9511248qkg.366.1583792647882;
        Mon, 09 Mar 2020 15:24:07 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtCW+fLB8QzaXn2Sr2P0CEQsHfa2lXJzsCZDIwtY2mePQah4+YwmAlTdXJ3yzBmsdQSZPlvfw==
X-Received: by 2002:ae9:edd2:: with SMTP id c201mr9511231qkg.366.1583792647635;
        Mon, 09 Mar 2020 15:24:07 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id k50sm23584589qtc.90.2020.03.09.15.24.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 15:24:06 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v6 06/14] KVM: Make dirty ring exclusive to dirty bitmap log
Date:   Mon,  9 Mar 2020 18:24:05 -0400
Message-Id: <20200309222405.345331-1-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309214424.330363-1-peterx@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There's no good reason to use both the dirty bitmap logging and the
new dirty ring buffer to track dirty bits.  We should be able to even
support both of them at the same time, but it could complicate things
which could actually help little.  Let's simply make it the rule
before we enable dirty ring on any arch, that we don't allow these two
interfaces to be used together.

The big world switch would be KVM_CAP_DIRTY_LOG_RING capability
enablement.  That's where we'll switch from the default dirty logging
way to the dirty ring way.  As long as kvm->dirty_ring_size is setup
correctly, we'll once and for all switch to the dirty ring buffer mode
for the current virtual machine.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 Documentation/virt/kvm/api.rst |  7 +++++++
 virt/kvm/kvm_main.c            | 12 ++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index bc17ca955495..55979d5095aa 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6143,3 +6143,10 @@ make sure all the existing dirty gfns are flushed to the dirty rings.
 
 The dirty ring can gets full.  When it happens, the KVM_RUN of the
 vcpu will return with exit reason KVM_EXIT_DIRTY_LOG_FULL.
+
+NOTE: the KVM_CAP_DIRTY_LOG_RING capability and the new ioctl
+KVM_RESET_DIRTY_RINGS are exclusive to the existing KVM_GET_DIRTY_LOG
+interface.  After enabling KVM_CAP_DIRTY_LOG_RING with an acceptable
+dirty ring size, the virtual machine will switch to the dirty ring
+tracking mode, and KVM_GET_DIRTY_LOG, KVM_CLEAR_DIRTY_LOG ioctls will
+stop working.
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2112958c7500..e51a14d24619 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1191,6 +1191,10 @@ int kvm_get_dirty_log(struct kvm *kvm,
 	unsigned long n;
 	unsigned long any = 0;
 
+	/* Dirty ring tracking is exclusive to dirty log tracking */
+	if (kvm->dirty_ring_size)
+		return -EINVAL;
+
 	as_id = log->slot >> 16;
 	id = (u16)log->slot;
 	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
@@ -1248,6 +1252,10 @@ int kvm_get_dirty_log_protect(struct kvm *kvm,
 	unsigned long *dirty_bitmap;
 	unsigned long *dirty_bitmap_buffer;
 
+	/* Dirty ring tracking is exclusive to dirty log tracking */
+	if (kvm->dirty_ring_size)
+		return -EINVAL;
+
 	as_id = log->slot >> 16;
 	id = (u16)log->slot;
 	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
@@ -1319,6 +1327,10 @@ int kvm_clear_dirty_log_protect(struct kvm *kvm,
 	unsigned long *dirty_bitmap;
 	unsigned long *dirty_bitmap_buffer;
 
+	/* Dirty ring tracking is exclusive to dirty log tracking */
+	if (kvm->dirty_ring_size)
+		return -EINVAL;
+
 	as_id = log->slot >> 16;
 	id = (u16)log->slot;
 	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
-- 
2.24.1

