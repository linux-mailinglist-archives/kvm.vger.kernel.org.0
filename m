Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781933DA939
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 18:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhG2Qie (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 12:38:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:25602 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229620AbhG2Qic (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 12:38:32 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10060"; a="209812830"
X-IronPort-AV: E=Sophos;i="5.84,278,1620716400"; 
   d="scan'208";a="209812830"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2021 09:38:28 -0700
X-IronPort-AV: E=Sophos;i="5.84,278,1620716400"; 
   d="scan'208";a="507347688"
Received: from wye1-mobl1.ccr.corp.intel.com (HELO localhost) ([10.249.174.73])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2021 09:38:25 -0700
Date:   Fri, 30 Jul 2021 00:38:22 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>, Yan Zhao <yan.y.zhao@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: A question of TDP unloading.
Message-ID: <20210729163822.ubzszrvnnmol4zlr@linux.intel.com>
References: <20210727161957.lxevvmy37azm2h7z@linux.intel.com>
 <YQBLZ/RrBFxE4G4w@google.com>
 <20210728065605.e4ql2hzrj5fkngux@linux.intel.com>
 <20210728072514.GA375@yzhao56-desk.sh.intel.com>
 <CANgfPd_Rt3udm8mUHzX=MaXPOafkXhUt++7ACNsG1PnPiLswnw@mail.gmail.com>
 <20210728172241.aizlvj2alvxfvd43@linux.intel.com>
 <CANgfPd_o+HC80aqTQn7CA3o4rN2AFPDUp_Jxj9CQ6Rie9+yAug@mail.gmail.com>
 <20210729030056.uk644q3eeoux2qfa@linux.intel.com>
 <dd09360e-436e-4e66-faad-656c8aa9cee2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd09360e-436e-4e66-faad-656c8aa9cee2@redhat.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 29, 2021 at 11:19:08AM +0200, Paolo Bonzini wrote:
> On 29/07/21 05:00, Yu Zhang wrote:
> > > I have a few questions about these unnecessary tear-downs during boot:
> > > 1. How many teardowns did you observe, and how many different roles
> > > did they represent? Just thrashing between two roles, or 12 different
> > > roles?
> > I saw 106 reloadings of the root TDP. Among them, 14 are caused by memslot
> > changes. Remaining ones are caused by the context reset from CR0/CR4/EFER
> > changes(85 for CR0 changes).
> 
> Possibly because CR0/CR4/EFER are changed multiple times on SMM entry (to go
> from real mode to protected mode to 32-bit to 64-bit)?  But most of those
> page tables should be very very small; they probably have only one page per
> level.  The SMM page tables are very small too, the only one that is really
> expensive to rebuild is the main non-SMM EPT.

Thanks Paolo. 

Well, I did not see any SMM entry in the whole test. And most resetings
are due to CR0 changes in OVMF(74 out of 85), the rest are from guest
kernel initialization stage.

As expected, the number of SPs used are fairly small - about 5 - 10 for
each TDP tree. For legcy TDP, since only 4 different TDP trees are built(
the ones caused by memslot zapping are not counted). The total number of
SPs are only 30+.

B.R.
Yu
> 
> Paolo
> 
