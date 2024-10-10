Return-Path: <kvm+bounces-28466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D99B998E23
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 19:13:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B74C6B21D20
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 17:13:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A31319C57C;
	Thu, 10 Oct 2024 17:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=efault@gmx.de header.b="extP5NzC"
X-Original-To: kvm@vger.kernel.org
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CFA192B9E;
	Thu, 10 Oct 2024 17:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728580416; cv=none; b=fBH4HDGmM1s0t2nUL+HxAkCpy++ALI24gRkaxpbeAQnDlD7fA7T+LYF0i6goUnZCYUb7YcKr2c7aRKqCb8Py5gUtwUnSUo7gxJVhgQ7UkaSMqp/ad0H2YTEITtVX/TIqGzeVn2Fg6HVYA8G9VOH6r2prGIKpu3aNJt9PBipU+1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728580416; c=relaxed/simple;
	bh=A9wjFLAKAEk9yzuZckU+ktdrv3eJgl+SDuYv1brdNeI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YP5ux+eH8D2znK5W/SyZAvgS1HwK2Q+wj6I3R28N6iU9kKF2gHivF5F87bYxtxiOSBamVOs8m9bD+JlgfXrWjrQWM8o5fMbGdKgc5DxE3MG/tefkW9PC5z+xOMsSjI3EzUUYUo8krNCRNPMS2jmpvKKJ2vEyAPQLlV0//10ngXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=efault@gmx.de header.b=extP5NzC; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1728580373; x=1729185173; i=efault@gmx.de;
	bh=3XZLc6SbnrxMvePS8IwMeOaCkl1TG1/tbpce3IB2Yjw=;
	h=X-UI-Sender-Class:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:MIME-Version:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=extP5NzCyPrR7Aq3Q35f+16DdpA16jJNhGX6KCUhl3dd3WnaI2zYckdEQMgEqyb5
	 25hcdy6SVYCKRNgiuFMa3LFjkkBJcz5klzQLNrzvTmU+fzjHusqo97oSme93CmTM9
	 5LFJMD26seeuwjel/xAWmuReHUJMvIcLfJ/7rkZIrVsRJqZL7c17jBWWABG81xqX7
	 WJG6TGe2RKC0jsfcg6coZELuEPh3Ge0yUaAThFHAQHgJ9yRz7Ki5uqEs0RSlr+U2Y
	 0+tIe4fTHVtZ6l8/6DqME1WeXAnp4iPsSY6b0Hg0lgWRd9tKa9sfxou0K7CtyQYMQ
	 YfM5iY+u+GmAcz40iA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from homer.fritz.box ([91.212.106.104]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MEUz4-1tAXJH1QWQ-00BRSQ; Thu, 10
 Oct 2024 19:12:53 +0200
Message-ID: <b8f3638880795a19108c36f72dd53974c10febdb.camel@gmx.de>
Subject: Re: [PATCH 17/24] sched/fair: Implement delayed dequeue
From: Mike Galbraith <efault@gmx.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Peter Zijlstra
 <peterz@infradead.org>, mingo@redhat.com, juri.lelli@redhat.com, 
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, 
 linux-kernel@vger.kernel.org, kprateek.nayak@amd.com,
 wuyun.abel@bytedance.com,  youssefesmat@chromium.org, tglx@linutronix.de,
 kvm@vger.kernel.org
Date: Thu, 10 Oct 2024 19:12:50 +0200
In-Reply-To: <Zwf-cfADFwt0awj3@google.com>
References: <20240727102732.960974693@infradead.org>
	 <20240727105030.226163742@infradead.org>
	 <CGME20240828223802eucas1p16755f4531ed0611dc4871649746ea774@eucas1p1.samsung.com>
	 <5618d029-769a-4690-a581-2df8939f26a9@samsung.com>
	 <ZwdA0sbA2tJA3IKh@google.com>
	 <028501cdd2469a678df3b77c25c3cd9a1b6eff66.camel@gmx.de>
	 <Zwf-cfADFwt0awj3@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Lh+PLmakrtT9C6mk8zDHoj44Uk4OBw6IT7lgwXAe96Li2LAYMTF
 kHQVNStpAjHLCjU7MOcnHsJSyufjiVVwVYcViGBlcKezqBTJx5Gmij4Bo/4Tgg2d1+Kjist
 QKGD0MgUt/rqxnuJ3sFvsC3SNPJSVZjqXDObh5mOj0wdblWZp6B43/CPMtJwY/P/sZP4Fcx
 CIzo3z4Ds+9MQ9GQmtG9g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:HTqKsGqFodg=;W/Mo7/h5QNmc08JUYniAybFrkCU
 L9dqD6AQzVvkanEHG+6sCNVBjlsPO1+YbkAeBFjSUtyueFj/lQRJTSwCRKyqDWQpoPmu0kfRD
 kWrqpbNYo0rlBDgAST1vUrz70W0Ghhs3jsTEp2DcOXGKDLdlXN93wt085zpNWThDh7nAIJIPe
 ErxPqM+5GvKWicQr68Zv4GRI5ra7g05n3ljirKcbqWegOhN8gVMmv2klPHuy+uIi4nD5bQIFK
 NkTeGCL3iRouv2nDzO9/Ns7+/+hbKngY6uehzaheiInX/YWkqk43HnTmXpPxaEU2gMyG+fhMF
 Hbr7m/9r+lbSy/8gzXXscHpFyT8TErxULFp2RR9B4Vxp8BsKRjZb8XLjUzGxn0+XK07A7pBBW
 AZc5eYfqEsrkdk4yUGNkwt7nqHPW+Hr4Y87jyd2etM+1prjQSOj1sbd8vYZqGYJRx7Y8ngZ/n
 JalpHrvGsGy5ZHRwKdwg8jd3Tt9MqwyfHgvL8So3qSiszdCndhEzc9gf0N5rVrjCz+aUTuk5R
 aeglGBzRhF1J8An8Fwi1yvgzNDF4oGEdtJb3U/uEu6xT461gcoFkRKKPdQ57nDxYdulNn8QoC
 R1HSVzAej1ekTL/UpyQOq+YWNPxylmJ5QZi/CoCYTRuPQlf9ye4qLtPytMgMKS96oBh0FY24h
 Yq2UJli5eAnwDEYPev1EJz44j63x72tcUvjW48tIpMyesfg29bti0jk6+SPzUGTrFPnKgca+l
 CZk6p87zxuW6RfShqAKL/kWC7IR5q/oUQyyE6u0teuiDduInd33z/3X8Bbh4E6zjKTLZ5wBEh
 ne5HvZRadMP3DtVTI9KHjMsQ==

On Thu, 2024-10-10 at 09:18 -0700, Sean Christopherson wrote:
> On Thu, Oct 10, 2024, Mike Galbraith wrote:
> > On Wed, 2024-10-09 at 19:49 -0700, Sean Christopherson wrote:
> > >
> > > Any thoughts on how best to handle this?=C2=A0 The below hack-a-fix =
resolves the issue,
> > > but it's obviously not appropriate.=C2=A0 KVM uses vcpu->preempted f=
or more than just
> > > posted interrupts, so KVM needs equivalent functionality to current-=
>on-rq as it
> > > was before this commit.
> > >
> > > @@ -6387,7 +6390,7 @@ static void kvm_sched_out(struct preempt_notif=
ier *pn,
> > > =C2=A0
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 WRITE_ONCE(vcpu->schedule=
d_out, true);
> > > =C2=A0
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (current->on_rq && vcpu->wa=
nts_to_run) {
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (se_runnable(&current->se) =
&& vcpu->wants_to_run) {
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 WRITE_ONCE(vcpu->preempted, true);
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 WRITE_ONCE(vcpu->ready, true);
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >
> > Why is that deemed "obviously not appropriate"?=C2=A0 ->on_rq in and o=
f
> > itself meaning only "on rq" doesn't seem like a bad thing.
>
> Doh, my wording was unclear.=C2=A0 I didn't mean the logic was inappropr=
iate, I meant
> that KVM shouldn't be poking into an internal sched/ helper.

Ah, confusion all better.  (yeah, swiping other's toys is naughty)

	-Mike

