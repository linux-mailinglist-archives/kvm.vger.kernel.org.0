Return-Path: <kvm+bounces-26927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A81CF9791A5
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 16:55:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 34F09B23209
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 14:55:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 822021D048B;
	Sat, 14 Sep 2024 14:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hXb5rdXT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3310F1E487
	for <kvm@vger.kernel.org>; Sat, 14 Sep 2024 14:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726325698; cv=none; b=fZ7TmSztr8C0fkwrtyD8xdYCWT0Ixxw+rX4cxxXYgQQcBAvIZweQKAYdNlxIuFJ4LSDuzB3TpNGXz7RkkQzTHykJ4ys13Oh2XKEkUUb9gOZrGUYEqQESfEoCz2uW2J3MqyqodakNfWv5mDCKOBJblFvdbpb2QyBHdu6MoQBQla0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726325698; c=relaxed/simple;
	bh=5vqFe1NkwqYbK1GlyJAnGUpZ6YKXQLLhsuxjpjYgUtA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T+yc0HNV8LjxyyWPXuZj7jIH2sUA4lyUrWCdPil3TGSKoSmMBTNpu/M0gaxLNgQod3LsYltaOKH3xoTyUBICedeK1F0b1on5ARCbNLHJrKEeqkozFKdiYV0XGwCEPbNssnqIgzHmxbLQZV8v215lGlmTO+gBBCQIrponWQtw05U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hXb5rdXT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726325696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wodVjwnSNwc0gFNYor5n5CGyYrSPXYq18vJ8vOowLAM=;
	b=hXb5rdXTNAu7RtIM/dZHCDREKMGMmtxKZfF4BJj001GW66zt9YvztYBO9SaIlkSUyogvuA
	XAgwFMcng4KukAdXzofScuBV4g7MH3caVd8RmOPsdwr/wGvBs7y6P4mMHvDHyiSmint3Kn
	TYMyxdV8LaL6+lZ29jx8+C+jE0/2kA4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-324-HNG5I578MrCVdlctMO5nAw-1; Sat, 14 Sep 2024 10:54:54 -0400
X-MC-Unique: HNG5I578MrCVdlctMO5nAw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-42cb830ea86so21215725e9.3
        for <kvm@vger.kernel.org>; Sat, 14 Sep 2024 07:54:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726325693; x=1726930493;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wodVjwnSNwc0gFNYor5n5CGyYrSPXYq18vJ8vOowLAM=;
        b=wAoXJJAHLGao/2z8EsmmSvHZ4S5uoGzvtN5NV/pTYVfpOxHu+2x9GwEUrfWMtt20X3
         UfgcXM+o+2hEkqZb/xY6/H2XQ9NGsRO8iuOJ0aRsXwmNKe+vCXG4MpCBhKEQmJcLKdX5
         8N6GCSCTyJ/Lsred5K/6YR2Mnk1Y74eA/jJqgZPKeVi7O3I/My9YLKQ+mAPbkQiXS3lX
         7AVTxHSncb3x1aBZNZRh29CesAVfxlGdmaA0V+4htAs5zlA9P2imoD6KbZoP3O1n5nIg
         aJ7I6I13knVxVKiYPeb3b0A3Bg9lSnxf51o1NffDuRY4DLiQpxl61EwvLlQJb8zUNORe
         1aRg==
X-Gm-Message-State: AOJu0Yy/cvDEg5/9H1HSq96FiNDOBurO2gqxaje7NaPfFH9tQLkLqf2e
	rdpwMrikv4sJggwXppJCpJP/74HDC0/n/dP4nx52SK3ZJ+VS+OQ2pPDXxWJWzgxFjCxRMcSzjI/
	RiIRf9yfbFJPFMhJpWIzjmqc3H44NKUOCeFkZid4anP1SedQQGygN5YcB8Xwb9zsqJQidoZ8bXa
	dvhl/Bz03JsphLZoGgQNdaDNL2rAe62sqecyaCRw==
X-Received: by 2002:a05:6000:1f89:b0:374:c040:b00e with SMTP id ffacd0b85a97d-378c2d5a827mr5563145f8f.39.1726325693269;
        Sat, 14 Sep 2024 07:54:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEyIWfOG8JjomMky4nPvXldHiDuEuPW4mwtxx7SOtSR//qo99bRHjoYqpLCvO5bn+hFKCd0IJtrmzp4bV62LkU=
X-Received: by 2002:a05:6000:1f89:b0:374:c040:b00e with SMTP id
 ffacd0b85a97d-378c2d5a827mr5563131f8f.39.1726325692711; Sat, 14 Sep 2024
 07:54:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240914011348.2558415-1-seanjc@google.com>
In-Reply-To: <20240914011348.2558415-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 14 Sep 2024 16:54:40 +0200
Message-ID: <CABgObfbV0HOAPA-4XjdUR2Q-gduEQhgSdJb1SzDQXd08M_pD+A@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86 pull requests for 6.12
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 14, 2024 at 3:13=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
> There's a trivial (and amusing) conflict with KVM s390 in the selftests p=
ull
> request (we both added "config" to the .gitignore, within a few days of e=
ach
> other, after the goof being around for a good year or more).
>
> Note, the pull requests are relative to v6.11-rc4.  I got a late start, a=
nd for
> some reason thought kvm/next would magically end up on rc4 or later.
>
> Note #2, I had a brainfart and put the testcase for verifying KVM's fastp=
ath
> correctly exits to userspace when needed in selftests, whereas the actual=
 KVM
> fix is in misc.  So if you run KVM selftests in the middle of pulling eve=
rything,
> expect the debug_regs test to fail.

Pulled all, thanks. Due to combination of being recovering from flu +
preparing to travel I will probably spend not be able to run tests for
a few days, but everything should be okay for the merge window.

Paolo


