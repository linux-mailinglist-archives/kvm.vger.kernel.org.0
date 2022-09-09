Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4E385B357A
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 12:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbiIIKpm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 06:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbiIIKpT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 06:45:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA8C5005E
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 03:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662720317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c0NgkoxjaxWZzPMna+r8g36cHTkfcmxMVnLk3I8tBk0=;
        b=PfJGHivym1xzIz2AjYjnhBL9e8CORwAur1pK6zV4nEvI21x1lpfukiv58gFvK8f1MO7f5T
        uZt3GO1q3G4Ww7DsyZ2RAH2mh73nifwHOYgVTyVgNcxJCsXdbZtJFLcsS+hTwK/S2NJwCJ
        jepm8tGeldt7Z2WyX/odgRBT3/0JgFw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-MkxgwddvMM-9vnd2TjolAQ-1; Fri, 09 Sep 2022 06:45:13 -0400
X-MC-Unique: MkxgwddvMM-9vnd2TjolAQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 52A2C101A56C;
        Fri,  9 Sep 2022 10:45:12 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E512E40D282E;
        Fri,  9 Sep 2022 10:45:11 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [RFC PATCH 7/9] kvm_main.c: duplicate invalid memslot also in inactive list
Date:   Fri,  9 Sep 2022 06:45:04 -0400
Message-Id: <20220909104506.738478-8-eesposit@redhat.com>
In-Reply-To: <20220909104506.738478-1-eesposit@redhat.com>
References: <20220909104506.738478-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation for atomic memslot updates, make sure the
invalid memslot is also replacing the old one in the inactive list.

This implies that once we want to insert the new slot for a MOVE,
or simply delete the existing one for a DELETE,
we need to remove the "invalid" slot, not the "old" one.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 virt/kvm/kvm_main.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6b73615891f0..31e46f9a06fa 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1830,6 +1830,7 @@ static int kvm_prepare_memslot(struct kvm *kvm,
 		}
 		batch->invalid = invalid_slot;
 		kvm_invalidate_memslot(kvm, old, invalid_slot);
+		kvm_replace_memslot(kvm, old, invalid_slot);
 	}
 
 	r = kvm_prepare_memory_region(kvm, batch);
@@ -1900,10 +1901,14 @@ static int kvm_set_memslot(struct kvm *kvm,
 		return r;
 
 	/*
-	 * if change is DELETE or MOVE, invalid is in active memslots
-	 * and old in inactive, so replace old with new.
+	 * if change is DELETE or MOVE, invalid is in both active and inactive
+	 * memslot list. This means that we don't need old anymore, and
+	 * we should replace invalid with new.
 	 */
-	kvm_replace_memslot(kvm, batch->old, batch->new);
+	if (batch->change == KVM_MR_DELETE || batch->change == KVM_MR_MOVE)
+		kvm_replace_memslot(kvm, batch->invalid, batch->new);
+	else
+		kvm_replace_memslot(kvm, batch->old, batch->new);
 
 	/* either old or invalid is the same, since invalid is old's copy */
 	as_id = kvm_memslots_get_as_id(batch->old, batch->new);
-- 
2.31.1

