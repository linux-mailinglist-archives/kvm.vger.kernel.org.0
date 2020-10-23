Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D69429771E
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 20:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1754835AbgJWSfi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 14:35:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55660 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754862AbgJWSeN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 14:34:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603478052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L3ZJsaKS1gNf0C0NZKbX4rkEwggNcdAZdu3ekfUHbZY=;
        b=hqSYUs5pNjN9+RCXc6rWPiDtC/dKCcvpsIe3KGu+qOkbRKkC1NhWNoEF0s4cDO8eQOPkuq
        AxmCiAlRASc8Dpu8uLPQbNU8J0Z18fMdEP2mFmEJAx5n8wfLTL/5qv59MhwA998h5Zt+zE
        SUXVaGHpi076NoG/BfS8iJE/6J7A+ZU=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-519dfBqYObqkufHJoNtkgQ-1; Fri, 23 Oct 2020 14:34:10 -0400
X-MC-Unique: 519dfBqYObqkufHJoNtkgQ-1
Received: by mail-qt1-f197.google.com with SMTP id t4so1652345qtd.23
        for <kvm@vger.kernel.org>; Fri, 23 Oct 2020 11:34:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L3ZJsaKS1gNf0C0NZKbX4rkEwggNcdAZdu3ekfUHbZY=;
        b=L9tjDVjtJ0JFR4oSNKQubJ6JA9VMVKBERxlsQwljOzbL/mwiPL1qLpxls1yUismV50
         Ryjdgwx86h264B3YbPfqN85JyR++78K5kFPCwAb/KpiwBAOskFyy9aAHHs6YBhgLBfkF
         YhPtHxgFvT0MOLdC/z0Y5Qu9runVJGL4q/PNqqUm4Wp0KXKQKr951p+hRtaYnQnGAYjF
         Jv0OcgQcd+piDJe0SJ62mTxWnWqzVzTVZ4K8WswHMdGWTzu+YHdCp25qTkk/z7h+4ymg
         ILiufDHG6h1i40pzBUX0XejRKNuv1wpa0gIYHkNJ/jGKxmk7s4/mutfD33ulGsJUSs96
         ydYg==
X-Gm-Message-State: AOAM5315iHi5FhjxUJN5natdQ+MgWQOMKaDByO9gSA05hRuikrxDydL7
        xddTqaKEIS7U3x+RCK8ZZ0DianF/OEJFfJVofOFlTMPDYd/SZ2eo0qXov8VhOqywMig6Byfd3gx
        1rnriWfENaOCb
X-Received: by 2002:a05:620a:1f3:: with SMTP id x19mr3642317qkn.62.1603478050032;
        Fri, 23 Oct 2020 11:34:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwRGmmVmVvSiP53ER+mNj/yPmjpiiLZ0TmvgyeT1c1TU7ocoQdHqPRJtCsXzUuQa26q5Tsp2w==
X-Received: by 2002:a05:620a:1f3:: with SMTP id x19mr3642286qkn.62.1603478049660;
        Fri, 23 Oct 2020 11:34:09 -0700 (PDT)
Received: from xz-x1.redhat.com (toroon474qw-lp140-04-174-95-215-133.dsl.bell.ca. [174.95.215.133])
        by smtp.gmail.com with ESMTPSA id u11sm1490407qtk.61.2020.10.23.11.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 11:34:09 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com, Andrew Jones <drjones@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v15 06/14] KVM: Make dirty ring exclusive to dirty bitmap log
Date:   Fri, 23 Oct 2020 14:33:50 -0400
Message-Id: <20201023183358.50607-7-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201023183358.50607-1-peterx@redhat.com>
References: <20201023183358.50607-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 00da3f01d632..33e393759444 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6507,3 +6507,10 @@ make sure all the existing dirty gfns are flushed to the dirty rings.
 
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
index 357b3f7b1127..c05b94696b21 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1426,6 +1426,10 @@ int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
 	unsigned long n;
 	unsigned long any = 0;
 
+	/* Dirty ring tracking is exclusive to dirty log tracking */
+	if (kvm->dirty_ring_size)
+		return -EINVAL;
+
 	*memslot = NULL;
 	*is_dirty = 0;
 
@@ -1487,6 +1491,10 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
 	unsigned long *dirty_bitmap_buffer;
 	bool flush;
 
+	/* Dirty ring tracking is exclusive to dirty log tracking */
+	if (kvm->dirty_ring_size)
+		return -EINVAL;
+
 	as_id = log->slot >> 16;
 	id = (u16)log->slot;
 	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
@@ -1595,6 +1603,10 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
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

