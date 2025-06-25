Return-Path: <kvm+bounces-50764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C04BEAE9113
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 00:27:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C07505A72A6
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 22:27:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF9832F3C19;
	Wed, 25 Jun 2025 22:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WUBRMx0C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0C12F3636
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 22:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750890444; cv=none; b=tg8ISALashvtsftTV9PnNjwNjBQb4cjNFH14Tp8R8RmEAXBGQghcyx942xnQwomE+T9BmGJfcSPA0Elyt5TAcVun+A6qg9z0siw10PfB8NZ0yhWn0kV64LuNa3IMrw/MtvKw5xDRPUYHe+kZDqXGE7wpVbBXgYkuVBp8ZRzMZv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750890444; c=relaxed/simple;
	bh=DFEscZ5b9vsxNrK8XTNMnFYFNxl79YOdvWMgo8lbEa8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OvC8X/5EfIMqKlYVVg5RqUMdZqYotmuFZhaQvWKKTXtGBxQoOU9uRIASqc3DY1INmjZDHHvupzvIKX1ixne2DGhf+AALbzn5YPgoX0V7NKCTFRdYwVcA5J8O1Ne4M0rtskbHyuKZFWfjpLZ5Lz5kDnXu3+VXM/Es8fVOxcUutWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WUBRMx0C; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-315af0857f2so231462a91.0
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 15:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750890442; x=1751495242; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OD2pD4+R4381Kg2MOknGhXekAxM4/TBUIlZk8fC9cWk=;
        b=WUBRMx0C0FvnNavGDK7154EL+5MXirXfw3i+uEw2o/G6dfWeylm3irydjyvzVLVhCF
         f6DcpRD4+sr0cwcZXHp44bNDAIohDbCXceFKa19YRiSLwUxcbjXDWQNi9k+9/kQUq1ex
         FKNPoeac9FuvmrRfwXd7FG7E7M8FKBIYO//NxRh9mgs5cxM42uuUhTH7jrPQ8MXJzJ84
         YBEWUE1kF0Z+3R2XsHAY7xhYQv9vi6/iqTqaEouhKtrN/xnptQslM7b5vx8NrfXujwTK
         MVmjT2dIwtk2192dPODia0sMIeTgi314uUmFYRAr1k9Wh9MZmqGPkSswgN0OGlv7jhoe
         XFJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750890442; x=1751495242;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OD2pD4+R4381Kg2MOknGhXekAxM4/TBUIlZk8fC9cWk=;
        b=XN/13DFzWNTeQb8mILRh7sk80fjgj1sANX9W6qqQsAKcf5JNtdV0kxsUh2DvFEnPZM
         iFabWByq5+twKpO1Av6htiofctRkqELX5smtuKlYmuWa7E7co1oJtmpYv8L1zUHSjis/
         NpO07IZpODGgyFjcYYSjP8BWmsHQJISTCzL3t/dMIvk04BH0M3+7fRGT/bM1hon89Svj
         0yzDM/dYuCbecvTfbiPI6BDsMG16nXDiAQtECBn13wCDEaapRY+TD1hZpQ5Y9i96Mj9A
         IFuuiVxPw+otX4XcAGO3vYHdWlXsPQKtgLx4/KgxNfz+qrX+1iqNH+6SoXrFPLuG3/Py
         rNNQ==
X-Gm-Message-State: AOJu0YzQCVWI6wl8dbhLypd3oIviVDtXX9p6qZKOWqMR8vr3MNMN5/oK
	vnsbsahbxsRtC9Ql6fi4n5dYVXYZZwJZx6FVPw8FwZ5gycjomKtcbpzhwA5+BpuAa8l+skODJLP
	uUudk0Q==
X-Google-Smtp-Source: AGHT+IFv6ztYjM5qJiX+FWDfTjscgh8hEQKISCm6JCRJkJrxAmKYZqkYmlVBTV8VVdIyT9z4CM7vgNmdYhQ=
X-Received: from pjbsz14.prod.google.com ([2002:a17:90b:2d4e:b0:2fc:2c9c:880])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3ec6:b0:312:639:a058
 with SMTP id 98e67ed59e1d1-315f2689f26mr6385028a91.27.1750890441959; Wed, 25
 Jun 2025 15:27:21 -0700 (PDT)
