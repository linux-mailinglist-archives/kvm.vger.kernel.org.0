Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A44F375D22
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 00:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbhEFWWR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 18:22:17 -0400
Received: from mga03.intel.com ([134.134.136.65]:61547 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230149AbhEFWWR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 18:22:17 -0400
IronPort-SDR: l5Nwb3MMSG+czVOfpGIhcD9ItSTAPy0LhK2auwsz1UE3Y1/c9EdUu+ssiTKlxfLC3Sx8HgdxV+
 Eix8kt0Rp5Mg==
X-IronPort-AV: E=McAfee;i="6200,9189,9976"; a="198648173"
X-IronPort-AV: E=Sophos;i="5.82,279,1613462400"; 
   d="scan'208";a="198648173"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2021 15:21:16 -0700
IronPort-SDR: i1sq+7gNyR7zXwaRtfWBg/jo8+giv/RiL5obO5NFc5iZ60UyxngQn2i4d3yfXxQw6LcoRlhHNw
 0XJ81EpGmQow==
X-IronPort-AV: E=Sophos;i="5.82,279,1613462400"; 
   d="scan'208";a="390879404"
Received: from sangbara-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.86.237])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2021 15:21:13 -0700
Message-ID: <ea3238d8b55ac39de01cdf202af2be009c395277.camel@intel.com>
Subject: Re: [PATCH 2/3] KVM: x86/mmu: Fix pf_fixed count in
 tdp_mmu_map_handle_target_level()
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ben Gardon <bgardon@google.com>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Date:   Fri, 07 May 2021 10:21:11 +1200
In-Reply-To: <YJQLXH/qebWuzLmF@google.com>
References: <cover.1620200410.git.kai.huang@intel.com>
         <23b565dd3b3dfa20aea1c13bce01163f9427a237.1620200410.git.kai.huang@intel.com>
         <CANgfPd-hf-+trgTWe=pjjuWSEyVn8F4WyZ4p5kqaMiqghjseew@mail.gmail.com>
         <193d473bdfcefa8a552a787025642eb90d3b9e18.camel@intel.com>
         <YJQLXH/qebWuzLmF@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0 (3.40.0-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-05-06 at 15:29 +0000, Sean Christopherson wrote:
> On Thu, May 06, 2021, Kai Huang wrote:
> > On Wed, 2021-05-05 at 09:11 -0700, Ben Gardon wrote:
> > > It would probably also be worth putting a comment on pf_fixed so that
> > > people in the future know what it's supposed to mean and we don't get
> > > into archeology, reverse engineering the meaning of the stat again.
> > 
> > It seems the legacy MMU code path is a better place to add the comment to explain when
> > pf_fixed should be increased.  However I am not sure whether it is necessary for this
> > patch (and I confess I found it's hard to explain why to increase pf_fixed in case of
> > emulation :)).  Or perhaps Sean can write a patch to add comment to legacy MMU :)
> 
> Ya, I think it makes sense to hold off on documenting the existing behavior in
> the TDP MMU.  As is often the case in KVM, just because KVM has always done
> something one way, doesn't mean it's correct/ideal.  But, bikeshedding over what
> faults exactly should count towards pf_fixed is best left to a separate patch.
> 
> > I ended up with  below, by adding a comment in TDP MMU saying "to make it consistent with
> > legacy MMU...", and in the commit message, I put a lore link of this discussion, since I
> > found Sean's explanation is quite useful. When people are interested in, they can do a git
> > blame and find the commit msg of this change -- although it is not as straightforward as
> > having comment directly.
> > 
> > Is this OK to you?
> > 
> > And Sean?
> 
> Yep, works for me.

Thanks!

