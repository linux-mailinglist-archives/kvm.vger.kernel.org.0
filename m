Return-Path: <kvm+bounces-42636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 34CF9A7BACA
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 12:30:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E120B3B922D
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 10:29:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CB7A1BEF87;
	Fri,  4 Apr 2025 10:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VvpTsL7X"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F311D5CDD
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 10:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743762573; cv=none; b=Z6shsLp+JL1cxpH/EWA3NykqnFTyAwQXhQwruPsACLx6rx8KAmDw4jHnpFWrTRBUx9hvs4Q1GCqh+4KW69X14bhSiSHEF0W6K8qHCuJ/bBlEggH6C6W7frWfqDhHduxHUZMpASBAgzBXyqzCj6kxbcYrwar7POtsH9valyb1VyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743762573; c=relaxed/simple;
	bh=pIzQK1XQVUOehm2a0IDXKr9Yx+FlZ4I6aBSO5ZnRFr4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tmAG5OR1PwceJ/Odx+9FJYZ93EJLBja/2mh5gMPMSXuyPNdYuf2800aEfyDeTUOOxhZKI0TqJrIQ4ekh75Y8gtOFjlMTnIqRo0qRar3vwYHXRizzvWkf0aQPApThXkH8cXSBNsDHAHtJxDriovMZ0YfVRUnPZcC6lsDW3Fpjoaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VvpTsL7X; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743762571;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mhILDOeGcZxr2T6k437hnDwGzh6WW1hiZTYtqJGkNJ8=;
	b=VvpTsL7X6POBppb8dd3pnEdSuxZJ1A5Pe6swSCmG3aL+glpQPWJ1C6Y7/p/OKK176D5Tc6
	T1M0+yELpwjZCiEo2q+ITECIATTy61Q94eRq0DYgEtALjwZaxulebT6+/ZTtY+RrGP6Y1Z
	TZ+eU5N3r6Dc+loR/vl53U3q+RbPZ3o=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-410-A1RDUENJMESqUwWq2eJIPg-1; Fri, 04 Apr 2025 06:29:29 -0400
X-MC-Unique: A1RDUENJMESqUwWq2eJIPg-1
X-Mimecast-MFC-AGG-ID: A1RDUENJMESqUwWq2eJIPg_1743762568
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-5e5c808e777so1769298a12.0
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 03:29:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743762567; x=1744367367;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mhILDOeGcZxr2T6k437hnDwGzh6WW1hiZTYtqJGkNJ8=;
        b=HRt19rD42gJPUaDBNC17K30yn9J4B1qNvp8bV5ZE/xIVGgszOSBYLzHbPRoxIKuBAJ
         WQIy3IAfXmc10wN8pPqnySA10/iTHhgzlh6MUIxb9g3KPTOCcNgJFUtCxNp0VtfmNtJ7
         0XSSqDyiEiX3VDc4voZzQnSN7y7Yr9fyXUirYgvvPJjzoeFY49RYVG7yo1wkn7chqYg3
         lg2WialoSTqCCBXfV9XDggurX8wz5TpW0bilHDhDuDZuttdiO36GFAdprla1dtZSU5S0
         zbM91JATI7ENtZML3D3PxpVL5pPsNFMhj+vWUarjmw4io9iDydH+lyYookOdl0TqZE16
         rG9w==
X-Forwarded-Encrypted: i=1; AJvYcCURkobeacF9nVt0g6ntNTmVoNIUsNClT18Re9BnGVEDbAQyRuxQfxImd389mk4ZPdPtzuQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUNsp7iipoKssNnAGAC2mEO2r669HB7igq8clS6vjs+Xce37OE
	Th9qBzgJSF/AdbHnp8C++skmv+UzMjED2IB3Lt8JKNkyWn/5V3VFPWd+96JjOApmEmHiMAONoJY
	U62xHwGW7yR9AFdb4C0P12+EHmNPkSCVIA9nTNGIpE1S0DQnZkoghNgc5Kw==
X-Gm-Gg: ASbGncvPYGzWMEcCL0ROr5GfGoYDa/j+I9+yhkQqpCMWTbv8qybW3oikx4PfrvZ6fSR
	5MCuu+FHYEM4p3z8aRaQ5bG1F4ZlfBghq0nxRXxfZkIM31LaugnJvdB9ZQ4+ajS5EX9lwxkIK5c
	zPGhFUJNDUk3SJat+Pl/Yh1/KDennMQD2ZVN2/B9Ywx6kigDah82mfkLk0+vgyARx4Yx4ZTRAx4
	eapi93UVbZwr7jxhm/kFwzO+fWiwNrJ6qz45mqEhUGd3+l0yNwS4XyhWmGa9zE97G4maddgjqnU
	dySHT81rBZqzYDZveZrU
