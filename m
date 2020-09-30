Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBE227EFCA
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 18:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730897AbgI3Q5l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 12:57:41 -0400
Received: from mga06.intel.com ([134.134.136.31]:40787 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgI3Q5k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 12:57:40 -0400
IronPort-SDR: 0npcKAL53ecuQhJjqC8MKfUR2KrfCxK3kNpAa68bDL9vC89OS2eTeElxR706r5pNFRvcZhYYY/
 lQ3E5m748v2g==
X-IronPort-AV: E=McAfee;i="6000,8403,9760"; a="224090047"
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="224090047"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 09:57:39 -0700
IronPort-SDR: xgByRAS1TUQW6FtwogJdlBUEjw+uFGJXHQTS2GTLfGkhvG3qi1lGYOLmsck3UytTgMIQ/Y4qiq
 0fyK6ra7Qqyg==
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="350727926"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 09:57:37 -0700
Date:   Wed, 30 Sep 2020 09:57:34 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH 03/22] kvm: mmu: Init / Uninit the TDP MMU
Message-ID: <20200930165734.GE32672@linux.intel.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-4-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925212302.3979661-4-bgardon@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 25, 2020 at 02:22:43PM -0700, Ben Gardon wrote:
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> new file mode 100644
> index 0000000000000..8241e18c111e6
> --- /dev/null
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -0,0 +1,34 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#include "tdp_mmu.h"
> +
> +static bool __read_mostly tdp_mmu_enabled = true;
> +module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0644);

This param should not exist until the TDP MMU is fully functional, e.g. running
KVM against "kvm: mmu: Support zapping SPTEs in the TDP MMU" immediately hits a
BUG() in the rmap code.  I haven't wrapped my head around the entire series to
grok whether it make sense to incrementally enable the TDP MMU, but my gut says
that's probably non-sensical.  The local variable can exist (default to false)
so that you can flip a single switch to enable the code instead of having to
plumb in the variable to its consumers.

  kernel BUG at arch/x86/kvm/mmu/mmu.c:1427!
  invalid opcode: 0000 [#1] SMP
  CPU: 4 PID: 1218 Comm: stable Not tainted 5.9.0-rc4+ #44
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:rmap_get_first.isra.0+0x51/0x60 [kvm]
  Code: <0f> 0b 45 31 c0 4c 89 c0 c3 66 0f 1f 44 00 00 0f 1f 44 00 00 49 b9
  RSP: 0018:ffffc9000099fb50 EFLAGS: 00010246
  RAX: 0000000000000000 RBX: 0000000000001000 RCX: 0000000000000000
  RDX: ffffc9000099fb60 RSI: ffffc9000099fb58 RDI: ffff88816b1a7ec8
  RBP: ffff88816b1a7e70 R08: ffff888173c95000 R09: ffff88816b1a7448
  R10: 00000000000000f8 R11: ffff88817bd29c70 R12: ffffc90000981000
  R13: ffffc9000099fbac R14: ffffc90000989a88 R15: ffff88816b1a7ec8
  FS:  00007f7a755fd700(0000) GS:ffff88817bd00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007f7a60141000 CR3: 000000016b031004 CR4: 0000000000172ea0
  Call Trace:
   __kvm_mmu_prepare_zap_page+0x98/0x330 [kvm]
   kvm_mmu_zap_all_fast+0x100/0x190 [kvm]
   kvm_page_track_flush_slot+0x54/0x80 [kvm]
   kvm_set_memslot+0x198/0x640 [kvm]
   kvm_delete_memslot+0x59/0xc0 [kvm]
   __kvm_set_memory_region+0x494/0x560 [kvm]
   ? khugepaged+0x470/0x2230
   ? mem_cgroup_charge_statistics.isra.0+0x1c/0x40
   kvm_set_memory_region+0x27/0x40 [kvm]
   kvm_vm_ioctl+0x379/0xca0 [kvm]
   ? do_user_addr_fault+0x1ad/0x3a7
   __x64_sys_ioctl+0x83/0xb0
   do_syscall_64+0x33/0x80
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
