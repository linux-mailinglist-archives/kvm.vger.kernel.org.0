Return-Path: <kvm+bounces-22504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86E9993F681
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 15:14:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E775284FA4
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 13:14:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8536914F9E9;
	Mon, 29 Jul 2024 13:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aPIMRBiY"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA7A1494BB
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 13:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722258780; cv=none; b=QRcidnuMXv9vpnjA6wnieEw7ITJ0FKvfgLaSkErs0RnKJ5tc+F5gLBYkBsxi0CZCh8278RnkJu8iab6bO5vI/fgQknnyewsLezcE+Wx4P0SZKrWPHcWBSXZjwbXJhqhKChYI+82sr5lvMSiw1w0DDz24052J0rOBQ703uFV09Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722258780; c=relaxed/simple;
	bh=HujL49U5F6fHU0B5jipRCFsJ+7oyVNLA44TdKWtpXzU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L5VRIs+1RtnIxXrVkgM7w3leaScY8KpK8eRAbihFbH76txKoNAy6Ii3vz/a5Q7hs7OP1kVE3nVNuTXVZfheZGzwhwyn0pZOlQDFq08i5jSfwmt4gVonS+4yq0IMAE+Z7nup4OBlXBFnYKiU3QyXifTgWEbBBtBVff5k+me+ojFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aPIMRBiY; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 29 Jul 2024 15:12:51 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1722258774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QO1N4xzjJwL1v9bMx8nbNpS+qR+/4zPti+mb3DQbgzc=;
	b=aPIMRBiYWfZMj37tn1rKHYNp+NXTuSYApDWSWZLcWR1Fi8XNmSMfduc+imFvF/H2+hKHnh
	zF2GciEqb8gaR1qtz0IGGrq5MsZUhvbMtTN2xBmDdeXlYva/6yiUpwoUHspfI/KBhYOEl9
	r4f9udkEiRuErtqGJdym0Ln/Xh+m4Do=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 0/6] Checking and CI improvements
Message-ID: <20240729-bbf3338a7becf7f9c18db23f@orel>
References: <20240726070456.467533-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240726070456.467533-1-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jul 26, 2024 at 05:04:41PM GMT, Nicholas Piggin wrote:
> Here's some assorted fixes and improvements to static checking
> and CI.
> 
> checkpatch support is a big one and you could consider it RFC
> for now. We may want to customise it somewhat (but IMO fewer
> customisations the easier to maintain the script if we can agree
> on close to kernel style). It's nice because it gets DCO, license
> headers, etc., not just code style.
> 
> Here is a pipeline with this series applied:
> 
> https://gitlab.com/npiggin/kvm-unit-tests/-/pipelines/1388888286
> 
> Thanks,
> Nick
> 
> Nicholas Piggin (6):
>   gitlab-ci: fix CentOS mirror list
>   arm: Fix kerneldoc
>   gitlab-ci: upgrade to CentOS 8
>   gitlab-ci: Move check-kerneldoc test out of the centos test
>   gitlab-ci: add a shellcheck test
>   checkpatch support
> 
>  .gitlab-ci.yml         |   83 +-
>  arm/fpu.c              |   24 +-
>  scripts/check-patch.py |   61 +
>  scripts/checkpatch.pl  | 7839 ++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 7986 insertions(+), 21 deletions(-)
>  create mode 100755 scripts/check-patch.py
>  create mode 100755 scripts/checkpatch.pl
> 
> -- 
> 2.45.2
>

For the series,

Acked-by: Andrew Jones <andrew.jones@linux.dev>

Thanks,
drew

