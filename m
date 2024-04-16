Return-Path: <kvm+bounces-14882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A55A98A7565
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 22:20:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 457701F232A9
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 20:20:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D30E213AD0E;
	Tue, 16 Apr 2024 20:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gbLIxlLg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52F0139D04
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 20:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713298784; cv=none; b=X8/SATYCbzCrBJs/nnRSclqim4ehwOVRRDxekp0FGibLqyNhskP4DnbQvCf6T3GngT3Do9wwPGT6VjR1WWtJ5YtMZOXLR9D3sR8URIQZ3B1cgd5WhZRqHkT+hMvsxwKulIFgA5xX6OfCVVcNcVNRI5jvuJyMfT9WxMwcqOlzRbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713298784; c=relaxed/simple;
	bh=ybXCHcqj00FEPMcU1M4yoB8jDZaSpssGJBd7HYa/CAE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=l8R/3dFJkaTNf/Dws6mJ/TkW8Iz5GMHUtS7Gi1wb7y0K1fAiSwMhNUgZ8fkYtiCWvqefeHlLLBn8wGEN5HIwuytKBlN85petFGErK1l3OPdRULc1Jq16zcR81y6PiZVOKnvup+lzBa2EcAG3BG9mvLzo/UwOXpDUIpTxrjOOvPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gbLIxlLg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713298781;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7FwpDdGBz6aFJuG+idTO3fB38qLbpwOngplwKUDudyw=;
	b=gbLIxlLgcL96Lti9pc9UsJQDFt+uFRFeaLDuzS2rdgcG5cRPddEXCwUce6C9mGiSChM2ic
	3btJWoE4fxR1KC1PL2AiJNLvxe/N93p9BEU9egB3Zyywhq4de8DdU7pgZ67tnJV0ze2nuT
	EhYLbTPPQtfN3B0QmnWzmcWW5kPGbb8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-516-hwl9LjASO2u4cF1X6UgTFQ-1; Tue,
 16 Apr 2024 16:19:37 -0400
X-MC-Unique: hwl9LjASO2u4cF1X6UgTFQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9BC043830082;
	Tue, 16 Apr 2024 20:19:36 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5E19018209F;
	Tue, 16 Apr 2024 20:19:36 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com,
	chao.gao@intel.com
Subject: [PATCH v2 00/10] KVM: MMU changes for confidential computing
Date: Tue, 16 Apr 2024 16:19:25 -0400
Message-ID: <20240416201935.3525739-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

This includes the MMU parts of "TDX/SNP part 1 of n"[1] while the rest
was posted as "KVM: guest_memfd: New hooks and functionality for SEV-SNP
and TDX"[2] last week.

It includes two basic parts:

- Allow non-zero value for non-present SPTE and removed SPTE, so that
  TDX can set the "suppress VE" bit

- Use PFERR_GUEST_ENC_MASK to indicate fault is private.

The changes from the previous posting were suggested by Chao Gao:

- small adjustment to comments

- fix checks for "!pte_access && !shadow_present_mask", rewriting them
  as "(pte_access | shadow_present_mask) != SHADOW_NONPRESENT_VALUE".

- move allocation of ve_info outside init_vmcs()

I'll push this series later this week to kvm/next, and rebase kvm-coco-queue
on top.

Paolo

[1] https://patchew.org/linux/20240227232100.478238-1-pbonzini@redhat.com/
[2] https://patchew.org/linux/20240404185034.3184582-1-pbonzini@redhat.com/

Isaku Yamahata (3):
  KVM: x86/mmu: Add Suppress VE bit to EPT
    shadow_mmio_mask/shadow_present_mask
  KVM: VMX: Introduce test mode related to EPT violation VE
  KVM: x86/mmu: Pass around full 64-bit error code for KVM page faults

Paolo Bonzini (3):
  KVM, x86: add architectural support code for #VE
  KVM: x86/mmu: Use PFERR_GUEST_ENC_MASK to indicate fault is private
  KVM: x86/mmu: check for invalid async page faults involving private
    memory

Sean Christopherson (4):
  KVM: Allow page-sized MMU caches to be initialized with custom 64-bit
    values
  KVM: x86/mmu: Replace hardcoded value 0 for the initial value for SPTE
  KVM: x86/mmu: Allow non-zero value for non-present SPTE and removed
    SPTE
  KVM: x86/mmu: Track shadow MMIO value on a per-VM basis

 arch/x86/include/asm/kvm_host.h |  5 +++
 arch/x86/include/asm/vmx.h      | 13 ++++++++
 arch/x86/kvm/Kconfig            | 13 ++++++++
 arch/x86/kvm/mmu/mmu.c          | 50 ++++++++++++++++++----------
 arch/x86/kvm/mmu/mmu_internal.h |  6 ++--
 arch/x86/kvm/mmu/mmutrace.h     |  2 +-
 arch/x86/kvm/mmu/paging_tmpl.h  | 16 ++++-----
 arch/x86/kvm/mmu/spte.c         | 24 ++++++++------
 arch/x86/kvm/mmu/spte.h         | 24 +++++++++++---
 arch/x86/kvm/mmu/tdp_mmu.c      | 18 +++++-----
 arch/x86/kvm/vmx/vmcs.h         |  5 +++
 arch/x86/kvm/vmx/vmx.c          | 59 ++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h          |  6 +++-
 include/linux/kvm_types.h       |  1 +
 virt/kvm/kvm_main.c             | 16 +++++++--
 15 files changed, 201 insertions(+), 57 deletions(-)

-- 
2.43.0


