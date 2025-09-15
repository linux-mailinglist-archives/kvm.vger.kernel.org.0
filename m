Return-Path: <kvm+bounces-57638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F295B5875E
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 00:20:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 39F8E177CB8
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 22:20:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14F9E2C11D5;
	Mon, 15 Sep 2025 22:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZDiSoLHO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57682C08AF
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 22:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757974840; cv=none; b=f0ymJ3z13GHW4uKwcWRbNbcwqh82PVoLBUMnSEPloOPf3CZSkOb6wZkuxFasqbY+IyLpkcr4ul1T2iWvE1+9m/WUur9oLMyyu+4u9hoYbF6mHY57krxi3T+mieNZpMR+hthBNgMYYRCJM56VU8I8UNvxjlfW80pDFaxwm9/I174=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757974840; c=relaxed/simple;
	bh=d1A4ZSLlQNC4zFoOiM/19Q9nc4Ro68qdi9KXC/JTmwE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hhMk8x0zi0LpEPDs+ULuKDpNfG81haFOaCblmfIgrDaXygNuWi2hBujf8eYdXPYl7m4YTt9uEtm3uPIbn4fqsEvyS+iaNgP3xahm4A5kX9jWkntiAkloEE3zj4+SmC76qlsiq3nrul042/Vtp9t/dvVP2BwMbItayEKV2JZeTqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZDiSoLHO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757974837;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zNCvg1SlA5uujYmTpj5dnM2XRiOsxEhqFlXcwCOlTYU=;
	b=ZDiSoLHOTqNlgzw/xbxj6lagsSDboUlV8dUy7tFWSfYp7rTZF3XEsYFLqsgl96slLs+s69
	5g1zwavw3DLvwzQInhiNce6m4kTh23eS+E55rYZzK870I2MNTUIQBDASCNZT17XFs1dqsp
	Oyd9Vz2k2MI0rP4fgu4L1AjDReG0tg0=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-311-_Vs-p6nkPKajGotiUndgRg-1; Mon, 15 Sep 2025 18:20:36 -0400
X-MC-Unique: _Vs-p6nkPKajGotiUndgRg-1
X-Mimecast-MFC-AGG-ID: _Vs-p6nkPKajGotiUndgRg_1757974835
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-b046bb6caa0so53460066b.0
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 15:20:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757974835; x=1758579635;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zNCvg1SlA5uujYmTpj5dnM2XRiOsxEhqFlXcwCOlTYU=;
        b=CQvjiERSw1ZtTWz4Pkdx2Gy1kS0ls43h1vK/MNf8TusnzyL99Q+zh67zgV6gS71xZV
         DbxfeZPWla5JQoLdrULiDOsk3v5yPQNN8iW2G+FuCsIA4AWOLM6+0gLxpAvPxRnSx2HI
         2wsfvwsUgUEpArAt5LdniI7CVgYd/BgoshXpPqKkVV93iVTw0yJJJuztKoTBvPbH49zd
         nKEsz+WmsSCc6zjWYCHjdiqhVrUgsHAiV2b1OGzkca2vMy3cv/1LyfuGXqrTeexD1JSg
         bWv5BliPlGjKcaj7zLgcAy7KpGXBRZeHEqyIlesm9TCe8ARKx9TWMpyNHFK7pI+N3OWl
         QW0Q==
X-Forwarded-Encrypted: i=1; AJvYcCVXJBt4KuUdlzx4kG8Uchag4CseeNlLqjA/YZTpDB/MBPlSARKDjVIjW2+4F04HalhocYI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVVwVdhborwhPtUIMpzCRlnsF6lVI2oGiQYnlsnbs43jeUxOvj
	YclXjJjuviMmk+GmFzmNBNHk2jzV6prxBmbanJWihZBA52w4QQBfNOuDxbDRDELr95GlYCJOFGx
	JD1WzvpLwsHheIoHCFDCOIEQ6Hc7ge300N6xI5NXtJ+aQqB+CCO4THQ==
X-Gm-Gg: ASbGnctTBkgLiqEm2iWye4hTKyR0TmYEyrf0Qa/mK6q9zYhi5BWbtCXGxN3ySWYSUAL
	FI01dy3gyLBA7TWihrOSeRsFXF5aaez9XJbQcLulyOEau9BiWAf2K27Ew5/kzO+LwByeqgEQCzt
	ugBPSwy3NJW5p+OSAfFukQm5r1I4eE5ICLzjQeD1fVZtmVOE0rwrI9LOHumOfAalbNmfrc2nt9U
	CVxvQthjzwu3hS/JgiMvJAnKdBjHM8nIaUeGbGtrRlEzq4rXXOgT9xXBKYG2EeGtAsOmt+aWGAw
	taoFdNmsrzeR/MOraKS0yqdhiggd
X-Received: by 2002:a17:906:c146:b0:b13:bdf0:3b88 with SMTP id a640c23a62f3a-b13bdf03bc2mr340562666b.43.1757974834833;
        Mon, 15 Sep 2025 15:20:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGDMmlY+A7AncdQvX7lWK2y0LwK1/e2IwXHvw4zMrKcaIUHt6jUeNuT8DB6d4WnPa6JGwjHvQ==
X-Received: by 2002:a17:906:c146:b0:b13:bdf0:3b88 with SMTP id a640c23a62f3a-b13bdf03bc2mr340560366b.43.1757974834411;
        Mon, 15 Sep 2025 15:20:34 -0700 (PDT)
Received: from redhat.com ([31.187.78.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b07c2d043desm854739366b.40.2025.09.15.15.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 15:20:33 -0700 (PDT)
Date: Mon, 15 Sep 2025 18:20:31 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jason Wang <jasowang@redhat.com>,
	kvm@vger.kernel.org, virtualization@lists.linux.dev,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH v2 0/3] vhost_task: Fix a bug where KVM wakes an exited
 task
Message-ID: <20250915182018-mutt-send-email-mst@kernel.org>
References: <20250827194107.4142164-1-seanjc@google.com>
 <aMh_BCLJqVKe-w7-@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMh_BCLJqVKe-w7-@google.com>

On Mon, Sep 15, 2025 at 02:03:00PM -0700, Sean Christopherson wrote:
> On Wed, Aug 27, 2025, Sean Christopherson wrote:
> > Michael,
> > 
> > Do you want to take this through the vhost tree?  It technically fixes a KVM
> > bug, but this obviously touches far more vhost code than KVM code, and the
> > patch that needs to go into 6.17 doesn't touch KVM at all.
> 
> Can this be squeezed into 6.17?  I know it's very late in the cycle, and that the
> KVM bug is pre-existing, but the increased impact of the bug is new in 6.17 and I
> don't want 6.17 to release without a fix.

To clarify you just mean 1/3, yes?


