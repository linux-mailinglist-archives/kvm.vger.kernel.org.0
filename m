Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33A2855356D
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 17:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352317AbiFUPJq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 11:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352298AbiFUPJo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 11:09:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5B5D027FF9
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 08:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655824175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iKMJAOMUnqojm6f+PSfvuxFpiYCb8Fg7PQ9tT8zsGYc=;
        b=agdHOcDXdDsuVs1HBLaD4OptKLURahy5LVCNfXByprGOQLowM5KgzNEJkjrmr6RaUKI+Ec
        Jld5KLOggigI3/QZbOJ46eMhs/Hmq4UydafJEpP3PY0nFbBYlGPn4UTcCaZEPCJusVoxT0
        xw2G+kFJgbcCjl9KIYjmx63OFTMb7+A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-445-WnP0U4rHOa-85xVkzuFcJw-1; Tue, 21 Jun 2022 11:09:28 -0400
X-MC-Unique: WnP0U4rHOa-85xVkzuFcJw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C0011044564;
        Tue, 21 Jun 2022 15:09:27 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9BEC818EA3;
        Tue, 21 Jun 2022 15:09:23 +0000 (UTC)
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
Subject: [PATCH v2 05/11] KVM: x86: emulator: update the emulation mode after CR0 write
Date:   Tue, 21 Jun 2022 18:08:56 +0300
Message-Id: <20220621150902.46126-6-mlevitsk@redhat.com>
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

CR0.PE toggles real/protected mode, thus its update
should update the emulation mode.

This is likely a benign bug because there is no writeback
of state, other than the RIP increment, and when toggling
CR0.PE, the CPU has to execute code from a very low memory address.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/emulate.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 6f4632babc4cd8..002687d17f9364 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3659,11 +3659,22 @@ static int em_movbe(struct x86_emulate_ctxt *ctxt)
 
 static int em_cr_write(struct x86_emulate_ctxt *ctxt)
 {
-	if (ctxt->ops->set_cr(ctxt, ctxt->modrm_reg, ctxt->src.val))
+	int cr_num = ctxt->modrm_reg;
+	int r;
+
+	if (ctxt->ops->set_cr(ctxt, cr_num, ctxt->src.val))
 		return emulate_gp(ctxt, 0);
 
 	/* Disable writeback. */
 	ctxt->dst.type = OP_NONE;
+
+	if (cr_num == 0) {
+		/* CR0 write might have updated CR0.PE */
+		r = update_emulation_mode(ctxt);
+		if (r != X86EMUL_CONTINUE)
+			return r;
+	}
+
 	return X86EMUL_CONTINUE;
 }
 
-- 
2.26.3

