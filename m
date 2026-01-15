Return-Path: <kvm+bounces-68208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E331D26E2A
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 18:53:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 177C83200B14
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 17:35:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E59723C0092;
	Thu, 15 Jan 2026 17:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DKHZCrFO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0E73A7F5D
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 17:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498473; cv=none; b=eBhz+Qjdcy/FDn8YjPPdIC7g5HetuJFzBlH182w+AkfkaXBNaYgauOZ2pbFJf6jy36+5TS9/+Va0IZ8Mzn0oUtJirZ71XxUusVwbrkKUnvz2Z+URtDw09cw6OTjpe79Q7U8HV6BA3KroW0kLiaqA64lk274MsVAQdTor/Eibfa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498473; c=relaxed/simple;
	bh=Kc3Rc89VDDetVPduJ80lK3reeCJZBUH0DPHeisPNCvk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=oXvG+4n2dctQY3hrJYaq1bfoCRkdm9B9CPb01PBVA0zcJx8qOpybQ5daaMK/UbueEi4fphCI6PUAKb/hDhfWN1/3E/7BxOaB5tCVpA5NNayi8aT4J9AdahJSAZmQrn3Ixl33NE09GOYHz66UvNfPYPtRUSvN7n2IzO+VJ7RV4rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DKHZCrFO; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-81f3f3af760so2119781b3a.1
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 09:34:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768498470; x=1769103270; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L5mdohV5Ko0SGA0KnC7ivB69sfeeYfTVYTLfzUKqBnw=;
        b=DKHZCrFOjlNSfyhX4EiGU3ag2sSpZwrDH8rgrHLYkornr9KbhHa2393HTmpzwdSWl8
         16Et827My5cFY7tcauZDNXs6ESTdzASXT1cE62GAKmfZ8movzIh9/EOfiVxNUFRAlhfy
         oCqnmeUchNqCXp0PKpKFMKOOmk91f4RudffQAbMgjjJy+2oSIb/EEbp8hdRk1lvZbW//
         N/AtO8GBguYfiO6v5qp+W/+XRWR+FYCJY28kWLJhPaXHWfyZv30wJ8u8uOtOZByS314l
         UJayJlymhf5O0BMVSK3U2I/kAxpXrkd5QfCAhLpb17lOgHNoW1JEnicmVH6L4K5iyG3r
         6ZEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768498470; x=1769103270;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L5mdohV5Ko0SGA0KnC7ivB69sfeeYfTVYTLfzUKqBnw=;
        b=Sj7bkv6VahD+f5wvGXs2VoVaZJAPq9XsrGfh+YBg7Eg9Vi/orbnk4fvjYf8RSPbKOR
         LFIyXl1FQdr9SdJJLVrb/fjUrIG9kXOQIa4HBLrule3wHaOForSuMbRGz/86tlfkro4C
         mCEsK2eRfyP6Ag/jvK6NZR50U7Mu5699TDxhdGo6kNVL2Fsp38QeZw+R/JrASJ98hfCi
         TyXWSbEiarIpjMZMVmU1uladhW8XIniiljjBRddMAEOVY+Vw7BdLi689EwYiED7Yp+7j
         3XgzrItetfEc1E9Mfzw9zVfWKM9sWgF+uPoZ9YaKqTJ3mz79RMNUipaJjzJmr/ot/Efa
         1QEg==
X-Gm-Message-State: AOJu0YxaqD49+B57zK7vU6f1bGQV4kKUdbF8rZit9PAVj9ILwitqwaau
	UocliH4Mxm0hLfL0Wva2pG9oTKhsmdwPMgtqep3v6yFh7TJQ+d2XH5NghHq3IXnAbx6q6P8SdZm
	TQVHIqA==
X-Received: from pfbln21.prod.google.com ([2002:a05:6a00:3cd5:b0:7e1:a138:bbf3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:aa7:88c6:0:b0:7a5:396d:76be
 with SMTP id d2e1a72fcca58-81fa01b96a6mr317310b3a.27.1768498470072; Thu, 15
 Jan 2026 09:34:30 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 15 Jan 2026 09:34:23 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260115173427.716021-1-seanjc@google.com>
Subject: [PATCH v4 0/4] KVM: nVMX: Disallow access to vmcs12 fields that
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

v4:
 - Filter out read-only fields too. [Xiaoyao]
 - Actually test the code.

v3:
 - https://lore.kernel.org/all/20260109041523.1027323-1-seanjc@google.com
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
 arch/x86/kvm/vmx/nested.c       | 31 ++++++++------
 arch/x86/kvm/vmx/vmcs.h         |  9 ++++
 arch/x86/kvm/vmx/vmcs12.c       | 74 +++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmcs12.h       |  8 ++--
 arch/x86/kvm/vmx/vmx.c          |  2 -
 7 files changed, 104 insertions(+), 24 deletions(-)


base-commit: acdc5446135932ca974b82d9d9a17762c7a82493
-- 
2.52.0.457.g6b5491de43-goog


