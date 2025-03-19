Return-Path: <kvm+bounces-41514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C02BCA6981F
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 19:36:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 25565189ADB6
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 18:34:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F056209F54;
	Wed, 19 Mar 2025 18:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rOd7eBGc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD271DE3C5
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 18:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742409282; cv=none; b=RxTF2xw+Qgk1AV6Jec1N+EotLwAntOPw7KOzloDbgDLG02koin+kV+o8alRNKJW2gcopswn9xXW2miH5XDoOUzshSv0nTfA1kpPBqtPx6IPmvWe/BL+voM8dfjfB8Kt9pQbz7M+RjCDFRcGFHhiI4P5W//DYl1joA0ojI95185U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742409282; c=relaxed/simple;
	bh=xDfGRUZsi+JftF2gYF7AxXEZtOiVOHijZyRdmOM/rVk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NEkGE1g0iDcntwC1yn+JqZ508PArsi0ctyCJPklDNW4BCpDKxwx8IxG6MljNWF8sBSQxhfu4VdsKD93T+e9BXrAKOG70ooInSX58QGTU4j1TVfps69grJ16ygjhlxlNJ+VhZ4H/bPPpWmEwYz7RYMyTGMfiexKbSqzixZwjBF/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rOd7eBGc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4342C4CEE4;
	Wed, 19 Mar 2025 18:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742409282;
	bh=xDfGRUZsi+JftF2gYF7AxXEZtOiVOHijZyRdmOM/rVk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rOd7eBGcDMNMOAavrN1qw+9HCE2pVCRYbEcnyeKrs9TQUOpSHKDMFPbqv4ga+zGPT
	 5/+r8oqPEPHVTT6qewpSV2s7BSrUB7YNisTys/U9dEdvGCBMU42/gdM5umrtKeTynG
	 d8mpN3Pcqv7KszhD+xKFul4AW6gQlTCGd/tAoe0q3vOg46dr4uueIoOYgVNmfw1Q/j
	 8YcSlkroEDBWTf5v5j0Yr2CUx1sI+8rof9FwVnLcgz7+V63JlzUHmV01ZBYIBTKjYt
	 nfkz1d98p59JyAYHpX4gIe0sQyrlv7GEeAdhTTKQOLj95oqnRXKH10sDv5z7sGU4+u
	 /4oPMdvcBGVJA==
Date: Wed, 19 Mar 2025 12:34:39 -0600
From: Keith Busch <kbusch@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] vfio/type1: conditional rescheduling while pinning
Message-ID: <Z9sOPykPIqJWYzca@kbusch-mbp>
References: <20250312225255.617869-1-kbusch@meta.com>
 <20250317154417.7503c094.alex.williamson@redhat.com>
 <Z9iilzUTwLKzcVfK@kbusch-mbp.dhcp.thefacebook.com>
 <20250317165347.269621e5.alex.williamson@redhat.com>
 <Z9rm-Y-B2et9uvKc@kbusch-mbp>
 <20250319121704.7744c73e.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250319121704.7744c73e.alex.williamson@redhat.com>

On Wed, Mar 19, 2025 at 12:17:04PM -0600, Alex Williamson wrote:
> Since you mention folding in the changes, are you working on an upstream
> kernel or a downstream backport?  Huge pfnmap support was added in
> v6.12 via [1].  Without that you'd never see better than a order-a
> fault.  I hope that's it because with all the kernel pieces in place it
> should "Just work".  Thanks,

Yep, this is a backport to 6.11, and I included that series. There were
a few extra patches outside it needed to port that far back, but nothing
difficult.

Anyway since my last email, things are looking more successful now. We
changed a few things in both user and kernel side, so we're just doing
more tests to confirm what part was the necessary change.

