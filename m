Return-Path: <kvm+bounces-24171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 948389520B2
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 19:06:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 492121F22A3F
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 17:06:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3B8C1BBBD0;
	Wed, 14 Aug 2024 17:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vw2rjbpG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED691BA89A
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 17:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723655182; cv=none; b=N8qJeyBWMT35dn9UatcLYTtyh9VtB2LGQQkRpL0fxYi0gYSTuVwBRcKMcyDXKwQp0AGGmOPeuH40XYLnAwfqbvwrRCdYGDikmjrku3UA5DCnuFs2dSqkm1Xi440Jfhi5wg/4T4/jI6QwP30t08epeMSRLRfmoH73aQgkN8Ek4dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723655182; c=relaxed/simple;
	bh=sARIX4ukqMN0+YO7QoHBlDh3NtqVN+qyWfzelkzISJQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l2RCdoPmEsBqM1WAGU5W73BI9BPF/stR7m+uQLkdRWW45rrwmq8MSjqS1SBtwhqlskPOjCGk9PUZnUpSbIiBKAA02P50YsPQ9tgM6HNsBtQwDgMUAu6x/WbNgMfJchS7thHWDq6lMlOO7giF6us8LELAI/ATCvyBVZU2+yIGVCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vw2rjbpG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723655179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sARIX4ukqMN0+YO7QoHBlDh3NtqVN+qyWfzelkzISJQ=;
	b=Vw2rjbpGVaLj9GhbF4znSARFqXop9eAHC47rftBRMoUKdsfme7/hdfdY0cbzZPpbIyQADS
	VzODf30GAZQQIY7wdAMTcQbLM7tA3mYiQuvGgTdv0A/UH9gSrBgclVU8IZ/fCNS5QPU5ym
	SiUJPqNjUDtrI6dpBRLIf7NutqUCmEE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-oiP2ntMjNh-d2vVMtw5QRg-1; Wed, 14 Aug 2024 13:06:18 -0400
X-MC-Unique: oiP2ntMjNh-d2vVMtw5QRg-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-428e48612acso78275e9.3
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 10:06:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723655177; x=1724259977;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sARIX4ukqMN0+YO7QoHBlDh3NtqVN+qyWfzelkzISJQ=;
        b=eCQtVngIyxLEEOYpy/+Be8bctAoCGEUOX0+BmqLWOnTGJDgJ744IopiGCd3sovY+Fd
         vjQxJWng6jCPK9pEcLqk18OH+8Q4PdAPcuqb2bx69kibbhyDNDBJ6X6uj0ISirxDvfIj
         NN2C5phbUbJ5ui9mHy4YctGm3j69MeQnT24k2IprX7LjqDWVWazGC3KnQ/ncmSFXLZ5M
         zXjZN9l02kIhpGK5gHzy0NGbEN0b/6Ka79KDDPFx7XM96yDtWbgsG7AvWL/v+i9/aqWN
         jlfFsMYgHU1gaeXdNCnUxuDrSi2ncbjh8i4339Tn9/vZQLiP3aoqcKQZLSslfoE/ZiuW
         ODNg==
X-Forwarded-Encrypted: i=1; AJvYcCXynIPEbdh4Dy6pBhrISqKthDPRcNwtqogzfalDDBXfun+AzmOWbgqMxyHkARvaNl1r9uXf6bSf7A3tflyYN8yNyppd
X-Gm-Message-State: AOJu0YzFzH6/PY4vJJxrtUqQi+iwEtYSYMBUFuvzrYIzEcyJup8tj9LZ
	FKyNI7iYb1DSquhHpVog+Y8oEtGsuascT2XW9eLCCXgUKuSO1cu6de5BI5vaykZIkGqPm33Osh7
	FFOtBTr6IdU6+hkxR7TsnKFv0nMykyd9lVnMdIQAShr+FZv8KX7dFXyBnS1mg3z6TdWAW8y9Cee
	LCR8JZbFLa1AtZJJL8MG7gr3WD
X-Received: by 2002:a05:6000:a91:b0:368:e634:1520 with SMTP id ffacd0b85a97d-371778158afmr3221007f8f.59.1723655177105;
        Wed, 14 Aug 2024 10:06:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEJ92s0bv9O9QBrTJDwjKcvnvPi4/xG23d+AxWMhC7q7M8ceY+CEkp/DVKnrkLJkmwapEuW3h74NVPYEizA4eA=
X-Received: by 2002:a05:6000:a91:b0:368:e634:1520 with SMTP id
 ffacd0b85a97d-371778158afmr3220976f8f.59.1723655176647; Wed, 14 Aug 2024
 10:06:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240814083113.21622-1-amit@kernel.org>
In-Reply-To: <20240814083113.21622-1-amit@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 14 Aug 2024 19:06:04 +0200
Message-ID: <CABgObfZHVO23h8MmWy=nzaToTMqcG3WgUVXHXf5N-Ca+c0y5wQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: SEV: uapi: fix typo in SEV_RET_INVALID_CONFIG
To: Amit Shah <amit@kernel.org>
Cc: seanjc@google.com, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, amit.shah@amd.com, 
	bp@alien8.de, ashish.kalra@amd.com, thomas.lendacky@amd.com, maz@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 14, 2024 at 10:31=E2=80=AFAM Amit Shah <amit@kernel.org> wrote:
>
> From: Amit Shah <amit.shah@amd.com>
>
> "INVALID" is misspelt in "SEV_RET_INAVLID_CONFIG". Since this is part of
> the UAPI, keep the current definition and add a new one with the fix.
>
> Fix-suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Amit Shah <amit.shah@amd.com>

Queued, thanks.

Paolo


