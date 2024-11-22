Return-Path: <kvm+bounces-32331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23A669D570E
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 02:31:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8256FB22573
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 01:31:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D4CC2AE94;
	Fri, 22 Nov 2024 01:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Umy53AZj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8C417580
	for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 01:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732239080; cv=none; b=Ixk93EBhdtnCBqkoM/1QCxeSqcRvTOZsk0v5ibMMoQZhDmeDBhIe3AQYGXxsPRHEoAxq7sGLR0LRCf66UOQfftor9mj4Ym7ZM8iWn314ui80Rnyh8GWvNRCdDNHDMdT1crvP11TaT1ldPvjAv1t9PhfGTCHwUd5n0Tp+y1NUTOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732239080; c=relaxed/simple;
	bh=Rn0xgoNCOv5UkUepbD0U0gJuGdeP+Vk36clKkENKZ4w=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RxtHInh119gQC42oQ1RmHfzJo/n6xzGZ/wgo+DyryKuKDbG0+60x6lgj+VSx8J7E7eRzcA/4KTxYbABXUwMqcveJP12nAMhmTOHsSms91VRWa+wtzXPQYJ3GftXQ0CB8rFa6/yCXBympv0YyUqGNkKfo54uJAskapLOXw+CtB78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Umy53AZj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732239077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8t1DiqSMOSf8rl9bEVdW1sVp9UNaQwGBgQ4YhDazXP8=;
	b=Umy53AZjcz+2FWDyoyXOO4Xc8gsgUfrpgHYKs1mlnUHY8rja1W7YIY9IhpPUeMEGP//Fe9
	Uss4Adyr4qmHuUJslOkS9+2WXcC6c9VSnvoSrgUpVdg8NDkNAk6+8Rcss+iWD5UxQibmVW
	lFGuyJy8Kx1tg1CwMvJUbcSUdu77Vgo=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-179-fGo17L7kOWW0E4ZpnbggfQ-1; Thu, 21 Nov 2024 20:31:16 -0500
X-MC-Unique: fGo17L7kOWW0E4ZpnbggfQ-1
X-Mimecast-MFC-AGG-ID: fGo17L7kOWW0E4ZpnbggfQ
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4638f4ce25aso19451791cf.0
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 17:31:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732239076; x=1732843876;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8t1DiqSMOSf8rl9bEVdW1sVp9UNaQwGBgQ4YhDazXP8=;
        b=Xc44lmM9jq5UbrLntkTtt2jOdjvQ3r/gHYBcCQr1ZaVBLDmpCBhbLK0QrQjGiJJjeR
         m+YpHlziCAKBYYfEUU86mGUPMEQxNLFutRt50gD50Er4rh88K+vFpCnE3mTQ6CQxz8yn
         ryaCrT8lif9G+spO2A8uv8S5GkL9y2IZvBbJH/pdJyTQiwJuv5zXIGu4QKht5TKOI1rk
         SpWnn2tRHnyEmO22NFXOtjvzcdNWGMfwgRajYdfNrc05ajgBzTmmFOu+iF8DtXg59+bP
         OoqRanry9u3b1uTnNQ8zTj10A0WsRWd67C+hTDQAbehJTLYkWAO5Ap6zL67ROVgDxWbg
         oMOA==
X-Gm-Message-State: AOJu0YzG/7sE23WBjMcgMpPnnQij3UawIoiwJXQn5Dlb4a4I0qEnG3Sh
	FcIBEQXMhrCA9PW/rwQpcM/LqwscegCMN0R6p5tPo1ydNNqy6xOJHtxMG43v76+4jXA1mlghEPn
	4PgJjVcP2gsWUKcI+p2DxUkRvEseVHKBKqlvwhFIJibS3NQlZqMvKOIpRfz5I60YZ8Is3XyPM+u
	+R1xxZy6tAuI6jS+g8UtnZsbCWX+H4g16Uu1R4
X-Gm-Gg: ASbGncvKyusNdCnfBP1fJUl7zKEJbhRTGm+qzwnMNvvPCunkPw24HjUpYrNkwXtUrUa
	vbaw/W9mhLPJutJ5or/dlAlWZX9LiR8HOWPTjdV44NaTYEheWB4PbgXrotY/qbOcDQ++q2dm0P1
	D3v1VnYZIx6Mlvdyv5f/79nUb4uxchN25ZjsiBvQu9nHTjJQcNYPWcGcnBNBzXeUNQ6lrc2SfwF
	JmFEOu/h3ChPoFG0bdDHatDm3WOcbD81Jc/tRPXB3L/qx7l5w==
X-Received: by 2002:ac8:5902:0:b0:461:4002:4d1c with SMTP id d75a77b69052e-4653d63b147mr14641181cf.50.1732239075771;
        Thu, 21 Nov 2024 17:31:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHnvEFK2PWDBZ/5O+gPK3NM11Lqg5WK6jEkUCrqWisLEf8kB1wZrFFZgsijMLz9DdsQbTAcUg==
X-Received: by 2002:ac8:5902:0:b0:461:4002:4d1c with SMTP id d75a77b69052e-4653d63b147mr14641021cf.50.1732239075448;
        Thu, 21 Nov 2024 17:31:15 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4653c0e1446sm5634931cf.0.2024.11.21.17.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2024 17:31:15 -0800 (PST)
Message-ID: <c506e88992b394433cd9e8ec92932bbe59f5b621.camel@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 0/5] Collection of tests for canonical
 checks on LA57 enabled CPUs
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>
Date: Thu, 21 Nov 2024 20:31:14 -0500
In-Reply-To: <f13e0e2b7cb68637ceb788f5ca51516231838579.camel@redhat.com>
References: <20240907005440.500075-1-mlevitsk@redhat.com>
	 <f13e0e2b7cb68637ceb788f5ca51516231838579.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Sun, 2024-11-03 at 16:08 -0500, Maxim Levitsky wrote:
> On Fri, 2024-09-06 at 20:54 -0400, Maxim Levitsky wrote:
> > This is a set of tests that checks KVM and CPU behaviour in regard to
> > canonical checks of various msrs, segment bases, instructions that
> > were found to ignore CR4.LA57 on CPUs that support 5 level paging.
> > 
> > Best regards,
> > 	Maxim Levitsky
> > 
> > Maxim Levitsky (5):
> >   x86: add _safe and _fep_safe variants to segment base load
> >     instructions
> >   x86: add a few functions for gdt manipulation
> >   x86: move struct invpcid_desc descriptor to processor.h
> >   Add a test for writing canonical values to various msrs and fields
> >   nVMX: add a test for canonical checks of various host state vmcs12
> >     fields.
> > 
> >  lib/x86/desc.c      |  39 ++++-
> >  lib/x86/desc.h      |   9 +-
> >  lib/x86/msr.h       |  42 ++++++
> >  lib/x86/processor.h |  58 +++++++-
> >  x86/Makefile.x86_64 |   1 +
> >  x86/canonical_57.c  | 346 ++++++++++++++++++++++++++++++++++++++++++++
> >  x86/pcid.c          |   6 -
> >  x86/vmx_tests.c     | 183 +++++++++++++++++++++++
> >  8 files changed, 667 insertions(+), 17 deletions(-)
> >  create mode 100644 x86/canonical_57.c
> > 
> > -- 
> > 2.26.3
> > 
> > 
> 
> Hi,
> A very kind ping on this patch series.
> 
> Best regards,
>      Maxim Levitsky
> 

Another very kind ping on this patch series.

Best regards,
	Maxim Levitsky


