Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 809A541C8C5
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 17:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344164AbhI2PzU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 11:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343734AbhI2PzT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 11:55:19 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F375C061760;
        Wed, 29 Sep 2021 08:53:38 -0700 (PDT)
Received: from cap.home.8bytes.org (p4ff2b5b0.dip0.t-ipconnect.de [79.242.181.176])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id C674DBE;
        Wed, 29 Sep 2021 17:53:35 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH v4 0/5] KVM: SVM: Add initial GHCB protocol version 2 support
Date:   Wed, 29 Sep 2021 17:53:25 +0200
Message-Id: <20210929155330.5597-1-joro@8bytes.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Hi,

here is a small set of patches which I took from the pending SEV-SNP
patch-sets to enable basic support for GHCB protocol version 2.

When SEV-SNP is not supported, only two new MSR protocol VMGEXIT calls
need to be supported:

	- MSR-based AP-reset-hold
	- MSR-based HV-feature-request

These calls are implemented here and then the protocol is lifted to
version 2.

This is submitted separately because the MSR-based AP-reset-hold call
is required to support kexec/kdump in SEV-ES guests.

The previous version can be found here:

	https://lore.kernel.org/kvm/20210913141345.27175-1-joro@8bytes.org/

Regards,

	Joerg

Changes v3->v4:

	- Rebased to kvm/queue
	- Addressed Sean's review comments on v3

Brijesh Singh (2):
  KVM: SVM: Add support for Hypervisor Feature support MSR protocol
  KVM: SVM: Increase supported GHCB protocol version

Joerg Roedel (1):
  KVM: SVM: Get rid of set_ghcb_msr() and *ghcb_msr_bits() functions

Sean Christopherson (1):
  KVM: SVM: Add helper to generate GHCB MSR version info, and drop macro

Tom Lendacky (1):
  KVM: SVM: Add support to handle AP reset MSR protocol

 arch/x86/include/asm/kvm_host.h   |  10 ++-
 arch/x86/include/asm/sev-common.h |  14 ++--
 arch/x86/include/uapi/asm/svm.h   |   1 +
 arch/x86/kvm/svm/sev.c            | 131 ++++++++++++++++++++----------
 arch/x86/kvm/svm/svm.h            |   5 --
 arch/x86/kvm/x86.c                |   5 +-
 6 files changed, 112 insertions(+), 54 deletions(-)


base-commit: 8960bc57dfb78f5de088af800576d9096282dca2
-- 
2.33.0

