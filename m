Return-Path: <kvm+bounces-67514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 102F0D07189
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 05:15:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8B98230213D1
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 04:15:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2D29284B3B;
	Fri,  9 Jan 2026 04:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ID426t+S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E7A500958
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 04:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767932127; cv=none; b=NdgZ0mxNBOu+BIeNwOsLvlmPL3t7soYX/PMhZIk6NVHqVxzK5NUZ4/bG1h6T+7KpI9potDGx2Oh5u3dcZRa2UJ2ZISHaCKAev9L73aAHtjuNWug2bNhIKTESwYnpPLXeCQUQKYrR9MFRwXOQDbf/QW9jWmwrFKCesWzzduWQIz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767932127; c=relaxed/simple;
	bh=74Q51z8vTxjhm1SPaj71MlzSWuITBRUMNs61bqSZO/k=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=BRp5z1mc0gZGkzwLNlIbu7tjID3HZby2hWUIiCjweknJ4XEMhB4PYy5g79/9uIitzS3iQlfnL6ie6Hg5GaQdLEallC3qVaofHYcvU9HSYkgt9o4e2S4Azfzb9RXD5v2eO2/6LsH6nQ01Cz/2IiOqmd+34gb88sPo0IWC9PgEkLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ID426t+S; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a0f47c0e60so83687305ad.3
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 20:15:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767932126; x=1768536926; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I/SrHC/cClP7f/QcHfYTZkut4gqfCw+/50QP5zds7PM=;
        b=ID426t+SFRqNXYrmdZ5DW7MO5n/Vo+MRFJXI+JyKllKmukX0M8y0tbXwSjRgEiOon4
         rAgRK0MmY429rthhSquio7zUdhOwx0iU+Xsin6SeMDSHW4ySdoVo/y+xgYgz/3cWOMMw
         qqf1H0cpogPhssFbvmnlJlYS0fFf7Mk7zl+Yqchs6j6lTfeftDeIO54Kd28hIYfguUpt
         oEyihxe2qFOqDnT98VoLyhlKgpmHc0rfjWQIZphKQzvX0lOIrEStxeeuvLWSnx+ePAiy
         SNf/pLmAfrxZXDPrIHvhszxPfbQb1Z6M0q2jMQQlBT9kmLI7tHw2GGbBvaHGZTIaUEWp
         vTqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767932126; x=1768536926;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I/SrHC/cClP7f/QcHfYTZkut4gqfCw+/50QP5zds7PM=;
        b=NphIPQIHmCoNICEK9gF3nQost8U5/pezUOdj8GpdzWmfdG6mlqm8ZONySP0iDVZnnd
         jfsaIIlL+ojL23FgF5hHHmg+adxEjgCdhqyj8bANh5Jl6ctnPr8DmOjbfZrMk1JuW4wM
         vTy099ZiGEM6f+GFLD57/QQKmmMB1pwmw1Zg7JGLzs4FF4y2M3Yz0899uPujFGf9xA+T
         s6CRLRBk78iHli4P4NTBGoGnbP+3xew9bvh3bRwHvvdas+m8d6Y/J8YuPUTQrLkZdoLj
         UrjhqXym7cGHFLg70bVaYaasXDgtpVvkE4D2Vwhs0GVRYJF1aZqkK9G/gVRs7ycTNGgM
         PXvQ==
X-Gm-Message-State: AOJu0Yz7K/cPGwQ/C8r+2nt4AzJjFZcnUZ+BL4tfWezk80ajI6J8VqSp
	B6q8eCuyf71CbTHGqFIZ3REmNR97THEJcTwgC9Zu4f8oH/XNSpkgKV//PKUOKftzkOEsocO48cy
	nmmHr2g==
X-Google-Smtp-Source: AGHT+IEToF3QTI5shEOsMmiQ96E7VXqvNzKYUHSM3YkiinzLnNt8kL655tkuOlXBvuaHJl5RH4C8GUvDq7Y=
X-Received: from plrp13.prod.google.com ([2002:a17:902:b08d:b0:295:50ce:4dd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d488:b0:29f:29ae:8733
 with SMTP id d9443c01a7336-2a3ee4b8be5mr83189225ad.53.1767932125917; Thu, 08
 Jan 2026 20:15:25 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  8 Jan 2026 20:15:19 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109041523.1027323-1-seanjc@google.com>
Subject: [PATCH v3 0/4] KVM: nVMX: Disallow access to vmcs12 fields that
 aren't supported by "hardware"
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Chao Gao <chao.gao@intel.com>, Xin Li <xin@zytor.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Disallow accesses to vmcs12 fields that are defined by KVM, but are unsupported
in the current incarnation of KVM, e.g. due to lack of hardware support for the
underlying VMCS fields.

The primary motivation is to avoid having to carry the same logic for shadowed
VMCS fields, which can't play nice with unsupported fields since VMREAD/VMWRITE
will fail when attempting to transfer state between vmcs12 and the shadow VMCS.

v3:
 - Collect reviews. [Xin, Chao]
 - Actually filter out vmcs12 fields when configuring shadow VMCS. [Chao]
 - Move VMX MSR configuration into nested_vmx_hardware_setup().
 - Add ENC_TO_VMCS12_IDX. [Xiaoyao]
 - Use a Xiaoyao's crazy double ROL16 math. :-) [Xiaoyao, obviously]

v2:
 - https://lore.kernel.org/all/20251230220220.4122282-1-seanjc@google.com
 - Name the array of KVM-defined fields kvm_supported_vmcs12_field_offsets,
   e.g. so that it's no confused with what's supported by hardware. [Xin]
 - Combine encodings in switch statements for fields shared fate. [Xin]
 - Drop the extern declaration of supported_vmcs12_field_offsets. [Chao]
 - Handle GUEST_INTR_STATUS in cpu_has_vmcs12_field() and add a patch to
   drop the custom handling from init_vmcs_shadow_fields(). [Chao]

v1: https://lore.kernel.org/all/20251216012918.1707681-1-seanjc@google.com

Sean Christopherson (4):
  KVM: nVMX: Setup VMX MSRs on loading CPU during
    nested_vmx_hardware_setup()
  KVM: VMX: Add a wrapper around ROL16() to get a vmcs12 from a field
    encoding
  KVM: nVMX: Disallow access to vmcs12 fields that aren't supported by
    "hardware"
  KVM: nVMX: Remove explicit filtering of GUEST_INTR_STATUS from shadow
    VMCS fields

 arch/x86/kvm/vmx/hyperv_evmcs.c |  2 +-
 arch/x86/kvm/vmx/hyperv_evmcs.h |  2 +-
 arch/x86/kvm/vmx/nested.c       | 28 +++++++------
 arch/x86/kvm/vmx/vmcs.h         |  9 ++++
 arch/x86/kvm/vmx/vmcs12.c       | 74 +++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmcs12.h       |  8 ++--
 arch/x86/kvm/vmx/vmx.c          |  2 -
 7 files changed, 101 insertions(+), 24 deletions(-)


base-commit: 9448598b22c50c8a5bb77a9103e2d49f134c9578
-- 
2.52.0.457.g6b5491de43-goog


