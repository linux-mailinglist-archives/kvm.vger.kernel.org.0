Return-Path: <kvm+bounces-28461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DD8C0998D17
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:19:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79503284544
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 16:19:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFEC71CDFBD;
	Thu, 10 Oct 2024 16:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kWWCbLRu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94CC1C2DA1
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 16:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728577141; cv=none; b=HNUAOeumDiJPnn3ufXSDAIdSmEmHhVDzMNmRilR5L/aWlLoZijg3fReF5lfblMKhgixS0bnsJZYRY3XeGnkaFAeY8Bf8RcVIyTdsDUl0vNuEJjBpjXyL7/onJuI6JvW73mfUPR+4kS1ZOhy88uJ166fMBLzAIaeVHAPEBBm3yuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728577141; c=relaxed/simple;
	bh=0taRQhQ9LqfmmG+vQ7qFCD+ZjBUWXq1z8qfHRkn6bZg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c1+snGA6S8w+N7HV5OKc30d63ASXWZK5P0bHwPToYsk6+XPpgRr12zNoX4xl7fNPFNhADCPuTGMotzUcsGRrQieiWzkrMqaAlwYOlciooyhtuGU5y2lMGgbqXme1VSQGGb068k6ObleyvuicRmpEfUW3MiMG2p/bY9KnG+pAmIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kWWCbLRu; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e290222fde4so1204484276.1
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 09:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728577139; x=1729181939; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D6G7OUX8q4BUWDj+3AyCy0cvuvdbRoe5UQJNlr3xoSc=;
        b=kWWCbLRuo7dJPl8n9SJ/OOo8+MMeZAEl0/Q5fd42OGcNy28G4UdvT/MO1WkOIEs9uH
         l0yG6MKSKGLFm4EoKeI/83pfYsqZzKW89DHkP4DsrZsgDoC/+b9s2Z77IGsX4qghrH3t
         0SK7FENveCC0T/5bE6R21o9S7NOMv/Eth+XwrjJYyqnMgcIPiRaJLmPzgWpb5dRwZ413
         rCpxH3QR6U/x3FH06VQ0dr7/+HYnrLuJjRNA5bdihob4cntVkjpTmNQo8QdJuUmLyaOY
         QD+8FRDGOOzuYsg9MSudjY8K8JEt24oQf6E7jRk93Zv/4PZ0jDIC4YtBu+4tAzPXS50C
         cbKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728577139; x=1729181939;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=D6G7OUX8q4BUWDj+3AyCy0cvuvdbRoe5UQJNlr3xoSc=;
        b=XNdyjs/HRctvs3ot3bc8HlWlByiVqyWx3zADeW0BMbquEyo7DfFkEsJVp0JibAsKNo
         FP3Ad1yyJUMmnCJ+VZG+AxXo9aBQRzCemEQyLEjIKmRDZLcs6YvvaNtv5CfLFjW9do9t
         cnr8q30mVbd8G+HHylL4aCNXPxsn6SpKBhSTzdfT07qYUfPI0dJVkt1k5oa3/0hGjr7Q
         /o7LJoUaGqmJ7SrOf29bp9qZ3heDGy+6apkZO7uemCIVeF4v9vW40wpWIyP/BZiV0GJa
         wQOOOTfWoWizc/nqcgVKwFLKuh/IKQim4lYS53no03VfT5RONXaTLVTwRwHffZqF6xCK
         TD3w==
X-Forwarded-Encrypted: i=1; AJvYcCXbbtMKjbkJ/GGGG1epyyG5QDIkX/un+EW6YTOaWV/jqMkJAqH/POhLQ9pjIEYvpHuMfgM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwXTNqBdtMObJKPbCSGnH5E9W2+hFEuRRwpU5+2SqkLvJS6xUJ1
	Idkv1lj0p3sEb8vTVTBn1RkzTUkhT9RiQKwR6MhQjDbQGtwZpkd3XEgSaLn34wY7CNa2pmInZJl
	nYw==
X-Google-Smtp-Source: AGHT+IEs3IpuQOP/zvRG77UWqmGygsitarAq+g3ot9CvViFEmkmJwJvNdEkRmxmn8vkxRVvB44456Fm4Qgg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:d353:0:b0:e28:e74f:4cb with SMTP id
 3f1490d57ef6-e28fe0df614mr95229276.0.1728577138650; Thu, 10 Oct 2024 09:18:58
 -0700 (PDT)
Date: Thu, 10 Oct 2024 09:18:57 -0700
In-Reply-To: <028501cdd2469a678df3b77c25c3cd9a1b6eff66.camel@gmx.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240727102732.960974693@infradead.org> <20240727105030.226163742@infradead.org>
 <CGME20240828223802eucas1p16755f4531ed0611dc4871649746ea774@eucas1p1.samsung.com>
 <5618d029-769a-4690-a581-2df8939f26a9@samsung.com> <ZwdA0sbA2tJA3IKh@google.com>
 <028501cdd2469a678df3b77c25c3cd9a1b6eff66.camel@gmx.de>
Message-ID: <Zwf-cfADFwt0awj3@google.com>
Subject: Re: [PATCH 17/24] sched/fair: Implement delayed dequeue
From: Sean Christopherson <seanjc@google.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com, 
	juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, 
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, 
	linux-kernel@vger.kernel.org, kprateek.nayak@amd.com, 
	wuyun.abel@bytedance.com, youssefesmat@chromium.org, tglx@linutronix.de, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 10, 2024, Mike Galbraith wrote:
> On Wed, 2024-10-09 at 19:49 -0700, Sean Christopherson wrote:
> >
> > Any thoughts on how best to handle this?=C2=A0 The below hack-a-fix res=
olves the issue,
> > but it's obviously not appropriate.=C2=A0 KVM uses vcpu->preempted for =
more than just
> > posted interrupts, so KVM needs equivalent functionality to current->on=
-rq as it
> > was before this commit.
> >
> > @@ -6387,7 +6390,7 @@ static void kvm_sched_out(struct preempt_notifier=
 *pn,
> > =C2=A0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 WRITE_ONCE(vcpu->scheduled_o=
ut, true);
> > =C2=A0
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (current->on_rq && vcpu->wants=
_to_run) {
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (se_runnable(&current->se) && =
vcpu->wants_to_run) {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 WRITE_ONCE(vcpu->preempted, true);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 WRITE_ONCE(vcpu->ready, true);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>=20
> Why is that deemed "obviously not appropriate"?  ->on_rq in and of
> itself meaning only "on rq" doesn't seem like a bad thing.

Doh, my wording was unclear.  I didn't mean the logic was inappropriate, I =
meant
that KVM shouldn't be poking into an internal sched/ helper.

