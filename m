Return-Path: <kvm+bounces-18536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A11808D63FF
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 16:05:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F3848B2C835
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 14:00:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16B5817622F;
	Fri, 31 May 2024 13:56:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from gorilla.13thmonkey.org (77-173-18-117.fixed.kpn.net [77.173.18.117])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 865AF158DAA
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 13:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=77.173.18.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717163775; cv=none; b=WS904TU6EsLZOhB+Q4mOKkc2rSjdDYS9rk2ds4q4GWdExuQoEvxbRy1zMdb9T9Nq575iuu37lTJ1Z2cuH6u0fBThQactMdQjOQ34ScWxueXtKO3trglS+cMd8dMYUApXo++Y+fIGrNey2Jj/6yi4IYR4L26bNf8mmiLk7ab3VMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717163775; c=relaxed/simple;
	bh=Kd5o22fNbh6A/Krj11PE3puVCnQbOEumSzfeLFv7k/w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ecPsehS4TUl2lbisUqWejHFO3/jtCQzlz7qGwCUahiZa3ca8Uz6BfUgz2gkIt8LB0qE5Ng5AjkLSLVfos3ni/fkGHBA5zM9r2ylITTY4F9mb1iTtKh6uG5R3prok/r21UKq6pBO/qp0Gy3EUpjgr8uibOe3jMieIgsm5ZdkbPo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gorilla.13thmonkey.org; spf=none smtp.mailfrom=gorilla.13thmonkey.org; arc=none smtp.client-ip=77.173.18.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gorilla.13thmonkey.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=gorilla.13thmonkey.org
Received: by gorilla.13thmonkey.org (Postfix, from userid 103)
	id 2903D2FF0981; Fri, 31 May 2024 15:46:00 +0200 (CEST)
Date: Fri, 31 May 2024 15:46:00 +0200
From: Reinoud Zandijk <reinoud@gorilla.13thmonkey.org>
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Cc: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	qemu-devel@nongnu.org,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Cameron Esfahani <dirty@apple.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Reinoud Zandijk <reinoud@netbsd.org>, kvm@vger.kernel.org,
	Roman Bolshakov <rbolshakov@ddn.com>
Subject: Re: [PATCH 2/5] cpu: move Qemu[Thread|Cond] setup into common code
Message-ID: <ZlnUmG41Ahi_dSzX@gorilla.13thmonkey.org>
References: <20240530194250.1801701-1-alex.bennee@linaro.org>
 <20240530194250.1801701-3-alex.bennee@linaro.org>
 <2a20631b-ce2a-4079-87c6-f77c0ba589e3@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2a20631b-ce2a-4079-87c6-f77c0ba589e3@linaro.org>

On Thu, May 30, 2024 at 03:29:41PM -0700, Pierrick Bouvier wrote:
> On 5/30/24 12:42, Alex Bennée wrote:
> > Aside from the round robin threads this is all common code. By
> > moving the halt_cond setup we also no longer need hacks to work around
> > the race between QOM object creation and thread creation.
> > 
> > It is a little ugly to free stuff up for the round robin thread but
> > better it deal with its own specialises than making the other
> > accelerators jump through hoops.
> > 
> > Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
...
> > diff --git a/target/i386/nvmm/nvmm-accel-ops.c b/target/i386/nvmm/nvmm-accel-ops.c
> > index 6b2bfd9b9c..0ba31201e2 100644
> > --- a/target/i386/nvmm/nvmm-accel-ops.c
> > +++ b/target/i386/nvmm/nvmm-accel-ops.c
> > @@ -64,9 +64,6 @@ static void nvmm_start_vcpu_thread(CPUState *cpu)
> >   {
> >       char thread_name[VCPU_THREAD_NAME_SIZE];
> > -    cpu->thread = g_new0(QemuThread, 1);
> > -    cpu->halt_cond = g_new0(QemuCond, 1);
> > -    qemu_cond_init(cpu->halt_cond);
> >       snprintf(thread_name, VCPU_THREAD_NAME_SIZE, "CPU %d/NVMM",
> >                cpu->cpu_index);
> >       qemu_thread_create(cpu->thread, thread_name, qemu_nvmm_cpu_thread_fn,

I haven't tested it since I don't have a recent qemu build but I doubt it will
give issues as its main qemu stuff.

Reinoud


