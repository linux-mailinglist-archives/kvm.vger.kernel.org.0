Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64DCE2BE25
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 06:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfE1ERV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 00:17:21 -0400
Received: from ozlabs.org ([203.11.71.1]:46775 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725817AbfE1ERV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 00:17:21 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 45CgXt22Cwz9s9T; Tue, 28 May 2019 14:17:18 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1559017038; bh=RdOxf3E5tUxsnW9M7gQbLgLEnpJ6TP1HLUx0MdurcxU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ER6OfrX3EWqrh+4q3VkjQffXpfag8PIeUeTA3OWvh6b1sTBIdGGiMqcLTGvIkHOKo
         Rz9Di6Q8oK05sDQRG417jp99AMEvJ3F3loJoCXX0Nnh2jm24jJJp12AJsrRTQlgbUb
         nc28cuHE34YPu0u0uhMQB0RkNgGXuwUjl/tUryqwQd/9XqgHv4Dy7iPMWkUN5EVbCm
         EH9FbIZy4HP/Oihh/NADR2eFAIZHMAAwcffOCH4hMikImB6+/z5GJWgxl3hBae+14F
         la24vW29vJsmvmt7MU85cP2z7HI2CLNqzl2kvMPZWpdDBre7jKHULL0S9mTHK4U3K1
         pi3WWsknb9i4A==
Date:   Tue, 28 May 2019 14:17:11 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Greg Kurz <groug@kaod.org>
Cc:     =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH] KVM: PPC: Book3S HV: XIVE: introduce a KVM device lock
Message-ID: <20190528041711.ewohm2pdrya5ompz@oak.ozlabs.ibm.com>
References: <20190524132030.6349-1-clg@kaod.org>
 <20190524201621.23eb7c44@bahia.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190524201621.23eb7c44@bahia.lan>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Greg,

On Fri, May 24, 2019 at 08:16:21PM +0200, Greg Kurz wrote:
> On Fri, 24 May 2019 15:20:30 +0200
> Cédric Le Goater <clg@kaod.org> wrote:
> 
> > The XICS-on-XIVE KVM device needs to allocate XIVE event queues when a
> > priority is used by the OS. This is referred as EQ provisioning and it
> > is done under the hood when :
> > 
> >   1. a CPU is hot-plugged in the VM
> >   2. the "set-xive" is called at VM startup
> >   3. sources are restored at VM restore
> > 
> > The kvm->lock mutex is used to protect the different XIVE structures
> > being modified but in some contextes, kvm->lock is taken under the
> > vcpu->mutex which is a forbidden sequence by KVM.
> > 
> > Introduce a new mutex 'lock' for the KVM devices for them to
> > synchronize accesses to the XIVE device structures.
> > 
> > Signed-off-by: Cédric Le Goater <clg@kaod.org>
> > ---
> >  arch/powerpc/kvm/book3s_xive.h        |  1 +
> >  arch/powerpc/kvm/book3s_xive.c        | 23 +++++++++++++----------
> >  arch/powerpc/kvm/book3s_xive_native.c | 15 ++++++++-------
> >  3 files changed, 22 insertions(+), 17 deletions(-)
> > 
> > diff --git a/arch/powerpc/kvm/book3s_xive.h b/arch/powerpc/kvm/book3s_xive.h
> > index 426146332984..862c2c9650ae 100644
> > --- a/arch/powerpc/kvm/book3s_xive.h
> > +++ b/arch/powerpc/kvm/book3s_xive.h
> > @@ -141,6 +141,7 @@ struct kvmppc_xive {
> >  	struct kvmppc_xive_ops *ops;
> >  	struct address_space   *mapping;
> >  	struct mutex mapping_lock;
> > +	struct mutex lock;
> >  };
> >  
> >  #define KVMPPC_XIVE_Q_COUNT	8
> > diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
> > index f623451ec0a3..12c8a36dd980 100644
> > --- a/arch/powerpc/kvm/book3s_xive.c
> > +++ b/arch/powerpc/kvm/book3s_xive.c
> > @@ -271,14 +271,14 @@ static int xive_provision_queue(struct kvm_vcpu *vcpu, u8 prio)
> >  	return rc;
> >  }
> >  
> > -/* Called with kvm_lock held */
> > +/* Called with xive->lock held */
> >  static int xive_check_provisioning(struct kvm *kvm, u8 prio)
> >  {
> >  	struct kvmppc_xive *xive = kvm->arch.xive;
> 
> Since the kvm_lock isn't protecting kvm->arch anymore, this looks weird.

Are you suggesting that something that was protected before now isn't
with Cédric's patch?

> Passing xive instead of kvm and using xive->kvm would make more sense IMHO.
> 
> Maybe fold the following into your patch ?

As far as I can see your delta patch doesn't actually change any
locking but just rationalizes the parameters for an internal
function.  That being so, for 5.2 I am intending to put Cédric's
original patch in, unless someone comes up with a good reason not to.

Paul.
