Return-Path: <kvm+bounces-18615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 26BB78D7F81
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 11:56:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 57E2A1C23743
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 09:56:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EC13823D9;
	Mon,  3 Jun 2024 09:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PQEzhCQ2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E184B82872
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 09:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717408549; cv=none; b=ncSUwU7tbBBl0TrqHqLhvvJNm72dJIaUfUwBG9jHT6MF9GAVEiR7FXC5qRf4JOWdlJT+51oKs6lsa8Pw9b3lC2xY/Pd0bjFlMYkQJOjkmHfrxtMT1rvzmU25fC/yY9PjVx28+ffD1Lywas0LVIuU4jUhnr99qUVAQIQiDuAnGv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717408549; c=relaxed/simple;
	bh=j3w5sdk50MWkOtg20m3zv01ZlNS2vEMP6HoG5dADsUc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h/tZMWLY6/h52oR7f0H4Olb4lIaqyx8SJqSmsf+y7EMdkiaJDBo3T6iPhFUUZxinpLyYz0ib6KSDkXVmoSnV128SaS/YtGsuG5ZnIxcY0t02Io2BSBXtvJMyVch4G9xmSKOo7b/efvKRluss5wMhnzopHxAN8wAMtD1WQhHy+VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PQEzhCQ2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717408546;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xQFdKCFzdq6v3MvHeosj3+MG8S4CXeRElH/ChtEAeRA=;
	b=PQEzhCQ29cf0bDIr/RR42djtp8QRbq3yiu1Sf/JWkLrb3qgHuWeKNMlx1fW3BzwBFsgVY9
	vuIOMZmkP7XWmeYbLL6ZGEGjKHw/CeyevYETKsGHY/coA4X6BE8PvzQyDvP7jXxIYm3TfA
	rdvKU3s0Mh/EZmMhNU6UuJzN8j3CQ4U=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-581-3xEUZc6fOQKmIvINz5eiJQ-1; Mon, 03 Jun 2024 05:55:43 -0400
X-MC-Unique: 3xEUZc6fOQKmIvINz5eiJQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-357766bb14fso1938100f8f.2
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 02:55:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717408542; x=1718013342;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xQFdKCFzdq6v3MvHeosj3+MG8S4CXeRElH/ChtEAeRA=;
        b=uhfSc/1VQlKC0V/eXH9qr+rLRYNZ7H/oES0wOlfPWstWwTwzKrdjwJ5P3P1EdwgPk4
         LK7lCmV7IgbbWHZa4vKKDl5P8JmtLnAozWqPPLYTRjrptZsDcGGa3xImiOkXOO96wTDE
         tAwiCIddvWpqcl6qn2JBHuJZ4OHhlTDNTpAYAfRC7SLhHpN89Q2AoI8Ckh0RhbkCCpHc
         n7dU/RrNd+eD+FV96OP4tx2vkz9WKP0CUF8+f26HreO8C4Mrws/i5iTZtqBvpo3M84uE
         BbAyxdSNSfZhWHC8UdkcQja1Qqdjril7nqxg6mBDjoRkugf9oA9ID2700x9ovOqFnvSt
         z34Q==
X-Forwarded-Encrypted: i=1; AJvYcCXmEE94jHsVBP2l/lCoU5Pd3TzOlQX8ffgG6JCvpHZ2ArwXV7C3Qoz+OY66qxvZC70EpEBJlU6dycq1oD7edyTiKGz6
X-Gm-Message-State: AOJu0YzzecOeESFvPT5aZSwMm6crowHpZ4UB/PWbpf2BJN9qxlP0TAmL
	rNdyXaryxvVQKoF2omS/IS4oSDXyhZXGcGARP1Opx2Ighrsn9nsHz11Z+mSIO1FESqVhjNajSgZ
	WmZ8gf/i3eSPVRUWM1Sv97RC8QssC6WtPY3u/7zD0R2Ztre1wBZlutjnuTIE/J401feQ5q6Kdgj
	VUNDF5iJ+u67jMTjrCKydMod9G
X-Received: by 2002:adf:f986:0:b0:354:fbdc:7d2e with SMTP id ffacd0b85a97d-35e0f25dfa8mr5821663f8f.11.1717408541901;
        Mon, 03 Jun 2024 02:55:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHpxOAOHxkNU8dENq9aFEzVMyoeYO1k6RFFGy4sePv2SF++egBtqW2Nr55d2BFMWXv4OxRFyuJxxtYl1D/9Ujg=
X-Received: by 2002:adf:f986:0:b0:354:fbdc:7d2e with SMTP id
 ffacd0b85a97d-35e0f25dfa8mr5821650f8f.11.1717408541522; Mon, 03 Jun 2024
 02:55:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <11311ff6-9214-4ead-91f9-c114b6aaf5c6@redhat.com>
In-Reply-To: <11311ff6-9214-4ead-91f9-c114b6aaf5c6@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 3 Jun 2024 11:55:29 +0200
Message-ID: <CABgObfY4SCxXCyb8JJtyJ+0j2QLCutB0SU8vKKifEHakEu88pw@mail.gmail.com>
Subject: Re: xave kvm-unit-test sometimes failing in CI
To: Thomas Huth <thuth@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, KVM <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 3, 2024 at 11:11=E2=80=AFAM Thomas Huth <thuth@redhat.com> wrot=
e:
>
>
>   Hi Paolo!
>
> FYI, looks like the "xsave" kvm-unit-test is sometimes failing in the CI,=
 e.g.:
>
>   https://gitlab.com/thuth/kvm-unit-tests/-/jobs/7000623436
>   https://gitlab.com/thuth/kvm-unit-tests/-/jobs/7000705993

Is this running nested?

For now I have sent "[PATCH kvm-unit-tests] gitlab-ci: store artifacts
even on failure" so that we can analyze what's going on.

Paolo


