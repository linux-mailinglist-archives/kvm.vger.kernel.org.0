Return-Path: <kvm+bounces-16851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BDE218BE7AB
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 17:45:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 08BB0B23D65
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 15:45:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F27F16C458;
	Tue,  7 May 2024 15:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NYX63ua3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19534165FB3
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 15:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715096706; cv=none; b=PcIQ1u8KCzC2Gk7wXF0EdC9i7K/2suQugX//huGfKo4AF7X0zfaAQQ9t6GwxANwlrHVV+fvUXiVDwaD7KF+SGoi2io1y1h62WxAw//Nfl9kL2vfZXcQvdR0S0AcC0PoPlEugnxWOCnXpbTgm9S6boEK0teqZ6V46qTR3Ubzqls4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715096706; c=relaxed/simple;
	bh=3EKyAa8M7cx/xE73k5vxAGMUtwqen/TT/5gLXWqWZ9Q=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=a1EpqbU3mdGYrtVVK0/2v7xLjT8e1/n2fdvVwxpwzsQYLQk+Hfn5OUZYWR0yoXDeLcd50BoKJWTqfNMts/ymM23dxmq2QfD9/gaZag6uHErxvkjjWMuZvlIiNEuVf0Alx893MvmpP53h0dO+1K0Zj2C1PJLMLczgEk00h0hvazA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NYX63ua3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715096704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bB7ooeC+6+Eo7pbT0iOPQxNvJmou4DDO/iz/oRY16T4=;
	b=NYX63ua3v1TGP+JsRUXfA4ofk+WhhcOaAm1k/V0u5XFlcXXZ+C4TBzbJKZuxupo2QRcId4
	wQnloYuGyoW2Yzn6qTJbp1I5PjV0YGr9VXBxSuu38APnsomrFTdL2BckUbt7zKj9BeJKBR
	L3vjdva74v/nYM8DL0yFGWuJdnlXT3I=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-594-yMQWyBTfMDqtxEwx2BSFkw-1; Tue,
 07 May 2024 11:45:00 -0400
X-MC-Unique: yMQWyBTfMDqtxEwx2BSFkw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8355229ABA11;
	Tue,  7 May 2024 15:45:00 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6B7CAC154E5;
	Tue,  7 May 2024 15:45:00 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH 0/7] KVM: MMU changes for TDX VE support
Date: Tue,  7 May 2024 11:44:52 -0400
Message-ID: <20240507154459.3950778-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

Allow a non-zero value for non-present SPTE and removed SPTE,
so that TDX can set the "suppress VE" bit.  This is taken from
https://patchew.org/linux/20240416201935.3525739-1-pbonzini@redhat.com/
with review comments addressed:

- do not dereference an address from the VMCS to include #VE info
  in the dump

- fail hard if the #VE info page cannot be allocated

Paolo

Isaku Yamahata (2):
  KVM: x86/mmu: Add Suppress VE bit to EPT
    shadow_mmio_mask/shadow_present_mask
  KVM: VMX: Introduce test mode related to EPT violation VE

Paolo Bonzini (1):
  KVM, x86: add architectural support code for #VE

Sean Christopherson (4):
  KVM: Allow page-sized MMU caches to be initialized with custom 64-bit
    values
  KVM: x86/mmu: Replace hardcoded value 0 for the initial value for SPTE
  KVM: x86/mmu: Allow non-zero value for non-present SPTE and removed
    SPTE
  KVM: x86/mmu: Track shadow MMIO value on a per-VM basis

 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/include/asm/vmx.h      | 13 ++++++++
 arch/x86/kvm/Kconfig            | 13 ++++++++
 arch/x86/kvm/mmu/mmu.c          | 21 ++++++++-----
 arch/x86/kvm/mmu/paging_tmpl.h  | 14 ++++-----
 arch/x86/kvm/mmu/spte.c         | 24 ++++++++-------
 arch/x86/kvm/mmu/spte.h         | 24 ++++++++++++---
 arch/x86/kvm/mmu/tdp_mmu.c      | 18 +++++------
 arch/x86/kvm/vmx/vmcs.h         |  5 ++++
 arch/x86/kvm/vmx/vmx.c          | 53 ++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h          |  6 +++-
 include/linux/kvm_types.h       |  1 +
 virt/kvm/kvm_main.c             | 16 ++++++++--
 13 files changed, 167 insertions(+), 43 deletions(-)

-- 
2.43.0


