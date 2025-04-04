Return-Path: <kvm+bounces-42637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 329DAA7BACC
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 12:30:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 67DC37A9AE6
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 10:29:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E7441DE2CC;
	Fri,  4 Apr 2025 10:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fC/G40EX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC4D1D8DE0
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 10:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743762574; cv=none; b=f3VXu+pvMEHDAyC3fH2oqEkv+kXgfEqA72EsKjmRvbMG27GxQpUUgbDXZOPFvc8HufyPgq0X8buII3vbIp3rnbelB+YSXQDHRUKnrTFr83rY56GXodU98RbnBt9lST13vqWQA6AwBvnXfF6hP5s9jPnP5p05mawynCg3UM3d2bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743762574; c=relaxed/simple;
	bh=ZXP9PdtNz5G4gmYwe9qut0Sxd9Ty7phi4XqNd27CsSM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TXv7WyneGIyNwAMIs6Y5M4x+W4npdgG63L5sx0xCRIXD1CFiy7pFWIITineZCX/Z4mNMC3WiyLQO8bQwCaVLVWD0xTotEKkbDVf4QlN2AlAQZjG5YzjD3tBxuZKNIs2tPD1AyQUloF5v2XWt0r4HbqcQmA21w9K518lWau0/1vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fC/G40EX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743762572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fh7eVIHVK7DZbml0KKr5DVpGA1dcsH/iEq7JogkgDmY=;
	b=fC/G40EXrH3amn5X0kRTDKnfgse98NnxzYRpAVu7V2yUa2v4MIBxzPVYno8WohkmAX7xoA
	yp97eUdDjDCCUJsAsA4nHAkH1mb7kqCMirkcdqxB+xoX+KPPxo+GSYmZOnhiI3R9clp8VK
	ZW6aHTr25NqfvCNygswfdEVNiF+76HI=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-466-XdKHzxY5P6-tVBRzbfOOxg-1; Fri, 04 Apr 2025 06:29:30 -0400
X-MC-Unique: XdKHzxY5P6-tVBRzbfOOxg-1
X-Mimecast-MFC-AGG-ID: XdKHzxY5P6-tVBRzbfOOxg_1743762570
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5e6c14c0a95so1616118a12.0
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 03:29:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743762569; x=1744367369;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fh7eVIHVK7DZbml0KKr5DVpGA1dcsH/iEq7JogkgDmY=;
        b=FnoDlN9UdCE04XEjMGcD+e/t9+WTTA2B7us9UmLdC82ToOYE+ETLoc5zfiY/UaMJeL
         L6CSRC+xL6zvQ1gvmoUkjmrx8Dm7DeU7/8Lla8lQbyhdv1SRUeTfBzTl5DEJah96bh7G
         0CJSqnx1HCi56bVNYaiLJeYeYEALa8PJ9rqCaBBrUvJXas3ELGOvLrun7rlXV9Fjqz8Y
         24DyIIR2bYv/t+CgWlCJ3FQnwmRPviaRVtz3G7rczRADQteuQx2v4KsGHiqQNKXtFCJ6
         Lfiurzqt731VQXWYa+BJjTlUJcJNu4/FZWu6ccilXlUwxQWl4zJmSaLHe7GpiKmWfDaU
         GYaQ==
X-Forwarded-Encrypted: i=1; AJvYcCWn7hsn6gkVhsShnq0wtUHc8fxuyfuapS8v2lkCSLVyIPhZY1QD3hwYT6dEb4I+QBrLjAE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFc8dr8MAeZXamFPHIyuOdtTHa92OoK9S3sjNtcbXXEI/tDgc6
	oe49cHHxaER2iQCOgGYvVHLYnExrnUcuK/RGACS72pj96OBoo4tYHFLlkj6UFL3HnUBkp3lozBt
	qy1b8sZTqmMnU9q+OKJ/dlXR2rkuZT0luTEh2oDUx0EwIObFkbWeStFK8oQ==
X-Gm-Gg: ASbGncsvWfDHH4/6qA61/91Wo+ZP1TzIxTKIxEEkTLAAuoGWoOkrdMwX1fgdth6GE/Z
	zjEprJQEKQbJKZZJxLBPevWZiHvxpYUc1e7O4QFMhSBcsOkP5bAZ6zjSNEKWpKG0A1yDmbdPEfg
	TqrxA2JqhVUKizYQgSGreyEVGDElsZgTpSmNGWHnv172dusmzYT702HYM1eORpQBwIBKKvXokiz
	VOD8K2gn+EpiZmAIVhxExNVKYhPQSRS4tD8FVsn5mmVXFSKX4fONcd4Gba8VnTDR05v3mRbaF0W
	N2OanCuW+x+UDGq9Z7X/
X-Received: by 2002:a05:6402:51d2:b0:5e4:92ca:34d0 with SMTP id 4fb4d7f45d1cf-5f0b3bce08cmr1901631a12.20.1743762569370;
        Fri, 04 Apr 2025 03:29:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF8YM5bc59qwjlQ36hgK1HFf0sMPpa9wPrpfputnw4Z5kCzZUI7+et+MKVBd0PZ6GNYMaCHiQ==
X-Received: by 2002:a05:6402:51d2:b0:5e4:92ca:34d0 with SMTP id 4fb4d7f45d1cf-5f0b3bce08cmr1901617a12.20.1743762569036;
        Fri, 04 Apr 2025 03:29:29 -0700 (PDT)
Received: from [192.168.122.1] ([151.49.230.224])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f088084f17sm2174115a12.61.2025.04.04.03.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Apr 2025 03:29:28 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH 3/5] Documentation: kvm: fix some definition lists
Date: Fri,  4 Apr 2025 12:29:17 +0200
Message-ID: <20250404102919.171952-4-pbonzini@redhat.com>
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

Ensure that they have a ":" in front of the defined item.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index efca6cc32dd5..e5e7fd42b47c 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7938,10 +7938,10 @@ by POWER10 processor.
 7.24 KVM_CAP_VM_COPY_ENC_CONTEXT_FROM
 -------------------------------------
 
-Architectures: x86 SEV enabled
-Type: vm
-Parameters: args[0] is the fd of the source vm
-Returns: 0 on success; ENOTTY on error
+:Architectures: x86 SEV enabled
+:Type: vm
+:Parameters: args[0] is the fd of the source vm
+:Returns: 0 on success; ENOTTY on error
 
 This capability enables userspace to copy encryption context from the vm
 indicated by the fd to the vm this is called on.
@@ -8662,7 +8662,7 @@ limit the attack surface on KVM's MSR emulation code.
 8.28 KVM_CAP_ENFORCE_PV_FEATURE_CPUID
 -------------------------------------
 
-Architectures: x86
+:Architectures: x86
 
 When enabled, KVM will disable paravirtual features provided to the
 guest according to the bits in the KVM_CPUID_FEATURES CPUID leaf
@@ -8896,7 +8896,7 @@ available to the guest on migration.
 8.33 KVM_CAP_HYPERV_ENFORCE_CPUID
 ---------------------------------
 
-Architectures: x86
+:Architectures: x86
 
 When enabled, KVM will disable emulated Hyper-V features provided to the
 guest according to the bits Hyper-V CPUID feature leaves. Otherwise, all
-- 
2.49.0


