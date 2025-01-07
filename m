Return-Path: <kvm+bounces-34678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D64FA041A7
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 15:08:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4534E7A2634
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 14:07:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D2CD1F8ADA;
	Tue,  7 Jan 2025 14:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LKUWDobZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0051F8AD5
	for <kvm@vger.kernel.org>; Tue,  7 Jan 2025 14:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736258575; cv=none; b=AXqpPeHKIxMA4dCENIWVViW2NwrrMeuJH4nCq6ifNbWmjgl7mImMUyBrZcPVYM5L1/tq4HmzqZg60z9HdwMheNiqBoBP3ObuGXw6veBUGNBA00mftK2lSIK05PEpth7LQyK+HY6RnApskEuv2HxQqa9o+uwHdd9Rf//EvM+oRfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736258575; c=relaxed/simple;
	bh=RTe1yhE1HiEX1HnPmbg12CaehcdsA2Ke4+utEMIqDaw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lS2dwdgj9TrYJXAYT/xU7F5f5SRUUvLM/yqfnmjp61ropCYyZDNrqzWf6Cv11Gj6usT7l0z6vivtHQ/+yXNCpIq19OmQHzMxXVQDGuVtt+UWCoANs2Z57mZ/rl+rWKph1e9rmELRpGNnWM0oJIlKpYhHBKKPBoK/bq79m7BoJb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LKUWDobZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736258566;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pMdUTD10Jj44OKCzUByVXOqxSHx5T1GS8JkjtREvkN4=;
	b=LKUWDobZ8hN1dlw/MbwIjqB3Tl8kaNOrPGz+YOioSj5an7oIo0HxR7YjXAUf3jyh9HasFx
	BsXSDrlWKHRlY3pW6oIlKkWsVHMC+PLef7BXAJf9wSSJGUMUgDiHo2r/zjpvdQRIUhB+Cj
	UnLDJ/V8UAqAgVhiXhCwdfPwK3fdJ7s=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-166-FKud0QHkPR2uPj9eigC73A-1; Tue, 07 Jan 2025 09:02:44 -0500
X-MC-Unique: FKud0QHkPR2uPj9eigC73A-1
X-Mimecast-MFC-AGG-ID: FKud0QHkPR2uPj9eigC73A
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-385e2579507so6867848f8f.1
        for <kvm@vger.kernel.org>; Tue, 07 Jan 2025 06:02:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736258563; x=1736863363;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pMdUTD10Jj44OKCzUByVXOqxSHx5T1GS8JkjtREvkN4=;
        b=S6gwGPEdJh8A8BOKF+3SgGY+YKf68dlK3RfUYSqliMhSp/u29Tw3ltnD04WeWUfyQF
         upvQ4jjLBIJK3X4sjVviGcr6wm3fEcpAkI0u+zIS2mvIegbRc9H9MItvlwQgxDhzVV/l
         OApdnKe3DvZ9JVDJhirey21RZ+1KwwxZOxmQOAj6qoYCuencK9U2KrWZFiZqGDi2681+
         QjEo0d1R7lGo3QMhMUKU+3HF0VymvQnRExJUlg3qLzwRXw3OE1RWLd2Gnt/VAcDkPnEU
         73v4hTyY5qwyyrnewQnZmZR++pZSXH8lqr+Hag/acbqZWJCPaLYGw0ZM3XtptnEYQGK2
         JjEA==
X-Forwarded-Encrypted: i=1; AJvYcCUdvkTVTbkhpezUJwWdSJgMqGx8by03yZmK1qHVzH0ylzeEDNCOIN2n2eBEbNQDPkkiG4Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3OhaFnpcffWM7vuwr4/Lo+8Gw8btLv/GkV8WMZRGCyLZeTW7+
	4GI3hOQfYlxd4+cmseW2+YnaFe5FXBRbDd5JKeHWe0CKhwgrk8sb6MF7mJhpBFSAv6BgT8TwtKu
	NMGPyrAchnKPXptT0Pr2WoPwtjpc8Kitdnc/83HdK2wC3BdF4MJXAQAA2MqWxFHpBpjvFe5IZTf
	JvBs+3KBfGWjpT7r5gBvsxU6n6
X-Gm-Gg: ASbGnctg9IeuwpHZPqjm2IKde1eg3K3BIoufeRz+dt0WGSyLwUBuJ4WoSv+400Fsw6c
	NS+sLKQe+CkbNcf9R88egVRNfIwayqQLfTcep7Q==
X-Received: by 2002:a05:6000:4913:b0:385:f1f2:13ee with SMTP id ffacd0b85a97d-38a223f71bamr51147907f8f.46.1736258561799;
        Tue, 07 Jan 2025 06:02:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGhTvIbckb7ENCT3GbMpMRuEadGJaJWUmdffjN6JeDY30Q9nuiOI31sPoDTdKwi/tVSJ7IiOjAfS95+pi1hezo=
X-Received: by 2002:a05:6000:4913:b0:385:f1f2:13ee with SMTP id
 ffacd0b85a97d-38a223f71bamr51147848f8f.46.1736258561213; Tue, 07 Jan 2025
 06:02:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241112073327.21979-1-yan.y.zhao@intel.com> <20241112073848.22298-1-yan.y.zhao@intel.com>
 <fdcab98a-82d3-44fe-8f4b-0b47e2be5b7e@redhat.com> <Z3zbRYnyUmVWvxFO@yzhao56-desk.sh.intel.com>
In-Reply-To: <Z3zbRYnyUmVWvxFO@yzhao56-desk.sh.intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 7 Jan 2025 15:02:28 +0100
Message-ID: <CABgObfZMR5y7T_dv-V8ng0dv=L00XgUmaDm-V9Y1aVEuz=0anw@mail.gmail.com>
Subject: Re: [PATCH v2 22/24] KVM: TDX: Finalize VM initialization
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: seanjc@google.com, kvm@vger.kernel.org, dave.hansen@linux.intel.com, 
	rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com, 
	reinette.chatre@intel.com, xiaoyao.li@intel.com, tony.lindgren@intel.com, 
	binbin.wu@linux.intel.com, dmatlack@google.com, isaku.yamahata@intel.com, 
	isaku.yamahata@gmail.com, nik.borisov@suse.com, linux-kernel@vger.kernel.org, 
	x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 7, 2025 at 8:45=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com> wrot=
e:
> > @@ -1715,8 +1715,8 @@ static int tdx_gmem_post_populate(struct kvm *kvm=
, gfn_t gfn, kvm_pfn_t pfn,
> >               goto out;
> >       }
> > -     WARN_ON_ONCE(!atomic64_read(&kvm_tdx->nr_premapped));
> > -     atomic64_dec(&kvm_tdx->nr_premapped);
> > +     if (!WARN_ON_ONCE(!atomic64_read(&kvm_tdx->nr_premapped)))
> > +             atomic64_dec(&kvm_tdx->nr_premapped);
> One concern here.
> If tdx_gmem_post_populate() is called when kvm_tdx->nr_premapped is 0, it=
 will
> trigger the WARN_ON here, indicating that something has gone wrong.
> Should KVM refuse to start the TD in this case?
>
> If we don't decrease kvm_tdx->nr_premapped in that case, it will remain 0=
,
> allowing it to pass the check in tdx_td_finalize().

Let's make it a KVM_BUG_ON then.

Paolo


