Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E3C49B607
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 15:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1578086AbiAYOT7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 09:19:59 -0500
Received: from 8bytes.org ([81.169.241.247]:46252 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1452451AbiAYOQs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 09:16:48 -0500
Received: from cap.home.8bytes.org (p549ad610.dip0.t-ipconnect.de [84.154.214.16])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id D4108106;
        Tue, 25 Jan 2022 15:16:31 +0100 (CET)
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
Subject: [PATCH v6 0/7] KVM: SVM: Add initial GHCB protocol version 2 support
Date:   Tue, 25 Jan 2022 15:16:19 +0100
Message-Id: <20220125141626.16008-1-joro@8bytes.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Hi,

here is a small set of patches which I originally took from the
pending SEV-SNP patch-sets to enable basic support for GHCB protocol
version 2. Meanwhile a couple of other patches from Sean
Christopherson have been added.

When SEV-SNP is not supported, only two new MSR protocol VMGEXIT calls
are required:

	- MSR-based AP-reset-hold
	- MSR-based HV-feature-request

These calls are implemented here and then the protocol is lifted to
version 2.

This is submitted separately because the MSR-based AP-reset-hold call
is required to support kexec/kdump in SEV-ES guests.

The previous version can be found here:

	https://lore.kernel.org/kvm/20211020124416.24523-1-joro@8bytes.org/

Regards,

	Joerg

Changes v5->v6:

	- Rebased to v5.17-rc1
	- Added changes requested by Sean Christopherson

Brijesh Singh (2):
  KVM: SVM: Add support for Hypervisor Feature support MSR protocol
  KVM: SVM: Increase supported GHCB protocol version

Joerg Roedel (2):
  KVM: SVM: Get rid of set_ghcb_msr() and *ghcb_msr_bits() functions
  KVM: SVM: Move kvm_emulate_ap_reset_hold() to AMD specific code

Sean Christopherson (2):
  KVM: SVM: Add helper to generate GHCB MSR verson info, and drop macro
  KVM: SVM: Set "released" on INIT-SIPI iff SEV-ES vCPU was in AP reset
    hold

Tom Lendacky (1):
  KVM: SVM: Add support to handle AP reset MSR protocol

 arch/x86/include/asm/kvm_host.h   |   2 +-
 arch/x86/include/asm/sev-common.h |  18 ++--
 arch/x86/include/uapi/asm/svm.h   |   1 +
 arch/x86/kvm/svm/sev.c            | 169 ++++++++++++++++++++----------
 arch/x86/kvm/svm/svm.c            |  13 ++-
 arch/x86/kvm/svm/svm.h            |  10 +-
 arch/x86/kvm/x86.c                |  12 +--
 7 files changed, 137 insertions(+), 88 deletions(-)


base-commit: e783362eb54cd99b2cac8b3a9aeac942e6f6ac07
-- 
2.34.1

