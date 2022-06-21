Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3C2C553542
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 17:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352250AbiFUPJZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 11:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233490AbiFUPJR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 11:09:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A84D91AD98
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 08:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655824155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dt+3U31rFRFWtq9wFVO0GaPK9O5t7emZ4zDQ3ZmYMBI=;
        b=giiFJWcNIPCNblRVtagScZo8I5ho5jYzYjKCPD7vfsxhDb+quqGKK38xi0UyoD343Z25BM
        v8N9qaErHdu4JLoUIQV2I4a4wWk8TnwzICWp+SKrEswE9sYBcXWJDyDro4MypFNXqS9OK+
        U2q+ZTnI3l6K2+Nny1Lrqfpk13+Gy/4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-551-yPq1Mh0SO8mkg_Sz9t-l6Q-1; Tue, 21 Jun 2022 11:09:12 -0400
X-MC-Unique: yPq1Mh0SO8mkg_Sz9t-l6Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ACB963815D2B;
        Tue, 21 Jun 2022 15:09:11 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B9A09D7F;
        Tue, 21 Jun 2022 15:09:08 +0000 (UTC)
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
Subject: [PATCH v2 01/11] KVM: x86: emulator: em_sysexit should update ctxt->mode
Date:   Tue, 21 Jun 2022 18:08:52 +0300
Message-Id: <20220621150902.46126-2-mlevitsk@redhat.com>
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

This is one of the instructions that can change the
processor mode.

Note that this is likely a benign bug, because the only problematic
mode change is from 32 bit to 64 bit which can lead to truncation of RIP,
and it is not possible to do with sysexit,
since sysexit running in 32 bit mode will be limited to 32 bit version.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/emulate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 39ea9138224c62..5aeb343ca8b007 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2888,6 +2888,7 @@ static int em_sysexit(struct x86_emulate_ctxt *ctxt)
 	ops->set_segment(ctxt, ss_sel, &ss, 0, VCPU_SREG_SS);
 
 	ctxt->_eip = rdx;
+	ctxt->mode = usermode;
 	*reg_write(ctxt, VCPU_REGS_RSP) = rcx;
 
 	return X86EMUL_CONTINUE;
-- 
2.26.3

