Return-Path: <kvm+bounces-29502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CB76B9ACA79
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 14:46:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E668F1C236D6
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 12:46:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1640E1BD039;
	Wed, 23 Oct 2024 12:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MNfEZyqW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E521B6556
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 12:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729687524; cv=none; b=ErnyDW28vTDHI8RElAkOcsgTW34eKpXcpRcOf+dOXtvpq+I33w114Si8niGyX3hTyhfx/jH35y75FEdB74S6eQrvQUqsO24vTsKTCm4YhvKv8OAmb1+OfjzdGyPhnJorwIfQNhwUGkAQVGtTmYoEAqXjLFD52P0RY7zCDPQJWO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729687524; c=relaxed/simple;
	bh=n6JPq6feOOxq4qvR2QYPYddN4qFZswV+XGRZJmKdXtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCj+gFy7+5+Jd4MEezOrz+1cXpzaipXKq85onkw4LQuXXNLXob9ExpJvWrIsLIYL8q5nJjrdFReD4YO8OmN/xmGdpcvDeypacJkBue04HvxYIB7ScYT2Qutn0ujRvnyo9fH7KvGVxUXiyVjgOGN5fpBrLna4j57rVHNueh6nALI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MNfEZyqW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729687521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a2ui8XgastR4FaJaNRkMjtjACkKRZ87hrIJU0Aq8EZo=;
	b=MNfEZyqWpYAPpiwEFnjhphhz6SeEUDtDOViiLMMNdi4Vm0Snf94+244f+xfdnFYUQy7Yqu
	4jOQD2j+wne4a4HvDeLfRzGOLEwgVbxieUkb3JNXGtLya6AIhTPrUkeJ4w+hgZdcuP1dUX
	wRMN5lR8+RRIb7jgKZJ53HL1QTdVcrk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-183-BznLAABhPdG1Twb1i2fFFg-1; Wed, 23 Oct 2024 08:45:19 -0400
X-MC-Unique: BznLAABhPdG1Twb1i2fFFg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-431604a3b47so43735735e9.3
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 05:45:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729687519; x=1730292319;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a2ui8XgastR4FaJaNRkMjtjACkKRZ87hrIJU0Aq8EZo=;
        b=k8gtXEtCXqGThHPIEe2jHWK+aB15gZhrD5UScYlgt+sR3npAmesEFYC6uPmFg19hnX
         akoiyLLhf+PjkWAn5H1dQqFw7U/eziPuebhpKK1Ul5wwX31Ggq0DHe9VOFtZVwxkK2/0
         bYGPiK0j+gA6ThzM94wEFlSxKjBPHaNTLTMBmPfNmaFfN9KjT97FGmTDNaqnPI5QtVfd
         diprm933L254xbXVvmSr+5+5i5hjavRVUna69eIHB1Ee5WTwmxA1adacRwR48jURfkxp
         yaEisCd9YEYUBGc2SOf5GmmEQfj4E9nEgSpNU46QmYVvnNMNbKoCwXI26TQgpszhv/51
         ucQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQbfo+vYcEjzHAxyIFAgqwbqNFyxKHs3Nvf3STtAdrbp4VRBLg+f4PtlvBscfYJR5RJZQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQLHBmDTnqfVx5YE3vpZ+S84YNovLPXPESsl7/GJ8rmaJR84rP
	x0Q3/qcNXS/y/GOeK2ixH/gls43rTNglq+IZnD6gOdQO7EjuzR3+B0ZB51SMDijWj4ekwXBMef1
	u897CCDILVvhdCKLC5jouoFgZy+aKY5QlKOYRjWoZKYIpOQsKIw==
X-Received: by 2002:a05:600c:524a:b0:431:12d0:746b with SMTP id 5b1f17b1804b1-431841af63amr16477945e9.35.1729687518661;
        Wed, 23 Oct 2024 05:45:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF0y1BXfPNku3lR35r76dw3XeTpiKZ5deNjUOi+WQ7BpuyYKJNKoHPylKmCWZZUAZbM7FLXSA==
X-Received: by 2002:a05:600c:524a:b0:431:12d0:746b with SMTP id 5b1f17b1804b1-431841af63amr16477735e9.35.1729687518246;
        Wed, 23 Oct 2024 05:45:18 -0700 (PDT)
