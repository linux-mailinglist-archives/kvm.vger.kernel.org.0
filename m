Return-Path: <kvm+bounces-29503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62CFA9ACA7E
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 14:46:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D34A1C23EE1
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 12:46:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CC771C3041;
	Wed, 23 Oct 2024 12:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VUqV2E+a"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2FC31C1753
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 12:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729687528; cv=none; b=BGKlxjS1cbRGfdIv0c50joZr+LGkNupiG/k3u1Qrjp0Jkg9H24d6ZTWhSG9BukV9Jvz0NtU5aUzuon9wcSGdPKKV7McP6wwXf2a7jXMipzOI1d3q3GOI8SVF3PgaBa6JvVQlulrl1A3yo3L13dCyha2Sw2x3TPGO9BW+/gKsMG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729687528; c=relaxed/simple;
	bh=hotHQZVnoFMtyRZ6tdX6vYrrQPC51HzlczEpuc7WVAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=auLPbbZVec1AA9/e6EMDjLRhD9tlxDy53Rnlmi6yb0zDD5MDGDdPonQ9F2sQa+3MNRGMLiHzFVscdDN6L35T/AZNHIuUPP54esYkuZ5REoRiVzdckG+5od/g+816PH5vnjuBSTovgs92PXIA0C3CqAzfVilzfvqiB/chqyGOpDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VUqV2E+a; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729687524;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9iFQ2SoxTB2E7EgmYJpFoUM8SnPrGQqTL5Y/dS2nnkc=;
	b=VUqV2E+aVT5OakSgQmGxIl8A0b7ftgCKKqHDJjpn45Pxj6lEO/L8gGziVw3k9Dsajtxx+b
	ycqe0BwbrYStiqueHNpEOATMoFq+FSqeyh7CRw7hs+Knztm1x/KniVhbwNDMEVknAZv1eZ
	l+3oyUfPrQEZpk2wA0wEYG3Zp+Xn/do=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-312-EOl26CTOPpmuPXc-Chrn-w-1; Wed, 23 Oct 2024 08:45:23 -0400
X-MC-Unique: EOl26CTOPpmuPXc-Chrn-w-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-37d59ad50f3so2988143f8f.0
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 05:45:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729687522; x=1730292322;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9iFQ2SoxTB2E7EgmYJpFoUM8SnPrGQqTL5Y/dS2nnkc=;
        b=LtiPJ0HQHD6mYTU3xb9tu4OEEJVA+6ccp0/IFP9aIklvAJV5EfayGLzjhD307hzvh4
         A2eg6rKw55/CKwruB8CETU3LIOlAHWlWc+y9RJlv5sw5WSX31AU88ItE3EI4UXQHNLvL
         daLjBnc2bIMXt/meDaZHQr3LSzfkfL9j/A0bQtMxRrTCYsySKIk82PPEjNfFHMX6eSfM
         1cOgH/My5Yxe4KUaMOoHj2HLNbIpAryDbQboNzGRXxceLXipeBz1JyR39eZSskfC70kC
         fVuDgJYIyscitKt6vyqGELolessmXg0hmITMIT7JG8HeJJqQW1Pm6QEUNnlp1vv/+ebA
         rJ/A==
X-Forwarded-Encrypted: i=1; AJvYcCXqOb7wmcyF3L8lfvhvqDiMLu8rjzRjbw/5Jf/6tTSAbSUQdGr1dwC1qFOeUR8p4R05F3Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIR9Pp2a5FcBSQqoJLE0wN8BQjJ5QKt7DZHJOpBPh0QwWqSeWY
	5957V98nGiu8ue5Tmy7NR6uzUlXVBGWvpw9Wme+FhIgImP+4BncUqmfWOmoQY2htAgVGTOJl5M/
	wXSvoubMIjXK3g7VVIVqoIvbP5WCxlabgceGHckbOllFS2I/Eqg==
X-Received: by 2002:adf:f781:0:b0:37d:4ba1:dcff with SMTP id ffacd0b85a97d-37efcf7b9d2mr1841022f8f.42.1729687522114;
        Wed, 23 Oct 2024 05:45:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEFIyABl/bqJdhPDpe+7L8YUu7GDBTYFDZy4WfrGhSIwctTeKRQGKwcmhFolqtMC+Mn/LIrUw==
X-Received: by 2002:adf:f781:0:b0:37d:4ba1:dcff with SMTP id ffacd0b85a97d-37efcf7b9d2mr1841004f8f.42.1729687521616;
        Wed, 23 Oct 2024 05:45:21 -0700 (PDT)
