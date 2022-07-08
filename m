Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54E3B56BC32
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 17:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237057AbiGHOm4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 10:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238404AbiGHOmw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 10:42:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 298255722D
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 07:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657291368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NjkLB4A+R0viOg+bQbca/divUcEXpQYDgr2soMIUIog=;
        b=KUJPJmORNHIYfcJOE4gi7StykDm+A5qMZMPGvKYpDlHps6b24ZWBLU8XL7WSw56NPQ7h80
        w4JzetVeDd/AS1+bTMgd+EG4d15Yg0FFnmzSL2dH7fBMosKZxgBc4qrF6IvafSFV9SMgB5
        1GUoZ7itUvJVJLfVG111WYyyat2SfPY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-496-1jUklKVUPA6mkarAIlhF9g-1; Fri, 08 Jul 2022 10:42:44 -0400
X-MC-Unique: 1jUklKVUPA6mkarAIlhF9g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 16AA01C05AF1;
        Fri,  8 Jul 2022 14:42:44 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.193.250])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 41933403160;
        Fri,  8 Jul 2022 14:42:42 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 07/25] KVM: selftests: Add ENCLS_EXITING_BITMAP{,HIGH} VMCS fields
Date:   Fri,  8 Jul 2022 16:42:05 +0200
Message-Id: <20220708144223.610080-8-vkuznets@redhat.com>
In-Reply-To: <20220708144223.610080-1-vkuznets@redhat.com>
References: <20220708144223.610080-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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

