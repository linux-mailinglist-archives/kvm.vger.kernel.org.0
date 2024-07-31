Return-Path: <kvm+bounces-22770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AF58943298
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 17:01:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC2721C241D8
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 15:01:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FC5D12B71;
	Wed, 31 Jul 2024 15:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CXaGVUUZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15502F37
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 15:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722438060; cv=none; b=sOFItvn1N1DcJh+Trl1kHMs12yZPmDyaKCPAC4nyYRc2+5e/wi34gTLh+p60If9hFuoT+Xr+L49bysM5finP21WNCBPQ7CtgD2ewSrKBLJ32/TqA00QEQNAr1RskhL/aLt85chwKKaPIjgYppLBUAt91eiqGP3qFMoVtDJ2KNyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722438060; c=relaxed/simple;
	bh=nGdZ27503sw9fiHMTs0cO1if35jpQQ843Oird3kfKNo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OdBoy4f8+koGU76zu70fMLZW314QoiCw2g3Nlp9jheCslFqoClzJYM+6s0jjnHz8zRTLXc0z7OknSX53kefCxpgI01pDhqJskDsJRwAoMd2HB7JI3sEvL/1yg5NKcb+dAMfhjWgVuj3WX7ghIxBLnuTmq+CHlj6ZjVuhifsYaMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CXaGVUUZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722438057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7PijAWHpj27mVXGTNX7nm9i0at4V71hwo6ih5E46RVY=;
	b=CXaGVUUZAgiXPNZpf+Ye33WsA419u1cTMI8ACH4GNhDPfX6m9dteh0HP0JAFQagmZSWT0R
	OdXrnHT9Uv3+A6SyA8drEBH1a3U5L/de/jzCawUh+bSDh4tOHw6bFM39Zo/lh7D9YPJHZX
	X/rwncSTpH4iuH847E+e3Rpus4r2zJU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-370-cOHM53soP9KoZF4B8uaOKA-1; Wed, 31 Jul 2024 11:00:55 -0400
X-MC-Unique: cOHM53soP9KoZF4B8uaOKA-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-36831948d94so2936945f8f.0
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 08:00:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722438054; x=1723042854;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7PijAWHpj27mVXGTNX7nm9i0at4V71hwo6ih5E46RVY=;
        b=c3qes/RcHf3+e50xZ4xJPYtRfkCDKzkAhMFvJwlzo0ijhl/XcfG+85K2Bsl/xzPWRh
         d5iFfFYVkjtx8ZEH3byyRnZ4kdGELM70NbmigSnL3e7vdNVAd/icDePUYNz17MvQOKJu
         sZwPViVy3CDoqZrSWTfcb5enxk6268L2Gi1a6V2ytJoRUTVQ1cj+xwTasPOYxRRgdYUW
         KJ0/rxNi5+q+BYbHLKsaLYvd7vSYt0ZuKTmqmsEbUYbjEDdlXk/tpAg5vXX4KH7QnyzV
         WPgM33hHrFw9U259IOM+X5Y1yaoONNZgA46e5OdBIFtMs1g5nhh8VZCwDrILc+mqTMyx
         pa1g==
X-Forwarded-Encrypted: i=1; AJvYcCUhrAaS0ZfBpnVgfMgmA8/VZlKeofXXUezGoNdmMKCCvhVZTrnJL7hBjkTsONc5ETWyFfyVE6YhYKhcz0TL73j7AW4k
X-Gm-Message-State: AOJu0YyAiDaHUMaW9LNyvsvU7kvQjgQhdv0ot2AYgEFIjQPiRjMkA/w1
	c3tDiwas8eWYgWH2/ZyyVGaHeFVMQJnOxm2afTGu9HzlYKPJHxrpnPTIA9b3snfiDfkEksbT7Mp
	tCDw2BjsY2koZQXDBAxFqXyZlag9j9m27VvSUA/yIQGAib9T9jukaOMFXgvZRd2ZJHL+XWmDRyL
	S4wrnQCEmJwX1AbYec7D2hB3R4
X-Received: by 2002:a5d:4390:0:b0:367:909b:8281 with SMTP id ffacd0b85a97d-36b5d0ddcd5mr9278543f8f.59.1722438053777;
        Wed, 31 Jul 2024 08:00:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH2ouV9byxsRnqParYc2rTJcYD/T8uRLb9ED2oKqaotw5Fw+mddunPTPazBC5jK1enVRFkg++45kCiTMm5vNCk=
X-Received: by 2002:a5d:4390:0:b0:367:909b:8281 with SMTP id
 ffacd0b85a97d-36b5d0ddcd5mr9278513f8f.59.1722438053267; Wed, 31 Jul 2024
 08:00:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240730053215.33768-1-flyingpeng@tencent.com>
 <db00e68b-2b34-49e1-aa72-425a35534762@redhat.com> <ZqlMob2o-97KsB8t@google.com>
 <CAPm50aLGRrK12ZSJzYadqO7Z7hM25NyXPdCD1sg_dTPCKKhJ-w@mail.gmail.com>
 <2e66f368-4502-4604-a98f-d8afb43413eb@redhat.com> <CAPm50aJ2RtxM4bQE9Mq5Fz1tQy85K_eVW7cyKX3-n4o7H07YvQ@mail.gmail.com>
In-Reply-To: <CAPm50aJ2RtxM4bQE9Mq5Fz1tQy85K_eVW7cyKX3-n4o7H07YvQ@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 31 Jul 2024 17:00:41 +0200
Message-ID: <CABgObfb2MX_ZAX3Mz=2E0PwMp2p9XK+BrHXQ-tN0=MS+1BGsHg@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Conditionally call kvm_zap_obsolete_pages
To: Hao Peng <flyingpenghao@gmail.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Peng Hao <flyingpeng@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 31, 2024 at 1:19=E2=80=AFPM Hao Peng <flyingpenghao@gmail.com> =
wrote:
> > So if anything you could check list_empty(&kvm->arch.active_mmu_pages)
> > before the loop of kvm_zap_obsolete_pages(), similar to what is done in
> > kvm_mmu_zap_oldest_mmu_pages().  I doubt it can have any practical
> > benefit, though.
>
> I did some tests, when ept=3D0,  kvm_zap_obsolete_pages was called 42
> times, and only 17 times
> active_mmu_page list was not empty. When tdp_mmu was enabled,
> active_mmu_page list
> was always empty.

Did you also test with nested virtual machines running?

In any case, we're talking of a difference of about 100 instructions
at most, so it's irrelevant.

Paolo


