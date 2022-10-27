Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A75560FCDF
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 18:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236687AbiJ0QTb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 12:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236575AbiJ0QTB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 12:19:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E36C196B7A
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 09:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666887536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+cor0KkOwTJItYQfjwJp6M8Gzu8KNstW05/3cHmtpUg=;
        b=GujaRbwDPn39Xig8DrPWRTezKZjhDT+g1bNPrJ2me77U/AZj3+zlcCPOAf1Z8pCtrRNZEr
        dSL46XJjbHnSZPEkN416hlXxElYPRR9bnpONwGjdV2d8zYXi52uaMBmikSDkuHdugeAyHg
        k4fY/1sKkjfp6i5zMGrvQzEpJkXbLBQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-380-hzHo1hAyNE6NbZsqvCRP6Q-1; Thu, 27 Oct 2022 12:18:53 -0400
X-MC-Unique: hzHo1hAyNE6NbZsqvCRP6Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E30D2185A7A3;
        Thu, 27 Oct 2022 16:18:52 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C223017593;
        Thu, 27 Oct 2022 16:18:52 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mhal@rbox.co, seanjc@google.com
Subject: [PATCH 14/16] KVM: Skip unnecessary "unmap" if gpc is already valid during refresh
Date:   Thu, 27 Oct 2022 12:18:47 -0400
Message-Id: <20221027161849.2989332-15-pbonzini@redhat.com>
In-Reply-To: <20221027161849.2989332-1-pbonzini@redhat.com>
References: <20221027161849.2989332-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        PP_MIME_FAKE_ASCII_TEXT,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

When refreshing a gfn=>pfn cache, skip straight to unlocking if the cache
already valid instead of stuffing the "old" variables to turn the
unmapping outro into a nop.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20221013211234.1318131-15-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/pfncache.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 68e2e53eac8a..b408a4b81e74 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -295,9 +295,8 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 		ret = hva_to_pfn_retry(gpc);
 	} else {
 		/* If the HVA→PFN mapping was already valid, don't unmap it. */
-		old_pfn = KVM_PFN_ERR_FAULT;
-		old_khva = NULL;
 		ret = 0;
+		goto out_unlock;
 	}
 
  out:
-- 
2.31.1


