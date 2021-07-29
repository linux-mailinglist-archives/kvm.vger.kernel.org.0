Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86FFA3D9C05
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 05:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbhG2DNM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 23:13:12 -0400
Received: from mga04.intel.com ([192.55.52.120]:24335 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233297AbhG2DNK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 23:13:10 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10059"; a="210908867"
X-IronPort-AV: E=Sophos;i="5.84,276,1620716400"; 
   d="scan'208";a="210908867"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2021 20:13:07 -0700
X-IronPort-AV: E=Sophos;i="5.84,276,1620716400"; 
   d="scan'208";a="506877323"
Received: from yzhao56-desk.sh.intel.com ([10.239.13.16])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2021 20:13:06 -0700
Date:   Thu, 29 Jul 2021 10:58:15 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: A question of TDP unloading.
Message-ID: <20210729025809.GA9585@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20210727161957.lxevvmy37azm2h7z@linux.intel.com>
 <YQBLZ/RrBFxE4G4w@google.com>
 <20210728065605.e4ql2hzrj5fkngux@linux.intel.com>
 <20210728072514.GA375@yzhao56-desk.sh.intel.com>
 <CANgfPd_Rt3udm8mUHzX=MaXPOafkXhUt++7ACNsG1PnPiLswnw@mail.gmail.com>
 <20210728172241.aizlvj2alvxfvd43@linux.intel.com>
 <CANgfPd_o+HC80aqTQn7CA3o4rN2AFPDUp_Jxj9CQ6Rie9+yAug@mail.gmail.com>
 <20210729030056.uk644q3eeoux2qfa@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729030056.uk644q3eeoux2qfa@linux.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 29, 2021 at 11:00:56AM +0800, Yu Zhang wrote:
> > 
> > Ooof that's a lot of resets, though if there are only a handful of
> > pages mapped, it might not be a noticeable performance impact. I think
> > it'd be worth collecting some performance data to quantify the impact.
> 
> Yes. Too many reset will definitely hurt the performance, though I did not see
> obvious delay.
>

if I add below limits before unloading mmu, and with
enable_unrestricted_guest=0, the boot time can be reduced to 31 secs
from more than 5 minutes. 

 void kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
 {
-       kvm_mmu_unload(vcpu);
-       kvm_init_mmu(vcpu, true);
+       union kvm_mmu_role new_role =
+               kvm_calc_tdp_mmu_root_page_role(vcpu, false);
+       struct kvm_mmu *context = &vcpu->arch.root_mmu;
+       bool reset = false;
+
+       if (new_role.as_u64 != context->mmu_role.as_u64) {
+               kvm_mmu_unload(vcpu);
+               reset = true;
+       }
+       kvm_init_mmu(vcpu, reset);

But with enable_unrestricted_guest=0, if I further modify the limits to
"if (new_role.base.word != context->mmu_role.base.word)", the VM would
fail to boot.
so, with mmu extended role changes, unload the mmu is necessary in some
situation, or at least we need to zap related sptes.

Thanks
Yan
