Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF3C199E8C
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 21:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730673AbgCaTA6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 15:00:58 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:20080 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729941AbgCaTAo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Mar 2020 15:00:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585681243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V6kMOTSpFcDOP0/szFuhOxO6Epp29hRF0tLj3kk1Vz8=;
        b=ALj1E49FBlCVILJe+1SQBZGGKdi34KaePAAwlbJOHLkqomOl3GEAcKqOqWNiXn6J/Ii6PE
        Szj/BL6RArlrgM/4SdqD0TKM4GKw6ax0xfa3I3eI/kjj3+tyVkoKnAScfjncTiCXKdYFAo
        +BsLhAoSFxnUJvUDvcu4JT69aC3CKmI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-bVlLqy8ON16ySv6aeZGASQ-1; Tue, 31 Mar 2020 15:00:41 -0400
X-MC-Unique: bVlLqy8ON16ySv6aeZGASQ-1
Received: by mail-wm1-f70.google.com with SMTP id s9so1451350wmh.2
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 12:00:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V6kMOTSpFcDOP0/szFuhOxO6Epp29hRF0tLj3kk1Vz8=;
        b=mN23ysW1rUwJHCCTx5nQOcQzCVYEtGUnaumo8tFyQ0rOWRM5WqTIDy4Z3AyPVauX6/
         TapNfF9LlAb0AXLIQau9VZTnUORZ1PBx46mWf5t5hL60uho9pvX29pBAwt2D0/lv7kNu
         HHISeJCU129cO4Uv7v0kIAtq1vVt5m6cFbj+m/x9Y1B9bh9j+pe6Na9l/Y/lcmcXpFo/
         cm9fyXcXxS5QnlSsZbxfiWTTbvBgZK8Nc+5o4u8c9px3S02FxCEg+dw/c4wE1qWhg60E
         yEoX2hD9lpMOCkAMT/oEbaJTaP2lwI2X1Rh9j8Pd4yYuPX8c90YbVPl/RUUSNL3EikB6
         XLMg==
X-Gm-Message-State: ANhLgQ3erlN0kNY9YPInYxbXaOEwR0nSrOVvCWc7+8PWOmcE4NvWPgL2
        ffGUNP6TJh4oRjcsZXpAw/btIZN7kL1Y/rhH0eFVNigRXt+5tpyv3h4tt4sd0TWvGBg2aqqkkHm
        g6Z6b0ZCO2QbO
X-Received: by 2002:a5d:4f08:: with SMTP id c8mr22446222wru.27.1585681240675;
        Tue, 31 Mar 2020 12:00:40 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuThXSQEdN/aEbHa49dPZlaZI4ScfCEKwPD+n8JlJD2q3rs9KEG7qvjptIjNzDS5gjRDFr73Q==
X-Received: by 2002:a5d:4f08:: with SMTP id c8mr22446200wru.27.1585681240485;
        Tue, 31 Mar 2020 12:00:40 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id p10sm23444848wre.15.2020.03.31.12.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 12:00:39 -0700 (PDT)
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
Subject: [PATCH v8 06/14] KVM: Make dirty ring exclusive to dirty bitmap log
Date:   Tue, 31 Mar 2020 14:59:52 -0400
Message-Id: <20200331190000.659614-7-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200331190000.659614-1-peterx@redhat.com>
References: <20200331190000.659614-1-peterx@redhat.com>
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
index aa54a34077b7..d56f86ba05a0 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6225,3 +6225,10 @@ make sure all the existing dirty gfns are flushed to the dirty rings.
 
 The dirty ring can gets full.  When it happens, the KVM_RUN of the
 vcpu will return with exit reason KVM_EXIT_DIRTY_LOG_FULL.
+
+NOTE: the capability KVM_CAP_DIRTY_LOG_RING and the corresponding
+ioctl KVM_RESET_DIRTY_RINGS are mutual exclusive to the existing ioctl
+KVM_GET_DIRTY_LOG.  After enabling KVM_CAP_DIRTY_LOG_RING with an
+acceptable dirty ring size, the virtual machine will switch to the
+dirty ring tracking mode.  Further ioctls to either KVM_GET_DIRTY_LOG
+or KVM_CLEAR_DIRTY_LOG will fail.
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index eacdedf8d122..1a4cc20c5a3c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1355,6 +1355,10 @@ int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
 	unsigned long n;
 	unsigned long any = 0;
 
+	/* Dirty ring tracking is exclusive to dirty log tracking */
+	if (kvm->dirty_ring_size)
+		return -EINVAL;
+
 	*memslot = NULL;
 	*is_dirty = 0;
 
@@ -1416,6 +1420,10 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
 	unsigned long *dirty_bitmap_buffer;
 	bool flush;
 
+	/* Dirty ring tracking is exclusive to dirty log tracking */
+	if (kvm->dirty_ring_size)
+		return -EINVAL;
+
 	as_id = log->slot >> 16;
 	id = (u16)log->slot;
 	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
@@ -1524,6 +1532,10 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 	unsigned long *dirty_bitmap_buffer;
 	bool flush;
 
+	/* Dirty ring tracking is exclusive to dirty log tracking */
+	if (kvm->dirty_ring_size)
+		return -EINVAL;
+
 	as_id = log->slot >> 16;
 	id = (u16)log->slot;
 	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
-- 
2.24.1

