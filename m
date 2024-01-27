Return-Path: <kvm+bounces-7263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 28D7383E90F
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 02:39:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D957628A91F
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 01:39:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB633BE7F;
	Sat, 27 Jan 2024 01:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kbo3x3w1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21BABE48;
	Sat, 27 Jan 2024 01:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706319537; cv=none; b=cveXB74eE+LXxEGJXLOsfpJULg40BcwIb+b1N+a24bxvjForilDQeOfwm/8hDldxregvOyW842oCwZlazey8ZxGAaE+7Wbka8bfSVlmhSl6HfAWKFDc/uRlVRuM4+krry9oPSkHs+q9//gxPjbQaJDU2iN1w3S1bHXZAklmCbmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706319537; c=relaxed/simple;
	bh=EW9I1GmtI/NYaykHlCPaSb+uO5ZMsxBSIs5XKl1L8J8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HgkTWdn7jAPLX+ZIjoHc3Pvp/rV7LhTWHvfz0nbpz9vsWVE1HMrUW7o8zE2mIvgpHpO1HIrzveYjP8CG0RYGjmuHNG06eFvV25DklrPvHS1rXC9IN6rXjQjvxcMhaMT8fRvLQMSj3c1ECrvcROZMEZcW7rCIJWznKIXbEB7fpNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kbo3x3w1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FBB7C433C7;
	Sat, 27 Jan 2024 01:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706319536;
	bh=EW9I1GmtI/NYaykHlCPaSb+uO5ZMsxBSIs5XKl1L8J8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kbo3x3w1y94CrIwx7l6lYrX7kZcdRk74FrX2H0ta9yjPM3Glmk3Icu0zIlcnsZitg
	 vCqC/7dvdMC9uaRq62IjE72BQBMSGckaKqrS4APCyfnOn7jWVlOhyM5Vpc7Uvd/+UG
	 tTF20jmZ7W6BIcaQTj1rRudygIKGv8rRX3lZaLWs=
Date: Fri, 26 Jan 2024 17:38:55 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: mlevitsk@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
	stable@vger.kernel.org, joe.jin@oracle.com
Subject: Re: Stable bugfix backport request of "KVM: x86: smm: preserve
 interrupt shadow in SMRAM"?
Message-ID: <2024012614-wreath-wreckage-f291@gregkh>
References: <20240127002016.95369-1-dongli.zhang@oracle.com>
 <2024012639-parsnip-quill-2352@gregkh>
 <79cace24-b2b6-8744-c175-bfb0a1bfc6eb@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79cace24-b2b6-8744-c175-bfb0a1bfc6eb@oracle.com>

On Fri, Jan 26, 2024 at 05:33:28PM -0800, Dongli Zhang wrote:
> Hi Greg,
> 
> On 1/26/24 17:08, Greg KH wrote:
> > On Fri, Jan 26, 2024 at 04:20:16PM -0800, Dongli Zhang wrote:
> >> Hi Maxim and Paolo, 
> >>
> >> This is the linux-stable backport request regarding the below patch.
> > 
> > For what tree(s)?
> 
> It is linux-5.15.y as in the Subject of the patch.

Am I blind, but I don't see that in the subject line anywhere :(


