Return-Path: <kvm+bounces-66867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E6B3CEAC03
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 23:02:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7E5EF301F7CA
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 22:02:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FE60288C81;
	Tue, 30 Dec 2025 22:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="asLRNHKn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF1F267B02
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 22:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767132144; cv=none; b=Xv8Vhjp29kAfKU90yV/5D7rbosdBzYyKU8jirBFBinnC8I4WcaA/YdTBVW8Bm27mucz5+QIJ/poBn+Qaw48SeMe/d3j6j7Hb5hBKjoMdfVWVScta+2vGDMbppzMiJaG4AkoFqakv0xePQXDKPACSvwEct6Rg6z8CDbyiuTY6eSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767132144; c=relaxed/simple;
	bh=PrO8ZpspcY9uetE5zi9xzA6cbVUP1q2CFd+R8evW2IU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=QoDO4T0VF3klqclj87ODO8n4n4AmS6n3KAqM9bP575Rj5eLLewtyoDJZ5wtW7kIhRZXjGIZodble4rms7Kw7pNvT31D7zZ28QvnjuDQcyUdcz1AtNQG8CVbCytlVXH7CESkDbqt4yALw7GNVQtPhpkq7dg9MoHuuOomdpc/XOvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=asLRNHKn; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c6e05af3bso22702883a91.3
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 14:02:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767132142; x=1767736942; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ao6FbYZ3gNN1FVAqmoUiire9m+aObbtdDrXexkBVZEU=;
        b=asLRNHKnTKjDeFlKTrghm17DJkkDEsuqtJ8PekAZKRAQCyDDSciokOjic7m7RlbfJg
         TGb52S4phjgGzVq5c04lgXSMGijm/GozcL7DSA8IVVxvRvQISd+n0CoGgtt622SJFXn0
         8MsYevXuMN6sky6Zm3obFxcPXb0UG73Ix+vBSWtPP3S1d+DUhNm+TRFjDVkLXNacUrbV
         ZXom60pH7o5kU0SWdx/DvVGhX1RqZiD4Xya5LLYnw8kW1DLJL91cvUyAMsgOo6aSug6c
         oHQs7zP5B0LdRuSHUNrB38oYLwzBW9304GUUIQx4WbO01hlDj2jn6GKCSlkPUeX4kUhS
         RMVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767132142; x=1767736942;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ao6FbYZ3gNN1FVAqmoUiire9m+aObbtdDrXexkBVZEU=;
        b=STey/0x1OrxNbaaosq5V+QugNoEstyrAJh8Bhh+VbWp/ZleAEwT0roOlo4W/Z4CrzS
         kMtCJpR0F0fFXEdu/WWiN07ZxXTuOh7gGCYlboktWhFYGlJxb33hll4udKoYPvC4MpsD
         6Hzi1RtN/O3j6Y+0RIfloSqGEPPjxrxBgDrWnBZ2XrWmmMRV1S3DGLoGPO2Brlv7dB5/
         3YCUO2G69f4Rn+5G7J7JTTZk2rBu0VQkcvU8BPwbh2fog8oXxDj5GumGw9xbQ7F16mtY
         qLLfK3NuOamX1tCFwMnhLfKQ5xThe/D3+Q/upwJVOw7Vt+2aZHP3dHW0DW0GHN+v01UU
         ckbA==
X-Gm-Message-State: AOJu0YxgWK//WOzZhEhxdU7bea+tSgghiWh2YSQ1m+Hy/U47+IQ1Lvf7
	vi2Jlx7sCc4O4pE9toF5FTj4MbtKuypT9hZR1nPMP4tf0bqiPhhSdCPNIX/t0CgqlM2L9rHg4AZ
	rz+CrKQ==
X-Google-Smtp-Source: AGHT+IHpa19P8F2HlGXcpKqQSM5qO1/gWJ/4MRi9sMQD8KNAkp88VDfiKcbfYBmqfpO9FpSVMHBvsK3/e6g=
X-Received: from pjboa3.prod.google.com ([2002:a17:90b:1bc3:b0:34c:2f02:7f5d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:58e3:b0:33f:eca0:47c6
 with SMTP id 98e67ed59e1d1-34e921e713dmr28144660a91.30.1767132141994; Tue, 30
 Dec 2025 14:02:21 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 14:02:18 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230220220.4122282-1-seanjc@google.com>
Subject: [PATCH v2 0/2] KVM: nVMX: Disallow access to unsupported vmcs12 fields
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Li <xin@zytor.com>, 
	Chao Gao <chao.gao@intel.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Disallow accesses to vmcs12 fields that are defined by KVM, but are unsupported
in the current incarnation of KVM, e.g. due to lack of hardware support for the
underlying VMCS fields.

The primary motivation is to avoid having to carry the same logic for shadowed
VMCS fields, which can't play nice with unsupported fields since VMREAD/VMWRITE
will fail when attempting to transfer state between vmcs12 and the shadow VMCS.

v2:
 - Name the array of KVM-defined fields kvm_supported_vmcs12_field_offsets,
   e.g. so that it's no confused with what's supported by hardware. [Xin]
 - Combine encodings in switch statements for fields shared fate. [Xin]
 - Drop the extern declaration of supported_vmcs12_field_offsets. [Chao]
 - Handle GUEST_INTR_STATUS in cpu_has_vmcs12_field() and add a patch to
   drop the custom handling from init_vmcs_shadow_fields(). [Chao]

v1: https://lore.kernel.org/all/20251216012918.1707681-1-seanjc@google.com

Sean Christopherson (2):
  KVM: nVMX: Disallow access to vmcs12 fields that aren't supported by
    "hardware"
  KVM: nVMX: Remove explicit filtering of GUEST_INTR_STATUS from shadow
    VMCS fields

 arch/x86/kvm/vmx/nested.c | 17 +++-------
 arch/x86/kvm/vmx/vmcs.h   |  8 +++++
 arch/x86/kvm/vmx/vmcs12.c | 70 +++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmcs12.h |  6 ++--
 arch/x86/kvm/vmx/vmx.c    |  2 ++
 5 files changed, 86 insertions(+), 17 deletions(-)


base-commit: 9448598b22c50c8a5bb77a9103e2d49f134c9578
-- 
2.52.0.351.gbe84eed79e-goog


