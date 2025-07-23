Return-Path: <kvm+bounces-53203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6295B0F03C
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 12:48:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFBC8AA5E30
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 10:47:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B168F2DA74A;
	Wed, 23 Jul 2025 10:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P7ym0+uu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE7D28134C
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 10:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753267642; cv=none; b=hkJx2EY6gNBzj1KN4l7WdYVLnsj5ZfBODXlwzYw42IrtpFnUfLmPDh6pfu/coceb6BvNM2eiT6Tiqt04yyZe/CjYVgkfDkhgryVwEOsYqMlypMueF3bOYBIohJK+txmlim1N8h9w8z15qhiTnsGukZg6n5S0yJe3d444wS0xCAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753267642; c=relaxed/simple;
	bh=MUaS34HTErlUKtpqI7fAvxjXHwHA3Ggu+n8KjjwOUII=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LjgNGFPX/Na6a7zKCNjFUJnGnZO7BVCrBgf+CBV8JFmSGUVcSmsdvlVuCDmywiR09MhSPqko4AgFCcs+JKt+tuXokWitVNz4FhW1d4Lavyp00lUwUrY1Qg/1Ol1cJuofa9uXrAvnIH4Rh/nKVBTBvtHaPKDfcpXPlDVEY0Bq/wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P7ym0+uu; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45626532e27so43560395e9.1
        for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 03:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267639; x=1753872439; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ArQXXXEY7OXN72DRjey+Kc1kp56HNzq8gc9uHD9gj5A=;
        b=P7ym0+uud2FBufY8A2c7e6SsjJEFE64gcIyYVvzXSWsCcUS3kVX3jUtbZl/2Dck2+O
         2e4dNbaIK3Jdj4oSU/ObadTw89/+xG+xctFDxVodADbD5tpvLIIA9G9jCJOzDqC9Govb
         uPWYj/9EGcUbaF06WCboTKVby3N2pvPNZDYRH470m8+7k5sBSCsNWCAtJ7XP3BfEVsdO
         jEG4MTj8NRtj6y5qGtFhlJFkHZle8pJppDXPgD6BN3ljGjcMt/fM6kNWttOZlN1I2ixh
         ohJY7RtjbvgqYcIFjd0iXA1XLncQdavXjp0xqsNgAJpb8hm8SSQ3b0dLEEgimChc0SUI
         Ok8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267639; x=1753872439;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ArQXXXEY7OXN72DRjey+Kc1kp56HNzq8gc9uHD9gj5A=;
        b=tja6G7x0hkzMDD9c6o+F9sR/fw1oGHGs9IfBXR54Iatm8IiaLqj72gZcvNve9cf1nL
         Z5d+XnbA0aM65h/36i9e56G1VapGa5Tu8nyCzqD+I6FGU0gyOs2ImbuWkDmpb//j5U9U
         qy7zxWoPG+F0KI9vtuAHrh1bs328v3yRzp8E8kLefFyI2GwKDi1FqKTPHJQr4e3OF7qv
         3ZkCtD6luTca9QP+7p4Paw6hONgMpwKt1MszPxPjdAoGKX5YwtyGDAjE2V+aKswieDLG
         YXV96X/Pyn85TDlqrUCNeXgO/YWDrg6xVnNAEpLQSXvDJOOoPwjf/x9VMPiIJScvoL9y
         o/Xg==
X-Gm-Message-State: AOJu0YxGXy3bzWv/nv545RPf+yRM9Sdni8Ackh/FgH415eZuB7nZF05T
	yyUF8MmvKy9hCi3pVgpxsQhOgFTPLp1Xkl91BZsA9Zw1DaWQGgPxr9VUw08MIPqpAu8MGjXo3Gf
	xvGCZeB2O622F+mw3DASVZuIVlLLTvRb9xvrO8OliWFXBK1nL7r9wd6g23mHdAb+ngd4JS8zD+D
	TYlilZ+WuP5Q47gw0nSw1VoaMADXU=
X-Google-Smtp-Source: AGHT+IFw9/gp4rUKGBmKsgikBacUJjpjGeakFJ8EOn8lPNZtvr6eyYajGoSHpKrwO0vxhCTQzHhdq7/1nA==
X-Received: from wmbes10.prod.google.com ([2002:a05:600c:810a:b0:456:2903:c96e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8717:b0:456:24aa:9586
 with SMTP id 5b1f17b1804b1-45868d4efa6mr17457625e9.21.1753267638782; Wed, 23
 Jul 2025 03:47:18 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:46:56 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-5-tabba@google.com>
Subject: [PATCH v16 04/22] KVM: x86: Select TDX's KVM_GENERIC_xxx dependencies
 iff CONFIG_KVM_INTEL_TDX=y
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

From: Sean Christopherson <seanjc@google.com>

Select KVM_GENERIC_PRIVATE_MEM and KVM_GENERIC_MEMORY_ATTRIBUTES directly
from KVM_INTEL_TDX, i.e. if and only if TDX support is fully enabled in
KVM.  There is no need to enable KVM's private memory support just because
the core kernel's INTEL_TDX_HOST is enabled.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/kvm/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 402ba00fdf45..13ab7265b505 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -95,8 +95,6 @@ config KVM_SW_PROTECTED_VM
 config KVM_INTEL
 	tristate "KVM for Intel (and compatible) processors support"
 	depends on KVM && IA32_FEAT_CTL
-	select KVM_GENERIC_PRIVATE_MEM if INTEL_TDX_HOST
-	select KVM_GENERIC_MEMORY_ATTRIBUTES if INTEL_TDX_HOST
 	help
 	  Provides support for KVM on processors equipped with Intel's VT
 	  extensions, a.k.a. Virtual Machine Extensions (VMX).
@@ -135,6 +133,8 @@ config KVM_INTEL_TDX
 	bool "Intel Trust Domain Extensions (TDX) support"
 	default y
 	depends on INTEL_TDX_HOST
+	select KVM_GENERIC_PRIVATE_MEM
+	select KVM_GENERIC_MEMORY_ATTRIBUTES
 	help
 	  Provides support for launching Intel Trust Domain Extensions (TDX)
 	  confidential VMs on Intel processors.
-- 
2.50.1.470.g6ba607880d-goog


