Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50D027AC81C
	for <lists+kvm@lfdr.de>; Sun, 24 Sep 2023 14:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjIXMp7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Sep 2023 08:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjIXMp6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Sep 2023 08:45:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A120610C
        for <kvm@vger.kernel.org>; Sun, 24 Sep 2023 05:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695559468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=woWU04N+glUzD420ymk+4+G9vxtbf/gGrQWI0ejKWmM=;
        b=KnRbdZc3/qOH85KZW2wYDptW8TEKhbacmIRGUBkICZfQFuOGa3esmK7JNrsVl51BMAZkPn
        r4L4STxsgY00E3thcoUZZxKTrN02RrRZ7QoOh9/8iGABzcfXgh2c++TG5F6/AlQBPiXp9w
        F19ddJB40ogrlZ9JJ+AD31O+7gO9tsM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-RcpmpXc_Nr6f4ntLhMcivQ-1; Sun, 24 Sep 2023 08:44:23 -0400
X-MC-Unique: RcpmpXc_Nr6f4ntLhMcivQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C1EBA85A5A8;
        Sun, 24 Sep 2023 12:44:22 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.45.226.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 777B740C6EA8;
        Sun, 24 Sep 2023 12:44:20 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 3/4] KVM: x86: add more information to kvm_exit tracepoint
Date:   Sun, 24 Sep 2023 15:44:09 +0300
Message-Id: <20230924124410.897646-4-mlevitsk@redhat.com>
In-Reply-To: <20230924124410.897646-1-mlevitsk@redhat.com>
References: <20230924124410.897646-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

