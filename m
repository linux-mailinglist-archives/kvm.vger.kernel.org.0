Return-Path: <kvm+bounces-24786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00F1195A2E9
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 18:35:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0941281F26
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 16:35:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B7B11531DD;
	Wed, 21 Aug 2024 16:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YwKW+M7Q"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723A814EC5C
	for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 16:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724258100; cv=none; b=YKeceYcmTt6MJv4Su6nsZxZ7DkHq9xF4pH+12eRf7JYH5Bd/oy0fdmD7DAd2V2Fw2WFbIqqA/PXMYobnB4031LJF80jse0qnz/h1KUdMtR7MfRImHhcPR7AzIi9UDQPpoWJZYIYH1ZMw8X+X2m1CjF9cz7j9rMoD/qq9IDyqlOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724258100; c=relaxed/simple;
	bh=y5JT6IufrXPYcmsUc9wPKflsWKeDh0XgQfGQEyJ3UW0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S0JRZ8fJWxA0ed4H/xlCaF44/cXsAOx9cv0mrmZFhVMjJJzWg/AU4VGL5vpxFPWCrH+YhcAAgRcI4n+20+47SLCN+eZJTaW4zCpR0ZNAKfgBm9TgFnhKqb8v/ZWnj3HputCSuI9P/5q5FTyd/7SnDJcAwf3EBGqCB4SgRzWGhYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YwKW+M7Q; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA7AC32781;
	Wed, 21 Aug 2024 16:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724258100;
	bh=y5JT6IufrXPYcmsUc9wPKflsWKeDh0XgQfGQEyJ3UW0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YwKW+M7QcJ6aJezTDysiz5C80f3hdSl6iXrAr15i4qza7/wj0dyjNo4gzqyhrieZk
	 HJd+Zi7UJB4SbeXbHbZ8Rf/DXhjGVT2YzVGNTTStAzpknTGRr+/3tkWzMB6s57ixsR
	 GMC1eaQ/UjAwEaSTewoeBzdz6/SLTd3N7Yk27HPlu64tPJd4dcTQveZGZlAgCKRXaP
	 F04wr0SM9LWB8Dwlz99lzASUJjBiI3fXZjSoT7pv59Gd7a1YwQcGooTjJSqXMZmAZ5
	 9BIFH8NnksdSjhyw3v21X0yGlqQvrsQWwDDsp/8FPJT2eWOLDgCr1jb5gyv3WVz6WN
	 j4ikbeeGpVVjw==
Date: Wed, 21 Aug 2024 10:34:57 -0600
From: Keith Busch <kbusch@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Keith Busch <kbusch@meta.com>, kvm@vger.kernel.org, x86@kernel.org,
	Alex Williamson <alex.williamson@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Xu Liu <liuxu@meta.com>
Subject: Re: [PATCH RFC] kvm: emulate avx vmovdq
Message-ID: <ZsYXMcb401-ynVFA@kbusch-mbp.mynextlight.net>
References: <20240820230431.3850991-1-kbusch@meta.com>
 <ZsYR5BdX0y4gntKx@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsYR5BdX0y4gntKx@google.com>

On Wed, Aug 21, 2024 at 09:12:20AM -0700, Sean Christopherson wrote:
> On Tue, Aug 20, 2024, Keith Busch wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > 
> > Because people would like to use this (see "Link"), interpret the VEX
> 
> Please explicitly call define the use case in the changelog.  Yeah, I can follow
> the link, but I shouldn't have to just to understand that this is the compiler
> generating vmovdqu for its built-in memcpy().

Sorry about that, but yes, it's essentially a compiler using an
intrinsic aware memcpy. That all works for mmio addresses from pci
passthrough functions, but currently fails on emulated device addresses.
 
> > prefix and emulate mov instrutions accordingly. The only avx
> > instructions emulated here are the aligned and unaligned mov.
> > Everything else will fail as before.
> > 
> > This is new territory for me, so any feedback is appreciated.
> 
> Heh, this is probably new territory for everyone except possibly Paolo.  I don't
> recall the last time KVM was effectively forced to add emulation for something
> this gnarly.

Thanks, I feel a little less shame admitting this patch took me longer
to figure out than predicted. :)

