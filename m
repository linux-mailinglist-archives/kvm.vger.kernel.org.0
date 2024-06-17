Return-Path: <kvm+bounces-19783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9527290B339
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 17:02:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3E9C61F2462B
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 15:02:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF6D013CA93;
	Mon, 17 Jun 2024 14:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NOdlDlbs"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED7413B2AD
	for <kvm@vger.kernel.org>; Mon, 17 Jun 2024 14:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718633566; cv=none; b=oxEtdMO5K2gtbNhkZRUNfkTmg00p+HKH1XzgGMNNwjzxZ7MQ3joQKrtMi9HYCXe84Nnw/7LqY7AHG0c1P2/DSVYpXWjuAp6cHXW0LFvWuWOr56zVUnyys/1aMii19A2PtqH/p624Sc9hitfbHrWfghU1EfkXvXs+unODhAgQtlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718633566; c=relaxed/simple;
	bh=idv+RNfMdguj95RYpQze1i3uEPYPHJkvIy7H4cIl85s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sPMlzrHJBkUqzHPzzMusXho87TNF0AFKQii65d0J7tN24sEJweslQPrYlEmYR39USSME2IlUg4nNx3L7Fgv7XKLXsNDuHuoWRO9U7oGWvBiTHEj5xjTx4zu+ly77gj/xv0y0+VJpcKLxvSfGOKEfcHsNuECSket3Yu1uVrjzNM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NOdlDlbs; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: npiggin@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718633561;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mGVZ/fpAR5i+VcfVDT6mwjpbS1ceLk+ZlfTHTPGpCUg=;
	b=NOdlDlbsCSppAuUtgRw7mfSfoS0QjgJr+7+3n6dgwVKcNFHzSfdutlZroMKD7e6/wnT7JO
	sBnotj2Cb9o42JTxBGqu+CnMupqsqfF+WLcfbtGoGO0/25zAysiaaEdWGw2mtbopmNd/Px
	gmmFGbEtkti4c4RpC/kU2Tuv251coQA=
X-Envelope-To: thuth@redhat.com
X-Envelope-To: lvivier@redhat.com
X-Envelope-To: linuxppc-dev@lists.ozlabs.org
X-Envelope-To: kvm@vger.kernel.org
Date: Mon, 17 Jun 2024 16:12:36 +0200
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v10 12/15] scripts/arch-run.bash: Fix
 run_panic() success exit status
Message-ID: <20240617-99b0652588f6bd62f04f34c2@orel>
References: <20240612052322.218726-1-npiggin@gmail.com>
 <20240612052322.218726-13-npiggin@gmail.com>
 <20240612-eef98a649a0764215ea0d91f@orel>
 <D1ZBXH42OY9O.3N6I0DBO4UF3J@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D1ZBXH42OY9O.3N6I0DBO4UF3J@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 14, 2024 at 10:56:02AM GMT, Nicholas Piggin wrote:
> On Wed Jun 12, 2024 at 5:26 PM AEST, Andrew Jones wrote:
> > On Wed, Jun 12, 2024 at 03:23:17PM GMT, Nicholas Piggin wrote:
> > > run_qemu_status() looks for "EXIT: STATUS=%d" if the harness command
> > > returned 1, to determine the final status of the test. In the case of
> > > panic tests, QEMU should terminate before successful exit status is
> > > known, so the run_panic() command must produce the "EXIT: STATUS" line.
> > > 
> > > With this change, running a panic test returns 0 on success (panic),
> > > and the run_test.sh unit test correctly displays it as PASS rather than
> > > FAIL.
> > > 
> > > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > > ---
> > >  scripts/arch-run.bash | 1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> > > index 8643bab3b..9bf2f0bbd 100644
> > > --- a/scripts/arch-run.bash
> > > +++ b/scripts/arch-run.bash
> > > @@ -378,6 +378,7 @@ run_panic ()
> > >  	else
> > >  		# some QEMU versions report multiple panic events
> > >  		echo "PASS: guest panicked"
> > > +		echo "EXIT: STATUS=1"
> > >  		ret=1
> > >  	fi
> > >  
> > > -- 
> > > 2.45.1
> > >
> >
> > Do we also need an 'echo "EXIT: STATUS=3"' in the if-arm of this if-else?
> 
> In that case we don't need it because run_panic() returns 3 in that
> case. run_qemu_status() only checks guest status if harness said
> QEMU ran successfully.

Ah, yes.

> 
> Arguably this is a bit hacky because "EXIT: STATUS" should really be
> a guest-printed status, and we would have a different success code
> for expected-QEMU-crash type of tests where guest can't provide status.
> I can do that incrementally after this if you like, but it's a bit
> more code.

Just this patch for now works for me.

Thanks,
drew

