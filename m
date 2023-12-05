Return-Path: <kvm+bounces-3502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B17A38050B2
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:39:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D6A0281998
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 10:39:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC0E256B67;
	Tue,  5 Dec 2023 10:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GYBDrTy+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179901BF4
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 02:38:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701772681;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gK4jXLoCS0bqGNjgQzNnw64KFoSSKVngg1q4fCtnDfA=;
	b=GYBDrTy+9aRpk28D9tNI/jr1ZfWEg3cqEcC98JL9Nkj2muRdyArJnKgZDMHsFTvHzPxXpK
	wGmLUZOQOhl9cEN+dxWDLTsHryeTIcXiFPt8RE+biDnNdVu8dcRC+hine3RdcxgjMy69xs
	lhzZwJafJsaysiW9k+NHuahn5PirP1I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-pUCADUVKOrqcI-bkOCOCOQ-1; Tue, 05 Dec 2023 05:37:58 -0500
X-MC-Unique: pUCADUVKOrqcI-bkOCOCOQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8BA6E85A589;
	Tue,  5 Dec 2023 10:37:57 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.45.225.152])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2217EC15E6A;
	Tue,  5 Dec 2023 10:37:54 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v4 3/4] KVM: x86: add information about pending requests to kvm_exit tracepoint
Date: Tue,  5 Dec 2023 12:37:44 +0200
Message-Id: <20231205103745.506724-4-mlevitsk@redhat.com>
In-Reply-To: <20231205103745.506724-1-mlevitsk@redhat.com>
References: <20231205103745.506724-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

This allows to gather information on how often kvm interrupts vCPUs due
to specific requests.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/trace.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 28e8a63368cc021..e275a02a21e5233 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -316,12 +316,14 @@ TRACE_EVENT(name,							     \
 		__field(	u32,	        intr_info	)	     \
 		__field(	u32,	        error_code	)	     \
 		__field(	unsigned int,	vcpu_id         )	     \
+		__field(	u64,		requests        )	     \
 	),								     \
 									     \
 	TP_fast_assign(							     \
 		__entry->guest_rip	= kvm_rip_read(vcpu);		     \
 		__entry->isa            = isa;				     \
 		__entry->vcpu_id        = vcpu->vcpu_id;		     \
+		__entry->requests       = READ_ONCE(vcpu->requests);	     \
 		static_call(kvm_x86_get_exit_info)(vcpu,		     \
 					  &__entry->exit_reason,	     \
 					  &__entry->info1,		     \
@@ -331,11 +333,13 @@ TRACE_EVENT(name,							     \
 	),								     \
 									     \
 	TP_printk("vcpu %u reason %s%s%s rip 0x%lx info1 0x%016llx "	     \
-		  "info2 0x%016llx intr_info 0x%08x error_code 0x%08x",	     \
+		  "info2 0x%016llx intr_info 0x%08x error_code 0x%08x "      \
+		  "requests 0x%016llx",					     \
 		  __entry->vcpu_id,					     \
 		  kvm_print_exit_reason(__entry->exit_reason, __entry->isa), \
 		  __entry->guest_rip, __entry->info1, __entry->info2,	     \
-		  __entry->intr_info, __entry->error_code)		     \
+		  __entry->intr_info, __entry->error_code, 		     \
+		  __entry->requests)					     \
 )
 
 /*
-- 
2.26.3


