Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF40A1F984F
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 15:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730372AbgFONWY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 09:22:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730024AbgFONWX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jun 2020 09:22:23 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52D24207DA;
        Mon, 15 Jun 2020 13:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592227342;
        bh=uy4ahmE9ucum8lJbLe9wqzS3k/FOFR4SdCtLdG3Gq0I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CuiJ8IZe30mcAP9RdYGckkauU+SBTZGV7fC5FPDiJq+tGsEDbRMQL7rvSkd5ArOww
         pPN+rmqegIMnx9RrOmwVAGu1H1PSl6bEY6Bj27lqFHlcZA0IWmy9tmDUik6+EGl1lp
         0SnhAKmINch4ZJTNpeFW3P/3R7GaCD6LN1FU1xP4=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jkp47-0036qq-TS; Mon, 15 Jun 2020 14:22:20 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 15 Jun 2020 14:22:19 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Dave Martin <Dave.Martin@arm.com>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kernel-team@android.com
Subject: Re: [PATCH 0/4] KVM/arm64: Enable PtrAuth on non-VHE KVM
In-Reply-To: <20200615125920.GJ25945@arm.com>
References: <20200615081954.6233-1-maz@kernel.org>
 <20200615125920.GJ25945@arm.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <dd0e5196a4e7baf4d0f8fba2b00e9ef5@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: Dave.Martin@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Dave,

On 2020-06-15 13:59, Dave Martin wrote:
> On Mon, Jun 15, 2020 at 09:19:50AM +0100, Marc Zyngier wrote:
>> Not having PtrAuth on non-VHE KVM (for whatever reason VHE is not
>> enabled on a v8.3 system) has always looked like an oddity. This
>> trivial series remedies it, and allows a non-VHE KVM to offer PtrAuth
>> to its guests.
> 
> How likely do you think it is that people will use such a 
> configuration?

Depending on the use case, very. See below.

> The only reason I can see for people to build a kernel with 
> CONFIG_VHE=n
> is as a workaround for broken hardware, or because the kernel is too 
> old
> to support VHE (in which case it doesn't understand ptrauth either, so
> it is irrelevant whether ptrauth depends on VHE).

Part of the work happening around running protected VMs (which cannot
be tampered with from EL1/0 host) makes it mandatory to disable VHE,
so that we can wrap the host EL1 in its own Stage-2 page tables.
We (the Android kernel team) are actively working on enabling this
feature.

> I wonder whether it's therefore better to "encourage" people to turn
> VHE on by making subsequent features depend on it where appropriate.
> We do want multiplatform kernels to be configured with CONFIG_VHE=y for
> example.

I'm all for having VHE on for platforms that support it. Which is why
CONFIG_VHE=y is present in defconfig. However, we cannot offer the same
level of guarantee as we can hopefully achieve with non-VHE (we can
drop mappings from Stage-1, but can't protect VMs from an evil or
compromised host). This is a very different use case from the usual
"reduced hypervisor overhead" that we want in the general case.

> I ask this, because SVE suffers the same "oddity".  If SVE can be
> enabled for non-VHE kernels straightforwardly then there's no reason 
> not
> to do so, but I worried in the past that this would duplicate complex
> code that would never be tested or used.

It is a concern. I guess that if we manage to get some traction on
Android, then the feature will get some testing! And yes, SVE is
next on my list.

> If supporting ptrauth with !VHE is as simple as this series suggests,
> then it's low-risk.  Perhaps SVE isn't much worse.  I was chasing nasty
> bugs around at the time the SVE KVM support was originally written, and
> didn't want to add more unknowns into the mix...

I think having started with a slightly smaller problem space was the
right thing to do at the time. We are now reasonably confident that
KVM and SVE are working correctly together, and we can now try to enable
it on !VHE.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
