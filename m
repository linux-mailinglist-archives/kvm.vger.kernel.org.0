Return-Path: <kvm+bounces-55986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D1BAB38FAA
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 02:16:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 094FB7C1768
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 00:16:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EF4F15667D;
	Thu, 28 Aug 2025 00:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xGKBFOaE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E63A35979
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 00:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756340198; cv=none; b=mxEAx+5QD8RusKsnj2D51n4szUR+OTdPldwKmP5KvOjaTSq0FQSUW0xLsbkGyx0pCoGE/jPzpQbi2PFnIKSn9qAmmxpsIYH5STSujszdllzKmHZtvmQlngSKGBZ6Il+DVbqdOC1Bbce4xe3x32rT3DQIjhq4j+ElDQZxw37SVKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756340198; c=relaxed/simple;
	bh=DRQULrR+FB4VYruNOuA3H9WZd2yskdckg89UGJxtXNI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YYvVlvlw7VqVmaJXTdluH7Qw9h0RNAcdpyftTGAsaxtwGHo2ip6ECYuBwTBSDg/7aGwmKmXj3tpOhUjh8NldKJRClDLwMgeC+vJ/iywPHmuFCAxeTx3vOGe9m3H7TrQkg/K5LwfiYMssHTqiIQmC4Ga2pwwYFBvFUJTSpE/cbiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xGKBFOaE; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2461c537540so4778095ad.0
        for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 17:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756340197; x=1756944997; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gN/JTBUQGojSDyUMvLZLw43SnOlQ5Fr1I8L6kd4ekdw=;
        b=xGKBFOaErHGPI+jd+8sUXO1g/7PTjCoW7j/fS9gLGoC+YZZdPCq9apo7Fv9m+v1DAT
         z8p+6OOqXY5mpiEjO0neHwD4vWQiKKxDIt3omaj4wF0NA493KLmDYKJJDDid/69m7CxH
         e4gwk6vm6PrZG0T7cp40skGw9ah9KIhQrPLKeb51jX4o3r/R/WbDO4L6rzhVMNN17p/H
         1ERDLGiprqX6k9FmWJKM6x81CGdo7WuBsDEip4OAkDqeXH2UrihYUV0WVxLyD0yH1Y9X
         LaIb5AJAQtw33HyxbBIoJdXwmPFTUnxw72MrEsijSlsAwq8oCioLRUi4UITAOsMP2f1E
         EuSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756340197; x=1756944997;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gN/JTBUQGojSDyUMvLZLw43SnOlQ5Fr1I8L6kd4ekdw=;
        b=SCQG2cIAJYloSKXr3l05DfmYWBeatAe1/CSMXarB0T9gKnd19+iFAN4bjUwWSjEC+g
         zoXgQAFR9bTXAuSolQNJ+irK8DArGQ8iEPf5BQkRfRS4NPPsgvc/hzLd+dGJirVglk21
         OKwNLqHW1fuTlbGQ6FcYKWAJDznlUOwd/EmZRzTLNXXpy03Ap/Hkz1ZtBWLGuwwnv2HE
         FsKADe0nwIcShfqTFZFaLBijteaYOoKSY1XeMmkvB7PtC+QKuW5zPZgm3hbDwJurdCuW
         S5JIMRs3643cSUiwGaxSZMUNtsKSS8U0CRL1XDTOwQELRahfAZSZOmevCQZo4jErISE/
         fVAA==
X-Forwarded-Encrypted: i=1; AJvYcCUrJzMFyEYKDCXDMZWqo2BZqOwhfwhEWwNj86yRpCBiYgInsQd2SWqdxIfUp1KShlzxCV0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxe9QfUBfjqZpzgm6xv/TNpc7FHu1zqUEEQ/If+XriypNSxwZ3q
	FnTVOjhEzr2X7RaRfqCv4Xh3rwNXn5Q1mh93tpP8ac+pQ/5fL7n4MtDR932+khrONoau8b+jbqD
	y9LFEFw==
X-Google-Smtp-Source: AGHT+IEeaZ+vZ1azz2+/JevayRHNowIgRsI1vZgWUZcfRT1k7jmZ4DcsJTv92NsfT4neFY+yGzMEa3j4/Ro=
X-Received: from pjxx6.prod.google.com ([2002:a17:90b:58c6:b0:324:ed49:6c92])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:94e:b0:246:ae6e:e5db
 with SMTP id d9443c01a7336-246ae6ee847mr198532435ad.42.1756340196775; Wed, 27
 Aug 2025 17:16:36 -0700 (PDT)
Date: Wed, 27 Aug 2025 17:16:35 -0700
In-Reply-To: <20250827201059.EmmdDFB_@linutronix.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250827194107.4142164-1-seanjc@google.com> <20250827201059.EmmdDFB_@linutronix.de>
Message-ID: <aK-f45qszH2VEzV7@google.com>
Subject: Re: [PATCH v2 0/3] vhost_task: Fix a bug where KVM wakes an exited task
From: Sean Christopherson <seanjc@google.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 27, 2025, Sebastian Andrzej Siewior wrote:
> On 2025-08-27 12:41:04 [-0700], Sean Christopherson wrote:
> > Michael,
>=20
> Sean,
>=20
> would the bellow work by chance? It is a quick shot but it looks
> symmetrical=E2=80=A6

Gah, sorry, I flagged your earlier mail and then forgot to circle back to i=
t
(for whatever reason, I didn't entirely grok what you were suggesting).

> diff --git a/kernel/vhost_task.c b/kernel/vhost_task.c
> index bc738fa90c1d6..27107dcc1cbfe 100644
> --- a/kernel/vhost_task.c
> +++ b/kernel/vhost_task.c
> @@ -100,6 +100,7 @@ void vhost_task_stop(struct vhost_task *vtsk)
>  	 * freeing it below.
>  	 */
>  	wait_for_completion(&vtsk->exited);
> +	put_task_struct(vtsk->task);
>  	kfree(vtsk);
>  }
>  EXPORT_SYMBOL_GPL(vhost_task_stop);
> @@ -148,7 +149,7 @@ struct vhost_task *vhost_task_create(bool (*fn)(void =
*),
>  		return ERR_CAST(tsk);
>  	}
> =20
> -	vtsk->task =3D tsk;
> +	vtsk->task =3D get_task_struct(tsk);
>  	return vtsk;
>  }
>  EXPORT_SYMBOL_GPL(vhost_task_create);

Nice!  This fixes things too.  Either solution works for me.  Or maybe do b=
oth?
Attempting to wake a task that vhost_task knows has exited (is exiting?) is=
 a
bit gross, but even with that hardening, guarding against UAF is very nice =
to
have too.

Tested-by: Sean Christopherson <seanjc@google.com>

