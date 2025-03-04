Return-Path: <kvm+bounces-39976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A668A4D375
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 07:09:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 27F427A7B27
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 06:07:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5418C1F755B;
	Tue,  4 Mar 2025 06:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GzBtxZF3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09731F5845
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 06:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741068424; cv=none; b=Z8m4Iy3e9zJk6VnLV2DwomTRxc5gqIFEvLCIZNS6qZ3XfXO1q1E/0yBUqgFTNwnOMNuMbr2XpDDLtKEIqKkabCCvTk7yDuCzby8h5UXEWyryEa5WBrgi8wcgyAcaCknwCXLlGWWyEI5PSstOxpeY8vgo2kiaFBKy2TLRmv8jz90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741068424; c=relaxed/simple;
	bh=H3yi31HVokcXJOCubsppmA5t1sFMy5S8K3VED2TAarI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=o0TpLdyGbkgTli2O3z46yTflFg7UWsLdXhbCx6zq9PlXgCPwVdk0j6W3uZW3nLMr14QYPdLa4a0/rvVGKz3z3WnbpJa29t/cGE1UhBlQaxx6d+kDwe4Bmdj8TlH79mYkqsij/0YXrvQpjtga8a27B6bRPnI9OFVvsE57vusRO28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GzBtxZF3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741068422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Gh8Xe3wJDPflxFCDUNvREYtPLwvRg7q/ggCpf5a4R/o=;
	b=GzBtxZF3/SLYtB7ENcArB0M8axZqYkI34EEAAXshCF2po+fugMhzdwSjZmu+RzRevk02iv
	geOZQn9NyCNkq6NxC/AWV3py4W8Miz5ejIj7ukHqlcqEpLP0uiorFK5tzAQlOvgyP2crBI
	NYbs1yQlu98CuoJ0f7YuPq/0Wyo1oEo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-230-m7A5iEGUNZ-MxK0My6uWjA-1; Tue,
 04 Mar 2025 01:06:50 -0500
X-MC-Unique: m7A5iEGUNZ-MxK0My6uWjA-1
X-Mimecast-MFC-AGG-ID: m7A5iEGUNZ-MxK0My6uWjA_1741068409
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3367F180087E;
	Tue,  4 Mar 2025 06:06:49 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 50A6919560A3;
	Tue,  4 Mar 2025 06:06:48 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: xiaoyao.li@intel.com,
	seanjc@google.com,
	yan.y.zhao@intel.com
Subject: [PATCH v3 0/4] KVM: x86: Introduce quirk KVM_X86_QUIRK_IGNORE_GUEST_PAT
Date: Tue,  4 Mar 2025 01:06:41 -0500
Message-ID: <20250304060647.2903469-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

This series is my evolution of Yan's patches at
https://patchew.org/linux/20250224070716.31360-1-yan.y.zhao@intel.com/.

The implementation of the quirk is unchanged, but the concepts in kvm_caps
are a bit different.  In particular:

- if a quirk is not applicable to some hardware, it is still included
  in KVM_CAP_DISABLE_QUIRKS2.  This way userspace knows that KVM is
  *aware* of a particular issue - even if disabling it has no effect
  because the quirk is not a problem on a specific hardware, userspace
  may want to know that it can rely on the problematic behavior not
  being present.  Therefore, KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT is
  simply auto-disabled on TDX machines.

- if instead a quirk cannot be disabled due to limitations, for example
  KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT if self-snoop is not present on
  the CPU, the quirk is removed completely from kvm_caps.supported_quirks
  and therefore from KVM_CAP_DISABLE_QUIRKS2.

This series does not introduce a way to query always-disabled quirks,
which could be for example KVM_CAP_DISABLED_QUIRKS.  This could be
added if we wanted for example to get rid of hypercall patching; it's
a trivial addition.

The main semantic change with respect to v2 is to prevent re-enabling
quirks that have been disabled with KVM_ENABLE_CAP.  This in turn makes
it possible to just use kvm->arch.disabled_quirks for TDX-enabled

Paolo

Supersedes: <20250301073428.2435768-1-pbonzini@redhat.com>

Paolo Bonzini (3):
  KVM: x86: do not allow re-enabling quirks
  KVM: x86: Allow vendor code to disable quirks
  KVM: x86: remove shadow_memtype_mask

Yan Zhao (3):
  KVM: x86: Introduce supported_quirks to block disabling quirks
  KVM: x86: Introduce Intel specific quirk
    KVM_X86_QUIRK_IGNORE_GUEST_PAT
  KVM: TDX: Always honor guest PAT on TDX enabled guests

 Documentation/virt/kvm/api.rst  | 22 +++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  7 +++++-
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/mmu.h              |  2 +-
 arch/x86/kvm/mmu/mmu.c          | 13 ----------
 arch/x86/kvm/mmu/spte.c         | 19 ++-------------
 arch/x86/kvm/mmu/spte.h         |  1 -
 arch/x86/kvm/svm/svm.c          |  1 +
 arch/x86/kvm/vmx/tdx.c          |  6 +++++
 arch/x86/kvm/vmx/vmx.c          | 43 +++++++++++++++++++++++++++------
 arch/x86/kvm/x86.c              | 13 +++++++---
 arch/x86/kvm/x86.h              |  3 +++
 12 files changed, 87 insertions(+), 44 deletions(-)

-- 
2.43.5


