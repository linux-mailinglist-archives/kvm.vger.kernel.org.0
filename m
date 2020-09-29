Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE30327BBA6
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 05:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbgI2DxB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 23:53:01 -0400
Received: from mga17.intel.com ([192.55.52.151]:63648 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726064AbgI2DxB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Sep 2020 23:53:01 -0400
IronPort-SDR: PSaEE/V5kVTMc36yVcOWeJpjD34M9z807+uZ24Zso1zXqmppG7Q2ixEgmsccYYVMXTcpMy2Tmf
 pe4j83Qo97zg==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="142130338"
X-IronPort-AV: E=Sophos;i="5.77,316,1596524400"; 
   d="scan'208";a="142130338"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 20:52:59 -0700
IronPort-SDR: hteUO/I0NkRZCWCqDL3H7Bh47P1tPJPqBYjCk6dgjVJo4jwAQFholEK4c5dCMLnGrHfNswXOR4
 bEWpDRx0rI0A==
X-IronPort-AV: E=Sophos;i="5.77,316,1596524400"; 
   d="scan'208";a="457102758"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 20:52:59 -0700
Date:   Mon, 28 Sep 2020 20:52:57 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Huacai Chen <chenhc@lemote.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        kvm-ppc@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: Re: [RFC PATCH 3/3] KVM: x86: Use KVM_BUG/KVM_BUG_ON to handle bugs
 that are fatal to the VM
Message-ID: <20200929035257.GH31514@linux.intel.com>
References: <20200923224530.17735-1-sean.j.christopherson@intel.com>
 <20200923224530.17735-4-sean.j.christopherson@intel.com>
 <878scze4l5.fsf@vitty.brq.redhat.com>
 <20200924181134.GB9649@linux.intel.com>
 <87k0wichht.fsf@vitty.brq.redhat.com>
 <20200925171233.GC31528@linux.intel.com>
 <731dd323-8c66-77ff-cf15-4bbdea34bcf9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <731dd323-8c66-77ff-cf15-4bbdea34bcf9@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 25, 2020 at 11:06:10PM +0200, Paolo Bonzini wrote:
> On 25/09/20 19:12, Sean Christopherson wrote:
> >> Do we actually want to prevent *all* ioctls? E.g. when 'vm bugged'
> >> condition is triggered userspace may want to extract some information to
> >> assist debugging but even things like KVM_GET_[S]REGS will just return
> >> -EIO. I'm not sure it is generally safe to enable *everything* (except
> >> for KVM_RUN which should definitely be forbidden) so maybe your approach
> >> is preferable.
> >
> > The answer to this probably depends on the answer to the first question of
> > when it's appropriate to use KVM_BUG().  E.g. if we limit usage to fatal or
> > dangrous cases, then blocking all ioctls() is probably the right thing do do.
> 
> I think usage should be limited to dangerous cases, basically WARN_ON
> level.  However I agree with Vitaly that KVM_GET_* should be allowed.

Makes sense.

On the topic of feedback from Vitaly, while dredging through my mailbox I
rediscovered his suggestion of kvm->kvm_internal_bug (or maybe just
kvm->internal_bug) instead of kvm->vm_bugged[*].  Like past me, I like the
"internal" variants better.

[*] https://lkml.kernel.org/r/20190930153358.GD14693@linux.intel.com

> The other question is whether to return -EIO or KVM_EXIT_INTERNAL_ERROR.
>  The latter is more likely to be handled already by userspace.

And probably less confusing for unsuspecting users.  E.g. -EIO is most
likely to be interpreted as "I screwed up", whereas KVM_EXIT_INTERNAL_ERROR
will correctly be read as "KVM screwed up".
