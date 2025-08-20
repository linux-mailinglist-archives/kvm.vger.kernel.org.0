Return-Path: <kvm+bounces-55128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 279F2B2DDF5
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 15:38:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 733DD7A5234
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 13:36:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9BEF322A12;
	Wed, 20 Aug 2025 13:35:19 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6605772617;
	Wed, 20 Aug 2025 13:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755696919; cv=none; b=Q1ExHGWVyuAyff9kMZMetGZ9dXzLB7HBnbIDVYNHvt5e7eY/ttjVpBRzXCmY4goCXVxdttA0He3m2MDUs8fhzGhggEmTvcGRfxVjZn8hXJNsSOGuJ/po+IVZj1OHVkGN2gsB1jcFKtRw2KfujjpzzqI45UYVhBDtKGG27HcsRAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755696919; c=relaxed/simple;
	bh=6ELQVz1pCGrjhQgs+Cr+aXgY3t+o6KTC0x0kgzj1D9k=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VV3p04PZG37iZOdA9byfzKMdQmDhtiqb3WH1CybTaz9W2iBvS3eHIKdRUQC3CrzA9ZN9fYbgreDAHFJODTMJNGrHKxX8dF1glJlwSboXiA9R9Xb/8NrVt26hKh047aQzSoQcGH8J5fabnexz93Ttb6k97cZ43rka6cPSuakP65c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8AABB59476;
	Wed, 20 Aug 2025 13:35:15 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf05.hostedemail.com (Postfix) with ESMTPA id 405C020018;
	Wed, 20 Aug 2025 13:35:13 +0000 (UTC)
Date: Wed, 20 Aug 2025 09:35:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Bibo Mao <maobibo@loongson.cn>, LKML <linux-kernel@vger.kernel.org>,
 Linux Trace Kernel <linux-trace-kernel@vger.kernel.org>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, Tianrui Zhao
 <zhaotianrui@loongson.cn>, Paolo Bonzini <pbonzini@redhat.com>, Masami
 Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] LoongArch: KVM: Move kvm_iocsr tracepoint out of
 generic code
Message-ID: <20250820093515.17afe135@gandalf.local.home>
In-Reply-To: <CAAhV-H5y8Tckih4jd3C8Q-M6OZiw2szCYuxLQfBXehpWSvrstA@mail.gmail.com>
References: <20250722094734.4920545b@gandalf.local.home>
	<2c2f5036-c3ae-3904-e940-8a8b71a65957@loongson.cn>
	<20250723214659.064b5d4a@gandalf.local.home>
	<15e46f69-f270-0520-1ad4-874448439d2b@loongson.cn>
	<CAAhV-H4TGus35B6ONdkSOMwWw+H6NRmHStV-Xu7vUYYrkDGfUQ@mail.gmail.com>
	<20250819202715.6f1cf0d6@gandalf.local.home>
	<CAAhV-H5y8Tckih4jd3C8Q-M6OZiw2szCYuxLQfBXehpWSvrstA@mail.gmail.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9k4eh3oijqqgwyg3ppxk7whhmtf5pw8y
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: 405C020018
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18nofUHrM87h1aA5I0GIXVNjvJt8sQYOls=
X-HE-Tag: 1755696913-536970
X-HE-Meta: U2FsdGVkX188CoBRITJc9sfrnjFJZAnQdfzvrGwI+DU2SR+8FpnwMpMY9Dva2BYtul0r8pAB7T3yfQGJdYFpl447Xnu+V9Cq2uh3G3yDIL70vxUEj+nGXp6og8B0PAdNjFvch7xTDKms7ipP6oJ1u5YO/7LvtcLsH/IM+pRmIcq7Ia1NrLkZ5DPMg0GTrkVZez1+2TvcfaqCQ1SnDMSU0aZb0+B2z4hh39OzbS+la0dtt8QVxLTEo3Y1r+6BGvkz/gQdLfC15IdkUoCmo50gnbHoZ1Vg5Dv+O6Y4qsMOF+DUS1SoG4YNpWfUbl8sRAAyTQbsa9TTeLn47+CqBQBTSd06zUo65A3C

On Wed, 20 Aug 2025 11:03:05 +0800
Huacai Chen <chenhuacai@kernel.org> wrote:

> > Did this fall through the cracks?  
> I don't know what this means, but I think you are pinging.

Sorry for the colloquialism, it's not actually the same as a ping. A ping
is for something that had no response. This is more about the patch was
acknowledged but did not go further. "Falling through the cracks" is like
picking a bunch of things up with a bucket that has a crack in it. Some of
those things may "fall through the crack" and not be processed.
> 
> This patch appears after I sent the KVM PR for 6.17, and it isn't a
> bugfix, so it will go to 6.18.

Well, it will start causing warnings soon because it wastes memory. But
that will likely begin in 6.18 so we are OK, as long as it gets into
linux-next before the warning trigger does.

-- Steve

