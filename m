Return-Path: <kvm+bounces-10353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AD4F86C020
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:21:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 00A211F22DE9
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 05:21:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A2EC3A1CC;
	Thu, 29 Feb 2024 05:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mRqTuSmi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B106B3984D;
	Thu, 29 Feb 2024 05:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709184070; cv=none; b=q65FL0urxyRiM/r4MrWEUCpNb9Rwfoa13QUDfO+jDlaK95ruInBTQ/er/OE+pjj2O4J/B6fVuA8SN2+YGs6VN0/rLf0/vtiPBSsezJCRo7lQe7a5Nf5HCpTbgcaZe40avWbn+us2m7679hM/zUwZQaj3x/thY9r/KLD/gXnmmJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709184070; c=relaxed/simple;
	bh=DHiWzPoy1kmOKKN7UVFFQWx2TovKkknoFp+snJK8Osw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RODTkiOvvhpuLqWv3FZqqoVOaqELbEiQp6v5uwYZ/Qiyk9UB4gVVBenZbBrwGvghF/Yga/BjuDKm3NfH/q7ZshCBllehYldhKV00fwzlBTshtLigDcSWxDE9vRq/Xxj70PSFa9ldjzfYRaMLWWBBaiA4hlddDkWhaKzB8w6R4JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mRqTuSmi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11E1C433F1;
	Thu, 29 Feb 2024 05:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709184070;
	bh=DHiWzPoy1kmOKKN7UVFFQWx2TovKkknoFp+snJK8Osw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mRqTuSmirBwMmznqcSKqYz8VGmpkPXcOSm7ezRsKOqrlQP4DKqMOAs4HU8lYI3TR3
	 HT06mNSjpPq5Vi2ZIJvYAmKu3uK60CDKjO2mDD7OMlRGWDicNyhz1VLhKke0yyhaTf
	 1tWfqw78tJCFQ+/juWqm2IjUg9r4tJFp2Tpmx1qntPBxaFrY7Jp7g3spBIjjyJ/pJ2
	 vy3xbeHFe3l3RmVm0cQi+tr84qomrmqC4MWbqmJzsJ0P/eqjVwUTgIpjhQyFP3aw0d
	 pgSZbjIZPLt0+KrNhBenNV3ChOmK0BzJ63+NssbMNPy2L5ljdpjouGxzQ2D86j0P9M
	 WnYxxI5CFP0ig==
Date: Thu, 29 Feb 2024 06:21:04 +0100
From: Greg KH <gregkh@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: cve@kernel.org, linux-kernel@vger.kernel.org,
	KVM list <kvm@vger.kernel.org>,
	Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: CVE-2021-46978: KVM: nVMX: Always make an attempt to map eVMCS
 after migration
Message-ID: <2024022905-barrette-lividly-c312@gregkh>
References: <2024022822-CVE-2021-46978-3516@gregkh>
 <54595439-1dbf-4c3c-b007-428576506928@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54595439-1dbf-4c3c-b007-428576506928@redhat.com>

On Wed, Feb 28, 2024 at 11:09:50PM +0100, Paolo Bonzini wrote:
> On 2/28/24 09:14, Greg Kroah-Hartman wrote:
> > From: gregkh@kernel.org
> > 
> > Description
> > ===========
> > 
> > In the Linux kernel, the following vulnerability has been resolved:
> > 
> > KVM: nVMX: Always make an attempt to map eVMCS after migration
> 
> How does this break the confidentiality, integrity or availability of the
> host kernel?  It's a fix for a failure to restart the guest after migration.
> Vitaly can confirm.

It's a fix for the availability of the guest kernel, which now can not
boot properly, right?  That's why this was selected.  If this is not
correct, I will be glad to revoke this.

> Apparently the authority to "dispute or modify an assigned CVE lies solely
> with the maintainers", but we don't have the authority to tell you in
> advance that a CVE is crap, so please consider this vulnerability to be
> disputed.

Great, but again, not allowing the guest kernel to boot again feels like
an "availability" issue to me.  If not, we can revoke this.

> Unlike what we discussed last week:
> 
> - the KVM list is not CC'd so whoever sees this reply will have to find the
> original message on their own

Adding a cc: to the subsystem mailing list for the CVEs involved can be
done, but would it really help much?

> - there is no list gathering all the discussions/complaints about these
> CVEs, since I cannot reply to linux-cve-announce@vger.kernel.org.

That's what lkml is for, and is why the "Reply-to:" is set on the
linux-cve-announce emails.  Creating yet-another-list isn't really going
to help much.

Also, this is part of the "import the GSD database into CVE" which the
CVE project asked us to do, which is why these "old" issues are popping
up now.

thanks,

greg k-h

