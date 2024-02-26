Return-Path: <kvm+bounces-9969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 08A8986805A
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 20:03:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 393291C25291
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 19:03:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A86312F5A2;
	Mon, 26 Feb 2024 19:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hc9frAMK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2A012DDAB
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 19:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708974230; cv=none; b=Yt+4JDCIYVwfWADcg77tuK/4VRg9pyF9ACc5UupmFiVIIOBppqAsIfNWPY9BBUmgYLL04sveVkSHCDSPnULz86lVMym4wDVXUTNbk0QKuxlFJJ56MQYgosYSlTmNPXn0GzoLzBWTpyDqDya3B3P6hj0UC3zopQ0h0+n/2szuOa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708974230; c=relaxed/simple;
	bh=JP2AhCp0qhW1Bb/uQ0B1c8bqZUtYcKr6siTzy/oGLZg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DV3XJvyPKDZROKWil9kW/NtOsLNsK77Oc3grDc2E5h71sjfxxOVhx141O8UJhPyJfhDcrg0akuGdOKDNKVAIstuvpuZ/q8fwwEGspFKVcUx9dq1fZIW2IsjMMEmNRqqrJbiI2XLmsaWN+hJ5okfJEZXNjiR7kWn/ZI9Wj9j7V3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hc9frAMK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708974227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/9RYhzIp/TSoYRODHKhiSBAhYa7Kz0V7a3mnNRHaZ14=;
	b=hc9frAMKmZhjaK2+hmkQ4FhC/UaqdUL/9hL7N0jwzGTHjnQIlMtuNVdxbdX75cV8V5/wau
	zy3dHr2lf+ngYrYmH5YiuXD2L6ByFOtmx2b1m/lgUexjSiQTxuufCEsQYMGdihxS+KZDms
	SKLYX6SQoGoHqq1EaBMhDXhY5OYt0rc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-479-pkuqUmQqP12Cr7DiNuPSug-1; Mon,
 26 Feb 2024 14:03:46 -0500
X-MC-Unique: pkuqUmQqP12Cr7DiNuPSug-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D4D133C14940;
	Mon, 26 Feb 2024 19:03:45 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AD491492BC6;
	Mon, 26 Feb 2024 19:03:45 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	aik@amd.com
Subject: [PATCH v3 01/15] KVM: SEV: fix compat ABI for KVM_MEMORY_ENCRYPT_OP
Date: Mon, 26 Feb 2024 14:03:30 -0500
Message-Id: <20240226190344.787149-2-pbonzini@redhat.com>
In-Reply-To: <20240226190344.787149-1-pbonzini@redhat.com>
References: <20240226190344.787149-1-pbonzini@redhat.com>
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
userspace, but they do not make any attempt to convert from one ABI to the other
when 32-bit userspace is running on 64-bit kernels.  This configuration never
worked, and SEV is only for 64-bit kernels so we're not breaking ABI on 32-bit
kernels.

Fix this by adding the appropriate padding; no functional change intended
for 64-bit userspace.

Reviewed-by: Michael Roth <michael.roth@amd.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/uapi/asm/kvm.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index ad29984d5e39..ef11aa4cab42 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -694,6 +694,7 @@ enum sev_cmd_id {
 
 struct kvm_sev_cmd {
 	__u32 id;
+	__u32 pad0;
 	__u64 data;
 	__u32 error;
 	__u32 sev_fd;
@@ -704,28 +705,35 @@ struct kvm_sev_launch_start {
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
@@ -738,33 +746,43 @@ struct kvm_sev_dbg {
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
@@ -772,17 +790,22 @@ struct kvm_sev_receive_start {
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
2.39.1



