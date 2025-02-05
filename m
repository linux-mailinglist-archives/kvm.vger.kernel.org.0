Return-Path: <kvm+bounces-37328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 65263A2891F
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 12:23:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E5B2B1658E6
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 11:23:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A77C222B5A8;
	Wed,  5 Feb 2025 11:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GFC1p+S4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C960721773C;
	Wed,  5 Feb 2025 11:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738754604; cv=none; b=nIa+G4Mb58O1RDRZ9gys7f25ZOx9JE6ubx4RS6w9k6lCs7Q6uVTYj9oRHj2aXPwBJwCvmawQu7s0AwITPDZy+N1oemVIcy186eJtf3O6PqTzytYyHVXjbJ7YQ3JtR+d/e+THmHhtt/GAA4Hfuf4/0zbg0lDBO7DOG76N/qcnpHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738754604; c=relaxed/simple;
	bh=JrqrsMm6ZW+oqoQfZL1aSYhz6WrCI/BCa1fGwa6BylI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ijuo4Rc7sc49xVAedr3c8IvvixYRRdzU6iX7/QWkn5WJHyLrUfU8++nTLeg1hOBBj0CkNlG9LwiVabW9NA+G49Js/J0luYwT5tg9fiD3gpMYZLKID6YgjIWVXWQ7fNrafR+ymBtTg+9peyFR95W1P8kxcmettoLGduEhPp5DLDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GFC1p+S4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A19A0C4CED1;
	Wed,  5 Feb 2025 11:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738754604;
	bh=JrqrsMm6ZW+oqoQfZL1aSYhz6WrCI/BCa1fGwa6BylI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GFC1p+S48lksLC+tsQdYni6gO7v8MUOwnqzy4WHXjPJChjR13UeRI4B7l65KW33SH
	 /Hp9zNgIyd9FNSb02vaeMak5i3fBagMBArBWrdwsnBAXdjjNfS8m0LvA2S+mjWNH3Z
	 Nor+SMevFn3VA483slwZl0sT30pIDdOGvq50rwygMkxXX0uCA5AnZe737U/g22Ttm9
	 lMeAUX4PEn7jjAXXCr4md0n8+pGt6V0gxvjikfWqcangUA+Oj80nbSxtaYgm2YlS9K
	 b20b/QpxFWgg10OcAV9tXs0JsOGkSzKa7GDD+JlGtUMbFbvdSS8/fRWxtVlN4Z7Vx7
	 RVIZtZ7v74PnA==
Date: Wed, 5 Feb 2025 16:43:50 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 2/3] KVM: x86: Remove use of apicv_update_lock when
 toggling guest debug state
Message-ID: <acf2q5da7s2rmh5tugozwhwv5rqafacgah7kjicrfc2qhbuzc6@k6ic4xngr552>
References: <cover.1738595289.git.naveen@kernel.org>
 <dc6cf3403e29c0296926e3bd8f0d4e87b67f4600.1738595289.git.naveen@kernel.org>
 <30fc469b5b2ec5e2d6703979a0d09ad0a9df29e1.camel@redhat.com>
 <a7eb34n6gkwg6kafh7r76tkwtweuflyfoczgxya2k63al2qdoe@phmszu6ilk4w>
 <Z6JTmvrkrLpaJ1nw@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6JTmvrkrLpaJ1nw@google.com>

On Tue, Feb 04, 2025 at 09:51:22AM -0800, Sean Christopherson wrote:
> On Tue, Feb 04, 2025, Naveen N Rao wrote:
> > On Mon, Feb 03, 2025 at 09:00:05PM -0500, Maxim Levitsky wrote:
> > > On Mon, 2025-02-03 at 22:33 +0530, Naveen N Rao (AMD) wrote:
> > > > apicv_update_lock is not required when querying the state of guest
> > > > debug in all the vcpus. Remove usage of the same, and switch to
> > > > kvm_set_or_clear_apicv_inhibit() helper to simplify the code.
> > > 
> > > It might be worth to mention that the reason why the lock is not needed,
> > > is because kvm_vcpu_ioctl from which this function is called takes 'vcpu->mutex'
> > > and thus concurrent execution of this function is not really possible.
> > 
> > Looking at this again, that looks to be a vcpu-specific lock, so I guess 
> > it is possible for multiple vcpus to run this concurrently?
> 
> Correct.
> 
> > In reality, this looks to be coming in from a vcpu ioctl from userspace, 
> > so this is probably not being invoked concurrently today.
> > 
> > Regardless, I wonder if moving this to a per-vcpu inhibit might be a 
> > better way to address this.
> 
> No, this is a slow path.

My comment was more from the point of view of correctness, rather than 
performance (with the goal of removing use of apicv_update_lock) -- 
similar to the issue with IRQWIN needing to maintain per-vcpu state. My 
naive understanding of Maxim's mail was that we would introduce per-vcpu 
inhibit field to maintain per-vcpu inhibit state, but not actually 
inhibit AVIC on a per-vcpu basis :)


Thanks,
Naveen

