Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50F82151C97
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 15:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbgBDOwO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 09:52:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53835 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727267AbgBDOwN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 09:52:13 -0500
Received: from [187.32.88.249] (helo=calabresa)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <cascardo@canonical.com>)
        id 1iyzYe-0002qd-S8; Tue, 04 Feb 2020 14:52:09 +0000
Date:   Tue, 4 Feb 2020 11:51:53 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] KVM: Pre-allocate 1 cpumask variable per cpu for both pv
 tlb and pv ipis
Message-ID: <20200204145059.GJ40679@calabresa>
References: <CANRm+CwwYoSLeA3Squp-_fVZpmYmxEfqOB+DGoQN4Y_iMT347w@mail.gmail.com>
 <878slio6hp.fsf@vitty.brq.redhat.com>
 <CANRm+CzkN9oYf4UqWYp2SHFii02=pvVLbW4oNkLmPan7ZroDZA@mail.gmail.com>
 <20200204142733.GI40679@calabresa>
 <871rrao1mr.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871rrao1mr.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 04, 2020 at 03:42:04PM +0100, Vitaly Kuznetsov wrote:
> Thadeu Lima de Souza Cascardo <cascardo@canonical.com> writes:
> 
> >> > >      /*
> >> > > @@ -624,6 +625,7 @@ static void __init kvm_guest_init(void)
> >> > >          kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
> >> > >          pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
> >> > >          pv_ops.mmu.tlb_remove_table = tlb_remove_table;
> >> > > +        pr_info("KVM setup pv remote TLB flush\n");
> >> > >      }
> >> > >
> >
> > I am more concerned about printing the "KVM setup pv remote TLB flush" message,
> > not only when KVM pv is used, but pv TLB flush is not going to be used, but
> > also when the system is not even paravirtualized.
> 
> Huh? In Wanpeng's patch this print is under
> 
> 	if (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
> 	    !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
> 	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME))
> 
> and if you mean another patch we descussed before which was adding
>  (!kvm_para_available() || nopv) check than it's still needed. Or,
> alternatively, we can make kvm_para_has_feature() check for that.
> 
> -- 
> Vitaly
> 

Yes, that's what I mean. Though not printing that when allocating the cpumasks
would fix this particular symptom, anyway.

But yes, it doesn't make sense to do all those feature checks when there is no
paravirtualization.

I believe we are in agreement.

Cascardo.
