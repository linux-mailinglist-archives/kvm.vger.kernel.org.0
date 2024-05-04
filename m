Return-Path: <kvm+bounces-16558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D83D88BB90F
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 03:10:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90F00284928
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 01:10:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9150017F0;
	Sat,  4 May 2024 01:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xmax+py6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E9A803
	for <kvm@vger.kernel.org>; Sat,  4 May 2024 01:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714785043; cv=none; b=B1+HJ3oXyDFCwljRPEk4HOtJ25kUH+RY8nB9EU48uJVF4TM9roBHA40LdsEwtS27PW8DambPYuOdOGPMYC3W8Vb+RieUCSNQnNlwoxPLp1pJXXWsIioqlk44zhGqHd9V0k04zBXbGawHOm+dmuzjKrxcmHHWY29E8gqC/7Jr93g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714785043; c=relaxed/simple;
	bh=5j15pv+yrGZxzoFQ7805vjKNBspZb0b8yz0WVYzwRsQ=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=RmQMUpajMxQJefocR2gW8ZXggqP5Tzu5iMTS08ceqTuPTz7tl8z5tS0ijvS9mdmEK9qwe/oqo0ehNuFPKHjykGHMXh0SolzJYf/kFmt9Bs5xbdxH50KQphJbuL1bqHlnZHkq8qfZv3D3JqSJE56t3NXKASEgf8XMqVgW74gNb20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xmax+py6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714785040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5j15pv+yrGZxzoFQ7805vjKNBspZb0b8yz0WVYzwRsQ=;
	b=Xmax+py6TZ+dLcSj7X+yNRLWKB3R7L0ZRI67FGBKf9ctSuvV0Py1RJkXATvaknZImY/v4z
	p++AHJRBuugF3N3/xAELkIchSEH1QSb5C/Hshyac7rvv5WlIe9L/jLzNf0OJb1zksZ/W7L
	cyhxVgs63oK8KTEk3y9vg1W+B7L2qxs=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-322-DH0CBq-PNISMYWWlwsvmtA-1; Fri, 03 May 2024 21:10:38 -0400
X-MC-Unique: DH0CBq-PNISMYWWlwsvmtA-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2e2035036f5so2207661fa.0
        for <kvm@vger.kernel.org>; Fri, 03 May 2024 18:10:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714785037; x=1715389837;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5j15pv+yrGZxzoFQ7805vjKNBspZb0b8yz0WVYzwRsQ=;
        b=fbdm+o5lCRG93o7yobTfAuJFxOkvEDOQUlkWDpcP/9WZkzoGoPo4YxKiFoZ/YN20Cg
         9I0+y+XNcilFVzZm1TeVcYa546/NWp6FsiRBDIDsY64HHoaJzWH0aSrx1HH92UQ7erBT
         GIql8DVFoYiccsBOXtUPXgvpBIgUJA94yEopO43mQ3/cW+CBjqSLBAnapP49N4PIg5n7
         xe24hV/C1w6n5QsZhO0o+XSPwrlKHUsJfWLDh7AZRqkKH3zEA7BG0+Mfw9ss9LZDO9m7
         geUconRGnAL3LYjVxJDL/dD5TizJCVjJ+mJqlYP+Ln4dQvcbyqtwV7VZPl9y5G3Mm5aU
         dIdw==
X-Gm-Message-State: AOJu0Yzdl/hh2M9HTg87houWYBneJ7iZcC5lRMlP5GNSfI8B+2OVN7/K
	xNLa7XRbs+n/Psn7AkD7RDRsUbi4ao/9kcNeC1WQNKQ5Bs9qN8KLWtYGKUsN+usAdl9zh0VAiMJ
	GXk3oyNtJm/0AY2pjpyYkGMEJf7gi7gFhG1lXgbp/yK1Y5qIB8w==
X-Received: by 2002:a2e:9ad7:0:b0:2e0:b713:6bb3 with SMTP id p23-20020a2e9ad7000000b002e0b7136bb3mr4284486ljj.8.1714785037440;
        Fri, 03 May 2024 18:10:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEr79L85iSn4mJxJvI3pNeWzN2d/P9lDGaQQNo1PN79AXRL4vlwHDJwAzOFSuYJsvYnLxbtVQ==
X-Received: by 2002:a2e:9ad7:0:b0:2e0:b713:6bb3 with SMTP id p23-20020a2e9ad7000000b002e0b7136bb3mr4284470ljj.8.1714785036983;
        Fri, 03 May 2024 18:10:36 -0700 (PDT)
Received: from [127.0.0.1] ([151.95.155.52])
        by smtp.gmail.com with ESMTPSA id o5-20020aa7c7c5000000b00572c25023b1sm2330239eds.0.2024.05.03.18.10.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 May 2024 18:10:36 -0700 (PDT)
Date: Sat, 04 May 2024 03:10:33 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
To: Sean Christopherson <seanjc@google.com>,
 James Morris <jamorris@linux.microsoft.com>
CC: kvm@vger.kernel.org, Thara Gopinath <tgopinath@linux.microsoft.com>,
 mic@digikod.net
Subject: Re: 2024 HEKI discussion: LPC microconf / KVM Forum?
User-Agent: K-9 Mail for Android
In-Reply-To: <ZjV0vXZJJ2_2p8gz@google.com>
References: <3564836-aa87-76d5-88d5-50269137f1@linux.microsoft.com> <ZjV0vXZJJ2_2p8gz@google.com>
Message-ID: <F301C3DE-2248-4E73-B694-07DC4FB6AE80@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable



Il 4 maggio 2024 01:35:25 CEST, Sean Christopherson <seanjc@google=2Ecom> =
ha scritto:
>The most contentious aspects of HEKI are the guest changes, not the KVM c=
hanges=2E
>The KVM uAPI and guest ABI will require some discussion, but I don't anti=
cipate
>those being truly hard problems to solve=2E

I am not sure I agree=2E=2E=2E The problem with HEKI as of last November w=
as that it's not clear what it protects against=2E What's the attack and ho=
w it's prevented=2E Pinning CR0/CR4 bits is fine and okay it helps for SMEP=
/SMAP/WP, but it's not the interesting part=2E

For example, it is nice to store all the kernel text in memory that is not=
 writable except during module loading and patching, but it doesn't add muc=
h to the security of the system if writability is just a hypercall away=2E =
So for example you could map the module loading and patching code so that i=
t has access to read-only data (enforced by the hypervisor system-wide) but=
 on the other hand can write to the kernel text=2E

So a potential API could be:=20
- a hypercall to register a key to be used for future authentication
- a hypercall to copy something to that region of memory only if the data =
passes some HMAC or signature algorithm
- introduce a VTL-like mechanism for permissions on a region of memory, e=
=2Eg=2E: memory that is never writable except from more privileged code (ke=
rnel text), memory that is never writable except through a hypercall=2E

And that is not necessarily a good idea or even something implementable :)=
 but at least it has an attack model and a strategy to prevent it=20

Otherwise the alternative would be to use VTLs for Linux and adopt a simil=
ar API in KVM=2E That is more generic, but it is probably even more controv=
ersial for guest side changes and therefore it needs even more a clear just=
ification of the attack model and how it's mitigated=2E

Paolo=20

> And if you really want to get HEKI
>moving, I would advise you not wait until September to hash out the KVM s=
ide of
>things, e=2Eg=2E I'd be more than happy to talk about HEKI in a PUCK[3] s=
ession=2E
Paolo


