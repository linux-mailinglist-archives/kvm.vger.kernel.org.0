Return-Path: <kvm+bounces-63646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 31675C6C4F8
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 02:54:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id D8A0D2AF2E
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 01:54:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 864CB25291B;
	Wed, 19 Nov 2025 01:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gvg0Y4go";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="MASS4D1t"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E41D23C4F3
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 01:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763517268; cv=none; b=NdRv4opMRhBv+wJM1tiCpWS0kBZ4jHY2i13EzD0d2rX7uQwk70d2wYrhdt+1QDxcDfXGM1+d1t7dIlstnclWKk+e+3+mIX9xAYsQ3wis6ZfH4gBJ2KkWcihOLzXrJE3mazUz8CTXe4i1J1lQlE6l7dzSBsvmQ6LHWLtI6x/oIeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763517268; c=relaxed/simple;
	bh=Ti4if+e0vZ3+Heb4vsKFgYIQ8JY3byZZQGyu2jg9Z6A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YoqaGrkYA+5q0/lJtuEv0FwskfXXp069AfAZrdzG9yJi2GVYrj5UaXFGaOSqx7ZFCcu9bOSWulsdfMGQAytJkNtog7e0b9jrpb93kcEfDtqpnqU+1R/TqYC3txBcOopeQN3qSC59UouFJGMAxrME5zpIyP8sHhDLli8njBXRZUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gvg0Y4go; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=MASS4D1t; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763517265;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ti4if+e0vZ3+Heb4vsKFgYIQ8JY3byZZQGyu2jg9Z6A=;
	b=Gvg0Y4gogN1qneOKSTpkaNmmRA96NBEPrCAhOZQ00dzwD994T2fSGyCdAQHq80GXjk3StZ
	jx7GVPkZi6ZK23GsvhC36zkYVt/CdWbRiG8UipDdTjGp0cDVnTk8qf4dw4wUDSpSBypsuv
	G8Bk4C7cmlaJd42iTJjNkzsamB2cM+U=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-402-hvaXmiJdOHGRialITimuIg-1; Tue, 18 Nov 2025 20:54:24 -0500
X-MC-Unique: hvaXmiJdOHGRialITimuIg-1
X-Mimecast-MFC-AGG-ID: hvaXmiJdOHGRialITimuIg_1763517263
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-34188ba5990so18606530a91.0
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 17:54:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763517263; x=1764122063; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ti4if+e0vZ3+Heb4vsKFgYIQ8JY3byZZQGyu2jg9Z6A=;
        b=MASS4D1teYG3gCx0wqopD8kITLT+rPBpfC4L3+HYxDblTPYoZS7LS3uf4eM0P6ri1N
         zF98uazmVswlNFbm/Nzl7HvT9A/zKXtE9Z0zvG//K5d39jQUZlNLqUZKEnpv9sKZ1rnf
         0+tk/9OCWbo7VGb5zZU/tBV7MwuQYKDumP9b1gpahNormDGlyfW7YSxTOHH4Tk2Ro8i9
         ukSPC4tneZi2qHHWe3JfG9zWgO10F3hwiMR+EwSSSn9snalgVeeClGOQXWcSD8zrRv+9
         ICzKNphuQx58FvR69ru5g39kDg/BM9KkzSnkVNNHiPtWTF3egCPGIiYL3dPv0MeSBQZH
         nOTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763517263; x=1764122063;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ti4if+e0vZ3+Heb4vsKFgYIQ8JY3byZZQGyu2jg9Z6A=;
        b=tdfBfUnbFJHbnOuiGWlZpS8302vEoL1e3gJrsGKyRUTV2J1mdGQQX1hbL7KZL+DGZ2
         S9K9TV1dI0exPUagbotRMhxLus+EuhNOEEJpSt7dQbeOogTpTDGuaWGDc09RzDIdxCCX
         etSHD54qlmXDefKpRxFmfFM+4ngO1esNJmi1OkdsS6iBBQZpqXkq1n1NVXUKci9DH330
         SN3qdoTyXrgy4+NFMZt+iwna87m2Jtrfk2UZ1I36sXgUEHoVyTro/pycEBLOI7iT+baU
         Ad6NTSGSk64lIcGAEM+1evcYOu/htIMc1kSFIlRfL7wNotSLwRxzI6cMSIlDNKn+En5Z
         ytRw==
X-Forwarded-Encrypted: i=1; AJvYcCV0g8rbFBvM6c7N4+Sx8PWFGqduExX7bZXzsJX2p7v2qD3QE0SJoLGxkyu85CemWC7IH5o=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCvyDxbYhM+rc6JsXJ+PttErcptoil3CGKwDP/GEkGLS1Y3P32
	qr6JZjX3+sVYPARijUKYJQIn8bjYqm8B745v/DW1dIB4IuzdtpkoyLTKzgrptrRI/8XVIxW6w49
	t4M7UKzMjXhrEotS7XWdP8OVzDhXsqKhawb3C1NruA1DDY/OW8D2aySdb49fkDcrqS/qtQOLbRK
	mBGPaYFG3jUj0tag4UyA9AZ2eXzAi4G/8BsYBD
X-Gm-Gg: ASbGncsaECQA3fsl/LgrhEqUaJOECNV4BQWe7tIVgU0mhuCnekZG62/91alzQuaXrZ9
	bz4/3MYY92bhScy7cIYF1R557TTkjqTp3Rg3DSh15vqaSPaGcbHOj6rimi2gEya/kXiMFnWXsCS
	LIYEr1BVrMjgtBcXwRKvbUPu8wnoFJ/6X6TXMC5ASqCyMxn96IMwlJPNZsidAArUU=
X-Received: by 2002:a17:90b:3847:b0:340:e103:bfdd with SMTP id 98e67ed59e1d1-343fa73278cmr18556662a91.25.1763517262753;
        Tue, 18 Nov 2025 17:54:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF5GXGkEHQ50wOVjXeybBNs1hI+lnVX7iORT/ZASpo0ztu6fbH4EioPP1/R57VRfBgN1e8GgzjV0oQvyiZ1tT0=
X-Received: by 2002:a17:90b:3847:b0:340:e103:bfdd with SMTP id
 98e67ed59e1d1-343fa73278cmr18556631a91.25.1763517262213; Tue, 18 Nov 2025
 17:54:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1763278904.git.mst@redhat.com> <dde7267a688904e4304bebfdbc420877cca70891.1763278904.git.mst@redhat.com>
In-Reply-To: <dde7267a688904e4304bebfdbc420877cca70891.1763278904.git.mst@redhat.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 19 Nov 2025 09:54:10 +0800
X-Gm-Features: AWmQ_bmKidj7jFUERWFCVnMYooo3WyTNjYb-AYGW49thc84xS2-48DV1m8Bt6Ms
Message-ID: <CACGkMEsnS9GCYCq-QVqv7W0Em76KKyFeWXOhkHNJmUWh4bsG=g@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] virtio: clean up features qword/dword terms
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>, 
	Paolo Abeni <pabeni@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 16, 2025 at 3:45=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> virtio pci uses word to mean "16 bits". mmio uses it to mean
> "32 bits".
>
> To avoid confusion, let's avoid the term in core virtio
> altogether. Just say U64 to mean "64 bit".
>
> Fixes: e7d4c1c5a546 ("virtio: introduce extended features")
> Cc: "Paolo Abeni" <pabeni@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Message-Id: <492ef5aaa196d155d0535b5b6f4ad5b3fba70a1b.1761058528.git.mst@=
redhat.com>
> ---

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


