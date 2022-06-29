Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27B61560401
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 17:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234275AbiF2PLx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 11:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233986AbiF2PLh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 11:11:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CAD2C3DDF2
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 08:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656515370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NjkLB4A+R0viOg+bQbca/divUcEXpQYDgr2soMIUIog=;
        b=i/7QU7C5SWitEvwV09adGLfgvc/bJaX6opOoT8wCK74/54zljD9D7McWxnb37q1wP4ZuHG
        D2FomiWrJz87YNRUwQy8cY2KstbXuyYsWSOk2w17kWc/07BCA1+bM1ui8FutNiscDyoitp
        7BNzZBS4adsq32K0pPT6bXqh59rHrs4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-303-qdZUodd2N8-RyZilk_Wp2w-1; Wed, 29 Jun 2022 11:06:52 -0400
X-MC-Unique: qdZUodd2N8-RyZilk_Wp2w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E44733C10698;
        Wed, 29 Jun 2022 15:06:49 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6EBFD40EC002;
        Wed, 29 Jun 2022 15:06:47 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 09/28] KVM: selftests: Add ENCLS_EXITING_BITMAP{,HIGH} VMCS fields
Date:   Wed, 29 Jun 2022 17:06:06 +0200
Message-Id: <20220629150625.238286-10-vkuznets@redhat.com>
In-Reply-To: <20220629150625.238286-1-vkuznets@redhat.com>
References: <20220629150625.238286-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

