Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 091691B527D
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 04:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgDWC0z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 22:26:55 -0400
Received: from mga05.intel.com ([192.55.52.43]:43420 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726543AbgDWCZ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 22:25:56 -0400
IronPort-SDR: 8L6SDG/pA/vkjoGf4C41ZkD7JFK0dLy2AJUr3uNlQP5PeUJx18o3MagsxnvNpIS9o1y6PZU9o9
 JvJD06KbnQOw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 19:25:54 -0700
IronPort-SDR: 6s2SpAKQxprKstnQMn+LDiBxmWWYHrjOS7uXJIMNqNubcIK7U9TeYc3C2OdNZ5pCVRJNgM7wiB
 DK7pq0imshaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,305,1583222400"; 
   d="scan'208";a="259273938"
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
Subject: [PATCH 03/13] KVM: x86: Set KVM_REQ_EVENT if run is canceled with req_immediate_exit set
Date:   Wed, 22 Apr 2020 19:25:40 -0700
Message-Id: <20200423022550.15113-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200423022550.15113-1-sean.j.christopherson@intel.com>
References: <20200423022550.15113-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Re-request KVM_REQ_EVENT if vcpu_enter_guest() bails after processing
pending requests and an immediate exit was requested.  This fixes a bug
where a pending event, e.g. VMX preemption timer, is delayed and/or lost
if the exit was deferred due to something other than a higher priority
_injected_ event, e.g. due to a pending nested VM-Enter.  This bug only
affects the !injected case as kvm_x86_ops.cancel_injection() sets
KVM_REQ_EVENT to redo the injection, but that's purely serendipitous
behavior with respect to the deferred event.

Note, emulated preemption timer isn't the only event that can be
affected, it simply happens to be the only event where not re-requesting
KVM_REQ_EVENT is blatantly visible to the guest.

Fixes: f4124500c2c13 ("KVM: nVMX: Fully emulate preemption timer")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ecd612807546..6af873b7e0ae 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8489,6 +8489,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	return r;
 
 cancel_injection:
+	if (req_immediate_exit)
+		kvm_make_request(KVM_REQ_EVENT, vcpu);
 	kvm_x86_ops.cancel_injection(vcpu);
 	if (unlikely(vcpu->arch.apic_attention))
 		kvm_lapic_sync_from_vapic(vcpu);
-- 
2.26.0

