Return-Path: <kvm+bounces-9287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CF9BC85D19F
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 08:43:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 85D141F24046
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 07:43:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86BBA3AC26;
	Wed, 21 Feb 2024 07:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nK6HEOCC"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E5B3AC14
	for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 07:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708501400; cv=none; b=syc9yzFX2RS2NMp2kSQExur1wYER67B8Vu9FvQmy7uK9BUmX/MYbniZ6d131K8HYT4VA4M2JLEfkJNDoDxvpi3tsBVNV1ZuTi3yEozF+4nfgGFBQAYlHdx09TvQuX/jrYOtDUOnJe/U7XykSAeDGwBqp1e5hl9GcT9ukJHfcETw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708501400; c=relaxed/simple;
	bh=i+odruXpyZDoj4T7F8WmFZTqW3BkqIyHP+enJNkvL0E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uUJtzlWNzpoKp0wq62DoiDur24wzHMkn2UW5c1qtz7Q7oCoNMAuEW34+ONCYl7rUfZAt9JN2iKwlP4G5jonfApWitnzNwLuHC/sbZMOY/VG5E8OTu49ITRJzW8rck2aNWI3hLmxiKcEg28zJ7q1S07OPOuC8Y98y4Qz2frvFIDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nK6HEOCC; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 21 Feb 2024 08:43:10 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708501393;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AHnDceGRllGyFNwVPyWXmLC366QTA5U6qIHUNwq3W10=;
	b=nK6HEOCCA3Eu2DEU+TcbMEtKnxyqfX8YsIDv/VqRpUam3ioTYkbrj5SGaA/AK/NSr7gyoP
	pyFpzsZ66buwFwCYKu4rCN+k3RyWJ6ZPXA4f/Ry0bgbGHxDx1VwSmPIricXPXowq6w/QuS
	QB/AF8iF1IpXujmUUGzNyalGq/m2cA8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org, 
	Laurent Vivier <lvivier@redhat.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Nico Boehr <nrb@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Eric Auger <eric.auger@redhat.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	David Hildenbrand <david@redhat.com>, Marc Hartmayer <mhartmay@linux.ibm.com>, 
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org
Subject: Re: [kvm-unit-tests PATCH v5 7/8] Add common/ directory for
 architecture-independent tests
Message-ID: <20240221-5417524c1ca5d615f005c7d6@orel>
References: <20240221032757.454524-1-npiggin@gmail.com>
 <20240221032757.454524-8-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240221032757.454524-8-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 21, 2024 at 01:27:56PM +1000, Nicholas Piggin wrote:
> x86/sieve.c is used by s390x, arm, and riscv via symbolic link. Make a
> new directory common/ for architecture-independent tests and move
> sieve.c here.
> 
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  arm/sieve.c    |  2 +-
>  common/sieve.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++
>  riscv/sieve.c  |  2 +-
>  s390x/sieve.c  |  2 +-
>  x86/sieve.c    | 52 +-------------------------------------------------
>  5 files changed, 55 insertions(+), 54 deletions(-)
>  create mode 100644 common/sieve.c
>  mode change 100644 => 120000 x86/sieve.c
>

Acked-by: Andrew Jones <andrew.jones@linux.dev>

