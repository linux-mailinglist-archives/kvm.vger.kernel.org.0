Return-Path: <kvm+bounces-22331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A38A93D776
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 19:17:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 073A92834FD
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 17:17:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2FF817C7D7;
	Fri, 26 Jul 2024 17:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A9hXAh1r"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B018E11C83
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 17:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722014255; cv=none; b=W0XLYNNUXYpW3u8BVii25ieTDdtGbWfF1qY7+TVT7RKfGjC8yUtjYznyKR1ekTc1ybGOGhI22PIEbyFK4mnYPv36A1zgkv14r2a0Tol3Fe2mKvJ+Pq/Rw2vV2TUeb8KwmmUg/WW83yIQ8i4uZXj3Fkh43QEI3wkwCCJy/D8bz7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722014255; c=relaxed/simple;
	bh=E/YjdKK5bjss9OX+5ucQe4BKWN/mL0wIoUPIY+Awg6A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T4UEIZUwNJgMopR+s2j887ENHn4kY72RnYJKgL9OjkPoJmekmd4Kj1I14zN4OsLZVi9bqaZvG3cN1IVne0wk7v/6CUnhDs+31NRU3MJZo/PyJLK91eEXCt8ZoJXLeoXQER3zFhmFgSc0VEOrfktPyoF0A2Nv14oRp7dXOZGTX8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A9hXAh1r; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722014252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OApdFCzqo5jT5gQz6j/mnTgntG4SRH6PuXi40PJMctc=;
	b=A9hXAh1rx93md+S+Spcw7CZEzwmIRIgu8g//w8YYZk8ridcjpaa7QILmVb8LRM68pMgorp
	QnqkcW2K/El2txnsnI/GO8Vzol6otEr+wNh30CVdJDTq1Yb5CNcoYRcQaioF0522IKsNFB
	gBN1oFwoBYsygixJwR+OVVLxp+YNIKE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-483-h9tT8wyyPG2ANBd8I3_PiQ-1; Fri, 26 Jul 2024 13:17:30 -0400
X-MC-Unique: h9tT8wyyPG2ANBd8I3_PiQ-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-368442fef36so1738468f8f.0
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 10:17:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722014249; x=1722619049;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OApdFCzqo5jT5gQz6j/mnTgntG4SRH6PuXi40PJMctc=;
        b=JhTDdOUQt0/Zl/cxMwdyY6u/HRY4eLazM4GmHp6tTNIUfDllsCdq5wxmgJv4HPwlGj
         xXmd09LkkPmcnJ+VLUomSqNmHggkqvXfAP0e+y5NC0al0ox+dYVVF1OrQa9XUAJR2jER
         EsQhqDaqt0QjZwvT8rkpo/rjfE/esHAXRdXC1YMErp39R+uYKtLCeL+O/Sn5cCpiCXNR
         Ln1qWXG37B31P6x+YChKpa1RPnNgxMcToFA1Sxpq7ReethRfgMRXznAU2M+oEs8ghmfV
         rcJm8Qw1pcej96flWF5mNM+wK8IwzayxmqYc73icA47kpykbWaNekOmnJPdQJCBcUzmn
         cF4w==
X-Forwarded-Encrypted: i=1; AJvYcCU4EnLz/0P3h2NFBBEog78jhCoOWNOsreEeYo69JmK0q+sl1CRnIukCHCgcONfypHjYALOzojHN2pejWrO1qNtUNP3V
X-Gm-Message-State: AOJu0YxB6Gw+g1OhJFsx/eLLpVyiAX++DfcstcsXAkL4SO39ny8xHAzo
	SWC1U9Y/ZQmPbangZmbblUOm8gyJU/tIJPSXjNSe1v8iD7y7unWOFqIugZYOXdoilaRFwMf9Y2c
	iz39Y0HHqZ4YRo/obIa33MoDnDN6VtuIDgThjemHMcEJPORFV/Vgc6MNwLHjlk7h4s+0siInjib
	EykOwXMGEc7eU65+gLvSWnM/8w
X-Received: by 2002:adf:f00c:0:b0:368:7943:8b1f with SMTP id ffacd0b85a97d-36b5d0d0f9dmr299725f8f.43.1722014249598;
        Fri, 26 Jul 2024 10:17:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFd1VNkfisws3kDZNVAAV056jx+FRvLl+xH4R2DpmtBRfzO3QhrpvL1Lk+cyt7pRxN2vcc4zzJXuPT7qynxKRI=
X-Received: by 2002:adf:f00c:0:b0:368:7943:8b1f with SMTP id
 ffacd0b85a97d-36b5d0d0f9dmr299705f8f.43.1722014249240; Fri, 26 Jul 2024
 10:17:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240724080858.46609-1-lei4.wang@intel.com> <CABgObfYHK+N68pOamxA4nT6iZUvEDeUN-AkNwEE9jgnig3AfNw@mail.gmail.com>
 <SA1PR11MB673499AE31632832A91042E3A8B42@SA1PR11MB6734.namprd11.prod.outlook.com>
In-Reply-To: <SA1PR11MB673499AE31632832A91042E3A8B42@SA1PR11MB6734.namprd11.prod.outlook.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 26 Jul 2024 19:17:17 +0200
Message-ID: <CABgObfYQhnT0B+jQEBrqucSDnbrY1FBRhoRRdou-u5icNkbvMg@mail.gmail.com>
Subject: Re: [PATCH] target/i386: Raise the highest index value used for any
 VMCS encoding
To: "Li, Xin3" <xin3.li@intel.com>
Cc: "Wang, Lei4" <lei4.wang@intel.com>, Marcelo Tosatti <mtosatti@redhat.com>, 
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 26, 2024 at 3:12=E2=80=AFAM Li, Xin3 <xin3.li@intel.com> wrote:
> > Hi, can you put together a complete series that includes all that's nee=
ded for
> > nested FRED support?
>
> We can do it.
>
> Just to be clear, this patch is not needed to enable nested FRED, but to
> fix the following vmx test in kvm-unit-tests, otherwise we get:
>     FAIL: VMX_VMCS_ENUM.MAX_INDEX expected: 29, actual: 19

But neither bit is defined without nested FRED (and failures if you
use -cpu host,migratable=3Dno are expected).

Paolo


