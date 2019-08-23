Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7509A4AB
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 03:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387545AbfHWBIW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 21:08:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:37991 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732613AbfHWBHL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 21:07:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 18:07:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,419,1559545200"; 
   d="scan'208";a="186733486"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Aug 2019 18:07:10 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 01/13] KVM: x86: Relocate MMIO exit stats counting
Date:   Thu, 22 Aug 2019 18:06:57 -0700
Message-Id: <20190823010709.24879-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190823010709.24879-1-sean.j.christopherson@intel.com>
References: <20190823010709.24879-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the stat.mmio_exits update into x86_emulate_instruction().  This is
both a bug fix, e.g. the current update flows will incorrectly increment
mmio_exits on emulation failure, and a preparatory change to set the
stage for eliminating EMULATE_DONE and company.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu.c     | 2 --
 arch/x86/kvm/vmx/vmx.c | 1 -
 arch/x86/kvm/x86.c     | 2 ++
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 4c45ff0cfbd0..845e39d8a970 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -5437,8 +5437,6 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u64 error_code,
 	case EMULATE_DONE:
 		return 1;
 	case EMULATE_USER_EXIT:
-		++vcpu->stat.mmio_exits;
-		/* fall through */
 	case EMULATE_FAIL:
 		return 0;
 	default:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 570a233e272b..18286e5b5983 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5200,7 +5200,6 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 		err = kvm_emulate_instruction(vcpu, 0);
 
 		if (err == EMULATE_USER_EXIT) {
-			++vcpu->stat.mmio_exits;
 			ret = 0;
 			goto out;
 		}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b4cfd786d0b6..cd425f54096a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6598,6 +6598,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 		}
 		r = EMULATE_USER_EXIT;
 	} else if (vcpu->mmio_needed) {
+		++vcpu->stat.mmio_exits;
+
 		if (!vcpu->mmio_is_write)
 			writeback = false;
 		r = EMULATE_USER_EXIT;
-- 
2.22.0

