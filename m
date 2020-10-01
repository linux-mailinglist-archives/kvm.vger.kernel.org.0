Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B55C827F71E
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 03:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730269AbgJABVC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 21:21:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55438 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725892AbgJABU7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Sep 2020 21:20:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601515258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6xHjUrHigWna5Zg5F0+gVJTiR0rRWsZLLLTG4Bqd1lY=;
        b=GXSW9TOOi9+hMARBvqrAwSKESAO6R3aQtaHhJy8yQ9CgdQFYcqj+r45ptGrXs7PnlOfADZ
        4eqsM64Ouk00WHiOn+emsM8Rsjdl6Z85pVo3nJj7MwDAemwq6S9+I2BaZH5RC8fP6DxjOn
        l+YWWhwN5L9v0GPucXOFpAfVUT7IMxw=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-2FjUoYE5N-S2zGvBvvgVDA-1; Wed, 30 Sep 2020 21:20:53 -0400
X-MC-Unique: 2FjUoYE5N-S2zGvBvvgVDA-1
Received: by mail-qk1-f199.google.com with SMTP id u23so2092058qku.17
        for <kvm@vger.kernel.org>; Wed, 30 Sep 2020 18:20:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6xHjUrHigWna5Zg5F0+gVJTiR0rRWsZLLLTG4Bqd1lY=;
        b=RdutEyZTlqkQPVNU7TGlp0dIsvd/7iHubri5V62Rdllbcy6ZXWTXPw8ksusbWuZuEL
         hKGUuyp9HAzQLB8wTa+ic3codL4CmrZ6ZrWow+Y+mVZjIlTmmK/s5/llxWh9t+nCDkhy
         1qhKmU8lWVaAyZrY4bqUpEPw0v9G6nlqo1RfDPmbu30mTCR+JkQSizag3zqBoZ1ZfXwS
         8i2sY3q1AFylWssx86oVwMjExtmwKeAT7Kskfwn+0EwIeFbpbwvafIBNoJg8JbwlJ9lN
         08HVTsbj45/eo3K7SjhDnr1F74n3OujWvPKaGL/yeD/mfLd94f0wH6xi/d58oKjPw/c0
         eg2A==
X-Gm-Message-State: AOAM530H3cX46PC5vNYPZTPchyhLN6sPbdOW1HC7yT43KSV5am/83c2e
        xD0oaCS42WBWmfeZC6gX48bIpeS/k6RpCz3u+emHHp1QmBvfiNRy6HGQn3NHY5xVb9odsz+rZzE
        KIVt1XG4CnbSW
X-Received: by 2002:a37:a483:: with SMTP id n125mr5483377qke.286.1601515252154;
        Wed, 30 Sep 2020 18:20:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwurgRzfPHvDcH9Lh9BPj9wXhHy0NxpZ4EZVEfDuquEWRGCTNjHu1TV/ye9RUStI4Woh0Z6iQ==
X-Received: by 2002:a37:a483:: with SMTP id n125mr5483347qke.286.1601515251752;
        Wed, 30 Sep 2020 18:20:51 -0700 (PDT)
Received: from localhost.localdomain (toroon474qw-lp130-09-184-147-14-204.dsl.bell.ca. [184.147.14.204])
        by smtp.gmail.com with ESMTPSA id y46sm4714478qtc.30.2020.09.30.18.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 18:20:51 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterx@redhat.com, "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v13 02/14] KVM: Cache as_id in kvm_memory_slot
Date:   Wed, 30 Sep 2020 21:20:32 -0400
Message-Id: <20201001012044.5151-3-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001012044.5151-1-peterx@redhat.com>
References: <20201001012044.5151-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cache the address space ID just like the slot ID.  It will be used in
order to fill in the dirty ring entries.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 include/linux/kvm_host.h | 1 +
 virt/kvm/kvm_main.c      | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 05e3c2fb3ef7..c6f45687ba89 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -346,6 +346,7 @@ struct kvm_memory_slot {
 	unsigned long userspace_addr;
 	u32 flags;
 	short id;
+	u16 as_id;
 };
 
 static inline unsigned long kvm_dirty_bitmap_bytes(struct kvm_memory_slot *memslot)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 68edd25dcb11..2e8539213125 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1247,6 +1247,11 @@ static int kvm_delete_memslot(struct kvm *kvm,
 
 	memset(&new, 0, sizeof(new));
 	new.id = old->id;
+	/*
+	 * This is only for debugging purpose; it should never be referenced
+	 * for a removed memslot.
+	 */
+	new.as_id = as_id;
 
 	r = kvm_set_memslot(kvm, mem, old, &new, as_id, KVM_MR_DELETE);
 	if (r)
@@ -1313,6 +1318,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (!mem->memory_size)
 		return kvm_delete_memslot(kvm, mem, &old, as_id);
 
+	new.as_id = as_id;
 	new.id = id;
 	new.base_gfn = mem->guest_phys_addr >> PAGE_SHIFT;
 	new.npages = mem->memory_size >> PAGE_SHIFT;
-- 
2.26.2

