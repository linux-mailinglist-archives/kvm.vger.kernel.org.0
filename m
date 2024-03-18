Return-Path: <kvm+bounces-12029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66A2387F2F3
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 23:10:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 223BC282210
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 22:10:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C3A85A783;
	Mon, 18 Mar 2024 22:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YoCa9Fbm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986575A0E9
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 22:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710799809; cv=none; b=Y9tyQeV5yscQKKWSB6/n8C3FAZBR7Dj6LNBRSkbSHp4GhukAlxCq8QmAnp3Pv5JxJZgOOSIE6IFu3mVgl9KxdemRSh2QIqAuWO1GDrrxvzMS2HV2r8HsH9zLCSzC+id6XcOM6IThA0Rit7GQkryz1zQydBSZGU+NzDkWoNwl5e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710799809; c=relaxed/simple;
	bh=Z5iRfxdNh5CyrDoUPDoH234u8YFkwUvwaTp8RBly4oA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A/iaLDm9KZnUFVR5vj8cJ6+82jqWY/F0AqTuOBYb7lfMxu6Mdji0g4H5HXZsOhTjBrW2QjgPr1v4jTmDk1ZIfbLigRpry0eyO02k3yu79EwU8pB9VyvQeBstRA8CVbg1IhAH0pATQATIqc+H4XHuS99GpDSzHmIIbZLD6hGkO+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YoCa9Fbm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710799806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WBkKm95Ln/2RsUgEOWoo/2LuPFULXZi0eLnZQwdqLAM=;
	b=YoCa9Fbmj2iwQ9DCkR2+hpqG1UPXqNcacgg65/R9pEMJEv2Ybp8DM8oo3GmSR5eafz/ec2
	Q6AA5F0d49c/iNdLPO09l62HCKaOaUZl4/98vN9bqiZ0IePFusy0g9hOgCVjr2VcfLBPNb
	tPTASJXo0u5v4mQP/I37aJl+rRYf3gw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-591-NnrrJCCFNB-Nld8hG1-VXA-1; Mon,
 18 Mar 2024 18:10:05 -0400
X-MC-Unique: NnrrJCCFNB-Nld8hG1-VXA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ACB591C04330;
	Mon, 18 Mar 2024 22:10:04 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8BF02492BC8;
	Mon, 18 Mar 2024 22:10:04 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Michael Roth <michael.roth@amd.com>
Subject: [PATCH 6/7] Documentation: kvm/sev: separate description of firmware
Date: Mon, 18 Mar 2024 18:10:01 -0400
Message-ID: <20240318221002.2712738-7-pbonzini@redhat.com>
In-Reply-To: <20240318221002.2712738-1-pbonzini@redhat.com>
References: <20240318221002.2712738-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

The description of firmware is included part under the "SEV Key Management"
header, part under the KVM_SEV_INIT ioctl.  Put these two bits together and
and rename "SEV Key Management" to what it actually is, namely a description
of the KVM_MEMORY_ENCRYPT_OP API.

Reviewed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    | 29 +++++++++++--------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 995780088eb2..4f2eb441c718 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -46,14 +46,8 @@ SEV hardware uses ASIDs to associate a memory encryption key with a VM.
 Hence, the ASID for the SEV-enabled guests must be from 1 to a maximum value
 defined in the CPUID 0x8000001f[ecx] field.
 
-SEV Key Management
-==================
-
-The SEV guest key management is handled by a separate processor called the AMD
-Secure Processor (AMD-SP). Firmware running inside the AMD-SP provides a secure
-key management interface to perform common hypervisor activities such as
-encrypting bootstrap code, snapshot, migrating and debugging the guest. For more
-information, see the SEV Key Management spec [api-spec]_
+The KVM_MEMORY_ENCRYPT_OP ioctl
+===============================
 
 The main ioctl to access SEV is KVM_MEMORY_ENCRYPT_OP.  If the argument
 to KVM_MEMORY_ENCRYPT_OP is NULL, the ioctl returns 0 if SEV is enabled
@@ -87,10 +81,6 @@ guests, such as launching, running, snapshotting, migrating and decommissioning.
 The KVM_SEV_INIT command is used by the hypervisor to initialize the SEV platform
 context. In a typical workflow, this command should be the first command issued.
 
-The firmware can be initialized either by using its own non-volatile storage or
-the OS can manage the NV storage for the firmware using the module parameter
-``init_ex_path``. If the file specified by ``init_ex_path`` does not exist or
-is invalid, the OS will create or override the file with output from PSP.
 
 Returns: 0 on success, -negative on error
 
@@ -434,6 +424,21 @@ issued by the hypervisor to make the guest ready for execution.
 
 Returns: 0 on success, -negative on error
 
+Firmware Management
+===================
+
+The SEV guest key management is handled by a separate processor called the AMD
+Secure Processor (AMD-SP). Firmware running inside the AMD-SP provides a secure
+key management interface to perform common hypervisor activities such as
+encrypting bootstrap code, snapshot, migrating and debugging the guest. For more
+information, see the SEV Key Management spec [api-spec]_
+
+The AMD-SP firmware can be initialized either by using its own non-volatile
+storage or the OS can manage the NV storage for the firmware using
+parameter ``init_ex_path`` of the ``ccp`` module. If the file specified
+by ``init_ex_path`` does not exist or is invalid, the OS will create or
+override the file with PSP non-volatile storage.
+
 References
 ==========
 
-- 
2.43.0