Date: Wed, 25 Jun 2025 15:25:43 -0700
In-Reply-To: <20250610195415.115404-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610195415.115404-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <175088945967.720021.14480054455090190643.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH v2 00/14] x86: Add CPUID properties, clean
 up related code
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>
Content-Type: text/plain; charset="utf-8"

On Tue, 10 Jun 2025 12:54:01 -0700, Sean Christopherson wrote:
> Copy KVM selftests' X86_PROPERTY_* infrastructure (multi-bit CPUID
> fields), and use the properties to clean up various warts.  The SEV code
> is particular makes things much harder than they need to be.
> 
> Note, this applies on kvm-x86 next.
> 
> v2:
>  - Avoid tabs immediatedly after #defines. [Dapeng]
>  - Sqaush the arch events vs. GP counters fixes into one patch. [Dapeng]
>  - Mask available arch events based on enumerate bit vector width. [Dapeng]
>  - Add a missing space in a printf argument. [Liam]
>  - Collect reviews. [Dapeng, Liam]
> 
> [...]

Applied to kvm-x86 next, thanks!

[01/14] x86: Encode X86_FEATURE_* definitions using a structure
        https://github.com/kvm-x86/kvm-unit-tests/commit/361f623cb12e
[02/14] x86: Add X86_PROPERTY_* framework to retrieve CPUID values
        https://github.com/kvm-x86/kvm-unit-tests/commit/77ea6ad194b2
[03/14] x86: Use X86_PROPERTY_MAX_VIRT_ADDR in is_canonical()
        https://github.com/kvm-x86/kvm-unit-tests/commit/9a3266bf023e
[04/14] x86: Implement get_supported_xcr0() using X86_PROPERTY_SUPPORTED_XCR0_{LO,HI}
        https://github.com/kvm-x86/kvm-unit-tests/commit/587db1e85faa
[05/14] x86: Add and use X86_PROPERTY_INTEL_PT_NR_RANGES
        https://github.com/kvm-x86/kvm-unit-tests/commit/25e295a5bb8f
[06/14] x86/pmu: Mark all arch events as available on AMD, and rename fields
        https://github.com/kvm-x86/kvm-unit-tests/commit/6c9e1907ecaa
[07/14] x86/pmu: Mark Intel architectural event available iff X <= CPUID.0xA.EAX[31:24]
        https://github.com/kvm-x86/kvm-unit-tests/commit/92dc5f7ab459
[08/14] x86/pmu: Use X86_PROPERTY_PMU_* macros to retrieve PMU information
        https://github.com/kvm-x86/kvm-unit-tests/commit/215e67c112bc
[09/14] x86/sev: Use VC_VECTOR from processor.h
        https://github.com/kvm-x86/kvm-unit-tests/commit/5d80d64dc482
[10/14] x86/sev: Skip the AMD SEV test if SEV is unsupported/disabled
        https://github.com/kvm-x86/kvm-unit-tests/commit/031a0b02be0a
[11/14] x86/sev: Define and use X86_FEATURE_* flags for CPUID 0x8000001F
        https://github.com/kvm-x86/kvm-unit-tests/commit/b643ae6207da
[12/14] x86/sev: Use X86_PROPERTY_SEV_C_BIT to get the AMD SEV C-bit location
        https://github.com/kvm-x86/kvm-unit-tests/commit/38147316d147
[13/14] x86/sev: Use amd_sev_es_enabled() to detect if SEV-ES is enabled
        https://github.com/kvm-x86/kvm-unit-tests/commit/8f6aee89b941
[14/14] x86: Move SEV MSR definitions to msr.h
        https://github.com/kvm-x86/kvm-unit-tests/commit/cebc6ef778a7

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

