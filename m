Return-Path: <kvm+bounces-2277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D99437F45C6
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 13:20:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0FA081C2085B
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 12:20:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 943224AF61;
	Wed, 22 Nov 2023 12:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen.org header.i=@xen.org header.b="tZpORAkD"
X-Original-To: kvm@vger.kernel.org
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F13212C;
	Wed, 22 Nov 2023 04:19:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
	s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
	Subject:To:From; bh=O6hLRXK6yeKR3L6pdrCbc5lhM310DUyC48DzYfsWYvk=; b=tZpORAkD1
	lcnWLw/OnmyphFpsriRXatUnw457DwkIMeSpO9TOKgGUx2DJKDJ9q/8s3Wos8kTxEe5ZGTrL/WJ4W
	5wRS6Y9gHPCxPcGegT9Vbd3yPxEswE543iuvQSxyG9mhx7yODKBehQ2+r08iMVefe6xHeW+oJ5uv2
	sBGtTQ1A=;
Received: from xenbits.xenproject.org ([104.239.192.120])
	by mail.xenproject.org with esmtp (Exim 4.92)
	(envelope-from <paul@xen.org>)
	id 1r5mBn-0004vx-AU; Wed, 22 Nov 2023 12:18:43 +0000
Received: from 54-240-197-231.amazon.com ([54.240.197.231] helo=REM-PW02S00X.ant.amazon.com)
	by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <paul@xen.org>)
	id 1r5mBn-0004y9-04; Wed, 22 Nov 2023 12:18:43 +0000
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
Subject: [PATCH v9 00/15] KVM: xen: update shared_info and vcpu_info handling
Date: Wed, 22 Nov 2023 12:18:07 +0000
Message-Id: <20231122121822.1042-1-paul@xen.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Paul Durrant <pdurrant@amazon.com>

This is a minimal update to version 8 of the series [1]. The only material
change is in "pfncache: allow a cache to be activated with a fixed
(userspace) HVA".

[1] https://lore.kernel.org/kvm/20231121180223.12484-1-paul@xen.org/

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
 virt/kvm/pfncache.c                           | 169 ++++++------
 8 files changed, 370 insertions(+), 233 deletions(-)


base-commit: 45b890f7689eb0aba454fc5831d2d79763781677
-- 
2.39.2


