Return-Path: <kvm+bounces-18792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 499BF8FB63A
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 16:54:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B0511C22CC4
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 14:54:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E94514A092;
	Tue,  4 Jun 2024 14:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xgl773XX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C521474BD
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 14:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717512654; cv=none; b=aKq5vroBzbxJyvAFc3U1g4nzd+WeGTR/yOjSAnOlOfqvLRsceV7bwRCNkFei8vbtsrW7o5v6ASHxk4n0WV3yyBHPYKNLE2XwZ14WPBkZlvSYbFwsJs61VcLkYC0e0/tG5kSGXlhyafPlrJa34EAqu85Bo1rMzWFwpDuSXIIUwi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717512654; c=relaxed/simple;
	bh=JuEiXKOQIIuq/b9x1Z5i9zxA5cWsMfMHqxkyXlio9JA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RkzRysqRaknMraRbxY3DaK07SSxMHZdTaXyqdlOr/BfJhOuVSaZGVRaCoIudiz4c85hYgpEKweUV/TTT+KiXVww52VGH3ZLdbiyuKnL4dxZXdKZiMQrTnKaMphQGUoO5LnQiDqjyI1P+upIbcfm6HVXoZPLRor0mrOoQ0oLHRZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xgl773XX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717512652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JuEiXKOQIIuq/b9x1Z5i9zxA5cWsMfMHqxkyXlio9JA=;
	b=Xgl773XX860XCqL/GdZOJGwTtCtKsZ+5ouoZOmHCd5crFrfSZgj3Jk84Af/bZaVLeSQZr0
	HsPp4O6NitL2doj0h0Qa4s+VVFFA+Odut8+Hn6U8Z7/z330qHYb6zbdwz1wcmcSM4eQSnd
	yCtQSLbAovpIM9w2cRxtX9hIbBC2GC8=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-130-z5X423bLOv6rv2do-FeB1g-1; Tue, 04 Jun 2024 10:50:51 -0400
X-MC-Unique: z5X423bLOv6rv2do-FeB1g-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2c1e6fc4122so1120320a91.0
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 07:50:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717512645; x=1718117445;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JuEiXKOQIIuq/b9x1Z5i9zxA5cWsMfMHqxkyXlio9JA=;
        b=PI+5D0BKGXRvyVdcWiQZiw2ZaoenbzG7VzX96eFFEaSiEW0T9qJSYDNgu4ABEQvjHV
         LZZt2lkFFv0l1v2ZytfbxumJNao0XH9WpVBipXUqWJjZ3viu7X/KfhCDxkIleu8MX7pB
         CE5Q4jIXH8f8mG/3anFNpxu+8UzCX0CtBectpy4LGRgTEQzVd1Z6N56hNeHfzIn5fCYq
         RGPs5UaWjw0S4wHLejPcmQeunNg6tjPpNlXSj1hAAQFkL+Ols84VVxMeHKWeWY6AupiW
         VqqvPQwRWVZdVyM1DzkPFZrKEGztwsRwtLxfXj+/MMM5kMJy1XHE4c6tur073HYuRMTZ
         1BJg==
X-Gm-Message-State: AOJu0YyY7ni3eo/BeeEefMxbMBtbOA4fszZZlW4RsPCjiWLfN1dUVuoz
	6jUw6NYQ+HkUjb4s/E1rpX2f/jPi4Zzmr/WSwBAPKh4tWF4P2QjYFf1JQHTvTEdiM906H7Z1Naz
	DrP3BUGYESw3hgo6iA7VSGOMzL3kBykVHpAoBl5BZUhECJjuSAtQEeJr9x4uyHx1QcdAafRjVBa
	P1QwWF4X+eQwOuNbhFG6I2AFHCgnO+g4ZI
X-Received: by 2002:a17:90a:3d46:b0:2c1:9235:7719 with SMTP id 98e67ed59e1d1-2c1dc56d616mr11367896a91.1.1717512644847;
        Tue, 04 Jun 2024 07:50:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHoIXnPB5RcxyTVo3veNER5WJ1gUdCo8FJ6NefmG+ZhnQ8qPDQ36u7rs4WlXd7f9fkwhAmCIl5Tm/iCJDdSh7A=
X-Received: by 2002:a17:90a:3d46:b0:2c1:9235:7719 with SMTP id
 98e67ed59e1d1-2c1dc56d616mr11367873a91.1.1717512644362; Tue, 04 Jun 2024
 07:50:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240604143507.1041901-1-pbonzini@redhat.com> <49f8aadf-6e3f-4d2b-a32a-8ba941a3a2a1@redhat.com>
In-Reply-To: <49f8aadf-6e3f-4d2b-a32a-8ba941a3a2a1@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 4 Jun 2024 16:50:31 +0200
Message-ID: <CABgObfaHq1g8CD=TP7hhrs07+uJDvSvWFKf1Ya-snOPHyp7fMw@mail.gmail.com>
Subject: Re: [PATCH kvm-unit-tests] realmode: load above stack
To: Thomas Huth <thuth@redhat.com>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 4, 2024 at 4:40=E2=80=AFPM Thomas Huth <thuth@redhat.com> wrote=
:
> This fails for me with:

Ok... I'll try building a fully relocated binary and copying it to the
right address.

Paolo


