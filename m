Return-Path: <kvm+bounces-23153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33F039464AC
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 22:52:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 871CFB22723
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:52:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2CA1757EA;
	Fri,  2 Aug 2024 20:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dG87xNtM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7C23EA98
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 20:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722631894; cv=none; b=U2EaNZvypJCLoG37b6FMKhyAgaYEUPAIAxpNAchlFGZWRzWV33oyUkRFlBF5HaE/qazUwsuh3u50FeidPRejUNYSH/7a7K+w7de1P1lx7TijO5NBWQcN7NxysuOpWs+MYDE31z6NHO+2QNgSZPmKciw6D4iiJg5Ok5c9kTU6DfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722631894; c=relaxed/simple;
	bh=FueBNgDDCfYI2k+0y4y+ZR1Vsa5mvu9gB1exHHHan94=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GgHuq/pOmUlywsb23OfBZr+1fDFaGChvcywYVwZ3yZ+4rxWO+ZAD4A/vdNLCnu26o6WvED0GtYDgAZYW1OT9ed2bwJG/qm6CBxr4YNLIDecj6lIJqOKSCXlQpvitb1AYNW5/IgjjZkTm/Y5pQCqeotqwttS1cOLqYwrKYedNALQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dG87xNtM; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7104d2cac39so3452886b3a.1
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 13:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722631892; x=1723236692; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tXkYm8GWgU7Uugm4gxQOf+EOoFr0lG6UD/VJhjiOPnM=;
        b=dG87xNtM3VLx+c+QMuryFY30aJ15tBOPtpwpo4+bhEVpRyCtFI1Jv1f0bzykPJgg/I
         NIPJN320Ukuzi9yfoo9cihjcJRcQmFRax0ffjpd0PTfRmz08j0xo1l7F3bWExgqL6NrI
         l28oPFyBQKv8CeYtx1yyJn1wxwc8ow8LwVmmRiDGT/lL7iY4VwuhwOpY2HRSsLIIpJrY
         OkrMb6rKV7xqVed8I9BzWwzsELuG/R0Yxk8fAzdRLrwRzjFzqAZJ9FBCj0D6EtrqX98E
         bn82vqF9DFHewXlIWHPceyCzIUu1r0/Pzyo+qcmlsUuT8aII1R/nHX3kmVTWXT7q2R21
         H9kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722631892; x=1723236692;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tXkYm8GWgU7Uugm4gxQOf+EOoFr0lG6UD/VJhjiOPnM=;
        b=WJI10iQOxj4DxwDKpZwXqKcdBHwPdWf+TbZy/UtWWXL1kTQH6Bvx+HJHcY0z2BWeBD
         qdO1ppf3h7DhTrcaCxR9EfBjC97YrRdjqP4g5wCAcwTA7hLNjyrOXmpmZiSPwMZCeUWL
         lXXCqwx7iEBI7XIvNK4JiYfmQfdw+3ZcwwpCVdjMULstNzG0Xj7g7v9MACowhn7bXZ9z
         N8Q/N7bWdy8GKqE/e/uBTqtj8pfeTA66mPKrEwJ42C+XNZHZnU5NBelTAFNNkO2Lhlen
         HuGESw4lizFMMgmu0n3iGKfC4k1iv02ghMeLNU7Dygtx3OrmbHq3oIOJBnlO8KZoHjEc
         gdeg==
X-Forwarded-Encrypted: i=1; AJvYcCW2qw5HlLO8cHqB9YfPr9+EL3524uuFvc8BKz+njDT1WvK0pSyTEq6k/4XBjN9fUBe+WFZXiKIZkHpGyXWaS5QVmtU2
X-Gm-Message-State: AOJu0YxCws1Gn0p/4F07QqnZbuw61Qjjy9cuE3KstgjFuhLM12IlkTEN
	FbtCGyrIBrRAQMiHhIdcmV65D5JIUUUvBMJET8SRB/k2Q0WysRkQsiIb/1aOJTnC7WiwvtLyFBq
	dYg==
X-Google-Smtp-Source: AGHT+IE1tZi1nsiH0SIgqwEaG7Vb1R0ZlJXHcVhuB6HgEl7rj1NR5a6/czPeOlKS3H+iSO3nwk8SFUENvrM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:6f01:b0:70d:fba:c51c with SMTP id
 d2e1a72fcca58-7106d071bd2mr16631b3a.3.1722631891698; Fri, 02 Aug 2024
 13:51:31 -0700 (PDT)
Date: Fri, 2 Aug 2024 13:51:30 -0700
In-Reply-To: <CABayD+dHLXwQK3YdwVi6raf+CF3XOaAiAG+tfDYPiZFzqeVXpQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802200136.329973-1-seanjc@google.com> <20240802200136.329973-3-seanjc@google.com>
 <CABayD+dHLXwQK3YdwVi6raf+CF3XOaAiAG+tfDYPiZFzqeVXpQ@mail.gmail.com>
Message-ID: <Zq1G0n-b8_C6DFp7@google.com>
Subject: Re: [PATCH 2/2] KVM: Protect vCPU's "last run PID" with rwlock, not RCU
From: Sean Christopherson <seanjc@google.com>
To: Steve Rutherford <srutherford@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 02, 2024, Steve Rutherford wrote:
> On Fri, Aug 2, 2024 at 1:01=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> > @@ -4178,9 +4181,9 @@ static int vcpu_get_pid(void *data, u64 *val)
> >  {
> >         struct kvm_vcpu *vcpu =3D data;
> >
> > -       rcu_read_lock();
> > -       *val =3D pid_nr(rcu_dereference(vcpu->pid));
> > -       rcu_read_unlock();
> > +       read_lock(&vcpu->pid_lock);
> > +       *val =3D pid_nr(vcpu->pid);
> > +       read_unlock(&vcpu->pid_lock);
> >         return 0;
> >  }
> >
> > @@ -4466,7 +4469,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
> >                 r =3D -EINVAL;
> >                 if (arg)
> >                         goto out;
> > -               oldpid =3D rcu_access_pointer(vcpu->pid);
> > +               oldpid =3D vcpu->pid;
>=20
> Overall this patch looks correct, but this spot took me a moment, and
> I want to confirm. This skips the reader lock since writing only
> happens just below, under the vcpu lock, and we've already taken that
> lock?

Yep, exactly.

