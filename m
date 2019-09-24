Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07944BC9BA
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 16:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436845AbfIXOFN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 24 Sep 2019 10:05:13 -0400
Received: from 2.mo179.mail-out.ovh.net ([178.33.250.45]:48616 "EHLO
        2.mo179.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392022AbfIXOFN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 10:05:13 -0400
X-Greylist: delayed 4198 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Sep 2019 10:05:12 EDT
Received: from player157.ha.ovh.net (unknown [10.108.35.223])
        by mo179.mail-out.ovh.net (Postfix) with ESMTP id 83436141D1F
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 13:50:08 +0200 (CEST)
Received: from kaod.org (deibp9eh1--blueice1n4.emea.ibm.com [195.212.29.166])
        (Authenticated sender: groug@kaod.org)
        by player157.ha.ovh.net (Postfix) with ESMTPSA id 69B17A1A10C8;
        Tue, 24 Sep 2019 11:49:56 +0000 (UTC)
Date:   Tue, 24 Sep 2019 13:49:54 +0200
From:   Greg Kurz <groug@kaod.org>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?B?Q8OpZHJpYw==?= Le Goater <clg@kaod.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 1/6] KVM: PPC: Book3S HV: XIVE: initialize private
 pointer when VPs are allocated
Message-ID: <20190924134954.2a6bf5f4@bahia.lan>
In-Reply-To: <20190924052855.GA7950@oak.ozlabs.ibm.com>
References: <156925341155.974393.11681611197111945710.stgit@bahia.lan>
        <156925341736.974393.18379970954169086891.stgit@bahia.lan>
        <20190924052855.GA7950@oak.ozlabs.ibm.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Ovh-Tracer-Id: 211669184222501307
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedufedrfedtgdegvdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 24 Sep 2019 15:28:55 +1000
Paul Mackerras <paulus@ozlabs.org> wrote:

> On Mon, Sep 23, 2019 at 05:43:37PM +0200, Greg Kurz wrote:
> > From: Cédric Le Goater <clg@kaod.org>
> > 
> > Do not assign the device private pointer before making sure the XIVE
> > VPs are allocated in OPAL and test pointer validity when releasing
> > the device.
> > 
> > Fixes: 5422e95103cf ("KVM: PPC: Book3S HV: XIVE: Replace the 'destroy' method by a 'release' method")
> > Signed-off-by: Cédric Le Goater <clg@kaod.org>
> > Signed-off-by: Greg Kurz <groug@kaod.org>
> 
> What happens in the case where the OPAL allocation fails?  Does the
> host crash, or hang, or leak resources?  I presume that users can
> trigger the allocation failure just by starting a suitably large
> number of guests - is that right?  Is there an easier way?  I'm trying
> to work out whether this is urgently needed in 5.4 and the stable
> trees or not.
> 

Wait... I don't quite remember how this patch landed in my tree but when
I look at it again I have the impression it tries to fix something that
cannot happen.

It is indeed easy to trigger the allocation failure, eg. start more than
127 guests on a Witherspoon system. But if this happens, the create
function returns an error and the device isn't created. I don't see how
the release function could hence get called with a "partially initialized"
device.

Please ignore this patch. Unfortunately the rest of the series doesn't
apply cleanly without it... I'll rebase and post a v2.

Sorry for the noise :-\

> Paul.

