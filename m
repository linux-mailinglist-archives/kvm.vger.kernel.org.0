Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBCFF7BA63B
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 18:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbjJEQce (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 12:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235633AbjJEQaz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 12:30:55 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8502660F;
        Thu,  5 Oct 2023 09:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1696523292; x=1728059292;
  h=date:message-id:cc:subject:from:to:mime-version:
   content-transfer-encoding:references:in-reply-to;
  bh=s/3kePokIc8Scb81vfgX7JZyGS6TBG9a+EGPzfosJzQ=;
  b=CkU0HpTTO8n3nFji1wcF7wYaa5po8BU0BxiIk41lcwWQXrrBPyyIbr3E
   h0jSeX50P9rkjCAIVS/luOr2xeNK6979Y9b2q3uykNUppqe16YQ6B+Eue
   x0aQcbYA0svBqEOuzkBpNpP1+veIFY7tZxZApHR9NBcVypBzMr3txFAub
   Y=;
X-IronPort-AV: E=Sophos;i="6.03,203,1694736000"; 
   d="scan'208";a="368009614"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-d23e07e8.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2023 16:28:04 +0000
Received: from EX19D004EUC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-iad-1d-m6i4x-d23e07e8.us-east-1.amazon.com (Postfix) with ESMTPS id 9862B808BA;
        Thu,  5 Oct 2023 16:28:01 +0000 (UTC)
Received: from localhost (10.13.235.138) by EX19D004EUC001.ant.amazon.com
 (10.252.51.190) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.37; Thu, 5 Oct
 2023 16:27:58 +0000
Content-Type: text/plain; charset="UTF-8"
Date:   Thu, 5 Oct 2023 16:27:54 +0000
Message-ID: <CW0NB512KP2E.2ZZD07F49LND3@amazon.com>
CC:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>,
        <linux-kernel@vger.kernel.org>, <graf@amazon.de>,
        <dwmw2@infradead.org>, <fgriffo@amazon.com>, <anelkz@amazon.de>,
        <peterz@infradead.org>
Subject: Re: [RFC] KVM: Allow polling vCPUs for events
From:   Nicolas Saenz Julienne <nsaenz@amazon.com>
To:     Sean Christopherson <seanjc@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: aerc 0.15.2-21-g30c1a30168df-dirty
References: <20231001111313.77586-1-nsaenz@amazon.com>
 <ZR35gq1NICwhOUAS@google.com>
In-Reply-To: <ZR35gq1NICwhOUAS@google.com>
X-Originating-IP: [10.13.235.138]
X-ClientProxiedBy: EX19D032UWA002.ant.amazon.com (10.13.139.81) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,
Thanks for taking the time to look at this.

On Wed Oct 4, 2023 at 11:47 PM UTC, Sean Christopherson wrote:
[...]
> > @@ -3996,6 +4002,39 @@ static int kvm_vcpu_mmap(struct file *file, stru=
ct vm_area_struct *vma)
> >       return 0;
> >  }
> >
> > +static __poll_t kvm_vcpu_poll(struct file *file, poll_table *wait)
> > +{
> > +     struct kvm_vcpu *vcpu =3D file->private_data;
> > +
> > +     if (!vcpu->poll_mask)
> > +             return EPOLLERR;
> > +
> > +     switch (READ_ONCE(vcpu->mode)) {
> > +     case OUTSIDE_GUEST_MODE:
> > +             /*
> > +              * Make sure writes to vcpu->request are visible before t=
he
> > +              * mode changes.
> > +              */
>
> Huh?  There are no writes to vcpu->request anywhere in here.

My thinking was the vcpu->requests load below could've been speculated
ahead of vcpu->mode's store, this will miss events when first entering
poll().

Since you pointed this out, I thought about it further. There is still
room for a race with the code as is, we need read vcpu->requests only
after poll_wait() returns, so as to make sure concurrent
kvm_make_request()/kvm_vcpu_kick() either wake up poll, or are visible
through the vcpu->requests check that precedes sleeping.

[...]

> > +             WRITE_ONCE(vcpu->mode, OUTSIDE_GUEST_MODE);
>
> This does not look remotely safe on multiple fronts.  For starters, I don=
't see
> anything in the .poll() infrastructure that provides serialization, e.g. =
if there
> are multiple tasks polling then this will be "interesting".

Would allowing only one poller be acceptable?

> And there is zero chance this is race-free, e.g. nothing prevents the vCP=
U task
> itself from changing vcpu->mode from POLLING_FOR_EVENTS to something else=
.
>
> Why on earth is this mucking with vcpu->mode?  Ignoring for the moment th=
at using
> vcpu->requests as the poll source is never going to happen, there's zero =
reason

IIUC accessing vcpu->requests in the kvm_vcpu_poll() is out of the
question? Aren't we're forced to do so in order to avoid the race I
mention above.

> to write vcpu->mode.  From a correctness perspective, AFAICT there's no n=
eed for
> any shenanigans at all, i.e. kvm_make_vcpu_request() could blindly and un=
conditionally
> call wake_up_interruptible().

I was fixated with the halt/vtl_return use-cases, where we're either
running the vCPU or polling, and it seemed a decent way to policy
whether calling wake_up_interruptible() is needed. Clearly not the case,
I'll get rid of all the vcpu->mode mucking. :)

> I suspect what you want is a fast way to track if there *may* be pollers.=
  Keying
> off and *writing* vcpu->mode makes no sense to me.
>
> I think what you want is something like this, where kvm_vcpu_poll() could=
 use
> atomic_fetch_or() and atomic_fetch_andnot() to manipulate vcpu->poll_mask=
.
> Or if we only want to support a single poller at a time, it could be a va=
nilla
> u64.  I suspect getting the poll_mask manipulation correct for multiple p=
ollers
> would be tricky, e.g. to avoid false negatives and leave a poller hanging=
.

I'll have a go at the multiple poller approach.

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 486800a7024b..5a260fb3b248 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -259,6 +259,14 @@ static inline bool kvm_kick_many_cpus(struct cpumask=
 *cpus, bool wait)
>         return true;
>  }
>
> +static inline bool kvm_request_is_being_polled(struct kvm_vcpu *vcpu,
> +                                              unsigned int req)
> +{
> +       u32 poll_mask =3D kvm_request_to_poll_mask(req);
> +
> +       return (atomic_read(vcpu->poll_mask) & poll_mask)
> +}
> +
>  static void kvm_make_vcpu_request(struct kvm_vcpu *vcpu, unsigned int re=
q,
>                                   struct cpumask *tmp, int current_cpu)
>  {
> @@ -285,6 +293,9 @@ static void kvm_make_vcpu_request(struct kvm_vcpu *vc=
pu, unsigned int req,
>                 if (cpu !=3D -1 && cpu !=3D current_cpu)
>                         __cpumask_set_cpu(cpu, tmp);
>         }
> +
> +       if (kvm_request_is_being_polled(vcpu, req))
> +               wake_up_interruptible(...);
>  }
>
>  bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,

I'll use this approach.

So since we have to provide a proper uAPI, do you have anything against
having user-space set the polling mask through an ioctl? Also any
suggestions on how kvm_request_to_poll_mask() should look like. For ex.
VSM mostly cares for regular interrupts/timers, so mapping

  KVM_REQ_UNBLOCK, KVM_REQ_HV_STIMER, KVM_REQ_EVENT, KVM_REQ_SMI,
  KVM_REQ_NMI

to a KVM_POLL_INTERRUPTS_FLAG would work. We can then have ad-hoc flags
for async-pf, kvmclock updates, dirty logging, etc...

Nicolas
