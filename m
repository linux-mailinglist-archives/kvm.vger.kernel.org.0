Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2973825CDF7
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 00:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729541AbgICWoh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 18:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728697AbgICWoh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Sep 2020 18:44:37 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A21AC061244;
        Thu,  3 Sep 2020 15:44:37 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4BjG8H2M5Nz9sTr; Fri,  4 Sep 2020 08:44:31 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1599173071; bh=KRd/t+/UkdW64sjFFWsE/w9PqOrIadpQpj6cLAsh6Hc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iaSmwdam3j0i8/vx9I09NdW3jxfgxdeUsYtwv3ki9t5GXsaaTTT6K0KDOI3bRWAaP
         Fvol7JYgfpH0qVav8kZk0yXXLkC7NZWKQV267qAX39N0hjuNxFJKZ8xcsWy5unK2MG
         DpxvRieqezgq6/ju7Khmvyu4o+EmFpMEqSKHedfv4n4nk78zh0L5DThf7FSEoPbTkD
         y4lZWvdtH9N9/sz15nCIg+79REMMj2h0fuRMOML8sZNWCYlVnwgkuqYniTJ1BPnIrG
         m9Z5IUyJccNZwt86HfXbHymRDm50JoFBvA19rdP0A6J/KJ3rQdcoxvNd7seWmlt64z
         2Cda1rplY6fFA==
Date:   Fri, 4 Sep 2020 08:44:26 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Greg Kurz <groug@kaod.org>
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: PPC: Book3S HV: XICS: Replace the 'destroy' method
 by a 'release' method
Message-ID: <20200903224426.GJ272502@thinks.paulus.ozlabs.org>
References: <159705408550.1308430.10165736270896374279.stgit@bahia.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159705408550.1308430.10165736270896374279.stgit@bahia.lan>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 10, 2020 at 12:08:05PM +0200, Greg Kurz wrote:
> Similarly to what was done with XICS-on-XIVE and XIVE native KVM devices
> with commit 5422e95103cf ("KVM: PPC: Book3S HV: XIVE: Replace the 'destroy'
> method by a 'release' method"), convert the historical XICS KVM device to
> implement the 'release' method. This is needed to run nested guests with
> an in-kernel IRQ chip. A typical POWER9 guest can select XICS or XIVE
> during boot, which requires to be able to destroy and to re-create the
> KVM device. Only the historical XICS KVM device is available under pseries
> at the current time and it still uses the legacy 'destroy' method.
> 
> Switching to 'release' means that vCPUs might still be running when the
> device is destroyed. In order to avoid potential use-after-free, the
> kvmppc_xics structure is allocated on first usage and kept around until
> the VM exits. The same pointer is used each time a KVM XICS device is
> being created, but this is okay since we only have one per VM.
> 
> Clear the ICP of each vCPU with vcpu->mutex held. This ensures that the
> next time the vCPU resumes execution, it won't be going into the XICS
> code anymore.
> 
> Signed-off-by: Greg Kurz <groug@kaod.org>

Thanks, applied to my kvm-ppc-next branch.

Paul.
