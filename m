Return-Path: <kvm+bounces-16871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A76BE8BE825
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:03:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7F8F4B284EC
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 16:01:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DF0216EC0F;
	Tue,  7 May 2024 15:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JrA+TRCA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A0216C44A
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 15:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715097508; cv=none; b=gmOrH5/VF+D8A6YD7hum8sc6wQPFMYmggi+umU3qkJIrDKq70ipsgw1uE3S02M4dU5BzWn1xOOM/MJ2sYfBGVaQj7lJe+BPWDYZeBfSqcYAKMU4cZoXvVCc9lyyrVcZIOFz/o5oK77RqfyHf0w8vNfsshcjfBTb4km8yfpBNW+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715097508; c=relaxed/simple;
	bh=VhDDefLstbHru7ZdZYPe2kSJKdJZTzVm7iepiZxsKjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BI5RdKq/tZ+KUOOem7dGmFSaVEwCodLbP/H3G5KYbneWE/blf11Vcs9axlpB4RQjCmnVx+IocKqkzzD6gAnfsRBK6XDocjx+Wel35Pmov0ZTOymZ7b2XU4H6D7eJXUG2r2o6xv26dALWBbR8gnFkkJR48vCidp5WMZUccKHhhvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JrA+TRCA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715097503;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PhSF5CLyMvZ9q5422nBduiCJ8agqIGSpdDou5cmGsPw=;
	b=JrA+TRCApKcA7V7MPWHLqb/mdv0q3+p493ReHsB6dq1Urvbx5cVX93OarDqVtfN1Pe0Xli
	qTwccOG6DbPkhQB+UziRakXnFJWe0XVGGRHGde8872Tg/VT1dgmU6Kw4SkHfE4npolT7Pv
	aZwnl/RAVl8AfQk1tFUNIkjxRjZ8rvA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-318-zk09axuqPlqCtT6mVwWP5A-1; Tue,
 07 May 2024 11:58:18 -0400
X-MC-Unique: zk09axuqPlqCtT6mVwWP5A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 786973C025D9;
	Tue,  7 May 2024 15:58:18 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5C641200B2F6;
	Tue,  7 May 2024 15:58:18 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>
Subject: [PATCH 03/17] KVM: x86: Define more SEV+ page fault error bits/flags for #NPF
Date: Tue,  7 May 2024 11:58:03 -0400
Message-ID: <20240507155817.3951344-4-pbonzini@redhat.com>
In-Reply-To: <20240507155817.3951344-1-pbonzini@redhat.com>
References: <20240507155817.3951344-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

From: Sean Christopherson <seanjc@google.com>

Define more #NPF error code flags that are relevant to SEV+ (mostly SNP)
guests, as specified by the APM:

 * Bit 31 (RMP):   Set to 1 if the fault was caused due to an RMP check or a
                   VMPL check failure, 0 otherwise.
 * Bit 34 (ENC):   Set to 1 if the guest’s effective C-bit was 1, 0 otherwise.
 * Bit 35 (SIZEM): Set to 1 if the fault was caused by a size mismatch between
                   PVALIDATE or RMPADJUST and the RMP, 0 otherwise.
 * Bit 36 (VMPL):  Set to 1 if the fault was caused by a VMPL permission
                   check failure, 0 otherwise.

Note, the APM is *extremely* misleading, and strongly implies that the
above flags can _only_ be set for #NPF exits from SNP guests.  That is a
lie, as bit 34 (C-bit=1, i.e. was encrypted) can be set when running _any_
flavor of SEV guest on SNP capable hardware.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20240228024147.41573-4-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a047480da5af..58bbcf76ad1e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -261,8 +261,12 @@ enum x86_intercept_stage;
 #define PFERR_FETCH_MASK	BIT(4)
 #define PFERR_PK_MASK		BIT(5)
 #define PFERR_SGX_MASK		BIT(15)
+#define PFERR_GUEST_RMP_MASK	BIT_ULL(31)
 #define PFERR_GUEST_FINAL_MASK	BIT_ULL(32)
 #define PFERR_GUEST_PAGE_MASK	BIT_ULL(33)
+#define PFERR_GUEST_ENC_MASK	BIT_ULL(34)
+#define PFERR_GUEST_SIZEM_MASK	BIT_ULL(35)
+#define PFERR_GUEST_VMPL_MASK	BIT_ULL(36)
 #define PFERR_IMPLICIT_ACCESS	BIT_ULL(48)
 
 #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
-- 
2.43.0



