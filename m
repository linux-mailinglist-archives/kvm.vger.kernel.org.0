Return-Path: <kvm+bounces-57711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9603B593E8
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 12:39:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0B2A3A44BB
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 10:39:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A7D230275A;
	Tue, 16 Sep 2025 10:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cMwmhzWO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241072E6CB5
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 10:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758019153; cv=none; b=eFiyoOCI/EWUfYupfHIbXXA8PGNM0dS8u1hfUwv0kN4cnuqGS1FbAbtJW4KDqgEK0ThvAWN2vZBEVXQMmQWsLdeK0xoIgUqv6NFsGCyioAlRhiu38IaqQ0nSIe8TdZgplw5nEnE1gu/4Ds6Faw9H/lAAh2XV87Env0QbVIMwr4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758019153; c=relaxed/simple;
	bh=LPY67TnpCAejEX5wSzQrRGXmESfxe7a/yzeUHoAKjYg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eH9QR2UzVcJocxhRlrrOeMEs0zQm7OdOvlkWCCYeGU3CC+Ut+cLrjxCCf3qO0VVp8H6CcCwqT8n+62VMu2jHzcOcw4XeYM5a+vI1MuQMvQMhJb0/lgsb3bRrazm75WZJ2xPcC8a2Ukr8vAqEYZr8gLBKcSwrK609z42q6qKKcec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cMwmhzWO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC9CC4CEEB;
	Tue, 16 Sep 2025 10:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758019152;
	bh=LPY67TnpCAejEX5wSzQrRGXmESfxe7a/yzeUHoAKjYg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cMwmhzWOIL3/PrIrWZDI0cNkdi8tMdNX0nOpqr6TaxbkEo066gYpN00jLQzbW5Enw
	 Yk8BszfzN/t7wGAYcHoicmqDZ33iFMlFAqh8YyE2noWz7tZgmgqMxcxhs4Pc5s2fV9
	 +/yKYQl4aIjxA0iXWT6KPcxYrqGad715/OphqDblDZ/1jOLKTpOmLjLiUtvffoWC4r
	 RBwaglieTR/v4zb7hB3CE1yIpPIBsI3WuO6seSV2BeoCCCFAZ1tkbZgQzDV4Y0FAic
	 /keAi7NShYOC3AVMqAO2la34JlDEECwTaUo9Lim0LyT9V7mOoc6YMV3d31knVyKOch
	 GV/9t004jcP/g==
Date: Tue, 16 Sep 2025 16:01:54 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Vasant Hegde <vasant.hegde@amd.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, 
	Nikunj A Dadhania <nikunj@amd.com>, Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, 
	Joao Martins <joao.m.martins@oracle.com>, "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [RFC PATCH v2 0/5] KVM: SVM: Enable AVIC by default on Zen 4+
Message-ID: <vckm3xriytj4nyfo7iiyzgdjxgvt7xl6f67fqoibdwyscb2zxb@qadmrn6csbzd>
References: <cover.1756993734.git.naveen@kernel.org>
 <aMif1bI7dCUUBK4Z@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMif1bI7dCUUBK4Z@google.com>

On Mon, Sep 15, 2025 at 04:23:01PM -0700, Sean Christopherson wrote:
> On Thu, Sep 04, 2025, Naveen N Rao (AMD) wrote:
> > This is v2 of the RFC posted here:
> > http://lkml.kernel.org/r/20250626145122.2228258-1-naveen@kernel.org
> > 
> > I have split up the patches and incorporated feedback on the RFC. This 
> > still depends on at least two other fixes:
> > - Reducing SVM IRQ Window inhibit lock contention: 
> >   http://lkml.kernel.org/r/cover.1752819570.git.naveen@kernel.org
> 
> Eh, I don't think this one in is a hard dependency.  Don't get me wrong, I want
> to land that series, ideally at the same time that AVIC is (conditionally) enabled
> by default, but I won't lose sleep if it lands a kernel or two later (tagged for
> stable@ as appropriate).

Sure. The primary reason I added it as a dependency is because this is 
unfortunately easy to hit given KVM/qemu defaults (KVM PIT in reinject 
mode, in-kernel irqchip). The performance degradation may not be readily 
noticeable though, so I am fine if this is taken up later.

> 
> Practically speaking, no feature the size of AVIC will ever be perfect.  At this
> point, I'm comfortable enabling AVIC by default and fixing-forward any remaining
> issues.  And I want to get AVIC enabled by default in 6.18 because I think that
> enabling AVIC in an LTS will be a big net positive for the overall KVM community.
> E.g. we'll likely get more exposure/coverage when distros/companies move to the
> next LTS, it'll be easier to manage LTS backports for downstream frankenkernels,
> etc.

:thumbsup:

> 
> > - Fixing TPR handling when AVIC is active: 
> >   http://lkml.kernel.org/r/cover.1756139678.git.maciej.szmigiero@oracle.com
> 
> This is queued for 6.17, just need to send the "thank you" and the PULL request.
> 
> As for this series, I'll post a v3 as time is running short for 6.18 (one of those
> situations where describing the changes I'm suggesting would take longer than just
> making the changes :-/).

All good, thanks!


- Naveen


