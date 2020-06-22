Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 427722034F8
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 12:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgFVKjw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 06:39:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:50840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727113AbgFVKjw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 06:39:52 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80FC4206FA;
        Mon, 22 Jun 2020 10:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592822391;
        bh=dgm7kjeoShRXdQis73vvUuIZrsj5DaDNqgHFNWcsw3Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S2oqL5OT+ITpyFdrgk4+bxcZAFW/FLK52PcA/biEqraUAECNSX51/R5fzxvk2f7WB
         UZAqUvp6800mgPzpJVP1UgHxUjFIhx+Vr4r85xUfOyDqkQFtKx5pQWnolc5lfZtUZ3
         +aVaTL+FXQM5zI0NYlNCAtqiefaCGGTkIjQrkO6E=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jnJrh-005Hny-Qi; Mon, 22 Jun 2020 11:39:50 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 22 Jun 2020 11:39:49 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, steven.price@arm.com
Subject: Re: [PATCH 2/4] arm64/x86: KVM: Introduce steal time cap
In-Reply-To: <20200622103146.fwtr7z3l3mnq4foh@kamzik.brq.redhat.com>
References: <20200619184629.58653-1-drjones@redhat.com>
 <20200619184629.58653-3-drjones@redhat.com>
 <5b1e895dc0c80bef3c0653894e2358cf@kernel.org>
 <20200622084110.uosiqx3oy22lremu@kamzik.brq.redhat.com>
 <5a52210e5f123d52459f15c594e77bad@kernel.org>
 <20200622103146.fwtr7z3l3mnq4foh@kamzik.brq.redhat.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <7118fcbe911bdb30374b400dc01ca8de@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: drjones@redhat.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, steven.price@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-06-22 11:31, Andrew Jones wrote:
> On Mon, Jun 22, 2020 at 10:51:47AM +0100, Marc Zyngier wrote:
>> On 2020-06-22 09:41, Andrew Jones wrote:
>> > On Mon, Jun 22, 2020 at 09:20:02AM +0100, Marc Zyngier wrote:
>> > > Hi Andrew,
>> > >
>> > > On 2020-06-19 19:46, Andrew Jones wrote:
>> > > > arm64 requires a vcpu fd (KVM_HAS_DEVICE_ATTR vcpu ioctl) to probe
>> > > > support for steal time. However this is unnecessary and complicates
>> > > > userspace (userspace may prefer delaying vcpu creation until after
>> > > > feature probing). Since probing steal time only requires a KVM fd,
>> > > > we introduce a cap that can be checked.
>> > >
>> > > So this is purely an API convenience, right? You want a way to
>> > > identify the presence of steal time accounting without having to
>> > > create a vcpu? It would have been nice to have this requirement
>> > > before we merged this code :-(.
>> >
>> > Yes. I wish I had considered it more closely when I was reviewing the
>> > patches. And, I believe we have yet another user interface issue that
>> > I'm looking at now. Without the VCPU feature bit I'm not sure how easy
>> > it will be for a migration to fail when attempting to migrate from a
>> > host
>> > with steal-time enabled to one that does not support steal-time. So it's
>> > starting to look like steal-time should have followed the pmu pattern
>> > completely, not just the vcpu device ioctl part.
>> 
>> Should we consider disabling steal time altogether until this is 
>> worked out?
> 
> I think we can leave it alone and just try to resolve it before merging
> QEMU patches (which I'm working on now). It doesn't look like kvmtool 
> or
> rust-vmm (the only other two KVM userspaces I'm paying some attention 
> to)
> do anything with steal-time yet, so they won't notice. And, I'm not 
> sure
> disabling steal-time for any other userspaces is better than just 
> trying
> to keep them working the best we can while improving the uapi.

Is it only migration that is affected? Or do you see issues that would
affect non-migrating userspace?

[...]

>> Accepting the pvtime attributes (setting up the per-vcpu area) has two
>> effects: we promise both the guest and userspace that we will provide
>> the guest with steal time. By not checking sched_info_on(), we lie to
>> both, with potential consequences. It really feels like a bug.
> 
> Yes, I agree now. Again, following the pmu pattern looks best here. The
> pmu will report that it doesn't have the attr support when its 
> underlying
> kernel support (perf counters) doesn't exist. That's a direct analogy 
> with
> steal-time relying on sched_info_on().

Indeed. I'd be happy to take a fix early if you can spin one.

> I'll work up another version of this series doing that, but before 
> posting
> I'll look at the migration issue a bit more and likely post something 
> for
> that as well.

OK. I'll park this series for now.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
