Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D42612837F
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 22:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727655AbfLTVCU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 16:02:20 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50638 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727654AbfLTVCK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Dec 2019 16:02:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576875729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G5ujQPtmC0gFSTE7FNk323KNrK3wygZRxxl448+O6gM=;
        b=HkLBqr23g1c1GDVt9mfJ5qZq51Q11fyHK+r+LH9lpi6I9zIm5D6ap7o00CzY68S9/0oRg0
        4eyV7vaICjF+LmEc8csMQVGQU2FRGxvYNwru/ExQGhym6UrA6Bh/hDJGASzCaL9+RZWK1a
        S794lLzLKKSU48bgPFL5PEFZylCwEf8=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-vVxpYvSIPkO4ZzUD0imYAA-1; Fri, 20 Dec 2019 16:02:07 -0500
X-MC-Unique: vVxpYvSIPkO4ZzUD0imYAA-1
Received: by mail-qt1-f200.google.com with SMTP id d18so6809770qtp.16
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 13:02:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G5ujQPtmC0gFSTE7FNk323KNrK3wygZRxxl448+O6gM=;
        b=q27NNu8+iLFq5R2AmH8FSzbRsbpnrgqbk6UuaXPBX2jJ/h+FCBQ4qFDCqTzAlBVdTx
         Vt2ax4+CBVonI32wYJB0WADYjUV5hV/Cat1oBjZEPrYgnyQ62edaCWIDrIjqHbBoZYfL
         5uvT8CEEjsxD7pQ3TpIGEtXJmo5GtoTk3OS+q3KpIToCM0lq2aExyteDaYuEBQV84G1G
         OHwy5AOf/dD0tBPh9FFI451Gug2LedEh6JftrbW4E1XZ1sCvN4nFFI+uSkq/ITX+BGFO
         5Zw3b3XZ3JeTPQCgTfdMSmkTIDkNqq5JF9JDUb1gqcEpJWVUnYu4WLpyBIruLyJ9KbGU
         n/PQ==
X-Gm-Message-State: APjAAAXkTuAXBuz/DUpSNMePtPVkqliVzDiz1yI5+Vu46wR8vV/JkQ5J
        e6T9cu3hZLuY2bdS4PQnxdzFarDFNdn8hZrGL4ech5HIbUR2YJpF7ZV0ZTy8eFRofGZQCKvHimK
        BxnLVB2UvZoL2
X-Received: by 2002:a37:a00b:: with SMTP id j11mr15296028qke.268.1576875724804;
        Fri, 20 Dec 2019 13:02:04 -0800 (PST)
X-Google-Smtp-Source: APXvYqyPYw38tftza/eiCRksgBlotjNaedZkoJuSdav/RZKZYcqAteHsuJrRYX9aYbSMnU9GxoyFwg==
X-Received: by 2002:a37:a00b:: with SMTP id j11mr15295997qke.268.1576875724543;
        Fri, 20 Dec 2019 13:02:04 -0800 (PST)
Received: from xz-x1.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id q25sm3243836qkq.88.2019.12.20.13.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 13:02:03 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>, peterx@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
Subject: [PATCH v2 09/17] KVM: Make dirty ring exclusive to dirty bitmap log
Date:   Fri, 20 Dec 2019 16:01:39 -0500
Message-Id: <20191220210147.49617-10-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191220210147.49617-1-peterx@redhat.com>
References: <20191220210147.49617-1-peterx@redhat.com>
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
 Documentation/virt/kvm/api.txt |  7 +++++++
 virt/kvm/kvm_main.c            | 12 ++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
index c141b285e673..b507b966f9f1 100644
--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -5411,3 +5411,10 @@ all the existing dirty gfns are flushed to the dirty rings.
 If one of the ring buffers is full, the guest will exit to userspace
 with the exit reason set to KVM_EXIT_DIRTY_LOG_FULL, and the KVM_RUN
 ioctl will return to userspace with zero.
+
+NOTE: the KVM_CAP_DIRTY_LOG_RING capability and the new ioctl
+KVM_RESET_DIRTY_RINGS are exclusive to the existing KVM_GET_DIRTY_LOG
+interface.  After enabling KVM_CAP_DIRTY_LOG_RING with an acceptable
+dirty ring size, the virtual machine will switch to the dirty ring
+tracking mode, and KVM_GET_DIRTY_LOG, KVM_CLEAR_DIRTY_LOG ioctls will
+stop working.
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4050631d05f3..b69d34425f8d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1204,6 +1204,10 @@ int kvm_get_dirty_log(struct kvm *kvm,
 	unsigned long n;
 	unsigned long any = 0;
 
+	/* Dirty ring tracking is exclusive to dirty log tracking */
+	if (kvm->dirty_ring_size)
+		return -EINVAL;
+
 	as_id = log->slot >> 16;
 	id = (u16)log->slot;
 	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
@@ -1261,6 +1265,10 @@ int kvm_get_dirty_log_protect(struct kvm *kvm,
 	unsigned long *dirty_bitmap;
 	unsigned long *dirty_bitmap_buffer;
 
+	/* Dirty ring tracking is exclusive to dirty log tracking */
+	if (kvm->dirty_ring_size)
+		return -EINVAL;
+
 	as_id = log->slot >> 16;
 	id = (u16)log->slot;
 	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
@@ -1332,6 +1340,10 @@ int kvm_clear_dirty_log_protect(struct kvm *kvm,
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

