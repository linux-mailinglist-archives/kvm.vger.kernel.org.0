Return-Path: <kvm+bounces-53684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65379B15580
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 00:56:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FB96560F6E
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 22:56:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 972E2288C23;
	Tue, 29 Jul 2025 22:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CdJcqhNP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A4F288C02
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 22:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829738; cv=none; b=T80NsLJ0wUIa8hwl2jjeQ2VLYBz/xxIN/ikEPqGsqcN+YbIJF1emYlnRFubS8LA/7PaYCivmcD9P/8mKeAg20clkzAqXXu4dzypjNKsyy7qKlfAnukrquUyL70RJ1cjCl6OIZRcMLw/OJ+6RATx5DXUji5f4c4bJ9bD7GhAMT2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829738; c=relaxed/simple;
	bh=PIR7Q1NgOshHJlYu6rpDm4VPA1b0uXtS/tyXN6l8IzA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MZlSWE1vWlQKA7IFIK5J18g6ByYGNj4/ABOUy5G42Y54zdiuQH/8qov+8R3+ZdWFmtACArhNxP7ZF8FjpeMHvwIuyBoc9bBJX83HnSFILwJMHAMXpPeLw042f/9LHbozsqkkS/GTeuFy6GvkAS/T+f46V0ZAdF7LCnG75VRw2oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CdJcqhNP; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3132e7266d3so6691100a91.2
        for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 15:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753829737; x=1754434537; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=gFnHmY/mnoB77L81qdmfXRRJ+itvZAH1/9yVsOU0ZkM=;
        b=CdJcqhNPeYdDqywNVFfaGHTsnnFI/kYoSeewkj1xaa7qqjq9eI95hADA8INU53cpFQ
         xzQ4+TnLVXr/Hwrw6Z7U52lDrp8U7uLYWITjM4bNgTkv1hE7z5ZuPIv413L3kXNoeoSe
         +fDFlWPQ+K55BxFCNHy/IgBjXrYnolew2kFR0gzJOEUgV3n3jvgwF6X0fl9Gro/SWPm6
         MKtsv35P3r8zvNBwUMckVTpdiKE4mEqKNClHpoQgc8FUhxl6Mp0cairryemRAlL5mJpX
         d8dJzVw47WosBUzv1Kgs/b3+pK2WqqL2vSKDvrL6LIb8X8uTTvuEiBMOQ1SsVy2qSf2X
         apYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753829737; x=1754434537;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gFnHmY/mnoB77L81qdmfXRRJ+itvZAH1/9yVsOU0ZkM=;
        b=QL7kMRtzgiwJKhTO3Jffko2zcp06UC4pEyOBrby1CMn0lJjD2xkmD+eYHwxks9/aAa
         /jsDyql36NA8mmBXBga+xPqsbk6OSIg1qlLq0QbqA2c7u0Be0D7Z8lm+aAu6zfs3gIYF
         j9cWGX6H2TxM6P6U7/zG7RkcSwRunmud8hktVtp8MrrwEQEqdWqjblEmbu92OzydSx1l
         EQpcls9sunLyJioWXgkmlM+roa07rva2/L44HV/kQErgN7vvdVmCCAdIUgKBmC2X6sa2
         v4+5jmFLxEhjp6E4ER3ihwkjkOp/rJtEVY5pe4w8+b6CfHPTFzsOGbdxvAd3B8RA/zHX
         C4cQ==
X-Gm-Message-State: AOJu0YwAcyUPPJ7QkA40f23XGaCMkankKIRrgqMizp7+K5hjfBNRN5cG
	wDdXnZSNEG1DREGk4Iexr/dzFCWlzxwDLLwPsRb0GO9g5u78K2Lrj4Q5CqvFg/BBiw1zG/kelkG
	eKKEqkQ==
X-Google-Smtp-Source: AGHT+IGW1K6V884yFJ/UsdufteHNa+YJReUfJU48NT0v+IzXl6w7knzHbQRXIxUuwcw5V5T6c1ZnGgjicS4=
X-Received: from pjbmf3.prod.google.com ([2002:a17:90b:1843:b0:31f:2efe:cece])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2885:b0:312:639:a058
 with SMTP id 98e67ed59e1d1-31f5de49d4dmr1634316a91.27.1753829736661; Tue, 29
 Jul 2025 15:55:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 15:54:35 -0700
In-Reply-To: <20250729225455.670324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729225455.670324-5-seanjc@google.com>
Subject: [PATCH v17 04/24] KVM: x86: Select TDX's KVM_GENERIC_xxx dependencies
 iff CONFIG_KVM_INTEL_TDX=y
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Select KVM_GENERIC_PRIVATE_MEM and KVM_GENERIC_MEMORY_ATTRIBUTES directly
from KVM_INTEL_TDX, i.e. if and only if TDX support is fully enabled in
KVM.  There is no need to enable KVM's private memory support just because
the core kernel's INTEL_TDX_HOST is enabled.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
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
2.50.1.552.g942d659e1b-goog


