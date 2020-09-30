Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9EC527F46B
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 23:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731107AbgI3VuH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 17:50:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47161 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731043AbgI3Vt7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Sep 2020 17:49:59 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601502598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nSk3L+lLkvPp2zEMzy7lJYZ9nOSi7WB6jupEA1yhNZY=;
        b=CQtJ2ersi3Lh6L47V5iH9XEgZ1Q5sIW2i6AMtzx0J5Kfn5CAwcA0FKJ1Pt6vvuTVVFROyo
        BHFcukcoBWBPXn56jy5IvkIpx1OUvyGhRjucb5kPf2Xq62S5IR2iKD4ORqb1MKH3ey6uI2
        Y3eoybYGgx+2nMq7mzkRi/eqXUVb7Ak=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-4A61YYKzPJeYXBhxrlat5w-1; Wed, 30 Sep 2020 17:49:53 -0400
X-MC-Unique: 4A61YYKzPJeYXBhxrlat5w-1
Received: by mail-qt1-f200.google.com with SMTP id l5so2190586qtu.20
        for <kvm@vger.kernel.org>; Wed, 30 Sep 2020 14:49:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nSk3L+lLkvPp2zEMzy7lJYZ9nOSi7WB6jupEA1yhNZY=;
        b=ONqK+1vM5gHKxGa4pWpHImH9K2KcMR/E5E+Uz/5WM7rMwY816EeqvkGPJNeJTqIQFB
         KOd1HB/dyqVeX8NxtjxeuZjgdZmvQDryy4q0z/tB+xdaV3T2VXrQNWGZ6nbDsUaux2ro
         CuxjsG+W4uxAX69IRg/4Z+qgiNybyafol4m3VxJ+DOP0JG1/iF3ld64CQOWqXsW49sPi
         RrppLUGUut3J+oJWQ8HKRQL3b1BeRp3pCTkVTMk0287ps1OvXPheP2MDOUJ1AcuYe6a9
         YZ2lTNJq4b7P2qDWIO/nhcEdkVUsHQuRGk5KxBmiMAaJ8S1Q/daUDQ8sMD9lZ+NR0hKV
         NoQQ==
X-Gm-Message-State: AOAM533TcLzxVT+75zIGXhmoBgouMgBRqSV/HYJ2uBJ9A7zoEb5BrrUM
        2HEqME/BSyscIqmwAV13B/Zg5Bx3I3MFMs6SkVE5NIpNEa+OA+Nr+NO8BXJFBws/uJFDBBqfUHF
        tt5Es9QgqzXWO
X-Received: by 2002:a05:620a:159b:: with SMTP id d27mr4736272qkk.28.1601502592577;
        Wed, 30 Sep 2020 14:49:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx6fbIGQaF1ah2COu5uu8NtppdFGpVXdoA4I6mTDTmKqVzv97JX+7YzZ+hePeH4V5AzWCYw9g==
X-Received: by 2002:a05:620a:159b:: with SMTP id d27mr4736253qkk.28.1601502592365;
        Wed, 30 Sep 2020 14:49:52 -0700 (PDT)
Received: from xz-x1.redhat.com (toroon474qw-lp130-09-184-147-14-204.dsl.bell.ca. [184.147.14.204])
        by smtp.gmail.com with ESMTPSA id j88sm3786165qte.96.2020.09.30.14.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 14:49:51 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     "Dr . David Alan Gilbert" <dgilbert@redhat.com>, peterx@redhat.com,
        Andrew Jones <drjones@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v12 01/13] KVM: Cache as_id in kvm_memory_slot
Date:   Wed, 30 Sep 2020 17:49:36 -0400
Message-Id: <20200930214948.47225-2-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200930214948.47225-1-peterx@redhat.com>
References: <20200930214948.47225-1-peterx@redhat.com>
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
index cf88233b819a..64228366bf9d 100644
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

