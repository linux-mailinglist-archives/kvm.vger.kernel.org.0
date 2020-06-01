Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE9D1EA34D
	for <lists+kvm@lfdr.de>; Mon,  1 Jun 2020 14:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbgFAMB0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 08:01:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57463 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727063AbgFAMAT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 08:00:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591012817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t0iDL7BowDYNcq44fr2mt7MXUp9DN6SRpw9sZLiGRV8=;
        b=BoRzWH3btylfNAokSPbatGW8GnRZgYXKs07m0FJhV7MBLd2yQ4A73gJKvBC8IgI4teb+z4
        GSqw6FxgJBAScv+dLXzl7XpCFQmhRfdc3dcp9medUBPx6vOovjnEikBqAS8VT153jKRw/H
        a1ynAKV48UP6832d94/oua9gmgxjxXk=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-2awJ9iTsOGqRFj_6DyGFNQ-1; Mon, 01 Jun 2020 08:00:14 -0400
X-MC-Unique: 2awJ9iTsOGqRFj_6DyGFNQ-1
Received: by mail-qt1-f197.google.com with SMTP id h49so7461765qtk.10
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 05:00:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t0iDL7BowDYNcq44fr2mt7MXUp9DN6SRpw9sZLiGRV8=;
        b=khqh5ITnrUCLJ4t+BfNePCl/ONmLGzem6GZWgHsXWb+xypfouQGAtZsiHKRLWPIcSJ
         dYx5L8sDkCJrtd3bKC/mjbN6WxfZZ+Kn84K7BxBk0oduKv5f69Z8Yz+2BzoRxbU3KtQJ
         K0VrfNxdFpR7ndynsx0TsQA+MmK5+bMFg/zCDZaWv59pwmJKBOf7QZPWfu+T0fB8tdix
         l9KLcT0DjIms1dA8I5ltF2G/G+m32KolD6c0gsVjIHsL8XIJsb6y4Fa0fafFztqgoy3b
         ozeGJaZ8Io60ZVE1jCneXvkgi5KfR7TuJtKlj5WcMKKprUxN6pMcLVmQqu4AW6UJVqla
         53Sw==
X-Gm-Message-State: AOAM531pt3/d+GXV05IJxMyw9srcDFlfZvaIXJ8/9iZeTLDEXVdsmYqX
        pqhTWH2KYq9jnfTFBpYz3jn++4b062W5UOVuLw9AFcrEmqrNKeIYmU1hMGMAmDRJ7EmI/WpfJwx
        TYhlyUp7jU1Pp
X-Received: by 2002:ac8:2df5:: with SMTP id q50mr21780457qta.228.1591012813730;
        Mon, 01 Jun 2020 05:00:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxKevJ+Gc95uadw9jcOQ6sK5QQZ9VPOeYVRFYWptIIu8gWsdG2pV8QB8JJ5rxea75QspQfhPg==
X-Received: by 2002:ac8:2df5:: with SMTP id q50mr21780431qta.228.1591012813473;
        Mon, 01 Jun 2020 05:00:13 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id l9sm14474185qki.90.2020.06.01.05.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 05:00:12 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v10 06/14] KVM: Make dirty ring exclusive to dirty bitmap log
Date:   Mon,  1 Jun 2020 07:59:49 -0400
Message-Id: <20200601115957.1581250-7-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601115957.1581250-1-peterx@redhat.com>
References: <20200601115957.1581250-1-peterx@redhat.com>
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
index c40b0c57427f..6b759f48a302 100644
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
2.26.2

