Return-Path: <kvm+bounces-18501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AF3158D5A4F
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 08:09:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3E9DBB25610
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 06:09:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C80E7F7D5;
	Fri, 31 May 2024 06:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wh4HNVq/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699E318756E;
	Fri, 31 May 2024 06:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717135748; cv=none; b=KysXnRYmXGGwIahvZr75/Wy7+bfC7oG7UuaCIiC6SvNi6QGCnD5Ii9OOjsAMcG2xvHB94fi4/52rU3/xOPDjGmEaK8nPwOUhJ4GcSBLeMzjbXN9kMTJPFXUCixJicOh3xtxPdID/VIikWHfvFqNO2nz1tbIYzQVqtHd7TvKFpXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717135748; c=relaxed/simple;
	bh=FOgJ1nWsKY1HqqT5AsZjlUD928VwEjzdZ/ngER5Sxw4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BVdClNVELJiij4KQm8VC6C4oDlLSpjNiawmpJFuF6Y2RZXiLQbv9utOM6j2uHV2Mic3x1TSZCFfEjSWmCDTEEltDnak8UoLgabH2LwHYcOuHoxYRyjpz5I827jObEIUgmV71yR9/A4nNqJSOSChUbnvougH3BMVQPFyiyy/4HVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wh4HNVq/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9F0C116B1;
	Fri, 31 May 2024 06:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717135747;
	bh=FOgJ1nWsKY1HqqT5AsZjlUD928VwEjzdZ/ngER5Sxw4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wh4HNVq/hiDTRYMJ7bdDbK4wcdDKh5OdWZzZKmevW5FqZHmWt+UmItoGmFWdGou18
	 bB4W9jm5tlsSkdLcpiBaZaV6HjMjtZ53NJz0uy23NZ4diJELXYAOK4qG2s9SLWKdAv
	 iUjeNCwevnjTI/8qrjAspMgMC1zhF+nCoiOZPqHc=
Date: Fri, 31 May 2024 08:09:13 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Gautam Menghani <gautam@linux.ibm.com>
Cc: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
	aneesh.kumar@kernel.org, naveen.n.rao@linux.ibm.com, corbet@lwn.net,
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] arch/powerpc/kvm: Fix doorbell emulation by adding DPDES
 support
Message-ID: <2024053143-wanted-legible-ca3f@gregkh>
References: <20240522082838.121769-1-gautam@linux.ibm.com>
 <rrsuqfqugrdowhws2f7ug7pzvimzkepx3g2cp36ijx2zhzokee@eitrr6vxp75w>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rrsuqfqugrdowhws2f7ug7pzvimzkepx3g2cp36ijx2zhzokee@eitrr6vxp75w>

On Fri, May 31, 2024 at 10:54:58AM +0530, Gautam Menghani wrote:
> Hello,
> 
> Please review this patch and let me know if any changes are needed.

There already was review comments on it, why ignore them?

