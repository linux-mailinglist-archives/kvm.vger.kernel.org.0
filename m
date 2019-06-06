Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9903D37374
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 13:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727601AbfFFLwu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 07:52:50 -0400
Received: from smtp.lucina.net ([62.176.169.44]:59844 "EHLO smtp.lucina.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727574AbfFFLwu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 07:52:50 -0400
Received: from nodbug.lucina.net (78-141-76-187.dynamic.orange.sk [78.141.76.187])
        by smtp.lucina.net (Postfix) with ESMTPSA id 4D89D122804
        for <kvm@vger.kernel.org>; Thu,  6 Jun 2019 13:52:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lucina.net;
        s=dkim-201811; t=1559821969;
        bh=XSZTQlQ28VPqPcvvc56kZYvHL/MgVYAABSdRpPLL1N8=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=lY8GO8I7zSmIOcIosoZn6/XNq4S9318uS76zZNKUzlKVtCY8/TRH8HuyIJlsqds7W
         1oS7rABLZZa//BlEJLvIsrWfgnRqJ6rn6+FthoN6naIeDaIXuJm405wbrB7x+bEC84
         4BCyHYv8svl+KJCfT9lDb+/X1Y+3u+ZGUe1OxlhLwtLsAhNWMRjgikx7sPdffkHCED
         F/aozzZa/csGpIL47ffWzX9yDNMK8Xj4SHlFDAPVyP2RTqSfSV7P6OhP8uwPvLQOfV
         ePeO9DZOxiKdZrqi1FUJqJq+Dcyf4EzVJb/yOPkM8z7DjjETJ8n06p21znA/aUR9L7
         GZTHP4OIu7+XA==
Received: by nodbug.lucina.net (Postfix, from userid 1000)
        id 2B246268437A; Thu,  6 Jun 2019 13:52:49 +0200 (CEST)
Date:   Thu, 6 Jun 2019 13:52:49 +0200
From:   Martin Lucina <martin@lucina.net>
To:     kvm@vger.kernel.org
Subject: Re: Interaction between host-side mprotect() and KVM MMU
Message-ID: <20190606115249.exu2kyrtxvsuqqa4@nodbug.lucina.net>
Mail-Followup-To: kvm@vger.kernel.org
References: <20190521072434.p4rtnbkerk5jqwh4@nodbug.lucina.net>
 <20190521140238.GA22089@linux.intel.com>
 <20190523092703.ddze6zcfsm2cj6kc@nodbug.lucina.net>
 <20190524192659.GE365@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190524192659.GE365@linux.intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Friday, 24.05.2019 at 12:26, Sean Christopherson wrote:
> On Thu, May 23, 2019 at 11:27:03AM +0200, Martin Lucina wrote:
> > On Tuesday, 21.05.2019 at 07:02, Sean Christopherson wrote:
> > > Not without modifying KVM and the kernel (if you want to do it through
> > > mprotect()).
> > 
> > Hooking up the full EPT protection bits available to KVM via mprotect()
> > would be the best solution for us, and could also give us the ability to
> > have execute-only pages on x86, which is a nice defence against ROP attacks
> > in the guest. However, I can see now that this is not a trivial
> > undertaking, especially across the various MMU models (tdp, softmmu) and
> > architectures dealt with by the core KVM code.
> 
> Belated thought on this...
> 
> Propagating PROT_EXEC from the host's VMAs to the EPT tables would require
> having *guest* memory mapped with PROT_EXEC in the host.  This is a
> non-starter for traditional virtualization as it would all but require the
> hypervisor to have RWX pages.
> 
> For the Solo5 case, since the guest is untrusted, mapping its code as
> executable in the host seems almost as bad from a security perspective.
> 
> So yeah, mprotect() might be convenient, but adding a KVM_MEM_NOEXEC
> flag to KVM_SET_USER_MEMORY_REGION would be more secure (and probably
> easier to implement in KVM).

This is a good point, and it had slipped my mind. Thanks for bringing it
up. So it looks like the correct way forward would be to use individual
memslots for the different Solo5 guest regions rather than mprotect() from
the host, i.e. splitting the protection bits at all the different layers
(host, EPT/TDP, guest).

This does change our architecture somewhat, I'll think about how it could
work and come back to this, am in the middle of some feature work right
now.

Thanks for the feedback.
