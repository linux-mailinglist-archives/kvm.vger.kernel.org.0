Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8F74BE3A6
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380242AbiBUQXV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 11:23:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380208AbiBUQXP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 11:23:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB5F627149
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 08:22:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645460570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cbki0TF8g05gfWmutcV9pyLiWp15y56GQBu92FXt0z8=;
        b=czEwyqMvjIuvx1pQP071kdIzQfMM1+XR2xGvXvleaiCE74orNgbigupQkV0OTTgB46N1aq
        hjqBeEqPe6NWK/RWMjETKLKw9vDNrVGVKnHjtLPrW96zhTzXANR+DU+sEBLNfgo2uos4f4
        KZDvGlElYvLLR7Q+LM1Wwon9i6xWFRg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-sLvUIf3KNZO8i1GSpRjT5w-1; Mon, 21 Feb 2022 11:22:47 -0500
X-MC-Unique: sLvUIf3KNZO8i1GSpRjT5w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 65A482F4C;
        Mon, 21 Feb 2022 16:22:46 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0923177477;
        Mon, 21 Feb 2022 16:22:45 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v2 05/25] KVM: x86/mmu: rephrase unclear comment
Date:   Mon, 21 Feb 2022 11:22:23 -0500
Message-Id: <20220221162243.683208-6-pbonzini@redhat.com>
In-Reply-To: <20220221162243.683208-1-pbonzini@redhat.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If accessed bits are not supported there simple isn't any distinction
between accessed and non-accessed gPTEs, so the comment does not make
much sense.  Rephrase it in terms of what happens if accessed bits
*are* supported.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 80b4b291002a..d1d17d28e81b 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -193,7 +193,7 @@ static bool FNAME(prefetch_invalid_gpte)(struct kvm_vcpu *vcpu,
 	if (!FNAME(is_present_gpte)(gpte))
 		goto no_present;
 
-	/* if accessed bit is not supported prefetch non accessed gpte */
+	/* if accessed bit is supported, prefetch only accessed gpte */
 	if (PT_HAVE_ACCESSED_DIRTY(vcpu->arch.mmu) &&
 	    !(gpte & PT_GUEST_ACCESSED_MASK))
 		goto no_present;
-- 
2.31.1


