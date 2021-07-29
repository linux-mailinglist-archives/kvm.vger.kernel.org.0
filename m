Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A577E3D9DD6
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 08:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbhG2GtQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 02:49:16 -0400
Received: from mga07.intel.com ([134.134.136.100]:3944 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234283AbhG2GtN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 02:49:13 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10059"; a="276597652"
X-IronPort-AV: E=Sophos;i="5.84,278,1620716400"; 
   d="scan'208";a="276597652"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2021 23:49:09 -0700
X-IronPort-AV: E=Sophos;i="5.84,278,1620716400"; 
   d="scan'208";a="506987458"
Received: from yzhao56-desk.sh.intel.com ([10.239.13.16])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2021 23:49:07 -0700
Date:   Thu, 29 Jul 2021 14:34:16 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: A question of TDP unloading.
Message-ID: <20210729063415.GA22427@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <YQBLZ/RrBFxE4G4w@google.com>
 <20210728065605.e4ql2hzrj5fkngux@linux.intel.com>
 <20210728072514.GA375@yzhao56-desk.sh.intel.com>
 <CANgfPd_Rt3udm8mUHzX=MaXPOafkXhUt++7ACNsG1PnPiLswnw@mail.gmail.com>
 <20210728172241.aizlvj2alvxfvd43@linux.intel.com>
 <CANgfPd_o+HC80aqTQn7CA3o4rN2AFPDUp_Jxj9CQ6Rie9+yAug@mail.gmail.com>
 <20210729030056.uk644q3eeoux2qfa@linux.intel.com>
 <20210729025809.GA9585@yzhao56-desk.sh.intel.com>
 <20210729051743.amqn3cizcwxf5q7n@linux.intel.com>
 <20210729051739.GA19566@yzhao56-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729051739.GA19566@yzhao56-desk.sh.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > Sorry? Do you mean your VM needs 5 minute to boot? What is your configuration?
> >
> yes. the VM needs 5 minutes to boot when I forced enable_unrestricted_guest=0 in kvm.
> 
> > VMX unrestricted guest has been supported on all Intel platforms since years 
> > ago. I do not see any reason to disable it.
> >
> yes. just for test purpose.
> To study the impact to the mode enable_unrestricted_guest=0,
> since in this mode, cr0, cr4 causes lots of vmexit.

one correction. actually with enable_unrestricted_guest=0, it has less
number of kvm_set_cr0(), but more kvm_mmu_reset_context() called from
kvm_set_cr0().
 ___________________________________________________________________
|                            |  #cr0  |#reset_context from cr0| #cr4|
| ---------------------------|--------|-----------------------|-----|
|enable_unrestricted_guest=0 | 627405 |      313704           | 13  | 
|----------------------------|--------|-----------------------|-----|
|enable_unrestricted_guest=1 |2092493 |       5               | 13  |
--------------------------------------------------------------------
