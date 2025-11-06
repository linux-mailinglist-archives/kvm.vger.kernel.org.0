Return-Path: <kvm+bounces-62152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EFD5C39476
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 07:39:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18E253B1AD2
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 06:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B0C42D877B;
	Thu,  6 Nov 2025 06:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VfI6H2RU";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="PEr1kS3I"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9D123B616
	for <kvm@vger.kernel.org>; Thu,  6 Nov 2025 06:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762411178; cv=none; b=tIsPUo2fSWbEmUxG69s2420UE0PLU1DNYY28o4mwB+JXYCIGw39WPyWHP5ISMJORr0CbjbUtJ1i2knFAd8Gxmr+LDBXSniQ8/jZkFpNbNx6DdKVQBEsWh0PzjujEPflm0AUIvfH3LjFFNtQ4oa3uyFLxHbM84CjLxneFkjOCOFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762411178; c=relaxed/simple;
	bh=E4x+LJMKyj7QMubHjnE5zCDzy8wXA0k+H3NO2jCye6g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Wbq1+ZQLCJ0e4EpsRdHWvuCu+upqlhEUGDvfzJvn2lCuli9iEb5eQ41AUU6pgidF8+UqssPa/e9s7chQf4P1zazHBdwvNeutsNqaFSU7mYQB/lASlJ98wuBRfURwLxyRLm2hgFCFVnoxpdqSa7oD7SiP6nmK9oJkEpSq1YvI3eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VfI6H2RU; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=PEr1kS3I; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762411175;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E4x+LJMKyj7QMubHjnE5zCDzy8wXA0k+H3NO2jCye6g=;
	b=VfI6H2RUgJbjOLiDL41HHg8KK7QT0X3diSyo0vBoNVUevPdQ1oMpfmDMarG6dm7BE47L2n
	/QUKsvI/PVdgZGSHR/gjX7f2eSJ1YKrdx+ew6tWHIAfKfxL/6XZKtjGFqXCPVqOqGgapYk
	Ja7mZMo/wHC9jHeWGmbrcyo/sy5olJU=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-548-EGUfMiQOOc27XlvJCGkTNQ-1; Thu, 06 Nov 2025 01:39:33 -0500
X-MC-Unique: EGUfMiQOOc27XlvJCGkTNQ-1
X-Mimecast-MFC-AGG-ID: EGUfMiQOOc27XlvJCGkTNQ_1762411173
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2956a694b47so10083245ad.1
        for <kvm@vger.kernel.org>; Wed, 05 Nov 2025 22:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762411173; x=1763015973; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E4x+LJMKyj7QMubHjnE5zCDzy8wXA0k+H3NO2jCye6g=;
        b=PEr1kS3I5lZNGZ2k88Lly2ry+jizqzzNColvhrPUO6UWwhCNaXy0/iPlJjGbXnUUlo
         RFTNfsClBSwFa+RrMtELCKDBBK3Q5GKqWGwPJQLgZtfp+tcTv3qRdr4pNU2qC8s69uEs
         E5h1sZSv/ww/Giw66zPAg3PAS/Ym278UACdjP317HNgFoHm0FB+69Vxs8e0xFAeGxaXI
         jYpHC6UaWp5qHRCRUQp3XIqDzdsfhNrqcjJJpxfFt0ezR2K3y6Q+gBKt3hxozsFGals6
         //qAGhj9nqO7SNekUftv02H2ZxiizRkJDv/feMltTg5ZSfO32oShh/lJhAAxtSM6IXbI
         r6gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762411173; x=1763015973;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E4x+LJMKyj7QMubHjnE5zCDzy8wXA0k+H3NO2jCye6g=;
        b=CAKy3vxNY2CaqGdlA1xE71UBypHtObXVAZ/dCEf5NVgnOtjZKkl9NepgLV7/EkUzp+
         RjgDdZsh2TY3pVRlw6pwYzADsvCRbP+vKVUKeYpPP87xH5yPL3A8XKKlcX9g/C+d/gTU
         o4HCHVLfVLhc6twTc5iXVcveQ98pzHDH843/D+bwbmXL9En2p8viMyfwoa2Ry3YQ0Tnc
         rd/GIbJN9bPa0SvkDsTA8a7Sn9D/OtY/9x7ZiZW/mEXGjUliCHbJvJN+u6S4qPplbKxk
         kMwoYB2TJGg2FBZ5JstC+AKOSE2vLuiK/b/CpSlA/2c0ru6wW4/bkoipfSF7OnMONKOm
         whaQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdmxRnr0YGk0fit+uAzwYzanaxLehdn9Y0XvVGsYb8a1IjuadQRjpTpDSXjcHMOQuyxm0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/OSc5TtduY50CaIuLOd32KqwNppgYLNTkgRwmqO8i1OOvIb3q
	zpUtngpKnfa8pljo96VTIt8zGBwRT5aXnN/l7tQsFpAsVFFJuvwVxy5q5S9fhd5GYuI/7K+Be3g
	wGvfWTxvzNsWVBOuqyhHZ1tuP6YVrRg+VISJkCAHiWlY2EUJ/ykdKOkEcEdF7gxs89PzZtzIQ+Z
	j4mof09vW74emLfHGeoNGe0Baz8Cjn
X-Gm-Gg: ASbGnctG/T4dhm64J5YJZlxkSuPAsKZBySB1YpYZZcuCgkkOpT3/RtlOq4DnzaV+n8s
	4ES1hVAUUUBcxHRY4zs0OKEi6zV71ST6kIz5AFbvOv361DB5igMiVVnFC+8EIQtfNXIxYMvQR8q
	Aw8CckLDrHTVmglw9NQFXLAa6OOsEPQyo2lGoVUgHRT6HE5tYmFh2ScbOx
X-Received: by 2002:a17:903:1a0e:b0:25c:8745:4a58 with SMTP id d9443c01a7336-2962adb2b1amr84975845ad.3.1762411172712;
        Wed, 05 Nov 2025 22:39:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFpHCZn4Khbl+18x66176Duo2bWA+Ef3DI8011wII5KrSvRNlnjSB8z+M/Df+pGaeJ/6qZv9XOQ9rhUVXUNA90=
X-Received: by 2002:a17:903:1a0e:b0:25c:8745:4a58 with SMTP id
 d9443c01a7336-2962adb2b1amr84975515ad.3.1762411172333; Wed, 05 Nov 2025
 22:39:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251101194358.13605-1-michael.christie@oracle.com>
In-Reply-To: <20251101194358.13605-1-michael.christie@oracle.com>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 6 Nov 2025 14:39:21 +0800
X-Gm-Features: AWmQ_bnp2Ane-TtwxK-agPWRTc9zG_WSwacf6sdblQAn0G25oEwwpTPuLhRVfWM
Message-ID: <CACGkMEs+iHO=dXNC1q1+Q7HjtQzZNUsBJ-F9Y6iK0NUV_OrKQA@mail.gmail.com>
Subject: Re: [PATCH 1/1] vhost: Fix kthread worker cgroup failure handling
To: Mike Christie <michael.christie@oracle.com>
Cc: virtualization@lists.linux-foundation.org, mst@redhat.com, 
	eperezma@redhat.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 2, 2025 at 3:45=E2=80=AFAM Mike Christie
<michael.christie@oracle.com> wrote:
>
> If we fail to attach to a cgroup we are leaking the id. This adds
> a new goto to free the id.
>
> Fixes: 7d9896e9f6d0 ("vhost: Reintroduce kthread API and add mode selecti=
on")
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


