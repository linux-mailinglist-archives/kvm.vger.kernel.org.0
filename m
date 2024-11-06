Return-Path: <kvm+bounces-31013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5588F9BF472
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 18:42:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C2471F235C2
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 17:42:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BF292076AA;
	Wed,  6 Nov 2024 17:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FDK3D7Ab"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4919A206E8E;
	Wed,  6 Nov 2024 17:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730914932; cv=none; b=qE/SVmaMJazJV86mhUyAf2XcetEhhXwA+3yWC/YEmLbeFtA2jyX6OJ7fZZb0qLAOywF8qG+vP4bsm4NTxI4SV1BYsRoE3PijMgiJDBGYZNRby8vSPs/BD/AYIEuVEALRbhoLywoZFlcsEg3UX3SCwGJzTYFD48RYcbpgdDGlW3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730914932; c=relaxed/simple;
	bh=0epe3jFoueeTdLMb6q6F6RZyKfIdh+oWykNex7JAsqw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tXGpw+9hRfP2oClj5McHt1az6AuJj4B8E5T6IapmvENkeIMichTE3hdPj5JymbAzoYNOYgeQg+UmqopG6rkaPB4WXup5VXSD8w3XulPPwEgYHenkbZvpskYOcpaJaqoQyRZaYFZ38fzJ3050BeqNI5twmJ5KEZungcQLm5EPbMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FDK3D7Ab; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nbsern2sRvPo4p5IDI4+GrvNhsWdB0M6Xb6CmZ3xr/w=; b=FDK3D7AbUixrdzISedEaOoJp3O
	Yv/LMM4V0tvDatZqNM6bUFtBht3PBRe4OYpJWuXrgh+hx3BQ5JnVOsYUMTjqmPtGaxKmC417nuhNO
	iI/4i6RthPKEK3eO5bfHlUnbbuBpVBACOggzJmmgWBaywzEGpVOruyyLjCFSwepBgiXVliGTjYFdh
	r3x1qnPMAA4w11L8PUWaZOJDoT2jIzr6ibkEyWyW20BVQjAareXNfk4ZiPuPAf++EMU5T74gktpgl
	QM5Hf73vcwIhQ7UHJ33b/Zxa4ty1fdCM2ScPjENzNATQ9bvnXSHL0EumVYWhGpi8b5dRndNnnaJXA
	5Oc3KF9w==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t8k2g-000000052CO-1Z4v;
	Wed, 06 Nov 2024 17:42:07 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 9B79E300478; Wed,  6 Nov 2024 18:42:06 +0100 (CET)
Date: Wed, 6 Nov 2024 18:42:06 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: James Houghton <jthoughton@google.com>
Cc: seanjc@google.com, jpoimboe@redhat.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, pbonzini@redhat.com,
	tglx@linutronix.de, x86@kernel.org
Subject: Re: [PATCH 03/11] objtool: Convert ANNOTATE_RETPOLINE_SAFE to
 ANNOTATE
Message-ID: <20241106174206.GP10375@noisy.programming.kicks-ass.net>
References: <ZXEEbrI7K6XGr2dN@google.com>
 <20240913204711.2041299-1-jthoughton@google.com>
 <CADrL8HXv6qG5ewYP07_b7a+FOKB5GAowQjV=6_sBPOrREi-c1Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADrL8HXv6qG5ewYP07_b7a+FOKB5GAowQjV=6_sBPOrREi-c1Q@mail.gmail.com>

On Wed, Oct 30, 2024 at 01:08:28PM -0700, James Houghton wrote:
> Hi Peter,
> 
> I'll go ahead and repost this series soon unless you tell me otherwise. :)

Thanks for your persistent poking. I've refreshed the queue:x86/kvm
branch, and provided the robots don't scream, I'll go and post it.


