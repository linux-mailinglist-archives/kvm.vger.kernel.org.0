Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97E673D7AD0
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 18:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbhG0QUI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 12:20:08 -0400
Received: from mga14.intel.com ([192.55.52.115]:10128 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229441AbhG0QUH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 12:20:07 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10057"; a="212201125"
X-IronPort-AV: E=Sophos;i="5.84,274,1620716400"; 
   d="scan'208";a="212201125"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2021 09:20:02 -0700
X-IronPort-AV: E=Sophos;i="5.84,274,1620716400"; 
   d="scan'208";a="505949944"
Received: from nwang2-mobl1.ccr.corp.intel.com (HELO localhost) ([10.249.173.89])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2021 09:19:59 -0700
Date:   Wed, 28 Jul 2021 00:19:57 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>
Cc:     kvm@vger.kernel.org
Subject: A question of TDP unloading.
Message-ID: <20210727161957.lxevvmy37azm2h7z@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

  I'd like to ask a question about kvm_reset_context(): is there any
  reason that we must alway unload TDP root in kvm_mmu_reset_context()?
  
  As you know, KVM MMU needs to track guest paging mode changes, to
  recalculate the mmu roles and reset callback routines(e.g., guest
  page table walker). These are done in kvm_mmu_reset_context(). Also,
  entering SMM, cpuid updates, and restoring L1 VMM's host state will
  trigger kvm_mmu_reset_context() too.
  
  Meanwhile, another job done by kvm_mmu_reset_context() is to unload
  the KVM MMU:
  
  - For shadow & legacy TDP, it means to unload the root shadow/TDP
    page and reconstruct another one in kvm_mmu_reload(), before
    entering guest. Old shadow/TDP pages will probably be reused later,
    after future guest paging mode switches.
  
  - For TDP MMU, it is even more aggressive, all TDP pages will be
    zapped, meaning a whole new TDP page table will be recontrustred,
    with each paging mode change in the guest. I witnessed dozens of
    rebuildings of TDP when booting a Linux guest(besides the ones
    caused by memslots rearrangement).
  
  However, I am wondering, why do we need the unloading, if GPA->HPA
  relationship is not changed? And if this is not a must, could we
  find a way to refactor kvm_mmu_reset_context(), so that unloading
  of TDP root is only performed when necessary(e.g, SMM switches and
  maybe after cpuid updates which may change the level of TDP)? 
  
  I tried to add a parameter in kvm_mmu_reset_context(), to make the
  unloading optional:  

+void kvm_mmu_reset_context(struct kvm_vcpu *vcpu, bool force_tdp_unload)
 {
-       kvm_mmu_unload(vcpu);
+       if (!tdp_enabled || force_tdp_unload)
+               kvm_mmu_unload(vcpu);
+
        kvm_init_mmu(vcpu);
 }

  But this change brings another problem - if we keep the TDP root, the
  role of existing SPs will be obsolete after guest paging mode changes.
  Altough I guess most role flags are irrelevant in TDP, I am not sure
  if this could cause any trouble.
  
  Is there anyone looking at this issue? Or do you have any suggestion?
  Thanks!
  
B.R.
Yu

