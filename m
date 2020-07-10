Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 575EF21BC2A
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 19:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgGJR0a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 13:26:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:55820 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726872AbgGJR03 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 13:26:29 -0400
IronPort-SDR: sBMxgZXQ7/HlO/Vgn5B8vc0vfmbcMF6ghsKuO+dPjcyKVIy9yfCYHHOtILSq24g25RsUz3Y3Ek
 qUoyWerRXEcQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9678"; a="166344401"
X-IronPort-AV: E=Sophos;i="5.75,336,1589266800"; 
   d="scan'208";a="166344401"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2020 10:26:29 -0700
IronPort-SDR: U2wWVGzF2bxDUqpiBke8rVdzvyD32ZflqGnpjfRh/e1i84exrqHBiLoaYeob2jrZHndhW4TMpQ
 +0052cJ5dJuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,336,1589266800"; 
   d="scan'208";a="306613436"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga004.fm.intel.com with ESMTP; 10 Jul 2020 10:26:28 -0700
Date:   Fri, 10 Jul 2020 10:26:28 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Mohammed Gamal <mgamal@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v3 0/9] KVM: Support guest MAXPHYADDR < host MAXPHYADDR
Message-ID: <20200710172628.GH1749@linux.intel.com>
References: <20200710154811.418214-1-mgamal@redhat.com>
 <CALMp9eRfZ50iyrED0-LU75VWhHu_kVoB2Qw55VzEFzZ=0QCGow@mail.gmail.com>
 <0c892b1e-6fe6-2aa7-602e-f5fadc54c257@redhat.com>
 <CALMp9eQXHGnXo4ACX2-qYww4XdRODMn-O6CAvhupib67Li9S2w@mail.gmail.com>
 <9e784c62-15ee-63b7-4942-474493bac536@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e784c62-15ee-63b7-4942-474493bac536@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 10, 2020 at 07:16:14PM +0200, Paolo Bonzini wrote:
> On 10/07/20 19:13, Jim Mattson wrote:
> > On Fri, Jul 10, 2020 at 10:06 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>
> >> On 10/07/20 18:30, Jim Mattson wrote:
> >>>>
> >>>> This can be problem when having a mixed setup of machines with 5-level page
> >>>> tables and machines with 4-level page tables, as live migration can change
> >>>> MAXPHYADDR while the guest runs, which can theoretically introduce bugs.
> >>>
> >>> Huh? Changing MAXPHYADDR while the guest runs should be illegal. Or
> >>> have I missed some peculiarity of LA57 that makes MAXPHYADDR a dynamic
> >>> CPUID information field?
> >>
> >> Changing _host_ MAXPHYADDR while the guest runs, such as if you migrate
> >> from a host-maxphyaddr==46 to a host-maxphyaddr==52 machine (while
> >> keeping guest-maxphyaddr==46).
> > 
> > Ah, but what does that have to do with LA57?
> 
> Intel only has MAXPHYADDR > 46 on LA57 machines (because in general OSes
> like to have a physical 1:1 map into the kernel part of the virtual
> address space, so having a higher MAXPHYADDR would be of limited use
> with 48-bit linear addresses).
> 
> In other words, while this issue has existed forever it could be ignored
> until IceLake introduced MAXPHYADDR==52 machines.  I'll introduce
> something like this in a commit message.

Yeah, the whole 5-level vs. 4-level thing needs clarification.  Using 5-level
doesn't magically change the host's MAXPA.  But using 5-level vs. 4-level EPT
does change the guest's effective MAXPA.

If the changelog is referring purely to host MAXPA, then just explicitly
state that and don't even mention 5-level vs. 4-level.
