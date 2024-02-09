Return-Path: <kvm+bounces-8462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D576684FC03
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 19:38:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9367C28A06C
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 18:38:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F171383CBF;
	Fri,  9 Feb 2024 18:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L5qzxVwF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027D369959
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 18:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707503870; cv=none; b=SdQ0wV1hXUKnEaJH0uHojK8mEOs3vXyJAjl4EClMAA9xLrt7Bkk6dL1ZtbNd9NKgisOZgS5wcyGomlkL9ei5XAldY9y2VimR6O0fx7iMSkxwHCybWOr8LBHh8sO+YCeAWB8wraak1RWJ0aKYDJUwkHNB4i4HsqofwoSIkN203Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707503870; c=relaxed/simple;
	bh=RxLLfzATPd8CcL00JsXxdxAVXGNsjasSdMTb1hKqlkw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a4OTXFa66BNBfN2EqJU7c7YSmpN5rmYBsJP66iYX3VKfhmjeVXnFnGPIfMhnyTes/Uu4kZUFRdxzuXXqXfVNy1oaN+yhren+j4s20l6sjEKyxBXNqvdJn067gkrAOFpGdT4I7EFmMVsxWzNpMR7Mw0wPLAV/qKIUxQ7WUIoD63Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L5qzxVwF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707503868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JKkYDmGY73Td6rgzpl/wuBQjFppyMsRM8qHK/Ed+sVo=;
	b=L5qzxVwF9DLreAwy06WnFFLCL6VotQMRW5hXU/LycQYNQdJnFIg6CelK26iSFwnVLHM+1d
	CBCgoKisgtq/t8pT5hWLZx+EHvS06T/RUm88mIjeE/BabKdHFolLxasIlEfWup41E7+6Gk
	r0kLnAxwCacBtKNjn0q5HidYJ/kGO+0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-473-IZfBK3ZGPgeFnIlnfZE0gg-1; Fri, 09 Feb 2024 13:37:44 -0500
X-MC-Unique: IZfBK3ZGPgeFnIlnfZE0gg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 265B584F9D2;
	Fri,  9 Feb 2024 18:37:44 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EC9CC492BC6;
	Fri,  9 Feb 2024 18:37:43 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	aik@amd.com,
	isaku.yamahata@intel.com
Subject: [PATCH 01/10] KVM: SEV: fix compat ABI for KVM_MEMORY_ENCRYPT_OP
Date: Fri,  9 Feb 2024 13:37:33 -0500
Message-Id: <20240209183743.22030-2-pbonzini@redhat.com>
In-Reply-To: <20240209183743.22030-1-pbonzini@redhat.com>
References: <20240209183743.22030-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

The data structs for KVM_MEMORY_ENCRYPT_OP have different sizes for 32- and 64-bit
kernels, but they do not make any attempt to convert from one ABI to the other.
Fix this by adding the appropriate padding.

No functional change intended for 64-bit userspace.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/uapi/asm/kvm.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 0ad6bda1fc39..b305daff056e 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -687,6 +687,7 @@ enum sev_cmd_id {
 
 struct kvm_sev_cmd {
 	__u32 id;
+	__u32 pad0;
 	__u64 data;
 	__u32 error;
 	__u32 sev_fd;
@@ -697,28 +698,35 @@ struct kvm_sev_launch_start {
 	__u32 policy;
 	__u64 dh_uaddr;
 	__u32 dh_len;
+	__u32 pad0;
 	__u64 session_uaddr;
 	__u32 session_len;
+	__u32 pad1;
 };
 
 struct kvm_sev_launch_update_data {
 	__u64 uaddr;
 	__u32 len;
+	__u32 pad0;
 };
 
 
 struct kvm_sev_launch_secret {
 	__u64 hdr_uaddr;
 	__u32 hdr_len;
+	__u32 pad0;
 	__u64 guest_uaddr;
 	__u32 guest_len;
+	__u32 pad1;
 	__u64 trans_uaddr;
 	__u32 trans_len;
+	__u32 pad2;
 };
 
 struct kvm_sev_launch_measure {
 	__u64 uaddr;
 	__u32 len;
+	__u32 pad0;
 };
 
 struct kvm_sev_guest_status {
@@ -731,33 +739,43 @@ struct kvm_sev_dbg {
 	__u64 src_uaddr;
 	__u64 dst_uaddr;
 	__u32 len;
+	__u32 pad0;
 };
 
 struct kvm_sev_attestation_report {
 	__u8 mnonce[16];
 	__u64 uaddr;
 	__u32 len;
+	__u32 pad0;
 };
 
 struct kvm_sev_send_start {
 	__u32 policy;
+	__u32 pad0;
 	__u64 pdh_cert_uaddr;
 	__u32 pdh_cert_len;
+	__u32 pad1;
 	__u64 plat_certs_uaddr;
 	__u32 plat_certs_len;
+	__u32 pad2;
 	__u64 amd_certs_uaddr;
 	__u32 amd_certs_len;
+	__u32 pad3;
 	__u64 session_uaddr;
 	__u32 session_len;
+	__u32 pad4;
 };
 
 struct kvm_sev_send_update_data {
 	__u64 hdr_uaddr;
 	__u32 hdr_len;
+	__u32 pad0;
 	__u64 guest_uaddr;
 	__u32 guest_len;
+	__u32 pad1;
 	__u64 trans_uaddr;
 	__u32 trans_len;
+	__u32 pad2;
 };
 
 struct kvm_sev_receive_start {
@@ -765,17 +783,22 @@ struct kvm_sev_receive_start {
 	__u32 policy;
 	__u64 pdh_uaddr;
 	__u32 pdh_len;
+	__u32 pad0;
 	__u64 session_uaddr;
 	__u32 session_len;
+	__u32 pad1;
 };
 
 struct kvm_sev_receive_update_data {
 	__u64 hdr_uaddr;
 	__u32 hdr_len;
+	__u32 pad0;
 	__u64 guest_uaddr;
 	__u32 guest_len;
+	__u32 pad1;
 	__u64 trans_uaddr;
 	__u32 trans_len;
+	__u32 pad2;
 };
 
 #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
-- 
2.39.0



