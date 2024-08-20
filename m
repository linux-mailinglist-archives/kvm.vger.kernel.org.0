Return-Path: <kvm+bounces-24646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 26AA6958ABB
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 17:08:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA35B1F24D6B
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 15:08:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17630191F7B;
	Tue, 20 Aug 2024 15:07:52 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8732E18E758;
	Tue, 20 Aug 2024 15:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724166471; cv=none; b=f5KACe5fGYLR8UjcIQrx0dZdxwU8k3Gb2OPciSLUsMqWJPbpmK8VQBJN4De0vfa8vzskp2y0E/F+0w+7FUQ34HVLZpXSGD9N5vTsisYnjySZ+tpgWzpRJ18CYNfi4iuy/3gxlYLTvOYWpXqtirWxGTwV1P7OHj1nM4GObNtTBeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724166471; c=relaxed/simple;
	bh=XxmLAWJAjlmW83otnLBDg9ds/6fWrw74YC3mtwOma+o=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ebnZ6g40stzdGe7uX9poDf7EKxkfAxaVTiccNRapX5PLJEV8JEjxlKkOfIFMGuziZYtMh52Xkp/xS1ssGiLJVw2tm1BUtMbtXZx1/ze/A5Vls3gbiWDOHQj53Qz4kfk2i+s6YY0yW3u0Kq0nxsCrzFJJLr/IVRRqMIebv0kpAXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86435C4AF0F;
	Tue, 20 Aug 2024 15:07:47 +0000 (UTC)
Date: Tue, 20 Aug 2024 11:08:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, Paolo
 Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Thomas
 Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Paul Durrant
 <paul@xen.org>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli
 <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall
 <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de
 Oliveira <bristot@redhat.com>, Valentin Schneider <vschneid@redhat.com>,
 Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, jalliste@amazon.co.uk, sveith@amazon.de,
 zide.chen@intel.com, Dongli Zhang <dongli.zhang@oracle.com>, Chenyi Qiang
 <chenyi.qiang@intel.com>
Subject: Re: [RFC PATCH v3 20/21] KVM: x86/xen: Prevent runstate times from
 becoming negative
Message-ID: <20240820110814.7d4117fd@gandalf.local.home>
In-Reply-To: <6f805099c5751a3092ee5f198fffb83673ba91ee.camel@infradead.org>
References: <20240522001817.619072-1-dwmw2@infradead.org>
	<20240522001817.619072-21-dwmw2@infradead.org>
	<Zr7X-5qK8sRXxyDP@google.com>
	<6f805099c5751a3092ee5f198fffb83673ba91ee.camel@infradead.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 20 Aug 2024 11:22:31 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> On Thu, 2024-08-15 at 21:39 -0700, Sean Christopherson wrote:
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0vx->last_steal =3D run_del=
ay;
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/*
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * If KVM clock time went =
backwards, stop updating until it
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * catches up (or the runs=
tates are reset by userspace).
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */ =20
> >=20
> > I take it this is a legitimate scenario where userpace sets KVM clock a=
nd then
> > the runstates, and KVM needs to lend a hand because userspace can't do =
those two
> > things atomically? =20
>=20
> Indeed. Will update the comment to make that more obvious.
>=20
> Thanks for the rest of the review on this series. I'll go through in
> detail and update it, hopefully this week.

Hmm, is this related at all to this:

  https://lore.kernel.org/all/20240806111157.1336532-1-suleiman@google.com/

-- Steve

