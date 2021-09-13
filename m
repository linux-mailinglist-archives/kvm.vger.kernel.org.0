Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D06340930B
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 16:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244694AbhIMORN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 10:17:13 -0400
Received: from 8bytes.org ([81.169.241.247]:56618 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345349AbhIMOPL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 10:15:11 -0400
Received: from cap.home.8bytes.org (p549ad441.dip0.t-ipconnect.de [84.154.212.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 8AC83205;
        Mon, 13 Sep 2021 16:13:53 +0200 (CEST)
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
Subject: [PATCH v3 0/4] KVM: SVM: Add initial GHCB protocol version 2 support
Date:   Mon, 13 Sep 2021 16:13:41 +0200
Message-Id: <20210913141345.27175-1-joro@8bytes.org>
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

Regards,

	Joerg

Changes v2->v3:

	- Rebased to v5.15-rc1

	- Reworked GHCB_MSR access interfaces as suggested by Sean
	  Christopherson.

Brijesh Singh (2):
  KVM: SVM: Add support for Hypervisor Feature support MSR protocol
  KVM: SVM: Increase supported GHCB protocol version

Joerg Roedel (1):
  KVM: SVM: Get rid of set_ghcb_msr() and *ghcb_msr_bits() functions

Tom Lendacky (1):
  KVM: SVM: Add support to handle AP reset MSR protocol

 arch/x86/include/asm/kvm_host.h   |  10 ++-
 arch/x86/include/asm/sev-common.h |   9 +++
 arch/x86/include/uapi/asm/svm.h   |   1 +
 arch/x86/kvm/svm/sev.c            | 115 +++++++++++++++++++-----------
 arch/x86/kvm/svm/svm.h            |   3 +-
 arch/x86/kvm/x86.c                |   5 +-
 6 files changed, 98 insertions(+), 45 deletions(-)


base-commit: 6880fa6c56601bb8ed59df6c30fd390cc5f6dd8f
-- 
2.33.0
