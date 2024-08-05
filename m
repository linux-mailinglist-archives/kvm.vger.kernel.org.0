Return-Path: <kvm+bounces-23235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D6946947F0D
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 18:16:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7A4F8B23AA4
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 16:16:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82AC615C14B;
	Mon,  5 Aug 2024 16:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X2M/qC3V"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4604015C134
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 16:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722874573; cv=none; b=R7mbXdyrx7CZgHmz/t1XHi1uGtzX43MipEDze7mD+Az/gRWGaUOfLewC1ZNXuUybulhJfoSpiCryzep9pC25Qyp7DFf/WXS6u1j2dSeQUpufu7S7TOcXeuxX1vEfc56+ApeMNNrV+TKa3jydNp7V7rMvIDr3HOcdXYGYbn+E2bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722874573; c=relaxed/simple;
	bh=r5pIys42IhQJQx8lEuqa51IL1PswrZiBgK+zrZ994p8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jk3YDrEPCH0w4Y39CHylOvn/j/GpB5KitEQCeOPuwclZHLyE7725ZRBCvdG7iu4GnDrxgkKPMUB0YCr7LxDmxOk7Pbrkud3RkLTzA/ws98Q9TsulhTQb/E8dXofq0bilxD9BghhJYuIwTVge3Gj+6g8tZKNa9Tjh/bbZCgEj39g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X2M/qC3V; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722874571;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r5pIys42IhQJQx8lEuqa51IL1PswrZiBgK+zrZ994p8=;
	b=X2M/qC3VLcev/F12J/4b2NNa/QN/Nm+b9dUG3dGwjqhUhvSRNC+0lf0mLqeF485hK8t4na
	bjL8cfz0jHprbPtslGJ6noth0Z8DvKNIrSFQLbARX1Rfh+cWhOCZ9iR7zcQtWRskW3HjTf
	L9URSjhYGkaebYZz7SAZKpzJivHEeFs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-418-1gccqNxYPI-xT4n74NsKHg-1; Mon, 05 Aug 2024 12:16:05 -0400
X-MC-Unique: 1gccqNxYPI-xT4n74NsKHg-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-36873a449dfso2836534f8f.0
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2024 09:16:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722874564; x=1723479364;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r5pIys42IhQJQx8lEuqa51IL1PswrZiBgK+zrZ994p8=;
        b=QMzX3e7jOn7ZC3EfbVDS+mvhVpSXlTTM5FDxIONY0UFmMppmbfo4HNGrF1zHCPUusE
         dWhWLZhadPOjVyja1BBvL+Row97GjoBKYGmJcdrxHU9GBjiVrio4BHkLUVMLmfVs5uCP
         5aaJ6ukWEzf6JUJjXYi1nP1FP7PJz1gYK1mp4+z62m4NxiPoXO4thlFWH27ucv+0yFmc
         uZm7iyrSIeuEr4Kvh96VP5Zc986oHVKGb5psDxvWYk1EiAMGIhCLv8biTUPPrfbxqf8l
         zd8PezW9hQ/0v7VGC3JPvWvamSZx2QERqKI2sNFlOhjSCkcOFumkJRjkCBSax/4fX27p
         3ePQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQ52CZhTfTNYAj2XI+v9kg69wSaEh1EL2UEUsY1v7Yq5KPOtBJ2cqV5U+nZosnRzj4HT6yjBHS4x2N4t6u/qsnrlZN
X-Gm-Message-State: AOJu0YxOeQMV42BR8shPxxIToFAqepA1hGgs5RSl/fUXjgLQCc2zA1Fj
	ig7hU9e2veauELURcpMHYFGXjKpaDn09YJDkyrLl6TJH0q/zOI8awuEeCaDdiPmj7AQisX6wHsE
	t4KU8J/aJsDeqKZ9lG3U2bz2+bGkGYla83/WEQhRiJSU2ZjYeT47AZ1EPlY1SGYczWxsvwVpQKq
	FM0JOpXVWKEb8dR/lY+Uuh9GxWRMfcUoCS
X-Received: by 2002:a5d:6509:0:b0:362:4679:b5a with SMTP id ffacd0b85a97d-36bb35c1044mr10943099f8f.16.1722874564196;
        Mon, 05 Aug 2024 09:16:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEGoDUslpHNhBcD4mtah+s+5GapLBs0+T4OFuy93L7cRZBRdKVT+DOqnAwk1xDGdCxC5wkRLOcdJ+TnY7mRCas=
X-Received: by 2002:a5d:6509:0:b0:362:4679:b5a with SMTP id
 ffacd0b85a97d-36bb35c1044mr10943075f8f.16.1722874563692; Mon, 05 Aug 2024
 09:16:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240801235333.357075-1-pbonzini@redhat.com> <20240802203608.3sds2wauu37cgebw@amd.com>
 <CABgObfbhB9AaoEONr+zPuG4YBZr2nd-BDA4Sqou-NKe-Y2Ch+Q@mail.gmail.com> <20240805153927.fxqyxoritwguquyd@amd.com>
In-Reply-To: <20240805153927.fxqyxoritwguquyd@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 5 Aug 2024 18:15:51 +0200
Message-ID: <CABgObfY0zt3NttX=bb2-1kThEAt_OhEn9pMdGZBSpH+aiibGig@mail.gmail.com>
Subject: Re: [PATCH] KVM: SEV: allow KVM_SEV_GET_ATTESTATION_REPORT for SNP guests
To: Michael Roth <michael.roth@amd.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 5, 2024 at 5:39=E2=80=AFPM Michael Roth <michael.roth@amd.com> =
wrote:
> > (And is there any user of query-sev-attestation-report for
> > non-SNP?)
>
> No, this would have always returned error, either via KVM, or via
> firmware failure.

I mean for *non-SNP*. If no one ever used it, we can deprecate the command.

Paolo


