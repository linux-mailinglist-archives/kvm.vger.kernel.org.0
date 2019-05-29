Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5230F2DC7E
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 14:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbfE2MNH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 29 May 2019 08:13:07 -0400
Received: from 2.mo173.mail-out.ovh.net ([178.33.251.49]:53596 "EHLO
        2.mo173.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfE2MNH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 May 2019 08:13:07 -0400
Received: from player711.ha.ovh.net (unknown [10.108.35.103])
        by mo173.mail-out.ovh.net (Postfix) with ESMTP id BD84E10135C
        for <kvm@vger.kernel.org>; Wed, 29 May 2019 14:03:59 +0200 (CEST)
Received: from kaod.org (lns-bzn-46-82-253-208-248.adsl.proxad.net [82.253.208.248])
        (Authenticated sender: groug@kaod.org)
        by player711.ha.ovh.net (Postfix) with ESMTPSA id 4F69D63843BA;
        Wed, 29 May 2019 12:03:53 +0000 (UTC)
Date:   Wed, 29 May 2019 14:03:52 +0200
From:   Greg Kurz <groug@kaod.org>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     =?UTF-8?B?Q8OpZHJpYw==?= Le Goater <clg@kaod.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH] KVM: PPC: Book3S HV: XIVE: introduce a KVM device lock
Message-ID: <20190529140352.318c5990@bahia.lab.toulouse-stg.fr.ibm.com>
In-Reply-To: <20190528041711.ewohm2pdrya5ompz@oak.ozlabs.ibm.com>
References: <20190524132030.6349-1-clg@kaod.org>
 <20190524201621.23eb7c44@bahia.lan>
 <20190528041711.ewohm2pdrya5ompz@oak.ozlabs.ibm.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Ovh-Tracer-Id: 8443967828062345659
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddruddvjedggeelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 28 May 2019 14:17:11 +1000
Paul Mackerras <paulus@ozlabs.org> wrote:

> Greg,
> 
> On Fri, May 24, 2019 at 08:16:21PM +0200, Greg Kurz wrote:
> > On Fri, 24 May 2019 15:20:30 +0200
> > Cédric Le Goater <clg@kaod.org> wrote:
> >   
> > > The XICS-on-XIVE KVM device needs to allocate XIVE event queues when a
> > > priority is used by the OS. This is referred as EQ provisioning and it
> > > is done under the hood when :
> > > 
> > >   1. a CPU is hot-plugged in the VM
> > >   2. the "set-xive" is called at VM startup
> > >   3. sources are restored at VM restore
> > > 
> > > The kvm->lock mutex is used to protect the different XIVE structures
> > > being modified but in some contextes, kvm->lock is taken under the
> > > vcpu->mutex which is a forbidden sequence by KVM.
> > > 
> > > Introduce a new mutex 'lock' for the KVM devices for them to
> > > synchronize accesses to the XIVE device structures.
> > > 
> > > Signed-off-by: Cédric Le Goater <clg@kaod.org>
> > > ---
> > >  arch/powerpc/kvm/book3s_xive.h        |  1 +
> > >  arch/powerpc/kvm/book3s_xive.c        | 23 +++++++++++++----------
> > >  arch/powerpc/kvm/book3s_xive_native.c | 15 ++++++++-------
> > >  3 files changed, 22 insertions(+), 17 deletions(-)
> > > 
> > > diff --git a/arch/powerpc/kvm/book3s_xive.h b/arch/powerpc/kvm/book3s_xive.h
> > > index 426146332984..862c2c9650ae 100644
> > > --- a/arch/powerpc/kvm/book3s_xive.h
> > > +++ b/arch/powerpc/kvm/book3s_xive.h
> > > @@ -141,6 +141,7 @@ struct kvmppc_xive {
> > >  	struct kvmppc_xive_ops *ops;
> > >  	struct address_space   *mapping;
> > >  	struct mutex mapping_lock;
> > > +	struct mutex lock;
> > >  };
> > >  
> > >  #define KVMPPC_XIVE_Q_COUNT	8
> > > diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
> > > index f623451ec0a3..12c8a36dd980 100644
> > > --- a/arch/powerpc/kvm/book3s_xive.c
> > > +++ b/arch/powerpc/kvm/book3s_xive.c
> > > @@ -271,14 +271,14 @@ static int xive_provision_queue(struct kvm_vcpu *vcpu, u8 prio)
> > >  	return rc;
> > >  }
> > >  
> > > -/* Called with kvm_lock held */
> > > +/* Called with xive->lock held */
> > >  static int xive_check_provisioning(struct kvm *kvm, u8 prio)
> > >  {
> > >  	struct kvmppc_xive *xive = kvm->arch.xive;  
> > 
> > Since the kvm_lock isn't protecting kvm->arch anymore, this looks weird.  
> 
> Are you suggesting that something that was protected before now isn't
> with Cédric's patch?
> 

Hi Paul,

No I'm not. As you point out below, it is just a matter of rationalizing the
arguments of xive_check_provisioning().

> > Passing xive instead of kvm and using xive->kvm would make more sense IMHO.
> > 
> > Maybe fold the following into your patch ?  
> 
> As far as I can see your delta patch doesn't actually change any
> locking but just rationalizes the parameters for an internal
> function.  That being so, for 5.2 I am intending to put Cédric's
> original patch in, unless someone comes up with a good reason not to.
> 

I certainly don't have such reason :)

Reviewed-by: Greg Kurz <groug@kaod.org>

> Paul.

