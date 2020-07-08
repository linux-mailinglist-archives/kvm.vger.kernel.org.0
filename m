Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2078D2190CE
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 21:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgGHTfX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 15:35:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23305 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726787AbgGHTeZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 15:34:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594236863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Gh6qA+fB/LA3kl5rPoiuYHmLXSgMPKPUDULRc9B3B0=;
        b=LYzaILzeyxn9FS6kQkJGAgBgASbzZjH4SiKdgjkWeBhBzqJakzBiGZpqugx4tA14Gr3quY
        Pop4i5SupOsczUY4fueF7jRFTSnm2gK7Nq+EhojydRl9tjQjnJUtQOsTYpbvN+ypUZy5uf
        TC7QYGzcvW7XQGvnkbOsQJ3ACMbivbE=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-bWx57m3MPSK5vchRBCxH9Q-1; Wed, 08 Jul 2020 15:34:21 -0400
X-MC-Unique: bWx57m3MPSK5vchRBCxH9Q-1
Received: by mail-qk1-f199.google.com with SMTP id i6so31643864qkn.22
        for <kvm@vger.kernel.org>; Wed, 08 Jul 2020 12:34:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Gh6qA+fB/LA3kl5rPoiuYHmLXSgMPKPUDULRc9B3B0=;
        b=ZagMfUNagaZ5VeoonqaYiaJ9ib7DdWa6X9ghXJ0lIkftZFzi5QGtvAN1qRhvGBOZlk
         abDOjAGRB40vF/lQVjma8IQi/Y+oxv0HArtTFkvLO26R86FtNt/AvZl3tiL2MVXBkjtC
         7t8k7ls68CYHLfeENr5s8RYyu/Xoq13/BlHZAtAAJjAKiziRba8islcc7kHS3eHbBKW+
         527/c4eh6gbnn5ROtTPxZJiWRSjxiTHMfpahUakWgcvrMfmvItafcFGCKMVKK0NHsZAL
         Id4hWXQ9iuzhZHN0vpfMFJjZmJ62fZaTKNwXTGsWS93q9g3K4TY+FfSrwUvJTk+HZ1lA
         6lRA==
X-Gm-Message-State: AOAM53025q+LTXHzHH5QBZ9TJ2Xvz6mgfinVFK0Qzpk+pn+Qcr4adkeH
        Sb/gM1dfxkMAdmnG3dDMRVKlICnofcdQ81dbnJ1y5Q2SChr+0YOUWXbaQkR4ZRe24c61vLi7d/M
        U4KdKuhyqZIQS
X-Received: by 2002:aed:208c:: with SMTP id 12mr61867796qtb.286.1594236860734;
        Wed, 08 Jul 2020 12:34:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxcc19hsTYobFOkkcQre46Z+fJ84n4EzXno6SCHdoqWxkBbl4iGltA5UbSOUP+brzOwG25//Q==
X-Received: by 2002:aed:208c:: with SMTP id 12mr61867771qtb.286.1594236860480;
        Wed, 08 Jul 2020 12:34:20 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c8:6f::1f4f])
        by smtp.gmail.com with ESMTPSA id f18sm664884qtc.28.2020.07.08.12.34.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 12:34:19 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v11 05/13] KVM: Make dirty ring exclusive to dirty bitmap log
Date:   Wed,  8 Jul 2020 15:34:00 -0400
Message-Id: <20200708193408.242909-6-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200708193408.242909-1-peterx@redhat.com>
References: <20200708193408.242909-1-peterx@redhat.com>
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
index c6b9f083d216..ffade37a15ae 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6267,3 +6267,10 @@ make sure all the existing dirty gfns are flushed to the dirty rings.
 
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
index 43e5536cfa93..c8c249edc885 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1374,6 +1374,10 @@ int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
 	unsigned long n;
 	unsigned long any = 0;
 
+	/* Dirty ring tracking is exclusive to dirty log tracking */
+	if (kvm->dirty_ring_size)
+		return -EINVAL;
+
 	*memslot = NULL;
 	*is_dirty = 0;
 
@@ -1435,6 +1439,10 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
 	unsigned long *dirty_bitmap_buffer;
 	bool flush;
 
+	/* Dirty ring tracking is exclusive to dirty log tracking */
+	if (kvm->dirty_ring_size)
+		return -EINVAL;
+
 	as_id = log->slot >> 16;
 	id = (u16)log->slot;
 	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
@@ -1543,6 +1551,10 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
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

