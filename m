Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A62835B3582
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 12:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbiIIKpg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 06:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbiIIKpT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 06:45:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83724F69E
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 03:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662720316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eUVXlYDwK0/TqR7ADYfBnKPJM99YoNpijZnP7G2Z+Ds=;
        b=AZm8lDSX0eggR0U9ANhNfOwcLFcE4LNFQabalsoZ+7HzgKDAi2v1z4N1u+Y2z+ik4vDgBq
        hMGFnEPGOXyDM6Y5pGCU98LeltInCM70qPSXMB7WGTaw0a0vyaXRJmlcbYK8IbYLolg8mz
        3MdXIxrjsTt3SydTQd79sz59MGGtR6I=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-Jxe2dHiBOQ-FzA5qflBSeg-1; Fri, 09 Sep 2022 06:45:13 -0400
X-MC-Unique: Jxe2dHiBOQ-FzA5qflBSeg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EEA911C05AE6;
        Fri,  9 Sep 2022 10:45:12 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B5F740D282E;
        Fri,  9 Sep 2022 10:45:12 +0000 (UTC)
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
Subject: [RFC PATCH 8/9] kvm_main.c: find memslots from the inactive memslot list
Date:   Fri,  9 Sep 2022 06:45:05 -0400
Message-Id: <20220909104506.738478-9-eesposit@redhat.com>
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

Instead of looking at the active list, look at the inactive.
This causes no harm to the current code, as active and inactive
lists are identical at this point.

In addition, provide flexibility for atomic memslot
updates, because in that case we want to perform multiple
updates in the inactive list first, and then perform a single
swap only. If we were to use the active list, previous updates
that were not yet swapped won't be seen, and the following logic
in kvm_prepare_batch() could for example find an old memslot
that was deleted in the inactive but not in the active, thus
wrongly assuming that the coming request is a MOVE and not a CREATE.

Note that this also causes no harm to the invalidate memslot, since
we are already inserting it as replacement in both active and inactive
list.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 31e46f9a06fa..ecd43560281c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1948,7 +1948,7 @@ static int kvm_prepare_batch(struct kvm *kvm,
 	as_id = mem->slot >> 16;
 	id = (u16)mem->slot;
 
-	slots = __kvm_memslots(kvm, as_id);
+	slots = kvm_get_inactive_memslots(kvm, as_id);
 
 	/*
 	 * Note, the old memslot (and the pointer itself!) may be invalidated
-- 
2.31.1

