Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA988553730
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 18:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353499AbiFUP7q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 11:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353631AbiFUP7B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 11:59:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0D4ABEB7
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 08:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655827140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NjkLB4A+R0viOg+bQbca/divUcEXpQYDgr2soMIUIog=;
        b=BaGsS6aTxhTp/x6XJe8+RKfZLxYmrXv5TdzWPmmpERNkGqRbhwQMFUhesxOMpvPjD7ZHH4
        4gDh3TigJyPDchusSBvfoJT7Z52838a025e/nBkcl4i7mbyBH5nCQzYTWWKvlblmev8/uk
        OZ18AX0CcRnLxI6vNc1yfSA7X0S2JGY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-a3PUNEvvNnGvPX_q0DnMlA-1; Tue, 21 Jun 2022 11:58:57 -0400
X-MC-Unique: a3PUNEvvNnGvPX_q0DnMlA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 54FD285A581;
        Tue, 21 Jun 2022 15:58:56 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 24A7C2026985;
        Tue, 21 Jun 2022 15:58:54 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/11] KVM: selftests: Add ENCLS_EXITING_BITMAP{,HIGH} VMCS fields
Date:   Tue, 21 Jun 2022 17:58:28 +0200
Message-Id: <20220621155830.60115-10-vkuznets@redhat.com>
In-Reply-To: <20220621155830.60115-1-vkuznets@redhat.com>
References: <20220621155830.60115-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The updated Enlightened VMCS definition has 'encls_exiting_bitmap'
field which needs mapping to VMCS, add the missing encoding.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/include/x86_64/vmx.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
index cc3604f8f1d3..5292d30fb7f2 100644
--- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
@@ -208,6 +208,8 @@ enum vmcs_field {
 	VMWRITE_BITMAP_HIGH		= 0x00002029,
 	XSS_EXIT_BITMAP			= 0x0000202C,
 	XSS_EXIT_BITMAP_HIGH		= 0x0000202D,
+	ENCLS_EXITING_BITMAP		= 0x0000202E,
+	ENCLS_EXITING_BITMAP_HIGH	= 0x0000202F,
 	TSC_MULTIPLIER			= 0x00002032,
 	TSC_MULTIPLIER_HIGH		= 0x00002033,
 	GUEST_PHYSICAL_ADDRESS		= 0x00002400,
-- 
2.35.3

