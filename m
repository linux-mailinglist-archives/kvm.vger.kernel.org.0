Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C60F527F74D
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 03:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731189AbgJABWf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 21:22:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60440 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730291AbgJABW1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Sep 2020 21:22:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601515345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Au/x+RXVuLpmMW71l+r09X+SFEaNcEAnQSW0uHVuybA=;
        b=TBH5tgvtNM3iQg1PZEWHIIntqtBdWlslPiCvkopa9Tur513j+GWFycDuze8iKPYMX3f3Y8
        shsAIU768KQ3XyyDQ+wjOJqTlok+P00Hu001WAi3Vx90YD1hxgsxvdA6ow0fL5SJQR51Af
        3bzcDBUqEPFYy55yMRY/9P9ljD8H614=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-9Ik5tzYFPeu8C_Koxzz1rA-1; Wed, 30 Sep 2020 21:22:24 -0400
X-MC-Unique: 9Ik5tzYFPeu8C_Koxzz1rA-1
Received: by mail-qk1-f197.google.com with SMTP id w64so2109006qkc.14
        for <kvm@vger.kernel.org>; Wed, 30 Sep 2020 18:22:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Au/x+RXVuLpmMW71l+r09X+SFEaNcEAnQSW0uHVuybA=;
        b=PG+jx3nJyJN1GHp4Wioxr+/YZvnWqns8M6hD/BSfLivqj3kX2NCbBJ1LXfn9sk0Is1
         KkZ77m8Zx4QiYvM8KdUtQX0snd10yEb3yQyAV22o3FGm7mQsJ8Pkt/fdmzs0JtRWULyd
         47KznwagPcOP81bLPpB+/TtYs7QaVxnAXGrJzeb5cgJJZk01KBe/8lbM7WUESvcpdpSx
         3q2IMxQYnY89v1gbfnBhkvjpBNBvgaSUpmdybZn0481/cjp636xaTjCqdtnQrL2Js7y3
         6S/k1a6bnE6c+mbQ9BeLF1OCaxG0oiV4qPd8Mu0JsVahw8XFKGM1GLGE2GVq/TTxb+Nt
         taCQ==
X-Gm-Message-State: AOAM531x8pAskbXKIpLyPlcjcQWbJXFSR+6yPVLtobYalH9g7H7sdZAE
        AFvBGNTH4Fww9AKQOO+L87pAIeeC/5a7Ho51C2Z9VVGYEMif2Wd+bGKyR1IjNQSzVA42q+/iILJ
        zrcnyIvQadBzh
X-Received: by 2002:a37:9f08:: with SMTP id i8mr5514632qke.197.1601515343543;
        Wed, 30 Sep 2020 18:22:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJHNu0WksI8q+v3CmlVSCeTCkIaWRAvpnmBVJ4CNWa5ya0x/cFOhsaCtmeYn8cdW52VAVBQA==
X-Received: by 2002:a37:9f08:: with SMTP id i8mr5514614qke.197.1601515343329;
        Wed, 30 Sep 2020 18:22:23 -0700 (PDT)
Received: from localhost.localdomain (toroon474qw-lp130-09-184-147-14-204.dsl.bell.ca. [184.147.14.204])
        by smtp.gmail.com with ESMTPSA id f76sm4174361qke.19.2020.09.30.18.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 18:22:22 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>, peterx@redhat.com,
        Andrew Jones <drjones@redhat.com>
Subject: [PATCH v13 06/14] KVM: Make dirty ring exclusive to dirty bitmap log
Date:   Wed, 30 Sep 2020 21:22:24 -0400
Message-Id: <20201001012224.5818-1-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001012044.5151-1-peterx@redhat.com>
References: <20201001012044.5151-1-peterx@redhat.com>
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

