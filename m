Return-Path: <kvm+bounces-52741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A639B08FEE
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 16:53:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 245AE3ACC03
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 14:52:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2F902F85D5;
	Thu, 17 Jul 2025 14:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s0R8BKVU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98BD2F7D02
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 14:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752763942; cv=none; b=YtGsK7uGDfeo0hPE9mCvP/haDCPH8TPkXdr4tu8kYaNavyjVuipNAbyrGRUhbtuMShtu82nDhYR1kKd+7YDesJ4jHiGaTu50+rZRwHlnwj51/4etNmeLPXWdwY6oP3duQqs1jNVwyUW4RP/0XGY61N9r1uQd581nB0HxAqXN7kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752763942; c=relaxed/simple;
	bh=80MorPPaHl9TsLZ1DeLV0RCLCihSjoeyYd2It40MXpE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=QmiPUoFl4Z4/PlOq6WkbBrVCC4DgihhzXvJgGhWZQo2ocgKLyTX8urFObVxsSUZm4Q7vxKi+Ii6oj8WA3kon37r0j4aXmodd1f89A4Kc7trd6ImrXibgvjey3KDJ30+ox8cObbsHma+Qc98VFjPIYE+zVyKQ5QqZMGHI30JPzck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s0R8BKVU; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-235196dfc50so11388715ad.1
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 07:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752763940; x=1753368740; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fzF8ddTvRDmr6+lqbUYAfepTkIRTUO0jsFB9VN0seVE=;
        b=s0R8BKVU6eVsMa8sSMcY/3aXDM9zZRcIUqSnA93l0t98tsjvJ5fKA32qbbC7BIb4rI
         hJFmFDY4kLEnqZt2YExISfm6hMz+e9EejDNgijce7kPtFwHVURL+sl2zYjxYirPdyC6Q
         oVHEuiFvo139y3hlMTRv2oTMQ/CtBwUam8qypF+82YkswcVtJT30ck0askPOHNd0nxVR
         6/CRzjZGaWmvEYrge8O2oBzMLC6HMUncwwW22ni1iEkvVx2352rF7cGYe/V0gzz69IcV
         G+7OVoveVPY+SS+w0faiVt74didos2hfmknGS5OlG3aGiilezOdDqcx7e103h7Fvple7
         9fUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752763940; x=1753368740;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fzF8ddTvRDmr6+lqbUYAfepTkIRTUO0jsFB9VN0seVE=;
        b=Lv1D3cEUcRPHS9GNwCKd+r7PMaqr38ckSi3lAhJGp1M6e63Xu5kH1W9rGjQ3tZqZFn
         0wD9Z7g9YY4yvtGMBC4Fh//sEni8L1VWwzX636NlUzLSeldYuNY9R4eKhWyMyZWNyhE2
         GHtutCrUomRuc0mnhI3G2l/wiYsP9JlLNNhvmiU9s12y7Y8zYAZuir8z+7p0UBow1wgv
         gEgEWu+rTJqjU8b9kXZoiARn2rmPCtRhtgrA2sf51r++SHvfvjbYzoXiUzpgFnydyfKy
         KJlpLvfH8xQIcFMnnssELhjvuIVH8I0n1oZp8K14ORQHaMm69AlJQNEpXC7co2J72bGb
         ve8w==
X-Gm-Message-State: AOJu0YwZpvxzi630gmZ+7kvcsWHsLn+QnHoePtnOL4g3gYD4Z09h1rGn
	j61c3SJO+qA1tfzQyBqZtDA4hdzTOBoEzwRu3jmdDwVVCe+EZ8YNs8aPQ4dcn3Ct6e7k/by2hRQ
	MLHBFgQ==
X-Google-Smtp-Source: AGHT+IH0TCNIA5Uad/LzniAvXS4UqU3CneQAWw0fd9zV5z/MZrAkbvNQTuD79l+G1oNGskvTAYSGIso5kE8=
X-Received: from pjbsn8.prod.google.com ([2002:a17:90b:2e88:b0:311:e71e:3fb9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f605:b0:234:7837:91de
 with SMTP id d9443c01a7336-23e38fb9eedmr1052995ad.26.1752763940025; Thu, 17
 Jul 2025 07:52:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 17 Jul 2025 07:52:16 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250717145216.85338-1-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: TDX fixes for 6.16-rc7
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Please pull three TDX fixes for 6.16, two of which have potential to cause ABI
problems.

The following changes since commit 4578a747f3c7950be3feb93c2db32eb597a3e55b:

  KVM: x86: avoid underflow when scaling TSC frequency (2025-07-09 13:52:50 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-fixes-6.16-rc7

for you to fetch changes up to b8be70ec2b47ca62ccb54dc3c2ab9a9c93653e00:

  KVM: VMX: Ensure unused kvm_tdx_capabilities fields are zeroed out (2025-07-15 14:04:39 -0700)

----------------------------------------------------------------
KVM TDX fixes for 6.16

 - Fix a formatting goof in the TDX documentation.

 - Reject KVM_SET_TSC_KHZ for guests with a protected TSC (currently only TDX).

 - Ensure struct kvm_tdx_capabilities fields that are not explicitly set by KVM
   are zeroed.

----------------------------------------------------------------
Binbin Wu (1):
      Documentation: KVM: Fix unexpected unindent warning

Kai Huang (1):
      KVM: x86: Reject KVM_SET_TSC_KHZ vCPU ioctl for TSC protected guest

Sean Christopherson (1):
      KVM: VMX: Ensure unused kvm_tdx_capabilities fields are zeroed out

 Documentation/virt/kvm/api.rst | 11 +++++++++--
 arch/x86/kvm/vmx/tdx.c         |  7 ++++---
 arch/x86/kvm/x86.c             |  4 ++++
 3 files changed, 17 insertions(+), 5 deletions(-)

