Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 167E52BE70
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 06:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbfE1Eyd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 00:54:33 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:57653 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726284AbfE1Eyc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 00:54:32 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 45ChMp2QYrz9s9T; Tue, 28 May 2019 14:54:30 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1559019270; bh=aC+6Lkv/34FxuxbKUC4fPrs6QGMEvkLgC2BtwfpcW8Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lk3nV4HTvMZX2ij/YZ7DMy6RTtwRhyG1V9JgRfIm935FAPiP0wtAz+YNSwG66d6+M
         6WNkbedQcJn5vKYkeC6gw+GDK7Patvi+flznc6VJckzknI3XD2Ee6qrcrzgNzmTj5g
         kORGbXOQ969Ah08j8rIun/k+mQComvAx8F0+8stvPFKcjvZO3+mErRb9xa1EJVvDGd
         52ncdzXEFfpnVMhU9IA1tgyppWann8HOif/XkRIKT751gfJW+ET1aPpOgG/ghWLlRQ
         zJvIFiIYCqNpUU3ww00WFBQegAgNF5K9faoSJ7zZlNc2N7nkoV5IezWdeRfU2Ph5wH
         EZbvms8axLwIg==
Date:   Tue, 28 May 2019 14:54:27 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 0/4] KVM: PPC: Book3S: Fix potential deadlocks
Message-ID: <20190528045427.fwbhxpjzcz2imqqk@oak.ozlabs.ibm.com>
References: <20190523063424.GB19655@blackberry>
 <3633e945-7126-c655-587d-e09eafb9f9f3@kaod.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3633e945-7126-c655-587d-e09eafb9f9f3@kaod.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 24, 2019 at 11:17:16AM +0200, Cédric Le Goater wrote:
> On 5/23/19 8:34 AM, Paul Mackerras wrote:
> > Recent reports of lockdep splats in the HV KVM code revealed that it
> > was taking the kvm->lock mutex in several contexts where a vcpu mutex
> > was already held.  Lockdep has only started warning since I added code
> > to take the vcpu mutexes in the XIVE device release functions, but
> > since Documentation/virtual/kvm/locking.txt specifies that the vcpu
> > mutexes nest inside kvm->lock, it seems that the new code is correct
> > and it is most of the old uses of kvm->lock that are wrong.
> > 
> > This series should fix the problems, by adding new mutexes that nest
> > inside the vcpu mutexes and using them instead of kvm->lock.
> 
> Hello,
> 
> I guest this warning when running a guest with this patchset :

Looks like we need the equivalent of 3309bec85e60 applied to the
p9/radix streamlined entry path.

Paul.
