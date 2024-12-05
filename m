Return-Path: <kvm+bounces-33114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F09E9E4F73
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 09:13:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 30DCE167DB6
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 08:13:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D04C1D0F46;
	Thu,  5 Dec 2024 08:13:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.gnudd.com (mail.gnudd.com [93.91.132.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05531CF5EC;
	Thu,  5 Dec 2024 08:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.91.132.248
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733386380; cv=none; b=JKxqEVQ0aWpvD8AtPSnHF0wcHh0MnN7rjrK6JCLRn6X0PvXJ6z38WbwZAQxrJMSNzK+Z4KfDw3c/ugzJVvDsgTsQkqoCp400cUrYyJlcLibMhEeRvJpNvI5brkeI5BWRsWB3bvD7pEZfOQupXUhvjv3EA8Yb3hUxb0blrLPLOZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733386380; c=relaxed/simple;
	bh=uKzZE5ndOJlXuvikA/kWZZC8y9nWmrh3CP7PH/q0nSk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BJ4qhwWZ2ofWAmUk1AoTltmGUQtVrsCS+FBDUuI5LWliqR0Otg0MRSKtn3H0Am19Awych3unIzLgHBkD/7V4MGA+vPZv7ubRXNk7v2YOCHc9B6UrRiLag8dIIrZO0JOADwe7puo8ypg681ullK+bzSk75nkiyKAKrRCV9lczTqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gnudd.com; spf=pass smtp.mailfrom=arcana.gnudd.com; arc=none smtp.client-ip=93.91.132.248
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gnudd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arcana.gnudd.com
Received: from dciminaghi by mail.gnudd.com with local (Exim 4.94.2)
	(envelope-from <dciminaghi@arcana.gnudd.com>)
	id 1tJ6OJ-0005D0-Tq; Thu, 05 Dec 2024 08:35:15 +0100
Date: Thu, 5 Dec 2024 08:35:15 +0100
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: Arnd Bergmann <arnd@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
	Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andy Shevchenko <andy@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 10/11] x86: remove old STA2x11 support
Message-ID: <Z1FXs005p8NtxsqD@arcana.i.gnudd.com>
References: <20241204103042.1904639-1-arnd@kernel.org>
 <20241204103042.1904639-11-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20241204103042.1904639-11-arnd@kernel.org>
X-Face: #Q;A)@_4.#>0+_%y]7aBr:c"ndLp&#+2?]J;lkse\^)FP^Lr5@O0{)J;'nny4%74.fM'n)M
 >ISCj.KmsL/HTxz!:Ju'pnj'Gz&.
Sender: ciminaghi@gnudd.com

On Wed, Dec 04, 2024 at 11:30:41AM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> ST ConneXt STA2x11 was an interface chip for Atom E6xx processors,
> using a number of components usually found on Arm SoCs. Most of this
> was merged upstream, but it was never complete enough to actually work
> and has been abandoned for many years.
> 
> We already had an agreement on removing it in 2022, but nobody ever
> submitted the patch to do it.
>
yes sorry for that, I've never found the time to do it.

Thanks a lot
Davide Ciminaghi

