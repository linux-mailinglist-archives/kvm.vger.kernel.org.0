Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E26578D966
	for <lists+kvm@lfdr.de>; Wed, 30 Aug 2023 20:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237059AbjH3SdD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Aug 2023 14:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244201AbjH3Mo2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Aug 2023 08:44:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181E7CDA
        for <kvm@vger.kernel.org>; Wed, 30 Aug 2023 05:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693399382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=woWU04N+glUzD420ymk+4+G9vxtbf/gGrQWI0ejKWmM=;
        b=Qd9KWMU74M4LEi1UbERFh3n1U/aBoTZUNwZH1iyElXHxlzH4VllVVcsD9DquCslNsq8L9K
        bWLQ/Ume0xSWrR17uMLpvYSg/2rimbRq8a3IGUyshz0K1Fpg5iKgpiVAdcjVc7pmICFlX1
        lIcnsBZUjZE/j+fWRtQDxnPgRhsI+nQ=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-442-tEX4fSVcNq-3tP4VwYPVwQ-1; Wed, 30 Aug 2023 08:42:57 -0400
X-MC-Unique: tEX4fSVcNq-3tP4VwYPVwQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 793751C0E4C4;
        Wed, 30 Aug 2023 12:42:56 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.45.224.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F98E2026D35;
        Wed, 30 Aug 2023 12:42:53 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 3/4] KVM: x86: add more information to kvm_exit tracepoint
Date:   Wed, 30 Aug 2023 15:42:42 +0300
Message-Id: <20230830124243.671152-4-mlevitsk@redhat.com>
In-Reply-To: <20230830124243.671152-1-mlevitsk@redhat.com>
References: <20230830124243.671152-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add:
  - Flag that shows that the VM is in guest mode
  - Bitmap of pending kvm requests.
  - Flag showing that this VM exit is due to request to have
    an immediate VM exit.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/trace.h | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index f4c56f59f5c11b..0657a3a348b4ae 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -320,12 +320,18 @@ TRACE_EVENT(name,							     \
 		__field(	u32,	        intr_info	)	     \
 		__field(	u32,	        error_code	)	     \
 		__field(	unsigned int,	vcpu_id         )	     \
+		__field(	bool,		guest_mode      )	     \
+		__field(	u64,		requests        )	     \
+		__field(	bool,		req_imm_exit	)	     \
 	),								     \
 									     \
 	TP_fast_assign(							     \
 		__entry->guest_rip	= kvm_rip_read(vcpu);		     \
 		__entry->isa            = isa;				     \
 		__entry->vcpu_id        = vcpu->vcpu_id;		     \
+		__entry->guest_mode     = is_guest_mode(vcpu);		     \
+		__entry->requests       = READ_ONCE(vcpu->requests);	     \
+		__entry->req_imm_exit   = vcpu->arch.req_immediate_exit;     \
 		static_call(kvm_x86_get_exit_info)(vcpu,		     \
 					  &__entry->exit_reason,	     \
 					  &__entry->info1,		     \
@@ -335,11 +341,15 @@ TRACE_EVENT(name,							     \
 	),								     \
 									     \
 	TP_printk("vcpu %u reason %s%s%s rip 0x%lx info1 0x%016llx "	     \
-		  "info2 0x%016llx intr_info 0x%08x error_code 0x%08x",	     \
+		  "info2 0x%016llx intr_info 0x%08x error_code 0x%08x "      \
+		  "requests 0x%016llx%s%s",				     \
 		  __entry->vcpu_id,					     \
 		  kvm_print_exit_reason(__entry->exit_reason, __entry->isa), \
 		  __entry->guest_rip, __entry->info1, __entry->info2,	     \
-		  __entry->intr_info, __entry->error_code)		     \
+		  __entry->intr_info, __entry->error_code, 		     \
+		  __entry->requests,					     \
+		  __entry->guest_mode ? " [guest]" : "",		     \
+		  __entry->req_imm_exit ? " [imm exit]" : "")		     \
 )
 
 /*
-- 
2.26.3

