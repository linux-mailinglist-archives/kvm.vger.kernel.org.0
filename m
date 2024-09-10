Return-Path: <kvm+bounces-26341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F271B9743D7
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:04:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A6E961F27CD2
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 20:04:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E4341A7076;
	Tue, 10 Sep 2024 20:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ghNoMVEb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C831AAE2C
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 20:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725998647; cv=none; b=gtKBVLz2z1R+2S7Eu/6OeqeCeMirRJqPcAXrhg3QYxo+FmLiAsZuXySFwoxFEJGQ4WyBc1LxhuiALV1NbNmeJovNwK8OTj6ctSdv1wWXfv8RFhhoFNJhz68sBZ1NYsU4jdDrK6iNCCJo84jgb+QlsKqW8b9x0YE8VuG/Hc7GcRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725998647; c=relaxed/simple;
	bh=LUyHOVPypjlR84RYyqJQSGlbhbD0ZpeGF01uBNTLrI0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dKp+W6C9WH5uYP6zV3+n5MdroonkOr+smwT66XUWaVEHoSHz97YbOF7wT2ThRQSiknk+LY7zEPLKAMe5/ahPkKbE25mic3abv3vnslUCCRGjngham1OPcK3GPGA/2LEuZRGJWdNU398hblIGmaVUs1nUeoJY8x4sn9EL/frJl+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ghNoMVEb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725998644;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ODrX+ASCtmtGCl0uByVc2NPs4XHLuXOI/zGjtysfC8o=;
	b=ghNoMVEb25ikEeLLT8Ihk3LCL7R7FDo7Yxmwwlh4cErQ/SVNaaTflssMT0JWdm+rWVj19F
	1lGbeiXB+V/PEQklmdWXMAju+TaKI2gC/FPyQOlm3WRk/wJcqB/bivWPuLOQZ/N+RQxYos
	r50s/4SsJmkjN4uO+yMQmq14WE3h2a0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-141-OpUMxQ4EO-mLYVErOoghOg-1; Tue,
 10 Sep 2024 16:04:02 -0400
X-MC-Unique: OpUMxQ4EO-mLYVErOoghOg-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 06CA319560AB;
	Tue, 10 Sep 2024 20:04:00 +0000 (UTC)
Received: from starship.lan (unknown [10.22.64.235])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7442F1956086;
	Tue, 10 Sep 2024 20:03:57 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: x86@kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ingo Molnar <mingo@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v5 2/3] KVM: x86: add information about pending requests to kvm_exit tracepoint
Date: Tue, 10 Sep 2024 16:03:49 -0400
Message-Id: <20240910200350.264245-3-mlevitsk@redhat.com>
In-Reply-To: <20240910200350.264245-1-mlevitsk@redhat.com>
References: <20240910200350.264245-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

This allows to gather information on how often kvm interrupts vCPUs due
to specific requests.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/trace.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index b4c014b1aa9a1..5a5b7757e8456 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -319,12 +319,14 @@ TRACE_EVENT(name,							     \
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
 		kvm_x86_call(get_exit_info)(vcpu,			     \
 					    &__entry->exit_reason,	     \
 					    &__entry->info1,		     \
@@ -334,11 +336,13 @@ TRACE_EVENT(name,							     \
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


