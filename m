Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98370623BA9
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 07:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbiKJGRU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 01:17:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232220AbiKJGRT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 01:17:19 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A5C275FC
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 22:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668061038; x=1699597038;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XUrorIavZh5+CV2SBtxNSWkJU5T0zIKw7KEelHvIjkw=;
  b=PvhAmVkPiwYZCCNnJ3eq1/VLuTL7EWNSsq7D6y5lfwmvTIIInUGXbjHi
   Qa5L26NajSB9kiEVI5LdquwZ3K/Pnzzplb66vMA3U8xaEr9veXhUUqd9p
   gcyupxhddjXKkbW6eyxL62dTeOyObY+Xw2e9rxK2/LkGp8RMqdGL0fZBd
   LEMjqjran/kx3VFtWfuj70YtE//aWOSglt3WVfYy4Y3iC18aLWZL6X05f
   Rwip8GxPU5GR36O0rJ8Bh/F8r0qARkn2K2mB+bsDw7PtgRiijdDBez0ON
   eb+krJoqgF31pAV/ov3HgYC/B1SkWn+UGW0ESrmaykhu3qQXFhQ7T5LNL
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="311223521"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="311223521"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 22:17:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="700667259"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="700667259"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga008.fm.intel.com with ESMTP; 09 Nov 2022 22:17:17 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernnel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, kevin.tian@intel.com
Subject: [PATCH 0/6] x86/traps,VMX: implement software based NMI/IRQ dispatch for VMX NMI/IRQ reinjection
Date:   Wed,  9 Nov 2022 21:53:41 -0800
Message-Id: <20221110055347.7463-1-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Upon receiving an external interrupt, KVM VMX reinjects it through
calling the interrupt handler in its IDT descriptor on the current
kernel stack, which essentially uses the IDT as an interrupt dispatch
table.

However the IDT is one of the lowest level critical data structures
between a x86 CPU and the Linux kernel, we should avoid using it
*directly* whenever possible, espeically in a software defined manner.

On x86, external interrupts are divided into the following groups
  1) system interrupts
  2) external device interrupts
With the IDT, system interrupts are dispatched through the IDT
directly, while external device interrupts are all routed to the
external interrupt dispatch function common_interrupt(), which
dispatches external device interrupts through a per-CPU external
interrupt dispatch table vector_irq.

Implement software based NMI/IRQ dispatch for VMX NMI/IRQ reinjection
to eliminate dispatching external interrupts through the IDT with adding
a system interrupt handler table for dispatching a system interrupt
to its corresponding handler directly. Thus a software based dispatch
function will be:

  void external_interrupt(struct pt_regs *regs, u8 vector)
  {
    if (is_system_interrupt(vector))
      system_interrupt_handler_table[vector_to_sysvec(vector)](regs);
    else /* external device interrupt */
      common_interrupt(regs, vector);
  }

And the software dispatch approach nukes a bunch of assembly.

What's more, with the Intel FRED (Flexible Return and Event Delivery)
architecture, IDT, the hardware based event dispatch table, is gone,
and the Linux kernel needs to dispatch events to their handlers with
vector to handler mappings, the dispatch function external_interrupt()
is also needed.

H. Peter Anvin (Intel) (1):
  x86/traps: let common_interrupt() handle IRQ_MOVE_CLEANUP_VECTOR

Xin Li (5):
  x86/traps: add a system interrupt table for system interrupt dispatch
  x86/traps: add install_system_interrupt_handler()
  x86/traps: add external_interrupt() to dispatch external interrupts
  KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq() for NMI/IRQ reinjection
  x86/traps: remove unused NMI entry exc_nmi_noist()

 arch/x86/include/asm/idtentry.h  |  15 -----
 arch/x86/include/asm/traps.h     |  12 ++++
 arch/x86/kernel/cpu/acrn.c       |   7 +-
 arch/x86/kernel/cpu/mshyperv.c   |  22 ++++---
 arch/x86/kernel/irq.c            |   4 ++
 arch/x86/kernel/kvm.c            |   4 +-
 arch/x86/kernel/nmi.c            |  10 ---
 arch/x86/kernel/traps.c          | 107 +++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmenter.S       |  33 ----------
 arch/x86/kvm/vmx/vmx.c           |  19 ++----
 drivers/xen/events/events_base.c |   5 +-
 11 files changed, 156 insertions(+), 82 deletions(-)

-- 
2.34.1

