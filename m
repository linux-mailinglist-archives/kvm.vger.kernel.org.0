Return-Path: <kvm+bounces-18652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DF53C8D838C
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 15:10:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E0AD1C224A6
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 13:10:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 244F912C814;
	Mon,  3 Jun 2024 13:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="niL7G3te"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D3312C528;
	Mon,  3 Jun 2024 13:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717420237; cv=none; b=FxELW0R1udcwi/xAgZAgC3Ed6Qn5KcQ4Mk9gpTchWG/1Rzs+rq/tAdxWXQcULwXzgbeWj7d6l6SwA/pBeHGqoLBEx+QV0yp0O72DpiwiPblWHKzimlcmmLSZOTz49HEf8uUGO0YHfxKBn0evau1VB94DuYTQEkpV8/jE67wW7u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717420237; c=relaxed/simple;
	bh=/U+/VxmSixKZ9uDr/+sYfe+DKCQqxNMHObH457JSDVY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F43QYfgXqELhb9BWkfK17iw/5JEmmbS+XSdMoa1igHE/J5MUfdGszICFs/W9O2J7aFeGpO+gijRWa5bLTugKBVzF6jDe9eQlzqd+GTmun07Ft4CUcYtc2I4yOS+o/QWpp4vXI1sgODK0plHDj4BVTSTwH6EYdjy7iZ0TkKipyRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=niL7G3te; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D258C2BD10;
	Mon,  3 Jun 2024 13:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717420236;
	bh=/U+/VxmSixKZ9uDr/+sYfe+DKCQqxNMHObH457JSDVY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=niL7G3teA3ZpMeqqGERZKifChBdGxIzUii/571g4IMuK3na3aK3RTt6aCs1ybtmCO
	 UKc4dyis8hBygdPykI50IiqTFGRS0ZXt6jRGdCfFSc/H+ot84DL/s2xneWGftP4jPP
	 4b1Ca1+KzFwHMykS1fnN3a2OAisg588BzCMtiNlz8wXarV5HdrvdfsGcYpLmBwzup1
	 sfMIb5/8cnGMSyR9pRyMPsxU8ny/BCccFbwk4iPziTv0Kozei1Sn3hUc1dREPYceqi
	 81bHSmEvOL1fGpoomE1LgjXElTMyGHFjf1UW7IOIBRjPPQ1SDuR166XvtMRWV62XtP
	 IcGkkCZfLVg7A==
Date: Mon, 3 Jun 2024 14:10:32 +0100
From: Will Deacon <will@kernel.org>
To: =?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v3 09/12] KVM: arm64: VHE: Add test module for hyp kCFI
Message-ID: <20240603131031.GB18991@willie-the-truck>
References: <20240510112645.3625702-1-ptosi@google.com>
 <20240510112645.3625702-10-ptosi@google.com>
 <20240513172120.GA29051@willie-the-truck>
 <lsb5l4ee4unh76r25x6lx5lgncoxsjfy3q6xeuncv3efhs7jzm@bzdwf6j274et>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <lsb5l4ee4unh76r25x6lx5lgncoxsjfy3q6xeuncv3efhs7jzm@bzdwf6j274et>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, May 29, 2024 at 01:26:31PM +0100, Pierre-Clément Tosi wrote:
> On Mon, May 13, 2024 at 06:21:21PM +0100, Will Deacon wrote:
> > On Fri, May 10, 2024 at 12:26:38PM +0100, Pierre-Clément Tosi wrote:
> > > diff --git a/arch/arm64/include/asm/kvm_cfi.h b/arch/arm64/include/asm/kvm_cfi.h
> > > new file mode 100644
> > > index 000000000000..13cc7b19d838
> > > --- /dev/null
> > > +++ b/arch/arm64/include/asm/kvm_cfi.h
> > > @@ -0,0 +1,36 @@
> > > +/* SPDX-License-Identifier: GPL-2.0-only */
> > > +/*
> > > + * Copyright (C) 2024 - Google Inc
> > > + * Author: Pierre-Clément Tosi <ptosi@google.com>
> > > + */
> > > +
> > > +#ifndef __ARM64_KVM_CFI_H__
> > > +#define __ARM64_KVM_CFI_H__
> > > +
> > > +#include <asm/kvm_asm.h>
> > > +#include <linux/errno.h>
> > > +
> > > +#ifdef CONFIG_HYP_SUPPORTS_CFI_TEST
> > > +
> > > +int kvm_cfi_test_register_host_ctxt_cb(void (*cb)(void));
> > > +int kvm_cfi_test_register_guest_ctxt_cb(void (*cb)(void));
> > 
> > Hmm, I tend to think this indirection is a little over the top for a test
> > module that only registers a small handful of handlers:
> > 
> > > +static int set_param_mode(const char *val, const struct kernel_param *kp,
> > > +			 int (*register_cb)(void (*)(void)))
> > > +{
> > > +	unsigned int *mode = kp->arg;
> > > +	int err;
> > > +
> > > +	err = param_set_uint(val, kp);
> > > +	if (err)
> > > +		return err;
> > > +
> > > +	switch (*mode) {
> > > +	case 0:
> > > +		return register_cb(NULL);
> > > +	case 1:
> > > +		return register_cb(hyp_trigger_builtin_cfi_fault);
> > > +	case 2:
> > > +		return register_cb((void *)hyp_cfi_builtin2module_test_target);
> > > +	case 3:
> > > +		return register_cb(trigger_module2builtin_cfi_fault);
> > > +	case 4:
> > > +		return register_cb(trigger_module2module_cfi_fault);
> > > +	default:
> > > +		return -EINVAL;
> > > +	}
> > > +}
> > 
> > Why not just have a hyp selftest that runs through all of this behind a
> > static key? I think it would simplify the code quite a bit, and you could
> > move the registration and indirection logic.
> 
> I agree that the code would be simpler but note that the resulting tests would
> have a more limited coverage compared to what this currently implements. In
> particular, they would likely miss issues with the failure path itself (e.g.
> [1]) as the synchronous exception would need to be "handled" to let the selftest
> complete. OTOH, that would have the benefit of not triggering a kernel panic,
> making the test easier to integrate into existing CI suites.
> 
> However, as the original request for those tests [2] was specifically about
> testing the failure path, I've held off from modifying the test module (in v4)
> until I get confirmation that Marc would be happy with your suggestion.
> 
> [1]: https://lore.kernel.org/kvmarm/20240529121251.1993135-2-ptosi@google.com/
> [2]: https://lore.kernel.org/kvmarm/867ci10zv6.wl-maz@kernel.org/

In which case, I think I'd drop the tests for now because I think the cure
is worse than the disease with the current implementation.

Will

