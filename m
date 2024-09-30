Return-Path: <kvm+bounces-27696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37BFA98AA65
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 18:56:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC5292842CD
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 16:56:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3349B194AEF;
	Mon, 30 Sep 2024 16:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SteVKDgc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7675193412
	for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 16:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727715394; cv=none; b=nFpX0+Ely9VB9ZEBtypRn+v3UXUpaIFhy1jDJx31Q3Byxcz4nC94vW34oCQbefV7hyjMfGjecds38GUvWcv366bOXEhVAlNbpe595sI3UUTE3hIZ0XFX7IjQIki5q0Z2RtDhB6nFvD15/seQ+sAYGynd/pI1cV4VE9OxYELQlk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727715394; c=relaxed/simple;
	bh=bmuEUyqk2bT1c3O+xO2sNPpOqDNsTNasFyYcsnwXMAo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MY2P2tfcLYMlWKQMJX8IQYimWC3ipDn+w4g648wtv+iR1m5DMoTuT4uB1yQuL/XWVOtKYkFwyW60G6oAVrkT+2xiPmQTQQF9SKER/RgwtdKDXYpgS8o6/sX3ezwzn9kCrdReieMm/HnBoWn0ZTxqKEC2VCNl/XYnXHdG65kPpZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SteVKDgc; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e2608234531so4651059276.1
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 09:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727715392; x=1728320192; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bmuEUyqk2bT1c3O+xO2sNPpOqDNsTNasFyYcsnwXMAo=;
        b=SteVKDgc4uqeIQW9aTFTUWbIU6JfB+PItmEUiuqHqPA4Ey2K2rZRC/OjKvoEcC2OZG
         XyHia6vx/s0yDj5gNTQth0RuJT+Uzx5WLRH4hzq9LiY90sKDMU7ynP9Bly7pv/AJCVCD
         hKaX0jXk1NTcpooWAMfaU00LstQwU9esg6MO/e9Bkb2afeuNSvNkVLowG+6fFzA7sV+X
         Qzo9rYAoZVIGLRaTGwZEzt2E90qrgzrsDs+aasGkxXiwlCFswWvygUAzNOy2uQCLdgmJ
         Y8CanrcWug44CUXq1cE/N/6HzevU+F5YvS9vNNFwac7BKdpNZ1miLWVpSrVWedf34oQu
         yi5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727715392; x=1728320192;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bmuEUyqk2bT1c3O+xO2sNPpOqDNsTNasFyYcsnwXMAo=;
        b=bUPuTPubOl1W+2zv+N/eLQUSGbqxW2HFcce0ElaUwsgx67XzFVBJoyZ6LBrJlmL2WJ
         OiqmgcnGICTe8qqztc21QuEdHPyClpsb8lWL6Bxatf6uqurTITYfk7gL5W98v5EPNt0q
         8e8pfonNWPw5FNiU4TsZgXD4CNprS21/2Asibb5KzTDbD2mzL0/3BxByHEPSg2cJBthj
         y7GtQWMenRwuExESJ693HszXXHBG6ZTBT0oG4f8HhWsCHBunc9lbEGQ59G7rU2gW3ArV
         VcUnfr2gEIoB2Oe35I/ztvjwuWnD4PkMENkKMemNVlyxVO0MGwQI4GVksgAX7wVq9m2T
         gwVA==
X-Forwarded-Encrypted: i=1; AJvYcCUYOTSnD3JxtuQAtKtPms1a19tCgtBbsQ+9xnlQo3cgM6tHshPuQFG7hoO89fsIB3Wz7UU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBWP08CDwkXV9I/BgEo1HGC/gc7xn93GXK6sIwaUhpVWBC2GkS
	jL84vmSl4SjckOKuKQDEfVfEFU5QI2YWqpU+DjojZz/oSZMxiXVKT5zR+fmBAOXr2DKEF9Y/uuJ
	lHw==
X-Google-Smtp-Source: AGHT+IEC5NPofYVzP+Wzs2dXMq4oR3r2G7SGyWOX8ZxrYfWVkpnj7bsqqKMZB753besVJFViOSuQTmArTz8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2e4d:0:b0:e16:4d66:982e with SMTP id
 3f1490d57ef6-e2604b436d5mr59541276.5.1727715391824; Mon, 30 Sep 2024 09:56:31
 -0700 (PDT)
Date: Mon, 30 Sep 2024 09:56:26 -0700
In-Reply-To: <208429ae-d9c5-4b73-86ff-a9b31e68f7eb@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240207172646.3981-1-xin3.li@intel.com> <20240207172646.3981-8-xin3.li@intel.com>
 <ZiJzFsoHR41Sd8lE@chao-email> <ZmoT0jaX_3Ww3Uzu@google.com>
 <feefa9d1-f266-414f-bb7b-b770ef0d8ec6@zytor.com> <ZuNJlzXntREQVb3n@google.com>
 <d65e62d2-ca64-4b29-8656-bb8411fe837d@zytor.com> <ZvQaNRhrsSJTYji3@google.com>
 <496a337d-a20d-4122-93a9-1520779c6d2d@zytor.com> <208429ae-d9c5-4b73-86ff-a9b31e68f7eb@zytor.com>
Message-ID: <ZvrYOj0Nn9m8VIWV@google.com>
Subject: Re: [PATCH v2 07/25] KVM: VMX: Set intercept for FRED MSRs
From: Sean Christopherson <seanjc@google.com>
To: Xin Li <xin@zytor.com>
Cc: Chao Gao <chao.gao@intel.com>, Xin Li <xin3.li@intel.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, shuah@kernel.org, 
	vkuznets@redhat.com, peterz@infradead.org, ravi.v.shankar@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 27, 2024, Xin Li wrote:
> > > > When FRED is advertised to a guest, KVM should allow FRED SSP MSRs
> > > > accesses through disabling FRED SSP MSRs interception no matter whe=
ther
> > > > supervisor shadow stacks are enabled or not.
> > >=20
> > > KVM doesn't necessarily need to disabling MSR interception, e.g. if
> > > the expectation
> > > is that the guest will rarely/never access the MSRs when CET is
> > > unsupported, then
> > > we're likely better off going with a trap-and-emulate model.=C2=A0 KV=
M
> > > needs to emulate
> > > RDMSR and WRMSR no matter what, e.g. in case the guest triggers a
> > > WRMSR when KVM
> > > is emulating, and so that userspace can get/set MSR values.
> > >=20
> > > And this means that yes, FRED virtualization needs to land after CET
> > > virtualization,
> > > otherwise managing the conflicts/dependencies will be a nightmare.
> > >=20
>=20
> I still plan to send another iteration of the FRED patch set for review,
> however I haven't seen your x86 KVM changes land into Linus' tree, it
> will happen soon, right?

Yep, we squeaked into rc1, the pull request to Linus was delayed because of
travel and conferences.

