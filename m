Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0057227F47F
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 23:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731255AbgI3VzE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 17:55:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49006 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730873AbgI3Vyk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Sep 2020 17:54:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601502878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gztZBGkRzVp8WHABoAlzTY5u2/3Xedlc1leDKo+CwFA=;
        b=HF6mnN5hMlahHa0rvIFkPhz70UEcGdnescdwl7G3U+fMKOyoxnRnMpgTWNsTF0MWYhd+UP
        NlrgHpwkOVj0D/HwInXX+f29RhwPmXptH0J2gCuhrOUZzMbbXcGV0cDH9uFwl5BnTgRLgZ
        +UPDHowz34cuNioGlHSuY0ofDwCS2TM=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-ieun0dq6PF6tGRzVo9GU-w-1; Wed, 30 Sep 2020 17:54:36 -0400
X-MC-Unique: ieun0dq6PF6tGRzVo9GU-w-1
Received: by mail-qv1-f72.google.com with SMTP id ct11so1832182qvb.16
        for <kvm@vger.kernel.org>; Wed, 30 Sep 2020 14:54:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gztZBGkRzVp8WHABoAlzTY5u2/3Xedlc1leDKo+CwFA=;
        b=BlqluPHaB07Fy6nRVJUuLgpJRIUByZw4Xuld9zHh0lsvzP2MeMxNqI5Z3NX0wDR6Pl
         ygQBahpLct6lPzIAROXd6rNnJEM1gRnB3LcbVSb+A82jH9EH84dEJ+qZW4vX5U0etpU4
         VzvWrNQEWnCeoeKUEJu655jCQuu2wzjlAyx36R+tBMaN348rYXY5H8g5ECwsX8nPuoys
         4vTGeGps7X9vW2awX2OoTpHSA8YeDquhEXYsf+9E7W/ikbsj4H68yn53n/EDlTmgmreS
         ex9d/G/12PsfbZiwYulx7TFjChwxpgKyx3AW/CBGBTmirBJOvjEu53Y1yo7JxQk4qv0M
         RI8w==
X-Gm-Message-State: AOAM530KH38noP0qTElJgHQogqc/9Xzvj6z1qiQfG3S+80VYFTPZqZ+3
        vkYwP4+6pDwc81l+LaSgZyjALve0VyZzz818yD6XELzffPEv9hvslpEljNoMfBgTP5YiP9a882+
        zWyhCNTwaL64O
X-Received: by 2002:ac8:3845:: with SMTP id r5mr4569369qtb.223.1601502875194;
        Wed, 30 Sep 2020 14:54:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPOXScD6l843W9QJYs/dVmI+c+0uBwzsiIKxQPyKljnuCbend6CH7peDDqRGj5nuDgH8MnGA==
X-Received: by 2002:ac8:3845:: with SMTP id r5mr4569354qtb.223.1601502874971;
        Wed, 30 Sep 2020 14:54:34 -0700 (PDT)
Received: from xz-x1.redhat.com (toroon474qw-lp130-09-184-147-14-204.dsl.bell.ca. [184.147.14.204])
        by smtp.gmail.com with ESMTPSA id s25sm4026348qtc.90.2020.09.30.14.54.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 14:54:34 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>, peterx@redhat.com
Subject: [PATCH v12 05/13] KVM: Make dirty ring exclusive to dirty bitmap log
Date:   Wed, 30 Sep 2020 17:54:33 -0400
Message-Id: <20200930215433.48004-1-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200930214948.47225-1-peterx@redhat.com>
References: <20200930214948.47225-1-peterx@redhat.com>
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
index f9d18f17bb0b..23f09b3717a6 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6309,3 +6309,10 @@ make sure all the existing dirty gfns are flushed to the dirty rings.
 
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
index 1f1da2ca907a..0574a9725727 100644
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

