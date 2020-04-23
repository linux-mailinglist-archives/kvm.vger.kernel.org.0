Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 855591B526A
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 04:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbgDWC0P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 22:26:15 -0400
Received: from mga06.intel.com ([134.134.136.31]:33067 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbgDWC0A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 22:26:00 -0400
IronPort-SDR: i70pUQgADsbrDYLQ4Bh5sIuKyU04zlTLzoRRYl9Pv/EDnZWNA1La6nFinqFOSVXinSlVqClG/N
 RUmjbLOUohBw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 19:25:55 -0700
IronPort-SDR: oB3KKJgN9AQTijfc1cV6lgRQhpSpEjBpSgpDWQYRur6awFonFIcrhzg3jvnBC3QbpqwrR+LD8/
 iSWA8uflepOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,305,1583222400"; 
   d="scan'208";a="259273961"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 22 Apr 2020 19:25:54 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: [PATCH 10/13] KVM: x86: WARN on injected+pending exception even in nested case
Date:   Wed, 22 Apr 2020 19:25:47 -0700
Message-Id: <20200423022550.15113-11-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200423022550.15113-1-sean.j.christopherson@intel.com>
References: <20200423022550.15113-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

WARN if a pending exception is coincident with an injected exception
before calling check_nested_events() so that the WARN will fire even if
inject_pending_event() bails early because check_nested_events() detects
the conflict.  Bailing early isn't problematic (quite the opposite), but
suppressing the WARN is undesirable as it could mask a bug elsewhere in
KVM.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6af873b7e0ae..7c49a7dc601f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7693,6 +7693,9 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
 			kvm_x86_ops.set_irq(vcpu);
 	}
 
+	WARN_ON_ONCE(vcpu->arch.exception.injected &&
+		     vcpu->arch.exception.pending);
+
 	/*
 	 * Call check_nested_events() even if we reinjected a previous event
 	 * in order for caller to determine if it should require immediate-exit
@@ -7711,7 +7714,6 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
 					vcpu->arch.exception.has_error_code,
 					vcpu->arch.exception.error_code);
 
-		WARN_ON_ONCE(vcpu->arch.exception.injected);
 		vcpu->arch.exception.pending = false;
 		vcpu->arch.exception.injected = true;
 
-- 
2.26.0

