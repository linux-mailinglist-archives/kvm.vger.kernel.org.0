Return-Path: <kvm+bounces-58739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CF6EB9ECF8
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 12:50:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 950681888BB1
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 10:49:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82EEA2F3634;
	Thu, 25 Sep 2025 10:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gKeeyylW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82EEC2EFD83;
	Thu, 25 Sep 2025 10:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758797282; cv=none; b=MfSgyvF+I0NNhuvXqSfyMWujuMKcEmt2yojxu/B/YvluNN+oLZZBNp4aOViRyKVjX+gorV1sNbZ113ZGVeEx83wV0KKXQO9NicIanmAPBbYR9DUVcX2ao1GMDkjxjMTohbfjKgSsKt46NLhKDX8362CIWcXZWjn43EDq+FZW+T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758797282; c=relaxed/simple;
	bh=mB28gI5dirAF/3/auWStLl/s+8NXTlq2RrrP766x9iE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GI4M8JyMgOwXldxwg6wEl5AHiCOd38ypOR7FF6pPJZMYcuau4fRBWu9UbRZd8KyiSG4e0RslsDx6cew2yO8Lh3idaPkxpx4/y2lGVw4YroqeMI29Y2h3ipHmr8rsl10GeoguMZIZERhg/2amK3Lt8/oQgygENu274wUHmdbYs3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gKeeyylW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA54C4CEF0;
	Thu, 25 Sep 2025 10:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758797282;
	bh=mB28gI5dirAF/3/auWStLl/s+8NXTlq2RrrP766x9iE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gKeeyylWNjqJhsLzjQQfJlgPLc6SbamEO0N8WdzIKxXGVZyguToErbxM57joU0VgU
	 8CLc7uA2DBfXH0twjgCYK5oqXQTDI1W/tNvpZjhJUuGhcsANkaVSuFFaAlcFejTgxq
	 GbquhyptnOy6dbA6pEb+IRNOxxr8scz6KXExMq0hZqA+9Yhwo534qP+HMC/AzLDbjZ
	 VdAY9Aj59BEbcYIx2qRqj0cxYTNEjuEZ1N9zrGurymAknU4R94/cH16w/mFO/OFJlW
	 kPMCKLo6lBPlgF73ZCW2JFX2PWx+tQn3kuhPW7o34EQHNHorqEOXCzzGvGVUuMhcQH
	 9B642hLsGCH0Q==
Date: Thu, 25 Sep 2025 16:13:17 +0530
From: Naveen N Rao <naveen@kernel.org>
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>, Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] KVM: selftests: Test TPR / CR8 sync and interrupt
 masking
Message-ID: <pssrvpxpo7ncvfkgunuwbenztcw4p4d3aavvbmgzcr23fg7biy@aeylu42ii3k6>
References: <90ea0b66874d676b93be43e9bf89a9a831323107.1758647049.git.maciej.szmigiero@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90ea0b66874d676b93be43e9bf89a9a831323107.1758647049.git.maciej.szmigiero@oracle.com>

On Tue, Sep 23, 2025 at 07:32:14PM +0200, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> Add a few extra TPR / CR8 tests to x86's xapic_state_test to see if:
> * TPR is 0 on reset,
> * TPR, PPR and CR8 are equal inside the guest,
> * TPR and CR8 read equal by the host after a VMExit
> * TPR borderline values set by the host correctly mask interrupts in the
> guest.
> 
> These hopefully will catch the most obvious cases of improper TPR sync or
> interrupt masking.
> 
> Do these tests both in x2APIC and xAPIC modes.
> The x2APIC mode uses SELF_IPI register to trigger interrupts to give it a
> bit of exercise too.
> 
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

Acked-by: Naveen N Rao (AMD) <naveen@kernel.org>


- Naveen


