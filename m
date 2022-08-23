Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCDE259EFA3
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 01:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbiHWXXu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 19:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiHWXXs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 19:23:48 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DDC895EB;
        Tue, 23 Aug 2022 16:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661297028; x=1692833028;
  h=from:to:cc:subject:date:message-id;
  bh=/r6rDwgWkkCE1tN6P9RzY0x7Kd+iQJ3tzAXrWfBRZlo=;
  b=M47vtwfwOFG8LHp+gzFJW/P1cnDdokR72010sE8XwxmqtgtufL33OggP
   mdQt9BmSl8pO5O8wFetA3I46WPFuPBzs1WBKdEgKfheb2cNlmO97eGyrK
   i6yIO3cCkl46cWf4P42ZcdySorhhVzapNbdjebjhhviBOItBMjso0q/lK
   YmSrtcjxMCMWBxheF81Ztlbna8HjJRvBGGtE4JLbUu10tbINzS6Dr6mXu
   H4fQcLzuWMT43qZm6CKCVrexlml39+UW5iQHOYhhXzdleqy/bQW2BBq3z
   onkJtoAOV/JRns8b9QXIUFVq3XDYp+JFUOLmJtwvwAvy8XqtDczW3jgr3
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10448"; a="355547570"
X-IronPort-AV: E=Sophos;i="5.93,259,1654585200"; 
   d="scan'208";a="355547570"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 16:23:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,259,1654585200"; 
   d="scan'208";a="605831215"
Received: from chang-linux-3.sc.intel.com ([172.25.66.173])
  by orsmga007.jf.intel.com with ESMTP; 23 Aug 2022 16:23:47 -0700
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     linux-kernel@vger.kernel.org, yang.zhong@intel.com,
        chang.seok.bae@intel.com
Subject: [RFC PATCH 0/2] KVM: x86: Add a new attribute to control dynamic XSTATE components
Date:   Tue, 23 Aug 2022 16:14:00 -0700
Message-Id: <20220823231402.7839-1-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.4 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi KVM folks,

While documenting the ARCH_{REQ|GET}_XCOMP_GUEST_PERM options [1], I came
to think of this new attribute as it can provide more consistent way of
enabling dynamic features for QEMU/KVM.

== Background ==

The new x86 arch_prctl() options [2] help to support dynamic AMX state
enabling. As the VCPU permission should be separate, additional options are
added for the userspace VMM like QEMU: ARCH_GET_XCOMP_GUEST_PERM and
ARCH_REQ_XCOMP_GUEST_PERM.

== Problem ==

KVM has already established a set of ioctls to control VM attributes. It
has the attribute to expose the KVM-supported XSTATE components [3].
This interface, however, is not necessarily compatible with those
arch_prctl() options. KVM may choose and expose some of the host-supported
features. Then using the host-provided interface may not comply with this
KVM policy.

== Solution ==

The patchset adds a new attribute to control XSTATE permission:
KVM_X86_XCOMP_GUEST_PERM, and it is available through the
KVM_GET_DEVICE_ATTR/KVM_SET_DEVICE_ATTR APIs. The KVM AMX test is updated
to use this. Then QEMU may switch to keep using the KVM API, which is more
consistent.

[1]: https://lore.kernel.org/lkml/ec95b28f-51a1-a9cf-7d72-a3a865797c7d@intel.com/
[2]: https://docs.kernel.org/x86/xstate.html
[3]: https://gitlab.com/qemu-project/qemu/-/blob/master/linux-headers/asm-x86/kvm.h#L456

Chang S. Bae (2):
  KVM: x86: Add a new system attribute for dynamic XSTATE component
  selftests: kvm: Use the KVM API to enable dynamic XSTATE features

 arch/x86/include/asm/fpu/api.h                |  1 +
 arch/x86/include/uapi/asm/kvm.h               |  1 +
 arch/x86/kernel/fpu/xstate.c                  |  6 ++++
 arch/x86/kvm/x86.c                            | 31 +++++++++++++++++++
 tools/arch/x86/include/uapi/asm/kvm.h         |  1 +
 .../selftests/kvm/lib/x86_64/processor.c      | 22 +++++++++----
 6 files changed, 56 insertions(+), 6 deletions(-)


base-commit: 1c23f9e627a7b412978b4e852793c5e3c3efc555
-- 
2.17.1

