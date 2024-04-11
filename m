Return-Path: <kvm+bounces-14342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B37E68A20E5
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 23:28:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E3F091C2325A
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 21:28:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7304339AF8;
	Thu, 11 Apr 2024 21:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1rFSV6Wn"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC723CF65;
	Thu, 11 Apr 2024 21:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712870909; cv=none; b=polrgxLsyRIBYeqLN3nxBGNtX8rKRvy14xM59kH7FW4sYaXRn7tcsrD2JPxPG7Fwnd28tREMqi9kLEU2pmKgZFKGvN2czpapbwZL0uIiqQg/v/6Aho5VrfrtVXkFq03w6NndUIgJL2Vw67IzSCsrr9q7MO28r6kYmfI5+JhAh0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712870909; c=relaxed/simple;
	bh=qYZJAos8Y1VlhyFh0wodG8r9EP6fTB4gaPBhuU18hO8=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=dfdC0AyJ+z3hyl9vQa4bmV2t9IzQvqbWlDTacSGrXRKrWDRAOjm34Q7ZfV8apoMEWFkGObWuVaN6E/F0973OdUZH3W9X/FWrVBFv6KLKOP0nJs5MWLRI82/tdGQd9SR6Ey0FZMRLlyAYZ6IGpFASTlcvT9rGJaYPwbIMjDx/YLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1rFSV6Wn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DDE9C072AA;
	Thu, 11 Apr 2024 21:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712870909;
	bh=qYZJAos8Y1VlhyFh0wodG8r9EP6fTB4gaPBhuU18hO8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=1rFSV6WnuiT57XyEfZi728PpeWo2haLruBtoEN/Awm7LEedlT6WNJf8F+xyZCGAbv
	 A/fAldqTr7ZyeA4IjWWh5av3FodBpvp0cpkMq0+hvyjt0yt+ElWoSI0swMmZrBNU6n
	 olojFA0RW078omUyeBn/qiSahZ9Hne+LuXx1HR/I=
Date: Thu, 11 Apr 2024 14:28:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, Claudio
 Imbrenda <imbrenda@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Peter Xu <peterx@redhat.com>, Alexander
 Gordeev <agordeev@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Andrea Arcangeli
 <aarcange@redhat.com>, kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 0/2] s390/mm: shared zeropage + KVM fixes
Message-Id: <20240411142827.d5c3bc401c6536bb1315049a@linux-foundation.org>
In-Reply-To: <20240411161441.910170-1-david@redhat.com>
References: <20240411161441.910170-1-david@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 11 Apr 2024 18:14:39 +0200 David Hildenbrand <david@redhat.com> wrote:

> This series fixes one issue with uffd + shared zeropages on s390x and
> fixes that "ordinary" KVM guests can make use of shared zeropages again.
> 
> ...
>
> Without the shared zeropage, during (2), the VM would suddenly consume
> 100 GiB on the migration source and destination. On the migration source,
> where we don't excpect memory overcommit, we could easilt end up crashing
> the VM during migration.
> 
> Independent of that, memory handed back to the hypervisor using "free page
> reporting" would end up consuming actual memory after the migration on the
> destination, not getting freed up until reused+freed again.
> 

Is a backport desirable?

If so, the [1/2] Fixes dates back to 2015 and the [2/2] Fixes is from
2017.  Is it appropriate that the patches be backported so far back,
and into different kernel versions?  

