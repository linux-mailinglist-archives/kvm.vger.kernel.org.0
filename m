Return-Path: <kvm+bounces-23864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AD8D494EFA0
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 16:32:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 485ACB23D01
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 14:32:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6CCF181B87;
	Mon, 12 Aug 2024 14:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="o1e4Nanw"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B05416E87A
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 14:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723473137; cv=none; b=YjoZOaCWkLgTKkKat0sW304RB5lBlUM245JVSgXC8FrUsPFbyXlPHwKJCmn7Ct7J+SUZPzKHP3B6n/8vdxASEhxPHHSJkv/77HVXbdkwzApDsNQl5gwYOTyPrNQnRYbr8P19cLMP6fvCz4cJ8HLxhfEXhT466WJBQCytlJIkTHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723473137; c=relaxed/simple;
	bh=evv8vzISKyHqWiTzA9mBLg5H2wB1aSQlD4XSblSo8nE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SQE7DsA9ZGKCToaUq3nRz48aJ/kI12SPPeDHh5NtRjtJBc0ri8IvCzkGI4e3PrIxsJ0LbQt4WeujWRjy+GsNlspiJbZKeovmEW5cAJMfKmnX8J6I5dwwf9LDnW+mRCpiGX3KJavOM7PWWVZfyQG+z8+8wzwGqPv0P03p3g4VfjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=o1e4Nanw; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 12 Aug 2024 16:32:09 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723473131;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O0BHsk7p7pyM9FCKtndFIBNXHJ/yqo6BMqJCtQdHc1I=;
	b=o1e4NanwN5DO2BCeLQfRpch6/pTVlpkxaTtO1n6WD040ZcNeN73FMVejFKBnNHNCYLVtkD
	HmrYxE3ngaai4qVG0qM03G6cqTSdxkWQplbWdIh3tA12xjKiQCL9cK8kNDrSVkolrQZYD0
	iCJvxiLzH0KWLQP8OGWsDARl8MxBj5A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 0/6] Checking and CI improvements
Message-ID: <20240812-84356f0889e97c6849d65513@orel>
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

Merged

Thanks,
drew

