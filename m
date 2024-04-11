Return-Path: <kvm+bounces-14223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E6A58A0A93
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 09:52:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 98B0D1C20C9C
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 07:52:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D80D13F44E;
	Thu, 11 Apr 2024 07:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="thj8jsF/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A39413E8B2;
	Thu, 11 Apr 2024 07:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712821901; cv=none; b=tmRIbciQAhPhtOoXZa1eEMW6Hh7bHfP++2LcV5vO73duTMqdmEm02mtZ7dbkcRwGrRLIb1PtZPSSt5FVZ8i88rt5N8pGYcyaiX2Mj6lytq+G/Tagt4cRgAGRAKFw3Jj3z5r2zB3qXoSy0gCrBnnYvOQ9VBsvvLgpeQcp3dCf2Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712821901; c=relaxed/simple;
	bh=yQ977sHokSopeKlSz6gwlpuep+m/Dh6CkBKLL1R+3Lg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZDJb1XEVLivXpZeCR16PMhuNb7Z55kPvVCVyPq6f2EIZ6OQsr78dtJUioUCzizmTy1ZwWISWXMec6d2fXoG84bSACpWiItMCZzRzyehbCFo8Y1ZunCGPe02B4baMgKQXVqXgmcHX9lWFrgnkv4umFrMtyhIWUEFWoIZiJ3PlnUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=thj8jsF/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378C6C433F1;
	Thu, 11 Apr 2024 07:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712821900;
	bh=yQ977sHokSopeKlSz6gwlpuep+m/Dh6CkBKLL1R+3Lg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=thj8jsF/Gm1dQFbLyczjAEu1tdUJhyP74hNYUELLn2IE7ZLW5muKR/VLeluspG5QR
	 x9QAvALL3EIhw8m+gYW0YfhkQzGT7R8Pxib+jBhhlMIkCgodADsHsdSlfhMZzus8J/
	 7TAT1PTxMYLUxWHFm/qhV0ZNNfEhrOVKPq2FYZ6E=
Date: Thu, 11 Apr 2024 09:51:38 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Alexandre Chartre <alexandre.chartre@oracle.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	daniel.sneddon@linux.intel.com, pawan.kumar.gupta@linux.intel.com,
	tglx@linutronix.de, konrad.wilk@oracle.com, peterz@infradead.org,
	seanjc@google.com, andrew.cooper3@citrix.com,
	dave.hansen@linux.intel.com, nik.borisov@suse.com,
	kpsingh@kernel.org, longman@redhat.com, bp@alien8.de,
	pbonzini@redhat.com
Subject: Re: [PATCH] KVM: x86: Set BHI_NO in guest when host is not affected
 by BHI
Message-ID: <2024041127-revival-nifty-8396@gregkh>
References: <20240411072445.522731-1-alexandre.chartre@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240411072445.522731-1-alexandre.chartre@oracle.com>

On Thu, Apr 11, 2024 at 09:24:45AM +0200, Alexandre Chartre wrote:
> When a system is not affected by the BHI bug then KVM should
> configure guests with BHI_NO to ensure they won't enable any
> BHI mitigation.
> 
> Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>

No Fixes: tag here?

thanks,

greg k-h

