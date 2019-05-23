Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0832827801
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 10:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729632AbfEWIbq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 May 2019 04:31:46 -0400
Received: from ozlabs.org ([203.11.71.1]:37523 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726070AbfEWIbq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 May 2019 04:31:46 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 458jQm0YZsz9sBK; Thu, 23 May 2019 18:31:43 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1558600304; bh=4kBURcQVJzDPrCq6q/MXFRgJRYWW/rL/Bj54OJHxbFE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oNs8DqoUx9vWoMPj/KncpAaRSJBNCCZBP19vOKl0LHGDjk2KYxef0UgAA7j8HqcIM
         AmCkQk+oYU14tf00NRrHn3RqDPjnlb8EeXmnpSAxMN/MBr8FNaMvHIpSokRHyyosh6
         i8KruwXowO9YOGirb0QBisoAIHFX5TP3co06Cem2Y5EU6U+OtmOcAV+ftkbJXeDvTL
         rupWyiVjtTqxFxjkx0WXivSQy2yCuBIQ/Angas+BMDus/lUqQuIp7OUco4OOt6kIpY
         3LzCOaHtxfzLYrejn29uN09yKkAfWfKVnDe6FepAH+5ZHgPCYXwRCG9ImGF8asfuGR
         I22+L5nOZYXwQ==
Date:   Thu, 23 May 2019 18:31:39 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>
Subject: Re: [PATCH 0/4] KVM: PPC: Book3S: Fix potential deadlocks
Message-ID: <20190523083139.GB27043@blackberry>
References: <20190523063424.GB19655@blackberry>
 <3d159268-3645-bbf0-8f99-306c9ca68611@ozlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d159268-3645-bbf0-8f99-306c9ca68611@ozlabs.ru>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 23, 2019 at 05:21:00PM +1000, Alexey Kardashevskiy wrote:
> 
> 
> On 23/05/2019 16:34, Paul Mackerras wrote:
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
> 
> I applied these 4, compiled, installed, rebooted, tried running a guest
> (which failed because I also updated QEMU and its cli has changed), got
> this. So VM was created and then destroyed without executing a single
> instruction, if that matters.

Looks like I need to remove the
	lockdep_assert_held(&kvm->arch.rtas_token_lock);

in kvmppc_rtas_tokens_free().  We don't have the rtas_token_lock, but
it doesn't matter because we are destroying the VM and nothing else
has a reference to it by now.

Paul.
