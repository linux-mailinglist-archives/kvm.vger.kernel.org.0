Return-Path: <kvm+bounces-57111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 31DC7B4FF81
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 16:34:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD3A41C2459A
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 14:34:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BCD834F485;
	Tue,  9 Sep 2025 14:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iaxfCBBa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0207081E;
	Tue,  9 Sep 2025 14:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757428423; cv=none; b=poAXhUHLvUgLNspmA+0T/CYBSbUpT+G9QLM89g6GTwx5qjOhlwme2CbfwShrA1XRjVbFw0hpyFO2BfuT2ruo+yyjGj7cPf2LgwjFtM75LX//w/7GDFg4JlWtryOvGduw+bwZ8J1zLJaQOoJooPftyavm9WkxrU6LdbKqVYujBLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757428423; c=relaxed/simple;
	bh=TkhuW1Vk3qpXZYupqghycFgpZ49+yjKvblPuLB+8TQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rSA3ILp3V6KtBcCp7wnm13CqbQHh8AfvjY8lglD+yrhcb6/8znZr6aYvSbRVCqdp/Z5VpqxOl/NLqUJaaN4B9OBEKQIpqb6KPyQgokIPMsdUgOxHwyJkg6c2QegEXNG6hsBVV5ldxIavSgTS7T8gZ+/zP3fFZmfA2yjqgZ+nGjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iaxfCBBa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C61C4CEF4;
	Tue,  9 Sep 2025 14:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757428423;
	bh=TkhuW1Vk3qpXZYupqghycFgpZ49+yjKvblPuLB+8TQs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iaxfCBBa7rE4YEEWfolFWk6iU8BrUVjszoKnSRwMgANOtGmEXSCNmnxvvXlH2ppsU
	 XJ5aeocmDjQFFdq1172z5de5qSMGzyx4hpCin1wcfV7A0WAFG6TBTmDnzYT2qghmnY
	 CwxmchFuK11JP0X4WN65DB72oPNrIcdeRlUazAG+iIWwo9Xat9jZfianECPDGNqhz6
	 wLqwGWObhrFQmJPNpefPARm8SqR29pSOruDyE6jQ5m2yqeuKPKgyCQb99BrAYIL0ra
	 hGzmP89ore61Z1tlfjtDW7een5ESsBc2uueehPz5Df0kHUNZ3JZvCxABBft95+NU4O
	 o4U0Dy5cj9J8A==
Date: Tue, 9 Sep 2025 20:00:44 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: Re: [RFC PATCH 0/3] KVM: SVM: Fix IRQ window inhibit handling
Message-ID: <y4sev4v2pixrjliqzpwccgtcwkqp7lkbxvufdhqkfamhmghqe5@u4e6mrwafm7k>
References: <cover.1752819570.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1752819570.git.naveen@kernel.org>

On Fri, Jul 18, 2025 at 12:13:33PM +0530, Naveen N Rao (AMD) wrote:
> Sean, Paolo,
> I have attempted to take the changes discussed in the below thread and 
> to convert them into a patch series:
> http://lkml.kernel.org/r/Z6JoInXNntIoHLQ8@google.com
> 
> I have tried to describe the changes, but the nested aspects would 
> definitely need a review to ensure correctness and that all aspects are 
> covered there.
> 
> None of these patches include patch tags since none were provided in the 
> discussion. I have proposed patch trailers on the individual patches.  
> Please take a look and let me know if that's fine.
> 
> I tested this lightly with nested guests as well and it is working fine 
> for me.

Sean, Paolo,
Any feedback on this - can you please take a look?


Thanks,
Naveen


