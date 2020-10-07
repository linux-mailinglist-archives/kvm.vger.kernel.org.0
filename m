Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6F21286970
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 22:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbgJGUyC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 16:54:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45072 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728563AbgJGUx7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Oct 2020 16:53:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602104037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Au/x+RXVuLpmMW71l+r09X+SFEaNcEAnQSW0uHVuybA=;
        b=WGDdAbjT6w0kfiwa9O43VI/ySbvdMP6u3/MIayBHBnEcaLWlrvTt+yX1Aw4xwXqMqs8uVX
        fk05EoiTZ4exrRNBEUMtpBKFApC+kkKMxX2/bUoWJSb1xVj6l5MZ8e9Mr3ZmQMvM0lKwfB
        Kp+siTTaTEJJCQnRyq84eU9oAy652Pg=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-_kSHhZxtOROtiehxaF23TQ-1; Wed, 07 Oct 2020 16:53:54 -0400
X-MC-Unique: _kSHhZxtOROtiehxaF23TQ-1
Received: by mail-qt1-f199.google.com with SMTP id b39so2250638qta.0
        for <kvm@vger.kernel.org>; Wed, 07 Oct 2020 13:53:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Au/x+RXVuLpmMW71l+r09X+SFEaNcEAnQSW0uHVuybA=;
        b=XCHjAPkiC1tFLb7R/Fo/ys7BSbCmtLTUyn/SH1oKbPLCG20poS+/FYmf1G752Wa8py
         w9Oo1tUxHzGKerAGcKmrhh6/V4BxG1z8Ti7zhvwQQQma3Xdcj0fbhs2oawHYw0gfZjZd
         bkUIu3lSbN2oDCXzM//eR+K9XFctnQ7iOL7eDQ8HOS24szqpKAhlSmzF7ojVF9vTrbiP
         YrTj83iavH8wM5qAsvKucswu9LX7LEUy4h0KC4zsyJf+M83I8JKcKeUu7a6sW9o8GCCw
         bH2n6SqeKgtVz2xpg4SUv5Hx9VumAUjeNHD/hCRx+sLFJtFfbHQasOQfgYLEEyveCgKa
         2lgA==
X-Gm-Message-State: AOAM531Jr4bXafKq5oUsTEIODW9t9KL901Y3ThujctAnfHG0tl13j9Qk
        wQn2vwtyx6aWrPuu4F2YPVt3BhytCl6N7JdVlwzQvE2bpDzT0PpNBp+cr3SiLgfWnFOsKoqDfrZ
        2ucdB1IpvlC9+
X-Received: by 2002:a37:2795:: with SMTP id n143mr4886009qkn.321.1602104032396;
        Wed, 07 Oct 2020 13:53:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjiRn3BZwVOTtMSBQsF9SY0fXdQh4OPcMgYkzG4Qar3b7Jv3xvbepa2hKiWkVOG1qQ5jByeA==
X-Received: by 2002:a37:2795:: with SMTP id n143mr4885994qkn.321.1602104032161;
        Wed, 07 Oct 2020 13:53:52 -0700 (PDT)
Received: from xz-x1.redhat.com (toroon474qw-lp140-04-174-95-215-133.dsl.bell.ca. [174.95.215.133])
        by smtp.gmail.com with ESMTPSA id j24sm2390695qkg.107.2020.10.07.13.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 13:53:51 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterx@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andrew Jones <drjones@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: [PATCH v14 06/14] KVM: Make dirty ring exclusive to dirty bitmap log
Date:   Wed,  7 Oct 2020 16:53:34 -0400
Message-Id: <20201007205342.295402-7-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201007205342.295402-1-peterx@redhat.com>
References: <20201007205342.295402-1-peterx@redhat.com>
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
index 6c41cc7eed77..eb628cc59b93 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6490,3 +6490,10 @@ make sure all the existing dirty gfns are flushed to the dirty rings.
 
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
index aefea6ebe132..f32f9fc60d0e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1430,6 +1430,10 @@ int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
 	unsigned long n;
 	unsigned long any = 0;
 
+	/* Dirty ring tracking is exclusive to dirty log tracking */
+	if (kvm->dirty_ring_size)
+		return -EINVAL;
+
 	*memslot = NULL;
 	*is_dirty = 0;
 
@@ -1491,6 +1495,10 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
 	unsigned long *dirty_bitmap_buffer;
 	bool flush;
 
+	/* Dirty ring tracking is exclusive to dirty log tracking */
+	if (kvm->dirty_ring_size)
+		return -EINVAL;
+
 	as_id = log->slot >> 16;
 	id = (u16)log->slot;
 	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
@@ -1599,6 +1607,10 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
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

