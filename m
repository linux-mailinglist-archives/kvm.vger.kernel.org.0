Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55CF1179713
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 18:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388352AbgCDRuR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 12:50:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52859 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388328AbgCDRuP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 12:50:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583344213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=88e070kHMgQjDdreg4NYtPFAqs0Pb9K+uERwa96oW/g=;
        b=L/lB6DwzFezHbeD20LndzCdn8/rY9DSd851X3B1Qs4FSehIMby8vn23xWKN7SDxAv+Q1wi
        trocBJ9YADX4pYuz4oSQFC2trydtCtF8r9w6nC8YQK80enDXBJPTnD/EHAwthQXHEAo+0W
        Kxxy75aC+ivB92S4BdQ8fhfhYGR0NH8=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-STZ6csJbO8-AiH8AoFF8DQ-1; Wed, 04 Mar 2020 12:50:11 -0500
X-MC-Unique: STZ6csJbO8-AiH8AoFF8DQ-1
Received: by mail-qv1-f69.google.com with SMTP id u5so1428692qvj.10
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2020 09:50:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=88e070kHMgQjDdreg4NYtPFAqs0Pb9K+uERwa96oW/g=;
        b=a2BqRHrTsbBkxunXtHSWHPnFZgRr4nuP3HO2fpDIdtmzXohNHhSj34a1uaVsDn9EDb
         bNgzOxdAHEvpxcz+XBTJteQtPYiDdyr+I2PaXzWbPZtspjdZMgdf2Z0ZIyDh5UqHpE1X
         D4ThvaRt8OEagGHk4uOgPctdMFa8NDaHt/WdlvS6Sc/ZGGGP8ryxHufJMcREMiuJbaLp
         DgeeEUJlxYrEeqVDPWPl4LmzrrguQ7A3nsGRm3cZa//mJYlNkyooXg5FhzF912Ab+7dz
         yVLNDxVZA85mntMknPEskMiMHo0/NcZVKWHp6OO+v5xwvmq/1kTQoE6Jl/2sj03+FMd8
         SPAw==
X-Gm-Message-State: ANhLgQ3g/vQC5uK3jrheN38X4stY/IgD27c+y0dw3KokRBh+oIGJq4Jl
        2YGdxN2daLRgABQYL55gsFGvfXZ4L85ifo/RERHNgPIPuHEJRkW3pCkbZBqmkb44sr77ZMy5e60
        mD1U3aIIY6yne
X-Received: by 2002:a37:6796:: with SMTP id b144mr3936275qkc.485.1583344210917;
        Wed, 04 Mar 2020 09:50:10 -0800 (PST)
X-Google-Smtp-Source: ADFU+vu9WZ6XP24dbx7zQpLCjm1Uw/r9f4TnWu/pZupo36cltZ2EcASFT4MB9aTSiTz8+K10AprVoA==
X-Received: by 2002:a37:6796:: with SMTP id b144mr3936242qkc.485.1583344210665;
        Wed, 04 Mar 2020 09:50:10 -0800 (PST)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id q3sm3448488qtf.67.2020.03.04.09.50.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 09:50:10 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Yan Zhao <yan.y.zhao@intel.com>, peterx@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>
Subject: [PATCH v5 06/14] KVM: Make dirty ring exclusive to dirty bitmap log
Date:   Wed,  4 Mar 2020 12:49:39 -0500
Message-Id: <20200304174947.69595-7-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200304174947.69595-1-peterx@redhat.com>
References: <20200304174947.69595-1-peterx@redhat.com>
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
index e26affa3ac4d..72dfb84a08a4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1244,6 +1244,10 @@ int kvm_get_dirty_log(struct kvm *kvm,
 	unsigned long n;
 	unsigned long any = 0;
 
+	/* Dirty ring tracking is exclusive to dirty log tracking */
+	if (kvm->dirty_ring_size)
+		return -EINVAL;
+
 	as_id = log->slot >> 16;
 	id = (u16)log->slot;
 	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
@@ -1301,6 +1305,10 @@ int kvm_get_dirty_log_protect(struct kvm *kvm,
 	unsigned long *dirty_bitmap;
 	unsigned long *dirty_bitmap_buffer;
 
+	/* Dirty ring tracking is exclusive to dirty log tracking */
+	if (kvm->dirty_ring_size)
+		return -EINVAL;
+
 	as_id = log->slot >> 16;
 	id = (u16)log->slot;
 	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
@@ -1372,6 +1380,10 @@ int kvm_clear_dirty_log_protect(struct kvm *kvm,
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

