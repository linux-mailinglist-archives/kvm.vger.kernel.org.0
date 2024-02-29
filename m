Return-Path: <kvm+bounces-10506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F198286CBAB
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 15:35:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 93D311F23710
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 14:35:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40AAE1361DF;
	Thu, 29 Feb 2024 14:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="MoeYV3uY"
X-Original-To: kvm@vger.kernel.org
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960F17E572
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 14:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709217308; cv=none; b=N4a/8K/CtpCFCiF7usmMCwa+01hWZ15EmGMApzpeulHUO+lZ1pZ38jj++P4gxk6YIwOVlGpGW0dRtF2+bbQwEdlLxCZKXe3AlWsvwuA31oAA6gbUA1GnfKT+IhjYS45cypnxw5c1zkDic/BIkRY85J4JAxdPV2Xga6PH+oxVG1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709217308; c=relaxed/simple;
	bh=GWpPMR8ZbLksGADyFNnEu6eEXxjrqbo9viVVcGcpEek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s0E9/Gy81J/eZeHeKgjEby7+3n3DuEd/t2mF0D5p1xJAyQqJ8zNxeWDKZ+q9YQ3efosvKZO2QqznqeJTCrvkUMbfAKq8SCbp95x5UvcyanES/8URB8c5roxi1lQ7IsZ7nSlB4CLlJ86VUK6GGodosXLLEAWcvV5zpP1FuXaI3+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=MoeYV3uY; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Received: from macsyma.thunk.org (c-73-8-226-230.hsd1.il.comcast.net [73.8.226.230])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 41TEYt41000445
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Feb 2024 09:34:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1709217298; bh=9bt+VU/O95vrA1tEuQjukbRaKwC00b255KFdPrFp97E=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=MoeYV3uYAv5122SPWNUGMWp9PPKVzRKU2RLDl2CujnRopc9LX36P5XG6diRJFB4+T
	 wNCbPQXsOCblO7Px9NyN3h67aFz5y4N0KReAGM/VDUkBaeFd0q47z6Nr8cH9eBUO/C
	 IzVrnwYqfpwDyK9vcHAmxew5lNrf5odyRVq0wRkxo9ccIGmhvtDMEd9jItKM/uIV+N
	 bMLNegFZCZYqJWzwqbGqVKbvZtSJP+Wj5p3nDdvOgpEs7yo7E2japQfKTkzsjt9k32
	 jO7G/KctJ1Yx/HBNBN292+vn49Zm34jpROlDvwOgyNeNqZ/m2OnErFkZm0v4TbPqg1
	 wb/NAibnWZksg==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id E988F3403F5; Thu, 29 Feb 2024 08:34:54 -0600 (CST)
Date: Thu, 29 Feb 2024 08:34:54 -0600
From: "Theodore Ts'o" <tytso@mit.edu>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Greg KH <gregkh@kernel.org>, cve@kernel.org, linux-kernel@vger.kernel.org,
        KVM list <kvm@vger.kernel.org>, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: CVE-2021-46978: KVM: nVMX: Always make an attempt to map eVMCS
 after migration
Message-ID: <20240229143454.GC272762@mit.edu>
References: <2024022822-CVE-2021-46978-3516@gregkh>
 <54595439-1dbf-4c3c-b007-428576506928@redhat.com>
 <2024022905-barrette-lividly-c312@gregkh>
 <CABgObfZ+bMOac-yf2v6jD+s0-_RXACY3ApDknC2FnTmmgDXEug@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABgObfZ+bMOac-yf2v6jD+s0-_RXACY3ApDknC2FnTmmgDXEug@mail.gmail.com>

On Thu, Feb 29, 2024 at 11:04:45AM +0100, Paolo Bonzini wrote:
> Also, LKML does not get the initial announcement, which makes it a bit
> more painful to find the full discussion on lore (you have to go
> through a "no message with that id, maybe you mean this one from other
> mailing lists" page, instead of having the whole thread in the same
> place). A linux-cve mailing list with public posting, used for Cc and
> Reply-to of the initial message, would solve this issue as well.

I believe the url https://lore.kernel.org/all/<message-id> will get
the whole thread, regardless of which mailing lists individual mail
messages were sent to, does it not?

					- Ted

