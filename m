Return-Path: <kvm+bounces-29165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63C5F9A3B7E
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 12:28:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 91EA21C22B66
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 10:28:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DED820125D;
	Fri, 18 Oct 2024 10:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P37ZQDP5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803BF168C3F;
	Fri, 18 Oct 2024 10:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729247291; cv=none; b=TiwvU8i8wijoCivo27ydVr6R0w+eHvUM6+bl2pEV3Bln/VuPezHU3mRJ0ItoH0fTxiFftWF+Z/ZZDaXShykkA+BBVHawF0j8sEgJPi4NUpE7Cw4mqDxnvLmTU0f1nMhCizmjkqSwMDKIKJlsYHwqzJW8jxCi5Pq3OvWWCiPp3YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729247291; c=relaxed/simple;
	bh=2ydi4xpyLhuUxVf5xZR3h0Khm/4a9TI3tUL2cCB0hDo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aXIKl0IbygsrZVm2Q3aeY4gsXDPXhMCIuzyynluAjTv8WE5nN7md4Ug6A/HLwyJfGAO08dodjZ25Np2p/8i9W3mOvisBG9cImL29zh3tw9q9i4QGLydrOwsmUxxZyUJe+zkPmzlymV1zEq+3PqArffKdWwMRcB9HraDMvrcfhjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P37ZQDP5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF55EC4CEC3;
	Fri, 18 Oct 2024 10:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729247291;
	bh=2ydi4xpyLhuUxVf5xZR3h0Khm/4a9TI3tUL2cCB0hDo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P37ZQDP5/525xkXwSNG16z7sLKcETMMyJvEeEPNFpJfEnV4IMnCmEmNs6EWEz7pUf
	 kRASfk8HFPsaP/SYNG5yjgZS1RQsFj6g2mkcA/xi8qxz9VMLUYdY3Uxlmseh6A3faj
	 TbGH1grsBDWx5Kf21eOiyBGYETOboT3BXIzNTAS4=
Date: Fri, 18 Oct 2024 12:28:08 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Cc: Breno Leitao <leitao@debian.org>, stable@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.15, 5.10, 5.4, 4.19 1/1] KVM: Fix a data race on
 last_boosted_vcpu in kvm_vcpu_on_spin()
Message-ID: <2024101802-unlearned-bullish-3ca2@gregkh>
References: <20241017175623.2045625-1-saeed.mirzamohammadi@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241017175623.2045625-1-saeed.mirzamohammadi@oracle.com>

On Thu, Oct 17, 2024 at 10:56:13AM -0700, Saeed Mirzamohammadi wrote:
> From: Breno Leitao <leitao@debian.org>
> 
> commit 49f683b41f28918df3e51ddc0d928cb2e934ccdb upstream.
> 

Now queued up, thanks.

greg k-h

