Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4012512866F
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2019 02:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbfLUBuJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 20:50:09 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:31648 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727039AbfLUBuD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Dec 2019 20:50:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576893002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G5ujQPtmC0gFSTE7FNk323KNrK3wygZRxxl448+O6gM=;
        b=I1M8c0p5QiQwBlyDveaSZom555aVYHaEqbh4tIwUAEH1PgOxpKaJyKsz0snavmxGqUVSVK
        E1vKAdUL36wvIoKGsJn5V7u+MjNoALRvaYErWYpYdJloJ3vViMDW4g09gDbXD+somwCEQK
        axut8GWHLHQPdVnWwBS2M1GD0sKo1Cg=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-OKXhJrWbOj6oyyGF7BBkGQ-1; Fri, 20 Dec 2019 20:50:01 -0500
X-MC-Unique: OKXhJrWbOj6oyyGF7BBkGQ-1
Received: by mail-qv1-f71.google.com with SMTP id j10so348997qvi.1
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 17:50:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G5ujQPtmC0gFSTE7FNk323KNrK3wygZRxxl448+O6gM=;
        b=j+PdoKBFge4FWcLN8v6T5QuoDrp6UTXdL9WEIozeEIXfTWTvUmFU+n1nu/YJsqTHzj
         hamqv+gvEKJ0jtIZfjF7V7ysCdw32UrpwA+NcpRmLYOodKPInhj4UQnbApSDElijVn3t
         tJ0ehbizDU5SA+xlEjTTP/N+eevxut3wmD4IuZbM711P7/wnV2K/z91nmbe+h33rhVbL
         2DwRwaITlIu1QfWMY9yoCjAEEGrEtyfLsNo7cNwMTdKd8I04pL/B4M5sIAUTxvNuUS5v
         JveZQEyjZIhB6Q9eqndoBt966zx9LWgo+p5iCK8ZTa1xPSoHPHY3XeK5CEg8HyKFAXuk
         4/pA==
X-Gm-Message-State: APjAAAW0T+zvps3/5E1MrEbYTuozo9vLPuvMQTUzGce5TjzdMYT0QLDc
        psrbA0F/X/HwR+FUZi3t2d2YzK9nPzvpnGhAuSP+5uvUOcGHKX3jaqASBdTjVQXsf9RpR8jn8Og
        XBScmi22inHEO
X-Received: by 2002:ad4:580e:: with SMTP id dd14mr15219147qvb.84.1576892999198;
        Fri, 20 Dec 2019 17:49:59 -0800 (PST)
X-Google-Smtp-Source: APXvYqxXDZ010Jj63Zw0teFHj3SM5N6tHwnvZPO/bBU+WjmdKSJbRxnWfEniJtAF0WxN2PoG7s2b7w==
X-Received: by 2002:ad4:580e:: with SMTP id dd14mr15219134qvb.84.1576892998922;
        Fri, 20 Dec 2019 17:49:58 -0800 (PST)
Received: from xz-x1.hitronhub.home (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id e21sm3396932qkm.55.2019.12.20.17.49.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 17:49:58 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RESEND v2 09/17] KVM: Make dirty ring exclusive to dirty bitmap log
Date:   Fri, 20 Dec 2019 20:49:30 -0500
Message-Id: <20191221014938.58831-10-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191221014938.58831-1-peterx@redhat.com>
References: <20191221014938.58831-1-peterx@redhat.com>
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

