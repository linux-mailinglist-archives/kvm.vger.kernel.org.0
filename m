Return-Path: <kvm+bounces-32176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDA1E9D3FA9
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 17:05:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84192284336
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 16:05:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7130A149C42;
	Wed, 20 Nov 2024 16:03:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81BC13B58A;
	Wed, 20 Nov 2024 16:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732118590; cv=none; b=tbPKts549sh5vINbSx3Mt1TGb2M49+pIaGUAA3cIOgSQvGIEpDyW4fmPTREs2wwv+Hbd3QbgzJlS3UEnhzxIQSMQk+ydkiEWDBhW9OL9rPqHpv9XwQN9yKuPUJ2cWagYBI4j6MYQ6MuD/Efdt6vX+CtMUPd6wwHiVyu6sUtMJwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732118590; c=relaxed/simple;
	bh=RJ4Vucc/cxtUFNACctKnTIOaLzrgb7JCOMjpeh0QwSo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lC1jK5gyv3QukK1bcP/bfYFin9F+RSp1SkyEhIrelOrv7YqFa1uRdsmwHihDUvKIdK7dKhJzN2eNDq1kZsjshXeGFo3zJQ6uH/rdpGRJ5MmhWhUUsTi7ro5lNe4uI+SzpLFHg/ivDusVBpf2jVpFXcW1RGmP2Qehf2HRxLW9yN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39AEDC4CECD;
	Wed, 20 Nov 2024 16:03:10 +0000 (UTC)
Date: Wed, 20 Nov 2024 08:03:08 -0800
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
	linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	jthoughton@google.com
Subject: Re: [PATCH v2 01/12] objtool: Generic annotation infrastructure
Message-ID: <20241120160308.o24km3zwrpbqn7m4@jpoimboe>
References: <20241111115935.796797988@infradead.org>
 <20241111125218.113053713@infradead.org>
 <20241115183828.6cs64mpbp5cqtce4@jpoimboe>
 <20241116093331.GG22801@noisy.programming.kicks-ass.net>
 <20241120003123.rhb57tk7mljeyusl@jpoimboe>
 <20241120010424.thsbdwfwz2e7elza@jpoimboe>
 <20241120085254.GD19989@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241120085254.GD19989@noisy.programming.kicks-ass.net>

On Wed, Nov 20, 2024 at 09:52:54AM +0100, Peter Zijlstra wrote:
> On Tue, Nov 19, 2024 at 05:04:24PM -0800, Josh Poimboeuf wrote:
> > On Tue, Nov 19, 2024 at 04:31:25PM -0800, Josh Poimboeuf wrote:
> > > On Sat, Nov 16, 2024 at 10:33:31AM +0100, Peter Zijlstra wrote:
> > > > On Fri, Nov 15, 2024 at 10:38:28AM -0800, Josh Poimboeuf wrote:
> > > > > On Mon, Nov 11, 2024 at 12:59:36PM +0100, Peter Zijlstra wrote:
> > > > > > +#define ASM_ANNOTATE(x)						\
> > > > > > +	"911:\n\t"						\
> > > > > > +	".pushsection .discard.annotate,\"M\",@progbits,8\n\t"	\
> > > > > > +	".long 911b - .\n\t"					\
> > > > > > +	".long " __stringify(x) "\n\t"				\
> > > > > > +	".popsection\n\t"
> > > > > 
> > > > > Why mergeable and progbits?
> > > > 
> > > > In order to get sh_entsize ?
> > > 
> > > Is that a guess?  If so, it's not very convincing as I don't see what
> > > entsize would have to do with it.
> > 
> > Oh, nevermind... I see it's a gas syntax issue.
> 
> Not a guess, only mergable gets entsize, and progbits is a required
> argument per the syntax in order to specify entsize.

If you look at "readelf -WS vmlinux" there are plenty of non-mergeable
sections with entsize.

-- 
Josh

