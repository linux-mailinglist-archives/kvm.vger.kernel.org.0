Return-Path: <kvm+bounces-31512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AD229C44F4
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 19:29:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D48E6283307
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 18:28:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78E2E1AAE00;
	Mon, 11 Nov 2024 18:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="N69zjM7Z"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C921A76CD;
	Mon, 11 Nov 2024 18:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731349727; cv=none; b=CuBnFOB3h/kQoazEpCcgwQ0p4TxijVgg26iwima6X9u9bIQkRQQSisEDLA8zQ1+gzn/pnyrSLbMbREfIbKW/kseL6l7CR5VK447LaaViQ3ZUp1+NB1nyCT51LH9QUkS8J/N6Pz3LnmsyEFZtbX7NZp5olzuVfCR5tb1TVc8pQnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731349727; c=relaxed/simple;
	bh=f32c2TkG7RKPZS1ZR39BM78SjOeMOw1mBaRO3DH5SGA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kGbhQnvQF3xwPtRXIgUVM+hprItQy+HuiFCm51zMa3VjqJ4Z189H1iEVddpzOME4RV5kAajHRVFHuRT7R+Ur5k5tkw+83j0J9klWWSKPFqkAeXgcjidWWARFtyYf7hAN5r9Cm/1aKY5V/LwS/IPMSlDEnMPSvP6bvNjKHqvR3xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=N69zjM7Z; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=G/UCR3WmKpMCMBpcDE7cPgAljVEs9mxddTCtZNEhxXc=; b=N69zjM7ZrttAVvy4dCOkgDs1yP
	VlN++AJOcx2LO+WmYrxDP3X+joET5UzSI/pw/tWXAEcY+gJHvxSObYKkDRTc9vAfcxeBAHFVOTWcG
	dA4+mXiSe/Ffjk6bjxcS31gR70Rt6Xqk7yAno2DP++7JQFdjmEEyWFDv80kaVtM2pYlqulKGkQQPo
	nbL1OcsPtwccinRm9CrlISvaWZx2xTKbuzRzMgq0m7rHf0XxKzjourtiVLDm0EPFyj/UBKg6+jxNu
	VV5QccWDSaD1byQtuzLEgSLgzIgMe24In6hQSm0yL2BT7l/xcfon1jEI4072vigLfmk3XCTLotcT6
	XAsGzHiw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tAZ9W-0000000D8mX-3D5H;
	Mon, 11 Nov 2024 18:28:42 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id EE57A300472; Mon, 11 Nov 2024 19:28:41 +0100 (CET)
Date: Mon, 11 Nov 2024 19:28:41 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, jpoimboe@redhat.com, tglx@linutronix.de,
	linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	jthoughton@google.com
Subject: Re: [PATCH v2 12/12] x86/kvm/emulate: Avoid RET for fastops
Message-ID: <20241111182841.GJ22801@noisy.programming.kicks-ass.net>
References: <20241111115935.796797988@infradead.org>
 <20241111125219.361243118@infradead.org>
 <ZzI-VHh0GpBUph3l@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZzI-VHh0GpBUph3l@google.com>

On Mon, Nov 11, 2024 at 09:26:44AM -0800, Sean Christopherson wrote:
> KVM: x86:
> 
> On Mon, Nov 11, 2024, Peter Zijlstra wrote:
> > Since there is only a single fastop() function, convert the FASTOP
> > stuff from CALL_NOSPEC+RET to JMP_NOSPEC+JMP, avoiding the return
> > thunks and all that jazz.
> > 
> > Specifically FASTOPs rely on the return thunk to preserve EFLAGS,
> > which not all of them can trivially do (call depth tracing suffers
> > here).
> 
> Maybe add an example?  Mostly as a reminder of how to reproduce the call depth
> issues.
> 
>   E.g. booting with "retbleed=force,stuff spectre_v2=retpoline,generic" causes
>   KVM-Unit-Test's "emulator" test to fail due to flags being clobbered.
> 
> > Objtool strenuously complains about this:
> > 
> >  - indirect call without a .rodata, fails to determine JUMP_TABLE,
> >    annotate
> >  - fastop functions fall through, exception
> >  - unreachable instruction after fastop_return, save/restore
> > 
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> 
> The original patch works, but with the fixup KVM fails emulation of an ADC and
> generates:

Bah, I'll go chase it down. Thanks!