Received: from avogadro.local ([151.95.144.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43186c3a5b4sm15391805e9.38.2024.10.23.05.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 05:45:17 -0700 (PDT)
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
Subject: [RFC PATCH 2/5] Documentation: kvm: fix a few mistakes
Date: Wed, 23 Oct 2024 14:45:04 +0200
Message-ID: <20241023124507.280382-3-pbonzini@redhat.com>
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

The only occurrence "Capability: none" actually meant the same as "basic".
Fix that and a few more aesthetic or content issues in the document.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 85dc04bfad3b..480ab8174e56 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -96,12 +96,9 @@ description:
   Capability:
       which KVM extension provides this ioctl.  Can be 'basic',
       which means that is will be provided by any kernel that supports
-      API version 12 (see section 4.1), a KVM_CAP_xyz constant, which
+      API version 12 (see section 4.1), or a KVM_CAP_xyz constant, which
       means availability needs to be checked with KVM_CHECK_EXTENSION
-      (see section 4.4), or 'none' which means that while not all kernels
-      support this ioctl, there's no capability bit to check its
-      availability: for kernels that don't support the ioctl,
-      the ioctl returns -ENOTTY.
+      (see section 4.4).
 
   Architectures:
       which instruction set architectures provide this ioctl.
@@ -338,8 +335,8 @@ KVM_S390_SIE_PAGE_OFFSET in order to obtain a memory map of the virtual
 cpu's hardware control block.
 
 
-4.8 KVM_GET_DIRTY_LOG (vm ioctl)
---------------------------------
+4.8 KVM_GET_DIRTY_LOG
+---------------------
 
 :Capability: basic
 :Architectures: all
@@ -1298,7 +1295,7 @@ See KVM_GET_VCPU_EVENTS for the data structure.
 
 :Capability: KVM_CAP_DEBUGREGS
 :Architectures: x86
-:Type: vm ioctl
+:Type: vcpu ioctl
 :Parameters: struct kvm_debugregs (out)
 :Returns: 0 on success, -1 on error
 
@@ -1320,7 +1317,7 @@ Reads debug registers from the vcpu.
 
 :Capability: KVM_CAP_DEBUGREGS
 :Architectures: x86
-:Type: vm ioctl
+:Type: vcpu ioctl
 :Parameters: struct kvm_debugregs (in)
 :Returns: 0 on success, -1 on error
 
@@ -2116,8 +2113,8 @@ TLB, prior to calling KVM_RUN on the associated vcpu.
 
 The "bitmap" field is the userspace address of an array.  This array
 consists of a number of bits, equal to the total number of TLB entries as
-determined by the last successful call to KVM_CONFIG_TLB, rounded up to the
-nearest multiple of 64.
+determined by the last successful call to ``KVM_ENABLE_CAP(KVM_CAP_SW_TLB)``,
+rounded up to the nearest multiple of 64.
 
 Each bit corresponds to one TLB entry, ordered the same as in the shared TLB
 array.
@@ -3554,6 +3551,27 @@ Errors:
 This ioctl returns the guest registers that are supported for the
 KVM_GET_ONE_REG/KVM_SET_ONE_REG calls.
 
+Note that s390 does not support KVM_GET_REG_LIST for historical reasons
+(read: nobody cared).  The set of registers in kernels 4.x and newer is:
+
+- KVM_REG_S390_TODPR
+
+- KVM_REG_S390_EPOCHDIFF
+
+- KVM_REG_S390_CPU_TIMER
+
+- KVM_REG_S390_CLOCK_COMP
+
+- KVM_REG_S390_PFTOKEN
+
+- KVM_REG_S390_PFCOMPARE
+
+- KVM_REG_S390_PFSELECT
+
+- KVM_REG_S390_PP
+
+- KVM_REG_S390_GBEA
+
 
 4.85 KVM_ARM_SET_DEVICE_ADDR (deprecated)
 -----------------------------------------
@@ -4902,8 +4899,8 @@ Coalesced pio is based on coalesced mmio. There is little difference
 between coalesced mmio and pio except that coalesced pio records accesses
 to I/O ports.
 
-4.117 KVM_CLEAR_DIRTY_LOG (vm ioctl)
-------------------------------------
+4.117 KVM_CLEAR_DIRTY_LOG
+-------------------------
 
 :Capability: KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2
 :Architectures: x86, arm64, mips
@@ -5212,7 +5209,7 @@ the cpu reset definition in the POP (Principles Of Operation).
 4.123 KVM_S390_INITIAL_RESET
 ----------------------------
 
-:Capability: none
+:Capability: basic
 :Architectures: s390
 :Type: vcpu ioctl
 :Parameters: none
@@ -6151,7 +6148,7 @@ applied.
 .. _KVM_ARM_GET_REG_WRITABLE_MASKS:
 
 4.139 KVM_ARM_GET_REG_WRITABLE_MASKS
--------------------------------------------
+------------------------------------
 
 :Capability: KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES
 :Architectures: arm64
-- 
2.46.2


