Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56EB426AD5B
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 21:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbgIOTTc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 15:19:32 -0400
Received: from mga18.intel.com ([134.134.136.126]:37628 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728002AbgIOTPU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 15:15:20 -0400
IronPort-SDR: jpu6sbgfgarRvochp2TdkCIwnWBE9evbVdFpNcCQMcb/fthZ4t9rILwK9HUCiJXY9sWDe2HbGf
 qqhb3YSUS00Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9745"; a="147082733"
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="147082733"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 12:15:08 -0700
IronPort-SDR: +QXOI6frlxKJqQT9QSK1/luWh9YStL/bPt1O4xifBlSTe5DlR1HQRd9PoXNv+wbD3QBZBeMu28
 oI2xAZlhyhdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="507694459"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga005.fm.intel.com with ESMTP; 15 Sep 2020 12:15:06 -0700
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
Subject: [PATCH v2 0/2] KVM: VMX: Clean up IRQ/NMI handling
Date:   Tue, 15 Sep 2020 12:15:03 -0700
Message-Id: <20200915191505.10355-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clean up KVM's handling of IRQ and NMI exits to move the invocation of the
IRQ handler to a standalone assembly routine, and to then consolidate the
NMI handling to use the same indirect call approach instead of using INTn.

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

Sean Christopherson (2):
  KVM: VMX: Move IRQ invocation to assembly subroutine
  KVM: VMX: Invoke NMI handler via indirect call instead of INTn

 arch/x86/kvm/vmx/vmenter.S | 34 +++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c     | 61 +++++++++++---------------------------
 2 files changed, 51 insertions(+), 44 deletions(-)

-- 
2.28.0

