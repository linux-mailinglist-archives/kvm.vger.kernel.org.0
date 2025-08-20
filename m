Return-Path: <kvm+bounces-55082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 15AFEB2D0B1
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 02:29:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B08E13B4010
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 00:27:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECA57156F5E;
	Wed, 20 Aug 2025 00:27:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CB313A86C;
	Wed, 20 Aug 2025 00:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755649647; cv=none; b=d7r/14wMP+lKaCz1ZH4naMzWvihDt07Cri7iSrRaxSd42F7QBEfPntUda3Y0Q5lt4z7uHBEL6lUqHQETMqSTd2rf1RINqCoyEhJPKi7BImLcJ2SMxqSnJND9WemhqmvGqN97lHzfV5474tP1vylruGdvR4Y4ZojNIKKgTaJzYDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755649647; c=relaxed/simple;
	bh=gm2a1v9IVPuOwd8HEXy/VDr0ag/FHWUnuaXgT4HbLik=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jJGWWUP54I2HNuYUnRWkbbApsrnrsdwAIs50Xjm15jdQGyMBX9nIk2U93uNrHyUv3q9YoXMGFIw468bQPSAQiHUMYycmmGuup9VFkOCx7997dRYy+0P5lQsJzpDjgP7cHICruO6MDkxd0Nd9yWwVmPHrnASO1QlC6wVDcauIhVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3676F1A0287;
	Wed, 20 Aug 2025 00:27:17 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf18.hostedemail.com (Postfix) with ESMTPA id 0590D2E;
	Wed, 20 Aug 2025 00:27:14 +0000 (UTC)
Date: Tue, 19 Aug 2025 20:27:15 -0400
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
Message-ID: <20250819202715.6f1cf0d6@gandalf.local.home>
In-Reply-To: <CAAhV-H4TGus35B6ONdkSOMwWw+H6NRmHStV-Xu7vUYYrkDGfUQ@mail.gmail.com>
References: <20250722094734.4920545b@gandalf.local.home>
	<2c2f5036-c3ae-3904-e940-8a8b71a65957@loongson.cn>
	<20250723214659.064b5d4a@gandalf.local.home>
	<15e46f69-f270-0520-1ad4-874448439d2b@loongson.cn>
	<CAAhV-H4TGus35B6ONdkSOMwWw+H6NRmHStV-Xu7vUYYrkDGfUQ@mail.gmail.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0590D2E
X-Stat-Signature: tui4sbrzrksw68jmexsrk315o7o7n5td
X-Rspamd-Server: rspamout02
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1++WOHapJUxAf+8t+c3THz1mBYsdmfqoyY=
X-HE-Tag: 1755649634-528654
X-HE-Meta: U2FsdGVkX18/nuGO+4wD+/Da8NSvPyPWizSJqU41fOf5srsgKcJhPQQfj8hvGQ+9RFovMTcjm++P2p1pyoagm8leyJqJpug8p61ybQ8+cexkgDpssKeB8xI9xycTlttA9xt8WXEOGXRV7XK3QcnZlX+LuM2ynNjWvXuZeBo4kSuNYALGvinW8xJJ+WEF6YjlC4qZRz0c4TI6XUMSF6YzmvvRgpjzTKHrSfL9SB36XUsMlLNwtkx7XWQP3k15iJ8mwYkEEh94ICrMOMwFsmziyefZ5aGK/PHVkYfIRpabd3dghYvjC38hgeeW64t+NZOloc4K+VOJc1fFHqT8wKZ8ECZ8uOTdluHZur+0ngE5ZDCtq3T+E2R1eLk6wTS1LWz/

On Thu, 24 Jul 2025 19:56:42 +0800
Huacai Chen <chenhuacai@kernel.org> wrote:

> On Thu, Jul 24, 2025 at 9:51=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wr=
ote:
> >
> >
> >
> > On 2025/7/24 =E4=B8=8A=E5=8D=889:46, Steven Rostedt wrote: =20
> > > On Thu, 24 Jul 2025 09:39:40 +0800
> > > Bibo Mao <maobibo@loongson.cn> wrote:
> > > =20
> > >>>    #define kvm_fpu_load_symbol      \
> > >>>     {0, "unload"},          \
> > >>>     {1, "load"}
> > >>> =20
> > >> Reviewed-by: Bibo Mao <maobibo@loongson.cn> =20
> > >
> > > Thanks,
> > >
> > > Should this go through the loongarch tree or should I take it? =20
> > Huacai,
> >
> > What is your point about this? =20
> I will take it, thanks.
>=20
> Huacai

Did this fall through the cracks?

-- Steve

