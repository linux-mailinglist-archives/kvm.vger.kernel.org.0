Return-Path: <kvm+bounces-57198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 20B9EB5171F
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 14:39:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 619607B90F1
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 12:36:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B914E2DECD6;
	Wed, 10 Sep 2025 12:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nP6aeFjn"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75F031B105;
	Wed, 10 Sep 2025 12:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757507813; cv=none; b=CKqq4SmLlVTUpjW4/pylMVDiz0xv7GsVAQf2e0oHlEF2/vUNbAOATvp3HkRDU2DeW0/sCMkAPYjp+8/vMIPk/Iq2D1Wbta8bbg+u5I6UBlRf6NXAFtiCi3GgjLTn4WvD6WcYdXlJzLRFZm9zn7CffzQNzU54RqYKHJ7wNz8H8iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757507813; c=relaxed/simple;
	bh=zwXZsM0BiAGrMWDdAApxn8sSH9M653Nov2KCSwxTqPw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TCCPlO3nS1LfUM+T6nWK+qJRgEWl6oe+xaVHVwFW4wu4nnQBpkXDtOou3DeVw3XcA9JhejeOhZXTO+BFDzpYG6jQlYOkg9bhE1+oivOtp6kdBaK3kKW0JJDmXDxFa5cIWy1hpwB4HdH6/jQmvx+o9MGUFUq055NW8WeivOwFAcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nP6aeFjn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DECCAC4CEF0;
	Wed, 10 Sep 2025 12:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757507813;
	bh=zwXZsM0BiAGrMWDdAApxn8sSH9M653Nov2KCSwxTqPw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nP6aeFjn+P+EWorOd8KkYTBDiwWcQjGa3JLTCl3vfloVccXb/7ZbIG7NWae+BE8yy
	 VtDlNlDHJ8vPfEGgCC6OxuQnxJOcxbnBQHFu3YJGwk6LsP+SFioUBoQOcjmlvBVQ8K
	 Om/cNRqVTgDl1g5P82JIDSmcwQ+emGp3g1qfMeLzSsVbQTAVnpH6jSil0bZgFTSt+u
	 c3ehPKX3vMoneqOku+9naezcKvLDNutYNfI36yJXgoGYUijpeN9Mkjn85sVP/hOvxO
	 KO4dRpeSUgpQsSNhr4+lwkwOhfPZaIEYA61o0+vSChWeCtK26+z7+BTUNlltp8s+RB
	 iY3Rf6Za9b8zg==
Date: Wed, 10 Sep 2025 18:00:35 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Vasant Hegde <vasant.hegde@amd.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: Re: [RFC PATCH 0/3] KVM: SVM: Fix IRQ window inhibit handling
Message-ID: <hdfss237zgmsktjuf26u7oowivu3nbip7jtit7y3he35vvq2vv@wkmjzqomy5lh>
References: <cover.1752819570.git.naveen@kernel.org>
 <y4sev4v2pixrjliqzpwccgtcwkqp7lkbxvufdhqkfamhmghqe5@u4e6mrwafm7k>
 <aMBI_mKJPun0eDJl@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMBI_mKJPun0eDJl@google.com>

On Tue, Sep 09, 2025 at 08:34:22AM -0700, Sean Christopherson wrote:
> On Tue, Sep 09, 2025, Naveen N Rao wrote:
> > On Fri, Jul 18, 2025 at 12:13:33PM +0530, Naveen N Rao (AMD) wrote:
> > > Sean, Paolo,
> > > I have attempted to take the changes discussed in the below thread and 
> > > to convert them into a patch series:
> > > http://lkml.kernel.org/r/Z6JoInXNntIoHLQ8@google.com
> > > 
> > > I have tried to describe the changes, but the nested aspects would 
> > > definitely need a review to ensure correctness and that all aspects are 
> > > covered there.
> > > 
> > > None of these patches include patch tags since none were provided in the 
> > > discussion. I have proposed patch trailers on the individual patches.  
> > > Please take a look and let me know if that's fine.
> > > 
> > > I tested this lightly with nested guests as well and it is working fine 
> > > for me.
> > 
> > Sean, Paolo,
> > Any feedback on this - can you please take a look?
> 
> I'm getting there, slowly.  Lot's of time sensitive things in flight right now
> both internally and upstream.  Sorry.

Sure, no worries. I primarily asked since this is a fix, and we have had 
a few reports of performance degradation due to the APICv inhibit lock.  
So, it would be good if this can be addressed sooner (compared to some 
of the other AVIC features).

Thanks,
Naveen


