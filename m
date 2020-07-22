Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFBE2229C88
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 18:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730617AbgGVQBl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 12:01:41 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:38080 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730092AbgGVQBk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jul 2020 12:01:40 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id A7F69305D76C;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.6])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 9DD4D305FFA8;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v1 21/34] KVM: VMX: Define EPT suppress #VE bit (bit 63 in EPT leaf entries)
Date:   Wed, 22 Jul 2020 19:01:08 +0300
Message-Id: <20200722160121.9601-22-alazar@bitdefender.com>
In-Reply-To: <20200722160121.9601-1-alazar@bitdefender.com>
References: <20200722160121.9601-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

VMX provides a capability that allows EPT violations to be reflected
into the guest as Virtualization Exceptions (#VE).  The primary use case
of EPT violation #VEs is to improve the performance of virtualization-
based security solutions, e.g. eliminate a VM-Exit -> VM-Exit roundtrip
when utilizing EPT to protect priveleged data structures or code.

The "Suppress #VE" bit allows a VMM to opt-out of EPT violation #VEs on
a per page basis, e.g. when a page is marked not-present due to lazy
installation or is write-protected for dirty page logging.

The "Suppress #VE" bit is ignored:

  - By hardware that does not support EPT violation #VEs
  - When the EPT violation #VE VMCS control is disabled
  - On non-leaf EPT entries

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/vmx.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 177500e9e68c..8082158e3e96 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -498,6 +498,7 @@ enum vmcs_field {
 #define VMX_EPT_IPAT_BIT    			(1ull << 6)
 #define VMX_EPT_ACCESS_BIT			(1ull << 8)
 #define VMX_EPT_DIRTY_BIT			(1ull << 9)
+#define VMX_EPT_SUPPRESS_VE_BIT			(1ull << 63)
 #define VMX_EPT_RWX_MASK                        (VMX_EPT_READABLE_MASK |       \
 						 VMX_EPT_WRITABLE_MASK |       \
 						 VMX_EPT_EXECUTABLE_MASK)
