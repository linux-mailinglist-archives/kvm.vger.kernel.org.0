Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB6A2695ED
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 21:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726033AbgINT4h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 15:56:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:50094 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725961AbgINT4g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 15:56:36 -0400
IronPort-SDR: hk7D+S/eltzBrA8k+iCz6Vn2Jvq5sN5qsds3Dl6VbMyidi36NeEKR9GWCzCnTlfACuRpieBRt4
 RmmoKSRRewwg==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="177217546"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="177217546"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 12:56:35 -0700
IronPort-SDR: MdEN13xKZ0uwTw3Wv173sApK1iJaywuHqbYr3TMFtChpWxcKXl+TFlIX+NRbu8EAlG1FY7yqIC
 j8hET53nG0uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="287730761"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga008.fm.intel.com with ESMTP; 14 Sep 2020 12:56:35 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 0/2] KVM: VMX: Clean up IRQ/NMI handling
Date:   Mon, 14 Sep 2020 12:56:32 -0700
Message-Id: <20200914195634.12881-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Minor (if there is such a thing for this code) cleanup of KVM's handling
of IRQ and NMI exits to move the invocation of the IRQ handler to a
standalone assembly routine, and to then consolidate the NMI handling to
use the same indirect call approach instead of using INTn.

The IRQ cleanup was suggested by Josh Poimboeuf in the context of a false
postive objtool warning[*].  I believe Josh intended to use UNWIND hints
instead of trickery to avoid objtool complaints.  I opted for trickery in
the form of a redundant, but explicit, restoration of RSP after the hidden
IRET.  AFAICT, there are no existing UNWIND hints that would let objtool
know that the stack is magically being restored, and adding a new hint to
save a single MOV <reg>, <reg> instruction seemed like overkill.

The NMI consolidation was loosely suggested by Andi Kleen.  Andi's actual
suggestion was to export and directly call the NMI handler, but that's a
more involved change (unless I'm misunderstanding the wants of the NMI
handler), whereas piggybacking the IRQ code is simple and seems like a
worthwhile intermediate step.

[*] https://lkml.kernel.org/r/20200908205947.arryy75c5cvldps7@treble

Sean Christopherson (2):
  KVM: VMX: Move IRQ invocation to assembly subroutine
  KVM: VMX: Invoke NMI handler via indirect call instead of INTn

 arch/x86/kvm/vmx/vmenter.S | 28 +++++++++++++++++
 arch/x86/kvm/vmx/vmx.c     | 61 +++++++++++---------------------------
 2 files changed, 45 insertions(+), 44 deletions(-)

-- 
2.28.0

