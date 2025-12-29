Return-Path: <kvm+bounces-66802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A873CE84E0
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 23:57:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 650FF300312F
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 22:57:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63088287256;
	Mon, 29 Dec 2025 22:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H8vVT4vV";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="PEAQPnsJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4101258ED5
	for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 22:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767049030; cv=none; b=KpP3rSwDN/fKTfgdXM1aZBQQTN2BG1B1aJIwkAuCVKY34TbITPJ1T2nySwpvbyLzyOVMa5wd3SHWMmtnkVWn1qSz5dCy1LZ53pGBenI0tb3lllvb2cwbPMD8fi4m6IOeDyX5VhIApLBwzo07IJ83IYQYw3I4Mw+QFpEU1xj+6Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767049030; c=relaxed/simple;
	bh=rKhMc7moZnucpQRJrp1OiMt9udRoh+GEJbqrJ1mvRrU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dj/Dj867wywQRw2CKmDt7+RENrtDI+HhvNAMu4oLgEj7RnNGFRSn3uee+qtfoFpOSVL+Bo9WPhm7vEGAdxk61JtEmF1f+Rjwf05WfKj2lrsFWQD94xdiFhGbDConMSSYFHnvsI4F7M+46SAP2BTi2zf2Yly4MZJtg6+n4ILyxos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H8vVT4vV; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=PEAQPnsJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767049026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rKhMc7moZnucpQRJrp1OiMt9udRoh+GEJbqrJ1mvRrU=;
	b=H8vVT4vVPmGY0kX+kpEqP49alEJqs39yLXeMJ6XschYOnttPB7a9jhlH176PqzNPy2Ul7U
	XghftcN8YSHQyf5QLRSZM3mWpjtz8XyaGpA3X4fz9lzKO61j1PHMeyUYsCMY2HRQzNfJBo
	+MAuv8EArFHdjTFqWsC/gFG9u1HCDTc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-467-ImNJrUd8O16ZZFK78FWSyg-1; Mon, 29 Dec 2025 17:57:04 -0500
X-MC-Unique: ImNJrUd8O16ZZFK78FWSyg-1
X-Mimecast-MFC-AGG-ID: ImNJrUd8O16ZZFK78FWSyg_1767049023
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4775d110fabso81254265e9.1
        for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 14:57:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767049023; x=1767653823; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rKhMc7moZnucpQRJrp1OiMt9udRoh+GEJbqrJ1mvRrU=;
        b=PEAQPnsJpWbUrc3frrk76T9yIclj7yTcrleCL9kNRJvWn9aw46IStrVFfD0mhjof95
         iaqIbkbDBz3CN6+S47bYf1zx1KS0QAZzP1iXH1PHM7BDl0WIi9zOScbkfRtGLV8dSbkx
         rBNxiWsbNtJcDbwvSyO03SGZDHQ3jSTLLDrjYRlgqua/wU4sTWxVbWt0cAslXcEP0xzp
         5c9RbnBfB5JYUSUGaZkitcoBp+HCKUi/kxkViz642CKl27AbLNLo54GWFtkZsney2yCv
         aVS8+170qwkjJGLp0OiAx59OII07+FXLCVBk7J2Df4VtEoFpwzSIDgAcmde7Vgd0gNKK
         1aGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767049023; x=1767653823;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rKhMc7moZnucpQRJrp1OiMt9udRoh+GEJbqrJ1mvRrU=;
        b=S2qeZzsA7hAI4CEa4Q5f5JHfGOq3bOs8+XISTtz8Mgb7wfi/2KCfCZoFP3IWDm7tCO
         ymBhamQN4Qt9mMph0R7DKojTb90vYWO+FihNiPkf1QuafS2Dv6Qd+zpon1WAs0loOiBh
         b6743NoeTIKOwgbowf5kykz7BsIloVQTHYIeNhE4tdZ3TfdxkGOjX6yLFiBnuHawzJAF
         MCiN2+0nhyTT5SlvD9SXDz3Iah8A1brIaCqv5vixCbqh4fqnZjm0xhab02diF9RFTzk8
         AzGWvYlk/lw1kitiI9ffSZ3BBN9Frj6rq5c7pqxrBtBNU9FxpjRKJIyWAGixPxs62uso
         +6cg==
X-Forwarded-Encrypted: i=1; AJvYcCULhG3h3APTSWP1EqJ+s4IuxFKFSE7LantBAPYdEwCJajr/U8RqFdkLAFqugej9lvscteY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxeeCRAIn1fXsVM+oor8623Jtnx1nRoUv+XV9L2wFIQfKZA2CqJ
	v20jTCLTQ8z4AQefjorvuuo5mhJhhbNcOC+wQOlURGFyVRsmBB2NHCmje7UCEBXULl1c1BtmSfh
	Dr15BT6o3gV9NJjWMdO75cFtL6c3OCR327moRnHq1F/Bv9lknqSKrLR+SP4r9wD5aVt5Nmr0klo
	EyGxdq7sQ9m9pbKlbSgWgaGOQOOXvj
X-Gm-Gg: AY/fxX4Eezoo5DvvIscf4Nb9kVJUj/suTaXuGieYaWjBwnaCJmIqnrI2fHLayg2QW0Y
	ayq/uO2URAtpKfG2+t6ewlJL9acX1iZFBoEP8aUy6KOrVUb63PCPAEqeKZfikf9VwbCfcFal2fz
	A9RIS74jKx+3huUVWazQUVxVz7S9netvPy61kDc4LNB/DRtUFXHKK2LeV5XfDLYa+6AGFMzyteD
	7LAbHUOz4xPLz5IjqTO46FrrtrvcOcazUWLMvXjEBNbB9OrrneYCJUhdc3SjlcVv05jEg==
X-Received: by 2002:a05:6000:26cf:b0:42f:f627:3aa3 with SMTP id ffacd0b85a97d-4324e709b83mr39163570f8f.56.1767049022752;
        Mon, 29 Dec 2025 14:57:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFw5RSB9i9zTXlUpMP+KZpiRPOwnZJ2wJjAmCBBZZ7ff+Uvoz6R8351vKYrSi8nEgYFvOVsD55PpP5fV/Elu24=
X-Received: by 2002:a05:6000:26cf:b0:42f:f627:3aa3 with SMTP id
 ffacd0b85a97d-4324e709b83mr39163560f8f.56.1767049022341; Mon, 29 Dec 2025
 14:57:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251224001249.1041934-1-pbonzini@redhat.com> <20251224001249.1041934-2-pbonzini@redhat.com>
 <ub4djdh4iqy5mhl4ea6gpalu2tpv5ymnw63wdkwehldzh477eq@frxtjt3umsqh> <aVKlJ5OBc8yRqjlF@google.com>
In-Reply-To: <aVKlJ5OBc8yRqjlF@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 29 Dec 2025 23:56:50 +0100
X-Gm-Features: AQt7F2rK5-45YoZmx0KzG3pMnmG43xyjViIyK1sveFWiX4C5kwCQkHI9RuRdVsM
Message-ID: <CABgObfbJURq6i1HceOHAsEk0gnOhK1vQfStPZ0-XEEL7qFUFmw@mail.gmail.com>
Subject: Re: [PATCH 1/5] x86, fpu: introduce fpu_load_guest_fpstate()
To: Sean Christopherson <seanjc@google.com>
Cc: Yao Yuan <yaoyuan@linux.alibaba.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, x86@kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 29, 2025 at 4:58=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> > Do we need make sure the irq is disabled w/ lockdep ?
>
> Yes please

Sure, no objection.

Paolo


