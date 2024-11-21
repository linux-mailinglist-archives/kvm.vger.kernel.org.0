Return-Path: <kvm+bounces-32254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 836299D4C2F
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 12:46:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 493E72819A3
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 11:46:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EDF31D1F6B;
	Thu, 21 Nov 2024 11:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VptVebi8"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B16616EBEE;
	Thu, 21 Nov 2024 11:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732189590; cv=none; b=qsG/nI5ZKs+e5Zkkcdgc7EOgJgEoRDOyFRqdor8UUBS9vgwGHtf3JQryG2nRErPHitLEdNHfLFR50iYbYjGq6BMmjWMLHqzJ9o4WS+LwbaHAsOFet/vpQqp5ZysM8J3DT93Zy/X66Xr41Y3/tzBdfRKtDaFEfi69zi3jWD6pcI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732189590; c=relaxed/simple;
	bh=u+qQGOjC/8Yvob8W00T6BT6gJcQ8ITzS/zMb1wpZMZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DOCTzgNAPAyyBiXM4fT9tyROoNLudjuL5wO2cs9At+hlUThcfAx/zwGYdPLooPNqyQkuBLMjs93UlZIjmjwEtwmFop1Y+7bf4rCed0R6A9MlC+D2hD+4cwGiJ5pzvkctPa/yj9yxszsUBfK12H8ep0sRMOMnYjCFMJv7xcHI/CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VptVebi8; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sBi7gZgjp6w2TJF/4NKwxDz1OUyb9c1yz3UviWlV53E=; b=VptVebi8eosVRNzrllxBaDfrCK
	RPSzd06sa9UzQ+8sIIV9QZ35PFAjX9we0WGsjAZBuEK3trPpSXpVlqw5K6q0qcNFmzaz7zQLIA5SY
	07AFVPVG7BcQnCDqB5IhCM/5y0QzxAB3hApfcbf7JetPOzuJP4lA8OmfgwFl/Dj8VPsW+3UuYWXZP
	C9jsnmalOlk4zZCAd6d3tDZ2X0wNumes7yoNH11evjWJx1P3SUAx+ExAcgthGPqNgDG38jrs8c4Zk
	JdbtEpeZ+k6gzNPYFMGea3yp8P5UC4nJeaNHypNlx1nzuvKkHCJrHxts+blnvdIzWYdfawPEnh6q0
	5lVLOSrA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tE5di-00000000ZnP-2sJo;
	Thu, 21 Nov 2024 11:46:26 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 71EF130068B; Thu, 21 Nov 2024 12:46:25 +0100 (CET)
Date: Thu, 21 Nov 2024 12:46:25 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
	linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	jthoughton@google.com
Subject: Re: [PATCH v2 01/12] objtool: Generic annotation infrastructure
Message-ID: <20241121114625.GI24774@noisy.programming.kicks-ass.net>
References: <20241111115935.796797988@infradead.org>
 <20241111125218.113053713@infradead.org>
 <20241115183828.6cs64mpbp5cqtce4@jpoimboe>
 <20241116093331.GG22801@noisy.programming.kicks-ass.net>
 <20241120003123.rhb57tk7mljeyusl@jpoimboe>
 <20241120010424.thsbdwfwz2e7elza@jpoimboe>
 <20241120085254.GD19989@noisy.programming.kicks-ass.net>
 <20241120160308.o24km3zwrpbqn7m4@jpoimboe>
 <20241120160324.ihoku7dopaju6nec@jpoimboe>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241120160324.ihoku7dopaju6nec@jpoimboe>

On Wed, Nov 20, 2024 at 08:03:24AM -0800, Josh Poimboeuf wrote:

> > If you look at "readelf -WS vmlinux" there are plenty of non-mergeable
> > sections with entsize.
> 
> Er, vmlinux.o

Well yes, but how do you set entsize from as? The manual only mentions
entsize in relation to M(ergable) with the .section command.

