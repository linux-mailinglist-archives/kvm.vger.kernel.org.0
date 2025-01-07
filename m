Return-Path: <kvm+bounces-34677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C3F7A0419C
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 15:07:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A532A188121B
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 14:05:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 308411F2386;
	Tue,  7 Jan 2025 14:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fiAsNxV+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED581F37DA
	for <kvm@vger.kernel.org>; Tue,  7 Jan 2025 14:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736258484; cv=none; b=M3beoy8FwTEZqAjsUmkYRkUKCXoJhTWDRKL7YHCPqkSc8zW55zYYbnTlt6WEXrIlseGjsfX7W+fai22WUj/tauNDmWZX0zR4x7BfwEXg0xQO3+tzsupdMcwfjXBvgggltDNHgr5Vzhi2oS6TmU7z7iziZT2HQXAmUBpCFjFdbCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736258484; c=relaxed/simple;
	bh=E0jJWnMOAu2y63eZiCnA4MnCJHnduOjxc0HK5EW1m4w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eV8W2begUu5/aLhHK7UeyfomzrSK1e+OD/JhedmIEOMfRokC7syEgWB/l6eMajlsIs5gYt6hMS3AOs+0Zr661Oxg2zffPlu78CUdjFIdt2H3FqF9ElvikBEHz0qYuCG0QEpvJSlzz8zoAbd6X3DUUgROZBw0BaFo0aW402IMGuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fiAsNxV+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736258480;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xWgB/43g9DBRIYKUelYRIXfafxY4t7D3Lk117io9EMs=;
	b=fiAsNxV+PQRVjNz37l8YTlVV9L4G2tf2ApoNMrLlbbAgHVJMqXswXqwQsoFrO/vPiZ+Lto
	HutNEhmgnUnk8qTrQ+ZEO/4Cdqg6UC5J3XYG3wXPKsHxLEqELhRO5W5La3UTUiH/eY9Pg3
	wG0E/WzFyZyYvGSIaZdSzoOfzCwmD9s=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-145-Qn89zmbKOZyEcVdi7FT8mg-1; Tue, 07 Jan 2025 09:01:19 -0500
X-MC-Unique: Qn89zmbKOZyEcVdi7FT8mg-1
X-Mimecast-MFC-AGG-ID: Qn89zmbKOZyEcVdi7FT8mg
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-436225d4389so73745605e9.1
        for <kvm@vger.kernel.org>; Tue, 07 Jan 2025 06:01:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736258478; x=1736863278;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xWgB/43g9DBRIYKUelYRIXfafxY4t7D3Lk117io9EMs=;
        b=VS/q4eGYqttkjAYVFTOK1ipCpxL1E9onC+XbJjxELJh4Bd1NhrTU63wfZe0mkRmkMY
         70zzE4jLbZ8K9W7YAWRGTVlcslTZA3O3RqHjXuu/7fLlt3b3K4PvkP/w2zC+HQip09Rb
         WTbgyru8xltihhOUbLPM5QZO85Ll7pRwH9WVaG/a4iQuEgmrVYlNjvhAXW85hCWw5r4O
         fX60PwspXAmI3E9TFo2+Ewv5UBCu+Wl5/HQZfLV+1ITn02Nd0GihsOXLT3InoNBlm5kZ
         0X2quhZitMHla63PSsg5U7mUFjvq1QVUDUXysRbzAezm7GdnSAd7/DF8YDu8edBVxmfA
         ZX8A==
X-Forwarded-Encrypted: i=1; AJvYcCU4vFz/hFpegNCn99ZzYgG98IhhXVtIbqu8cuiRRK6eurgeInCfutYeUb4o9ua9fMsgv00=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZ5UZtPcrTtuCuSQdI51VQEF18KMk+bOgZS+p6xLmUc5vcyor0
	R3jb1ODZyLXv0xju4mDFc1bGE+YefvInBjihIzKqJvJ+M+cQFUFHPmS2fD4YTPFYMvOEmeGmKzP
	Z/oZWRwtRy01GdqWaLw8jDgWhkjGQXoxbModyFdSL1BYsIczrfHJQGab5Sf6IVqY7O5QVXvqvYd
	TJvMzFZHF7tRT1KvLG9x2dqb7F
X-Gm-Gg: ASbGncuNAsK8SqMzV7z5ITavfOO6KPN7atdmqwMNm19njb1NiyYA708gEVcgcVymfz7
	n3gg16cJUtl/zTkMLlF0eUsNPs3LN2PQxUC8hlg==
X-Received: by 2002:a05:600c:1c25:b0:434:ff08:202e with SMTP id 5b1f17b1804b1-436dc1f2358mr27500345e9.8.1736258478217;
        Tue, 07 Jan 2025 06:01:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE84o8DSMKExsnYSg+1t9rEB7/Z8LXBXPNW+Ge5Jk6UQzmCPGi8fDV1a5stPpYBvRnlDpeaSYztaegwlTOPSCA=
X-Received: by 2002:a05:600c:1c25:b0:434:ff08:202e with SMTP id
 5b1f17b1804b1-436dc1f2358mr27499745e9.8.1736258477810; Tue, 07 Jan 2025
 06:01:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241115084600.12174-1-yan.y.zhao@intel.com> <CABgObfbukWu5srwDGA-orsd35VRk-ZGmqbMzoCfwQvN-HMHDnw@mail.gmail.com>
 <Z2kp11RuI1zJe2t0@yzhao56-desk.sh.intel.com> <Z3xsE_ixvNiSC4ij@google.com>
In-Reply-To: <Z3xsE_ixvNiSC4ij@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 7 Jan 2025 15:01:05 +0100
Message-ID: <CABgObfa=t1dGR5cEhbUqVWTD03vZR4QrzEUgHxq+3JJ7YsA9pA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Only zap valid non-mirror roots in kvm_zap_gfn_range()
To: Sean Christopherson <seanjc@google.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>, rick.p.edgecombe@intel.com, 
	binbin.wu@linux.intel.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 7, 2025 at 12:49=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
> On Mon, Dec 23, 2024, Yan Zhao wrote:
> > On Sun, Dec 22, 2024 at 08:28:56PM +0100, Paolo Bonzini wrote:
> > > I think we should treat honoring of guest PAT like zap-memslot-only,
> > > and make it a quirk that TDX disables.  Making it a quirk adds a bit =
of
> > > complexity, but it documents why the code exists and it makes it easy=
 for
> > > TDX to disable it.
>
> Belated +1.  Adding a quirk for honoring guest PAT was on my todo list.  =
A quirk
> also allows setups that don't provide a Bochs device to honor guest PAT, =
which
> IIRC is needed for virtio-gpu with a non-snooping graphics device.
>
> > Thanks! Will do in this way after the new year.
>
> Nice!  One oddity to keep in mind when documenting the quirk is that KVM =
always
> honors guest PAT when running on AMD.  :-/

And also when implementing it - the quirk should be absent on AMD.

Paolo


