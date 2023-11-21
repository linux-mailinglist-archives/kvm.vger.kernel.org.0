Return-Path: <kvm+bounces-2207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BE717F357C
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 19:03:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 794D52829E6
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 18:03:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3708522065;
	Tue, 21 Nov 2023 18:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen.org header.i=@xen.org header.b="BrFgap+s"
X-Original-To: kvm@vger.kernel.org
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DFD12A;
	Tue, 21 Nov 2023 10:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
	s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
	Subject:To:From; bh=ApY+rn3G/nOW/ld6052bD3LXs+qXCXswGYK8qsPr9M8=; b=BrFgap+sw
	l2nTXG3eNcovUHWIq/QdZUWWLOEwzARgJIvGAzWfqKdh4cm6B1E17W8e7MKOKhSPGiraP/271NlZh
	JXk25UAl6JubDkoZMMgMi5Jd7ydqCskLs5XMcxJkwFJSPSsqtgQlHCCxSmfojKgpFjkhpr/mfDp9Q
	4ILkQ9iU=;
Received: from xenbits.xenproject.org ([104.239.192.120])
	by mail.xenproject.org with esmtp (Exim 4.92)
	(envelope-from <paul@xen.org>)
	id 1r5V5D-00083I-Cg; Tue, 21 Nov 2023 18:02:47 +0000
Received: from 54-240-197-231.amazon.com ([54.240.197.231] helo=REM-PW02S00X.ant.amazon.com)
	by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <paul@xen.org>)
	id 1r5V5D-0004Z3-1u; Tue, 21 Nov 2023 18:02:47 +0000
From: Paul Durrant <paul@xen.org>
To: David Woodhouse <dwmw2@infradead.org>,
	Paul Durrant <paul@xen.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v8 00/15] KVM: xen: update shared_info and vcpu_info handling
Date: Tue, 21 Nov 2023 18:02:08 +0000
Message-Id: <20231121180223.12484-1-paul@xen.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Paul Durrant <pdurrant@amazon.com>

Currently the shared_info page is treated as guest memory and the VMM
informs KVM of its location using a GFN. However it is not guest memory as
such; it's an overlay page. So the pfncache is pointlessly invalidated and
re-activated to create a new mapping of the *same page* of memory every
time the guest requests that shared_info be mapped into its address space.
Avoid doing that by modifying the pfncache code to allow activation using
a fixed userspace HVA as well as a GPA.

Version 8 of the series has been substantially re-worked and includes
several clean-up patches, particlarly the non-trivial clean-up patches:
"pfncache: remove KVM_GUEST_USES_PFN usage" and "xen: split up
kvm_xen_set_evtchn_fast()". Each patch carries its own version history.

Paul Durrant (15):
  KVM: pfncache: Add a map helper function
  KVM: pfncache: remove unnecessary exports
  KVM: xen: mark guest pages dirty with the pfncache lock held
  KVM: pfncache: add a mark-dirty helper
  KVM: pfncache: remove KVM_GUEST_USES_PFN usage
  KVM: pfncache: stop open-coding offset_in_page()
  KVM: pfncache: include page offset in uhva and use it consistently
  KVM: pfncache: allow a cache to be activated with a fixed (userspace)
    HVA
  KVM: xen: allow shared_info to be mapped by fixed HVA
  KVM: xen: allow vcpu_info to be mapped by fixed HVA
  KVM: selftests / xen: map shared_info using HVA rather than GFN
  KVM: selftests / xen: re-map vcpu_info using HVA rather than GPA
  KVM: xen: advertize the KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA capability
  KVM: xen: split up kvm_xen_set_evtchn_fast()
  KVM: xen: allow vcpu_info content to be 'safely' copied

 Documentation/virt/kvm/api.rst                |  53 +++-
 arch/x86/kvm/x86.c                            |   7 +-
 arch/x86/kvm/xen.c                            | 260 +++++++++++-------
 include/linux/kvm_host.h                      |  38 ++-
 include/linux/kvm_types.h                     |   8 -
 include/uapi/linux/kvm.h                      |   9 +-
 .../selftests/kvm/x86_64/xen_shinfo_test.c    |  59 +++-
 virt/kvm/pfncache.c                           | 175 ++++++------
 8 files changed, 374 insertions(+), 235 deletions(-)


base-commit: 45b890f7689eb0aba454fc5831d2d79763781677
---
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org
-- 
2.39.2


