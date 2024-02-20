Return-Path: <kvm+bounces-9183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E7B8185BBEA
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 13:22:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 87AEE1F22A08
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 12:22:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 771FD692F5;
	Tue, 20 Feb 2024 12:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QDYtDv/L"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475985B5A1
	for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 12:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708431767; cv=none; b=It2DfvBdhU4fSPG1Z2veDYj1i1Vn+G8ztvnGO+z7wJhKYquSZFV0QSQ0J23IqFhCh6S7r1IcUC/LrZF8cysSMDtDEUNmBtGQQGBs4BsKYV21Pk+Yl/77/WYihfkExlZRQBfG5pFA+hn4srYUTIxO9JO1IA+OoPMihLg4aQGSZwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708431767; c=relaxed/simple;
	bh=1f11NDJPNaBatEI6pO3kjUS1wCUWc9exdxFhhlFAAj0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qQy0sG0VV83LBb0cLozdIVLv9egG3WmpqBwm/NadyNbu3n6hC9Bf758XRjD+Ra+vds2wdWD7iR4qnkNpjSA2UTaKRMjilaubBb4PcCDcXgBVNb/6kcBl241UX1NU7cE83EhoZX4HiBmVvQ7i5lCB7xppw8nCy9apWptjDbwXkx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QDYtDv/L; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708431765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nryE0QvpwIF+GBr6vQnaZDO8tVOPi12/n3SsPAdoTf4=;
	b=QDYtDv/LeiRDpgJx4tt0BA4UsHSmM2uQdHag/+jy8dFZf/UTUl/Rcmg+34cBNZWqmXqyTC
	m7eSzg8g24jyD/qQhoI6YaLMsVyx5JdlOfo5bWIq11K6bOGKRQ9pYV7hbQ7MvUtGy2hmxA
	9dXFnkZ9pajMURjLxKaGZl2BEjcwoQc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-122-6ikwyzPPOJisDw_vLtrG0A-1; Tue, 20 Feb 2024 07:22:43 -0500
X-MC-Unique: 6ikwyzPPOJisDw_vLtrG0A-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-41225d3b3d1so26400765e9.0
        for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 04:22:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708431762; x=1709036562;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nryE0QvpwIF+GBr6vQnaZDO8tVOPi12/n3SsPAdoTf4=;
        b=NZxEfy+uaJLPqRfxZ9vzF/P/4wcdTSnTTa4EHteXo4k//1rCM5ep/h17DB3IXx9hlk
         nw2lUlinnXX0JtB9nTrxX92RAmVPUI0oq+u8q+7PHovIJG1y1UGK2xNOTCLbdZxUNH7b
         Y0dAB0WP82YI0jg3OrSrePF4kwQUywYTbk7BDLuKu9IxLB2t96xpmfS6DD2qj5LGnI3V
         THg8A28ZlY93ZHITehmPk/ZjM/MGYfsJT8UEBua4l9uA2sv2i7QbMnBsynWAs20DEagK
         mAqPrBGfeJ4TGbzNlDoxo3xHMo+eQJEnwKSxSK80P/K18CJfk2PikklktaYTGyCfe/vz
         Fm9A==
X-Forwarded-Encrypted: i=1; AJvYcCXo/BosHKwsg8MZZa0meYW/IfscJyiYIhQ+E5nYii1l5CbBCM3ZtDTAKmRYjJSZxyBQE6A4GJsqMfOQr+M7nbkLbGik
X-Gm-Message-State: AOJu0YxJR+nPz/pDJUnSvjfY+lz4WLNsA1XbjgOpX5Wp6LBGUdqbZ5YU
	Si3CDgN7zPZlAX51o1wc+r5MOGtfsUWmaeIL81/NSiIT/8HunXGg3mRFTxWpPajAQ/dL6dCQU1W
	mK+JbI5yK3MQQevDU9JYIXD3TdsD9kwpXBGiuxm690DtMW86kXcm23/03QytfQe+A6zdzDPfT84
	ajxEpVzBzoTqp68Of5lsyRq1dm
X-Received: by 2002:a05:600c:35c4:b0:411:e145:bfad with SMTP id r4-20020a05600c35c400b00411e145bfadmr10448439wmq.40.1708431762461;
        Tue, 20 Feb 2024 04:22:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFvnATC39HsxnxsVPrX2vePi3o4k+bGJVrQJVVrIuj4lKaYfDwJip1nNryMKhpbiQwD04oJARcbUxMwnO4L7xA=
X-Received: by 2002:a05:600c:35c4:b0:411:e145:bfad with SMTP id
 r4-20020a05600c35c400b00411e145bfadmr10448417wmq.40.1708431762136; Tue, 20
 Feb 2024 04:22:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240131230902.1867092-1-pbonzini@redhat.com> <2b5e6d68-007e-48bd-be61-9a354be2ccbf@intel.com>
 <CABgObfa_7ZAq1Kb9G=ehkzHfc5if3wnFi-kj3MZLE3oYLrArdQ@mail.gmail.com>
 <CABgObfbetwO=4whrCE+cFfCPJa0nsK=h6sQAaoamJH=UqaJqTg@mail.gmail.com>
 <CABgObfbUcG5NyKhLOnihWKNVM0OZ7zb9R=ADzq7mjbyOCg3tUw@mail.gmail.com> <eefbce80-18c5-42e7-8cde-3a352d5811de@intel.com>
In-Reply-To: <eefbce80-18c5-42e7-8cde-3a352d5811de@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 20 Feb 2024 13:22:29 +0100
Message-ID: <CABgObfY=3msvJ2M-gHMqawcoaW5CDVDVxCO0jWi+6wrcrsEtAw@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] x86/cpu: fix invalid MTRR mask values for SEV or TME
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Zixi Chen <zixchen@redhat.com>, Adam Dunlap <acdunlap@google.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, x86@kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 13, 2024 at 11:02=E2=80=AFPM Dave Hansen <dave.hansen@intel.com=
> wrote:
> Your patches make things a wee bit worse in the meantime, but they pale
> in comparison to the random spaghetti that we've already got.  Also, we
> probably need the early TME stuff regardless.
>
> I think I'll probably suck it up, apply them, then fix them up along
> with the greater mess.
>
> Anybody have any better ideas?

Ping, in the end are we applying these patches for either 6.8 or 6.9?

Paolo