Received: from avogadro.local ([151.95.144.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43186bdeb4asm15319465e9.15.2024.10.23.05.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 05:45:21 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: roy.hopkins@suse.com,
	seanjc@google.com,
	michael.roth@amd.com,
	ashish.kalra@amd.com,
	jroedel@suse.de,
	thomas.lendacky@amd.com,
	nsaenz@amazon.com,
	anelkz@amazon.de,
	oliver.upton@linux.dev,
	isaku.yamahata@intel.com,
	maz@kernel.org,
	steven.price@arm.com,
	kai.huang@intel.com,
	rick.p.edgecombe@intel.com,
	James.Bottomley@HansenPartnership.com
Subject: [RFC PATCH 3/5] Documentation: kvm: replace section numbers with links
Date: Wed, 23 Oct 2024 14:45:05 +0200
Message-ID: <20241023124507.280382-4-pbonzini@redhat.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241023124507.280382-1-pbonzini@redhat.com>
References: <20241023124507.280382-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In order to simplify further introduction of hyperlinks, replace explicit
section numbers with rST hyperlinks.  The section numbers could actually
be removed now, but I'm not going to do a huge change throughout the file
for an RFC...

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst | 40 ++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 480ab8174e56..42030227dedd 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -96,9 +96,9 @@ description:
   Capability:
       which KVM extension provides this ioctl.  Can be 'basic',
       which means that is will be provided by any kernel that supports
-      API version 12 (see section 4.1), or a KVM_CAP_xyz constant, which
-      means availability needs to be checked with KVM_CHECK_EXTENSION
-      (see section 4.4).
+      API version 12 (see :ref:`KVM_GET_API_VERSION <KVM_GET_API_VERSION>`),
+      or a KVM_CAP_xyz constant that can be checked with
+      :ref:`KVM_CHECK_EXTENSION <KVM_CHECK_EXTENSION>`.
 
   Architectures:
       which instruction set architectures provide this ioctl.
@@ -115,6 +115,8 @@ description:
       are not detailed, but errors with specific meanings are.
 
 
+.. _KVM_GET_API_VERSION:
+
 4.1 KVM_GET_API_VERSION
 -----------------------
 
@@ -243,6 +245,8 @@ This list also varies by kvm version and host processor, but does not change
 otherwise.
 
 
+.. _KVM_CHECK_EXTENSION:
+
 4.4 KVM_CHECK_EXTENSION
 -----------------------
 
@@ -285,7 +289,7 @@ the VCPU file descriptor can be mmap-ed, including:
 
 - if KVM_CAP_DIRTY_LOG_RING is available, a number of pages at
   KVM_DIRTY_LOG_PAGE_OFFSET * PAGE_SIZE.  For more information on
-  KVM_CAP_DIRTY_LOG_RING, see section 8.3.
+  KVM_CAP_DIRTY_LOG_RING, see :ref:`KVM_CAP_DIRTY_LOG_RING`.
 
 
 4.7 KVM_CREATE_VCPU
@@ -1426,6 +1430,8 @@ because of a quirk in the virtualization implementation (see the internals
 documentation when it pops into existence).
 
 
+.. _KVM_ENABLE_CAP:
+
 4.37 KVM_ENABLE_CAP
 -------------------
 
@@ -2560,7 +2566,7 @@ Specifically:
 ======================= ========= ===== =======================================
 
 .. [1] These encodings are not accepted for SVE-enabled vcpus.  See
-       KVM_ARM_VCPU_INIT.
+       :ref:`KVM_ARM_VCPU_INIT`.
 
        The equivalent register content can be accessed via bits [127:0] of
        the corresponding SVE Zn registers instead for vcpus that have SVE
@@ -5036,8 +5042,8 @@ Recognised values for feature:
 Finalizes the configuration of the specified vcpu feature.
 
 The vcpu must already have been initialised, enabling the affected feature, by
-means of a successful KVM_ARM_VCPU_INIT call with the appropriate flag set in
-features[].
+means of a successful :ref:`KVM_ARM_VCPU_INIT <KVM_ARM_VCPU_INIT>` call with the
+appropriate flag set in features[].
 
 For affected vcpu features, this is a mandatory step that must be performed
 before the vcpu is fully usable.
@@ -6380,6 +6386,8 @@ the capability to be present.
 `flags` must currently be zero.
 
 
+.. _kvm_run:
+
 5. The kvm_run structure
 ========================
 
@@ -7099,11 +7107,15 @@ primary storage for certain register types. Therefore, the kernel may use the
 values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
 
 
+.. _cap_enable:
+
 6. Capabilities that can be enabled on vCPUs
 ============================================
 
 There are certain capabilities that change the behavior of the virtual CPU or
-the virtual machine when enabled. To enable them, please see section 4.37.
+the virtual machine when enabled. To enable them, please see
+:ref:`KVM_ENABLE_CAP`.
+
 Below you can find a list of capabilities and what their effect on the vCPU or
 the virtual machine is when enabling them.
 
@@ -7312,7 +7324,7 @@ KVM API and also from the guest.
           sets are supported
           (bitfields defined in arch/x86/include/uapi/asm/kvm.h).
 
-As described above in the kvm_sync_regs struct info in section 5 (kvm_run):
+As described above in the kvm_sync_regs struct info in section :ref:`kvm_run`,
 KVM_CAP_SYNC_REGS "allow[s] userspace to access certain guest registers
 without having to call SET/GET_*REGS". This reduces overhead by eliminating
 repeated ioctl calls for setting and/or getting register values. This is
@@ -7358,13 +7370,15 @@ Unused bitfields in the bitarrays must be set to zero.
 
 This capability connects the vcpu to an in-kernel XIVE device.
 
+.. _cap_enable_vm:
+
 7. Capabilities that can be enabled on VMs
 ==========================================
 
 There are certain capabilities that change the behavior of the virtual
-machine when enabled. To enable them, please see section 4.37. Below
-you can find a list of capabilities and what their effect on the VM
-is when enabling them.
+machine when enabled. To enable them, please see section
+:ref:`KVM_ENABLE_CAP`. Below you can find a list of capabilities and
+what their effect on the VM is when enabling them.
 
 The following information is provided along with the description:
 
@@ -8515,6 +8529,8 @@ guest according to the bits in the KVM_CPUID_FEATURES CPUID leaf
 (0x40000001). Otherwise, a guest may use the paravirtual features
 regardless of what has actually been exposed through the CPUID leaf.
 
+.. _KVM_CAP_DIRTY_LOG_RING:
+
 8.29 KVM_CAP_DIRTY_LOG_RING/KVM_CAP_DIRTY_LOG_RING_ACQ_REL
 ----------------------------------------------------------
 
-- 
2.46.2


