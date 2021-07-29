Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C62B3D9D0A
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 07:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbhG2FRx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 01:17:53 -0400
Received: from mga03.intel.com ([134.134.136.65]:34960 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229973AbhG2FRw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 01:17:52 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10059"; a="212836981"
X-IronPort-AV: E=Sophos;i="5.84,278,1620716400"; 
   d="scan'208";a="212836981"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2021 22:17:49 -0700
X-IronPort-AV: E=Sophos;i="5.84,278,1620716400"; 
   d="scan'208";a="518021092"
Received: from wye1-mobl1.ccr.corp.intel.com (HELO localhost) ([10.249.174.73])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2021 22:17:46 -0700
Date:   Thu, 29 Jul 2021 13:17:43 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: A question of TDP unloading.
Message-ID: <20210729051743.amqn3cizcwxf5q7n@linux.intel.com>
References: <20210727161957.lxevvmy37azm2h7z@linux.intel.com>
 <YQBLZ/RrBFxE4G4w@google.com>
 <20210728065605.e4ql2hzrj5fkngux@linux.intel.com>
 <20210728072514.GA375@yzhao56-desk.sh.intel.com>
 <CANgfPd_Rt3udm8mUHzX=MaXPOafkXhUt++7ACNsG1PnPiLswnw@mail.gmail.com>
 <20210728172241.aizlvj2alvxfvd43@linux.intel.com>
 <CANgfPd_o+HC80aqTQn7CA3o4rN2AFPDUp_Jxj9CQ6Rie9+yAug@mail.gmail.com>
 <20210729030056.uk644q3eeoux2qfa@linux.intel.com>
 <20210729025809.GA9585@yzhao56-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729025809.GA9585@yzhao56-desk.sh.intel.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 29, 2021 at 10:58:15AM +0800, Yan Zhao wrote:
> On Thu, Jul 29, 2021 at 11:00:56AM +0800, Yu Zhang wrote:
> > > 
> > > Ooof that's a lot of resets, though if there are only a handful of
> > > pages mapped, it might not be a noticeable performance impact. I think
> > > it'd be worth collecting some performance data to quantify the impact.
> > 
> > Yes. Too many reset will definitely hurt the performance, though I did not see
> > obvious delay.
> >
> 
> if I add below limits before unloading mmu, and with
> enable_unrestricted_guest=0, the boot time can be reduced to 31 secs
> from more than 5 minutes. 

Sorry? Do you mean your VM needs 5 minute to boot? What is your configuration?

VMX unrestricted guest has been supported on all Intel platforms since years 
ago. I do not see any reason to disable it.

B.R.
Yu

> 
>  void kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
>  {
> -       kvm_mmu_unload(vcpu);
> -       kvm_init_mmu(vcpu, true);
> +       union kvm_mmu_role new_role =
> +               kvm_calc_tdp_mmu_root_page_role(vcpu, false);
> +       struct kvm_mmu *context = &vcpu->arch.root_mmu;
> +       bool reset = false;
> +
> +       if (new_role.as_u64 != context->mmu_role.as_u64) {
> +               kvm_mmu_unload(vcpu);
> +               reset = true;
> +       }
> +       kvm_init_mmu(vcpu, reset);
> 
> But with enable_unrestricted_guest=0, if I further modify the limits to
> "if (new_role.base.word != context->mmu_role.base.word)", the VM would
> fail to boot.
> so, with mmu extended role changes, unload the mmu is necessary in some
> situation, or at least we need to zap related sptes.
> 
> Thanks
> Yan
