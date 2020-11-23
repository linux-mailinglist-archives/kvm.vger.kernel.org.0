Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4802C04C0
	for <lists+kvm@lfdr.de>; Mon, 23 Nov 2020 12:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729000AbgKWLjv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Nov 2020 06:39:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:52500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726529AbgKWLjv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Nov 2020 06:39:51 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F27BF2073C;
        Mon, 23 Nov 2020 11:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606131590;
        bh=0UIU4HVD/JiG5U+u4RsuKKh3hEgOAsAPOUEnJ0oyqk4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q+nTExfrAFoGXJxebGNcj/i0n7QidFqfZK1qgrW0vMH5v+3P2p/SZPb0eLbc3GCQ2
         B5PWlsOz2enbiiUP0j+eMdl+cUXZ0rkJBSI5Jb3XBvKLAtwYPsjDkgV1Tkexr54OEV
         myK/qPy7FrEPKhoKjs1GlOcY3mFDNjKcnDeZ8k5A=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1khACB-00Ctnb-Ky; Mon, 23 Nov 2020 11:39:47 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 23 Nov 2020 11:39:47 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     darkhan@amazon.com
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, corbet@lwn.net,
        james.morse@arm.com, catalin.marinas@arm.com, chenhc@lemote.com,
        paulus@ozlabs.org, frankja@linux.ibm.com, mingo@redhat.com,
        acme@redhat.com, graf@amazon.de, darkhan@amazon.de
Subject: Re: [PATCH 0/3] Introduce new vcpu ioctls KVM_(GET|SET)_MANY_REGS
In-Reply-To: <20201120125616.14436-1-darkhan@amazon.com>
References: <20201120125616.14436-1-darkhan@amazon.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <287408cf179690f975daa4f665926d66@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: darkhan@amazon.com, pbonzini@redhat.com, kvm@vger.kernel.org, corbet@lwn.net, james.morse@arm.com, catalin.marinas@arm.com, chenhc@lemote.com, paulus@ozlabs.org, frankja@linux.ibm.com, mingo@redhat.com, acme@redhat.com, graf@amazon.de, darkhan@amazon.de
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-11-20 12:56, darkhan@amazon.com wrote:
> From: Darkhan Mukashov <darkhan@amazon.com>
> 
> The ultimate goal is to introduce new vcpu ioctls 
> KVM_(GET|SET)_MANY_REGS.
> To introduce these ioctls, implementations of KVM_(GET|SET)_ONE_REG 
> have
> to be refactored. Specifically, KVM_(GET|SET)_ONE_REG should be handled 
> in
> a generic kvm_vcpu_ioctl function.
> 
> New KVM APIs KVM_(GET|SET)_MANY_REGS make it possible to bulk 
> read/write
> vCPU registers at one ioctl call. These ioctls can be very useful when
> vCPU state serialization/deserialization is required (e.g. live update 
> of
> kvm, live migration of guests), hence all registers have to be
> saved/restored. KVM_(GET|SET)_MANY_REGS will help avoid performance
> overhead associated with syscall (ioctl in our case) handling. Tests
> conducted on AWS Graviton2 Processors (64-bit ARM Neoverse cores) show
> that average save/restore time of all vCPU registers can be optimized
> ~3.5 times per vCPU with new ioctls. Test results can be found in Table 
> 1.
> +---------+-------------+---------------+
> |         | kvm_one_reg | kvm_many_regs |
> +---------+-------------+---------------+
> | get all |   123 usec  |    33 usec    |
> +---------+-------------+---------------+
> | set all |   120 usec  |    36 usec    |
> +---------+-------------+---------------+
> 	Table 1. Test results

I have asked in private last week, and didn't get a satisfying answer:

We are talking about 90us over the time taken by enough state to be
transferred to the target so that it can be restarted. What proportion
does this represent? I'd expect userspace to do this from the vcpu
thread, and thus to be able to do everything in parallel, in which case
the gain doesn't scale with the number of vcpu.

One of the reasons for me being reluctant is that the userspace API
breaks extremely often, and that you are now adding yet another one
that can be used concurrently with the existing one.

So I would really like to see the whole picture, and not just this
very narrow "make it faster" approach. I also want to understand
why this is a "MANY" approach, and not "ALL".

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
