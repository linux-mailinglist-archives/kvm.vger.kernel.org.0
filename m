Return-Path: <kvm+bounces-23402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F205394956F
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 18:21:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AFE392828C2
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 16:21:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56F853EA64;
	Tue,  6 Aug 2024 16:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TiKAs2Gz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1442D057
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 16:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722961303; cv=none; b=QCM/XQPDQCJcaTxhLlhvkrekAQocumRsFNe9R6hxFaXwc95ynxKccIREPJv1hp5wINq/3HqhnZqgUjHGbWc91PlKf3KigHQhQe4aWxSaoTx4SnnP8QYu/cBC/Tjj0SNga9hPWYWWd702fE7Mi6AU+pyEEc3ZuEzsCHlE1tHTAYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722961303; c=relaxed/simple;
	bh=MiXXafwse1Ho0ogWmbf243gxNuNXsRyUhzg/zHyNTAo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A+ZoziWMPguiEeFrEMt4tyWdT2zmYViaHgBgHYn8p0vJe8dflszm63+H2fKy1OLLASTUSXhRRj04Xsp9gM6/Km1Yh+qmFX+gwu77mEEGgwJVlr2PxZVsSEX/G/3Bgw67U2L/6idI+bJL99pp6SxwElsTR95f3c8ttLE2UrncYlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TiKAs2Gz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722961301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2FeBeGVvfW8PBlHksAEroqOcnOyuOxAZ4FSuVaz9/So=;
	b=TiKAs2GzkGsgoj3/B7e1p0B+OlKwDlvM3ysrlG/A7ha88D+yXcBa4DFw/GIZTh3iz3VuwS
	CqSIE2X7wqfK2Psc6NVphDA0qHlbTdkBuYpa5SExmZlSr8NmPyUK1UcUB96Z0BCHj62mTl
	qz8epYDq1QOYKjmO9gWB5gUYTrE6yPI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-678-rfTdGN_iNF2o7VAyellsjw-1; Tue, 06 Aug 2024 12:21:39 -0400
X-MC-Unique: rfTdGN_iNF2o7VAyellsjw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-42671a6fb9dso4902685e9.3
        for <kvm@vger.kernel.org>; Tue, 06 Aug 2024 09:21:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722961298; x=1723566098;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2FeBeGVvfW8PBlHksAEroqOcnOyuOxAZ4FSuVaz9/So=;
        b=WT8KuFjryTTZZzLuJJkH0hNxy8DL9qGETM/Fqka1nC3Ejw7aUv/9GfgQXltli9RkPu
         61tO3yCEAt8pYmhiY/IgVK/HY7845WG85EX6DZuUU357wKvfNUTTJw1iwWHeiMbXyJGH
         1SeHB0Sp/hhR+25XANUO0zNKqC3JodlQ2wRxhZbCxsHa/R21L14+yJ3mnCnIp/B/TP13
         f2iA12y05jdwdvkhlxC0/TzxzzhhjtN7re1SII0WPlOSIsD967gcRHDl20Q35bfYCsEZ
         +wzhtPSKGBq33yiGONLpFNvwGsAuBzl6GokrZGQMSEQX8d2JQh8hW5KitNwTxuLfe0Km
         /Q7A==
X-Forwarded-Encrypted: i=1; AJvYcCWgBhMjKqboqKE2kF806JWSjNtuJVUkiYR3DabhrT3lNiny1ubR1gdtoKIZ0D1QRvJJBl20jrWI9FU+DTY1WMOi/0Zw
X-Gm-Message-State: AOJu0YwvKdJdIOYn6PHD53e9NHc1Awh8qyQTHLY6ouQXF4YcBKHHkmMe
	a3UhWF3DxV0BhDyDmSEEylNrFYRNyqKy1FVy4dPGozeJQVzfna1iPw8xkOAWp4cVH1BlLODxmpL
	3F2Ka5xOYBdMUV3rDuUg2BaYQkPFgn1SFPQD/kLFQuy3wkmKM3JSMytdxjxLUs8RZtAmBMpTV1N
	W/Nh15OOx9t4escUSIPi4qIWg1
X-Received: by 2002:a05:600c:1546:b0:428:141b:ddfc with SMTP id 5b1f17b1804b1-428e6b9380emr105540645e9.31.1722961298536;
        Tue, 06 Aug 2024 09:21:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGU1q3RMsranuxYkdZFpDwHO0qfjlEH0Ad/+UdEwGzzyeZWLt3wvbDG2XrLGZK5hSgx/PGnMZDLcktFLi9HY78=
X-Received: by 2002:a05:600c:1546:b0:428:141b:ddfc with SMTP id
 5b1f17b1804b1-428e6b9380emr105540345e9.31.1722961298087; Tue, 06 Aug 2024
 09:21:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240806053701.138337-1-eiichi.tsukata@nutanix.com> <ZrJJPwX-1YjichNB@google.com>
In-Reply-To: <ZrJJPwX-1YjichNB@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 6 Aug 2024 18:21:25 +0200
Message-ID: <CABgObfZQsCVYO5v47p=X0CoHQCYnAfgpyYR=3PTwv7BWhdm5vw@mail.gmail.com>
Subject: Re: [RFC PATCH] KVM: x86: hyper-v: Inhibit APICv with VP Assist on SPR/EMR
To: Sean Christopherson <seanjc@google.com>
Cc: Eiichi Tsukata <eiichi.tsukata@nutanix.com>, chao.gao@intel.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, vkuznets@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, jon@nutanix.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 6, 2024 at 6:03=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
> > As is noted in [1], this issue is considered to be a microcode issue
> > specific to SPR/EMR.
>
> I don't think we can claim that without a more explicit statement from In=
tel.
> And I would really like Intel to clarify exactly what is going on, so tha=
t (a)
> it can be properly documented and (b) we can implement a precise, targete=
d
> workaround in KVM.

It is not even clear to me why this patch has any effect at all,
because PV EOI and APICv don't work together anyway: PV EOI requires
apic->highest_isr_cache =3D=3D -1 (see apic_sync_pv_eoi_to_guest()) but
the cache is only set without APICv (see apic_set_isr()).  Therefore,
PV EOI should be basically a no-op with APICv in use.

Second, there should be no need to disable APICv: as long as
kvm_lapic_set_pv_eoi() is not called, the VP assist page can be
enabled but PV EOI never triggered.  That should be tested and, if it
doesn't work, that's even more proof that we don't know what's going
on.

Also note that the PV EOI mechanism exists in the same way with KVM
paravirtualization, even without Hyper-V enabled, and should trigger
the same microcode issue.  The only difference is that Windows does
not know about it and, it seems, the issue does not trigger with
Linux.

Paolo


> Chao?
>
> > Disable APICv when guest tries to enable VP Assist page only when it's
> > running on those problematic CPU models.
> >
> > Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D218267 [1]
> > Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
> > ---
>


