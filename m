Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C247251688D
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 00:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378144AbiEAWM0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 May 2022 18:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378529AbiEAWMM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 May 2022 18:12:12 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227265E756;
        Sun,  1 May 2022 15:08:33 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nlHjs-0008OZ-Jp; Mon, 02 May 2022 00:08:24 +0200
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 08/12] KVM: x86: Print error code in exception injection tracepoint iff valid
Date:   Mon,  2 May 2022 00:07:32 +0200
Message-Id: <e8f0511733ed2a0410cbee8a0a7388eac2ee5bac.1651440202.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1651440202.git.maciej.szmigiero@oracle.com>
References: <cover.1651440202.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Print the error code in the exception injection tracepoint if and only if
the exception has an error code.  Define the entire error code sequence
as a set of formatted strings, print empty strings if there's no error
code, and abuse __print_symbolic() by passing it an empty array to coerce
it into printing the error code as a hex string.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 arch/x86/kvm/trace.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index d07428e660e3..385436d12024 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -376,10 +376,11 @@ TRACE_EVENT(kvm_inj_exception,
 		__entry->reinjected	= reinjected;
 	),
 
-	TP_printk("%s (0x%x)%s",
+	TP_printk("%s%s%s%s%s",
 		  __print_symbolic(__entry->exception, kvm_trace_sym_exc),
-		  /* FIXME: don't print error_code if not present */
-		  __entry->has_error ? __entry->error_code : 0,
+		  !__entry->has_error ? "" : " (",
+		  !__entry->has_error ? "" : __print_symbolic(__entry->error_code, { }),
+		  !__entry->has_error ? "" : ")",
 		  __entry->reinjected ? " [reinjected]" : "")
 );
 
