Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 689C655358B
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 17:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352332AbiFUPJx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 11:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352312AbiFUPJp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 11:09:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 83AB228985
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 08:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655824182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NYiOoA3CHr2nOmHO8vU5aX4tOn3kv3w+htprdLNd+uI=;
        b=iNM0NVZxCgqzkjVjnMPFYG/Xi2n4EnkiTDX1NFqnsCE8y9nL2yAe1EeODCpVKOkPnqZ+kr
        3gDH0uYGNn7nEC77NhyiAanIZIRUpCNdStxjLjfU5pm4bjKJ13qbn7tpaq73AH6pxewYZF
        f3O/l2xmsC8zZ/N5jkv9OR5YrpCHBeE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-119-sBrtEnZDMfi6RFbwg89pdw-1; Tue, 21 Jun 2022 11:09:32 -0400
X-MC-Unique: sBrtEnZDMfi6RFbwg89pdw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 250BA1C08966;
        Tue, 21 Jun 2022 15:09:31 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A6D4610725;
        Tue, 21 Jun 2022 15:09:27 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 06/11] KVM: x86: emulator/smm: number of GPRs in the SMRAM image depends on the image format
Date:   Tue, 21 Jun 2022 18:08:57 +0300
Message-Id: <20220621150902.46126-7-mlevitsk@redhat.com>
In-Reply-To: <20220621150902.46126-1-mlevitsk@redhat.com>
References: <20220621150902.46126-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 64 bit host, if the guest doesn't have X86_FEATURE_LM, we would
access 16 gprs to 32-bit smram image, causing out-ouf-bound ram
access.

On 32 bit host, the rsm_load_state_64/enter_smm_save_state_64
is compiled out, thus access overflow can't happen.

Fixes: b443183a25ab61 ("KVM: x86: Reduce the number of emulator GPRs to '8' for 32-bit KVM")

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/emulate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 002687d17f9364..ce186aebca8e83 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2469,7 +2469,7 @@ static int rsm_load_state_32(struct x86_emulate_ctxt *ctxt,
 	ctxt->eflags =             GET_SMSTATE(u32, smstate, 0x7ff4) | X86_EFLAGS_FIXED;
 	ctxt->_eip =               GET_SMSTATE(u32, smstate, 0x7ff0);
 
-	for (i = 0; i < NR_EMULATOR_GPRS; i++)
+	for (i = 0; i < 8; i++)
 		*reg_write(ctxt, i) = GET_SMSTATE(u32, smstate, 0x7fd0 + i * 4);
 
 	val = GET_SMSTATE(u32, smstate, 0x7fcc);
@@ -2526,7 +2526,7 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
 	u16 selector;
 	int i, r;
 
-	for (i = 0; i < NR_EMULATOR_GPRS; i++)
+	for (i = 0; i < 16; i++)
 		*reg_write(ctxt, i) = GET_SMSTATE(u64, smstate, 0x7ff8 - i * 8);
 
 	ctxt->_eip   = GET_SMSTATE(u64, smstate, 0x7f78);
-- 
2.26.3