X-Received: by 2002:a05:6402:3593:b0:5e4:c532:d69d with SMTP id 4fb4d7f45d1cf-5f0b309b682mr2148143a12.0.1743762567336;
        Fri, 04 Apr 2025 03:29:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEmoV1MYcdwLtpfSGoF+5ukGiKvJOsY+H/bN0znAVOJPtTTDi9a2JwSVODl/Bxo9X77PYGQTQ==
X-Received: by 2002:a05:6402:3593:b0:5e4:c532:d69d with SMTP id 4fb4d7f45d1cf-5f0b309b682mr2148129a12.0.1743762566946;
        Fri, 04 Apr 2025 03:29:26 -0700 (PDT)
Received: from [192.168.122.1] ([151.49.230.224])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f087ed1c68sm2047151a12.17.2025.04.04.03.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Apr 2025 03:29:26 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH 2/5] Documentation: kvm: drop "Capability" heading from capabilities
Date: Fri,  4 Apr 2025 12:29:16 +0200
Message-ID: <20250404102919.171952-3-pbonzini@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250404102919.171952-1-pbonzini@redhat.com>
References: <20250404102919.171952-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It is redundant, and sometimes wrong.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 49a604154564..efca6cc32dd5 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7977,7 +7977,6 @@ See Documentation/arch/x86/sgx.rst for more details.
 7.26 KVM_CAP_PPC_RPT_INVALIDATE
 -------------------------------
 
-:Capability: KVM_CAP_PPC_RPT_INVALIDATE
 :Architectures: ppc
 :Type: vm
 
@@ -8052,7 +8051,6 @@ upgrading the VMM process without interrupting the guest.
 7.30 KVM_CAP_PPC_AIL_MODE_3
 -------------------------------
 
-:Capability: KVM_CAP_PPC_AIL_MODE_3
 :Architectures: ppc
 :Type: vm
 
@@ -8066,7 +8064,6 @@ handling interrupts and system calls.
 7.31 KVM_CAP_DISABLE_QUIRKS2
 ----------------------------
 
-:Capability: KVM_CAP_DISABLE_QUIRKS2
 :Parameters: args[0] - set of KVM quirks to disable
 :Architectures: x86
 :Type: vm
@@ -8910,7 +8907,6 @@ leaf.
 8.34 KVM_CAP_EXIT_HYPERCALL
 ---------------------------
 
-:Capability: KVM_CAP_EXIT_HYPERCALL
 :Architectures: x86
 :Type: vm
 
@@ -8929,7 +8925,6 @@ ENOSYS for the others.
 8.35 KVM_CAP_PMU_CAPABILITY
 ---------------------------
 
-:Capability: KVM_CAP_PMU_CAPABILITY
 :Architectures: x86
 :Type: vm
 :Parameters: arg[0] is bitmask of PMU virtualization capabilities.
@@ -8951,7 +8946,6 @@ should adjust CPUID leaf 0xA to reflect that the PMU is disabled.
 8.36 KVM_CAP_ARM_SYSTEM_SUSPEND
 -------------------------------
 
-:Capability: KVM_CAP_ARM_SYSTEM_SUSPEND
 :Architectures: arm64
 :Type: vm
 
@@ -8961,7 +8955,6 @@ type KVM_SYSTEM_EVENT_SUSPEND to process the guest suspend request.
 8.37 KVM_CAP_S390_PROTECTED_DUMP
 --------------------------------
 
-:Capability: KVM_CAP_S390_PROTECTED_DUMP
 :Architectures: s390
 :Type: vm
 
@@ -8974,7 +8967,6 @@ available and supports the `KVM_PV_DUMP_CPU` subcommand.
 8.38 KVM_CAP_VM_DISABLE_NX_HUGE_PAGES
 -------------------------------------
 
-:Capability: KVM_CAP_VM_DISABLE_NX_HUGE_PAGES
 :Architectures: x86
 :Type: vm
 :Parameters: arg[0] must be 0.
@@ -8991,7 +8983,6 @@ This capability may only be set before any vCPUs are created.
 8.39 KVM_CAP_S390_CPU_TOPOLOGY
 ------------------------------
 
-:Capability: KVM_CAP_S390_CPU_TOPOLOGY
 :Architectures: s390
 :Type: vm
 
@@ -9016,7 +9007,6 @@ must point to a byte where the value will be stored or retrieved from.
 8.40 KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
 ---------------------------------------
 
-:Capability: KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
 :Architectures: arm64
 :Type: vm
 :Parameters: arg[0] is the new split chunk size.
@@ -9043,7 +9033,6 @@ block sizes is exposed in KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES as a
 8.41 KVM_CAP_VM_TYPES
 ---------------------
 
-:Capability: KVM_CAP_MEMORY_ATTRIBUTES
 :Architectures: x86
 :Type: system ioctl
 
-- 
2.49.0


