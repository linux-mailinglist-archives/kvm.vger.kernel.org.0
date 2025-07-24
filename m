Return-Path: <kvm+bounces-53326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2800B0FE6D
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 03:47:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DAE8B545120
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 01:47:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34C451917F0;
	Thu, 24 Jul 2025 01:47:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C3E2E401;
	Thu, 24 Jul 2025 01:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753321631; cv=none; b=JfGl+v1jjrEdiIaug/S5VIlAMMxk6m/wzDXfoTFTevX4hOApHlaX8GZqC7R0TVJLwcvlZMAhPjIKlE+JP0AK4IWN59c9Z9fyc3YVDIqu/fC7iJykqrqt8vw7JdM8hfE8y8Le/gy2MWxRP2kHlf1xbdRz4kW90uf2MXnSwf8T+Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753321631; c=relaxed/simple;
	bh=JGAPT2y5vCJk7CHZcqulhAcsd3hJ86zVp2npp+8zxIs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XbceFpHiawrXUnHjjXNSdD9As+n0q2+xhnJn0YFgv+3BCG5FWRFetx8sRagjN9jR0uzPiX6/HYxzFzmqbfXBy4x3YTkjOET8jvK4Qyno9UdfvjVJVyJg4mE6IDZFk6wxsNHvoFMCmejVXqMrosZw9TL+ObGY4MvGlBtIpnmvQa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 30F29140257;
	Thu, 24 Jul 2025 01:47:00 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf06.hostedemail.com (Postfix) with ESMTPA id 15E862000F;
	Thu, 24 Jul 2025 01:46:57 +0000 (UTC)
Date: Wed, 23 Jul 2025 21:46:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Bibo Mao <maobibo@loongson.cn>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux Trace Kernel
 <linux-trace-kernel@vger.kernel.org>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, Tianrui Zhao <zhaotianrui@loongson.cn>, Huacai
 Chen <chenhuacai@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Masami
 Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] LoongArch: KVM: Move kvm_iocsr tracepoint out of
 generic code
Message-ID: <20250723214659.064b5d4a@gandalf.local.home>
In-Reply-To: <2c2f5036-c3ae-3904-e940-8a8b71a65957@loongson.cn>
References: <20250722094734.4920545b@gandalf.local.home>
	<2c2f5036-c3ae-3904-e940-8a8b71a65957@loongson.cn>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hwzx9b664hbnaqgib6b3t6gt3tjoitbi
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: 15E862000F
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+R71P4igtfWWN1YfuNJBdwIDm4LxWkQLI=
X-HE-Tag: 1753321617-46973
X-HE-Meta: U2FsdGVkX18On4fhUvlFtAwON6K9H7h8+QKr1p2cROfk+XC700B0IdFLooO3C4BVn1CUAvUakMAIGuzInJsyCTlEdjojcaqPhWX1nYYgJiKqnbqxWDo0lu/++sQaUzUyudYKijmSc4Jzx8MshNfyAi7xFrHweb0yOixVPvdKgCE6kcIPBC17qgv1Z0F4f5fpvIYb+gxaptVTIn6RKQsazQMRHWSo0iTeyBByaFeCa4pt9YdW6uUzsDJ6TWTGkhrAUTimxfHlvsJOYbkci6QsCzp5K4AaJSXvrXe8Fjech8gAWEIrGN+gP/cugt26IELeS8pu/CjwFK4npecydlbRUUb3dvg1Sd7CZhfPr74AXJE=

On Thu, 24 Jul 2025 09:39:40 +0800
Bibo Mao <maobibo@loongson.cn> wrote:

> >   #define kvm_fpu_load_symbol	\
> >   	{0, "unload"},		\
> >   	{1, "load"}
> >   
> Reviewed-by: Bibo Mao <maobibo@loongson.cn>

Thanks,

Should this go through the loongarch tree or should I take it?

Either way works for me.

-- Steve

